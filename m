Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897A0C43334
	for <fio@archiver.kernel.org>; Fri, 24 Jun 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiFXMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 24 Jun 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiFXMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Jun 2022 08:00:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CDA7E00F
        for <fio@vger.kernel.org>; Fri, 24 Jun 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=kT/IDZT0FsaIY2XxEhCYXxadnNsW4jbBWCbNC3vcaAw=; b=GxM/9JPX8rywdXoKaVAdEBbsWp
        s/6VuWW3zKUAB5xT8dW2wafSlhOO9eCxM5sCG3KHF/nlAJlZwTiAnrYj41Gj/5GSEHc6SrrxworJP
        5FIrinGKqRpAv9DDMtDoNBBdlwMrwZDafC3xH2ZJDhCiLLyay/oHYTsj9G6F3/za2Wk+carDpWwWZ
        3X0+0/HkRKdJ9TxMvIh1m+KxT3dl6ivSlRzGVCW3Y2sEudeiK2nGYOFVsFJqEt2tWP12lySen0i7p
        cn1WFf8mokBsZbaSSYkC1lmgYGxDysYyV2t2VxBT+6Lm+0pOJK2Jya7Z4M9fhqPIGYQxTK+BWJUN9
        Y0oFH8NA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4hym-00CBeX-Da
        for fio@vger.kernel.org; Fri, 24 Jun 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B747A1BC015F; Fri, 24 Jun 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220624120001.B747A1BC015F@kernel.dk>
Date:   Fri, 24 Jun 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6aaebfbe7269f95164ac83a04505869f96f5f83a:

  configure: add option to disable xnvme build (2022-06-22 11:45:32 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 660879102e32a0ed3d3225afaebcc0d46625a4a6:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-06-23 08:20:22 -0600)

----------------------------------------------------------------
Bart Van Assche (2):
      ci/travis-*: Fix shellcheck warnings
      ci: Verify the Android build

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 .github/workflows/ci.yml     |  5 +++++
 ci/actions-build.sh          | 19 +++++++++++++++++--
 ci/actions-full-test.sh      |  2 ++
 ci/actions-install.sh        |  7 +++++++
 ci/actions-smoke-test.sh     |  2 ++
 ci/travis-install-librpma.sh |  6 +++---
 ci/travis-install-pmdk.sh    |  9 +++++----
 7 files changed, 41 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index cd8ce142..650366b2 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -15,6 +15,7 @@ jobs:
         - linux-clang
         - macos
         - linux-i686-gcc
+        - android
         include:
         - build: linux-gcc
           os: ubuntu-20.04
@@ -27,8 +28,12 @@ jobs:
         - build: linux-i686-gcc
           os: ubuntu-20.04
           arch: i686
+        - build: android
+          os: ubuntu-20.04
+          arch: aarch64-linux-android32
 
     env:
+      CI_TARGET_BUILD: ${{ matrix.build }}
       CI_TARGET_ARCH: ${{ matrix.arch }}
       CC: ${{ matrix.cc }}
 
diff --git a/ci/actions-build.sh b/ci/actions-build.sh
index 74a6fdcb..2b3de8e3 100755
--- a/ci/actions-build.sh
+++ b/ci/actions-build.sh
@@ -11,8 +11,23 @@ main() {
     local configure_flags=()
 
     set_ci_target_os
-    case "${CI_TARGET_OS}" in
-        "linux")
+    case "${CI_TARGET_BUILD}/${CI_TARGET_OS}" in
+        android/*)
+            export UNAME=Android
+            if [ -z "${CI_TARGET_ARCH}" ]; then
+                echo "Error: CI_TARGET_ARCH has not been set"
+                return 1
+            fi
+            NDK=$PWD/android-ndk-r24/toolchains/llvm/prebuilt/linux-x86_64/bin
+            export PATH="${NDK}:${PATH}"
+            export LIBS="-landroid"
+            CC=${NDK}/${CI_TARGET_ARCH}-clang
+            if [ ! -e "${CC}" ]; then
+                echo "Error: could not find ${CC}"
+                return 1
+            fi
+            ;;
+        */linux)
             case "${CI_TARGET_ARCH}" in
                 "i686")
                     extra_cflags="${extra_cflags} -m32"
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 8282002f..d1675f6e 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -3,6 +3,8 @@
 set -eu
 
 main() {
+    [ "${CI_TARGET_BUILD}" = android ] && return 0
+
     echo "Running long running tests..."
     export PYTHONUNBUFFERED="TRUE"
     if [[ "${CI_TARGET_ARCH}" == "arm64" ]]; then
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 0e472717..ff514926 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -83,6 +83,13 @@ install_macos() {
 }
 
 main() {
+    if [ "${CI_TARGET_BUILD}" = "android" ]; then
+	echo "Installing Android NDK..."
+	wget --quiet https://dl.google.com/android/repository/android-ndk-r24-linux.zip
+	unzip -q android-ndk-r24-linux.zip
+	return 0
+    fi
+
     set_ci_target_os
 
     install_function="install_${CI_TARGET_OS}"
diff --git a/ci/actions-smoke-test.sh b/ci/actions-smoke-test.sh
index c129c89f..3196f6a1 100755
--- a/ci/actions-smoke-test.sh
+++ b/ci/actions-smoke-test.sh
@@ -3,6 +3,8 @@
 set -eu
 
 main() {
+    [ "${CI_TARGET_BUILD}" = "android" ] && return 0
+
     echo "Running smoke tests..."
     make test
 }
diff --git a/ci/travis-install-librpma.sh b/ci/travis-install-librpma.sh
index b127f3f5..4e5ed21d 100755
--- a/ci/travis-install-librpma.sh
+++ b/ci/travis-install-librpma.sh
@@ -16,7 +16,7 @@ cmake .. -DCMAKE_BUILD_TYPE=Release \
 	-DBUILD_DOC=OFF \
 	-DBUILD_EXAMPLES=OFF \
 	-DBUILD_TESTS=OFF
-make -j$(nproc)
-sudo make -j$(nproc) install
-cd $WORKDIR
+make -j"$(nproc)"
+sudo make -j"$(nproc)" install
+cd "$WORKDIR"
 rm -rf $ZIP_FILE rpma-${LIBRPMA_VERSION}
diff --git a/ci/travis-install-pmdk.sh b/ci/travis-install-pmdk.sh
index 3b0b5bbc..7bde9fd0 100755
--- a/ci/travis-install-pmdk.sh
+++ b/ci/travis-install-pmdk.sh
@@ -12,7 +12,8 @@ WORKDIR=$(pwd)
 #    /bin/sh: 1: clang: not found
 # if CC is not set to the full path of clang.
 #
-export CC=$(type -P $CC)
+CC=$(type -P "$CC")
+export CC
 
 # Install PMDK libraries, because PMDK's libpmem
 # is a dependency of the librpma fio engine.
@@ -22,7 +23,7 @@ export CC=$(type -P $CC)
 wget https://github.com/pmem/pmdk/releases/download/${PMDK_VERSION}/pmdk-${PMDK_VERSION}.tar.gz
 tar -xzf pmdk-${PMDK_VERSION}.tar.gz
 cd pmdk-${PMDK_VERSION}
-make -j$(nproc) NDCTL_ENABLE=n
-sudo make -j$(nproc) install prefix=/usr NDCTL_ENABLE=n
-cd $WORKDIR
+make -j"$(nproc)" NDCTL_ENABLE=n
+sudo make -j"$(nproc)" install prefix=/usr NDCTL_ENABLE=n
+cd "$WORKDIR"
 rm -rf pmdk-${PMDK_VERSION}
