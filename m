Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgG0MAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Jul 2020 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD3AC061794
        for <fio@vger.kernel.org>; Mon, 27 Jul 2020 05:00:09 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k01na-0005fB-L7
        for fio@vger.kernel.org; Mon, 27 Jul 2020 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200727120001.CB7A51BC01C5@kernel.dk>
Date: Mon, 27 Jul 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e235e74dfd0627b17690194f957da509b8ace808:

  Merge branch 'test-cleanup' of https://github.com/vincentkfu/fio (2020-07-25 13:55:16 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 11b280c158db01744effde3863bfe9c65f7af090:

  t/jobs/t001[1-2].fio: run for 10 seconds instead of 3 (2020-07-26 22:19:47 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Merge branch 'travis_cleanup' of https://github.com/sitsofe/fio
      Merge branch 'enable_or_exit' of https://github.com/sitsofe/fio
      Merge branch 'fix_travis_libiscsi' of https://github.com/sitsofe/fio
      t/jobs/t001[1-2].fio: run for 10 seconds instead of 3

Sitsofe Wheeler (12):
      travis: simplify yml file
      travis: improve installation dependencies
      configure: check for Debian/Ubuntu tcmalloc_minimal
      travis: use install section instead of before_install section
      travis: add dependency for cuda ioengine
      travis: enable libiscsi and cuda ioengines
      travis: make CI install script bail out on first error
      memory: fix incorrect pointer comparison when freeing cuda memory
      Makefile: fix incorrectly set libiscsi cflags
      configure: fail when explicit enabling doesn't succeed
      travis: remove unneeded dependency
      travis: fix x86 libiscsi detection

 .travis.yml               | 18 ++++----------
 Makefile                  |  2 +-
 ci/travis-build.sh        | 23 ++++++++++++++----
 ci/travis-install.sh      | 30 ++++++++++++++++-------
 configure                 | 62 +++++++++++++++++++++++++++++------------------
 memory.c                  |  2 +-
 t/jobs/t0011-5d2788d5.fio |  2 +-
 t/jobs/t0012.fio          |  2 +-
 8 files changed, 87 insertions(+), 54 deletions(-)

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index b64f0a95..e35aff39 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -9,36 +9,28 @@ arch:
   - amd64
   - arm64
 env:
-  matrix:
-    - BUILD_ARCH="x86"
-    - BUILD_ARCH="x86_64"
   global:
     - MAKEFLAGS="-j 2"
 matrix:
   include:
+    - os: linux
+      compiler: gcc
+      arch: amd64
+      env: BUILD_ARCH="x86" # Only do the gcc x86 build to reduce clutter
     # Default xcode image
     - os: osx
       compiler: clang # Workaround travis setting CC=["clang", "gcc"]
-      env: BUILD_ARCH="x86_64"
       arch: amd64
     # Latest xcode image (needs periodic updating)
     - os: osx
       compiler: clang
       osx_image: xcode11.2
-      env: BUILD_ARCH="x86_64"
       arch: amd64
   exclude:
     - os: osx
       compiler: gcc
-    - os: linux
-      compiler: clang
-      arch: amd64
-      env: BUILD_ARCH="x86" # Only do the gcc x86 build to reduce clutter
-    - os: linux
-      env: BUILD_ARCH="x86"
-      arch: arm64
 
-before_install:
+install:
   - ci/travis-install.sh
 
 script:
diff --git a/Makefile b/Makefile
index f374ac84..8e1ebc90 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,7 @@ endif
 ifdef CONFIG_LIBISCSI
   iscsi_SRCS = engines/libiscsi.c
   iscsi_LIBS = $(LIBISCSI_LIBS)
-  iscsi_CFLAGS = $(LIBISCSI_LIBS)
+  iscsi_CFLAGS = $(LIBISCSI_CFLAGS)
   ENGINES += iscsi
 endif
 
diff --git a/ci/travis-build.sh b/ci/travis-build.sh
index 06012e89..231417e2 100755
--- a/ci/travis-build.sh
+++ b/ci/travis-build.sh
@@ -1,16 +1,29 @@
 #!/bin/bash
 
+CI_TARGET_ARCH="${BUILD_ARCH:-$TRAVIS_CPU_ARCH}"
 EXTRA_CFLAGS="-Werror"
 PYTHONUNBUFFERED=TRUE
+CONFIGURE_FLAGS=()
 
-if [[ "$BUILD_ARCH" == "x86" ]]; then
-    EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32"
-fi
+case "$TRAVIS_OS_NAME" in
+    "linux")
+        CONFIGURE_FLAGS+=(--enable-libiscsi)
+        case "$CI_TARGET_ARCH" in
+            "x86")
+                EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32"
+                ;;
+            "amd64")
+                CONFIGURE_FLAGS+=(--enable-cuda)
+                ;;
+        esac
+    ;;
+esac
+CONFIGURE_FLAGS+=(--extra-cflags="${EXTRA_CFLAGS}")
 
