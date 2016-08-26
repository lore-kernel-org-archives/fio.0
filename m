Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45145 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbcHZMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Aug 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bdFnn-00018h-G6
        for fio@vger.kernel.org; Fri, 26 Aug 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160826120002.7727F2C0286@kernel.dk>
Date: Fri, 26 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9e4438fecd1d92b4d5221f35d5e73546f52c6ebf:

  stat: don't trust per_unit_log() if log is NULL (2016-08-22 13:23:29 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 04d6530f6ecd50520e99732b0b6bb90f71ff131a:

  file: fix numjobs > 1 and implied jobname as filename (2016-08-25 21:00:55 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'epoch-histograms' of https://github.com/cronburg/fio
      file: fix numjobs > 1 and implied jobname as filename

Karl Cronburg (1):
      Give job file to fiologparser_hist.py so that it can auto detect     log_hist_msec. This commit also adds handling of unix epoch     timestamps by fiologparser_hist.py.

 file.h                          |  1 +
 filesetup.c                     | 43 +++++++++++++++++++++++++++++++----------
 init.c                          | 20 -------------------
 tools/hist/fiologparser_hist.py | 41 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 73 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/file.h b/file.h
index f7e5d20..aff3ce9 100644
--- a/file.h
+++ b/file.h
@@ -211,5 +211,6 @@ extern void free_release_files(struct thread_data *);
 extern void filesetup_mem_free(void);
 extern void fio_file_reset(struct thread_data *, struct fio_file *);
 extern int fio_files_done(struct thread_data *);
+extern bool exists_and_not_regfile(const char *);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index 5db44c2..fc9f306 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1242,31 +1242,33 @@ static void get_file_type(struct fio_file *f)
 	}
 }
 
-static int __is_already_allocated(const char *fname)
+static bool __is_already_allocated(const char *fname)
 {
 	struct flist_head *entry;
-	char *filename;
 
 	if (flist_empty(&filename_list))
-		return 0;
+		return false;
 
 	flist_for_each(entry, &filename_list) {
-		filename = flist_entry(entry, struct file_name, list)->filename;
+		struct file_name *fn;
 
-		if (strcmp(filename, fname) == 0)
-			return 1;
+		fn = flist_entry(entry, struct file_name, list);
+
+		if (!strcmp(fn->filename, fname))
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
-static int is_already_allocated(const char *fname)
+static bool is_already_allocated(const char *fname)
 {
-	int ret;
+	bool ret;
 
 	fio_file_hash_lock();
 	ret = __is_already_allocated(fname);
 	fio_file_hash_unlock();
+
 	return ret;
 }
 
@@ -1327,6 +1329,26 @@ static struct fio_file *alloc_new_file(struct thread_data *td)
 	return f;
 }
 
+bool exists_and_not_regfile(const char *filename)
+{
+	struct stat sb;
+
+	if (lstat(filename, &sb) == -1)
+		return false;
+
+#ifndef WIN32 /* NOT Windows */
+	if (S_ISREG(sb.st_mode))
+		return false;
+#else
+	/* \\.\ is the device namespace in Windows, where every file
+	 * is a device node */
+	if (S_ISREG(sb.st_mode) && strncmp(filename, "\\\\.\\", 4) != 0)
+		return false;
+#endif
+
+	return true;
+}
+
 int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 {
 	int cur_files = td->files_index;
@@ -1343,7 +1365,8 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	sprintf(file_name + len, "%s", fname);
 
 	/* clean cloned siblings using existing files */
-	if (numjob && is_already_allocated(file_name))
+	if (numjob && is_already_allocated(file_name) &&
+	    !exists_and_not_regfile(fname))
 		return 0;
 
 	f = alloc_new_file(td);
diff --git a/init.c b/init.c
index 5ff7385..0221ab2 100644
--- a/init.c
+++ b/init.c
@@ -903,26 +903,6 @@ static const char *get_engine_name(const char *str)
 	return p;
 }
 
-static int exists_and_not_regfile(const char *filename)
-{
-	struct stat sb;
-
-	if (lstat(filename, &sb) == -1)
-		return 0;
-
-#ifndef WIN32 /* NOT Windows */
-	if (S_ISREG(sb.st_mode))
-		return 0;
-#else
-	/* \\.\ is the device namespace in Windows, where every file
-	 * is a device node */
-	if (S_ISREG(sb.st_mode) && strncmp(filename, "\\\\.\\", 4) != 0)
-		return 0;
-#endif
-
-	return 1;
-}
-
 static void init_rand_file_service(struct thread_data *td)
 {
 	unsigned long nranges = td->o.nr_files << FIO_FSERVICE_SHIFT;
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index 778cc00..93dca01 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -255,6 +255,29 @@ def guess_max_from_bins(ctx, hist_cols):
 
 def main(ctx):
 
+    if ctx.job_file:
+        try:
+            from configparser import SafeConfigParser
+        except ImportError:
+            from ConfigParser import SafeConfigParser
+
+        cp = SafeConfigParser(allow_no_value=True)
+        with open(ctx.job_file, 'r') as fp:
+            cp.read(fp)
+
+        if ctx.interval is None:
+            # Auto detect --interval value
+            for s in cp.sections():
+                try:
+                    hist_msec = cp[s]['log_hist_msec']
+                    if hist_msec is not None:
+                        ctx.interval = int(hist_msec)
+                except KeyError:
+                    pass
+
+    if ctx.interval is None:
+        ctx.interval = 1000
+
     # Automatically detect how many columns are in the input files,
     # calculate the corresponding 'coarseness' parameter used to generate
     # those files, and calculate the appropriate bin latency values:
@@ -291,6 +314,14 @@ def main(ctx):
             arr = arr.astype(int)
             
             if arr.size > 0:
+                # Jump immediately to the start of the input, rounding
+                # down to the nearest multiple of the interval (useful when --log_unix_epoch
+                # was used to create these histograms):
+                if start == 0 and arr[0][0] - ctx.max_latency > end:
+                    start = arr[0][0] - ctx.max_latency
+                    start = start - (start % ctx.interval)
+                    end = start + ctx.interval
+
                 process_interval(ctx, arr, start, end)
                 
                 # Update arr to throw away samples we no longer need - samples which
@@ -321,9 +352,8 @@ if __name__ == '__main__':
         help='number of seconds of data to process at a time')
 
     arg('-i', '--interval',
-        default=1000,
         type=int,
-        help='interval width (ms)')
+        help='interval width (ms), default 1000 ms')
 
     arg('-d', '--divisor',
         required=False,
@@ -347,5 +377,12 @@ if __name__ == '__main__':
         type=int,
         help='FIO_IO_U_PLAT_GROUP_NR as defined in stat.h')
 
+    arg('--job-file',
+        default=None,
+        type=str,
+        help='Optional argument pointing to the job file used to create the '
+             'given histogram files. Useful for auto-detecting --log_hist_msec and '
+             '--log_unix_epoch (in fio) values.')
+
     main(p.parse_args())
 
