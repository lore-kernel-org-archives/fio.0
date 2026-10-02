Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44571492502
	for <fio@vger.kernel.org>; Fri,  2 Oct 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790942411; cv=none; b=s2EC+eBpAND7ZDD2V+5HtQhpb3+m9HKKzF8/hklvcqVIhenvl8ho9sntu+botiHL5IlS4TyDFP26sLuBQxnpM5cP5DkUp4iJwM+gwt/MH+RBE/WHLb256rk7+0wavggNcSCACBeGSsR7Coozmu1Onu5wDxtH/Ihzv+qWqxXwtwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790942411; c=relaxed/simple;
	bh=hoyxURu7lDwgzb67kSi4EnOCcX/Lm5bzN1GuNgrTzIY=;
	h=Subject:From:To:Date:Message-Id; b=IfjxFfKAmkriJcqb5Oi2GkQshKCukwj9NdvFnAdeojKFS9QEWvW1uKK/bmmwYQPwKmVuJqFJrOQdY5J9zfv4urh18411/WkmL+7BMII9yUxf5+lJk712itii6S4mWvtf/mP9xobn28EdQ6FXSLSprUDzuF1jusEHMw1UlHYWHUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J6Vb0l3p; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J6Vb0l3p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=SSemR2Ngh679laIT2+h28I8sQtSPZyrSE1fJTDQg3g8=; b=J6Vb0l3pXtkg2wgyClofECcu+S
	tEtYXMnfHxVs0X8dPK6OQNwKmDI2yLpYp1SYVcfBTnYjZU0yXI9eI4R59Vil6DQZu5jjTOSL3is07
	mf74bTH7y2gswvrF/lbqqqKyNmTKfeEJpmVGxfYcqwX6EIp+GBJDHr26Qkv0dVEcIMm+qlOPAx8fS
	boJjvmb/I6tVEc6BlK7mI9qxmjQxbohPQ6hAhuWFFYUOtQ5KfVzRzYLnl0KxW850hNpItqJQa1wzQ
	LyQxlS/gnuRhPa/QJkluxgsuXS+TcvfwrTwuUOBgotp2W81naWPNenZ69KlIO9uIT3ahR8XM7VfB4
	AaDIQKBA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCbvo-00000000CgL-12yB
	for fio@vger.kernel.org;
	Fri, 02 Oct 2026 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id CC0BE1BC0161; Fri,  2 Oct 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri,  2 Oct 2026 06:00:01 -0600
Message-Id: <20261002120001.CC0BE1BC0161@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e27aa8b47c371491044ce9d7b3ee2f8488ba91b4:

  Merge branch 'fix/no-rdwr-when-job-never-writes' of https://github.com/hmi-jeon/fio (2026-09-30 13:24:00 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to daf3f3b837f81ac2464c6a67bba829c984d65a3f:

  Merge branch 'master' of https://github.com/rorychen/fio-HSMR (2026-10-01 14:26:20 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'master' of https://github.com/rorychen/fio-HSMR

rorychen (1):
      fio replay: Add an option replay_issue to replay blktrace files from __BLK_TA_ISSUE

 HOWTO.rst        |  8 ++++++++
 blktrace.c       | 59 ++++++++++++++++++++++++++++++++++++++++++++++----------
 cconv.c          |  2 ++
 fio.1            | 10 +++++++++-
 options.c        | 11 +++++++++++
 server.h         |  2 +-
 thread_options.h |  4 ++--
 7 files changed, 82 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index e6a08800..3684fe70 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3892,6 +3892,14 @@ I/O replay
 	a device that doesn't support them. This option takes a comma
 	separated list of read, write, trim, sync.
 
