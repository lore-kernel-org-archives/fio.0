Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgKFNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Nov 2020 08:00:07 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC18EC0613CF
        for <fio@vger.kernel.org>; Fri,  6 Nov 2020 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kb1LX-0000pg-Kl
        for fio@vger.kernel.org; Fri, 06 Nov 2020 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201106130002.10E421BC017B@kernel.dk>
Date: Fri,  6 Nov 2020 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 38c2f9384db8dbd93f59d965d70ab0d3a53343fa:

  Windows: update dobuild.cmd to run the configure/make (2020-11-04 16:43:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ea693b6e4501a1385bf62a01f6fb1f3609d31a4a:

  Revert "Windows: update dobuild.cmd to run the configure/make" (2020-11-05 15:33:00 -0700)

----------------------------------------------------------------
Albert Chang (2):
      Makefile: fix usage of JAVA_HOME environmental variable
      engines/hdfs: swap fio_hdfsio_init and fio_hdfsio_io_u_init

Jens Axboe (3):
      Merge branch 'patch-1' of https://github.com/gloit042/fio
      Merge branch 'master' of https://github.com/albert-chang0/fio
      Revert "Windows: update dobuild.cmd to run the configure/make"

gloit042 (1):
      goptions: correct postfix

 Makefile               |  2 +-
 engines/libhdfs.c      |  4 ++--
 goptions.c             |  2 +-
 os/windows/_domake.sh  | 17 -----------------
 os/windows/dobuild.cmd | 23 ++++++++++-------------
 5 files changed, 14 insertions(+), 34 deletions(-)
 delete mode 100755 os/windows/_domake.sh

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 48788f24..8c8a8fce 100644
--- a/Makefile
+++ b/Makefile
@@ -60,7 +60,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
-  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server -L$(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server $(FIO_LIBHDFS_LIB)/libhdfs.a -ljvm
+  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/lib/$(FIO_HDFS_CPU)/server -L$(JAVA_HOME)/lib/$(FIO_HDFS_CPU)/server $(FIO_LIBHDFS_LIB)/libhdfs.a -ljvm
   FIO_CFLAGS += $(HDFSFLAGS)
   SOURCE += engines/libhdfs.c
 endif
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index 9ca82f78..eb55c3c5 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -240,7 +240,7 @@ int fio_hdfsio_close_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static int fio_hdfsio_init(struct thread_data *td)
+static int fio_hdfsio_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
 	struct hdfsio_options *options = td->eo;
 	struct hdfsio_data *hd = td->io_ops_data;
@@ -349,7 +349,7 @@ static int fio_hdfsio_setup(struct thread_data *td)
 	return 0;
 }
 
-static int fio_hdfsio_io_u_init(struct thread_data *td, struct io_u *io_u)
+static int fio_hdfsio_init(struct thread_data *td)
 {
 	struct hdfsio_data *hd = td->io_ops_data;
 	struct hdfsio_options *options = td->eo;
diff --git a/goptions.c b/goptions.c
index f44254bf..0b8c56a2 100644
--- a/goptions.c
+++ b/goptions.c
@@ -826,7 +826,7 @@ static struct gopt *gopt_new_str_val(struct gopt_job_view *gjv,
 				     unsigned long long *p, unsigned int idx)
 {
 	struct gopt_str_val *g;
-	const gchar *postfix[] = { "B", "KiB", "MiB", "GiB", "PiB", "PiB", "" };
+	const gchar *postfix[] = { "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB" };
 	GtkWidget *label;
 	int i;
 
diff --git a/os/windows/_domake.sh b/os/windows/_domake.sh
deleted file mode 100755
index 05625ff4..00000000
--- a/os/windows/_domake.sh
+++ /dev/null
@@ -1,17 +0,0 @@
-#!/usr/bin/env bash
-
-set -e
-
-cd "$2"
-cd ../..
-if [ -e "fio.exe" ]; then
-  make clean
-fi
-
-if [ "$1" = "x86" ]; then
-  ./configure --disable-native --build-32bit-win
-else
-  ./configure --disable-native
-fi
-
-make -j
diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
index ea79dd03..08df3e87 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -1,18 +1,5 @@
 @echo off
 setlocal enabledelayedexpansion
-
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
-C:\Cygwin64\bin\bash -l %cd%/_domake.sh %FIO_ARCH% %cd%
-
 set /a counter=1
 for /f "tokens=3" %%i in (..\..\FIO-VERSION-FILE) do (
  if "!counter!"=="1" set FIO_VERSION=%%i
@@ -29,6 +16,16 @@ if not defined FIO_VERSION_NUMBERS (
   goto end
 )
 
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
 if defined SIGN_FIO (
   signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\fio.exe
   signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 ..\..\fio.exe

