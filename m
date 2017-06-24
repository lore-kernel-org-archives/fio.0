Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45812 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdFXMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 24 Jun 2017 08:00:13 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dOjjY-0004gb-18
        for fio@vger.kernel.org; Sat, 24 Jun 2017 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170624120001.D19362C0235@kernel.dk>
Date: Sat, 24 Jun 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cf6b7fb4f1883af9cbc443ed2536e7454ed51215:

  t/time-test: cleanups (2017-06-22 19:29:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a2c95580b468a1ddd72ecb5532aca7d94f6efa5b:

  stat: Add iops stat and sample number information to terse format (2017-06-23 16:31:02 -0600)

----------------------------------------------------------------
Andreas Herrmann (4):
      stat: Print one-line iops stat
      stat: Print number of samples in bw and iops stats
      stat: Merge show_thread_status_terse_* functions
      stat: Add iops stat and sample number information to terse format

Tomohiro Kusumi (7):
      Makefile: use fmt(1) rather than tr(1) on NetBSD/etc
      server: don't use void* for pointer arithmetic (gcc)
      io_u: don't use void* for pointer arithmetic (gcc)
      init: don't use void* for pointer arithmetic (gcc)
      client: don't use void* for pointer arithmetic (gcc)
      verify: don't use void* for pointer arithmetic (gcc)
      smalloc: don't use void* for pointer arithmetic (gcc)

 HOWTO            |  19 +++++---
 Makefile         |  10 ++++
 client.c         |  13 +++---
 fio.1            |  26 ++++++++---
 init.c           |   6 +--
 io_u.c           |   2 +-
 server.c         |   6 ++-
 server.h         |   2 +-
 smalloc.c        |   2 +-
 stat.c           | 139 +++++++++++++++++++++++--------------------------------
 t/verify-state.c |   3 +-
 verify-state.h   |   2 +-
 verify.c         |   7 +--
 13 files changed, 126 insertions(+), 111 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 22c5a5b..b2db69d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -127,7 +127,7 @@ Command line options
 
 .. option:: --terse-version=type
 
-	Set terse version output format (default 3, or 2 or 4).
+	Set terse version output format (default 3, or 2 or 4 or 5).
 
 .. option:: --version
 
@@ -3168,11 +3168,12 @@ first value is the version of the terse output format. If the output has to be
 changed for some reason, this number will be incremented by 1 to signify that
 change.
 
-Split up, the format is as follows:
+Split up, the format is as follows (comments in brackets denote when a
+field was introduced or whether its specific to some terse version):
 
     ::
 
-        terse version, fio version, jobname, groupid, error
+	terse version, fio version [v3], jobname, groupid, error
 
     READ status::
 
@@ -3181,7 +3182,8 @@ Split up, the format is as follows:
         Completion latency: min, max, mean, stdev (usec)
         Completion latency percentiles: 20 fields (see below)
         Total latency: min, max, mean, stdev (usec)
-        Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev
+	Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+	IOPS [v5]: min, max, mean, stdev, number of samples
 
     WRITE status:
 
@@ -3192,7 +3194,12 @@ Split up, the format is as follows:
         Completion latency: min, max, mean, stdev (usec)
         Completion latency percentiles: 20 fields (see below)
         Total latency: min, max, mean, stdev (usec)
-        Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev
+	Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+	IOPS [v5]: min, max, mean, stdev, number of samples
+
+    TRIM status [all but version 3]:
+
+	Fields are similar to READ/WRITE status.
 
     CPU usage::
 
@@ -3210,7 +3217,7 @@ Split up, the format is as follows:
 
         <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000, 2000, >=2000
 
-    Disk utilization::
+    Disk utilization [v3]::
 
         Disk name, Read ios, write ios,
         Read merges, write merges,
diff --git a/Makefile b/Makefile
index 64fa97a..bef930f 100644
--- a/Makefile
+++ b/Makefile
@@ -327,8 +327,13 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
 	@mv -f $*.d $*.d.tmp
 	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
+ifeq ($(CONFIG_TARGET_OS), NetBSD)
+	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | tr -cs "[:graph:]" "\n" | \
+		sed -e 's/^ *//' -e '/^$$/ d' -e 's/$$/:/' >> $*.d
+else
 	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 | \
 		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
+endif
 	@rm -f $*.d.tmp
 
 ifdef CONFIG_ARITHMETIC
@@ -366,8 +371,13 @@ init.o: init.c FIO-VERSION-FILE
 	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
 	@mv -f $*.d $*.d.tmp
 	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
+ifeq ($(CONFIG_TARGET_OS), NetBSD)
+	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | tr -cs "[:graph:]" "\n" | \
+		sed -e 's/^ *//' -e '/^$$/ d' -e 's/$$/:/' >> $*.d
+else
 	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 | \
 		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
+endif
 	@rm -f $*.d.tmp
 
 gcompat.o: gcompat.c gcompat.h
diff --git a/client.c b/client.c
index 7a986aa..281d853 100644
--- a/client.c
+++ b/client.c
@@ -885,6 +885,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		convert_io_stat(&dst->slat_stat[i], &src->slat_stat[i]);
 		convert_io_stat(&dst->lat_stat[i], &src->lat_stat[i]);
 		convert_io_stat(&dst->bw_stat[i], &src->bw_stat[i]);
+		convert_io_stat(&dst->iops_stat[i], &src->iops_stat[i]);
 	}
 
 	dst->usr_time		= le64_to_cpu(src->usr_time);
