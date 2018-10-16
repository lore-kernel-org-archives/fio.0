Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34148 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeJPTuW (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Oct 2018 15:50:22 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gCO1D-0005XD-L7
        for fio@vger.kernel.org; Tue, 16 Oct 2018 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181016120002.703C32C0083@kernel.dk>
Date: Tue, 16 Oct 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ee6ce26c029dbdb62184d2f011fdab61d3429d82:

  options: kill 'use_os_rand' (2018-10-08 13:43:23 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d5dbacf662b1cc3fb09b5cd70b236ab98d1c0dbe:

  Merge branch 'offload-serialize-overlap2' of https://github.com/vincentkfu/fio (2018-10-15 14:09:18 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'offload-serialize-overlap2' of https://github.com/vincentkfu/fio

Vincent Fu (4):
      init: loosen serialize_overlap restrictions
      fio: enable overlap checking with offload submission
      docs: enable serialize_overlap with io_submit_mode=offload
      rate-submit: remove code that can never be executed

 HOWTO         |  9 +++++++--
 backend.c     |  8 +++++++-
 fio.1         | 11 +++++++++--
 fio.h         |  3 +++
 init.c        | 13 +++----------
 ioengines.c   |  2 ++
 rate-submit.c | 37 +++++++++++++++++++++++++++++++++----
 7 files changed, 64 insertions(+), 19 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a2503e9..72ef872 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2339,8 +2339,13 @@ I/O depth
 	``serialize_overlap`` tells fio to avoid provoking this behavior by explicitly
 	serializing in-flight I/Os that have a non-zero overlap. Note that setting
 	this option can reduce both performance and the :option:`iodepth` achieved.
-	Additionally this option does not work when :option:`io_submit_mode` is set to
-	offload. Default: false.
+
+	This option only applies to I/Os issued for a single job except when it is
+	enabled along with :option:`io_submit_mode`=offload. In offload mode, fio
+	will check for overlap among all I/Os submitted by offload jobs with :option:`serialize_overlap`
+	enabled. Threads must be used for all such jobs.
+
+	Default: false.
 
 .. option:: io_submit_mode=str
 
diff --git a/backend.c b/backend.c
index 76e456f..cc3c4e7 100644
--- a/backend.c
+++ b/backend.c
@@ -29,6 +29,7 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <math.h>
+#include <pthread.h>
 
 #include "fio.h"
 #include "smalloc.h"
@@ -65,6 +66,7 @@ unsigned int stat_number = 0;
 int shm_id = 0;
 int temp_stall_ts;
 unsigned long done_secs = 0;
+pthread_mutex_t overlap_check = PTHREAD_MUTEX_INITIALIZER;
 
 #define JOB_START_TIMEOUT	(5 * 1000)
 
@@ -567,7 +569,7 @@ static int unlink_all_files(struct thread_data *td)
 /*
  * Check if io_u will overlap an in-flight IO in the queue
  */
-static bool in_flight_overlap(struct io_u_queue *q, struct io_u *io_u)
+bool in_flight_overlap(struct io_u_queue *q, struct io_u *io_u)
 {
 	bool overlap;
 	struct io_u *check_io_u;
@@ -1872,7 +1874,11 @@ static void *thread_main(void *data)
 			 "perhaps try --debug=io option for details?\n",
 			 td->o.name, td->io_ops->name);
 
+	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
+		pthread_mutex_lock(&overlap_check);
 	td_set_runstate(td, TD_FINISHING);
+	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
+		pthread_mutex_unlock(&overlap_check);
 
 	update_rusage_stat(td);
 	td->ts.total_run_time = mtime_since_now(&td->epoch);
diff --git a/fio.1 b/fio.1
index bf181b3..7691b2b 100644
--- a/fio.1
+++ b/fio.1
@@ -2070,8 +2070,15 @@ changing data and the overlapping region has a non-zero size. Setting
 \fBserialize_overlap\fR tells fio to avoid provoking this behavior by explicitly
 serializing in-flight I/Os that have a non-zero overlap. Note that setting
 this option can reduce both performance and the \fBiodepth\fR achieved.
-Additionally this option does not work when \fBio_submit_mode\fR is set to
-offload. Default: false.
+.RS
+.P
+This option only applies to I/Os issued for a single job except when it is
+enabled along with \fBio_submit_mode\fR=offload. In offload mode, fio
+will check for overlap among all I/Os submitted by offload jobs with \fBserialize_overlap\fR
+enabled. Threads must be used for all such jobs.
+.P
+Default: false.
+.RE
 .TP
 .BI io_submit_mode \fR=\fPstr
 This option controls how fio submits the I/O to the I/O engine. The default
diff --git a/fio.h b/fio.h
index 53bcda1..e394e16 100644
--- a/fio.h
+++ b/fio.h
@@ -852,4 +852,7 @@ enum {
 extern void exec_trigger(const char *);
 extern void check_trigger_file(void);
 
+extern bool in_flight_overlap(struct io_u_queue *q, struct io_u *io_u);
+extern pthread_mutex_t overlap_check;
+
 #endif
diff --git a/init.c b/init.c
index 1eddc6f..a2b70c4 100644
--- a/init.c
+++ b/init.c
@@ -744,19 +744,12 @@ static int fixup_options(struct thread_data *td)
 	/*
 	 * There's no need to check for in-flight overlapping IOs if the job
 	 * isn't changing data or the maximum iodepth is guaranteed to be 1
+	 * when we are not in offload mode
 	 */
 	if (o->serialize_overlap && !(td->flags & TD_F_READ_IOLOG) &&
-	    (!(td_write(td) || td_trim(td)) || o->iodepth == 1))
+	    (!(td_write(td) || td_trim(td)) || o->iodepth == 1) &&
+	    o->io_submit_mode != IO_MODE_OFFLOAD)
 		o->serialize_overlap = 0;
-	/*
-	 * Currently can't check for overlaps in offload mode
-	 */
-	if (o->serialize_overlap && o->io_submit_mode == IO_MODE_OFFLOAD) {
-		log_err("fio: checking for in-flight overlaps when the "
-			"io_submit_mode is offload is not supported\n");
-		o->serialize_overlap = 0;
-		ret |= warnings_fatal;
-	}
 
 	if (o->nr_files > td->files_index)
 		o->nr_files = td->files_index;
diff --git a/ioengines.c b/ioengines.c
index ba02952..47f606a 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -288,6 +288,8 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 
 	assert((io_u->flags & IO_U_F_FLIGHT) == 0);
 	io_u_set(td, io_u, IO_U_F_FLIGHT);
+	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
+		pthread_mutex_unlock(&overlap_check);
 
 	assert(fio_file_open(io_u->file));
 
diff --git a/rate-submit.c b/rate-submit.c
index 2f02fe2..68ad755 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -9,6 +9,36 @@
 #include "lib/getrusage.h"
 #include "rate-submit.h"
 
+static void check_overlap(struct io_u *io_u)
+{
+	int i;
+	struct thread_data *td;
+	bool overlap = false;
+
+	do {
+		/*
+		 * Allow only one thread to check for overlap at a
+		 * time to prevent two threads from thinking the coast
+		 * is clear and then submitting IOs that overlap with
+		 * each other
+		 */
+		pthread_mutex_lock(&overlap_check);
+		for_each_td(td, i) {
+			if (td->runstate <= TD_SETTING_UP ||
+				td->runstate >= TD_FINISHING ||
+				!td->o.serialize_overlap ||
+				td->o.io_submit_mode != IO_MODE_OFFLOAD)
+				continue;
+
+			overlap = in_flight_overlap(&td->io_u_all, io_u);
+			if (overlap) {
+				pthread_mutex_unlock(&overlap_check);
+				break;
+			}
+		}
+	} while (overlap);
+}
+
 static int io_workqueue_fn(struct submit_worker *sw,
 			   struct workqueue_work *work)
 {
@@ -17,6 +47,9 @@ static int io_workqueue_fn(struct submit_worker *sw,
 	struct thread_data *td = sw->priv;
 	int ret;
 
+	if (td->o.serialize_overlap)
+		check_overlap(io_u);
+
 	dprint(FD_RATE, "io_u %p queued by %u\n", io_u, gettid());
 
 	io_u_set(td, io_u, IO_U_F_NO_FILE_PUT);
@@ -50,10 +83,6 @@ static int io_workqueue_fn(struct submit_worker *sw,
 		ret = io_u_queued_complete(td, min_evts);
 		if (ret > 0)
 			td->cur_depth -= ret;
-	} else if (ret == FIO_Q_BUSY) {
-		ret = io_u_queued_complete(td, td->cur_depth);
-		if (ret > 0)
-			td->cur_depth -= ret;
 	}
 
 	return 0;

