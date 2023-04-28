Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64F5C77B61
	for <fio@archiver.kernel.org>; Fri, 28 Apr 2023 12:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345949AbjD1MAW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Apr 2023 08:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345951AbjD1MAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Apr 2023 08:00:18 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F9E2D5B
        for <fio@vger.kernel.org>; Fri, 28 Apr 2023 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=l8VF481OG5dV6zq4MqcdUxvc21rxXuQfe/taRa+qlvE=; b=TD7EhyfCYwJn7SvcQvqpGGta0B
        mPSZEGwvhijRX6PT0n7hlYmd9VKk6M1Wc4WxhuYlOCAI5ILZApUTy3VwJlWd4W+vOgASqXl15Ryvy
        V38IhAkBRJvrOq42u4gnxs7ZNO8EXJu8LA5As2O9K+KrlCRzB3B6IIReZb5Il0wPQcwtWhDEqf8JQ
        0OsWiZnTNvjDxoLa2wPa11gmzQX3TxD/CBYGDL4Fg+fPjahOV67gy9JtymnouJXNo10W17rGnfvNt
        kMmTBd57MPkaB62zDuDNYRlAqh7/IyTHT9aowV+6UwXBCAoLECK/kXNFeEWGLss4IyHr35dW7WbGq
        0FPEFieg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1psMlf-00DK9G-2Q
        for fio@vger.kernel.org;
        Fri, 28 Apr 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 98C4A1BC0167; Fri, 28 Apr 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230428120001.98C4A1BC0167@kernel.dk>
