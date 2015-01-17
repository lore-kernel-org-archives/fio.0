Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbbAQNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 17 Jan 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YCSyz-00028f-9y
	for fio@vger.kernel.org; Sat, 17 Jan 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150117130003.3F07440156@lyth.info>
Date: Sat, 17 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9cc80b6d92a15c6b9cbdbc021436f1628054cfda:

  Improve rate limiting (2015-01-15 10:39:12 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae703cdf31532e337cc18c259c883bf5314aa43a:

  net: don't record/verify UDP sequence numbers if buffer is too small (2015-01-16 18:26:37 -0700)

----------------------------------------------------------------
Jens Axboe (6):
      Improve precision of the io_limit setting
      ioengine: if we get BUSY in queuing, adjust accounting
      verify: always check completion list for low depth verifies
      sha256: fix verify failure
      Fix segfault with client/server and minimal output
      crc/test: sha1 should do _final() after _update()

Steven Noonan (1):
      net: don't record/verify UDP sequence numbers if buffer is too small

 backend.c     |    8 ++++----
 crc/sha1.c    |    7 +------
 crc/sha1.h    |    2 +-
 crc/test.c    |    4 +++-
 diskutil.c    |    3 +++
 engines/net.c |    6 ++++++
 fio.h         |    8 ++++++++
 ioengines.c   |    9 ++++++++-
 verify.c      |   14 +++++++++++---
 9 files changed, 45 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index efabfa7..9012140 100644
--- a/backend.c
+++ b/backend.c
@@ -667,13 +667,13 @@ static int io_bytes_exceeded(struct thread_data *td)
 	unsigned long long bytes, limit;
 
 	if (td_rw(td))
-		bytes = td->this_io_bytes[DDIR_READ] + td->this_io_bytes[DDIR_WRITE];
+		bytes = td->io_issue_bytes[DDIR_READ] + td->io_issue_bytes[DDIR_WRITE];
 	else if (td_write(td))
-		bytes = td->this_io_bytes[DDIR_WRITE];
+		bytes = td->io_issue_bytes[DDIR_WRITE];
 	else if (td_read(td))
-		bytes = td->this_io_bytes[DDIR_READ];
+		bytes = td->io_issue_bytes[DDIR_READ];
 	else
-		bytes = td->this_io_bytes[DDIR_TRIM];
+		bytes = td->io_issue_bytes[DDIR_TRIM];
 
 	if (td->o.io_limit)
 		limit = td->o.io_limit;
diff --git a/crc/sha1.c b/crc/sha1.c
index 117fbd9..8d64c8e 100644
--- a/crc/sha1.c
+++ b/crc/sha1.c
@@ -55,7 +55,7 @@ void fio_sha1_update(struct fio_sha1_ctx *ctx, const void *data,
 		memcpy(ctx->W, data, len);
 }
 
-void fio_sha1_final(unsigned char hashout[20], struct fio_sha1_ctx *ctx)
+void fio_sha1_final(struct fio_sha1_ctx *ctx)
 {
 	static const unsigned char pad[64] = { 0x80 };
 	unsigned int padlen[2];
@@ -69,11 +69,6 @@ void fio_sha1_final(unsigned char hashout[20], struct fio_sha1_ctx *ctx)
 	i = ctx->size & 63;
 	fio_sha1_update(ctx, pad, 1+ (63 & (55 - i)));
 	fio_sha1_update(ctx, padlen, 8);
-
-	/* Output hash
-	 */
-	for (i = 0; i < 5; i++)
-		((unsigned int *)hashout)[i] = htonl(ctx->H[i]);
 }
 
 #if defined(__i386__) || defined(__x86_64__)
diff --git a/crc/sha1.h b/crc/sha1.h
index 14af44a..75317f7 100644
--- a/crc/sha1.h
+++ b/crc/sha1.h
@@ -15,6 +15,6 @@ struct fio_sha1_ctx {
 
 void fio_sha1_init(struct fio_sha1_ctx *);
 void fio_sha1_update(struct fio_sha1_ctx *, const void *dataIn, unsigned long len);
-void fio_sha1_final(unsigned char hashout[20], struct fio_sha1_ctx *);
+void fio_sha1_final(struct fio_sha1_ctx *);
 
 #endif
diff --git a/crc/test.c b/crc/test.c
index bc5cc45..dbc5653 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -111,8 +111,10 @@ static void t_sha1(struct test_type *t, void *buf, size_t size)
 
 	fio_sha1_init(&ctx);
 
-	for (i = 0; i < NR_CHUNKS; i++)
+	for (i = 0; i < NR_CHUNKS; i++) {
 		fio_sha1_update(&ctx, buf, size);
+		fio_sha1_final(&ctx);
+	}
 }
 
 static void t_sha256(struct test_type *t, void *buf, size_t size)
diff --git a/diskutil.c b/diskutil.c
index 98ae2fe..52d87f6 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -694,6 +694,9 @@ void show_disk_util(int terse, struct json_object *parent)
 	struct flist_head *entry;
 	struct disk_util *du;
 
+	if (!disk_util_mutex)
+		return;
+
 	fio_mutex_down(disk_util_mutex);
 
 	if (flist_empty(&disk_list)) {
diff --git a/engines/net.c b/engines/net.c
index 7a0fe69..cd19535 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -484,6 +484,9 @@ static void store_udp_seq(struct netio_data *nd, struct io_u *io_u)
 {
 	struct udp_seq *us;
 
+	if (io_u->xfer_buflen < sizeof(*us))
+		return;
+
 	us = io_u->xfer_buf + io_u->xfer_buflen - sizeof(*us);
 	us->magic = cpu_to_le64((uint64_t) FIO_UDP_SEQ_MAGIC);
 	us->bs = cpu_to_le64((uint64_t) io_u->xfer_buflen);
@@ -496,6 +499,9 @@ static void verify_udp_seq(struct thread_data *td, struct netio_data *nd,
 	struct udp_seq *us;
 	uint64_t seq;
 
+	if (io_u->xfer_buflen < sizeof(*us))
+		return;
+
 	if (nd->seq_off)
 		return;
 
diff --git a/fio.h b/fio.h
index be2f23a..d28f8ce 100644
--- a/fio.h
+++ b/fio.h
@@ -235,7 +235,15 @@ struct thread_data {
 	uint64_t total_io_size;
 	uint64_t fill_device_size;
 
+	/*
+	 * Issue side
+	 */
 	uint64_t io_issues[DDIR_RWDIR_CNT];
+	uint64_t io_issue_bytes[DDIR_RWDIR_CNT];
+
+	/*
+	 * Completions
+	 */
 	uint64_t io_blocks[DDIR_RWDIR_CNT];
 	uint64_t this_io_blocks[DDIR_RWDIR_CNT];
 	uint64_t io_bytes[DDIR_RWDIR_CNT];
diff --git a/ioengines.c b/ioengines.c
index 6370a56..00098d6 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -294,13 +294,20 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 					sizeof(struct timeval));
 	}
 
-	if (ddir_rw(acct_ddir(io_u)))
+	if (ddir_rw(acct_ddir(io_u))) {
 		td->io_issues[acct_ddir(io_u)]++;
+		td->io_issue_bytes[acct_ddir(io_u)] += io_u->xfer_buflen;
+	}
 
 	ret = td->io_ops->queue(td, io_u);
 
 	unlock_file(td, io_u->file);
 
+	if (ret == FIO_Q_BUSY && ddir_rw(acct_ddir(io_u))) {
+		td->io_issues[acct_ddir(io_u)]--;
+		td->io_issue_bytes[acct_ddir(io_u)] -= io_u->xfer_buflen;
+	}
+
 	/*
 	 * If an error was seen and the io engine didn't propagate it
 	 * back to 'td', do so.
diff --git a/verify.c b/verify.c
index 205f01a..b6793d7 100644
--- a/verify.c
+++ b/verify.c
@@ -472,6 +472,7 @@ static int verify_io_u_sha256(struct verify_header *hdr, struct vcont *vc)
 
 	fio_sha256_init(&sha256_ctx);
 	fio_sha256_update(&sha256_ctx, p, hdr->len - hdr_size(hdr));
+	fio_sha256_final(&sha256_ctx);
 
 	if (!memcmp(vh->sha256, sha256_ctx.buf, sizeof(sha256)))
 		return 0;
@@ -497,6 +498,7 @@ static int verify_io_u_sha1(struct verify_header *hdr, struct vcont *vc)
 
 	fio_sha1_init(&sha1_ctx);
 	fio_sha1_update(&sha1_ctx, p, hdr->len - hdr_size(hdr));
+	fio_sha1_final(&sha1_ctx);
 
 	if (!memcmp(vh->sha1, sha1_ctx.H, sizeof(sha1)))
 		return 0;
@@ -627,6 +629,7 @@ static int verify_io_u_md5(struct verify_header *hdr, struct vcont *vc)
 
 	fio_md5_init(&md5_ctx);
 	fio_md5_update(&md5_ctx, p, hdr->len - hdr_size(hdr));
+	fio_md5_final(&md5_ctx);
 
 	if (!memcmp(vh->md5_digest, md5_ctx.hash, sizeof(hash)))
 		return 0;
@@ -893,6 +896,7 @@ static void fill_sha256(struct verify_header *hdr, void *p, unsigned int len)
 
 	fio_sha256_init(&sha256_ctx);
 	fio_sha256_update(&sha256_ctx, p, len);
+	fio_sha256_final(&sha256_ctx);
 }
 
 static void fill_sha1(struct verify_header *hdr, void *p, unsigned int len)
@@ -904,6 +908,7 @@ static void fill_sha1(struct verify_header *hdr, void *p, unsigned int len)
 
 	fio_sha1_init(&sha1_ctx);
 	fio_sha1_update(&sha1_ctx, p, len);
+	fio_sha1_final(&sha1_ctx);
 }
 
 static void fill_crc7(struct verify_header *hdr, void *p, unsigned int len)
@@ -950,6 +955,7 @@ static void fill_md5(struct verify_header *hdr, void *p, unsigned int len)
 
 	fio_md5_init(&md5_ctx);
 	fio_md5_update(&md5_ctx, p, len);
+	fio_md5_final(&md5_ctx);
 }
 
 static void populate_hdr(struct thread_data *td, struct io_u *io_u,
@@ -1540,10 +1546,12 @@ int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
 		return 0;
 
 	/*
-	 * If we're not into the window of issues - depth yet, continue
+	 * If we're not into the window of issues - depth yet, continue. If
+	 * issue is shorter than depth, do check.
 	 */
-	if (td->io_blocks[DDIR_READ] < s->depth ||
-	    s->numberio - td->io_blocks[DDIR_READ] > s->depth)
+	if ((td->io_blocks[DDIR_READ] < s->depth ||
+	    s->numberio - td->io_blocks[DDIR_READ] > s->depth) &&
+	    s->numberio > s->depth)
 		return 0;
 
 	/*
