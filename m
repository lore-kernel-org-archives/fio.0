Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaIMMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 13 Sep 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XSlzp-00042E-FZ
	for fio@vger.kernel.org; Sat, 13 Sep 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140913120003.EAD5E403DD@lyth.info>
Date: Sat, 13 Sep 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 44c8268d6e6d3b3f1efb1eb8a1c2d7bba1e8477b:

  server: fix wrong use of exit() in server when daemonized (2014-09-11 17:05:58 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8a91fd4b0d42c730d48b5cd672df869609975a0a:

  Fio 2.1.12 (2014-09-12 12:09:32 -0600)

----------------------------------------------------------------
fio v2.1.12

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.1.12

 FIO-VERSION-GEN        |    2 +-
 os/windows/install.wxs |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 9982b1f..d36c76d 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.11
+DEF_VER=fio-2.1.12
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 3643c8a..18918cc 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.11">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.12">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
