Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34358 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbdIFMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Sep 2017 08:00:16 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dpZ0B-00089T-DP
        for fio@vger.kernel.org; Wed, 06 Sep 2017 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170906120002.42A442C0167@kernel.dk>
Date: Wed,  6 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 07dff7d1d614b33e3a6d3e3ade38ce648b53a632:

  Merge branch 'shifted_logging' of https://github.com/sitsofe/fio (2017-09-02 17:00:24 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 83a9e706745e5a5affd5475b884e42d0100f783f:

  Merge branch 'windows_io_hint' of https://github.com/sitsofe/fio (2017-09-05 15:37:36 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      filesetup: revert O_DIRECT for layout mess
      Merge branch 'gluster_printf' of https://github.com/sitsofe/fio
      Merge branch 'travis_32bit' of https://github.com/sitsofe/fio
      Merge branch 'windows_io_hint' of https://github.com/sitsofe/fio

Sitsofe Wheeler (3):
      travis: add 32 bit build, minor updates and cleanups
      glusterfs: silence printf specifier warnings
      windowsaio: obey sequential/random I/O hinting

 .travis.yml               | 29 +++++++++++++++++++++++++----
 engines/glusterfs.c       |  8 ++++----
 engines/glusterfs_async.c |  2 +-
 engines/windowsaio.c      | 23 ++++++++++++++++++-----
 filesetup.c               | 25 ++++++-------------------
 5 files changed, 54 insertions(+), 33 deletions(-)

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index 795c0fc..94f69fb 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -5,12 +5,16 @@ compiler:
   - clang
   - gcc
 env:
+  matrix:
+    - BUILD_ARCH="x86"
+    - BUILD_ARCH="x86_64"
   global:
     - MAKEFLAGS="-j 2"
 matrix:
   include:
     - os: osx
       compiler: clang # Workaround travis setting CC=["clang", "gcc"]
+      env: BUILD_ARCH="x86_64"
     # Build using the 10.12 SDK but target and run on OSX 10.11
 #   - os: osx
 #     compiler: clang
@@ -19,12 +23,29 @@ matrix:
     # Build on the latest OSX version (will eventually become obsolete)
     - os: osx
       compiler: clang
-      osx_image: xcode8.2
+      osx_image: xcode8.3
+      env: BUILD_ARCH="x86_64"
   exclude:
     - os: osx
       compiler: gcc
+  exclude:
+    - os: linux
+      compiler: clang
+      env: BUILD_ARCH="x86" # Only do the gcc x86 build to reduce clutter
 before_install:
-  - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then sudo apt-get -qq update; fi
-  - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then sudo apt-get install -qq -y libaio-dev libnuma-dev libz-dev librbd-dev glusterfs-common libibverbs-dev librdmacm-dev; fi
+  - EXTRA_CFLAGS="-Werror"
+  - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
+        pkgs=(libaio-dev libnuma-dev libz-dev librbd-dev libibverbs-dev librdmacm-dev);
+        if [[ "$BUILD_ARCH" == "x86" ]]; then
+            pkgs=("${pkgs[@]/%/:i386}");
+            pkgs+=(gcc-multilib);
+            EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32";
+        else
+            pkgs+=(glusterfs-common);
+        fi;
+        sudo apt-get -qq update;
+        sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}";
+    fi
 script:
