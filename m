Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60584 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdFPMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Jun 2017 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dLpv9-0003ao-GN
        for fio@vger.kernel.org; Fri, 16 Jun 2017 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170616120001.BE6722C0120@kernel.dk>
Date: Fri, 16 Jun 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 72cd4146e538450b8789095b910ffce2b397a06c:

  sync: add support for write life time hint (2017-06-14 09:55:40 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e5aaf1e677d1413125ffaf7aae48b1e8f4ce9ebc:

  Fio 2.21 (2017-06-15 12:25:03 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.21

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index a9ddb31..3b4f206 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.20
+DEF_VER=fio-2.21
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 05d2a83..860570a 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.20">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.21">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
