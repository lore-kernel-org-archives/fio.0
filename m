Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40055 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbaDIMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Apr 2014 08:00:08 -0400
Received: from kernel.dk ([54.225.238.116] helo=rt116.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WXrAi-000836-Fp
	for fio@vger.kernel.org; Wed, 09 Apr 2014 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140409120003.9111D40067@rt116.dk>
Date: Wed,  9 Apr 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bc4f5ef67d26ef98f4822d5f798cb8c4e2d2fce5:

  Support limited mixed command line options and job file (2014-04-06 10:10:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 42793d9467cc45d08ced5211c3797bf68a3d24cc:

  iolog: skip max_bs[rw] increment for rw == DDIR_INVAL (2014-04-08 21:18:37 -0600)

----------------------------------------------------------------
Christian Ehrhardt (2):
      fio: fix s390 time accounting
      fio: fix s390 nop

Jens Axboe (7):
      blktrace: probe IO depth
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      Revert "Fixup ->open_files if not given"
      Increment open file count manually
      server: fix fd leak in error case
      diskutil: fix potential out-of-bounds array write
      iolog: skip max_bs[rw] increment for rw == DDIR_INVAL

 arch/arch-s390.h |   15 ++++++++++-----
 blktrace.c       |   23 +++++++++++++++++++++++
 diskutil.c       |    2 +-
 engines/net.c    |    1 +
 engines/rbd.c    |    1 +
 filesetup.c      |    7 -------
 gettime.c        |   14 +++++++++++---
 iolog.c          |    2 +-
 server.c         |    1 +
 9 files changed, 49 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index bcd9163..56cb230 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -18,18 +18,25 @@
 #define __NR_sys_vmsplice	309
 #endif
 
-#define nop		asm volatile ("diag 0,0,68" : : : "memory")
+#define nop		asm volatile("nop" : : : "memory")
 #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
 #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
 
+/*
+ * Fio needs monotonic (never lower), but not strict monotonic (never the same)
+ * so store clock fast is enough
+ */
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned long long clk;
 
-	__asm__ __volatile__("stck %0" : "=Q" (clk) : : "cc");
-	return clk;
+	__asm__ __volatile__("stckf %0" : "=Q" (clk) : : "cc");
+	return clk>>12;
 }
 
+#define ARCH_CPU_CLOCK_CYCLES_PER_USEC 1
+#define ARCH_HAVE_CPU_CLOCK
+
 #define ARCH_HAVE_INIT
 extern int tsc_reliable;
 static inline int arch_init(char *envp[])
@@ -38,6 +45,4 @@ static inline int arch_init(char *envp[])
 	return 0;
 }
 
-#define ARCH_HAVE_CPU_CLOCK
-
 #endif
diff --git a/blktrace.c b/blktrace.c
index 4b5567e..52f0c71 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -217,6 +217,7 @@ static int trace_add_file(struct thread_data *td, __u32 device)
 
 		dprint(FD_BLKTRACE, "add devices %s\n", dev);
 		fileno = add_file_exclusive(td, dev);
+		td->o.open_files++;
 		td->files[fileno]->major = maj;
 		td->files[fileno]->minor = min;
 		trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
@@ -373,6 +374,7 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	struct fifo *fifo;
 	int fd, i, old_state;
 	struct fio_file *f;
+	int this_depth, depth;
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
@@ -391,6 +393,7 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	ios[0] = ios[1] = 0;
 	rw_bs[0] = rw_bs[1] = 0;
 	skipped_writes = 0;
