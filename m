Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0F91C93D7
	for <fio@vger.kernel.org>; Thu, 22 Aug 2024 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724328015; cv=none; b=eh6UK+IWRE9Iw8ZuVMQr07aQwLIvLp2a/cG9Zw/kukRxXeeeP5x3YpzO72mZ2FU9PR2jO8bgMBEIdGPqKETvjn9dLH2ocaEDiCMYsvVb6Q1fjJr0bCla3mZpAXWcctl/M4X0MCpQd8j9OQFVeZSez983LU/1veRkkc1AfkCePJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724328015; c=relaxed/simple;
	bh=XVJKlggfo8Fmfm5nLTiU5+Doc6mOQMSA7rkKewj81Bw=;
	h=Subject:From:To:Message-Id:Date; b=q/85gH6qZXAWB8E/Rq9yK6H5I2iuWZt3f6/ElNWfeRjKk7iMKZIXbX2qK1bunFwsb+eJBs42WdPz3MHA5Jy8jg8qhUAmm++Y1CZLTKDjL1e+DDO1fLq0sUZCeBGukN1zTbY5Liv7UUm8Tuhle1UXB60oFfE3DUJCLtS/sSugUFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W998BTvb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W998BTvb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=82bHfj+EwD/EFpfGPXBuBk6Gv9FrqWEmo6BOk381RlQ=; b=W998BTvbwWBrpvWAKfFpxYUI7t
	+XpGceF6z+Q29L2Fa0wcbm4Vz1Uefgf2BVsoCPQr85pzJkRjS0be7ipXkf0htynCUg9CH6P5pEJ6g
	1/IiaGCqHGwG0ke245CEAoxBNmugQNaFTbDdrpUvr7Th+P8aKR4oLbnfSSyhsOL6DnKyUxRdRZqns
	QLRE/DxisO1SayL8zUbx2jCoXMJQ7G7AO2MWXyHNdV7N1rrI3bXxDP3Mxai5z7nET4Xp3JPlVKzIq
	ZDkbItGNve6D75kiLxYfodyYev0dP+ToLJWV4GYJI8KGjEKdzJAz6PrBpv40hwbP2ItVLJOO9UVhq
	l+XJREOw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh6U3-0000000ATRB-3dYr
	for fio@vger.kernel.org;
	Thu, 22 Aug 2024 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5C8D01BC0154; Thu, 22 Aug 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240822120001.5C8D01BC0154@kernel.dk>
Date: Thu, 22 Aug 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7bc12310ac39f8bf694a6785d027e4cee96dbbdf:

  Merge branch 'errdetails' of https://github.com/minwooim/fio (2024-08-16 08:21:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2d416331db2735031e85c8da64ce93382796799b:

  ci: install isal packages for testing (2024-08-21 20:31:46 +0000)

----------------------------------------------------------------
Vincent Fu (3):
      ci: remove arm64 case for tests
      ci: run tests in containers
      ci: install isal packages for testing

 .github/workflows/ci.yml | 32 ++++++++++++++++++++++++
 ci/actions-build.sh      | 14 ++++++++---
 ci/actions-full-test.sh  | 28 ++++++++++++++++++---
 ci/actions-install.sh    | 63 ++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 128 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index e53082c3..1601aa9e 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -5,6 +5,38 @@ on:
   pull_request:
 
 jobs:
+  build-containers:
+    runs-on: ubuntu-latest
+
+    strategy:
+      fail-fast: false
+      matrix:
+        container:
+        - {os: 'debian', dh: 'debian', ver: 'bookworm', target_arch: 'x86_64'}
+        - {os: 'fedora', dh: 'fedora', ver: '40', target_arch: 'x86_64'}
+        - {os: 'ubuntu', dh: 'ubuntu', ver: 'noble', target_arch: 'i686'}
+        - {os: 'ubuntu', dh: 'ubuntu', ver: 'noble', target_arch: 'x86_64'}
+
+    container:
+      image: ${{ matrix.container.dh }}:${{ matrix.container.ver }}
+      env:
+        CI_TARGET_BUILD: Linux
+        CI_TARGET_ARCH: ${{ matrix.container.target_arch }}
+        CI_TARGET_OS: ${{ matrix.container.os }}
+        CI_TARGET_OS_VER: ${{ matrix.container.ver }}
+
+    steps:
+    - name: Checkout repo
+      uses: actions/checkout@v4
+    - name: Install dependencies
+      run:  ./ci/actions-install.sh
+    - name: Build
+      run:  ./ci/actions-build.sh
+    - name: Smoke test
+      run:  ./ci/actions-smoke-test.sh
+    - name: Full test
+      run:  ./ci/actions-full-test.sh
+
   build:
     runs-on: ${{ matrix.os }}
     strategy:
diff --git a/ci/actions-build.sh b/ci/actions-build.sh
index 47d4f044..de444a22 100755
--- a/ci/actions-build.sh
+++ b/ci/actions-build.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # This script expects to be invoked from the base fio directory.
 set -eu
 
