Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54294 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbdF1MAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Jun 2017 08:00:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dQBdn-0007B6-9W
        for fio@vger.kernel.org; Wed, 28 Jun 2017 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170628120001.F313D2C0235@kernel.dk>
Date: Wed, 28 Jun 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit db84b73bd7b0c3b718596fbeb6a5f940b05a6735:

  stat: fix group percentage (2017-06-27 00:47:27 +0100)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 867f90e36d9d1458b20e5fab4542ce6c631f2633:

  blktrace: remove unused ioctl definitions (2017-06-27 19:59:49 -0600)

----------------------------------------------------------------
Daniel Verkamp (1):
      lib/ffz: remove dead store

Ido Ben-Tsion (1):
      HOWTO: fix the v3 terse output definition

Jens Axboe (3):
      Update API for file write hints
      mtd: add private rpmatch()
      blktrace: remove unused ioctl definitions

Tomohiro Kusumi (2):
      HOWTO: add offset unit info for offset= option
      man page: add offset unit info for offset= option

 HOWTO                 | 10 ++++++----
 blktrace_api.h        |  5 -----
 fio.1                 | 12 +++++++-----
 ioengines.c           | 13 ++++++++++++-
 lib/ffz.h             |  4 +---
 os/os-linux.h         | 13 ++++++++-----
 oslib/libmtd_common.h | 13 ++-----------
 7 files changed, 36 insertions(+), 34 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 2007dc0..37caa3c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1090,11 +1090,13 @@ I/O type
 
 .. option:: offset=int
 
-	Start I/O at the provided offset in the file, given as either a fixed size or
-	a percentage. If a percentage is given, the next ``blockalign``-ed offset
-	will be used. Data before the given offset will not be touched. This
+	Start I/O at the provided offset in the file, given as either a fixed size in
+	bytes or a percentage. If a percentage is given, the next ``blockalign``-ed
+	offset will be used. Data before the given offset will not be touched. This
 	effectively caps the file size at `real_size - offset`. Can be combined with
 	:option:`size` to constrain the start and end range of the I/O workload.
+	A percentage can be specified by the percentage number plus 1 with preceding '-'.
+	For example, -1 is parsed as 0%, -10 is parsed as 9%, -101 is parsed as 100%.
 
 .. option:: offset_increment=int
 
@@ -3323,7 +3325,7 @@ will be a disk utilization section.
 Below is a single line containing short names for each of the fields in the
 minimal output v3, separated by semicolons::
 
-	terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_max;read_clat_min;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_max;write_clat_min;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10
 ;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;pu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
+terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;
 write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
 
 Trace file format
diff --git a/blktrace_api.h b/blktrace_api.h
index 3df3347..e2d8cb3 100644
--- a/blktrace_api.h
+++ b/blktrace_api.h
@@ -127,9 +127,4 @@ struct blk_user_trace_setup {
 	__u32 pid;
 };
 
-#define BLKTRACESETUP _IOWR(0x12,115,struct blk_user_trace_setup)
-#define BLKTRACESTART _IO(0x12,116)
-#define BLKTRACESTOP _IO(0x12,117)
-#define BLKTRACETEARDOWN _IO(0x12,118)
-
 #endif
diff --git a/fio.1 b/fio.1
index 6a6ea1b..ac87c9d 100644
--- a/fio.1
+++ b/fio.1
@@ -911,11 +911,13 @@ If true, use buffered I/O.  This is the opposite of the \fBdirect\fR parameter.
 Default: true.
 .TP
 .BI offset \fR=\fPint
