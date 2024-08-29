Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9232E18C344
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724921911; cv=none; b=ji5vm1dFuvVKOuBI/8EyjxHN3Uf8w2gs/CEt/ZWoI5f0HpoRI80p9Oh8b2Dw8vUzWq7eggKYQRR7ynxBbSXA4mctCNQXbDme1p8JKiEBu1ZNeRtSEy71cPOB0gbX8nvHr4l9wt45gDSq6J0LEjmYjgpO5Fc2VJWOvw6OXfC5gH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724921911; c=relaxed/simple;
	bh=wUHcd3/zWbSpdi6q237yp7kBch3b/NTFXC2pIe3IjYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bREzOzVZGxghvZij+1+FnLe4hJKZii1GZjZrz84DDALdiVNY4vUSPF1o1zjdkdJnVMEKrCOxO7+3cFqtgv0sTbkEXqOOd57oEj64zY3Cpeu91fvIR/H13lu33cL7PeT2pdKY+s5y5oXkZlXglWFvtAK8knSFX3ab4zvEHrAeqUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pecWfj/c; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pecWfj/c"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724921909; x=1756457909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wUHcd3/zWbSpdi6q237yp7kBch3b/NTFXC2pIe3IjYg=;
  b=pecWfj/cPugQUqDNIym+EfsaVlb16wGk923VNd+12mdQLtIhXlrLbyfX
   jr5a/L1by7LVuB1D26TwttQTquNXbI+Xf9D+1EsqUvam3/CwrTAbaNwZp
   uDaw3gb2ERRiaFBayvdNkRp4db5JW//Ots2c7iM1l7eejLHSXR5AtB+9Y
   01xZ8eJ1MOaWD+JyjKW8T/95IZEv7cR3X5Tk3oT6vsRqEin23Ep9QBz08
   VWpPL+j5pfq9tWqSbsj4OdP35vSrtL4Vre8AHaX1I9UgkoCZhC+kny0uC
   wC+gE/yUP5zj9ijJmX/kSo1BYWBlfcgyiuK0g3rMkci8VECQjIKkmfyVU
   w==;
X-CSE-ConnectionGUID: BEr6bF8DT428R+CItwKIWg==
X-CSE-MsgGUID: XgdeZr43QRqTDpu74OZy+Q==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="24854816"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:58:29 +0800
IronPort-SDR: 66d02a1f_0TttemlQfJjjkdYrPihJ6LyPIa80MHnMmuVJ9h1oEH1DaIA
 GHH0AVj25lORmVQPe6W/q9BEAZUElaZ5pQhwy4g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Aug 2024 00:58:23 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Aug 2024 01:58:27 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Nick Neumann <nick@pcpartpicker.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/9] stat: reduce arguments of add_*lat_sample() functions
Date: Thu, 29 Aug 2024 17:58:18 +0900
Message-ID: <20240829085826.999859-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
References: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The functions add_clat_sample(), add_lat_sample() and add_slat_sample()
have a rather large number of arguments, and some of the arguments are
members of the struct io_u. Pass io_u instead of those arguments to
reduce the number of arguments.

Some add_clat_sample() callers in engines/fileoperations.c do not have
io_u reference, then pass NULL instead of the io_u. This indicates to
use 0 values instead of the io_u fields.

While add_slat_sample() takes only struct thread_data * and struct
*io_u, add_clat_sample() and add_lat_sample() still require three more
arguments: 1) nsec is required because struct io_u does not have
completion time, 2) ddir is required to support fileoperations IO
engine, and 3) bs to record partial IO completion.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 engines/fileoperations.c |  6 +++---
 io_u.c                   | 14 +++-----------
 stat.c                   | 35 +++++++++++++++++++++++------------
 stat.h                   | 13 +++++++------
 4 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/engines/fileoperations.c b/engines/fileoperations.c
index c52f0900..e5303359 100644
--- a/engines/fileoperations.c
+++ b/engines/fileoperations.c
@@ -129,7 +129,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, NULL);
 	}
 
 	return 0;
@@ -200,7 +200,7 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, NULL);
 	}
 
 	return 0;
@@ -250,7 +250,7 @@ static int delete_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, NULL);
 	}
 
 	return 0;
diff --git a/io_u.c b/io_u.c
index 40b09082..c49cd4df 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2016,8 +2016,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		unsigned long long tnsec;
 
 		tnsec = ntime_since(&io_u->start_time, &icd->time);
-		add_lat_sample(td, idx, tnsec, bytes, io_u->offset,
-			       io_u->ioprio, io_u->clat_prio_index);
+		add_lat_sample(td, idx, tnsec, bytes, io_u);
 
 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops = &td->prof_io_ops;
