Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001931990CE
	for <fio@vger.kernel.org>; Thu,  5 Sep 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725537612; cv=none; b=mFmuxw7LwSHdzZuyon5NmPZQF7K4atm//RuFrYkv0rTUziyhfZp9yIpTk56gu6+hXfFGsgSpoZlNRWFFytyBgTI3N7IWlCMegmTbBQ2w1dtcxugH/GwMUhm6oCdgc0vLQMA+ZguUvEimow0be7J9ZyYwB7eiBdzCs82jDyHlFf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725537612; c=relaxed/simple;
	bh=GYlbG5UD/qB3U2e/30XAxg3NbRgB4qIzZOLLhj2SChU=;
	h=Subject:From:To:Message-Id:Date; b=ttHjiuaL4j9iT3Vz8BPqhmjbj20tA0g8Z4o9w6J7dYMfd/KJw2hurXccI98/HQQlNbdCSeFjr/CA5Ir1pboZN5UkUScqjYkL8ijxfJKIC457G+hbFT7woJWy1n0NEDWrFurm9SVcyHvOmlzkuMse8jvkPvgKI6pgGxwx2gVo2RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WWnRjvIJ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WWnRjvIJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Ld9xNGQV6VXTuEAkEb50MVQUNIA9ug1VAWkplxooxSE=; b=WWnRjvIJuoD/q5LsmXJYj5vGgf
	XT9dXZ3xsG0JDDctZZ1kVRstLgieMzMF4SxXRHC4lGOwcb9CoQu0ZDMUFIBMg0M7WSKr1uVZN05Jw
	DBD8x0jBgAU6xCno+8EEcAbLw1xJrmXpaPwtH3pnLRwcOQXHXgfs9l5Jksm4Trn7lErwemkJ3At41
	JpV/u7QyFYGUBJnJoXfjBvpVJK3RDDVDBDA75HhvhDw+t3FuDOUuaeDhyZs/eaZzrCCYynEw2Istr
	V/PjKENCYEOyNhNVkmjePqYHvseXKYAcsfZkrmRr4GPihLQ2ej6OU27SAcSYfH2ZoAuzR8PrNg5bw
	E7/0Ma7g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1smB9g-00000000TYy-0LPw
	for fio@vger.kernel.org;
	Thu, 05 Sep 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D693E1BC013B; Thu,  5 Sep 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240905120001.D693E1BC013B@kernel.dk>
Date: Thu,  5 Sep 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 5d789274bd8979d881ad793faba9f885f3b80113:

  Merge branch 'no-librpma' of https://github.com/grom72/fio (2024-09-03 14:44:57 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 20d0ba84d3b7e7abd8a3318175b46f5e5363547d:

  t/jobs/t0034: add test for the log_issue_time option (2024-09-04 13:59:45 -0400)

----------------------------------------------------------------
Shin'ichiro Kawasaki (9):
      stat: reduce arguments of add_*lat_sample() functions
      stat: reduce arguments of add_log_sample()
      iolog: refactor flush_samples()
      iolog: drop struct io_sample_offset
      introduce the log_issue_time option
      doc: fix the descriptions of the log_prio option
      doc: describe the log_issue_time option
      t/jobs/t0033: add test for the log file format
      t/jobs/t0034: add test for the log_issue_time option

 HOWTO.rst                |  40 ++++++++++--
 cconv.c                  |   2 +
 client.c                 |  36 ++++++-----
 engines/fileoperations.c |   6 +-
 fio.1                    |  26 +++++---
 init.c                   |  12 ++++
 io_u.c                   |  14 +----
 iolog.c                  | 156 ++++++++++++++++++++++++++---------------------
 iolog.h                  |  47 ++++++++++----
 options.c                |  10 +++
 server.c                 |  10 +--
 server.h                 |   3 +-
 stat.c                   | 155 ++++++++++++++++++++++++++++------------------
 stat.h                   |  13 ++--
 t/jobs/t0033.fio         |  28 +++++++++
 t/jobs/t0034.fio         |  27 ++++++++
 t/run-fio-tests.py       |  66 ++++++++++++++++++++
 thread_options.h         |   2 +
 18 files changed, 459 insertions(+), 194 deletions(-)
 create mode 100644 t/jobs/t0033.fio
 create mode 100644 t/jobs/t0034.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 4ef7a41d..a363206d 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4223,6 +4223,21 @@ Measurements and reporting
 	entry as well as the other data values. Defaults to 0 meaning that
 	offsets are not present in logs. Also see `Log File Formats`_.
 
+.. option:: log_prio=bool
+
+	If this is set, the *Command priority* field in `Log File Formats`_
+	shows the priority value and the IO priority class of the command.
+	Otherwise, the field shows if the command has the highest RT
+	priority class or not. Also see	`Log File Formats`_.
+
+.. option:: log_issue_time=bool
+
+	If this is set, the iolog options will include the command issue time
+	for the I/O entry as well as the other data values. Defaults to 0
+	meaning that command issue times are not present in logs. Also see
+	`Log File Formats`_. This option shall be set together with
+	:option:`write_lat_log` and :option:`log_offset`.
+
 .. option:: log_compression=int
 
 	If this is set, fio will compress the I/O logs as it goes, to keep the
