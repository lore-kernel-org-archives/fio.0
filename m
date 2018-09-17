Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37346 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbeIQR1V (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Sep 2018 13:27:21 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g1sCS-0003br-81
        for fio@vger.kernel.org; Mon, 17 Sep 2018 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180917120002.288152C0311@kernel.dk>
Date: Mon, 17 Sep 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e26029be10ee2c570cba2c4cc2b1987568306cd2:

  Merge branch 'histo-log-dup-timestamp' of https://github.com/parallel-fs-utils/fio (2018-09-12 14:33:04 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0f9f1921197d79fe5069473b9d85ca4559ef8c42:

  axmap: isset_fn() should use 1ULL, not 1UL (2018-09-16 21:58:26 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      Merge branch 'windows_static' of https://github.com/sitsofe/fio
      axmap: use 64-bit type for number of bits
      axmap: use 64-bit index for the handlers
      lfsr: use unsigned long long for 64-bit values
      t/axmap: use a 64-bit type (not size_t) for axmap tests
      axmap: isset_fn() should use 1ULL, not 1UL

Sitsofe Wheeler (1):
      build: change where we set -static for Windows

 Makefile    |  2 +-
 configure   |  1 +
 lib/axmap.c | 19 ++++++++++---------
 lib/axmap.h |  2 +-
 lib/lfsr.c  |  8 ++++----
 t/axmap.c   | 10 +++++-----
 6 files changed, 22 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 42e5205..4721b78 100644
--- a/Makefile
+++ b/Makefile
@@ -198,7 +198,7 @@ endif
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   SOURCE += os/windows/posix.c
   LIBS	 += -lpthread -lpsapi -lws2_32
-  CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format -static
+  CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
 endif
 
 OBJS := $(SOURCE:.c=.o)
diff --git a/configure b/configure
index 26c345b..5490e26 100755
--- a/configure
+++ b/configure
@@ -361,6 +361,7 @@ CYGWIN*)
   output_sym "CONFIG_WINDOWSAIO"
   # We now take the regular configuration path without having exit 0 here.
   # Flags below are still necessary mostly for MinGW.
+  build_static="yes"
   socklen_t="yes"
   rusage_thread="yes"
   fdatasync="yes"
diff --git a/lib/axmap.c b/lib/axmap.c
index 03e712f..27301bd 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -110,7 +110,7 @@ void axmap_free(struct axmap *axmap)
 }
 
 /* Allocate memory for a set that can store the numbers 0 .. @nr_bits - 1. */
