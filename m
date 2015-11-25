Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55063 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbbKYNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 25 Nov 2015 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a1Zg2-0000to-VM
	for fio@vger.kernel.org; Wed, 25 Nov 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151125130002.1423F2C00C7@kernel.dk>
Date: Wed, 25 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4b157ac6446364e5eecdcdbf75fc1a814489a343:

  A few min/max cleanups (2015-11-23 15:04:56 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aab8901041d1bb548d58e3cb1038a19d73ecd094:

  Fio 2.2.12 (2015-11-24 21:13:34 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.2.12

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index a5949d3..4d73d63 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.11
+DEF_VER=fio-2.2.12
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 4bc5bd4..1b22b2c 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.11">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.12">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
