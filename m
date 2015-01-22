Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVNAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 22 Jan 2015 08:00:08 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YEHMk-0006jR-Ju
	for fio@vger.kernel.org; Thu, 22 Jan 2015 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150122130003.09D1E401DB@lyth.info>
Date: Thu, 22 Jan 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 91e475290c03db58f856a62f763d29e964934114:

  shm: disable iomem=shm* for shm disabled (2015-01-20 18:38:11 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 64666f8fe2242cbe4d804df2305924a9e43e8699:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2015-01-22 00:57:00 +0100)

----------------------------------------------------------------

Jens Axboe (3):
      sha256: fix verify failure
      Fio 2.2.5
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio

 FIO-VERSION-GEN        |    2 +-
 os/windows/install.wxs |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index a8c8e65..da75022 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.4
+DEF_VER=fio-2.2.5
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 2f75d00..f72dfb1 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.4">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.5">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
