Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754768AbcJZMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bzMsE-0001Z8-W0
        for fio@vger.kernel.org; Wed, 26 Oct 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161026120002.3B2DD2C1A72@kernel.dk>
Date: Wed, 26 Oct 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 43f248c4527a49d3de0cd758ce669f7736028ea4:

  Use the POSIX `EDEADLK` instead of the Linux `EDEADLOCK` (2016-10-24 20:48:43 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a0290964d9e15aa9faa5a139effc14cfa5bcd3f1:

  Fio 2.15 (2016-10-25 12:38:13 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.15

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 8d4f1ef..eac0e00 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.14
+DEF_VER=fio-2.15
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index da09b9f..25cb269 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.14">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.15">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
