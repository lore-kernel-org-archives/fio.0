Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37608 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbbGAMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Jul 2015 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAGgO-0002QM-8L
	for fio@vger.kernel.org; Wed, 01 Jul 2015 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150701120001.664BB2C00D0@kernel.dk>
Date: Wed,  1 Jul 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 94815a5c8366a9290167e8539f29994c2d43d15c:

  configure: fixup clang stupidity (2015-06-29 20:46:31 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aa1af5fd4a7b801cc506cb511eb09f64c89648b6:

  smalloc: fix unused 'int_mask' warning if redzoning is turned off (2015-06-30 15:31:50 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      smalloc: fix unused 'int_mask' warning if redzoning is turned off

 smalloc.c | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/smalloc.c b/smalloc.c
index 447d5c5..6bf66fc 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -32,7 +32,9 @@
 #define SMALLOC_POST_RED	0x5aa55aa5U
 
 unsigned int smalloc_pool_size = INITIAL_SIZE;
+#ifdef SMALLOC_REDZONE
 static const int int_mask = sizeof(int) - 1;
+#endif
 
 struct pool {
 	struct fio_mutex *lock;			/* protects this pool */
