Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60402 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbdKGNAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Nov 2017 08:00:18 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eC3UI-0006xI-0Y
        for fio@vger.kernel.org; Tue, 07 Nov 2017 13:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171107130002.632BF2C02AF@kernel.dk>
Date: Tue,  7 Nov 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9f50b4106bd1d6fa1c325900d1fb286832ccc5e8:

  Fio 3.2 (2017-11-03 15:23:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3b973af558aa0802e2c8193e9afac4cd49af3ca0:

  Merge branch 'fix-libhdfs' of https://github.com/follitude/fio (2017-11-06 09:11:07 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-libhdfs' of https://github.com/follitude/fio

follitude (1):
      Makefile: tiny fix of libhdfs

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 76243ff..2893348 100644
--- a/Makefile
+++ b/Makefile
@@ -51,7 +51,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
-  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server -L$(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server -ljvm $(FIO_LIBHDFS_LIB)/libhdfs.a
+  HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server -L$(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server $(FIO_LIBHDFS_LIB)/libhdfs.a -ljvm
   CFLAGS += $(HDFSFLAGS)
   SOURCE += engines/libhdfs.c
 endif