@@ -5188,7 +5203,7 @@ Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
 
     *time* (`msec`), *value*, *data direction*, *block size* (`bytes`),
-    *offset* (`bytes`), *command priority*
+    *offset* (`bytes`), *command priority*, *issue time* (`nsec`)
 
 *Time* for the log entry is always in milliseconds. The *value* logged depends
 on the type of log, it will be one of the following:
@@ -5213,8 +5228,21 @@ The entry's *block size* is always in bytes. The *offset* is the position in byt
 from the start of the file for that particular I/O. The logging of the offset can be
 toggled with :option:`log_offset`.
 
-*Command priority* is 0 for normal priority and 1 for high priority. This is controlled
-by the ioengine specific :option:`cmdprio_percentage`.
+If :option:`log_prio` is not set, the entry's *Command priority* is 1 for an IO
+executed with the highest RT priority class (:option:`prioclass` =1 or
+:option:`cmdprio_class` =1) and 0 otherwise. This is controlled by the
+:option:`prioclass` option and the ioengine specific
+:option:`cmdprio_percentage`  :option:`cmdprio_class` options. If
+:option:`log_prio` is set, the entry's *Command priority* is the priority set
+for the IO, as a 16-bits hexadecimal number with the lowest 13 bits indicating
+the priority value (:option:`prio` and :option:`cmdprio` options) and the
+highest 3 bits indicating the IO priority class (:option:`prioclass` and
+:option:`cmdprio_class` options).
+
+The entry's *issue time* is the command issue time in nanoseconds. The logging
+of the issue time can be toggled with :option:`log_issue_time`. This field has
+valid values in completion latency log file (clat), or submit latency log file
+(slat). The field has value 0 in other logs files.
 
 Fio defaults to logging every individual I/O but when windowed logging is set
 through :option:`log_avg_msec`, either the average (by default), the maximum
@@ -5224,12 +5252,12 @@ is set to both) is recorded. The log file format when both the values are report
 takes this form:
 
     *time* (`msec`), *value*, *value1*, *data direction*, *block size* (`bytes`),
-    *offset* (`bytes`), *command priority*
+    *offset* (`bytes`), *command priority*, *issue time* (`nsec`)
 
 
 Each *data direction* seen within the window period will aggregate its values in a
-separate row. Further, when using windowed logging the *block size* and *offset*
-entries will always contain 0.
+separate row. Further, when using windowed logging the *block size*, *offset*
+and *issue time* entries will always contain 0.
 
 
 Client/Server
diff --git a/cconv.c b/cconv.c
index 1d494982..9571f1a8 100644
--- a/cconv.c
+++ b/cconv.c
@@ -216,6 +216,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->log_max = le32_to_cpu(top->log_max);
 	o->log_offset = le32_to_cpu(top->log_offset);
 	o->log_prio = le32_to_cpu(top->log_prio);
+	o->log_issue_time = le32_to_cpu(top->log_issue_time);
 	o->log_gz = le32_to_cpu(top->log_gz);
 	o->log_gz_store = le32_to_cpu(top->log_gz_store);
 	o->log_alternate_epoch = le32_to_cpu(top->log_alternate_epoch);
@@ -458,6 +459,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->log_max = cpu_to_le32(o->log_max);
 	top->log_offset = cpu_to_le32(o->log_offset);
 	top->log_prio = cpu_to_le32(o->log_prio);
+	top->log_issue_time = cpu_to_le32(o->log_issue_time);
 	top->log_gz = cpu_to_le32(o->log_gz);
 	top->log_gz_store = cpu_to_le32(o->log_gz_store);
 	top->log_alternate_epoch = cpu_to_le32(o->log_alternate_epoch);