Date:   Fri, 28 Apr 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 9724b4f5ebf0841087c5a56c1d83efe0f4aeb6d7:

  Revert "zbd: Report the zone capacity" (2023-04-27 05:08:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0771592f81fcb032e261b18212477ceffc6cdac5:

  Merge branch 'master' of https://github.com/bvanassche/fio (2023-04-27 17:08:41 -0600)

----------------------------------------------------------------
Anuj Gupta (1):
      t/io_uring: avoid null-ptr dereference in case setup_ring fails

Bart Van Assche (2):
      Detect ASharedMemory_create() support
      ci: Also test the Android recovery environment

Jens Axboe (2):
      t/io_uring: make submitter_init() return < 0 on error
      Merge branch 'master' of https://github.com/bvanassche/fio

Vincent Fu (2):
      ci: add Windows Cygwin and msys2 builds to GitHub Actions
      ci: work around for GitHub Actions Cygwin sed issue

 .github/workflows/ci.yml | 82 +++++++++++++++++++++++++++++++++++++++++++++---
 ci/actions-build.sh      | 18 +++++++++--
 ci/actions-full-test.sh  |  5 ++-
 ci/actions-install.sh    | 18 +++++++----
 ci/actions-smoke-test.sh |  5 ++-
 ci/common.sh             |  2 +-
 configure                | 20 ++++++++++++
 os/os-ashmem.h           |  4 +--
 t/io_uring.c             | 37 ++++++++++++++++------
 9 files changed, 163 insertions(+), 28 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 4bc91d3e..dd2997f0 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -16,6 +16,9 @@ jobs:
         - macos
         - linux-i686-gcc
         - android
+        - windows-cygwin-64
+        - windows-cygwin-32
+        - windows-msys2-64
         include:
         - build: linux-gcc
           os: ubuntu-22.04
@@ -31,6 +34,25 @@ jobs:
         - build: android
           os: ubuntu-22.04
           arch: aarch64-linux-android32
+        - build: android-recovery
+          os: ubuntu-22.04
+          arch: aarch64-linux-android32
+        - build: windows-cygwin-64
+          os: windows-latest
+          arch: x86_64
+          installer_arch: x64
+          shell: bash
+        - build: windows-cygwin-32
+          os: windows-latest
+          arch: i686
+          installer_arch: x86
+          shell: bash
+        - build: windows-msys2-64
+          os: windows-latest
+          cc: clang
+          arch: x86_64
+          installer_arch: x64
+          shell: msys2
 
     env:
       CI_TARGET_BUILD: ${{ matrix.build }}
@@ -38,13 +60,65 @@ jobs:
       CC: ${{ matrix.cc }}
 
     steps:
+    - name: git config line endings (Windows)
+      if: ${{ contains( matrix.build, 'windows' ) }}
+      run: git config --global core.autocrlf input
     - name: Checkout repo
       uses: actions/checkout@v3
+    - name: Install Cygwin toolchain (Windows)
+      if: ${{ startsWith(matrix.build, 'windows-cygwin') }}
+      uses: cygwin/cygwin-install-action@master
+      with:
+        packages: >
+          mingw64-${{matrix.arch}}-binutils
+          mingw64-${{matrix.arch}}-CUnit
+          mingw64-${{matrix.arch}}-curl
+          mingw64-${{matrix.arch}}-dlfcn
+          mingw64-${{matrix.arch}}-gcc-core
+          mingw64-${{matrix.arch}}-headers
+          mingw64-${{matrix.arch}}-runtime
+          mingw64-${{matrix.arch}}-zlib
+
+    - name: Install msys2 toolchain (Windows)
+      if: ${{ startsWith(matrix.build, 'windows-msys2') }}
+      uses: msys2/setup-msys2@v2
+      with:
+        install: >
+          git
+          base-devel
+          mingw-w64-${{matrix.arch}}-clang
+          mingw-w64-${{matrix.arch}}-cunit
+          mingw-w64-${{matrix.arch}}-toolchain
+          mingw-w64-${{matrix.arch}}-lld
+          mingw-w64-${{matrix.arch}}-python-scipy
+          mingw-w64-${{matrix.arch}}-python-six
+          mingw-w64-${{matrix.arch}}-python-statsmodels
+          mingw-w64-${{matrix.arch}}-python-sphinx
+
     - name: Install dependencies
-      run: ./ci/actions-install.sh
+      run: ${{matrix.shell}} ./ci/actions-install.sh
+      if: ${{ !contains( matrix.build, 'msys2' ) }}
     - name: Build
-      run: ./ci/actions-build.sh
+      run:  ${{matrix.shell}} ./ci/actions-build.sh
+    - name: Build installer (Windows)
+      if: ${{ contains( matrix.build, 'windows' ) }}
+      shell: cmd
+      run: |
+        cd os\windows
+        dobuild.cmd ${{ matrix.installer_arch }}
+        cd ..\..
+
+    - name: Upload installer (Windows)
+      if: ${{ contains( matrix.build, 'windows' ) }}
+      uses: actions/upload-artifact@v3
+      with:
+        name: ${{ matrix.build }}-installer
+        path: os\windows\*.msi
+    - name: Remove dependency files to resolve Makefile Cygwin sed issue (Windows)
+      if: ${{ startsWith(matrix.build, 'windows-cygwin') }}
+      run: rm *.d */*.d */*/*.d
+      shell: bash
     - name: Smoke test
-      run: ./ci/actions-smoke-test.sh
+      run:  ${{matrix.shell}} ./ci/actions-smoke-test.sh
     - name: Full test
-      run: ./ci/actions-full-test.sh
+      run:  ${{matrix.shell}} ./ci/actions-full-test.sh
diff --git a/ci/actions-build.sh b/ci/actions-build.sh
index 2b3de8e3..351b8d18 100755
--- a/ci/actions-build.sh
+++ b/ci/actions-build.sh
@@ -12,7 +12,7 @@ main() {
 
     set_ci_target_os
     case "${CI_TARGET_BUILD}/${CI_TARGET_OS}" in
-        android/*)
+        android*/*)
             export UNAME=Android
             if [ -z "${CI_TARGET_ARCH}" ]; then
                 echo "Error: CI_TARGET_ARCH has not been set"
