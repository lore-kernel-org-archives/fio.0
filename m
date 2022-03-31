Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A11DC433EF
	for <fio@archiver.kernel.org>; Thu, 31 Mar 2022 12:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiCaMDr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 31 Mar 2022 08:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbiCaMDG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 31 Mar 2022 08:03:06 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D7820A38A
        for <fio@vger.kernel.org>; Thu, 31 Mar 2022 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=HZyRwFVPOMxAT50ztAxijslDDx1HC4KeqOwnCn5Ez3Q=; b=TZGmI1oEAvLi/i2hBW7KEjmNKI
        5W5nF8+9+yHcBwkCAzYQfuesolIsf1EEMRs7CNrkYI67JGvj/y8GPFJN2LWY9m1t+6d53SttDquv4
        2rdt/uALjw3F9rm9omnV9CJWtD1vroQXVy26Tvg8i8mpbEJhTKjwPrysWuRW7yuOH7eDc2I+0vAum
        t1cMknhLcTc+XlYPHcRuU/8bjq++gxrs2H8JZZkvTPc68T76tEoA1QlAJ7yp4bGPk7SbspKHI8wye
        SmMgIplf7jcHUY4yg4Yw7xa7JtZLtiE4VubSvTT+vkBpkOKcHjbUnHFFAn9LRDNU/jKLAfFwKsDA7
        1MzJ9Wtw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZtTB-0002wq-8J
        for fio@vger.kernel.org; Thu, 31 Mar 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B60C51BC0148; Thu, 31 Mar 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220331120001.B60C51BC0148@kernel.dk>
Date:   Thu, 31 Mar 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5e644771eb91e91dd0fa32f4b51f90c44853a2b1:

  Merge branch 'status-interval-finished-jobs' of https://github.com/mmkayPL/fio (2022-03-29 06:30:44 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 87933e32e356b15b85c6d9775d5e840994080a4f:

  Rename 'fallthrough' attribute to 'fio_fallthrough' (2022-03-30 17:31:36 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Rename 'fallthrough' attribute to 'fio_fallthrough'

 compiler/compiler.h |  4 ++--
 crc/murmur3.c       |  4 ++--
 engines/http.c      |  2 +-
 hash.h              | 24 ++++++++++++------------
 init.c              |  2 +-
 io_u.c              | 10 +++++-----
 lib/lfsr.c          | 32 ++++++++++++++++----------------
 parse.c             |  4 ++--
 t/lfsr-test.c       |  6 +++---
 9 files changed, 44 insertions(+), 44 deletions(-)

---

Diff of recent changes:

diff --git a/compiler/compiler.h b/compiler/compiler.h
index 3fd0822f..fefadeaa 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -72,9 +72,9 @@
 #endif
 
 #if __has_attribute(__fallthrough__)
-#define fallthrough	 __attribute__((__fallthrough__))
+#define fio_fallthrough	 __attribute__((__fallthrough__))
 #else
-#define fallthrough	do {} while (0)  /* fallthrough */
+#define fio_fallthrough	do {} while (0)  /* fallthrough */
 #endif
 
 #endif
diff --git a/crc/murmur3.c b/crc/murmur3.c
index ba408a9e..08660bc8 100644
--- a/crc/murmur3.c
+++ b/crc/murmur3.c
@@ -30,10 +30,10 @@ static uint32_t murmur3_tail(const uint8_t *data, const int nblocks,
 	switch (len & 3) {
 	case 3:
 		k1 ^= tail[2] << 16;
-		fallthrough;
+		fio_fallthrough;
 	case 2:
 		k1 ^= tail[1] << 8;
-		fallthrough;
+		fio_fallthrough;
 	case 1:
 		k1 ^= tail[0];
 		k1 *= c1;
diff --git a/engines/http.c b/engines/http.c
index 57d4967d..696febe1 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -297,7 +297,7 @@ static int _curl_trace(CURL *handle, curl_infotype type,
 	switch (type) {
 	case CURLINFO_TEXT:
 		fprintf(stderr, "== Info: %s", data);
-		fallthrough;
+		fio_fallthrough;
 	default:
 	case CURLINFO_SSL_DATA_OUT:
 	case CURLINFO_SSL_DATA_IN:
diff --git a/hash.h b/hash.h
index 2c04bc29..f7596a56 100644
--- a/hash.h
+++ b/hash.h
@@ -142,20 +142,20 @@ static inline uint32_t jhash(const void *key, uint32_t length, uint32_t initval)
 	/* Last block: affect all 32 bits of (c) */
 	/* All the case statements fall through */
 	switch (length) {
-	case 12: c += (uint32_t) k[11] << 24;	fallthrough;
-	case 11: c += (uint32_t) k[10] << 16;	fallthrough;
-	case 10: c += (uint32_t) k[9] << 8;	fallthrough;
-	case 9:  c += k[8];			fallthrough;
-	case 8:  b += (uint32_t) k[7] << 24;	fallthrough;
-	case 7:  b += (uint32_t) k[6] << 16;	fallthrough;
-	case 6:  b += (uint32_t) k[5] << 8;	fallthrough;
-	case 5:  b += k[4];			fallthrough;
-	case 4:  a += (uint32_t) k[3] << 24;	fallthrough;
-	case 3:  a += (uint32_t) k[2] << 16;	fallthrough;
-	case 2:  a += (uint32_t) k[1] << 8;	fallthrough;
+	case 12: c += (uint32_t) k[11] << 24;	fio_fallthrough;
+	case 11: c += (uint32_t) k[10] << 16;	fio_fallthrough;
+	case 10: c += (uint32_t) k[9] << 8;	fio_fallthrough;
+	case 9:  c += k[8];			fio_fallthrough;
+	case 8:  b += (uint32_t) k[7] << 24;	fio_fallthrough;
+	case 7:  b += (uint32_t) k[6] << 16;	fio_fallthrough;
+	case 6:  b += (uint32_t) k[5] << 8;	fio_fallthrough;
+	case 5:  b += k[4];			fio_fallthrough;
+	case 4:  a += (uint32_t) k[3] << 24;	fio_fallthrough;
+	case 3:  a += (uint32_t) k[2] << 16;	fio_fallthrough;
+	case 2:  a += (uint32_t) k[1] << 8;	fio_fallthrough;
 	case 1:  a += k[0];
 		 __jhash_final(a, b, c);
-		 fallthrough;
+		 fio_fallthrough;
 	case 0: /* Nothing left to add */
 		break;
 	}
diff --git a/init.c b/init.c
index b7f866e6..6f186051 100644
--- a/init.c
+++ b/init.c
@@ -2990,7 +2990,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			log_err("%s: unrecognized option '%s'\n", argv[0],
 							argv[optind - 1]);
 			show_closest_option(argv[optind - 1]);
-			fallthrough;
+			fio_fallthrough;
 		default:
 			do_exit++;
 			exit_val = 1;
diff --git a/io_u.c b/io_u.c
index 50197a4b..eec378dd 100644
--- a/io_u.c
+++ b/io_u.c
@@ -993,7 +993,7 @@ static void __io_u_mark_map(uint64_t *map, unsigned int nr)
 		break;
 	case 1 ... 4:
 		idx = 1;
-		fallthrough;
+		fio_fallthrough;
 	case 0:
 		break;
 	}
@@ -1035,7 +1035,7 @@ void io_u_mark_depth(struct thread_data *td, unsigned int nr)
 		break;
 	case 2 ... 3:
 		idx = 1;
-		fallthrough;
+		fio_fallthrough;
 	case 1:
 		break;
 	}
@@ -1076,7 +1076,7 @@ static void io_u_mark_lat_nsec(struct thread_data *td, unsigned long long nsec)
 		break;
 	case 2 ... 3:
 		idx = 1;
-		fallthrough;
+		fio_fallthrough;
 	case 0 ... 1:
 		break;
 	}
@@ -1118,7 +1118,7 @@ static void io_u_mark_lat_usec(struct thread_data *td, unsigned long long usec)
 		break;
 	case 2 ... 3:
 		idx = 1;
-		fallthrough;
+		fio_fallthrough;
 	case 0 ... 1:
 		break;
 	}
@@ -1166,7 +1166,7 @@ static void io_u_mark_lat_msec(struct thread_data *td, unsigned long long msec)
 		break;
 	case 2 ... 3:
 		idx = 1;
-		fallthrough;
+		fio_fallthrough;
 	case 0 ... 1:
 		break;
 	}
