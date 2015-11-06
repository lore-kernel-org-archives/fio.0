Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824AbbKFNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 6 Nov 2015 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Zugcd-0008C9-2Z
	for fio@vger.kernel.org; Fri, 06 Nov 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151106130002.217772C00B0@kernel.dk>
Date: Fri,  6 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f6cbf8ac4f70c800bbbfc23c5dcf44ed619c0acc:

  output_buffer: only realloc once, and memset just what we need (2015-10-30 19:34:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0e0484c51ff9bae3ea5bcdf2a97b614e5a1a6612:

  Fio 2.2.11 (2015-11-05 09:05:15 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.2.11

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 9dd811d..a5949d3 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.10
+DEF_VER=fio-2.2.11
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 77d6bf2..4bc5bd4 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.10">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.11">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
