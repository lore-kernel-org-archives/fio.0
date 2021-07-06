Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 10/11] fio: Introduce the log_prio option
Date: Tue,  6 Jul 2021 09:17:42 +0900
Message-Id: <20210706001743.10818-11-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Introduce the log_prio option to expand priority logging from just a
single bit information (priority high vs low) to the full value of the
priority value used to execute IOs. When this option is set, the
priority value is printed as a 16-bits hexadecimal value combining
the I/O priority class and priority level as defined by the
ioprio_value() helper.

Similarly to the log_offset option, this option does not result in
actual I/O priority logging when log_avg_msec is set.

This patch also fixes a problem with the IO_U_F_PRIORITY flag, namely
that this flag is used to indicate that the IO is being executed with a
high priority on the device while at the same time indicating how to
account for the IO completion latency (high_prio clat vs low_prio clat).
With the introduction of the aioprioclass and aioprio options, these
assumptions are not necesarilly compatible anymore.
These problems are addressed as follows:
* The priority_bit field of struct iosample is replaced with the
  16-bits priority field representing the full io_u->ioprio value. When
  log_prio is set, the priority field value is logged as is. When
  log_prio is not set, 1 is logged as the entry's priority field if the
  sample priority class is IOPRIO_CLASS_RT, and 0 otherwise.
* IO_U_F_PRIORITY is renamed to IO_U_F_HIGH_PRIO to indicate that a job
  IO has the highest priority within the job context and so must be
  accounted as such using high_prio clat.

While fio final statistics only show accounting of high vs low IO
completion latency statistics, the log_prio option allows a user to
perform more detailed statistical analysis of a workload using
multiple different IO priorities.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 cconv.c              |  2 ++
 client.c             |  2 ++
 engines/filecreate.c |  2 +-
 engines/filedelete.c |  2 +-
 engines/filestat.c   |  2 +-
 engines/io_uring.c   |  6 ++--
 engines/libaio.c     |  5 +--
 eta.c                |  2 +-
 fio.1                | 15 +++++++--
 init.c               |  4 +++
 io_u.c               | 14 ++++++---
 io_u.h               | 10 ++++--
 iolog.c              | 45 ++++++++++++++++++++------
 iolog.h              | 16 ++++++++--
 options.c            | 10 ++++++
 os/os-android.h      |  5 +++
 os/os-linux.h        |  5 +++
 os/os.h              |  3 ++
 server.h             |  3 +-
 stat.c               | 75 +++++++++++++++++++++++---------------------
 stat.h               |  9 +++---
 thread_options.h     |  4 +++
 22 files changed, 170 insertions(+), 71 deletions(-)

diff --git a/cconv.c b/cconv.c
index 74c24106..c5d52c84 100644
--- a/cconv.c
+++ b/cconv.c
@@ -192,6 +192,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->log_hist_coarseness = le32_to_cpu(top->log_hist_coarseness);
 	o->log_max = le32_to_cpu(top->log_max);
 	o->log_offset = le32_to_cpu(top->log_offset);
+	o->log_prio = le32_to_cpu(top->log_prio);
 	o->log_gz = le32_to_cpu(top->log_gz);
 	o->log_gz_store = le32_to_cpu(top->log_gz_store);
 	o->log_unix_epoch = le32_to_cpu(top->log_unix_epoch);
@@ -415,6 +416,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
 	top->log_max = cpu_to_le32(o->log_max);
 	top->log_offset = cpu_to_le32(o->log_offset);
+	top->log_prio = cpu_to_le32(o->log_prio);
 	top->log_gz = cpu_to_le32(o->log_gz);
 	top->log_gz_store = cpu_to_le32(o->log_gz_store);
 	top->log_unix_epoch = cpu_to_le32(o->log_unix_epoch);
diff --git a/client.c b/client.c
index 29d8750a..8b230617 100644
--- a/client.c
+++ b/client.c
@@ -1679,6 +1679,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 	ret->log_type		= le32_to_cpu(ret->log_type);
 	ret->compressed		= le32_to_cpu(ret->compressed);
 	ret->log_offset		= le32_to_cpu(ret->log_offset);
+	ret->log_prio		= le32_to_cpu(ret->log_prio);
 	ret->log_hist_coarseness = le32_to_cpu(ret->log_hist_coarseness);
 
 	if (*store_direct)
