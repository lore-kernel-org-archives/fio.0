Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAA426560A
	for <fio@vger.kernel.org>; Wed, 21 May 2025 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747828818; cv=none; b=ZzYSubNk48WEJNFkmd82Mm+viBiglvpM7R5tP7R2aq1Fopwa5BCj9W8cFQPVX6PKCe9B2tIlqc3k6qrJQpDQbu03Rs3u4NmewXyoZgQSESnSojj8Vzj1Pnp67U30BxbTgmH7F4pR9Nxv3akL0oj7iDkrBxRUNM7EufspHzJcqTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747828818; c=relaxed/simple;
	bh=HWXOxIMTmrOIkGvKUNHelS1UU6f0GrCHuLnU7fp5r5U=;
	h=Subject:From:To:Message-Id:Date; b=VNJiWWI4+VyuFRxhTXuDtSddO+OY8H/hCKJahN3tdK9Xisrn5GjgGVlom72TKw1CqJ7RcL7189RxqWKPv8G4rQA/8UqmKKWpmHi5Scc3WwjPenhDCOx7LIdB6obcL1T5CRTn21Jw2lpXJaYYphBw+rPJNGy8Rl70ET3glSEOv0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dI+dBaNh; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dI+dBaNh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PmK5Jus+HNv7T6gS76YNmBaIVta05kmwQeDOtoiDiZc=; b=dI+dBaNhKu4YiluOgCKqLWwUOZ
	zPc7p955BfQ9otn70vU+EfegbqZES5A4onjVtnPyAoDTZYdJLLtLR8fLISh1rKgb4YFmaSe4bnmc9
	+gctcZAnXdyRMJdzGyid5ERvZXUhiVSSdBWI7x03qJAavPSVOorSXw8mqsCCGL/hPCa+aa61m5Mnq
	t2xDZvJuSEJeLoysRFwpM1kxIONbMXmJpD9yWh5lqKC01CbuOPsjNYXCojKGd4WM8DnBT5Y3gSyRW
	x6tbwHBN2PpBIorUh3BFb5n0EMD3bS303luWU7DfktkzbSTwPViihb4DNhu5LDKwtpEf7AMeANKNj
	At3FjSzA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uHi79-00000004cc2-3oC7
	for fio@vger.kernel.org;
	Wed, 21 May 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3C81C1BC0161; Wed, 21 May 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250521120001.3C81C1BC0161@kernel.dk>
Date: Wed, 21 May 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit fb253b221687439c92a0ee147427d70a4e36e28f:

  t/verify: add tests to exercise verify_pattern_interval (2025-05-16 12:09:30 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ff930c4653ae3952d6b09ab3ec89671aeabf2cbe:

  Fio 3.40 (2025-05-20 12:23:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.40

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 623fd33d..f9db3568 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.39
+DEF_VER=fio-3.40
 
 LF='
 '
