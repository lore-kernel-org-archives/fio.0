Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47628 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfI1MAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Sep 2019 08:00:07 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEBOP-00038x-4T
        for fio@vger.kernel.org; Sat, 28 Sep 2019 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190928120001.5D65E2C02C4@kernel.dk>
Date: Sat, 28 Sep 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 106a71cd6c24f31fce9d95c49e00ff4b28aa6fdc:

  t/zbd: Avoid magic number of test case count (2019-09-26 00:47:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e2defc22798dcd884356fbbaf8856689839b52e5:

  configure: add --enable-libaio-uring parameter (2019-09-27 13:51:12 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      configure: add --enable-libaio-uring parameter

 configure | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index b174a6fc..59da2f7e 100755
--- a/configure
+++ b/configure
@@ -150,6 +150,7 @@ disable_native="no"
 march_set="no"
 libiscsi="no"
 libnbd="no"
+libaio_uring="no"
 prefix=/usr/local
 
 # parse options
@@ -212,6 +213,8 @@ for opt do
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
+  --enable-libaio-uring) libaio_uring="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -250,6 +253,7 @@ if test "$show_help" = "yes" ; then
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
   echo "--disable-tcmalloc	Disable tcmalloc support"
+  echo "--enable-libaio-uring   Enable libaio emulated over io_uring"
   exit $exit_val
 fi
 
@@ -603,17 +607,23 @@ int main(void)
   return 0;
 }
 EOF
-  if compile_prog "" "-laio" "libaio" ; then
+  if test "$libaio_uring" = "yes" && compile_prog "" "-luring" "libaio io_uring" ; then
+    libaio=yes
+    LIBS="-luring $LIBS"
+  elif compile_prog "" "-laio" "libaio" ; then
     libaio=yes
+    libaio_uring=no
     LIBS="-laio $LIBS"
   else
     if test "$libaio" = "yes" ; then
       feature_not_found "linux AIO" "libaio-dev or libaio-devel"
     fi
     libaio=no
+    libaio_uring=no
   fi
 fi
 print_config "Linux AIO support" "$libaio"
+print_config "Linux AIO over io_uring" "$libaio_uring"
 
 ##########################################
 # posix aio probe
@@ -2449,6 +2459,9 @@ if test "$zlib" = "yes" ; then
 fi
 if test "$libaio" = "yes" ; then
   output_sym "CONFIG_LIBAIO"
+  if test "$libaio_uring" = "yes" ; then
+    output_sym "CONFIG_LIBAIO_URING"
+  fi
 fi
 if test "$posix_aio" = "yes" ; then
   output_sym "CONFIG_POSIXAIO"

