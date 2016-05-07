Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56202 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbcEGMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 7 May 2016 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1az0tv-0000TP-Ep
	for fio@vger.kernel.org; Sat, 07 May 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160507120001.F33612C00D8@kernel.dk>
Date: Sat,  7 May 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 604577f1329b617d724d6712868d344a5adf5251:

  libfio: clear iops/bw sample times on stats reset (2016-05-05 10:55:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d5bdff69e877a3f65928278df9d252d8881ff864:

  Makefile: fix path to tools/fiologparser.py (2016-05-06 17:10:33 -0600)

----------------------------------------------------------------
Brian Boylston (4):
      add pmemblk engine
      add an example job file for pmemblk
      pmemblk: remove comments about an external engine
      pmemblk: don't use #defines for the pmemblk_* functions

Jens Axboe (13):
      Improve logging accuracy
      stat: remove debug statement
      Makefile: add tools/fiologpaser.py
      Merge branch 'libpmemblk' of https://github.com/bgbhpe/fio
      engines/pmeblk: fixup coding style
      engines/pmemblk: get rid of CACHE_LOCK/UNLOCK defines
      Wire up pmemblk
      Merge branch 'logging'
      helper_thread: split into separate file
      os/os-mac: kill unused code
      diskutil: adapt to new helper_thread functions
      Fix typo in tools/fiologparser.py
      Makefile: fix path to tools/fiologparser.py

Mark Nelson (1):
      added fio log parser tool.

 HOWTO                 |  11 +-
 Makefile              |   7 +-
 backend.c             |  87 +--------
 configure             |  11 ++
 diskutil.c            |   3 +-
 diskutil.h            |   5 +-
 engines/pmemblk.c     | 523 ++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/pmemblk.fio  |  71 +++++++
 fio.1                 |  13 +-
 fio.h                 |   2 -
 fio_time.h            |   1 +
 helper_thread.c       | 167 ++++++++++++++++
 helper_thread.h       |  11 ++
 init.c                |  10 +
 io_u.c                |  18 +-
 iolog.c               |  89 +++++++--
 iolog.h               |  10 +-
 libfio.c              |   2 +
 options.c             |   6 +
 os/os-mac.h           |  69 -------
 stat.c                | 152 ++++++++++++---
 stat.h                |   9 +-
 time.c                |   9 +
 tools/fiologparser.py | 152 +++++++++++++++
 workqueue.c           |   5 +-
 25 files changed, 1213 insertions(+), 230 deletions(-)
 create mode 100644 engines/pmemblk.c
 create mode 100644 examples/pmemblk.fio
 create mode 100644 helper_thread.c
 create mode 100644 helper_thread.h
 create mode 100755 tools/fiologparser.py

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 1f523d3..88d10a1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -798,6 +798,9 @@ ioengine=str	Defines how the job issues io to the file. The following
 				overwriting. The writetrim mode works well
 				for this constraint.
 
+			pmemblk	Read and write through the NVML libpmemblk
+				interface.
+
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
 				filename, eg ioengine=external:/tmp/foo.o
@@ -1263,10 +1266,14 @@ exitall_on_error	When one job finishes in error, terminate the rest. The
 		default is to wait for each job to finish.
 
 bwavgtime=int	Average the calculated bandwidth over the given time. Value
-		is specified in milliseconds.
+		is specified in milliseconds. If the job also does bandwidth
+		logging through 'write_bw_log', then the minimum of this option
+		and 'log_avg_msec' will be used.  Default: 500ms.
 
 iopsavgtime=int	Average the calculated IOPS over the given time. Value
-		is specified in milliseconds.
+		is specified in milliseconds. If the job also does IOPS logging
+		through 'write_iops_log', then the minimum of this option and
+		'log_avg_msec' will be used.  Default: 500ms.
 
 create_serialize=bool	If true, serialize the file creating for the jobs.
 			This may be handy to avoid interleaving of data
diff --git a/Makefile b/Makefile
index 007ae40..0133ac4 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,7 @@ OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
-SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio)
+SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py)
 
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3
@@ -45,7 +45,7 @@ SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		workqueue.c rate-submit.c optgroup.c
+		workqueue.c rate-submit.c optgroup.c helper_thread.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
@@ -124,6 +124,9 @@ ifdef CONFIG_MTD
   SOURCE += oslib/libmtd.c
   SOURCE += oslib/libmtd_legacy.c
 endif
+ifdef CONFIG_PMEMBLK
+  SOURCE += engines/pmemblk.c
+endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
diff --git a/backend.c b/backend.c
index 1723b8f..7de6f65 100644
--- a/backend.c
+++ b/backend.c
@@ -57,11 +57,7 @@
 #include "workqueue.h"
 #include "lib/mountcheck.h"
 #include "rate-submit.h"
-
-static pthread_t helper_thread;
-static pthread_mutex_t helper_lock;
-pthread_cond_t helper_cond;
-int helper_do_stat = 0;
+#include "helper_thread.h"
 
 static struct fio_mutex *startup_mutex;
 static struct flist_head *cgroup_list;
@@ -79,7 +75,6 @@ unsigned int stat_number = 0;
 int shm_id = 0;
 int temp_stall_ts;
 unsigned long done_secs = 0;
-volatile int helper_exit = 0;
 
 #define PAGE_ALIGN(buf)	\
 	(char *) (((uintptr_t) (buf) + page_mask) & ~page_mask)
@@ -1722,7 +1717,7 @@ static void *thread_main(void *data)
 
 	fio_unpin_memory(td);
 
-	fio_writeout_logs(td);
+	td_writeout_logs(td, true);
 
 	iolog_compress_exit(td);
 	rate_submit_exit(td);
@@ -2319,82 +2314,10 @@ reap:
 	update_io_ticks();
 }
 
-static void wait_for_helper_thread_exit(void)
-{
-	void *ret;
-
-	helper_exit = 1;
-	pthread_cond_signal(&helper_cond);
-	pthread_join(helper_thread, &ret);
-}
-
 static void free_disk_util(void)
 {
 	disk_util_prune_entries();
-
-	pthread_cond_destroy(&helper_cond);
-}
-
-static void *helper_thread_main(void *data)
-{
-	struct sk_out *sk_out = data;
-	int ret = 0;
-
-	sk_out_assign(sk_out);
-
-	fio_mutex_up(startup_mutex);
-
-	while (!ret) {
-		uint64_t sec = DISK_UTIL_MSEC / 1000;
-		uint64_t nsec = (DISK_UTIL_MSEC % 1000) * 1000000;
-		struct timespec ts;
-		struct timeval tv;
-
-		gettimeofday(&tv, NULL);
-		ts.tv_sec = tv.tv_sec + sec;
-		ts.tv_nsec = (tv.tv_usec * 1000) + nsec;
-
-		if (ts.tv_nsec >= 1000000000ULL) {
-			ts.tv_nsec -= 1000000000ULL;
-			ts.tv_sec++;
-		}
-
-		pthread_cond_timedwait(&helper_cond, &helper_lock, &ts);
-
-		ret = update_io_ticks();
-
-		if (helper_do_stat) {
-			helper_do_stat = 0;
-			__show_running_run_stats();
-		}
-
-		if (!is_backend)
-			print_thread_status();
-	}
-
-	sk_out_drop();
-	return NULL;
-}
-
-static int create_helper_thread(struct sk_out *sk_out)
-{
-	int ret;
-
-	setup_disk_util();
-
-	pthread_cond_init(&helper_cond, NULL);
-	pthread_mutex_init(&helper_lock, NULL);
-
-	ret = pthread_create(&helper_thread, NULL, helper_thread_main, sk_out);
-	if (ret) {
-		log_err("Can't create helper thread: %s\n", strerror(ret));
-		return 1;
-	}
-
-	dprint(FD_MUTEX, "wait on startup_mutex\n");
-	fio_mutex_down(startup_mutex);
-	dprint(FD_MUTEX, "done waiting on startup_mutex\n");
-	return 0;
+	helper_thread_destroy();
 }
 
 int fio_backend(struct sk_out *sk_out)
