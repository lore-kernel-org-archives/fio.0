Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54338 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932186AbdCINAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Mar 2017 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1clxfq-0001vN-A8
        for fio@vger.kernel.org; Thu, 09 Mar 2017 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170309130002.64F3B2C1C4A@kernel.dk>
Date: Thu,  9 Mar 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8f7630813305a4f4f04a5f9ba20b2a7d486c0cfb:

  io_u: don't add slat samples if we are in ramp time (2017-03-07 10:18:53 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae3a5accfdbe1fbfde6ba4ab583887a7d3d779ac:

  verify: add support for the sha3 variants (2017-03-08 09:13:14 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      crc: add support for sha3 variants
      verify: add support for the sha3 variants

 HOWTO      |  12 +++++
 crc/sha3.c | 173 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crc/sha3.h |  42 +++++++++++++++
 crc/test.c |  81 +++++++++++++++++++++++++++++
 fio.1      |   2 +-
 options.c  |  16 ++++++
 verify.c   | 173 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 verify.h   |  16 ++++++
 8 files changed, 514 insertions(+), 1 deletion(-)
 create mode 100644 crc/sha3.c
 create mode 100644 crc/sha3.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a72d868..15ed425 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2355,6 +2355,18 @@ Verification
 		**sha1**
 			Use optimized sha1 as the checksum function.
 
+		**sha3-224**
+			Use optimized sha3-224 as the checksum function.
+
+		**sha3-256**
+			Use optimized sha3-256 as the checksum function.
+
+		**sha3-384**
+			Use optimized sha3-384 as the checksum function.
+
+		**sha3-512**
+			Use optimized sha3-512 as the checksum function.
+
 		**meta**
 			This option is deprecated, since now meta information is included in
 			generic verification header and meta verification happens by
diff --git a/crc/sha3.c b/crc/sha3.c
new file mode 100644
index 0000000..2685dce
--- /dev/null
+++ b/crc/sha3.c
@@ -0,0 +1,173 @@
+/*
+ * Cryptographic API.
+ *
+ * SHA-3, as specified in
+ * http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
+ *
+ * SHA-3 code by Jeff Garzik <jeff@garzik.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)���
+ * any later version.
+ *
+ */
+#include <string.h>
+#include <inttypes.h>
+
+#include "../os/os.h"
+
+#include "sha3.h"
+
+#define KECCAK_ROUNDS 24
+
+#define ROTL64(x, y) (((x) << (y)) | ((x) >> (64 - (y))))
+
+static const uint64_t keccakf_rndc[24] = {
+	0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808aULL,
+	0x8000000080008000ULL, 0x000000000000808bULL, 0x0000000080000001ULL,
+	0x8000000080008081ULL, 0x8000000000008009ULL, 0x000000000000008aULL,
+	0x0000000000000088ULL, 0x0000000080008009ULL, 0x000000008000000aULL,
+	0x000000008000808bULL, 0x800000000000008bULL, 0x8000000000008089ULL,
+	0x8000000000008003ULL, 0x8000000000008002ULL, 0x8000000000000080ULL,
+	0x000000000000800aULL, 0x800000008000000aULL, 0x8000000080008081ULL,
+	0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
+};
+
+static const int keccakf_rotc[24] = {
+	1,  3,  6,  10, 15, 21, 28, 36, 45, 55, 2,  14,
+	27, 41, 56, 8,  25, 43, 62, 18, 39, 61, 20, 44
+};
+
+static const int keccakf_piln[24] = {
+	10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4,
+	15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1
+};
+
+/* update the state with given number of rounds */
+
+static void keccakf(uint64_t st[25])
+{
+	int i, j, round;
+	uint64_t t, bc[5];
+
+	for (round = 0; round < KECCAK_ROUNDS; round++) {
+
+		/* Theta */
+		for (i = 0; i < 5; i++)
+			bc[i] = st[i] ^ st[i + 5] ^ st[i + 10] ^ st[i + 15]
+				^ st[i + 20];
+
+		for (i = 0; i < 5; i++) {
+			t = bc[(i + 4) % 5] ^ ROTL64(bc[(i + 1) % 5], 1);
+			for (j = 0; j < 25; j += 5)
+				st[j + i] ^= t;
+		}
+
+		/* Rho Pi */
+		t = st[1];
+		for (i = 0; i < 24; i++) {
+			j = keccakf_piln[i];
+			bc[0] = st[j];
+			st[j] = ROTL64(t, keccakf_rotc[i]);
+			t = bc[0];
+		}
+
+		/* Chi */
+		for (j = 0; j < 25; j += 5) {
+			for (i = 0; i < 5; i++)
+				bc[i] = st[j + i];
+			for (i = 0; i < 5; i++)
+				st[j + i] ^= (~bc[(i + 1) % 5]) &
+					     bc[(i + 2) % 5];
+		}
+
+		/* Iota */
+		st[0] ^= keccakf_rndc[round];
+	}
+}
+
+static void fio_sha3_init(struct fio_sha3_ctx *sctx, unsigned int digest_sz)
+{
+	memset(sctx->st, 0, sizeof(sctx->st));
+	sctx->md_len = digest_sz;
+	sctx->rsiz = 200 - 2 * digest_sz;
+	sctx->rsizw = sctx->rsiz / 8;
+	sctx->partial = 0;
+	memset(sctx->buf, 0, sizeof(sctx->buf));
+}
+
+void fio_sha3_224_init(struct fio_sha3_ctx *sctx)
+{
+	fio_sha3_init(sctx, SHA3_224_DIGEST_SIZE);
+}
+
+void fio_sha3_256_init(struct fio_sha3_ctx *sctx)
+{
+	fio_sha3_init(sctx, SHA3_256_DIGEST_SIZE);
+}
+
+void fio_sha3_384_init(struct fio_sha3_ctx *sctx)
+{
+	fio_sha3_init(sctx, SHA3_384_DIGEST_SIZE);
+}
+
+void fio_sha3_512_init(struct fio_sha3_ctx *sctx)
+{
+	fio_sha3_init(sctx, SHA3_512_DIGEST_SIZE);
+}
+
+int fio_sha3_update(struct fio_sha3_ctx *sctx, const uint8_t *data,
+		    unsigned int len)
+{
+	unsigned int done;
+	const uint8_t *src;
+
+	done = 0;
+	src = data;
+
+	if ((sctx->partial + len) > (sctx->rsiz - 1)) {
+		if (sctx->partial) {
+			done = -sctx->partial;
+			memcpy(sctx->buf + sctx->partial, data,
+			       done + sctx->rsiz);
+			src = sctx->buf;
+		}
+
+		do {
+			unsigned int i;
+
+			for (i = 0; i < sctx->rsizw; i++)
+				sctx->st[i] ^= ((uint64_t *) src)[i];
+			keccakf(sctx->st);
+
+			done += sctx->rsiz;
+			src = data + done;
+		} while (done + (sctx->rsiz - 1) < len);
+
+		sctx->partial = 0;
+	}
+	memcpy(sctx->buf + sctx->partial, src, len - done);
+	sctx->partial += (len - done);
+
+	return 0;
+}
+
+void fio_sha3_final(struct fio_sha3_ctx *sctx)
+{
+	unsigned int i, inlen = sctx->partial;
+
+	sctx->buf[inlen++] = 0x06;
+	memset(sctx->buf + inlen, 0, sctx->rsiz - inlen);
+	sctx->buf[sctx->rsiz - 1] |= 0x80;
+
+	for (i = 0; i < sctx->rsizw; i++)
+		sctx->st[i] ^= ((uint64_t *) sctx->buf)[i];
+
+	keccakf(sctx->st);
+
+	for (i = 0; i < sctx->rsizw; i++)
+		sctx->st[i] = cpu_to_le64(sctx->st[i]);
+
+	memcpy(sctx->sha, sctx->st, sctx->md_len);
+}
diff --git a/crc/sha3.h b/crc/sha3.h
new file mode 100644
index 0000000..9f1970a
--- /dev/null
+++ b/crc/sha3.h
@@ -0,0 +1,42 @@
+/*
+ * Common values for SHA-3 algorithms
+ */
+#ifndef __CRYPTO_SHA3_H__
+#define __CRYPTO_SHA3_H__
+
+#include <inttypes.h>
+
+#define SHA3_224_DIGEST_SIZE	(224 / 8)
+#define SHA3_224_BLOCK_SIZE	(200 - 2 * SHA3_224_DIGEST_SIZE)
+
+#define SHA3_256_DIGEST_SIZE	(256 / 8)
+#define SHA3_256_BLOCK_SIZE	(200 - 2 * SHA3_256_DIGEST_SIZE)
+
+#define SHA3_384_DIGEST_SIZE	(384 / 8)
+#define SHA3_384_BLOCK_SIZE	(200 - 2 * SHA3_384_DIGEST_SIZE)
+
+#define SHA3_512_DIGEST_SIZE	(512 / 8)
+#define SHA3_512_BLOCK_SIZE	(200 - 2 * SHA3_512_DIGEST_SIZE)
+
+struct fio_sha3_ctx {
+	uint64_t	st[25];
+	unsigned int	md_len;
+	unsigned int	rsiz;
+	unsigned int	rsizw;
+
+	unsigned int	partial;
+	uint8_t		buf[SHA3_224_BLOCK_SIZE];
+
+	uint8_t		*sha;
+};
+
+void fio_sha3_224_init(struct fio_sha3_ctx *sctx);
+void fio_sha3_256_init(struct fio_sha3_ctx *sctx);
+void fio_sha3_384_init(struct fio_sha3_ctx *sctx);
+void fio_sha3_512_init(struct fio_sha3_ctx *sctx);
+
+int fio_sha3_update(struct fio_sha3_ctx *sctx, const uint8_t *data,
+		    unsigned int len);
+void fio_sha3_final(struct fio_sha3_ctx *sctx);
+
+#endif
diff --git a/crc/test.c b/crc/test.c
index 78f19ac..368229e 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -16,6 +16,7 @@
 #include "../crc/sha1.h"
 #include "../crc/sha256.h"
 #include "../crc/sha512.h"
+#include "../crc/sha3.h"
 #include "../crc/xxhash.h"
 #include "../crc/murmur3.h"
 #include "../crc/fnv.h"
@@ -47,6 +48,10 @@ enum {
 	T_MURMUR3	= 1U << 10,
 	T_JHASH		= 1U << 11,
 	T_FNV		= 1U << 12,
+	T_SHA3_224	= 1U << 13,
+	T_SHA3_256	= 1U << 14,
+	T_SHA3_384	= 1U << 15,
+	T_SHA3_512	= 1U << 16,
 };
 
 static void t_md5(struct test_type *t, void *buf, size_t size)
@@ -143,6 +148,62 @@ static void t_sha512(struct test_type *t, void *buf, size_t size)
 		fio_sha512_update(&ctx, buf, size);
 }
 
