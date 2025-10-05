Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEB0208D0
	for <fio@vger.kernel.org>; Sun,  5 Oct 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759665612; cv=none; b=myRMYPNnCqnzeHsGCtXLx/dhfBIkjboJRpJH8Xuy//cPg5094YhnAVQmBxgQ1IzQtt3SKVftAwXaJEaIVo7nfKDA2oK7utwXE3AcafOEqu0V2UxeeLDEbl7WvAQyYUZkRKCq1woESrI6Sj4Gwj9J8YUH52x8Z7yxKYGtCJEdN/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759665612; c=relaxed/simple;
	bh=IpFW8oPmqPskUrGa+H52zGTj0H2JgBS0qxdUwI/g3Rw=;
	h=Subject:From:To:Message-Id:Date; b=kp5oH/tjbQcDKELAgbwJmMvdkkpVsZkyOwWQCSHXmsOp1HQpghB4AON7fcZ6rJjzU0yuu3pqMVijB4AP4VQZt0HkD11pUNxzokDNDtE0i9KoyQBIpRFw80UWh+HH3evt8NDJSblCxI97j7EGwwW2RTNVl9ZrTCbDuT8wJMBHtWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VQ5QNbis; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VQ5QNbis"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=aPrm3SNC+5Wq3lOMNitp4kJORxt8KbuGl4j9hrhzKkc=; b=VQ5QNbiswuc1ZFqcCNyQzAOJRT
	U/I7V7LtwzJ5DWrgspd0W0ea5FWOa6osig5KOsdLovU3musjAhr4v/Tv1iAGjndGsFX++WmbOhXqH
	dhG29j71wj7FApRNpHCPhMxdQupFFQ6240ixZAMAgru6TH2HXAOgbpxuvYE21MQjsfKeM2yXaujj/
	k/YjJjiQnW0cGMfLnh8iKm+wBR2RYjHCWC3i9SJtzJ98SBSk+WaQQlE/qh8UIszP1OEoG6Wc2DpZ2
	3POu1uGrkSuskWUGljuUyhks1nPXx/nvAW9+RpUOdY3wOLPbwRFGh+dsL1Pm7f1i5cEsxYIqOfBHu
	falyNcuQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v5NPI-000000088L3-0tOI
	for fio@vger.kernel.org;
	Sun, 05 Oct 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3432A1BC0140; Sun,  5 Oct 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20251005120001.3432A1BC0140@kernel.dk>
Date: Sun,  5 Oct 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 97a91b6a69a633d55d8bfa31715fb0434709f223:

  Merge branch 'fix/io_uring-pi-validate' of https://github.com/stanleyzhang9/fio (2025-10-01 15:02:38 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9806424ae0ce388c8dad1687864b02dee3d8e0d2:

  REPORTING-BUGS: add note about reports on malicious job files (2025-10-04 16:57:44 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      REPORTING-BUGS: add note about reports on malicious job files

 REPORTING-BUGS | 7 +++++++
 1 file changed, 7 insertions(+)

---

Diff of recent changes:

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index c0204d7e..17c4fcaa 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -1,6 +1,13 @@
 Reporting a bug
 ---------------
 
+If you're contemplating reporting issues with deliberately constructed job
+files that cause the parser to crash, then only do so if you also intend
+to fix the issue. Legitimate job files that cause parsing issues should of
+course be reported, however please don't waste our time with maliciously
+constructed job files that cause double frees, fio crashes, or other effects
+of that nature.
+
 ...via the mailing list
 =======================
 