@@ -1696,6 +1697,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		s->data.val	= le64_to_cpu(s->data.val);
 		s->__ddir	= __le32_to_cpu(s->__ddir);
 		s->bs		= le64_to_cpu(s->bs);
+		s->priority	= le16_to_cpu(s->priority);
 
 		if (ret->log_offset) {
 			struct io_sample_offset *so = (void *) s;
diff --git a/engines/filecreate.c b/engines/filecreate.c
index 16c64928..4bb13c34 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -49,7 +49,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
 	}
 
 	return 0;
diff --git a/engines/filedelete.c b/engines/filedelete.c
index 64c58639..e882ccf0 100644
--- a/engines/filedelete.c
+++ b/engines/filedelete.c
@@ -51,7 +51,7 @@ static int delete_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
 	}
 
 	return 0;
diff --git a/engines/filestat.c b/engines/filestat.c
index 405f028d..00311247 100644
--- a/engines/filestat.c
+++ b/engines/filestat.c
@@ -125,7 +125,7 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
 	}
 
 	return 0;
diff --git a/engines/io_uring.c b/engines/io_uring.c
index d083a65f..c44768d8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -270,6 +270,7 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->ioprio = td->o.ioprio_class << 13;
 		if (ld->ioprio_set)
 			sqe->ioprio |= td->o.ioprio;
+		io_u->ioprio = sqe->ioprio;
 		sqe->off = io_u->offset;
 		sqe->rw_flags = 0;
 	} else if (ddir_sync(io_u->ddir)) {
@@ -384,8 +385,9 @@ static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
 	unsigned int p = o->cmdprio_percentage[io_u->ddir];
 
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		ld->sqes[io_u->index].ioprio = ioprio_value(IOPRIO_CLASS_RT, 0);
-		io_u->flags |= IO_U_F_PRIORITY;
+		io_u->ioprio = ioprio_value(IOPRIO_CLASS_RT, 0);
+		ld->sqes[io_u->index].ioprio = io_u->ioprio;
+		io_u->flags |= IO_U_F_HIGH_PRIO;
 	}
 }
 
diff --git a/engines/libaio.c b/engines/libaio.c
index c0cbf97b..123705ea 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -288,6 +288,7 @@ static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
 		ioprio_value(o->aioprio_class[ddir], o->aioprio[ddir]);
 
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		io_u->ioprio = aioprio;
 		io_u->iocb.aio_reqprio = aioprio;
 		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
 		if (!td->ioprio || aioprio < td->ioprio) {
@@ -295,14 +296,14 @@ static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
 			 * The AIO priortity is higher than the default context
 			 * priority.
 			 */
-			io_u->flags |= IO_U_F_PRIORITY;
+			io_u->flags |= IO_U_F_HIGH_PRIO;
 		}
 	} else if (td->ioprio && td->ioprio < aioprio) {
 		/*
 		 * The IO will be executed with the default context priority
 		 * and it is higher than the aio priority.
 		 */
-		io_u->flags |= IO_U_F_PRIORITY;
+		io_u->flags |= IO_U_F_HIGH_PRIO;
 	}
 }
 
diff --git a/eta.c b/eta.c
index db13cb18..ea1781f3 100644
--- a/eta.c
+++ b/eta.c
@@ -509,7 +509,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		memcpy(&rate_prev_time, &now, sizeof(now));
 		regrow_agg_logs();
 		for_each_rw_ddir(ddir) {
-			add_agg_sample(sample_val(je->rate[ddir]), ddir, 0, 0);
+			add_agg_sample(sample_val(je->rate[ddir]), ddir, 0);
 		}
 	}
 
diff --git a/fio.1 b/fio.1
index 129aeb94..3cef5e2d 100644
--- a/fio.1
+++ b/fio.1
@@ -3200,6 +3200,11 @@ If this is set, the iolog options will include the byte offset for the I/O
 entry as well as the other data values. Defaults to 0 meaning that
 offsets are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
 .TP
+.BI log_prio \fR=\fPbool
+If this is set, the iolog options will include the I/O priority for the I/O
+entry as well as the other data values. Defaults to 0 meaning that
+I/O priorities are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
+.TP
 .BI log_compression \fR=\fPint
 If this is set, fio will compress the I/O logs as it goes, to keep the
 memory footprint lower. When a log reaches the specified size, that chunk is
