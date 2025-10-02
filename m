Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB41C2F4A12
	for <fio@vger.kernel.org>; Thu,  2 Oct 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759406411; cv=none; b=Vba61tzTrNfC9qhPVtQCfXgzspdgn79VrBwRjO7ArwIwBv/IT3zQGhX9l1SahNsPo/Qa93IDmEgzyRmnliU+/J5LyJwSPFHUzguBtNu8peS1pYaX2Igo5UitU6Gb/TjGzW7B712HsnPdSb8Uqnf66LHZGRP2n7yFetGVyMYw+Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759406411; c=relaxed/simple;
	bh=OdzVD54kSnTSw/akHNpBfI1mPzTrqes4FaqcPTLlsIQ=;
	h=Subject:From:To:Message-Id:Date; b=Vh8JaYvSQ0H9DCHG/CSHc7qspk1sFfNSML9HwA+btEumptqBp0YUglvjDS5kew6DRSu+zHsbU4Jg+TkE2ktBA2sGC39T93ZDuBhpaVjo9iIZBJQ5mBP8/+tzOYOfWWXi79Es7SHs/8Vnuqktj9UTMGn2HeZrOjD8oxaQt3hXIgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ooVAqYUm; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ooVAqYUm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=aumcWRtd6IOoRQWJYupKuJMwJrc2a+DXYbqcDYlYnW8=; b=ooVAqYUmAE4LNI9KO/plzig6/G
	L/II2qJXXdMzEeD9NsB8nSAzQR57T6SfCofrPjIalz51eebbYKyfVQZgR9HErRY9Z0sWRKGSY/3C+
	BVXQeiyXtcJNV0kLJLezwFyCoBeSVhZQX8/huEJm0Yt0+4/QsuAJpLbrb1uveZWat+pe2TiotMGk9
	o/1O1psVZBlS9aJvWjAQsCngFvxTCg0R/hD1mJsYzK5kafFJ3a1QkOh7ENA35O0OFvcrv1QubLCWy
	3ghEzLSbGyyZ3qe92bCksLZOmTIq+2rKuQrGhDVO7GYRruePjjTjRoVzi016EpvwWMnYEENDDYQ7+
	p5JLxADg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v4Hye-0000000EGLq-3JEe
	for fio@vger.kernel.org;
	Thu, 02 Oct 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C8CB81BC015E; Thu,  2 Oct 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20251002120001.C8CB81BC015E@kernel.dk>
Date: Thu,  2 Oct 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit cda225765af700722a1c621aacda2ceb45929e52:

  Merge branch 'master' of https://github.com/kaimeyer-arcserve/fio (2025-09-25 23:06:37 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 97a91b6a69a633d55d8bfa31715fb0434709f223:

  Merge branch 'fix/io_uring-pi-validate' of https://github.com/stanleyzhang9/fio (2025-10-01 15:02:38 -0400)

----------------------------------------------------------------
Stanley Zhang (1):
      engines/io_uring: validate PI on read

Vincent Fu (1):
      Merge branch 'fix/io_uring-pi-validate' of https://github.com/stanleyzhang9/fio

 engines/io_uring.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 02f80bda..89f44044 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -686,24 +686,19 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	if (cqe->res == io_u->xfer_buflen ||
 	    (io_u->ddir == DDIR_TRIM && !cqe->res)) {
 		io_u->error = 0;
+		if (io_u->ddir == DDIR_READ && o->md_per_io_size && !o->pi_act)
+			fio_ioring_validate_md(td, io_u);
 		return io_u;
 	}
 
-	if (cqe->res != io_u->xfer_buflen) {
-		if (io_u->ddir == DDIR_TRIM) {
-			ld->async_trim_fail = 1;
-			cqe->res = 0;
-		}
-		if (cqe->res > io_u->xfer_buflen)
-			io_u->error = -cqe->res;
-		else
-			io_u->resid = io_u->xfer_buflen - cqe->res;
-
-		return io_u;
+	if (io_u->ddir == DDIR_TRIM) {
+		ld->async_trim_fail = 1;
+		cqe->res = 0;
 	}
-
-	if (o->md_per_io_size)
-		fio_ioring_validate_md(td, io_u);
+	if (cqe->res > io_u->xfer_buflen)
+		io_u->error = -cqe->res;
+	else
+		io_u->resid = io_u->xfer_buflen - cqe->res;
 
 	return io_u;
 }