+static void t_sha3_224(struct test_type *t, void *buf, size_t size)
+{
+	uint8_t sha[SHA3_224_DIGEST_SIZE];
+	struct fio_sha3_ctx ctx = { .sha = sha };
+	int i;
+
+	fio_sha3_224_init(&ctx);
+
+	for (i = 0; i < NR_CHUNKS; i++) {
+		fio_sha3_update(&ctx, buf, size);
+		fio_sha3_final(&ctx);
+	}
+}
+
+static void t_sha3_256(struct test_type *t, void *buf, size_t size)
+{
+	uint8_t sha[SHA3_256_DIGEST_SIZE];
+	struct fio_sha3_ctx ctx = { .sha = sha };
+	int i;
+
+	fio_sha3_256_init(&ctx);
+
+	for (i = 0; i < NR_CHUNKS; i++) {
+		fio_sha3_update(&ctx, buf, size);
+		fio_sha3_final(&ctx);
+	}
+}
+
+static void t_sha3_384(struct test_type *t, void *buf, size_t size)
+{
+	uint8_t sha[SHA3_384_DIGEST_SIZE];
+	struct fio_sha3_ctx ctx = { .sha = sha };
+	int i;
+
+	fio_sha3_384_init(&ctx);
+
+	for (i = 0; i < NR_CHUNKS; i++) {
+		fio_sha3_update(&ctx, buf, size);
+		fio_sha3_final(&ctx);
+	}
+}
+
+static void t_sha3_512(struct test_type *t, void *buf, size_t size)
+{
+	uint8_t sha[SHA3_512_DIGEST_SIZE];
+	struct fio_sha3_ctx ctx = { .sha = sha };
+	int i;
+
+	fio_sha3_512_init(&ctx);
+
+	for (i = 0; i < NR_CHUNKS; i++) {
+		fio_sha3_update(&ctx, buf, size);
+		fio_sha3_final(&ctx);
+	}
+}
+
 static void t_murmur3(struct test_type *t, void *buf, size_t size)
 {
 	int i;
@@ -247,6 +308,26 @@ static struct test_type t[] = {
 		.fn = t_fnv,
 	},
 	{
+		.name = "sha3-224",
+		.mask = T_SHA3_224,
+		.fn = t_sha3_224,
+	},
+	{
+		.name = "sha3-256",
+		.mask = T_SHA3_256,
+		.fn = t_sha3_256,
+	},
+	{
+		.name = "sha3-384",
+		.mask = T_SHA3_384,
+		.fn = t_sha3_384,
+	},
+	{
+		.name = "sha3-512",
+		.mask = T_SHA3_512,
+		.fn = t_sha3_512,
+	},
+	{
 		.name = NULL,
 	},
 };
