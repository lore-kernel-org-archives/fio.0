Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34597 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdHaMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 31 Aug 2017 08:00:13 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dnO8q-0005ND-PG
        for fio@vger.kernel.org; Thu, 31 Aug 2017 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170831120001.DFEF42C0167@kernel.dk>
Date: Thu, 31 Aug 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 63463983ce10e9678c5ad309608630eea873b4df:

  Merge branch 'asmfix' of https://github.com/oohal/fio (2017-08-29 15:35:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2b2fa7f5ecfd5cd5b54a209934b05b770e9c9301:

  lib/axmap: a few fixes/cleanups (2017-08-30 13:03:26 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      lib/axmap: a few fixes/cleanups

 lib/axmap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/lib/axmap.c b/lib/axmap.c
index 2ee3a25..bf203df 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -184,6 +184,9 @@ static bool axmap_clear_fn(struct axmap_level *al, unsigned long offset,
 void axmap_clear(struct axmap *axmap, uint64_t bit_nr)
 {
 	axmap_handler(axmap, bit_nr, axmap_clear_fn, NULL);
+
+	if (bit_nr < axmap->first_free)
+		axmap->first_free = bit_nr;
 }
 
 struct axmap_set_data {
@@ -191,7 +194,7 @@ struct axmap_set_data {
 	unsigned int set_bits;
 };
 
-static unsigned long bit_masks[] = {
+static const unsigned long bit_masks[] = {
 	0x0000000000000000, 0x0000000000000001, 0x0000000000000003, 0x0000000000000007,
 	0x000000000000000f, 0x000000000000001f, 0x000000000000003f, 0x000000000000007f,
 	0x00000000000000ff, 0x00000000000001ff, 0x00000000000003ff, 0x00000000000007ff,
@@ -372,10 +375,9 @@ static uint64_t axmap_find_first_free(struct axmap *axmap, unsigned int level,
 
 static uint64_t axmap_first_free(struct axmap *axmap)
 {
-	if (firstfree_valid(axmap))
-		return axmap->first_free;
+	if (!firstfree_valid(axmap))
+		axmap->first_free = axmap_find_first_free(axmap, axmap->nr_levels - 1, 0);
 
-	axmap->first_free = axmap_find_first_free(axmap, axmap->nr_levels - 1, 0);
 	return axmap->first_free;
 }
 
