Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B860D3B531C
	for <fio@vger.kernel.org>; Wed, 25 Feb 2026 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024410; cv=none; b=cVgOmL50KmYQFtchhC9eOxmTazKO28Q2BtLh+MN37ljjMZN+WfT4L2lGnt0snZ4vKbaDip25lDH0Fu2ZCem/2x8XAGIh5Xf3VNECvoEq4yyk9dqlZeA1hDoJduvERWRHUJvy8vLS1zkxsT+289tFhOfC5NRANHZds6zc9Sj/1Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024410; c=relaxed/simple;
	bh=EzGKPDfj+qpZB4zYwUfRp4PNqbXJYzwxQUMtkMkgb4I=;
	h=Subject:From:To:Date:Message-Id; b=MXCz4vRevtfm5Z6NlFkjr0vYeb+eq6x2jlym9s4+SELJr73su5dt/ELvaAUzEtgeZZQ0vckiTPUO/qm/ytSlH08MFO79kMOUib53KWH0d1mFh1gRkzBfo3u0EcOe+0AVMV66R7JYOjcdRl/QIlzXuAo2Ow4el5jbIv70jvN0+c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tkGUKGLN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tkGUKGLN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=wvtZs/wz/Mz+tHZNY7P3kwj/qSMsNqjUpB9nLBjB0oQ=; b=tkGUKGLNG73+6vEvf6v+nlROEe
	8i2f19rvLjuQfa69ta75NhsVEg9Q538VGcQWNJ0Pio3izwauWMsZPSAc9YKPX2dPA+z6sy8Uu+Cr/
	mpGN58y0k6fTwecKSNAFmkvSOIvUtXzy2sj6ouL3KbkSbjSJ5F8belKM7SuQpi8drEfeRCbaqYqiK
	hnqcBaso3CNL3VvgTmLYhNq45zj2xBWA5LlmPMULiQ3qcuvhZBM6wDa2IYBUWmy3B0wEEY47q+9g9
	EpEsf5qbp6KJCxzpss9CTVIWyiFpLa4SrY4Q58whzlvUqQd9xP4MrYSiflMtNBQy+qLWVgUE+NfDh
	QeoAMwiw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvEUn-000000014x4-0GiB
	for fio@vger.kernel.org;
	Wed, 25 Feb 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A205E1BC017F; Wed, 25 Feb 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 25 Feb 2026 06:00:01 -0700
Message-Id: <20260225130001.A205E1BC017F@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1a04e5746c28316bd8a64825bf2b5739dc01c589:

  stat: Remove duplicate space in __show_run_stats() (2026-02-13 11:44:32 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 411de8ecef63194adf805d4807b5dc3730571655:

  Merge branch 'offload_stability' of https://github.com/tomas-winkler-sndk/fio (2026-02-24 08:03:09 -0700)

----------------------------------------------------------------
Chana Zaks (1):
      time: fix ramp completion offload workers

Jens Axboe (1):
      Merge branch 'offload_stability' of https://github.com/tomas-winkler-sndk/fio

Tomas Winkler (1):
      libfio: fix crash when io_submit_mode=offload

 libfio.c | 19 ++++++++++++++++---
 time.c   |  9 +++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/libfio.c b/libfio.c
index 57f3f858..52afeafb 100644
--- a/libfio.c
+++ b/libfio.c
@@ -132,15 +132,28 @@ void clear_io_state(struct thread_data *td, int all)
 	clear_inflight(td);
 }
 
-void reset_all_stats(struct thread_data *td)
+/*
+ * Update thinktime block counter
+ */
+static void update_thinktime_blocks_counter(struct thread_data *td)
 {
 	unsigned long long b;
-	int i;
 
-	reset_io_counters(td, 1);
+	/* an offload worker has no thinktime blocks counters initialized */
+	if (!td->thinktime_blocks_counter)
+		return;
 
 	b = ddir_rw_sum(td->thinktime_blocks_counter);
 	td->last_thinktime_blocks -= b;
+}
+
+void reset_all_stats(struct thread_data *td)
+{
+	int i;
+
+	reset_io_counters(td, 1);
+
+	update_thinktime_blocks_counter(td);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		td->io_bytes[i] = 0;
diff --git a/time.c b/time.c
index 386c76fc..71dc7b15 100644
--- a/time.c
+++ b/time.c
@@ -197,6 +197,15 @@ static bool parent_update_ramp(struct thread_data *td)
 
 bool ramp_period_over(struct thread_data *td)
 {
+	/*
+	 * In offload mode, ramp state is tracked on the parent job td.
+	 * The transition to RAMP_FINISHING is handled by the parent, so
+	 * propagate it here to ensure the worker advances to RAMP_DONE.
+	 */
+	if (td->o.io_submit_mode == IO_MODE_OFFLOAD && td->parent &&
+	    td->parent->ramp_period_state == RAMP_FINISHING)
+		td->ramp_period_state = RAMP_FINISHING;
+
 	if (td->ramp_period_state == RAMP_DONE)
 		return true;
 