+.. option:: replay_issue=bool
+
+	When replaying I/O with :option:`read_iolog` the default behavior is to
+        replay the blktrace files from queue action. IO requests may be merged, causing
+        replayed I/O to differ from the actual I/O issued to the driver. By setting
+        this variable fio will replay from issue action which can more accurately
+        reflects device traffic but preserve the original behavior of DISCARD, NOTIFY, 
+        and FLUSH requests from queue action.
 
 Threads, processes and job synchronization
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/blktrace.c b/blktrace.c
index 71d21122..1f2a9bc0 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -307,8 +307,9 @@ static bool handle_trace_flush(struct thread_data *td, struct blk_io_trace *t,
 }
 
 /*
- * We only care for queue traces, most of the others are side effects
- * due to internal workings of the block layer.
+ * We only care for queue traces by default, most of the others are side effects
+ * due to internal workings of the block layer. However, issue traces can capture
+ * the actual I/O issued to the device.
  */
 static bool queue_trace(struct thread_data *td, struct blk_io_trace *t,
 			 unsigned long *ios, unsigned long long *bs,
@@ -317,8 +318,31 @@ static bool queue_trace(struct thread_data *td, struct blk_io_trace *t,
 	unsigned long long *last_ttime = &td->io_log_last_ttime;
 	unsigned long long delay = 0;
 
-	if ((t->action & 0xffff) != __BLK_TA_QUEUE)
-		return false;
+	if (td->o.replay_ta_issue) {
+		/* Replay FLUSH/DISCARD/NOTIFY from Q(QUEUE) action,
+		 * replay all other commands from D(ISSUE) action.
+		 * The FLUSH and write commands will be replayed respectively 
+		 * for the request of write I/O with FLUSH. 
+		 */
+		if (t->action & (BLK_TC_ACT(BLK_TC_NOTIFY) |
+			BLK_TC_ACT(BLK_TC_DISCARD) |
+			BLK_TC_ACT(BLK_TC_FLUSH))) {
+			if ((t->action & 0xffff) != __BLK_TA_QUEUE)
+				return false;
+				/* special cmd processing */
+		} else {
+			if ((t->action & 0xffff) != __BLK_TA_ISSUE)
+				return false;
+			/* Ignore PC requests as they're not user read and write IOs, 
+			 * otherwise, replay from issue will fail due to wrong t->bytes */
+			if (t->action & BLK_TC_ACT(BLK_TC_PC))
+				return false;
+			/* normal IO processing */
+		}
+	} else {
+		if ((t->action & 0xffff) != __BLK_TA_QUEUE)
+			return false;
+	}
 
 	if (!(t->action & BLK_TC_ACT(BLK_TC_NOTIFY))) {
 		delay = delay_since_ttime(td, t->time);
@@ -496,12 +520,27 @@ bool read_blktrace(struct thread_data* td)
 			goto err;
 		}
 		if ((t.action & BLK_TC_ACT(BLK_TC_NOTIFY)) == 0) {
-			if ((t.action & 0xffff) == __BLK_TA_QUEUE)
-				depth_inc(&t, this_depth);
-			else if (((t.action & 0xffff) == __BLK_TA_BACKMERGE) ||
-				((t.action & 0xffff) == __BLK_TA_FRONTMERGE))
-				depth_dec(&t, this_depth);
-			else if ((t.action & 0xffff) == __BLK_TA_COMPLETE)
+			if (td->o.replay_ta_issue) {
+				/* Increase queue depth at the action of __BLK_TA_ISSUE "D"
+				 * as the queued READ/WRITE may be merged to send to the driver.
+				 * However, still keep increasing queue depth for DISCARD/FLUSH
+				 * from __BLK_TA_QUEUE "Q". */
+				if (((t.action & 0xffff) == __BLK_TA_ISSUE &&
+					 t.action & (BLK_TC_ACT(BLK_TC_READ) |
+								 BLK_TC_ACT(BLK_TC_WRITE))) ||
+					((t.action & 0xffff) == __BLK_TA_QUEUE &&
+					 t.action & (BLK_TC_ACT(BLK_TC_DISCARD) |
+								 BLK_TC_ACT(BLK_TC_FLUSH))))
+					depth_inc(&t, this_depth);
+			} else { /* Replay the blktrace file from __BLK_TA_QUEUE action */
+				if ((t.action & 0xffff) == __BLK_TA_QUEUE)
+					depth_inc(&t, this_depth);
+				else if (((t.action & 0xffff) == __BLK_TA_BACKMERGE) ||
+					((t.action & 0xffff) == __BLK_TA_FRONTMERGE))
+					depth_dec(&t, this_depth);
+			}
+
+			if ((t.action & 0xffff) == __BLK_TA_COMPLETE)
 				depth_end(&t, this_depth, depth);
 
 			if (t_is_write(&t) && read_only) {
diff --git a/cconv.c b/cconv.c
index ac4208e3..6eaeba7a 100644
--- a/cconv.c
+++ b/cconv.c
@@ -330,6 +330,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->gtod_cpu = le32_to_cpu(top->gtod_cpu);
 	o->clocksource = le32_to_cpu(top->clocksource);
 	o->no_stall = le32_to_cpu(top->no_stall);
+	o->replay_ta_issue = le32_to_cpu(top->replay_ta_issue);
 	o->trim_percentage = le32_to_cpu(top->trim_percentage);
 	o->trim_batch = le32_to_cpu(top->trim_batch);
 	o->trim_zero = le32_to_cpu(top->trim_zero);
@@ -573,6 +574,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->gtod_cpu = cpu_to_le32(o->gtod_cpu);
 	top->clocksource = cpu_to_le32(o->clocksource);
 	top->no_stall = cpu_to_le32(o->no_stall);
+	top->replay_ta_issue = cpu_to_le32(o->replay_ta_issue);
 	top->trim_percentage = cpu_to_le32(o->trim_percentage);
 	top->trim_batch = cpu_to_le32(o->trim_batch);
 	top->trim_zero = cpu_to_le32(o->trim_zero);
diff --git a/fio.1 b/fio.1
index 3988e8a9..7dc5c353 100644
--- a/fio.1
+++ b/fio.1
@@ -3601,7 +3601,6 @@ must be a power of 2.
 .BI replay_scale \fR=\fPint
 Scale bye offsets down by this factor when replaying traces. Should most
 likely use \fBreplay_align\fR as well.
-.SS "Threads, processes and job synchronization"
 .TP
 .BI replay_skip \fR=\fPstr
 Sometimes it's useful to skip certain IO types in a replay trace. This could
@@ -3609,6 +3608,15 @@ be, for instance, eliminating the writes in the trace. Or not replaying the
 trims/discards, if you are redirecting to a device that doesn't support them.
 This option takes a comma separated list of read, write, trim, sync.
 .TP
+.BI replay_issue \fR=\fPbool
+When replaying I/O with \fBread_iolog\fR the default behavior is to replay
+the blktrace files from queue action. IO requests may be merged, causing
+replayed I/O to differ from the actual I/O issued to the driver. By setting
+this variable fio will replay from issue action which can more accurately
+reflects device traffic but preserve the original behavior of DISCARD,
+NOTIFY, and FLUSH requests from queue action.
+.SS "Threads, processes and job synchronization"
+.TP
 .BI thread
 Fio defaults to creating jobs by using fork, however if this option is
 given, fio will create jobs by using POSIX Threads' function
diff --git a/options.c b/options.c
index 29b86386..bb7296ed 100644
--- a/options.c
+++ b/options.c
@@ -3890,6 +3890,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IOLOG,
 	},
+	{
+		.name   = "replay_issue",
+		.lname  = "Replay from trace action by queue or issue",
+		.type   = FIO_OPT_BOOL,
+		.off1   = offsetof(struct thread_options, replay_ta_issue),
+		.def    = "0",
+		.parent = "read_iolog",
+		.help   = "Replay the blktrace files from the trace actions of queue or issue",
+		.category = FIO_OPT_C_IO,
+		.group  = FIO_OPT_G_IOLOG,
+	},	
 	{
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
diff --git a/server.h b/server.h
index e38900ee..0dbb0c9f 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 121,
+	FIO_SERVER_VER			= 122,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 45324b64..ed6808fd 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -291,6 +291,7 @@ struct thread_options {
 	unsigned int job_start_clock_id;
 	enum fio_cs clocksource;
 	unsigned int no_stall;
+	unsigned int replay_ta_issue;
 	unsigned int trim_percentage;
 	unsigned int trim_batch;
 	unsigned int trim_zero;
@@ -318,7 +319,6 @@ struct thread_options {
 	char *iops_log_file;
 	char *hist_log_file;
 	char *replay_redirect;
-
 	/*
 	 * Pre-run and post-run shell
 	 */
@@ -633,6 +633,7 @@ struct thread_options_pack {
 	uint32_t job_start_clock_id;
 	uint32_t clocksource;
 	uint32_t no_stall;
+	uint32_t replay_ta_issue;
 	uint32_t trim_percentage;
 	uint32_t trim_batch;
 	uint32_t trim_zero;
@@ -641,7 +642,6 @@ struct thread_options_pack {
 	uint32_t lat_percentiles;
 	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad2;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
