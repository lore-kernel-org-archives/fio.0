Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgH2MAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 29 Aug 2020 08:00:07 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28913C061236
        for <fio@vger.kernel.org>; Sat, 29 Aug 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBzWe-00044i-Aa
        for fio@vger.kernel.org; Sat, 29 Aug 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200829120001.B1FF21BC0042@kernel.dk>
Date: Sat, 29 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0ed7d55e6610020c4642ddb246f6ce1ab697052d:

  zbd: don't read past the WP on a read only workload with verify (2020-08-27 12:27:36 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to db83b0abd16bbd6b8f589a993e6f70d9812be6e3:

  Use fallthrough attribute (2020-08-28 09:14:38 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'master' of https://github.com/donny372/fio into master
      Use fallthrough attribute

donny372 (1):
      Avoid multiple instance read iolog from stdin.

 compiler/compiler.h | 10 ++++++++++
 crc/murmur3.c       |  5 +++--
 hash.h              | 24 +++++++++++++-----------
 init.c              | 24 ++++++++++++++----------
 io_u.c              |  5 +++++
 lib/lfsr.c          | 32 ++++++++++++++++----------------
 parse.c             |  4 ++--
 t/lfsr-test.c       |  7 ++++---
 8 files changed, 67 insertions(+), 44 deletions(-)

---

Diff of recent changes:

diff --git a/compiler/compiler.h b/compiler/compiler.h
index 8a784b92..8988236c 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -66,4 +66,14 @@
 #define FIELD_SIZE(s, f) (sizeof(((__typeof__(s))0)->f))
 #endif
 
+#ifndef __has_attribute
+#define __GCC4_has_attribute___fallthrough__	0
+#endif
+
+#if __has_attribute(__fallthrough__)
+#define fallthrough	 __attribute__((__fallthrough__))
+#else
+#define fallthrough	do {} while (0)  /* fallthrough */
+#endif
+
 #endif
diff --git a/crc/murmur3.c b/crc/murmur3.c
index f4f2f2c6..ba408a9e 100644
--- a/crc/murmur3.c
+++ b/crc/murmur3.c
@@ -1,4 +1,5 @@
 #include "murmur3.h"
+#include "../compiler/compiler.h"
 
 static inline uint32_t rotl32(uint32_t x, int8_t r)
 {
@@ -29,10 +30,10 @@ static uint32_t murmur3_tail(const uint8_t *data, const int nblocks,
 	switch (len & 3) {
 	case 3:
 		k1 ^= tail[2] << 16;
-		/* fall through */
+		fallthrough;
 	case 2:
 		k1 ^= tail[1] << 8;
-		/* fall through */
+		fallthrough;
 	case 1:
 		k1 ^= tail[0];
 		k1 *= c1;
diff --git a/hash.h b/hash.h
index 66dd3d69..2c04bc29 100644
--- a/hash.h
+++ b/hash.h
@@ -3,6 +3,7 @@
 
 #include <inttypes.h>
 #include "arch/arch.h"
+#include "compiler/compiler.h"
 
 /* Fast hashing routine for a long.
    (C) 2002 William Lee Irwin III, IBM */
@@ -141,19 +142,20 @@ static inline uint32_t jhash(const void *key, uint32_t length, uint32_t initval)
 	/* Last block: affect all 32 bits of (c) */
 	/* All the case statements fall through */
 	switch (length) {
-	case 12: c += (uint32_t) k[11] << 24;	/* fall through */
-	case 11: c += (uint32_t) k[10] << 16;	/* fall through */
-	case 10: c += (uint32_t) k[9] << 8;	/* fall through */
-	case 9:  c += k[8];			/* fall through */
-	case 8:  b += (uint32_t) k[7] << 24;	/* fall through */
-	case 7:  b += (uint32_t) k[6] << 16;	/* fall through */
-	case 6:  b += (uint32_t) k[5] << 8;	/* fall through */
-	case 5:  b += k[4];			/* fall through */
-	case 4:  a += (uint32_t) k[3] << 24;	/* fall through */
-	case 3:  a += (uint32_t) k[2] << 16;	/* fall through */
-	case 2:  a += (uint32_t) k[1] << 8;	/* fall through */
+	case 12: c += (uint32_t) k[11] << 24;	fallthrough;
+	case 11: c += (uint32_t) k[10] << 16;	fallthrough;
+	case 10: c += (uint32_t) k[9] << 8;	fallthrough;
+	case 9:  c += k[8];			fallthrough;
+	case 8:  b += (uint32_t) k[7] << 24;	fallthrough;
+	case 7:  b += (uint32_t) k[6] << 16;	fallthrough;
+	case 6:  b += (uint32_t) k[5] << 8;	fallthrough;
+	case 5:  b += k[4];			fallthrough;
+	case 4:  a += (uint32_t) k[3] << 24;	fallthrough;
+	case 3:  a += (uint32_t) k[2] << 16;	fallthrough;
+	case 2:  a += (uint32_t) k[1] << 8;	fallthrough;
 	case 1:  a += k[0];
 		 __jhash_final(a, b, c);
+		 fallthrough;
 	case 0: /* Nothing left to add */
 		break;
 	}
diff --git a/init.c b/init.c
index 491b46e6..3cd0238b 100644
--- a/init.c
+++ b/init.c
@@ -1835,6 +1835,7 @@ static int __parse_jobs_ini(struct thread_data *td,
 		int nested, char *name, char ***popts, int *aopts, int *nopts)
 {
 	bool global = false;
+	bool stdin_occupied = false;
 	char *string;
 	FILE *f;
 	char *p;
@@ -1851,9 +1852,10 @@ static int __parse_jobs_ini(struct thread_data *td,
 	if (is_buf)
 		f = NULL;
 	else {
-		if (!strcmp(file, "-"))
+		if (!strcmp(file, "-")) {
 			f = stdin;
-		else
+			stdin_occupied = true;
+		} else
 			f = fopen(file, "r");
 
 		if (!f) {
@@ -2056,15 +2058,17 @@ static int __parse_jobs_ini(struct thread_data *td,
 
 		ret = fio_options_parse(td, opts, num_opts);
 
-		if (!ret) {
-			if (!strcmp(file, "-") && td->o.read_iolog_file != NULL) {
-				char *fname = get_name_by_idx(td->o.read_iolog_file,
-							      td->subjob_number);
-				if (!strcmp(fname, "-")) {
-					log_err("fio: we can't read both iolog "
-						"and job file from stdin.\n");
+		if (!ret && td->o.read_iolog_file != NULL) {
+			char *fname = get_name_by_idx(td->o.read_iolog_file,
+						      td->subjob_number);
+			if (!strcmp(fname, "-")) {
+				if (stdin_occupied) {
+					log_err("fio: only one user (read_iolog_file/job "
+						"file) of stdin is permitted at once but "
+						"more than one was found.\n");
 					ret = 1;
 				}
+				stdin_occupied = true;
 			}
 		}
 		if (!ret) {
@@ -2891,7 +2895,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			log_err("%s: unrecognized option '%s'\n", argv[0],
 							argv[optind - 1]);
 			show_closest_option(argv[optind - 1]);
-			/* fall through */
+			fallthrough;
 		default:
 			do_exit++;
 			exit_val = 1;
diff --git a/io_u.c b/io_u.c
index 2ef5acec..155d0a32 100644
--- a/io_u.c
+++ b/io_u.c
@@ -993,6 +993,7 @@ static void __io_u_mark_map(uint64_t *map, unsigned int nr)
 		break;
 	case 1 ... 4:
 		idx = 1;
+		fallthrough;
 	case 0:
 		break;
 	}
@@ -1034,6 +1035,7 @@ void io_u_mark_depth(struct thread_data *td, unsigned int nr)
 		break;
 	case 2 ... 3:
 		idx = 1;
+		fallthrough;
 	case 1:
 		break;
 	}
@@ -1074,6 +1076,7 @@ static void io_u_mark_lat_nsec(struct thread_data *td, unsigned long long nsec)
 		break;
 	case 2 ... 3:
 		idx = 1;
+		fallthrough;
 	case 0 ... 1:
 		break;
 	}
@@ -1115,6 +1118,7 @@ static void io_u_mark_lat_usec(struct thread_data *td, unsigned long long usec)
 		break;
 	case 2 ... 3:
 		idx = 1;
+		fallthrough;
 	case 0 ... 1:
 		break;
 	}
@@ -1162,6 +1166,7 @@ static void io_u_mark_lat_msec(struct thread_data *td, unsigned long long msec)
 		break;
 	case 2 ... 3:
 		idx = 1;
+		fallthrough;
 	case 0 ... 1:
 		break;
 	}
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 1ef6ebbf..a32e850a 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -88,37 +88,37 @@ static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
 	 */
 	switch (spin) {
 		case 15: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case 14: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case 13: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case 12: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case 11: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case 10: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  9: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  8: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  7: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  6: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  5: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  4: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  3: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  2: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  1: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		case  0: __LFSR_NEXT(fl, fl->last_val);
-		/* fall through */
+		fallthrough;
 		default: break;
 	}
 }
diff --git a/parse.c b/parse.c
index 04b2e198..f4cefcf6 100644
--- a/parse.c
+++ b/parse.c
@@ -596,7 +596,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 	}
 	case FIO_OPT_STR_VAL_TIME:
 		is_time = 1;
-		/* fall through */
+		fallthrough;
 	case FIO_OPT_ULL:
 	case FIO_OPT_INT:
 	case FIO_OPT_STR_VAL: {
@@ -941,7 +941,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 	}
 	case FIO_OPT_DEPRECATED:
 		ret = 1;
-		/* fall through */
+		fallthrough;
 	case FIO_OPT_SOFT_DEPRECATED:
 		log_info("Option %s is deprecated\n", o->name);
 		break;
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index ea8c8ddb..279e07f0 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -6,6 +6,7 @@
 #include "../lib/lfsr.h"
 #include "../gettime.h"
 #include "../fio_time.h"
+#include "../compiler/compiler.h"
 
 static void usage(void)
 {
@@ -40,11 +41,11 @@ int main(int argc, char *argv[])
 	switch (argc) {
 		case 5: if (strncmp(argv[4], "verify", 7) == 0)
 				verify = 1;
-			/* fall through */
+			fallthrough;
 		case 4: spin = atoi(argv[3]);
-			/* fall through */
+			fallthrough;
 		case 3: seed = atol(argv[2]);
-			/* fall through */
+			fallthrough;
 		case 2: numbers = strtol(argv[1], NULL, 16);
 				break;
 		default: usage();

