Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbhCKNAg (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Mar 2021 08:00:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97855C061574
        for <fio@vger.kernel.org>; Thu, 11 Mar 2021 05:00:36 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKKv7-007KfZ-0v
        for fio@vger.kernel.org; Thu, 11 Mar 2021 13:00:21 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210311130002.230601BC0158@kernel.dk>
Date: Thu, 11 Mar 2021 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6b8cadb66c62394420a39b46af1a2967b916c829:

  Merge branch 'master' of https://github.com/DevriesL/fio (2021-03-09 07:58:39 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9697503cacf01c2b83f09973a6c8f9439156ce63:

  Merge branch 'fallock-blkdev' of https://github.com/dmonakhov/fio (2021-03-10 13:30:23 -0700)

----------------------------------------------------------------
Dmitry Monakhov (1):
      engines/falloc: add blockdevice as a target

Jens Axboe (2):
      Merge branch 'master' of https://github.com/venkatrag1/fio
      Merge branch 'fallock-blkdev' of https://github.com/dmonakhov/fio

Venkat Ramesh (1):
      options: allow separate values for max_latency

 HOWTO            |  5 +++--
 cconv.c          |  6 ++++--
 engines/falloc.c |  4 ++--
 fio.1            |  5 +++--
 init.c           |  4 +++-
 io_u.c           | 23 +++++++++++++++--------
 options.c        |  6 ++++--
 server.h         |  2 +-
 thread_options.h |  4 ++--
 9 files changed, 37 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 52812cc7..1e5ebd5d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2663,11 +2663,12 @@ I/O latency
 	true, fio will continue running and try to meet :option:`latency_target`
 	by adjusting queue depth.
 
-.. option:: max_latency=time
+.. option:: max_latency=time[,time][,time]
 
 	If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
 	maximum latency. When the unit is omitted, the value is interpreted in
-	microseconds.
+	microseconds. Comma-separated values may be specified for reads, writes,
+	and trims as described in :option:`blocksize`.
 
 .. option:: rate_cycle=int
 
diff --git a/cconv.c b/cconv.c
index b10868fb..aa06e3ea 100644
--- a/cconv.c
+++ b/cconv.c
@@ -143,6 +143,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 		o->rate_iops_min[i] = le32_to_cpu(top->rate_iops_min[i]);
 
 		o->perc_rand[i] = le32_to_cpu(top->perc_rand[i]);
+
+		o->max_latency[i] = le64_to_cpu(top->max_latency[i]);
 	}
 
 	o->ratecycle = le32_to_cpu(top->ratecycle);
@@ -289,7 +291,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->sync_file_range = le32_to_cpu(top->sync_file_range);
 	o->latency_target = le64_to_cpu(top->latency_target);
 	o->latency_window = le64_to_cpu(top->latency_window);
-	o->max_latency = le64_to_cpu(top->max_latency);
 	o->latency_percentile.u.f = fio_uint64_to_double(le64_to_cpu(top->latency_percentile.u.i));
 	o->latency_run = le32_to_cpu(top->latency_run);
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
@@ -491,7 +492,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->sync_file_range = cpu_to_le32(o->sync_file_range);
 	top->latency_target = __cpu_to_le64(o->latency_target);
 	top->latency_window = __cpu_to_le64(o->latency_window);
-	top->max_latency = __cpu_to_le64(o->max_latency);
 	top->latency_percentile.u.i = __cpu_to_le64(fio_double_to_uint64(o->latency_percentile.u.f));
 	top->latency_run = __cpu_to_le32(o->latency_run);
 	top->compress_percentage = cpu_to_le32(o->compress_percentage);
@@ -550,6 +550,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 		top->rate_iops_min[i] = cpu_to_le32(o->rate_iops_min[i]);
 
 		top->perc_rand[i] = cpu_to_le32(o->perc_rand[i]);
+
+		top->max_latency[i] = __cpu_to_le64(o->max_latency[i]);
 	}
 
 	memcpy(top->verify_pattern, o->verify_pattern, MAX_PATTERN_SIZE);
diff --git a/engines/falloc.c b/engines/falloc.c
index 6382569b..4b05ed68 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -25,8 +25,8 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 
 	dprint(FD_FILE, "fd open %s\n", f->file_name);
 
