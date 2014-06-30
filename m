Return-Path: <axboe@kernel.dk>
Message-ID: <53B1E257.5070405@kernel.dk>
Date: Mon, 30 Jun 2014 16:19:03 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Log offsets of I/O operations
References: <87pphr7g5d.fsf@gmail.com> <53B1DBB8.4080901@kernel.dk> <87d2dqcak6.fsf@gmail.com>
In-Reply-To: <87d2dqcak6.fsf@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060009020007000107040906"
To: Abutalib Aghayev <agayev@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060009020007000107040906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-06-30 16:09, Abutalib Aghayev wrote:
>
> On Mon, Jun 30 2014 at 17:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-06-29 11:43, Abutalib Aghayev wrote:
>>>
>>> This is a quick and dirty patch to log offsets of I/O operations as
>>> well.  It is useful if you would like to make offset vs latency plot for
>>> random I/O, which may not be interesting to many people, so feel free to
>>> ignore it.
>>
>> I can definitely see this being useful. But adding 8 bytes to every log
>> entry complicates things, as fio is already memory intensive there when
>> logging longer runs.
>>
>> I'd suggest having two logging types:
>>
>> struct io_sample {
>>             uint64_t time;
>>             uint64_t val;
>>             uint32_t ddir;
>>             uint32_t bs;
>>             uint64_t offset;
>
> I assume you didn't mean offset being here as well.

Ah no, of course not.

>> struct io_sample_offset {
>>             struct io_sample s;
>>             uint64_t offset;
>> };
>>
>> and using the right type for what you are logging. This means you'd need
>> an option to switch on the offset logging, and that you'd need to store
>> this in the iolog struct (whether to log offset or not) and use the
>> appropriate size for allocating and extending the log entries when needed.
>>
>> Make sense?
>
> Yes, let me rework the patch.

Thanks! Note that you also need to handle the client/server part. 
Half-assed attempt attached, not tested at all. Still needs the client 
part update.


-- 
Jens Axboe


--------------060009020007000107040906
Content-Type: text/x-patch;
 name="iolog-offset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iolog-offset.patch"

diff --git a/backend.c b/backend.c
index ee75566af84c..ac6ed3e45fc2 100644
--- a/backend.c
+++ b/backend.c
@@ -2020,9 +2020,9 @@ int fio_backend(void)
 		return 0;
 
 	if (write_bw_log) {
-		setup_log(&agg_io_log[DDIR_READ], 0, IO_LOG_TYPE_BW);
-		setup_log(&agg_io_log[DDIR_WRITE], 0, IO_LOG_TYPE_BW);
-		setup_log(&agg_io_log[DDIR_TRIM], 0, IO_LOG_TYPE_BW);
+		setup_log(&agg_io_log[DDIR_READ], 0, IO_LOG_TYPE_BW, 0);
+		setup_log(&agg_io_log[DDIR_WRITE], 0, IO_LOG_TYPE_BW, 0);
+		setup_log(&agg_io_log[DDIR_TRIM], 0, IO_LOG_TYPE_BW, 0);
 	}
 
 	startup_mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
diff --git a/client.c b/client.c
index 828dd97b0b35..9ab7e70df8ca 100644
--- a/client.c
+++ b/client.c
@@ -1156,7 +1156,11 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 	 */
 	nr_samples = le32_to_cpu(pdu->nr_samples);
 
-	total = nr_samples * sizeof(struct io_sample);
+	if (pdu->log_offset)
+		total = nr_samples * sizeof(struct io_sample);
+	else
+		total = nr_samples * sizeof(struct io_sample_offset);
+
 	ret = malloc(total + sizeof(*pdu));
 	ret->nr_samples = nr_samples;
 
@@ -1225,10 +1229,11 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
 	} else
 		ret = pdu;
 
+	ret->nr_samples		= le64_to_cpu(ret->nr_samples);
 	ret->thread_number	= le32_to_cpu(ret->thread_number);
-	ret->nr_samples		= le32_to_cpu(ret->nr_samples);
 	ret->log_type		= le32_to_cpu(ret->log_type);
 	ret->compressed		= le32_to_cpu(ret->compressed);
