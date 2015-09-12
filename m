Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbbILMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 12 Sep 2015 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZajTS-0000Gr-VV
	for fio@vger.kernel.org; Sat, 12 Sep 2015 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150912120002.371752C225F@kernel.dk>
Date: Sat, 12 Sep 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 736a50cd7d04e510d0a104316a6b4a3a5bcc43f6:

  workqueue: Ensure submission offload worker inherits parent's options (2015-09-08 09:10:55 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 93b35789c2183f3bb0e7e825815fa7622e61f21f:

  Fio 2.2.10 (2015-09-11 15:13:37 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.2.10

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 46d65fc..9dd811d 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.9
+DEF_VER=fio-2.2.10
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 1492182..77d6bf2 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.9">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.10">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
