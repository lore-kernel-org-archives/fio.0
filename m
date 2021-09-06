Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B80BC433F5
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 12:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2123161004
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 12:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbhIFMBM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 6 Sep 2021 08:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241354AbhIFMBM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Sep 2021 08:01:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC28AC061575
        for <fio@vger.kernel.org>; Mon,  6 Sep 2021 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=LzutZJD3qjF/rTZ83EpueD1tvgdfXQW+xGtSX9zqdEQ=; b=VoqWZzfBmICj/Er7u5Znl65t3A
        FOfxNDluac1ldKOMsS10Jmyk0zY3O+3CdQbTEsQ+5hklDIsQypC9GR18Y2kIcZlgER07zCvv8mgqh
        bHc41/q73YnDOSjMT3xLNFDpfF9MFdxE3ll48E6JPyCOw9Wl7q+bz/bopko6BLNM0SGioj8i877Mq
        uEx+UvifkpQmzmTAs8bYhJywzu2dKfggKE3GUjwolrUAhsZaCSQwzm1zYbJuRS1WXgnXsp9JCzF30
        c9IVUwGyxRtsU+IDhyjhHADROmRatb+Q6fbu9yTzWBJiopJQ0P5VR+7ynHfCPFyaHXfYUWqlaZ3ua
        EErWvbJg==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mNDID-0015zO-J3
        for fio@vger.kernel.org; Mon, 06 Sep 2021 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C65591BC013D; Mon,  6 Sep 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210906120001.C65591BC013D@kernel.dk>
