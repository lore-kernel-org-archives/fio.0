Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460B6CA0ECA
	for <fio@archiver.kernel.org>; Tue, 12 Sep 2023 12:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbjILMBL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 12 Sep 2023 08:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbjILMAt (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Sep 2023 08:00:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEB919B7
        for <fio@vger.kernel.org>; Tue, 12 Sep 2023 05:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=QYXuAYnto4Gxc0FOiETePleHlP/DF5t3MGKtzXrOfrI=; b=f4lmA0EOqNe1qspbdo9lp6fybq
        EHeo/VuZZg8w/iBljYz09xdfqVj6LxyyoS6LmjSTiIMxWMkALsAbL/N/1VKBS4n9U3i20+YD1Fscw
        mmPw/EieQNKL6gBK2SZdl5OksdBkmsKH8IblnsbwHe2zxW/1ONg/dFzdTZJjg8RT4qYR/KivTdxdP
        pErVNAkoER52sZhw6LlsyX+nBiWqLRglU5mdDFc6o47aQGl7dqr3aOEWHWiE5B9i6Kjr4LS//81X/
        ZOGdFEMx50fehmjxu2lOiB9DX7FTvNw7lBxdSf8fNUp9cK5baV0KNWfPwG4Re365SIFcdEOhhDA8I
        VA712uMw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qg23v-0065af-2L
        for fio@vger.kernel.org;
        Tue, 12 Sep 2023 12:00:13 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D17501BC017F; Tue, 12 Sep 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230912120001.D17501BC017F@kernel.dk>
Date:   Tue, 12 Sep 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 904ee91c2831615a054a8dea9b164e96ae00abb3:

  Merge branch 'pcpp_parse_nr_fix' of https://github.com/PCPartPicker/fio (2023-09-02 07:35:49 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e4a9812dee084b058eca6ebde9634a3d573a0079:

  engines:nvme: fill command fields as per pi check bits (2023-09-11 10:55:56 -0600)

----------------------------------------------------------------
Ankit Kumar (2):
      engines:io_uring_cmd: disallow verify for e2e pi with extended blocks
      engines:nvme: fill command fields as per pi check bits

Vincent Fu (1):
      Merge branch 'pcpp_epoch_fixing_2' of https://github.com/PCPartPicker/fio

aggieNick02 (2):
      Record job start time to fix time pain points
      Make log_unix_epoch an official alias of log_alternate_epoch

 HOWTO.rst          | 21 +++++++++++++++------
 backend.c          |  2 +-
 cconv.c            |  4 ++--
 client.c           |  1 +
 engines/io_uring.c | 14 ++++++++++++++
 engines/nvme.c     | 15 ++++++++++-----
 fio.1              | 23 +++++++++++++++++------
 fio.h              |  3 ++-
 fio_time.h         |  2 +-
 libfio.c           |  2 +-
 options.c          | 22 ++++++++++++----------
 rate-submit.c      |  2 +-
 server.c           |  1 +
 stat.c             |  6 +++++-
 stat.h             |  1 +
 thread_options.h   |  8 +++-----
 time.c             | 20 ++++++++++++++------
 17 files changed, 101 insertions(+), 46 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 89032941..7f26978a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -755,6 +755,10 @@ Time related parameters
 	calls will be excluded from other uses. Fio will manually clear it from the
 	CPU mask of other jobs.
 
+.. option:: job_start_clock_id=int
+   The clock_id passed to the call to `clock_gettime` used to record job_start
+   in the `json` output format. Default is 0, or CLOCK_REALTIME.
+
 
 Target file/device
 ~~~~~~~~~~~~~~~~~~
@@ -3966,6 +3970,13 @@ Measurements and reporting
 	same reporting group, unless if separated by a :option:`stonewall`, or by
 	using :option:`new_group`.
 
+    NOTE: When :option: `group_reporting` is used along with `json` output,
+    there are certain per-job properties which can be different between jobs
+    but do not have a natural group-level equivalent. Examples include
+    `kb_base`, `unit_base`, `sig_figs`, `thread_number`, `pid`, and
+    `job_start`. For these properties, the values for the first job are
+    recorded for the group.
+
 .. option:: new_group
 
 	Start a new reporting group. See: :option:`group_reporting`.  If not given,
@@ -4103,9 +4114,7 @@ Measurements and reporting
 
 .. option:: log_unix_epoch=bool
 
-	If set, fio will log Unix timestamps to the log files produced by enabling
-	write_type_log for each log type, instead of the default zero-based
-	timestamps.
+	Backwards compatible alias for log_alternate_epoch.
 
 .. option:: log_alternate_epoch=bool
 
@@ -4116,9 +4125,9 @@ Measurements and reporting
 
 .. option:: log_alternate_epoch_clock_id=int
 
-	Specifies the clock_id to be used by clock_gettime to obtain the alternate epoch
-	if either log_unix_epoch or log_alternate_epoch are true. Otherwise has no
-	effect. Default value is 0, or CLOCK_REALTIME.
+    Specifies the clock_id to be used by clock_gettime to obtain the alternate
+    epoch if log_alternate_epoch is true. Otherwise has no effect. Default
+    value is 0, or CLOCK_REALTIME.
 
 .. option:: block_error_percentiles=bool
 
diff --git a/backend.c b/backend.c
index 5f074039..a5895fec 100644
--- a/backend.c
+++ b/backend.c
@@ -1858,7 +1858,7 @@ static void *thread_main(void *data)
 	if (rate_submit_init(td, sk_out))
 		goto err;
 
-	set_epoch_time(td, o->log_unix_epoch | o->log_alternate_epoch, o->log_alternate_epoch_clock_id);
+	set_epoch_time(td, o->log_alternate_epoch_clock_id, o->job_start_clock_id);
 	fio_getrusage(&td->ru_start);
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
diff --git a/cconv.c b/cconv.c
index ce6acbe6..341388d4 100644
--- a/cconv.c
+++ b/cconv.c
@@ -216,9 +216,9 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->log_prio = le32_to_cpu(top->log_prio);
 	o->log_gz = le32_to_cpu(top->log_gz);
 	o->log_gz_store = le32_to_cpu(top->log_gz_store);
-	o->log_unix_epoch = le32_to_cpu(top->log_unix_epoch);
 	o->log_alternate_epoch = le32_to_cpu(top->log_alternate_epoch);
 	o->log_alternate_epoch_clock_id = le32_to_cpu(top->log_alternate_epoch_clock_id);
+	o->job_start_clock_id = le32_to_cpu(top->job_start_clock_id);
 	o->norandommap = le32_to_cpu(top->norandommap);
 	o->softrandommap = le32_to_cpu(top->softrandommap);
 	o->bs_unaligned = le32_to_cpu(top->bs_unaligned);
@@ -455,9 +455,9 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->log_prio = cpu_to_le32(o->log_prio);
 	top->log_gz = cpu_to_le32(o->log_gz);
 	top->log_gz_store = cpu_to_le32(o->log_gz_store);
-	top->log_unix_epoch = cpu_to_le32(o->log_unix_epoch);
 	top->log_alternate_epoch = cpu_to_le32(o->log_alternate_epoch);
 	top->log_alternate_epoch_clock_id = cpu_to_le32(o->log_alternate_epoch_clock_id);
+	top->job_start_clock_id = cpu_to_le32(o->job_start_clock_id);
 	top->norandommap = cpu_to_le32(o->norandommap);
 	top->softrandommap = cpu_to_le32(o->softrandommap);
 	top->bs_unaligned = cpu_to_le32(o->bs_unaligned);
diff --git a/client.c b/client.c
index c257036b..345fa910 100644
--- a/client.c
+++ b/client.c
@@ -956,6 +956,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->error		= le32_to_cpu(src->error);
 	dst->thread_number	= le32_to_cpu(src->thread_number);
 	dst->groupid		= le32_to_cpu(src->groupid);
+	dst->job_start		= le64_to_cpu(src->job_start);
 	dst->pid		= le32_to_cpu(src->pid);
 	dst->members		= le32_to_cpu(src->members);
 	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6cdf1b4f..05703df8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -18,6 +18,7 @@
 #include "../lib/memalign.h"
 #include "../lib/fls.h"
 #include "../lib/roundup.h"
+#include "../verify.h"
 
 #ifdef ARCH_HAVE_IOURING
 
@@ -1299,6 +1300,19 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 				return 1;
 			}
                 }