@@ -1452,7 +1453,7 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 	z_stream stream;
 	uint32_t nr_samples;
 	size_t total;
-	void *p;
+	char *p;
 
 	stream.zalloc = Z_NULL;
 	stream.zfree = Z_NULL;
@@ -1478,10 +1479,10 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 
 	memcpy(ret, pdu, sizeof(*pdu));
 
-	p = (void *) ret + sizeof(*pdu);
+	p = (char *) ret + sizeof(*pdu);
 
 	stream.avail_in = cmd->pdu_len - sizeof(*pdu);
-	stream.next_in = (void *) pdu + sizeof(*pdu);
+	stream.next_in = (void *)((char *) pdu + sizeof(*pdu));
 	while (stream.avail_in) {
 		unsigned int this_chunk = 65536;
 		unsigned int this_len;
@@ -1491,7 +1492,7 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 			this_chunk = total;
 
 		stream.avail_out = this_chunk;
-		stream.next_out = p;
+		stream.next_out = (void *)p;
 		err = inflate(&stream, Z_NO_FLUSH);
 		/* may be Z_OK, or Z_STREAM_END */
 		if (err < 0) {
@@ -1566,7 +1567,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 
 		s = __get_sample(samples, ret->log_offset, i);
 		if (ret->log_type == IO_LOG_TYPE_HIST)
-			s = (struct io_sample *)((void *)s + sizeof(struct io_u_plat_entry) * i);
+			s = (struct io_sample *)((char *)s + sizeof(struct io_u_plat_entry) * i);
 
 		s->time		= le64_to_cpu(s->time);
 		s->data.val	= le64_to_cpu(s->data.val);
@@ -1580,7 +1581,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		}
 
 		if (ret->log_type == IO_LOG_TYPE_HIST) {
-			s->data.plat_entry = (struct io_u_plat_entry *)(((void *)s) + sizeof(*s));
+			s->data.plat_entry = (struct io_u_plat_entry *)(((char *)s) + sizeof(*s));
 			s->data.plat_entry->list.next = NULL;
 			s->data.plat_entry->list.prev = NULL;
 		}
diff --git a/fio.1 b/fio.1
index 96eceaf..6a6ea1b 100644
--- a/fio.1
+++ b/fio.1
@@ -43,7 +43,7 @@ Deprecated, use \-\-output-format instead to select multiple formats.
 Display version information and exit.
 .TP
 .BI \-\-terse\-version \fR=\fPversion
-Set terse version output format (default 3, or 2 or 4)
+Set terse version output format (default 3, or 2, 4, 5)
 .TP
 .B \-\-help
 Display usage information and exit.
@@ -2161,10 +2161,11 @@ scripted use.
 A job description (if provided) follows on a new line.  Note that the first
 number in the line is the version number. If the output has to be changed
 for some reason, this number will be incremented by 1 to signify that
-change.  The fields are:
+change. Numbers in brackets (e.g. "[v3]") indicate which terse version
+introduced a field. The fields are:
 .P
 .RS
-.B terse version, fio version, jobname, groupid, error
+.B terse version, fio version [v3], jobname, groupid, error
 .P
 Read status:
 .RS
@@ -2188,7 +2189,11 @@ Total latency:
 .RE
 Bandwidth:
 .RS
-.B min, max, aggregate percentage of total, mean, standard deviation
+.B min, max, aggregate percentage of total, mean, standard deviation, number of samples [v5]
+.RE
+IOPS [v5]:
+.RS
+.B min, max, mean, standard deviation, number of samples
 .RE
 .RE
 .P
@@ -2214,10 +2219,19 @@ Total latency:
 .RE
 Bandwidth:
 .RS
-.B min, max, aggregate percentage of total, mean, standard deviation
+.B min, max, aggregate percentage of total, mean, standard deviation, number of samples [v5]
+.RE
+IOPS [v5]:
+.RS
+.B min, max, mean, standard deviation, number of samples
 .RE
 .RE
 .P
+Trim status [all but version 3]:
+.RS
+Similar to Read/Write status but for trims.
+.RE
+.P
 CPU usage:
 .RS
 .B user, system, context switches, major page faults, minor page faults
@@ -2240,7 +2254,7 @@ Milliseconds:
 .RE
 .RE
 .P
-Disk utilization (1 for each disk used):
+Disk utilization (1 for each disk used) [v3]:
 .RS
 .B name, read ios, write ios, read merges, write merges, read ticks, write ticks, read in-queue time, write in-queue time, disk utilization percentage
 .RE
diff --git a/init.c b/init.c
index 2b7768a..934b9d7 100644
--- a/init.c
+++ b/init.c
@@ -361,7 +361,7 @@ static int setup_thread_area(void)
 #endif
 
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
-	fio_debug_jobp = (void *) threads + max_jobs * sizeof(struct thread_data);
+	fio_debug_jobp = (unsigned int *)(threads + max_jobs);
 	*fio_debug_jobp = -1;
 
 	flow_init();
@@ -1364,6 +1364,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td->ts.slat_stat[i].min_val = ULONG_MAX;
 		td->ts.lat_stat[i].min_val = ULONG_MAX;
 		td->ts.bw_stat[i].min_val = ULONG_MAX;
+		td->ts.iops_stat[i].min_val = ULONG_MAX;
 	}
 	td->ddir_seq_nr = o->ddir_seq_nr;
 