@@ -20,7 +20,9 @@ main() {
             fi
             NDK=$PWD/android-ndk-r24/toolchains/llvm/prebuilt/linux-x86_64/bin
             export PATH="${NDK}:${PATH}"
-            export LIBS="-landroid"
+            if [ "${CI_TARGET_BUILD}" = "android" ]; then
+                export LIBS="-landroid"
+            fi
             CC=${NDK}/${CI_TARGET_ARCH}-clang
             if [ ! -e "${CC}" ]; then
                 echo "Error: could not find ${CC}"
@@ -41,7 +43,17 @@ main() {
                     )
                     ;;
             esac
-        ;;
+	    ;;
+        */windows)
+	    configure_flags+=("--disable-native")
+            case "${CI_TARGET_ARCH}" in
+                "i686")
+		    configure_flags+=("--build-32bit-win")
+                    ;;
+                "x86_64")
+                    ;;
+            esac
+	    ;;
     esac
     configure_flags+=(--extra-cflags="${extra_cflags}")
 
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index d1675f6e..d2fb4201 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -3,7 +3,10 @@
 set -eu
 
 main() {
-    [ "${CI_TARGET_BUILD}" = android ] && return 0
+    case "${CI_TARGET_BUILD}" in
+	android*)
+	    return 0;;
+    esac
 
     echo "Running long running tests..."
     export PYTHONUNBUFFERED="TRUE"
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index fb3bd141..0d73ac97 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -89,13 +89,19 @@ install_macos() {
     pip3 install scipy six statsmodels
 }
 
+install_windows() {
+	pip3 install scipy six statsmodels sphinx
+}
+
 main() {
-    if [ "${CI_TARGET_BUILD}" = "android" ]; then
-	echo "Installing Android NDK..."
-	wget --quiet https://dl.google.com/android/repository/android-ndk-r24-linux.zip
-	unzip -q android-ndk-r24-linux.zip
-	return 0
-    fi
+    case "${CI_TARGET_BUILD}" in
+	android*)
+	    echo "Installing Android NDK..."
+	    wget --quiet https://dl.google.com/android/repository/android-ndk-r24-linux.zip
+	    unzip -q android-ndk-r24-linux.zip
+	    return 0
+	    ;;
+    esac
 
     set_ci_target_os
 
diff --git a/ci/actions-smoke-test.sh b/ci/actions-smoke-test.sh
index 3196f6a1..494462ac 100755
--- a/ci/actions-smoke-test.sh
+++ b/ci/actions-smoke-test.sh
@@ -3,7 +3,10 @@
 set -eu
 
 main() {
-    [ "${CI_TARGET_BUILD}" = "android" ] && return 0
+    case "${CI_TARGET_BUILD}" in
+	android*)
+	    return 0;;
+    esac
 
     echo "Running smoke tests..."
     make test
diff --git a/ci/common.sh b/ci/common.sh
index 8861f843..3cf6a416 100644
--- a/ci/common.sh
+++ b/ci/common.sh
@@ -15,7 +15,7 @@ function set_ci_target_os {
             darwin*)
                 CI_TARGET_OS="macos"
                 ;;
-            msys*)
+            cygwin|msys*)
                 CI_TARGET_OS="windows"
                 ;;
             bsd*)
diff --git a/configure b/configure
index abb6d016..ca03350b 100755
--- a/configure
+++ b/configure
@@ -1345,6 +1345,23 @@ if compile_prog "" "" "sync_file_range"; then
 fi
 print_config "sync_file_range" "$sync_file_range"
 
+##########################################
+# ASharedMemory_create() probe
+if test "$ASharedMemory_create" != "yes" ; then
+  ASharedMemory_create="no"
+fi
+cat > $TMPC << EOF
+#include <android/sharedmem.h>
+int main(int argc, char **argv)
+{
+  return ASharedMemory_create("", 0);
+}
+EOF
+if compile_prog "" "" "ASharedMemory_create"; then
+  ASharedMemory_create="yes"
+fi
+print_config "ASharedMemory_create" "$ASharedMemory_create"
+
 ##########################################
 # ext4 move extent probe
 if test "$ext4_me" != "yes" ; then
@@ -3011,6 +3028,9 @@ fi
 if test "$sync_file_range" = "yes" ; then
   output_sym "CONFIG_SYNC_FILE_RANGE"
 fi
+if test "$ASharedMemory_create" = "yes" ; then
+  output_sym "CONFIG_ASHAREDMEMORY_CREATE"
+fi
 if test "$sfaa" = "yes" ; then
   output_sym "CONFIG_SFAA"
 fi
