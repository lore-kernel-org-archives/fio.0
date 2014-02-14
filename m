Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43993 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBNNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 14 Feb 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WEINA-0008Qf-Rt
	for fio@vger.kernel.org; Fri, 14 Feb 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140214130003.8246141A12@strynoevaenget.dk>
Date: Fri, 14 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8d6ecac27d36b3001c8fed00eab7f32cd573636a:

  null: style fixup (2014-02-12 21:25:20 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b74b8208826be02d93d0933eb24ad792f4e78f64:

  Fix inverted logic in gtod_reduce() (2014-02-13 20:04:02 -0700)

----------------------------------------------------------------
Bruce Cran (1):
      Fix IPv6 check on FreeBSD by including netinet/in.h

Jens Axboe (2):
      Don't compute iops samples for gtod_reduce=1
      Fix inverted logic in gtod_reduce()

Sitsofe Wheeler (2):
      cpuid: Null terminate x86 CPU string.
      io_u_qiter: Fix buffer overrun

 arch/arch-x86-common.h |    1 +
 configure              |    1 +
 io_u.c                 |   14 +++++++++++---
 io_u_queue.h           |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index 179572d..26a14a8 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -60,6 +60,7 @@ static inline int arch_init(char *envp[])
 			 (unsigned int *) &str[8],
 			 (unsigned int *) &str[4]);
 
+	str[11] = '\0';
 	if (!strcmp(str, "GenuineIntel"))
 		tsc_reliable = arch_init_intel(level);
 	else if (!strcmp(str, "AuthenticAMD"))
diff --git a/configure b/configure
index 78a6ccb..89405cd 100755
--- a/configure
+++ b/configure
@@ -1098,6 +1098,7 @@ ipv6="no"
 cat > $TMPC << EOF
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <netinet/in.h>
 #include <netdb.h>
 #include <stdio.h>
 int main(int argc, char **argv)
diff --git a/io_u.c b/io_u.c
index acc1a7b..61038a4 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1521,13 +1521,19 @@ void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 		td_verror(td, io_u->error, "io_u error");
 }
 
+static inline int gtod_reduce(struct thread_data *td)
+{
+	return td->o.disable_clat && td->o.disable_lat && !td->o.disable_slat
+		&& td->o.disable_bw;
+}
+
 static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 				  struct io_completion_data *icd,
 				  const enum fio_ddir idx, unsigned int bytes)
 {
 	unsigned long lusec = 0;
 
-	if (!td->o.disable_clat || !td->o.disable_bw)
+	if (!gtod_reduce(td))
 		lusec = utime_since(&io_u->issue_time, &icd->time);
 
 	if (!td->o.disable_lat) {
@@ -1559,7 +1565,8 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	if (!td->o.disable_bw)
 		add_bw_sample(td, idx, bytes, &icd->time);
 
-	add_iops_sample(td, idx, bytes, &icd->time);
+	if (!gtod_reduce(td))
+		add_iops_sample(td, idx, bytes, &icd->time);
 
 	if (td->o.number_ios && !--td->o.number_ios)
 		td->done = 1;
@@ -1680,7 +1687,8 @@ static void init_icd(struct thread_data *td, struct io_completion_data *icd,
 		     int nr)
 {
 	int ddir;
-	if (!td->o.disable_clat || !td->o.disable_bw)
+
+	if (!gtod_reduce(td))
 		fio_gettime(&icd->time, NULL);
 
 	icd->nr = nr;
diff --git a/io_u_queue.h b/io_u_queue.h
index 4f6e8e6..5b6cad0 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -29,7 +29,7 @@ static inline int io_u_qempty(struct io_u_queue *q)
 }
 
 #define io_u_qiter(q, io_u, i)	\
-	for (i = 0, io_u = (q)->io_us[0]; i < (q)->nr; i++, io_u = (q)->io_us[i])
+	for (i = 0; i < (q)->nr && (io_u = (q)->io_us[i]); i++)
 
 int io_u_qinit(struct io_u_queue *q, unsigned int nr);
 void io_u_qexit(struct io_u_queue *q);
