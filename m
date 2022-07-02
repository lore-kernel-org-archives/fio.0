Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AFCC433EF
	for <fio@archiver.kernel.org>; Sat,  2 Jul 2022 12:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiGBMAT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 2 Jul 2022 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiGBMAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Jul 2022 08:00:19 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AF1E4F
        for <fio@vger.kernel.org>; Sat,  2 Jul 2022 05:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=9PntD6vkBEjoMUA/CwZkYJNXGuBYCAFj22tiUuhCZg0=; b=grjXL9bxD2XImIeM2BMEV3PCxD
        WCjh3pkpa4tOJ2dgrInoi3zQ0LFNaEKA3BStpVpHbLnbjEsqvlzrMGyidiOtdFBHcIcvH3zw8/NC7
        kEx7v2ZRWRmN05f0zi+9gxV5GIb6EFHHtCl7Wy7kNL22G4lqFHGDRjVdM+MlUvp/2Ks6NXh0OvlC2
        U0QIlTRMYesGZm7Gk3rrpIrkCIkGzBQ20UXNgxuVwJagVoO5uwEKdCgVCloZOsZ+MES5fW44xkqM+
        qgF58mP+ScHAU+YHjbDFllTYWCTyPtrLW86T0n7hq6Q6MJCNg3kchxifB7Vw3VDHSNOxZIl+w9ZBm
        b5bDWnvA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o7bnB-00GB9P-9J
        for fio@vger.kernel.org; Sat, 02 Jul 2022 12:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id DE9741BC0177; Sat,  2 Jul 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220702120001.DE9741BC0177@kernel.dk>
Date:   Sat,  2 Jul 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 660879102e32a0ed3d3225afaebcc0d46625a4a6:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-06-23 08:20:22 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dc4729e3ef6a9116d7cd30e96e4f5863883e5bd7:

  hash: cleanups (2022-07-01 15:03:39 -0600)

----------------------------------------------------------------
Georg Sauthoff (1):
      Simplify and optimize __fill_random_buf

Jens Axboe (3):
      Merge branch 'fill-random-smaller' of https://github.com/gsauthof/fio
      lib/rand: improve __fill_random_buf()
      hash: cleanups

 engines/rdma.c |  2 +-
 hash.h         | 26 --------------------------
 lib/rand.c     | 30 +++++++++---------------------
 3 files changed, 10 insertions(+), 48 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rdma.c b/engines/rdma.c
index e3bb2567..fcb41068 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -1389,7 +1389,7 @@ static int fio_rdmaio_setup(struct thread_data *td)
 		rd = malloc(sizeof(*rd));
 
 		memset(rd, 0, sizeof(*rd));
-		init_rand_seed(&rd->rand_state, (unsigned int) GOLDEN_RATIO_PRIME, 0);
+		init_rand_seed(&rd->rand_state, (unsigned int) GOLDEN_RATIO_64, 0);
 		td->io_ops_data = rd;
 	}
 
diff --git a/hash.h b/hash.h
index f7596a56..51f0706e 100644
--- a/hash.h
+++ b/hash.h
@@ -9,32 +9,6 @@
    (C) 2002 William Lee Irwin III, IBM */
 
 /*
- * Knuth recommends primes in approximately golden ratio to the maximum
- * integer representable by a machine word for multiplicative hashing.
- * Chuck Lever verified the effectiveness of this technique:
- * http://www.citi.umich.edu/techreports/reports/citi-tr-00-1.pdf
- *
- * These primes are chosen to be bit-sparse, that is operations on
- * them can use shifts and additions instead of multiplications for
- * machines where multiplications are slow.
- */
-
-#if BITS_PER_LONG == 32
-/* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
-#define GOLDEN_RATIO_PRIME 0x9e370001UL
-#elif BITS_PER_LONG == 64
-/*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
-#define GOLDEN_RATIO_PRIME 0x9e37fffffffc0001UL
-#else
-#error Define GOLDEN_RATIO_PRIME for your wordsize.
-#endif
-
-/*
- * The above primes are actively bad for hashing, since they are
- * too sparse. The 32-bit one is mostly ok, the 64-bit one causes
- * real problems. Besides, the "prime" part is pointless for the
- * multiplicative hash.
- *
  * Although a random odd number will do, it turns out that the golden
  * ratio phi = (sqrt(5)-1)/2, or its negative, has particularly nice
  * properties.
diff --git a/lib/rand.c b/lib/rand.c
index 6e893e80..1e669116 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -97,29 +97,17 @@ void init_rand_seed(struct frand_state *state, uint64_t seed, bool use64)
 
 void __fill_random_buf(void *buf, unsigned int len, uint64_t seed)
 {
-	void *ptr = buf;
+	uint64_t *b = buf;
+	uint64_t *e = b  + len / sizeof(*b);
+	unsigned int rest = len % sizeof(*b);
 
-	while (len) {
-		int this_len;
-
-		if (len >= sizeof(int64_t)) {
-			*((int64_t *) ptr) = seed;
-			this_len = sizeof(int64_t);
-		} else if (len >= sizeof(int32_t)) {
-			*((int32_t *) ptr) = seed;
-			this_len = sizeof(int32_t);
-		} else if (len >= sizeof(int16_t)) {
-			*((int16_t *) ptr) = seed;
-			this_len = sizeof(int16_t);
-		} else {
-			*((int8_t *) ptr) = seed;
-			this_len = sizeof(int8_t);
-		}
-		ptr += this_len;
-		len -= this_len;
-		seed *= GOLDEN_RATIO_PRIME;
-		seed >>= 3;
+	for (; b != e; ++b) {
+		*b = seed;
+		seed = __hash_u64(seed);
 	}
+
+	if (fio_unlikely(rest))
+		__builtin_memcpy(e, &seed, rest);
 }
 
 uint64_t fill_random_buf(struct frand_state *fs, void *buf,
