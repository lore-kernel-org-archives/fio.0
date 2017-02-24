Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57100 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdBXNoC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Feb 2017 08:44:02 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1chFTf-0003Eq-Cy
        for fio@vger.kernel.org; Fri, 24 Feb 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170224130001.753562C0086@kernel.dk>
Date: Fri, 24 Feb 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 484817a95764dc7ba83b9f16c417bd727813043a:

  configure: disable compile time asserts for !opt and !static_assert (2017-02-22 09:00:06 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c9057434a99a85f643ce433c7fec9b8f7fad9761:

  Fio 2.18 (2017-02-23 08:44:32 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.18

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index e2d8a43..570e21f 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.17
+DEF_VER=fio-2.18
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 9e776de..bb2b90b 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.17">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.18">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
