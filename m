Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA6DC77B7A
	for <fio@archiver.kernel.org>; Thu, 25 May 2023 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbjEYMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 May 2023 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240300AbjEYMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 May 2023 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5208699
        for <fio@vger.kernel.org>; Thu, 25 May 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wkVWMkLQPJ5sibmdE4IjAzNF6kuXNIhHj1RCIku/lK8=; b=qYYC3tbHGHYCNb9DKh1J5GkSEM
        OfUbP7h9lwW2cpTlPVgnDSNih9tRmUOy3lvqd5lgA1+ENvANl56y8KGP1Je8wXSh+KWujRRPZEszN
        7Cio9Q9LluXNWoGIGiefzemsoxpgmm4GI/dDtRZkBgAMROj7Jk2DreXT2upLmWjoyGSS+tkQUXK0m
        40Vjj1FGqPklnHmee8oSccS9XXsDPcP5bETvC6CPqA9AKw3THnQzcQuJq6kuEOkxt+waaP03sFN6w
        o4u/v9S/kjSUQcpd09dzPFikN7ZY8hJWIWG7a7IWT9accPfdVtJHKJAMA9O6F1oHXC6U48GYRTlFb
        35D3dWEA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q29dU-00CALk-C3
        for fio@vger.kernel.org; Thu, 25 May 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 52F101BC015D; Thu, 25 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230525120001.52F101BC015D@kernel.dk>
