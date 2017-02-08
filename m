Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50498 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754355AbdBHNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2017 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cbRqw-00023Y-5i
        for fio@vger.kernel.org; Wed, 08 Feb 2017 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170208130001.E04BC2C0091@kernel.dk>
Date: Wed,  8 Feb 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9d25d068f88f1be7ce4e67654ee26f8faa1ebca4:

  doc: minor HOWTO fixes (2017-02-04 10:25:58 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 855f03627f2bce6a7f725fe6cc92e7ebe8d39deb:

  fnv: work with non-64-bit aligned chunks of data (2017-02-07 15:11:37 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      init: don't crash server on failure to open output log
      bloom: if we're not setting bits, break after first failed mask check
      fnv: work with non-64-bit aligned chunks of data

 crc/fnv.c   | 24 +++++++++++++++++++++---
 init.c      | 17 +++++++++++------
 lib/bloom.c |  4 +++-
 3 files changed, 35 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/crc/fnv.c b/crc/fnv.c
index 04c0560..4cd0650 100644
--- a/crc/fnv.c
+++ b/crc/fnv.c
@@ -2,14 +2,32 @@
 
 #define FNV_PRIME	0x100000001b3ULL
 
+/*
+ * 64-bit fnv, but don't require 64-bit multiples of data. Use bytes
+ * for the last unaligned chunk.
+ */
 uint64_t fnv(const void *buf, uint32_t len, uint64_t hval)
 {
 	const uint64_t *ptr = buf;
-	const uint64_t *end = (void *) buf + len;
 
-	while (ptr < end) {
+	while (len) {
 		hval *= FNV_PRIME;
-		hval ^= (uint64_t) *ptr++;
+		if (len >= sizeof(uint64_t)) {
+			hval ^= (uint64_t) *ptr++;
+			len -= sizeof(uint64_t);
+			continue;
+		} else {
+			const uint8_t *ptr8 = (const uint8_t *) ptr;
+			uint64_t val = 0;
+			int i;
+
+			for (i = 0; i < len; i++) {
+				val <<= 8;
+				val |= (uint8_t) *ptr8++;
+			}
+			hval ^= val;
+			break;
+		}
 	}
 
 	return hval;
diff --git a/init.c b/init.c
index 34ed20f..0a2ace1 100644
--- a/init.c
+++ b/init.c
@@ -2326,17 +2326,22 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case 'b':
 			write_bw_log = 1;
 			break;
-		case 'o':
+		case 'o': {
+			FILE *tmp;
+
 			if (f_out && f_out != stdout)
 				fclose(f_out);
 
-			f_out = fopen(optarg, "w+");
-			if (!f_out) {
-				perror("fopen output");
-				exit(1);
+			tmp = fopen(optarg, "w+");
+			if (!tmp) {
+				log_err("fio: output file open error: %s\n", strerror(errno));
+				exit_val = 1;
+				do_exit++;
+				break;
 			}
-			f_err = f_out;
+			f_err = f_out = tmp;
 			break;
+			}
 		case 'm':
 			output_format = FIO_OUTPUT_TERSE;
 			break;
diff --git a/lib/bloom.c b/lib/bloom.c
index 7a9ebaa..bb81dbb 100644
--- a/lib/bloom.c
+++ b/lib/bloom.c
@@ -104,8 +104,10 @@ static bool __bloom_check(struct bloom *b, const void *data, unsigned int len,
 
 		if (b->map[index] & (1U << bit))
 			was_set++;
-		if (set)
+		else if (set)
 			b->map[index] |= 1U << bit;
+		else
+			break;
 	}
 
 	return was_set == N_HASHES;
