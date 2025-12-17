Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C425E35971C
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765976414; cv=none; b=IdPBjI55oebK1LxoX6mphMGzyqLrHy6r8fxQExPgA1qnhzVsUMESmKEYWdVHiH+S+LpG9eoKFip9TajYf32j0O883qn/AMlrgMIfdnvtz4CmL9JYgBrmU5ELFqrvNi+H0LdX2J0fIfMvqnwkKp7OqoRHVfzOOa4DCSBjtuzOuNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765976414; c=relaxed/simple;
	bh=lT5Bik7itejwAXGymVuQiUtHlWnkVN4M8/219gV/eXQ=;
	h=Subject:From:To:Date:Message-Id; b=gPPFShKyP/lZx8e7unZYRnK1K6eNE7XKeBsbqgkeBOqY5MLq9uDmHt6NcvxVpNq35znLkmNG0u3kP0TWQ4VIQAh88bj5wkaEjHaezmtKm2fhWKyREN5J66fzKxowwntrksusv9M+Z5UHeT5POc9tIp7n8dTtFsKFest6TuaMPJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ItWkqkVW; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ItWkqkVW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=mO3z5nBvi7HrcPVFTN3knQ2nAfRhSunJFnrUmJbFhHw=; b=ItWkqkVWAiY4zbirjODtgfej48
	pqkntm52hVvusiCkK6HSLoXVbIpJxrr+lqfh8iIbqovvPFHG7WaifhPLOedsNr3q9g2hw7nCx5vec
	x66o782PC2CupKMggqxjebs3P3Gx0lXW5ue09Shmh8rhYPN4/VBhPHz3uBlCM57eZjxMKGXXn/h3L
	N+DvzYelHxn9nAMXQ4ekp3ZWfMwKK/okZrXhZyd/rS39v8i4WoDhtpK3qVi/4H2bY2Yc9MS5vgpO6
	iiAnsfN0SdYPwfEhHbHqsJhwWlF3JnrM/EbKnmk/7iBObsm27zJCkW9ZepVPywzygCNM06YfbzE0M
	5MIA+krQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVr8S-00000004jGi-0p2K
	for fio@vger.kernel.org;
	Wed, 17 Dec 2025 13:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 27A951BC0192; Wed, 17 Dec 2025 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 17 Dec 2025 06:00:02 -0700
Message-Id: <20251217130002.27A951BC0192@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9af9614ba9578a61f08d0b780441d122790d4fed:

  Merge branch 'baloo/push-lxolyxxkxkpv' of https://github.com/baloo/fio (2025-12-13 23:29:10 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3a4c1dd89241f5aff2835047a166dde19ae796b3:

  Merge branch 'fix/prchk-segfault' of https://github.com/calebsander/fio (2025-12-16 13:10:09 -0500)

----------------------------------------------------------------
Caleb Sander Mateos (1):
      io_uring: don't segfault if pi_chk isn't specified

Vincent Fu (1):
      Merge branch 'fix/prchk-segfault' of https://github.com/calebsander/fio

 engines/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index bc29d3d8..6c3eb43c 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1593,11 +1593,11 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 		pi_attr->len = o->md_per_io_size;
 		pi_attr->app_tag = o->apptag;
 		pi_attr->flags = 0;
-		if (strstr(o->pi_chk, "GUARD") != NULL)
+		if (o->prchk & NVME_IO_PRINFO_PRCHK_GUARD)
 			pi_attr->flags |= IO_INTEGRITY_CHK_GUARD;
-		if (strstr(o->pi_chk, "REFTAG") != NULL)
+		if (o->prchk & NVME_IO_PRINFO_PRCHK_REF)
 			pi_attr->flags |= IO_INTEGRITY_CHK_REFTAG;
-		if (strstr(o->pi_chk, "APPTAG") != NULL)
+		if (o->prchk & NVME_IO_PRINFO_PRCHK_APP)
 			pi_attr->flags |= IO_INTEGRITY_CHK_APPTAG;
 	}
 
