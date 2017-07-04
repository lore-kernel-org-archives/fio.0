Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50888 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbdGDMAY (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 4 Jul 2017 08:00:24 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dSMVC-0007Br-OK
        for fio@vger.kernel.org; Tue, 04 Jul 2017 12:00:23 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170704120002.3DFA82C0087@kernel.dk>
Date: Tue,  4 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5283741f7be708fbbb3feb2cd5ca5187f3a964d1:

  gettime: reduce test CPU clock entries to 1000 (2017-07-02 16:21:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1be7afd7329ebdca520d637f571d2b31c33f6ba1:

  Merge branch 'fallocate_native' of https://github.com/sitsofe/fio (2017-07-03 16:51:31 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fallocate_native' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      filesetup: add native fallocate
      HOWTO: indent v3 terse output definition

 HOWTO         | 11 ++++++++---
 file.h        |  1 +
 filesetup.c   | 30 ++++++++++++++++++++++++++++--
 fio.1         |  9 +++++++--
 options.c     | 14 +++++++++++---
 os/os-linux.h | 18 ++++++++++++++++++
 os/os-mac.h   | 12 ++++++++++++
 os/os.h       |  8 ++++++++
 8 files changed, 93 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 6e53cff..92c3b73 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1049,6 +1049,10 @@ I/O type
 		**none**
 			Do not pre-allocate space.
 
+		**native**
+			Use a platform's native pre-allocation call but fall back to
+			**none** behavior if it fails/is not implemented.
+
 		**posix**
 			Pre-allocate via :manpage:`posix_fallocate(3)`.
 
@@ -1063,8 +1067,9 @@ I/O type
 			Backward-compatible alias for **posix**.
 
 	May not be available on all supported platforms. **keep** is only available
-	on Linux. If using ZFS on Solaris this must be set to **none** because ZFS
-	doesn't support it. Default: **posix**.
+	on Linux. If using ZFS on Solaris this cannot be set to **posix**
+	because ZFS doesn't support pre-allocation. Default: **native** if any
+	pre-allocation methods are available, **none** if not.
 
 .. option:: fadvise_hint=str
 
@@ -3328,7 +3333,7 @@ will be a disk utilization section.
 Below is a single line containing short names for each of the fields in the
 minimal output v3, separated by semicolons::
 
-terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;
 write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
+	terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10
 ;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
 
 Trace file format
diff --git a/file.h b/file.h
index 9801bb5..84daa5f 100644
--- a/file.h
+++ b/file.h
@@ -63,6 +63,7 @@ enum fio_fallocate_mode {
 	FIO_FALLOCATE_NONE	= 1,
 	FIO_FALLOCATE_POSIX	= 2,
 	FIO_FALLOCATE_KEEP_SIZE	= 3,
+	FIO_FALLOCATE_NATIVE	= 4,
 };
 
 /*
diff --git a/filesetup.c b/filesetup.c
index f3e3865..38ad9ed 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -38,6 +38,25 @@ static inline void clear_error(struct thread_data *td)
 	td->verror[0] = '\0';
 }
 
+static inline int native_fallocate(struct thread_data *td, struct fio_file *f)
+{
+	bool success;
+
+	success = fio_fallocate(f, 0, f->real_file_size);
+	dprint(FD_FILE, "native fallocate of file %s size %llu was "
+			"%ssuccessful\n", f->file_name,
+			(unsigned long long) f->real_file_size,
+			!success ? "un": "");
+
+	if (success)
+		return 0;
+
+	if (errno == ENOSYS)
+		dprint(FD_FILE, "native fallocate is not implemented\n");
+
+	return -1;
+}
+
 static void fallocate_file(struct thread_data *td, struct fio_file *f)
 {
 	int r;
@@ -45,10 +64,16 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 	if (td->o.fill_device)
 		return;
 
-#ifdef CONFIG_POSIX_FALLOCATE
 	switch (td->o.fallocate_mode) {
+	case FIO_FALLOCATE_NATIVE:
+		r = native_fallocate(td, f);
+		if (r != 0)
+			log_err("fio: native_fallocate call failed: %s\n",
+					strerror(errno));
+		break;
 	case FIO_FALLOCATE_NONE:
 		break;
+#ifdef CONFIG_POSIX_FALLOCATE
 	case FIO_FALLOCATE_POSIX:
 		dprint(FD_FILE, "posix_fallocate file %s size %llu\n",
 				 f->file_name,
@@ -58,6 +83,7 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 		if (r > 0)
 			log_err("fio: posix_fallocate fails: %s\n", strerror(r));
 		break;
+#endif /* CONFIG_POSIX_FALLOCATE */
 #ifdef CONFIG_LINUX_FALLOCATE
 	case FIO_FALLOCATE_KEEP_SIZE:
 		dprint(FD_FILE, "fallocate(FALLOC_FL_KEEP_SIZE) "
@@ -74,7 +100,7 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 		log_err("fio: unknown fallocate mode: %d\n", td->o.fallocate_mode);
 		assert(0);
 	}
-#endif /* CONFIG_POSIX_FALLOCATE */
+
 }
 
 /*
diff --git a/fio.1 b/fio.1
index ab04208..9783646 100644
--- a/fio.1
+++ b/fio.1
@@ -436,6 +436,10 @@ are:
 .B none
 Do not pre-allocate space.
 .TP
+.B native
+Use a platform's native pre-allocation call but fall back to 'none' behavior if
+it fails/is not implemented.
+.TP
 .B posix
 Pre-allocate via \fBposix_fallocate\fR\|(3).
 .TP
@@ -450,8 +454,9 @@ Backward-compatible alias for 'posix'.
 .RE
 .P
 May not be available on all supported platforms. 'keep' is only
-available on Linux. If using ZFS on Solaris this must be set to 'none'
-because ZFS doesn't support it. Default: 'posix'.
+available on Linux. If using ZFS on Solaris this cannot be set to 'posix'
+because ZFS doesn't support it. Default: 'native' if any pre-allocation methods
+are available, 'none' if not.
 .RE
 .TP
 .BI fadvise_hint \fR=\fPstr
diff --git a/options.c b/options.c
index 09a21af..b21f09a 100644
--- a/options.c
+++ b/options.c
@@ -2289,14 +2289,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.parent = "nrfiles",
 		.hide	= 1,
 	},
-#ifdef CONFIG_POSIX_FALLOCATE
+#if defined(CONFIG_POSIX_FALLOCATE) || defined(FIO_HAVE_NATIVE_FALLOCATE)
 	{
 		.name	= "fallocate",
 		.lname	= "Fallocate",
 		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, fallocate_mode),
 		.help	= "Whether pre-allocation is performed when laying out files",
-		.def	= "posix",
+		.def	= "native",
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 		.posval	= {
@@ -2304,10 +2304,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_FALLOCATE_NONE,
 			    .help = "Do not pre-allocate space",
 			  },
+			  { .ival = "native",
+			    .oval = FIO_FALLOCATE_NATIVE,
+			    .help = "Use native pre-allocation if possible",
+			  },
+#ifdef CONFIG_POSIX_FALLOCATE
 			  { .ival = "posix",
 			    .oval = FIO_FALLOCATE_POSIX,
 			    .help = "Use posix_fallocate()",
 			  },
+#endif
 #ifdef CONFIG_LINUX_FALLOCATE
 			  { .ival = "keep",
 			    .oval = FIO_FALLOCATE_KEEP_SIZE,
@@ -2319,10 +2325,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_FALLOCATE_NONE,
 			    .help = "Alias for 'none'",
 			  },
+#ifdef CONFIG_POSIX_FALLOCATE
 			  { .ival = "1",
 			    .oval = FIO_FALLOCATE_POSIX,
 			    .help = "Alias for 'posix'",
 			  },
+#endif
 		},
 	},
 #else	/* CONFIG_POSIX_FALLOCATE */
@@ -2332,7 +2340,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support fallocate",
 	},
