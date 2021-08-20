Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:58173 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbhHTL0V (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Aug 2021 07:26:21 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] options: Add thinktime_iotime option
Date: Fri, 20 Aug 2021 20:25:42 +0900
Message-Id: <20210820112542.1489147-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

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

To track the time and IO block count at the last stall, add
last_thinktime variable and last_thinktime_blocks variable to struct
thread_data. Also, introduce the helper function init_thinktime()
to group thinktime related preparations.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO            |  9 ++++++++-
 backend.c        | 45 +++++++++++++++++++++++++++++++++++++++------
 cconv.c          |  2 ++
 fio.1            |  7 ++++++-
 fio.h            |  2 ++
 options.c        | 14 ++++++++++++++
 server.h         |  2 +-
 thread_options.h |  3 +++
 8 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/HOWTO b/HOWTO
index 9bfd38b4..cfb278ef 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2710,7 +2710,7 @@ I/O rate
 	Stall the job for the specified period of time after an I/O has completed before issuing the
 	next. May be used to simulate processing being done by an application.
 	When the unit is omitted, the value is interpreted in microseconds.  See
-	:option:`thinktime_blocks` and :option:`thinktime_spin`.
+	:option:`thinktime_blocks`, :option:`thinktime_iotime` and :option:`thinktime_spin`.
 
 .. option:: thinktime_spin=time
 
@@ -2735,6 +2735,13 @@ I/O rate
 	:option:`thinktime_blocks` blocks. If this is set to `issue`, then the trigger happens
 	at the issue side.
 
+.. option:: thinktime_iotime=time
+
+	Only valid if :option:`thinktime` is set - Repeat job stall for
+	:option:`thinktime` after executing I/Os for `thinktime_iotime`. When
+	the unit is omitted, :option:`thinktime_iotime` is interpreted as a
+	number of seconds.
+
 .. option:: rate=int[,int][,int]
 
 	Cap the bandwidth used by this job. The number is in bytes/sec, the normal
diff --git a/backend.c b/backend.c
index 808e4362..5cdb8124 100644
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
@@ -1791,17 +1827,14 @@ static void *thread_main(void *data)
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
index e3a8c27c..92491ddb 100644
--- a/cconv.c
+++ b/cconv.c
@@ -213,6 +213,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->thinktime_spin = le32_to_cpu(top->thinktime_spin);
 	o->thinktime_blocks = le32_to_cpu(top->thinktime_blocks);
 	o->thinktime_blocks_type = le32_to_cpu(top->thinktime_blocks_type);
+	o->thinktime_iotime = le32_to_cpu(top->thinktime_iotime);
 	o->fsync_blocks = le32_to_cpu(top->fsync_blocks);
 	o->fdatasync_blocks = le32_to_cpu(top->fdatasync_blocks);
 	o->barrier_blocks = le32_to_cpu(top->barrier_blocks);
@@ -438,6 +439,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->thinktime_spin = cpu_to_le32(o->thinktime_spin);
 	top->thinktime_blocks = cpu_to_le32(o->thinktime_blocks);
 	top->thinktime_blocks_type = __cpu_to_le32(o->thinktime_blocks_type);
+	top->thinktime_iotime = __cpu_to_le32(o->thinktime_iotime);
 	top->fsync_blocks = cpu_to_le32(o->fsync_blocks);
 	top->fdatasync_blocks = cpu_to_le32(o->fdatasync_blocks);
 	top->barrier_blocks = cpu_to_le32(o->barrier_blocks);
diff --git a/fio.1 b/fio.1
index 382cebfc..3cae15b3 100644
--- a/fio.1
+++ b/fio.1
@@ -2471,7 +2471,7 @@ problem). Note that this option cannot reliably be used with async IO engines.
 Stall the job for the specified period of time after an I/O has completed before issuing the
 next. May be used to simulate processing being done by an application.
 When the unit is omitted, the value is interpreted in microseconds. See
-\fBthinktime_blocks\fR and \fBthinktime_spin\fR.
+\fBthinktime_blocks\fR, \fBthinktime_iotime\fR and \fBthinktime_spin\fR.
 .TP
 .BI thinktime_spin \fR=\fPtime
 Only valid if \fBthinktime\fR is set - pretend to spend CPU time doing
@@ -2493,6 +2493,11 @@ The default is `complete', which triggers \fBthinktime\fR when fio completes
 \fBthinktime_blocks\fR blocks. If this is set to `issue', then the trigger happens
 at the issue side.
 .TP
+.BI thinktime_iotime \fR=\fPtime
+Only valid if \fBthinktime\fR is set - Repeat job stall for \fBthinktime\fR
+after executing I/Os for \fBthinktime_iotime\fR. When the unit is omitted,
+\fBthinktime_iotime\fR is interpreted as a number of seconds.
+.TP
 .BI rate \fR=\fPint[,int][,int]
 Cap the bandwidth used by this job. The number is in bytes/sec, the normal
 suffix rules apply. Comma-separated values may be specified for reads,
diff --git a/fio.h b/fio.h
index 6f6b211b..85ed60fc 100644
--- a/fio.h
+++ b/fio.h
@@ -365,6 +365,8 @@ struct thread_data {
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 
 	uint64_t *thinktime_blocks_counter;
+	struct timespec last_thinktime;
+	uint64_t last_thinktime_blocks;
 
 	/*
 	 * State for random io, a bitmap of blocks done vs not done
diff --git a/options.c b/options.c
index 8c2ab7cc..3fe1e6bd 100644
--- a/options.c
+++ b/options.c
@@ -3688,6 +3688,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		},
 		.parent = "thinktime",
 	},
+	{
+		.name	= "thinktime_iotime",
+		.lname	= "Thinktime interval",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, thinktime_iotime),
+		.help	= "IO time interval between 'thinktime'",
+		.is_time = 1,
+		.is_seconds = 1,
+		.def	= "0",
+		.parent	= "thinktime",
+		.hide	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_THINKTIME,
+	},
 	{
 		.name	= "rate",
 		.lname	= "I/O rate",
diff --git a/server.h b/server.h
index daed057a..7ce2ddb1 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 92,
+	FIO_SERVER_VER			= 93,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 4b4ecfe1..6fe1cad7 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -189,6 +189,7 @@ struct thread_options {
 	unsigned int thinktime_spin;
 	unsigned int thinktime_blocks;
 	unsigned int thinktime_blocks_type;
+	unsigned int thinktime_iotime;
 	unsigned int fsync_blocks;
 	unsigned int fdatasync_blocks;
 	unsigned int barrier_blocks;
@@ -500,6 +501,8 @@ struct thread_options_pack {
 	uint32_t thinktime_spin;
 	uint32_t thinktime_blocks;
 	uint32_t thinktime_blocks_type;
+	uint32_t thinktime_iotime;
+	uint32_t pad6;
 	uint32_t fsync_blocks;
 	uint32_t fdatasync_blocks;
 	uint32_t barrier_blocks;
-- 
2.31.1


