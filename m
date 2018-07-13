Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbeGMMOd (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Jul 2018 08:14:33 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fdwk7-0004Kt-3c
        for fio@vger.kernel.org; Fri, 13 Jul 2018 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180713120002.48E4F2C00B0@kernel.dk>
Date: Fri, 13 Jul 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b8c7923917200c7c68c84c21549940d4be6b1398:

  t/axmap: add longer overlap test case (2018-07-11 15:32:31 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to edfca254378e729035073af6ac0d9156565afebe:

  axmap: optimize ulog64 usage in axmap_handler() (2018-07-12 08:33:14 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      axmap: optimize ulog64 usage in axmap_handler()

 lib/axmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/lib/axmap.c b/lib/axmap.c
index 4047f23..454af0b 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -156,10 +156,10 @@ static bool axmap_handler(struct axmap *axmap, uint64_t bit_nr,
 			  void *), void *data)
 {
 	struct axmap_level *al;
+	uint64_t index = bit_nr;
 	int i;
 
 	for (i = 0; i < axmap->nr_levels; i++) {
-		unsigned long index = ulog64(bit_nr, i);
 		unsigned long offset = index >> UNIT_SHIFT;
 		unsigned int bit = index & BLOCKS_PER_UNIT_MASK;
 
@@ -167,6 +167,9 @@ static bool axmap_handler(struct axmap *axmap, uint64_t bit_nr,
 
 		if (func(al, offset, bit, data))
 			return true;
+
+		if (index)
+			index >>= UNIT_SHIFT;
 	}
 
 	return false;
