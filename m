Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543061537A8
	for <fio@vger.kernel.org>; Tue, 27 Aug 2024 07:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742545; cv=none; b=BlnO7GCJiaGFVN3C4w8VG8+yIZDCGlLckyFy1a3OBZvh/ddqIyBYwZgD6YYZCi8Swkxk/rUDojAk189MMnVMfJJyQQW3+7ZpXe4EW8G5IEM61KTL18+gNDwmD+5pUFNDpD4stISyDNHHKc9iPPdnsVD2UwXJ6AYhmy84r9zEcUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742545; c=relaxed/simple;
	bh=KgaK/ZOZOr+33nzx7ZW5LyDNynuxFpmULJke8RcTcsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GII8n0iKDG6ZHo9jS6+ecHI1mpjlK0fQc2I49Ty/uLwXmRfsLzd5cct8d/kjZ9dO1LqGgqlPH2uaXn1N6ysUB0f6Iq7D1G08Mm7IQXeVGnYJRSQMv+qLgn4F1+e/Nz5kHuFhg128YbJNoEB4hO1EODFmdByhOIiGRoXS3Yxqj44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FATovtnU; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FATovtnU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724742543; x=1756278543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KgaK/ZOZOr+33nzx7ZW5LyDNynuxFpmULJke8RcTcsE=;
  b=FATovtnU4eTWLhO9TgYh8AMz5IDq8uO35fw6bNmLT/RWrvbRhC7nQraC
   xyvx9FEDEzw8yAuUcBdUXL1aOKKmgvTQX5BJIj6aFVSwhFwIUy0xrtePE
   m9zrpCNOE/wBBWcPz1QS9hwJZ4CiliBCdhVm+X5LlpjWv3e3puTn4uyqe
   2042lL7tKFkKbX++Tjbv2oYgM6znzesPVWHQ7UWa2Ia9hnkhxOxRxotWi
   rI3DOTWKjDFvhy9SQN+DZ8/IrSqs7NCMHvN8AVijmqPCo11PyqTn4T4oG
   ZpF/0u7M3mHh9k5ELT4PCag6FQnTSn2/zX+Xab8ALhnd9a7XT67HOBVjw
   g==;
X-CSE-ConnectionGUID: q8mcoR7pSBm4UQ6UBgPQzQ==
X-CSE-MsgGUID: aKvqsE7dSlKSILRemp9hWQ==
X-IronPort-AV: E=Sophos;i="6.10,179,1719849600"; 
   d="scan'208";a="25297875"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2024 15:08:57 +0800
IronPort-SDR: 66cd6eca_gOkA2jKT2GcO1KqSE5C+CcUE8WjciB6v4iR+Gie7OL5aM9t
 P/twivIsCydizmnZ6R/1qjxH5JRYqCy3rdcntbg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2024 23:14:35 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2024 00:08:56 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 5/9] introduce the log_issue_time option
Date: Tue, 27 Aug 2024 16:08:46 +0900
Message-ID: <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When write_lat_log option is set, fio outputs the 'clat' completion
latency log file. This clat log can be used to analyze IO latency. This
file can also be considered as an IO trace file as each IO entry can
fully describe an IO when the --log_offset and --log_prio options are
also used.

However, using the clat log file as an IO trace is inaccuate due to two
reasons. Firstly, the time field of each entry uses millisecond units,
which is too coarse for fast IOs (e.g. when using SSDs). Secondly, the
time field value is recorded not at command completion, but at log
sample recording. The time field value is slightly different from the IO
completion time. It can be used only as an approximated completion time.

To analyze IO issue time and IO completion time accurately using the
clat log, introduce the new option 'log_issue_time'. When this option is
set, add another field to the log file entries and put the IO issue time
in nanosecond to the field. The IO completion time can be calculated by
adding the completion latency to the IO issue time.

The IO issue time field is added to 'slat' submit latency log file also.
This helps to calculate IO start time by subtracting the submission
latency from the IO issue time.

The log_issue_time option can be used for IO trace when the
write_lat_log option and the log_offset options are set together. When
the log_issue_time option is set but the write_lat_log option or the
log_offset option is not set, fio errors out. When the log_issue_time
option and the write_lat_log option are set together with other
write_X_log options, the IO issue time field is added to all log files.
As for the other log files than clat and slat log, the IO issue time
does not have meaning then '0' is set to the field. When log_avg_msec
option is set, average of the log values of the specified duration is
logged. The IO issue time does not have meaning in this case either and
'0' is set to the field.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 cconv.c          |  2 ++
 client.c         | 30 ++++++++++++++++++++----------
 init.c           | 12 ++++++++++++
 iolog.c          | 29 +++++++++++++++++++++--------
 iolog.h          | 30 ++++++++++++++++++++++++------
 options.c        | 10 ++++++++++
 server.c         |  4 ++++
 server.h         |  1 +
 stat.c           | 24 +++++++++++++++---------
 thread_options.h |  2 ++
 10 files changed, 111 insertions(+), 33 deletions(-)

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
index 0b6044dd..5964faba 100644
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
 