-#endif /* CONFIG_POSIX_FALLOCATE */
+#endif /* CONFIG_POSIX_FALLOCATE || FIO_HAVE_NATIVE_FALLOCATE */
 	{
 		.name	= "fadvise_hint",
 		.lname	= "Fadvise hint",
diff --git a/os/os-linux.h b/os/os-linux.h
index 8c1e93b..e7d600d 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -392,4 +392,22 @@ static inline int shm_attach_to_open_removed(void)
 	return 1;
 }
 
+#ifdef CONFIG_LINUX_FALLOCATE
+#define FIO_HAVE_NATIVE_FALLOCATE
+static inline bool fio_fallocate(struct fio_file *f, uint64_t offset,
+				 uint64_t len)
+{
+	int ret;
+	ret = fallocate(f->fd, 0, 0, len);
+	if (ret == 0)
+		return true;
+
+	/* Work around buggy old glibc versions... */
+	if (ret > 0)
+		errno = ret;
+
+	return false;
+}
+#endif
+
 #endif
diff --git a/os/os-mac.h b/os/os-mac.h
index 7de36ea..a1536c7 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -20,6 +20,7 @@
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CHARDEV_SIZE
+#define FIO_HAVE_NATIVE_FALLOCATE
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -101,4 +102,15 @@ static inline int gettid(void)
  */
 extern int fdatasync(int fd);
 
+static inline bool fio_fallocate(struct fio_file *f, uint64_t offset, uint64_t len)
+{
+	fstore_t store = {F_ALLOCATEALL, F_PEOFPOSMODE, offset, len};
+	if (fcntl(f->fd, F_PREALLOCATE, &store) != -1) {
+		if (ftruncate(f->fd, len) == 0)
+			return true;
+	}
+
+	return false;
+}
+
 #endif
diff --git a/os/os.h b/os/os.h
index 1d400c8..afee9f9 100644
--- a/os/os.h
+++ b/os/os.h
@@ -361,4 +361,12 @@ static inline int shm_attach_to_open_removed(void)
 }
 #endif
 
+#ifndef FIO_HAVE_NATIVE_FALLOCATE
+static inline bool fio_fallocate(struct fio_file *f, uint64_t offset, uint64_t len)
+{
+	errno = ENOSYS;
+	return false;
+}
+#endif
+
 #endif
