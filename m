Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbDWOC2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Apr 2015 10:02:28 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YlHi0-0006Ma-Bo
	for fio@vger.kernel.org; Thu, 23 Apr 2015 14:02:28 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150423140228.39E642C01AD@kernel.dk>
Date: Thu, 23 Apr 2015 08:02:28 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9e98688960347b9b733db9426fb7747f22d3a77e:

  Fix off-by-one in cpus_allowed (2015-04-21 09:39:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8a16f59b66e5198050ec735998692ba9436a9884:

  blktrace: only probe and set depth if option isn't set (2015-04-22 19:54:54 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      configure: check for more of the used MTD features
      blktrace: only probe and set depth if option isn't set

 blktrace.c | 5 ++---
 configure  | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index 9afc5be..e63c708 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -456,10 +456,9 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	td->o.odirect = 1;
 
 	/*
-	 * we don't know if this option was set or not. it defaults to 1,
-	 * so we'll just guess that we should override it if it's still 1
+	 * If depth wasn't manually set, use probed depth
 	 */
-	if (td->o.iodepth == 1)
+	if (!fio_option_is_set(&td->o, iodepth))
 		td->o.iodepth = td->o.iodepth_low = depth;
 
 	return 0;
diff --git a/configure b/configure
index ff97200..8e496b0 100755
--- a/configure
+++ b/configure
@@ -1378,6 +1378,7 @@ cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
   struct mtd_info_user info;
+  info.type = MTD_MLCNANDFLASH;
   return ioctl(0, MEMGETINFO, &info);
 }
 EOF