+
+		/*
+		 * For extended logical block sizes we cannot use verify when
+		 * end to end data protection checks are enabled, as the PI
+		 * section of data buffer conflicts with verify.
+		 */
+		if (data->ms && data->pi_type && data->lba_ext &&
+		    td->o.verify != VERIFY_NONE) {
+			log_err("%s: for extended LBA, verify cannot be used when E2E data protection is enabled\n",
+				f->file_name);
+			td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+			return 1;
+		}
 	}
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
diff --git a/engines/nvme.c b/engines/nvme.c
index 08503b33..75a5e0c1 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -415,19 +415,24 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	case NVME_NS_DPS_PI_TYPE2:
 		switch (data->guard_type) {
 		case NVME_NVM_NS_16B_GUARD:
-			cmd->cdw14 = (__u32)slba;
+			if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF)
+				cmd->cdw14 = (__u32)slba;
 			break;
 		case NVME_NVM_NS_64B_GUARD:
-			cmd->cdw14 = (__u32)slba;
-			cmd->cdw3 = ((slba >> 32) & 0xffff);
+			if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+				cmd->cdw14 = (__u32)slba;
+				cmd->cdw3 = ((slba >> 32) & 0xffff);
+			}
 			break;
 		default:
 			break;
 		}
-		cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
+			cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
 		break;
 	case NVME_NS_DPS_PI_TYPE3:
