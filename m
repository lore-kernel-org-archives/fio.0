Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094D82DF6F4
	for <fio@vger.kernel.org>; Tue, 25 Aug 2026 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659217; cv=none; b=KHP4/aAbTsNfaXie6I88u1cvst6dLlSavPwLWgN/hhg6XI57i6xaDQK8bkxOnYVSFiUgNzzhbrsoF/Uq7c1JreRnoY9jWJ3BKCcuJl0PB8zFXl8YnK12M3xoxj6o5fYVm6V8OK2wdWIFwME3m46qP5HatU6jokuCAKvTH26Zn9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659217; c=relaxed/simple;
	bh=QdqV0C3d/m8cb224WefTKIj1B6B/z4dnZAy0s6VjjlE=;
	h=Subject:From:To:Date:Message-Id; b=EWSrtnxrB0vaTk9LqUjGFHF80u/O/AYJpkRpoOCs0mKXDT90iRFYLuFscrdgH3P9TtXvrGGiLjWSSv4RJL53Vz5CVC0c44SXKEO/xo1Poh+da+cWVl78BHew8fiiusEmUtQhueV/GZsEcVQV5Y06dSeOU7Nh4IIlM6upymecMy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nGFYhBb6; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nGFYhBb6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=AUHVlV7v8L6Jr4twWtLJXvfk234JheOcGHJtEZ2v4aE=; b=nGFYhBb65R0RS5k3neo6EEeTBe
	YzFV4C8hExBPnxhKJ2ja4mD4zH/2LtHSXHjh9wv/JLeLfdap2XYvf15dcN5QWX7WYiuHBPydNebTy
	9Itk/tDjj2N/Imn21vH/YgJjhO9s4cehvAxIL0ZVyw6yc8TxHjVnJ8LjcEp8Tgp1KYKysWoX15t1v
	rv3X55NIaUOcPSTGEuOHi1lgCamQt4QEIGbA1kreaErMnrrl+0hakB3i9oFk5AL5lvup7EJXh7W54
	G2JoytEJOFho302o2yKk682p90LX3u85Iq6suwQQDQci3fSegjyfxEIczw/YBlbRKEi7Zm4YO8Q22
	Gmo2M4vw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wypoy-000000092p0-3nPJ
	for fio@vger.kernel.org;
	Tue, 25 Aug 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 81E781BC0165; Tue, 25 Aug 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 25 Aug 2026 06:00:01 -0600
Message-Id: <20260825120001.81E781BC0165@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f5344384f7c7b6e9e6aa9336e476e8f6eb54dd3a:

  Merge branch 'doc-fix' of https://github.com/Panky-codes/fio (2026-08-21 12:31:33 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 93ab5b9771768dc99cef9550a75f74c5948eac0d:

  Merge branch 'reap-signaled-worker-exit-code' of https://github.com/Vladyyy/fio (2026-08-24 15:42:41 +0000)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'reap-signaled-worker-exit-code' of https://github.com/Vladyyy/fio

Vlad Tudose (1):
      backend: exit non-zero when a job process is killed by a signal

 backend.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 35f522e5..2b419b12 100644
--- a/backend.c
+++ b/backend.c
@@ -2449,9 +2449,12 @@ static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 			if (WIFSIGNALED(status)) {
 				int sig = WTERMSIG(status);
 
-				if (sig != SIGTERM && sig != SIGUSR2)
+				if (sig != SIGTERM && sig != SIGUSR2) {
 					log_err("fio: pid=%d, got signal=%d\n",
 							(int) td->pid, sig);
+					if (!td->error)
+						td->error = EINTR;
+				}
 				td->sig = sig;
 				td_set_runstate(td, TD_REAPED);
 				goto reaped;