@@ -2038,8 +2037,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 	if (ddir_rw(idx)) {
 		if (!td->o.disable_clat) {
-			add_clat_sample(td, idx, llnsec, bytes, io_u->offset,
-					io_u->ioprio, io_u->clat_prio_index);
+			add_clat_sample(td, idx, llnsec, bytes, io_u);
 			io_u_mark_latency(td, llnsec);
 		}
 
@@ -2301,15 +2299,9 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 void io_u_queued(struct thread_data *td, struct io_u *io_u)
 {
 	if (!td->o.disable_slat && ramp_time_over(td) && td->o.stats) {
-		unsigned long slat_time;
-
-		slat_time = ntime_since(&io_u->start_time, &io_u->issue_time);
-
 		if (td->parent)
 			td = td->parent;
-
-		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen,
-				io_u->offset, io_u->ioprio);
+		add_slat_sample(td, io_u);
 	}
 }
 
diff --git a/stat.c b/stat.c
index b98e8b27..fac6d534 100644
--- a/stat.c
+++ b/stat.c
@@ -3297,17 +3297,25 @@ add_lat_percentile_prio_sample(struct thread_stat *ts, unsigned long long nsec,
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long long nsec, unsigned long long bs,
-		     uint64_t offset, unsigned int ioprio,
-		     unsigned short clat_prio_index)
+		     struct io_u *io_u)
 {
 	const bool needs_lock = td_async_processing(td);
 	unsigned long elapsed, this_window;
 	struct thread_stat *ts = &td->ts;
 	struct io_log *iolog = td->clat_hist_log;
+	uint64_t offset = 0;
+	unsigned int ioprio = 0;
+	unsigned short clat_prio_index = 0;
 
 	if (needs_lock)
 		__td_io_u_lock(td);
 
+	if (io_u) {
+		offset = io_u->offset;
+		ioprio = io_u->ioprio;
+		clat_prio_index = io_u->clat_prio_index;
+	}
+
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
 	/*
@@ -3381,24 +3389,27 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		__td_io_u_unlock(td);
 }
 
-void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long long nsec, unsigned long long bs,
-		     uint64_t offset, unsigned int ioprio)
+void add_slat_sample(struct thread_data *td, struct io_u *io_u)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
+	enum fio_ddir ddir;
+	unsigned long long nsec;
 
+	ddir = io_u->ddir;
 	if (!ddir_rw(ddir))
 		return;
 
 	if (needs_lock)
 		__td_io_u_lock(td);
 
+	nsec = ntime_since(&io_u->start_time, &io_u->issue_time);
+
 	add_stat_sample(&ts->slat_stat[ddir], nsec);
 
 	if (td->slat_log)
-		add_log_sample(td, td->slat_log, sample_val(nsec), ddir, bs,
-			       offset, ioprio);
+		add_log_sample(td, td->slat_log, sample_val(nsec), ddir,
+			       io_u->xfer_buflen, io_u->offset, io_u->ioprio);
 
 	if (ts->slat_percentiles)
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_SLAT);
@@ -3409,8 +3420,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		    unsigned long long nsec, unsigned long long bs,
-		    uint64_t offset, unsigned int ioprio,
-		    unsigned short clat_prio_index)
+		    struct io_u * io_u)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -3425,7 +3435,7 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->lat_log)
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
-			       offset, ioprio);
+			       io_u->offset, io_u->ioprio);
 
 	/*
 	 * When lat_percentiles=1 (default 0), the reported per priority
@@ -3439,8 +3449,9 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 	 */
 	if (ts->lat_percentiles) {
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
-		add_lat_percentile_prio_sample(ts, nsec, ddir, clat_prio_index);
-		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
+		add_lat_percentile_prio_sample(ts, nsec, ddir,
+					       io_u->clat_prio_index);
+		add_stat_prio_sample(ts->clat_prio[ddir], io_u->clat_prio_index,
 				     nsec);
 	}
 	if (needs_lock)
diff --git a/stat.h b/stat.h
index 0d57cceb..ac74d6c2 100644
--- a/stat.h
+++ b/stat.h
@@ -366,12 +366,13 @@ extern void reset_io_stats(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
 
-extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-			   unsigned long long, uint64_t, unsigned int, unsigned short);
-extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-			    unsigned long long, uint64_t, unsigned int, unsigned short);
-extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t, unsigned int);
+extern void add_lat_sample(struct thread_data *, enum fio_ddir,
+			   unsigned long long, unsigned long long,
+			   struct io_u *);
+extern void add_clat_sample(struct thread_data *, enum fio_ddir,
+			    unsigned long long, unsigned long long,
+			    struct io_u *);
+extern void add_slat_sample(struct thread_data *, struct io_u *);
 extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long);
 extern void add_iops_sample(struct thread_data *, struct io_u *,
 				unsigned int);
-- 
2.45.2

