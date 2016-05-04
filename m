Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53444 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcEDMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 May 2016 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1axvTI-00076V-Tz
	for fio@vger.kernel.org; Wed, 04 May 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160504120002.513FA2C00AC@kernel.dk>
Date: Wed,  4 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 08a2cbf64720d9371ea4649b1bdc00257916a326:

  Update RBD documentation (2016-05-02 08:25:16 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2078c1369f993b4d760d3fe1f90cb6ffa4389fe5:

  hash: import Linux sparse hash fix (2016-05-03 13:56:47 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      hash: import Linux sparse hash fix

 hash.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/hash.h b/hash.h
index 02b0614..1d7608b 100644
--- a/hash.h
+++ b/hash.h
@@ -28,13 +28,29 @@
 #error Define GOLDEN_RATIO_PRIME for your wordsize.
 #endif
 
-#define GR_PRIME_64	0x9e37fffffffc0001ULL
+/*
+ * The above primes are actively bad for hashing, since they are
+ * too sparse. The 32-bit one is mostly ok, the 64-bit one causes
+ * real problems. Besides, the "prime" part is pointless for the
+ * multiplicative hash.
+ *
+ * Although a random odd number will do, it turns out that the golden
+ * ratio phi = (sqrt(5)-1)/2, or its negative, has particularly nice
+ * properties.
+ *
+ * These are the negative, (1 - phi) = (phi^2) = (3 - sqrt(5))/2.
+ * (See Knuth vol 3, section 6.4, exercise 9.)
+ */
+#define GOLDEN_RATIO_32 0x61C88647
+#define GOLDEN_RATIO_64 0x61C8864680B583EBull
 
 static inline unsigned long __hash_long(unsigned long val)
 {
 	unsigned long hash = val;
 
 #if BITS_PER_LONG == 64
+	hash *= GOLDEN_RATIO_64;
+#else
 	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
 	unsigned long n = hash;
 	n <<= 18;
@@ -49,9 +65,6 @@ static inline unsigned long __hash_long(unsigned long val)
 	hash += n;
 	n <<= 2;
 	hash += n;
-#else
-	/* On some cpus multiply is faster, on others gcc will do shifts */
-	hash *= GOLDEN_RATIO_PRIME;
 #endif
 
 	return hash;
@@ -65,7 +78,7 @@ static inline unsigned long hash_long(unsigned long val, unsigned int bits)
 
 static inline uint64_t __hash_u64(uint64_t val)
 {
-	return val * GR_PRIME_64;
+	return val * GOLDEN_RATIO_64;
 }
 	
 static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
@@ -77,7 +90,7 @@ static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
  * Bob Jenkins jhash
  */
 
-#define JHASH_INITVAL	GOLDEN_RATIO_PRIME
+#define JHASH_INITVAL	GOLDEN_RATIO_32
 
 static inline uint32_t rol32(uint32_t word, uint32_t shift)
 {
