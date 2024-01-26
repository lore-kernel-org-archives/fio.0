Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957A11BC21
	for <fio@vger.kernel.org>; Fri, 26 Jan 2024 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706274015; cv=none; b=KUUwEOL7hq5g8gCsMzNHpQQ3fJ811kQZN1+jH1NG+lLVFfOoD8gzZK5JkUNEcmP8Yvad4lGHUX3q5JIlgBDbNKyBTEQyUVb8+Apy5KwOvFrskqMLK+pgnlwdvWrcYAiQdjPAOulxrrHvInBx2yFXiKozNm2ZK0jvXsMuTcsGLtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706274015; c=relaxed/simple;
	bh=LrPNVwZuzQCqQBGQmZMlNhLXMevv24wlJ6qXL+9jrRw=;
	h=Subject:From:To:Message-Id:Date; b=QN2OZzImyoaarquEZ2wiiF4YVaousqQtNYciNE7GIsHPzLcDZx8dzoU4a4knXgOwB982VqojRr27USJmLeZ1odDapH4TFJFrhT9Dh9gyYGm8rPZ70cOSB3z40++3hK3TCR2N8Cce+duJrlKTYZ2ATfV8ZDfU6F/LaaiWChxYVHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZQMsJpXl; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZQMsJpXl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=++uUj/pIt3mhD7fHdA2YmemIwdjwd8ryg1ztxgt2YI8=; b=ZQMsJpXl8t8/U+YcwltnTC2c0Q
	SgegGKTOa4l47TsSNVq9/W29k0XghnuFfCxeLK65Q8amUIKO3VWjCAYesy5JkaMwnPowpA0/ADWrF
	uD93KNKVidmWkCfqQunp5Wde/kzwkEft/dROOn8x2yYCY1kJ7w5am8ssjtthKWB7WJ/ePIjvaXicg
	zWp/NVhZ1h6GVgAcG8I7kFqukYLfwjxdUT1J+1EJDhe+i16lQmqs+ZzcQVOFUpP+DANn+FU4dP/UR
	svJ3y0u5lAqX/roXZerbzrm2nvtxL6iFafmBXkboBMRr7+xlQVt90SfQeEh1dvGdJ7qu21B+P8o5C
	oRGEbJig==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTLoT-000000062r4-44tO
	for fio@vger.kernel.org;
	Fri, 26 Jan 2024 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3F5E81BC0168; Fri, 26 Jan 2024 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240126130002.3F5E81BC0168@kernel.dk>
