Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56956 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbfBLNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Feb 2019 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gtXfR-0004QI-8k
        for fio@vger.kernel.org; Tue, 12 Feb 2019 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190212130002.51F552C00B5@kernel.dk>
Date: Tue, 12 Feb 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6616949337d8409ec0999f2b3ad240ea2d037a82:

  io_uring: sync header with the kernel (2019-02-10 09:36:48 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 71144e676e710b37966f447ccd8d944813dfa6d1:

  configure: enable -Wimplicit-fallthrough if we have it (2019-02-11 13:30:52 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Document switch fall-through cases
      configure: enable -Wimplicit-fallthrough if we have it

 configure      | 17 +++++++++++++++++
 crc/murmur3.c  |  2 ++
 engines/http.c |  4 +++-
 hash.h         | 22 +++++++++++-----------
 init.c         |  1 +
 lib/lfsr.c     | 16 ++++++++++++++++
 t/lfsr-test.c  |  5 ++++-
 7 files changed, 54 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index c4fffd99..6e549cdc 100755
--- a/configure
+++ b/configure
@@ -2312,6 +2312,20 @@ if compile_prog "" "" "__kernel_rwf_t"; then
 fi
 print_config "__kernel_rwf_t" "$__kernel_rwf_t"
 
+##########################################
+# check if gcc has -Wimplicit-fallthrough
+fallthrough="no"
+cat > $TMPC << EOF
+int main(int argc, char **argv)
+{
+  return 0;
+}
+EOF
+if compile_prog "-Wimplicit-fallthrough" "" "-Wimplicit-fallthrough"; then
+  fallthrough="yes"
+fi
+print_config "-Wimplicit-fallthrough" "$fallthrough"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2583,6 +2597,9 @@ fi
 if test "$__kernel_rwf_t" = "yes"; then
   output_sym "CONFIG_HAVE_KERNEL_RWF_T"
 fi
+if test "$fallthrough" = "yes"; then
+  CFLAGS="$CFLAGS -Wimplicit-fallthrough"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/crc/murmur3.c b/crc/murmur3.c
index e316f592..f4f2f2c6 100644
--- a/crc/murmur3.c
+++ b/crc/murmur3.c
@@ -29,8 +29,10 @@ static uint32_t murmur3_tail(const uint8_t *data, const int nblocks,
 	switch (len & 3) {
 	case 3:
 		k1 ^= tail[2] << 16;
+		/* fall through */
 	case 2:
 		k1 ^= tail[1] << 8;
+		/* fall through */
 	case 1:
 		k1 ^= tail[0];
 		k1 *= c1;
diff --git a/engines/http.c b/engines/http.c
index d81e4288..a35c0332 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -296,9 +296,11 @@ static int _curl_trace(CURL *handle, curl_infotype type,
 
 	switch (type) {
 	case CURLINFO_TEXT:
-	fprintf(stderr, "== Info: %s", data);
+		fprintf(stderr, "== Info: %s", data);
+		/* fall through */
 	default:
 	case CURLINFO_SSL_DATA_OUT:
+		/* fall through */
 	case CURLINFO_SSL_DATA_IN:
 		return 0;
 
diff --git a/hash.h b/hash.h
index d227b938..66dd3d69 100644
--- a/hash.h
+++ b/hash.h
@@ -141,17 +141,17 @@ static inline uint32_t jhash(const void *key, uint32_t length, uint32_t initval)
 	/* Last block: affect all 32 bits of (c) */
 	/* All the case statements fall through */
 	switch (length) {
-	case 12: c += (uint32_t) k[11] << 24;
-	case 11: c += (uint32_t) k[10] << 16;
-	case 10: c += (uint32_t) k[9] << 8;
-	case 9:  c += k[8];
-	case 8:  b += (uint32_t) k[7] << 24;
-	case 7:  b += (uint32_t) k[6] << 16;
-	case 6:  b += (uint32_t) k[5] << 8;
-	case 5:  b += k[4];
-	case 4:  a += (uint32_t) k[3] << 24;
-	case 3:  a += (uint32_t) k[2] << 16;
-	case 2:  a += (uint32_t) k[1] << 8;
+	case 12: c += (uint32_t) k[11] << 24;	/* fall through */
+	case 11: c += (uint32_t) k[10] << 16;	/* fall through */
+	case 10: c += (uint32_t) k[9] << 8;	/* fall through */
+	case 9:  c += k[8];			/* fall through */
+	case 8:  b += (uint32_t) k[7] << 24;	/* fall through */
+	case 7:  b += (uint32_t) k[6] << 16;	/* fall through */
+	case 6:  b += (uint32_t) k[5] << 8;	/* fall through */
+	case 5:  b += k[4];			/* fall through */
+	case 4:  a += (uint32_t) k[3] << 24;	/* fall through */
+	case 3:  a += (uint32_t) k[2] << 16;	/* fall through */
+	case 2:  a += (uint32_t) k[1] << 8;	/* fall through */
 	case 1:  a += k[0];
 		 __jhash_final(a, b, c);
 	case 0: /* Nothing left to add */
diff --git a/init.c b/init.c
index a2b70c4a..e6378715 100644
--- a/init.c
+++ b/init.c
@@ -2907,6 +2907,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			log_err("%s: unrecognized option '%s'\n", argv[0],
 							argv[optind - 1]);
 			show_closest_option(argv[optind - 1]);
+			/* fall through */
 		default:
 			do_exit++;
 			exit_val = 1;
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 49e34a8c..32fbec56 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -88,21 +88,37 @@ static inline void __lfsr_next(struct fio_lfsr *fl, unsigned int spin)
 	 */
 	switch (spin) {
 		case 15: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case 14: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case 13: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case 12: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case 11: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case 10: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  9: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  8: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  7: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  6: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  5: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  4: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  3: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  2: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  1: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		case  0: __LFSR_NEXT(fl, fl->last_val);
+		/* fall through */
 		default: break;
 	}
 }
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index a01f2cfc..ea8c8ddb 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -39,9 +39,12 @@ int main(int argc, char *argv[])
 	/* Read arguments */
 	switch (argc) {
 		case 5: if (strncmp(argv[4], "verify", 7) == 0)
-					verify = 1;
+				verify = 1;
+			/* fall through */
 		case 4: spin = atoi(argv[3]);
+			/* fall through */
 		case 3: seed = atol(argv[2]);
+			/* fall through */
 		case 2: numbers = strtol(argv[1], NULL, 16);
 				break;
 		default: usage();

