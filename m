Return-Path: <rebecca@bsdio.com>
From: Rebecca Cran <rebecca@bsdio.com>
Date: Tue,  3 Nov 2020 02:47:41 +0000
Message-Id: <20201103024741.1958-1-rebecca@bsdio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: [PATCH] Windows: update dobuild.cmd to run the configure/make
To: fio@vger.kernel.org
Cc: Rebecca Cran <rebecca@bsdio.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Add a new shell script, _domake.sh which runs under Cygwin. This
is invoked via dobuild.cmd to run the configure and make steps of
the build. In this way, a single command, run from a Developer Command
Prompt, can be used to go from a clean workspace to a final installer
binary.

Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
---
 os/windows/_domake.sh  | 17 +++++++++++++++++
 os/windows/dobuild.cmd | 23 +++++++++++++----------
 2 files changed, 30 insertions(+), 10 deletions(-)
 create mode 100755 os/windows/_domake.sh

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
+if [ "$1" =3D "x86" ]; then
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
 @echo off=0D
 setlocal enabledelayedexpansion=0D
+=0D
+if "%1"=3D=3D"x86" set FIO_ARCH=3Dx86=0D
+if "%1"=3D=3D"x64" set FIO_ARCH=3Dx64=0D
+=0D
+if not defined FIO_ARCH (=0D
+  echo Error: must specify the architecture.=0D
+  echo Usage: dobuild x86=0D
+  echo Usage: dobuild x64=0D
+  goto end=0D
+)=0D
+=0D
+C:\Cygwin64\bin\bash -l %cd%/_domake.sh %FIO_ARCH% %cd%=0D
+=0D
 set /a counter=3D1=0D
 for /f "tokens=3D3" %%i in (..\..\FIO-VERSION-FILE) do (=0D
  if "!counter!"=3D=3D"1" set FIO_VERSION=3D%%i=0D
@@ -16,16 +29,6 @@ if not defined FIO_VERSION_NUMBERS (
   goto end=0D
 )=0D
 =0D
-if "%1"=3D=3D"x86" set FIO_ARCH=3Dx86=0D
-if "%1"=3D=3D"x64" set FIO_ARCH=3Dx64=0D
-=0D
-if not defined FIO_ARCH (=0D
-  echo Error: must specify the architecture.=0D
-  echo Usage: dobuild x86=0D
-  echo Usage: dobuild x64=0D
-  goto end=0D
-)=0D
-=0D
 if defined SIGN_FIO (=0D
   signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\f=
io.exe=0D
   signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /t=
d sha256 /fd sha256 ..\..\fio.exe=0D
--=20
2.29.2



