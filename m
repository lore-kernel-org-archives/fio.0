Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33549 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcCJNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Mar 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1ae0CB-0003TO-OA
	for fio@vger.kernel.org; Thu, 10 Mar 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160310130001.7D1DF2C0105@kernel.dk>
Date: Thu, 10 Mar 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4f126cad8fc5ed71c7ac8155726e38395c689905:

  .gitignore: ignore vim undo files (2016-03-08 11:19:17 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9d0ad2a56d63e7f59473f31708358a4b65d2a5e3:

  t/gen-rand: remove compile warning on 32-bit (2016-03-09 14:15:11 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Fio 2.7
      t/gen-rand: remove compile warning on 32-bit

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 t/gen-rand.c           | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 597e615..a4ff012 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.6
+DEF_VER=fio-2.7
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 011c1eb..ed9f98b 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.6">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.7">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/t/gen-rand.c b/t/gen-rand.c
index c2a31bc..a03646a 100644
--- a/t/gen-rand.c
+++ b/t/gen-rand.c
@@ -54,10 +54,10 @@ int main(int argc, char *argv[])
 	pass = fail = 0;
 	for (i = 0; i < index; i++) {
 		if (buckets[i] < vmin || buckets[i] > vmax) {
-			printf("FAIL bucket%4lu: val=%8lu (%.1f < %.1f > %.1f)\n", i + 1, buckets[i], vmin, mean, vmax);
+			printf("FAIL bucket%4lu: val=%8lu (%.1f < %.1f > %.1f)\n", (unsigned long) i + 1, buckets[i], vmin, mean, vmax);
 			fail++;
 		} else {
-			printf("PASS bucket%4lu: val=%8lu (%.1f < %.1f > %.1f)\n", i + 1, buckets[i], vmin, mean, vmax);
+			printf("PASS bucket%4lu: val=%8lu (%.1f < %.1f > %.1f)\n", (unsigned long) i + 1, buckets[i], vmin, mean, vmax);
 			pass++;
 		}
 	}
