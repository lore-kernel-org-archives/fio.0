Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731046AbgKENAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 Nov 2020 08:00:09 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBF5C0613CF
        for <fio@vger.kernel.org>; Thu,  5 Nov 2020 05:00:08 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kaerz-0005te-Vs
        for fio@vger.kernel.org; Thu, 05 Nov 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201105130002.369721BC0131@kernel.dk>
Date: Thu,  5 Nov 2020 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 08a3f6fef1fe6c9fcd18d5ed40ca81097922bb14:

  fio: fix dynamic engines soname definition (2020-11-01 07:16:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 38c2f9384db8dbd93f59d965d70ab0d3a53343fa:

  Windows: update dobuild.cmd to run the configure/make (2020-11-04 16:43:14 -0700)

----------------------------------------------------------------
Rebecca Cran (1):
      Windows: update dobuild.cmd to run the configure/make

 os/windows/_domake.sh  | 17 +++++++++++++++++
 os/windows/dobuild.cmd | 23 +++++++++++++----------
 2 files changed, 30 insertions(+), 10 deletions(-)
 create mode 100755 os/windows/_domake.sh

---

Diff of recent changes:

diff --git a/os/windows/_domake.sh b/os/windows/_domake.sh
new file mode 100755
index 00000000..05625ff4
--- /dev/null
+++ b/os/windows/_domake.sh
@@ -0,0 +1,17 @@
+#!/usr/bin/env bash
+
+set -e
+
+cd "$2"
+cd ../..
+if [ -e "fio.exe" ]; then
+  make clean
+fi
+
+if [ "$1" = "x86" ]; then
+  ./configure --disable-native --build-32bit-win
+else
+  ./configure --disable-native
+fi
+
+make -j
diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
index 08df3e87..ea79dd03 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -1,5 +1,18 @@
 @echo off
 setlocal enabledelayedexpansion
+
+if "%1"=="x86" set FIO_ARCH=x86
+if "%1"=="x64" set FIO_ARCH=x64
+
+if not defined FIO_ARCH (
+  echo Error: must specify the architecture.
+  echo Usage: dobuild x86
+  echo Usage: dobuild x64
+  goto end
+)
+
+C:\Cygwin64\bin\bash -l %cd%/_domake.sh %FIO_ARCH% %cd%
+
 set /a counter=1
 for /f "tokens=3" %%i in (..\..\FIO-VERSION-FILE) do (
  if "!counter!"=="1" set FIO_VERSION=%%i
@@ -16,16 +29,6 @@ if not defined FIO_VERSION_NUMBERS (
   goto end
 )
 
-if "%1"=="x86" set FIO_ARCH=x86
-if "%1"=="x64" set FIO_ARCH=x64
-
-if not defined FIO_ARCH (
-  echo Error: must specify the architecture.
-  echo Usage: dobuild x86
-  echo Usage: dobuild x64
-  goto end
-)
-
 if defined SIGN_FIO (
   signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\fio.exe
   signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 ..\..\fio.exe

