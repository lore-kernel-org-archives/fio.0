Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43186 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbeLBAMi (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 1 Dec 2018 19:12:38 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gT4sT-0001J6-UY
        for fio@vger.kernel.org; Sat, 01 Dec 2018 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181201130002.0DB012C01D6@kernel.dk>
Date: Sat,  1 Dec 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a0318e176ace1e53b0049965f63b0c60b55ff8cd:

  gettime: use nsec in get_cycles_per_msec division (2018-11-29 11:21:18 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 68afa5b570a7e0dce0470817037f7828cf36cd2f:

  stat: assign for first stat iteration, don't sum (2018-11-30 14:44:25 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      engines/libaio: only initialize iocb members when we need to
      stat: only apply proper stat summing for event timestamps
      stat: assign for first stat iteration, don't sum

 engines/libaio.c | 24 +++++++++++++++--------
 stat.c           | 60 ++++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 61 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libaio.c b/engines/libaio.c
index d386d14..9c8a61b 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -125,16 +125,20 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 	else
 		iocb = &io_u->iocb;
 
-	iocb->u.c.flags = 0;
-
 	if (io_u->ddir == DDIR_READ) {
-		io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-		if (o->hipri)
-			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
+		if (o->fixedbufs) {
+			iocb->aio_fildes = f->fd;
+			iocb->aio_lio_opcode = IO_CMD_PREAD;
+			iocb->u.c.offset = io_u->offset;
+		} else
+			io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 	} else if (io_u->ddir == DDIR_WRITE) {
-		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-		if (o->hipri)
-			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
+		if (o->fixedbufs) {
+			iocb->aio_fildes = f->fd;
+			iocb->aio_lio_opcode = IO_CMD_PWRITE;
+			iocb->u.c.offset = io_u->offset;
+		} else
+			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
@@ -468,6 +472,10 @@ static int fio_libaio_post_init(struct thread_data *td)
 			iocb = &ld->user_iocbs[i];
 			iocb->u.c.buf = io_u->buf;
 			iocb->u.c.nbytes = td_max_bs(td);
+
+			iocb->u.c.flags = 0;
+			if (o->hipri)
+				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
 		}
 	}
 
diff --git a/stat.c b/stat.c
index 331abf6..887509f 100644
--- a/stat.c
+++ b/stat.c
@@ -1518,13 +1518,10 @@ struct json_object *show_thread_status(struct thread_stat *ts,
 	return ret;
 }
 
-static void sum_stat(struct io_stat *dst, struct io_stat *src, bool first)
+static void __sum_stat(struct io_stat *dst, struct io_stat *src, bool first)
 {
 	double mean, S;
 
-	if (src->samples == 0)
-		return;
-
 	dst->min_val = min(dst->min_val, src->min_val);
 	dst->max_val = max(dst->max_val, src->max_val);
 
@@ -1551,6 +1548,39 @@ static void sum_stat(struct io_stat *dst, struct io_stat *src, bool first)
 	dst->samples += src->samples;
 	dst->mean.u.f = mean;
 	dst->S.u.f = S;
+
+}
+
+/*
+ * We sum two kinds of stats - one that is time based, in which case we
+ * apply the proper summing technique, and then one that is iops/bw
+ * numbers. For group_reporting, we should just add those up, not make
+ * them the mean of everything.
+ */
+static void sum_stat(struct io_stat *dst, struct io_stat *src, bool first,
+		     bool pure_sum)
+{
+	if (src->samples == 0)
+		return;
+
+	if (!pure_sum) {
+		__sum_stat(dst, src, first);
+		return;
+	}
+
+	if (first) {
+		dst->min_val = src->min_val;
+		dst->max_val = src->max_val;
+		dst->samples = src->samples;
+		dst->mean.u.f = src->mean.u.f;
+		dst->S.u.f = src->S.u.f;
+	} else {
+		dst->min_val += src->min_val;
+		dst->max_val += src->max_val;
+		dst->samples += src->samples;
+		dst->mean.u.f += src->mean.u.f;
+		dst->S.u.f += src->S.u.f;
+	}
 }
 
 void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
@@ -1586,22 +1616,22 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
 		if (!dst->unified_rw_rep) {
-			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first);
-			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first);
-			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first);
-			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first);
-			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], first);
+			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
+			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first, false);
+			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first, false);
+			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first, true);
+			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], first, true);
 
 			dst->io_bytes[l] += src->io_bytes[l];
 
 			if (dst->runtime[l] < src->runtime[l])
 				dst->runtime[l] = src->runtime[l];
 		} else {
-			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], first);
-			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first);
-			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first);
-			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first);
-			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], first);
+			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], first, false);
+			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first, false);
+			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first, false);
+			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first, true);
+			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], first, true);
 
 			dst->io_bytes[0] += src->io_bytes[l];
 
@@ -1616,7 +1646,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		}
 	}
 
-	sum_stat(&dst->sync_stat, &src->sync_stat, first);
+	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
 	dst->usr_time += src->usr_time;
 	dst->sys_time += src->sys_time;
 	dst->ctx += src->ctx;