diff --git a/fio.1 b/fio.1
index 56f2d11..cc68dee 100644
--- a/fio.1
+++ b/fio.1
@@ -1414,7 +1414,7 @@ option.  The allowed values are:
 .RS
 .RS
 .TP
-.B md5 crc16 crc32 crc32c crc32c-intel crc64 crc7 sha256 sha512 sha1 xxhash
+.B md5 crc16 crc32 crc32c crc32c-intel crc64 crc7 sha256 sha512 sha1 sha3-224 sha3-256 sha3-384 sha3-512 xxhash
 Store appropriate checksum in the header of each block. crc32c-intel is
 hardware accelerated SSE4.2 driven, falls back to regular crc32c if
 not supported by the system.
diff --git a/options.c b/options.c
index a543e5a..dcf0eea 100644
--- a/options.c
+++ b/options.c
@@ -2674,6 +2674,22 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = VERIFY_SHA512,
 			    .help = "Use sha512 checksums for verification",
 			  },
+			  { .ival = "sha3-224",
+			    .oval = VERIFY_SHA3_224,
+			    .help = "Use sha3-224 checksums for verification",
+			  },
+			  { .ival = "sha3-256",
+			    .oval = VERIFY_SHA3_256,
+			    .help = "Use sha3-256 checksums for verification",
+			  },
+			  { .ival = "sha3-384",
+			    .oval = VERIFY_SHA3_384,
+			    .help = "Use sha3-384 checksums for verification",
+			  },
+			  { .ival = "sha3-512",
+			    .oval = VERIFY_SHA3_512,
+			    .help = "Use sha3-512 checksums for verification",
+			  },
 			  { .ival = "xxhash",
 			    .oval = VERIFY_XXHASH,
 			    .help = "Use xxhash checksums for verification",
diff --git a/verify.c b/verify.c
index 5c7e43d..f567ec1 100644
--- a/verify.c
+++ b/verify.c
@@ -25,6 +25,7 @@
 #include "crc/sha512.h"
 #include "crc/sha1.h"
 #include "crc/xxhash.h"
+#include "crc/sha3.h"
 
 static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 struct verify_header *hdr, unsigned int header_num,
@@ -172,6 +173,18 @@ static inline unsigned int __hdr_size(int verify_type)
 	case VERIFY_SHA512:
 		len = sizeof(struct vhdr_sha512);
 		break;
+	case VERIFY_SHA3_224:
+		len = sizeof(struct vhdr_sha3_224);
+		break;
+	case VERIFY_SHA3_256:
+		len = sizeof(struct vhdr_sha3_256);
+		break;
+	case VERIFY_SHA3_384:
+		len = sizeof(struct vhdr_sha3_384);
+		break;
+	case VERIFY_SHA3_512:
+		len = sizeof(struct vhdr_sha3_512);
+		break;
 	case VERIFY_XXHASH:
 		len = sizeof(struct vhdr_xxhash);
 		break;
@@ -431,6 +444,84 @@ static int verify_io_u_xxhash(struct verify_header *hdr, struct vcont *vc)
 	return EILSEQ;
 }
 
