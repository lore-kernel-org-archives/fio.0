Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaKHNAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 8 Nov 2014 08:00:08 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xn5cd-00025V-BM
	for fio@vger.kernel.org; Sat, 08 Nov 2014 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141108130004.2617440128@lyth.info>
Date: Sat,  8 Nov 2014 06:00:04 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 544992f770de2b98481b980e463e0492c2f2763e:

  smalloc: add zeroing scalloc() variant (2014-11-06 15:19:31 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 988d97bac90c9ff3ee40a8ccd588fdf78f19320d:

  client/server: percentile_precision wasn't net converted (2014-11-07 18:47:41 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Add time_since_genesis()
      iolog: fix intermittent crash on exit with verify enabled
      client/server: percentile_precision wasn't net converted

 client.c   |    1 +
 fio_time.h |    1 +
 iolog.c    |    2 +-
 server.c   |    1 +
 time.c     |    5 +++++
 5 files changed, 9 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index e9eab81..56ee6dc 100644
--- a/client.c
+++ b/client.c
@@ -805,6 +805,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->minf		= le64_to_cpu(src->minf);
 	dst->majf		= le64_to_cpu(src->majf);
 	dst->clat_percentiles	= le64_to_cpu(src->clat_percentiles);
+	dst->percentile_precision = le64_to_cpu(src->percentile_precision);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
 		fio_fp64_t *fps = &src->percentile_list[i];
diff --git a/fio_time.h b/fio_time.h
index 5fd3847..27520b0 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -7,6 +7,7 @@ extern uint64_t utime_since_now(const struct timeval *);
 extern uint64_t mtime_since(const struct timeval *, const struct timeval *);
 extern uint64_t mtime_since_now(const struct timeval *);
 extern uint64_t time_since_now(const struct timeval *);
+extern uint64_t time_since_genesis(void);
 extern uint64_t mtime_since_genesis(void);
 extern uint64_t utime_since_genesis(void);
 extern void usec_spin(unsigned int);
diff --git a/iolog.c b/iolog.c
index 1ff64e6..785e549 100644
--- a/iolog.c
+++ b/iolog.c
@@ -173,7 +173,7 @@ void prune_io_piece_log(struct thread_data *td)
 	}
 
 	while (!flist_empty(&td->io_hist_list)) {
-		ipo = flist_entry(&td->io_hist_list, struct io_piece, list);
+		ipo = flist_first_entry(&td->io_hist_list, struct io_piece, list);
 		flist_del(&ipo->list);
 		remove_trim_entry(td, ipo);
 		td->io_hist_len--;
diff --git a/server.c b/server.c
index 14eb199..d70444b 100644
--- a/server.c
+++ b/server.c
@@ -1040,6 +1040,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.minf		= cpu_to_le64(ts->minf);
 	p.ts.majf		= cpu_to_le64(ts->majf);
 	p.ts.clat_percentiles	= cpu_to_le64(ts->clat_percentiles);
+	p.ts.percentile_precision = cpu_to_le64(ts->percentile_precision);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
 		fio_fp64_t *src = &ts->percentile_list[i];
diff --git a/time.c b/time.c
index f3de3e7..b145dc5 100644
--- a/time.c
+++ b/time.c
@@ -53,6 +53,11 @@ void usec_sleep(struct thread_data *td, unsigned long usec)
 	} while (!td->terminate);
 }
 
+uint64_t time_since_genesis(void)
+{
+	return time_since_now(&genesis);
+}
+
 uint64_t mtime_since_genesis(void)
 {
 	return mtime_since_now(&genesis);
