Return-Path: <rebecca@bsdio.com>
From: Rebecca Cran <rebecca@bsdio.com>
Date: Mon, 16 Nov 2020 03:03:21 +0000
Message-Id: <20201116030321.1957-1-rebecca@bsdio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: [PATCH] Windows: introduce fiobuild.cmd and fiopkg.cmd
To: fio@vger.kernel.org
Cc: Rebecca Cran <rebecca@bsdio.com>, Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

fiobuild.cmd automates the building process to pass the correct arguments
to configure to build fio for use on any x86 or x64 processor by using
--disable-native.

fiopkg.cmd optionally signs the binaries, builds the installer and signs
that too.

dobuild.cmd was misnamed, but is now used by CI. Keep it around, but
update it to just call fiopkg.cmd.

Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
---
 os/windows/_domake.sh   | 17 +++++++++++++
 os/windows/dobuild.cmd  | 53 +----------------------------------------
 os/windows/fiobuild.cmd | 17 +++++++++++++
 os/windows/fiopkg.cmd   | 52 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 52 deletions(-)
 create mode 100755 os/windows/_domake.sh
 create mode 100644 os/windows/fiobuild.cmd
 create mode 100644 os/windows/fiopkg.cmd

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
index 08df3e87..be73e6a6 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -1,52 +1 @@
-@echo off=0D
-setlocal enabledelayedexpansion=0D
-set /a counter=3D1=0D
-for /f "tokens=3D3" %%i in (..\..\FIO-VERSION-FILE) do (=0D
- if "!counter!"=3D=3D"1" set FIO_VERSION=3D%%i=0D
- set /a counter+=3D1=0D
-)=0D
-=0D
-for /f "tokens=3D2 delims=3D-" %%i in ("%FIO_VERSION%") do (=0D
- set FIO_VERSION_NUMBERS=3D%%i=0D
-)=0D
-=0D
-if not defined FIO_VERSION_NUMBERS (=0D
-  echo Could not find version numbers in the string '%FIO_VERSION%'=0D
-  echo Expected version to follow format 'fio-^([0-9]+.[0-9.]+^)'=0D
-  goto end=0D
-)=0D
-=0D
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
-if defined SIGN_FIO (=0D
-  signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\f=
io.exe=0D
-  signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /t=
d sha256 /fd sha256 ..\..\fio.exe=0D
-=0D
-  signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\t=
\*.exe=0D
-  signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /t=
d sha256 /fd sha256 ..\..\t\*.exe=0D
-)=0D
-=0D
-if exist ..\..\fio.pdb (=0D
-  set FIO_PDB=3Dtrue=0D
-) else (=0D
-  set FIO_PDB=3Dfalse=0D
-)=0D
-=0D
-"%WIX%bin\candle" -nologo -arch %FIO_ARCH% -dFioVersionNumbers=3D"%FIO_VER=
SION_NUMBERS%" -dFioPDB=3D"%FIO_PDB%" install.wxs=0D
-@if ERRORLEVEL 1 goto end=0D
-"%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs=0D
-@if ERRORLEVEL 1 goto end=0D
-"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj -ext W=
ixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi=0D
-:end=0D
-=0D
-if defined SIGN_FIO (=0D
-  signtool sign /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sh=
a256 /fd sha256 %FIO_VERSION%-%FIO_ARCH%.msi=0D
-)=0D
+fiopkg.cmd %1
\ No newline at end of file
diff --git a/os/windows/fiobuild.cmd b/os/windows/fiobuild.cmd
new file mode 100644
index 00000000..4a4171a2
--- /dev/null
+++ b/os/windows/fiobuild.cmd
@@ -0,0 +1,17 @@
+@echo off=0D
+setlocal enabledelayedexpansion=0D
+=0D
+if "%1"=3D=3D"x86" set FIO_ARCH=3Dx86=0D
+if "%1"=3D=3D"x64" set FIO_ARCH=3Dx64=0D
+=0D
+if not defined FIO_ARCH (=0D
+  echo Error: must specify the architecture.=0D
+  echo Usage: fiobuild x86=0D
+  echo Usage: fiobuild x64=0D
+  goto end=0D
+)=0D
+=0D
+C:\Cygwin64\bin\bash -l %cd%/_domake.sh %FIO_ARCH% %cd%=0D
+=0D
+=0D
+:end
\ No newline at end of file
diff --git a/os/windows/fiopkg.cmd b/os/windows/fiopkg.cmd
new file mode 100644
index 00000000..08df3e87
--- /dev/null
+++ b/os/windows/fiopkg.cmd
@@ -0,0 +1,52 @@
+@echo off=0D
+setlocal enabledelayedexpansion=0D
+set /a counter=3D1=0D
+for /f "tokens=3D3" %%i in (..\..\FIO-VERSION-FILE) do (=0D
+ if "!counter!"=3D=3D"1" set FIO_VERSION=3D%%i=0D
+ set /a counter+=3D1=0D
+)=0D
+=0D
+for /f "tokens=3D2 delims=3D-" %%i in ("%FIO_VERSION%") do (=0D
+ set FIO_VERSION_NUMBERS=3D%%i=0D
+)=0D
+=0D
+if not defined FIO_VERSION_NUMBERS (=0D
+  echo Could not find version numbers in the string '%FIO_VERSION%'=0D
+  echo Expected version to follow format 'fio-^([0-9]+.[0-9.]+^)'=0D
+  goto end=0D
+)=0D
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
+if defined SIGN_FIO (=0D
+  signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\f=
io.exe=0D
+  signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /t=
d sha256 /fd sha256 ..\..\fio.exe=0D
+=0D
+  signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\t=
\*.exe=0D
+  signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /t=
d sha256 /fd sha256 ..\..\t\*.exe=0D
+)=0D
+=0D
+if exist ..\..\fio.pdb (=0D
+  set FIO_PDB=3Dtrue=0D
+) else (=0D
+  set FIO_PDB=3Dfalse=0D
+)=0D
+=0D
+"%WIX%bin\candle" -nologo -arch %FIO_ARCH% -dFioVersionNumbers=3D"%FIO_VER=
SION_NUMBERS%" -dFioPDB=3D"%FIO_PDB%" install.wxs=0D
+@if ERRORLEVEL 1 goto end=0D
+"%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs=0D
+@if ERRORLEVEL 1 goto end=0D
+"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj -ext W=
ixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi=0D
+:end=0D
+=0D
+if defined SIGN_FIO (=0D
+  signtool sign /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sh=
a256 /fd sha256 %FIO_VERSION%-%FIO_ARCH%.msi=0D
+)=0D
--=20
2.29.2



