Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF3E146D6A
	for <fio@vger.kernel.org>; Tue, 27 Aug 2024 07:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742543; cv=none; b=IliFeKNJ5qRd8CzYTMEAsH569Ac0aY/2DA6Zk4KewXyKStuDm1GI+p4lZvJKGjGJVGVgW2OxG3E5J4hC/7E19JyK5HKvTzWqdjuewaUt2u1WlWyvayp1tyWCcAUAhvVU/1t04xwuYCM4C/Ljrx7+GKI6Mz1DoK0RfpaUR/ib8tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742543; c=relaxed/simple;
	bh=terMpmijEQ3x5DxmDIUaO3yrl2iKNXeLs3m0li5NaqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuI+NyOWdDX+i1pcnEQCE42pTFlF4us0/VH8cnF9pDFx1Zy2hZ/nSF1R5/7DGOjsLWJUuYp6DqLf5OSvrR+ZO4ey9zFAUXHGxmDlFuG5/1o4X5Ubz7q1N+jnHTS8h95tT/6w/CDX5MTWj3dR8oOUz6ntajoQPC8jXKEZklZxMbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MFiA6g4d; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MFiA6g4d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724742541; x=1756278541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=terMpmijEQ3x5DxmDIUaO3yrl2iKNXeLs3m0li5NaqM=;
  b=MFiA6g4dIhFyk/NE4kGAUDCQxo5Y2CFTNAkUdaODmxWWpDBDoOF0w0hd
   H/UMoJhi+nIWcX2t2aGBPDRzEDF3PdIsRwRUZnh9PKL3laY3eSvg8mmFV
   tb6ojO9Qwe0pakgC18c/dgwq9w+LwTG/c4a+Jr2t74B2rBY0TZoOfWluC
   YNrIPCllgJF2dfaH+jl6qw4BbhBbYoBflw6x+HPO3WLxF6MVtNz+69iA5
   fiDoWnOVOmy5AK8CwdvK0TBprDBVmks0kKLmdZUi+0LqTn47W5mwBk4+Y
   BFE6Ukw+njIdMy4Q9Dbsqg6bFjTCWpVoG0v7tfjzymxWUz4H1yoUQewJ9
   g==;
X-CSE-ConnectionGUID: PycjSpThTYCvG+H1KQ0qFQ==
X-CSE-MsgGUID: ugEuqKyQQz2b6Psrmwejsw==
X-IronPort-AV: E=Sophos;i="6.10,179,1719849600"; 
   d="scan'208";a="25297869"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2024 15:08:54 +0800
IronPort-SDR: 66cd6ec7_XlbV6NGbialsAst9+DXrZjD79I0FHNzclCy5L5zTjCfOGAR
 HlSICJNZ4gcz9/hCLjFBboUHHGgMMHecHtsBw2g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2024 23:14:32 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2024 00:08:53 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/9] stat: reduce arguments of add_log_sample()
Date: Tue, 27 Aug 2024 16:08:43 +0900
Message-ID: <20240827070850.947037-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The number of arguments of add_log_sample() has increased as fields get
added to the log file format. Five parameters of them (data, ddir, bs,
offset and priority) are passed to __add_log_sample(). This makes the
function look more complicated and log field addition harder. To
simplify the function, pack the five arguments into the new struct
log_sample.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 stat.c | 117 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 70 insertions(+), 47 deletions(-)

diff --git a/stat.c b/stat.c
index fac6d534..03681b9d 100644
--- a/stat.c
+++ b/stat.c
@@ -24,6 +24,14 @@
 #define LOG_MSEC_SLACK	1
 #endif
 
+struct log_sample {
+	union io_sample_data data;
+	uint32_t ddir;
+	uint64_t bs;
+	uint64_t offset;
+	uint16_t priority;
+};
+
 struct fio_sem *stat_sem;
 
 void clear_rusage_stat(struct thread_data *td)
@@ -3031,17 +3039,15 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 	return iolog->pending;
 }
 
