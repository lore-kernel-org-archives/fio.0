Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47521 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdBUNAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Feb 2017 08:00:13 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cgA3B-0005yn-2b
        for fio@vger.kernel.org; Tue, 21 Feb 2017 13:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170221130002.35F452C227F@kernel.dk>
Date: Tue, 21 Feb 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dbd39049ca473de7dc031cd9bf3efe992834323f:

  Revert "configure: Drop default CONFIG_LITTLE_ENDIAN for Cygwin" (2017-02-19 17:57:43 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 349cdc89ffebb8f3a9cf3ff5be6a9934b94f1b05:

  appveyor: add CI building of the Windows version of fio (2017-02-20 07:19:20 +0000)

----------------------------------------------------------------
Sitsofe Wheeler (1):
      appveyor: add CI building of the Windows version of fio

 appveyor.yml | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 appveyor.yml

---

Diff of recent changes:

diff --git a/appveyor.yml b/appveyor.yml
new file mode 100644
index 0000000..7543393
--- /dev/null
+++ b/appveyor.yml
@@ -0,0 +1,27 @@
+clone_depth: 50
+environment:
+  MAKEFLAGS: -j 2
+  matrix:
+    - platform: x86_64
+      BUILD_ARCH: x64
+      CYG_ROOT: C:\cygwin64
+      CONFIGURE_OPTIONS:
+    - platform: x86
+      BUILD_ARCH: x86
+      CYG_ROOT: C:\cygwin
+      CONFIGURE_OPTIONS: --build-32bit-win
+
+build_script:
+  - SET PATH=%CYG_ROOT%\bin;%PATH%
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure ${CONFIGURE_OPTIONS} && make.exe'
+
+after_build:
+  - cd os\windows && dobuild.cmd %BUILD_ARCH%
+
+test_script:
+  - SET PATH=%CYG_ROOT%\bin;%PATH%
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
+
+artifacts:
+  - path: os\windows\*.msi
+    name: msi