-  - ./configure --extra-cflags="-Werror" && make && make test
+  - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
+  - make test
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index 2abc283..981dfa3 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -165,11 +165,11 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 	if (td_read(td)) {
 		if (glfs_lstat(g->fs, f->file_name, &sb)
 		    || sb.st_size < f->real_file_size) {
-			dprint(FD_FILE, "fio extend file %s from %ld to %ld\n",
-			       f->file_name, sb.st_size, f->real_file_size);
+			dprint(FD_FILE, "fio extend file %s from %jd to %" PRIu64 "\n",
+			       f->file_name, (intmax_t) sb.st_size, f->real_file_size);
 			ret = glfs_ftruncate(g->fd, f->real_file_size);
 			if (ret) {
-				log_err("failed fio extend file %s to %ld\n",
+				log_err("failed fio extend file %s to %" PRIu64 "\n",
 					f->file_name, f->real_file_size);
 			} else {
 				unsigned long long left;
@@ -190,7 +190,7 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 
 					r = glfs_write(g->fd, b, bs, 0);
 					dprint(FD_IO,
-					       "fio write %d of %ld file %s\n",
+					       "fio write %d of %" PRIu64 " file %s\n",
 					       r, f->real_file_size,
 					       f->file_name);
 
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index f46cb26..97271d6 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -92,7 +92,7 @@ static void gf_async_cb(glfs_fd_t * fd, ssize_t ret, void *data)
 	struct io_u *io_u = data;
 	struct fio_gf_iou *iou = io_u->engine_data;
 
-	dprint(FD_IO, "%s ret %lu\n", __FUNCTION__, ret);
+	dprint(FD_IO, "%s ret %zd\n", __FUNCTION__, ret);
 	iou->io_complete = 1;
 }
 
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index c4c5abd..314eaad 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -169,13 +169,26 @@ static int fio_windowsaio_open_file(struct thread_data *td, struct fio_file *f)
 
 	/*
 	 * Inform Windows whether we're going to be doing sequential or
-	 * random io so it can tune the Cache Manager
+	 * random IO so it can tune the Cache Manager
 	 */
-	if (td->o.td_ddir == TD_DDIR_READ  ||
-		td->o.td_ddir == TD_DDIR_WRITE)
-		flags |= FILE_FLAG_SEQUENTIAL_SCAN;
-	else
+	switch (td->o.fadvise_hint) {
+	case F_ADV_TYPE:
+		if (td_random(td))
+			flags |= FILE_FLAG_RANDOM_ACCESS;
+		else
+			flags |= FILE_FLAG_SEQUENTIAL_SCAN;
+		break;
+	case F_ADV_RANDOM:
 		flags |= FILE_FLAG_RANDOM_ACCESS;
+		break;
+	case F_ADV_SEQUENTIAL:
+		flags |= FILE_FLAG_SEQUENTIAL_SCAN;
+		break;
+	case F_ADV_NONE:
+		break;
+	default:
+		log_err("fio: unknown fadvise type %d\n", td->o.fadvise_hint);
+	}
 
 	if (!td_write(td) || read_only)
 		access = GENERIC_READ;
diff --git a/filesetup.c b/filesetup.c
index 5e8ea35..b51ab35 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -15,7 +15,6 @@
 #include "os/os.h"
 #include "hash.h"
 #include "lib/axmap.h"
-#include "lib/memalign.h"
 
 #ifdef CONFIG_LINUX_FALLOCATE
 #include <linux/falloc.h>
@@ -110,7 +109,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 {
 	int new_layout = 0, unlink_file = 0, flags;
 	unsigned long long left;
-	unsigned int bs, alloc_size = 0;
+	unsigned int bs;
 	char *b = NULL;
 
 	if (read_only) {
@@ -147,8 +146,6 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		flags |= O_CREAT;
 	if (new_layout)
 		flags |= O_TRUNC;
-	if (td->o.odirect)
-		flags |= OS_O_DIRECT;
 
 #ifdef WIN32
 	flags |= _O_BINARY;
@@ -162,14 +159,8 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		if (err == ENOENT && !td->o.allow_create)
 			log_err("fio: file creation disallowed by "
 					"allow_file_create=0\n");
-		else {
-			if (err == EINVAL && (flags & OS_O_DIRECT))
-				log_err("fio: looks like your filesystem "
-					"does not support "
-					"direct=1/buffered=0\n");
-
+		else
 			td_verror(td, err, "open");
-		}
 		return 1;
 	}
 
@@ -196,18 +187,14 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
-	if (td->o.odirect && !OS_O_DIRECT && fio_set_directio(td, f))
-		goto err;
-
 	left = f->real_file_size;
 	bs = td->o.max_bs[DDIR_WRITE];
 	if (bs > left)
 		bs = left;
 
-	alloc_size = bs;
-	b = fio_memalign(page_size, alloc_size);
+	b = malloc(bs);
 	if (!b) {
-		td_verror(td, errno, "fio_memalign");
+		td_verror(td, errno, "malloc");
 		goto err;
 	}
 
@@ -260,14 +247,14 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 			f->io_size = f->real_file_size;
 	}
 
-	fio_memfree(b, alloc_size);
+	free(b);
 done:
 	return 0;
 err:
 	close(f->fd);
 	f->fd = -1;
 	if (b)
-		fio_memfree(b, alloc_size);
+		free(b);
 	return 1;
 }
 