-struct axmap *axmap_new(unsigned long nr_bits)
+struct axmap *axmap_new(uint64_t nr_bits)
 {
 	struct axmap *axmap;
 	unsigned int i, levels;
@@ -135,13 +135,14 @@ struct axmap *axmap_new(unsigned long nr_bits)
 	for (i = 0; i < axmap->nr_levels; i++) {
 		struct axmap_level *al = &axmap->levels[i];
 
+		nr_bits = (nr_bits + BLOCKS_PER_UNIT - 1) >> UNIT_SHIFT;
+
 		al->level = i;
-		al->map_size = (nr_bits + BLOCKS_PER_UNIT - 1) >> UNIT_SHIFT;
+		al->map_size = nr_bits;
 		al->map = malloc(al->map_size * sizeof(unsigned long));
 		if (!al->map)
 			goto free_levels;
 
-		nr_bits = (nr_bits + BLOCKS_PER_UNIT - 1) >> UNIT_SHIFT;
 	}
 
 	axmap_reset(axmap);
@@ -164,7 +165,7 @@ free_axmap:
  * returns true.
  */
 static bool axmap_handler(struct axmap *axmap, uint64_t bit_nr,
-			  bool (*func)(struct axmap_level *, unsigned long, unsigned int,
+			  bool (*func)(struct axmap_level *, uint64_t, unsigned int,
 			  void *), void *data)
 {
 	struct axmap_level *al;
@@ -193,12 +194,12 @@ static bool axmap_handler(struct axmap *axmap, uint64_t bit_nr,
  * returns true.
  */
 static bool axmap_handler_topdown(struct axmap *axmap, uint64_t bit_nr,
-	bool (*func)(struct axmap_level *, unsigned long, unsigned int, void *))
+	bool (*func)(struct axmap_level *, uint64_t, unsigned int, void *))
 {
 	int i;
 
 	for (i = axmap->nr_levels - 1; i >= 0; i--) {
-		unsigned long index = bit_nr >> (UNIT_SHIFT * i);
+		uint64_t index = bit_nr >> (UNIT_SHIFT * i);
 		unsigned long offset = index >> UNIT_SHIFT;
 		unsigned int bit = index & BLOCKS_PER_UNIT_MASK;
 
@@ -219,7 +220,7 @@ struct axmap_set_data {
  * the boundary of the element at offset @offset. Return the number of bits
  * that have been set in @__data->set_bits if @al->level == 0.
  */
-static bool axmap_set_fn(struct axmap_level *al, unsigned long offset,
+static bool axmap_set_fn(struct axmap_level *al, uint64_t offset,
 			 unsigned int bit, void *__data)
 {
 	struct axmap_set_data *data = __data;
@@ -321,10 +322,10 @@ unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr,
 	return set_bits;
 }
 
-static bool axmap_isset_fn(struct axmap_level *al, unsigned long offset,
+static bool axmap_isset_fn(struct axmap_level *al, uint64_t offset,
 			   unsigned int bit, void *unused)
 {
-	return (al->map[offset] & (1UL << bit)) != 0;
+	return (al->map[offset] & (1ULL << bit)) != 0;
 }
 
 bool axmap_isset(struct axmap *axmap, uint64_t bit_nr)
diff --git a/lib/axmap.h b/lib/axmap.h
index 55349d8..aa59768 100644
--- a/lib/axmap.h
+++ b/lib/axmap.h
@@ -5,7 +5,7 @@
 #include "types.h"
 
 struct axmap;
-struct axmap *axmap_new(unsigned long nr_bits);
+struct axmap *axmap_new(uint64_t nr_bits);
 void axmap_free(struct axmap *bm);
 
 void axmap_set(struct axmap *axmap, uint64_t bit_nr);
diff --git a/lib/lfsr.c b/lib/lfsr.c
index a4f1fb1..49e34a8 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -78,7 +78,7 @@ static uint8_t lfsr_taps[64][FIO_MAX_TAPS] =
 
 #define __LFSR_NEXT(__fl, __v)						\
 	__v = ((__v >> 1) | __fl->cached_bit) ^			\
-			(((__v & 1UL) - 1UL) & __fl->xormask);
+			(((__v & 1ULL) - 1ULL) & __fl->xormask);
 
 static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
 {
@@ -146,7 +146,7 @@ static uint64_t lfsr_create_xormask(uint8_t *taps)
 	uint64_t xormask = 0;
 
 	for(i = 0; i < FIO_MAX_TAPS && taps[i] != 0; i++)
-		xormask |= 1UL << (taps[i] - 1);
+		xormask |= 1ULL << (taps[i] - 1);
 
 	return xormask;
 }
@@ -161,7 +161,7 @@ static uint8_t *find_lfsr(uint64_t size)
 	 * take that into account.
 	 */
 	for (i = 3; i < 64; i++)
-		if ((1UL << i) > size)
+		if ((1ULL << i) > size)
 			return lfsr_taps[i];
 
 	return NULL;
@@ -241,7 +241,7 @@ int lfsr_init(struct fio_lfsr *fl, uint64_t nums, unsigned long seed,
 
 	fl->max_val = nums - 1;
 	fl->xormask = lfsr_create_xormask(taps);
-	fl->cached_bit = 1UL << (taps[0] - 1);
+	fl->cached_bit = 1ULL << (taps[0] - 1);
 
 	if (prepare_spin(fl, spin))
 		return 1;
diff --git a/t/axmap.c b/t/axmap.c
index a2e6fd6..9d6bdee 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -5,7 +5,7 @@
 #include "../lib/lfsr.h"
 #include "../lib/axmap.h"
 
-static int test_regular(size_t size, int seed)
+static int test_regular(uint64_t size, int seed)
 {
 	struct fio_lfsr lfsr;
 	struct axmap *map;
@@ -61,11 +61,11 @@ static int check_next_free(struct axmap *map, uint64_t start, uint64_t expected)
 	return 0;
 }
 
-static int test_next_free(size_t size, int seed)
+static int test_next_free(uint64_t size, int seed)
 {
 	struct fio_lfsr lfsr;
 	struct axmap *map;
-	size_t osize;
+	uint64_t osize;
 	uint64_t ff, lastfree;
 	int err, i;
 
@@ -196,7 +196,7 @@ static int test_next_free(size_t size, int seed)
 	return 0;
 }
 
-static int test_multi(size_t size, unsigned int bit_off)
+static int test_multi(uint64_t size, unsigned int bit_off)
 {
 	unsigned int map_size = size;
 	struct axmap *map;
@@ -395,7 +395,7 @@ static int test_overlap(void)
 
 int main(int argc, char *argv[])
 {
-	size_t size = (1UL << 23) - 200;
+	uint64_t size = (1ULL << 23) - 200;
 	int seed = 1;
 
 	if (argc > 1) {

