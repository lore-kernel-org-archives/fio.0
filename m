Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165AbaFLMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Jun 2014 08:00:08 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Wv3fq-0001HS-Fs
	for fio@vger.kernel.org; Thu, 12 Jun 2014 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140612120003.433E4403F8@lyth.info>
Date: Thu, 12 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 70afff5949ccad1196256763aab69b2528b55d88:

  iolog: remember to add bytes to total IO size (2014-06-09 19:56:51 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0ed2192dc4600ebef0715e748969b80fd58fe156:

  Fio 2.1.10 (2014-06-10 13:18:38 -0600)

----------------------------------------------------------------
fio v2.1.10

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.1.10

 FIO-VERSION-GEN        |    2 +-
 os/windows/install.wxs |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 4cb3545..d2b5405 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.9
+DEF_VER=fio-2.1.10
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index bd89a7b..d69a086 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.9">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.10">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