+static int verify_io_u_sha3(struct verify_header *hdr, struct vcont *vc,
+			    struct fio_sha3_ctx *sha3_ctx, uint8_t *sha,
+			    unsigned int sha_size, const char *name)
+{
+	void *p = io_u_verify_off(hdr, vc);
+
+	dprint(FD_VERIFY, "%s verify io_u %p, len %u\n", name, vc->io_u, hdr->len);
+
+	fio_sha3_update(sha3_ctx, p, hdr->len - hdr_size(vc->td, hdr));
+	fio_sha3_final(sha3_ctx);
+
+	if (!memcmp(sha, sha3_ctx->sha, sha_size))
+		return 0;
+
+	vc->name = name;
+	vc->good_crc = sha;
+	vc->bad_crc = sha3_ctx->sha;
+	vc->crc_len = sha_size;
+	log_verify_failure(hdr, vc);
+	return EILSEQ;
+}
+
+static int verify_io_u_sha3_224(struct verify_header *hdr, struct vcont *vc)
+{
+	struct vhdr_sha3_224 *vh = hdr_priv(hdr);
+	uint8_t sha[SHA3_224_DIGEST_SIZE];
+	struct fio_sha3_ctx sha3_ctx = {
+		.sha = sha,
+	};
+
+	fio_sha3_224_init(&sha3_ctx);
+
+	return verify_io_u_sha3(hdr, vc, &sha3_ctx, vh->sha,
+				SHA3_224_DIGEST_SIZE, "sha3-224");
+}
+
+static int verify_io_u_sha3_256(struct verify_header *hdr, struct vcont *vc)
+{
+	struct vhdr_sha3_256 *vh = hdr_priv(hdr);
+	uint8_t sha[SHA3_256_DIGEST_SIZE];
+	struct fio_sha3_ctx sha3_ctx = {
+		.sha = sha,
+	};
+
+	fio_sha3_256_init(&sha3_ctx);
+
+	return verify_io_u_sha3(hdr, vc, &sha3_ctx, vh->sha,
+				SHA3_256_DIGEST_SIZE, "sha3-256");
+}
+
+static int verify_io_u_sha3_384(struct verify_header *hdr, struct vcont *vc)
+{
+	struct vhdr_sha3_384 *vh = hdr_priv(hdr);
+	uint8_t sha[SHA3_384_DIGEST_SIZE];
+	struct fio_sha3_ctx sha3_ctx = {
+		.sha = sha,
+	};
+
+	fio_sha3_384_init(&sha3_ctx);
+
+	return verify_io_u_sha3(hdr, vc, &sha3_ctx, vh->sha,
+				SHA3_384_DIGEST_SIZE, "sha3-384");
+}
+
+static int verify_io_u_sha3_512(struct verify_header *hdr, struct vcont *vc)
+{
+	struct vhdr_sha3_512 *vh = hdr_priv(hdr);
+	uint8_t sha[SHA3_512_DIGEST_SIZE];
+	struct fio_sha3_ctx sha3_ctx = {
+		.sha = sha,
+	};
+
+	fio_sha3_512_init(&sha3_ctx);
+
+	return verify_io_u_sha3(hdr, vc, &sha3_ctx, vh->sha,
+				SHA3_512_DIGEST_SIZE, "sha3-512");
+}
+
 static int verify_io_u_sha512(struct verify_header *hdr, struct vcont *vc)
 {
 	void *p = io_u_verify_off(hdr, vc);
@@ -882,6 +973,18 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 		case VERIFY_SHA512:
 			ret = verify_io_u_sha512(hdr, &vc);
 			break;
+		case VERIFY_SHA3_224:
+			ret = verify_io_u_sha3_224(hdr, &vc);
+			break;
+		case VERIFY_SHA3_256:
+			ret = verify_io_u_sha3_256(hdr, &vc);
+			break;
+		case VERIFY_SHA3_384:
+			ret = verify_io_u_sha3_384(hdr, &vc);
+			break;
+		case VERIFY_SHA3_512:
+			ret = verify_io_u_sha3_512(hdr, &vc);
+			break;
 		case VERIFY_XXHASH:
 			ret = verify_io_u_xxhash(hdr, &vc);
 			break;
@@ -919,6 +1022,56 @@ static void fill_xxhash(struct verify_header *hdr, void *p, unsigned int len)
 	vh->hash = XXH32_digest(state);
 }
 
