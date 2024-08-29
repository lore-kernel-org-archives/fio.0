Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB320193078
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724932811; cv=none; b=hMUy2WXUbsmrccKYFCGcjpvkDGXWxHTZbOtmpYX+Tp69SwfxmLof0mEBV6ZxXjdL7qw8qlp2rmuonzNu5or5I/fiej9qIeDVNriuLlRo+bjLyeeVengslc0bTIuBSuDuRSvnQsrtWAoiMiANg7ZBhLRvA7Lp45oU2+ALgSitVzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724932811; c=relaxed/simple;
	bh=WMStBmZ23W2M+PoXwmadl3sdesHBPxS4veKzqtOL6sU=;
	h=Subject:From:To:Message-Id:Date; b=IDVgZUbHzqNKeKaBTUHnUXgru4W2PQFtRrjiLxo8uzg9vCokG02SJ/9a6IPG0HutX8FX1ERG9nDhFLJVy7nN4Q/dOeSCrVO7OV/Y6VVJDj20b3WU9030U9R5YxcuXlJNKEi/BTugYbiRTvyXnhJ1LNMcF0pYRnsUwlP7/ICU0nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RT1XbGXB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RT1XbGXB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zlZz2Rs3HV8f1ud5uSSzgy7sx+54eSRa2mImYdaQTGw=; b=RT1XbGXB7nBRg9A5+UjL08fNz9
	0c/WV3dfv9lJUP/nJ8Fg4MXwPI1DXjtcFmoMM9sWrov8+B2v3oA32XJ4RLN6NLnzE+rhL79hfC9FE
	zOhIywP1hbHzKK1KXwG67qG7ia73DEIKv9wo3e08HItADzGAFvjQ19zwyIK8nhE+kAjpo3bWreDdu
	0JW6F+shudOCqV1tNSCvxzs01FkrI4DV0Vt71siHN8NCd1g1AcEgES0k6TZr+enR/iBXr6dXCm+0v
	yx35ZuqonCKcwIBYO4ccw6IGphRcoS9fpxRjtnkmndjuV0hqKn+QlKBzrxcMAC8FcEcPMauUnt1Lf
	heYYhZvw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sjdoq-000000021jI-3gaT
	for fio@vger.kernel.org;
	Thu, 29 Aug 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 950A21BC012E; Thu, 29 Aug 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240829120001.950A21BC012E@kernel.dk>
Date: Thu, 29 Aug 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2d416331db2735031e85c8da64ce93382796799b:

  ci: install isal packages for testing (2024-08-21 20:31:46 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2a26258077b987ddba0633d07aaec0abfb5462a2:

  ci: add containers for Alma, Oracle, and Rocky Linux (2024-08-27 18:29:54 +0000)

----------------------------------------------------------------
Vincent Fu (2):
      ci: install updated bash on macOS platforms via workflow
      ci: add containers for Alma, Oracle, and Rocky Linux

 .github/workflows/ci.yml |   6 +++
 ci/actions-build.sh      |   2 +-
 ci/actions-install.sh    | 103 +++++++++++++++++++++++++++++++++++------------
 3 files changed, 84 insertions(+), 27 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 1601aa9e..6fbba591 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -14,6 +14,9 @@ jobs:
         container:
         - {os: 'debian', dh: 'debian', ver: 'bookworm', target_arch: 'x86_64'}
         - {os: 'fedora', dh: 'fedora', ver: '40', target_arch: 'x86_64'}
+        - {os: 'alma', dh: 'almalinux', ver: '9', target_arch: 'x86_64'}
+        - {os: 'oracle', dh: 'oraclelinux', ver: '9', target_arch: 'x86_64'}
+        - {os: 'rocky', dh: 'rockylinux', ver: '9', target_arch: 'x86_64'}
         - {os: 'ubuntu', dh: 'ubuntu', ver: 'noble', target_arch: 'i686'}
         - {os: 'ubuntu', dh: 'ubuntu', ver: 'noble', target_arch: 'x86_64'}
 
@@ -127,6 +130,9 @@ jobs:
           mingw-w64-${{matrix.arch}}-python-statsmodels
           mingw-w64-${{matrix.arch}}-python-sphinx
 
+    - name: install bash 4 (macOS)
+      if: ${{ contains( matrix.build, 'macOS' ) }}
+      run:  HOMEBREW_NO_AUTO_UPDATE=1 brew install bash
     - name: Install dependencies
       run: ${{matrix.shell}} ./ci/actions-install.sh
       if: ${{ !contains( matrix.build, 'msys2' ) }}
diff --git a/ci/actions-build.sh b/ci/actions-build.sh
index de444a22..861ed3a8 100755
--- a/ci/actions-build.sh
+++ b/ci/actions-build.sh
@@ -38,7 +38,7 @@ main() {
                     ;;
 	    esac
 	    ;;&
-        */linux | */ubuntu | */debian | */fedora)
+        */linux | */ubuntu | */debian | */fedora | */alma | */oracle | */rocky)
             case "${CI_TARGET_ARCH}" in
                 "i686")
                     extra_cflags="${extra_cflags} -m32"
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 38d39de9..77c511af 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # This script expects to be invoked from the base fio directory.
 set -eu
 
