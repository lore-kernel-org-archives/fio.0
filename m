Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34060 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdETMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 20 May 2017 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dC33D-0006wb-0v
        for fio@vger.kernel.org; Sat, 20 May 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170520120001.B25402C2469@kernel.dk>
Date: Sat, 20 May 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dd3805d49995e59fdf61e2560c3fec5b7f5c71b6:

  Remove leftover warnings (2017-05-18 12:53:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4641daa9b2e33bc63197dfec48584eaf05890a01:

  Fio 2.20 (2017-05-19 08:25:27 -0600)

----------------------------------------------------------------
Andreas Herrmann (1):
      stat: Re-add output of basic bw information if bw_log is not written

Jens Axboe (1):
      Fio 2.20

 FIO-VERSION-GEN        | 2 +-
 os/windows/install.wxs | 2 +-
 stat.c                 | 8 +++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 4cc903f..a9ddb31 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.19
+DEF_VER=fio-2.20
 
 LF='
 '
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index ffaed8e..05d2a83 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.19">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.20">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/stat.c b/stat.c
index 6e47c34..5b48413 100644
--- a/stat.c
+++ b/stat.c
@@ -2465,7 +2465,7 @@ static int __add_samples(struct thread_data *td, struct timeval *parent_tv,
 
 		add_stat_sample(&stat[ddir], rate);
 
-		if (td->bw_log) {
+		if (log) {
 			unsigned int bs = 0;
 
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
@@ -2541,12 +2541,14 @@ int calc_log_samples(void)
 			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
 			continue;
 		}
-		if (td->bw_log && !per_unit_log(td->bw_log)) {
+		if (!td->bw_log ||
+			(td->bw_log && !per_unit_log(td->bw_log))) {
 			tmp = add_bw_samples(td, &now);
 			if (tmp < next)
 				next = tmp;
 		}
-		if (td->iops_log && !per_unit_log(td->iops_log)) {
+		if (!td->iops_log ||
+			(td->iops_log && !per_unit_log(td->iops_log))) {
 			tmp = add_iops_samples(td, &now);
 			if (tmp < next)
 				next = tmp;
