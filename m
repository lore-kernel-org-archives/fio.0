Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44482 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755257AbdJJMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Oct 2017 08:00:10 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e1tCk-0000HS-IY
        for fio@vger.kernel.org; Tue, 10 Oct 2017 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171010120001.69BEC2C0111@kernel.dk>
Date: Tue, 10 Oct 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f7c9bfd57232c6e11623d741be340d32f796c726:

  backend: don't complain about no IO done for create_only=1 (2017-10-06 11:41:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b18775f7b7c6c7d0a4d9b0a38e2a979e4180d14e:

  Update file creation example (2017-10-09 14:42:45 -0600)

----------------------------------------------------------------
Jens Axboe (7):
      engines/filecreate: a few fixes
      engines/filecreate: don't use file hash
      engines/filecreate: set FIO_NOSTATS flag
      filesetup: don't track file allocation for jobs == 1
      time: add ntime_since_now()
      engine/filecreate: use clat and reads for stats
      Update file creation example

Josef Bacik (3):
      add a filecreate engine
      add FIO_FILENOHASH ioengine flag
      add an filecreate example file to examples/

Vincent Fu (2):
      stat: update description of clat accounting in stat.h
      stat: update json+ output format for --lat_percentiles option

 HOWTO                            |  4 ++
 Makefile                         |  2 +-
 engines/filecreate.c             | 90 ++++++++++++++++++++++++++++++++++++++++
 examples/filecreate-ioengine.fio | 35 ++++++++++++++++
 filesetup.c                      | 29 ++++++++++---
 fio.1                            |  4 ++
 fio_time.h                       |  1 +
 gettime.c                        |  8 ++++
 io_u.c                           |  2 +-
 ioengines.h                      |  2 +
 options.c                        |  4 ++
 stat.c                           |  9 +++-
 stat.h                           | 23 +++++-----
 tools/fio_jsonplus_clat2csv      | 12 +++++-
 14 files changed, 203 insertions(+), 22 deletions(-)
 create mode 100644 engines/filecreate.c
 create mode 100644 examples/filecreate-ioengine.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 8fad2ce..df79e2d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1797,6 +1797,10 @@ I/O engine
 			absolute or relative. See :file:`engines/skeleton_external.c` for
 			details of writing an external I/O engine.
 
