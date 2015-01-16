Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbAPNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 16 Jan 2015 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YC6VQ-00020A-JA
	for fio@vger.kernel.org; Fri, 16 Jan 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150116130002.EBAC34017D@lyth.info>
Date: Fri, 16 Jan 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e298cc8ab1e007482be2ab1488ae8d547af82520:

  rbd example: 'invalidate=false' no longer necessary (2015-01-14 09:31:35 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9cc80b6d92a15c6b9cbdbc021436f1628054cfda:

  Improve rate limiting (2015-01-15 10:39:12 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Improve rate limiting

 fio_time.h |    4 ++--
 io_u.c     |   11 +++++++----
 time.c     |   15 +++++++++++----
 3 files changed, 20 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/fio_time.h b/fio_time.h
index 27520b0..79f324a 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -10,8 +10,8 @@ extern uint64_t time_since_now(const struct timeval *);
 extern uint64_t time_since_genesis(void);
 extern uint64_t mtime_since_genesis(void);
 extern uint64_t utime_since_genesis(void);
-extern void usec_spin(unsigned int);
-extern void usec_sleep(struct thread_data *, unsigned long);
+extern uint64_t usec_spin(unsigned int);
+extern uint64_t usec_sleep(struct thread_data *, unsigned long);
 extern void fill_start_time(struct timeval *);
 extern void set_genesis_time(void);
 extern int ramp_time_over(struct thread_data *);
diff --git a/io_u.c b/io_u.c
index 23a9e4a..5971d78 100644
--- a/io_u.c
+++ b/io_u.c
@@ -529,6 +529,12 @@ void io_u_quiesce(struct thread_data *td)
 	 * io's that have been actually submitted to an async engine,
 	 * and cur_depth is meaningless for sync engines.
 	 */
+	if (td->io_u_queued || td->cur_depth) {
+		int fio_unused ret;
+
+		ret = td_io_commit(td);
+	}
+
 	while (td->io_u_in_flight) {
 		int fio_unused ret;
 
@@ -539,7 +545,6 @@ void io_u_quiesce(struct thread_data *td)
 static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 {
 	enum fio_ddir odir = ddir ^ 1;
-	struct timeval t;
 	long usec;
 
 	assert(ddir_rw(ddir));
@@ -574,9 +579,7 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 
 	io_u_quiesce(td);
 
-	fio_gettime(&t, NULL);
-	usec_sleep(td, usec);
-	usec = utime_since_now(&t);
+	usec = usec_sleep(td, usec);
 
 	td->rate_pending_usleep[ddir] -= usec;
 
diff --git a/time.c b/time.c
index b145dc5..f1833c7 100644
--- a/time.c
+++ b/time.c
@@ -9,25 +9,29 @@ static unsigned long ns_granularity;
 /*
  * busy looping version for the last few usec
  */
-void usec_spin(unsigned int usec)
+uint64_t usec_spin(unsigned int usec)
 {
 	struct timeval start;
+	uint64_t t;
 
 	fio_gettime(&start, NULL);
-	while (utime_since_now(&start) < usec)
+	while ((t = utime_since_now(&start)) < usec)
 		nop;
+
+	return t;
 }
 
-void usec_sleep(struct thread_data *td, unsigned long usec)
+uint64_t usec_sleep(struct thread_data *td, unsigned long usec)
 {
 	struct timespec req;
 	struct timeval tv;
+	uint64_t t = 0;
 
 	do {
 		unsigned long ts = usec;
 
 		if (usec < ns_granularity) {
-			usec_spin(usec);
+			t += usec_spin(usec);
 			break;
 		}
 
@@ -46,11 +50,14 @@ void usec_sleep(struct thread_data *td, unsigned long usec)
 			break;
 
 		ts = utime_since_now(&tv);
+		t += ts;
 		if (ts >= usec)
 			break;
 
 		usec -= ts;
 	} while (!td->terminate);
+
+	return t;
 }
 
 uint64_t time_since_genesis(void)