@@ -29,7 +29,16 @@ main() {
                 return 1
             fi
             ;;
-        */linux)
+        */linux | */ubuntu)
+            case "${CI_TARGET_ARCH}" in
+                "x86_64")
+                    configure_flags+=(
+                        "--enable-cuda"
+                    )
+                    ;;
+	    esac
+	    ;;&
+        */linux | */ubuntu | */debian | */fedora)
             case "${CI_TARGET_ARCH}" in
                 "i686")
                     extra_cflags="${extra_cflags} -m32"
@@ -37,7 +46,6 @@ main() {
                     ;;
                 "x86_64")
                     configure_flags+=(
-                        "--enable-cuda"
                         "--enable-libiscsi"
                         "--enable-libnbd"
                     )
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index d2fb4201..23bdd219 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -10,11 +10,31 @@ main() {
 
     echo "Running long running tests..."
     export PYTHONUNBUFFERED="TRUE"
-    if [[ "${CI_TARGET_ARCH}" == "arm64" ]]; then
-        python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
-    else
-        python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
+    skip=(
+        6
+	1007
+	1008
+    )
+    args=(
+        --debug
+    )
+    if [ "${GITHUB_JOB}" == "build-containers" ]; then
+        # io_uring is disabled in containers
+        # so skip the io_uring test
+        skip+=(
+            18
+        )
+	# cmd priority does not work in containers
+	# so skip the related latency test cases
+	args+=(
+	    -p
+            "1010:--skip 15 16 17 18 19 20 21 22"
+        )
+
     fi
+
+    echo python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
+    python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
     make -C doc html
 }
 
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 6eb2d795..38d39de9 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -9,6 +9,12 @@ SCRIPT_DIR=$(dirname "$0")
 install_ubuntu() {
     local pkgs
 
+    if [ "${GITHUB_JOB}" == "build-containers" ]; then
+        # containers run as root and do not have sudo
+        apt update
+        apt -y install sudo
+    fi
+
     cat <<DPKGCFG | sudo tee /etc/dpkg/dpkg.cfg.d/dpkg-speedup > /dev/null
 # Skip fsync
 force-unsafe-io
@@ -17,6 +23,7 @@ path-exclude=/usr/share/man/*
 path-exclude=/usr/share/locale/*/LC_MESSAGES/*.mo
 path-exclude=/usr/share/doc/*
 DPKGCFG
+
     # Packages available on i686 and x86_64
     pkgs=(
         libaio-dev
@@ -43,6 +50,7 @@ DPKGCFG
             pkgs+=(
                 libglusterfs-dev
                 libgoogle-perftools-dev
+                libisal-dev
                 libiscsi-dev
                 libnbd-dev
                 libpmem-dev
@@ -50,12 +58,18 @@ DPKGCFG
                 libprotobuf-c-dev
                 librbd-dev
                 libtcmalloc-minimal4
-                nvidia-cuda-dev
                 libibverbs-dev
                 librdmacm-dev
+	        pkg-config
             )
 	    echo "Removing libunwind-14-dev because of conflicts with libunwind-dev"
 	    sudo apt remove -y libunwind-14-dev
+	    if [ "${CI_TARGET_OS}" == "linux" ] || [ "${CI_TARGET_OS}" == "ubuntu" ]; then
+	        # Only for Ubuntu
+		pkgs+=(
+		   nvidia-cuda-dev
+		)
+	    fi
             ;;
     esac
 
@@ -66,6 +80,17 @@ DPKGCFG
 	python3-sphinx
 	python3-statsmodels
     )
+    if [ "${GITHUB_JOB}" == "build-containers" ]; then
+        pkgs+=(
+            bison
+            build-essential
+            cmake
+            flex
+            unzip
+            wget
+            zlib1g-dev
+        )
+    fi
 
     echo "Updating APT..."
     sudo apt-get -qq update
@@ -77,6 +102,40 @@ DPKGCFG
     fi
 }
 
+install_fedora() {
+    dnf install -y \
+        bison-devel \
+        cmake \
+        cunit-devel \
+        flex-devel \
+        isa-l-devel \
+        kernel-devel \
+        libaio-devel \
+        libgfapi-devel \
+        libibverbs-devel \
+        libiscsi-devel \
+        libnbd-devel \
+        libnfs-devel \
+        libpmem-devel \
+        libpmem2-devel \
+        librbd-devel \
+        numactl-devel \
+        protobuf-c-devel \
+        python3-scipy \
+        python3-sphinx \
+        python3-statsmodels \
+        unzip \
+        valgrind-devel \
+        wget \
+
+    # install librpma from sources
+    ci/actions-install-librpma.sh
+}
+
+install_debian() {
+    install_ubuntu
+}
+
 install_linux() {
     install_ubuntu
 }
@@ -86,7 +145,7 @@ install_macos() {
     #echo "Updating homebrew..."
     #brew update >/dev/null 2>&1
     echo "Installing packages..."
-    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs
+    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs bash
     pip3 install scipy six statsmodels sphinx
 }
 