+		**filecreate**
+			Simply create the files and do no IO to them.  You still need to
+			set  `filesize` so that all the accounting still occurs, but no
+			actual IO will be done other than creating the file.
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/Makefile b/Makefile
index 3764da5..76243ff 100644
--- a/Makefile
+++ b/Makefile
@@ -42,7 +42,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c \
+		engines/ftruncate.c engines/filecreate.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/engines/filecreate.c b/engines/filecreate.c
new file mode 100644
index 0000000..c6b6597
--- /dev/null
+++ b/engines/filecreate.c
@@ -0,0 +1,90 @@
+/*
+ * filecreate engine
+ *
+ * IO engine that doesn't do any IO, just creates files and tracks the latency
+ * of the file creation.
+ */
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include "../fio.h"
+#include "../filehash.h"
+
+static int open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start;
+	int do_lat = !td->o.disable_lat;
+
+	dprint(FD_FILE, "fd open %s\n", f->file_name);
+
+	if (f->filetype != FIO_TYPE_FILE) {
+		log_err("fio: only files are supported fallocate \n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+	if (do_lat)
+		fio_gettime(&start, NULL);
+
+	f->fd = open(f->file_name, O_CREAT|O_RDWR, 0600);
+
+	if (f->fd == -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e = errno;
+
+		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
+		td_verror(td, e, buf);
+		return 1;
+	}
+
+	if (do_lat) {
+		uint64_t nsec;
+
+		nsec = ntime_since_now(&start);
+		add_clat_sample(td, DDIR_READ, nsec, 0, 0);
+	}
+
+	return 0;
+}
+
+static int queue_io(struct thread_data *td, struct io_u fio_unused *io_u)
+{
+	return FIO_Q_COMPLETED;
+}
+
+/*
+ * Ensure that we at least have a block size worth of IO to do for each
+ * file. If the job file has td->o.size < nr_files * block_size, then
+ * fio won't do anything.
+ */
+static int get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	f->real_file_size = td_min_bs(td);
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "filecreate",
+	.version	= FIO_IOOPS_VERSION,
+	.queue		= queue_io,
+	.get_file_size	= get_file_size,
+	.open_file	= open_file,
+	.close_file	= generic_close_file,
+	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+static void fio_init fio_filecreate_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_filecreate_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/filecreate-ioengine.fio b/examples/filecreate-ioengine.fio
new file mode 100644
index 0000000..ec7caad
--- /dev/null
+++ b/examples/filecreate-ioengine.fio
@@ -0,0 +1,35 @@
+# Example filecreate job
+#
+# create_on_open is needed so that the open happens during the run and not the
+# setup.
+#
+# openfiles needs to be set so that you do not exceed the maximum allowed open
+# files.
+#
+# filesize needs to be set to a non zero value so fio will actually run, but the
+# IO will not really be done and the write latency numbers will only reflect the
+# open times.
+[global]
+create_on_open=1
+nrfiles=31250
+ioengine=filecreate
+fallocate=none
+filesize=4k
+openfiles=1
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
+[t6]
+[t7]
+[t8]
+[t9]
+[t10]
+[t11]
+[t12]
+[t13]
+[t14]
+[t15]
diff --git a/filesetup.c b/filesetup.c
index 891a55a..0631a01 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1342,6 +1342,7 @@ void close_and_free_files(struct thread_data *td)
 {
 	struct fio_file *f;
 	unsigned int i;
+	bool use_free = td_ioengine_flagged(td, FIO_NOFILEHASH);
 
 	dprint(FD_FILE, "close files\n");
 
@@ -1361,13 +1362,19 @@ void close_and_free_files(struct thread_data *td)
 			td_io_unlink_file(td, f);
 		}
 
-		sfree(f->file_name);
+		if (use_free)
+			free(f->file_name);
+		else
+			sfree(f->file_name);
 		f->file_name = NULL;
 		if (fio_file_axmap(f)) {
 			axmap_free(f->io_axmap);
 			f->io_axmap = NULL;
 		}
-		sfree(f);
+		if (use_free)
+			free(f);
+		else
+			sfree(f);
 	}
 
 	td->o.filename = NULL;
