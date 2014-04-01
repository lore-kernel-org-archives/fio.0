Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58589 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaDAMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Apr 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WUxMM-0006Zs-Ak
	for fio@vger.kernel.org; Tue, 01 Apr 2014 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140401120004.24A68400B5@strynoevaenget.dk>
Date: Tue,  1 Apr 2014 06:00:04 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9f973d1322fe387bc9b4442a23a912cfbc2203b9:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-03-28 08:09:35 -0600)

are available in the git repository at:


  git://git.kernel.dk/fio.git master

for you to fetch changes up to f42557f8ba1fc6bbf6b5fce4ae3a53cfc8bbb35b:

  Fio 2.1.7 (2014-03-31 09:05:54 -0600)

----------------------------------------------------------------
fio v2.1.7

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.1.7

 FIO-VERSION-GEN        |    2 +-
 os/windows/install.wxs |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 4122933..918a9df 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.6.1
+DEF_VER=fio-2.1.7
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index df5707f..7820449 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.6.1">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.7">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
