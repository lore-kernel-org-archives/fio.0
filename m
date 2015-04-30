Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39803 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbbD3L7z (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 30 Apr 2015 07:59:55 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Ynn8E-0000GR-3t
	for fio@vger.kernel.org; Thu, 30 Apr 2015 11:59:54 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150430120001.BF9342C01B2@kernel.dk>
Date: Thu, 30 Apr 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 76a00ec6684317902e536365b89531431e7f8867:

  blktrace: only set O_DIRECT if the min bs is a multiple of 4k (2015-04-28 15:30:02 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 020d54bdf73e691b90b75d3abfd8e6f06cd1f637:

  configure: add support for --prefix (2015-04-29 10:29:16 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      configure: add support for --prefix

 Makefile  | 2 +-
 configure | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 9b7f27a..1b312cb 100644
--- a/Makefile
+++ b/Makefile
@@ -243,7 +243,7 @@ ifeq ($(CONFIG_TARGET_OS), SunOS)
 else
 	INSTALL = install
 endif
-prefix = /usr/local
+prefix = $(INSTALL_PREFIX)
 bindir = $(prefix)/bin
 
 ifeq ($(CONFIG_TARGET_OS), Darwin)
diff --git a/configure b/configure
index 8e496b0..0b9874b 100755
--- a/configure
+++ b/configure
@@ -135,11 +135,14 @@ show_help="no"
 exit_val=0
 gfio_check="no"
 libhdfs="no"
+prefix=/usr/local
 
 # parse options
 for opt do
   optarg=`expr "x$opt" : 'x[^=]*=\(.*\)'`
   case "$opt" in
+  --prefix=*) prefix="$optarg"
+  ;;
   --cpu=*) cpu="$optarg"
   ;;
   #  esx is cross compiled and cannot be detect through simple uname calls
@@ -178,6 +181,7 @@ for opt do
 done
 
 if test "$show_help" = "yes" ; then
+  echo "--prefix=              Use this directory as installation prefix"
   echo "--cpu=                 Specify target CPU if auto-detect fails"
   echo "--cc=                  Specify compiler to use"
   echo "--extra-cflags=        Specify extra CFLAGS to pass to compiler"
@@ -1612,3 +1616,4 @@ echo "CFLAGS+=$CFLAGS" >> $config_host_mak
 echo "LDFLAGS+=$LDFLAGS" >> $config_host_mak
 echo "CC=$cc" >> $config_host_mak
 echo "BUILD_CFLAGS=$BUILD_CFLAGS $CFLAGS" >> $config_host_mak
+echo "INSTALL_PREFIX=$prefix" >> $config_host_mak
