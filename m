Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaKVNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 22 Nov 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XsAIG-0003jV-GD
	for fio@vger.kernel.org; Sat, 22 Nov 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141122130003.70DFA40162@lyth.info>
Date: Sat, 22 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 256bc54c13ba8b37eb0e08fdbbd1bbbcfe8a86cc:

  server: fix missing ETA in some cases (2014-11-19 09:34:01 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to df8fb6097058098f1c2f7c2cf4019640561768df:

  iolog: account for wasted time in ipo stall (2014-11-21 14:33:33 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      blktrace: correct setting of iodepth
      iolog: account for wasted time in ipo stall

 blktrace.c |    4 ++--
 fio.h      |    1 +
 init.c     |    1 -
 iolog.c    |   18 ++++++++++++++++--
 4 files changed, 19 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index 8d288b0..9afc5be 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -459,8 +459,8 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	 * we don't know if this option was set or not. it defaults to 1,
 	 * so we'll just guess that we should override it if it's still 1
 	 */
-	if (td->o.iodepth != 1)
-		td->o.iodepth = depth;
+	if (td->o.iodepth == 1)
+		td->o.iodepth = td->o.iodepth_low = depth;
 
 	return 0;
 err:
diff --git a/fio.h b/fio.h
index 0601b37..5e352c6 100644
--- a/fio.h
+++ b/fio.h
@@ -252,6 +252,7 @@ struct thread_data {
 	struct timeval start;	/* start of this loop */
 	struct timeval epoch;	/* time job was started */
 	struct timeval last_issue;
+	long time_offset;
 	struct timeval tv_cache;
 	struct timeval terminate_time;
 	unsigned int tv_cache_nr;
diff --git a/init.c b/init.c
index b72689a..4f66759 100644
--- a/init.c
+++ b/init.c
@@ -565,7 +565,6 @@ static int fixup_options(struct thread_data *td)
 	if (!o->max_bs[DDIR_TRIM])
 		o->max_bs[DDIR_TRIM] = o->bs[DDIR_TRIM];
 
-
 	o->rw_min_bs = min(o->min_bs[DDIR_READ], o->min_bs[DDIR_WRITE]);
 	o->rw_min_bs = min(o->min_bs[DDIR_TRIM], o->rw_min_bs);
 
diff --git a/iolog.c b/iolog.c
index 785e549..99f8bc1 100644
--- a/iolog.c
+++ b/iolog.c
@@ -60,14 +60,22 @@ void log_file(struct thread_data *td, struct fio_file *f,
 
 static void iolog_delay(struct thread_data *td, unsigned long delay)
 {
-	unsigned long usec = utime_since_now(&td->last_issue);
-	unsigned long this_delay;
+	uint64_t usec = utime_since_now(&td->last_issue);
+	uint64_t this_delay;
+	struct timeval tv;
 
+	if (delay < td->time_offset) {
+		td->time_offset = 0;
+		return;
+	}
+
+	delay -= td->time_offset;
 	if (delay < usec)
 		return;
 
 	delay -= usec;
 
+	fio_gettime(&tv, NULL);
 	while (delay && !td->terminate) {
 		this_delay = delay;
 		if (this_delay > 500000)
@@ -76,6 +84,12 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 		usec_sleep(td, this_delay);
 		delay -= this_delay;
 	}
+
+	usec = utime_since_now(&tv);
+	if (usec > delay)
+		td->time_offset = usec - delay;
+	else
+		td->time_offset = 0;
 }
 
 static int ipo_special(struct thread_data *td, struct io_piece *ipo)