+	ret->log_offset		= le32_to_cpu(ret->log_offset);
 
 	for (i = 0; i < ret->nr_samples; i++) {
 		struct io_sample *s = &ret->samples[i];
diff --git a/init.c b/init.c
index 6b29aa702407..4f8b38d6e632 100644
--- a/init.c
+++ b/init.c
@@ -1146,14 +1146,19 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		goto err;
 
 	if (o->lat_log_file || write_lat_log) {
-		setup_log(&td->lat_log, o->log_avg_msec, IO_LOG_TYPE_LAT);
-		setup_log(&td->slat_log, o->log_avg_msec, IO_LOG_TYPE_SLAT);
-		setup_log(&td->clat_log, o->log_avg_msec, IO_LOG_TYPE_CLAT);
+		setup_log(&td->lat_log, o->log_avg_msec, IO_LOG_TYPE_LAT,
+				o->log_offset);
+		setup_log(&td->slat_log, o->log_avg_msec, IO_LOG_TYPE_SLAT,
+				o->log_offset);
+		setup_log(&td->clat_log, o->log_avg_msec, IO_LOG_TYPE_CLAT,
+				o->log_offset);
 	}
 	if (o->bw_log_file || write_bw_log)
-		setup_log(&td->bw_log, o->log_avg_msec, IO_LOG_TYPE_BW);
+		setup_log(&td->bw_log, o->log_avg_msec, IO_LOG_TYPE_BW,
+				o->log_offset);
 	if (o->iops_log_file)
-		setup_log(&td->iops_log, o->log_avg_msec, IO_LOG_TYPE_IOPS);
+		setup_log(&td->iops_log, o->log_avg_msec, IO_LOG_TYPE_IOPS,
+				o->log_offset);
 
 	if (!o->name)
 		o->name = strdup(jobname);
diff --git a/io_u.c b/io_u.c
index 997e1137ab90..5b9d483dcd33 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1567,7 +1567,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		unsigned long tusec;
 
 		tusec = utime_since(&io_u->start_time, &icd->time);
-		add_lat_sample(td, idx, tusec, bytes);
+		add_lat_sample(td, idx, tusec, bytes, io_u->offset);
 
 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops = &td->prof_io_ops;
@@ -1585,7 +1585,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	}
 
 	if (!td->o.disable_clat) {
-		add_clat_sample(td, idx, lusec, bytes);
+		add_clat_sample(td, idx, lusec, bytes, io_u->offset);
 		io_u_mark_latency(td, lusec);
 	}
 
@@ -1823,7 +1823,8 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 		unsigned long slat_time;
 
 		slat_time = utime_since(&io_u->start_time, &io_u->issue_time);
-		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen);
+		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen,
+				io_u->offset);
 	}
 }
 
diff --git a/iolog.c b/iolog.c
index fd1e9e49dd18..ad3cf9cd9151 100644
--- a/iolog.c
+++ b/iolog.c
@@ -539,7 +539,8 @@ int init_iolog(struct thread_data *td)
 	return ret;
 }
 
-void setup_log(struct io_log **log, unsigned long avg_msec, int log_type)
+void setup_log(struct io_log **log, unsigned long avg_msec, int log_type,
+	       int log_offset)
 {
 	struct io_log *l = malloc(sizeof(*l));
 
@@ -547,7 +548,8 @@ void setup_log(struct io_log **log, unsigned long avg_msec, int log_type)
 	l->nr_samples = 0;
 	l->max_samples = 1024;
 	l->log_type = log_type;
-	l->log = malloc(l->max_samples * sizeof(struct io_sample));
+	l->log_offset = log_offset;
+	l->log = malloc(l->max_samples * log_entry_sz(l));
 	l->avg_msec = avg_msec;
 	*log = l;
 }
@@ -593,10 +595,22 @@ void __finish_log(struct io_log *log, const char *name)
 	buf = set_file_buffer(f);
 
 	for (i = 0; i < log->nr_samples; i++) {
-		fprintf(f, "%lu, %lu, %u, %u\n",
-				(unsigned long) log->log[i].time,
-				(unsigned long) log->log[i].val,
-				log->log[i].ddir, log->log[i].bs);
+		struct io_sample *s = get_sample(log, i);
+
+		if (!log->log_offset) {
+			fprintf(f, "%lu, %lu, %u, %u\n",
+					(unsigned long) s->time,
+					(unsigned long) s->val,
+					s->ddir, s->bs);
+		} else {
+			struct io_sample_offset *so = (void *) s;
+
+			fprintf(f, "%lu, %lu, %u, %u, %llu\n",
+					(unsigned long) s->time,
+					(unsigned long) s->val,
+					s->ddir, s->bs,
+					(unsigned long long) so->offset);
+		}
 	}
 
 	fclose(f);