@@ -1481,7 +1488,10 @@ static struct fio_file *alloc_new_file(struct thread_data *td)
 {
 	struct fio_file *f;
 
-	f = smalloc(sizeof(*f));
+	if (td_ioengine_flagged(td, FIO_NOFILEHASH))
+		f = calloc(1, sizeof(*f));
+	else
+		f = smalloc(sizeof(*f));
 	if (!f) {
 		assert(0);
 		return NULL;
@@ -1564,7 +1574,10 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	if (td->io_ops && td_ioengine_flagged(td, FIO_DISKLESSIO))
 		f->real_file_size = -1ULL;
 
-	f->file_name = smalloc_strdup(file_name);
+	if (td_ioengine_flagged(td, FIO_NOFILEHASH))
+		f->file_name = strdup(file_name);
+	else
+		f->file_name = smalloc_strdup(file_name);
 	if (!f->file_name)
 		assert(0);
 
@@ -1588,7 +1601,8 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	if (f->filetype == FIO_TYPE_FILE)
 		td->nr_normal_files++;
 
-	set_already_allocated(file_name);
+	if (td->o.numjobs > 1)
+		set_already_allocated(file_name);
 
 	if (inc)
 		td->o.nr_files++;
@@ -1768,7 +1782,10 @@ void dup_files(struct thread_data *td, struct thread_data *org)
 		__f = alloc_new_file(td);
 
 		if (f->file_name) {
-			__f->file_name = smalloc_strdup(f->file_name);
+			if (td_ioengine_flagged(td, FIO_NOFILEHASH))
+				__f->file_name = strdup(f->file_name);
+			else
+				__f->file_name = smalloc_strdup(f->file_name);
 			if (!__f->file_name)
 				assert(0);
 
diff --git a/fio.1 b/fio.1
index b943db2..68ed3ba 100644
--- a/fio.1
+++ b/fio.1
@@ -1577,6 +1577,10 @@ the engine filename, e.g. `ioengine=external:/tmp/foo.o' to load
 ioengine `foo.o' in `/tmp'. The path can be either
 absolute or relative. See `engines/skeleton_external.c' in the fio source for
 details of writing an external I/O engine.
+.TP
+.B filecreate
+Create empty files only.  \fBfilesize\fR still needs to be specified so that fio
+will run and grab latency results, but no IO will actually be done on the files.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
diff --git a/fio_time.h b/fio_time.h
index f4eac79..c7c3dbb 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -5,6 +5,7 @@
 
 struct thread_data;
 extern uint64_t ntime_since(const struct timespec *, const struct timespec *);
+extern uint64_t ntime_since_now(const struct timespec *);
 extern uint64_t utime_since(const struct timespec *, const struct timespec *);
 extern uint64_t utime_since_now(const struct timespec *);
 extern uint64_t mtime_since(const struct timespec *, const struct timespec *);
diff --git a/gettime.c b/gettime.c
index 3dcaaf6..7945528 100644
--- a/gettime.c
+++ b/gettime.c
@@ -448,6 +448,14 @@ uint64_t ntime_since(const struct timespec *s, const struct timespec *e)
        return nsec + (sec * 1000000000LL);
 }
 
+uint64_t ntime_since_now(const struct timespec *s)
+{
+	struct timespec now;
+
+	fio_gettime(&now, NULL);
+	return ntime_since(s, &now);
+}
+
 uint64_t utime_since(const struct timespec *s, const struct timespec *e)
 {
 	int64_t sec, usec;
diff --git a/io_u.c b/io_u.c
index 58c2320..fb4180a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1779,7 +1779,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	if (td->parent)
 		td = td->parent;
 
-	if (!td->o.stats)
+	if (!td->o.stats || td_ioengine_flagged(td, FIO_NOSTATS))
 		return;
 
 	if (no_reduce)
diff --git a/ioengines.h b/ioengines.h
index 177cbc0..32b18ed 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -59,6 +59,8 @@ enum fio_ioengine_flags {
 	FIO_MEMALIGN	= 1 << 9,	/* engine wants aligned memory */
 	FIO_BIT_BASED	= 1 << 10,	/* engine uses a bit base (e.g. uses Kbit as opposed to KB) */
 	FIO_FAKEIO	= 1 << 11,	/* engine pretends to do IO */
+	FIO_NOSTATS	= 1 << 12,	/* don't do IO stats */
+	FIO_NOFILEHASH	= 1 << 13,	/* doesn't hash the files for lookup later. */
 };
 
 /*
diff --git a/options.c b/options.c
index 5c1abe9..ddcc4e5 100644
--- a/options.c
+++ b/options.c
@@ -1843,6 +1843,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "DAX Device based IO engine",
 			  },
 #endif
+			  {
+			    .ival = "filecreate",
+			    .help = "File creation engine",
+			  },
 			  { .ival = "external",
 			    .help = "Load external engine (append name)",
 			    .cb = str_ioengine_external_cb,
diff --git a/stat.c b/stat.c
index 09afa5b..c5a68ad 100644
--- a/stat.c
+++ b/stat.c
@@ -962,7 +962,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	unsigned int len;
 	int i;
 	const char *ddirname[] = {"read", "write", "trim"};
-	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object;
+	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object = NULL;
 	char buf[120];
 	double p_of_agg = 100.0;
 
@@ -1036,7 +1036,9 @@ static void add_ddir_status_json(struct thread_stat *ts,
 
 	if (output_format & FIO_OUTPUT_JSON_PLUS) {
 		clat_bins_object = json_create_object();
-		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+		if (ts->clat_percentiles)
+			json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+
 		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
 			if (ts->io_u_plat[ddir][i]) {
 				snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
@@ -1055,6 +1057,9 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_int(tmp_object, "max", max);
 	json_object_add_value_float(tmp_object, "mean", mean);
 	json_object_add_value_float(tmp_object, "stddev", dev);
+	if (output_format & FIO_OUTPUT_JSON_PLUS && ts->lat_percentiles)
+		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+
 	if (ovals)
 		free(ovals);
 
diff --git a/stat.h b/stat.h
index 848331b..3fda084 100644
--- a/stat.h
+++ b/stat.h
@@ -24,6 +24,16 @@ struct group_run_stats {
 #define FIO_IO_U_LAT_M_NR 12
 
 /*
+ * Constants for clat percentiles
+ */
+#define FIO_IO_U_PLAT_BITS 6
+#define FIO_IO_U_PLAT_VAL (1 << FIO_IO_U_PLAT_BITS)
+#define FIO_IO_U_PLAT_GROUP_NR 29
+#define FIO_IO_U_PLAT_NR (FIO_IO_U_PLAT_GROUP_NR * FIO_IO_U_PLAT_VAL)
+#define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
+					list of percentiles */
+
+/*
  * Aggregate clat samples to report percentile(s) of them.
  *
  * EXECUTIVE SUMMARY
@@ -34,7 +44,7 @@ struct group_run_stats {
  *
  * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the maximum
  * range being tracked for latency samples. The maximum value tracked
- * accurately will be 2^(GROUP_NR + PLAT_BITS -1) microseconds.
+ * accurately will be 2^(GROUP_NR + PLAT_BITS - 1) nanoseconds.
  *
  * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the memory
  * requirement of storing those aggregate counts. The memory used will
@@ -98,22 +108,15 @@ struct group_run_stats {
  *	3	8	2		[256,511]		64
  *	4	9	3		[512,1023]		64
  *	...	...	...		[...,...]		...
- *	18	23	17		[8838608,+inf]**	64
+ *	28	33	27		[8589934592,+inf]**	64
  *
  *  * Special cases: when n < (M-1) or when n == (M-1), in both cases,
  *    the value cannot be rounded off. Use all bits of the sample as
  *    index.
  *
- *  ** If a sample's MSB is greater than 23, it will be counted as 23.
+ *  ** If a sample's MSB is greater than 33, it will be counted as 33.
  */
 
-#define FIO_IO_U_PLAT_BITS 6
-#define FIO_IO_U_PLAT_VAL (1 << FIO_IO_U_PLAT_BITS)
-#define FIO_IO_U_PLAT_GROUP_NR 29
-#define FIO_IO_U_PLAT_NR (FIO_IO_U_PLAT_GROUP_NR * FIO_IO_U_PLAT_VAL)
-#define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
-					list of percentiles */
-
 /*
  * Trim cycle count measurements
  */
diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
index d4ac16e..64fdc9f 100755
--- a/tools/fio_jsonplus_clat2csv
+++ b/tools/fio_jsonplus_clat2csv
@@ -107,8 +107,16 @@ def main():
 
         prev_ddir = None
         for ddir in ddir_set:
+            if 'bins' in jsondata['jobs'][jobnum][ddir]['clat_ns']:
+                bins_loc = 'clat_ns'
+            elif 'bins' in jsondata['jobs'][jobnum][ddir]['lat_ns']:
+                bins_loc = 'lat_ns'
+            else:
+                raise RuntimeError("Latency bins not found. "
+                                   "Are you sure you are using json+ output?")
+
             bins[ddir] = [[int(key), value] for key, value in
-                          jsondata['jobs'][jobnum][ddir]['clat_ns']
+                          jsondata['jobs'][jobnum][ddir][bins_loc]
                           ['bins'].iteritems()]
             bins[ddir] = sorted(bins[ddir], key=lambda bin: bin[0])
 
@@ -123,7 +131,7 @@ def main():
         outfile = stub + '_job' + str(jobnum) + ext
 
         with open(outfile, 'w') as output:
-            output.write("clat_nsec, ")
+            output.write("{0}ec, ".format(bins_loc))
             ddir_list = list(ddir_set)
             for ddir in ddir_list:
                 output.write("{0}_count, {0}_cumulative, {0}_percentile, ".
