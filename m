Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6B0C433EF
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 01:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B7060232
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 01:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhIFBvH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:51:07 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10861 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhIFBvG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 5 Sep 2021 21:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630893002; x=1662429002;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cw8wahVJ4JkeAYKN7lvaeD8eyN/paiRVJdpKlSrwWYU=;
  b=ZumwVT7RvkPgd7KAGbipCW5GJtWgOSFaEOw3lP2zEbOXptUniMYTT+hv
   fqR8e6ktn0crYtjUYqcsuTP3wklS8BFo7ZkCzYz70HYpAAbzZHDGRhIdb
   EIJMTGIYP4G8sXyyV/CiaDzkolMCJ0Rt3iMUDFanbRDl3CebE+liy5bWl
   DBMubVieYgHxrUaz7QoVuoJjlX21kvuJctPWbI8XFib3FISPtaxgfAy8H
   qEb+U/yPSGkJJmhUMOogBde6NLkEzMMLURG3YETwwrtX0X7x7peKktV24
   hp/DeyXy6mjndFPj2omiix8dNB4ZqKKaV25uWWnIAn/CnHWcdeMVRvxiW
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,271,1624291200"; 
   d="scan'208";a="283049824"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 09:50:02 +0800
IronPort-SDR: PgPPvka4auP62fIF1hC8/igJbGQI2ha07BtVntTIg1IS6jeqDNkwm4oiA+Z76WjrcDMfItLqQ4
 1rTMN5HVK2qMISjc4LphDWMOwOnBCbARUG4MC/AgqcHDMbwAbdWhtNGMh72Kf6o48uRjnlA1Wa
 jeDKdwJ45IexJQiKMcrIiR3oss6lkwN7fBPNAMsbWBdr/AmwOt8NrTdEFk9+bsmO+4veRrAvnl
 pkxfT1g6VUULFZRLw+/QymW6Of+Sa0U7wrtg1F78Nhya3OBkYbAXzGHIvUE+BkYIuB5Wgz1isc
 2UteE08SnNIXQt7eW7xsafZm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:26:42 -0700
IronPort-SDR: 5GSYrT+WZPB4gxGAjkRvUtSmV41Sj/jlx6v6FW44ZtoPYiq3/um68ILlIVbq+SEKBistGL97Gd
 3gkG8Yo6ycuWCS+7t53m/S+U1aIiwqutaMsFz/gQPPzGjVpuVVcbuYVBxyWP+kBVagx/SiUP73
 jbYM75TJEH+NjKR0D3fj3tvoPHsRLxLlWGcfiDEXIxPQuAoCebkcNvIOiTWVqqgEuCOW83z0Xm
 e2jUwyuN1lZ+0++J2smokjss4LFzracNNKP/IYzff16SxaeCl4Vc6Mdyim3IZGA6vCJ5rXMOme
 8jM=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Sep 2021 18:50:01 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3] options: Add thinktime_iotime option
Date:   Mon,  6 Sep 2021 10:50:00 +0900
Message-Id: <20210906015000.1780077-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The thinktime option allows stalling a job for a specified amount of
time. Using the thinktime_blocks option, periodic stalls can be added
every thinktime_blocks IOs. However, with this option, the periodic
stall may not be repeated at equal time intervals as the time to execute
thinktime_blocks IOs may vary.

To control the thinktime interval by time, introduce the option
thinktime_iotime. With this new option, the thinktime stall is repeated
after IOs are executed for thinktime_iotime. If this option is used
together with the thinktime_blocks option, the thinktime pause is
repeated after thinktime_iotime or after thinktime_blocks IOs, whichever
happens first.

To support the new option, add a new member thinktime_iotime in the
struct thread_options and the struct thread_options_pack. Avoid size
increase of the struct thread_options_pack by replacing a padding 'pad5'
with the new member. To keep thinktime related members close, move the
members near the position where the padding was placed. Make same
changes to the struct thread_option also for consistency.

To track the time and IO block count at the last stall, add
last_thinktime variable and last_thinktime_blocks variable to struct
thread_data. Also, introduce the helper function init_thinktime()
to group thinktime related preparations.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
Changes from v2:
* Improved descriptions in fio.1 and HOWTO
* Fixed order of members added to fio_options
* Rebased to the master branch tip

Changes from v1:
* Moved thinktime related members in thread_options_pack to avoid padding

 HOWTO            | 14 +++++++++++++-
 backend.c        | 45 +++++++++++++++++++++++++++++++++++++++------
 cconv.c          |  2 ++
 fio.1            | 13 ++++++++++++-
 fio.h            |  2 ++
 options.c        | 14 ++++++++++++++
 server.h         |  2 +-
 thread_options.h | 21 ++++++++++++---------
 8 files changed, 95 insertions(+), 18 deletions(-)

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
 
-- 
2.31.1

