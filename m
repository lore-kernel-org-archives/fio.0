Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC59168C1D
	for <fio@vger.kernel.org>; Wed, 12 Jun 2024 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718193609; cv=none; b=iO70JPVX1+0tV1/GC7lHdUp36vMqUoXg1/QpYar7ZnwvGyVHBTzBQfzdBmmJJmxREc3tX+OiJ4So/G18JHUCSXZQGr4YXTxYQnv7XmQcvid3eH5kLwdvzN2BYDt09ddapI6+j06Oaogx0kOOHtcOum8Fd9EPyQEwHvszG3VVw2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718193609; c=relaxed/simple;
	bh=i5dTelSk4vg41Dldr/3hmmpud/zny/5ZeqFNb8BxoBw=;
	h=Subject:From:To:Message-Id:Date; b=lIMZGoxIi51GaOEXaUwn+UPdG0izNCYzKmXCEj/AQc1SSWKptGrJzrTWPEpu3T00dlZhKMbmdybdUdiC3MNde2meK4gMKCqfnvsp7daqAPEB3TNnbpnBhjbhaITOM4H/GlrpePVNkaUjCaYHDz+mGLv3bYJBg7aq78sO/+GIyt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ciqRtzdD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ciqRtzdD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=RJz32nPPUN5RznCsOUjsmkcof/4s1Od/Imgfne9v0HY=; b=ciqRtzdDdz4sdoPj6JVIOch9+P
	JxB5QBkIi8SRrR9gbJI2hUgrwl+Me1/xuS/py9FlVge82weOWtjqcPFCyfkTU+EXmc4FTr04gSzqj
	dV+ditDpqSMTaOQ3XfEelNok7AUkfd9Zpj34NK0XiffKDeMRIjUq4E/idNG/q1z+wiQic1F8/RZOj
	y/6KNRbnkySGh34x9SjPdYZaaINTQpB6VAA8siAq/yT2QRSfyEtRSwJd/1gT+CgmgbSLPi+TgPHcG
	4qbNpTP6SIZ+jU61QwW/YsB/wpwzuQmfUqgSHpGFtqZPtJjwxKrE+iedcA9dUFZBzGHI1caILZGlh
	fwgr7/tQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHMe3-0000000Ef7E-3W5o
	for fio@vger.kernel.org;
	Wed, 12 Jun 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 7BBC61BC013F; Wed, 12 Jun 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240612120001.7BBC61BC013F@kernel.dk>
Date: Wed, 12 Jun 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit fbf954c96bb4089b3097adde723216a4668f854b:

  engines/io_uring: eliminate FDP memory corruption risk (2024-06-07 09:45:02 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a15118757dad19c7f17700903d169676f244e318:

  helper_thread: check for null scalloc return value (2024-06-11 16:19:38 -0400)

----------------------------------------------------------------
Vincent Fu (5):
      Reapply "smalloc: smalloc() already clears memory, scalloc() need not do it again"
      t/stest: confirm that scalloc clears the buffer
      iolog: check scalloc return value
      t/stest: remove useless error assignment
      helper_thread: check for null scalloc return value

 helper_thread.c |  2 ++
 iolog.c         |  1 +
 smalloc.c       |  8 +-------
 t/stest.c       | 37 +++++++++++++++++++++++++++++++------
 4 files changed, 35 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/helper_thread.c b/helper_thread.c
index 332ccb53..fed21d1d 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -418,6 +418,8 @@ int helper_thread_create(struct fio_sem *startup_sem, struct sk_out *sk_out)
 	int ret;
 
 	hd = scalloc(1, sizeof(*hd));
+	if (!hd)
+		return 1;
 
 	setup_disk_util();
 	steadystate_setup();
diff --git a/iolog.c b/iolog.c
index b57f845e..f727c97f 100644
--- a/iolog.c
+++ b/iolog.c
@@ -840,6 +840,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 	struct flist_head *list;
 
 	l = scalloc(1, sizeof(*l));
+	assert(l);
 	INIT_FLIST_HEAD(&l->io_logs);
 	l->log_type = p->log_type;
 	l->log_offset = p->log_offset;
diff --git a/smalloc.c b/smalloc.c
index 134f3d77..23243054 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -566,13 +566,7 @@ void *smalloc(size_t size)
 
 void *scalloc(size_t nmemb, size_t size)
 {
-	void *ret;
-
-	ret = smalloc(nmemb * size);
-	if (ret)
-		memset(ret, 0, nmemb * size);
-
-	return ret;
+	return smalloc(nmemb * size);
 }
 
 char *smalloc_strdup(const char *str)
diff --git a/t/stest.c b/t/stest.c
index c6bf2d1e..16ce6923 100644
--- a/t/stest.c
+++ b/t/stest.c
@@ -25,10 +25,11 @@ static FLIST_HEAD(list);
 
 static int do_rand_allocs(void)
 {
-	unsigned int size, nr, rounds = 0, ret = 0;
+	unsigned int i, size, nr, rounds = 0, ret = 0;
 	unsigned long total;
 	struct elem *e;
 	bool error;
+	char *c;
 
 	while (rounds++ < LOOPS) {
 #ifdef STEST_SEED
@@ -38,12 +39,26 @@ static int do_rand_allocs(void)
 		nr = total = 0;
 		while (total < MAXSMALLOC) {
 			size = 8 * sizeof(struct elem) + (int) (999.0 * (rand() / (RAND_MAX + 1.0)));
-			e = smalloc(size);
+			e = scalloc(1, size);
 			if (!e) {
 				printf("fail at %lu, size %u\n", total, size);
 				ret++;
 				break;
 			}
+
+			c = (char *)e;
+			for (i = 0; i < size; i++) {
+				if (*(c+i) != 0) {
+					printf("buffer not cleared at %lu, size %u\n", total, size);
+					ret++;
+					break;
+				}
+			}
+
+			/* stop the while loop if buffer was not cleared */
+			if (i < size)
+				break;
+
 			e->magic1 = MAGIC1;
 			e->magic2 = MAGIC2;
 			e->size = size;
@@ -63,15 +78,25 @@ static int do_rand_allocs(void)
 			sfree(e);
 
 			if (!error) {
-				e = smalloc(LARGESMALLOC);
+				e = scalloc(1, LARGESMALLOC);
 				if (!e) {
-					error = true;
 					ret++;
 					printf("failure allocating %u bytes at %lu allocated during sfree phase\n",
 						LARGESMALLOC, total);
+					break;
 				}
-				else
-					sfree(e);
+
+				c = (char *)e;
+				for (i = 0; i < LARGESMALLOC; i++) {
+					if (*(c+i) != 0) {
+						error = true;
+						ret++;
+						printf("large buffer not cleared at %lu, size %u\n", total, size);
+						break;
+					}
+				}
+
+				sfree(e);
 			}
 		}
 	}
