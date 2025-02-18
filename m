Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495ED22FF31
	for <fio@vger.kernel.org>; Tue, 18 Feb 2025 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739883614; cv=none; b=ND+KlkB6NvFYrz5x8D2oBkmJPPDopSP+aor3fk6Nrv0+uqSD/GAjmdkAD8A7WD79m3CJnp55CwqYrA7JuyN1Lv2NKHMbzLUpIXMO8nTCw35kranmIINcbjm9K6uWI3qmQ8sRoer44zrOiXlLUx/0ReapVcW7hhCX/Zmffwl+Ulw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739883614; c=relaxed/simple;
	bh=gHuKYIkqN/IVr68TOpUKUYmTuiO70V1Loyx6QohvbSs=;
	h=Subject:From:To:Message-Id:Date; b=qd2NIMzBJEi1DF9ds48F2QZe7+tn7bNp4ZDWPfB+/fvylL76nCe3GkBos6ZixTonVbeSi2VzronPdCvdtDvnpjcRaLU1wF2ayxgAFc4iFayKO26w64+JGq2hhJOWxh0GsjCTlW0L5WT5q1PGPQ22LVwB5MMRcNOf1ruM6b9LJJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d31Xp77g; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d31Xp77g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GjNObG4k4iHSjBIY5iN1P1ju3ivBuJkmnbWdl2hzKU0=; b=d31Xp77gxsvInkPyD1fWEXZgit
	xRWIG7Dr83E5gemS+pN6Ud1S4w/rlxIy0sj6vsrN58mp08GnizH8IXFeGWBbN2aad1wbRgeBpLqkx
	kG9hlJF6lS5RGi2pXRNqXXxnvOE8onL1lNyT2trcTVJ24W50EpbBZBn9Azrz/mIUOcUFRZtZ+ECyF
	YQtWcXrfzd6yaslPuLg90AcJFgVJJuUwku4p3UJNmomIeyoZWBTU5CO2pJb0Z/1+A55eczrWrXJbc
	4zeN9F3XWHzxtHoR09iqN1XNDfFFgOLLYOuxc1fH3MkveICTDGW4hIkiB+vjqJOwPFrEaJCqZXxh2
	iAWHiNhA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkNCp-00000001zsk-2JTn
	for fio@vger.kernel.org;
	Tue, 18 Feb 2025 13:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4B0801BC0136; Tue, 18 Feb 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250218130001.4B0801BC0136@kernel.dk>