diff --git a/iolog.h b/iolog.h
index 3af56682c64e..42095b2379ff 100644
--- a/iolog.h
+++ b/iolog.h
@@ -28,6 +28,11 @@ struct io_sample {
 	uint32_t bs;
 };
 
+struct io_sample_offset {
+	struct io_sample s;
+	uint64_t offset;
+};
+
 enum {
 	IO_LOG_TYPE_LAT = 1,
 	IO_LOG_TYPE_CLAT,
@@ -45,7 +50,7 @@ struct io_log {
 	 */
 	unsigned long nr_samples;
 	unsigned long max_samples;
-	struct io_sample *log;
+	void *log;
 
 	unsigned int log_type;
 
@@ -55,6 +60,11 @@ struct io_log {
 	unsigned int disabled;
 
 	/*
+	 * Log offsets
+	 */
+	unsigned int log_offset;
+
+	/*
 	 * Windowed average, for logging single entries average over some
 	 * period of time.
 	 */
@@ -63,6 +73,20 @@ struct io_log {
 	unsigned long avg_last;
 };
 
+static inline size_t log_entry_sz(struct io_log *log)
+{
+	if (log->log_offset)
+		return sizeof(struct io_sample_offset);
+	else
+		return sizeof(struct io_sample);
+}
+
+static inline struct io_sample *get_sample(struct io_log *iolog,
+					   uint64_t sample)
+{
+	return iolog->log + sample * log_entry_sz(iolog);
+}
+
 enum {
 	IP_F_ONRB	= 1,
 	IP_F_ONLIST	= 2,
@@ -121,18 +145,18 @@ extern void write_iolog_close(struct thread_data *);
  */
 extern void finalize_logs(struct thread_data *td);
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int);
+				unsigned int, unsigned long long);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int);
+				unsigned int, unsigned long long);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int);
+				unsigned int, unsigned long long);
 extern void add_bw_sample(struct thread_data *, enum fio_ddir, unsigned int,
 				struct timeval *);
 extern void add_iops_sample(struct thread_data *, enum fio_ddir, unsigned int,
 				struct timeval *);
 extern void init_disk_util(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
-extern void setup_log(struct io_log **, unsigned long, int);
+extern void setup_log(struct io_log **, unsigned long, int, int);
 extern void __finish_log(struct io_log *, const char *);
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern int write_bw_log;
diff --git a/options.c b/options.c
index 74347f3554e0..da70087d2fd7 100644
--- a/options.c
+++ b/options.c
@@ -3095,6 +3095,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "log_offset",
+		.lname	= "Log offset of IO",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(log_offset),
+		.help	= "Include offset of IO for each log entry",
+		.def	= "0",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "bwavgtime",
 		.lname	= "Bandwidth average time",
 		.type	= FIO_OPT_INT,
diff --git a/server.c b/server.c
index 76b6b54d369b..cd00cc65f852 100644
--- a/server.c
+++ b/server.c
@@ -1177,7 +1177,7 @@ static int fio_send_iolog_gz(struct cmd_iolog_pdu *pdu, struct io_log *log)
 	}
 
 	stream.next_in = (void *) log->log;
