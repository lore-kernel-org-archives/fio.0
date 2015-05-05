Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39959 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbbEEMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 May 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YpbW6-0006JI-V9
	for fio@vger.kernel.org; Tue, 05 May 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150505120001.A82B42C0272@kernel.dk>
Date: Tue,  5 May 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 020d54bdf73e691b90b75d3abfd8e6f06cd1f637:

  configure: add support for --prefix (2015-04-29 10:29:16 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 95603b7470fac1917cb11bc686e60b4339f8a2fc:

  Fix Runtime, IOPS, bandwidth recorded incorrectly (2015-05-04 16:07:10 -0600)

----------------------------------------------------------------
Brian Fulton (1):
      Fix Runtime, IOPS, bandwidth recorded incorrectly

Jens Axboe (1):
      blktrace: support for non-512b sector sizes

Steven Noonan (2):
      gettime: add support for CLOCK_MONOTONIC_RAW
      lfsr-test: print total elapsed time correctly

 backend.c     | 36 ++++++++++++++++-----------
 blktrace.c    | 78 +++++++++++++++++++++++++++++++++++++++++------------------
 configure     | 21 ++++++++++++++++
 file.h        |  1 +
 gettime.c     |  4 ++-
 t/lfsr-test.c |  2 +-
 6 files changed, 102 insertions(+), 40 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 65a3e18..e87c5f8 100644
--- a/backend.c
+++ b/backend.c
@@ -363,6 +363,20 @@ static inline int runtime_exceeded(struct thread_data *td, struct timeval *t)
 	return 0;
 }
 
