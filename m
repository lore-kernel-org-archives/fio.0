Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45102 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbcIMMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Sep 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bjmNf-0000oG-LZ
        for fio@vger.kernel.org; Tue, 13 Sep 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160913120001.EE6842C1A70@kernel.dk>
Date: Tue, 13 Sep 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5e333ada464c885d2a33a30e98812bfb666e6052:

  init: pass in right pointer to def thread options free (2016-09-11 19:14:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 247e54360a9dff433e815f91b500073fe3c1a820:

  Makefile: fixup java path for libhdfs (2016-09-12 08:10:45 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Makefile: fixup java path for libhdfs

 Makefile  | 2 +-
 configure | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 3f67ab7..6b5548a 100644
--- a/Makefile
+++ b/Makefile
@@ -49,7 +49,7 @@ SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
-  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/`uname -m`/server -L$(JAVA_HOME)/jre/lib/`uname -m`/server -ljvm $(FIO_LIBHDFS_LIB)/libhdfs.a
+  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server -L$(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server -ljvm $(FIO_LIBHDFS_LIB)/libhdfs.a
   CFLAGS += $(HDFSFLAGS)
   SOURCE += engines/libhdfs.c
 endif
diff --git a/configure b/configure
index 93c3720..2851f54 100755
--- a/configure
+++ b/configure
@@ -1489,6 +1489,10 @@ if test "$libhdfs" = "yes" ; then
   if test "$hdfs_conf_error" = "1" ; then
     exit 1
   fi
+  FIO_HDFS_CPU=$cpu
+  if test "$FIO_HDFS_CPU" = "x86_64" ; then
+    FIO_HDFS_CPU="amd64"
+  fi
 fi
 echo "HDFS engine                   $libhdfs"
 
@@ -1829,6 +1833,7 @@ if test "$gf_trim" = "yes" ; then
 fi
 if test "$libhdfs" = "yes" ; then
   output_sym "CONFIG_LIBHDFS"
+  echo "FIO_HDFS_CPU=$FIO_HDFS_CPU" >> $config_host_mak
   echo "JAVA_HOME=$JAVA_HOME" >> $config_host_mak
   echo "FIO_LIBHDFS_INCLUDE=$FIO_LIBHDFS_INCLUDE" >> $config_host_mak
   echo "FIO_LIBHDFS_LIB=$FIO_LIBHDFS_LIB" >> $config_host_mak
