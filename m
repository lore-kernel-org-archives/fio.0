Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2DDC61DA4
	for <fio@archiver.kernel.org>; Sat, 18 Feb 2023 13:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBRNAQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 18 Feb 2023 08:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBRNAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 Feb 2023 08:00:15 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AED16317
        for <fio@vger.kernel.org>; Sat, 18 Feb 2023 05:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=oMncRPyfIV/DmjGojPgSeqUXkFkWLvj/drewUn4W4UU=; b=rMa6Pp1/rZIRG6LjZRtDkDvoec
        IX1oItVrOqNDXbEHP2dH2GiaAN/DrtaSn+QHoJK5QB2fbnmnwf0uY+uMQeo3km7nvMrvfRCgAVVIY
        HXbIlYOhrb5A3gGcUTsJHPDSmFdKAJdrIPUh1YQWKHwQTmSrDKj02zjNg2MPd0bRxAjUDZmpTz+p+
        X7xvD32+q8mzWxeFXHoUdId6hpfRSZhb28nTD2eRLMFYF7pg7X+bewx5/MX9euucczhtPDtX13i/d
        x+o8gVyGT6vmesuOl5/tfzkkGIGaW9iJstJUzqeNFMsxgJnCn2GXOOwcFasEsgIaWhsdZ+fBw78Xv
        htf1alOw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pTMoI-00B2kb-1k
        for fio@vger.kernel.org;
        Sat, 18 Feb 2023 13:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E14321BC016C; Sat, 18 Feb 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230218130001.E14321BC016C@kernel.dk>