-		cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
+			cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
 		break;
 	case NVME_NS_DPS_PI_NONE:
 		break;
diff --git a/fio.1 b/fio.1
index f0dc49ab..8159caa4 100644
--- a/fio.1
+++ b/fio.1
@@ -537,6 +537,10 @@ copy that segment, instead of entering the kernel with a
 \fBgettimeofday\fR\|(2) call. The CPU set aside for doing these time
 calls will be excluded from other uses. Fio will manually clear it from the
 CPU mask of other jobs.
+.TP
+.BI job_start_clock_id \fR=\fPint
+The clock_id passed to the call to \fBclock_gettime\fR used to record job_start
+in the \fBjson\fR output format. Default is 0, or CLOCK_REALTIME.
 .SS "Target file/device"
 .TP
 .BI directory \fR=\fPstr
@@ -3664,6 +3668,15 @@ quickly becomes unwieldy. To see the final report per-group instead of
 per-job, use \fBgroup_reporting\fR. Jobs in a file will be part of the
 same reporting group, unless if separated by a \fBstonewall\fR, or by
 using \fBnew_group\fR.
+.RS
+.P
+NOTE: When \fBgroup_reporting\fR is used along with \fBjson\fR output, there
+are certain per-job properties which can be different between jobs but do not
+have a natural group-level equivalent. Examples include \fBkb_base\fR,
+\fBunit_base\fR, \fBsig_figs\fR, \fBthread_number\fR, \fBpid\fR, and
+\fBjob_start\fR. For these properties, the values for the first job are
+recorded for the group.
+.RE
 .TP
 .BI new_group
 Start a new reporting group. See: \fBgroup_reporting\fR. If not given,
