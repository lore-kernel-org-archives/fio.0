Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47298 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030915AbeCANAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Mar 2018 08:00:19 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1erNol-00046J-IW
        for fio@vger.kernel.org; Thu, 01 Mar 2018 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180301130002.8DA742C0085@kernel.dk>
Date: Thu,  1 Mar 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 68ae273e7544ebafeef721281b9bda5d42d66f4c:

  Merge branch 'master' of https://github.com/brycepg/fio (2018-02-27 16:15:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e09d68c8da4ab91397490577454de928106651f5:

  Merge branch 'win_build' of https://github.com/sitsofe/fio (2018-02-28 09:44:08 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      configure: improve static zlib package warning
      Merge branch 'win_build' of https://github.com/sitsofe/fio

Sitsofe Wheeler (3):
      appveyor: minor refactoring, clarifications
      windows: minor windows installer improvements
      windows: document MinGW zlib install and remove custom zlib search

 README                 |   4 +++-
 appveyor.yml           |  12 +++++-------
 configure              |  17 +++++------------
 os/windows/dobuild.cmd |  12 +++++++++++-
 os/windows/eula.rtf    | Bin 1072 -> 1075 bytes
 os/windows/install.wxs |   8 ++++----
 6 files changed, 28 insertions(+), 25 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index fc28b16..fba5f10 100644
--- a/README
+++ b/README
@@ -172,7 +172,9 @@ directory.
 How to compile fio on 64-bit Windows:
 
  1. Install Cygwin (http://www.cygwin.com/). Install **make** and all
-    packages starting with **mingw64-i686** and **mingw64-x86_64**.
+    packages starting with **mingw64-i686** and **mingw64-x86_64**. Ensure
+    **mingw64-i686-zlib** and **mingw64-x86_64-zlib** are installed if you wish
+    to enable fio's log compression functionality.
  2. Open the Cygwin Terminal.
  3. Go to the fio directory (source files).
  4. Run ``make clean && make -j``.
diff --git a/appveyor.yml b/appveyor.yml
index 844afa5..c6c3689 100644
--- a/appveyor.yml
+++ b/appveyor.yml
@@ -1,30 +1,28 @@
-clone_depth: 1
+clone_depth: 1 # NB: this stops FIO-VERSION-GEN making tag based versions
+
 environment:
   CYG_MIRROR: http://cygwin.mirror.constant.com
   CYG_ROOT: C:\cygwin64
   MAKEFLAGS: -j 2
   matrix:
-    - platform: x86_64
-      BUILD_ARCH: x64
+    - platform: x64
       PACKAGE_ARCH: x86_64
       CONFIGURE_OPTIONS:
     - platform: x86
-      BUILD_ARCH: x86
       PACKAGE_ARCH: i686
       CONFIGURE_OPTIONS: --build-32bit-win
 
 install:
   - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib" > NULL'
+  - SET PATH=%CYG_ROOT%\bin;%PATH% #��NB: Changed env variables persist to later sections
 
 build_script:
-  - SET PATH=%CYG_ROOT%\bin;%PATH%
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
 
 after_build:
-  - cd os\windows && dobuild.cmd %BUILD_ARCH%
+  - cd os\windows && dobuild.cmd %PLATFORM%
 
 test_script:
-  - SET PATH=%CYG_ROOT%\bin;%PATH%
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
 
 artifacts:
diff --git a/configure b/configure
index 2b99ce9..2e8eb18 100755
--- a/configure
+++ b/configure
@@ -320,18 +320,8 @@ CYGWIN*)
   if test -z "${CC}${cross_prefix}"; then
     if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
       cc="i686-w64-mingw32-gcc"
-      if test -e "../zlib/contrib/vstudio/vc14/x86/ZlibStatReleaseWithoutAsm/zlibstat.lib"; then
-        echo "Building with zlib support"
-        output_sym "CONFIG_ZLIB"
-        echo "LIBS=../zlib/contrib/vstudio/vc14/x86/ZlibStatReleaseWithoutAsm/zlibstat.lib" >> $config_host_mak
-      fi
     else
       cc="x86_64-w64-mingw32-gcc"
