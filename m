Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58908 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbdBONAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Feb 2017 08:00:09 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cdzBo-00008X-6l
        for fio@vger.kernel.org; Wed, 15 Feb 2017 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170215130001.9BE002C0218@kernel.dk>
Date: Wed, 15 Feb 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 06cbb3c71fc75dbeddebb53c8f0a2ea95dc28228:

  Windows: re-enable the mmap ioengine and fix static asserts (2017-02-13 15:38:59 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c1f50f765a0a51931605c1fb223d166e3b3a93c6:

  Use 0 instead of DDIR_READ to iterate from 0 to DDIR_RWDIR_CNT (2017-02-14 08:24:24 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (6):
      configure: Drop default CONFIG_LITTLE_ENDIAN for Cygwin
      configure: Use x86 instead of i386 for $cpu for IA32
      Drop conditional declaration of disk_list
      Always set ->real_file_size to -1 when failed to get file size
      Add missing "rand"/"trimwrite" strings to corresponding ddir slots
      Use 0 instead of DDIR_READ to iterate from 0 to DDIR_RWDIR_CNT

 configure     | 3 +--
 diskutil.c    | 2 --
 eta.c         | 6 +++---
 filesetup.c   | 6 ++++--
 io_ddir.h     | 4 ++--
 io_u.c        | 6 +++---
 libfio.c      | 5 -----
 stat.c        | 4 ++--
 steadystate.c | 2 +-
 9 files changed, 16 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 0a258bf..be29db9 100755
--- a/configure
+++ b/configure
@@ -306,7 +306,6 @@ CYGWIN*)
       fi
     fi
   fi
-  output_sym "CONFIG_LITTLE_ENDIAN"
   if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
     output_sym "CONFIG_32BIT"
   else
@@ -379,7 +378,7 @@ case "$cpu" in
     cpu="$cpu"
   ;;
   i386|i486|i586|i686|i86pc|BePC)
-    cpu="i386"
+    cpu="x86"
   ;;
   x86_64|amd64)
     cpu="x86_64"
diff --git a/diskutil.c b/diskutil.c
index c3bcec9..dca3748 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -18,8 +18,6 @@ static struct disk_util *last_du;
 
 static struct fio_mutex *disk_util_mutex;
 
-FLIST_HEAD(disk_list);
-
 static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 		int majdev, int mindev, char *path);
 
diff --git a/eta.c b/eta.c
index 1d66163..adf7f94 100644
--- a/eta.c
+++ b/eta.c
@@ -440,7 +440,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		if (td->runstate > TD_SETTING_UP) {
 			int ddir;
 
-			for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+			for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 				if (unified_rw_rep) {
 					io_bytes[0] += td->io_bytes[ddir];
 					io_iops[0] += td->io_blocks[ddir];
@@ -574,7 +574,7 @@ void display_thread_status(struct jobs_eta *je)
 			sprintf(perc_str, "%3.1f%%", perc);
 		}
 
-		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			rate_str[ddir] = num2str(je->rate[ddir], 4,
 						1024, je->is_pow2, je->unit_base);
 			iops_str[ddir] = num2str(je->iops[ddir], 4, 1, 0, N2S_NONE);
@@ -601,7 +601,7 @@ void display_thread_status(struct jobs_eta *je)
 			p += sprintf(p, "%*s", linelen_last - l, "");
 		linelen_last = l;
 
-		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			free(rate_str[ddir]);
 			free(iops_str[ddir]);
 		}
diff --git a/filesetup.c b/filesetup.c
index eb28826..3fa8b32 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -375,10 +375,12 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
 	else
-		f->real_file_size = -1;
+		f->real_file_size = -1ULL;
 
-	if (ret)
+	if (ret) {
+		f->real_file_size = -1ULL;
 		return ret;
+	}
 
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
diff --git a/io_ddir.h b/io_ddir.h
index 2141119..613d5fb 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -61,9 +61,9 @@ static inline int ddir_rw(enum fio_ddir ddir)
 
 static inline const char *ddir_str(enum td_ddir ddir)
 {
-	static const char *__str[] = { NULL, "read", "write", "rw", NULL,
+	static const char *__str[] = { NULL, "read", "write", "rw", "rand",
 				"randread", "randwrite", "randrw",
-				"trim", NULL, NULL, NULL, "randtrim" };
+				"trim", NULL, "trimwrite", NULL, "randtrim" };
 
 	return __str[ddir];
 }
diff --git a/io_u.c b/io_u.c
index 1daaf7b..f1a3916 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1902,7 +1902,7 @@ static void init_icd(struct thread_data *td, struct io_completion_data *icd,
 	icd->nr = nr;
 
 	icd->error = 0;
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		icd->bytes_done[ddir] = 0;
 }
 
@@ -1941,7 +1941,7 @@ int io_u_sync_complete(struct thread_data *td, struct io_u *io_u)
 		return -1;
 	}
 
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		td->bytes_done[ddir] += icd.bytes_done[ddir];
 
 	return 0;
@@ -1980,7 +1980,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 		return -1;
 	}
 
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		td->bytes_done[ddir] += icd.bytes_done[ddir];
 
 	return ret;
diff --git a/libfio.c b/libfio.c
index 7e0d32c..4b53c92 100644
--- a/libfio.c
+++ b/libfio.c
@@ -36,12 +36,7 @@
 #include "helper_thread.h"
 #include "filehash.h"
 
-/*
- * Just expose an empty list, if the OS does not support disk util stats
- */
-#ifndef FIO_HAVE_DISK_UTIL
 FLIST_HEAD(disk_list);
-#endif
 
 unsigned long arch_flags = 0;
 
diff --git a/stat.c b/stat.c
index f1d468c..0bb21d0 100644
--- a/stat.c
+++ b/stat.c
@@ -2442,7 +2442,7 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	/*
 	 * Compute both read and write rates for the interval.
 	 */
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 		uint64_t delta;
 
 		delta = td->this_io_bytes[ddir] - td->stat_io_bytes[ddir];
@@ -2517,7 +2517,7 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 	/*
 	 * Compute both read and write rates for the interval.
 	 */
-	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 		uint64_t delta;
 
 		delta = td->this_io_blocks[ddir] - td->stat_io_blocks[ddir];
diff --git a/steadystate.c b/steadystate.c
index 43c715c..98f027c 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -231,7 +231,7 @@ void steadystate_check(void)
 		}
 
 		td_io_u_lock(td);
-		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			td_iops += td->io_blocks[ddir];
 			td_bytes += td->io_bytes[ddir];
 		}