Date: Tue, 18 Feb 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2768c33ec1a34cbc03f122876fea72a630da9ccb:

  Merge branch 't0036-0037' of https://github.com/kawasaki/fio (2025-02-14 09:26:48 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3ee531989f41b242b73d9f6cb33186a686a7133c:

  crc/sha512: fix missing finalize part of sha512 hash (2025-02-17 16:30:07 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      crc/sha512: fix missing finalize part of sha512 hash

Ritesh Harjani (IBM) (1):
      libaio: Add vectored io support

 HOWTO.rst        |  4 ++++
 crc/sha512.c     | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crc/sha512.h     |  1 +
 engines/libaio.c | 37 ++++++++++++++++++++++++++++++++++--
 verify.c         |  2 ++
 5 files changed, 99 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 504a64b8..3f2bde18 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2515,6 +2515,10 @@ with the caveat that when used on the command line, they must come after the
 	not support torn-write protection. To learn a file's torn-write limits, issue
 	statx with STATX_WRITE_ATOMIC.
 
+.. option:: libaio_vectored=bool : [libaio]
+
+    Submit vectored read and write requests.
+
 .. option:: fdp=bool : [io_uring_cmd] [xnvme]
 
 	Enable Flexible Data Placement mode for write commands.
diff --git a/crc/sha512.c b/crc/sha512.c
index f599cdcc..78e64ba2 100644
--- a/crc/sha512.c
+++ b/crc/sha512.c
@@ -195,3 +195,60 @@ void fio_sha512_update(struct fio_sha512_ctx *sctx, const uint8_t *data,
 	/* erase our data */
 	memset(sctx->W, 0, sizeof(sctx->W));
 }
+
+void fio_sha512_final(struct fio_sha512_ctx *sctx)
+{
+	uint8_t *hash = sctx->buf;
+	static uint8_t padding[128] = { 0x80, };
+	unsigned int index, pad_len;
+	uint8_t bits[128];
+	uint64_t t2;
+	uint32_t t;
+	int i, j;
+
+        index = pad_len = t = i = j = 0;
+        t2 = 0;
+
+	/* Save number of bits */
+	t = sctx->count[0];
+	bits[15] = t; t>>=8;
+	bits[14] = t; t>>=8;
+	bits[13] = t; t>>=8;
+	bits[12] = t;
+	t = sctx->count[1];
+	bits[11] = t; t>>=8;
+	bits[10] = t; t>>=8;
+	bits[9 ] = t; t>>=8;
+	bits[8 ] = t;
+	t = sctx->count[2];
+	bits[7 ] = t; t>>=8;
+	bits[6 ] = t; t>>=8;
+	bits[5 ] = t; t>>=8;
+	bits[4 ] = t;
+	t = sctx->count[3];
+	bits[3 ] = t; t>>=8;
+	bits[2 ] = t; t>>=8;
+	bits[1 ] = t; t>>=8;
+	bits[0 ] = t;
+
+	/* Pad out to 112 mod 128. */
+	index = (sctx->count[0] >> 3) & 0x7f;
+	pad_len = (index < 112) ? (112 - index) : ((128+112) - index);
+	fio_sha512_update(sctx, padding, pad_len);
+
+	/* Append length (before padding) */
+	fio_sha512_update(sctx, bits, 16);
+
+	/* Store state in digest */
+	for (i = j = 0; i < 8; i++, j += 8) {
+		t2 = sctx->state[i];
+		hash[j+7] = (char)t2 & 0xff; t2>>=8;
+		hash[j+6] = (char)t2 & 0xff; t2>>=8;
+		hash[j+5] = (char)t2 & 0xff; t2>>=8;
+		hash[j+4] = (char)t2 & 0xff; t2>>=8;
+		hash[j+3] = (char)t2 & 0xff; t2>>=8;
+		hash[j+2] = (char)t2 & 0xff; t2>>=8;
+		hash[j+1] = (char)t2 & 0xff; t2>>=8;
+		hash[j  ] = (char)t2 & 0xff;
+	}
+}
diff --git a/crc/sha512.h b/crc/sha512.h
index 5adf6271..dd26d8aa 100644
--- a/crc/sha512.h
+++ b/crc/sha512.h
@@ -12,5 +12,6 @@ struct fio_sha512_ctx {
 
 void fio_sha512_init(struct fio_sha512_ctx *);
 void fio_sha512_update(struct fio_sha512_ctx *, const uint8_t *, unsigned int);
+void fio_sha512_final(struct fio_sha512_ctx *sctx);
 
 #endif
diff --git a/engines/libaio.c b/engines/libaio.c
index c2d43793..aff4025e 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -37,6 +37,7 @@ struct libaio_data {
 	struct io_u **io_us;
 
 	struct io_u **io_u_index;
+	struct iovec *iovecs;		/* for vectored requests */
 
 	/*
 	 * Basic ring buffer. 'head' is incremented in _queue(), and
@@ -60,6 +61,7 @@ struct libaio_options {
 	unsigned int userspace_reap;
 	struct cmdprio_options cmdprio_options;
 	unsigned int nowait;
+	unsigned int vectored;
 };
 
 static struct fio_option options[] = {
@@ -81,6 +83,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name	= "libaio_vectored",
+		.lname	= "Use libaio preadv,pwritev",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct libaio_options, vectored),
+		.help	= "Use libaio {preadv,pwritev} instead of libaio {pread,pwrite}",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+
 	CMDPRIO_OPTIONS(struct libaio_options, FIO_OPT_G_LIBAIO),
 	{
 		.name	= NULL,
@@ -101,13 +113,32 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 	struct libaio_options *o = td->eo;
 	struct fio_file *f = io_u->file;
 	struct iocb *iocb = &io_u->iocb;
+	struct libaio_data *ld = td->io_ops_data;
 
 	if (io_u->ddir == DDIR_READ) {
-		io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (o->vectored) {
+			struct iovec *iov = &ld->iovecs[io_u->index];
+
+			iov->iov_base = io_u->xfer_buf;
+			iov->iov_len = (size_t)io_u->xfer_buflen;
+			io_prep_preadv(iocb, f->fd, iov, 1, io_u->offset);
+		} else {
+			io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen,
+						  io_u->offset);
+		}
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
 	} else if (io_u->ddir == DDIR_WRITE) {
-		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (o->vectored) {
+			struct iovec *iov = &ld->iovecs[io_u->index];
+
+			iov->iov_base = io_u->xfer_buf;
+			iov->iov_len = (size_t)io_u->xfer_buflen;
+			io_prep_pwritev(iocb, f->fd, iov, 1, io_u->offset);
+		} else {
+			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen,
+						   io_u->offset);
+		}
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
 #ifdef FIO_HAVE_RWF_ATOMIC
@@ -394,6 +425,7 @@ static void fio_libaio_cleanup(struct thread_data *td)
 			io_destroy(ld->aio_ctx);
 
 		fio_cmdprio_cleanup(&ld->cmdprio);
+		free(ld->iovecs);
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
@@ -428,6 +460,7 @@ static int fio_libaio_init(struct thread_data *td)
 	ld->aio_events = calloc(ld->entries, sizeof(struct io_event));
 	ld->iocbs = calloc(ld->entries, sizeof(struct iocb *));
 	ld->io_us = calloc(ld->entries, sizeof(struct io_u *));
+	ld->iovecs = calloc(ld->entries, sizeof(ld->iovecs[0]));
 
 	td->io_ops_data = ld;
 
diff --git a/verify.c b/verify.c
index 4dbf8d56..570c888f 100644
--- a/verify.c
+++ b/verify.c
@@ -537,6 +537,7 @@ static int verify_io_u_sha512(struct verify_header *hdr, struct vcont *vc)
 
 	fio_sha512_init(&sha512_ctx);
 	fio_sha512_update(&sha512_ctx, p, hdr->len - hdr_size(vc->td, hdr));
+	fio_sha512_final(&sha512_ctx);
 
 	if (!memcmp(vh->sha512, sha512_ctx.buf, sizeof(sha512)))
 		return 0;
@@ -1092,6 +1093,7 @@ static void fill_sha512(struct verify_header *hdr, void *p, unsigned int len)
 
 	fio_sha512_init(&sha512_ctx);
 	fio_sha512_update(&sha512_ctx, p, len);
+	fio_sha512_final(&sha512_ctx);
 }
 
 static void fill_sha256(struct verify_header *hdr, void *p, unsigned int len)
