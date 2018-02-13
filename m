Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60394 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935077AbeBMNA1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Feb 2018 08:00:27 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1elaCA-00012K-TX
        for fio@vger.kernel.org; Tue, 13 Feb 2018 13:00:27 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180213130002.885B52C00B7@kernel.dk>
Date: Tue, 13 Feb 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3c0a8bc2f33ba721a97b459d5b32acbf4460450f:

  init: fixup some bad style in previous commit (2018-02-10 14:44:49 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f2cd91604af170e972438c461a40230e266a57d9:

  debug: fix inverted logic in fio_did_warn() (2018-02-12 10:55:07 -0700)

----------------------------------------------------------------
Bryce Guinta (1):
      Make fiologparser_hist compatible with python3

Jens Axboe (7):
      Merge branch 'master' of https://github.com/brycepg/fio
      init: add global 'warned' state
      filesetup: convert root flush warning to fio_did_warn()
      verify: convert verify buf too small warning to fio_did_warn()
      io_u: convert zoned bug warning to fio_did_warn()
      iolog: convert drop warning to fio_did_warn()
      debug: fix inverted logic in fio_did_warn()

 debug.h                         | 19 ++++++++++++++++++-
 filesetup.c                     |  5 +----
 init.c                          |  6 +++++-
 io_u.c                          | 10 ++--------
 iolog.c                         |  6 +-----
 tools/hist/fiologparser_hist.py | 11 ++++++-----
 verify.c                        |  5 +----
 7 files changed, 34 insertions(+), 28 deletions(-)

---

Diff of recent changes:

diff --git a/debug.h b/debug.h
index e3aa3f1..ba62214 100644
--- a/debug.h
+++ b/debug.h
@@ -2,6 +2,7 @@
 #define FIO_DEBUG_H
 
 #include <assert.h>
+#include "lib/types.h"
 #include "log.h"
 
 enum {
@@ -26,7 +27,23 @@ enum {
 	FD_DEBUG_MAX,
 };
 
-extern unsigned int fio_debug_jobno, *fio_debug_jobp;
+extern unsigned int fio_debug_jobno, *fio_debug_jobp, *fio_warned;
+
+static inline bool fio_did_warn(unsigned int mask)
+{
+	if (*fio_warned & mask)
+		return true;
+
+	*fio_warned |= mask;
+	return false;
+}
+
+enum {
+	FIO_WARN_ROOT_FLUSH	= 1,
+	FIO_WARN_VERIFY_BUF	= 2,
+	FIO_WARN_ZONED_BUG	= 4,
+	FIO_WARN_IOLOG_DROP	= 8,
+};
 
 #ifdef FIO_INC_DEBUG
 struct debug_level {
diff --git a/filesetup.c b/filesetup.c
index 3cda606..cced556 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -20,8 +20,6 @@
 #include <linux/falloc.h>
 #endif
 
-static int root_warn;
-
 static FLIST_HEAD(filename_list);
 
 /*
@@ -516,10 +514,9 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 			ret = blockdev_invalidate_cache(f);
 		}
 		if (ret < 0 && errno == EACCES && geteuid()) {
-			if (!root_warn) {
+			if (!fio_did_warn(FIO_WARN_ROOT_FLUSH)) {
 				log_err("fio: only root may flush block "
 					"devices. Cache flush bypassed!\n");
-				root_warn = 1;
 			}
 			ret = 0;
 		}
diff --git a/init.c b/init.c
index 25661be..28061db 100644
--- a/init.c
+++ b/init.c
@@ -79,6 +79,7 @@ static int prev_group_jobs;
 unsigned long fio_debug = 0;
 unsigned int fio_debug_jobno = -1;
 unsigned int *fio_debug_jobp = NULL;
+unsigned int *fio_warned = NULL;
 
 static char cmd_optstr[256];
 static bool did_arg;
@@ -309,6 +310,7 @@ static void free_shm(void)
 	if (threads) {
 		flow_exit();
 		fio_debug_jobp = NULL;
+		fio_warned = NULL;
 		free_threads_shm();
 	}
 
@@ -341,7 +343,7 @@ static int setup_thread_area(void)
 	do {
 		size_t size = max_jobs * sizeof(struct thread_data);
 
-		size += sizeof(unsigned int);
+		size += 2 * sizeof(unsigned int);
 
 #ifndef CONFIG_NO_SHM
 		shm_id = shmget(0, size, IPC_CREAT | 0600);
@@ -376,6 +378,8 @@ static int setup_thread_area(void)
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
 	fio_debug_jobp = (unsigned int *)(threads + max_jobs);
 	*fio_debug_jobp = -1;
+	fio_warned = fio_debug_jobp + 1;
+	*fio_warned = 0;
 
 	flow_init();
 
diff --git a/io_u.c b/io_u.c
index 404c75b..b54a79c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -163,7 +163,6 @@ static int __get_next_rand_offset_zoned_abs(struct thread_data *td,
 {
 	struct zone_split_index *zsi;
 	uint64_t lastb, send, stotal;
-	static int warned;
 	unsigned int v;
 
 	lastb = last_block(td, f, ddir);
@@ -192,10 +191,8 @@ bail:
 	 * Should never happen
 	 */
 	if (send == -1U) {
-		if (!warned) {
+		if (!fio_did_warn(FIO_WARN_ZONED_BUG))
 			log_err("fio: bug in zoned generation\n");
-			warned = 1;
-		}
 		goto bail;
 	} else if (send > lastb) {
 		/*
@@ -223,7 +220,6 @@ static int __get_next_rand_offset_zoned(struct thread_data *td,
 {
 	unsigned int v, send, stotal;
 	uint64_t offset, lastb;
-	static int warned;
 	struct zone_split_index *zsi;
 
 	lastb = last_block(td, f, ddir);
@@ -248,10 +244,8 @@ bail:
 	 * Should never happen
 	 */
 	if (send == -1U) {
-		if (!warned) {
+		if (!fio_did_warn(FIO_WARN_ZONED_BUG))
 			log_err("fio: bug in zoned generation\n");
-			warned = 1;
-		}
 		goto bail;
 	}
 
diff --git a/iolog.c b/iolog.c
index 760d7b0..34e74a8 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1141,8 +1141,6 @@ size_t log_chunk_sizes(struct io_log *log)
 
 #ifdef CONFIG_ZLIB
 
-static bool warned_on_drop;
-
 static void iolog_put_deferred(struct io_log *log, void *ptr)
 {
 	if (!ptr)
@@ -1152,10 +1150,8 @@ static void iolog_put_deferred(struct io_log *log, void *ptr)
 	if (log->deferred < IOLOG_MAX_DEFER) {
 		log->deferred_items[log->deferred] = ptr;
 		log->deferred++;
-	} else if (!warned_on_drop) {
+	} else if (!fio_did_warn(FIO_WARN_IOLOG_DROP))
 		log_err("fio: had to drop log entry free\n");
-		warned_on_drop = true;
-	}
 	pthread_mutex_unlock(&log->deferred_free_lock);
 }
 
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index 2e05b92..62a4eb4 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -177,7 +177,7 @@ def print_all_stats(ctx, end, mn, ss_cnt, vs, ws, mx):
 
     avg = weighted_average(vs, ws)
     values = [mn, avg] + list(ps) + [mx]
-    row = [end, ss_cnt] + map(lambda x: float(x) / ctx.divisor, values)
+    row = [end, ss_cnt] + [float(x) / ctx.divisor for x in values]
     fmt = "%d, %d, %d, " + fmt_float_list(ctx, 5) + ", %d"
     print (fmt % tuple(row))
 
@@ -288,9 +288,9 @@ def main(ctx):
 
         max_cols = guess_max_from_bins(ctx, __HIST_COLUMNS)
         coarseness = int(np.log2(float(max_cols) / __HIST_COLUMNS))
-        bin_vals = np.array(map(lambda x: plat_idx_to_val_coarse(x, coarseness), np.arange(__HIST_COLUMNS)), dtype=float)
-        lower_bin_vals = np.array(map(lambda x: plat_idx_to_val_coarse(x, coarseness, 0.0), np.arange(__HIST_COLUMNS)), dtype=float)
-        upper_bin_vals = np.array(map(lambda x: plat_idx_to_val_coarse(x, coarseness, 1.0), np.arange(__HIST_COLUMNS)), dtype=float)
+        bin_vals = np.array([plat_idx_to_val_coarse(x, coarseness) for x in np.arange(__HIST_COLUMNS)], dtype=float)
+        lower_bin_vals = np.array([plat_idx_to_val_coarse(x, coarseness, 0.0) for x in np.arange(__HIST_COLUMNS)], dtype=float)
+        upper_bin_vals = np.array([plat_idx_to_val_coarse(x, coarseness, 1.0) for x in np.arange(__HIST_COLUMNS)], dtype=float)
 
     fps = [open(f, 'r') for f in ctx.FILE]
     gen = histogram_generator(ctx, fps, ctx.buff_size)
@@ -333,7 +333,8 @@ def main(ctx):
             start += ctx.interval
             end = start + ctx.interval
     finally:
-        map(lambda f: f.close(), fps)
+        for fp in fps:
+            fp.close()
 
 
 if __name__ == '__main__':
diff --git a/verify.c b/verify.c
index b178450..aeafdb5 100644
--- a/verify.c
+++ b/verify.c
@@ -241,7 +241,6 @@ struct vcont {
 };
 
 #define DUMP_BUF_SZ	255
-static int dump_buf_warned;
 
 static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 		     const char *type, struct fio_file *f)
@@ -260,10 +259,8 @@ static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 
 	buf_left -= strlen(fname);
 	if (buf_left <= 0) {
-		if (!dump_buf_warned) {
+		if (!fio_did_warn(FIO_WARN_VERIFY_BUF))
 			log_err("fio: verify failure dump buffer too small\n");
-			dump_buf_warned = 1;
-		}
 		free(ptr);
 		return;
 	}
