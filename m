Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AB5372891
	for <fio@vger.kernel.org>; Wed, 17 Sep 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758110414; cv=none; b=nmYtiIm4TEOTlg3d/uskMXQYPTkBYEBZuKaORxXt4SAZj11mTDtjtTceC6kJZoY9ZA1CBtFP4fQn8KooucAhdKcnhxGw6o5aksdB7hiaOF9mxdxAyn4QWi1Us5odvFp74C33lf4czkDwZe3OXcsz7R9J/80MUXQdmcZI2LQnXcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758110414; c=relaxed/simple;
	bh=NNs/d/y6R50xRO4mUIt/iqYFwTxcKBfk9zNJFveCYmc=;
	h=Subject:From:To:Message-Id:Date; b=sSiRqwNJixyM24JDtwVwvPU01PcE7IjXcfZ6d2+6d7hiSi3WhSE94QxgviVcJSHjpEFdBNgWCiQl0Qz4cWC5oNWxOSFi8RRBhry+CfA1v/GdCA0sAiCmSNiNfkxYv9J/h6vq/+YAte+yJIwSfL7YGqN00AEYYu3yizoGTCG59pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vPxQ7R7S; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vPxQ7R7S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=yIs4+s5pZGjMg7+sB04TBbbbl/JE+sqdut0fqeCXX78=; b=vPxQ7R7SCX4xodAM0WzIi4i9pa
	Ww9bAvP/2UOEJy3J1vOcAkq4zdGmzmroUQ5wSXgVrmlNBYEotp8//UM3LQAvzQ8enneFHu+b9cx9L
	f+OayWT3qckyXZwPASgYzxzP39vxVAPI6Kqax82qDsz/jAS/vOUnF0ccfCoJQyOLWJZkaCAqtqvGu
	Ku0EvbNbV41qxDSUP2LrGKBdfzimA5lCXbJG/SCxXcv21KoQ//za5W80JlHpFR/vGrOWnP9UyTYm7
	VQRBfii9grxvQm3mIkxaa59m7pAtdwcXytXBsh7X4ozvBRdt4ZojJ0DEqE0a6FqYd1iLzAqoVoqcL
	88Fee6ow==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyqpR-0000000BzgK-3lnH
	for fio@vger.kernel.org;
	Wed, 17 Sep 2025 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 2C3CD1BC0113; Wed, 17 Sep 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250917120001.2C3CD1BC0113@kernel.dk>
Date: Wed, 17 Sep 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 84787adffac2435e72f6f08336e32559fd31e3a0:

  Merge branch 'master' of https://github.com/Meiye-lj/fio (2025-09-08 07:57:10 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2c573a35f3d6b67723114af9e6dffad1e94474bc:

  stat: used shared sem for stats lock (2025-09-16 10:08:57 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      stat: used shared sem for stats lock

 stat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index ee5bdf1f..1151a09f 100644
--- a/stat.c
+++ b/stat.c
@@ -3688,7 +3688,7 @@ int calc_log_samples(void)
 
 void stat_init(void)
 {
-	stat_sem = fio_sem_init(FIO_SEM_UNLOCKED);
+	stat_sem = fio_shared_sem_init(FIO_SEM_UNLOCKED);
 }
 
 void stat_exit(void)
@@ -3698,7 +3698,7 @@ void stat_exit(void)
 	 * have ended.
 	 */
 	fio_sem_down(stat_sem);
-	fio_sem_remove(stat_sem);
+	fio_shared_sem_remove(stat_sem);
 }
 
 /*