Date:   Sat, 18 Feb 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit ded6cce8274ccf6f3820fb19ab46fd6d2aed0311:

  Merge branch 'Read_Stats_Not_Reported_For_Timed_Backlog_Verifies' of github.com:horshack-dpreview/fio (2023-02-15 12:49:31 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f9fc7a27cae5ea2dbb310c05f7b693c68ba15537:

  backend: fix runtime when used with thinktime (2023-02-17 19:52:50 -0700)

----------------------------------------------------------------
Ankit Kumar (1):
      backend: fix runtime when used with thinktime

Jens Axboe (1):
      Get rid of O_ATOMIC

Vincent Fu (3):
      iolog: handle trim commands when reading iologs
      filesetup: don't skip flags for trim workloads
      Merge branch 'remove_pmemblk_engine' of github.com:osalyk/fio

osalyk (1):
      pmemblk: remove pmemblk engine

 HOWTO.rst               |  11 --
 Makefile                |   5 -
 backend.c               |  28 ++-
 ci/actions-install.sh   |   1 -
 configure               |  41 -----
 engines/ime.c           |   4 -
 engines/libzbc.c        |   6 -
 engines/pmemblk.c       | 449 ------------------------------------------------
 examples/pmemblk.fio    |  71 --------
 examples/pmemblk.png    | Bin 107529 -> 0 bytes
 filesetup.c             |  10 --
 fio.1                   |  10 --
 init.c                  |   6 -
 iolog.c                 |  27 ++-
 memory.c                |   4 +-
 options.c               |   6 -
 os/os-linux.h           |   6 -
 os/os.h                 |   6 -
 os/windows/examples.wxs |   4 -
 19 files changed, 42 insertions(+), 653 deletions(-)
 delete mode 100644 engines/pmemblk.c
 delete mode 100644 examples/pmemblk.fio
 delete mode 100644 examples/pmemblk.png

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 158c5d89..7a0535af 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1110,12 +1110,6 @@ I/O type
 	OpenBSD and ZFS on Solaris don't support direct I/O.  On Windows the synchronous
 	ioengines don't support direct I/O.  Default: false.
 
-.. option:: atomic=bool
-
-	If value is true, attempt to use atomic direct I/O. Atomic writes are
-	guaranteed to be stable once acknowledged by the operating system. Only
-	Linux supports O_ATOMIC right now.
-
 .. option:: buffered=bool
 
 	If value is true, use buffered I/O. This is the opposite of the
@@ -2147,11 +2141,6 @@ I/O engine
 			before overwriting. The `trimwrite` mode works well for this
 			constraint.
 
-		**pmemblk**
-			Read and write using filesystem DAX to a file on a filesystem
-			mounted with DAX on a persistent memory device through the PMDK
-			libpmemblk library.
-
 		**dev-dax**
 			Read and write using device DAX to a persistent memory device (e.g.,
 			/dev/dax0.0) through the PMDK libpmem library.
diff --git a/Makefile b/Makefile
index 5f4e6562..e4cde4ba 100644
--- a/Makefile
+++ b/Makefile
@@ -208,11 +208,6 @@ ifdef CONFIG_MTD
   SOURCE += oslib/libmtd.c
   SOURCE += oslib/libmtd_legacy.c
 endif
-ifdef CONFIG_PMEMBLK
-  pmemblk_SRCS = engines/pmemblk.c
-  pmemblk_LIBS = -lpmemblk
-  ENGINES += pmemblk
-endif
 ifdef CONFIG_LINUX_DEVDAX
   dev-dax_SRCS = engines/dev-dax.c
   dev-dax_LIBS = -lpmem
diff --git a/backend.c b/backend.c
index 0ccc7c2b..cb1fbf42 100644
--- a/backend.c
+++ b/backend.c
@@ -866,6 +866,7 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 			     struct timespec *time)
 {
 	unsigned long long b;
+	unsigned long long runtime_left;
 	uint64_t total;
 	int left;
 	struct timespec now;
@@ -874,7 +875,7 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 	if (td->o.thinktime_iotime) {
 		fio_gettime(&now, NULL);
 		if (utime_since(&td->last_thinktime, &now)
-		    >= td->o.thinktime_iotime + td->o.thinktime) {
+		    >= td->o.thinktime_iotime) {
 			stall = true;
 		} else if (!fio_option_is_set(&td->o, thinktime_blocks)) {
 			/*
@@ -897,11 +898,24 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 
 	io_u_quiesce(td);
 
+	left = td->o.thinktime_spin;
+	if (td->o.timeout) {
+		runtime_left = td->o.timeout - utime_since_now(&td->epoch);
+		if (runtime_left < (unsigned long long)left)
+			left = runtime_left;
+	}
+
 	total = 0;
-	if (td->o.thinktime_spin)
-		total = usec_spin(td->o.thinktime_spin);
+	if (left)
+		total = usec_spin(left);
 
 	left = td->o.thinktime - total;
+	if (td->o.timeout) {
+		runtime_left = td->o.timeout - utime_since_now(&td->epoch);
+		if (runtime_left < (unsigned long long)left)
+			left = runtime_left;
+	}
+
 	if (left)
 		total += usec_sleep(td, left);
 
@@ -930,8 +944,10 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 		fio_gettime(time, NULL);
 
 	td->last_thinktime_blocks = b;
-	if (td->o.thinktime_iotime)
+	if (td->o.thinktime_iotime) {
+		fio_gettime(&now, NULL);
 		td->last_thinktime = now;
+	}
 }
 
 /*
@@ -1333,7 +1349,7 @@ int init_io_u_buffers(struct thread_data *td)
 	 * overflow later. this adjustment may be too much if we get
 	 * lucky and the allocator gives us an aligned address.
 	 */
-	if (td->o.odirect || td->o.mem_align || td->o.oatomic ||
+	if (td->o.odirect || td->o.mem_align ||
 	    td_ioengine_flagged(td, FIO_RAWIO))
 		td->orig_buffer_size += page_mask + td->o.mem_align;
 
@@ -1352,7 +1368,7 @@ int init_io_u_buffers(struct thread_data *td)
 	if (data_xfer && allocate_io_mem(td))
 		return 1;
 
-	if (td->o.odirect || td->o.mem_align || td->o.oatomic ||
+	if (td->o.odirect || td->o.mem_align ||
 	    td_ioengine_flagged(td, FIO_RAWIO))
 		p = PTR_ALIGN(td->orig_buffer, page_mask) + td->o.mem_align;
 	else
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index c16dff16..5057fca3 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -45,7 +45,6 @@ DPKGCFG
                 libnbd-dev
                 libpmem-dev
                 libpmem2-dev
-                libpmemblk-dev
                 libprotobuf-c-dev
                 librbd-dev
                 libtcmalloc-minimal4
diff --git a/configure b/configure
index 182cd3c3..0d02bce8 100755
--- a/configure
+++ b/configure
@@ -163,7 +163,6 @@ show_help="no"
 exit_val=0
 gfio_check="no"
 libhdfs="no"
-pmemblk="no"
 devdax="no"
 pmem="no"
 cuda="no"
@@ -2229,43 +2228,6 @@ if compile_prog "" "-lpmem2" "libpmem2"; then
 fi
 print_config "libpmem2" "$libpmem2"
 
-##########################################
-# Check whether we have libpmemblk
-# libpmem is a prerequisite
-if test "$libpmemblk" != "yes" ; then
-  libpmemblk="no"
-fi
-if test "$libpmem" = "yes"; then
-  cat > $TMPC << EOF
-#include <libpmemblk.h>
-int main(int argc, char **argv)
-{
-  PMEMblkpool *pbp;
-  pbp = pmemblk_open("", 0);
-  return 0;
-}
-EOF
-  if compile_prog "" "-lpmemblk" "libpmemblk"; then
-    libpmemblk="yes"
-  fi
-fi
-print_config "libpmemblk" "$libpmemblk"
-
-# Choose libpmem-based ioengines
-if test "$libpmem" = "yes" && test "$disable_pmem" = "no"; then
-  devdax="yes"
-  if test "$libpmem1_5" = "yes"; then
-    pmem="yes"
-  fi
-  if test "$libpmemblk" = "yes"; then
-    pmemblk="yes"
-  fi
-fi
-
-##########################################
-# Report whether pmemblk engine is enabled
-print_config "PMDK pmemblk engine" "$pmemblk"
-
 ##########################################
 # Report whether dev-dax engine is enabled
 print_config "PMDK dev-dax engine" "$devdax"
@@ -3191,9 +3153,6 @@ fi
 if test "$mtd" = "yes" ; then
   output_sym "CONFIG_MTD"
 fi
-if test "$pmemblk" = "yes" ; then
-  output_sym "CONFIG_PMEMBLK"
-fi
 if test "$devdax" = "yes" ; then
   output_sym "CONFIG_LINUX_DEVDAX"
 fi
diff --git a/engines/ime.c b/engines/ime.c
index f6690cc1..037b8419 100644
--- a/engines/ime.c
+++ b/engines/ime.c
@@ -188,10 +188,6 @@ static int fio_ime_open_file(struct thread_data *td, struct fio_file *f)
 		return 1;
 	}
 
-	if (td->o.oatomic) {
-		td_verror(td, EINVAL, "IME does not support atomic IO");
-		return 1;
-	}
 	if (td->o.odirect)
 		flags |= O_DIRECT;
 	flags |= td->o.sync_io;
diff --git a/engines/libzbc.c b/engines/libzbc.c
index cb3e9ca5..1bf1e8c8 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -71,12 +71,6 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 			flags |= O_RDONLY;
 	}
 
-	if (td->o.oatomic) {
-		td_verror(td, EINVAL, "libzbc does not support O_ATOMIC");
-		log_err("%s: libzbc does not support O_ATOMIC\n", f->file_name);
-		return -EINVAL;
-	}
-
 	ld = calloc(1, sizeof(*ld));
 	if (!ld)
 		return -ENOMEM;
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
deleted file mode 100644
index 849d8a15..00000000
--- a/engines/pmemblk.c
+++ /dev/null
@@ -1,449 +0,0 @@
-/*
- * pmemblk: IO engine that uses PMDK libpmemblk to read and write data
- *
- * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License,
- * version 2 as published by the Free Software Foundation..
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the Free
- * Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
- * Boston, MA 02110-1301, USA.
- */
-
-/*
- * pmemblk engine
- *
- * IO engine that uses libpmemblk to read and write data
- *
- * To use:
- *   ioengine=pmemblk
- *
- * Other relevant settings:
- *   thread=1   REQUIRED
- *   iodepth=1
- *   direct=1
- *   unlink=1
- *   filename=/mnt/pmem0/fiotestfile,BSIZE,FSIZEMiB
- *
- *   thread must be set to 1 for pmemblk as multiple processes cannot
- *     open the same block pool file.
- *
- *   iodepth should be set to 1 as pmemblk is always synchronous.
- *   Use numjobs to scale up.
- *
- *   direct=1 is implied as pmemblk is always direct. A warning message
- *   is printed if this is not specified.
- *
- *   unlink=1 removes the block pool file after testing, and is optional.
- *
- *   The pmem device must have a DAX-capable filesystem and be mounted
- *   with DAX enabled.  filename must point to a file on that filesystem.
- *
- *   Example:
- *     mkfs.xfs /dev/pmem0
- *     mkdir /mnt/pmem0
- *     mount -o dax /dev/pmem0 /mnt/pmem0
- *
- *   When specifying the filename, if the block pool file does not already
- *   exist, then the pmemblk engine creates the pool file if you specify
- *   the block and file sizes.  BSIZE is the block size in bytes.
- *   FSIZEMB is the pool file size in MiB.
- *
- *   See examples/pmemblk.fio for more.
- *
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <sys/uio.h>
-#include <errno.h>
-#include <assert.h>
-#include <string.h>
-#include <libpmem.h>
-#include <libpmemblk.h>
-
-#include "../fio.h"
-
-/*
- * libpmemblk
- */
-typedef struct fio_pmemblk_file *fio_pmemblk_file_t;
-
-struct fio_pmemblk_file {
-	fio_pmemblk_file_t pmb_next;
-	char *pmb_filename;
-	uint64_t pmb_refcnt;
-	PMEMblkpool *pmb_pool;
-	size_t pmb_bsize;
-	size_t pmb_nblocks;
-};
-
-static fio_pmemblk_file_t Cache;
-
-static pthread_mutex_t CacheLock = PTHREAD_MUTEX_INITIALIZER;
-
-#define PMB_CREATE   (0x0001)	/* should create file */
-
-fio_pmemblk_file_t fio_pmemblk_cache_lookup(const char *filename)
-{
-	fio_pmemblk_file_t i;
-
-	for (i = Cache; i != NULL; i = i->pmb_next)
-		if (!strcmp(filename, i->pmb_filename))
-			return i;
-
-	return NULL;
-}
-
-static void fio_pmemblk_cache_insert(fio_pmemblk_file_t pmb)
-{
-	pmb->pmb_next = Cache;
-	Cache = pmb;
-}
-
-static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
-{
-	fio_pmemblk_file_t i;
-
-	if (pmb == Cache) {
-		Cache = Cache->pmb_next;
-		pmb->pmb_next = NULL;
-		return;
-	}
-
-	for (i = Cache; i != NULL; i = i->pmb_next)
-		if (pmb == i->pmb_next) {
-			i->pmb_next = i->pmb_next->pmb_next;
-			pmb->pmb_next = NULL;
-			return;
-		}
-}
-
-/*
- * to control block size and gross file size at the libpmemblk
- * level, we allow the block size and file size to be appended
- * to the file name:
- *
- *   path[,bsize,fsizemib]
- *
- * note that we do not use the fio option "filesize" to dictate
- * the file size because we can only give libpmemblk the gross
- * file size, which is different from the net or usable file
- * size (which is probably what fio wants).
- *
- * the final path without the parameters is returned in ppath.
- * the block size and file size are returned in pbsize and fsize.
- *
- * note that the user specifies the file size in MiB, but
- * we return bytes from here.
- */
-static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
-			   uint64_t *pfsize)
-{
-	char *path;
-	char *s;
-	uint64_t bsize;
-	uint64_t fsizemib;
-
-	path = strdup(pathspec);
-	if (!path) {
-		*ppath = NULL;
-		return;
-	}
-
-	/* extract sizes, if given */
-	s = strrchr(path, ',');
-	if (s && (fsizemib = strtoull(s + 1, NULL, 10))) {
-		*s = 0;
-		s = strrchr(path, ',');
-		if (s && (bsize = strtoull(s + 1, NULL, 10))) {
-			*s = 0;
-			*ppath = path;
-			*pbsize = bsize;
-			*pfsize = fsizemib << 20;
-			return;
-		}
-	}
-
-	/* size specs not found */
-	strcpy(path, pathspec);
-	*ppath = path;
-	*pbsize = 0;
-	*pfsize = 0;
-}
-
-static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
-{
-	fio_pmemblk_file_t pmb;
-	char *path = NULL;
-	uint64_t bsize = 0;
-	uint64_t fsize = 0;
-
-	pmb_parse_path(pathspec, &path, &bsize, &fsize);
-	if (!path)
-		return NULL;
-
-	pthread_mutex_lock(&CacheLock);
-
-	pmb = fio_pmemblk_cache_lookup(path);
-	if (!pmb) {
-		pmb = malloc(sizeof(*pmb));
-		if (!pmb)
-			goto error;
-
-		/* try opening existing first, create it if needed */
-		pmb->pmb_pool = pmemblk_open(path, bsize);
-		if (!pmb->pmb_pool && (errno == ENOENT) &&
-		    (flags & PMB_CREATE) && (0 < fsize) && (0 < bsize)) {
-			pmb->pmb_pool =
-			    pmemblk_create(path, bsize, fsize, 0644);
-		}
-		if (!pmb->pmb_pool) {
-			log_err("pmemblk: unable to open pmemblk pool file %s (%s)\n",
-			     path, strerror(errno));
-			goto error;
-		}
-
-		pmb->pmb_filename = path;
-		pmb->pmb_next = NULL;
-		pmb->pmb_refcnt = 0;
-		pmb->pmb_bsize = pmemblk_bsize(pmb->pmb_pool);
-		pmb->pmb_nblocks = pmemblk_nblock(pmb->pmb_pool);
-
-		fio_pmemblk_cache_insert(pmb);
-	} else {
-		free(path);
-	}
-
-	pmb->pmb_refcnt += 1;
-
-	pthread_mutex_unlock(&CacheLock);
-
-	return pmb;
-
-error:
-	if (pmb) {
-		if (pmb->pmb_pool)
-			pmemblk_close(pmb->pmb_pool);
-		pmb->pmb_pool = NULL;
-		pmb->pmb_filename = NULL;
-		free(pmb);
-	}
-	if (path)
-		free(path);
-
-	pthread_mutex_unlock(&CacheLock);
-	return NULL;
-}
-
-static void pmb_close(fio_pmemblk_file_t pmb, const bool keep)
-{
-	pthread_mutex_lock(&CacheLock);
-
-	pmb->pmb_refcnt--;
-
-	if (!keep && !pmb->pmb_refcnt) {
-		pmemblk_close(pmb->pmb_pool);
-		pmb->pmb_pool = NULL;
-		free(pmb->pmb_filename);
-		pmb->pmb_filename = NULL;
-		fio_pmemblk_cache_remove(pmb);
-		free(pmb);
-	}
-
-	pthread_mutex_unlock(&CacheLock);
-}
-
-static int pmb_get_flags(struct thread_data *td, uint64_t *pflags)
-{
-	static int thread_warned = 0;
-	static int odirect_warned = 0;
-
-	uint64_t flags = 0;
-
-	if (!td->o.use_thread) {
-		if (!thread_warned) {
-			thread_warned = 1;
-			log_err("pmemblk: must set thread=1 for pmemblk engine\n");
-		}
-		return 1;
-	}
-
-	if (!td->o.odirect && !odirect_warned) {
-		odirect_warned = 1;
-		log_info("pmemblk: direct == 0, but pmemblk is always direct\n");
-	}
-
-	if (td->o.allow_create)
-		flags |= PMB_CREATE;
-
-	(*pflags) = flags;
-	return 0;
-}
-
-static int fio_pmemblk_open_file(struct thread_data *td, struct fio_file *f)
-{
-	uint64_t flags = 0;
-	fio_pmemblk_file_t pmb;
-
-	if (pmb_get_flags(td, &flags))
-		return 1;
-
-	pmb = pmb_open(f->file_name, flags);
-	if (!pmb)
-		return 1;
-
-	FILE_SET_ENG_DATA(f, pmb);
-	return 0;
-}
-
-static int fio_pmemblk_close_file(struct thread_data fio_unused *td,
-				  struct fio_file *f)
-{
-	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
-
-	if (pmb)
-		pmb_close(pmb, false);
-
-	FILE_SET_ENG_DATA(f, NULL);
-	return 0;
-}
-
-static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
-{
-	uint64_t flags = 0;
-	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
-
-	if (fio_file_size_known(f))
-		return 0;
-
-	if (!pmb) {
-		if (pmb_get_flags(td, &flags))
-			return 1;
-		pmb = pmb_open(f->file_name, flags);
-		if (!pmb)
-			return 1;
-	}
-
-	f->real_file_size = pmb->pmb_bsize * pmb->pmb_nblocks;
-
-	fio_file_set_size_known(f);
-
-	if (!FILE_ENG_DATA(f))
-		pmb_close(pmb, true);
-
-	return 0;
-}
-
-static enum fio_q_status fio_pmemblk_queue(struct thread_data *td,
-					   struct io_u *io_u)
-{
-	struct fio_file *f = io_u->file;
-	fio_pmemblk_file_t pmb = FILE_ENG_DATA(f);
-
-	unsigned long long off;
-	unsigned long len;
-	void *buf;
-
-	fio_ro_check(td, io_u);
-
-	switch (io_u->ddir) {
-	case DDIR_READ:
-	case DDIR_WRITE:
-		off = io_u->offset;
-		len = io_u->xfer_buflen;
-
-		io_u->error = EINVAL;
-		if (off % pmb->pmb_bsize)
-			break;
-		if (len % pmb->pmb_bsize)
-			break;
-		if ((off + len) / pmb->pmb_bsize > pmb->pmb_nblocks)
-			break;
-
-		io_u->error = 0;
-		buf = io_u->xfer_buf;
-		off /= pmb->pmb_bsize;
-		len /= pmb->pmb_bsize;
-		while (0 < len) {
-			if (io_u->ddir == DDIR_READ) {
-				if (0 != pmemblk_read(pmb->pmb_pool, buf, off)) {
-					io_u->error = errno;
-					break;
-				}
-			} else if (0 != pmemblk_write(pmb->pmb_pool, buf, off)) {
-				io_u->error = errno;
-				break;
-			}
-			buf += pmb->pmb_bsize;
-			off++;
-			len--;
-		}
-		off *= pmb->pmb_bsize;
-		len *= pmb->pmb_bsize;
-		io_u->resid = io_u->xfer_buflen - (off - io_u->offset);
-		break;
-	case DDIR_SYNC:
-	case DDIR_DATASYNC:
-	case DDIR_SYNC_FILE_RANGE:
-		/* we're always sync'd */
-		io_u->error = 0;
-		break;
-	default:
-		io_u->error = EINVAL;
-		break;
-	}
-
-	return FIO_Q_COMPLETED;
-}
-
-static int fio_pmemblk_unlink_file(struct thread_data *td, struct fio_file *f)
-{
-	char *path = NULL;
-	uint64_t bsize = 0;
-	uint64_t fsize = 0;
-
-	/*
-	 * we need our own unlink in case the user has specified
-	 * the block and file sizes in the path name.  we parse
-	 * the file_name to determine the file name we actually used.
-	 */
-
-	pmb_parse_path(f->file_name, &path, &bsize, &fsize);
-	if (!path)
-		return ENOENT;
-
-	unlink(path);
-	free(path);
-	return 0;
-}
-
-FIO_STATIC struct ioengine_ops ioengine = {
-	.name = "pmemblk",
-	.version = FIO_IOOPS_VERSION,
-	.queue = fio_pmemblk_queue,
-	.open_file = fio_pmemblk_open_file,
-	.close_file = fio_pmemblk_close_file,
-	.get_file_size = fio_pmemblk_get_file_size,
-	.unlink_file = fio_pmemblk_unlink_file,
-	.flags = FIO_SYNCIO | FIO_DISKLESSIO | FIO_NOEXTEND | FIO_NODISKUTIL,
-};
-
-static void fio_init fio_pmemblk_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_pmemblk_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
diff --git a/examples/pmemblk.fio b/examples/pmemblk.fio
deleted file mode 100644
index 59bb2a8a..00000000
--- a/examples/pmemblk.fio
+++ /dev/null
@@ -1,71 +0,0 @@
-[global]
-bs=1m
-ioengine=pmemblk
-norandommap
-time_based
-runtime=30
-group_reporting
-disable_lat=1
-disable_slat=1
-disable_clat=1
-clat_percentiles=0
-cpus_allowed_policy=split
-
-# For the pmemblk engine:
-#
-#   IOs always complete immediately
-#   IOs are always direct
-#   Must use threads
-#
-iodepth=1
-direct=1
-thread
-numjobs=16
-#
-# Unlink can be used to remove the files when done, but if you are
-# using serial runs with stonewall, and you want the files to be created
-# only once and unlinked only at the very end, then put the unlink=1
-# in the last group.  This is the method demonstrated here.
-#
-# Note that if you have a read-only group and if the files will be
-# newly created, then all of the data will read back as zero and the
-# read will be optimized, yielding performance that is different from
-# that of reading non-zero blocks (or unoptimized zero blocks).
-#
-unlink=0
-#
-# The pmemblk engine does IO to files in a DAX-mounted filesystem.
-# The filesystem should be created on an NVDIMM (e.g /dev/pmem0)
-# and then mounted with the '-o dax' option.  Note that the engine
-# accesses the underlying NVDIMM directly, bypassing the kernel block
-# layer, so the usual filesystem/disk performance monitoring tools such
-# as iostat will not provide useful data.
-#
-# Here we specify a test file on each of two NVDIMMs.  The first
-# number after the file name is the block size in bytes (4096 bytes
-# in this example).  The second number is the size of the file to
-# create in MiB (1 GiB in this example); note that the actual usable
-# space available to fio will be less than this as libpmemblk requires
-# some space for metadata.
-#
-# Currently, the minimum block size is 512 bytes and the minimum file
-# size is about 17 MiB (these are libpmemblk requirements).
-#
-# While both files in this example have the same block size and file
-# size, this is not required.
-#
-filename=/pmem0/fio-test,4096,1024
-#filename=/pmem1/fio-test,4096,1024
-
-[pmemblk-write]
-rw=randwrite
-stonewall
-
-[pmemblk-read]
-rw=randread
-stonewall
-#
-# We're done, so unlink the file:
-#
-unlink=1
-
diff --git a/examples/pmemblk.png b/examples/pmemblk.png
deleted file mode 100644
index 250e254b..00000000
Binary files a/examples/pmemblk.png and /dev/null differ
diff --git a/filesetup.c b/filesetup.c
index cb7047c5..648f48c6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -737,21 +737,11 @@ int generic_open_file(struct thread_data *td, struct fio_file *f)
 			f_out = stderr;
 	}
 
-	if (td_trim(td))
-		goto skip_flags;
 	if (td->o.odirect)
 		flags |= OS_O_DIRECT;
-	if (td->o.oatomic) {
-		if (!FIO_O_ATOMIC) {
-			td_verror(td, EINVAL, "OS does not support atomic IO");
-			return 1;
-		}
-		flags |= OS_O_DIRECT | FIO_O_ATOMIC;
-	}
 	flags |= td->o.sync_io;
 	if (td->o.create_on_open && td->o.allow_create)
 		flags |= O_CREAT;
-skip_flags:
 	if (f->filetype != FIO_TYPE_FILE)
 		flags |= FIO_O_NOATIME;
 
diff --git a/fio.1 b/fio.1
index 00a09353..e94fad0a 100644
--- a/fio.1
+++ b/fio.1
@@ -873,11 +873,6 @@ If value is true, use non-buffered I/O. This is usually O_DIRECT. Note that
 OpenBSD and ZFS on Solaris don't support direct I/O. On Windows the synchronous
 ioengines don't support direct I/O. Default: false.
 .TP
-.BI atomic \fR=\fPbool
-If value is true, attempt to use atomic direct I/O. Atomic writes are
-guaranteed to be stable once acknowledged by the operating system. Only
-Linux supports O_ATOMIC right now.
-.TP
 .BI buffered \fR=\fPbool
 If value is true, use buffered I/O. This is the opposite of the
 \fBdirect\fR option. Defaults to true.
@@ -1959,11 +1954,6 @@ e.g., on NAND, writing sequentially to erase blocks and discarding
 before overwriting. The \fBtrimwrite\fR mode works well for this
 constraint.
 .TP
-.B pmemblk
-Read and write using filesystem DAX to a file on a filesystem
-mounted with DAX on a persistent memory device through the PMDK
-libpmemblk library.
-.TP
 .B dev\-dax
 Read and write using device DAX to a persistent memory device (e.g.,
 /dev/dax0.0) through the PMDK libpmem library.
diff --git a/init.c b/init.c
index f6a8056a..78c6c803 100644
--- a/init.c
+++ b/init.c
@@ -916,12 +916,6 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
-	/*
-	 * O_ATOMIC implies O_DIRECT
-	 */
-	if (o->oatomic)
-		o->odirect = 1;
-
 	/*
 	 * If randseed is set, that overrides randrepeat
 	 */
diff --git a/iolog.c b/iolog.c
index 3b296cd7..ea779632 100644
--- a/iolog.c
+++ b/iolog.c
@@ -439,7 +439,7 @@ static bool read_iolog(struct thread_data *td)
 	unsigned long long offset;
 	unsigned int bytes;
 	unsigned long long delay = 0;
-	int reads, writes, waits, fileno = 0, file_action = 0; /* stupid gcc */
+	int reads, writes, trims, waits, fileno = 0, file_action = 0; /* stupid gcc */
 	char *rfname, *fname, *act;
 	char *str, *p;
 	enum fio_ddir rw;
@@ -461,7 +461,7 @@ static bool read_iolog(struct thread_data *td)
 	rfname = fname = malloc(256+16);
 	act = malloc(256+16);
 
-	syncs = reads = writes = waits = 0;
+	syncs = reads = writes = trims = waits = 0;
 	while ((p = fgets(str, 4096, td->io_log_rfile)) != NULL) {
 		struct io_piece *ipo;
 		int r;
@@ -552,6 +552,13 @@ static bool read_iolog(struct thread_data *td)
 			if (read_only)
 				continue;
 			writes++;
+		} else if (rw == DDIR_TRIM) {
+			/*
+			 * Don't add a trim for ro mode
+			 */
+			if (read_only)
+				continue;
+			trims++;
 		} else if (rw == DDIR_WAIT) {
 			if (td->o.no_stall)
 				continue;
@@ -634,14 +641,16 @@ static bool read_iolog(struct thread_data *td)
 		return true;
 	}
 
-	if (!reads && !writes && !waits)
+	if (!reads && !writes && !waits && !trims)
 		return false;
-	else if (reads && !writes)
-		td->o.td_ddir = TD_DDIR_READ;
-	else if (!reads && writes)
-		td->o.td_ddir = TD_DDIR_WRITE;
-	else
-		td->o.td_ddir = TD_DDIR_RW;
+
+	td->o.td_ddir = 0;
+	if (reads)
+		td->o.td_ddir |= TD_DDIR_READ;
+	if (writes)
+		td->o.td_ddir |= TD_DDIR_WRITE;
+	if (trims)
+		td->o.td_ddir |= TD_DDIR_TRIM;
 
 	return true;
 }