+static void fill_sha3(struct fio_sha3_ctx *sha3_ctx, void *p, unsigned int len)
+{
+	fio_sha3_update(sha3_ctx, p, len);
+	fio_sha3_final(sha3_ctx);
+}
+
+static void fill_sha3_224(struct verify_header *hdr, void *p, unsigned int len)
+{
+	struct vhdr_sha3_224 *vh = hdr_priv(hdr);
+	struct fio_sha3_ctx sha3_ctx = {
+		.sha = vh->sha,
+	};
+
+	fio_sha3_224_init(&sha3_ctx);
+	fill_sha3(&sha3_ctx, p, len);
+}
+
+static void fill_sha3_256(struct verify_header *hdr, void *p, unsigned int len)
+{
+	struct vhdr_sha3_256 *vh = hdr_priv(hdr);
+	struct fio_sha3_ctx sha3_ctx = {
+		.sha = vh->sha,
+	};
+
+	fio_sha3_256_init(&sha3_ctx);
+	fill_sha3(&sha3_ctx, p, len);
+}
+
+static void fill_sha3_384(struct verify_header *hdr, void *p, unsigned int len)
+{
+	struct vhdr_sha3_384 *vh = hdr_priv(hdr);
+	struct fio_sha3_ctx sha3_ctx = {
+		.sha = vh->sha,
+	};
+
+	fio_sha3_384_init(&sha3_ctx);
+	fill_sha3(&sha3_ctx, p, len);
+}
+
+static void fill_sha3_512(struct verify_header *hdr, void *p, unsigned int len)
+{
+	struct vhdr_sha3_512 *vh = hdr_priv(hdr);
+	struct fio_sha3_ctx sha3_ctx = {
+		.sha = vh->sha,
+	};
+
+	fio_sha3_512_init(&sha3_ctx);
+	fill_sha3(&sha3_ctx, p, len);
+}
+
 static void fill_sha512(struct verify_header *hdr, void *p, unsigned int len)
 {
 	struct vhdr_sha512 *vh = hdr_priv(hdr);
@@ -1085,6 +1238,26 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 						io_u, hdr->len);
 		fill_sha512(hdr, data, data_len);
 		break;
