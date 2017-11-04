Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33555 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdKDMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Nov 2017 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAx7X-0007Dp-3o
        for fio@vger.kernel.org; Sat, 04 Nov 2017 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171104120002.92CD32C012F@kernel.dk>
Date: Sat,  4 Nov 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 34851ad5ffacf9f4f8a7f23ee2edb17281b917a0:

  io_u_queue: convert rings to bool (2017-11-02 12:26:39 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9f50b4106bd1d6fa1c325900d1fb286832ccc5e8:

  Fio 3.2 (2017-11-03 15:23:49 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'json_bw_bytes' of https://github.com/sitsofe/fio
      Fio 3.2

Sitsofe Wheeler (1):
      stat: add bw_bytes JSON key

Tomohiro Kusumi (3):
      solaris: #include <pthread.h>
      solaris: add os_phys_mem() implementation
      solaris: add get_fs_free_size() implementation

 FIO-VERSION-GEN        |  2 +-
 os/os-solaris.h        | 25 ++++++++++++++++++++++++-
 os/windows/install.wxs |  2 +-
 stat.c                 |  7 +++++--
 4 files changed, 31 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 8c075cb..22f4404 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.1
+DEF_VER=fio-3.2
 
 LF='
 '
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 45268b2..2f13723 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -12,12 +12,15 @@
 #include <sys/mman.h>
 #include <sys/dkio.h>
 #include <sys/byteorder.h>
+#include <sys/statvfs.h>
+#include <pthread.h>
 
 #include "../file.h"
 
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_USE_GENERIC_BDEV_SIZE
+#define FIO_HAVE_FS_STAT
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_GETTID
 
@@ -65,7 +68,27 @@ static inline int blockdev_invalidate_cache(struct fio_file *f)
 
 static inline unsigned long long os_phys_mem(void)
 {
-	return 0;
+	long pagesize, pages;
+
+	pagesize = sysconf(_SC_PAGESIZE);
+	pages = sysconf(_SC_PHYS_PAGES);
+	if (pages == -1 || pagesize == -1)
+		return 0;
+
+	return (unsigned long long) pages * (unsigned long long) pagesize;
+}
+
+static inline unsigned long long get_fs_free_size(const char *path)
+{
+	unsigned long long ret;
+	struct statvfs s;
+
+	if (statvfs(path, &s) < 0)
+		return -1ULL;
+
+	ret = s.f_frsize;
+	ret *= (unsigned long long) s.f_bfree;
+	return ret;
 }
 
 static inline void os_random_seed(unsigned long seed, os_random_state_t *rs)
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 58244c5..6dfe231 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.1">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.2">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/stat.c b/stat.c
index c8a45db..89e2e6c 100644
--- a/stat.c
+++ b/stat.c
@@ -956,7 +956,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		struct group_run_stats *rs, int ddir, struct json_object *parent)
 {
 	unsigned long long min, max, minv, maxv;
-	unsigned long long bw;
+	unsigned long long bw_bytes, bw;
 	unsigned long long *ovals = NULL;
 	double mean, dev, iops;
 	unsigned int len;
@@ -975,17 +975,20 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_object(parent,
 		ts->unified_rw_rep ? "mixed" : ddirname[ddir], dir_object);
 
+	bw_bytes = 0;
 	bw = 0;
 	iops = 0.0;
 	if (ts->runtime[ddir]) {
 		uint64_t runt = ts->runtime[ddir];
 
-		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024; /* KiB/s */
+		bw_bytes = ((1000 * ts->io_bytes[ddir]) / runt); /* Bytes/s */
+		bw = bw_bytes / 1024; /* KiB/s */
 		iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
 	}
 
 	json_object_add_value_int(dir_object, "io_bytes", ts->io_bytes[ddir]);
 	json_object_add_value_int(dir_object, "io_kbytes", ts->io_bytes[ddir] >> 10);
+	json_object_add_value_int(dir_object, "bw_bytes", bw_bytes);
 	json_object_add_value_int(dir_object, "bw", bw);
 	json_object_add_value_float(dir_object, "iops", iops);
 	json_object_add_value_int(dir_object, "runtime", ts->runtime[ddir]);