-static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
-			     enum fio_ddir ddir, unsigned long long bs,
-			     unsigned long t, uint64_t offset,
-			     unsigned int priority)
+static void __add_log_sample(struct io_log *iolog, unsigned long t,
+			     struct log_sample *sample)
 {
 	struct io_logs *cur_log;
 
 	if (iolog->disabled)
 		return;
 	if (flist_empty(&iolog->io_logs))
-		iolog->avg_last[ddir] = t;
+		iolog->avg_last[sample->ddir] = t;
 
 	cur_log = get_cur_log(iolog);
 	if (cur_log) {
@@ -3049,18 +3055,18 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 
 		s = get_sample(iolog, cur_log, cur_log->nr_samples);
 
-		s->data = data;
+		s->data = sample->data;
 		s->time = t;
 		if (iolog->td && iolog->td->o.log_alternate_epoch)
 			s->time += iolog->td->alternate_epoch;
-		io_sample_set_ddir(iolog, s, ddir);
-		s->bs = bs;
-		s->priority = priority;
+		io_sample_set_ddir(iolog, s, sample->ddir);
+		s->bs = sample->bs;
+		s->priority = sample->priority;
 
 		if (iolog->log_offset) {
 			struct io_sample_offset *so = (void *) s;
 
-			so->offset = offset;
+			so->offset = sample->offset;
 		}
 
 		cur_log->nr_samples++;
@@ -3157,20 +3163,21 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 	 * had actual samples done.
 	 */
 	if (iolog->avg_window[ddir].samples) {
-		union io_sample_data data;
+		struct log_sample sample = { {{ 0, 0 }}, ddir, 0, 0, 0 };
+		union io_sample_data *d = &sample.data;
 
 		if (log_max == IO_LOG_SAMPLE_AVG) {
-			data.val.val0 = iolog->avg_window[ddir].mean.u.f + 0.50;
-			data.val.val1 = 0;
+			d->val.val0 = iolog->avg_window[ddir].mean.u.f + 0.50;
+			d->val.val1 = 0;
 		} else if (log_max == IO_LOG_SAMPLE_MAX) {
-			data.val.val0 = iolog->avg_window[ddir].max_val;
-			data.val.val1 = 0;
+			d->val.val0 = iolog->avg_window[ddir].max_val;
+			d->val.val1 = 0;
 		} else {
-			data.val.val0 = iolog->avg_window[ddir].mean.u.f + 0.50;
-			data.val.val1 = iolog->avg_window[ddir].max_val;
+			d->val.val0 = iolog->avg_window[ddir].mean.u.f + 0.50;
+			d->val.val1 = iolog->avg_window[ddir].max_val;
 		}
 
-		__add_log_sample(iolog, data, ddir, 0, elapsed, 0, 0);
+		__add_log_sample(iolog, elapsed, &sample);
 	}
 
 	reset_io_stat(&iolog->avg_window[ddir]);
@@ -3187,11 +3194,10 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 
 static unsigned long add_log_sample(struct thread_data *td,
 				    struct io_log *iolog,
-				    union io_sample_data data,
-				    enum fio_ddir ddir, unsigned long long bs,
-				    uint64_t offset, unsigned int ioprio)
+				    struct log_sample *sample)
 {
 	unsigned long elapsed, this_window;
+	enum fio_ddir ddir = sample->ddir;
 
 	if (!ddir_rw(ddir))
 		return 0;
@@ -3202,8 +3208,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * If no time averaging, just add the log sample.
 	 */
 	if (!iolog->avg_msec) {
-		__add_log_sample(iolog, data, ddir, bs, elapsed, offset,
-				 ioprio);
+		__add_log_sample(iolog, elapsed, sample);
 		return 0;
 	}
 
@@ -3211,7 +3216,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * Add the sample. If the time period has passed, then
 	 * add that entry to the log and clear.
 	 */
-	add_stat_sample(&iolog->avg_window[ddir], data.val.val0);
+	add_stat_sample(&iolog->avg_window[ddir], sample->data.val.val0);
 
 	/*
 	 * If period hasn't passed, adding the above sample is all we
@@ -3256,12 +3261,13 @@ void add_agg_sample(union io_sample_data data, enum fio_ddir ddir,
 		    unsigned long long bs)
 {
 	struct io_log *iolog;
+	struct log_sample sample = { data, ddir, bs, 0, 0 };
 
 	if (!ddir_rw(ddir))
 		return;
 
 	iolog = agg_io_log[ddir];
-	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0, 0);
+	__add_log_sample(iolog, mtime_since_genesis(), &sample);
 }
 
 void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
@@ -3331,9 +3337,12 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
 				     nsec);
 
-	if (td->clat_log)
-		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
-			       offset, ioprio);
+	if (td->clat_log) {
+		struct log_sample sample = { sample_val(nsec), ddir, bs,
+			offset, ioprio };
+
+		add_log_sample(td, td->clat_log, &sample);
+	}
 
 	if (ts->clat_percentiles) {
 		/*
@@ -3359,6 +3368,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		if (this_window >= iolog->hist_msec) {
 			uint64_t *io_u_plat;
 			struct io_u_plat_entry *dst;
+			struct log_sample sample = { {{ 0, 0 }}, ddir, bs,
+				offset, ioprio };
 
 			/*
 			 * Make a byte-for-byte copy of the latency histogram
@@ -3372,8 +3383,9 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			memcpy(&(dst->io_u_plat), io_u_plat,
 				FIO_IO_U_PLAT_NR * sizeof(uint64_t));
 			flist_add(&dst->list, &hw->list);
-			__add_log_sample(iolog, sample_plat(dst), ddir, bs,
-					 elapsed, offset, ioprio);
+
+			sample.data = sample_plat(dst);
+			__add_log_sample(iolog, elapsed, &sample);
 
 			/*
 			 * Update the last time we recorded as being now, minus
@@ -3407,9 +3419,12 @@ void add_slat_sample(struct thread_data *td, struct io_u *io_u)
 
 	add_stat_sample(&ts->slat_stat[ddir], nsec);
 
-	if (td->slat_log)
-		add_log_sample(td, td->slat_log, sample_val(nsec), ddir,
-			       io_u->xfer_buflen, io_u->offset, io_u->ioprio);
+	if (td->slat_log) {
+		struct log_sample sample = { sample_val(nsec), ddir,
+			io_u->xfer_buflen, io_u->offset, io_u->ioprio };
+
+		add_log_sample(td, td->slat_log, &sample);
+	}
 
 	if (ts->slat_percentiles)
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_SLAT);
@@ -3433,9 +3448,12 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	add_stat_sample(&ts->lat_stat[ddir], nsec);
 
-	if (td->lat_log)
-		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
-			       io_u->offset, io_u->ioprio);
+	if (td->lat_log) {
+		struct log_sample sample = { sample_val(nsec), ddir, bs,
+			io_u->offset, io_u->ioprio };
+
+		add_log_sample(td, td->lat_log, &sample);
+	}
 
 	/*
 	 * When lat_percentiles=1 (default 0), the reported per priority
@@ -3475,9 +3493,12 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 
 	add_stat_sample(&ts->bw_stat[io_u->ddir], rate);
 
-	if (td->bw_log)
-		add_log_sample(td, td->bw_log, sample_val(rate), io_u->ddir,
-			       bytes, io_u->offset, io_u->ioprio);
+	if (td->bw_log) {
+		struct log_sample sample = { sample_val(rate), io_u->ddir,
+			bytes, io_u->offset, io_u->ioprio };
+
+		add_log_sample(td, td->bw_log, &sample);
+	}
 
 	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
 
@@ -3526,13 +3547,12 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 		add_stat_sample(&stat[ddir], rate);
 
 		if (log) {
-			unsigned long long bs = 0;
+			struct log_sample sample = {
+				sample_val(rate), ddir, 0, 0, 0 };
 
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
-				bs = td->o.min_bs[ddir];
-
-			next = add_log_sample(td, log, sample_val(rate), ddir,
-					      bs, 0, 0);
+				sample.bs = td->o.min_bs[ddir];
+			next = add_log_sample(td, log, &sample);
 			next_log = min(next_log, next);
 		}
 
@@ -3570,9 +3590,12 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 
 	add_stat_sample(&ts->iops_stat[io_u->ddir], 1);
 
-	if (td->iops_log)
-		add_log_sample(td, td->iops_log, sample_val(1), io_u->ddir,
-			       bytes, io_u->offset, io_u->ioprio);
+	if (td->iops_log) {
+		struct log_sample sample = { sample_val(1), io_u->ddir, bytes,
+			io_u->offset, io_u->ioprio };
+
+		add_log_sample(td, td->iops_log, &sample);
+	}
 
 	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
 
-- 
2.45.2

