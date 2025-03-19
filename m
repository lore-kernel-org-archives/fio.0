Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126541C8637
	for <fio@vger.kernel.org>; Wed, 19 Mar 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742385611; cv=none; b=SVlfwhMJrOlpfwz1SIx3NadLrVnmUubdsCAwCOk9StHWaBhndpLIFtP+y6McxbQig8JXPVlgDJ+A19yb6q1s0MByJEkfXpJsodV+MLBvADqQXPCiPjsXrFw1hrEncVCCp3wakdeXNG5h/5xlv63m5IFvzuEISt4Dz4IJpYDIi6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742385611; c=relaxed/simple;
	bh=3Q0bbLuhtK55WnjrmmpP53tH6DA3R1FY/Vlv7W+SYEA=;
	h=Subject:From:To:Message-Id:Date; b=bzcQi9BERbOAB8CWk5XLTAB0bQGc7BxamiU1fysFcyoh+q2uAlbPZrGS+DRSHP22ktu1EtLCtt/ny1b7ohPsDMwG7Q36naNOLFz9KJhpNqYahULUarzRL7WmF4V4isgRcDgwEOPR+OwRQ9p2WuU02JWGhHQJDPHEKkZPtCA4u/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=naHks13N; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="naHks13N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=FuTiUhDVypei1Tx+cEtwTWFy/5xo9FCX2T+DFi5HXA4=; b=naHks13NR08dzN+xzLLvj/EMAo
	A7mygRUGPZQx4bC5CZAMTUcH1wCkAnJm4SDVMSSm1re5ieL64y8B1Y0TO7bkEI5M+2IFj80XnITn/
	cO/vIMvaDFtByiRo1Tr8UOrQiWZ+bwFT+GBCT9mbulk6+tt0iEB0s+4YtJvB0CJ3oeGW1KmgJmJnR
	nK6kdc8UDX8Fi7YeCrWlYGM5AP4eJToDktdZfQjgQtUGEmqQDOPEGYae8Kwotb9Imm6ycWKrCgDsZ
	DohsAtAGahEofDu4m01fecG1rDEfQtHPkcLse/AsB+JNQjviqMAAvqMgkRLENoHddbzTk2IsSXTw7
	xN8OeHww==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tus5c-00000009ZcZ-1LKy
	for fio@vger.kernel.org;
	Wed, 19 Mar 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 35A311BC0161; Wed, 19 Mar 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250319120001.35A311BC0161@kernel.dk>
Date: Wed, 19 Mar 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d2a4910bbefcb3ddecf2868a955ef27ec71286fc:

  Merge branch 'dfs' of https://github.com/henglgh/fio (2025-03-07 11:39:42 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 58818df7b0948d36ba9743160a1f570700d2347d:

  Merge branch 'iouring-spellingfix-2025-03-18' of https://github.com/proact-de/fio (2025-03-18 07:14:24 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'iouring-spellingfix-2025-03-18' of https://github.com/proact-de/fio

Martin Steigerwald (1):
      Fix spelling error in IO uring engine.

 engines/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 983e32b7..08f220c8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -180,7 +180,7 @@ static struct fio_option options[] = {
 		.lname	= "Additional Write commands support (Write Uncorrectable, Write Zeores)",
 		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct ioring_options, write_mode),
-		.help	= "Issue Write Uncorrectable or Zeroes command instaed of Write command",
+		.help	= "Issue Write Uncorrectable or Zeroes command instead of Write command",
 		.def	= "write",
 		.posval = {
 			  { .ival = "write",
