Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgHVMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 22 Aug 2020 08:00:08 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C303C061573
        for <fio@vger.kernel.org>; Sat, 22 Aug 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9SBp-00084j-FD
        for fio@vger.kernel.org; Sat, 22 Aug 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200822120002.2CDA21BC01B0@kernel.dk>
Date: Sat, 22 Aug 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e711df54082b5d2d739e9ee3e46a2bc23b1b3c7c:

  file: provider fio_file_free() helper (2020-08-19 13:02:42 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d836624b3a7eb3433bdf8f7193b44daacd5ba6d1:

  engines/io_uring: don't attempt to set RLIMITs (2020-08-21 16:22:43 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'adjusting-libpmem' of https://github.com/lukaszstolarczuk/fio into master
      engines/io_uring: don't attempt to set RLIMITs

��ukasz Stolarczuk (1):
      engines/libpmem: adjust for PMDK >=1.5 usage

 configure            |  30 ++-
 engines/io_uring.c   |   8 -
 engines/libpmem.c    | 501 +++++++++------------------------------------------
 examples/libpmem.fio |  17 +-
 4 files changed, 127 insertions(+), 429 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index d3997b5f..6d672fe5 100755
--- a/configure
+++ b/configure
@@ -2117,10 +2117,11 @@ if test "$libpmem" != "yes" ; then
 fi
 cat > $TMPC << EOF
 #include <libpmem.h>
+#include <stdlib.h>
 int main(int argc, char **argv)
 {
   int rc;
-  rc = pmem_is_pmem(0, 0);
+  rc = pmem_is_pmem(NULL, NULL);
   return 0;
 }
 EOF
@@ -2129,6 +2130,27 @@ if compile_prog "" "-lpmem" "libpmem"; then
 fi
 print_config "libpmem" "$libpmem"
 
+##########################################
+# Check whether libpmem's version >= 1.5
+if test "$libpmem1_5" != "yes" ; then
+  libpmem1_5="no"
+fi
+if test "$libpmem" = "yes"; then
+  cat > $TMPC << EOF
+#include <libpmem.h>
+#include <stdlib.h>
+int main(int argc, char **argv)
+{
+  pmem_memcpy(NULL, NULL, NULL, NULL);
+  return 0;
+}
+EOF
+  if compile_prog "" "-lpmem" "libpmem1_5"; then
+    libpmem1_5="yes"
+  fi
+fi
+print_config "libpmem1_5" "$libpmem1_5"
+
 ##########################################
 # Check whether we have libpmemblk
 # libpmem is a prerequisite
@@ -2151,10 +2173,12 @@ EOF
 fi
 print_config "libpmemblk" "$libpmemblk"
 
-# Choose the ioengines
+# Choose libpmem-based ioengines
 if test "$libpmem" = "yes" && test "$disable_pmem" = "no"; then
-  pmem="yes"
   devdax="yes"
+  if test "$libpmem1_5" = "yes"; then
+    pmem="yes"
+  fi
   if test "$libpmemblk" = "yes"; then
     pmemblk="yes"
   fi
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 57925594..2b1b1357 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -574,14 +574,6 @@ static int fio_ioring_queue_init(struct thread_data *td)
 	ld->ring_fd = ret;
 
 	if (o->fixedbufs) {
-		struct rlimit rlim = {
-			.rlim_cur = RLIM_INFINITY,
-			.rlim_max = RLIM_INFINITY,
-		};
-
-		if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0)
-			return -1;
-
 		ret = syscall(__NR_io_uring_register, ld->ring_fd,
 				IORING_REGISTER_BUFFERS, ld->iovecs, depth);
 		if (ret < 0)
diff --git a/engines/libpmem.c b/engines/libpmem.c
index 3f63055c..a9b3e29b 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -2,6 +2,7 @@
  * libpmem: IO engine that uses PMDK libpmem to read and write data
  *
  * Copyright (C) 2017 Nippon Telegraph and Telephone Corporation.
+ * Copyright 2018-2020, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License,
@@ -17,7 +18,7 @@
 /*
  * libpmem engine
  *
- * IO engine that uses libpmem to read and write data
+ * IO engine that uses libpmem to write data (and memcpy to read)
  *
  * To use:
  *   ioengine=libpmem
@@ -25,21 +26,23 @@
  * Other relevant settings:
  *   iodepth=1
  *   direct=1
+ *   sync=1
  *   directory=/mnt/pmem0/
  *   bs=4k
  *
- *   direct=1 means that pmem_drain() is executed for each write operation.
- *   In contrast, direct=0 means that pmem_drain() is not executed.
+ *   sync=1 means that pmem_drain() is executed for each write operation.
+ *   Otherwise is not and should be called on demand.
+ *
+ *   direct=1 means PMEM_F_MEM_NONTEMPORAL flag is set in pmem_memcpy().
  *
  *   The pmem device must have a DAX-capable filesystem and be mounted
- *   with DAX enabled. directory must point to a mount point of DAX FS.
+ *   with DAX enabled. Directory must point to a mount point of DAX FS.
  *
  *   Example:
  *     mkfs.xfs /dev/pmem0
  *     mkdir /mnt/pmem0
  *     mount -o dax /dev/pmem0 /mnt/pmem0
  *
- *
  * See examples/libpmem.fio for more.
  *
  *
@@ -47,7 +50,7 @@
  *   By default, the libpmem engine will let the system find the libpmem.so
  *   that it uses. You can use an alternative libpmem by setting the
  *   FIO_PMEM_LIB environment variable to the full path to the desired
- *   libpmem.so.
+ *   libpmem.so. This engine requires PMDK >= 1.5.
  */
 
 #include <stdio.h>
@@ -64,394 +67,117 @@
 #include "../fio.h"
 #include "../verify.h"
 
-/*
- * Limits us to 1GiB of mapped files in total to model after
- * libpmem engine behavior
- */
-#define MMAP_TOTAL_SZ   (1 * 1024 * 1024 * 1024UL)
-
 struct fio_libpmem_data {
 	void *libpmem_ptr;
 	size_t libpmem_sz;
 	off_t libpmem_off;
 };
 
-#define MEGABYTE ((uintptr_t)1 << 20)
-#define GIGABYTE ((uintptr_t)1 << 30)
-#define PROCMAXLEN 2048 /* maximum expected line length in /proc files */
-#define roundup(x, y)   ((((x) + ((y) - 1)) / (y)) * (y))
-
-static bool Mmap_no_random;
-static void *Mmap_hint;
-static unsigned long long Mmap_align;
-
-/*
- * util_map_hint_align -- choose the desired mapping alignment
- *
- * Use 2MB/1GB page alignment only if the mapping length is at least
- * twice as big as the page size.
- */
-static inline size_t util_map_hint_align(size_t len, size_t req_align)
-{
-	size_t align = Mmap_align;
-
-	dprint(FD_IO, "DEBUG util_map_hint_align\n" );
-
-	if (req_align)
-		align = req_align;
-	else if (len >= 2 * GIGABYTE)
-		align = GIGABYTE;
-	else if (len >= 4 * MEGABYTE)
-		align = 2 * MEGABYTE;
-
-	dprint(FD_IO, "align=%d\n", (int)align);
-	return align;
-}
-
-#ifdef __FreeBSD__
-static const char *sscanf_os = "%p %p";
-#define MAP_NORESERVE 0
-#define OS_MAPFILE "/proc/curproc/map"
-#else
-static const char *sscanf_os = "%p-%p";
-#define OS_MAPFILE "/proc/self/maps"
-#endif
-
-/*
- * util_map_hint_unused -- use /proc to determine a hint address for mmap()
- *
- * This is a helper function for util_map_hint().
- * It opens up /proc/self/maps and looks for the first unused address
- * in the process address space that is:
- * - greater or equal 'minaddr' argument,
- * - large enough to hold range of given length,
- * - aligned to the specified unit.
- *
- * Asking for aligned address like this will allow the DAX code to use large
- * mappings.  It is not an error if mmap() ignores the hint and chooses
- * different address.
- */
-static char *util_map_hint_unused(void *minaddr, size_t len, size_t align)
+static int fio_libpmem_init(struct thread_data *td)
 {
-	char *lo = NULL;        /* beginning of current range in maps file */
-	char *hi = NULL;        /* end of current range in maps file */
-	char *raddr = minaddr;  /* ignore regions below 'minaddr' */
-
-#ifdef WIN32
-	MEMORY_BASIC_INFORMATION mi;
-#else
-	FILE *fp;
-	char line[PROCMAXLEN];  /* for fgets() */
-#endif
-
-	dprint(FD_IO, "DEBUG util_map_hint_unused\n");
-	assert(align > 0);
-
-	if (raddr == NULL)
-		raddr += page_size;
-
-	raddr = (char *)roundup((uintptr_t)raddr, align);
-
-#ifdef WIN32
-	while ((uintptr_t)raddr < UINTPTR_MAX - len) {
-		size_t ret = VirtualQuery(raddr, &mi, sizeof(mi));
-		if (ret == 0) {
-			ERR("VirtualQuery %p", raddr);
-			return MAP_FAILED;
-		}
-		dprint(FD_IO, "addr %p len %zu state %d",
-				mi.BaseAddress, mi.RegionSize, mi.State);
-
-		if ((mi.State != MEM_FREE) || (mi.RegionSize < len)) {
-			raddr = (char *)mi.BaseAddress + mi.RegionSize;
-			raddr = (char *)roundup((uintptr_t)raddr, align);
-			dprint(FD_IO, "nearest aligned addr %p", raddr);
-		} else {
-			dprint(FD_IO, "unused region of size %zu found at %p",
-					mi.RegionSize, mi.BaseAddress);
-			return mi.BaseAddress;
-		}
-	}
-
-	dprint(FD_IO, "end of address space reached");
-	return MAP_FAILED;
-#else
-	fp = fopen(OS_MAPFILE, "r");
-	if (!fp) {
-		log_err("!%s\n", OS_MAPFILE);
-		return MAP_FAILED;
-	}
-
-	while (fgets(line, PROCMAXLEN, fp) != NULL) {
-		/* check for range line */
-		if (sscanf(line, sscanf_os, &lo, &hi) == 2) {
-			dprint(FD_IO, "%p-%p\n", lo, hi);
-			if (lo > raddr) {
-				if ((uintptr_t)(lo - raddr) >= len) {
-					dprint(FD_IO, "unused region of size "
-							"%zu found at %p\n",
-							lo - raddr, raddr);
-					break;
-				} else {
-					dprint(FD_IO, "region is too small: "
-							"%zu < %zu\n",
-							lo - raddr, len);
-				}
-			}
-
-			if (hi > raddr) {
-				raddr = (char *)roundup((uintptr_t)hi, align);
-				dprint(FD_IO, "nearest aligned addr %p\n",
-						raddr);
-			}
-
-			if (raddr == 0) {
-				dprint(FD_IO, "end of address space reached\n");
-				break;
-			}
-		}
-	}
-
-	/*
-	 * Check for a case when this is the last unused range in the address
-	 * space, but is not large enough. (very unlikely)
-	 */
-	if ((raddr != NULL) && (UINTPTR_MAX - (uintptr_t)raddr < len)) {
-		dprint(FD_IO, "end of address space reached");
-		raddr = MAP_FAILED;
-	}
-
-	fclose(fp);
-
-	dprint(FD_IO, "returning %p", raddr);
-	return raddr;
-#endif
-}
+	struct thread_options *o = &td->o;
 
-/*
- * util_map_hint -- determine hint address for mmap()
- *
- * If PMEM_MMAP_HINT environment variable is not set, we let the system to pick
- * the randomized mapping address.  Otherwise, a user-defined hint address
- * is used.
- *
- * Windows Environment:
- *   XXX - Windows doesn't support large DAX pages yet, so there is
- *   no point in aligning for the same.
- *
- * Except for Windows Environment:
- *   ALSR in 64-bit Linux kernel uses 28-bit of randomness for mmap
- *   (bit positions 12-39), which means the base mapping address is randomized
- *   within [0..1024GB] range, with 4KB granularity.  Assuming additional
- *   1GB alignment, it results in 1024 possible locations.
- *
- *   Configuring the hint address via PMEM_MMAP_HINT environment variable
- *   disables address randomization.  In such case, the function will search for
- *   the first unused, properly aligned region of given size, above the
- *   specified address.
- */
-static char *util_map_hint(size_t len, size_t req_align)
-{
-	char *addr;
-	size_t align = 0;
-	char *e = NULL;
-
-	dprint(FD_IO, "DEBUG util_map_hint\n");
-	dprint(FD_IO, "len %zu req_align %zu\n", len, req_align);
-
-	/* choose the desired alignment based on the requested length */
-	align = util_map_hint_align(len, req_align);
-
-	e = getenv("PMEM_MMAP_HINT");
-	if (e) {
-		char *endp;
-		unsigned long long val = 0;
-
-		errno = 0;
-
-		val = strtoull(e, &endp, 16);
-		if (errno || endp == e) {
-			dprint(FD_IO, "Invalid PMEM_MMAP_HINT\n");
-		} else {
-			Mmap_hint = (void *)val;
-			Mmap_no_random = true;
-			dprint(FD_IO, "PMEM_MMAP_HINT set to %p\n", Mmap_hint);
-		}
-	}
+	dprint(FD_IO,"o->rw_min_bs %llu \n o->fsync_blocks %u \n o->fdatasync_blocks %u \n",
+			o->rw_min_bs,o->fsync_blocks,o->fdatasync_blocks);
+	dprint(FD_IO, "DEBUG fio_libpmem_init\n");
 
-	if (Mmap_no_random) {
-		dprint(FD_IO, "user-defined hint %p\n", (void *)Mmap_hint);
-		addr = util_map_hint_unused((void *)Mmap_hint, len, align);
-	} else {
-		/*
-		 * Create dummy mapping to find an unused region of given size.
-		 * * Request for increased size for later address alignment.
-		 *
-		 * Windows Environment: 
-		 *   Use MAP_NORESERVE flag to only reserve the range of pages
-		 *   rather than commit.  We don't want the pages to be actually
-		 *   backed by the operating system paging file, as the swap
-		 *   file is usually too small to handle terabyte pools.
-		 *
-		 * Except for Windows Environment:
-		 *   Use MAP_PRIVATE with read-only access to simulate
-		 *   zero cost for overcommit accounting.  Note: MAP_NORESERVE
-		 *   flag is ignored if overcommit is disabled (mode 2).
-		 */
-#ifndef WIN32
-		addr = mmap(NULL, len + align, PROT_READ,
-				MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
-#else
-		addr = mmap(NULL, len + align, PROT_READ,
-				MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0);
-#endif
-		if (addr != MAP_FAILED) {
-			dprint(FD_IO, "system choice %p\n", addr);
-			munmap(addr, len + align);
-			addr = (char *)roundup((uintptr_t)addr, align);
-		}
+	if ((o->rw_min_bs & page_mask) &&
+	    (o->fsync_blocks || o->fdatasync_blocks)) {
+		log_err("libpmem: mmap options dictate a minimum block size of "
+				"%llu bytes\n",	(unsigned long long) page_size);
+		return 1;
 	}
-
-	dprint(FD_IO, "hint %p\n", addr);
-
-	return addr;
+	return 0;
 }
 
 /*
- * This is the mmap execution function
+ * This is the pmem_map_file execution function
  */
 static int fio_libpmem_file(struct thread_data *td, struct fio_file *f,
 			    size_t length, off_t off)
 {
 	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
-	int flags = 0;
-	void *addr = NULL;
-
-	dprint(FD_IO, "DEBUG fio_libpmem_file\n");
-
-	if (td_rw(td))
-		flags = PROT_READ | PROT_WRITE;
-	else if (td_write(td)) {
-		flags = PROT_WRITE;
+	mode_t mode = 0;
+	size_t mapped_len;
+	int is_pmem;
 
-		if (td->o.verify != VERIFY_NONE)
-			flags |= PROT_READ;
-	} else
-		flags = PROT_READ;
+	if(td_rw(td))
+		mode = S_IWUSR | S_IRUSR;
+	else if (td_write(td))
+		mode = S_IWUSR;
+	else
+		mode = S_IRUSR;
 
-	dprint(FD_IO, "f->file_name = %s  td->o.verify = %d \n", f->file_name,
+	dprint(FD_IO, "DEBUG fio_libpmem_file\n");
+	dprint(FD_IO, "f->file_name = %s td->o.verify = %d \n", f->file_name,
 			td->o.verify);
-	dprint(FD_IO, "length = %ld  flags = %d  f->fd = %d off = %ld \n",
-			length, flags, f->fd,off);
-
-	addr = util_map_hint(length, 0);
+	dprint(FD_IO, "length = %ld f->fd = %d off = %ld file mode = %d \n",
+			length, f->fd, off, mode);
 
-	fdd->libpmem_ptr = mmap(addr, length, flags, MAP_SHARED, f->fd, off);
-	if (fdd->libpmem_ptr == MAP_FAILED) {
+	/* unmap any existing mapping */
+	if (fdd->libpmem_ptr) {
+		dprint(FD_IO,"pmem_unmap \n");
+		if (pmem_unmap(fdd->libpmem_ptr, fdd->libpmem_sz) < 0)
+			return errno;
 		fdd->libpmem_ptr = NULL;
-		td_verror(td, errno, "mmap");
 	}
 
-	if (td->error && fdd->libpmem_ptr)
-		munmap(fdd->libpmem_ptr, length);
-
-	return td->error;
-}
-
-/*
- * XXX Just mmap an appropriate portion, we cannot mmap the full extent
- */
-static int fio_libpmem_prep_limited(struct thread_data *td, struct io_u *io_u)
-{
-	struct fio_file *f = io_u->file;
-	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
-
-	dprint(FD_IO, "DEBUG fio_libpmem_prep_limited\n" );
-
-	if (io_u->buflen > f->real_file_size) {
-		log_err("libpmem: bs too big for libpmem engine\n");
-		return EIO;
+	if((fdd->libpmem_ptr = pmem_map_file(f->file_name, length, PMEM_FILE_CREATE, mode, &mapped_len, &is_pmem)) == NULL) {
+		td_verror(td, errno, pmem_errormsg());
+		goto err;
 	}
 
-	fdd->libpmem_sz = min(MMAP_TOTAL_SZ, f->real_file_size);
-	if (fdd->libpmem_sz > f->io_size)
-		fdd->libpmem_sz = f->io_size;
+	if (!is_pmem) {
+		td_verror(td, errno, "file_name does not point to persistent memory");
+	}
 
-	fdd->libpmem_off = io_u->offset;
+err:
+	if (td->error && fdd->libpmem_ptr)
+		pmem_unmap(fdd->libpmem_ptr, length);
 
-	return fio_libpmem_file(td, f, fdd->libpmem_sz, fdd->libpmem_off);
+	return td->error;
 }
 
-/*
- * Attempt to mmap the entire file
- */
-static int fio_libpmem_prep_full(struct thread_data *td, struct io_u *io_u)
+static int fio_libpmem_open_file(struct thread_data *td, struct fio_file *f)
 {
-	struct fio_file *f = io_u->file;
-	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
-	int ret;
-
-	dprint(FD_IO, "DEBUG fio_libpmem_prep_full\n" );
+	struct fio_libpmem_data *fdd;
 
-	if (fio_file_partial_mmap(f))
-		return EINVAL;
+	dprint(FD_IO,"DEBUG fio_libpmem_open_file\n");
+	dprint(FD_IO,"f->io_size=%ld \n",f->io_size);
+	dprint(FD_IO,"td->o.size=%lld \n",td->o.size);
+	dprint(FD_IO,"td->o.iodepth=%d\n",td->o.iodepth);
+	dprint(FD_IO,"td->o.iodepth_batch=%d \n",td->o.iodepth_batch);
 
-	dprint(FD_IO," f->io_size %ld : io_u->offset %lld \n",
-			f->io_size, io_u->offset);
+	if (fio_file_open(f))
+		td_io_close_file(td, f);
 
-	if (io_u->offset != (size_t) io_u->offset ||
-	    f->io_size != (size_t) f->io_size) {
-		fio_file_set_partial_mmap(f);
-		return EINVAL;
+	fdd = calloc(1, sizeof(*fdd));
+	if (!fdd) {
+		return 1;
 	}
+	FILE_SET_ENG_DATA(f, fdd);
 	fdd->libpmem_sz = f->io_size;
 	fdd->libpmem_off = 0;
 
-	ret = fio_libpmem_file(td, f, fdd->libpmem_sz, fdd->libpmem_off);
-	if (ret)
-		fio_file_set_partial_mmap(f);
-
-	return ret;
+	return fio_libpmem_file(td, f, fdd->libpmem_sz, fdd->libpmem_off);
 }
 
 static int fio_libpmem_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
-	int ret;
 
 	dprint(FD_IO, "DEBUG fio_libpmem_prep\n" );
-	/*
-	 * It fits within existing mapping, use it
-	 */
-	dprint(FD_IO," io_u->offset %llu : fdd->libpmem_off %llu : "
-			"io_u->buflen %llu : fdd->libpmem_sz %llu\n",
-			io_u->offset, (unsigned long long) fdd->libpmem_off,
-			io_u->buflen, (unsigned long long) fdd->libpmem_sz);
-
-	if (io_u->offset >= fdd->libpmem_off &&
-	    (io_u->offset + io_u->buflen <=
-	     fdd->libpmem_off + fdd->libpmem_sz))
-		goto done;
-
-	/*
-	 * unmap any existing mapping
-	 */
-	if (fdd->libpmem_ptr) {
-		dprint(FD_IO,"munmap \n");
-		if (munmap(fdd->libpmem_ptr, fdd->libpmem_sz) < 0)
-			return errno;
-		fdd->libpmem_ptr = NULL;
-	}
+	dprint(FD_IO," io_u->offset %llu : fdd->libpmem_off %ld : "
+			"io_u->buflen %llu : fdd->libpmem_sz %ld\n",
+			io_u->offset, fdd->libpmem_off,
+			io_u->buflen, fdd->libpmem_sz);
 
-	if (fio_libpmem_prep_full(td, io_u)) {
-		td_clear_error(td);
-		ret = fio_libpmem_prep_limited(td, io_u);
-		if (ret)
-			return ret;
+	if (io_u->buflen > f->real_file_size) {
+		log_err("libpmem: bs bigger than the file size\n");
+		return EIO;
 	}
 
-done:
 	io_u->mmap_data = fdd->libpmem_ptr + io_u->offset - fdd->libpmem_off
 				- f->file_offset;
 	return 0;
@@ -460,10 +186,15 @@ done:
 static enum fio_q_status fio_libpmem_queue(struct thread_data *td,
 					   struct io_u *io_u)
 {
+	unsigned flags = 0;
+
 	fio_ro_check(td, io_u);
 	io_u->error = 0;
 
 	dprint(FD_IO, "DEBUG fio_libpmem_queue\n");
+	dprint(FD_IO,"td->o.odirect %d td->o.sync_io %d \n",td->o.odirect, td->o.sync_io);
+	flags = td->o.sync_io ? 0 : PMEM_F_MEM_NODRAIN;
+	flags |= td->o.odirect ? PMEM_F_MEM_NONTEMPORAL : PMEM_F_MEM_TEMPORAL;
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
@@ -472,20 +203,15 @@ static enum fio_q_status fio_libpmem_queue(struct thread_data *td,
 	case DDIR_WRITE:
 		dprint(FD_IO, "DEBUG mmap_data=%p, xfer_buf=%p\n",
 				io_u->mmap_data, io_u->xfer_buf );
-		dprint(FD_IO,"td->o.odirect %d \n",td->o.odirect);
-		if (td->o.odirect) {
-			pmem_memcpy_persist(io_u->mmap_data,
-						io_u->xfer_buf,
-						io_u->xfer_buflen);
-		} else {
-			pmem_memcpy_nodrain(io_u->mmap_data,
-						io_u->xfer_buf,
-						io_u->xfer_buflen);
-		}
+		pmem_memcpy(io_u->mmap_data,
+					io_u->xfer_buf,
+					io_u->xfer_buflen,
+					flags);
 		break;
 	case DDIR_SYNC:
 	case DDIR_DATASYNC:
 	case DDIR_SYNC_FILE_RANGE:
+		pmem_drain();
 		break;
 	default:
 		io_u->error = EINVAL;
@@ -495,53 +221,10 @@ static enum fio_q_status fio_libpmem_queue(struct thread_data *td,
 	return FIO_Q_COMPLETED;
 }
 
-static int fio_libpmem_init(struct thread_data *td)
-{
-	struct thread_options *o = &td->o;
-
-	dprint(FD_IO,"o->rw_min_bs %llu \n o->fsync_blocks %d \n o->fdatasync_blocks %d \n",
-			o->rw_min_bs,o->fsync_blocks,o->fdatasync_blocks);
-	dprint(FD_IO, "DEBUG fio_libpmem_init\n");
-
-	if ((o->rw_min_bs & page_mask) &&
-	    (o->fsync_blocks || o->fdatasync_blocks)) {
-		log_err("libpmem: mmap options dictate a minimum block size of "
-				"%llu bytes\n",	(unsigned long long) page_size);
-		return 1;
-	}
-	return 0;
-}
-
-static int fio_libpmem_open_file(struct thread_data *td, struct fio_file *f)
-{
-	struct fio_libpmem_data *fdd;
-	int ret;
-
-	dprint(FD_IO,"DEBUG fio_libpmem_open_file\n");
-	dprint(FD_IO,"f->io_size=%ld \n",f->io_size);
-	dprint(FD_IO,"td->o.size=%lld \n",td->o.size);
-	dprint(FD_IO,"td->o.iodepth=%d\n",td->o.iodepth);
-	dprint(FD_IO,"td->o.iodepth_batch=%d \n",td->o.iodepth_batch);
-
-	ret = generic_open_file(td, f);
-	if (ret)
-		return ret;
-
-	fdd = calloc(1, sizeof(*fdd));
-	if (!fdd) {
-		int fio_unused __ret;
-		__ret = generic_close_file(td, f);
-		return 1;
-	}
-
-	FILE_SET_ENG_DATA(f, fdd);
-
-	return 0;
-}
-
 static int fio_libpmem_close_file(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
+	int ret = 0;
 
 	dprint(FD_IO,"DEBUG fio_libpmem_close_file\n");
 	dprint(FD_IO,"td->o.odirect %d \n",td->o.odirect);
@@ -551,11 +234,15 @@ static int fio_libpmem_close_file(struct thread_data *td, struct fio_file *f)
 		pmem_drain();
 	}
 
+	if (fdd->libpmem_ptr)
+		ret = pmem_unmap(fdd->libpmem_ptr, fdd->libpmem_sz);
+	if (fio_file_open(f))
+		ret &= generic_close_file(td, f);
+
 	FILE_SET_ENG_DATA(f, NULL);
 	free(fdd);
-	fio_file_clear_partial_mmap(f);
 
-	return generic_close_file(td, f);
+	return ret;
 }
 
 FIO_STATIC struct ioengine_ops ioengine = {
@@ -567,22 +254,12 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.open_file	= fio_libpmem_open_file,
 	.close_file	= fio_libpmem_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO |FIO_NOEXTEND,
+	.flags		= FIO_SYNCIO | FIO_RAWIO | FIO_DISKLESSIO | FIO_NOEXTEND |
+				FIO_NODISKUTIL | FIO_BARRIER | FIO_MEMALIGN,
 };
 
 static void fio_init fio_libpmem_register(void)
 {
-#ifndef WIN32
-	Mmap_align = page_size;
-#else
-	if (Mmap_align == 0) {
-		SYSTEM_INFO si;
-
-		GetSystemInfo(&si);
-		Mmap_align = si.dwAllocationGranularity;
-	}
-#endif
-
 	register_ioengine(&ioengine);
 }
 
diff --git a/examples/libpmem.fio b/examples/libpmem.fio
index d44fcfa7..65b1d687 100644
--- a/examples/libpmem.fio
+++ b/examples/libpmem.fio
@@ -15,6 +15,7 @@ iodepth=1
 iodepth_batch=1
 thread=1
 numjobs=1
+runtime=300
 
 #
 # In case of 'scramble_buffers=1', the source buffer
@@ -27,13 +28,17 @@ numjobs=1
 scramble_buffers=0
 
 #
-# direct=0:
-#   Using pmem_memcpy_nodrain() for write operation
+# depends on direct option, flags are set for pmem_memcpy() call:
+# direct=1 - PMEM_F_MEM_NONTEMPORAL,
+# direct=0 - PMEM_F_MEM_TEMPORAL.
 #
-# direct=1:
-#   Using pmem_memcpy_persist() for write operation
+direct=1
+
+#
+# sync=1 means that pmem_drain() is executed for each write operation.
 #
-direct=0
+sync=1
+
 
 #
 # Setting for fio process's CPU Node and Memory Node
@@ -47,7 +52,7 @@ numa_mem_policy=bind:0
 cpus_allowed_policy=split
 
 #
-# The pmemblk engine does IO to files in a DAX-mounted filesystem.
+# The libpmem engine does IO to files in a DAX-mounted filesystem.
 # The filesystem should be created on an NVDIMM (e.g /dev/pmem0)
 # and then mounted with the '-o dax' option.  Note that the engine
 # accesses the underlying NVDIMM directly, bypassing the kernel block

