Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0962253A1
	for <fio@vger.kernel.org>; Fri,  6 Feb 2026 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770382814; cv=none; b=ZHA9LOK6ClTfjLMOlwr0ex9obbbDB8AlWDFAPSkSCWx3CSQ1rLBp+lqf4dV7FT0ypg/HMd9VP9vNnwGhvwTiTeOcCFxdIbiMI7kfgWY7XvhQHvMHOo3/0CZ1348bC/YeKjZBCjxLgeiLvkR4zD3sq5LnGM3wlnGDvuCGVdnFbzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770382814; c=relaxed/simple;
	bh=lnvOB1WxdTRBZ3ePfMW8Vv+eQADzhlrKYBbhXYg8wQU=;
	h=Subject:From:To:Date:Message-Id; b=qT/EIWRLVtyRmhveHrA6Q8NADFL3JyLG1tTUXEZmWIjvEYkZtUEqj/kzbBPZo3BFelENa9bg2BHAI3oQxeJVZRAhpFAcJNGjXoFNzVACsTt3/tfP1Q0jE+7tojxJx/7Pw0EPR+hVEa72FgKxfH2doL1PB+lPStwODWJ12o3/QbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Os9immeD; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Os9immeD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=BCa1dAfo69IiIZ3WjQ5adJPU8zse45Yp0IwCFetjjZA=; b=Os9immeDir7ri7ng0/GjhsngRt
	PhDfTgYPQTOVEboXMg2tI4z4kxuKoNneDhygZ6wOf+tDaEvP+E52dM4oF2Wcemxl/FpJn+mwV0rwD
	3dtxSJe8Gy40mmOAE5E0nWbrSL1/5MhE4cXQe2mnsQUTbaKgF9ZG/a7xaWCJceJYcogH00pIT8XWM
	SM5u2uA4YVM5+76kRIyArrsfwb51y4u3vw0d1GJ7gaZKSoA1rV4f62P9VsRExOLssirvAGzYD7zav
	A4chTvQvKrDCOzx6P/96vZba9a5DMxkLcyF9DIldfdwU38sqI37ev8OIC6mw1nCBIbbARNpI53UC/
	B3Vzonlg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1voLRN-00000003oQx-2PeZ
	for fio@vger.kernel.org;
	Fri, 06 Feb 2026 13:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 7DB661BC00FD; Fri,  6 Feb 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri,  6 Feb 2026 06:00:01 -0700
Message-Id: <20260206130001.7DB661BC00FD@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 5e5975a411cfd2af04c49f8d822e8e06a01a3771:

  Merge branch 'sprandom-fix' of https://github.com/tomas-winkler-sndk/fio (2026-02-02 08:05:59 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a8ab726842f4140dfcdb4240138f1abba9b54c05:

  Merge branch 'offload_fix' of https://github.com/tomas-winkler-sndk/fio (2026-02-05 13:14:38 -0700)

----------------------------------------------------------------
Chana Zaks (1):
      workqueue: fix threads stall when running with io_submit_mode offload

Jens Axboe (1):
      Merge branch 'offload_fix' of https://github.com/tomas-winkler-sndk/fio

 workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/workqueue.c b/workqueue.c
index 3636bc3a..e3ff0323 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -285,6 +285,7 @@ static int start_worker(struct workqueue *wq, unsigned int index,
 	sw->wq = wq;
 	sw->index = index;
 	sw->sk_out = sk_out;
+	sw->flags = 0;
 
 	if (wq->ops.alloc_worker_fn) {
 		ret = wq->ops.alloc_worker_fn(sw);
@@ -295,7 +296,7 @@ static int start_worker(struct workqueue *wq, unsigned int index,
 	ret = pthread_create(&sw->thread, NULL, worker_thread, sw);
 	if (!ret) {
 		pthread_mutex_lock(&sw->lock);
-		sw->flags = SW_F_IDLE;
+		sw->flags |= SW_F_IDLE;
 		pthread_mutex_unlock(&sw->lock);
 		return 0;
 	}
