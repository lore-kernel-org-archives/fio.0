Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60176 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbeHWP3j (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Aug 2018 11:29:39 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fsoHc-0007Lc-Mz
        for fio@vger.kernel.org; Thu, 23 Aug 2018 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180823120002.5A8022C234E@kernel.dk>
Date: Thu, 23 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit daa899130fdd40f5df720ee54980b00b07903dc4:

  io_u: residiual size should be unsigned long long (2018-08-21 09:16:09 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c08890d3a81cebb5b4bde14afb6c7778bb390ddf:

  Merge branch 'axmap' of https://github.com/bvanassche/fio (2018-08-22 20:13:45 -0600)

----------------------------------------------------------------
Bart Van Assche (5):
      lib/axmap: Add more documentation
      lib/axmap: Inline ulog64()
      lib/axmap: Make axmap_new() more robust
      lib/axmap: Simplify axmap_set_fn()
      lib/axmap: Optimize __axmap_set()

Jens Axboe (1):
      Merge branch 'axmap' of https://github.com/bvanassche/fio

 lib/axmap.c | 96 ++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 36 deletions(-)

---

Diff of recent changes:

diff --git a/lib/axmap.c b/lib/axmap.c
index 923aae4..e194e80 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -57,26 +57,33 @@ static const unsigned long bit_masks[] = {
 #endif
 };
 
+/**
+ * struct axmap_level - a bitmap used to implement struct axmap
+ * @level: Level index. Each map has at least one level with index zero. The
+ *	higher the level index, the fewer bits a struct axmap_level contains.
+ * @map_size: Number of elements of the @map array.
+ * @map: A bitmap with @map_size elements.
+ */
 struct axmap_level {
 	int level;
 	unsigned long map_size;
 	unsigned long *map;
 };
 
+/**
+ * struct axmap - a set that can store numbers 0 .. @nr_bits - 1
+ * @nr_level: Number of elements of the @levels array.
+ * @levels: struct axmap_level array in which lower levels contain more bits
+ *	than higher levels.
+ * @nr_bits: One more than the highest value stored in the set.
+ */
 struct axmap {
 	unsigned int nr_levels;
 	struct axmap_level *levels;
 	uint64_t nr_bits;
 };
 
-static inline unsigned long ulog64(unsigned long val, unsigned int log)
-{
-	while (log-- && val)
-		val >>= UNIT_SHIFT;
-
-	return val;
-}
-
+/* Remove all elements from the @axmap set */
 void axmap_reset(struct axmap *axmap)
 {
 	int i;
@@ -102,6 +109,7 @@ void axmap_free(struct axmap *axmap)
 	free(axmap);
 }
 
+/* Allocate memory for a set that can store the numbers 0 .. @nr_bits - 1. */
 struct axmap *axmap_new(unsigned long nr_bits)
 {
 	struct axmap *axmap;
@@ -120,6 +128,8 @@ struct axmap *axmap_new(unsigned long nr_bits)
 
 	axmap->nr_levels = levels;
 	axmap->levels = calloc(axmap->nr_levels, sizeof(struct axmap_level));
+	if (!axmap->levels)
+		goto free_axmap;
 	axmap->nr_bits = nr_bits;
 
 	for (i = 0; i < axmap->nr_levels; i++) {
@@ -129,23 +139,30 @@ struct axmap *axmap_new(unsigned long nr_bits)
 		al->map_size = (nr_bits + BLOCKS_PER_UNIT - 1) >> UNIT_SHIFT;
 		al->map = malloc(al->map_size * sizeof(unsigned long));
 		if (!al->map)
-			goto err;
+			goto free_levels;
 
 		nr_bits = (nr_bits + BLOCKS_PER_UNIT - 1) >> UNIT_SHIFT;
 	}
 
 	axmap_reset(axmap);
 	return axmap;
-err:
+
+free_levels:
 	for (i = 0; i < axmap->nr_levels; i++)
-		if (axmap->levels[i].map)
-			free(axmap->levels[i].map);
+		free(axmap->levels[i].map);
 
 	free(axmap->levels);
+
+free_axmap:
 	free(axmap);
 	return NULL;
 }
 
+/*
+ * Call @func for each level, starting at level zero, until a level is found
+ * for which @func returns true. Return false if none of the @func calls
+ * returns true.
+ */
 static bool axmap_handler(struct axmap *axmap, uint64_t bit_nr,
 			  bool (*func)(struct axmap_level *, unsigned long, unsigned int,
 			  void *), void *data)
@@ -170,13 +187,18 @@ static bool axmap_handler(struct axmap *axmap, uint64_t bit_nr,
 	return false;
 }
 
+/*
+ * Call @func for each level, starting at the highest level, until a level is
+ * found for which @func returns true. Return false if none of the @func calls
+ * returns true.
+ */
 static bool axmap_handler_topdown(struct axmap *axmap, uint64_t bit_nr,
 	bool (*func)(struct axmap_level *, unsigned long, unsigned int, void *))
 {
 	int i;
 
 	for (i = axmap->nr_levels - 1; i >= 0; i--) {
-		unsigned long index = ulog64(bit_nr, i);
+		unsigned long index = bit_nr >> (UNIT_SHIFT * i);
 		unsigned long offset = index >> UNIT_SHIFT;
 		unsigned int bit = index & BLOCKS_PER_UNIT_MASK;
 
@@ -192,6 +214,11 @@ struct axmap_set_data {
 	unsigned int set_bits;
 };
 
+/*
+ * Set at most @__data->nr_bits bits in @al at offset @offset. Do not exceed
+ * the boundary of the element at offset @offset. Return the number of bits
+ * that have been set in @__data->set_bits if @al->level == 0.
+ */
 static bool axmap_set_fn(struct axmap_level *al, unsigned long offset,
 			 unsigned int bit, void *__data)
 {
@@ -208,18 +235,12 @@ static bool axmap_set_fn(struct axmap_level *al, unsigned long offset,
 	 */
 	overlap = al->map[offset] & mask;
 	if (overlap == mask) {
-done:
 		data->set_bits = 0;
 		return true;
 	}
 
 	if (overlap) {
-		const int __bit = ffz(~overlap);
-
-		nr_bits = __bit - bit;
-		if (!nr_bits)
-			goto done;
-
+		nr_bits = ffz(~overlap) - bit;
 		mask = bit_masks[nr_bits] << bit;
 	}
 
@@ -230,36 +251,33 @@ done:
 	if (!al->level)
 		data->set_bits = nr_bits;
 
+	/* For the next level */
 	data->nr_bits = 1;
+
 	return al->map[offset] != -1UL;
 }
 
+/*
+ * Set up to @data->nr_bits starting from @bit_nr in @axmap. Start at
+ * @bit_nr. If that bit has not yet been set then set it and continue until
+ * either @data->nr_bits have been set or a 1 bit is found. Store the number
+ * of bits that have been set in @data->set_bits. It is guaranteed that all
+ * bits that have been requested to set fit in the same unsigned long word of
+ * level 0 of @axmap.
+ */
 static void __axmap_set(struct axmap *axmap, uint64_t bit_nr,
 			 struct axmap_set_data *data)
 {
-	unsigned int set_bits, nr_bits = data->nr_bits;
+	unsigned int nr_bits = data->nr_bits;
 
 	if (bit_nr > axmap->nr_bits)
 		return;
 	else if (bit_nr + nr_bits > axmap->nr_bits)
 		nr_bits = axmap->nr_bits - bit_nr;
 
-	set_bits = 0;
-	while (nr_bits) {
-		axmap_handler(axmap, bit_nr, axmap_set_fn, data);
-		set_bits += data->set_bits;
+	assert(nr_bits <= BLOCKS_PER_UNIT);
 
-		if (!data->set_bits ||
-		    data->set_bits != (BLOCKS_PER_UNIT - nr_bits))
-			break;
-
-		nr_bits -= data->set_bits;
-		bit_nr += data->set_bits;
-
-		data->nr_bits = nr_bits;
-	}
-
-	data->set_bits = set_bits;
+	axmap_handler(axmap, bit_nr, axmap_set_fn, data);
 }
 
 void axmap_set(struct axmap *axmap, uint64_t bit_nr)
@@ -269,6 +287,12 @@ void axmap_set(struct axmap *axmap, uint64_t bit_nr)
 	__axmap_set(axmap, bit_nr, &data);
 }
 
+/*
+ * Set up to @nr_bits starting from @bit in @axmap. Start at @bit. If that
+ * bit has not yet been set then set it and continue until either @nr_bits
+ * have been set or a 1 bit is found. Return the number of bits that have been
+ * set.
+ */
 unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr,
 			  unsigned int nr_bits)
 {

