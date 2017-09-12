Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdILMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Sep 2017 08:00:10 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1drjrN-0008Mr-KU
        for fio@vger.kernel.org; Tue, 12 Sep 2017 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170912120001.7F79C2C0120@kernel.dk>
Date: Tue, 12 Sep 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 83a9e706745e5a5affd5475b884e42d0100f783f:

  Merge branch 'windows_io_hint' of https://github.com/sitsofe/fio (2017-09-05 15:37:36 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c6fa271e32f08f35d7fc25272e77c0f7ee17bfec:

  Merge branch 'solaris-clock-setaffinity' of https://github.com/szaydel/fio (2017-09-11 14:26:01 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'verify_trigger' of https://github.com/sitsofe/fio
      Merge branch 'solaris-clock-setaffinity' of https://github.com/szaydel/fio

Sam Zaydel (1):
      Fix clock setaffinity failed error which occurs on Solaris and Solaris derivatives such as Illumos.

Sitsofe Wheeler (1):
      backend: verify-trigger fixes

 backend.c       | 9 +++++++--
 os/os-solaris.h | 2 +-
 server.c        | 1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index d2675b4..6198c3d 100644
--- a/backend.c
+++ b/backend.c
@@ -1391,6 +1391,8 @@ static bool keep_running(struct thread_data *td)
 
 	if (td->done)
 		return false;
+	if (td->terminate)
+		return false;
 	if (td->o.time_based)
 		return true;
 	if (td->o.loops) {
@@ -2042,7 +2044,10 @@ static bool __check_trigger_file(void)
 static bool trigger_timedout(void)
 {
 	if (trigger_timeout)
-		return time_since_genesis() >= trigger_timeout;
+		if (time_since_genesis() >= trigger_timeout) {
+			trigger_timeout = 0;
+			return true;
+		}
 
 	return false;
 }
@@ -2051,7 +2056,7 @@ void exec_trigger(const char *cmd)
 {
 	int ret;
 
-	if (!cmd)
+	if (!cmd || cmd[0] == '\0')
 		return;
 
 	ret = system(cmd);
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 6af25d2..45268b2 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -97,7 +97,7 @@ static inline int fio_set_odirect(struct fio_file *f)
  * pset binding hooks for fio
  */
 #define fio_setaffinity(pid, cpumask)		\
-	pset_bind((cpumask), P_PID, (pid), NULL)
+	pset_bind((cpumask), P_LWPID, (pid), NULL)
 #define fio_getaffinity(pid, ptr)	({ 0; })
 
 #define fio_cpu_clear(mask, cpu)	pset_assign(PS_NONE, (cpu), NULL)
diff --git a/server.c b/server.c
index a640fe3..2c08c3e 100644
--- a/server.c
+++ b/server.c
@@ -970,6 +970,7 @@ static int handle_trigger_cmd(struct fio_net_cmd *cmd)
 	} else
 		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, rep, sz, NULL, SK_F_FREE | SK_F_INLINE);
 
+	fio_terminate_threads(TERMINATE_ALL);
 	exec_trigger(buf);
 	return 0;
 }
