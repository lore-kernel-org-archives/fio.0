Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbhHSMAo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Aug 2021 08:00:44 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9378C061575
        for <fio@vger.kernel.org>; Thu, 19 Aug 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGgiM-00B6A8-3l
        for fio@vger.kernel.org; Thu, 19 Aug 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210819120001.D38961BC0154@kernel.dk>
Date: Thu, 19 Aug 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit df9e8b65a52fdab5a1ac48847c44d7201faa3cf1:

  Merge branch 'dfs_update_13_api' of https://github.com/johannlombardi/fio (2021-08-13 10:01:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 864314464e2772a9885da34ea041f130073affe9:

  Merge branch 'patch-1' of https://github.com/antroseco/fio (2021-08-18 10:47:55 -0600)

----------------------------------------------------------------
Andreas Economides (1):
      server: reopen standard streams to /dev/null

Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/antroseco/fio

 server.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index 42eaa4b1..859a401b 100644
--- a/server.c
+++ b/server.c
@@ -2565,6 +2565,7 @@ static int write_pid(pid_t pid, const char *pidfile)
  */
 int fio_start_server(char *pidfile)
 {
+	FILE *file;
 	pid_t pid;
 	int ret;
 
@@ -2597,14 +2598,28 @@ int fio_start_server(char *pidfile)
 	setsid();
 	openlog("fio", LOG_NDELAY|LOG_NOWAIT|LOG_PID, LOG_USER);
 	log_syslog = true;
-	close(STDIN_FILENO);
-	close(STDOUT_FILENO);
-	close(STDERR_FILENO);
+
+	file = freopen("/dev/null", "r", stdin);
+	if (!file)
+		perror("freopen");
+
+	file = freopen("/dev/null", "w", stdout);
+	if (!file)
+		perror("freopen");
+
+	file = freopen("/dev/null", "w", stderr);
+	if (!file)
+		perror("freopen");
+
 	f_out = NULL;
 	f_err = NULL;
 
 	ret = fio_server();
 
+	fclose(stdin);
+	fclose(stdout);
+	fclose(stderr);
+
 	closelog();
 	unlink(pidfile);
 	free(pidfile);

