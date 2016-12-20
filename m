Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:13482 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933105AbcLTXxj (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Dec 2016 18:53:39 -0500
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id 6908D168A
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 23:53:38 +0000 (UTC)
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2353.austin.hpe.com (Postfix) with ESMTP id 36F6855
        for <fio@vger.kernel.org>; Tue, 20 Dec 2016 23:53:37 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 2/2] pmemblk: Clarify fsize is in MiB not MB
Date: Tue, 20 Dec 2016 17:56:38 -0600
Message-Id: <20161220235638.35477-2-elliott@hpe.com>
In-Reply-To: <20161220235638.35477-1-elliott@hpe.com>
References: <20161220235638.35477-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Clarify that the FSIZE argument is in MiB (power of 2) rather
than MB (power of 10) in comments and variable names.
---
 engines/pmemblk.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 977a02b..62f3746 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -27,11 +27,11 @@
  *   ioengine=pmemblk
  *
  * Other relevant settings:
+ *   thread=1   REQUIRED
  *   iodepth=1
  *   direct=1
- *   thread=1   REQUIRED
  *   unlink=1
- *   filename=/pmem0/fiotestfile,BSIZE,FSIZEMB
+ *   filename=/mnt/pmem0/fiotestfile,BSIZE,FSIZEMiB
  *
  *   thread must be set to 1 for pmemblk as multiple processes cannot
  *     open the same block pool file.
@@ -39,22 +39,31 @@
  *   iodepth should be set to 1 as pmemblk is always synchronous.
  *   Use numjobs to scale up.
  *
- *   direct=1 is implied as pmemblk is always direct.
+ *   direct=1 is implied as pmemblk is always direct. A warning message
+ *   is printed if this is not specified.
+ *
+ *   unlink=1 removes the block pool file after testing, and is optional.
+ *
+ *   The pmem device must have a DAX-capable filesystem and be mounted
+ *   with DAX enabled.  filename must point to a file on that filesystem.
  *
- *   Can set unlink to 1 to remove the block pool file after testing.
+ *   Example:
+ *     mkfs.xfs /dev/pmem0
+ *     mkdir /mnt/pmem0
+ *     mount -o dax /dev/pmem0 /mnt/pmem0
  *
  *   When specifying the filename, if the block pool file does not already
- *   exist, then the pmemblk engine can create the pool file if you specify
+ *   exist, then the pmemblk engine creates the pool file if you specify
  *   the block and file sizes.  BSIZE is the block size in bytes.
- *   FSIZEMB is the pool file size in MB.
+ *   FSIZEMiB is the pool file size in MiB.
  *
  *   See examples/pmemblk.fio for more.
  *
  * libpmemblk.so
- *   By default, the pmemblk engine will let the system find the libpmemblk.so
- *   that it uses.  You can use an alternative libpmemblk by setting the
- *   FIO_PMEMBLK_LIB environment variable to the full path to the desired
- *   libpmemblk.so.
+ *   By default, the pmemblk engine lets the system find libpmemblk.so
+ *   (e.g., see /etc/ld.conf.so).  You may use an alternative libpmemblk
+ *   by setting the FIO_PMEMBLK_LIB environment variable to the full path
+ *   to the desired libpmemblk.so file.
  *
  */
 
@@ -187,7 +196,7 @@ static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
  * level, we allow the block size and file size to be appended
  * to the file name:
  *
- *   path[,bsize,fsizemb]
+ *   path[,bsize,fsizemib]
  *
  * note that we do not use the fio option "filesize" to dictate
  * the file size because we can only give libpmemblk the gross
@@ -197,7 +206,7 @@ static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
  * the final path without the parameters is returned in ppath.
  * the block size and file size are returned in pbsize and fsize.
  *
- * note that the user should specify the file size in MiB, but
+ * note that the user specifies the file size in MiB, but
  * we return bytes from here.
  */
 static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
@@ -206,7 +215,7 @@ static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
 	char *path;
 	char *s;
 	uint64_t bsize;
-	uint64_t fsizemb;
+	uint64_t fsizemib;
 
 	path = strdup(pathspec);
 	if (!path) {
@@ -216,14 +225,14 @@ static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
 
 	/* extract sizes, if given */
 	s = strrchr(path, ',');
-	if (s && (fsizemb = strtoull(s + 1, NULL, 10))) {
+	if (s && (fsizemib = strtoull(s + 1, NULL, 10))) {
 		*s = 0;
 		s = strrchr(path, ',');
 		if (s && (bsize = strtoull(s + 1, NULL, 10))) {
 			*s = 0;
 			*ppath = path;
 			*pbsize = bsize;
-			*pfsize = fsizemb << 20;
+			*pfsize = fsizemib << 20;
 			return;
 		}
 	}
-- 
2.9.3

