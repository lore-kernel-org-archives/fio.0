Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54598 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaCGNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 7 Mar 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WLuNg-00081Z-F5
	for fio@vger.kernel.org; Fri, 07 Mar 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140307130003.7D04941E39@strynoevaenget.dk>
Date: Fri,  7 Mar 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6cf71c249abd60f2d2f6878ae436d4bab00aacbd:

  Fix compile on CentOS/RHEL5 (2014-03-05 15:49:54 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b24f59ab5ac96a67a016dc921687b0feae9bbf94:

  Detect Windows operating system in ./configure (2014-03-06 14:31:57 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 2.1.6.1

Stefan Hajnoczi (2):
      Honor ./configure --cc= option
      Detect Windows operating system in ./configure

 FIO-VERSION-GEN        |    2 +-
 configure              |    8 +++++---
 os/windows/install.wxs |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 8953d10..4122933 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.6
+DEF_VER=fio-2.1.6.1
 
 LF='
 '
diff --git a/configure b/configure
index 4a8d352..63aa02d 100755
--- a/configure
+++ b/configure
@@ -130,9 +130,6 @@ output_sym() {
 targetos=""
 cpu=""
 
-cross_prefix=${cross_prefix-${CROSS_COMPILE}}
-cc="${CC-${cross_prefix}gcc}"
-
 # default options
 show_help="no"
 exit_val=0
@@ -175,6 +172,9 @@ if test "$show_help" = "yes" ; then
   exit $exit_val
 fi
 
+cross_prefix=${cross_prefix-${CROSS_COMPILE}}
+cc="${CC-${cross_prefix}gcc}"
+
 if check_define __ANDROID__ ; then
   targetos="Android"
 elif check_define __linux__ ; then
@@ -184,6 +184,8 @@ elif check_define __OpenBSD__ ; then
 elif check_define __sun__ ; then
   targetos='SunOS'
   CFLAGS="$CFLAGS -D_REENTRANT"
+elif check_define _WIN32 ; then
+  targetos='CYGWIN'
 else
   targetos=`uname -s`
 fi
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 694d422..df5707f 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.6">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.6.1">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
