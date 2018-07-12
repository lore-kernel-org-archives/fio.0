Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38820 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbeGLMJc (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Jul 2018 08:09:32 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fdaGf-0001Ix-5K
        for fio@vger.kernel.org; Thu, 12 Jul 2018 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180712120002.20E282C00AA@kernel.dk>
Date: Thu, 12 Jul 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dc54a01f9a2966133f6d1a52f3718d267117b4f3:

  t/axmap: clean up overlap tests (2018-07-10 21:51:16 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b8c7923917200c7c68c84c21549940d4be6b1398:

  t/axmap: add longer overlap test case (2018-07-11 15:32:31 -0600)

----------------------------------------------------------------
Jens Axboe (11):
      t/axmap: a few more overlap cases
      t/axmap: don't print 'pass' on failure
      axmap: clean up 'no bits to set' case
      t/axmap: add zero return overlap cases
      axmap: code cleanups
      fio: should_fsync() returns bool
      axmap: remove unused 'data' argument to topdown handler
      axmap: a few more cleanups
      axmap: fix continued sequential bit setting
      t/axmap: add regression case for recent overlap failure case
      t/axmap: add longer overlap test case

 fio.h       |  8 +++---
 lib/axmap.c | 83 +++++++++++++++++++++++++++++--------------------------------
 t/axmap.c   | 45 +++++++++++++++++++++++++++++++--
 3 files changed, 86 insertions(+), 50 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index 51b8fdc..3ac552b 100644
--- a/fio.h
+++ b/fio.h
@@ -539,14 +539,14 @@ static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 
 #define REAL_MAX_JOBS		4096
 
-static inline int should_fsync(struct thread_data *td)
+static inline bool should_fsync(struct thread_data *td)
 {
 	if (td->last_was_sync)
-		return 0;
+		return false;
 	if (td_write(td) || td->o.override_sync)
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
 /*
diff --git a/lib/axmap.c b/lib/axmap.c
index c29597f..4047f23 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -37,6 +37,28 @@
 
 #define firstfree_valid(b)	((b)->first_free != (uint64_t) -1)
 
+static const unsigned long bit_masks[] = {
+	0x0000000000000000, 0x0000000000000001, 0x0000000000000003, 0x0000000000000007,
+	0x000000000000000f, 0x000000000000001f, 0x000000000000003f, 0x000000000000007f,
+	0x00000000000000ff, 0x00000000000001ff, 0x00000000000003ff, 0x00000000000007ff,
+	0x0000000000000fff, 0x0000000000001fff, 0x0000000000003fff, 0x0000000000007fff,
+	0x000000000000ffff, 0x000000000001ffff, 0x000000000003ffff, 0x000000000007ffff,
+	0x00000000000fffff, 0x00000000001fffff, 0x00000000003fffff, 0x00000000007fffff,
+	0x0000000000ffffff, 0x0000000001ffffff, 0x0000000003ffffff, 0x0000000007ffffff,
+	0x000000000fffffff, 0x000000001fffffff, 0x000000003fffffff, 0x000000007fffffff,
+	0x00000000ffffffff,
+#if BITS_PER_LONG == 64
+	0x00000001ffffffff, 0x00000003ffffffff, 0x00000007ffffffff, 0x0000000fffffffff,
+	0x0000001fffffffff, 0x0000003fffffffff, 0x0000007fffffffff, 0x000000ffffffffff,
+	0x000001ffffffffff, 0x000003ffffffffff, 0x000007ffffffffff, 0x00000fffffffffff,
+	0x00001fffffffffff, 0x00003fffffffffff, 0x00007fffffffffff, 0x0000ffffffffffff,
+	0x0001ffffffffffff, 0x0003ffffffffffff, 0x0007ffffffffffff, 0x000fffffffffffff,
+	0x001fffffffffffff, 0x003fffffffffffff, 0x007fffffffffffff, 0x00ffffffffffffff,
+	0x01ffffffffffffff, 0x03ffffffffffffff, 0x07ffffffffffffff, 0x0fffffffffffffff,
+	0x1fffffffffffffff, 0x3fffffffffffffff, 0x7fffffffffffffff, 0xffffffffffffffff
+#endif
+};
+
 struct axmap_level {
 	int level;
 	unsigned long map_size;
@@ -50,7 +72,7 @@ struct axmap {
 	uint64_t nr_bits;
 };
 
-static unsigned long ulog64(unsigned long val, unsigned int log)
+static inline unsigned long ulog64(unsigned long val, unsigned int log)
 {
 	while (log-- && val)
 		val >>= UNIT_SHIFT;
@@ -151,20 +173,16 @@ static bool axmap_handler(struct axmap *axmap, uint64_t bit_nr,
 }
 
 static bool axmap_handler_topdown(struct axmap *axmap, uint64_t bit_nr,
-	bool (*func)(struct axmap_level *, unsigned long, unsigned int, void *),
-	void *data)
+	bool (*func)(struct axmap_level *, unsigned long, unsigned int, void *))
 {
-	struct axmap_level *al;
-	int i, level = axmap->nr_levels;
+	int i;
 
 	for (i = axmap->nr_levels - 1; i >= 0; i--) {
-		unsigned long index = ulog64(bit_nr, --level);
+		unsigned long index = ulog64(bit_nr, i);
 		unsigned long offset = index >> UNIT_SHIFT;
 		unsigned int bit = index & BLOCKS_PER_UNIT_MASK;
 
-		al = &axmap->levels[i];
-
-		if (func(al, offset, bit, data))
+		if (func(&axmap->levels[i], offset, bit, NULL))
 			return true;
 	}
 
@@ -194,28 +212,6 @@ struct axmap_set_data {
 	unsigned int set_bits;
 };
 
-static const unsigned long bit_masks[] = {
-	0x0000000000000000, 0x0000000000000001, 0x0000000000000003, 0x0000000000000007,
-	0x000000000000000f, 0x000000000000001f, 0x000000000000003f, 0x000000000000007f,
-	0x00000000000000ff, 0x00000000000001ff, 0x00000000000003ff, 0x00000000000007ff,
-	0x0000000000000fff, 0x0000000000001fff, 0x0000000000003fff, 0x0000000000007fff,
-	0x000000000000ffff, 0x000000000001ffff, 0x000000000003ffff, 0x000000000007ffff,
-	0x00000000000fffff, 0x00000000001fffff, 0x00000000003fffff, 0x00000000007fffff,
-	0x0000000000ffffff, 0x0000000001ffffff, 0x0000000003ffffff, 0x0000000007ffffff,
-	0x000000000fffffff, 0x000000001fffffff, 0x000000003fffffff, 0x000000007fffffff,
-	0x00000000ffffffff,
-#if BITS_PER_LONG == 64
-	0x00000001ffffffff, 0x00000003ffffffff, 0x00000007ffffffff, 0x0000000fffffffff,
-	0x0000001fffffffff, 0x0000003fffffffff, 0x0000007fffffffff, 0x000000ffffffffff,
-	0x000001ffffffffff, 0x000003ffffffffff, 0x000007ffffffffff, 0x00000fffffffffff,
-	0x00001fffffffffff, 0x00003fffffffffff, 0x00007fffffffffff, 0x0000ffffffffffff,
-	0x0001ffffffffffff, 0x0003ffffffffffff, 0x0007ffffffffffff, 0x000fffffffffffff,
-	0x001fffffffffffff, 0x003fffffffffffff, 0x007fffffffffffff, 0x00ffffffffffffff,
-	0x01ffffffffffffff, 0x03ffffffffffffff, 0x07ffffffffffffff, 0x0fffffffffffffff,
-	0x1fffffffffffffff, 0x3fffffffffffffff, 0x7fffffffffffffff, 0xffffffffffffffff
-#endif
-};
-
 static bool axmap_set_fn(struct axmap_level *al, unsigned long offset,
 			 unsigned int bit, void *__data)
 {
@@ -231,16 +227,19 @@ static bool axmap_set_fn(struct axmap_level *al, unsigned long offset,
 	 * Mask off any potential overlap, only sets contig regions
 	 */
 	overlap = al->map[offset] & mask;
-	if (overlap == mask)
+	if (overlap == mask) {
+done:
+		data->set_bits = 0;
 		return true;
+	}
 
 	if (overlap) {
 		const int __bit = ffz(~overlap);
 
-		if (__bit == bit)
-			return true;
-
 		nr_bits = __bit - bit;
+		if (!nr_bits)
+			goto done;
+
 		mask = bit_masks[nr_bits] << bit;
 	}
 
@@ -304,7 +303,7 @@ unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr,
 		unsigned int max_bits, this_set;
 
 		max_bits = BLOCKS_PER_UNIT - (bit_nr & BLOCKS_PER_UNIT_MASK);
-		if (max_bits < nr_bits)
+		if (nr_bits > max_bits)
 			data.nr_bits = max_bits;
 
 		this_set = data.nr_bits;
@@ -329,7 +328,7 @@ static bool axmap_isset_fn(struct axmap_level *al, unsigned long offset,
 bool axmap_isset(struct axmap *axmap, uint64_t bit_nr)
 {
 	if (bit_nr <= axmap->nr_bits)
-		return axmap_handler_topdown(axmap, bit_nr, axmap_isset_fn, NULL);
+		return axmap_handler_topdown(axmap, bit_nr, axmap_isset_fn);
 
 	return false;
 }
@@ -347,13 +346,8 @@ static uint64_t axmap_find_first_free(struct axmap *axmap, unsigned int level,
 	for (i = level; i >= 0; i--) {
 		struct axmap_level *al = &axmap->levels[i];
 
-		/*
-		 * Clear 'ret', this is a bug condition.
-		 */
-		if (index >= al->map_size) {
-			ret = -1ULL;
-			break;
-		}
+		if (index >= al->map_size)
+			goto err;
 
 		for (j = index; j < al->map_size; j++) {
 			if (al->map[j] == -1UL)
@@ -371,6 +365,7 @@ static uint64_t axmap_find_first_free(struct axmap *axmap, unsigned int level,
 	if (ret < axmap->nr_bits)
 		return ret;
 
+err:
 	return (uint64_t) -1ULL;
 }
 
diff --git a/t/axmap.c b/t/axmap.c
index 3f6b8f1..1512737 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -117,11 +117,21 @@ static int test_overlap(void)
 {
 	struct overlap_test tests[] = {
 		{
+			.start	= 0,
+			.nr	= 0,
+			.ret	= 0,
+		},
+		{
 			.start	= 16,
 			.nr	= 16,
 			.ret	= 16,
 		},
 		{
+			.start	= 16,
+			.nr	= 0,
+			.ret	= 0,
+		},
+		{
 			.start	= 0,
 			.nr	= 32,
 			.ret	= 16,
@@ -137,6 +147,16 @@ static int test_overlap(void)
 			.ret	= 16,
 		},
 		{
+			.start	= 79,
+			.nr	= 1,
+			.ret	= 0,
+		},
+		{
+			.start	= 80,
+			.nr	= 21,
+			.ret	= 21,
+		},
+		{
 			.start	= 102,
 			.nr	= 1,
 			.ret	= 1,
@@ -172,6 +192,26 @@ static int test_overlap(void)
 			.ret	= 0,
 		},
 		{
+			.start	= 1100,
+			.nr	= 1,
+			.ret	= 1,
+		},
+		{
+			.start	= 1000,
+			.nr	= 256,
+			.ret	= 100,
+		},
+		{
+			.start	= 22684,
+			.nr	= 1,
+			.ret	= 1,
+		},
+		{
+			.start	= 22670,
+			.nr	= 60,
+			.ret	= 14,
+		},
+		{
 			.start	= -1U,
 		},
 	};
@@ -179,7 +219,7 @@ static int test_overlap(void)
 	int entries, i, ret, err = 0;
 
 	entries = 0;
-	for (i = 0; tests[i].start != 1U; i++) {
+	for (i = 0; tests[i].start != -1U; i++) {
 		unsigned int this = tests[i].start + tests[i].nr;
 
 		if (this > entries)
@@ -204,7 +244,8 @@ static int test_overlap(void)
 		}
 	}
 
-	printf("pass!\n");
+	if (!err)
+		printf("pass!\n");
 	axmap_free(map);
 	return err;
 }