-./configure --extra-cflags="${EXTRA_CFLAGS}" &&
+./configure "${CONFIGURE_FLAGS[@]}" &&
     make &&
     make test &&
-    if [[ "$TRAVIS_CPU_ARCH" == "arm64" ]]; then
+    if [[ "$CI_TARGET_ARCH" == "arm64" ]]; then
 	sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
     else
 	sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
diff --git a/ci/travis-install.sh b/ci/travis-install.sh
index 232ab6b1..b6895e82 100755
--- a/ci/travis-install.sh
+++ b/ci/travis-install.sh
@@ -1,13 +1,15 @@
 #!/bin/bash
+set -e
 
+CI_TARGET_ARCH="${BUILD_ARCH:-$TRAVIS_CPU_ARCH}"
 case "$TRAVIS_OS_NAME" in
     "linux")
 	# Architecture-dependent packages.
 	pkgs=(
 	    libaio-dev
-	    libcunit1
 	    libcunit1-dev
-	    libgoogle-perftools4
+	    libfl-dev
+	    libgoogle-perftools-dev
 	    libibverbs-dev
 	    libiscsi-dev
 	    libnuma-dev
@@ -15,15 +17,26 @@ case "$TRAVIS_OS_NAME" in
 	    librdmacm-dev
 	    libz-dev
 	)
-	if [[ "$BUILD_ARCH" == "x86" ]]; then
-	    pkgs=("${pkgs[@]/%/:i386}")
-	    pkgs+=(gcc-multilib)
-	else
-	    pkgs+=(glusterfs-common)
+	case "$CI_TARGET_ARCH" in
+	    "x86")
+		pkgs=("${pkgs[@]/%/:i386}")
+		pkgs+=(
+		    gcc-multilib
+		    pkg-config:i386
+	        )
+		;;
+	    "amd64")
+		pkgs+=(nvidia-cuda-dev)
+		;;
+	esac
+	if [[ $CI_TARGET_ARCH != "x86" ]]; then
+		pkgs+=(glusterfs-common)
 	fi
 	# Architecture-independent packages and packages for which we don't
 	# care about the architecture.
 	pkgs+=(
+	    bison
+	    flex
 	    python3
 	    python3-scipy
 	    python3-six
@@ -34,8 +47,7 @@ case "$TRAVIS_OS_NAME" in
     "osx")
 	brew update >/dev/null 2>&1
 	brew install cunit
-	pip3 install scipy
-	pip3 install six
+	pip3 install scipy six
 	;;
 esac
 
diff --git a/configure b/configure
index 25216c63..5925e94f 100755
--- a/configure
+++ b/configure
@@ -144,6 +144,7 @@ libhdfs="no"
 pmemblk="no"
 devdax="no"
 pmem="no"
+cuda="no"
 disable_lex=""
 disable_pmem="no"
 disable_native="no"
@@ -202,7 +203,7 @@ for opt do
   ;;
   --disable-pmem) disable_pmem="yes"
   ;;
-  --enable-cuda) enable_cuda="yes"
+  --enable-cuda) cuda="yes"
   ;;
   --disable-native) disable_native="yes"
   ;;
@@ -626,8 +627,13 @@ int main(void)
   return 0;
 }
 EOF
-  if test "$libaio_uring" = "yes" && compile_prog "" "-luring" "libaio io_uring" ; then
-    libaio=yes
+  if test "$libaio_uring" = "yes"; then
+    if compile_prog "" "-luring" "libaio io_uring" ; then
+      libaio=yes
+      LIBS="-luring $LIBS"
+    else
+      feature_not_found "libaio io_uring" ""
+    fi
   elif compile_prog "" "-laio" "libaio" ; then
     libaio=yes
     libaio_uring=no
@@ -2052,7 +2058,7 @@ if test "$libhdfs" = "yes" ; then
     hdfs_conf_error=1
   fi
   if test "$hdfs_conf_error" = "1" ; then
-    exit 1
+    feature_not_found "libhdfs" ""
   fi
   FIO_HDFS_CPU=$cpu
   if test "$FIO_HDFS_CPU" = "x86_64" ; then
@@ -2170,15 +2176,16 @@ fi
 print_config "DDN's Infinite Memory Engine" "$libime"
 
 ##########################################
-# Check if we have required environment variables configured for libiscsi
-if test "$libiscsi" = "yes" ; then
-  if $(pkg-config --atleast-version=1.9.0 libiscsi); then
+# Check if we have libiscsi
+if test "$libiscsi" != "no" ; then
+  minimum_libiscsi=1.9.0
+  if $(pkg-config --atleast-version=$minimum_libiscsi libiscsi); then
     libiscsi="yes"
     libiscsi_cflags=$(pkg-config --cflags libiscsi)
     libiscsi_libs=$(pkg-config --libs libiscsi)
   else
     if test "$libiscsi" = "yes" ; then