-	stream.avail_in = log->nr_samples * sizeof(struct io_sample);
+	stream.avail_in = log->nr_samples * log_entry_sz(log);
 
 	do {
 		unsigned int this_len, flags = 0;
@@ -1214,8 +1214,8 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	struct cmd_iolog_pdu pdu;
 	int i, ret = 0;
 
+	pdu.nr_samples = cpu_to_le64(log->nr_samples);
 	pdu.thread_number = cpu_to_le32(td->thread_number);
-	pdu.nr_samples = __cpu_to_le32(log->nr_samples);
 	pdu.log_type = cpu_to_le32(log->log_type);
 	pdu.compressed = cpu_to_le32(use_zlib);
 
@@ -1223,12 +1223,18 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	pdu.name[FIO_NET_NAME_MAX - 1] = '\0';
 
 	for (i = 0; i < log->nr_samples; i++) {
-		struct io_sample *s = &log->log[i];
+		struct io_sample *s = get_sample(log, i);
 
 		s->time	= cpu_to_le64(s->time);
 		s->val	= cpu_to_le64(s->val);
 		s->ddir	= cpu_to_le32(s->ddir);
 		s->bs	= cpu_to_le32(s->bs);
+
+		if (log->log_offset) {
+			struct io_sample_offset *so = (void *) s;
+
+			so->offset = cpu_to_le64(so->offset);
+		}
 	}
 
 	/*
@@ -1246,7 +1252,7 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 		return fio_send_iolog_gz(&pdu, log);
 
 	return fio_send_cmd_ext_pdu(server_fd, FIO_NET_CMD_IOLOG, log->log,
-			log->nr_samples * sizeof(struct io_sample), 0, 0);
+			log->nr_samples * log_entry_sz(log), 0, 0);
 }
 
 void fio_server_send_add_job(struct thread_data *td)
diff --git a/server.h b/server.h
index 52ad4a1518fb..cc4c5b435a2f 100644
--- a/server.h
+++ b/server.h
@@ -143,10 +143,11 @@ struct cmd_text_pdu {
 };
 
 struct cmd_iolog_pdu {
+	uint64_t nr_samples;
 	uint32_t thread_number;
-	uint32_t nr_samples;
 	uint32_t log_type;
 	uint32_t compressed;
+	uint32_t log_offset;
 	uint8_t name[FIO_NET_NAME_MAX];
 	struct io_sample samples[0];
 };
diff --git a/stat.c b/stat.c
index 3adb46eab808..bac637592f94 100644
--- a/stat.c
+++ b/stat.c
@@ -1563,9 +1563,10 @@ static inline void add_stat_sample(struct io_stat *is, unsigned long data)
 
 static void __add_log_sample(struct io_log *iolog, unsigned long val,
 			     enum fio_ddir ddir, unsigned int bs,
-			     unsigned long t)
+			     unsigned long t, unsigned long long offset)
 {
 	const int nr_samples = iolog->nr_samples;
+	struct io_sample *s;
 
 	if (iolog->disabled)
 		return;
@@ -1574,9 +1575,10 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 		iolog->avg_last = t;
 
 	if (iolog->nr_samples == iolog->max_samples) {
-		int new_size = sizeof(struct io_sample) * iolog->max_samples*2;
+		size_t new_size;
 		void *new_log;
 
+		new_size = 2 * iolog->max_samples * log_entry_sz(iolog);
 		new_log = realloc(iolog->log, new_size);
 		if (!new_log) {
 			log_err("fio: failed extending iolog! Will stop logging.\n");
@@ -1587,10 +1589,19 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 		iolog->max_samples <<= 1;
 	}
 
-	iolog->log[nr_samples].val = val;
-	iolog->log[nr_samples].time = t;
-	iolog->log[nr_samples].ddir = ddir;
-	iolog->log[nr_samples].bs = bs;
+	s = get_sample(iolog, nr_samples);
+
+	s->val = val;
+	s->time = t;
+	s->ddir = ddir;
+	s->bs = bs;
+
+	if (iolog->log_offset) {
+		struct io_sample_offset *so = (void *) s;
+
+		so->offset = offset;
+	}
+
 	iolog->nr_samples++;
 }
 
@@ -1646,19 +1657,19 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed)
 		unsigned long mr;
 
 		mr = iolog->avg_window[DDIR_READ].mean.u.f + 0.50;
-		__add_log_sample(iolog, mr, DDIR_READ, 0, elapsed);
+		__add_log_sample(iolog, mr, DDIR_READ, 0, elapsed, 0);
 	}
 	if (iolog->avg_window[DDIR_WRITE].samples) {
 		unsigned long mw;
 
 		mw = iolog->avg_window[DDIR_WRITE].mean.u.f + 0.50;
-		__add_log_sample(iolog, mw, DDIR_WRITE, 0, elapsed);
+		__add_log_sample(iolog, mw, DDIR_WRITE, 0, elapsed, 0);
 	}
 	if (iolog->avg_window[DDIR_TRIM].samples) {
 		unsigned long mw;
 
 		mw = iolog->avg_window[DDIR_TRIM].mean.u.f + 0.50;
-		__add_log_sample(iolog, mw, DDIR_TRIM, 0, elapsed);
+		__add_log_sample(iolog, mw, DDIR_TRIM, 0, elapsed, 0);
 	}
 
 	reset_io_stat(&iolog->avg_window[DDIR_READ]);
@@ -1668,7 +1679,7 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed)
 
 static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 			   unsigned long val, enum fio_ddir ddir,
-			   unsigned int bs)
+			   unsigned int bs, unsigned long long offset)
 {
 	unsigned long elapsed, this_window;
 
@@ -1681,7 +1692,7 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 * If no time averaging, just add the log sample.
 	 */
 	if (!iolog->avg_msec) {
-		__add_log_sample(iolog, val, ddir, bs, elapsed);
+		__add_log_sample(iolog, val, ddir, bs, elapsed, offset);
 		return;
 	}
 
@@ -1730,7 +1741,7 @@ void add_agg_sample(unsigned long val, enum fio_ddir ddir, unsigned int bs)
 		return;
 
 	iolog = agg_io_log[ddir];
-	__add_log_sample(iolog, val, ddir, bs, mtime_since_genesis());
+	__add_log_sample(iolog, val, ddir, bs, mtime_since_genesis(), 0);
 }
 
 static void add_clat_percentile_sample(struct thread_stat *ts,
@@ -1743,7 +1754,8 @@ static void add_clat_percentile_sample(struct thread_stat *ts,
 }
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long usec, unsigned int bs)
+		     unsigned long usec, unsigned int bs,
+		     unsigned long long offset)
 {
 	struct thread_stat *ts = &td->ts;
 
@@ -1753,14 +1765,15 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->clat_stat[ddir], usec);
 
 	if (td->clat_log)