+/*
+ * We need to update the runtime consistently in ms, but keep a running
+ * tally of the current elapsed time in microseconds for sub millisecond
+ * updates.
+ */
+static inline void update_runtime(struct thread_data *td,
+				  unsigned long long *elapsed_us,
+				  const enum fio_ddir ddir)
+{
+	td->ts.runtime[ddir] -= (elapsed_us[ddir] + 999) / 1000;
+	elapsed_us[ddir] += utime_since_now(&td->start);
+	td->ts.runtime[ddir] += (elapsed_us[ddir] + 999) / 1000;
+}
+
 static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 			       int *retptr)
 {
@@ -1306,7 +1320,7 @@ static void io_workqueue_fn(struct thread_data *td, struct io_u *io_u)
  */
 static void *thread_main(void *data)
 {
-	unsigned long long elapsed;
+	unsigned long long elapsed_us[DDIR_RWDIR_CNT] = { 0, };
 	struct thread_data *td = data;
 	struct thread_options *o = &td->o;
 	pthread_condattr_t attr;
@@ -1544,18 +1558,12 @@ static void *thread_main(void *data)
 		check_update_rusage(td);
 
 		fio_mutex_down(stat_mutex);
-		if (td_read(td) && td->io_bytes[DDIR_READ]) {
-			elapsed = mtime_since_now(&td->start);
-			td->ts.runtime[DDIR_READ] += elapsed;
-		}
-		if (td_write(td) && td->io_bytes[DDIR_WRITE]) {
-			elapsed = mtime_since_now(&td->start);
-			td->ts.runtime[DDIR_WRITE] += elapsed;
-		}
-		if (td_trim(td) && td->io_bytes[DDIR_TRIM]) {
-			elapsed = mtime_since_now(&td->start);
-			td->ts.runtime[DDIR_TRIM] += elapsed;
-		}
+		if (td_read(td) && td->io_bytes[DDIR_READ])
+			update_runtime(td, elapsed_us, DDIR_READ);
+		if (td_write(td) && td->io_bytes[DDIR_WRITE])
+			update_runtime(td, elapsed_us, DDIR_WRITE);
+		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
+			update_runtime(td, elapsed_us, DDIR_TRIM);
 		fio_gettime(&td->start, NULL);
 		fio_mutex_up(stat_mutex);
 
@@ -1579,7 +1587,7 @@ static void *thread_main(void *data)
 		check_update_rusage(td);
 
 		fio_mutex_down(stat_mutex);
-		td->ts.runtime[DDIR_READ] += mtime_since_now(&td->start);
+		update_runtime(td, elapsed_us, DDIR_READ);
 		fio_gettime(&td->start, NULL);
 		fio_mutex_up(stat_mutex);
 
diff --git a/blktrace.c b/blktrace.c
index bb0bcbe..2d4dc1b 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -4,6 +4,8 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
 #include <dirent.h>
 
 #include "flist.h"
@@ -127,17 +129,37 @@ static void trace_add_open_close_event(struct thread_data *td, int fileno, enum
 	flist_add_tail(&ipo->list, &td->io_log_list);
 }
 
-static int trace_add_file(struct thread_data *td, __u32 device)
+static int get_dev_blocksize(const char *dev, unsigned int *bs)
 {
-	static unsigned int last_maj, last_min, last_fileno;
+	int fd;
+
+	fd = open(dev, O_RDONLY);
+	if (fd < 0)
+		return 1;
+
+	if (ioctl(fd, BLKSSZGET, bs) < 0) {
+		close(fd);
+		return 1;
+	}
+
+	close(fd);
+	return 0;
+}
+
+static int trace_add_file(struct thread_data *td, __u32 device,
+			  unsigned int *bs)
+{
+	static unsigned int last_maj, last_min, last_fileno, last_bs;
 	unsigned int maj = FMAJOR(device);
 	unsigned int min = FMINOR(device);
 	struct fio_file *f;
-	char dev[256];
 	unsigned int i;
+	char dev[256];
 
-	if (last_maj == maj && last_min == min)
+	if (last_maj == maj && last_min == min) {
+		*bs = last_bs;
 		return last_fileno;
+	}
 
 	last_maj = maj;
 	last_min = min;
@@ -145,14 +167,17 @@ static int trace_add_file(struct thread_data *td, __u32 device)
 	/*
 	 * check for this file in our list
 	 */
-	for_each_file(td, f, i)
+	for_each_file(td, f, i) {
 		if (f->major == maj && f->minor == min) {
 			last_fileno = f->fileno;
-			return last_fileno;
+			last_bs = f->bs;
+			goto out;
 		}
+	}
 
 	strcpy(dev, "/dev");
 	if (blktrace_lookup_device(td->o.replay_redirect, dev, maj, min)) {
+		unsigned int this_bs;
 		int fileno;
 
 		if (td->o.replay_redirect)
@@ -164,13 +189,22 @@ static int trace_add_file(struct thread_data *td, __u32 device)
 
 		dprint(FD_BLKTRACE, "add devices %s\n", dev);
 		fileno = add_file_exclusive(td, dev);
+
+		if (get_dev_blocksize(dev, &this_bs))
+			this_bs = 512;
+
 		td->o.open_files++;
 		td->files[fileno]->major = maj;
 		td->files[fileno]->minor = min;
+		td->files[fileno]->bs = this_bs;
 		trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
+
 		last_fileno = fileno;
+		last_bs = this_bs;
 	}
 
+out:
+	*bs = last_bs;
 	return last_fileno;
 }
 
@@ -179,16 +213,13 @@ static int trace_add_file(struct thread_data *td, __u32 device)
  */
 static void store_ipo(struct thread_data *td, unsigned long long offset,
 		      unsigned int bytes, int rw, unsigned long long ttime,
-		      int fileno)
+		      int fileno, unsigned int bs)
 {
 	struct io_piece *ipo = malloc(sizeof(*ipo));
 
 	init_ipo(ipo);
 
-	/*
-	 * the 512 is wrong here, it should be the hardware sector size...
-	 */
-	ipo->offset = offset * 512;
+	ipo->offset = offset * bs;
 	ipo->len = bytes;
 	ipo->delay = ttime / 1000;
 	if (rw)
@@ -225,27 +256,25 @@ static void handle_trace_notify(struct blk_io_trace *t)
 static void handle_trace_discard(struct thread_data *td,
 				 struct blk_io_trace *t,
 				 unsigned long long ttime,
-				 unsigned long *ios, unsigned int *bs)
+				 unsigned long *ios, unsigned int *rw_bs)
 {
 	struct io_piece *ipo = malloc(sizeof(*ipo));
+	unsigned int bs;
 	int fileno;
 
 	init_ipo(ipo);
-	fileno = trace_add_file(td, t->device);
+	fileno = trace_add_file(td, t->device, &bs);
 
 	ios[DDIR_TRIM]++;
-	if (t->bytes > bs[DDIR_TRIM])
-		bs[DDIR_TRIM] = t->bytes;
+	if (t->bytes > rw_bs[DDIR_TRIM])
+		rw_bs[DDIR_TRIM] = t->bytes;
 
 	td->o.size += t->bytes;
 
 	memset(ipo, 0, sizeof(*ipo));
 	INIT_FLIST_HEAD(&ipo->list);
 
-	/*
-	 * the 512 is wrong here, it should be the hardware sector size...
-	 */
-	ipo->offset = t->sector * 512;
+	ipo->offset = t->sector * bs;
 	ipo->len = t->bytes;
 	ipo->delay = ttime / 1000;
 	ipo->ddir = DDIR_TRIM;
@@ -259,21 +288,22 @@ static void handle_trace_discard(struct thread_data *td,
 
 static void handle_trace_fs(struct thread_data *td, struct blk_io_trace *t,
 			    unsigned long long ttime, unsigned long *ios,
-			    unsigned int *bs)
+			    unsigned int *rw_bs)
 {
+	unsigned int bs;
 	int rw;
 	int fileno;
 
-	fileno = trace_add_file(td, t->device);
+	fileno = trace_add_file(td, t->device, &bs);
 
 	rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
 
-	if (t->bytes > bs[rw])
-		bs[rw] = t->bytes;
+	if (t->bytes > rw_bs[rw])
+		rw_bs[rw] = t->bytes;
 
 	ios[rw]++;
 	td->o.size += t->bytes;
-	store_ipo(td, t->sector, t->bytes, rw, ttime, fileno);
+	store_ipo(td, t->sector, t->bytes, rw, ttime, fileno, bs);
 }
 
 /*
diff --git a/configure b/configure
index 0b9874b..3b871ef 100755
--- a/configure
+++ b/configure
@@ -721,6 +721,24 @@ fi
 echo "CLOCK_MONOTONIC               $clock_monotonic"
 
 ##########################################
+# CLOCK_MONOTONIC_RAW probe
+clock_monotonic_raw="no"
+if test "$clock_gettime" = "yes" ; then
+  cat > $TMPC << EOF
+#include <stdio.h>
+#include <time.h>
+int main(int argc, char **argv)
+{
+  return clock_gettime(CLOCK_MONOTONIC_RAW, NULL);
+}
+EOF
+  if compile_prog "" "$LIBS" "clock monotonic"; then
+      clock_monotonic_raw="yes"
+  fi
+fi
+echo "CLOCK_MONOTONIC_RAW           $clock_monotonic_raw"
+
+##########################################
 # CLOCK_MONOTONIC_PRECISE probe
 clock_monotonic_precise="no"
 if test "$clock_gettime" = "yes" ; then
@@ -1485,6 +1503,9 @@ fi
 if test "$clock_monotonic" = "yes" ; then
   output_sym "CONFIG_CLOCK_MONOTONIC"
 fi
+if test "$clock_monotonic_raw" = "yes" ; then
+  output_sym "CONFIG_CLOCK_MONOTONIC_RAW"
+fi
 if test "$clock_monotonic_precise" = "yes" ; then
   output_sym "CONFIG_CLOCK_MONOTONIC_PRECISE"
 fi
diff --git a/file.h b/file.h
index 22ec742..d5595c1 100644
--- a/file.h
+++ b/file.h
@@ -78,6 +78,7 @@ struct fio_file {
 	 */
 	unsigned int major, minor;
 	int fileno;
+	int bs;
 	char *file_name;
 
 	/*
diff --git a/gettime.c b/gettime.c
index 180aa5f..ac54111 100644
--- a/gettime.c
+++ b/gettime.c
@@ -133,7 +133,9 @@ static void fio_init gtod_init(void)
 #ifdef CONFIG_CLOCK_GETTIME
 static int fill_clock_gettime(struct timespec *ts)
 {
-#ifdef CONFIG_CLOCK_MONOTONIC
+#if defined(CONFIG_CLOCK_MONOTONIC_RAW)
+	return clock_gettime(CLOCK_MONOTONIC_RAW, ts);
+#elif defined(CONFIG_CLOCK_MONOTONIC)
 	return clock_gettime(CLOCK_MONOTONIC, ts);
 #else
 	return clock_gettime(CLOCK_REALTIME, ts);
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 901f1a6..4352b89 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -122,7 +122,7 @@ int main(int argc, char *argv[])
 	if (verify)
 		printf("(slower due to verification)");
 	printf("\n==============================\n");
-	printf("Elapsed: %lf s\n", total / pow(10,9));
+	printf("Elapsed: %lf s\n", total / pow(10,6));
 	printf("Mean:    %lf us\n", mean);
 
 	free(v_start);
