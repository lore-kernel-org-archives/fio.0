Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752410AbeDOMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 15 Apr 2018 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f7gKD-00012C-Pe
        for fio@vger.kernel.org; Sun, 15 Apr 2018 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180415120001.7BC0D2C00EE@kernel.dk>
Date: Sun, 15 Apr 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c479640d6208236744f0562b1e79535eec290e2b:

  Merge branch 'proc_group' of https://github.com/sitsofe/fio (2018-04-13 17:25:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dd39e2d406b6be11aa5432311034761aff5d6ba8:

  cconv: add conversion for 'replay_time_scale' (2018-04-14 16:26:17 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      iolog: fix issue with replay rate
      Add 'replay_time_scale' option
      cconv: add conversion for 'replay_time_scale'

 HOWTO            |  8 ++++++++
 blktrace.c       | 14 ++++++++++----
 cconv.c          |  2 ++
 fio.1            |  6 ++++++
 iolog.c          |  5 +++--
 options.c        | 13 +++++++++++++
 server.h         |  2 +-
 thread_options.h |  2 ++
 8 files changed, 45 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 5c8623d..68b6b82 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2311,6 +2311,14 @@ I/O replay
 	still respecting ordering. The result is the same I/O pattern to a given
 	device, but different timings.
 
+.. option:: replay_time_scale=int
+
+	When replaying I/O with :option:`read_iolog`, fio will honor the
+	original timing in the trace. With this option, it's possible to scale
+	the time. It's a percentage option, if set to 50 it means run at 50%
+	the original IO rate in the trace. If set to 200, run at twice the
+	original IO rate. Defaults to 100.
+
 .. option:: replay_redirect=str
 
 	While replaying I/O patterns using :option:`read_iolog` the default behavior
diff --git a/blktrace.c b/blktrace.c
index 6e4d0a4..71ac412 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -333,13 +333,19 @@ static void handle_trace(struct thread_data *td, struct blk_io_trace *t,
 		return;
 
 	if (!(t->action & BLK_TC_ACT(BLK_TC_NOTIFY))) {
-		if (!last_ttime || td->o.no_stall) {
-			last_ttime = t->time;
+		if (!last_ttime || td->o.no_stall)
 			delay = 0;
-		} else {
+		else if (td->o.replay_time_scale == 100)
 			delay = t->time - last_ttime;
-			last_ttime = t->time;
+		else {
+			double tmp = t->time - last_ttime;
+			double scale;
+
+			scale = (double) 100.0 / (double) td->o.replay_time_scale;
+			tmp *= scale;
+			delay = tmp;
 		}
+		last_ttime = t->time;
 	}
 
 	t_bytes_align(&td->o, t);
diff --git a/cconv.c b/cconv.c
index dbe0071..585ed86 100644
--- a/cconv.c
+++ b/cconv.c
@@ -291,6 +291,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->block_error_hist = le32_to_cpu(top->block_error_hist);
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
+	o->replay_time_scale = le32_to_cpu(top->replay_time_scale);
 	o->per_job_logs = le32_to_cpu(top->per_job_logs);
 	o->write_bw_log = le32_to_cpu(top->write_bw_log);
 	o->write_lat_log = le32_to_cpu(top->write_lat_log);
@@ -481,6 +482,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->block_error_hist = cpu_to_le32(o->block_error_hist);
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
+	top->replay_time_scale = cpu_to_le32(o->replay_time_scale);
 	top->per_job_logs = cpu_to_le32(o->per_job_logs);
 	top->write_bw_log = cpu_to_le32(o->write_bw_log);
 	top->write_lat_log = cpu_to_le32(o->write_lat_log);
diff --git a/fio.1 b/fio.1
index dd4f9cb..3b5522f 100644
--- a/fio.1
+++ b/fio.1
@@ -2036,6 +2036,12 @@ respect the timestamps and attempt to replay them as fast as possible while
 still respecting ordering. The result is the same I/O pattern to a given
 device, but different timings.
 .TP
+.BI replay_time_scale \fR=\fPint
+When replaying I/O with \fBread_iolog\fR, fio will honor the original timing
+in the trace. With this option, it's possible to scale the time. It's a
+percentage option, if set to 50 it means run at 50% the original IO rate in
+the trace. If set to 200, run at twice the original IO rate. Defaults to 100.
+.TP
 .BI replay_redirect \fR=\fPstr
 While replaying I/O patterns using \fBread_iolog\fR the default behavior
 is to replay the IOPS onto the major/minor device that each IOP was recorded
diff --git a/iolog.c b/iolog.c
index bfafc03..3f0fc22 100644
--- a/iolog.c
+++ b/iolog.c
@@ -63,6 +63,7 @@ void log_file(struct thread_data *td, struct fio_file *f,
 static void iolog_delay(struct thread_data *td, unsigned long delay)
 {
 	uint64_t usec = utime_since_now(&td->last_issue);
+	unsigned long orig_delay = delay;
 	uint64_t this_delay;
 	struct timespec ts;
 
@@ -88,8 +89,8 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 	}
 
 	usec = utime_since_now(&ts);
-	if (usec > delay)
-		td->time_offset = usec - delay;
+	if (usec > orig_delay)
+		td->time_offset = usec - orig_delay;
 	else
 		td->time_offset = 0;
 }
diff --git a/options.c b/options.c
index fae3943..045c62b 100644
--- a/options.c
+++ b/options.c
@@ -3157,6 +3157,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.pow2	= 1,
 	},
 	{
+		.name	= "replay_time_scale",
+		.lname	= "Replay Time Scale",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, replay_time_scale),
+		.def	= "100",
+		.minval	= 1,
+		.parent	= "read_iolog",
+		.hide	= 1,
+		.help	= "Scale time for replay events",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IOLOG,
+	},
+	{
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
 		.type	= FIO_OPT_STR_STORE,
diff --git a/server.h b/server.h
index 1eee7dc..4896860 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 71,
+	FIO_SERVER_VER			= 72,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index dc290b0..944feaf 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -317,6 +317,7 @@ struct thread_options {
 
 	unsigned int replay_align;
 	unsigned int replay_scale;
+	unsigned int replay_time_scale;
 
 	unsigned int per_job_logs;
 
@@ -592,6 +593,7 @@ struct thread_options_pack {
 
 	uint32_t replay_align;
 	uint32_t replay_scale;
+	uint32_t replay_time_scale;
 
 	uint32_t per_job_logs;
 
