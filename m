Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39192 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933019AbeBUNAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Feb 2018 08:00:18 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eoU0P-0008Rj-Pq
        for fio@vger.kernel.org; Wed, 21 Feb 2018 13:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180221130002.C52FB2C0131@kernel.dk>
Date: Wed, 21 Feb 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 488468793d72297f7dccd42a7b50011e74de0688:

  Merge branch 'wip-ifed-rados' of https://github.com/ifed01/fio (2018-02-14 12:43:04 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cd174b909109e527e41ca42ac761c5f7d29f25e5:

  Fio 3.5 (2018-02-20 15:30:28 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.5

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 5aed535..7abd8ce 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.3
+DEF_VER=fio-3.5
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 905addc..577af55 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.3">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.5">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