+	this_depth = depth = 0;
 	do {
 		int ret = trace_fifo_get(td, fifo, fd, &t, sizeof(t));
 
@@ -425,6 +428,12 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 			goto err;
 		}
 		if ((t.action & BLK_TC_ACT(BLK_TC_NOTIFY)) == 0) {
+			if ((t.action & 0xffff) == __BLK_TA_QUEUE)
+				this_depth++;
+			else if ((t.action & 0xffff) == __BLK_TA_COMPLETE) {
+				depth = max(depth, this_depth);
+				this_depth = 0;
+			}
 			if (!ttime) {
 				ttime = t.time;
 				cpu = t.cpu;
@@ -469,6 +478,13 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 		return 1;
 	}
 
+	/*
+	 * For stacked devices, we don't always get a COMPLETE event so
+	 * the depth grows to insane values. Limit it to something sane(r).
+	 */
+	if (!depth || depth > 1024)
+		depth = 1024;
+
 	if (skipped_writes)
 		log_err("fio: %s skips replay of %lu writes due to read-only\n",
 						td->o.name, skipped_writes);
@@ -494,6 +510,13 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	 */
 	td->o.odirect = 1;
 
+	/*
+	 * we don't know if this option was set or not. it defaults to 1,
+	 * so we'll just guess that we should override it if it's still 1
+	 */
+	if (td->o.iodepth != 1)
+		td->o.iodepth = depth;
+
 	return 0;
 err:
 	close(fd);
diff --git a/diskutil.c b/diskutil.c
index 9aa1fa1..cbde42e 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -236,7 +236,7 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 		 * are links to the real directories for the slave
 		 * devices?
 		 */
-		linklen = readlink(temppath, slavepath, PATH_MAX - 0);
+		linklen = readlink(temppath, slavepath, PATH_MAX - 1);
 		if (linklen  < 0) {
 			perror("readlink() for slave device.");
 			return;
diff --git a/engines/net.c b/engines/net.c
index 110e158..fcf4b89 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1196,6 +1196,7 @@ static int fio_netio_setup(struct thread_data *td)
 	if (!td->files_index) {
 		add_file(td, td->o.filename ?: "net", 0, 0);
 		td->o.nr_files = td->o.nr_files ?: 1;
+		td->o.open_files++;
 	}
 
 	if (!td->io_ops->data) {
diff --git a/engines/rbd.c b/engines/rbd.c
index 9d64efd..ff35373 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -379,6 +379,7 @@ static int fio_rbd_setup(struct thread_data *td)
 	if (!td->files_index) {
 		add_file(td, td->o.filename ? : "rbd", 0, 0);
 		td->o.nr_files = td->o.nr_files ? : 1;
+		td->o.open_files++;
 	}
 	f = td->files[0];
 	f->real_file_size = info.size;
diff --git a/filesetup.c b/filesetup.c
index bf05b6f..abea1e6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1279,13 +1279,6 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 
 	set_already_allocated(file_name);
 
-	/*
-	 * For adding files after the fact - if openfiles= isn't
-	 * given as an option, ensure we allow at least one file open
-	 */
-	if (!td->o.open_files)
-		td->o.open_files = 1;
-
 	if (inc)
 		td->o.nr_files++;
 
diff --git a/gettime.c b/gettime.c
index b89cd46..c6d45f8 100644
--- a/gettime.c
+++ b/gettime.c
@@ -13,7 +13,7 @@
 #include "hash.h"
 #include "os/os.h"
 
-#ifdef ARCH_HAVE_CPU_CLOCK
+#if defined(ARCH_HAVE_CPU_CLOCK) && !defined(ARCH_CPU_CLOCK_CYCLES_PER_USEC)
 static unsigned long cycles_per_usec;
 static unsigned long inv_cycles_per_usec;
 #endif
@@ -177,7 +177,11 @@ static void *__fio_gettime(struct timeval *tp)
 		} else if (tv)
 			tv->last_cycles = t;
 
+#ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
+		usecs = t / ARCH_CPU_CLOCK_CYCLES_PER_USEC;
+#else
 		usecs = (t * inv_cycles_per_usec) / 16777216UL;
+#endif
 		tp->tv_sec = usecs / 1000000;
 		tp->tv_usec = usecs % 1000000;
 		break;
@@ -229,7 +233,7 @@ void fio_gettime(struct timeval *tp, void fio_unused *caller)
 	}
 }
 
-#ifdef ARCH_HAVE_CPU_CLOCK
+#if defined(ARCH_HAVE_CPU_CLOCK) && !defined(ARCH_CPU_CLOCK_CYCLES_PER_USEC)
 static unsigned long get_cycles_per_usec(void)
 {
 	struct timeval s, e;
@@ -318,9 +322,13 @@ static int calibrate_cpu_clock(void)
 #else
 static int calibrate_cpu_clock(void)
 {
+#ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
+	return 0;
+#else
 	return 1;
-}
 #endif
+}
+#endif // ARCH_HAVE_CPU_CLOCK
 
 #ifndef CONFIG_TLS_THREAD
 void fio_local_clock_init(int is_thread)
diff --git a/iolog.c b/iolog.c
index e805eae..1eb89b2 100644
--- a/iolog.c
+++ b/iolog.c
@@ -371,7 +371,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 		} else {
 			ipo->offset = offset;
 			ipo->len = bytes;
-			if (bytes > td->o.max_bs[rw])
+			if (rw != DDIR_INVAL && bytes > td->o.max_bs[rw])
 				td->o.max_bs[rw] = bytes;
 			ipo->fileno = fileno;
 			ipo->file_action = file_action;
diff --git a/server.c b/server.c
index d72835b..beee2db 100644
--- a/server.c
+++ b/server.c
@@ -1394,6 +1394,7 @@ static int fio_init_server_connection(void)
 
 	if (listen(sk, 0) < 0) {
 		log_err("fio: listen: %s\n", strerror(errno));
+		close(sk);
 		return -1;
 	}
 
