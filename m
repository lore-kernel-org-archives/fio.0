Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaGZMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 26 Jul 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XB0dx-0007LI-MH
	for fio@vger.kernel.org; Sat, 26 Jul 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140726120004.62F7B401B7@lyth.info>
Date: Sat, 26 Jul 2014 06:00:04 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 24ef7a61bc7b9ec0f479980b6b219ef7d986d708:

  crc/test: cleanup and better precision (2014-07-25 10:12:26 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae7e055f755e77dfa71ae9040250ce8eec238721:

  crc/test: a few more cleanups and code unifications (2014-07-25 15:15:46 +0200)

----------------------------------------------------------------
Jens Axboe (1):
      crc/test: a few more cleanups and code unifications

 crc/test.c |   99 +++++++++++++++++-------------------------------------------
 1 file changed, 27 insertions(+), 72 deletions(-)

---

Diff of recent changes:

diff --git a/crc/test.c b/crc/test.c
index 194bbed..0c3b2da 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -26,7 +26,7 @@
 struct test_type {
 	const char *name;
 	unsigned int mask;
-	uint64_t (*fn)(void *, size_t);
+	void (*fn)(void *, size_t);
 };
 
 enum {
@@ -42,162 +42,105 @@ enum {
 	T_XXHASH	= 1U << 9,
 };
 
-static void randomize_buf(void *buf, unsigned int size, int seed)
-{
-	struct frand_state state;
-
-	init_rand_seed(&state, seed);
-	fill_random_buf(&state, buf, size);
-}
-
-static uint64_t t_md5(void *buf, size_t size)
+static void t_md5(void *buf, size_t size)
 {
 	uint32_t digest[4];
 	struct fio_md5_ctx ctx = { .hash = digest };
-	struct timeval s;
 	int i;
 
 	fio_md5_init(&ctx);
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_md5_update(&ctx, buf, size);
-
-	return utime_since_now(&s);
 }
 
-static uint64_t t_crc64(void *buf, size_t size)
+static void t_crc64(void *buf, size_t size)
 {
-	struct timeval s;
 	int i;
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_crc64(buf, size);
-
-	return utime_since_now(&s);
 }
 
-static uint64_t t_crc32(void *buf, size_t size)
+static void t_crc32(void *buf, size_t size)
 {
-	struct timeval s;
 	int i;
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_crc32(buf, size);
-
-	return utime_since_now(&s);
 }
 
-static uint64_t t_crc32c(void *buf, size_t size)
+static void t_crc32c(void *buf, size_t size)
 {
-	struct timeval s;
 	int i;
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_crc32c(buf, size);
-
-	return utime_since_now(&s);
 }
 
-static uint64_t t_crc16(void *buf, size_t size)
+static void t_crc16(void *buf, size_t size)
 {
-	struct timeval s;
 	int i;
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_crc16(buf, size);
-
-	return utime_since_now(&s);
 }
 
-static uint64_t t_crc7(void *buf, size_t size)
+static void t_crc7(void *buf, size_t size)
 {
-	struct timeval s;
-	uint64_t ret;
 	int i;
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_crc7(buf, size);
-
-	ret = utime_since_now(&s);
-	return ret;
 }
 
-static uint64_t t_sha1(void *buf, size_t size)
+static void t_sha1(void *buf, size_t size)
 {
 	uint32_t sha[5];
 	struct fio_sha1_ctx ctx = { .H = sha };
-	struct timeval s;
-	uint64_t ret;
 	int i;
 
 	fio_sha1_init(&ctx);
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_sha1_update(&ctx, buf, size);
-
-	ret = utime_since_now(&s);
-	return ret;
 }
 
-static uint64_t t_sha256(void *buf, size_t size)
+static void t_sha256(void *buf, size_t size)
 {
 	uint8_t sha[64];
 	struct fio_sha256_ctx ctx = { .buf = sha };
-	struct timeval s;
-	uint64_t ret;
 	int i;
 
 	fio_sha256_init(&ctx);
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_sha256_update(&ctx, buf, size);
-
-	ret = utime_since_now(&s);
-	return ret;
 }
 
-static uint64_t t_sha512(void *buf, size_t size)
+static void t_sha512(void *buf, size_t size)
 {
 	uint8_t sha[128];
 	struct fio_sha512_ctx ctx = { .buf = sha };
-	struct timeval s;
-	uint64_t ret;
 	int i;
 
 	fio_sha512_init(&ctx);
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_sha512_update(&ctx, buf, size);
-
-	ret = utime_since_now(&s);
-	return ret;
 }
 
-static uint64_t t_xxhash(void *buf, size_t size)
+static void t_xxhash(void *buf, size_t size)
 {
 	void *state;
-	struct timeval s;
-	uint64_t ret;
 	int i;
 
 	state = XXH32_init(0x8989);
 
-	fio_gettime(&s, NULL);
 	for (i = 0; i < NR_CHUNKS; i++)
 		XXH32_update(state, buf, size);
 
 	XXH32_digest(state);
-	ret = utime_since_now(&s);
-	return ret;
 }
 
 static struct test_type t[] = {
@@ -292,6 +235,7 @@ int fio_crctest(const char *type)
 {
 	unsigned int test_mask = 0;
 	uint64_t mb = CHUNK * NR_CHUNKS;
+	struct frand_state state;
 	int i, first = 1;
 	void *buf;
 
@@ -310,18 +254,29 @@ int fio_crctest(const char *type)
 	}
 
 	buf = malloc(CHUNK);
-	randomize_buf(buf, CHUNK, 0x8989);
+	init_rand_seed(&state, 0x8989);
+	fill_random_buf(&state, buf, CHUNK);
 
 	for (i = 0; t[i].name; i++) {
+		struct timeval tv;
 		double mb_sec;
 		uint64_t usec;
 
 		if (!(t[i].mask & test_mask))
 			continue;
 
-		usec = t[i].fn(buf, CHUNK);
-		if (first)
-			usec = t[i].fn(buf, CHUNK);
+		/*
+		 * For first run, make sure CPUs are spun up and that
+		 * we've touched the data.
+		 */
+		if (first) {
+			usec_spin(100000);
+			t[i].fn(buf, CHUNK);
+		}
+
+		fio_gettime(&tv, NULL);
+		t[i].fn(buf, CHUNK);
+		usec = utime_since_now(&tv);
 
 		mb_sec = (double) mb / (double) usec;
 		mb_sec /= (1.024 * 1.024);