@@ -2403,8 +2404,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			break;
 		case 'V':
 			terse_version = atoi(optarg);
-			if (!(terse_version == 2 || terse_version == 3 ||
-			     terse_version == 4)) {
+			if (!(terse_version >= 2 && terse_version <= 5)) {
 				log_err("fio: bad terse version format\n");
 				exit_val = 1;
 				do_exit++;
diff --git a/io_u.c b/io_u.c
index 375413f..8d42d65 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1602,7 +1602,7 @@ static void small_content_scramble(struct io_u *io_u)
 	unsigned int i, nr_blocks = io_u->buflen / 512;
 	uint64_t boffset;
 	unsigned int offset;
-	void *p, *end;
+	char *p, *end;
 
 	if (!nr_blocks)
 		return;
diff --git a/server.c b/server.c
index 8b36e38..a640fe3 100644
--- a/server.c
+++ b/server.c
@@ -252,9 +252,10 @@ static int fio_send_data(int sk, const void *p, unsigned int len)
 	return fio_sendv_data(sk, &iov, 1);
 }
 
-static int fio_recv_data(int sk, void *p, unsigned int len, bool wait)
+static int fio_recv_data(int sk, void *buf, unsigned int len, bool wait)
 {
 	int flags;
+	char *p = buf;
 
 	if (wait)
 		flags = MSG_WAITALL;
@@ -377,7 +378,7 @@ struct fio_net_cmd *fio_net_recv_cmd(int sk, bool wait)
 			break;
 
 		/* There's payload, get it */
-		pdu = (void *) cmdret->payload + pdu_offset;
+		pdu = (char *) cmdret->payload + pdu_offset;
 		ret = fio_recv_data(sk, pdu, cmd.pdu_len, wait);
 		if (ret)
 			break;
@@ -1474,6 +1475,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		convert_io_stat(&p.ts.slat_stat[i], &ts->slat_stat[i]);
 		convert_io_stat(&p.ts.lat_stat[i], &ts->lat_stat[i]);
 		convert_io_stat(&p.ts.bw_stat[i], &ts->bw_stat[i]);
+		convert_io_stat(&p.ts.iops_stat[i], &ts->iops_stat[i]);
 	}
 
 	p.ts.usr_time		= cpu_to_le64(ts->usr_time);
diff --git a/server.h b/server.h
index 7f235f3..f63a518 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 64,
+	FIO_SERVER_VER			= 65,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/smalloc.c b/smalloc.c
index e48cfe8..cab7132 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -189,7 +189,7 @@ static bool add_pool(struct pool *pool, unsigned int alloc_size)
 		goto out_fail;
 
 	pool->map = ptr;
-	pool->bitmap = (void *) ptr + (pool->nr_blocks * SMALLOC_BPL);
+	pool->bitmap = (unsigned int *)((char *) ptr + (pool->nr_blocks * SMALLOC_BPL));
 	memset(pool->bitmap, 0, bitmap_blocks * sizeof(unsigned int));
 
 	pool->lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
diff --git a/stat.c b/stat.c
index 5042650..b3b2cb3 100644
--- a/stat.c
+++ b/stat.c
@@ -496,8 +496,15 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
 		}
 
