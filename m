Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:6285 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752413AbdAJVRp (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Jan 2017 16:17:45 -0500
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id 249981549
        for <fio@vger.kernel.org>; Tue, 10 Jan 2017 21:17:44 +0000 (UTC)
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2352.austin.hpe.com (Postfix) with ESMTP id 27EC646
        for <fio@vger.kernel.org>; Tue, 10 Jan 2017 21:17:43 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 1/4] pmemblk, dev-dax: load libpmem and libpmemblk at startup
Date: Tue, 10 Jan 2017 15:21:24 -0600
Message-Id: <20170110212127.64926-1-elliott@hpe.com>
In-Reply-To: <20170104065453.15106-1-elliott@hpe.com>
References: <20170104065453.15106-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

The pmemblk and dev-dax ioengines were loading libpmem.so and
libpmemblk.so using dlopen() at runtime.

Although the upstream nvml Makefile installs a libpmem.so
symbolic link, some of the distros (e.g. SUSE Linux Enterprise
Server 12 SP2) are just installing so.1 symbolic links.  So,
fio fails to find the libpmem.so and libpmemblk.so library files.

http://www.ibm.com/developerworks/linux/library/l-shlibs/index.html
says applications should always load the versioned filenames to
avoid compatibility issues; the non-versioned filenames are just
for the compiler and linker.

Change ./configure to pass -lpmem and -lpmemblk to the compiler
so the fio binary loads the versioned filename at startup like
the other libraries, rather than open the non-versioned filename
with dlopen() during runtime.

This way they show up in ldd:
$ ldd fio
        linux-vdso.so.1 (0x00007ffc290aa000)
        libpmemblk.so.1 => /lib64/libpmemblk.so.1 (0x00007f65b5bc4000)
        libpmem.so.1 => /lib64/libpmem.so.1 (0x00007f65b59be000)
        libnuma.so.1 => /lib64/libnuma.so.1 (0x00007f65b57b3000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f65b55ab000)
        libaio.so.1 => /lib64/libaio.so.1 (0x00007f65b53a9000)
        libz.so.1 => /lib64/libz.so.1 (0x00007f65b5191000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f65b4e88000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f65b4c6a000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f65b4a66000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f65b46a0000)
        libuuid.so.1 => /lib64/libuuid.so.1 (0x00007f65b449b000)
        /lib64/ld-linux-x86-64.so.2 (0x0000559f4d872000)
---
 configure         | 20 ++++++++++-----
 engines/dev-dax.c | 22 +---------------
 engines/pmemblk.c | 77 +++++--------------------------------------------------
 3 files changed, 21 insertions(+), 98 deletions(-)

diff --git a/configure b/configure
index fc15782..68c4859 100755
--- a/configure
+++ b/configure
@@ -1578,26 +1578,32 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "-lpmem" "libpmem"; then
   libpmem="yes"
+  LIBS="-lpmem $LIBS"
 fi
 echo "libpmem                       $libpmem"
 
 ##########################################
 # Check whether we have libpmemblk
+# libpmem is a prerequisite
 libpmemblk="no"
-cat > $TMPC << EOF
+if test "$libpmem" = "yes"; then
+  cat > $TMPC << EOF
 #include <libpmemblk.h>
 int main(int argc, char **argv)
 {
-  int rc;
-  rc = pmemblk_open("", 0);
+  PMEMblkpool *pbp;
+  pbp = pmemblk_open("", 0);
   return 0;
 }
 EOF
-if compile_prog "" "-lpmemblk -lpmem" "libpmemblk"; then
-  libpmemblk="yes"
+  if compile_prog "" "-lpmemblk" "libpmemblk"; then
+    libpmemblk="yes"
+    LIBS="-lpmemblk $LIBS"
+  fi
 fi
 echo "libpmemblk                    $libpmemblk"
 
+# Choose the ioengines
 if test "$libpmem" = "yes" && test "$disable_pmem" = "no"; then
   devdax="yes"
   if test "$libpmemblk" = "yes"; then
@@ -1607,11 +1613,11 @@ fi
 
 ##########################################
 # Report whether pmemblk engine is enabled
-echo "NVML libpmemblk engine        $pmemblk"
+echo "NVML pmemblk engine           $pmemblk"
 
 ##########################################
 # Report whether dev-dax engine is enabled
-echo "NVML Device Dax engine        $devdax"
+echo "NVML dev-dax engine           $devdax"
 
 # Check if we have lex/yacc available
 yacc="no"
diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index 2516bca..45aca4e 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -51,8 +51,8 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
-#include <dlfcn.h>
 #include <libgen.h>
+#include <libpmem.h>
 
 #include "../fio.h"
 #include "../verify.h"
@@ -69,8 +69,6 @@ struct fio_devdax_data {
 	off_t devdax_off;
 };
 