diff --git a/lib/lfsr.c b/lib/lfsr.c
index a32e850a..e86086c4 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -88,37 +88,37 @@ static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
 	 */
 	switch (spin) {
 		case 15: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case 14: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case 13: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case 12: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case 11: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case 10: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  9: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  8: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  7: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  6: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  5: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  4: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  3: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  2: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  1: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		case  0: __LFSR_NEXT(fl, fl->last_val);
-		fallthrough;
+		fio_fallthrough;
 		default: break;
 	}
 }
diff --git a/parse.c b/parse.c
index e0bee004..656a5025 100644
--- a/parse.c
+++ b/parse.c
@@ -601,7 +601,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 	}
 	case FIO_OPT_STR_VAL_TIME:
 		is_time = 1;
-		fallthrough;
+		fio_fallthrough;
 	case FIO_OPT_ULL:
 	case FIO_OPT_INT:
 	case FIO_OPT_STR_VAL:
@@ -980,7 +980,7 @@ store_option_value:
 	}
 	case FIO_OPT_DEPRECATED:
 		ret = 1;
-		fallthrough;
+		fio_fallthrough;
 	case FIO_OPT_SOFT_DEPRECATED:
 		log_info("Option %s is deprecated\n", o->name);
 		break;
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 279e07f0..4b255e19 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -41,11 +41,11 @@ int main(int argc, char *argv[])
 	switch (argc) {
 		case 5: if (strncmp(argv[4], "verify", 7) == 0)
 				verify = 1;
-			fallthrough;
+			fio_fallthrough;
 		case 4: spin = atoi(argv[3]);
-			fallthrough;
+			fio_fallthrough;
 		case 3: seed = atol(argv[2]);
-			fallthrough;
+			fio_fallthrough;
 		case 2: numbers = strtol(argv[1], NULL, 16);
 				break;
 		default: usage();
