Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaEMMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 13 May 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WkBNO-0003Bw-4m
	for fio@vger.kernel.org; Tue, 13 May 2014 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140513120003.AA41A400C3@lyth.info>
Date: Tue, 13 May 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 890b665611751661aac1030603175bb7bbde34bc:

  verify: fix verification of uncompleted or errored ios (2014-05-06 19:06:51 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2c3fcd7bd67209e141e259b1fdd4585e8d91167c:

  Fio 2.1.9 (2014-05-12 17:18:13 -0600)

----------------------------------------------------------------
fio v2.1.9

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.1.9

 FIO-VERSION-GEN        |    2 +-
 os/windows/install.wxs |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index b126baf..4cb3545 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.8
+DEF_VER=fio-2.1.9
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index e78bb30..bd89a7b 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.8">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.9">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
