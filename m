Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45768 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754746AbdLTNAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 20 Dec 2017 08:00:16 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eRdyp-0002dy-PT
        for fio@vger.kernel.org; Wed, 20 Dec 2017 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171220130001.92BE02C009F@kernel.dk>
Date: Wed, 20 Dec 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9b50942ecec9c79fa82050c503fe313cfd87ac96:

  ioengines: clear out ->td_ops_dlhandle if we close it (2017-12-15 13:35:56 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e3ccbdd5f93d33162a93000586461ac6bba5a7d3:

  Fio 3.3 (2017-12-19 13:16:36 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      backend: tweaks to missed rate thinktime
      Fio 3.3

 FIO-VERSION-GEN        | 2 +-
 backend.c              | 8 +++++---
 os/windows/install.wxs | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 22f4404..5aed535 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.2
+DEF_VER=fio-3.3
 
 LF='
 '
diff --git a/backend.c b/backend.c
index e248117..b4a09ac 100644
--- a/backend.c
+++ b/backend.c
@@ -899,12 +899,14 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
 	 */
 	if (total && td->rate_bps[ddir] && td->o.rate_ign_think) {
 		uint64_t missed = (td->rate_bps[ddir] * total) / 1000000ULL;
+		uint64_t bs = td->o.min_bs[ddir];
+		uint64_t usperop = bs * 1000000ULL / td->rate_bps[ddir];
 		uint64_t over;
 
-		if (total >= 1000000)
-			over = td->o.min_bs[ddir];
+		if (usperop <= total)
+			over = bs;
 		else
-			over = (td->o.min_bs[ddir] * total) / 1000000ULL;
+			over = (usperop - total) / usperop * -bs;
 
 		td->rate_io_issue_bytes[ddir] += (missed - over);
 	}
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 6dfe231..905addc 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.2">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.3">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