-      echo "libiscsi" "Install libiscsi >= 1.9.0"
+      feature_not_found "libiscsi" "libiscsi >= $minimum_libiscsi"
     fi
     libiscsi="no"
   fi
@@ -2186,16 +2193,16 @@ fi
 print_config "iscsi engine" "$libiscsi"
 
 ##########################################
-# Check if we have libnbd (for NBD support).
-minimum_libnbd=0.9.8
-if test "$libnbd" = "yes" ; then
+# Check if we have libnbd (for NBD support)
+if test "$libnbd" != "no" ; then
+  minimum_libnbd=0.9.8
   if $(pkg-config --atleast-version=$minimum_libnbd libnbd); then
     libnbd="yes"
     libnbd_cflags=$(pkg-config --cflags libnbd)
     libnbd_libs=$(pkg-config --libs libnbd)
   else
     if test "$libnbd" = "yes" ; then
-      echo "libnbd" "Install libnbd >= $minimum_libnbd"
+      feature_not_found "libnbd" "libnbd >= $minimum_libnbd"
     fi
     libnbd="no"
   fi
@@ -2506,9 +2513,7 @@ print_config "march_armv8_a_crc_crypto" "$march_armv8_a_crc_crypto"
 
 ##########################################
 # cuda probe
-if test "$cuda" != "yes" ; then
-  cuda="no"
-fi
+if test "$cuda" != "no" ; then
 cat > $TMPC << EOF
 #include <cuda.h>
 int main(int argc, char **argv)
@@ -2516,9 +2521,15 @@ int main(int argc, char **argv)
   return cuInit(0);
 }
 EOF
-if test "$enable_cuda" = "yes" && compile_prog "" "-lcuda" "cuda"; then
-  cuda="yes"
-  LIBS="-lcuda $LIBS"
+  if compile_prog "" "-lcuda" "cuda"; then
+    cuda="yes"
+    LIBS="-lcuda $LIBS"
+  else
+    if test "$cuda" = "yes" ; then
+      feature_not_found "cuda" ""
+    fi
+    cuda="no"
+  fi
 fi
 print_config "cuda" "$cuda"
 
@@ -3006,11 +3017,16 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if test "$disable_tcmalloc" != "yes"  && compile_prog "" "-ltcmalloc" "tcmalloc"; then
-  LIBS="-ltcmalloc $LIBS"
-  tcmalloc="yes"
-else
-  tcmalloc="no"
+if test "$disable_tcmalloc" != "yes"; then
+  if compile_prog "" "-ltcmalloc" "tcmalloc"; then
+    tcmalloc="yes"
+    LIBS="-ltcmalloc $LIBS"
+  elif compile_prog "" "-l:libtcmalloc_minimal.so.4" "tcmalloc_minimal4"; then
+    tcmalloc="yes"
+    LIBS="-l:libtcmalloc_minimal.so.4 $LIBS"
+  else
+    tcmalloc="no"
+  fi
 fi
 print_config "TCMalloc support" "$tcmalloc"
 
diff --git a/memory.c b/memory.c
index 5f0225f7..6cf73333 100644
--- a/memory.c
+++ b/memory.c
@@ -274,7 +274,7 @@ static int alloc_mem_cudamalloc(struct thread_data *td, size_t total_mem)
 static void free_mem_cudamalloc(struct thread_data *td)
 {
 #ifdef CONFIG_CUDA
-	if (td->dev_mem_ptr != NULL)
+	if (td->dev_mem_ptr)
 		cuMemFree(td->dev_mem_ptr);
 
 	if (cuCtxDestroy(td->cu_ctx) != CUDA_SUCCESS)
diff --git a/t/jobs/t0011-5d2788d5.fio b/t/jobs/t0011-5d2788d5.fio
index 50daf612..f90cee90 100644
--- a/t/jobs/t0011-5d2788d5.fio
+++ b/t/jobs/t0011-5d2788d5.fio
@@ -7,7 +7,7 @@
 bs=4k
 ioengine=null
 size=100g
-runtime=3
+runtime=10
 flow_id=1
 
 [flow1]
diff --git a/t/jobs/t0012.fio b/t/jobs/t0012.fio
index 985eb16b..03fea627 100644
--- a/t/jobs/t0012.fio
+++ b/t/jobs/t0012.fio
@@ -8,7 +8,7 @@
 bs=4k
 ioengine=null
 size=100g
-runtime=3
+runtime=10
 flow_id=1
 gtod_cpu=1
 