@@ -4133,8 +4138,14 @@ The entry's `block size' is always in bytes. The `offset' is the position in byt
 from the start of the file for that particular I/O. The logging of the offset can be
 toggled with \fBlog_offset\fR.
 .P
-`Command priority` is 0 for normal priority and 1 for high priority. This is controlled
-by the ioengine specific \fBcmdprio_percentage\fR.
+If \fBlog_prio\fR is not set, the entry's `Command priority` is 1 for an IO executed
+with the highest RT priority class (\fBprioclass\fR=1 or \fBaioprioclass\fR=1) and 0
+otherwise. This is controlled by the \fBprioclass\fR option and the ioengine specific
+\fBcmdprio_percentage\fR \fBaioprioclass\fR options. If \fBlog_prio\fR is set, the
+entry's `Command priority` is the priority set for the IO, as a 16-bits hexadecimal
+number with the lowest 13 bits indicating the priority value (\fBprio\fR and
+\fBaioprio\fR options) and the highest 3 bits indicating the IO priority class
+(\fBprioclass\fR and \fBaioprioclass\fR options).
 .P
 Fio defaults to logging every individual I/O but when windowed logging is set
 through \fBlog_avg_msec\fR, either the average (by default) or the maximum
diff --git a/init.c b/init.c
index 60c7cff4..33320159 100644
--- a/init.c
+++ b/init.c
@@ -1557,6 +1557,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_LAT,
 			.log_offset = o->log_offset,
+			.log_prio = o->log_prio,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
@@ -1590,6 +1591,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_HIST,
 			.log_offset = o->log_offset,
+			.log_prio = o->log_prio,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
@@ -1621,6 +1623,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_BW,
 			.log_offset = o->log_offset,
+			.log_prio = o->log_prio,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
@@ -1652,6 +1655,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_IOPS,
 			.log_offset = o->log_offset,
+			.log_prio = o->log_prio,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
diff --git a/io_u.c b/io_u.c
index b60488a3..897bd1f7 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1595,7 +1595,7 @@ again:
 		assert(io_u->flags & IO_U_F_FREE);
 		io_u_clear(td, io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
 				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
-				 IO_U_F_VER_LIST | IO_U_F_PRIORITY);
+				 IO_U_F_VER_LIST | IO_U_F_HIGH_PRIO);
 
 		io_u->error = 0;
 		io_u->acct_ddir = -1;
@@ -1799,6 +1799,10 @@ struct io_u *get_io_u(struct thread_data *td)
 	io_u->xfer_buf = io_u->buf;
 	io_u->xfer_buflen = io_u->buflen;
 
+	/*
+	 * Remember the issuing context priority. The IO engine may change this.
+	 */
+	io_u->ioprio = td->ioprio;
 out:
 	assert(io_u->file);
 	if (!td_io_prep(td, io_u)) {
@@ -1884,7 +1888,8 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		unsigned long long tnsec;
 
 		tnsec = ntime_since(&io_u->start_time, &icd->time);
-		add_lat_sample(td, idx, tnsec, bytes, io_u->offset, io_u_is_prio(io_u));
+		add_lat_sample(td, idx, tnsec, bytes, io_u->offset,
+			       io_u->ioprio, io_u_is_high_prio(io_u));
 
 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops = &td->prof_io_ops;
@@ -1905,7 +1910,8 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 	if (ddir_rw(idx)) {
 		if (!td->o.disable_clat) {
-			add_clat_sample(td, idx, llnsec, bytes, io_u->offset, io_u_is_prio(io_u));
+			add_clat_sample(td, idx, llnsec, bytes, io_u->offset,
+					io_u->ioprio, io_u_is_high_prio(io_u));
 			io_u_mark_latency(td, llnsec);
 		}
 
@@ -2162,7 +2168,7 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 			td = td->parent;
 
 		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen,
-				io_u->offset, io_u_is_prio(io_u));
+				io_u->offset, io_u->ioprio);
 	}
 }
 
diff --git a/io_u.h b/io_u.h
index d4c5be43..bdbac525 100644
--- a/io_u.h
+++ b/io_u.h
@@ -21,7 +21,7 @@ enum {
 	IO_U_F_TRIMMED		= 1 << 5,
 	IO_U_F_BARRIER		= 1 << 6,
 	IO_U_F_VER_LIST		= 1 << 7,
-	IO_U_F_PRIORITY		= 1 << 8,
+	IO_U_F_HIGH_PRIO	= 1 << 8,
 };
 
 /*
@@ -46,6 +46,11 @@ struct io_u {
 	 */
 	unsigned short numberio;
 
+	/*
+	 * IO priority.
+	 */
+	unsigned short ioprio;
+
 	/*
 	 * Allocated/set buffer and length
 	 */
@@ -188,7 +193,6 @@ static inline enum fio_ddir acct_ddir(struct io_u *io_u)
 	td_flags_clear((td), &(io_u->flags), (val))
 #define io_u_set(td, io_u, val)		\
 	td_flags_set((td), &(io_u)->flags, (val))
-#define io_u_is_prio(io_u)	\
-	(io_u->flags & (unsigned int) IO_U_F_PRIORITY) != 0
+#define io_u_is_high_prio(io_u)	(io_u->flags & IO_U_F_HIGH_PRIO)
 
 #endif
diff --git a/iolog.c b/iolog.c
index cf264916..7a8b6227 100644
--- a/iolog.c
+++ b/iolog.c
@@ -733,6 +733,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 	INIT_FLIST_HEAD(&l->io_logs);
 	l->log_type = p->log_type;
 	l->log_offset = p->log_offset;
+	l->log_prio = p->log_prio;
 	l->log_gz = p->log_gz;
 	l->log_gz_store = p->log_gz_store;
 	l->avg_msec = p->avg_msec;
@@ -765,6 +766,8 @@ void setup_log(struct io_log **log, struct log_params *p,
 
 	if (l->log_offset)
 		l->log_ddir_mask = LOG_OFFSET_SAMPLE_BIT;
+	if (l->log_prio)
+		l->log_ddir_mask |= LOG_PRIO_SAMPLE_BIT;
 
 	INIT_FLIST_HEAD(&l->chunk_list);
 
@@ -891,33 +894,55 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
-	int log_offset;
+	int log_offset, log_prio;
 	uint64_t i, nr_samples;
+	unsigned int prio_val;
+	const char *fmt;
 
 	if (!sample_size)
 		return;
 
 	s = __get_sample(samples, 0, 0);
 	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
+	log_prio = (s->__ddir & LOG_PRIO_SAMPLE_BIT) != 0;
+
+	if (log_offset) {
+		if (log_prio)
+			fmt = "%lu, %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
+		else
+			fmt = "%lu, %" PRId64 ", %u, %llu, %llu, %u\n";
+	} else {
+		if (log_prio)
+			fmt = "%lu, %" PRId64 ", %u, %llu, 0x%04x\n";
+		else
+			fmt = "%lu, %" PRId64 ", %u, %llu, %u\n";
+	}
 
 	nr_samples = sample_size / __log_entry_sz(log_offset);
 
 	for (i = 0; i < nr_samples; i++) {
 		s = __get_sample(samples, log_offset, i);
 
+		if (log_prio)
+			prio_val = s->priority;
+		else
+			prio_val = ioprio_value_is_class_rt(s->priority);
+
 		if (!log_offset) {
-			fprintf(f, "%lu, %" PRId64 ", %u, %llu, %u\n",
-					(unsigned long) s->time,
-					s->data.val,
-					io_sample_ddir(s), (unsigned long long) s->bs, s->priority_bit);
+			fprintf(f, fmt,
+				(unsigned long) s->time,
+				s->data.val,
+				io_sample_ddir(s), (unsigned long long) s->bs,
+				prio_val);
 		} else {
 			struct io_sample_offset *so = (void *) s;
 
-			fprintf(f, "%lu, %" PRId64 ", %u, %llu, %llu, %u\n",
-					(unsigned long) s->time,
-					s->data.val,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					(unsigned long long) so->offset, s->priority_bit);
+			fprintf(f, fmt,
+				(unsigned long) s->time,
+				s->data.val,
+				io_sample_ddir(s), (unsigned long long) s->bs,
+				(unsigned long long) so->offset,
+				prio_val);
 		}
 	}
 }
diff --git a/iolog.h b/iolog.h
index 9e382cc0..7d66b7c4 100644
--- a/iolog.h
+++ b/iolog.h
@@ -42,7 +42,7 @@ struct io_sample {
 	uint64_t time;
 	union io_sample_data data;
 	uint32_t __ddir;
-	uint8_t priority_bit;
+	uint16_t priority;
 	uint64_t bs;
 };
 
@@ -104,6 +104,11 @@ struct io_log {
 	 */
 	unsigned int log_offset;
 
+	/*
+	 * Log I/O priorities
+	 */
+	unsigned int log_prio;
+
 	/*
 	 * Max size of log entries before a chunk is compressed
 	 */
@@ -145,7 +150,13 @@ struct io_log {
  * If the upper bit is set, then we have the offset as well
  */
 #define LOG_OFFSET_SAMPLE_BIT	0x80000000U
-#define io_sample_ddir(io)	((io)->__ddir & ~LOG_OFFSET_SAMPLE_BIT)
+/*
+ * If the bit following the upper bit is set, then we have the priority
+ */
+#define LOG_PRIO_SAMPLE_BIT	0x40000000U
+
+#define LOG_SAMPLE_BITS		(LOG_OFFSET_SAMPLE_BIT | LOG_PRIO_SAMPLE_BIT)
+#define io_sample_ddir(io)	((io)->__ddir & ~LOG_SAMPLE_BITS)
 
 static inline void io_sample_set_ddir(struct io_log *log,
 				      struct io_sample *io,
@@ -262,6 +273,7 @@ struct log_params {
 	int hist_coarseness;
 	int log_type;
 	int log_offset;
+	int log_prio;
 	int log_gz;
 	int log_gz_store;
 	int log_compress;
diff --git a/options.c b/options.c
index 50e48815..4c370945 100644
--- a/options.c
+++ b/options.c
@@ -4292,6 +4292,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "log_prio",
+		.lname	= "Log priority of IO",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, log_prio),
+		.help	= "Include priority value of IO for each log entry",
+		.def	= "0",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
 #ifdef CONFIG_ZLIB
 	{
 		.name	= "log_compression",
diff --git a/os/os-android.h b/os/os-android.h
index 6801b8a8..022e0e92 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -184,6 +184,11 @@ static inline int ioprio_value(int ioprio_class, int ioprio)
 	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
 }
 
+static inline bool ioprio_value_is_class_rt(unsigned int priority)
+{
+	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
+}
+
 static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 {
 	return syscall(__NR_ioprio_set, which, who,
diff --git a/os/os-linux.h b/os/os-linux.h
index 87bed43b..c96f749a 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -131,6 +131,11 @@ static inline int ioprio_value(int ioprio_class, int ioprio)
 	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
 }
 
+static inline bool ioprio_value_is_class_rt(unsigned int priority)
+{
+	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
+}
+
 static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 {
 	return syscall(__NR_ioprio_set, which, who,
diff --git a/os/os.h b/os/os.h
index 7bf7c53c..77f7b1f5 100644
--- a/os/os.h
+++ b/os/os.h
@@ -117,6 +117,9 @@ static inline int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu_index)
 extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
+#ifndef FIO_HAVE_IOPRIO_CLASS
+#define ioprio_value_is_class_rt(prio)	(false)
+#endif
 #ifndef FIO_HAVE_IOPRIO
 #define ioprio_value(prioclass, prio)	(0)
 #define ioprio_set(which, who, prioclass, prio)	(0)
diff --git a/server.h b/server.h
index c128df28..b2f6c517 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 91,
+	FIO_SERVER_VER			= 92,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -193,6 +193,7 @@ struct cmd_iolog_pdu {
 	uint32_t log_type;
 	uint32_t compressed;
 	uint32_t log_offset;
+	uint32_t log_prio;
 	uint32_t log_hist_coarseness;
 	uint8_t name[FIO_NET_NAME_MAX];
 	struct io_sample samples[0];
diff --git a/stat.c b/stat.c
index a8a96c85..99275620 100644
--- a/stat.c
+++ b/stat.c
@@ -2860,7 +2860,8 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 
 static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 			     enum fio_ddir ddir, unsigned long long bs,
-			     unsigned long t, uint64_t offset, uint8_t priority_bit)
+			     unsigned long t, uint64_t offset,
+			     unsigned int priority)
 {
 	struct io_logs *cur_log;
 
@@ -2879,7 +2880,7 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 		s->time = t + (iolog->td ? iolog->td->unix_epoch : 0);
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
-		s->priority_bit = priority_bit;
+		s->priority = priority;
 
 		if (iolog->log_offset) {
 			struct io_sample_offset *so = (void *) s;
@@ -2956,7 +2957,7 @@ void reset_io_stats(struct thread_data *td)
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
-			      unsigned long elapsed, bool log_max, uint8_t priority_bit)
+			      unsigned long elapsed, bool log_max)
 {
 	/*
 	 * Note an entry in the log. Use the mean from the logged samples,
@@ -2971,26 +2972,26 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 		else
 			data.val = iolog->avg_window[ddir].mean.u.f + 0.50;
 
-		__add_log_sample(iolog, data, ddir, 0, elapsed, 0, priority_bit);
+		__add_log_sample(iolog, data, ddir, 0, elapsed, 0, 0);
 	}
 
 	reset_io_stat(&iolog->avg_window[ddir]);
 }
 
 static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
-			     bool log_max, uint8_t priority_bit)
+			     bool log_max)
 {
 	int ddir;
 
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-		__add_stat_to_log(iolog, ddir, elapsed, log_max, priority_bit);
+		__add_stat_to_log(iolog, ddir, elapsed, log_max);
 }
 
 static unsigned long add_log_sample(struct thread_data *td,
 				    struct io_log *iolog,
 				    union io_sample_data data,
 				    enum fio_ddir ddir, unsigned long long bs,
-				    uint64_t offset, uint8_t priority_bit)
+				    uint64_t offset, unsigned int ioprio)
 {
 	unsigned long elapsed, this_window;
 
@@ -3003,7 +3004,8 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * If no time averaging, just add the log sample.
 	 */
 	if (!iolog->avg_msec) {
-		__add_log_sample(iolog, data, ddir, bs, elapsed, offset, priority_bit);
+		__add_log_sample(iolog, data, ddir, bs, elapsed, offset,
+				 ioprio);
 		return 0;
 	}
 
@@ -3027,7 +3029,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 			return diff;
 	}
 
-	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0, priority_bit);
+	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0);
 
 	iolog->avg_last[ddir] = elapsed - (elapsed % iolog->avg_msec);
 
@@ -3041,19 +3043,19 @@ void finalize_logs(struct thread_data *td, bool unit_logs)
 	elapsed = mtime_since_now(&td->epoch);
 
 	if (td->clat_log && unit_logs)
-		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
 	if (td->slat_log && unit_logs)
-		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
 	if (td->lat_log && unit_logs)
-		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
 	if (td->bw_log && (unit_logs == per_unit_log(td->bw_log)))
-		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
 	if (td->iops_log && (unit_logs == per_unit_log(td->iops_log)))
-		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
 }
 
-void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned long long bs,
-					uint8_t priority_bit)
+void add_agg_sample(union io_sample_data data, enum fio_ddir ddir,
+		    unsigned long long bs)
 {
 	struct io_log *iolog;
 
@@ -3061,7 +3063,7 @@ void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned long
 		return;
 
 	iolog = agg_io_log[ddir];
-	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0, priority_bit);
+	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0, 0);
 }
 
 void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
@@ -3083,14 +3085,14 @@ static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
 }
 
 static void add_lat_percentile_sample(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir, uint8_t priority_bit,
-				enum fio_lat lat)
+				unsigned long long nsec, enum fio_ddir ddir,
+				bool high_prio, enum fio_lat lat)
 {
 	unsigned int idx = plat_val_to_idx(nsec);
 
 	add_lat_percentile_sample_noprio(ts, nsec, ddir, lat);
 
-	if (!priority_bit)
+	if (!high_prio)
 		ts->io_u_plat_low_prio[ddir][idx]++;
 	else
 		ts->io_u_plat_high_prio[ddir][idx]++;
@@ -3098,7 +3100,7 @@ static void add_lat_percentile_sample(struct thread_stat *ts,
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long long nsec, unsigned long long bs,
-		     uint64_t offset, uint8_t priority_bit)
+		     uint64_t offset, unsigned int ioprio, bool high_prio)
 {
 	const bool needs_lock = td_async_processing(td);
 	unsigned long elapsed, this_window;
@@ -3111,7 +3113,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
 	if (!ts->lat_percentiles) {
-		if (priority_bit)
+		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
 			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
@@ -3119,13 +3121,13 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->clat_log)
 		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
-			       offset, priority_bit);
+			       offset, ioprio);
 
 	if (ts->clat_percentiles) {
 		if (ts->lat_percentiles)
 			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
 		else
-			add_lat_percentile_sample(ts, nsec, ddir, priority_bit, FIO_CLAT);
+			add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_CLAT);
 	}
 
 	if (iolog && iolog->hist_msec) {
@@ -3154,7 +3156,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 				FIO_IO_U_PLAT_NR * sizeof(uint64_t));
 			flist_add(&dst->list, &hw->list);
 			__add_log_sample(iolog, sample_plat(dst), ddir, bs,
-						elapsed, offset, priority_bit);
+					 elapsed, offset, ioprio);
 
 			/*
 			 * Update the last time we recorded as being now, minus
@@ -3171,8 +3173,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-			unsigned long long nsec, unsigned long long bs, uint64_t offset,
-			uint8_t priority_bit)
+		     unsigned long long nsec, unsigned long long bs,
+		     uint64_t offset, unsigned int ioprio)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -3186,8 +3188,8 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->slat_stat[ddir], nsec);
 
 	if (td->slat_log)
-		add_log_sample(td, td->slat_log, sample_val(nsec), ddir, bs, offset,
-			priority_bit);
+		add_log_sample(td, td->slat_log, sample_val(nsec), ddir, bs,
+			       offset, ioprio);
 
 	if (ts->slat_percentiles)
 		add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_SLAT);
@@ -3198,7 +3200,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		    unsigned long long nsec, unsigned long long bs,
-		    uint64_t offset, uint8_t priority_bit)
+		    uint64_t offset, unsigned int ioprio, bool high_prio)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -3213,11 +3215,11 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->lat_log)
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
-			       offset, priority_bit);
+			       offset, ioprio);
 
 	if (ts->lat_percentiles) {
-		add_lat_percentile_sample(ts, nsec, ddir, priority_bit, FIO_LAT);
-		if (priority_bit)
+		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
+		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
 			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
@@ -3246,7 +3248,7 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 
 	if (td->bw_log)
 		add_log_sample(td, td->bw_log, sample_val(rate), io_u->ddir,
-			       bytes, io_u->offset, io_u_is_prio(io_u));
+			       bytes, io_u->offset, io_u->ioprio);
 
 	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
 
@@ -3300,7 +3302,8 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			next = add_log_sample(td, log, sample_val(rate), ddir, bs, 0, 0);
+			next = add_log_sample(td, log, sample_val(rate), ddir,
+					      bs, 0, 0);
 			next_log = min(next_log, next);
 		}
 
@@ -3340,7 +3343,7 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 
 	if (td->iops_log)
 		add_log_sample(td, td->iops_log, sample_val(1), io_u->ddir,
-			       bytes, io_u->offset, io_u_is_prio(io_u));
+			       bytes, io_u->offset, io_u->ioprio);
 
 	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
 
diff --git a/stat.h b/stat.h
index d08d4dc0..a06237e7 100644
--- a/stat.h
+++ b/stat.h
@@ -341,13 +341,12 @@ extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
 
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t, uint8_t);
+			   unsigned long long, uint64_t, unsigned int, bool);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t, uint8_t);
+			    unsigned long long, uint64_t, unsigned int, bool);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t, uint8_t);
-extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long bs,
-				uint8_t priority_bit);
+				unsigned long long, uint64_t, unsigned int);
+extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long);
 extern void add_iops_sample(struct thread_data *, struct io_u *,
 				unsigned int);
 extern void add_bw_sample(struct thread_data *, struct io_u *,
diff --git a/thread_options.h b/thread_options.h
index 23c4f28c..897a43ea 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -365,6 +365,8 @@ struct thread_options {
 	unsigned int ignore_zone_limits;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
+
+	unsigned int log_prio;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -666,6 +668,8 @@ struct thread_options_pack {
 	uint32_t zone_mode;
 	int32_t max_open_zones;
 	uint32_t ignore_zone_limits;
+
+	uint32_t log_prio;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
-- 
2.31.1


