Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402009;
	b=tT/FljJ0GTRUX4L8brCqUSWxifZovImeW/qIbhDJfqNw3nthSQKs3FU1pBvajUOH0hpo
	 tmwrF7hc7FD5e7cOGwJiPgEcnWIif2OQOa5yk1BB3LcDXCVggxuklER6ZrY6EUQBdDkfj
	 7F1zYIUrF/n0p5ppoaFir7hb6bF6VfYxAzKnhZNUMucUWPXNSHnuygR/B0DS/7T5H5DA/
	 JQSVA+2i0MywntyCoUOSciOvTfgfaBDLEWS3NxojsVae4zTNdn2sRR7jVpD2gdw0opo0P
	 e7qThC/SVl9y2LMxqt8S6We3yry3vE73Qnwd60byG8I+wJboxYeWGeYJWaF4aFUODVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402009;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=tPD1MTlHx8LLUuL3anjlPNPZww43NWFeu/4dxP3EqSw=;
	b=Tc24oPtixyXlMIKZfuLBo80RSaxq9IQJH7FE+kRLLvW3lVFaA7rSx7J0VQiAmMpoIV2u
	 QOaXyjGjzc0Katsv8BsvpbeDl2upq2X4/9dAVnrU5TjZhBxeLhv28Ongb4a5Of2+RP9PM
	 ZOrEdgB6gWjjzxM+3p7ALMzA/3/Rqn2U/nEueAsVyI2S6IFpf/y4TR7n3vJFHt//86Sdw
	 90aoBiT9bq4/XbywVc8HiFRN58ee8mYtMT086Q9asLh6NPVXBiDfPURtSVwLzUfVt9+ne
	 2KfIkfqGbeoyK89e/i+v37EJX69Rl15cju3iXUtQAp+CJHaPis17/BBr7yYECcT2o0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=G3Nlve3r;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99FD606A32A
	for <fio@vger.kernel.org>; Wed, 11 Nov 2026 13:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D99FD606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=G3Nlve3r
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=tPD1MTlHx8LLUuL3anjlPNPZww43NWFeu/4dxP3EqSw=; b=G3Nlve3rKfV7Hu3a3j8cOlkTeW
	DDst5FpNj127NQI7DfbTr1R3zxScShuNQm7z3/YXzCv1UiOXqLMp8CgvLaGpPZC1X/8jMuumgJlv0
	TwZmjIN/T83MZmVOPtTi1gGqxzI7BPD4safRnmWblGP8TuR/yyVeSlTN4qtcFVsjD2zdHOejboQXQ
	VHX+9FkUjHw+XNf9NRAZqtYv72PYakQdJqLzl/F4uicAyMc0BUytsLDFkiI/GRqN+dsAfWa+ET3wG
	+ORL2zajO57U+0izh+GB/zqViNTJ7MCpGV3Lcn2SKzTH3K7rsmp7gC5DDSHLk/6Hy2oEMdWi9ncJ8
	Vpx05waw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR7vp-0000000992C-0dLU
	for fio@vger.kernel.org;
	Wed, 11 Nov 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 050C71BC0142; Wed, 11 Nov 2026 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 11 Nov 2026 06:00:01 -0700
Message-Id: <20261111130002.050C71BC0142@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit bfffdcd1ec9ca694c7ce780975f73e9ef0dbfaa2:

  Merge branch 'factor-out-parse-iolog-line' of https://github.com/arethusa/fio (2026-11-05 14:01:15 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 290c2b255c6144b2601a665f0582590fcf735a76:

  Merge branch 'fsync_flags' of https://github.com/Panky-codes/fio (2026-11-10 12:56:55 -0500)

----------------------------------------------------------------
Pankaj Raghav (1):
      engines/io_uring: clear stale SQE fields for sync requests

Vincent Fu (1):
      Merge branch 'fsync_flags' of https://github.com/Panky-codes/fio

 engines/io_uring.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index a7b67ce7..4421fef3 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1057,7 +1057,17 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		sqe->ioprio = td->ioprio;
 		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
+		/*
+		 * SQEs are reused across io_u submissions. The kernel rejects
+		 * fsync/sync_file_range with -EINVAL if addr, buf_index or
+		 * splice_fd_in are set, or if fsync_flags (which aliases
+		 * rw_flags) has bits other than IORING_FSYNC_DATASYNC. Clear
+		 * anything a previous read/write may have left behind.
+		 */
 		sqe->ioprio = 0;
+		sqe->addr = 0;
+		sqe->buf_index = 0;
+		sqe->splice_fd_in = 0;
 		if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
 			sqe->off = f->first_write;
 			sqe->len = f->last_write - f->first_write;
@@ -1065,8 +1075,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->opcode = IORING_OP_SYNC_FILE_RANGE;
 		} else {
 			sqe->off = 0;
-			sqe->addr = 0;
 			sqe->len = 0;
+			sqe->fsync_flags = 0;
 			if (io_u->ddir == DDIR_DATASYNC)
 				sqe->fsync_flags |= IORING_FSYNC_DATASYNC;
 			sqe->opcode = IORING_OP_FSYNC;
