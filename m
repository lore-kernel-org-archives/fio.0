Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58718 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbbFJMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Jun 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z2efs-0005N9-TJ
	for fio@vger.kernel.org; Wed, 10 Jun 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150610120001.E99502C0101@kernel.dk>
Date: Wed, 10 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5924538164650c6c0dc0e866d6ed15eb199ed020:

  verify: add raw pattern verify (2015-06-08 20:43:43 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f491a907983c1022ec3c4d3a76d969c286fe441b:

  Dropped commented out part of line. (2015-06-09 14:14:20 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      verify: fix dumping of received/expected buffers on failure
      verify: cleanup code for verify pattern without headers
      options: use fio_option_is_set() to detect verify setting

Sam Zaydel (3):
      int may be too small for a size_t on some systems.
      Merge branch 'master' of github.com:axboe/fio into fixtype
      Dropped commented out part of line.

 backend.c |  3 ++-
 options.c |  2 +-
 verify.c  | 91 +++++++++++++++++++++++++++++++++++++++++++--------------------
 3 files changed, 66 insertions(+), 30 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 975317f..6989407 100644
--- a/backend.c
+++ b/backend.c
@@ -1242,7 +1242,8 @@ static int keep_running(struct thread_data *td)
 
 static int exec_string(struct thread_options *o, const char *string, const char *mode)
 {
-	int ret, newlen = strlen(string) + strlen(o->name) + strlen(mode) + 9 + 1;
+	size_t newlen = strlen(string) + strlen(o->name) + strlen(mode) + 9 + 1;
+	int ret;
 	char *str;
 
 	str = malloc(newlen);
diff --git a/options.c b/options.c
index cd37141..e3b9338 100644
--- a/options.c
+++ b/options.c
@@ -1064,7 +1064,7 @@ static int str_verify_pattern_cb(void *data, const char *input)
 	/*
 	 * VERIFY_META could already be set
 	 */
-	if (!ret && td->o.verify == VERIFY_NONE)
+	if (!ret && !fio_option_is_set(&td->o, verify))
 		td->o.verify = VERIFY_PATTERN;
 
 	return ret;
diff --git a/verify.c b/verify.c
index 806f41e..f833e85 100644
--- a/verify.c
+++ b/verify.c
@@ -28,6 +28,10 @@
 static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 struct verify_header *hdr, unsigned int header_num,
 			 unsigned int header_len);
+static void fill_hdr(struct verify_header *hdr, int verify_type, uint32_t len,
+		     uint64_t rand_seed);
+static void __fill_hdr(struct verify_header *hdr, int verify_type, uint32_t len,
+		       uint64_t rand_seed);
 
 void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len)
 {
@@ -133,6 +137,7 @@ static inline unsigned int __hdr_size(int verify_type)
 	switch (verify_type) {
 	case VERIFY_NONE:
 	case VERIFY_NULL:
+	case VERIFY_PATTERN:
 		len = 0;
 		break;
 	case VERIFY_MD5:
@@ -167,10 +172,8 @@ static inline unsigned int __hdr_size(int verify_type)
 	case VERIFY_SHA1:
 		len = sizeof(struct vhdr_sha1);
 		break;
-	case VERIFY_PATTERN:
 	case VERIFY_PATTERN_NO_HDR:
-		len = 0;
-		break;
+		return 0;
 	default:
 		log_err("fio: unknown verify header!\n");
 		assert(0);
@@ -179,8 +182,12 @@ static inline unsigned int __hdr_size(int verify_type)
 	return len + sizeof(struct verify_header);
 }
 
-static inline unsigned int hdr_size(struct verify_header *hdr)
+static inline unsigned int hdr_size(struct thread_data *td,
+				    struct verify_header *hdr)
 {
+	if (td->o.verify == VERIFY_PATTERN_NO_HDR)
+		return 0;
+
 	return __hdr_size(hdr->verify_type);
 }
 
@@ -266,7 +273,7 @@ static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
  * Dump the contents of the read block and re-generate the correct data
  * and dump that too.
  */
-static void dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
+static void __dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
 {
 	struct thread_data *td = vc->td;
 	struct io_u *io_u = vc->io_u;
@@ -302,6 +309,19 @@ static void dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
 	free(buf);
 }
 
+static void dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
+{
+	struct thread_data *td = vc->td;
+	struct verify_header shdr;
+
+	if (td->o.verify == VERIFY_PATTERN_NO_HDR) {
+		__fill_hdr(&shdr, td->o.verify, vc->io_u->buflen, 0);
+		hdr = &shdr;
+	}
+
+	__dump_verify_buffers(hdr, vc);
+}
+
 static void log_verify_failure(struct verify_header *hdr, struct vcont *vc)
 {
 	unsigned long long offset;
@@ -326,7 +346,7 @@ static void log_verify_failure(struct verify_header *hdr, struct vcont *vc)
  */
 static inline void *io_u_verify_off(struct verify_header *hdr, struct vcont *vc)
 {
-	return vc->io_u->buf + vc->hdr_num * hdr->len + hdr_size(hdr);
+	return vc->io_u->buf + vc->hdr_num * hdr->len + hdr_size(vc->td, hdr);
 }
 
 static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
@@ -421,7 +441,7 @@ static int verify_io_u_xxhash(struct verify_header *hdr, struct vcont *vc)
 	dprint(FD_VERIFY, "xxhash verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
 	state = XXH32_init(1);
-	XXH32_update(state, p, hdr->len - hdr_size(hdr));
+	XXH32_update(state, p, hdr->len - hdr_size(vc->td, hdr));
 	hash = XXH32_digest(state);
 
 	if (vh->hash == hash)
@@ -447,7 +467,7 @@ static int verify_io_u_sha512(struct verify_header *hdr, struct vcont *vc)
 	dprint(FD_VERIFY, "sha512 verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
 	fio_sha512_init(&sha512_ctx);
-	fio_sha512_update(&sha512_ctx, p, hdr->len - hdr_size(hdr));
+	fio_sha512_update(&sha512_ctx, p, hdr->len - hdr_size(vc->td, hdr));
 
 	if (!memcmp(vh->sha512, sha512_ctx.buf, sizeof(sha512)))
 		return 0;
@@ -472,7 +492,7 @@ static int verify_io_u_sha256(struct verify_header *hdr, struct vcont *vc)
 	dprint(FD_VERIFY, "sha256 verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
 	fio_sha256_init(&sha256_ctx);
-	fio_sha256_update(&sha256_ctx, p, hdr->len - hdr_size(hdr));
+	fio_sha256_update(&sha256_ctx, p, hdr->len - hdr_size(vc->td, hdr));
 	fio_sha256_final(&sha256_ctx);
 
 	if (!memcmp(vh->sha256, sha256_ctx.buf, sizeof(sha256)))
@@ -498,7 +518,7 @@ static int verify_io_u_sha1(struct verify_header *hdr, struct vcont *vc)
 	dprint(FD_VERIFY, "sha1 verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
 	fio_sha1_init(&sha1_ctx);
-	fio_sha1_update(&sha1_ctx, p, hdr->len - hdr_size(hdr));
+	fio_sha1_update(&sha1_ctx, p, hdr->len - hdr_size(vc->td, hdr));
 	fio_sha1_final(&sha1_ctx);
 
 	if (!memcmp(vh->sha1, sha1_ctx.H, sizeof(sha1)))
@@ -520,7 +540,7 @@ static int verify_io_u_crc7(struct verify_header *hdr, struct vcont *vc)
 
 	dprint(FD_VERIFY, "crc7 verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
-	c = fio_crc7(p, hdr->len - hdr_size(hdr));
+	c = fio_crc7(p, hdr->len - hdr_size(vc->td, hdr));
 
 	if (c == vh->crc7)
 		return 0;
@@ -541,7 +561,7 @@ static int verify_io_u_crc16(struct verify_header *hdr, struct vcont *vc)
 
 	dprint(FD_VERIFY, "crc16 verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
-	c = fio_crc16(p, hdr->len - hdr_size(hdr));
+	c = fio_crc16(p, hdr->len - hdr_size(vc->td, hdr));
 
 	if (c == vh->crc16)
 		return 0;
@@ -562,7 +582,7 @@ static int verify_io_u_crc64(struct verify_header *hdr, struct vcont *vc)
 
 	dprint(FD_VERIFY, "crc64 verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
-	c = fio_crc64(p, hdr->len - hdr_size(hdr));
+	c = fio_crc64(p, hdr->len - hdr_size(vc->td, hdr));
 
 	if (c == vh->crc64)
 		return 0;
@@ -583,7 +603,7 @@ static int verify_io_u_crc32(struct verify_header *hdr, struct vcont *vc)
 
 	dprint(FD_VERIFY, "crc32 verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
-	c = fio_crc32(p, hdr->len - hdr_size(hdr));
+	c = fio_crc32(p, hdr->len - hdr_size(vc->td, hdr));
 
 	if (c == vh->crc32)
 		return 0;
@@ -604,7 +624,7 @@ static int verify_io_u_crc32c(struct verify_header *hdr, struct vcont *vc)
 
 	dprint(FD_VERIFY, "crc32c verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
-	c = fio_crc32c(p, hdr->len - hdr_size(hdr));
+	c = fio_crc32c(p, hdr->len - hdr_size(vc->td, hdr));
 
 	if (c == vh->crc32)
 		return 0;
@@ -629,7 +649,7 @@ static int verify_io_u_md5(struct verify_header *hdr, struct vcont *vc)
 	dprint(FD_VERIFY, "md5 verify io_u %p, len %u\n", vc->io_u, hdr->len);
 
 	fio_md5_init(&md5_ctx);
-	fio_md5_update(&md5_ctx, p, hdr->len - hdr_size(hdr));
+	fio_md5_update(&md5_ctx, p, hdr->len - hdr_size(vc->td, hdr));
 	fio_md5_final(&md5_ctx);
 
 	if (!memcmp(vh->md5_digest, md5_ctx.hash, sizeof(hash)))
@@ -962,6 +982,26 @@ static void fill_md5(struct verify_header *hdr, void *p, unsigned int len)
 	fio_md5_final(&md5_ctx);
 }
 
+static void __fill_hdr(struct verify_header *hdr, int verify_type,
+		       uint32_t len, uint64_t rand_seed)
+{
+	void *p = hdr;
+
+	hdr->magic = FIO_HDR_MAGIC;
+	hdr->verify_type = verify_type;
+	hdr->len = len;
+	hdr->rand_seed = rand_seed;
+	hdr->crc32 = fio_crc32c(p, offsetof(struct verify_header, crc32));
+}
+
+
+static void fill_hdr(struct verify_header *hdr, int verify_type, uint32_t len,
+		     uint64_t rand_seed)
+{
+	if (verify_type != VERIFY_PATTERN_NO_HDR)
+		__fill_hdr(hdr, verify_type, len, rand_seed);
+}
+
 static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 struct verify_header *hdr, unsigned int header_num,
 			 unsigned int header_len)
@@ -969,20 +1009,13 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 	unsigned int data_len;
 	void *data, *p;
 
-	if (td->o.verify == VERIFY_PATTERN_NO_HDR)
-		return;
-
 	p = (void *) hdr;
 
-	hdr->magic = FIO_HDR_MAGIC;
-	hdr->verify_type = td->o.verify;
-	hdr->len = header_len;
-	hdr->rand_seed = io_u->rand_seed;
-	hdr->crc32 = fio_crc32c(p, offsetof(struct verify_header, crc32));
+	fill_hdr(hdr, td->o.verify, header_len, io_u->rand_seed);
 
-	data_len = header_len - hdr_size(hdr);
+	data_len = header_len - hdr_size(td, hdr);
 
-	data = p + hdr_size(hdr);
+	data = p + hdr_size(td, hdr);
 	switch (td->o.verify) {
 	case VERIFY_MD5:
 		dprint(FD_VERIFY, "fill md5 io_u %p, len %u\n",
@@ -1041,14 +1074,16 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 		fill_sha1(hdr, data, data_len);
 		break;
 	case VERIFY_PATTERN:
+	case VERIFY_PATTERN_NO_HDR:
 		/* nothing to do here */
 		break;
 	default:
 		log_err("fio: bad verify type: %d\n", td->o.verify);
 		assert(0);
 	}
-	if (td->o.verify_offset)
-		memswp(p, p + td->o.verify_offset, hdr_size(hdr));
+
+	if (td->o.verify_offset && hdr_size(td, hdr))
+		memswp(p, p + td->o.verify_offset, hdr_size(td, hdr));
 }
 
 /*