Date:   Mon,  6 Sep 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 63176c21beb68ec54787eb2fd6be5b3c9132113b:

  examples: add examples for cmdprio_* IO priority options (2021-09-03 10:12:25 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f7942acdc23a4ee837ef30834e1d2cb1fc6d0afe:

  options: Add thinktime_iotime option (2021-09-05 21:11:25 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      options: Add thinktime_iotime option

 HOWTO            | 14 +++++++++++++-
 backend.c        | 45 +++++++++++++++++++++++++++++++++++++++------
 cconv.c          |  2 ++
 fio.1            | 13 ++++++++++++-
 fio.h            |  2 ++
 options.c        | 14 ++++++++++++++
 server.h         |  2 +-
 thread_options.h | 21 ++++++++++++---------
 8 files changed, 95 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 1853f56a..297a0485 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2745,7 +2745,7 @@ I/O rate
 	Stall the job for the specified period of time after an I/O has completed before issuing the
 	next. May be used to simulate processing being done by an application.
 	When the unit is omitted, the value is interpreted in microseconds.  See
-	:option:`thinktime_blocks` and :option:`thinktime_spin`.
+	:option:`thinktime_blocks`, :option:`thinktime_iotime` and :option:`thinktime_spin`.
 
 .. option:: thinktime_spin=time
 
@@ -2770,6 +2770,18 @@ I/O rate
 	:option:`thinktime_blocks` blocks. If this is set to `issue`, then the trigger happens
 	at the issue side.
 
+.. option:: thinktime_iotime=time
+
+	Only valid if :option:`thinktime` is set - control :option:`thinktime`
+	interval by time. The :option:`thinktime` stall is repeated after IOs
+	are executed for :option:`thinktime_iotime`. For example,
+	``--thinktime_iotime=9s --thinktime=1s`` repeat 10-second cycle with IOs
+	for 9 seconds and stall for 1 second. When the unit is omitted,
+	:option:`thinktime_iotime` is interpreted as a number of seconds. If
+	this option is used together with :option:`thinktime_blocks`, the
+	:option:`thinktime` stall is repeated after :option:`thinktime_iotime`
+	or after :option:`thinktime_blocks` IOs, whichever happens first.
+
 .. option:: rate=int[,int][,int]
 
 	Cap the bandwidth used by this job. The number is in bytes/sec, the normal
diff --git a/backend.c b/backend.c
index 1bcb035a..86fa6d41 100644
--- a/backend.c
+++ b/backend.c
@@ -858,15 +858,47 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 	return 0;
 }
 
+static void init_thinktime(struct thread_data *td)
+{
+	if (td->o.thinktime_blocks_type == THINKTIME_BLOCKS_TYPE_COMPLETE)
+		td->thinktime_blocks_counter = td->io_blocks;
+	else
+		td->thinktime_blocks_counter = td->io_issues;
+	td->last_thinktime = td->epoch;
+	td->last_thinktime_blocks = 0;
+}
+
 static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 			     struct timespec *time)
 {
 	unsigned long long b;
 	uint64_t total;
 	int left;
+	struct timespec now;
+	bool stall = false;
+
+	if (td->o.thinktime_iotime) {
+		fio_gettime(&now, NULL);
+		if (utime_since(&td->last_thinktime, &now)
+		    >= td->o.thinktime_iotime + td->o.thinktime) {
+			stall = true;
+		} else if (!fio_option_is_set(&td->o, thinktime_blocks)) {
+			/*
+			 * When thinktime_iotime is set and thinktime_blocks is
+			 * not set, skip the thinktime_blocks check, since
+			 * thinktime_blocks default value 1 does not work
+			 * together with thinktime_iotime.
+			 */
+			return;
+		}
+
+	}
 
 	b = ddir_rw_sum(td->thinktime_blocks_counter);
-	if (b % td->o.thinktime_blocks || !b)
+	if (b >= td->last_thinktime_blocks + td->o.thinktime_blocks)
+		stall = true;
+
+	if (!stall)
 		return;
 
 	io_u_quiesce(td);
@@ -902,6 +934,10 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 
 	if (time && should_check_rate(td))
 		fio_gettime(time, NULL);
+
+	td->last_thinktime_blocks = b;
+	if (td->o.thinktime_iotime)
+		td->last_thinktime = now;
 }
 
 /*
@@ -1792,17 +1828,14 @@ static void *thread_main(void *data)
 	if (rate_submit_init(td, sk_out))
 		goto err;
 
-	if (td->o.thinktime_blocks_type == THINKTIME_BLOCKS_TYPE_COMPLETE)
-		td->thinktime_blocks_counter = td->io_blocks;
-	else
-		td->thinktime_blocks_counter = td->io_issues;
-
 	set_epoch_time(td, o->log_unix_epoch);
 	fio_getrusage(&td->ru_start);
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->ss.prev_time, &td->epoch, sizeof(td->epoch));
 
+	init_thinktime(td);
+
 	if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||
 			o->ratemin[DDIR_TRIM]) {
 	        memcpy(&td->lastrate[DDIR_READ], &td->bw_sample_time,
diff --git a/cconv.c b/cconv.c
index 2dc5274e..2104308c 100644
--- a/cconv.c
+++ b/cconv.c
@@ -214,6 +214,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->thinktime_spin = le32_to_cpu(top->thinktime_spin);
 	o->thinktime_blocks = le32_to_cpu(top->thinktime_blocks);
 	o->thinktime_blocks_type = le32_to_cpu(top->thinktime_blocks_type);
+	o->thinktime_iotime = le32_to_cpu(top->thinktime_iotime);
 	o->fsync_blocks = le32_to_cpu(top->fsync_blocks);
 	o->fdatasync_blocks = le32_to_cpu(top->fdatasync_blocks);
 	o->barrier_blocks = le32_to_cpu(top->barrier_blocks);
@@ -440,6 +441,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->thinktime_spin = cpu_to_le32(o->thinktime_spin);
 	top->thinktime_blocks = cpu_to_le32(o->thinktime_blocks);
 	top->thinktime_blocks_type = __cpu_to_le32(o->thinktime_blocks_type);
+	top->thinktime_iotime = __cpu_to_le32(o->thinktime_iotime);
 	top->fsync_blocks = cpu_to_le32(o->fsync_blocks);
 	top->fdatasync_blocks = cpu_to_le32(o->fdatasync_blocks);
 	top->barrier_blocks = cpu_to_le32(o->barrier_blocks);
diff --git a/fio.1 b/fio.1
index 03fddffb..78988c9e 100644
--- a/fio.1
+++ b/fio.1
@@ -2499,7 +2499,7 @@ problem). Note that this option cannot reliably be used with async IO engines.
 Stall the job for the specified period of time after an I/O has completed before issuing the
 next. May be used to simulate processing being done by an application.
 When the unit is omitted, the value is interpreted in microseconds. See
-\fBthinktime_blocks\fR and \fBthinktime_spin\fR.
+\fBthinktime_blocks\fR, \fBthinktime_iotime\fR and \fBthinktime_spin\fR.
 .TP
 .BI thinktime_spin \fR=\fPtime
 Only valid if \fBthinktime\fR is set - pretend to spend CPU time doing
@@ -2520,6 +2520,17 @@ Only valid if \fBthinktime\fR is set - control how \fBthinktime_blocks\fR trigge
 The default is `complete', which triggers \fBthinktime\fR when fio completes
 \fBthinktime_blocks\fR blocks. If this is set to `issue', then the trigger happens
 at the issue side.
+.TP
+.BI thinktime_iotime \fR=\fPtime
+Only valid if \fBthinktime\fR is set - control \fBthinktime\fR interval by time.
+The \fBthinktime\fR stall is repeated after IOs are executed for
+\fBthinktime_iotime\fR. For example, `\-\-thinktime_iotime=9s \-\-thinktime=1s'
+repeat 10-second cycle with IOs for 9 seconds and stall for 1 second. When the
+unit is omitted, \fBthinktime_iotime\fR is interpreted as a number of seconds.
+If this option is used together with \fBthinktime_blocks\fR, the \fBthinktime\fR
+stall is repeated after \fBthinktime_iotime\fR or after \fBthinktime_blocks\fR
+IOs, whichever happens first.
+
 .TP
 .BI rate \fR=\fPint[,int][,int]
 Cap the bandwidth used by this job. The number is in bytes/sec, the normal
diff --git a/fio.h b/fio.h
index da1fe085..6bb21ebb 100644
--- a/fio.h
+++ b/fio.h
@@ -370,6 +370,8 @@ struct thread_data {
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 
 	uint64_t *thinktime_blocks_counter;
+	struct timespec last_thinktime;
+	uint64_t last_thinktime_blocks;
 
 	/*
 	 * State for random io, a bitmap of blocks done vs not done
diff --git a/options.c b/options.c
index 74ac1f3f..460cf4ff 100644
--- a/options.c
+++ b/options.c
@@ -3680,6 +3680,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		},
 		.parent = "thinktime",
 	},
+	{
+		.name	= "thinktime_iotime",
+		.lname	= "Thinktime interval",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, thinktime_iotime),
+		.help	= "IO time interval between 'thinktime'",
+		.def	= "0",
+		.parent	= "thinktime",
+		.hide	= 1,
+		.is_seconds = 1,
+		.is_time = 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_THINKTIME,
+	},
 	{
 		.name	= "rate",
 		.lname	= "I/O rate",
diff --git a/server.h b/server.h
index 3ff32d9a..44b8da12 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 93,
+	FIO_SERVER_VER			= 94,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 9990ab9b..6e1a2cdd 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -191,10 +191,6 @@ struct thread_options {
 
 	unsigned int hugepage_size;
 	unsigned long long rw_min_bs;
-	unsigned int thinktime;
-	unsigned int thinktime_spin;
-	unsigned int thinktime_blocks;
-	unsigned int thinktime_blocks_type;
 	unsigned int fsync_blocks;
 	unsigned int fdatasync_blocks;
 	unsigned int barrier_blocks;
@@ -303,6 +299,12 @@ struct thread_options {
 	char *exec_prerun;
 	char *exec_postrun;
 
+	unsigned int thinktime;
+	unsigned int thinktime_spin;
+	unsigned int thinktime_blocks;
+	unsigned int thinktime_blocks_type;
+	unsigned int thinktime_iotime;
+
 	uint64_t rate[DDIR_RWDIR_CNT];
 	uint64_t ratemin[DDIR_RWDIR_CNT];
 	unsigned int ratecycle;
@@ -504,10 +506,6 @@ struct thread_options_pack {
 
 	uint32_t hugepage_size;
 	uint64_t rw_min_bs;
-	uint32_t thinktime;
-	uint32_t thinktime_spin;
-	uint32_t thinktime_blocks;
-	uint32_t thinktime_blocks_type;
 	uint32_t fsync_blocks;
 	uint32_t fdatasync_blocks;
 	uint32_t barrier_blocks;
@@ -612,6 +610,12 @@ struct thread_options_pack {
 	uint8_t exec_prerun[FIO_TOP_STR_MAX];
 	uint8_t exec_postrun[FIO_TOP_STR_MAX];
 
+	uint32_t thinktime;
+	uint32_t thinktime_spin;
+	uint32_t thinktime_blocks;
+	uint32_t thinktime_blocks_type;
+	uint32_t thinktime_iotime;
+
 	uint64_t rate[DDIR_RWDIR_CNT];
 	uint64_t ratemin[DDIR_RWDIR_CNT];
 	uint32_t ratecycle;
@@ -651,7 +655,6 @@ struct thread_options_pack {
 	uint64_t latency_target;
 	uint64_t latency_window;
 	uint64_t max_latency[DDIR_RWDIR_CNT];
-	uint32_t pad5;
 	fio_fp64_t latency_percentile;
 	uint32_t latency_run;
 
