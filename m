Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4C323956E
	for <fio@vger.kernel.org>; Fri,  1 Aug 2025 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754049613; cv=none; b=Q8bvkc0/X6dLQc7R+iWOWY88/ijbLWBwJJrvoyb7ZEpzd5QnfrF7LC3DqINGGzQRdms430WObuXsh3wKuPcYoseNSoNKQ0oTlloAftS1VcIjzBD3IiHyCuCugiwnnWzVBy557AKP31CZFYFiCrpTOk+CZTuNwRylg+zUkij8jYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754049613; c=relaxed/simple;
	bh=L+1M+IZZktJfOB2Y7PrzojU+k4rcr56g012Qm0r8m34=;
	h=Subject:From:To:Message-Id:Date; b=uRK4JLr0xWVZTMpyFodtpo3h5RUi18KKwtFxEQMJMiGW0EW6F4wzkeQE9oJTIJBLAF/2kWjYMCPIMUXHdFHXOrHf/GwY/QWWFOer7aeQXfx8PE4iBN4D5u/xTd2Y9nl8wLN3Sqou9cB7PBvkUsQomP3daS1/nMIAxXd+Dzc5D3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iUv9SWwt; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iUv9SWwt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rrZ9JC4PwSdLvX0ClCS0L5X5JiY8a8xFY3Oi6G5u+V8=; b=iUv9SWwtUABof4u3Kan/Aw6cgz
	azQ9IJFAvTPxgxDd6MwaMKx/otC6EJ+ea56zGwxCbz9Y3GGITfJeLNhsIG5aEmzPBeFZx0Sk8jgCz
	/S1S1wrW/EiLKsVyTXeQixn63xohByIiaZQJVmF2BRQFrzXvvzXlpb492Do0GZAQxanUiECW3sjDM
	9r805X97qSHS8uw9wbxMlolLrDllzYTgud5uiZvwG0ZUUv1en64rLkfLaabFuwRvsaickjTonFwYu
	v0J7a8RIUrTrNyGSo0rBLai5qUnAkb775UhIyj1bJwNkbzC1XmTj5/62SGXwG3gdx/e/EnSEQJ8iF
	nxwu4+VQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uhoQe-0000000DkzQ-0OHY
	for fio@vger.kernel.org;
	Fri, 01 Aug 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 603251BC0150; Fri,  1 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250801120001.603251BC0150@kernel.dk>
Date: Fri,  1 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 306d89868d07b98d1683585468d232703007e0da:

  engines/io_uring: don't duplicate open/close file code (2025-07-23 14:22:36 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6e8c646c310219bf4026d74f02ce4652d27866ff:

  eta: convert skip_eta() to ANSI C declaration (2025-07-31 11:19:21 -0400)

----------------------------------------------------------------
Tomas Winkler (2):
      filesetup: make longest_existing_path() static and const-correct
      eta: convert skip_eta() to ANSI C declaration

 eta.c       | 2 +-
 filesetup.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/eta.c b/eta.c
index 7d07708f..16109510 100644
--- a/eta.c
+++ b/eta.c
@@ -381,7 +381,7 @@ bool eta_time_within_slack(unsigned int time)
  * These are the conditions under which we might be able to skip the eta
  * calculation.
  */
-static bool skip_eta()
+static bool skip_eta(void)
 {
 	if (!(output_format & FIO_OUTPUT_NORMAL) && f_out == stdout)
 		return true;
diff --git a/filesetup.c b/filesetup.c
index a94d3b38..bcbd871e 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1002,7 +1002,8 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 /*
  * Find longest path component that exists and return its length
  */
-int longest_existing_path(char *path) {
+static int longest_existing_path(const char *path)
+{
 	char buf[PATH_MAX];
 	bool done;
 	char *buf_pos;
