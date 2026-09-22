Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7CF53D0DB
	for <fio@vger.kernel.org>; Tue, 22 Sep 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790078412; cv=none; b=N409XrWUsm9jmeA2zAn+2HwQ5jKdHZEr9DqGqhJB9Yv9y72dOFqijRNixeSt9nXJq+SQ4A1T3zI5yrYsVALXpEnNzZopjoXygvXdHwJjz6tFxK2ptoUEUYljcorHrhJSZkh/KBVJfub476WzihznzWQG853ijsgV2xQjUr9BAWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790078412; c=relaxed/simple;
	bh=mx8u8OfEGrwoq4w5BUfDSRU2LeBrhaUrIqJ42vhpWUE=;
	h=Subject:From:To:Date:Message-Id; b=tcyPp4xbkq1TdVpj5hmKxIOf8HVPexjFuiOP1KcAKIOOthD1TXbnfn9ffiblZLd1eE1plU6S4JIBIJtO7e8tJdlr4rafTSQk/+fYPh4ARjLnmfmYsD7bdZ4c5AjmOMf+XqMaMsbTmznsIJWbt1lh13ALmF4KBd8IjfRyZor68oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pDguxmOy; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pDguxmOy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=+aSVxNp7bY6JMthit0uxYcvo/29SW9PiFe6iYdr1f1I=; b=pDguxmOyibQuNu4NlhlbxrruY4
	uHzejNCG+HI5K5gf5OMyyXIfr42ul8/jSv6m6tV7l0b2Bu73NsylM9EwZTU+5z47wirJo22J7SPER
	uLNHI/bXnT3JTpvhXPNiVR2WYdndj7sz5Xty/PABI+87iuQ3eSS71fSSOWK/82JGsNAiQtFcZe9wA
	hW8cOuMgOGqN1SiF4sbFY5XaVrHpxdfWpKdFr8WMWD8qwTfIpCZ0cshiYgzpETkjYhBnHoSOk+csZ
	rVZP9BVZKL7YOLnLwwiYlncfBjf98PEu3PkHY9OXgwcQnyV6bnYcksCLffJcy6tNR3DgUNkU2gsSR
	6u51Qi3g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x8zAL-0000000DWIT-3dKY
	for fio@vger.kernel.org;
	Tue, 22 Sep 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 50C001BC012E; Tue, 22 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 22 Sep 2026 06:00:01 -0600
Message-Id: <20260922120001.50C001BC012E@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2ef248b912406bb4cfe54aa45295a84924d00f46:

  Merge branch 'readme-typo' of github.com:vic233333/fio (2026-09-21 03:14:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 47c14c6f35b1c94650faf49b19db568cf38c38d4:

  Merge branch 'metadata' of https://github.com/sc108-lee/fio (2026-09-21 18:16:20 -0400)

----------------------------------------------------------------
Steven Seungcheol Lee (1):
      Remove metadata transfer from Data Transfer 00b commands

Vincent Fu (1):
      Merge branch 'metadata' of https://github.com/sc108-lee/fio

 engines/nvme.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/engines/nvme.c b/engines/nvme.c
index e989306a..61d30413 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -394,33 +394,34 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	/* cdw12 represent number of lba's for read/write */
 	cmd->cdw12 = nlb | (io_u->dtype << 20) | cdw12_flags;
 	cmd->cdw13 = io_u->dspec << 16;
-	if (iov) {
-		iov->iov_base = io_u->xfer_buf;
-		iov->iov_len = io_u->xfer_buflen;
-		cmd->addr = (__u64)(uintptr_t)iov;
-		cmd->data_len = 1;
-	} else {
-		/* use buffer only for data transfer commands */
-		switch (cmd->opcode) {
+
+	/* use buffer only for data transfer commands */
+	switch (cmd->opcode) {
 		case nvme_cmd_read:
 		case nvme_cmd_write:
 		case nvme_cmd_compare:
 		case nvme_zns_cmd_append:
-			cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
-			cmd->data_len = io_u->xfer_buflen;
+			if (iov) {
+				iov->iov_base = io_u->xfer_buf;
+				iov->iov_len = io_u->xfer_buflen;
+				cmd->addr = (__u64)(uintptr_t)iov;
+				cmd->data_len = 1;
+			} else {
+				cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
+				cmd->data_len = io_u->xfer_buflen;
+			}
+			if (data->lba_shift && data->ms) {
+				cmd->metadata = (__u64)(uintptr_t)io_u->mmap_data;
+				cmd->metadata_len = (nlb + 1) * data->ms;
+			}
 			break;
 		case nvme_cmd_write_zeroes:
 		case nvme_cmd_write_uncor:
 		case nvme_cmd_verify:
-			/* since cmd->addr and cmd->data_len is set to 0 by memset */
+			/* since data, metadata is set to 0 by memset */
 			break;
 		default:
 			return -ENOTSUP;
-		}
-	}
-	if (data->lba_shift && data->ms) {
-		cmd->metadata = (__u64)(uintptr_t)io_u->mmap_data;
-		cmd->metadata_len = (nlb + 1) * data->ms;
 	}
 	cmd->nsid = data->nsid;
 	return 0;