Date:   Thu, 25 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5a649e2dddc4d8ad163b0cf57f7cea00a2e94a33:

  Fio 3.35 (2023-05-23 12:33:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 954b86f71b0718943796192be1a89ffb0da5a97c:

  ci: upload tagged GitHub Actions Windows installers as releases (2023-05-24 09:58:11 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      ci: stop using AppVeyor for Windows builds
      ci: upload tagged GitHub Actions Windows installers as releases

 .appveyor.yml            | 68 ------------------------------------------------
 .github/workflows/ci.yml |  7 ++++-
 README.rst               | 11 ++++----
 ci/appveyor-install.sh   | 43 ------------------------------
 4 files changed, 12 insertions(+), 117 deletions(-)
 delete mode 100644 .appveyor.yml
 delete mode 100755 ci/appveyor-install.sh

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
deleted file mode 100644
index a63cf24f..00000000
--- a/.appveyor.yml
+++ /dev/null
@@ -1,68 +0,0 @@
-clone_depth: 1 # NB: this stops FIO-VERSION-GEN making tag based versions
-
-image:
-  - Visual Studio 2019
-
-environment:
-  CYG_MIRROR: http://cygwin.mirror.constant.com
-  matrix:
-# --disable-tls for the msys2 build to work around
-# breakage with clang/lld 16.0.0-1
-    - ARCHITECTURE: x64
-      CC: clang
-      CONFIGURE_OPTIONS: --enable-pdb --disable-tls
-      DISTRO: msys2
-# Skip 32 bit clang build
-#    - ARCHITECTURE: x86
-#      CC: clang
-#      CONFIGURE_OPTIONS: --enable-pdb
-#      DISTRO: msys2
-    - ARCHITECTURE: x64
-      CONFIGURE_OPTIONS:
-      DISTRO: cygwin
-    - ARCHITECTURE: x86
-      CONFIGURE_OPTIONS: --build-32bit-win
-      DISTRO: cygwin
-
-install:
-  - if %DISTRO%==cygwin (
-      SET "PATH=C:\cygwin64\bin;C:\cygwin64;%PATH%"
-    )
-  - if %DISTRO%==msys2 if %ARCHITECTURE%==x86 (
-      SET "PATH=C:\msys64\mingw32\bin;C:\msys64\usr\bin;%PATH%"
-    )
-  - if %DISTRO%==msys2 if %ARCHITECTURE%==x64 (
-      SET "PATH=C:\msys64\mingw64\bin;C:\msys64\usr\bin;%PATH%"
-    )
-  - SET PATH=C:\Python38-x64;%PATH% # NB: Changed env variables persist to later sections
-  - SET PYTHONUNBUFFERED=TRUE
-  - bash.exe ci\appveyor-install.sh
-
-build_script:
-  - bash.exe configure --extra-cflags=-Werror --disable-native %CONFIGURE_OPTIONS%
-  - make.exe -j2
-
-after_build:
-  - file.exe fio.exe
-  - make.exe test
-  - 'cd os\windows && dobuild.cmd %ARCHITECTURE% && cd ..'
-  - ls.exe ./os/windows/*.msi
-  - ps: Get-ChildItem .\os\windows\*.msi | % { Push-AppveyorArtifact $_.FullName -FileName $_.Name -DeploymentName fio.msi }
-
-test_script:
-  - python.exe t/run-fio-tests.py --artifact-root test-artifacts --debug
-
-deploy:
-  - provider: GitHub
-    description: fio Windows installer
-    auth_token:                      # encrypted token from GitHub
-      secure: Tjj+xRQEV25P6dQgboUblTCKx/LtUOUav2bvzSCtwMhHMAxrrn2adod6nlTf0ItV
-    artifact: fio.msi                # upload installer to release assets
-    draft: false
-    prerelease: false
-    on:
-      APPVEYOR_REPO_TAG: true        # deploy on tag push only
-      DISTRO: cygwin
-
-on_finish:
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -d test-artifacts ] && 7z a -t7z test-artifacts.7z test-artifacts -xr!foo.0.0 -xr!latency.?.0 -xr!fio_jsonplus_clat2csv.test && appveyor PushArtifact test-artifacts.7z'
diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index dd2997f0..69fedf77 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -108,12 +108,17 @@ jobs:
         dobuild.cmd ${{ matrix.installer_arch }}
         cd ..\..
 
-    - name: Upload installer (Windows)
+    - name: Upload installer as artifact (Windows)
       if: ${{ contains( matrix.build, 'windows' ) }}
       uses: actions/upload-artifact@v3
       with:
         name: ${{ matrix.build }}-installer
         path: os\windows\*.msi
+    - name: Upload installer as release for tagged builds (Windows)
+      uses: softprops/action-gh-release@v1
+      if: ${{ startsWith(github.ref, 'refs/tags/') && startsWith(matrix.build, 'windows-cygwin') }}
+      with:
+        files: os/windows/*.msi
     - name: Remove dependency files to resolve Makefile Cygwin sed issue (Windows)
       if: ${{ startsWith(matrix.build, 'windows-cygwin') }}
       run: rm *.d */*.d */*/*.d
diff --git a/README.rst b/README.rst
index 8f6208e3..dd521daf 100644
--- a/README.rst
+++ b/README.rst
@@ -123,11 +123,12 @@ Solaris:
 	``pkgutil -i fio``.
 
 Windows:
-	Beginning with fio 3.31 Windows installers are available on GitHub at
-        https://github.com/axboe/fio/releases. The latest builds for Windows
-	can also be grabbed from https://ci.appveyor.com/project/axboe/fio by
-	clicking the latest x86 or x64 build and then selecting the Artifacts
-	tab.
+        Beginning with fio 3.31 Windows installers for tagged releases are
+        available on GitHub at https://github.com/axboe/fio/releases. The
+        latest installers for Windows can also be obtained as GitHub Actions
+        artifacts by selecting a build from
+        https://github.com/axboe/fio/actions. These require logging in to a
+        GitHub account.
 
 BSDs:
 	Packages for BSDs may be available from their binary package repositories.
diff --git a/ci/appveyor-install.sh b/ci/appveyor-install.sh
deleted file mode 100755
index 1e28c454..00000000
--- a/ci/appveyor-install.sh
+++ /dev/null
@@ -1,43 +0,0 @@
-#!/bin/bash
-# The PATH to appropriate distro commands must already be set before invoking
-# this script
-# The following environment variables must be set:
-# PLATFORM={i686,x64}
-# DISTRO={cygwin,msys2}
-# The following environment can optionally be set:
-# CYG_MIRROR=<URL>
-set -eu
-
-case "${ARCHITECTURE}" in
-    "x64")
-        PACKAGE_ARCH="x86_64"
-        ;;
-    "x86")
-        PACKAGE_ARCH="i686"
-        ;;
-esac
-
-echo "Installing packages..."
-case "${DISTRO}" in
-    "cygwin")
-        CYG_MIRROR=${CYG_MIRROR:-"http://cygwin.mirror.constant.com"}
-        setup-x86_64.exe --quiet-mode --no-shortcuts --only-site \
-            --site "${CYG_MIRROR}" --packages \
-            "mingw64-${PACKAGE_ARCH}-CUnit,mingw64-${PACKAGE_ARCH}-zlib"
-        ;;
-    "msys2")
-        #pacman --noconfirm -Syuu # MSYS2 core update
-        #pacman --noconfirm -Syuu # MSYS2 normal update
-        pacman.exe --noconfirm -S \
-            mingw-w64-${PACKAGE_ARCH}-clang \
-            mingw-w64-${PACKAGE_ARCH}-cunit \
-            mingw-w64-${PACKAGE_ARCH}-toolchain \
-            mingw-w64-${PACKAGE_ARCH}-lld
-        pacman.exe -Q # List installed packages
-        ;;
-esac
-
-python.exe -m pip install scipy six statsmodels
-
-echo "Python3 path: $(type -p python3 2>&1)"
-echo "Python3 version: $(python3 -V 2>&1)"
