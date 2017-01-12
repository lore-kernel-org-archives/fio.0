Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46436 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdALNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cRez5-00009a-EQ
        for fio@vger.kernel.org; Thu, 12 Jan 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170112130002.6DBB12C124B@kernel.dk>
Date: Thu, 12 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9bae252254d0ce37a144cb4c8d2cb4222d539a9e:

  Python style/portability fix (2017-01-10 13:20:30 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0cbb3f53ebeec45478c7b361c2a84092da93e4a8:

  pmemblk: Clarify fsize is in MiB not MB (2017-01-11 21:00:01 -0700)

----------------------------------------------------------------
Robert Elliott (4):
      pmemblk, dev-dax: load libpmem and libpmemblk at startup
      pmemblk, dev-dax: Update descriptions
      pmemblk, dev-dax: clean up error logs
      pmemblk: Clarify fsize is in MiB not MB

 HOWTO             |  10 +++--
 configure         |  20 ++++++----
 engines/dev-dax.c |  44 ++++++--------------
 engines/pmemblk.c | 117 +++++++++++++++---------------------------------------
 fio.1             |   6 ++-
 5 files changed, 66 insertions(+), 131 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 33f8718..9c8a837 100644
--- a/HOWTO
+++ b/HOWTO
@@ -904,11 +904,13 @@ ioengine=str	Defines how the job issues io to the file. The following
 				overwriting. The writetrim mode works well
 				for this constraint.
 
-			pmemblk	Read and write through the NVML libpmemblk
-				interface.
+			pmemblk	Read and write using filesystem DAX to a file
+				on a filesystem mounted with DAX on a persistent
+				memory device through the NVML libpmemblk library.
 
-			dev-dax Read and write through a DAX device exposed
-				from persistent memory.
+			dev-dax Read and write using device DAX to a persistent
+				memory device (e.g., /dev/dax0.0) through the
+				NVML libpmem library.
 
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
diff --git a/configure b/configure
index 7de88f8..d768e9d 100755
--- a/configure
+++ b/configure
@@ -1583,26 +1583,32 @@ int main(int argc, char **argv)
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
@@ -1612,11 +1618,11 @@ fi
 
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
index 2516bca..235a31e 100644
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
@@ -108,7 +106,7 @@ static int fio_devdax_prep_limited(struct thread_data *td, struct io_u *io_u)
 	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
 
 	if (io_u->buflen > f->real_file_size) {
-		log_err("fio: bs too big for dev-dax engine\n");
+		log_err("dev-dax: bs too big for dev-dax engine\n");
 		return EIO;
 	}
 
@@ -212,29 +210,11 @@ static int fio_devdax_queue(struct thread_data *td, struct io_u *io_u)
 static int fio_devdax_init(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
-	const char *path;
-	void *dl;
 
 	if ((o->rw_min_bs & page_mask) &&
 	    (o->fsync_blocks || o->fdatasync_blocks)) {
-		log_err("fio: mmap options dictate a minimum block size of "
-			"%llu bytes\n", (unsigned long long) page_size);
-		return 1;
-	}
-
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
+		log_err("dev-dax: mmap options dictate a minimum block size of %llu bytes\n",
+			(unsigned long long) page_size);
 		return 1;
 	}
 
@@ -292,8 +272,8 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	rc = stat(f->file_name, &st);
 	if (rc < 0) {
-		log_err("%s: failed to stat file %s: %d\n",
-			td->o.name, f->file_name, errno);
+		log_err("%s: failed to stat file %s (%s)\n",
+			td->o.name, f->file_name, strerror(errno));
 		return -errno;
 	}
 
@@ -302,8 +282,8 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	rpath = realpath(spath, npath);
 	if (!rpath) {
-		log_err("%s: realpath on %s failed: %d\n",
-			td->o.name, spath, errno);
+		log_err("%s: realpath on %s failed (%s)\n",
+			td->o.name, spath, strerror(errno));
 		return -errno;
 	}
 
@@ -318,15 +298,15 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	sfile = fopen(spath, "r");
 	if (!sfile) {
-		log_err("%s: fopen on %s failed: %d\n",
-			td->o.name, spath, errno);
+		log_err("%s: fopen on %s failed (%s)\n",
+			td->o.name, spath, strerror(errno));
 		return 1;
 	}
 
 	rc = fscanf(sfile, "%lu", &size);
 	if (rc < 0) {
-		log_err("%s: fscanf on %s failed: %d\n",
-			td->o.name, spath, errno);
+		log_err("%s: fscanf on %s failed (%s)\n",
+			td->o.name, spath, strerror(errno));
 		return 1;
 	}
 
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 5439da0..e8476f9 100644
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
@@ -39,23 +39,26 @@
  *   iodepth should be set to 1 as pmemblk is always synchronous.
  *   Use numjobs to scale up.
  *
- *   direct=1 is implied as pmemblk is always direct.
+ *   direct=1 is implied as pmemblk is always direct. A warning message
+ *   is printed if this is not specified.
+ *
+ *   unlink=1 removes the block pool file after testing, and is optional.
  *
- *   Can set unlink to 1 to remove the block pool file after testing.
+ *   The pmem device must have a DAX-capable filesystem and be mounted
+ *   with DAX enabled.  filename must point to a file on that filesystem.
+ *
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
- * libpmemblk.so
- *   By default, the pmemblk engine will let the system find the libpmemblk.so
- *   that it uses.  You can use an alternative libpmemblk by setting the
- *   FIO_PMEMBLK_LIB environment variable to the full path to the desired
- *   libpmemblk.so.
- *
  */
 
 #include <stdio.h>
@@ -64,68 +67,15 @@
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
@@ -187,7 +137,7 @@ static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
  * level, we allow the block size and file size to be appended
  * to the file name:
  *
- *   path[,bsize,fsizemb]
+ *   path[,bsize,fsizemib]
  *
  * note that we do not use the fio option "filesize" to dictate
  * the file size because we can only give libpmemblk the gross
@@ -197,7 +147,7 @@ static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
  * the final path without the parameters is returned in ppath.
  * the block size and file size are returned in pbsize and fsize.
  *
- * note that the user should specify the file size in MiB, but
+ * note that the user specifies the file size in MiB, but
  * we return bytes from here.
  */
 static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
@@ -206,7 +156,7 @@ static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
 	char *path;
 	char *s;
 	uint64_t bsize;
-	uint64_t fsizemb;
+	uint64_t fsizemib;
 
 	path = strdup(pathspec);
 	if (!path) {
@@ -216,14 +166,14 @@ static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
 
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
@@ -250,11 +200,6 @@ static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
 
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
@@ -267,9 +212,8 @@ static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
 			    pmemblk_create(path, bsize, fsize, 0644);
 		}
 		if (!pmb->pmb_pool) {
-			log_err
-			    ("fio: enable to open pmemblk pool file (errno %d)\n",
-			     errno);
+			log_err("pmemblk: unable to open pmemblk pool file %s (%s)\n",
+			     path, strerror(errno));
 			goto error;
 		}
 
@@ -331,14 +275,14 @@ static int pmb_get_flags(struct thread_data *td, uint64_t *pflags)
 	if (!td->o.use_thread) {
 		if (!thread_warned) {
 			thread_warned = 1;
-			log_err("fio: must set thread=1 for pmemblk engine\n");
+			log_err("pmemblk: must set thread=1 for pmemblk engine\n");
 		}
 		return 1;
 	}
 
 	if (!td->o.odirect && !odirect_warned) {
 		odirect_warned = 1;
-		log_info("fio: direct == 0, but pmemblk is always direct\n");
+		log_info("pmemblk: direct == 0, but pmemblk is always direct\n");
 	}
 
 	if (td->o.allow_create)
@@ -410,14 +354,11 @@ static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
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
@@ -435,7 +376,11 @@ static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
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
diff --git a/fio.1 b/fio.1
index f486276..56f2d11 100644
--- a/fio.1
+++ b/fio.1
@@ -811,10 +811,12 @@ and discarding before overwriting. The trimwrite mode works well for this
 constraint.
 .TP
 .B pmemblk
-Read and write through the NVML libpmemblk interface.
+Read and write using filesystem DAX to a file on a filesystem mounted with
+DAX on a persistent memory device through the NVML libpmemblk library.
 .TP
 .B dev-dax
-Read and write through a DAX device exposed from persistent memory.
+Read and write using device DAX to a persistent memory device
+(e.g., /dev/dax0.0) through the NVML libpmem library.
 .RE
 .P
 .RE
