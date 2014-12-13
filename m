Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbaLMNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 13 Dec 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XzmIl-0001as-V9
	for fio@vger.kernel.org; Sat, 13 Dec 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141213130002.7B07E40128@lyth.info>
Date: Sat, 13 Dec 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a4d3b4dbf594be6223a21a47a7ce4c21c7dddaf0:

  Update size/io_size descriptions (2014-12-10 19:21:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 70034d87976e9175054b8c5d7b32f28be638570f:

  eta.c: check malloc return code (2014-12-12 21:50:30 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      backend: abstract out waiting for completions
      backend: fix should_check_rate() typo in wait_for_completions()

Robert Elliott (1):
      eta.c: check malloc return code

 backend.c |   75 ++++++++++++++++++++++++++-----------------------------------
 eta.c     |    2 ++
 2 files changed, 34 insertions(+), 43 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index f027cf0..3424a09 100644
--- a/backend.c
+++ b/backend.c
@@ -418,6 +418,34 @@ static void check_update_rusage(struct thread_data *td)
 	}
 }
 
+static int wait_for_completions(struct thread_data *td, struct timeval *time,
+				uint64_t *bytes_done)
+{
+	const int full = queue_full(td);
+	int min_evts = 0;
+	int ret;
+
+	/*
+	 * if the queue is full, we MUST reap at least 1 event
+	 */
+	min_evts = min(td->o.iodepth_batch_complete, td->cur_depth);
+	if (full && !min_evts)
+		min_evts = 1;
+
+	if (time && (__should_check_rate(td, DDIR_READ) ||
+	    __should_check_rate(td, DDIR_WRITE) ||
+	    __should_check_rate(td, DDIR_TRIM)))
+		fio_gettime(time, NULL);
+
+	do {
+		ret = io_u_queued_complete(td, min_evts, bytes_done);
+		if (ret < 0)
+			break;
+	} while (full && (td->cur_depth > td->o.iodepth_low));
+
+	return ret;
+}
+
 /*
  * The main verify engine. Runs over the writes we previously submitted,
  * reads the blocks back in, and checks the crc/md5 of the data.
@@ -599,27 +627,9 @@ sync_done:
 		 */
 reap:
 		full = queue_full(td) || (ret == FIO_Q_BUSY && td->cur_depth);
-		if (full || !td->o.iodepth_batch_complete) {
-			min_events = min(td->o.iodepth_batch_complete,
-					 td->cur_depth);
-			/*
-			 * if the queue is full, we MUST reap at least 1 event
-			 */
-			if (full && !min_events)
-				min_events = 1;
+		if (full || !td->o.iodepth_batch_complete)
+			ret = wait_for_completions(td, NULL, bytes_done);
 
-			do {
-				/*
-				 * Reap required number of io units, if any,
-				 * and do the verification on them through
-				 * the callback handler
-				 */
-				if (io_u_queued_complete(td, min_events, bytes_done) < 0) {
-					ret = -1;
-					break;
-				}
-			} while (full && (td->cur_depth > td->o.iodepth_low));
-		}
 		if (ret < 0)
 			break;
 	}
@@ -707,7 +717,6 @@ static uint64_t do_io(struct thread_data *td)
 		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td) ||
 		td->o.time_based) {
 		struct timeval comp_time;
-		int min_evts = 0;
 		struct io_u *io_u;
 		int ret2, full;
 		enum fio_ddir ddir;
@@ -871,28 +880,8 @@ sync_done:
 		 */
 reap:
 		full = queue_full(td) || (ret == FIO_Q_BUSY && td->cur_depth);
-		if (full || !td->o.iodepth_batch_complete) {
-			min_evts = min(td->o.iodepth_batch_complete,
-					td->cur_depth);
-			/*
-			 * if the queue is full, we MUST reap at least 1 event
-			 */
-			if (full && !min_evts)
-				min_evts = 1;
-
-			if (__should_check_rate(td, DDIR_READ) ||
-			    __should_check_rate(td, DDIR_WRITE) ||
-			    __should_check_rate(td, DDIR_TRIM))
-				fio_gettime(&comp_time, NULL);
-
-			do {
-				ret = io_u_queued_complete(td, min_evts, bytes_done);
-				if (ret < 0)
-					break;
-
-			} while (full && (td->cur_depth > td->o.iodepth_low));
-		}
-
+		if (full || !td->o.iodepth_batch_complete)
+			ret = wait_for_completions(td, &comp_time, bytes_done);
 		if (ret < 0)
 			break;
 		if (!ddir_rw_sum(bytes_done) && !(td->io_ops->flags & FIO_NOIO))
diff --git a/eta.c b/eta.c
index a90f1fb..167bf5f 100644
--- a/eta.c
+++ b/eta.c
@@ -572,6 +572,8 @@ struct jobs_eta *get_jobs_eta(int force, size_t *size)
 
 	*size = sizeof(*je) + THREAD_RUNSTR_SZ;
 	je = malloc(*size);
+	if (!je)
+		return NULL;
 	memset(je, 0, *size);
 
 	if (!calc_thread_status(je, force)) {