@@ -1730,6 +1736,10 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 			s->aux[IOS_AUX_OFFSET_INDEX] =
 				le64_to_cpu(s->aux[IOS_AUX_OFFSET_INDEX]);
 
+		if (ret->log_issue_time)
+			s->aux[IOS_AUX_ISSUE_TIME_INDEX] =
+				le64_to_cpu(s->aux[IOS_AUX_ISSUE_TIME_INDEX]);
+
 		if (ret->log_type == IO_LOG_TYPE_HIST) {
 			s->data.plat_entry = (struct io_u_plat_entry *)(((char *)s) + sizeof(*s));
 			s->data.plat_entry->list.next = NULL;
diff --git a/init.c b/init.c
index ff3e9a90..3b213c0e 100644
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
+			log_err("fio: log_issue_time option requires log_write_lat_log and log_offset options\n");
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
+		log_err("fio: log_issue_time option requires log_write_lat_log and log_offset options\n");
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
diff --git a/iolog.c b/iolog.c
index bb1ade86..aadb0d05 100644
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
@@ -1038,7 +1043,7 @@ static int print_sample_fields(char **p, size_t *left, const char *fmt, ...) {
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
-	bool log_offset, log_prio, log_avg_max;
+	bool log_offset, log_prio, log_avg_max, log_issue_time;
 	uint64_t i, nr_samples;
 	char buf[256];
 	char *p;
@@ -1048,15 +1053,16 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 	if (!sample_size)
 		return;
 
-	s = __get_sample(samples, 0, 0);
+	s = __get_sample(samples, 0, 0, 0);
 	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
 	log_prio = (s->__ddir & LOG_PRIO_SAMPLE_BIT) != 0;
 	log_avg_max = (s->__ddir & LOG_AVG_MAX_SAMPLE_BIT) != 0;
+	log_issue_time = (s->__ddir & LOG_ISSUE_TIME_SAMPLE_BIT) != 0;
 
-	nr_samples = sample_size / __log_entry_sz(log_offset);
+	nr_samples = sample_size / __log_entry_sz(log_offset, log_issue_time);
 
 	for (i = 0; i < nr_samples; i++) {
-		s = __get_sample(samples, log_offset, i);
+		s = __get_sample(samples, log_offset, log_issue_time, i);
 		p = buf;
 		left = sizeof(buf);
 
@@ -1094,6 +1100,13 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 		if (ret)
 			return;
 
+		if (log_issue_time) {
+			ret = print_sample_fields(&p, &left, ", %llu",
+						  (unsigned long long) s->aux[IOS_AUX_ISSUE_TIME_INDEX]);
+			if (ret)
+				return;
+		}
+
 		fprintf(f, "%s\n", buf);
 	}
 }
diff --git a/iolog.h b/iolog.h
index d868921b..e864d169 100644
--- a/iolog.h
+++ b/iolog.h
@@ -62,6 +62,7 @@ struct io_sample {
  */
 enum {
 	IOS_AUX_OFFSET_INDEX,
+	IOS_AUX_ISSUE_TIME_INDEX,
 };
 
 enum {
@@ -122,6 +123,11 @@ struct io_log {
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
@@ -171,9 +177,14 @@ struct io_log {
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
@@ -183,19 +194,22 @@ static inline void io_sample_set_ddir(struct io_log *log,
 	io->__ddir = ddir | log->log_ddir_mask;
 }
 
-static inline size_t __log_entry_sz(bool log_offset)
+static inline size_t __log_entry_sz(bool log_offset, bool log_issue_time)
 {
 	size_t ret = sizeof(struct io_sample);
 
 	if (log_offset)
 		ret += sizeof(uint64_t);
 
+	if (log_issue_time)
+		ret += sizeof(uint64_t);
+
 	return ret;
 }
 
 static inline size_t log_entry_sz(struct io_log *log)
 {
-	return __log_entry_sz(log->log_offset);
+	return __log_entry_sz(log->log_offset, log->log_issue_time);
 }
 
 static inline size_t log_sample_sz(struct io_log *log, struct io_logs *cur_log)
@@ -203,10 +217,12 @@ static inline size_t log_sample_sz(struct io_log *log, struct io_logs *cur_log)
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
 
@@ -219,7 +235,8 @@ static inline struct io_sample *get_sample(struct io_log *iolog,
 					   struct io_logs *cur_log,
 					   uint64_t sample)
 {
-	return __get_sample(cur_log->log, iolog->log_offset, sample);
+	return __get_sample(cur_log->log,
+			    iolog->log_offset, iolog->log_issue_time, sample);
 }
 
 enum {
@@ -295,6 +312,7 @@ struct log_params {
 	int log_type;
 	int log_offset;
 	int log_prio;
+	int log_issue_time;
 	int log_gz;
 	int log_gz_store;
 	int log_compress;
diff --git a/options.c b/options.c
index ab650bb7..73fd4a7f 100644
--- a/options.c
+++ b/options.c
@@ -4727,6 +4727,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
index dbb9eb5e..5967f421 100644
--- a/server.c
+++ b/server.c
@@ -2298,6 +2298,10 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 			if (log->log_offset)
 				s->aux[IOS_AUX_OFFSET_INDEX] =
 					cpu_to_le64(s->aux[IOS_AUX_OFFSET_INDEX]);
+
+			if (log->log_issue_time)
+				s->aux[IOS_AUX_ISSUE_TIME_INDEX] =
+					cpu_to_le64(s->aux[IOS_AUX_ISSUE_TIME_INDEX]);
 		}
 	}
 
diff --git a/server.h b/server.h
index a8e4dbf2..2157da97 100644
--- a/server.h
+++ b/server.h
@@ -197,6 +197,7 @@ struct cmd_iolog_pdu {
 	uint32_t compressed;
 	uint32_t log_offset;
 	uint32_t log_prio;
+	uint32_t log_issue_time;
 	uint32_t log_hist_coarseness;
 	uint32_t per_job_logs;
 	uint8_t name[FIO_NET_NAME_MAX];
diff --git a/stat.c b/stat.c
index 56d04e7a..2cfd6819 100644
--- a/stat.c
+++ b/stat.c
@@ -30,6 +30,7 @@ struct log_sample {
 	uint64_t bs;
 	uint64_t offset;
 	uint16_t priority;
+	uint64_t issue_time;
 };
 
 struct fio_sem *stat_sem;
@@ -3066,6 +3067,9 @@ static void __add_log_sample(struct io_log *iolog, unsigned long t,
 		if (iolog->log_offset)
 			s->aux[IOS_AUX_OFFSET_INDEX] = sample->offset;
 
+		if (iolog->log_issue_time)
+			s->aux[IOS_AUX_ISSUE_TIME_INDEX] = sample->issue_time;
+
 		cur_log->nr_samples++;
 		return;
 	}
@@ -3160,7 +3164,7 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 	 * had actual samples done.
 	 */
 	if (iolog->avg_window[ddir].samples) {
-		struct log_sample sample = { {{ 0, 0 }}, ddir, 0, 0, 0 };
+		struct log_sample sample = { {{ 0, 0 }}, ddir, 0, 0, 0, 0 };
 		union io_sample_data *d = &sample.data;
 
 		if (log_max == IO_LOG_SAMPLE_AVG) {
@@ -3258,7 +3262,7 @@ void add_agg_sample(union io_sample_data data, enum fio_ddir ddir,
 		    unsigned long long bs)
 {
 	struct io_log *iolog;
-	struct log_sample sample = { data, ddir, bs, 0, 0 };
+	struct log_sample sample = { data, ddir, bs, 0, 0, 0 };
 
 	if (!ddir_rw(ddir))
 		return;
@@ -3336,7 +3340,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->clat_log) {
 		struct log_sample sample = { sample_val(nsec), ddir, bs,
-			offset, ioprio };
+			offset, ioprio,
+			ntime_since(&td->epoch, &io_u->issue_time) };
 
 		add_log_sample(td, td->clat_log, &sample);
 	}
@@ -3366,7 +3371,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			uint64_t *io_u_plat;
 			struct io_u_plat_entry *dst;
 			struct log_sample sample = { {{ 0, 0 }}, ddir, bs,
-				offset, ioprio };
+				offset, ioprio, 0 };
 
 			/*
 			 * Make a byte-for-byte copy of the latency histogram
@@ -3418,7 +3423,8 @@ void add_slat_sample(struct thread_data *td, struct io_u *io_u)
 
 	if (td->slat_log) {
 		struct log_sample sample = { sample_val(nsec), ddir,
-			io_u->xfer_buflen, io_u->offset, io_u->ioprio };
+			io_u->xfer_buflen, io_u->offset, io_u->ioprio,
+			ntime_since(&td->epoch, &io_u->issue_time) };
 
 		add_log_sample(td, td->slat_log, &sample);
 	}
@@ -3447,7 +3453,7 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->lat_log) {
 		struct log_sample sample = { sample_val(nsec), ddir, bs,
-			io_u->offset, io_u->ioprio };
+			io_u->offset, io_u->ioprio, 0 };
 
 		add_log_sample(td, td->lat_log, &sample);
 	}
@@ -3492,7 +3498,7 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 
 	if (td->bw_log) {
 		struct log_sample sample = { sample_val(rate), io_u->ddir,
-			bytes, io_u->offset, io_u->ioprio };
+			bytes, io_u->offset, io_u->ioprio, 0 };
 
 		add_log_sample(td, td->bw_log, &sample);
 	}
@@ -3545,7 +3551,7 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 
 		if (log) {
 			struct log_sample sample = {
-				sample_val(rate), ddir, 0, 0, 0 };
+				sample_val(rate), ddir, 0, 0, 0, 0 };
 
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				sample.bs = td->o.min_bs[ddir];
@@ -3589,7 +3595,7 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 
 	if (td->iops_log) {
 		struct log_sample sample = { sample_val(1), io_u->ddir, bytes,
-			io_u->offset, io_u->ioprio };
+			io_u->offset, io_u->ioprio, 0 };
 
 		add_log_sample(td, td->iops_log, &sample);
 	}
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
-- 
2.45.2