-static void * (*pmem_memcpy_persist)(void *dest, const void *src, size_t len);
-
 static int fio_devdax_file(struct thread_data *td, struct fio_file *f,
 			   size_t length, off_t off)
 {
@@ -212,8 +210,6 @@ static int fio_devdax_queue(struct thread_data *td, struct io_u *io_u)
 static int fio_devdax_init(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
-	const char *path;
-	void *dl;
 
 	if ((o->rw_min_bs & page_mask) &&
 	    (o->fsync_blocks || o->fdatasync_blocks)) {
@@ -222,22 +218,6 @@ static int fio_devdax_init(struct thread_data *td)
 		return 1;
 	}
 
-	path = getenv("FIO_PMEM_LIB");
-	if (!path)
-		path = "libpmem.so";
-
-	dl = dlopen(path, RTLD_NOW | RTLD_NODELETE);
-	if (!dl) {
-		log_err("fio: unable to open libpmem: %s\n", dlerror());
-		return 1;
-	}
-
-	pmem_memcpy_persist = dlsym(dl, "pmem_memcpy_persist");
-	if (!pmem_memcpy_persist) {
-		log_err("fio: unable to load libpmem: %s\n", dlerror());
-		return 1;
-	}
-
 	return 0;
 }
 
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index ca72697..7b1affa 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -50,12 +50,6 @@
  *
  *   See examples/pmemblk.fio for more.
  *
- * libpmemblk.so
- *   By default, the pmemblk engine will let the system find the libpmemblk.so
- *   that it uses.  You can use an alternative libpmemblk by setting the
- *   FIO_PMEMBLK_LIB environment variable to the full path to the desired
- *   libpmemblk.so.
- *
  */
 
 #include <stdio.h>
@@ -64,68 +58,15 @@
 #include <sys/uio.h>
 #include <errno.h>
 #include <assert.h>
-#include <dlfcn.h>
 #include <string.h>
+#include <libpmem.h>
+#include <libpmemblk.h>
 
 #include "../fio.h"
 
 /*
  * libpmemblk
  */
-struct PMEMblkpool_s;
-typedef struct PMEMblkpool_s PMEMblkpool;
-
-static PMEMblkpool *(*pmemblk_create) (const char *, size_t, size_t, mode_t);
-static PMEMblkpool *(*pmemblk_open) (const char *, size_t);
-static void (*pmemblk_close) (PMEMblkpool *);
-static size_t(*pmemblk_nblock) (PMEMblkpool *);
-static size_t(*pmemblk_bsize) (PMEMblkpool *);
-static int (*pmemblk_read) (PMEMblkpool *, void *, off_t);
-static int (*pmemblk_write) (PMEMblkpool *, const void *, off_t);
-
-int load_libpmemblk(const char *path)
-{
-	void *dl;
-
-	if (!path)
-		path = "libpmemblk.so";
-
-	dl = dlopen(path, RTLD_NOW | RTLD_NODELETE);
-	if (!dl)
-		goto errorout;
-
-	pmemblk_create = dlsym(dl, "pmemblk_create");
-	if (!pmemblk_create)
-		goto errorout;
-	pmemblk_open = dlsym(dl, "pmemblk_open");
-	if (!pmemblk_open)
-		goto errorout;
-	pmemblk_close = dlsym(dl, "pmemblk_close");
-	if (!pmemblk_close)
-		goto errorout;
-	pmemblk_nblock = dlsym(dl, "pmemblk_nblock");
-	if (!pmemblk_nblock)
-		goto errorout;
-	pmemblk_bsize = dlsym(dl, "pmemblk_bsize");
-	if (!pmemblk_bsize)
-		goto errorout;
-	pmemblk_read = dlsym(dl, "pmemblk_read");
-	if (!pmemblk_read)
-		goto errorout;
-	pmemblk_write = dlsym(dl, "pmemblk_write");
-	if (!pmemblk_write)
-		goto errorout;
-
-	return 0;
-
-errorout:
-	log_err("fio: unable to load libpmemblk: %s\n", dlerror());
-	if (dl)
-		dlclose(dl);
-
-	return -1;
-}
-
 typedef struct fio_pmemblk_file *fio_pmemblk_file_t;
 
 struct fio_pmemblk_file {
@@ -250,11 +191,6 @@ static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
 
 	pmb = fio_pmemblk_cache_lookup(path);
 	if (!pmb) {
-		/* load libpmemblk if needed */
-		if (!pmemblk_open)
-			if (load_libpmemblk(getenv("FIO_PMEMBLK_LIB")))
-				goto error;
-
 		pmb = malloc(sizeof(*pmb));
 		if (!pmb)
 			goto error;
@@ -410,14 +346,11 @@ static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
 	unsigned long long off;
 	unsigned long len;
 	void *buf;
-	int (*blkop) (PMEMblkpool *, void *, off_t) = (void *)pmemblk_write;
 
 	fio_ro_check(td, io_u);
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		blkop = pmemblk_read;
-		/* fall through */
 	case DDIR_WRITE:
 		off = io_u->offset;
 		len = io_u->xfer_buflen;
@@ -435,7 +368,11 @@ static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
 		off /= pmb->pmb_bsize;
 		len /= pmb->pmb_bsize;
 		while (0 < len) {
-			if (0 != blkop(pmb->pmb_pool, buf, off)) {
+			if (io_u->ddir == DDIR_READ &&
+			   0 != pmemblk_read(pmb->pmb_pool, buf, off)) {
+				io_u->error = errno;
+				break;
+			} else if (0 != pmemblk_write(pmb->pmb_pool, buf, off)) {
 				io_u->error = errno;
 				break;
 			}
-- 
2.9.3

