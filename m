Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9542A625
	for <fio@vger.kernel.org>; Sat, 20 Apr 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713614413; cv=none; b=D7aYAg+JyJFrtTdFZQgw4lwj07EM3cJIJ8GBVESevTHuFubsKKMmUf1A22VEXBAMx4zYBMZwCjeMgNBslf9hweBaUlP+wbN/AWUt6dGgGeGucYuqWanksTfmtvWMhqKFd0TLRseU8NEYqI+fGnyONTja5aJTegLhJAi7XSSsyps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713614413; c=relaxed/simple;
	bh=DNldUXGkFcItldVkQixsBHqWUwU3X9wHzEwNnbdsPpk=;
	h=Subject:From:To:Message-Id:Date; b=oThK65V70SktK/qqQADjWcwWK6wLh6qtpMLSof0oNlJxWnnhX5OgHuRS4Asx00Vr7uZGJ4hzGcea8LddxODFRUMQvSS1Fnf8rRmdBiTy+QTjdLdq+sXRwyjs+CHMcMzzQF7zqRgIwp2Oqt7tYkS20eed6JPQ0u0v1KTKZvISdb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VvE3PcPx; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VvE3PcPx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GZJyOQXSVJUlws04y3Ke5A/qAnGhriJaEXr7Dp2T7XY=; b=VvE3PcPxCO3q4g1TZQmDWWZ1z6
	J0FusO9EBE2hYU2pXXbd/PagtoHt3x/qHRZY0KaxhW4lOpWQ0sttsfacKePVkiUX977y/ntk5gjT3
	pOIsd++qNEJTIUueHm04g1Ybz+ZlZkjXGJlhSSQz7TdzvlfsDQ+AhaqiRzzoGKJePWF11whFRG1dG
	iXu01Gnsd6aWO0OC0pY6CvEVfgeQnGuP7tUhbz1DuC1vgo2Ep1NJDHVpXMPXukETECXlqcptuPH2/
	NNoT8CouI8YiXNK+aoMQP4ldDejSzQhn40m7XneSScDBqdU6DDP0W/1a3umgyAsujvZtgFLJGMbsu
	pmaeKbfw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ry9O0-0000000Cr7m-0ctU
	for fio@vger.kernel.org;
	Sat, 20 Apr 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 94DFB1BC0176; Sat, 20 Apr 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240420120001.94DFB1BC0176@kernel.dk>
Date: Sat, 20 Apr 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 420415dd1180c14ec0f55f65a05e57ea1fd85f9f:

  fio: ioengine flag cleanup (2024-04-18 12:36:01 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c948ee34afde7eda14adf82512772b03f6fb1d69:

  Merge branch 'master' of https://github.com/celestinechen/fio (2024-04-19 13:51:05 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/celestinechen/fio

celestinechen (1):
      FIO with fsync option issues more DDIR_SYNC commands than expected

 io_u.c      | 2 --
 ioengines.c | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 83895893..a499ff07 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2113,7 +2113,6 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	if (ddir_sync(ddir)) {
 		if (io_u->error)
 			goto error;
-		td->last_was_sync = true;
 		if (f) {
 			f->first_write = -1ULL;
 			f->last_write = -1ULL;
@@ -2123,7 +2122,6 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		return;
 	}
 
-	td->last_was_sync = false;
 	td->last_ddir = ddir;
 
 	if (!io_u->error && ddir_rw(ddir)) {
diff --git a/ioengines.c b/ioengines.c
index 87cc2286..6b81dc77 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -436,6 +436,8 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 			io_u_mark_depth(td, 1);
 			td->ts.total_io_u[io_u->ddir]++;
 		}
+
+		td->last_was_sync = ddir_sync(io_u->ddir);
 	} else if (ret == FIO_Q_QUEUED) {
 		td->io_u_queued++;
 
@@ -445,6 +447,8 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 
 		if (td->io_u_queued >= td->o.iodepth_batch)
 			td_io_commit(td);
+
+		td->last_was_sync = ddir_sync(io_u->ddir);
 	}
 
 	if (!td_ioengine_flagged(td, FIO_SYNCIO) &&
