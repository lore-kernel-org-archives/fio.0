Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932625AbdDEMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Apr 2017 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cvjbX-0005og-JX
        for fio@vger.kernel.org; Wed, 05 Apr 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170405120001.D84A82C351A@kernel.dk>
Date: Wed,  5 Apr 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5ba01402d96e113ac451441f45d0c8b4dd281f4d:

  backend: move freeing of td->mutex to main thread (2017-04-03 08:46:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e07a8a2281c7a5a0ec4eb8e8e66601ca1f9f71bb:

  Fio 2.19 (2017-04-04 08:30:59 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.19

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 570e21f..4cc903f 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.18
+DEF_VER=fio-2.19
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index bb2b90b..ffaed8e 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.18">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.19">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
