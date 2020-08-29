Return-Path: <rebecca@bsdio.com>
From: Rebecca Cran <rebecca@bsdio.com>
Date: Sat, 29 Aug 2020 23:25:50 +0000
Message-Id: <20200829232550.108-1-rebecca@bsdio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: [PATCH] Update os/windows/dobuild.cmd to support signing binaries/installer
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Rebecca Cran <rebecca@bsdio.com>
List-ID: <fio@vger.kernel.org>

Since organizations are increasingly requiring software to be digitally
signed, or have heuristics that penalize unsigned software, add support
to do build.cmd to sign both the .exe binaries and the .msi installer.

Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
---
 os/windows/dobuild.cmd | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
index ef12d82d..d06a2afa 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -26,9 +26,21 @@ if not defined FIO_ARCH (
   goto end=0D
 )=0D
 =0D
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
 "%WIX%bin\candle" -nologo -arch %FIO_ARCH% -dFioVersionNumbers=3D"%FIO_VER=
SION_NUMBERS%" install.wxs=0D
 @if ERRORLEVEL 1 goto end=0D
 "%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs=0D
 @if ERRORLEVEL 1 goto end=0D
 "%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj -ext W=
ixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi=0D
 :end=0D
+=0D
+if defined SIGN_FIO (=0D
+  signtool sign /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sh=
a256 /fd sha256 %FIO_VERSION%-%FIO_ARCH%.msi=0D
+)
\ No newline at end of file
--=20
2.28.0