@@ -2427,14 +2350,14 @@ int fio_backend(struct sk_out *sk_out)
 
 	set_genesis_time();
 	stat_init();
-	create_helper_thread(sk_out);
+	helper_thread_create(startup_mutex, sk_out);
 
 	cgroup_list = smalloc(sizeof(*cgroup_list));
 	INIT_FLIST_HEAD(cgroup_list);
 
 	run_threads(sk_out);
 
-	wait_for_helper_thread_exit();
+	helper_thread_exit();
 
 	if (!fio_abort) {
 		__show_run_stats();
diff --git a/configure b/configure
index 6e2488c..5f6bca3 100755
--- a/configure
+++ b/configure
@@ -135,6 +135,7 @@ show_help="no"
 exit_val=0
 gfio_check="no"
 libhdfs="no"
+pmemblk="no"
 disable_lex=""
 prefix=/usr/local
 
@@ -169,6 +170,8 @@ for opt do
   ;;
   --enable-libhdfs) libhdfs="yes"
   ;;
+  --enable-pmemblk) pmemblk="yes"
+  ;;
   --disable-lex) disable_lex="yes"
   ;;
   --enable-lex) disable_lex="no"
@@ -199,6 +202,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-numa         Disable libnuma even if found"
   echo "--disable-gfapi        Disable gfapi"
   echo "--enable-libhdfs       Enable hdfs support"
+  echo "--enable-pmemblk       Enable NVML libpmemblk support"
   echo "--disable-lex          Disable use of lex/yacc for math"
   echo "--enable-lex           Enable use of lex/yacc for math"
   echo "--disable-shm          Disable SHM support"
@@ -1479,6 +1483,10 @@ if compile_prog "" "" "mtd"; then
 fi
 echo "MTD                           $mtd"
 
+##########################################
+# Report whether pmemblk engine is enabled
+echo "NVML libpmemblk engine        $pmemblk"
+
 # Check if we have lex/yacc available
 yacc="no"
 yacc_is_bison="no"
@@ -1795,6 +1803,9 @@ if test "$libhdfs" = "yes" ; then
 if test "$mtd" = "yes" ; then
   output_sym "CONFIG_MTD"
 fi
+if test "$pmemblk" = "yes" ; then
+  output_sym "CONFIG_PMEMBLK"
+fi
 if test "$arith" = "yes" ; then
   output_sym "CONFIG_ARITHMETIC"
   if test "$yacc_is_bison" = "yes" ; then
diff --git a/diskutil.c b/diskutil.c
index c25c5c9..8031d5d 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -11,6 +11,7 @@
 #include "fio.h"
 #include "smalloc.h"
 #include "diskutil.h"
+#include "helper_thread.h"
 
 static int last_majdev, last_mindev;
 static struct disk_util *last_du;
@@ -121,7 +122,7 @@ int update_io_ticks(void)
 
 	fio_mutex_down(disk_util_mutex);
 
