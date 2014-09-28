Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaI1MAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 28 Sep 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XYD92-0006KO-Fz
	for fio@vger.kernel.org; Sun, 28 Sep 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140928120003.89D4E4017D@lyth.info>
Date: Sun, 28 Sep 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1066358aebafb7221732bedd6fb9fde56b14be7b:

  Improve dedupe/compression buffer filling for mixed block sizes (2014-09-26 15:04:58 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bc095aab789a2e7d036c6d499f6c124a0c2d5de0:

  t/dedupe: fixup bloom entry calculation (2014-09-27 21:29:03 -0600)

----------------------------------------------------------------
Jens Axboe (12):
      parse: fix issue with not filling leftover percentages correctly
      dedupe: exit gracefully if device/file open fails
      Add murmurhash3
      crc/test: fix alignment
      crc/test: add jhash
      Move murmur3 hash to crc/
      t/dedupe: print dedupe ratio instead of made-up factor
      crc/test: if the checksum needs a _final(), do it in the loop
      Add fnv hash
      crc/test: add fnv
      bloom: up hashes to 5 by default
      t/dedupe: fixup bloom entry calculation

 Makefile      |    4 +--
 crc/fnv.c     |   16 ++++++++++
 crc/fnv.h     |    8 +++++
 crc/murmur3.c |   68 +++++++++++++++++++++++++++++++++++++++++
 crc/murmur3.h |    8 +++++
 crc/test.c    |   93 ++++++++++++++++++++++++++++++++++++++++++++-------------
 lib/bloom.c   |   29 ++++++++++++++----
 options.c     |   11 +++----
 t/dedupe.c    |   15 ++++++----
 9 files changed, 212 insertions(+), 40 deletions(-)
 create mode 100644 crc/fnv.c
 create mode 100644 crc/fnv.h
 create mode 100644 crc/murmur3.c
 create mode 100644 crc/murmur3.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 8c424e3..8c6c056 100644
--- a/Makefile
+++ b/Makefile
@@ -192,8 +192,8 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
 T_DEDUPE_OBJS = t/dedupe.o
 T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
-		memalign.o lib/bloom.o t/debug.o crc/xxhash.o crc/crc32c.o \
-		crc/crc32c-intel.o
+		memalign.o lib/bloom.o t/debug.o crc/xxhash.o crc/murmur3.o \
+		crc/crc32c.o crc/crc32c-intel.o crc/fnv.o
 T_DEDUPE_PROGS = t/dedupe
 endif
 
diff --git a/crc/fnv.c b/crc/fnv.c
new file mode 100644
index 0000000..04c0560
--- /dev/null
+++ b/crc/fnv.c
@@ -0,0 +1,16 @@
+#include "fnv.h"
+
+#define FNV_PRIME	0x100000001b3ULL
+
+uint64_t fnv(const void *buf, uint32_t len, uint64_t hval)
+{
+	const uint64_t *ptr = buf;
+	const uint64_t *end = (void *) buf + len;
+
+	while (ptr < end) {
+		hval *= FNV_PRIME;
+		hval ^= (uint64_t) *ptr++;
+	}
+
+	return hval;
+}
diff --git a/crc/fnv.h b/crc/fnv.h
new file mode 100644
index 0000000..ef2b77b
--- /dev/null
+++ b/crc/fnv.h
@@ -0,0 +1,8 @@
+#ifndef FIO_FNV_H
+#define FIO_FNV_H
+
+#include <inttypes.h>
+
+uint64_t fnv(const void *, uint32_t, uint64_t);
+
+#endif
diff --git a/crc/murmur3.c b/crc/murmur3.c
new file mode 100644
index 0000000..e316f59
--- /dev/null
+++ b/crc/murmur3.c
@@ -0,0 +1,68 @@
+#include "murmur3.h"
+
+static inline uint32_t rotl32(uint32_t x, int8_t r)
+{
+	return (x << r) | (x >> (32 - r));
+}
+
+//-----------------------------------------------------------------------------
+// Finalization mix - force all bits of a hash block to avalanche
+
+static inline uint32_t fmix32(uint32_t h)
+{
+	h ^= h >> 16;
+	h *= 0x85ebca6b;
+	h ^= h >> 13;
+	h *= 0xc2b2ae35;
+	h ^= h >> 16;
+
+	return h;
+}
+
+static uint32_t murmur3_tail(const uint8_t *data, const int nblocks,
+			     uint32_t len, const uint32_t c1,
+			     const uint32_t c2, uint32_t h1)
+{
+	const uint8_t *tail = (const uint8_t *)(data + nblocks * 4);
+
+	uint32_t k1 = 0;
+	switch (len & 3) {
+	case 3:
+		k1 ^= tail[2] << 16;
+	case 2:
+		k1 ^= tail[1] << 8;
+	case 1:
+		k1 ^= tail[0];
+		k1 *= c1;
+		k1 = rotl32(k1, 15);
+		k1 *= c2;
+		h1 ^= k1;
+	};
+
+	return fmix32(h1 ^ len);
+}
+
+uint32_t murmurhash3(const void *key, uint32_t len, uint32_t seed)
+{
+	const uint8_t *data = (const uint8_t *)key;
+	const int nblocks = len / 4;
+	uint32_t h1 = seed;
+	const uint32_t c1 = 0xcc9e2d51;
+	const uint32_t c2 = 0x1b873593;
+	const uint32_t *blocks = (const uint32_t *)(data + nblocks * 4);
+	int i;
+
+	for (i = -nblocks; i; i++) {
+		uint32_t k1 = blocks[i];
+
+		k1 *= c1;
+		k1 = rotl32(k1, 15);
+		k1 *= c2;
+
+		h1 ^= k1;
+		h1 = rotl32(h1, 13);
+		h1 = h1 * 5 + 0xe6546b64;
+	}
+
+	return murmur3_tail(data, nblocks, len, c1, c2, h1);
+}
diff --git a/crc/murmur3.h b/crc/murmur3.h
new file mode 100644
index 0000000..89f6500
--- /dev/null
+++ b/crc/murmur3.h
@@ -0,0 +1,8 @@
+#ifndef FIO_MURMUR3_H
+#define FIO_MURMUR3_H
+
+#include <inttypes.h>
+
+uint32_t murmurhash3(const void *key, uint32_t len, uint32_t seed);
+
+#endif
diff --git a/crc/test.c b/crc/test.c
index 36054e6..bca46f2 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -17,6 +17,9 @@
 #include "../crc/sha256.h"
 #include "../crc/sha512.h"
 #include "../crc/xxhash.h"
+#include "../crc/murmur3.h"
+#include "../crc/fnv.h"
+#include "../hash.h"
 
 #include "test.h"
 
@@ -26,7 +29,8 @@
 struct test_type {
 	const char *name;
 	unsigned int mask;
-	void (*fn)(void *, size_t);
+	void (*fn)(struct test_type *, void *, size_t);
+	uint32_t output;
 };
 
 enum {
@@ -40,9 +44,12 @@ enum {
 	T_SHA256	= 1U << 7,
 	T_SHA512	= 1U << 8,
 	T_XXHASH	= 1U << 9,
+	T_MURMUR3	= 1U << 10,
+	T_JHASH		= 1U << 11,
+	T_FNV		= 1U << 12,
 };
 
-static void t_md5(void *buf, size_t size)
+static void t_md5(struct test_type *t, void *buf, size_t size)
 {
 	uint32_t digest[4];
 	struct fio_md5_ctx ctx = { .hash = digest };
@@ -50,13 +57,13 @@ static void t_md5(void *buf, size_t size)
 
 	fio_md5_init(&ctx);
 
-	for (i = 0; i < NR_CHUNKS; i++)
+	for (i = 0; i < NR_CHUNKS; i++) {
 		fio_md5_update(&ctx, buf, size);
-
-	fio_md5_final(&ctx);
+		fio_md5_final(&ctx);
+	}
 }
 
-static void t_crc64(void *buf, size_t size)
+static void t_crc64(struct test_type *t, void *buf, size_t size)
 {
 	int i;
 
@@ -64,7 +71,7 @@ static void t_crc64(void *buf, size_t size)
 		fio_crc64(buf, size);
 }
 
-static void t_crc32(void *buf, size_t size)
+static void t_crc32(struct test_type *t, void *buf, size_t size)
 {
 	int i;
 
@@ -72,7 +79,7 @@ static void t_crc32(void *buf, size_t size)
 		fio_crc32(buf, size);
 }
 
-static void t_crc32c(void *buf, size_t size)
+static void t_crc32c(struct test_type *t, void *buf, size_t size)
 {
 	int i;
 
@@ -80,7 +87,7 @@ static void t_crc32c(void *buf, size_t size)
 		fio_crc32c(buf, size);
 }
 
-static void t_crc16(void *buf, size_t size)
+static void t_crc16(struct test_type *t, void *buf, size_t size)
 {
 	int i;
 
@@ -88,7 +95,7 @@ static void t_crc16(void *buf, size_t size)
 		fio_crc16(buf, size);
 }
 
-static void t_crc7(void *buf, size_t size)
+static void t_crc7(struct test_type *t, void *buf, size_t size)
 {
 	int i;
 
@@ -96,7 +103,7 @@ static void t_crc7(void *buf, size_t size)
 		fio_crc7(buf, size);
 }
 
-static void t_sha1(void *buf, size_t size)
+static void t_sha1(struct test_type *t, void *buf, size_t size)
 {
 	uint32_t sha[5];
 	struct fio_sha1_ctx ctx = { .H = sha };
@@ -108,7 +115,7 @@ static void t_sha1(void *buf, size_t size)
 		fio_sha1_update(&ctx, buf, size);
 }
 
-static void t_sha256(void *buf, size_t size)
+static void t_sha256(struct test_type *t, void *buf, size_t size)
 {
 	uint8_t sha[64];
 	struct fio_sha256_ctx ctx = { .buf = sha };
@@ -116,13 +123,13 @@ static void t_sha256(void *buf, size_t size)
 
 	fio_sha256_init(&ctx);
 
-	for (i = 0; i < NR_CHUNKS; i++)
+	for (i = 0; i < NR_CHUNKS; i++) {
 		fio_sha256_update(&ctx, buf, size);
-
-	fio_sha256_final(&ctx);
+		fio_sha256_final(&ctx);
+	}
 }
 
-static void t_sha512(void *buf, size_t size)
+static void t_sha512(struct test_type *t, void *buf, size_t size)
 {
 	uint8_t sha[128];
 	struct fio_sha512_ctx ctx = { .buf = sha };
@@ -134,7 +141,31 @@ static void t_sha512(void *buf, size_t size)
 		fio_sha512_update(&ctx, buf, size);
 }
 
-static void t_xxhash(void *buf, size_t size)
+static void t_murmur3(struct test_type *t, void *buf, size_t size)
+{
+	int i;
+
+	for (i = 0; i < NR_CHUNKS; i++)
+		murmurhash3(buf, size, 0x8989);
+}
+
+static void t_jhash(struct test_type *t, void *buf, size_t size)
+{
+	int i;
+
+	for (i = 0; i < NR_CHUNKS; i++)
+		t->output += jhash(buf, size, 0x8989);
+}
+
+static void t_fnv(struct test_type *t, void *buf, size_t size)
+{
+	int i;
+
+	for (i = 0; i < NR_CHUNKS; i++)
+		t->output += fnv(buf, size, 0x8989);
+}
+
+static void t_xxhash(struct test_type *t, void *buf, size_t size)
 {
 	void *state;
 	int i;
@@ -144,7 +175,7 @@ static void t_xxhash(void *buf, size_t size)
 	for (i = 0; i < NR_CHUNKS; i++)
 		XXH32_update(state, buf, size);
 
-	XXH32_digest(state);
+	t->output = XXH32_digest(state);
 }
 
 static struct test_type t[] = {
@@ -199,6 +230,21 @@ static struct test_type t[] = {
 		.fn = t_xxhash,
 	},
 	{
+		.name = "murmur3",
+		.mask = T_MURMUR3,
+		.fn = t_murmur3,
+	},
+	{
+		.name = "jhash",
+		.mask = T_JHASH,
+		.fn = t_jhash,
+	},
+	{
+		.name = "fnv",
+		.mask = T_FNV,
+		.fn = t_fnv,
+	},
+	{
 		.name = NULL,
 	},
 };
@@ -265,6 +311,7 @@ int fio_crctest(const char *type)
 		struct timeval tv;
 		double mb_sec;
 		uint64_t usec;
+		char pre[3];
 
 		if (!(t[i].mask & test_mask))
 			continue;
@@ -275,16 +322,20 @@ int fio_crctest(const char *type)
 		 */
 		if (first) {
 			usec_spin(100000);
-			t[i].fn(buf, CHUNK);
+			t[i].fn(&t[i], buf, CHUNK);
 		}
 
 		fio_gettime(&tv, NULL);
-		t[i].fn(buf, CHUNK);
+		t[i].fn(&t[i], buf, CHUNK);
 		usec = utime_since_now(&tv);
 
 		mb_sec = (double) mb / (double) usec;
 		mb_sec /= (1.024 * 1.024);
-		printf("%s:\t%8.2f MB/sec\n", t[i].name, mb_sec);
+		if (strlen(t[i].name) >= 7)
+			sprintf(pre, "\t");
+		else
+			sprintf(pre, "\t\t");
+		printf("%s:%s%8.2f MB/sec\n", t[i].name, pre, mb_sec);
 		first = 0;
 	}
 
diff --git a/lib/bloom.c b/lib/bloom.c
index b469fde..33d093a 100644
--- a/lib/bloom.c
+++ b/lib/bloom.c
@@ -5,7 +5,9 @@
 #include "../hash.h"
 #include "../minmax.h"
 #include "../crc/xxhash.h"
+#include "../crc/murmur3.h"
 #include "../crc/crc32c.h"
+#include "../crc/fnv.h"
 
 struct bloom {
 	uint64_t nentries;
@@ -21,27 +23,42 @@ struct bloom_hash {
 	uint32_t (*fn)(const void *, uint32_t, uint32_t);
 };
 
-static uint32_t b_crc32c(const void *buf, uint32_t len, uint32_t seed)
+static uint32_t bloom_crc32c(const void *buf, uint32_t len, uint32_t seed)
 {
 	return fio_crc32c(buf, len);
 }
 
+static uint32_t bloom_fnv(const void *buf, uint32_t len, uint32_t seed)
+{
+	return fnv(buf, len, seed);
+}
+
+#define BLOOM_SEED	0x8989
+
 struct bloom_hash hashes[] = {
 	{
-		.seed = 0x8989,
+		.seed = BLOOM_SEED,
 		.fn = jhash,
 	},
 	{
-		.seed = 0x8989,
+		.seed = BLOOM_SEED,
 		.fn = XXH32,
 	},
 	{
-		.seed = 0,
-		.fn = b_crc32c,
+		.seed = BLOOM_SEED,
+		.fn = murmurhash3,
+	},
+	{
+		.seed = BLOOM_SEED,
+		.fn = bloom_crc32c,
+	},
+	{
+		.seed = BLOOM_SEED,
+		.fn = bloom_fnv,
 	},
 };
 
-#define N_HASHES	3
+#define N_HASHES	5
 
 #define MIN_ENTRIES	1073741824UL
 
diff --git a/options.c b/options.c
index 593f717..56e9108 100644
--- a/options.c
+++ b/options.c
@@ -98,9 +98,9 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 			if (perc > 100)
 				perc = 100;
 			else if (!perc)
-				perc = -1;
+				perc = -1U;
 		} else
-			perc = -1;
+			perc = -1U;
 
 		if (str_to_decimal(fname, &val, 1, o, 0)) {
 			log_err("fio: bssplit conversion failed\n");
@@ -127,7 +127,7 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 	for (i = 0; i < o->bssplit_nr[ddir]; i++) {
 		struct bssplit *bsp = &bssplit[i];
 
-		if (bsp->perc == (unsigned char) -1)
+		if (bsp->perc == -1U)
 			perc_missing++;
 		else
 			perc += bsp->perc;
@@ -138,17 +138,18 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 		free(bssplit);
 		return 1;
 	}
+
 	/*
 	 * If values didn't have a percentage set, divide the remains between
 	 * them.
 	 */
 	if (perc_missing) {
-		if (perc_missing == 1)
+		if (perc_missing == 1 && o->bssplit_nr[ddir] == 1)
 			perc = 100;
 		for (i = 0; i < o->bssplit_nr[ddir]; i++) {
 			struct bssplit *bsp = &bssplit[i];
 
-			if (bsp->perc == (unsigned char) -1)
+			if (bsp->perc == -1U)
 				bsp->perc = (100 - perc) / perc_missing;
 		}
 	}
diff --git a/t/dedupe.c b/t/dedupe.c
index 5998138..f9fb8c4 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -452,7 +452,7 @@ static int dedupe_check(const char *filename, uint64_t *nextents,
 	if (use_bloom) {
 		uint64_t bloom_entries;
 
-		bloom_entries = (3 * dev_size ) / (blocksize * 2);
+		bloom_entries = 8 * (dev_size / blocksize);
 		bloom = bloom_new(bloom_entries);
 	}
 
@@ -475,10 +475,11 @@ static void show_chunk(struct chunk *c)
 
 static void show_stat(uint64_t nextents, uint64_t nchunks)
 {
-	double perc;
+	double perc, ratio;
 
 	printf("Extents=%lu, Unique extents=%lu\n", (unsigned long) nextents, (unsigned long) nchunks);
-	printf("De-dupe factor: %3.2f\n", (double) nextents / (double) nchunks);
+	ratio = (double) nextents / (double) nchunks;
+	printf("De-dupe ratio: 1:%3.2f\n", ratio - 1.0);
 
 	perc = 1.00 - ((double) nchunks / (double) nextents);
 	perc *= 100.0;
@@ -575,10 +576,12 @@ int main(int argc, char *argv[])
 
 	ret = dedupe_check(argv[optind], &nextents, &nchunks);
 
-	if (!bloom)
-		iter_rb_tree(&nextents, &nchunks);
+	if (!ret) {
+		if (!bloom)
+			iter_rb_tree(&nextents, &nchunks);
 
-	show_stat(nextents, nchunks);
+		show_stat(nextents, nchunks);
+	}
 
 	fio_mutex_remove(rb_lock);
 	if (bloom)
