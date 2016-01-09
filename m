Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbcAINAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 9 Jan 2016 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aHt7i-0002e7-M1
	for fio@vger.kernel.org; Sat, 09 Jan 2016 13:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160109130001.8E97E2C16ED@kernel.dk>
Date: Sat,  9 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 98996ef93ff37e0f51d90ca87ff0f75d4d1c153f:

  t/verify-state: add helper to inspect verify dump state files (2016-01-07 15:06:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 204c368ebe461b08b18124e1e5555a65b128ab7a:

  use option smalloc_pool_size (2016-01-08 14:29:12 +0100)

----------------------------------------------------------------
Andreas Piesk (1):
      use option smalloc_pool_size

 smalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/smalloc.c b/smalloc.c
index b6b367a..6f647c0 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -204,7 +204,7 @@ void sinit(void)
 	int i, ret;
 
 	for (i = 0; i < MAX_POOLS; i++) {
-		ret = add_pool(&mp[i], INITIAL_SIZE);
+		ret = add_pool(&mp[i], smalloc_pool_size);
 		if (ret)
 			break;
 	}
