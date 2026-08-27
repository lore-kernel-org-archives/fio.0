Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3DB40F750
	for <fio@vger.kernel.org>; Thu, 27 Aug 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787832011; cv=none; b=Nu/wDVkMq2kIYcNd/xLLqAk4tp0WB5pm/CUDeLKzCz/P+crOlY592IBDbB6KJ3Jz80EYLlJjHtYzR8Z27qlpUzubd1l6orI1j19D6CXNjdOzbClEIcTeiXUlUn8xV4olb8DWFxIPuRinEQd3K0zubAiSyJiprr1NavJqUe9Uh9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787832011; c=relaxed/simple;
	bh=UbF0+ICLqBzPG0gtKW1lN6pIzBwn4Mdr+3UBvVemr68=;
	h=Subject:From:To:Date:Message-Id; b=WR6va6KP9w49pxNV16hu8sNt9kTuBGjAyY6MthwYXBU2I9LnBMon5RV3yelWXcsp3j0DPa8aIVuwPWVAhKKLv92eSU/hP0kNYScOBs6f8OG8vuRx5GKBQluFbAIQLLt33gX6R+slQ10iSvQq9N6kUXK7gJMkBWEmesjBupe8kp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Oux/i4SP; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oux/i4SP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GnW8ePWZ2fs44kKIPebHcEC4T3ws5cQcHuxwjUKcY5E=; b=Oux/i4SPD2W099rmGHWmQFjYVv
	PF9dwUlPewgr19WrWSvUh1ODIWGAjgzV8h3G/J2YwWZk5Orm1cH+G4EBAQdErBfJLlBlGfdgHMgYo
	/uLItJANpsXgaC91RKJ4tKHDBY5eGXii9pA/cjUnNL9lWJhrgFzTuBnR1JJuGhnihoE61onEztPY5
	TzqMiW0Ppjrg6wSSHxiXrt8yzDFbnd5Ew/PAfyTVW2HVZ65p6z/ad+1hpwaqFlG+FhwqPM1hRFjnI
	sfRqsL1KcwdTdGobkPF7ftOgwEJvw2YUvdYTTMLihDwZd3se1a+jVG7rnsWcLKwRCtoLkK07wvADw
	UOcAr28w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzYm5-0000000ClbF-1KJY
	for fio@vger.kernel.org;
	Thu, 27 Aug 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 74CF31BC0157; Thu, 27 Aug 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 27 Aug 2026 06:00:01 -0600
Message-Id: <20260827120001.74CF31BC0157@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 93ab5b9771768dc99cef9550a75f74c5948eac0d:

  Merge branch 'reap-signaled-worker-exit-code' of https://github.com/Vladyyy/fio (2026-08-24 15:42:41 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae35a58399b28edf857f7ebc43b3eb40d86ac29b:

  Merge branch 'verify-zero-dump' of https://github.com/sarthak-k/fio (2026-08-26 16:12:53 +0000)

----------------------------------------------------------------
Sarthak Killedar (1):
      verify: dump the received buffer when zero verify fails

Vincent Fu (1):
      Merge branch 'verify-zero-dump' of https://github.com/sarthak-k/fio

 verify.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/verify.c b/verify.c
index 633a9bb2..a978aff0 100644
--- a/verify.c
+++ b/verify.c
@@ -891,7 +891,7 @@ static int mem_is_zero_slow(const void *data, size_t length, size_t *offset)
 	return !length;
 }
 
-static int verify_zero(struct io_u *io_u)
+static int verify_zero(struct thread_data *td, struct io_u *io_u)
 {
 	size_t offset;
 
@@ -904,6 +904,15 @@ static int verify_zero(struct io_u *io_u)
 		", block offset %lu\n",
 			io_u->file->file_name, io_u->verify_offset, io_u->buflen,
 			(unsigned long) offset);
+
+	/*
+	 * Only the received data is worth dumping here, the expected
+	 * contents are all zeroes.
+	 */
+	if (td->o.verify_dump)
+		dump_buf(io_u->buf, io_u->buflen, io_u->verify_offset,
+				"received", io_u->file);
+
 	return EILSEQ;
 }
 
@@ -912,7 +921,7 @@ static int verify_trimmed_io_u(struct thread_data *td, struct io_u *io_u)
 	if (!td->o.trim_zero)
 		return 0;
 
-	return verify_zero(io_u);
+	return verify_zero(td, io_u);
 }
 
 static int verify_header(struct io_u *io_u, struct thread_data *td,
@@ -1018,7 +1027,7 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 		goto done;
 	} else if (io_u->flags & IO_U_F_ZEROED) {
 		dprint(FD_VERIFY, "verifying write zeroes command\n");
-		ret = verify_zero(io_u);
+		ret = verify_zero(td, io_u);
 		goto done;
 	}
 