diff --git a/memory.c b/memory.c
index 577d3dd5..2fdca657 100644
--- a/memory.c
+++ b/memory.c
@@ -295,7 +295,7 @@ int allocate_io_mem(struct thread_data *td)
 
 	total_mem = td->orig_buffer_size;
 
-	if (td->o.odirect || td->o.mem_align || td->o.oatomic ||
+	if (td->o.odirect || td->o.mem_align ||
 	    td_ioengine_flagged(td, FIO_MEMALIGN)) {
 		total_mem += page_mask;
 		if (td->o.mem_align && td->o.mem_align > page_size)
@@ -341,7 +341,7 @@ void free_io_mem(struct thread_data *td)
 	unsigned int total_mem;
 
 	total_mem = td->orig_buffer_size;
-	if (td->o.odirect || td->o.oatomic)
+	if (td->o.odirect)
 		total_mem += page_mask;
 
 	if (td->io_ops->iomem_alloc && !fio_option_is_set(&td->o, mem_type)) {
diff --git a/options.c b/options.c
index 49612345..536ba91c 100644
--- a/options.c
+++ b/options.c
@@ -2096,12 +2096,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Hadoop Distributed Filesystem (HDFS) engine"
 			  },
 #endif
-#ifdef CONFIG_PMEMBLK
-			  { .ival = "pmemblk",
-			    .help = "PMDK libpmemblk based IO engine",
-			  },
-
-#endif
 #ifdef CONFIG_IME
 			  { .ival = "ime_psync",
 			    .help = "DDN's IME synchronous IO engine",
diff --git a/os/os-linux.h b/os/os-linux.h
index bbb1f27c..7a78b42d 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -205,12 +205,6 @@ static inline unsigned long long os_phys_mem(void)
 #define FIO_O_NOATIME	0
 #endif
 
-#ifdef O_ATOMIC
-#define OS_O_ATOMIC	O_ATOMIC
-#else
-#define OS_O_ATOMIC	040000000
-#endif
-
 #ifdef MADV_REMOVE
 #define FIO_MADV_FREE	MADV_REMOVE
 #endif
diff --git a/os/os.h b/os/os.h
index c428260c..ebaf8af5 100644
--- a/os/os.h
+++ b/os/os.h
@@ -133,12 +133,6 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #define OS_O_DIRECT			O_DIRECT
 #endif
 
-#ifdef OS_O_ATOMIC
-#define FIO_O_ATOMIC			OS_O_ATOMIC
-#else
-#define FIO_O_ATOMIC			0
-#endif
-
 #ifndef FIO_HAVE_HUGETLB
 #define SHM_HUGETLB			0
 #define MAP_HUGETLB			0
diff --git a/os/windows/examples.wxs b/os/windows/examples.wxs
index 9308ba8b..d70c7713 100755
--- a/os/windows/examples.wxs
+++ b/os/windows/examples.wxs
@@ -125,9 +125,6 @@
                 <Component>
                   <File Source="..\..\examples\numa.fio" />
                 </Component>
-                <Component>
-                  <File Source="..\..\examples\pmemblk.fio" />
-                </Component>
                 <Component>
                   <File Source="..\..\examples\poisson-rate-submission.fio" />
                 </Component>
@@ -212,7 +209,6 @@
             <ComponentRef Id="netio_multicast.fio" />
             <ComponentRef Id="null.fio" />
             <ComponentRef Id="numa.fio" />
-            <ComponentRef Id="pmemblk.fio" />
             <ComponentRef Id="poisson_rate_submission.fio" />
             <ComponentRef Id="rados.fio"/>
             <ComponentRef Id="rand_zones.fio" />
