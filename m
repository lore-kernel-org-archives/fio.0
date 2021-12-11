Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE5CC433EF
	for <fio@archiver.kernel.org>; Sat, 11 Dec 2021 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhLKNAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 11 Dec 2021 08:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhLKNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 11 Dec 2021 08:00:07 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DE4C061714
        for <fio@vger.kernel.org>; Sat, 11 Dec 2021 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1LwioXs1XiKgMcRjS3tmMqDYE1azToIV2yUQ/4jVv1U=; b=mbSG1BxTh40uRqAVHQApyHt7DM
        myV4152lEG/xtYIe0VCBwQIdAhyD6R44JJ/7RD541RqlB06HNLO8kSdIpuIa5/lcexBEhi8VCTO+f
        ebi3ZgU95Sy+OdZG++JUm5zxOpcf3vTIWupCxQqocRxAba8HgqEp/OMFX1TMp7qv+weVW2hOrapwx
        qGOp4CXc/9dfFoDRTU+CkvawhZR8DLq3h206KD9sb6oIXrJPzfPIH2aoV2bG7BYSFZIB6xEuj8wKd
        9MZl1FGtXz5B2gHEGcvpp34J0jJ+LXJVIr2eHPWF0ehD/tDCpe76+k8UN5SVcNpfucQPeMWrb/53Y
        D7H8tWTg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mw1yu-000k56-Lg
        for fio@vger.kernel.org; Sat, 11 Dec 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id A2E481BC016E; Sat, 11 Dec 2021 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211211130001.A2E481BC016E@kernel.dk>
