Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51554 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752049AbdARNAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Jan 2017 08:00:15 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cTpqN-0005KZ-Lb
        for fio@vger.kernel.org; Wed, 18 Jan 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170118130001.C8A102C0093@kernel.dk>
Date: Wed, 18 Jan 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bc0c01e5d03d27e80d2a3b85ab21714bb6f32a19:

  Support zlib in the Windows build (enabled latency histogram logging) (2017-01-11 21:03:23 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d7ea5a89fa2745f5bd743187b62bd05120c44c30:

  Fio 2.17 (2017-01-17 08:51:31 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.17

wei xiao (1):
      Drop crc32c-arm64 option

 FIO-VERSION-GEN        | 2 +-
 HOWTO                  | 5 -----
 options.c              | 4 ----
 os/windows/install.wxs | 2 +-
 verify.c               | 1 -
 verify.h               | 1 -
 6 files changed, 2 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index b324859..e2d8a43 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.16
+DEF_VER=fio-2.17
 
 LF='
 '
diff --git a/HOWTO b/HOWTO
index 9c8a837..9ba511b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1517,11 +1517,6 @@ verify=str	If writing to a file, fio can verify the file contents
 				back to regular software crc32c, if not
 				supported by the system.
 
-			crc32c-arm64 Use hardware assisted crc32c calculation
-				provided on CRC enabled ARM 64-bits processors.
-				Falls back to regular software crc32c, if not
-				supported by the system.
-
 			crc32	Use a crc32 sum of the data area and store
 				it in the header of each block.
 
diff --git a/options.c b/options.c
index 5886c50..1ca16e8 100644
--- a/options.c
+++ b/options.c
@@ -2647,10 +2647,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = VERIFY_CRC32C,
 			    .help = "Use crc32c checksums for verification (hw assisted, if available)",
 			  },
-			  { .ival = "crc32c-arm64",
-			    .oval = VERIFY_CRC32C,
-			    .help = "Use crc32c checksums for verification (hw assisted, if available)",
-			  },
 			  { .ival = "crc32c",
 			    .oval = VERIFY_CRC32C,
 			    .help = "Use crc32c checksums for verification (hw assisted, if available)",
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index b660fc6..22b7f7e 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.16">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.17">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/verify.c b/verify.c
index 02cd3a4..5c7e43d 100644
--- a/verify.c
+++ b/verify.c
@@ -1211,7 +1211,6 @@ nothing:
 void fio_verify_init(struct thread_data *td)
 {
 	if (td->o.verify == VERIFY_CRC32C_INTEL ||
-	    td->o.verify == VERIFY_CRC32C_ARM64 ||
 	    td->o.verify == VERIFY_CRC32C) {
 		crc32c_arm64_probe();
 		crc32c_intel_probe();
diff --git a/verify.h b/verify.h
index 8d40ff6..deb161e 100644
--- a/verify.h
+++ b/verify.h
@@ -15,7 +15,6 @@ enum {
 	VERIFY_CRC64,			/* crc64 sum data blocks */
 	VERIFY_CRC32,			/* crc32 sum data blocks */
 	VERIFY_CRC32C,			/* crc32c sum data blocks */
-	VERIFY_CRC32C_ARM64,		/* crc32c sum data blocks with hw */
 	VERIFY_CRC32C_INTEL,		/* crc32c sum data blocks with hw */
 	VERIFY_CRC16,			/* crc16 sum data blocks */
 	VERIFY_CRC7,			/* crc7 sum data blocks */