diff --git a/os/os-ashmem.h b/os/os-ashmem.h
index c34ff656..80eab7c4 100644
--- a/os/os-ashmem.h
+++ b/os/os-ashmem.h
@@ -6,7 +6,7 @@
 #include <linux/ashmem.h>
 #include <linux/shm.h>
 #include <android/api-level.h>
-#if __ANDROID_API__ >= __ANDROID_API_O__
+#ifdef CONFIG_ASHAREDMEMORY_CREATE
 #include <android/sharedmem.h>
 #else
 #define ASHMEM_DEVICE	"/dev/ashmem"
@@ -27,7 +27,7 @@ static inline int shmctl(int __shmid, int __cmd, struct shmid_ds *__buf)
 	return ret;
 }
 
-#if __ANDROID_API__ >= __ANDROID_API_O__
+#ifdef CONFIG_ASHAREDMEMORY_CREATE
 static inline int shmget(key_t __key, size_t __size, int __shmflg)
 {
 	char keybuf[11];
diff --git a/t/io_uring.c b/t/io_uring.c
index 6b0efef8..bf0aa26e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1049,7 +1049,7 @@ static int submitter_init(struct submitter *s)
 
 		buf = allocate_mem(s, bs);
 		if (!buf)
-			return 1;
+			return -1;
 		s->iovecs[i].iov_base = buf;
 		s->iovecs[i].iov_len = bs;
 	}
@@ -1059,14 +1059,15 @@ static int submitter_init(struct submitter *s)
 		err = 0;
 	} else if (!aio) {
 		err = setup_ring(s);
-		sprintf(buf, "Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
+		if (!err)
+			sprintf(buf, "Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
 	} else {
 		sprintf(buf, "Engine=aio\n");
 		err = setup_aio(s);
 	}
 	if (err) {
 		printf("queue setup failed: %s, %d\n", strerror(errno), err);
-		return 1;
+		return -1;
 	}
 
 	if (!init_printed) {
@@ -1172,9 +1173,15 @@ static void *submitter_aio_fn(void *data)
 	struct iocb *iocbs;
 	struct io_event *events;
 #ifdef ARCH_HAVE_CPU_CLOCK
-	int nr_batch = submitter_init(s);
-#else
-	submitter_init(s);
+	int nr_batch;
+#endif
+
+	ret = submitter_init(s);
+	if (ret < 0)
+		goto done;
+
+#ifdef ARCH_HAVE_CPU_CLOCK
+	nr_batch = ret;
 #endif
 
 	iocbsptr = calloc(depth, sizeof(struct iocb *));
@@ -1238,6 +1245,7 @@ static void *submitter_aio_fn(void *data)
 	free(iocbsptr);
 	free(iocbs);
 	free(events);
+done:
 	finish = 1;
 	return NULL;
 }
@@ -1277,9 +1285,15 @@ static void *submitter_uring_fn(void *data)
 	struct io_sq_ring *ring = &s->sq_ring;
 	int ret, prepped;
 #ifdef ARCH_HAVE_CPU_CLOCK
-	int nr_batch = submitter_init(s);
-#else
-	submitter_init(s);
+	int nr_batch;
+#endif
+
+	ret = submitter_init(s);
+	if (ret < 0)
+		goto done;
+
+#ifdef ARCH_HAVE_CPU_CLOCK
+	nr_batch = ret;
 #endif
 
 	if (register_ring)
@@ -1383,6 +1397,7 @@ submit:
 	if (register_ring)
 		io_uring_unregister_ring(s);
 
+done:
 	finish = 1;
 	return NULL;
 }
@@ -1393,7 +1408,8 @@ static void *submitter_sync_fn(void *data)
 	struct submitter *s = data;
 	int ret;
 
-	submitter_init(s);
+	if (submitter_init(s) < 0)
+		goto done;
 
 	do {
 		uint64_t offset;
@@ -1429,6 +1445,7 @@ static void *submitter_sync_fn(void *data)
 			add_stat(s, s->clock_index, 1);
 	} while (!s->finish);
 
+done:
 	finish = 1;
 	return NULL;
 }
