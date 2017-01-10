Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:15700 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752416AbdAJVRx (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Jan 2017 16:17:53 -0500
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 560BE606BB
        for <fio@vger.kernel.org>; Tue, 10 Jan 2017 21:17:52 +0000 (UTC)
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2354.austin.hpe.com (Postfix) with ESMTP id 56AA14E
        for <fio@vger.kernel.org>; Tue, 10 Jan 2017 21:17:51 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 4/4] pmemblk: Clarify fsize is in MiB not MB
Date: Tue, 10 Jan 2017 15:21:27 -0600
Message-Id: <20170110212127.64926-4-elliott@hpe.com>
In-Reply-To: <20170110212127.64926-1-elliott@hpe.com>
References: <20170104065453.15106-1-elliott@hpe.com>
 <20170110212127.64926-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Clarify that the FSIZE argument is in MiB (power of 2) rather
than MB (power of 10) in comments and variable names.
---
 engines/pmemblk.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 7c609cf..c70015b 100644
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
@@ -39,14 +39,23 @@
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
+ *   FSIZEMB is the pool file size in MiB.
  *
  *   See examples/pmemblk.fio for more.
  *
@@ -128,7 +137,7 @@ static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
  * level, we allow the block size and file size to be appended
  * to the file name:
  *
- *   path[,bsize,fsizemb]
+ *   path[,bsize,fsizemib]
  *
  * note that we do not use the fio option "filesize" to dictate
  * the file size because we can only give libpmemblk the gross
@@ -138,7 +147,7 @@ static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
  * the final path without the parameters is returned in ppath.
  * the block size and file size are returned in pbsize and fsize.
  *
- * note that the user should specify the file size in MiB, but
+ * note that the user specifies the file size in MiB, but
  * we return bytes from here.
  */
 static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
@@ -147,7 +156,7 @@ static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
 	char *path;
 	char *s;
 	uint64_t bsize;
-	uint64_t fsizemb;
+	uint64_t fsizemib;
 
 	path = strdup(pathspec);
 	if (!path) {
@@ -157,14 +166,14 @@ static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
 
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