@@ -3795,9 +3808,7 @@ decompressed with fio, using the \fB\-\-inflate\-log\fR command line
 parameter. The files will be stored with a `.fz' suffix.
 .TP
 .BI log_unix_epoch \fR=\fPbool
-If set, fio will log Unix timestamps to the log files produced by enabling
-write_type_log for each log type, instead of the default zero-based
-timestamps.
+Backward-compatible alias for \fBlog_alternate_epoch\fR.
 .TP
 .BI log_alternate_epoch \fR=\fPbool
 If set, fio will log timestamps based on the epoch used by the clock specified
@@ -3806,9 +3817,9 @@ enabling write_type_log for each log type, instead of the default zero-based
 timestamps.
 .TP
 .BI log_alternate_epoch_clock_id \fR=\fPint
-Specifies the clock_id to be used by clock_gettime to obtain the alternate epoch
-if either \fBBlog_unix_epoch\fR or \fBlog_alternate_epoch\fR are true. Otherwise has no
-effect. Default value is 0, or CLOCK_REALTIME.
+Specifies the clock_id to be used by clock_gettime to obtain the alternate
+epoch if \fBlog_alternate_epoch\fR is true. Otherwise has no effect. Default
+value is 0, or CLOCK_REALTIME.
 .TP
 .BI block_error_percentiles \fR=\fPbool
 If set, record errors in trim block-sized units from writes and trims and
diff --git a/fio.h b/fio.h
index a54f57c9..1322656f 100644
--- a/fio.h
+++ b/fio.h
@@ -388,7 +388,8 @@ struct thread_data {
 
 	struct timespec start;	/* start of this loop */
 	struct timespec epoch;	/* time job was started */
-	unsigned long long alternate_epoch; /* Time job was started, clock_gettime's clock_id epoch based. */
+	unsigned long long alternate_epoch; /* Time job was started, as clock_gettime(log_alternate_epoch_clock_id) */
+	unsigned long long job_start; /* Time job was started, as clock_gettime(job_start_clock_id) */
 	struct timespec last_issue;
 	long time_offset;
 	struct timespec ts_cache;
diff --git a/fio_time.h b/fio_time.h
index 62d92120..b20e734c 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -30,6 +30,6 @@ extern bool ramp_time_over(struct thread_data *);
 extern bool in_ramp_time(struct thread_data *);
 extern void fio_time_init(void);
 extern void timespec_add_msec(struct timespec *, unsigned int);
-extern void set_epoch_time(struct thread_data *, int, clockid_t);
+extern void set_epoch_time(struct thread_data *, clockid_t, clockid_t);
 
 #endif
diff --git a/libfio.c b/libfio.c
index 237ce34c..5c433277 100644
--- a/libfio.c
+++ b/libfio.c
@@ -149,7 +149,7 @@ void reset_all_stats(struct thread_data *td)
 		td->ts.runtime[i] = 0;
 	}
 
-	set_epoch_time(td, td->o.log_unix_epoch | td->o.log_alternate_epoch, td->o.log_alternate_epoch_clock_id);
+	set_epoch_time(td, td->o.log_alternate_epoch_clock_id, td->o.job_start_clock_id);
 	memcpy(&td->start, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
diff --git a/options.c b/options.c
index 65b2813c..6b2cb53f 100644
--- a/options.c
+++ b/options.c
@@ -4612,17 +4612,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.help	= "Install libz-dev(el) to get compression support",
 	},
 #endif
-	{
-		.name = "log_unix_epoch",
-		.lname = "Log epoch unix",
-		.type = FIO_OPT_BOOL,
-		.off1 = offsetof(struct thread_options, log_unix_epoch),
-		.help = "Use Unix time in log files",
-		.category = FIO_OPT_C_LOG,
-		.group = FIO_OPT_G_INVALID,
-	},
 	{
 		.name = "log_alternate_epoch",
+		.alias = "log_unix_epoch",
 		.lname = "Log epoch alternate",
 		.type = FIO_OPT_BOOL,
 		.off1 = offsetof(struct thread_options, log_alternate_epoch),
@@ -4635,7 +4627,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname = "Log alternate epoch clock_id",
 		.type = FIO_OPT_INT,
 		.off1 = offsetof(struct thread_options, log_alternate_epoch_clock_id),
-		.help = "If log_alternate_epoch or log_unix_epoch is true, this option specifies the clock_id from clock_gettime whose epoch should be used. If neither of those is true, this option has no effect. Default value is 0, or CLOCK_REALTIME",
+		.help = "If log_alternate_epoch is true, this option specifies the clock_id from clock_gettime whose epoch should be used. If log_alternate_epoch is false, this option has no effect. Default value is 0, or CLOCK_REALTIME",
 		.category = FIO_OPT_C_LOG,
 		.group = FIO_OPT_G_INVALID,
 	},
@@ -4964,6 +4956,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CLOCK,
 	},
+	{
+		.name	= "job_start_clock_id",
+		.lname	= "Job start clock_id",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, job_start_clock_id),
+		.help	= "The clock_id passed to the call to clock_gettime used to record job_start in the json output format. Default is 0, or CLOCK_REALTIME",
+		.verify	= gtod_cpu_verify,
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_CLOCK,
+	},
 	{
 		.name	= "unified_rw_reporting",
 		.lname	= "Unified RW Reporting",
diff --git a/rate-submit.c b/rate-submit.c
index 6f6d15bd..92be3df7 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -185,7 +185,7 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	if (td->io_ops->post_init && td->io_ops->post_init(td))
 		goto err_io_init;
 
-	set_epoch_time(td, td->o.log_unix_epoch | td->o.log_alternate_epoch, td->o.log_alternate_epoch_clock_id);
+	set_epoch_time(td, td->o.log_alternate_epoch_clock_id, td->o.job_start_clock_id);
 	fio_getrusage(&td->ru_start);
 	clear_io_state(td, 1);
 
diff --git a/server.c b/server.c
index bb423702..27332e32 100644
--- a/server.c
+++ b/server.c
@@ -1706,6 +1706,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.error		= cpu_to_le32(ts->error);
 	p.ts.thread_number	= cpu_to_le32(ts->thread_number);
 	p.ts.groupid		= cpu_to_le32(ts->groupid);
+	p.ts.job_start		= cpu_to_le64(ts->job_start);
 	p.ts.pid		= cpu_to_le32(ts->pid);
 	p.ts.members		= cpu_to_le32(ts->members);
 	p.ts.unified_rw_rep	= cpu_to_le32(ts->unified_rw_rep);
diff --git a/stat.c b/stat.c
index 7b791628..7cf6bee1 100644
--- a/stat.c
+++ b/stat.c
@@ -1712,6 +1712,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	root = json_create_object();
 	json_object_add_value_string(root, "jobname", ts->name);
 	json_object_add_value_int(root, "groupid", ts->groupid);
+	json_object_add_value_int(root, "job_start", ts->job_start);
 	json_object_add_value_int(root, "error", ts->error);
 
 	/* ETA Info */
@@ -2526,6 +2527,7 @@ void __show_run_stats(void)
 			 */
 			ts->thread_number = td->thread_number;
 			ts->groupid = td->groupid;
+			ts->job_start = td->job_start;
 
 			/*
 			 * first pid in group, not very useful...
@@ -3048,7 +3050,9 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 		s = get_sample(iolog, cur_log, cur_log->nr_samples);
 
 		s->data = data;
-		s->time = t + (iolog->td ? iolog->td->alternate_epoch : 0);
+		s->time = t;
+		if (iolog->td && iolog->td->o.log_alternate_epoch)
+			s->time += iolog->td->alternate_epoch;
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
 		s->priority = priority;
diff --git a/stat.h b/stat.h
index 8ceabc48..bd986d4e 100644
--- a/stat.h
+++ b/stat.h
@@ -169,6 +169,7 @@ struct thread_stat {
 	uint32_t error;
 	uint32_t thread_number;
 	uint32_t groupid;
+	uint64_t job_start; /* Time job was started, as clock_gettime(job_start_clock_id) */
 	uint32_t pid;
 	char description[FIO_JOBDESC_SIZE];
 	uint32_t members;
diff --git a/thread_options.h b/thread_options.h
index 38a9993d..fdde055e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -170,7 +170,6 @@ struct thread_options {
 	unsigned int log_offset;
 	unsigned int log_gz;
 	unsigned int log_gz_store;
-	unsigned int log_unix_epoch;
 	unsigned int log_alternate_epoch;
 	unsigned int log_alternate_epoch_clock_id;
 	unsigned int norandommap;
@@ -273,6 +272,7 @@ struct thread_options {
 	unsigned int unified_rw_rep;
 	unsigned int gtod_reduce;
 	unsigned int gtod_cpu;
+	unsigned int job_start_clock_id;
 	enum fio_cs clocksource;
 	unsigned int no_stall;
 	unsigned int trim_percentage;
@@ -422,7 +422,6 @@ struct thread_options_pack {
 	uint32_t iodepth_batch_complete_min;
 	uint32_t iodepth_batch_complete_max;
 	uint32_t serialize_overlap;
-	uint32_t pad;
 
 	uint64_t size;
 	uint64_t io_size;
@@ -433,13 +432,11 @@ struct thread_options_pack {
 	uint32_t fill_device;
 	uint32_t file_append;
 	uint32_t unique_filename;
-	uint32_t pad3;
 	uint64_t file_size_low;
 	uint64_t file_size_high;
 	uint64_t start_offset;
 	uint64_t start_offset_align;
 	uint32_t start_offset_nz;
-	uint32_t pad4;
 
 	uint64_t bs[DDIR_RWDIR_CNT];
 	uint64_t ba[DDIR_RWDIR_CNT];
@@ -494,7 +491,6 @@ struct thread_options_pack {
 	uint32_t log_offset;
 	uint32_t log_gz;
 	uint32_t log_gz_store;
-	uint32_t log_unix_epoch;
 	uint32_t log_alternate_epoch;
 	uint32_t log_alternate_epoch_clock_id;
 	uint32_t norandommap;
@@ -593,6 +589,7 @@ struct thread_options_pack {
 	uint32_t unified_rw_rep;
 	uint32_t gtod_reduce;
 	uint32_t gtod_cpu;
+	uint32_t job_start_clock_id;
 	uint32_t clocksource;
 	uint32_t no_stall;
 	uint32_t trim_percentage;
@@ -603,6 +600,7 @@ struct thread_options_pack {
 	uint32_t lat_percentiles;
 	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
+	uint32_t pad;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
diff --git a/time.c b/time.c
index 5c4d6de0..7cbab6ff 100644
--- a/time.c
+++ b/time.c
@@ -172,14 +172,22 @@ void set_genesis_time(void)
 	fio_gettime(&genesis, NULL);
 }
 
-void set_epoch_time(struct thread_data *td, int log_alternate_epoch, clockid_t clock_id)
+void set_epoch_time(struct thread_data *td, clockid_t log_alternate_epoch_clock_id, clockid_t job_start_clock_id)
 {
+	struct timespec ts;
 	fio_gettime(&td->epoch, NULL);
-	if (log_alternate_epoch) {
-		struct timespec ts;
-		clock_gettime(clock_id, &ts);
-		td->alternate_epoch = (unsigned long long)(ts.tv_sec) * 1000 +
-		                 (unsigned long long)(ts.tv_nsec) / 1000000;
+	clock_gettime(log_alternate_epoch_clock_id, &ts);
+	td->alternate_epoch = (unsigned long long)(ts.tv_sec) * 1000 +
+						  (unsigned long long)(ts.tv_nsec) / 1000000;
+	if (job_start_clock_id == log_alternate_epoch_clock_id)
+	{
+		td->job_start = td->alternate_epoch;
+	}
+	else
+	{
+		clock_gettime(job_start_clock_id, &ts);
+		td->job_start = (unsigned long long)(ts.tv_sec) * 1000 +
+						(unsigned long long)(ts.tv_nsec) / 1000000;
 	}
 }
 