-		add_log_sample(td, td->clat_log, usec, ddir, bs);
+		add_log_sample(td, td->clat_log, usec, ddir, bs, offset);
 
 	if (ts->clat_percentiles)
 		add_clat_percentile_sample(ts, usec, ddir);
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long usec, unsigned int bs)
+		     unsigned long usec, unsigned int bs,
+		     unsigned long long offset)
 {
 	struct thread_stat *ts = &td->ts;
 
@@ -1770,11 +1783,12 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->slat_stat[ddir], usec);
 
 	if (td->slat_log)
-		add_log_sample(td, td->slat_log, usec, ddir, bs);
+		add_log_sample(td, td->slat_log, usec, ddir, bs, offset);
 }
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
-		    unsigned long usec, unsigned int bs)
+		    unsigned long usec, unsigned int bs,
+		    unsigned long long offset)
 {
 	struct thread_stat *ts = &td->ts;
 
@@ -1784,7 +1798,7 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->lat_stat[ddir], usec);
 
 	if (td->lat_log)
-		add_log_sample(td, td->lat_log, usec, ddir, bs);
+		add_log_sample(td, td->lat_log, usec, ddir, bs, offset);
 }
 
 void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
@@ -1818,7 +1832,7 @@ void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
 		add_stat_sample(&ts->bw_stat[ddir], rate);
 
 		if (td->bw_log)
-			add_log_sample(td, td->bw_log, rate, ddir, bs);
+			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
 
 		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
 	}
@@ -1857,7 +1871,7 @@ void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs
 		add_stat_sample(&ts->iops_stat[ddir], iops);
 
 		if (td->iops_log)
-			add_log_sample(td, td->iops_log, iops, ddir, bs);
+			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
 
 		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
 	}
diff --git a/thread_options.h b/thread_options.h
index 57d84dbba3de..e53000ab248b 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -108,6 +108,7 @@ struct thread_options {
 	unsigned long long rand_seed;
 	unsigned int use_os_rand;
 	unsigned int log_avg_msec;
+	unsigned int log_offset;
 	unsigned int norandommap;
 	unsigned int softrandommap;
 	unsigned int bs_unaligned;
@@ -335,6 +336,7 @@ struct thread_options_pack {
 	uint64_t rand_seed;
 	uint32_t use_os_rand;
 	uint32_t log_avg_msec;
+	uint32_t log_offset;
 	uint32_t norandommap;
 	uint32_t softrandommap;
 	uint32_t bs_unaligned;

--------------060009020007000107040906--

