Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34928 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbDOMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Apr 2015 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YiLzC-0005Km-82
	for fio@vger.kernel.org; Wed, 15 Apr 2015 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150415120003.73C9F40187@lyth.info>
Date: Wed, 15 Apr 2015 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 92aef550de95c5b33c489cbabd2c1a70e59475b3:

  configure: update to changes in fusion-aw packaging (2015-04-09 08:24:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 89c176baca1170db809d4f46416e262851d00874:

  Fio 2.2.7 (2015-04-14 18:08:59 -0600)

----------------------------------------------------------------
fio v2.2.7

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.2.7

 FIO-VERSION-GEN        |    2 +-
 os/windows/install.wxs |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 9ae7b7d..22c9f68 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.6
+DEF_VER=fio-2.2.7
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 74f1d28..ba58b92 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.6">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.7">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
