Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48146 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbcD2MAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 29 Apr 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1aw75W-0000e0-RY
	for fio@vger.kernel.org; Fri, 29 Apr 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160429120001.8B1852C18E8@kernel.dk>
Date: Fri, 29 Apr 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 603e604eb6d9b3ba9f201a6bff0a18da1a6c0967:

  oslib/getopt_long: allow (unique) short match (2016-04-22 18:14:24 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fe8d0f4c54f0c308c9a02a4e3c2f5084e8bf5461:

  Fio 2.9 (2016-04-28 16:23:10 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.9

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 502d4fe..fcdbd98 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.8
+DEF_VER=fio-2.9
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 366547d..44cc938 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.8">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.9">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