-	if (f->filetype != FIO_TYPE_FILE) {
-		log_err("fio: only files are supported fallocate \n");
+	if (f->filetype != FIO_TYPE_FILE && f->filetype != FIO_TYPE_BLOCK) {
+		log_err("fio: only files and blockdev are supported fallocate \n");
 		return 1;
 	}
 	if (!strcmp(f->file_name, "-")) {
diff --git a/fio.1 b/fio.1
index 2c0d8348..b95a67ab 100644
--- a/fio.1
+++ b/fio.1
@@ -2403,10 +2403,11 @@ Used with \fBlatency_target\fR. If false (default), fio will find the highest
 queue depth that meets \fBlatency_target\fR and exit. If true, fio will continue
 running and try to meet \fBlatency_target\fR by adjusting queue depth.
 .TP
-.BI max_latency \fR=\fPtime
+.BI max_latency \fR=\fPtime[,time][,time]
 If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
 maximum latency. When the unit is omitted, the value is interpreted in
-microseconds.
+microseconds. Comma-separated values may be specified for reads, writes,
+and trims as described in \fBblocksize\fR.
 .TP
 .BI rate_cycle \fR=\fPint
 Average bandwidth for \fBrate\fR and \fBrate_min\fR over this number
diff --git a/init.c b/init.c
index eea6e546..e8530fec 100644
--- a/init.c
+++ b/init.c
@@ -961,7 +961,9 @@ static int fixup_options(struct thread_data *td)
 	/*
 	 * Fix these up to be nsec internally
 	 */
-	o->max_latency *= 1000ULL;
+	for_each_rw_ddir(ddir)
+		o->max_latency[ddir] *= 1000ULL;
+
 	o->latency_target *= 1000ULL;
 
 	return ret;
diff --git a/io_u.c b/io_u.c
index 00a219c2..b421a579 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1389,11 +1389,16 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
-static void lat_fatal(struct thread_data *td, struct io_completion_data *icd,
+static void lat_fatal(struct thread_data *td, struct io_u *io_u, struct io_completion_data *icd,
 		      unsigned long long tnsec, unsigned long long max_nsec)
 {
-	if (!td->error)
-		log_err("fio: latency of %llu nsec exceeds specified max (%llu nsec)\n", tnsec, max_nsec);
+	if (!td->error) {
+		log_err("fio: latency of %llu nsec exceeds specified max (%llu nsec): %s %s %llu %llu\n",
+					tnsec, max_nsec,
+					io_u->file->file_name,
+					io_ddir_name(io_u->ddir),
+					io_u->offset, io_u->buflen);
+	}
 	td_verror(td, ETIMEDOUT, "max latency exceeded");
 	icd->error = ETIMEDOUT;
 }
@@ -1888,11 +1893,13 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 				icd->error = ops->io_u_lat(td, tnsec);
 		}
 
-		if (td->o.max_latency && tnsec > td->o.max_latency)
-			lat_fatal(td, icd, tnsec, td->o.max_latency);
-		if (td->o.latency_target && tnsec > td->o.latency_target) {
-			if (lat_target_failed(td))
-				lat_fatal(td, icd, tnsec, td->o.latency_target);
+		if (ddir_rw(idx)) {
+			if (td->o.max_latency[idx] && tnsec > td->o.max_latency[idx])
+				lat_fatal(td, io_u, icd, tnsec, td->o.max_latency[idx]);
+			if (td->o.latency_target && tnsec > td->o.latency_target) {
+				if (lat_target_failed(td))
+					lat_fatal(td, io_u, icd, tnsec, td->o.latency_target);
+			}
 		}
 	}
 
diff --git a/options.c b/options.c
index e3b0c4ef..0791101e 100644
--- a/options.c
+++ b/options.c
@@ -3756,8 +3756,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "max_latency",
 		.lname	= "Max Latency (usec)",
-		.type	= FIO_OPT_STR_VAL_TIME,
-		.off1	= offsetof(struct thread_options, max_latency),
+		.type	= FIO_OPT_ULL,
+		.off1	= offsetof(struct thread_options, max_latency[DDIR_READ]),
+		.off2	= offsetof(struct thread_options, max_latency[DDIR_WRITE]),
+		.off3	= offsetof(struct thread_options, max_latency[DDIR_TRIM]),
 		.help	= "Maximum tolerated IO latency (usec)",
 		.is_time = 1,
 		.category = FIO_OPT_C_IO,
diff --git a/server.h b/server.h
index 74618ca7..b45b319b 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 88,
+	FIO_SERVER_VER			= 89,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 88fd7ad9..5ecc72d7 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -207,7 +207,7 @@ struct thread_options {
 	enum fio_memtype mem_type;
 	unsigned int mem_align;
 
-	unsigned long long max_latency;
+	unsigned long long max_latency[DDIR_RWDIR_CNT];
 
 	unsigned int exit_what;
 	unsigned int stonewall;
@@ -629,7 +629,7 @@ struct thread_options_pack {
 
 	uint64_t latency_target;
 	uint64_t latency_window;
-	uint64_t max_latency;
+	uint64_t max_latency[DDIR_RWDIR_CNT];
 	uint32_t pad5;
 	fio_fp64_t latency_percentile;
 	uint32_t latency_run;

