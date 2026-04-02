Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C053DEFF1
	for <fio@vger.kernel.org>; Thu,  2 Apr 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775131218; cv=none; b=Sio6csu6CnPy27iw9nqCHbd08z2djQ8RQWjMp5K31FQJVhFGJiDfWRFkNTPSBh7mmXCebzOttQOsD77mEzcPFrgXz/qTwBFLto68+u9KzrSrUgCApKx2sSrQaPSMtrqCclExKijc/BKBYX5Y5WxFrj0DedNYZUObpby2W47be0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775131218; c=relaxed/simple;
	bh=KBG18NO1j7EjCqYlVAtgFOOIPEfimeRgf4Q2L7fDTzo=;
	h=Subject:From:To:Date:Message-Id; b=NmkNwBI23VLcvsuSDv9/RsdR5xMyTBBJndyRY86TEl3kgHprIAdGRnJDD2fyLdkmt3FJut+qOnImuSwLrepA02Q8CEAhXCbLhclNHkQvoIdxba4E5dvx8DIc9e4c5Mdw4IjiUao0xfcEY56O2Ep6BzNfCJ67M91x8tXwbSYycmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F4ZnLPcU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F4ZnLPcU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pnFbmihV2LL+coNqDaCIjGEz97Mmxh6ik5wThBeHr64=; b=F4ZnLPcU8g3/tfrthe5A82u3/M
	qqHigGtgY0fRkzFIq3cpl27fKX3OgdBSwUmA3d1dj0vampVIhSWUJ4ejbWXXIblyN11Lw05j4h+hj
	NCtX+JHtYcCEf8AnR1ivlDPrfcv0DcTrKM3gGwqEGdCGEXQnDJaRXyWYjYLvBCHj0YiJjVcVPvoDu
	/O9Kfc302dNifD3ntzkM+O81qICLdI8b7WJQ51lDoCNp8RPWWMAwS0Rb/HA7KnmZ0hqSS3PJGGJca
	spLOUKT01eMqtMGH4zSKAl++S7QwNtV8v/fZ2WHd0oZ39hDxQy70/GNcJzRMGvEq0b9Uel1JjMZuc
	fOblmczw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8GiT-0000000CEfo-1Kpe
	for fio@vger.kernel.org;
	Thu, 02 Apr 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id CF6D11BC012A; Thu,  2 Apr 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu,  2 Apr 2026 06:00:01 -0600
Message-Id: <20260402120001.CF6D11BC012A@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 698fa8f0682b809b3f85f50c593067e90108f92e:

  Merge branch 'fix-null-comm-prctl' of https://github.com/Criticayon/fio (2026-03-18 19:31:08 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d0218ba66e9dc8402f1ac366b964277a1f2f2797:

  Merge branch 'fix_statsem_deadlock' of https://github.com/RyanTedrick/fio (2026-04-01 09:08:08 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix_statsem_deadlock' of https://github.com/RyanTedrick/fio

Ryan Tedrick (1):
      Fix stat_sem/rusage_sem deadlock during stats collection

 backend.c |  9 ++++-----
 stat.c    | 35 ++++++++++++++++++++++-------------
 2 files changed, 26 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index c63bbd07..4ce3d07f 100644
--- a/backend.c
+++ b/backend.c
@@ -2095,11 +2095,10 @@ static void *thread_main(void *data)
 		clear_state = true;
 
 		/*
-		 * Make sure we've successfully updated the rusage stats
-		 * before waiting on the stat mutex. Otherwise we could have
-		 * the stat thread holding stat mutex and waiting for
-		 * the rusage_sem, which would never get upped because
-		 * this thread is waiting for the stat mutex.
+		 * Service any pending rusage request, then acquire stat_sem to update
+		 * runtime counters. This trylock loop will primarily guard against
+		 * contention from concurrent stat calls or other slow operations under
+		 * stat_sem.
 		 */
 		deadlock_loop_cnt = 0;
 		do {
diff --git a/stat.c b/stat.c
index 63c9927f..305d1ae3 100644
--- a/stat.c
+++ b/stat.c
@@ -2821,16 +2821,35 @@ int __show_running_run_stats(void)
 	unsigned long long *rt;
 	struct timespec ts;
 
-	fio_sem_down(stat_sem);
-
 	rt = malloc(thread_number * sizeof(unsigned long long));
 	fio_gettime(&ts, NULL);
 
+	/*
+	 * Collect rusage from workers outside stat_sem to prevent deadlock caused
+	 * by semaphore contention between the stat thread and the worker threads.
+	 */
 	for_each_td(td) {
 		if (td->runstate >= TD_EXITED)
 			continue;
 
-		td->update_rusage = 1;
+		if (td->rusage_sem) {
+			td->update_rusage = 1;
+			/* Prevent deadlock if worker exits between first check and sem_down */
+			if (td->runstate >= TD_EXITED) {
+				td->update_rusage = 0;
+				continue;
+			}
+			fio_sem_down(td->rusage_sem);
+		}
+		td->update_rusage = 0;
+	} end_for_each();
+
+	fio_sem_down(stat_sem);
+
+	for_each_td(td) {
+		if (td->runstate >= TD_EXITED)
+			continue;
+	
 		for_each_rw_ddir(ddir) {
 			td->ts.io_bytes[ddir] = td->io_bytes[ddir];
 		}
@@ -2845,16 +2864,6 @@ int __show_running_run_stats(void)
 			td->ts.runtime[DDIR_TRIM] += rt[__td_index];
 	} end_for_each();
 
-	for_each_td(td) {
-		if (td->runstate >= TD_EXITED)
-			continue;
-		if (td->rusage_sem) {
-			td->update_rusage = 1;
-			fio_sem_down(td->rusage_sem);
-		}
-		td->update_rusage = 0;
-	} end_for_each();
-
 	__show_run_stats();
 
 	for_each_td(td) {
