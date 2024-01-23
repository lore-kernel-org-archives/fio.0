Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE0456768
	for <fio@vger.kernel.org>; Tue, 23 Jan 2024 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706014817; cv=none; b=lHvlFm7cPu8VvoF2hKNfmdnhKc7nk35D2oyjOMCbSVive8KzHNwMRQMN4EqaboBy9HutW/TPy8UvUWzcUQwUa0NLRvMrr9fGDu1ndXMx902TUGHB3U+KyKwnKuypboArKAZDodK/u5k6gwQuG9VWjuXbnfIFxl52QawCpIobW40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706014817; c=relaxed/simple;
	bh=Ki9Jb0SBPh0KvvVsTZKKtRsvJBBIDOJ9rvWUNnmJGnI=;
	h=Subject:From:To:Message-Id:Date; b=JSnUauzp+qYPQpUA3j3/NNQR9IDsj4PmYozpYpqbd5EVEty0CKJFxSwapUTadmBnddbHedmZuya81ZMBEd67dw1ss+WIkz+nrjWufwCr3qRolR2OUMrNZJ+WcsVhdorerTOSFB9Yl+Yz9xjbF1d0pjOfTL+4SqZRl38y/YyaV0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KQSpo8Le; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KQSpo8Le"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=sGFKhbH0uW7JxaIHtcoSrX4XTi+Xxhsi9uqQIVi6B1Q=; b=KQSpo8LeOCSujTOalp2giZVblz
	fSN1doBArvUnKztC2WG+EvbTZyuenIzY96+KTxVV7NDfnY2/vkXmJetGfTC77IGbnea4ZUuQrtJ5C
	60Zw9UtUmBgME9Eb8yZc/hQ/kAbV3qAJVU6v4IVjP/hO7uftWG0R1BLlCzASzflr8bSvM9Sb0gdWX
	yJbXa/AerUnpXlnXw5BRXZTow20SZ4ukgh5WiAn7iQDPVXlg8KVW82rH/YfM1ojneMtLbJ6kw3Oqe
	B6/uDgfoDzbvBO7ZLXiSetA+IJ2jJ7g+7mGPwGU4Gl0AvCGA+zIkqRuoiT0udkK5Fv8UJPlhD1QTs
	nzVVuh3g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rSGNu-00000003s5J-0MXJ
	for fio@vger.kernel.org;
	Tue, 23 Jan 2024 13:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 91A301BC0156; Tue, 23 Jan 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240123130001.91A301BC0156@kernel.dk>
Date: Tue, 23 Jan 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit aa84b5ba581add84ce6e73b20ca0fbd04f6058c8:

  ci: stop hard coding number of jobs for make (2024-01-18 13:00:31 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8b3190c3ea38af87778a68c576947f8797215d33:

  filesetup: clear O_RDWR flag for verify_only write workloads (2024-01-22 11:51:05 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      filesetup: clear O_RDWR flag for verify_only write workloads

 filesetup.c | 5 +++++
 1 file changed, 5 insertions(+)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 816d1081..2d277a64 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -749,6 +749,11 @@ open_again:
 		if (!read_only)
 			flags |= O_RDWR;
 
+		if (td->o.verify_only) {
+			flags &= ~O_RDWR;
+			flags |= O_RDONLY;
+		}
+
 		if (f->filetype == FIO_TYPE_FILE && td->o.allow_create)
 			flags |= O_CREAT;
 
