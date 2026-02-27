Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1C41FBEA6
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 06:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172058; cv=none; b=RFJ7Wws4iWZI1qSUjQHabENp6nB2IBEAIj9wvtyFFpWkDwLrUyrOlDcg4wBoipaRUXNhh2PsHXa5JUj6lrSvsTBRmzcyLC1DlbiQcLB1dRwphbiSGZzsHGiIwAklK1PdisIv6X9MtXS8FT23iqxKGImDo4bc/kncge9hW+2iTzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172058; c=relaxed/simple;
	bh=nyCpRO6Uat+K2NVikanpMOkHSEcKqcyUF38XfsnAOJ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8C5a6998P6oUh/rRejJ5s6IY0mXC/xmAajIG5JOweDBpE/b9U6f2u+FpNcSaJaLzITQPgUpCqw0Fjk1ArXZ3lIxym8oS80S/XVXQn/i2kWYf07xAyfPaELCOdF1/x42ldl7Dnp6IqI+RJrK/H5CXn6/rzkXC3RaKftpRS5to8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kq/7Ms37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kq/7Ms37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBB7C116C6;
	Fri, 27 Feb 2026 06:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172058;
	bh=nyCpRO6Uat+K2NVikanpMOkHSEcKqcyUF38XfsnAOJ0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kq/7Ms378nljdjLVzqZEOadqOqWngyO0DDyVCD29FGIoHiEsK+YOAMWNY8rp1KVG0
	 hVsi2wQ1X++hTcujgTTzG9q169Prjd0zbM5xdRNwfsQ9r9uxFt6iyaC7p7HJJa0Did
	 V0eywsjlXisVkyxQMQlD0atofhy/z2U0ziEy/R2S3lUPI7kF0SF8HJy2shoEC9k8VK
	 GiRkloHkbeG1ZI1H6I0Bn3fQnEupzkptb83Qwn/C9be+tTKkjvoJOve4co7w3TY0dz
	 8HnZ4mXbaTz0sQ0DNucRlhn5ZGRQvUsTxxjsYoHPXoRs9Jv9l+lD/0xOZQ5ZjPgisk
	 DNrI/WzaKqXzQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v3 4/8] engines: io_uring: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 14:55:34 +0900
Message-ID: <20260227055538.2334916-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260227055538.2334916-1-dlemoal@kernel.org>
References: <20260227055538.2334916-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flag the io_uring engine with the FIO_ASYNCIO_SYNC_SYNCFS flag to
indicate that the syncfs operation is supported, synchronously.
Modify fio_ioring_queue() to call do_io_u_sync() for an io_u that has
the DDIR_SYNCFS data direction.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/io_uring.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 0ea3aba12e2c..d4dff3b8f275 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -890,12 +890,19 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
-	/* if async trim has been tried and failed, punt to sync */
-	if (io_u->ddir == DDIR_TRIM && ld->async_trim_fail) {
+	/*
+	 * If this is a syncfs request, or if async trim has been tried and
+	 * failed, punt to sync.
+	 * */
+	if (io_u->ddir == DDIR_SYNCFS ||
+	    (io_u->ddir == DDIR_TRIM && ld->async_trim_fail)) {
 		if (ld->queued)
 			return FIO_Q_BUSY;
 
-		do_io_u_trim(td, io_u);
+		if (io_u->ddir == DDIR_TRIM)
+			do_io_u_trim(td, io_u);
+		else
+			do_io_u_sync(td, io_u);
 
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
@@ -2013,7 +2020,8 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO |
 					FIO_ASYNCIO_SETS_ISSUE_TIME |
-					FIO_MULTI_RANGE_TRIM,
+					FIO_MULTI_RANGE_TRIM |
+					FIO_ASYNCIO_SYNC_SYNCFS,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
-- 
2.53.0