-	if (!helper_exit) {
+	if (!helper_should_exit()) {
 		flist_for_each(entry, &disk_list) {
 			du = flist_entry(entry, struct disk_util, list);
 			update_io_tick_disk(du);
diff --git a/diskutil.h b/diskutil.h
index 25d0beb..ff8a5b0 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -4,8 +4,7 @@
 #define FIO_DU_NAME_SZ		64
 
 #include "lib/output_buffer.h"
-
-extern volatile int helper_exit;
+#include "helper_thread.h"
 
 struct disk_util_stats {
 	uint64_t ios[2];
@@ -129,7 +128,7 @@ static inline void print_disk_util(struct disk_util_stat *du,
 
 static inline int update_io_ticks(void)
 {
-	return helper_exit;
+	return helper_should_exit();
 }
 #endif
 
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
new file mode 100644
index 0000000..ab4b769
--- /dev/null
+++ b/engines/pmemblk.c
@@ -0,0 +1,523 @@
+/*
+ * pmemblk: IO engine that uses NVML libpmemblk to read and write data
+ *
+ * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the Free
+ * Software Foundation, Inc., 59 Temple Place, Suite 330,
+ * Boston, MA 02111-1307 USA
+ */
+
+/*
+ * pmemblk engine
+ *
+ * IO engine that uses libpmemblk to read and write data
+ *
+ * To use:
+ *   ioengine=pmemblk
+ *
+ * Other relevant settings:
+ *   iodepth=1
+ *   direct=1
+ *   thread=1   REQUIRED
+ *   unlink=1
+ *   filename=/pmem0/fiotestfile,BSIZE,FSIZEMB
+ *
+ *   thread must be set to 1 for pmemblk as multiple processes cannot
+ *     open the same block pool file.
+ *
+ *   iodepth should be set to 1 as pmemblk is always synchronous.
+ *   Use numjobs to scale up.
+ *
+ *   direct=1 is implied as pmemblk is always direct.
+ *
+ *   Can set unlink to 1 to remove the block pool file after testing.
+ *
+ *   When specifying the filename, if the block pool file does not already
+ *   exist, then the pmemblk engine can create the pool file if you specify
+ *   the block and file sizes.  BSIZE is the block size in bytes.
+ *   FSIZEMB is the pool file size in MB.
+ *
+ *   See examples/pmemblk.fio for more.
+ *
+ * libpmemblk.so
+ *   By default, the pmemblk engine will let the system find the libpmemblk.so
+ *   that it uses.  You can use an alternative libpmemblk by setting the
+ *   FIO_PMEMBLK_LIB environment variable to the full path to the desired
+ *   libpmemblk.so.
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/uio.h>
+#include <errno.h>
+#include <assert.h>
+#include <dlfcn.h>
+#include <string.h>
+
+#include "../fio.h"
+
+/*
+ * libpmemblk
+ */
+struct PMEMblkpool_s;
+typedef struct PMEMblkpool_s PMEMblkpool;
+
+PMEMblkpool *(*pmemblk_create) (const char *, size_t, size_t, mode_t) = NULL;
+PMEMblkpool *(*pmemblk_open) (const char *, size_t) = NULL;
+void (*pmemblk_close) (PMEMblkpool *) = NULL;
+size_t(*pmemblk_nblock) (PMEMblkpool *) = NULL;
+size_t(*pmemblk_bsize) (PMEMblkpool *) = NULL;
+int (*pmemblk_read) (PMEMblkpool *, void *, off_t) = NULL;
+int (*pmemblk_write) (PMEMblkpool *, const void *, off_t) = NULL;
+
+int load_libpmemblk(const char *path)
+{
+	void *dl;
+
+	if (NULL == path)
+		path = "libpmemblk.so";
+
+	dl = dlopen(path, RTLD_NOW | RTLD_NODELETE);
+	if (NULL == dl)
+		goto errorout;
+
+	if (NULL == (pmemblk_create = dlsym(dl, "pmemblk_create")))
+		goto errorout;
+	if (NULL == (pmemblk_open = dlsym(dl, "pmemblk_open")))
+		goto errorout;
+	if (NULL == (pmemblk_close = dlsym(dl, "pmemblk_close")))
+		goto errorout;
+	if (NULL == (pmemblk_nblock = dlsym(dl, "pmemblk_nblock")))
+		goto errorout;
+	if (NULL == (pmemblk_bsize = dlsym(dl, "pmemblk_bsize")))
+		goto errorout;
+	if (NULL == (pmemblk_read = dlsym(dl, "pmemblk_read")))
+		goto errorout;
+	if (NULL == (pmemblk_write = dlsym(dl, "pmemblk_write")))
+		goto errorout;
+
+	return 0;
+
+errorout:
+	log_err("fio: unable to load libpmemblk: %s\n", dlerror());
+	if (NULL != dl)
+		dlclose(dl);
+
+	return (-1);
+
+}				/* load_libpmemblk() */
+
+typedef struct fio_pmemblk_file *fio_pmemblk_file_t;
+struct fio_pmemblk_file {
+	fio_pmemblk_file_t pmb_next;
+	char *pmb_filename;
+	uint64_t pmb_refcnt;
+	PMEMblkpool *pmb_pool;
+	size_t pmb_bsize;
+	size_t pmb_nblocks;
+};
+#define FIOFILEPMBSET(_f, _v)  do {                 \
+	(_f)->engine_data = (uint64_t)(uintptr_t)(_v);  \
+} while(0)
+#define FIOFILEPMBGET(_f)  ((fio_pmemblk_file_t)((_f)->engine_data))
+
+static fio_pmemblk_file_t Cache = NULL;
+
+static pthread_mutex_t CacheLock = PTHREAD_MUTEX_INITIALIZER;
+
+#define PMB_CREATE   (0x0001)	/* should create file */
+
+fio_pmemblk_file_t fio_pmemblk_cache_lookup(const char *filename)
+{
+	fio_pmemblk_file_t i;
+
+	for (i = Cache; i != NULL; i = i->pmb_next)
+		if (0 == strcmp(filename, i->pmb_filename))
+			return i;
+
+	return NULL;
+
+}				/* fio_pmemblk_cache_lookup() */
+
+static void fio_pmemblk_cache_insert(fio_pmemblk_file_t pmb)
+{
+	pmb->pmb_next = Cache;
+	Cache = pmb;
+
+	return;
+
+}				/* fio_pmemblk_cache_insert() */
+
+static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
+{
+	fio_pmemblk_file_t i;
+
+	if (pmb == Cache) {
+		Cache = Cache->pmb_next;
+		pmb->pmb_next = NULL;
+		return;
+	}
+
+	for (i = Cache; i != NULL; i = i->pmb_next)
+		if (pmb == i->pmb_next) {
+			i->pmb_next = i->pmb_next->pmb_next;
+			pmb->pmb_next = NULL;
+			return;
+		}
+
+	return;
+
+}				/* fio_pmemblk_cache_remove() */
+
+/*
+ * to control block size and gross file size at the libpmemblk
+ * level, we allow the block size and file size to be appended
+ * to the file name:
+ *
+ *   path[,bsize,fsizemb]
+ *
+ * note that we do not use the fio option "filesize" to dictate
+ * the file size because we can only give libpmemblk the gross
+ * file size, which is different from the net or usable file
+ * size (which is probably what fio wants).
+ *
+ * the final path without the parameters is returned in ppath.
+ * the block size and file size are returned in pbsize and fsize.
+ *
+ * note that the user should specify the file size in MiB, but
+ * we return bytes from here.
+ */
+static void
+pmb_parse_path(const char *pathspec,
+	       char **ppath, uint64_t * pbsize, uint64_t * pfsize)
+{
+	char *path;
+	char *s;
+	uint64_t bsize;
+	uint64_t fsizemb;
+
+	path = strdup(pathspec);
+	if (NULL == path) {
+		*ppath = NULL;
+		return;
+	}
+
+	/* extract sizes, if given */
+	s = strrchr(path, ',');
+	if (s && (fsizemb = strtoull(s + 1, NULL, 10))) {
+		*s = 0;
+		s = strrchr(path, ',');
+		if (s && (bsize = strtoull(s + 1, NULL, 10))) {
+			*s = 0;
+			*ppath = path;
+			*pbsize = bsize;
+			*pfsize = fsizemb << 20;
+			return;
+		}
+	}
+
+	/* size specs not found */
+	strcpy(path, pathspec);
+	*ppath = path;
+	*pbsize = 0;
+	*pfsize = 0;
+	return;
+
+}				/* pmb_parse_path() */
+
+static
+ fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
+{
+	fio_pmemblk_file_t pmb;
+	char *path = NULL;
+	uint64_t bsize = 0;
+	uint64_t fsize = 0;
+
+	pmb_parse_path(pathspec, &path, &bsize, &fsize);
+	if (NULL == path)
+		return NULL;
+
+	pthread_mutex_lock(&CacheLock);
+
+	pmb = fio_pmemblk_cache_lookup(path);
+
+	if (NULL == pmb) {
+		/* load libpmemblk if needed */
+		if (NULL == pmemblk_open)
+			if (0 != load_libpmemblk(getenv("FIO_PMEMBLK_LIB")))
+				goto error;
+
+		pmb = malloc(sizeof(*pmb));
+		if (NULL == pmb)
+			goto error;
+
+		/* try opening existing first, create it if needed */
+		pmb->pmb_pool = pmemblk_open(path, bsize);
+		if ((NULL == pmb->pmb_pool) &&
+		    (ENOENT == errno) &&
+		    (flags & PMB_CREATE) && (0 < fsize) && (0 < bsize)) {
+			pmb->pmb_pool =
+			    pmemblk_create(path, bsize, fsize, 0644);
+		}
+		if (NULL == pmb->pmb_pool) {
+			log_err
+			    ("fio: enable to open pmemblk pool file (errno %d)\n",
+			     errno);
+			goto error;
+		}
+
+		pmb->pmb_filename = path;
+		pmb->pmb_next = NULL;
+		pmb->pmb_refcnt = 0;
+		pmb->pmb_bsize = pmemblk_bsize(pmb->pmb_pool);
+		pmb->pmb_nblocks = pmemblk_nblock(pmb->pmb_pool);
+
+		fio_pmemblk_cache_insert(pmb);
+	}
+
+	pmb->pmb_refcnt += 1;
+
+	pthread_mutex_unlock(&CacheLock);
+
+	return pmb;
+
+error:
+	if (NULL != pmb) {
+		if (NULL != pmb->pmb_pool)
+			pmemblk_close(pmb->pmb_pool);
+		pmb->pmb_pool = NULL;
+		pmb->pmb_filename = NULL;
+		free(pmb);
+	}
+	if (NULL != path)
+		free(path);
+
+	pthread_mutex_unlock(&CacheLock);
+	return NULL;
+
+}				/* pmb_open() */
+
+static void pmb_close(fio_pmemblk_file_t pmb, const int keep)
+{
+	pthread_mutex_lock(&CacheLock);
+
+	pmb->pmb_refcnt--;
+
+	if (!keep && (0 == pmb->pmb_refcnt)) {
+		pmemblk_close(pmb->pmb_pool);
+		pmb->pmb_pool = NULL;
+		free(pmb->pmb_filename);
+		pmb->pmb_filename = NULL;
+		fio_pmemblk_cache_remove(pmb);
+		free(pmb);
+	}
+
+	pthread_mutex_unlock(&CacheLock);
+
+}				/* pmb_close() */
+
+static int pmb_get_flags(struct thread_data *td, uint64_t * pflags)
+{
+	static int thread_warned = 0;
+	static int odirect_warned = 0;
+
+	uint64_t flags = 0;
+
+	if (!td->o.use_thread) {
+		if (!thread_warned) {
+			thread_warned = 1;
+			log_err("fio: must set thread=1 for pmemblk engine\n");
+		}
+		return 1;
+	}
+
+	if (!td->o.odirect && !odirect_warned) {
+		odirect_warned = 1;
+		log_info("fio: direct == 0, but pmemblk is always direct\n");
+	}
+
+	if (td->o.allow_create)
+		flags |= PMB_CREATE;
+
+	(*pflags) = flags;
+	return 0;
+
+}				/* pmb_get_flags() */
+
+static int fio_pmemblk_open_file(struct thread_data *td, struct fio_file *f)
+{
+	uint64_t flags = 0;
+	fio_pmemblk_file_t pmb;
+
+	if (0 != pmb_get_flags(td, &flags))
+		return 1;
+
+	pmb = pmb_open(f->file_name, flags);
+	if (NULL == pmb)
+		return 1;
+
+	FIOFILEPMBSET(f, pmb);
+
+	return 0;
+
+}				/* fio_pmemblk_open_file() */
+
+static int
+fio_pmemblk_close_file(struct thread_data fio_unused * td, struct fio_file *f)
+{
+	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+
+	if (pmb)
+		pmb_close(pmb, 0);
+
+	FIOFILEPMBSET(f, NULL);
+
+	return 0;
+
+}				/* fio_pmemblk_close_file() */
+
+static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	uint64_t flags = 0;
+	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	if (NULL == pmb) {
+		if (0 != pmb_get_flags(td, &flags))
+			return 1;
+		pmb = pmb_open(f->file_name, flags);
+		if (NULL == pmb)
+			return 1;
+	}
+
+	f->real_file_size = pmb->pmb_bsize * pmb->pmb_nblocks;
+
+	fio_file_set_size_known(f);
+
+	if (NULL == FIOFILEPMBGET(f))
+		pmb_close(pmb, 1);
+
+	return 0;
+
+}				/* fio_pmemblk_get_file_size() */
+
+static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
+
+	unsigned long long off;
+	unsigned long len;
+	void *buf;
+	int (*blkop) (PMEMblkpool *, void *, off_t) = (void *)pmemblk_write;
+
+	fio_ro_check(td, io_u);
+
+	switch (io_u->ddir) {
+	case DDIR_READ:
+		blkop = pmemblk_read;
+		/* fall through */
+	case DDIR_WRITE:
+		off = io_u->offset;
+		len = io_u->xfer_buflen;
+
+		io_u->error = EINVAL;
+		if (0 != (off % pmb->pmb_bsize))
+			break;
+		if (0 != (len % pmb->pmb_bsize))
+			break;
+		if ((off + len) / pmb->pmb_bsize > pmb->pmb_nblocks)
+			break;
+
+		io_u->error = 0;
+		buf = io_u->xfer_buf;
+		off /= pmb->pmb_bsize;
+		len /= pmb->pmb_bsize;
+		while (0 < len) {
+			if (0 != blkop(pmb->pmb_pool, buf, off)) {
+				io_u->error = errno;
+				break;
+			}
+			buf += pmb->pmb_bsize;
+			off++;
+			len--;
+		}
+		off *= pmb->pmb_bsize;
+		len *= pmb->pmb_bsize;
+		io_u->resid = io_u->xfer_buflen - (off - io_u->offset);
+		break;
+	case DDIR_SYNC:
+	case DDIR_DATASYNC:
+	case DDIR_SYNC_FILE_RANGE:
+		/* we're always sync'd */
+		io_u->error = 0;
+		break;
+	default:
+		io_u->error = EINVAL;
+		break;
+	}
+
+	return FIO_Q_COMPLETED;
+
+}				/* fio_pmemblk_queue() */
+
+static int fio_pmemblk_unlink_file(struct thread_data *td, struct fio_file *f)
+{
+	char *path = NULL;
+	uint64_t bsize = 0;
+	uint64_t fsize = 0;
+
+	/*
+	 * we need our own unlink in case the user has specified
+	 * the block and file sizes in the path name.  we parse
+	 * the file_name to determine the file name we actually used.
+	 */
+
+	pmb_parse_path(f->file_name, &path, &bsize, &fsize);
+	if (NULL == path)
+		return 1;
+
+	unlink(path);
+	free(path);
+
+	return 0;
+
+}				/* fio_pmemblk_unlink_file() */
+
+struct ioengine_ops ioengine = {
+	.name = "pmemblk",
+	.version = FIO_IOOPS_VERSION,
+	.queue = fio_pmemblk_queue,
+	.open_file = fio_pmemblk_open_file,
+	.close_file = fio_pmemblk_close_file,
+	.get_file_size = fio_pmemblk_get_file_size,
+	.unlink_file = fio_pmemblk_unlink_file,
+	.flags = FIO_SYNCIO | FIO_DISKLESSIO | FIO_NOEXTEND | FIO_NODISKUTIL,
+};
+
+static void
+fio_init fio_pmemblk_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void
+fio_exit fio_pmemblk_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/pmemblk.fio b/examples/pmemblk.fio
new file mode 100644
index 0000000..2d5ecfc
--- /dev/null
+++ b/examples/pmemblk.fio
@@ -0,0 +1,71 @@
+[global]
+bs=1m
+ioengine=pmemblk
+norandommap
+time_based=1
+runtime=30
+group_reporting
+disable_lat=1
+disable_slat=1
+disable_clat=1
+clat_percentiles=0
+cpus_allowed_policy=split
+
+# For the pmemblk engine:
+#
+#   IOs always complete immediately
+#   IOs are always direct
+#   Must use threads
+#
+iodepth=1
+direct=1
+thread=1
+numjobs=16
+#
+# Unlink can be used to remove the files when done, but if you are
+# using serial runs with stonewall, and you want the files to be created
+# only once and unlinked only at the very end, then put the unlink=1
+# in the last group.  This is the method demonstrated here.
+#
+# Note that if you have a read-only group and if the files will be
+# newly created, then all of the data will read back as zero and the
+# read will be optimized, yielding performance that is different from
+# that of reading non-zero blocks (or unoptimized zero blocks).
+#
+unlink=0
+#
+# The pmemblk engine does IO to files in a DAX-mounted filesystem.
+# The filesystem should be created on an NVDIMM (e.g /dev/pmem0)
+# and then mounted with the '-o dax' option.  Note that the engine
+# accesses the underlying NVDIMM directly, bypassing the kernel block
+# layer, so the usual filesystem/disk performance monitoring tools such
+# as iostat will not provide useful data.
+#
+# Here we specify a test file on each of two NVDIMMs.  The first
+# number after the file name is the block size in bytes (4096 bytes
+# in this example).  The second number is the size of the file to
+# create in MiB (1 GiB in this example); note that the actual usable
+# space available to fio will be less than this as libpmemblk requires
+# some space for metadata.
+#
+# Currently, the minimum block size is 512 bytes and the minimum file
+# size is about 17 MiB (these are libpmemblk requirements).
+#
+# While both files in this example have the same block size and file
+# size, this is not required.
+#
+filename=/pmem0/fio-test,4096,1024
+filename=/pmem1/fio-test,4096,1024
+
+[pmemblk-write]
+rw=randwrite
+stonewall
+
+[pmemblk-read]
+rw=randread
+stonewall
+#
+# We're done, so unlink the file:
+#
+unlink=1
+
diff --git a/fio.1 b/fio.1
index 73fdee6..ebb4899 100644
--- a/fio.1
+++ b/fio.1
@@ -700,6 +700,9 @@ treated as erases. Depending on the underlying device type, the I/O may have
 to go in a certain pattern, e.g., on NAND, writing sequentially to erase blocks
 and discarding before overwriting. The writetrim mode works well for this
 constraint.
+.TP
+.B pmemblk
+Read and write through the NVML libpmemblk interface.
 .RE
 .P
 .RE
@@ -1180,12 +1183,14 @@ Terminate all jobs if one job finishes in error.  Default: wait for each job
 to finish.
 .TP
 .BI bwavgtime \fR=\fPint
-Average bandwidth calculations over the given time in milliseconds.  Default:
-500ms.
+Average bandwidth calculations over the given time in milliseconds. If the job
+also does bandwidth logging through \fBwrite_bw_log\fR, then the minimum of
+this option and \fBlog_avg_msec\fR will be used.  Default: 500ms.
 .TP
 .BI iopsavgtime \fR=\fPint
-Average IOPS calculations over the given time in milliseconds.  Default:
-500ms.
+Average IOPS calculations over the given time in milliseconds. If the job
+also does IOPS logging through \fBwrite_iops_log\fR, then the minimum of
+this option and \fBlog_avg_msec\fR will be used.  Default: 500ms.
 .TP
 .BI create_serialize \fR=\fPbool
 If true, serialize file creation for the jobs.  Default: true.
diff --git a/fio.h b/fio.h
index 829cc81..6a244c3 100644
--- a/fio.h
+++ b/fio.h
@@ -445,8 +445,6 @@ extern int nr_clients;
 extern int log_syslog;
 extern int status_interval;
 extern const char fio_version_string[];
-extern int helper_do_stat;
-extern pthread_cond_t helper_cond;
 extern char *trigger_file;
 extern char *trigger_cmd;
 extern char *trigger_remote_cmd;
diff --git a/fio_time.h b/fio_time.h
index 79f324a..cb271c2 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -17,5 +17,6 @@ extern void set_genesis_time(void);
 extern int ramp_time_over(struct thread_data *);
 extern int in_ramp_time(struct thread_data *);
 extern void fio_time_init(void);
+extern void timeval_add_msec(struct timeval *, unsigned int);
 
 #endif
diff --git a/helper_thread.c b/helper_thread.c
new file mode 100644
index 0000000..1befabf
--- /dev/null
+++ b/helper_thread.c
@@ -0,0 +1,167 @@
+#include "fio.h"
+#include "smalloc.h"
+#include "helper_thread.h"
+
+static struct helper_data {
+	volatile int exit;
+	volatile int reset;
+	volatile int do_stat;
+	struct sk_out *sk_out;
+	pthread_t thread;
+	pthread_mutex_t lock;
+	pthread_cond_t cond;
+	struct fio_mutex *startup_mutex;
+} *helper_data;
+
+void helper_thread_destroy(void)
+{
+	pthread_cond_destroy(&helper_data->cond);
+	pthread_mutex_destroy(&helper_data->lock);
+	sfree(helper_data);
+}
+
+void helper_reset(void)
+{
+	if (!helper_data)
+		return;
+
+	pthread_mutex_lock(&helper_data->lock);
+
+	if (!helper_data->reset) {
+		helper_data->reset = 1;
+		pthread_cond_signal(&helper_data->cond);
+	}
+
+	pthread_mutex_unlock(&helper_data->lock);
+}
+
+void helper_do_stat(void)
+{
+	if (!helper_data)
+		return;
+
+	pthread_mutex_lock(&helper_data->lock);
+	helper_data->do_stat = 1;
+	pthread_cond_signal(&helper_data->cond);
+	pthread_mutex_unlock(&helper_data->lock);
+}
+
+bool helper_should_exit(void)
+{
+	if (!helper_data)
+		return true;
+
+	return helper_data->exit;
+}
+
+void helper_thread_exit(void)
+{
+	void *ret;
+
+	pthread_mutex_lock(&helper_data->lock);
+	helper_data->exit = 1;
+	pthread_cond_signal(&helper_data->cond);
+	pthread_mutex_unlock(&helper_data->lock);
+
+	pthread_join(helper_data->thread, &ret);
+}
+
+static void *helper_thread_main(void *data)
+{
+	struct helper_data *hd = data;
+	unsigned int msec_to_next_event, next_log;
+	struct timeval tv, last_du;
+	int ret = 0;
+
+	sk_out_assign(hd->sk_out);
+
+	gettimeofday(&tv, NULL);
+	memcpy(&last_du, &tv, sizeof(tv));
+
+	fio_mutex_up(hd->startup_mutex);
+
+	msec_to_next_event = DISK_UTIL_MSEC;
+	while (!ret && !hd->exit) {
+		struct timespec ts;
+		struct timeval now;
+		uint64_t since_du;
+
+		timeval_add_msec(&tv, msec_to_next_event);
+		ts.tv_sec = tv.tv_sec;
+		ts.tv_nsec = tv.tv_usec * 1000;
+
+		pthread_mutex_lock(&hd->lock);
+		pthread_cond_timedwait(&hd->cond, &hd->lock, &ts);
+
+		gettimeofday(&now, NULL);
+
+		if (hd->reset) {
+			memcpy(&tv, &now, sizeof(tv));
+			memcpy(&last_du, &now, sizeof(last_du));
+			hd->reset = 0;
+		}
+
+		pthread_mutex_unlock(&hd->lock);
+
+		since_du = mtime_since(&last_du, &now);
+		if (since_du >= DISK_UTIL_MSEC || DISK_UTIL_MSEC - since_du < 10) {
+			ret = update_io_ticks();
+			timeval_add_msec(&last_du, DISK_UTIL_MSEC);
+			msec_to_next_event = DISK_UTIL_MSEC;
+			if (since_du >= DISK_UTIL_MSEC)
+				msec_to_next_event -= (since_du - DISK_UTIL_MSEC);
+		} else {
+			if (since_du >= DISK_UTIL_MSEC)
+				msec_to_next_event = DISK_UTIL_MSEC - (DISK_UTIL_MSEC - since_du);
+			else
+				msec_to_next_event = DISK_UTIL_MSEC;
+		}
+
+		if (hd->do_stat) {
+			hd->do_stat = 0;
+			__show_running_run_stats();
+		}
+
+		next_log = calc_log_samples();
+		if (!next_log)
+			next_log = DISK_UTIL_MSEC;
+
+		msec_to_next_event = min(next_log, msec_to_next_event);
+
+		if (!is_backend)
+			print_thread_status();
+	}
+
+	fio_writeout_logs(false);
+
+	sk_out_drop();
+	return NULL;
+}
+
+int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
+{
+	struct helper_data *hd;
+	int ret;
+
+	hd = smalloc(sizeof(*hd));
+
+	setup_disk_util();
+
+	hd->sk_out = sk_out;
+	pthread_cond_init(&hd->cond, NULL);
+	pthread_mutex_init(&hd->lock, NULL);
+	hd->startup_mutex = startup_mutex;
+
+	ret = pthread_create(&hd->thread, NULL, helper_thread_main, hd);
+	if (ret) {
+		log_err("Can't create helper thread: %s\n", strerror(ret));
+		return 1;
+	}
+
+	helper_data = hd;
+
+	dprint(FD_MUTEX, "wait on startup_mutex\n");
+	fio_mutex_down(startup_mutex);
+	dprint(FD_MUTEX, "done waiting on startup_mutex\n");
+	return 0;
+}
diff --git a/helper_thread.h b/helper_thread.h
new file mode 100644
index 0000000..78933b1
--- /dev/null
+++ b/helper_thread.h
@@ -0,0 +1,11 @@
+#ifndef FIO_HELPER_THREAD_H
+#define FIO_HELPER_THREAD_H
+
+extern void helper_reset(void);
+extern void helper_do_stat(void);
+extern bool helper_should_exit(void);
+extern void helper_thread_destroy(void);
+extern void helper_thread_exit(void);
+extern int helper_thread_create(struct fio_mutex *, struct sk_out *);
+
+#endif
diff --git a/init.c b/init.c
index 89e05c0..c579d5c 100644
--- a/init.c
+++ b/init.c
@@ -1416,6 +1416,11 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		};
 		const char *suf;
 
+		if (fio_option_is_set(o, bw_avg_time))
+			p.avg_msec = min(o->log_avg_msec, o->bw_avg_time);
+		else
+			o->bw_avg_time = p.avg_msec;
+
 		if (p.log_gz_store)
 			suf = "log.fz";
 		else
@@ -1436,6 +1441,11 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		};
 		const char *suf;
 