Date: Fri, 26 Jan 2024 06:00:02 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7f250f7514bacef1a3cea24a22ecce8bd30378bd:

  ci: resolve GitHub Actions Node.js warnings (2024-01-24 19:45:33 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 90a0fbc83c59ddfacc3e90dcb7721ff322bfe26f:

  Merge branch 'coverity-fix' of https://github.com/ankit-sam/fio (2024-01-25 10:20:10 -0700)

----------------------------------------------------------------
Ankit Kumar (3):
      stat: log out both average and max over the window
      docs: update fio man page for log_window_value
      iolog: fix reported defect from coverity scan

Jens Axboe (2):
      t/io_uring: remove dma map option
      Merge branch 'coverity-fix' of https://github.com/ankit-sam/fio

Vincent Fu (1):
      docs: change listed type for log_window_value to str

 HOWTO.rst    | 45 ++++++++++++++++++++++++++--------
 client.c     |  6 +++--
 fio.1        | 47 ++++++++++++++++++++++++++++--------
 iolog.c      | 79 +++++++++++++++++++++++++++++++++++++++++++++---------------
 iolog.h      | 21 +++++++++++++---
 options.c    | 34 ++++++++++++++++++++++----
 server.c     |  6 +++--
 stat.c       | 32 ++++++++++++++----------
 t/io_uring.c | 46 ++---------------------------------
 9 files changed, 207 insertions(+), 109 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index d0ba8021..ba160551 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4067,7 +4067,7 @@ Measurements and reporting
 	I/O that completes. When writing to the disk log, that can quickly grow to a
 	very large size. Setting this option makes fio average the each log entry
 	over the specified period of time, reducing the resolution of the log.  See
-	:option:`log_max_value` as well. Defaults to 0, logging all entries.
+	:option:`log_window_value` as well. Defaults to 0, logging all entries.
 	Also see `Log File Formats`_.
 
 .. option:: log_hist_msec=int
@@ -4088,11 +4088,28 @@ Measurements and reporting
 	histogram logs contain 1216 latency bins. See :option:`write_hist_log`
 	and `Log File Formats`_.
 
-.. option:: log_max_value=bool
+.. option:: log_window_value=str, log_max_value=str
 
-	If :option:`log_avg_msec` is set, fio logs the average over that window. If
-	you instead want to log the maximum value, set this option to 1. Defaults to
-	0, meaning that averaged values are logged.
+	If :option:`log_avg_msec` is set, fio by default logs the average over that
+	window. This option determines whether fio logs the average, maximum or
+	both the values over the window. This only affects the latency logging,
+	as both average and maximum values for iops or bw log will be same.
+	Accepted values are:
+
+		**avg**
+			Log average value over the window. The default.
+
+		**max**
+			Log maximum value in the window.
+
+		**both**
+			Log both average and maximum value over the window.
+
+		**0**
+			Backward-compatible alias for **avg**.
+
+		**1**
+			Backward-compatible alias for **max**.
 
 .. option:: log_offset=bool
 
@@ -5061,11 +5078,19 @@ toggled with :option:`log_offset`.
 by the ioengine specific :option:`cmdprio_percentage`.
 
 Fio defaults to logging every individual I/O but when windowed logging is set
-through :option:`log_avg_msec`, either the average (by default) or the maximum
-(:option:`log_max_value` is set) *value* seen over the specified period of time
-is recorded. Each *data direction* seen within the window period will aggregate
-its values in a separate row. Further, when using windowed logging the *block
-size* and *offset* entries will always contain 0.
+through :option:`log_avg_msec`, either the average (by default), the maximum
+(:option:`log_window_value` is set to max) *value* seen over the specified period
+of time, or both the average *value* and maximum *value1* (:option:`log_window_value`
+is set to both) is recorded. The log file format when both the values are reported
+takes this form:
+
+    *time* (`msec`), *value*, *value1*, *data direction*, *block size* (`bytes`),
+    *offset* (`bytes`), *command priority*
+
+
+Each *data direction* seen within the window period will aggregate its values in a
+separate row. Further, when using windowed logging the *block size* and *offset*
+entries will always contain 0.
 
 
 Client/Server
diff --git a/client.c b/client.c
index 699a2e5b..4cb7dffe 100644
--- a/client.c
+++ b/client.c
@@ -1718,8 +1718,10 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 			s = (struct io_sample *)((char *)s + sizeof(struct io_u_plat_entry) * i);
 
 		s->time		= le64_to_cpu(s->time);
-		if (ret->log_type != IO_LOG_TYPE_HIST)
-			s->data.val	= le64_to_cpu(s->data.val);
+		if (ret->log_type != IO_LOG_TYPE_HIST) {
+			s->data.val.val0	= le64_to_cpu(s->data.val.val0);
+			s->data.val.val1	= le64_to_cpu(s->data.val.val1);
+		}
 		s->__ddir	= __le32_to_cpu(s->__ddir);
 		s->bs		= le64_to_cpu(s->bs);
 		s->priority	= le16_to_cpu(s->priority);
diff --git a/fio.1 b/fio.1
index 8f659f1d..aef1dc85 100644
--- a/fio.1
+++ b/fio.1
@@ -3764,7 +3764,7 @@ By default, fio will log an entry in the iops, latency, or bw log for every
 I/O that completes. When writing to the disk log, that can quickly grow to a
 very large size. Setting this option makes fio average the each log entry
 over the specified period of time, reducing the resolution of the log. See
-\fBlog_max_value\fR as well. Defaults to 0, logging all entries.
+\fBlog_window_value\fR as well. Defaults to 0, logging all entries.
 Also see \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_hist_msec \fR=\fPint
@@ -3782,10 +3782,28 @@ the histogram logs enabled with \fBlog_hist_msec\fR. For each increment
 in coarseness, fio outputs half as many bins. Defaults to 0, for which
 histogram logs contain 1216 latency bins. See \fBLOG FILE FORMATS\fR section.
 .TP
-.BI log_max_value \fR=\fPbool
-If \fBlog_avg_msec\fR is set, fio logs the average over that window. If
-you instead want to log the maximum value, set this option to 1. Defaults to
-0, meaning that averaged values are logged.
+.BI log_window_value \fR=\fPstr "\fR,\fP log_max_value" \fR=\fPstr
+If \fBlog_avg_msec\fR is set, fio by default logs the average over that window.
+This option determines whether fio logs the average, maximum or both the
+values over the window. This only affects the latency logging, as both average
+and maximum values for iops or bw log will be same. Accepted values are:
+.RS
+.TP
+.B avg
+Log average value over the window. The default.
+.TP
+.B max
+Log maximum value in the window.
+.TP
+.B both
+Log both average and maximum value over the window.
+.TP
+.B 0
+Backward-compatible alias for \fBavg\fR.
+.TP
+.B 1
+Backward-compatible alias for \fBmax\fR.
+.RE
 .TP
 .BI log_offset \fR=\fPbool
 If this is set, the iolog options will include the byte offset for the I/O
@@ -4797,11 +4815,20 @@ number with the lowest 13 bits indicating the priority value (\fBprio\fR and
 (\fBprioclass\fR and \fBcmdprio_class\fR options).
 .P
 Fio defaults to logging every individual I/O but when windowed logging is set
-through \fBlog_avg_msec\fR, either the average (by default) or the maximum
-(\fBlog_max_value\fR is set) `value' seen over the specified period of time
-is recorded. Each `data direction' seen within the window period will aggregate
-its values in a separate row. Further, when using windowed logging the `block
-size' and `offset' entries will always contain 0.
+through \fBlog_avg_msec\fR, either the average (by default), the maximum
+(\fBlog_window_value\fR is set to max) `value' seen over the specified period of
+time, or both the average `value' and maximum `value1' (\fBlog_window_value\fR is
+set to both) is recorded. The log file format when both the values are reported
+takes this form:
+.RS
+.P
+time (msec), value, value1, data direction, block size (bytes), offset (bytes),
+command priority
+.RE
+.P
+Each `data direction' seen within the window period will aggregate its values
+in a separate row. Further, when using windowed logging the `block size' and
+`offset' entries will always contain 0.
 .SH CLIENT / SERVER
 Normally fio is invoked as a stand-alone application on the machine where the
 I/O workload should be generated. However, the backend and frontend of fio can
diff --git a/iolog.c b/iolog.c
index 5213c60f..f52a9a80 100644
--- a/iolog.c
+++ b/iolog.c
@@ -862,6 +862,13 @@ void setup_log(struct io_log **log, struct log_params *p,
 		l->log_ddir_mask = LOG_OFFSET_SAMPLE_BIT;
 	if (l->log_prio)
 		l->log_ddir_mask |= LOG_PRIO_SAMPLE_BIT;
+	/*
+	 * The bandwidth-log option generates agg-read_bw.log,
+	 * agg-write_bw.log and agg-trim_bw.log for which l->td is NULL.
+	 * Check if l->td is valid before dereferencing it.
+	 */
+	if (l->td && l->td->o.log_max == IO_LOG_SAMPLE_BOTH)
+		l->log_ddir_mask |= LOG_AVG_MAX_SAMPLE_BIT;
 
 	INIT_FLIST_HEAD(&l->chunk_list);
 
@@ -988,7 +995,7 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
-	int log_offset, log_prio;
+	int log_offset, log_prio, log_avg_max;
 	uint64_t i, nr_samples;
 	unsigned int prio_val;
 	const char *fmt;
@@ -999,17 +1006,32 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 	s = __get_sample(samples, 0, 0);
 	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
 	log_prio = (s->__ddir & LOG_PRIO_SAMPLE_BIT) != 0;
+	log_avg_max = (s->__ddir & LOG_AVG_MAX_SAMPLE_BIT) != 0;
 
 	if (log_offset) {
-		if (log_prio)
-			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
-		else
-			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
+		if (log_prio) {
+			if (log_avg_max)
+				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
+			else
+				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
+		} else {
+			if (log_avg_max)
+				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
+			else
+				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
+		}
 	} else {
-		if (log_prio)
-			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
-		else
-			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %u\n";
+		if (log_prio) {
+			if (log_avg_max)
+				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
+			else
+				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
+		} else {
+			if (log_avg_max)
+				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %u\n";
+			else
+				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %u\n";
+		}
 	}
 
 	nr_samples = sample_size / __log_entry_sz(log_offset);
@@ -1023,20 +1045,37 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 			prio_val = ioprio_value_is_class_rt(s->priority);
 
 		if (!log_offset) {
-			fprintf(f, fmt,
-				s->time,
-				s->data.val,
-				io_sample_ddir(s), (unsigned long long) s->bs,
-				prio_val);
+			if (log_avg_max)
+				fprintf(f, fmt,
+					s->time,
+					s->data.val.val0,
+					s->data.val.val1,
+					io_sample_ddir(s), (unsigned long long) s->bs,
+					prio_val);
+			else
+				fprintf(f, fmt,
+					s->time,
+					s->data.val.val0,
+					io_sample_ddir(s), (unsigned long long) s->bs,
+					prio_val);
 		} else {
 			struct io_sample_offset *so = (void *) s;
 
-			fprintf(f, fmt,
-				s->time,
-				s->data.val,
-				io_sample_ddir(s), (unsigned long long) s->bs,
-				(unsigned long long) so->offset,
-				prio_val);
+			if (log_avg_max)
+				fprintf(f, fmt,
+					s->time,
+					s->data.val.val0,
+					s->data.val.val1,
+					io_sample_ddir(s), (unsigned long long) s->bs,
+					(unsigned long long) so->offset,
+					prio_val);
+			else
+				fprintf(f, fmt,
+					s->time,
+					s->data.val.val0,
+					io_sample_ddir(s), (unsigned long long) s->bs,
+					(unsigned long long) so->offset,
+					prio_val);
 		}
 	}
 }
diff --git a/iolog.h b/iolog.h
index 62cbd1b0..26dd5cca 100644
--- a/iolog.h
+++ b/iolog.h
@@ -26,13 +26,23 @@ struct io_hist {
 	struct flist_head list;
 };
 
+enum {
+	IO_LOG_SAMPLE_AVG = 0,
+	IO_LOG_SAMPLE_MAX,
+	IO_LOG_SAMPLE_BOTH,
+};
+
+struct io_sample_value {
+	uint64_t val0;
+	uint64_t val1;
+};
 
 union io_sample_data {
-	uint64_t val;
+	struct io_sample_value val;
 	struct io_u_plat_entry *plat_entry;
 };
 
-#define sample_val(value) ((union io_sample_data) { .val = value })
+#define sample_val(value) ((union io_sample_data) { .val.val0 = value })
 #define sample_plat(plat) ((union io_sample_data) { .plat_entry = plat })
 
 /*
@@ -154,8 +164,13 @@ struct io_log {
  * If the bit following the upper bit is set, then we have the priority
  */
 #define LOG_PRIO_SAMPLE_BIT	0x40000000U
+/*
+ * If the bit following prioity sample vit is set, we report both avg and max
+ */
+#define LOG_AVG_MAX_SAMPLE_BIT	0x20000000U
 
-#define LOG_SAMPLE_BITS		(LOG_OFFSET_SAMPLE_BIT | LOG_PRIO_SAMPLE_BIT)
+#define LOG_SAMPLE_BITS		(LOG_OFFSET_SAMPLE_BIT | LOG_PRIO_SAMPLE_BIT |\
+					LOG_AVG_MAX_SAMPLE_BIT)
 #define io_sample_ddir(io)	((io)->__ddir & ~LOG_SAMPLE_BITS)
 
 static inline void io_sample_set_ddir(struct io_log *log,
diff --git a/options.c b/options.c
index 53df03de..1da4de78 100644
--- a/options.c
+++ b/options.c
@@ -4540,14 +4540,38 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
-		.name	= "log_max_value",
-		.lname	= "Log maximum instead of average",
-		.type	= FIO_OPT_BOOL,
+		.name	= "log_window_value",
+		.alias  = "log_max_value",
+		.lname	= "Log maximum, average or both values",
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, log_max),
-		.help	= "Log max sample in a window instead of average",
-		.def	= "0",
+		.help	= "Log max, average or both sample in a window",
+		.def	= "avg",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
+		.posval	= {
+			  { .ival = "avg",
+			    .oval = IO_LOG_SAMPLE_AVG,
+			    .help = "Log average value over the window",
+			  },
+			  { .ival = "max",
+			    .oval = IO_LOG_SAMPLE_MAX,
+			    .help = "Log maximum value in the window",
+			  },
+			  { .ival = "both",
+			    .oval = IO_LOG_SAMPLE_BOTH,
+			    .help = "Log both average and maximum values over the window"
+			  },
+			  /* Compatibility with former boolean values */
+			  { .ival = "0",
+			    .oval = IO_LOG_SAMPLE_AVG,
+			    .help = "Alias for 'avg'",
+			  },
+			  { .ival = "1",
+			    .oval = IO_LOG_SAMPLE_MAX,
+			    .help = "Alias for 'max'",
+			  },
+		},
 	},
 	{
 		.name	= "log_offset",
diff --git a/server.c b/server.c
index b9f0e2ac..afaeb348 100644
--- a/server.c
+++ b/server.c
@@ -2288,8 +2288,10 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 			struct io_sample *s = get_sample(log, cur_log, i);
 
 			s->time		= cpu_to_le64(s->time);
-			if (log->log_type != IO_LOG_TYPE_HIST)
-				s->data.val	= cpu_to_le64(s->data.val);
+			if (log->log_type != IO_LOG_TYPE_HIST) {
+				s->data.val.val0	= cpu_to_le64(s->data.val.val0);
+				s->data.val.val1	= cpu_to_le64(s->data.val.val1);
+			}
 			s->__ddir	= __cpu_to_le32(s->__ddir);
 			s->bs		= cpu_to_le64(s->bs);
 
diff --git a/stat.c b/stat.c
index 7cf6bee1..11b58626 100644
--- a/stat.c
+++ b/stat.c
@@ -3149,7 +3149,7 @@ void reset_io_stats(struct thread_data *td)
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
-			      unsigned long elapsed, bool log_max)
+			      unsigned long elapsed, int log_max)
 {
 	/*
 	 * Note an entry in the log. Use the mean from the logged samples,
@@ -3159,10 +3159,16 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 	if (iolog->avg_window[ddir].samples) {
 		union io_sample_data data;
 
-		if (log_max)
-			data.val = iolog->avg_window[ddir].max_val;
-		else
-			data.val = iolog->avg_window[ddir].mean.u.f + 0.50;
+		if (log_max == IO_LOG_SAMPLE_AVG) {
+			data.val.val0 = iolog->avg_window[ddir].mean.u.f + 0.50;
+			data.val.val1 = 0;
+		} else if (log_max == IO_LOG_SAMPLE_MAX) {
+			data.val.val0 = iolog->avg_window[ddir].max_val;
+			data.val.val1 = 0;
+		} else {
+			data.val.val0 = iolog->avg_window[ddir].mean.u.f + 0.50;
+			data.val.val1 = iolog->avg_window[ddir].max_val;
+		}
 
 		__add_log_sample(iolog, data, ddir, 0, elapsed, 0, 0);
 	}
@@ -3171,7 +3177,7 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 }
 
 static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
-			     bool log_max)
+			     int log_max)
 {
 	enum fio_ddir ddir;
 
@@ -3205,7 +3211,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * Add the sample. If the time period has passed, then
 	 * add that entry to the log and clear.
 	 */
-	add_stat_sample(&iolog->avg_window[ddir], data.val);
+	add_stat_sample(&iolog->avg_window[ddir], data.val.val0);
 
 	/*
 	 * If period hasn't passed, adding the above sample is all we
@@ -3221,7 +3227,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 			return diff;
 	}
 
-	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0);
+	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max);
 
 	iolog->avg_last[ddir] = elapsed - (elapsed % iolog->avg_msec);
 
@@ -3235,15 +3241,15 @@ void finalize_logs(struct thread_data *td, bool unit_logs)
 	elapsed = mtime_since_now(&td->epoch);
 
 	if (td->clat_log && unit_logs)
-		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max);
 	if (td->slat_log && unit_logs)
-		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max);
 	if (td->lat_log && unit_logs)
-		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max);
 	if (td->bw_log && (unit_logs == per_unit_log(td->bw_log)))
-		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max);
 	if (td->iops_log && (unit_logs == per_unit_log(td->iops_log)))
-		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max);
 }
 
 void add_agg_sample(union io_sample_data data, enum fio_ddir ddir,
diff --git a/t/io_uring.c b/t/io_uring.c
index bf0aa26e..efc50caa 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -129,7 +129,6 @@ static int batch_complete = BATCH_COMPLETE;
 static int bs = BS;
 static int polled = 1;		/* use IO polling */
 static int fixedbufs = 1;	/* use fixed user buffers */
-static int dma_map;		/* pre-map DMA buffers */
 static int register_files = 1;	/* use fixed files */
 static int buffered = 0;	/* use buffered IO, not O_DIRECT */
 static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
@@ -155,17 +154,6 @@ static float plist[] = { 1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0,
 			80.0, 90.0, 95.0, 99.0, 99.5, 99.9, 99.95, 99.99 };
 static int plist_len = 17;
 
-#ifndef IORING_REGISTER_MAP_BUFFERS
-#define IORING_REGISTER_MAP_BUFFERS	26
-struct io_uring_map_buffers {
-	__s32	fd;
-	__u32	buf_start;
-	__u32	buf_end;
-	__u32	flags;
-	__u64	rsvd[2];
-};
-#endif
-
 static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 			 enum nvme_csi csi, void *data)
 {
@@ -405,22 +393,6 @@ static void add_stat(struct submitter *s, int clock_index, int nr)
 #endif
 }
 
-static int io_uring_map_buffers(struct submitter *s)
-{
-	struct io_uring_map_buffers map = {
-		.fd		= s->files[0].real_fd,
-		.buf_end	= depth,
-	};
-
-	if (do_nop)
-		return 0;
-	if (s->nr_files > 1)
-		fprintf(stdout, "Mapping buffers may not work with multiple files\n");
-
-	return syscall(__NR_io_uring_register, s->ring_fd,
-			IORING_REGISTER_MAP_BUFFERS, &map, 1);
-}
-
 static int io_uring_register_buffers(struct submitter *s)
 {
 	if (do_nop)
@@ -950,14 +922,6 @@ static int setup_ring(struct submitter *s)
 			perror("io_uring_register_buffers");
 			return 1;
 		}
-
-		if (dma_map) {
-			ret = io_uring_map_buffers(s);
-			if (ret < 0) {
-				perror("io_uring_map_buffers");
-				return 1;
-			}
-		}
 	}
 
 	if (register_files) {
@@ -1071,7 +1035,7 @@ static int submitter_init(struct submitter *s)
 	}
 
 	if (!init_printed) {
-		printf("polled=%d, fixedbufs=%d/%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, dma_map, register_files, buffered, depth);
+		printf("polled=%d, fixedbufs=%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, register_files, buffered, depth);
 		printf("%s", buf);
 		init_printed = 1;
 	}
@@ -1519,7 +1483,6 @@ static void usage(char *argv, int status)
 		" -b <int>  : Block size, default %d\n"
 		" -p <bool> : Polled IO, default %d\n"
 		" -B <bool> : Fixed buffers, default %d\n"
-		" -D <bool> : DMA map fixed buffers, default %d\n"
 		" -F <bool> : Register files, default %d\n"
 		" -n <int>  : Number of threads, default %d\n"
 		" -O <bool> : Use O_DIRECT, default %d\n"
@@ -1534,7 +1497,7 @@ static void usage(char *argv, int status)
 		" -P <bool> : Automatically place on device home node %d\n"
 		" -u <bool> : Use nvme-passthrough I/O, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
-		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
+		fixedbufs, register_files, nthreads, !buffered, do_nop,
 		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
 		use_sync, register_ring, numa_placement, pt);
 	exit(status);
@@ -1656,9 +1619,6 @@ int main(int argc, char *argv[])
 		case 'r':
 			runtime = atoi(optarg);
 			break;
-		case 'D':
-			dma_map = !!atoi(optarg);
-			break;
 		case 'R':
 			random_io = !!atoi(optarg);
 			break;
@@ -1694,8 +1654,6 @@ int main(int argc, char *argv[])
 		batch_complete = depth;
 	if (batch_submit > depth)
 		batch_submit = depth;
-	if (!fixedbufs && dma_map)
-		dma_map = 0;
 
 	submitter = calloc(nthreads, sizeof(*submitter) +
 				roundup_pow2(depth) * sizeof(struct iovec));
