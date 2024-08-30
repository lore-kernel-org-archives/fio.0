Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E774199927
	for <fio@vger.kernel.org>; Fri, 30 Aug 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725019214; cv=none; b=fu4ShVPvOuDtQ3o3xbLcYQUlco2N/2lWVltALdS885/v6QDom/YfGGoXlbf/kQ8Iih7gKKVZ0j0AcDeVP0PHm6KxA2R3EjR86zvJPHmcZCaqXUE5SBcL2S1sQk1Gms5nHaRyJ4Q28/8rtQ3DJrN6ZCP+RAeAOp1wS57YoFkq5OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725019214; c=relaxed/simple;
	bh=VSlgnjUcmncY1LFd64Jczdj/A7IC/jiaLLyKkyxxzfQ=;
	h=Subject:From:To:Message-Id:Date; b=c7NyHRYSHMp2q3jjvGYojEGcaZ+2yZVyRSaqDuwx7JRRlJl+lqCYYT+xIV0rm6XkxRSvFez2Pq/SE3Xx/k/XP+yhC+nsIPKnHqo8We+BYw1nlB8A+dskmjg5oNtTRyYxXO/GV0Oa/XQlK3E5qBLWDWywEL6khRBPk3ec3l87pCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=raN5XpzQ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="raN5XpzQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=y4IJ/PcpUp00NtSn5qj+wVcsBx6dzOvviCqea2Tasbk=; b=raN5XpzQJvlCqHTeuue5bYEZlT
	SOgkUSpGzQOtgngcCtF0cVMoRtG3s9msKy8TpZmPb9IQr0SQPHPd3tQchC8KqPoHReZ8d4hp+lNGU
	v07Tia8GmljvaFuSDuoqPBeSLM/1edTbse9V0vakVlMg3rQgfD+12uBD7dlVkclphz51jwpdgCbfi
	KARyD1Uxj4jqcVhxW4VbFIPnTCulACnc+f1vt3ky9zMfy+0bbXffGYOT9/vQW6BpwcNtoQmnE3EED
	hbwMzQl1xkrcj9gJ6KIXyShqQ6NmZlMVK3kWzUEcIMBhjaPMElr3B0+T2KShQETqcVWPXhfWd5jst
	rBhx/Zxw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sk0IO-0000000BfTP-3XmK
	for fio@vger.kernel.org;
	Fri, 30 Aug 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A231A1BC0109; Fri, 30 Aug 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240830120001.A231A1BC0109@kernel.dk>
Date: Fri, 30 Aug 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2a26258077b987ddba0633d07aaec0abfb5462a2:

  ci: add containers for Alma, Oracle, and Rocky Linux (2024-08-27 18:29:54 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 00dc75d2f80fc130d2627ed4bb25548ba77e5fbc:

  Remove 'uncached' support (2024-08-29 07:22:17 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Remove 'uncached' support

 engines/io_uring.c           | 11 +----------
 engines/sync.c               |  9 +--------
 os/os-linux.h                |  4 ----
 tools/fiograph/fiograph.conf |  6 +++---
 4 files changed, 5 insertions(+), 25 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index bfbdc3b4..1d4a6118 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -106,7 +106,6 @@ struct ioring_options {
 	unsigned int sqpoll_set;
 	unsigned int sqpoll_cpu;
 	unsigned int nonvectored;
-	unsigned int uncached;
 	unsigned int nowait;
 	unsigned int force_async;
 	unsigned int md_per_io_size;
@@ -244,11 +243,7 @@ static struct fio_option options[] = {
 	{
 		.name	= "uncached",
 		.lname	= "Uncached",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct ioring_options, uncached),
-		.help	= "Use RWF_UNCACHED for buffered read/writes",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_IOURING,
+		.type	= FIO_OPT_SOFT_DEPRECATED,
 	},
 	{
 		.name	= "nowait",
@@ -395,8 +390,6 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			}
 		}
 		sqe->rw_flags = 0;
-		if (!td->o.odirect && o->uncached)
-			sqe->rw_flags |= RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |= RWF_NOWAIT;
 
@@ -465,8 +458,6 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 		sqe->fd = f->fd;
 	}
 	sqe->rw_flags = 0;
-	if (!td->o.odirect && o->uncached)
-		sqe->rw_flags |= RWF_UNCACHED;
 	if (o->nowait)
 		sqe->rw_flags |= RWF_NOWAIT;
 
diff --git a/engines/sync.c b/engines/sync.c
index d1999122..b8be4eb3 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -39,7 +39,6 @@ struct psyncv2_options {
 	void *pad;
 	unsigned int hipri;
 	unsigned int hipri_percentage;
-	unsigned int uncached;
 	unsigned int nowait;
 };
 
@@ -68,11 +67,7 @@ static struct fio_option options[] = {
 	{
 		.name	= "uncached",
 		.lname	= "Uncached",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct psyncv2_options, uncached),
-		.help	= "Use RWF_UNCACHED for buffered read/writes",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_INVALID,
+		.type	= FIO_OPT_SOFT_DEPRECATED,
 	},
 	{
 		.name	= "nowait",
@@ -172,8 +167,6 @@ static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
 	if (o->hipri &&
 	    (rand_between(&sd->rand_state, 1, 100) <= o->hipri_percentage))
 		flags |= RWF_HIPRI;
-	if (!td->o.odirect && o->uncached)
-		flags |= RWF_UNCACHED;
 	if (o->nowait)
 		flags |= RWF_NOWAIT;
 
diff --git a/os/os-linux.h b/os/os-linux.h
index c5cd6515..4d150311 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -328,10 +328,6 @@ static inline int fio_set_sched_idle(void)
 #define RWF_NOWAIT	0x00000008
 #endif
 
-#ifndef RWF_UNCACHED
-#define RWF_UNCACHED	0x00000040
-#endif
-
 #ifndef RWF_WRITE_LIFE_SHIFT
 #define RWF_WRITE_LIFE_SHIFT		4
 #define RWF_WRITE_LIFE_SHORT		(1 << RWF_WRITE_LIFE_SHIFT)
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 123c39ae..4621215c 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,10 +51,10 @@ specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_ke
 specific_options=ime_psync  ime_psyncv
 
 [ioengine_io_uring]
-specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
+specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async
 
 [ioengine_io_uring_cmd]
-specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async  cmd_type  md_per_io_size  pi_act  pi_chk  apptag  apptag_mask
+specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  nowait  force_async  cmd_type  md_per_io_size  pi_act  pi_chk  apptag  apptag_mask
 
 [ioengine_libaio]
 specific_options=userspace_reap  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  nowait
@@ -108,7 +108,7 @@ specific_options=hostname  bindname  port  verb
 specific_options=hipri  readfua  writefua  sg_write_mode  stream_id
 
 [ioengine_pvsync2]
-specific_options=hipri  hipri_percentage  uncached  nowait  sync  psync  vsync  pvsync
+specific_options=hipri  hipri_percentage  nowait  sync  psync  vsync  pvsync
 
 [ioengine_xnvme]
 specific_options=hipri  sqthread_poll  xnvme_be  xnvme_async  xnvme_sync  xnvme_admin  xnvme_dev_nsid  xnvme_iovec
