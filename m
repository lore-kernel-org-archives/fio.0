Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729191AbgIGMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 Sep 2020 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CF6C061756
        for <fio@vger.kernel.org>; Mon,  7 Sep 2020 05:00:05 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFFoa-0008Hv-Gt
        for fio@vger.kernel.org; Mon, 07 Sep 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200907120002.0611A1BC0127@kernel.dk>
Date: Mon,  7 Sep 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8b38f40138047975ea7a59b9ce06681ffdd2c31d:

  fio: support io_size=N% (N <= 100) (2020-09-05 09:37:59 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 03eabd8a7a53c80a6c9d1376b38a9b7ddce2268a:

  Merge branch 'guasi_fixes' of https://github.com/sitsofe/fio into master (2020-09-06 16:14:58 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fio 3.23
      Merge branch 'guasi_fixes' of https://github.com/sitsofe/fio into master

Sitsofe Wheeler (1):
      Makefile/configure: fix guasi build

 FIO-VERSION-GEN | 2 +-
 Makefile        | 1 +
 configure       | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index bf0fee99..5ee7735c 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.22
+DEF_VER=fio-3.23
 
 LF='
 '
diff --git a/Makefile b/Makefile
index 8e1ebc90..6678c2fd 100644
--- a/Makefile
+++ b/Makefile
@@ -108,6 +108,7 @@ ifdef CONFIG_LINUX_SPLICE
 endif
 ifdef CONFIG_GUASI
   guasi_SRCS = engines/guasi.c
+  guasi_LIBS = -lguasi
   ENGINES += guasi
 endif
 ifdef CONFIG_SOLARISAIO
diff --git a/configure b/configure
index 6d672fe5..81bfb270 100755
--- a/configure
+++ b/configure
@@ -1325,7 +1325,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "" "guasi"; then
+if compile_prog "" "-lguasi" "guasi"; then
   guasi="yes"
 fi
 print_config "GUASI" "$guasi"

