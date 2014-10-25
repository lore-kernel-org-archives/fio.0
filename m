Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35295 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaJYT1w (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 25 Oct 2014 15:27:52 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xi00r-00011C-Mi
	for fio@vger.kernel.org; Sat, 25 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141025120003.839B9400B9@lyth.info>
Date: Sat, 25 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 98b4b0a286c2a8c77d9cefd84cfaf47544b5b9e0:

  diskutil: get rid of disk_util_start_exit() (2014-10-23 23:47:01 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ec803e97e616d8a410d760368c478b683625842a:

  Loop Iteration Offset Bug (2014-10-24 14:47:34 -0600)

----------------------------------------------------------------
Brian Fulton (1):
      Loop Iteration Offset Bug

Gwendal Grignou (1):
      fio: fix alignement to prevent bus error on ARM

Jens Axboe (1):
      Fix fp alignment

 libfio.c |    4 +++-
 stat.h   |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/libfio.c b/libfio.c
index 9ed802a..b823bd4 100644
--- a/libfio.c
+++ b/libfio.c
@@ -108,8 +108,10 @@ void clear_io_state(struct thread_data *td)
 	reset_io_counters(td);
 
 	close_files(td);
-	for_each_file(td, f, i)
+	for_each_file(td, f, i) {
 		fio_file_clear_done(f);
+		f->file_offset = get_start_offset(td, f);
+	}
 
 	/*
 	 * Set the same seed to get repeatable runs
diff --git a/stat.h b/stat.h
index 32ea226..16b3d1a 100644
--- a/stat.h
+++ b/stat.h
@@ -172,6 +172,7 @@ struct thread_stat {
 	 * IO Error related stats
 	 */
 	uint16_t continue_on_error;
+	uint16_t filler[3];
 	uint64_t total_err_count;
 	uint32_t first_error;
 
@@ -180,7 +181,7 @@ struct thread_stat {
 
 	uint32_t latency_depth;
 	uint64_t latency_target;
-	uint16_t pad;
+	uint32_t pad;
 	fio_fp64_t latency_percentile;
 	uint64_t latency_window;
 } __attribute__((packed));