-		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
-			bw_str, min, max, p_of_agg, mean, dev);
+		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, "
+			"avg=%5.02f, stdev=%5.02f, samples=%5lu\n",
+			bw_str, min, max, p_of_agg, mean, dev,
+			(&ts->bw_stat[ddir])->samples);
+	}
+	if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
+		log_buf(out, "   iops : min=%5llu, max=%5llu, avg=%5.02f, "
+			"stdev=%5.02f, samples=%5lu\n",
+			min, max, mean, dev, (&ts->iops_stat[ddir])->samples);
 	}
 }
 
@@ -856,13 +863,13 @@ static void show_thread_status_normal(struct thread_stat *ts,
 
 static void show_ddir_status_terse(struct thread_stat *ts,
 				   struct group_run_stats *rs, int ddir,
-				   struct buf_output *out)
+				   int ver, struct buf_output *out)
 {
 	unsigned long long min, max, minv, maxv, bw, iops;
 	unsigned long long *ovals = NULL;
 	double mean, dev;
 	unsigned int len;
-	int i;
+	int i, bw_stat;
 
 	assert(ddir_rw(ddir));
 
@@ -912,7 +919,8 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	if (ovals)
 		free(ovals);
 
-	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
+	bw_stat = calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev);
+	if (bw_stat) {
 		double p_of_agg = 100.0;
 
 		if (rs->agg[ddir]) {
@@ -924,6 +932,19 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 		log_buf(out, ";%llu;%llu;%f%%;%f;%f", min, max, p_of_agg, mean, dev);
 	} else
 		log_buf(out, ";%llu;%llu;%f%%;%f;%f", 0ULL, 0ULL, 0.0, 0.0, 0.0);
+
+	if (ver == 5) {
+		if (bw_stat)
+			log_buf(out, ";%lu", (&ts->bw_stat[ddir])->samples);
+		else
+			log_buf(out, ";%lu", 0UL);
+
+		if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev))
+			log_buf(out, ";%llu;%llu;%f;%f;%lu", min, max,
+				mean, dev, (&ts->iops_stat[ddir])->samples);
+		else
+			log_buf(out, ";%llu;%llu;%f;%f;%lu", 0ULL, 0ULL, 0.0, 0.0, 0UL);
+	}
 }
 
 static void add_ddir_status_json(struct thread_stat *ts,
@@ -1047,74 +1068,24 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_float(dir_object, "bw_agg", p_of_agg);
 	json_object_add_value_float(dir_object, "bw_mean", mean);
 	json_object_add_value_float(dir_object, "bw_dev", dev);
-}
-
-static void show_thread_status_terse_v2(struct thread_stat *ts,
-					struct group_run_stats *rs,
-					struct buf_output *out)
-{
-	double io_u_dist[FIO_IO_U_MAP_NR];
-	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
-	double io_u_lat_m[FIO_IO_U_LAT_M_NR];
-	double usr_cpu, sys_cpu;
-	int i;
-
-	/* General Info */
-	log_buf(out, "2;%s;%d;%d", ts->name, ts->groupid, ts->error);
-	/* Log Read Status */
-	show_ddir_status_terse(ts, rs, DDIR_READ, out);
-	/* Log Write Status */
-	show_ddir_status_terse(ts, rs, DDIR_WRITE, out);
-	/* Log Trim Status */
-	show_ddir_status_terse(ts, rs, DDIR_TRIM, out);
+	json_object_add_value_int(dir_object, "bw_samples",
+				(&ts->bw_stat[ddir])->samples);
 
-	/* CPU Usage */
-	if (ts->total_run_time) {
-		double runt = (double) ts->total_run_time;
-
-		usr_cpu = (double) ts->usr_time * 100 / runt;
-		sys_cpu = (double) ts->sys_time * 100 / runt;
-	} else {
-		usr_cpu = 0;
-		sys_cpu = 0;
+	if (!calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
+		min = max = 0;
+		mean = dev = 0.0;
 	}
-
-	log_buf(out, ";%f%%;%f%%;%llu;%llu;%llu", usr_cpu, sys_cpu,
-						(unsigned long long) ts->ctx,
-						(unsigned long long) ts->majf,
-						(unsigned long long) ts->minf);
-
-	/* Calc % distribution of IO depths, usecond, msecond latency */
-	stat_calc_dist(ts->io_u_map, ddir_rw_sum(ts->total_io_u), io_u_dist);
-	stat_calc_lat_nu(ts, io_u_lat_u);
-	stat_calc_lat_m(ts, io_u_lat_m);
-
-	/* Only show fixed 7 I/O depth levels*/
-	log_buf(out, ";%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%",
-			io_u_dist[0], io_u_dist[1], io_u_dist[2], io_u_dist[3],
-			io_u_dist[4], io_u_dist[5], io_u_dist[6]);
-
-	/* Microsecond latency */
-	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
-		log_buf(out, ";%3.2f%%", io_u_lat_u[i]);
-	/* Millisecond latency */
-	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
-		log_buf(out, ";%3.2f%%", io_u_lat_m[i]);
-	/* Additional output if continue_on_error set - default off*/
-	if (ts->continue_on_error)
-		log_buf(out, ";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
-	log_buf(out, "\n");
-
-	/* Additional output if description is set */
-	if (strlen(ts->description))
-		log_buf(out, ";%s", ts->description);
-
-	log_buf(out, "\n");
+	json_object_add_value_int(dir_object, "iops_min", min);
+	json_object_add_value_int(dir_object, "iops_max", max);
+	json_object_add_value_float(dir_object, "iops_mean", mean);
+	json_object_add_value_float(dir_object, "iops_stddev", dev);
+	json_object_add_value_int(dir_object, "iops_samples",
+				(&ts->iops_stat[ddir])->samples);
 }
 
-static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
-					   struct group_run_stats *rs, int ver,
-					   struct buf_output *out)
+static void show_thread_status_terse_all(struct thread_stat *ts,
+					 struct group_run_stats *rs, int ver,
+					 struct buf_output *out)
 {
 	double io_u_dist[FIO_IO_U_MAP_NR];
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
@@ -1123,15 +1094,19 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 	int i;
 
 	/* General Info */
-	log_buf(out, "%d;%s;%s;%d;%d", ver, fio_version_string,
-					ts->name, ts->groupid, ts->error);
+	if (ver == 2)
+		log_buf(out, "2;%s;%d;%d", ts->name, ts->groupid, ts->error);
+	else
+		log_buf(out, "%d;%s;%s;%d;%d", ver, fio_version_string,
+			ts->name, ts->groupid, ts->error);
+
 	/* Log Read Status */
-	show_ddir_status_terse(ts, rs, DDIR_READ, out);
+	show_ddir_status_terse(ts, rs, DDIR_READ, ver, out);
 	/* Log Write Status */
-	show_ddir_status_terse(ts, rs, DDIR_WRITE, out);
+	show_ddir_status_terse(ts, rs, DDIR_WRITE, ver, out);
 	/* Log Trim Status */
-	if (ver == 4)
-		show_ddir_status_terse(ts, rs, DDIR_TRIM, out);
+	if (ver == 2 || ver == 4 || ver == 5)
+		show_ddir_status_terse(ts, rs, DDIR_TRIM, ver, out);
 
 	/* CPU Usage */
 	if (ts->total_run_time) {
@@ -1167,11 +1142,14 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 		log_buf(out, ";%3.2f%%", io_u_lat_m[i]);
 
 	/* disk util stats, if any */
-	show_disk_util(1, NULL, out);
+	if (ver >= 3)
+		show_disk_util(1, NULL, out);
 
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
 		log_buf(out, ";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
+	if (ver == 2)
+		log_buf(out, "\n");
 
 	/* Additional output if description is set */
 	if (strlen(ts->description))
@@ -1412,10 +1390,8 @@ static void show_thread_status_terse(struct thread_stat *ts,
 				     struct group_run_stats *rs,
 				     struct buf_output *out)
 {
-	if (terse_version == 2)
-		show_thread_status_terse_v2(ts, rs, out);
-	else if (terse_version == 3 || terse_version == 4)
-		show_thread_status_terse_v3_v4(ts, rs, terse_version, out);
+	if (terse_version >= 2 && terse_version <= 5)
+		show_thread_status_terse_all(ts, rs, terse_version, out);
 	else
 		log_err("fio: bad terse version!? %d\n", terse_version);
 }
@@ -1507,6 +1483,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first);
 			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first);
 			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first);
+			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], first);
 
 			dst->io_bytes[l] += src->io_bytes[l];
 