-Start I/O at the provided offset in the file, given as either a fixed size or a
-percentage. If a percentage is given, the next \fBblockalign\fR-ed offset will
-be used. Data before the given offset will not be touched. This effectively
-caps the file size at (real_size - offset). Can be combined with \fBsize\fR to
-constrain the start and end range of the I/O workload.
+Start I/O at the provided offset in the file, given as either a fixed size in
+bytes or a percentage. If a percentage is given, the next \fBblockalign\fR-ed
+offset will be used. Data before the given offset will not be touched. This
+effectively caps the file size at (real_size - offset). Can be combined with
+\fBsize\fR to constrain the start and end range of the I/O workload. A percentage
+can be specified by the percentage number plus 1 with preceding '-'. For example,
+-1 is parsed as 0%, -10 is parsed as 9%, -101 is parsed as 100%.
 .TP
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes the
diff --git a/ioengines.c b/ioengines.c
index abbaa9a..6e6e3de 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -476,8 +476,19 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 	if (fio_option_is_set(&td->o, write_hint) &&
 	    (f->filetype == FIO_TYPE_BLOCK || f->filetype == FIO_TYPE_FILE)) {
 		uint64_t hint = td->o.write_hint;
+		int cmd;
 
-		if (fcntl(f->fd, F_SET_RW_HINT, &hint) < 0) {
+		/*
+		 * For direct IO, we just need/want to set the hint on
+		 * the file descriptor. For buffered IO, we need to set
+		 * it on the inode.
+		 */
+		if (td->o.odirect)
+			cmd = F_SET_FILE_RW_HINT;
+		else
+			cmd = F_SET_RW_HINT;
+
+		if (fcntl(f->fd, cmd, &hint) < 0) {
 			td_verror(td, errno, "fcntl write hint");
 			goto err;
 		}
diff --git a/lib/ffz.h b/lib/ffz.h
index e2c1b8e..16c9ae9 100644
--- a/lib/ffz.h
+++ b/lib/ffz.h
@@ -27,10 +27,8 @@ static inline int ffs64(uint64_t word)
 		word >>= 2;
 		r += 2;
 	}
-	if (!(word & 1)) {
-		word >>= 1;
+	if (!(word & 1))
 		r += 1;
-	}
 
 	return r;
 }
diff --git a/os/os-linux.h b/os/os-linux.h
index 3e7a2fc..8c1e93b 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -309,14 +309,17 @@ static inline int fio_set_sched_idle(void)
 #endif
 #define F_GET_RW_HINT		(F_LINUX_SPECIFIC_BASE + 11)
 #define F_SET_RW_HINT		(F_LINUX_SPECIFIC_BASE + 12)
+#define F_GET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 13)
+#define F_SET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 14)
 #endif
 
 #ifndef RWH_WRITE_LIFE_NONE
-#define RWH_WRITE_LIFE_NONE	0
-#define RWH_WRITE_LIFE_SHORT	1
-#define RWH_WRITE_LIFE_MEDIUM	2
-#define RWH_WRITE_LIFE_LONG	3
-#define RWH_WRITE_LIFE_EXTREME	4
+#define RWH_WRITE_LIFE_NOT_SET	0
+#define RWH_WRITE_LIFE_NONE	1
+#define RWH_WRITE_LIFE_SHORT	2
+#define RWH_WRITE_LIFE_MEDIUM	3
+#define RWH_WRITE_LIFE_LONG	4
+#define RWH_WRITE_LIFE_EXTREME	5
 #endif
 
 #define FIO_HAVE_WRITE_HINT
diff --git a/oslib/libmtd_common.h b/oslib/libmtd_common.h
index 9768066..3f9e1b8 100644
--- a/oslib/libmtd_common.h
+++ b/oslib/libmtd_common.h
@@ -119,20 +119,11 @@ extern "C" {
 	fprintf(stderr, "%s: warning!: " fmt "\n", PROGRAM_NAME, ##__VA_ARGS__); \
 } while(0)
 
-#if defined(__UCLIBC__)
-/* uClibc versions before 0.9.34 don't have rpmatch() */
-#if __UCLIBC_MAJOR__ == 0 && \
-		(__UCLIBC_MINOR__ < 9 || \
-		(__UCLIBC_MINOR__ == 9 && __UCLIBC_SUBLEVEL__ < 34))
-#undef rpmatch
-#define rpmatch __rpmatch
-static inline int __rpmatch(const char *resp)
+static inline int mtd_rpmatch(const char *resp)
 {
     return (resp[0] == 'y' || resp[0] == 'Y') ? 1 :
 	(resp[0] == 'n' || resp[0] == 'N') ? 0 : -1;
 }
-#endif
-#endif
 
 /**
  * prompt the user for confirmation
@@ -154,7 +145,7 @@ static inline bool prompt(const char *msg, bool def)
 		}
 
 		if (strcmp("\n", line) != 0) {
-			switch (rpmatch(line)) {
+			switch (mtd_rpmatch(line)) {
 			case 0: ret = false; break;
 			case 1: ret = true; break;
 			case -1:
