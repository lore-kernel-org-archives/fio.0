Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE99D2737E2
	for <fio@vger.kernel.org>; Tue,  1 Jul 2025 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751371217; cv=none; b=mzaTQ5dcJYrGwQ6y2ppae+fPflU3YVaUg49YW2WU/JXl/TPqwgjTcEKk7cJh5qwzxJa+nqceOxwizF9/WjOETtma5ysuMdaxvM9w2kywcb5KUoBKo/6Ga8jgtwfilxlJLy3UCY0nyP4Ngl6n1ceZ8i8PurhmGEU5B6WDoJ4168A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751371217; c=relaxed/simple;
	bh=xLBErME7I0Yw+l12xH5531UxjdCtrFueF+L7XCgh+Uc=;
	h=Subject:From:To:Message-Id:Date; b=uIg4UmNwOAjaKI/+BIc67Me/jXQLUEhsgwrcD6Poc/UET6Np50wo1UC/S6aOPRRtjmcN+KhtvF+0v7fKIjLJxJosyirObtDjcXVX2QDD1ybxVZgmSy0rSWCSdS19QozSGZMADsB6DqoFNSxw5i0a5hUItn0VLTd6mAeU9x6RWj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JBjk4EHM; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JBjk4EHM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=8k/3AkMtL1DNASEEVPGc1b5AgP4ZhpzpdfsvbeWVD9k=; b=JBjk4EHMOH/AtrfWwL20gdDhZi
	rnFiupxPX0wdDudwPDthnBYPCiMjROGFEgmwMU2aHPzVUprtLXmpUJilustE5yk4J4XSmskANdwGg
	kmC0k0Ih1e3Uj8WTrWhICI6GPYENIDgagTI0Mg3/7G6wFr46pej8W0knYMOe9dFTOWjYcNa4mbspX
	Woha74dSHmXO3YgLAncy9cOtt5No2qtFIpjKlcyAahB6Ms/2GyHx+O2BM9m3o3jDpbJrFYgTDO6qx
	I6SGOZ++TMEhQOaOh3tDjtmWT6S7omfIWKvzNLEJ4MFKyN3ozOT5sAksHFi9SvCqzHDCh59MmOwC9
	KU72i3Xw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uWZef-00000006qTg-3FNU
	for fio@vger.kernel.org;
	Tue, 01 Jul 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D37231BC0175; Tue,  1 Jul 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250701120001.D37231BC0175@kernel.dk>
Date: Tue,  1 Jul 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7037b833e175aae32900b73bf597aad08c1d8472:

  windows: drop nanosleep and clock_gettime (2025-06-23 15:04:34 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5db7e6b26bd07824c6207dcbac1a8e7a95a3f20c:

  Merge branch 'fix-randtrimwrite' of https://github.com/minwooim/fio (2025-06-30 07:42:00 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-randtrimwrite' of https://github.com/minwooim/fio

Jungwon Lee (1):
      io_u: fix offset calculation in randtrimwrite

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 70a11837..360bd774 100644
--- a/io_u.c
+++ b/io_u.c
@@ -431,7 +431,7 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 	if (td_randtrimwrite(td) && ddir == DDIR_WRITE) {
 		/* don't mark randommap for these writes */
 		io_u_set(td, io_u, IO_U_F_BUSY_OK);
-		offset = f->last_start[DDIR_TRIM];
+		offset = f->last_start[DDIR_TRIM] - f->file_offset;
 		*is_random = true;
 		ret = 0;
 	} else if (rw_seq) {
