Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8C67E767
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709643621; cv=none; b=CLdnqrTUEyDdCQN65YdiLenWtkgvZvK7snmtS3ZamMa0BhqiIWFmJkozLd5rbDHFllbMwBB7EsHf/WUgAeWy8RCgHl8u/YquS4MLCgR23DuvFCYETyLJ+1p+P/YEFaG/Px5K2pzule7ni+2iqsRAUd52B6//GgUM2YFvsxTpQMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709643621; c=relaxed/simple;
	bh=gvzEJVZ25Lf3VPdINAB0TE2nftv+NFgOYLcAi14Q2RI=;
	h=Subject:From:To:Message-Id:Date; b=g3QYplbYQNm71crLT3cmMlLJ6d1wlKfydb4+1XEhgeU/xFlUOsWD8lsk2CjmH+HYe3D0wr/G5RJUIRZszNic5ee+aGAqU39roG9AnLxy2W3mOqJ+rAWc22LvDri2BRF6QwYil55lUXZ/bhaKq6sV2Pyj5h9MYZfARsiu91r7GFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qt3B9MQk; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qt3B9MQk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=nZSQgwRAG+QYb+7gIMc+9U6JHTT52Eetj4HERb20hHA=; b=qt3B9MQkJWdmylteQ7ocXdAO+B
	/3fNhlx1GojYn9FU1x4/g7ParDdXEOrtRAk58U/XnixMFT1/iM8znhwQbsWJjHUx8k1Kpy3Ll30lo
	5q9pAyr7mYB9xKRdXzhjie47NUuOflELzyQ0lsqN2ecvZDujp7hTItmp33rK4soCCNycvfQrKgYYW
	p5wgGGHyByduXJI9sGJ03jqGA0DSVy0JUVIoAr/qdApBGgBQU7ZUmX7JR+QInTZEuhSaiO4QY/8rr
	HsUkxkIx4QuEXTowKN6tAdPL0z8pjFWyZYcLqASMA3xKBudK7henmF7NGAqIcQ4i4zaCCCw+C0lPq
	KCcqCAnQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhUOu-00000005Qi2-2j1s
	for fio@vger.kernel.org;
	Tue, 05 Mar 2024 13:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 0F9761BC01CE; Tue,  5 Mar 2024 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240305130002.0F9761BC01CE@kernel.dk>
Date: Tue,  5 Mar 2024 06:00:02 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 5ae4f4220a48dddddc84c8b839ef9d8a1ed4edb1:

  gettime: fix cpuclock-test on AMD platforms (2024-02-27 12:36:45 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2dddfd35396e2f7a1bb06cc7c92aa1e283be084e:

  Merge branch 'patch-ioengines' of https://github.com/kcoms555/fio (2024-03-04 07:31:47 -0700)

----------------------------------------------------------------
Jaeho (1):
      ioengines: Make td_io_queue print log_err when got error

Jens Axboe (1):
      Merge branch 'patch-ioengines' of https://github.com/kcoms555/fio

 ioengines.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index 87cc2286..5dd4355d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -413,7 +413,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (io_u->error == EINVAL && td->io_issues[io_u->ddir & 1] == 1 &&
 	    td->o.odirect) {
 
-		log_info("fio: first direct IO errored. File system may not "
+		log_err("fio: first direct IO errored. File system may not "
 			 "support direct IO, or iomem_align= is bad, or "
 			 "invalid block size. Try setting direct=0.\n");
 	}
@@ -421,7 +421,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (zbd_unaligned_write(io_u->error) &&
 	    td->io_issues[io_u->ddir & 1] == 1 &&
 	    td->o.zone_mode != ZONE_MODE_ZBD) {
-		log_info("fio: first I/O failed. If %s is a zoned block device, consider --zonemode=zbd\n",
+		log_err("fio: first I/O failed. If %s is a zoned block device, consider --zonemode=zbd\n",
 			 io_u->file->file_name);
 	}
 
