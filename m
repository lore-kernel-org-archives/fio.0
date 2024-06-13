Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098FB1459EE
	for <fio@vger.kernel.org>; Thu, 13 Jun 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280014; cv=none; b=i2D6eNC2xRNinvhlXUpbhf+pm3xb8vQsIXx7/yKtfm5ediXb9ouhiUFVyt+JK2Wj3LRO6VOrx4gu8Wdslm9daYQX8zdnUs40CZB0gQxQYFb/qLu4ZAnYBy8bHmAfGca3mlsoG3sYrhXUwYxe0Cauw0+BYztVUN9Z8aW9/dNGrwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280014; c=relaxed/simple;
	bh=kh2phBq4boKlWew/8Q4jHkcflf/4DJyR+pQXBWIUbeI=;
	h=Subject:From:To:Message-Id:Date; b=ocxXQDVLq7khCOx+/jYPIogTLY1X0HHJk7CNYB1u3CiPZ4ZYqUFGquYOHTpknUUc15fvTsurGmIZqJWorp8rBHTgGBNOb7A0qM2Pn4Kmo0+SnRmyUSa5u7Ovv2VbU5lrSvLSEnljLry+wKbtFQp0csRLO0ls8OBtR2fO36t4v5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mWY+EFad; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mWY+EFad"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=SJNM8kytuuBK2wbDjhM9KAiVfzb3ar93TLh2NKyxAU4=; b=mWY+EFadgvD2T66y/jxO+RMVeP
	aU9xrUQo7xpl4yaF4kEe9EWK6nvSFrcp3B1o/YUGgCYJ9CXvN5PZuXo0YnL4vIOn4SAitCHddMgDM
	fY6rOfwKfu3AY9cOnSsi8i7YHULD/CZykFTQfgxcV8TmBwCuOojkxA+3PiCC3tITCUYlXKKbimKD3
	7KLVRAjjX680UtvFufK0O6vJmQx4n5le6jjv05f0C2D4eRh+5QmI1ZK/J9i4HEuPjOYqgI6I9rABn
	ep+h+gXS5tSEsF6cnnE2hLoxPY4h9DsdWGdiII7em6kDJfX5A/kciowfcz8IHqKMUo6LBCp6kcYS1
	/OZ0YG5Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHj7c-0000000Fim1-0P37
	for fio@vger.kernel.org;
	Thu, 13 Jun 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 17ADE1BC0185; Thu, 13 Jun 2024 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240613120002.17ADE1BC0185@kernel.dk>
Date: Thu, 13 Jun 2024 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a15118757dad19c7f17700903d169676f244e318:

  helper_thread: check for null scalloc return value (2024-06-11 16:19:38 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bd7492a47a5bb0ec66a05ae0cff0c9065afb0f88:

  smalloc: add a comment explaining why scalloc does not zero memory (2024-06-12 13:06:09 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      smalloc: add a comment explaining why scalloc does not zero memory

 smalloc.c | 4 ++++
 1 file changed, 4 insertions(+)

---

Diff of recent changes:

diff --git a/smalloc.c b/smalloc.c
index 23243054..ac7ef701 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -566,6 +566,10 @@ void *smalloc(size_t size)
 
 void *scalloc(size_t nmemb, size_t size)
 {
+	/*
+	 * smalloc_pool (called by smalloc) will zero the memory, so we don't
+	 * need to do it here.
+	 */
 	return smalloc(nmemb * size);
 }
 
