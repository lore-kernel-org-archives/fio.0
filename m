Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbbFZMAN (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Jun 2015 08:00:13 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z8SIn-0005Dw-2x
	for fio@vger.kernel.org; Fri, 26 Jun 2015 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150626120001.C934D2C00C7@kernel.dk>
Date: Fri, 26 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cdf91594d537b59588f3a95c4cc44336326faaf3:

  Modify rdma engine to use proper arguments. (2015-06-23 16:28:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6b2db5c151bf676960046cd1dd2919be7cf30048:

  Fio 2.2.9 (2015-06-25 11:13:19 -0600)

----------------------------------------------------------------
Akinobu Mita (1):
      Fix testing and setting set_options bitmap

Jens Axboe (1):
      Fio 2.2.9

 FIO-VERSION-GEN        | 2 +-
 options.c              | 4 ++--
 os/windows/install.wxs | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 25fad7d..46d65fc 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.8
+DEF_VER=fio-2.2.9
 
 LF='
 '
diff --git a/options.c b/options.c
index 76146a7..ed5d37e 100644
--- a/options.c
+++ b/options.c
@@ -4365,7 +4365,7 @@ static int opt_is_set(struct thread_options *o, struct fio_option *opt)
 	opt_off = opt - &fio_options[0];
 	index = opt_off / (8 * sizeof(uint64_t));
 	offset = opt_off & ((8 * sizeof(uint64_t)) - 1);
-	return (o->set_options[index] & (1UL << offset)) != 0;
+	return (o->set_options[index] & ((uint64_t)1 << offset)) != 0;
 }
 
 int __fio_option_is_set(struct thread_options *o, unsigned int off1)
@@ -4390,5 +4390,5 @@ void fio_option_mark_set(struct thread_options *o, struct fio_option *opt)
 	opt_off = opt - &fio_options[0];
 	index = opt_off / (8 * sizeof(uint64_t));
 	offset = opt_off & ((8 * sizeof(uint64_t)) - 1);
-	o->set_options[index] |= 1UL << offset;
+	o->set_options[index] |= (uint64_t)1 << offset;
 }
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 2a67a4d..1492182 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.8">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.9">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