+		if (fio_option_is_set(o, iops_avg_time))
+			p.avg_msec = min(o->log_avg_msec, o->iops_avg_time);
+		else
+			o->iops_avg_time = p.avg_msec;
+
 		if (p.log_gz_store)
 			suf = "log.fz";
 		else
diff --git a/io_u.c b/io_u.c
index 6622bc0..eb15dc2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1710,16 +1710,18 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		}
 	}
 
-	if (!td->o.disable_clat) {
-		add_clat_sample(td, idx, lusec, bytes, io_u->offset);
-		io_u_mark_latency(td, lusec);
-	}
+	if (ddir_rw(idx)) {
+		if (!td->o.disable_clat) {
+			add_clat_sample(td, idx, lusec, bytes, io_u->offset);
+			io_u_mark_latency(td, lusec);
+		}
 
-	if (!td->o.disable_bw)
-		add_bw_sample(td, idx, bytes, &icd->time);
+		if (!td->o.disable_bw && per_unit_log(td->bw_log))
+			add_bw_sample(td, io_u, bytes, lusec);
 
-	if (no_reduce)
-		add_iops_sample(td, idx, bytes, &icd->time);
+		if (no_reduce && per_unit_log(td->iops_log))
+			add_iops_sample(td, io_u, bytes);
+	}
 
 	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM) {
 		uint32_t *info = io_u_block_info(td, io_u);
diff --git a/iolog.c b/iolog.c
index 94d3f3c..71afe86 100644
--- a/iolog.c
+++ b/iolog.c
@@ -18,6 +18,7 @@
 #include "verify.h"
 #include "trim.h"
 #include "filelock.h"
+#include "smalloc.h"
 
 static const char iolog_ver2[] = "fio version 2 iolog";
 
@@ -574,14 +575,12 @@ void setup_log(struct io_log **log, struct log_params *p,
 {
 	struct io_log *l;
 
-	l = calloc(1, sizeof(*l));
+	l = smalloc(sizeof(*l));
 	l->nr_samples = 0;
-	l->max_samples = DEF_LOG_ENTRIES;
 	l->log_type = p->log_type;
 	l->log_offset = p->log_offset;
 	l->log_gz = p->log_gz;
 	l->log_gz_store = p->log_gz_store;
-	l->log = malloc(l->max_samples * log_entry_sz(l));
 	l->avg_msec = p->avg_msec;
 	l->filename = strdup(filename);
 	l->td = p->td;
@@ -631,7 +630,7 @@ void free_log(struct io_log *log)
 {
 	free(log->log);
 	free(log->filename);
-	free(log);
+	sfree(log);
 }
 
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
@@ -1202,29 +1201,74 @@ static int __write_log(struct thread_data *td, struct io_log *log, int try)
 	return 0;
 }
 
-static int write_iops_log(struct thread_data *td, int try)
+static int write_iops_log(struct thread_data *td, int try, bool unit_log)
 {
-	return __write_log(td, td->iops_log, try);
+	int ret;
+
+	if (per_unit_log(td->iops_log) != unit_log)
+		return 0;
+
+	ret = __write_log(td, td->iops_log, try);
+	if (!ret)
+		td->iops_log = NULL;
+
+	return ret;
 }
 
-static int write_slat_log(struct thread_data *td, int try)
+static int write_slat_log(struct thread_data *td, int try, bool unit_log)
 {
-	return __write_log(td, td->slat_log, try);
+	int ret;
+
+	if (!unit_log)
+		return 0;
+
+	ret = __write_log(td, td->slat_log, try);
+	if (!ret)
+		td->slat_log = NULL;
+
+	return ret;
 }
 
-static int write_clat_log(struct thread_data *td, int try)
+static int write_clat_log(struct thread_data *td, int try, bool unit_log)
 {
-	return __write_log(td, td->clat_log, try);
+	int ret;
+
+	if (!unit_log)
+		return 0;
+
+	ret = __write_log(td, td->clat_log, try);
+	if (!ret)
+		td->clat_log = NULL;
+
+	return ret;
 }
 
-static int write_lat_log(struct thread_data *td, int try)
+static int write_lat_log(struct thread_data *td, int try, bool unit_log)
 {
-	return __write_log(td, td->lat_log, try);
+	int ret;
+
+	if (!unit_log)
+		return 0;
+
+	ret = __write_log(td, td->lat_log, try);
+	if (!ret)
+		td->lat_log = NULL;
+
+	return ret;
 }
 
-static int write_bandw_log(struct thread_data *td, int try)
+static int write_bandw_log(struct thread_data *td, int try, bool unit_log)
 {
-	return __write_log(td, td->bw_log, try);
+	int ret;
+
+	if (per_unit_log(td->bw_log) != unit_log)
+		return 0;
+
+	ret = __write_log(td, td->bw_log, try);
+	if (!ret)
+		td->bw_log = NULL;
+
+	return ret;
 }
 
 enum {
@@ -1239,7 +1283,7 @@ enum {
 
 struct log_type {
 	unsigned int mask;
-	int (*fn)(struct thread_data *, int);
+	int (*fn)(struct thread_data *, int, bool);
 };
 
 static struct log_type log_types[] = {
@@ -1265,7 +1309,7 @@ static struct log_type log_types[] = {
 	},
 };
 
-void fio_writeout_logs(struct thread_data *td)
+void td_writeout_logs(struct thread_data *td, bool unit_logs)
 {
 	unsigned int log_mask = 0;
 	unsigned int log_left = ALL_LOG_NR;
@@ -1273,7 +1317,7 @@ void fio_writeout_logs(struct thread_data *td)
 
 	old_state = td_bump_runstate(td, TD_FINISHING);
 
-	finalize_logs(td);
+	finalize_logs(td, unit_logs);
 
 	while (log_left) {
 		int prev_log_left = log_left;
@@ -1283,7 +1327,7 @@ void fio_writeout_logs(struct thread_data *td)
 			int ret;
 
 			if (!(log_mask & lt->mask)) {
-				ret = lt->fn(td, log_left != 1);
+				ret = lt->fn(td, log_left != 1, unit_logs);
 				if (!ret) {
 					log_left--;
 					log_mask |= lt->mask;
@@ -1297,3 +1341,12 @@ void fio_writeout_logs(struct thread_data *td)
 
 	td_restore_runstate(td, old_state);
 }
+
+void fio_writeout_logs(bool unit_logs)
+{
+	struct thread_data *td;
+	int i;
+
+	for_each_td(td, i)
+		td_writeout_logs(td, unit_logs);
+}
diff --git a/iolog.h b/iolog.h
index 74f2170..739a7c8 100644
--- a/iolog.h
+++ b/iolog.h
@@ -207,12 +207,18 @@ struct log_params {
 	int log_compress;
 };
 
-extern void finalize_logs(struct thread_data *td);
+static inline bool per_unit_log(struct io_log *log)
+{
+	return log && !log->avg_msec;
+}
+
+extern void finalize_logs(struct thread_data *td, bool);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
 extern void flush_log(struct io_log *, int);
 extern void flush_samples(FILE *, void *, uint64_t);
 extern void free_log(struct io_log *);
-extern void fio_writeout_logs(struct thread_data *);
+extern void fio_writeout_logs(bool);
+extern void td_writeout_logs(struct thread_data *, bool);
 extern int iolog_flush(struct io_log *, int);
 
 static inline void init_ipo(struct io_piece *ipo)
diff --git a/libfio.c b/libfio.c
index b17f148..55762d7 100644
--- a/libfio.c
+++ b/libfio.c
@@ -33,6 +33,7 @@
 #include "smalloc.h"
 #include "os/os.h"
 #include "filelock.h"
+#include "helper_thread.h"
 
 /*
  * Just expose an empty list, if the OS does not support disk util stats
@@ -151,6 +152,7 @@ void reset_all_stats(struct thread_data *td)
 
 	lat_target_reset(td);
 	clear_rusage_stat(td);
+	helper_reset();
 }
 
 void reset_fio_state(void)
diff --git a/options.c b/options.c
index b6c980e..980b7e5 100644
--- a/options.c
+++ b/options.c
@@ -1569,6 +1569,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Hadoop Distributed Filesystem (HDFS) engine"
 			  },
 #endif
+#ifdef CONFIG_PMEMBLK
+			  { .ival = "pmemblk",
+			    .help = "NVML libpmemblk based IO engine",
+			  },
+
+#endif
 			  { .ival = "external",
 			    .help = "Load external engine (append name)",
 			  },
diff --git a/os/os-mac.h b/os/os-mac.h
index d202e99..76d388e 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -35,76 +35,7 @@
 
 typedef off_t off64_t;
 
-/* OS X as of 10.6 doesn't have the timer_* functions. 
- * Emulate the functionality using setitimer and sigaction here
- */
-
-#define MAX_TIMERS 64
-
 typedef unsigned int clockid_t;
-typedef unsigned int timer_t;
-
-struct itimerspec {
-	struct timespec it_value;
-	struct timespec it_interval;
-};
-
-static struct sigevent fio_timers[MAX_TIMERS];
-static unsigned int num_timers = 0;
-
-static void sig_alrm(int signum)
-{
-	union sigval sv;
-	
-	for (int i = 0; i < num_timers; i++) {
-		if (fio_timers[i].sigev_notify_function == NULL)
-			continue;
-		
-		if (fio_timers[i].sigev_notify == SIGEV_THREAD)
-			fio_timers[i].sigev_notify_function(sv);
-		else if (fio_timers[i].sigev_notify == SIGEV_SIGNAL)
-			kill(getpid(), fio_timers[i].sigev_signo);
-	}
-}
-
-static inline int timer_settime(timer_t timerid, int flags,
-				const struct itimerspec *value,
-				struct itimerspec *ovalue)
-{
-	struct sigaction sa;
-	struct itimerval tv;
-	struct itimerval tv_out;
-	int rc;
-	
-	tv.it_interval.tv_sec = value->it_interval.tv_sec;
-	tv.it_interval.tv_usec = value->it_interval.tv_nsec / 1000;
-
-	tv.it_value.tv_sec = value->it_value.tv_sec;
-	tv.it_value.tv_usec = value->it_value.tv_nsec / 1000;
-
-	sa.sa_handler = sig_alrm;
-	sigemptyset(&sa.sa_mask);
-	sa.sa_flags = 0;
-	
-	rc = sigaction(SIGALRM, &sa, NULL);
-
-	if (!rc)
-		rc = setitimer(ITIMER_REAL, &tv, &tv_out);
-	
-	if (!rc && ovalue != NULL) {
-		ovalue->it_interval.tv_sec = tv_out.it_interval.tv_sec;
-		ovalue->it_interval.tv_nsec = tv_out.it_interval.tv_usec * 1000;
-		ovalue->it_value.tv_sec = tv_out.it_value.tv_sec;
-		ovalue->it_value.tv_nsec = tv_out.it_value.tv_usec * 1000;
-	}
-
-	return rc;
-}
-
-static inline int timer_delete(timer_t timer)
-{
-	return 0;
-}
 
 #define FIO_OS_DIRECTIO
 static inline int fio_set_odirect(int fd)
diff --git a/stat.c b/stat.c
index 6d8d4d0..95f206e 100644
--- a/stat.c
+++ b/stat.c
@@ -15,6 +15,7 @@
 #include "idletime.h"
 #include "lib/pow2.h"
 #include "lib/output_buffer.h"
+#include "helper_thread.h"
 
 struct fio_mutex *stat_mutex;
 
@@ -1862,13 +1863,21 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 		iolog->avg_last = t;
 
 	if (iolog->nr_samples == iolog->max_samples) {
-		size_t new_size;
+		size_t new_size, new_samples;
 		void *new_log;
 
-		new_size = 2 * iolog->max_samples * log_entry_sz(iolog);
+		if (!iolog->max_samples)
+			new_samples = DEF_LOG_ENTRIES;
+		else
+			new_samples = iolog->max_samples * 2;
+
+		new_size = new_samples * log_entry_sz(iolog);
 
 		if (iolog->log_gz && (new_size > iolog->log_gz)) {
-			if (iolog_flush(iolog, 0)) {
+			if (!iolog->log) {
+				iolog->log = malloc(new_size);
+				iolog->max_samples = new_samples;
+			} else if (iolog_flush(iolog, 0)) {
 				log_err("fio: failed flushing iolog! Will stop logging.\n");
 				iolog->disabled = 1;
 				return;
@@ -1882,7 +1891,7 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 				return;
 			}
 			iolog->log = new_log;
-			iolog->max_samples <<= 1;
+			iolog->max_samples = new_samples;
 		}
 	}
 
@@ -2013,21 +2022,21 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 	iolog->avg_last = elapsed;
 }
 
-void finalize_logs(struct thread_data *td)
+void finalize_logs(struct thread_data *td, bool unit_logs)
 {
 	unsigned long elapsed;
 
 	elapsed = mtime_since_now(&td->epoch);
 
-	if (td->clat_log)
+	if (td->clat_log && unit_logs)
 		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
-	if (td->slat_log)
+	if (td->slat_log && unit_logs)
 		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
-	if (td->lat_log)
+	if (td->lat_log && unit_logs)
 		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
-	if (td->bw_log)
+	if (td->bw_log && (unit_logs == per_unit_log(td->bw_log)))
 		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
-	if (td->iops_log)
+	if (td->iops_log && (unit_logs == per_unit_log(td->iops_log)))
 		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
 }
 
@@ -2056,9 +2065,6 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 {
 	struct thread_stat *ts = &td->ts;
 
-	if (!ddir_rw(ddir))
-		return;
-
 	td_io_u_lock(td);
 
 	add_stat_sample(&ts->clat_stat[ddir], usec);
@@ -2108,18 +2114,41 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 	td_io_u_unlock(td);
 }
 
-void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
-		   struct timeval *t)
+void add_bw_sample(struct thread_data *td, struct io_u *io_u,
+		   unsigned int bytes, unsigned long spent)
+{
+	struct thread_stat *ts = &td->ts;
+	unsigned long rate;
+
+	if (spent)
+		rate = bytes * 1000 / spent;
+	else
+		rate = 0;
+
+	td_io_u_lock(td);
+
+	add_stat_sample(&ts->bw_stat[io_u->ddir], rate);
+
+	if (td->bw_log)
+		add_log_sample(td, td->bw_log, rate, io_u->ddir, bytes, io_u->offset);
+
+	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
+	td_io_u_unlock(td);
+}
+
+static int add_bw_samples(struct thread_data *td, struct timeval *t)
 {
 	struct thread_stat *ts = &td->ts;
 	unsigned long spent, rate;
+	enum fio_ddir ddir;
 
-	if (!ddir_rw(ddir))
-		return;
+	if (per_unit_log(td->bw_log))
+		return 0;
 
 	spent = mtime_since(&td->bw_sample_time, t);
-	if (spent < td->o.bw_avg_time)
-		return;
+	if (spent < td->o.bw_avg_time &&
+	    td->o.bw_avg_time - spent >= 10)
+		return td->o.bw_avg_time - spent;
 
 	td_io_u_lock(td);
 
@@ -2141,27 +2170,50 @@ void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
 		add_stat_sample(&ts->bw_stat[ddir], rate);
 
 		if (td->bw_log)
-			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			add_log_sample(td, td->bw_log, rate, ddir, 0, 0);
 
 		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
 	}
 
-	fio_gettime(&td->bw_sample_time, NULL);
+	timeval_add_msec(&td->bw_sample_time, td->o.bw_avg_time);
+
+	td_io_u_unlock(td);
+
+	if (spent <= td->o.bw_avg_time)
+		return td->o.bw_avg_time;
+
+	return td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
+}
+
+void add_iops_sample(struct thread_data *td, struct io_u *io_u,
+		     unsigned int bytes)
+{
+	struct thread_stat *ts = &td->ts;
+
+	td_io_u_lock(td);
+
+	add_stat_sample(&ts->iops_stat[io_u->ddir], 1);
+
+	if (td->iops_log)
+		add_log_sample(td, td->iops_log, 1, io_u->ddir, bytes, io_u->offset);
+
+	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
 	td_io_u_unlock(td);
 }
 
-void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
-		     struct timeval *t)
+static int add_iops_samples(struct thread_data *td, struct timeval *t)
 {
 	struct thread_stat *ts = &td->ts;
 	unsigned long spent, iops;
+	enum fio_ddir ddir;
 
-	if (!ddir_rw(ddir))
-		return;
+	if (per_unit_log(td->iops_log))
+		return 0;
 
 	spent = mtime_since(&td->iops_sample_time, t);
-	if (spent < td->o.iops_avg_time)
-		return;
+	if (spent < td->o.iops_avg_time &&
+	    td->o.iops_avg_time - spent >= 10)
+		return td->o.iops_avg_time - spent;
 
 	td_io_u_lock(td);
 
@@ -2183,13 +2235,52 @@ void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs
 		add_stat_sample(&ts->iops_stat[ddir], iops);
 
 		if (td->iops_log)
-			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			add_log_sample(td, td->iops_log, iops, ddir, 0, 0);
 
 		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
 	}
 
-	fio_gettime(&td->iops_sample_time, NULL);
+	timeval_add_msec(&td->iops_sample_time, td->o.iops_avg_time);
+
 	td_io_u_unlock(td);
+
+	if (spent <= td->o.iops_avg_time)
+		return td->o.iops_avg_time;
+
+	return td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
+}
+
+/*
+ * Returns msecs to next event
+ */
+int calc_log_samples(void)
+{
+	struct thread_data *td;
+	unsigned int next = ~0U, tmp;
+	struct timeval now;
+	int i;
+
+	fio_gettime(&now, NULL);
+
+	for_each_td(td, i) {
+		if (!ramp_time_over(td) ||
+		    !(td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING)) {
+			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
+			continue;
+		}
+		if (!per_unit_log(td->bw_log)) {
+			tmp = add_bw_samples(td, &now);
+			if (tmp < next)
+				next = tmp;
+		}
+		if (!per_unit_log(td->iops_log)) {
+			tmp = add_iops_samples(td, &now);
+			if (tmp < next)
+				next = tmp;
+		}
+	}
+
+	return next == ~0U ? 0 : next;
 }
 
 void stat_init(void)
@@ -2212,8 +2303,7 @@ void stat_exit(void)
  */
 void show_running_run_stats(void)
 {
-	helper_do_stat = 1;
-	pthread_cond_signal(&helper_cond);
+	helper_do_stat();
 }
 
 uint32_t *io_u_block_info(struct thread_data *td, struct io_u *io_u)
diff --git a/stat.h b/stat.h
index 9c3f192..86f1a0b 100644
--- a/stat.h
+++ b/stat.h
@@ -276,11 +276,12 @@ extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long,
 				unsigned int, uint64_t);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
 				unsigned int, uint64_t);
-extern void add_bw_sample(struct thread_data *, enum fio_ddir, unsigned int,
-				struct timeval *);
-extern void add_iops_sample(struct thread_data *, enum fio_ddir, unsigned int,
-				struct timeval *);
 extern void add_agg_sample(unsigned long, enum fio_ddir, unsigned int);
+extern void add_iops_sample(struct thread_data *, struct io_u *,
+				unsigned int);
+extern void add_bw_sample(struct thread_data *, struct io_u *,
+				unsigned int, unsigned long);
+extern int calc_log_samples(void);
 
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern int write_bw_log;
diff --git a/time.c b/time.c
index b145e90..0e64af5 100644
--- a/time.c
+++ b/time.c
@@ -6,6 +6,15 @@
 static struct timeval genesis;
 static unsigned long ns_granularity;
 
+void timeval_add_msec(struct timeval *tv, unsigned int msec)
+{
+	tv->tv_usec += 1000 * msec;
+	if (tv->tv_usec >= 1000000) {
+		tv->tv_usec -= 1000000;
+		tv->tv_sec++;
+	}
+}
+
 /*
  * busy looping version for the last few usec
  */
diff --git a/tools/fiologparser.py b/tools/fiologparser.py
new file mode 100755
index 0000000..0574099
--- /dev/null
+++ b/tools/fiologparser.py
@@ -0,0 +1,152 @@
+#!/usr/bin/python
+#
+# fiologparser.py
+#
+# This tool lets you parse multiple fio log files and look at interaval
+# statistics even when samples are non-uniform.  For instance:
+#
+# fiologparser.py -s *bw*
+#
+# to see per-interval sums for all bandwidth logs or:
+#
+# fiologparser.py -a *clat*
+#
+# to see per-interval average completion latency.
+
+import argparse
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-i', '--interval', required=False, type=int, default=1000, help='interval of time in seconds.')
+    parser.add_argument('-d', '--divisor', required=False, type=int, default=1, help='divide the results by this value.')
+    parser.add_argument('-f', '--full', dest='full', action='store_true', default=False, help='print full output.')
+    parser.add_argument('-a', '--average', dest='average', action='store_true', default=False, help='print the average for each interval.')
+    parser.add_argument('-s', '--sum', dest='sum', action='store_true', default=False, help='print the sum for each interval.')
+    parser.add_argument("FILE", help="collectl log output files to parse", nargs="+")
+    args = parser.parse_args()
+
+    return args
+
+def get_ftime(series):
+    ftime = 0
+    for ts in series:
+        if ftime == 0 or ts.last.end < ftime:
+            ftime = ts.last.end
+    return ftime
+
+def print_full(ctx, series):
+    ftime = get_ftime(series)
+    start = 0 
+    end = ctx.interval
+
+    while (start < ftime):
+        end = ftime if ftime < end else end
+        results = [ts.get_value(start, end) for ts in series]
+        print "%s, %s" % (end, ', '.join(["%0.3f" % i for i in results]))
+        start += ctx.interval
+        end += ctx.interval
+
+def print_sums(ctx, series):
+    ftime = get_ftime(series)
+    start = 0
+    end = ctx.interval
+
+    while (start < ftime):
+        end = ftime if ftime < end else end
+        results = [ts.get_value(start, end) for ts in series]
+        print "%s, %0.3f" % (end, sum(results))
+        start += ctx.interval
+        end += ctx.interval
+
+def print_averages(ctx, series):
+    ftime = get_ftime(series)
+    start = 0
+    end = ctx.interval
+
+    while (start < ftime):
+        end = ftime if ftime < end else end
+        results = [ts.get_value(start, end) for ts in series]
+        print "%s, %0.3f" % (end, float(sum(results))/len(results))
+        start += ctx.interval
+        end += ctx.interval
+
+
+def print_default(ctx, series):
+    ftime = get_ftime(series)
+    start = 0
+    end = ctx.interval
+    averages = []
+    weights = []
+
+    while (start < ftime):
+        end = ftime if ftime < end else end
+        results = [ts.get_value(start, end) for ts in series]
+        averages.append(sum(results)) 
+        weights.append(end-start)
+        start += ctx.interval
+        end += ctx.interval
+
+    total = 0
+    for i in xrange(0, len(averages)):
+        total += averages[i]*weights[i]
+    print '%0.3f' % (total/sum(weights))
+ 
+class TimeSeries():
+    def __init__(self, ctx, fn):
+        self.ctx = ctx
+        self.last = None 
+        self.samples = []
+        self.read_data(fn)
+
+    def read_data(self, fn):
+        f = open(fn, 'r')
+        p_time = 0
+        for line in f:
+            (time, value, foo, bar) = line.rstrip('\r\n').rsplit(', ')
+            self.add_sample(p_time, int(time), int(value))
+            p_time = int(time)
+ 
+    def add_sample(self, start, end, value):
+        sample = Sample(ctx, start, end, value)
+        if not self.last or self.last.end < end:
+            self.last = sample
+        self.samples.append(sample)
+
+    def get_value(self, start, end):
+        value = 0
+        for sample in self.samples:
+            value += sample.get_contribution(start, end)
+        return value
+
+class Sample():
+    def __init__(self, ctx, start, end, value):
+       self.ctx = ctx
+       self.start = start
+       self.end = end
+       self.value = value
+
+    def get_contribution(self, start, end):
+       # short circuit if not within the bound
+       if (end < self.start or start > self.end):
+           return 0 
+
+       sbound = self.start if start < self.start else start
+       ebound = self.end if end > self.end else end
+       ratio = float(ebound-sbound) / (end-start) 
+       return self.value*ratio/ctx.divisor
+
+
+if __name__ == '__main__':
+    ctx = parse_args()
+    series = []
+    for fn in ctx.FILE:
+       series.append(TimeSeries(ctx, fn)) 
+    if ctx.sum:
+        print_sums(ctx, series)
+    elif ctx.average:
+        print_averages(ctx, series)
+    elif ctx.full:
+        print_full(ctx, series)
+    else:
+        print_default(ctx, series)
+
diff --git a/workqueue.c b/workqueue.c
index 6e67f3e..4f9c414 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -9,6 +9,7 @@
 #include "fio.h"
 #include "flist.h"
 #include "workqueue.h"
+#include "smalloc.h"
 
 enum {
 	SW_F_IDLE	= 1 << 0,
@@ -263,7 +264,7 @@ void workqueue_exit(struct workqueue *wq)
 		}
 	} while (shutdown && shutdown != wq->max_workers);
 
-	free(wq->workers);
+	sfree(wq->workers);
 	wq->workers = NULL;
 	pthread_mutex_destroy(&wq->flush_lock);
 	pthread_cond_destroy(&wq->flush_cond);
@@ -317,7 +318,7 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 	pthread_mutex_init(&wq->flush_lock, NULL);
 	pthread_mutex_init(&wq->stat_lock, NULL);
 
-	wq->workers = calloc(wq->max_workers, sizeof(struct submit_worker));
+	wq->workers = smalloc(wq->max_workers * sizeof(struct submit_worker));
 
 	for (i = 0; i < wq->max_workers; i++)
 		if (start_worker(wq, i, sk_out))