@@ -102,36 +102,87 @@ DPKGCFG
     fi
 }
 
+# Fedora and related distributions
 install_fedora() {
-    dnf install -y \
-        bison-devel \
-        cmake \
-        cunit-devel \
-        flex-devel \
-        isa-l-devel \
-        kernel-devel \
-        libaio-devel \
-        libgfapi-devel \
-        libibverbs-devel \
-        libiscsi-devel \
-        libnbd-devel \
-        libnfs-devel \
-        libpmem-devel \
-        libpmem2-devel \
-        librbd-devel \
-        numactl-devel \
-        protobuf-c-devel \
-        python3-scipy \
-        python3-sphinx \
-        python3-statsmodels \
-        unzip \
-        valgrind-devel \
-        wget \
+    pkgs=(
+        bison-devel
+        git
+        cmake
+        flex-devel
+        gperftools
+        isa-l-devel
+        kernel-devel
+        libaio-devel
+        libibverbs-devel
+        libiscsi-devel
+        libnbd-devel
+        libnfs-devel
+        libpmem-devel
+        libpmem2-devel
+        librbd-devel
+        numactl-devel
+        protobuf-c-devel
+        python3-scipy
+        python3-sphinx
+        sudo
+        unzip
+        valgrind-devel
+        wget
+    )
+
+    case "${CI_TARGET_OS}" in
+        "fedora")
+            pkgs+=(
+                cunit-devel
+                libgfapi-devel
+                python3-statsmodels
+            )
+            ;;
+        "rocky" | "alma" | "oracle")
+            pkgs+=(
+                CUnit-devel
+                python-pip
+            )
+            ;;&
+        "rocky" | "alma")
+            pkgs+=(
+                glusterfs-api-devel
+            )
+            ;;
+    esac
+    dnf install -y "${pkgs[@]}"
 
     # install librpma from sources
     ci/actions-install-librpma.sh
 }
 
+install_rhel_clone() {
+    dnf install -y epel-release
+    install_fedora
+
+    # I could not find a python3-statsmodels package in the repos
+    pip3 install statsmodels
+}
+
+install_oracle() {
+    dnf config-manager --set-enabled ol9_codeready_builder
+    install_rhel_clone
+}
+
+install_alma() {
+    dnf install -y 'dnf-command(config-manager)'
+    dnf config-manager --set-enabled crb
+    dnf install -y almalinux-release-devel
+    install_rhel_clone
+}
+
+install_rocky() {
+    dnf install -y 'dnf-command(config-manager)'
+    dnf config-manager --set-enabled crb
+    dnf config-manager --set-enabled devel
+    install_rhel_clone
+}
+
 install_debian() {
     install_ubuntu
 }
@@ -145,7 +196,7 @@ install_macos() {
     #echo "Updating homebrew..."
     #brew update >/dev/null 2>&1
     echo "Installing packages..."
-    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs bash
+    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs
     pip3 install scipy six statsmodels sphinx
 }
 
