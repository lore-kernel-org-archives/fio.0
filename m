Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686AbcAMNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 Jan 2016 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aJL1w-0003jH-V3
	for fio@vger.kernel.org; Wed, 13 Jan 2016 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160113130002.39F4A2C00E7@kernel.dk>
Date: Wed, 13 Jan 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 204c368ebe461b08b18124e1e5555a65b128ab7a:

  use option smalloc_pool_size (2016-01-08 14:29:12 +0100)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a7cd478dffddb6d3d3109bce9f603139384c673e:

  options: fix bs_cmp() (2016-01-12 10:18:50 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      options: fix bs_cmp()

 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 871552b..0bf1390 100644
--- a/options.c
+++ b/options.c
@@ -41,7 +41,7 @@ static int bs_cmp(const void *p1, const void *p2)
 	const struct bssplit *bsp1 = p1;
 	const struct bssplit *bsp2 = p2;
 
-	return bsp1->perc < bsp2->perc;
+	return (int) bsp1->perc - (int) bsp2->perc;
 }
 
 static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
