Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56661 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbdI1MAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Sep 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dxXU9-0008SL-Fd
        for fio@vger.kernel.org; Thu, 28 Sep 2017 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170928120002.2B48F2C0111@kernel.dk>
Date: Thu, 28 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7595fa09fbf048c9045617668bf0159a6cb82eac:

  Remove old exp/README.md file (2017-09-26 13:38:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b6b662b64c70bf043bbafd654f9bf98513ea5dc9:

  Fio 3.1 (2017-09-28 04:23:20 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.1

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 31acf1c..8c075cb 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.0
+DEF_VER=fio-3.1
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index edfefa8..58244c5 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.0">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.1">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