Date:   Sat, 11 Dec 2021 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 79eb6c9a17de959d72ee51c601b2764225101282:

  ioengines: libzbc: disable libzbc block backend driver (2021-12-09 21:34:21 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2ea393df3256e44398558c264f035f8db7656b08:

  Merge branch 'github-actions' of https://github.com/sitsofe/fio (2021-12-10 11:08:26 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'github-actions' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      ci: add CI via GitHub Actions
      ci: retire travis configuration

 .github/workflows/ci.yml | 45 ++++++++++++++++++++++++
 .travis.yml              | 37 --------------------
 ci/actions-build.sh      | 37 ++++++++++++++++++++
 ci/actions-full-test.sh  | 15 ++++++++
 ci/actions-install.sh    | 91 ++++++++++++++++++++++++++++++++++++++++++++++++
 ci/actions-smoke-test.sh | 10 ++++++
 ci/common.sh             | 34 ++++++++++++++++++
 ci/travis-build.sh       | 32 -----------------
 ci/travis-install.sh     | 65 ----------------------------------
 9 files changed, 232 insertions(+), 134 deletions(-)
 create mode 100644 .github/workflows/ci.yml
 delete mode 100644 .travis.yml
 create mode 100755 ci/actions-build.sh
 create mode 100755 ci/actions-full-test.sh
 create mode 100755 ci/actions-install.sh
 create mode 100755 ci/actions-smoke-test.sh
 create mode 100644 ci/common.sh
 delete mode 100755 ci/travis-build.sh
 delete mode 100755 ci/travis-install.sh

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
new file mode 100644
index 00000000..a766cfa8
--- /dev/null
+++ b/.github/workflows/ci.yml
@@ -0,0 +1,45 @@
+name: CI
+
+on:
+  push:
+  pull_request:
+
+jobs:
+  build:
+    runs-on: ${{ matrix.os }}
+    strategy:
+      fail-fast: false
+      matrix:
+        build:
+        - linux-gcc
+        - linux-clang
+        - macos
+        - linux-i686-gcc
+        include:
+        - build: linux-gcc
+          os: ubuntu-20.04
+          cc: gcc
+        - build: linux-clang
+          os: ubuntu-20.04
+          cc: clang
+        - build: macos
+          os: macos-10.15
+        - build: linux-i686-gcc
+          os: ubuntu-20.04
+          arch: i686
+
+    env:
+      CI_TARGET_ARCH: ${{ matrix.arch }}
+      CC: ${{ matrix.cc }}
+
+    steps:
+    - name: Checkout repo
+      uses: actions/checkout@v2
+    - name: Install dependencies
+      run: ./ci/actions-install.sh
+    - name: Build
+      run: ./ci/actions-build.sh
+    - name: Smoke test
+      run: ./ci/actions-smoke-test.sh
+    - name: Full test
+      run: ./ci/actions-full-test.sh
diff --git a/.travis.yml b/.travis.yml
deleted file mode 100644
index e35aff39..00000000
--- a/.travis.yml
+++ /dev/null
@@ -1,37 +0,0 @@
-language: c
-dist: bionic
-os:
-  - linux
-compiler:
-  - clang
-  - gcc
-arch:
-  - amd64
-  - arm64
-env:
-  global:
-    - MAKEFLAGS="-j 2"
-matrix:
-  include:
-    - os: linux
-      compiler: gcc
-      arch: amd64
-      env: BUILD_ARCH="x86" # Only do the gcc x86 build to reduce clutter
-    # Default xcode image
-    - os: osx
-      compiler: clang # Workaround travis setting CC=["clang", "gcc"]
-      arch: amd64
-    # Latest xcode image (needs periodic updating)
-    - os: osx
-      compiler: clang
-      osx_image: xcode11.2
-      arch: amd64
-  exclude:
-    - os: osx
-      compiler: gcc
-
-install:
-  - ci/travis-install.sh
-
-script:
-  - ci/travis-build.sh
diff --git a/ci/actions-build.sh b/ci/actions-build.sh
new file mode 100755
index 00000000..74a6fdcb
--- /dev/null
+++ b/ci/actions-build.sh
@@ -0,0 +1,37 @@
+#!/bin/bash
+# This script expects to be invoked from the base fio directory.
+set -eu
+
+SCRIPT_DIR=$(dirname "$0")
+# shellcheck disable=SC1091
+. "${SCRIPT_DIR}/common.sh"
+
+main() {
+    local extra_cflags="-Werror"
+    local configure_flags=()
+
+    set_ci_target_os
+    case "${CI_TARGET_OS}" in
+        "linux")
+            case "${CI_TARGET_ARCH}" in
+                "i686")
+                    extra_cflags="${extra_cflags} -m32"
+                    export LDFLAGS="-m32"
+                    ;;
+                "x86_64")
+                    configure_flags+=(
+                        "--enable-cuda"
+                        "--enable-libiscsi"
+                        "--enable-libnbd"
+                    )
+                    ;;
+            esac
+        ;;
+    esac
+    configure_flags+=(--extra-cflags="${extra_cflags}")
+
+    ./configure "${configure_flags[@]}"
+    make -j 2
+}
+
+main
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
new file mode 100755
index 00000000..4ae1dba1
--- /dev/null
+++ b/ci/actions-full-test.sh
@@ -0,0 +1,15 @@
+#!/bin/bash
+# This script expects to be invoked from the base fio directory.
+set -eu
+
+main() {
+    echo "Running long running tests..."
+    export PYTHONUNBUFFERED="TRUE"
+    if [[ "${CI_TARGET_ARCH}" == "arm64" ]]; then
+        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
+    else
+        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
+    fi
+}
+
+main
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
new file mode 100755
index 00000000..7408ccb4
--- /dev/null
+++ b/ci/actions-install.sh
@@ -0,0 +1,91 @@
+#!/bin/bash
+# This script expects to be invoked from the base fio directory.
+set -eu
+
+SCRIPT_DIR=$(dirname "$0")
+# shellcheck disable=SC1091
+. "${SCRIPT_DIR}/common.sh"
+
+install_ubuntu() {
+    local pkgs
+
+    cat <<DPKGCFG | sudo tee /etc/dpkg/dpkg.cfg.d/dpkg-speedup > /dev/null
+# Skip fsync
+force-unsafe-io
+# Don't install documentation
+path-exclude=/usr/share/man/*
+path-exclude=/usr/share/locale/*/LC_MESSAGES/*.mo
+path-exclude=/usr/share/doc/*
+DPKGCFG
+    # Packages available on i686 and x86_64
+    pkgs=(
+        libaio-dev
+        libcunit1-dev
+        libcurl4-openssl-dev
+        libfl-dev
+        libibverbs-dev
+        libnuma-dev
+        librdmacm-dev
+        valgrind
+    )
+    case "${CI_TARGET_ARCH}" in
+        "i686")
+            sudo dpkg --add-architecture i386
+            pkgs=("${pkgs[@]/%/:i386}")
+            pkgs+=(
+                gcc-multilib
+                pkg-config:i386
+                zlib1g-dev:i386
+            )
+            ;;
+        "x86_64")
+            pkgs+=(
+                libglusterfs-dev
+                libgoogle-perftools-dev
+                libiscsi-dev
+                libnbd-dev
+                libpmem-dev
+                libpmemblk-dev
+                librbd-dev
+                libtcmalloc-minimal4
+                nvidia-cuda-dev
+            )
+            ;;
+    esac
+
+    # Architecture-independent packages and packages for which we don't
+    # care about the architecture.
+    pkgs+=(
+        python3-scipy
+    )
+
+    echo "Updating APT..."
+    sudo apt-get -qq update
+    echo "Installing packages..."
+    sudo apt-get install -o APT::Immediate-Configure=false --no-install-recommends -qq -y "${pkgs[@]}"
+}
+
+install_linux() {
+    install_ubuntu
+}
+
+install_macos() {
+    # Assumes homebrew and python3 are already installed
+    #echo "Updating homebrew..."
+    #brew update >/dev/null 2>&1
+    echo "Installing packages..."
+    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit
+    pip3 install scipy six
+}
+
+main() {
+    set_ci_target_os
+
+    install_function="install_${CI_TARGET_OS}"
+    ${install_function}
+
+    echo "Python3 path: $(type -p python3 2>&1)"
+    echo "Python3 version: $(python3 -V 2>&1)"
+}
+
+main
diff --git a/ci/actions-smoke-test.sh b/ci/actions-smoke-test.sh
new file mode 100755
index 00000000..c129c89f
--- /dev/null
+++ b/ci/actions-smoke-test.sh
@@ -0,0 +1,10 @@
+#!/bin/bash
+# This script expects to be invoked from the base fio directory.
+set -eu
+
+main() {
+    echo "Running smoke tests..."
+    make test
+}
+
+main
diff --git a/ci/common.sh b/ci/common.sh
new file mode 100644
index 00000000..8861f843
--- /dev/null
+++ b/ci/common.sh
@@ -0,0 +1,34 @@
+# shellcheck shell=bash
+
+function set_ci_target_os {
+    # Function that exports CI_TARGET_OS to the current OS if it is not already
+    # set.
+
+    # Don't override CI_TARGET_OS if already set
+    CI_TARGET_OS=${CI_TARGET_OS:-}
+    if [[ -z ${CI_TARGET_OS} ]]; then
+        # Detect operating system
+        case "${OSTYPE}" in
+            linux*)
+                CI_TARGET_OS="linux"
+                ;;
+            darwin*)
+                CI_TARGET_OS="macos"
+                ;;
+            msys*)
+                CI_TARGET_OS="windows"
+                ;;
+            bsd*)
+                CI_TARGET_OS="bsd"
+                ;;
+            *)
+                CI_TARGET_OS=""
+        esac
+    fi
+
+    # Don't override CI_TARGET_ARCH if already set
+    CI_TARGET_ARCH=${CI_TARGET_ARCH:-}
+    if [[ -z ${CI_TARGET_ARCH} ]]; then
+        CI_TARGET_ARCH="$(uname -m)"
+    fi
+}
diff --git a/ci/travis-build.sh b/ci/travis-build.sh
deleted file mode 100755
index 923d882d..00000000
--- a/ci/travis-build.sh
+++ /dev/null
@@ -1,32 +0,0 @@
-#!/bin/bash
-set -eu
-
-CI_TARGET_ARCH="${BUILD_ARCH:-$TRAVIS_CPU_ARCH}"
-EXTRA_CFLAGS="-Werror"
-export PYTHONUNBUFFERED=TRUE
-CONFIGURE_FLAGS=()
-
-case "$TRAVIS_OS_NAME" in
-    "linux")
-        CONFIGURE_FLAGS+=(--enable-libiscsi)
-        case "$CI_TARGET_ARCH" in
-            "x86")
-                EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32"
-                export LDFLAGS="-m32"
-                ;;
-            "amd64")
-                CONFIGURE_FLAGS+=(--enable-cuda)
-                ;;
-        esac
-    ;;
-esac
-CONFIGURE_FLAGS+=(--extra-cflags="${EXTRA_CFLAGS}")
-
-./configure "${CONFIGURE_FLAGS[@]}" &&
-    make &&
-    make test &&
-    if [[ "$CI_TARGET_ARCH" == "arm64" ]]; then
-        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
-    else
-        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
-    fi
diff --git a/ci/travis-install.sh b/ci/travis-install.sh
deleted file mode 100755
index 4c4c04c5..00000000
--- a/ci/travis-install.sh
+++ /dev/null
@@ -1,65 +0,0 @@
-#!/bin/bash
-set -eu
-
-CI_TARGET_ARCH="${BUILD_ARCH:-$TRAVIS_CPU_ARCH}"
-case "$TRAVIS_OS_NAME" in
-    "linux")
-	# Architecture-dependent packages.
-	pkgs=(
-	    libaio-dev
-	    libcunit1-dev
-	    libfl-dev
-	    libgoogle-perftools-dev
-	    libibverbs-dev
-	    libiscsi-dev
-	    libnuma-dev
-	    librbd-dev
-	    librdmacm-dev
-	    libz-dev
-	)
-	case "$CI_TARGET_ARCH" in
-	    "x86")
-		pkgs=("${pkgs[@]/%/:i386}")
-		pkgs+=(
-		    gcc-multilib
-		    pkg-config:i386
-	        )
-		;;
-	    "amd64")
-		pkgs+=(nvidia-cuda-dev)
-		;;
-	esac
-	if [[ $CI_TARGET_ARCH != "x86" ]]; then
-		pkgs+=(glusterfs-common)
-	fi
-	# Architecture-independent packages and packages for which we don't
-	# care about the architecture.
-	pkgs+=(
-	    bison
-	    flex
-	    python3
-	    python3-scipy
-	    python3-six
-	)
-	sudo apt-get -qq update
-	sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}"
-	# librpma is supported on the amd64 (x86_64) architecture for now
-	if [[ $CI_TARGET_ARCH == "amd64" ]]; then
-		# install libprotobuf-c-dev required by librpma_gpspm
-		sudo apt-get install --no-install-recommends -qq -y libprotobuf-c-dev
-		# PMDK libraries have to be installed, because
-		# libpmem is a dependency of the librpma fio engine
-		ci/travis-install-pmdk.sh
-		# install librpma from sources from GitHub
-		ci/travis-install-librpma.sh
-	fi
-	;;
-    "osx")
-	brew update >/dev/null 2>&1
-	brew install cunit
-	pip3 install scipy six
-	;;
-esac
-
-echo "Python3 path: $(type -p python3 2>&1)"
-echo "Python3 version: $(python3 -V 2>&1)"