diff --git a/client.c b/client.c
index 4cb7dffe..5964faba 100644
--- a/client.c
+++ b/client.c
@@ -1388,8 +1388,8 @@ static void handle_eta(struct fio_client *client, struct fio_net_cmd *cmd)
 static void client_flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 				      uint64_t sample_size)
 {
-	struct io_sample *s;
-	int log_offset;
+	struct io_sample *s, *s_tmp;
+	bool log_offset, log_issue_time;
 	uint64_t i, j, nr_samples;
 	struct io_u_plat_entry *entry;
 	uint64_t *io_u_plat;
@@ -1399,15 +1399,17 @@ static void client_flush_hist_samples(FILE *f, int hist_coarseness, void *sample
 	if (!sample_size)
 		return;
 
-	s = __get_sample(samples, 0, 0);
+	s = __get_sample(samples, 0, 0, 0);
 	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
+	log_issue_time = (s->__ddir & LOG_ISSUE_TIME_SAMPLE_BIT) != 0;
 
-	nr_samples = sample_size / __log_entry_sz(log_offset);
+	nr_samples = sample_size / __log_entry_sz(log_offset, log_issue_time);
 
 	for (i = 0; i < nr_samples; i++) {
 
-		s = (struct io_sample *)((char *)__get_sample(samples, log_offset, i) +
-			i * sizeof(struct io_u_plat_entry));
+		s_tmp = __get_sample(samples, log_offset, log_issue_time, i);
+		s = (struct io_sample *)((char *)s_tmp +
+					 i * sizeof(struct io_u_plat_entry));
 
 		entry = s->data.plat_entry;
 		io_u_plat = entry->io_u_plat;
@@ -1595,6 +1597,7 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 	uint64_t nr_samples;
 	size_t total;
 	char *p;
+	size_t log_entry_size;
 
 	stream.zalloc = Z_NULL;
 	stream.zfree = Z_NULL;
@@ -1610,11 +1613,13 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 	 */
 	nr_samples = le64_to_cpu(pdu->nr_samples);
 
+	log_entry_size = __log_entry_sz(le32_to_cpu(pdu->log_offset),
+					le32_to_cpu(pdu->log_issue_time));
 	if (pdu->log_type == IO_LOG_TYPE_HIST)
-		total = nr_samples * (__log_entry_sz(le32_to_cpu(pdu->log_offset)) +
-					sizeof(struct io_u_plat_entry));
+		total = nr_samples * (log_entry_size +
+				      sizeof(struct io_u_plat_entry));
 	else
-		total = nr_samples * __log_entry_sz(le32_to_cpu(pdu->log_offset));
+		total = nr_samples * log_entry_size;
 	ret = malloc(total + sizeof(*pdu));
 	ret->nr_samples = nr_samples;
 
@@ -1703,6 +1708,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 	ret->compressed		= le32_to_cpu(ret->compressed);
 	ret->log_offset		= le32_to_cpu(ret->log_offset);
 	ret->log_prio		= le32_to_cpu(ret->log_prio);
+	ret->log_issue_time	= le32_to_cpu(ret->log_issue_time);
 	ret->log_hist_coarseness = le32_to_cpu(ret->log_hist_coarseness);
 	ret->per_job_logs	= le32_to_cpu(ret->per_job_logs);
 
@@ -1713,7 +1719,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 	for (i = 0; i < ret->nr_samples; i++) {
 		struct io_sample *s;
 
-		s = __get_sample(samples, ret->log_offset, i);
+		s = __get_sample(samples, ret->log_offset, ret->log_issue_time, i);
 		if (ret->log_type == IO_LOG_TYPE_HIST)
 			s = (struct io_sample *)((char *)s + sizeof(struct io_u_plat_entry) * i);
 
@@ -1726,11 +1732,13 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		s->bs		= le64_to_cpu(s->bs);
 		s->priority	= le16_to_cpu(s->priority);
 
-		if (ret->log_offset) {
-			struct io_sample_offset *so = (void *) s;
+		if (ret->log_offset)
+			s->aux[IOS_AUX_OFFSET_INDEX] =
+				le64_to_cpu(s->aux[IOS_AUX_OFFSET_INDEX]);
 
-			so->offset = le64_to_cpu(so->offset);
-		}
+		if (ret->log_issue_time)
+			s->aux[IOS_AUX_ISSUE_TIME_INDEX] =
+				le64_to_cpu(s->aux[IOS_AUX_ISSUE_TIME_INDEX]);
 
 		if (ret->log_type == IO_LOG_TYPE_HIST) {
 			s->data.plat_entry = (struct io_u_plat_entry *)(((char *)s) + sizeof(*s));
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
diff --git a/fio.1 b/fio.1
index 1953aea1..a4ab07ed 100644
--- a/fio.1
+++ b/fio.1
@@ -3933,9 +3933,16 @@ entry as well as the other data values. Defaults to 0 meaning that
 offsets are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_prio \fR=\fPbool
-If this is set, the iolog options will include the I/O priority for the I/O
-entry as well as the other data values. Defaults to 0 meaning that
-I/O priorities are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
+If this is set, the `Command priority` field in \fBLOG FILE FORMATS\fR
+shows the priority value and the IO priority class of the command.
+Otherwise, the field shows if the command has the highest RT priority
+class or not. Also see \fBLOG FILE FORMATS\fR section.
+.TP
+.BI log_issue_time \fR=\fPbool
+If this is set, the iolog options will include the command issue time for the
+I/O entry as well as the other data values. Defaults to 0 meaning that command
+issue times are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
+This option shall be set together with \fBwrite_lat_log\fR and \fBlog_offset\fR.
 .TP
 .BI log_compression \fR=\fPint
 If this is set, fio will compress the I/O logs as it goes, to keep the
@@ -4932,7 +4939,7 @@ and IOPS. The logs share a common format, which looks like this:
 .RS
 .P
 time (msec), value, data direction, block size (bytes), offset (bytes),
-command priority
+command priority, issue time (nsec)
 .RE
 .P
 `Time' for the log entry is always in milliseconds. The `value' logged depends
@@ -4975,6 +4982,11 @@ number with the lowest 13 bits indicating the priority value (\fBprio\fR and
 \fBcmdprio\fR options) and the highest 3 bits indicating the IO priority class
 (\fBprioclass\fR and \fBcmdprio_class\fR options).
 .P
+The entry's `issue time` is the command issue time in nanoseconds. The logging
+of the issue time can be toggled with \fBlog_issue_time\fR. This field has valid
+values in completion latency log file (clat), or submit latency log file (slat).
+The field has value 0 in other log files.
+.P
 Fio defaults to logging every individual I/O but when windowed logging is set
 through \fBlog_avg_msec\fR, either the average (by default), the maximum
 (\fBlog_window_value\fR is set to max) `value' seen over the specified period of
@@ -4984,12 +4996,12 @@ takes this form:
 .RS
 .P
 time (msec), value, value1, data direction, block size (bytes), offset (bytes),
-command priority
+command priority, issue time (nsec)
 .RE
 .P
 Each `data direction' seen within the window period will aggregate its values
-in a separate row. Further, when using windowed logging the `block size' and
-`offset' entries will always contain 0.
+in a separate row. Further, when using windowed logging the `block size',
+`offset' and `issue time` entries will always contain 0.
 .SH CLIENT / SERVER
 Normally fio is invoked as a stand-alone application on the machine where the
 I/O workload should be generated. However, the backend and frontend of fio can
diff --git a/init.c b/init.c
index ff3e9a90..414535cc 100644
--- a/init.c
+++ b/init.c
@@ -1621,12 +1621,18 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_type = IO_LOG_TYPE_LAT,
 			.log_offset = o->log_offset,
 			.log_prio = o->log_prio,
+			.log_issue_time = o->log_issue_time,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
 		const char *pre = make_log_name(o->lat_log_file, o->name);
 		const char *suf;
 
+		if (o->log_issue_time && !o->log_offset) {
+			log_err("fio: log_issue_time option requires write_lat_log and log_offset options\n");
+			goto err;
+		}
+
 		if (p.log_gz_store)
 			suf = "log.fz";
 		else
@@ -1650,6 +1656,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			setup_log(&td->clat_log, &p, logname);
 		}
 
+	} else if (o->log_issue_time) {
+		log_err("fio: log_issue_time option requires write_lat_log and log_offset options\n");
+		goto err;
 	}
 
 	if (o->write_hist_log) {
@@ -1661,6 +1670,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_type = IO_LOG_TYPE_HIST,
 			.log_offset = o->log_offset,
 			.log_prio = o->log_prio,
+			.log_issue_time = o->log_issue_time,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
@@ -1693,6 +1703,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_type = IO_LOG_TYPE_BW,
 			.log_offset = o->log_offset,
 			.log_prio = o->log_prio,
+			.log_issue_time = o->log_issue_time,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
@@ -1725,6 +1736,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_type = IO_LOG_TYPE_IOPS,
 			.log_offset = o->log_offset,
 			.log_prio = o->log_prio,
+			.log_issue_time = o->log_issue_time,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
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
 
diff --git a/iolog.c b/iolog.c
index f727c97f..aadb0d05 100644
--- a/iolog.c
+++ b/iolog.c
@@ -845,6 +845,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 	l->log_type = p->log_type;
 	l->log_offset = p->log_offset;
 	l->log_prio = p->log_prio;
+	l->log_issue_time = p->log_issue_time;
 	l->log_gz = p->log_gz;
 	l->log_gz_store = p->log_gz_store;
 	l->avg_msec = p->avg_msec;
@@ -887,6 +888,9 @@ void setup_log(struct io_log **log, struct log_params *p,
 	if (l->td && l->td->o.log_max == IO_LOG_SAMPLE_BOTH)
 		l->log_ddir_mask |= LOG_AVG_MAX_SAMPLE_BIT;
 
+	if (l->log_issue_time)
+		l->log_ddir_mask |= LOG_ISSUE_TIME_SAMPLE_BIT;
+
 	INIT_FLIST_HEAD(&l->chunk_list);
 
 	if (l->log_gz && !p->td)
@@ -969,7 +973,7 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 			       uint64_t sample_size)
 {
 	struct io_sample *s;
-	int log_offset;
+	bool log_offset, log_issue_time;
 	uint64_t i, j, nr_samples;
 	struct io_u_plat_entry *entry, *entry_before;
 	uint64_t *io_u_plat;
@@ -980,13 +984,14 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 	if (!sample_size)
 		return;
 
-	s = __get_sample(samples, 0, 0);
+	s = __get_sample(samples, 0, 0, 0);
 	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
+	log_issue_time = (s->__ddir & LOG_ISSUE_TIME_SAMPLE_BIT) != 0;
 
-	nr_samples = sample_size / __log_entry_sz(log_offset);
+	nr_samples = sample_size / __log_entry_sz(log_offset, log_issue_time);
 
 	for (i = 0; i < nr_samples; i++) {
-		s = __get_sample(samples, log_offset, i);
+		s = __get_sample(samples, log_offset, log_issue_time, i);
 
 		entry = s->data.plat_entry;
 		io_u_plat = entry->io_u_plat;
@@ -1009,91 +1014,100 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 	}
 }
 
+static int print_sample_fields(char **p, size_t *left, const char *fmt, ...) {
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(*p, *left, fmt, ap);
+	if (ret < 0 || ret >= *left) {
+		log_err("sample file write failed: %d\n", ret);
+		return -1;
+	}
+	va_end(ap);
+
+	*p += ret;
+	*left -= ret;
+
+	return 0;
+}
+
+/*
+ * flush_samples - Generate output for log samples
+ * Each sample output is built using a temporary buffer. This buffer size
+ * assumptions are:
+ * - Each sample has less than 10 fields
+ * - Each sample field fits in 25 characters (20 digits for 64 bit number
+ *   and a few bytes delimiter)
+ */
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
-	int log_offset, log_prio, log_avg_max;
+	bool log_offset, log_prio, log_avg_max, log_issue_time;
 	uint64_t i, nr_samples;
-	unsigned int prio_val;
-	const char *fmt;
+	char buf[256];
+	char *p;
+	size_t left;
+	int ret;
 
 	if (!sample_size)
 		return;
 
-	s = __get_sample(samples, 0, 0);
+	s = __get_sample(samples, 0, 0, 0);
 	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
 	log_prio = (s->__ddir & LOG_PRIO_SAMPLE_BIT) != 0;
 	log_avg_max = (s->__ddir & LOG_AVG_MAX_SAMPLE_BIT) != 0;
+	log_issue_time = (s->__ddir & LOG_ISSUE_TIME_SAMPLE_BIT) != 0;
 
-	if (log_offset) {
-		if (log_prio) {
-			if (log_avg_max)
-				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
-			else
-				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
-		} else {
-			if (log_avg_max)
-				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
-			else
-				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
-		}
-	} else {
-		if (log_prio) {
-			if (log_avg_max)
-				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
-			else
-				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
-		} else {
-			if (log_avg_max)
-				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %u\n";
-			else
-				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %u\n";
-		}
-	}
-
-	nr_samples = sample_size / __log_entry_sz(log_offset);
+	nr_samples = sample_size / __log_entry_sz(log_offset, log_issue_time);
 
 	for (i = 0; i < nr_samples; i++) {
-		s = __get_sample(samples, log_offset, i);
+		s = __get_sample(samples, log_offset, log_issue_time, i);
+		p = buf;
+		left = sizeof(buf);
+
+		ret = print_sample_fields(&p, &left, "%" PRIu64 ", %" PRId64,
+					  s->time, s->data.val.val0);
+		if (ret)
+			return;
+
+		if (log_avg_max) {
+			ret = print_sample_fields(&p, &left, ", %" PRId64,
+						  s->data.val.val1);
+			if (ret)
+				return;
+		}
+
+		ret = print_sample_fields(&p, &left, ", %u, %llu",
+					  io_sample_ddir(s),
+					  (unsigned long long) s->bs);
+		if (ret)
+			return;
+
+		if (log_offset) {
+			ret = print_sample_fields(&p, &left, ", %llu",
+						  (unsigned long long) s->aux[IOS_AUX_OFFSET_INDEX]);
+			if (ret)
+				return;
+		}
 
 		if (log_prio)
-			prio_val = s->priority;
+			ret = print_sample_fields(&p, &left, ", 0x%04x",
+						  s->priority);
 		else
-			prio_val = ioprio_value_is_class_rt(s->priority);
-
-		if (!log_offset) {
-			if (log_avg_max)
-				fprintf(f, fmt,
-					s->time,
-					s->data.val.val0,
-					s->data.val.val1,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					prio_val);
-			else
-				fprintf(f, fmt,
-					s->time,
-					s->data.val.val0,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					prio_val);
-		} else {
-			struct io_sample_offset *so = (void *) s;
-
-			if (log_avg_max)
-				fprintf(f, fmt,
-					s->time,
-					s->data.val.val0,
-					s->data.val.val1,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					(unsigned long long) so->offset,
-					prio_val);
-			else
-				fprintf(f, fmt,
-					s->time,
-					s->data.val.val0,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					(unsigned long long) so->offset,
-					prio_val);
+			ret = print_sample_fields(&p, &left, ", %u",
+						  ioprio_value_is_class_rt(s->priority));
+		if (ret)
+			return;
+
+		if (log_issue_time) {
+			ret = print_sample_fields(&p, &left, ", %llu",
+						  (unsigned long long) s->aux[IOS_AUX_ISSUE_TIME_INDEX]);
+			if (ret)
+				return;
 		}
+
+		fprintf(f, "%s\n", buf);
 	}
 }
 
diff --git a/iolog.h b/iolog.h
index 26dd5cca..e864d169 100644
--- a/iolog.h
+++ b/iolog.h
@@ -54,11 +54,15 @@ struct io_sample {
 	uint32_t __ddir;
 	uint16_t priority;
 	uint64_t bs;
+	uint64_t aux[];
 };
 
-struct io_sample_offset {
-	struct io_sample s;
-	uint64_t offset;
+/*
+ * Enumerate indexes of auxiliary log data in struct io_sample aux[] array
+ */
+enum {
+	IOS_AUX_OFFSET_INDEX,
+	IOS_AUX_ISSUE_TIME_INDEX,
 };
 
 enum {
@@ -119,6 +123,11 @@ struct io_log {
 	 */
 	unsigned int log_prio;
 
+	/*
+	 * Log I/O issuing time
+	 */
+	unsigned int log_issue_time;
+
 	/*
 	 * Max size of log entries before a chunk is compressed
 	 */
@@ -168,9 +177,14 @@ struct io_log {
  * If the bit following prioity sample vit is set, we report both avg and max
  */
 #define LOG_AVG_MAX_SAMPLE_BIT	0x20000000U
+/*
+ * If the bit following AVG_MAX_SAMPLE_BIT is set, we report the issue time also
+ */
+#define LOG_ISSUE_TIME_SAMPLE_BIT	0x10000000U
 
 #define LOG_SAMPLE_BITS		(LOG_OFFSET_SAMPLE_BIT | LOG_PRIO_SAMPLE_BIT |\
-					LOG_AVG_MAX_SAMPLE_BIT)
+					LOG_AVG_MAX_SAMPLE_BIT |\
+					LOG_ISSUE_TIME_SAMPLE_BIT)
 #define io_sample_ddir(io)	((io)->__ddir & ~LOG_SAMPLE_BITS)
 
 static inline void io_sample_set_ddir(struct io_log *log,
@@ -180,17 +194,22 @@ static inline void io_sample_set_ddir(struct io_log *log,
 	io->__ddir = ddir | log->log_ddir_mask;
 }
 
-static inline size_t __log_entry_sz(int log_offset)
+static inline size_t __log_entry_sz(bool log_offset, bool log_issue_time)
 {
+	size_t ret = sizeof(struct io_sample);
+
 	if (log_offset)
-		return sizeof(struct io_sample_offset);
-	else
-		return sizeof(struct io_sample);
+		ret += sizeof(uint64_t);
+
+	if (log_issue_time)
+		ret += sizeof(uint64_t);
+
+	return ret;
 }
 
 static inline size_t log_entry_sz(struct io_log *log)
 {
-	return __log_entry_sz(log->log_offset);
+	return __log_entry_sz(log->log_offset, log->log_issue_time);
 }
 
 static inline size_t log_sample_sz(struct io_log *log, struct io_logs *cur_log)
@@ -198,10 +217,12 @@ static inline size_t log_sample_sz(struct io_log *log, struct io_logs *cur_log)
 	return cur_log->nr_samples * log_entry_sz(log);
 }
 
-static inline struct io_sample *__get_sample(void *samples, int log_offset,
+static inline struct io_sample *__get_sample(void *samples, bool log_offset,
+					     bool log_issue_time,
 					     uint64_t sample)
 {
-	uint64_t sample_offset = sample * __log_entry_sz(log_offset);
+	uint64_t sample_offset = sample *
+		__log_entry_sz(log_offset, log_issue_time);
 	return (struct io_sample *) ((char *) samples + sample_offset);
 }
 
@@ -214,7 +235,8 @@ static inline struct io_sample *get_sample(struct io_log *iolog,
 					   struct io_logs *cur_log,
 					   uint64_t sample)
 {
-	return __get_sample(cur_log->log, iolog->log_offset, sample);
+	return __get_sample(cur_log->log,
+			    iolog->log_offset, iolog->log_issue_time, sample);
 }
 
 enum {
@@ -290,6 +312,7 @@ struct log_params {
 	int log_type;
 	int log_offset;
 	int log_prio;
+	int log_issue_time;
 	int log_gz;
 	int log_gz_store;
 	int log_compress;
diff --git a/options.c b/options.c
index df986196..5a6b0a06 100644
--- a/options.c
+++ b/options.c
@@ -4717,6 +4717,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "log_issue_time",
+		.lname	= "Log IO issue time",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, log_issue_time),
+		.help	= "Include IO issue time for each log entry",
+		.def	= "0",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
 #ifdef CONFIG_ZLIB
 	{
 		.name	= "log_compression",
diff --git a/server.c b/server.c
index afaeb348..5967f421 100644
--- a/server.c
+++ b/server.c
@@ -2295,11 +2295,13 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 			s->__ddir	= __cpu_to_le32(s->__ddir);
 			s->bs		= cpu_to_le64(s->bs);
 
-			if (log->log_offset) {
-				struct io_sample_offset *so = (void *) s;
+			if (log->log_offset)
+				s->aux[IOS_AUX_OFFSET_INDEX] =
+					cpu_to_le64(s->aux[IOS_AUX_OFFSET_INDEX]);
 
-				so->offset = cpu_to_le64(so->offset);
-			}
+			if (log->log_issue_time)
+				s->aux[IOS_AUX_ISSUE_TIME_INDEX] =
+					cpu_to_le64(s->aux[IOS_AUX_ISSUE_TIME_INDEX]);
 		}
 	}
 
diff --git a/server.h b/server.h
index a8e4dbf2..449c18cf 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 106,
+	FIO_SERVER_VER			= 107,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -197,6 +197,7 @@ struct cmd_iolog_pdu {
 	uint32_t compressed;
 	uint32_t log_offset;
 	uint32_t log_prio;
+	uint32_t log_issue_time;
 	uint32_t log_hist_coarseness;
 	uint32_t per_job_logs;
 	uint8_t name[FIO_NET_NAME_MAX];
diff --git a/stat.c b/stat.c
index b98e8b27..2cfd6819 100644
--- a/stat.c
+++ b/stat.c
@@ -24,6 +24,15 @@
 #define LOG_MSEC_SLACK	1
 #endif
 
+struct log_sample {
+	union io_sample_data data;
+	uint32_t ddir;
+	uint64_t bs;
+	uint64_t offset;
+	uint16_t priority;
+	uint64_t issue_time;
+};
+
 struct fio_sem *stat_sem;
 
 void clear_rusage_stat(struct thread_data *td)
@@ -3031,17 +3040,15 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
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
@@ -3049,19 +3056,19 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 
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
 
-		if (iolog->log_offset) {
-			struct io_sample_offset *so = (void *) s;
+		if (iolog->log_offset)
+			s->aux[IOS_AUX_OFFSET_INDEX] = sample->offset;
 
-			so->offset = offset;
-		}
+		if (iolog->log_issue_time)
+			s->aux[IOS_AUX_ISSUE_TIME_INDEX] = sample->issue_time;
 
 		cur_log->nr_samples++;
 		return;
@@ -3157,20 +3164,21 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 	 * had actual samples done.
 	 */
 	if (iolog->avg_window[ddir].samples) {
-		union io_sample_data data;
+		struct log_sample sample = { {{ 0, 0 }}, ddir, 0, 0, 0, 0 };
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
@@ -3187,11 +3195,10 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 
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
@@ -3202,8 +3209,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * If no time averaging, just add the log sample.
 	 */
 	if (!iolog->avg_msec) {
-		__add_log_sample(iolog, data, ddir, bs, elapsed, offset,
-				 ioprio);
+		__add_log_sample(iolog, elapsed, sample);
 		return 0;
 	}
 
@@ -3211,7 +3217,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * Add the sample. If the time period has passed, then
 	 * add that entry to the log and clear.
 	 */
-	add_stat_sample(&iolog->avg_window[ddir], data.val.val0);
+	add_stat_sample(&iolog->avg_window[ddir], sample->data.val.val0);
 
 	/*
 	 * If period hasn't passed, adding the above sample is all we
@@ -3256,12 +3262,13 @@ void add_agg_sample(union io_sample_data data, enum fio_ddir ddir,
 		    unsigned long long bs)
 {
 	struct io_log *iolog;
+	struct log_sample sample = { data, ddir, bs, 0, 0, 0 };
 
 	if (!ddir_rw(ddir))
 		return;
 
 	iolog = agg_io_log[ddir];
-	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0, 0);
+	__add_log_sample(iolog, mtime_since_genesis(), &sample);
 }
 
 void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
@@ -3297,17 +3304,25 @@ add_lat_percentile_prio_sample(struct thread_stat *ts, unsigned long long nsec,
 
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
@@ -3323,9 +3338,13 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
 				     nsec);
 
-	if (td->clat_log)
-		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
-			       offset, ioprio);
+	if (td->clat_log) {
+		struct log_sample sample = { sample_val(nsec), ddir, bs,
+			offset, ioprio,
+			ntime_since(&td->epoch, &io_u->issue_time) };
+
+		add_log_sample(td, td->clat_log, &sample);
+	}
 
 	if (ts->clat_percentiles) {
 		/*
@@ -3351,6 +3370,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		if (this_window >= iolog->hist_msec) {
 			uint64_t *io_u_plat;
 			struct io_u_plat_entry *dst;
+			struct log_sample sample = { {{ 0, 0 }}, ddir, bs,
+				offset, ioprio, 0 };
 
 			/*
 			 * Make a byte-for-byte copy of the latency histogram
@@ -3364,8 +3385,9 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
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
@@ -3381,24 +3403,31 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
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
 
-	if (td->slat_log)
-		add_log_sample(td, td->slat_log, sample_val(nsec), ddir, bs,
-			       offset, ioprio);
+	if (td->slat_log) {
+		struct log_sample sample = { sample_val(nsec), ddir,
+			io_u->xfer_buflen, io_u->offset, io_u->ioprio,
+			ntime_since(&td->epoch, &io_u->issue_time) };
+
+		add_log_sample(td, td->slat_log, &sample);
+	}
 
 	if (ts->slat_percentiles)
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_SLAT);
@@ -3409,8 +3438,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		    unsigned long long nsec, unsigned long long bs,
-		    uint64_t offset, unsigned int ioprio,
-		    unsigned short clat_prio_index)
+		    struct io_u * io_u)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -3423,9 +3451,12 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	add_stat_sample(&ts->lat_stat[ddir], nsec);
 
-	if (td->lat_log)
-		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
-			       offset, ioprio);
+	if (td->lat_log) {
+		struct log_sample sample = { sample_val(nsec), ddir, bs,
+			io_u->offset, io_u->ioprio, 0 };
+
+		add_log_sample(td, td->lat_log, &sample);
+	}
 
 	/*
 	 * When lat_percentiles=1 (default 0), the reported per priority
@@ -3439,8 +3470,9 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
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
@@ -3464,9 +3496,12 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 
 	add_stat_sample(&ts->bw_stat[io_u->ddir], rate);
 
-	if (td->bw_log)
-		add_log_sample(td, td->bw_log, sample_val(rate), io_u->ddir,
-			       bytes, io_u->offset, io_u->ioprio);
+	if (td->bw_log) {
+		struct log_sample sample = { sample_val(rate), io_u->ddir,
+			bytes, io_u->offset, io_u->ioprio, 0 };
+
+		add_log_sample(td, td->bw_log, &sample);
+	}
 
 	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
 
@@ -3515,13 +3550,12 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 		add_stat_sample(&stat[ddir], rate);
 
 		if (log) {
-			unsigned long long bs = 0;
+			struct log_sample sample = {
+				sample_val(rate), ddir, 0, 0, 0, 0 };
 
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
-				bs = td->o.min_bs[ddir];
-
-			next = add_log_sample(td, log, sample_val(rate), ddir,
-					      bs, 0, 0);
+				sample.bs = td->o.min_bs[ddir];
+			next = add_log_sample(td, log, &sample);
 			next_log = min(next_log, next);
 		}
 
@@ -3559,9 +3593,12 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 
 	add_stat_sample(&ts->iops_stat[io_u->ddir], 1);
 
-	if (td->iops_log)
-		add_log_sample(td, td->iops_log, sample_val(1), io_u->ddir,
-			       bytes, io_u->offset, io_u->ioprio);
+	if (td->iops_log) {
+		struct log_sample sample = { sample_val(1), io_u->ddir, bytes,
+			io_u->offset, io_u->ioprio, 0 };
+
+		add_log_sample(td, td->iops_log, &sample);
+	}
 
 	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
 
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
diff --git a/t/jobs/t0033.fio b/t/jobs/t0033.fio
new file mode 100644
index 00000000..156bdadc
--- /dev/null
+++ b/t/jobs/t0033.fio
@@ -0,0 +1,28 @@
+[global]
+rw=read
+filename=t0033file
+size=8k
+time_based
+runtime=2s
+ioengine=libaio
+iodepth=1
+
+[job1]
+write_bw_log=log
+log_prio=1
+
+[job2]
+write_lat_log=log
+log_avg_msec=100
+log_window_value=both
+
+[job3]
+write_iops_log=log
+log_offset=1
+log_prio=1
+
+[job4]
+write_iops_log=log
+log_avg_msec=100
+log_window_value=both
+log_offset=1
diff --git a/t/jobs/t0034.fio b/t/jobs/t0034.fio
new file mode 100644
index 00000000..2b6c4b2d
--- /dev/null
+++ b/t/jobs/t0034.fio
@@ -0,0 +1,27 @@
+[global]
+rw=read
+filename=t0034file
+size=8k
+time_based
+runtime=2s
+ioengine=libaio
+iodepth=1
+
+[job1]
+write_lat_log=log
+log_offset=1
+log_issue_time=1
+
+[job2]
+write_lat_log=log
+log_offset=1
+log_issue_time=1
+log_avg_msec=100
+log_window_value=both
+
+[job3]
+write_lat_log=log
+write_bw_log=log
+write_iops_log=log
+log_offset=1
+log_issue_time=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 22580613..47482144 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -47,6 +47,7 @@ import time
 import shutil
 import logging
 import argparse
+import re
 from pathlib import Path
 from statsmodels.sandbox.stats.runs import runstest_1samp
 from fiotestlib import FioExeTest, FioJobFileTest, run_fio_tests
@@ -553,6 +554,51 @@ class FioJobFileTest_t0029(FioJobFileTest):
         if self.json_data['jobs'][1]['read']['io_kbytes'] != 8:
             self.passed = False
 
+class FioJobFileTest_LogFileFormat(FioJobFileTest):
+    """Test log file format"""
+    def setup(self, *args, **kws):
+        super().setup(*args, **kws)
+        self.patterns = {}
+
+    def check_result(self):
+        super().check_result()
+
+        if not self.passed:
+            return
+
+        for logfile in self.patterns.keys():
+            file_path = os.path.join(self.paths['test_dir'], logfile)
+            with open(file_path, "r") as f:
+                line = f.readline()
+                if not re.match(self.patterns[logfile], line):
+                    self.passed = False
+                    self.failure_reason = "wrong log file format: " + logfile
+                    return
+
+class FioJobFileTest_t0033(FioJobFileTest_LogFileFormat):
+    """Test log file format"""
+    def setup(self, *args, **kws):
+        super().setup(*args, **kws)
+        self.patterns = {
+            'log_bw.1.log': '\\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
+            'log_clat.2.log': '\\d+, \\d+, \\d+, \\d+, 0, \\d+\\n',
+            'log_iops.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
+            'log_iops.4.log': '\\d+, \\d+, \\d+, \\d+, 0, 0, \\d+\\n',
+        }
+
+class FioJobFileTest_t0034(FioJobFileTest_LogFileFormat):
+    """Test log file format"""
+    def setup(self, *args, **kws):
+        super().setup(*args, **kws)
+        self.patterns = {
+            'log_clat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, \\d+\\n',
+            'log_slat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, \\d+\\n',
+            'log_lat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
+            'log_clat.2.log': '\\d+, \\d+, \\d+, \\d+, 0, 0, \\d+, 0\\n',
+            'log_bw.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
+            'log_iops.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
+        }
+
 class FioJobFileTest_iops_rate(FioJobFileTest):
     """Test consists of fio test job t0011
     Confirm that job0 iops == 1000
@@ -878,6 +924,26 @@ TEST_LIST = [
         'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
+    {
+        'test_id':          33,
+        'test_class':       FioJobFileTest_t0033,
+        'job':              't0033.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
+    {
+        'test_id':          34,
+        'test_class':       FioJobFileTest_t0034,
+        'job':              't0034.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
diff --git a/thread_options.h b/thread_options.h
index 20fc18a3..ee1e5b31 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -400,6 +400,7 @@ struct thread_options {
 
 	unsigned int log_entries;
 	unsigned int log_prio;
+	unsigned int log_issue_time;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -708,6 +709,7 @@ struct thread_options_pack {
 
 	uint32_t log_entries;
 	uint32_t log_prio;
+	uint32_t log_issue_time;
 
 	uint32_t fdp;
 	uint32_t dp_type;
