Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42743 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbbGPMAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Jul 2015 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZFhpe-000689-U4
	for fio@vger.kernel.org; Thu, 16 Jul 2015 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150716120002.34C4C2C00B7@kernel.dk>
Date: Thu, 16 Jul 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4fbe186054f09654f31c9a77b743d2aa40c85e54:

  HOWTO: spelling error (2015-07-13 14:35:30 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to adaa73f65a8b805dced0b017984d536f215e4353:

  README: no delay on sync to backup git hosts anymore (2015-07-15 08:43:03 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      README: no delay on sync to backup git hosts anymore

 README | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index ab42f1b..cfe7084 100644
--- a/README
+++ b/README
@@ -26,9 +26,9 @@ Snapshots can download from:
 
 	http://brick.kernel.dk/snaps/
 
-There are also two official mirrors. Both of these are synced within
-an hour of commits landing at git.kernel.dk. So if the main repo is
-down for some reason, either one of those is safe to use:
+There are also two official mirrors. Both of these are automatically synced
+with the main repository, when changes are pushed. If the main repo is down
+for some reason, either one of these is safe to use as a backup:
 
 	git://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
 	https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
