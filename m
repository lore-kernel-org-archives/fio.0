Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53436 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbcIXMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 24 Sep 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bnlci-0000Iv-0u
        for fio@vger.kernel.org; Sat, 24 Sep 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160924120001.A47242C00D4@kernel.dk>
Date: Sat, 24 Sep 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1d272416412b0c867224a2b667e6b6124cbc26e8:

  stat: check if ctime_r() ends in a newline before stripping (2016-09-20 21:58:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0a301e93062df3735f9bb87c445e18d98a4b6efb:

  bloom: add string version (2016-09-23 11:57:00 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      bloom: use bool
      bloom: hashes take byte lengths, not nwords
      bloom: add string version

 lib/bloom.c | 15 ++++++++++-----
 lib/bloom.h |  4 +++-
 2 files changed, 13 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/lib/bloom.c b/lib/bloom.c
index f4eff57..c2e6c11 100644
--- a/lib/bloom.c
+++ b/lib/bloom.c
@@ -88,14 +88,14 @@ void bloom_free(struct bloom *b)
 	free(b);
 }
 
-static int __bloom_check(struct bloom *b, uint32_t *data, unsigned int nwords,
-			 int set)
+static bool __bloom_check(struct bloom *b, const void *data, unsigned int len,
+			  bool set)
 {
 	uint32_t hash[N_HASHES];
 	int i, was_set;
 
 	for (i = 0; i < N_HASHES; i++) {
-		hash[i] = hashes[i].fn(data, nwords, hashes[i].seed);
+		hash[i] = hashes[i].fn(data, len, hashes[i].seed);
 		hash[i] = hash[i] % b->nentries;
 	}
 
@@ -113,7 +113,12 @@ static int __bloom_check(struct bloom *b, uint32_t *data, unsigned int nwords,
 	return was_set == N_HASHES;
 }
 
-int bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords)
+bool bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords)
 {
-	return __bloom_check(b, data, nwords, 1);
+	return __bloom_check(b, data, nwords * sizeof(uint32_t), true);
+}
+
+bool bloom_set_string(struct bloom *b, const char *data, unsigned int len)
+{
+	return __bloom_check(b, data, len, true);
 }
diff --git a/lib/bloom.h b/lib/bloom.h
index 127ed9b..d40d9f6 100644
--- a/lib/bloom.h
+++ b/lib/bloom.h
@@ -2,11 +2,13 @@
 #define FIO_BLOOM_H
 
 #include <inttypes.h>
+#include "../lib/types.h"
 
 struct bloom;
 
 struct bloom *bloom_new(uint64_t entries);
 void bloom_free(struct bloom *b);
-int bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords);
+bool bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords);
+bool bloom_set_string(struct bloom *b, const char *data, unsigned int len);
 
 #endif
