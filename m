Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4F0C433EF
	for <fio@archiver.kernel.org>; Sat, 20 Nov 2021 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhKTNDM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 20 Nov 2021 08:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbhKTNDL (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 20 Nov 2021 08:03:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557CFC061574
        for <fio@vger.kernel.org>; Sat, 20 Nov 2021 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qwr90Bw/PLWLgjEf3OC/IvIuLdi/KFDfr60RB3w+878=; b=i+N6MePp0p79QGJkwp4trtGFTo
        bdWv2ftFgJ4owwWykY3VJ5Z5gYTnLfnU/fXb8Ol5Jq/NeAx2OAP4wgQVwsYJatj/cBBQdJJau23oF
        MuuL/XohTqOr1jHo+CK+bnBs6bJc/021BmCzqyWUdl0u9nKKslUkgyCrLS3Fv1FEIP1hSywxLAxGm
        lThe6sqwqh4gMl2rcy8MsghPJmj8pkO4ZHlW2jlhSyvr3XdI6rPbkc6wzWbNQowccIccKdA7bH1zq
        K1I+goTgzyX0GzY5MhvEPoVet2FyZFcoUVKttqEwEVjmlHhJGWD9P6CI1MV+EDk03JA7cSF52YdIh
        T2yJLScQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1moPyP-00AcV7-Kd
        for fio@vger.kernel.org; Sat, 20 Nov 2021 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id A069D1BC0174; Sat, 20 Nov 2021 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211120130001.A069D1BC0174@kernel.dk>
Date:   Sat, 20 Nov 2021 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5711325cbb37d10c21a6975d1f1ebea11799c05e:

  Makefile: Fix android compilation (2021-11-17 16:14:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to beda9d8d9e9148ff34eaa0eeb0cde19a36f47494:

  t/io_uring: add -R option for random/sequential IO (2021-11-19 10:44:15 -0700)

----------------------------------------------------------------
Damien Le Moal (1):
      fio: Introduce the log_entries option

Jens Axboe (2):
      t/io_uring: use internal random generator
      t/io_uring: add -R option for random/sequential IO

 HOWTO            | 12 ++++++++++++
 Makefile         |  3 +--
 cconv.c          |  2 ++
 fio.1            | 11 +++++++++++
 lib/rand.c       |  2 +-
 lib/rand.h       |  1 +
 options.c        | 12 ++++++++++++
 server.h         |  2 +-
 stat.c           | 12 +++++-------
 t/io_uring.c     | 34 +++++++++++++++++++++++++++-------
 thread_options.h |  2 ++
 11 files changed, 75 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 196bca6c..a3b3acfe 100644
--- a/HOWTO
+++ b/HOWTO
@@ -3537,6 +3537,18 @@ Measurements and reporting
 	:option:`write_bw_log` for details about the filename format and `Log
 	File Formats`_ for how data is structured within the file.
 
+.. option:: log_entries=int
+
+	By default, fio will log an entry in the iops, latency, or bw log for
+	every I/O that completes. The initial number of I/O log entries is 1024.
+	When the log entries are all used, new log entries are dynamically
+	allocated.  This dynamic log entry allocation may negatively impact
+	time-related statistics such as I/O tail latencies (e.g. 99.9th percentile
+	completion latency). This option allows specifying a larger initial
+	number of log entries to avoid run-time allocations of new log entries,
+	resulting in more precise time-related I/O statistics.
+	Also see :option:`log_avg_msec`. Defaults to 1024.
+
 .. option:: log_avg_msec=int
 
 	By default, fio will log an entry in the iops, latency, or bw log for every
diff --git a/Makefile b/Makefile
index 04c1e0a7..5d17bcab 100644
--- a/Makefile
+++ b/Makefile
@@ -375,8 +375,7 @@ T_VS_PROGS = t/fio-verify-state
 T_PIPE_ASYNC_OBJS = t/read-to-pipe-async.o
 T_PIPE_ASYNC_PROGS = t/read-to-pipe-async
 
-T_IOU_RING_OBJS = t/io_uring.o
-T_IOU_RING_OBJS += t/arch.o
+T_IOU_RING_OBJS = t/io_uring.o lib/rand.o lib/pattern.o lib/strntol.o
 T_IOU_RING_PROGS = t/io_uring
 
 T_MEMLOCK_OBJS = t/memlock.o
diff --git a/cconv.c b/cconv.c
index 2104308c..4f8d27eb 100644
--- a/cconv.c
+++ b/cconv.c
@@ -187,6 +187,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->rand_repeatable = le32_to_cpu(top->rand_repeatable);
 	o->allrand_repeatable = le32_to_cpu(top->allrand_repeatable);
 	o->rand_seed = le64_to_cpu(top->rand_seed);
+	o->log_entries = le32_to_cpu(top->log_entries);
 	o->log_avg_msec = le32_to_cpu(top->log_avg_msec);
 	o->log_hist_msec = le32_to_cpu(top->log_hist_msec);
 	o->log_hist_coarseness = le32_to_cpu(top->log_hist_coarseness);
@@ -416,6 +417,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->rand_repeatable = cpu_to_le32(o->rand_repeatable);
 	top->allrand_repeatable = cpu_to_le32(o->allrand_repeatable);
 	top->rand_seed = __cpu_to_le64(o->rand_seed);
+	top->log_entries = cpu_to_le32(o->log_entries);
 	top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
 	top->log_max = cpu_to_le32(o->log_max);
 	top->log_offset = cpu_to_le32(o->log_offset);
diff --git a/fio.1 b/fio.1
index e3c3feae..a6469541 100644
--- a/fio.1
+++ b/fio.1
@@ -3243,6 +3243,17 @@ logging (see \fBlog_avg_msec\fR) has been enabled. See
 \fBwrite_bw_log\fR for details about the filename format and \fBLOG
 FILE FORMATS\fR for how data is structured within the file.
 .TP
+.BI log_entries \fR=\fPint
+By default, fio will log an entry in the iops, latency, or bw log for
+every I/O that completes. The initial number of I/O log entries is 1024.
+When the log entries are all used, new log entries are dynamically
+allocated.  This dynamic log entry allocation may negatively impact
+time-related statistics such as I/O tail latencies (e.g. 99.9th percentile
+completion latency). This option allows specifying a larger initial
+number of log entries to avoid run-time allocation of new log entries,
+resulting in more precise time-related I/O statistics.
+Also see \fBlog_avg_msec\fR as well. Defaults to 1024.
+.TP
 .BI log_avg_msec \fR=\fPint
 By default, fio will log an entry in the iops, latency, or bw log for every
 I/O that completes. When writing to the disk log, that can quickly grow to a
diff --git a/lib/rand.c b/lib/rand.c
index e74da609..6e893e80 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -59,7 +59,7 @@ static void __init_rand32(struct taus88_state *state, unsigned int seed)
 		__rand32(state);
 }
 
-static void __init_rand64(struct taus258_state *state, uint64_t seed)
+void __init_rand64(struct taus258_state *state, uint64_t seed)
 {
 	int cranks = 6;
 
diff --git a/lib/rand.h b/lib/rand.h
index a8060045..2b4be788 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -162,6 +162,7 @@ static inline uint64_t __get_next_seed(struct frand_state *fs)
 
 extern void init_rand(struct frand_state *, bool);
 extern void init_rand_seed(struct frand_state *, uint64_t seed, bool);
+void __init_rand64(struct taus258_state *state, uint64_t seed);
 extern void __fill_random_buf(void *buf, unsigned int len, uint64_t seed);
 extern uint64_t fill_random_buf(struct frand_state *, void *buf, unsigned int len);
 extern void __fill_random_buf_percentage(uint64_t, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
diff --git a/options.c b/options.c
index 460cf4ff..102bcf56 100644
--- a/options.c
+++ b/options.c
@@ -4244,6 +4244,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "log_entries",
+		.lname	= "Log entries",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, log_entries),
+		.help	= "Initial number of entries in a job IO log",
+		.def	= __fio_stringify(DEF_LOG_ENTRIES),
+		.minval	= DEF_LOG_ENTRIES,
+		.maxval	= MAX_LOG_ENTRIES,
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "log_avg_msec",
 		.lname	= "Log averaging (msec)",
diff --git a/server.h b/server.h
index 44b8da12..25b6bbdc 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 94,
+	FIO_SERVER_VER			= 95,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index cd35b114..e0dc99b6 100644
--- a/stat.c
+++ b/stat.c
@@ -2688,27 +2688,25 @@ static inline void add_stat_sample(struct io_stat *is, unsigned long long data)
  */
 static struct io_logs *get_new_log(struct io_log *iolog)
 {
-	size_t new_size, new_samples;
+	size_t new_samples;
 	struct io_logs *cur_log;
 
 	/*
 	 * Cap the size at MAX_LOG_ENTRIES, so we don't keep doubling
 	 * forever
 	 */
-	if (!iolog->cur_log_max)
-		new_samples = DEF_LOG_ENTRIES;
-	else {
+	if (!iolog->cur_log_max) {
+		new_samples = iolog->td->o.log_entries;
+	} else {
 		new_samples = iolog->cur_log_max * 2;
 		if (new_samples > MAX_LOG_ENTRIES)
 			new_samples = MAX_LOG_ENTRIES;
 	}
 
-	new_size = new_samples * log_entry_sz(iolog);
-
 	cur_log = smalloc(sizeof(*cur_log));
 	if (cur_log) {
 		INIT_FLIST_HEAD(&cur_log->list);
-		cur_log->log = malloc(new_size);
+		cur_log->log = calloc(new_samples, log_entry_sz(iolog));
 		if (cur_log->log) {
 			cur_log->nr_samples = 0;
 			cur_log->max_samples = new_samples;
diff --git a/t/io_uring.c b/t/io_uring.c
index f758a6d9..b79822d7 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -28,6 +28,7 @@
 #include "../arch/arch.h"
 #include "../lib/types.h"
 #include "../lib/roundup.h"
+#include "../lib/rand.h"
 #include "../minmax.h"
 #include "../os/linux/io_uring.h"
 
@@ -59,6 +60,8 @@ static unsigned sq_ring_mask, cq_ring_mask;
 
 struct file {
 	unsigned long max_blocks;
+	unsigned long max_size;
+	unsigned long cur_off;
 	unsigned pending_ios;
 	int real_fd;
 	int fixed_fd;
@@ -86,6 +89,8 @@ struct submitter {
 
 	__s32 *fds;
 
+	struct taus258_state rand_state;
+
 	unsigned long *clock_batch;
 	int clock_index;
 	unsigned long *plat;
@@ -120,7 +125,8 @@ static int do_nop = 0;		/* no-op SQ ring commands */
 static int nthreads = 1;
 static int stats = 0;		/* generate IO stats */
 static int aio = 0;		/* use libaio */
-static int runtime = 0;	/* runtime */
+static int runtime = 0;		/* runtime */
+static int random_io = 1;	/* random or sequential IO */
 
 static unsigned long tsc_rate;
 
@@ -448,8 +454,15 @@ static void init_io(struct submitter *s, unsigned index)
 	}
 	f->pending_ios++;
 
-	r = lrand48();
-	offset = (r % (f->max_blocks - 1)) * bs;
+	if (random_io) {
+		r = __rand64(&s->rand_state);
+		offset = (r % (f->max_blocks - 1)) * bs;
+	} else {
+		offset = f->cur_off;
+		f->cur_off += bs;
+		if (f->cur_off + bs > f->max_size)
+			f->cur_off = 0;
+	}
 
 	if (register_files) {
 		sqe->flags = IOSQE_FIXED_FILE;
@@ -517,9 +530,11 @@ static int get_file_size(struct file *f)
 			return -1;
 
 		f->max_blocks = bytes / bs;
+		f->max_size = bytes;
 		return 0;
 	} else if (S_ISREG(st.st_mode)) {
 		f->max_blocks = st.st_size / bs;
+		f->max_size = st.st_size;
 		return 0;
 	}
 
@@ -586,6 +601,7 @@ static int submitter_init(struct submitter *s)
 	s->tid = gettid();
 	printf("submitter=%d, tid=%d\n", s->index, s->tid);
 
+	__init_rand64(&s->rand_state, pthread_self());
 	srand48(pthread_self());
 
 	for (i = 0; i < MAX_FDS; i++)
@@ -1066,11 +1082,12 @@ static void usage(char *argv, int status)
 		" -N <bool> : Perform just no-op requests, default %d\n"
 		" -t <bool> : Track IO latencies, default %d\n"
 		" -T <int>  : TSC rate in HZ\n"
-		" -a <bool> : Use legacy aio, default %d\n"
-		" -r <int>  : Runtime in seconds, default %s\n",
+		" -r <int>  : Runtime in seconds, default %s\n"
+		" -R <bool> : Use random IO, default %d\n"
+		" -a <bool> : Use legacy aio, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
-		stats, aio, runtime == 0 ? "unlimited" : runtime_str);
+		stats, runtime == 0 ? "unlimited" : runtime_str, aio, random_io);
 	exit(status);
 }
 
@@ -1130,7 +1147,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1194,6 +1211,9 @@ int main(int argc, char *argv[])
 		case 'D':
 			dma_map = !!atoi(optarg);
 			break;
+		case 'R':
+			random_io = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
diff --git a/thread_options.h b/thread_options.h
index 6e1a2cdd..8f4c8a59 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -377,6 +377,7 @@ struct thread_options {
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 
+	unsigned int log_entries;
 	unsigned int log_prio;
 };
 
@@ -683,6 +684,7 @@ struct thread_options_pack {
 	int32_t max_open_zones;
 	uint32_t ignore_zone_limits;
 
+	uint32_t log_entries;
 	uint32_t log_prio;
 } __attribute__((packed));
 