@@ -1517,6 +1494,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first);
 			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first);
 			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first);
+			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], first);
 
 			dst->io_bytes[0] += src->io_bytes[l];
 
@@ -1598,6 +1576,7 @@ void init_thread_stat(struct thread_stat *ts)
 		ts->clat_stat[j].min_val = -1UL;
 		ts->slat_stat[j].min_val = -1UL;
 		ts->bw_stat[j].min_val = -1UL;
+		ts->iops_stat[j].min_val = -1UL;
 	}
 	ts->groupid = -1;
 }
diff --git a/t/verify-state.c b/t/verify-state.c
index 9a2c3df..78a56da 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -58,7 +58,8 @@ static void show(struct thread_io_list *s, size_t size)
 		show_s(s, no_s);
 		no_s++;
 		size -= __thread_io_list_sz(s->depth, s->nofiles);
-		s = (void *) s + __thread_io_list_sz(s->depth, s->nofiles);
+		s = (struct thread_io_list *)((char *) s +
+			__thread_io_list_sz(s->depth, s->nofiles));
 	} while (size != 0);
 }
 
diff --git a/verify-state.h b/verify-state.h
index e46265e..1586f63 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -77,7 +77,7 @@ static inline size_t thread_io_list_sz(struct thread_io_list *s)
 
 static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
 {
-	return (void *) s + thread_io_list_sz(s);
+	return (struct thread_io_list *)((char *) s + thread_io_list_sz(s));
 }
 
 static inline void verify_state_gen_name(char *out, size_t size,
diff --git a/verify.c b/verify.c
index ffd8707..1f177d7 100644
--- a/verify.c
+++ b/verify.c
@@ -388,7 +388,7 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 	(void)paste_format_inplace(pattern, pattern_size,
 				   td->o.verify_fmt, td->o.verify_fmt_sz, io_u);
 
-	buf = (void *) hdr + header_size;
+	buf = (char *) hdr + header_size;
 	len = get_hdr_inc(td, io_u) - header_size;
 	mod = (get_hdr_inc(td, io_u) * vc->hdr_num + header_size) % pattern_size;
 
@@ -1188,9 +1188,10 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 unsigned int header_len)
 {
 	unsigned int data_len;
-	void *data, *p;
+	void *data;
+	char *p;
 
-	p = (void *) hdr;
+	p = (char *) hdr;
 
 	fill_hdr(td, io_u, hdr, header_num, header_len, io_u->rand_seed);
 