-      if test -e "../zlib/contrib/vstudio/vc14/x64/ZlibStatReleaseWithoutAsm/zlibstat.lib"; then
-        echo "Building with zlib support"
-        output_sym "CONFIG_ZLIB"
-        echo "LIBS=../zlib/contrib/vstudio/vc14/x64/ZlibStatReleaseWithoutAsm/zlibstat.lib" >> $config_host_mak
-      fi
     fi
   fi
   if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
@@ -359,7 +349,7 @@ CYGWIN*)
   static_assert="yes"
   ipv6="yes"
   mkdir_two="no"
-  echo "BUILD_CFLAGS=$CFLAGS -I../zlib -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
+  echo "BUILD_CFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
   ;;
 esac
 
@@ -2376,7 +2366,10 @@ if test "$disable_opt" = "yes" ; then
   output_sym "CONFIG_DISABLE_OPTIMIZATIONS"
 fi
 if test "$zlib" = "no" ; then
-  echo "Consider installing zlib-dev (zlib-devel or zlib-static), some fio features depend on it."
+  echo "Consider installing zlib-dev (zlib-devel, some fio features depend on it."
+  if test "$build_static" = "yes"; then
+    echo "Note that some distros have separate packages for static libraries."
+  fi
 fi
 if test "$cuda" = "yes" ; then
   output_sym "CONFIG_CUDA"
diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
index fd54a9c..ef12d82 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -6,6 +6,16 @@ for /f "tokens=3" %%i in (..\..\FIO-VERSION-FILE) do (
  set /a counter+=1
 )
 
+for /f "tokens=2 delims=-" %%i in ("%FIO_VERSION%") do (
+ set FIO_VERSION_NUMBERS=%%i
+)
+
+if not defined FIO_VERSION_NUMBERS (
+  echo Could not find version numbers in the string '%FIO_VERSION%'
+  echo Expected version to follow format 'fio-^([0-9]+.[0-9.]+^)'
+  goto end
+)
+
 if "%1"=="x86" set FIO_ARCH=x86
 if "%1"=="x64" set FIO_ARCH=x64
 
@@ -16,7 +26,7 @@ if not defined FIO_ARCH (
   goto end
 )
 
-"%WIX%bin\candle" -nologo -arch %FIO_ARCH% install.wxs
+"%WIX%bin\candle" -nologo -arch %FIO_ARCH% -dFioVersionNumbers="%FIO_VERSION_NUMBERS%" install.wxs
 @if ERRORLEVEL 1 goto end
 "%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs
 @if ERRORLEVEL 1 goto end
diff --git a/os/windows/eula.rtf b/os/windows/eula.rtf
index 1c92932..b2798bb 100755
Binary files a/os/windows/eula.rtf and b/os/windows/eula.rtf differ
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 577af55..73b2810 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -1,7 +1,7 @@
 <?xml version="1.0" encoding="utf-8"?>
 <Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
 
-	<?if $(env.FIO_ARCH) = x86 ?>
+	<?if $(sys.BUILDARCH) = x86 ?>
 		<?define ProgramDirectory = ProgramFilesFolder ?>
 	<?else?>
 		<?define ProgramDirectory = ProgramFiles64Folder ?>
@@ -10,9 +10,9 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.5">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="$(var.FioVersionNumbers)">
 		<Package
-		  Description="Flexible IO Tester"
+		  Description="Flexible I/O Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
 		  Languages="1033" Manufacturer="fio"
 		  InstallScope="perMachine" InstallPrivileges="elevated" Compressed="yes"/>
@@ -48,7 +48,7 @@
 			</Directory>
 	</Directory>
 
-	<Feature Id="AlwaysInstall" Absent="disallow" ConfigurableDirectory="INSTALLDIR" Display="hidden" Level="1" Title="Flexible IO Tester">
+	<Feature Id="AlwaysInstall" Absent="disallow" ConfigurableDirectory="INSTALLDIR" Display="hidden" Level="1" Title="Flexible I/O Tester">
 		<ComponentRef Id="fio.exe"/>
 		<ComponentRef Id="HOWTO"/>
 		<ComponentRef Id="README"/>
