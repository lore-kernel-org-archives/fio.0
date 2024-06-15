Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1B922318
	for <fio@vger.kernel.org>; Sat, 15 Jun 2024 12:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718453045; cv=none; b=buHA2hgulVT32dn1Og8CGb3zsnHfJowZPtX1WVwW2eTemBj0sel9MYfDDHxIerBuBuECdyhkbxMuSCkvTjX7qR5fYa8trvt45j6pMsqPyFbx3fy6StINV4aq4hW8h/juaT/jWjPwdJpgB2czR0yKgGITnPw9oyGSThSFhuL1waw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718453045; c=relaxed/simple;
	bh=vb7fc4A/ERa3QAH9ikOjh16+tuM9m8eA4qnAg1/aGQU=;
	h=Subject:From:To:Message-Id:Date; b=T21GBfdvJrvD6AAiYBiNA33Mcc5dJmvTyt7qLCHhSr46dJMD2WBckoyqEkFrpWrZTvNlpx8Hu8qS+GDG11ERhBoyCs7WmFN3wSGxBVDvtC2reHvn8csKxrgCAqKirFYd1D81la04yYMHk1mLjBP0uu9B9X/ZSpKAm60iP0S3z+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZLlVZAMq; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZLlVZAMq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zXuqZhw44VPOsi9+dVriH8HvwLa2y+on+T6iBO8pFWI=; b=ZLlVZAMqYflu3RMmemBBrpBZdX
	koM04g6MWvW1BySFpG2RxR2Yrx9a+4uoBa8OnIwXoHmKYLJ/fdMoLTJNNzC7LKb3g4/aO9/CbQ/lC
	d6kRSdb4bsA9H9DWtUqrD9Ie5Pg/C5qQlrAv8XhFQE5lZPCr4k7aqtAcVUqplYdtwLXshmK3mNjop
	/A3W+4khrflnl7yW+b6hRfdIG76fqu8xTZ6+KSexK8rkH7d7V/tJFQEMgGXd+hwavS8BKwou7ybjH
	ZzaapGM8TAVEWLtC2VAH4ObGBc/lFu/kMLW7ohiVY9myDQyZWbaaUdH7digJAu0krL/OSObsl0Vly
	p8n88oQg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sIS5F-000000050Bd-0LfO
	for fio@vger.kernel.org;
	Sat, 15 Jun 2024 12:03:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5B3971BC0139; Sat, 15 Jun 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240615120001.5B3971BC0139@kernel.dk>
Date: Sat, 15 Jun 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit bd7492a47a5bb0ec66a05ae0cff0c9065afb0f88:

  smalloc: add a comment explaining why scalloc does not zero memory (2024-06-12 13:06:09 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 05a52be478dbbaa73d7ef563133125b24c001f1c:

  Merge branch 'nfs' of https://github.com/panxiao2014/fio (2024-06-14 06:19:28 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'nfs' of https://github.com/panxiao2014/fio

Pan Xiao (1):
      Fix issue when start randwrite by using nfs engine

 engines/nfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/nfs.c b/engines/nfs.c
index ce748d14..6bc4af1f 100644
--- a/engines/nfs.c
+++ b/engines/nfs.c
@@ -280,7 +280,7 @@ static int fio_libnfs_open(struct thread_data *td, struct fio_file *f)
 	nfs_data = calloc(1, sizeof(struct nfs_data));
 	nfs_data->options = options;
 
-	if (td->o.td_ddir == TD_DDIR_WRITE)
+	if (td_write(td))
 		flags |= O_CREAT | O_RDWR;
 	else
 		flags |= O_RDWR;