+	case VERIFY_SHA3_224:
+		dprint(FD_VERIFY, "fill sha3-224 io_u %p, len %u\n",
+						io_u, hdr->len);
+		fill_sha3_224(hdr, data, data_len);
+		break;
+	case VERIFY_SHA3_256:
+		dprint(FD_VERIFY, "fill sha3-256 io_u %p, len %u\n",
+						io_u, hdr->len);
+		fill_sha3_256(hdr, data, data_len);
+		break;
+	case VERIFY_SHA3_384:
+		dprint(FD_VERIFY, "fill sha3-384 io_u %p, len %u\n",
+						io_u, hdr->len);
+		fill_sha3_384(hdr, data, data_len);
+		break;
+	case VERIFY_SHA3_512:
+		dprint(FD_VERIFY, "fill sha3-512 io_u %p, len %u\n",
+						io_u, hdr->len);
+		fill_sha3_512(hdr, data, data_len);
+		break;
 	case VERIFY_XXHASH:
 		dprint(FD_VERIFY, "fill xxhash io_u %p, len %u\n",
 						io_u, hdr->len);
diff --git a/verify.h b/verify.h
index deb161e..5aae2e7 100644
--- a/verify.h
+++ b/verify.h
@@ -20,6 +20,10 @@ enum {
 	VERIFY_CRC7,			/* crc7 sum data blocks */
 	VERIFY_SHA256,			/* sha256 sum data blocks */
 	VERIFY_SHA512,			/* sha512 sum data blocks */
+	VERIFY_SHA3_224,		/* sha3-224 sum data blocks */
+	VERIFY_SHA3_256,		/* sha3-256 sum data blocks */
+	VERIFY_SHA3_384,		/* sha3-384 sum data blocks */
+	VERIFY_SHA3_512,		/* sha3-512 sum data blocks */
 	VERIFY_XXHASH,			/* xxhash sum data blocks */
 	VERIFY_SHA1,			/* sha1 sum data blocks */
 	VERIFY_PATTERN,			/* verify specific patterns */
@@ -48,6 +52,18 @@ struct verify_header {
 struct vhdr_md5 {
 	uint32_t md5_digest[4];
 };
+struct vhdr_sha3_224 {
+	uint8_t sha[224 / 8];
+};
+struct vhdr_sha3_256 {
+	uint8_t sha[256 / 8];
+};
+struct vhdr_sha3_384 {
+	uint8_t sha[384 / 8];
+};
+struct vhdr_sha3_512 {
+	uint8_t sha[512 / 8];
+};
 struct vhdr_sha512 {
 	uint8_t sha512[128];
 };
