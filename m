Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF5E23ABBE
	for <fio@vger.kernel.org>; Wed, 29 Oct 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761739212; cv=none; b=jvKDxrec0SuueNdrL2Xr9VrNFYD+2BGRAVrcPkANRdiNuKWoL+WToC6oPdEnJ4q+ZXFGbxqsMFpix/4dZDp1GPCcd1hwJzSrJUOZN7/GA2gXPWAckJgJhRSj1UAR7vjU2ETvKPfYWlYMsVTjVAg4VbNlcfbap5fugiuaZVBby5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761739212; c=relaxed/simple;
	bh=Pxl5NkVZiO1cIgVhYOPhXoASChfH61vptQDJAWA4ti8=;
	h=Subject:From:To:Date:Message-Id; b=XDhUVg6ZjhCXKOt5sCytOsIT0is1mHOaSkkjg8BQtO5Ck+hD4FKcjctN9lw+/JSE1HLNyQXjRQV3140C1YclfwdnE0yx9AM9WIXEiLz0SrzQEdFBnNeVsBLRwYbIUWgE4xuDBet7JER/EzwGE63orIeINAipaV1r6VJy9q5OnyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=esoUAJcf; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="esoUAJcf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=lxd0N4jSyXKHD85KuJVHuwhXprE8MyA7fcx5diKzOs4=; b=esoUAJcf2qRc7tQcOsIa9uAJQF
	dvQQxXxFAkt51Yu4dRzl+nun5rOmXZHaXXD1Mp1muHlgjZYoYU3rGcFwUENQVyyeoyemazib+jEEg
	NCcGVd+/bOcF9MHnggK3GsubxqLu7li22QUhu36SrOW5G6S4QXmIlbBc6z/QkXAcM3syqtfZ5k8xg
	8UmI/WB7LshNtbLGvaJZlLA1gQUXcP901mXAtNvzEbRnoVh3LCFnT0j9rii4ZS81pckzmOlAiXZOn
	mYud9THLmqdVQVKSeYuv5V0Fv4hq1Kp/WfzOnqA1kU3hFSTtv0y0pZ2f1Iz9iiDtMbYrgv7vwEuOq
	1IEzC+LQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vE3yj-00000006cYB-2Ih5
	for fio@vger.kernel.org;
	Wed, 29 Oct 2025 11:04:33 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id BEF911BC013B; Wed, 29 Oct 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 29 Oct 2025 06:00:01 -0600
Message-Id: <20251029120001.BEF911BC013B@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7272fd82813a65e3d72ef5c543c7473ec411f4cd:

  t/io_uring: use IORING_SETUP_NO_SQARRAY if available (2025-10-15 08:12:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 967de14b99c124aa0bd8269cbfa230147faffab6:

  Merge branch 'hist_coarseness' of https://github.com/tachyonwill/fio (2025-10-28 12:41:15 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'hist_coarseness' of https://github.com/tachyonwill/fio

William Butler (1):
      options: Add range validation for log_hist_coarseness

 options.c | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 77b42cdb..e1a87430 100644
--- a/options.c
+++ b/options.c
@@ -4751,6 +4751,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "log_hist_coarseness",
 		.lname	= "Histogram logs coarseness",
 		.type	= FIO_OPT_INT,
+		.maxval = 6,
+		.minval = 0,
 		.off1	= offsetof(struct thread_options, log_hist_coarseness),
 		.help	= "Integer in range [0,6]. Higher coarseness outputs"
 			" fewer histogram bins per sample. The number of bins for"
