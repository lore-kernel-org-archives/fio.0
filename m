Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41110 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbaISMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Sep 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XUwr7-0001zj-C8
	for fio@vger.kernel.org; Fri, 19 Sep 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140919120003.06D40401E4@lyth.info>
Date: Fri, 19 Sep 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cea475cd767b7e3d5c4fb2383247cbc78877cf56:

  btrace2fio: add rate output (2014-09-17 17:58:31 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8fc46b4d03bc61c4e72b69c3bc59bd50c4943e03:

  btrace2fio: expand rate options, bug fixes (2014-09-18 17:23:55 +0200)

----------------------------------------------------------------
Jens Axboe (1):
      btrace2fio: expand rate options, bug fixes

 t/btrace2fio.c |  209 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 159 insertions(+), 50 deletions(-)

---

Diff of recent changes:

diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index 4dff3ec..e4e05ca 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -17,6 +17,8 @@
 
 static unsigned int rt_threshold = 1000000;
 static unsigned int ios_threshold = 10;
+static unsigned int rate_threshold;
+static unsigned int set_rate;
 static int output_ascii = 1;
 static char *filename;
 
@@ -33,7 +35,6 @@ struct trace_file {
 
 struct btrace_out {
 	unsigned long ios[DDIR_RWDIR_CNT];
-	unsigned long rw_bs[DDIR_RWDIR_CNT];
 	unsigned long merges[DDIR_RWDIR_CNT];
 
 	uint64_t last_end[DDIR_RWDIR_CNT];
@@ -44,9 +45,9 @@ struct btrace_out {
 
 	int inflight;
 	unsigned int depth;
-	uint64_t first_ttime;
-	uint64_t last_ttime;
-	uint64_t kb;
+	uint64_t first_ttime[DDIR_RWDIR_CNT];
+	uint64_t last_ttime[DDIR_RWDIR_CNT];
+	uint64_t kb[DDIR_RWDIR_CNT];
 
 	uint64_t start_delay;
 };
@@ -191,7 +192,7 @@ static int discard_pdu(struct fifo *fifo, int fd, struct blk_io_trace *t)
 	return trace_fifo_get(fifo, fd, NULL, t->pdu_len);
 }
 
-static void handle_trace_notify(struct blk_io_trace *t)
+static int handle_trace_notify(struct blk_io_trace *t)
 {
 	switch (t->action) {
 	case BLK_TN_PROCESS:
@@ -204,8 +205,10 @@ static void handle_trace_notify(struct blk_io_trace *t)
 		break;
 	default:
 		log_err("unknown trace act %x\n", t->action);
-		break;
+		return 1;
 	}
+
+	return 0;
 }
 
 static void __add_bs(struct btrace_out *o, unsigned int len, int rw)
@@ -241,7 +244,7 @@ static void add_bs(struct btrace_out *o, unsigned int len, int rw)
 #define FMAJOR(dev)	((unsigned int) ((dev) >> FMINORBITS))
 #define FMINOR(dev)	((unsigned int) ((dev) & FMINORMASK))
 
-static void btrace_add_file(struct btrace_pid *p, uint32_t devno)
+static int btrace_add_file(struct btrace_pid *p, uint32_t devno)
 {
 	unsigned int maj = FMAJOR(devno);
 	unsigned int min = FMINOR(devno);
@@ -250,9 +253,9 @@ static void btrace_add_file(struct btrace_pid *p, uint32_t devno)
 	char dev[256];
 
 	if (filename)
-		return;
+		return 0;
 	if (p->last_major == maj && p->last_minor == min)
-		return;
+		return 0;
 
 	p->last_major = maj;
 	p->last_minor = min;
@@ -264,13 +267,17 @@ static void btrace_add_file(struct btrace_pid *p, uint32_t devno)
 		f = &p->files[i];
 
 		if (f->major == maj && f->minor == min)
-			return;
+			return 0;
 	}
 
 	strcpy(dev, "/dev");
 	if (!blktrace_lookup_device(NULL, dev, maj, min)) {
 		log_err("fio: failed to find device %u/%u\n", maj, min);
-		return;
+		if (!output_ascii) {
+			log_err("fio: use -d to specify device\n");
+			return 1;
+		}
+		return 0;
 	}
 
 	p->files = realloc(p->files, (p->nr_files + 1) * sizeof(*f));
@@ -279,35 +286,47 @@ static void btrace_add_file(struct btrace_pid *p, uint32_t devno)
 	f->major = maj;
 	f->minor = min;
 	p->nr_files++;
+	return 0;
+}
+
+static int t_to_rwdir(struct blk_io_trace *t)
+{
+	if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
+		return DDIR_TRIM;
+
+	return (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
 }
 
-static void handle_trace_discard(struct blk_io_trace *t, struct btrace_pid *p)
+static int handle_trace_discard(struct blk_io_trace *t, struct btrace_pid *p)
 {
 	struct btrace_out *o = &p->o;
 
-	btrace_add_file(p, t->device);
+	if (btrace_add_file(p, t->device))
+		return 1;
 
-	if (o->first_ttime == -1ULL)
-		o->first_ttime = t->time;
+	if (o->first_ttime[2] == -1ULL)
+		o->first_ttime[2] = t->time;
 
 	o->ios[DDIR_TRIM]++;
 	add_bs(o, t->bytes, DDIR_TRIM);
+	return 0;
 }
 
-static void handle_trace_fs(struct blk_io_trace *t, struct btrace_pid *p)
+static int handle_trace_fs(struct blk_io_trace *t, struct btrace_pid *p)
 {
 	struct btrace_out *o = &p->o;
 	int rw;
 
-	btrace_add_file(p, t->device);
+	if (btrace_add_file(p, t->device))
+		return 1;
 
 	first_ttime = min(first_ttime, (uint64_t) t->time);
 
-	if (o->first_ttime == -1ULL)
-		o->first_ttime = t->time;
-
 	rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
 
+	if (o->first_ttime[rw] == -1ULL)
+		o->first_ttime[rw] = t->time;
+
 	add_bs(o, t->bytes, rw);
 	o->ios[rw]++;
 
@@ -315,25 +334,27 @@ static void handle_trace_fs(struct blk_io_trace *t, struct btrace_pid *p)
 		o->seq[rw]++;
 
 	o->last_end[rw] = t->sector + (t->bytes >> 9);
+	return 0;
 }
 
-static void handle_queue_trace(struct blk_io_trace *t, struct btrace_pid *p)
+static int handle_queue_trace(struct blk_io_trace *t, struct btrace_pid *p)
 {
 	if (t->action & BLK_TC_ACT(BLK_TC_NOTIFY))
-		handle_trace_notify(t);
+		return handle_trace_notify(t);
 	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
-		handle_trace_discard(t, p);
+		return handle_trace_discard(t, p);
 	else
-		handle_trace_fs(t, p);
+		return handle_trace_fs(t, p);
 }
 
-static void handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
+static int handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
 {
 	unsigned int act = t->action & 0xffff;
+	int ret = 0;
 
 	if (act == __BLK_TA_QUEUE) {
 		inflight_add(p, t->sector, t->bytes);
-		handle_queue_trace(t, p);
+		ret = handle_queue_trace(t, p);
 	} else if (act == __BLK_TA_REQUEUE) {
 		p->o.inflight--;
 	} else if (act == __BLK_TA_BACKMERGE) {
@@ -344,11 +365,8 @@ static void handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
 			inflight_remove(i);
 
 		i = inflight_find(t->sector);
-		if (i) {
-			int rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
-
-			inflight_merge(i, rw, t->bytes);
-		}
+		if (i)
+			inflight_merge(i, t_to_rwdir(t), t->bytes);
 	} else if (act == __BLK_TA_FRONTMERGE) {
 		struct inflight *i;
 
@@ -357,20 +375,19 @@ static void handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
 			inflight_remove(i);
 
 		i = inflight_find(t->sector);
-		if (i) {
-			int rw = (t->action & BLK_TC_ACT(BLK_TC_WRITE)) != 0;
-
-			inflight_merge(i, rw, 0);
-		}
+		if (i)
+			inflight_merge(i, t_to_rwdir(t), 0);
 	} else if (act == __BLK_TA_COMPLETE) {
 		struct inflight *i;
 
 		i = inflight_find(t->sector + (t->bytes >> 9));
 		if (i) {
-			i->p->o.kb += (t->bytes >> 10);
+			i->p->o.kb[t_to_rwdir(t)] += (t->bytes >> 10);
 			inflight_remove(i);
 		}
 	}
+
+	return ret;
 }
 
 static void byteswap_trace(struct blk_io_trace *t)
@@ -414,11 +431,12 @@ static struct btrace_pid *pid_hash_get(pid_t pid)
 		int i;
 
 		p = calloc(1, sizeof(*p));
-		p->o.first_ttime = -1ULL;
-		p->o.last_ttime = -1ULL;
 
-		for (i = 0; i < DDIR_RWDIR_CNT; i++)
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			p->o.first_ttime[i] = -1ULL;
+			p->o.last_ttime[i] = -1ULL;
 			p->o.last_end[i] = -1ULL;
+		}
 
 		p->pid = pid;
 		flist_add_tail(&p->hash_list, hash_list);
@@ -438,7 +456,7 @@ static int load_blktrace(const char *filename, int need_swap)
 	unsigned long traces;
 	struct blk_io_trace t;
 	struct fifo *fifo;
-	int fd;
+	int fd, ret = 0;
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
@@ -482,14 +500,19 @@ static int load_blktrace(const char *filename, int need_swap)
 		}
 
 		p = pid_hash_get(t.pid);
-		handle_trace(&t, p);
-		p->o.last_ttime = t.time;
+		ret = handle_trace(&t, p);
+		if (ret)
+			break;
+		p->o.last_ttime[t_to_rwdir(&t)] = t.time;
 		traces++;
 	} while (1);
 
 	fifo_free(fifo);
 	close(fd);
 
+	if (ret)
+		return ret;
+
 	if (output_ascii)
 		printf("Traces loaded: %lu\n", traces);
 
@@ -508,6 +531,41 @@ static int bs_cmp(const void *ba, const void *bb)
 	return bsb->nr - bsa->nr;
 }
 
+static unsigned long o_to_kb_rate(struct btrace_out *o, int rw)
+{
+	uint64_t usec = (o->last_ttime[rw] - o->first_ttime[rw]) / 1000ULL;
+	uint64_t val;
+
+	if (!usec)
+		return 0;
+
+	val = o->kb[rw] * 1000ULL;
+	return val / (usec / 1000ULL);
+}
+
+static uint64_t o_first_ttime(struct btrace_out *o)
+{
+	uint64_t first;
+
+	first = min(o->first_ttime[0], o->first_ttime[1]);
+	return min(first, o->first_ttime[2]);
+}
+
+static uint64_t o_longest_ttime(struct btrace_out *o)
+{
+	uint64_t ret = 0;
+	int i;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		uint64_t diff;
+
+		diff = o->last_ttime[i] - o->first_ttime[i];
+		ret = max(diff, ret);
+	}
+
+	return ret;
+}
+
 static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 {
 	const char *msg[] = { "reads", "writes", "trims" };
@@ -532,6 +590,7 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 		printf("\tmerges: %lu (perc=%3.2f%%)\n", o->merges[i], perc);
 		perc = ((float) o->seq[i] * 100.0) / (float) o->ios[i];
 		printf("\tseq:    %lu (perc=%3.2f%%)\n", o->seq[i], perc);
+		printf("\trate:   %lu KB/sec\n", o_to_kb_rate(o, i));
 
 		for (j = 0; j < o->nr_bs[i]; j++) {
 			struct bs *bs = &o->bs[i][j];
@@ -542,9 +601,8 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 	}
 
 	printf("depth:\t%u\n", o->depth);
-	usec = (o->last_ttime - o->first_ttime) / 1000ULL;
+	usec = o_longest_ttime(o) / 1000ULL;
 	printf("usec:\t%lu (delay=%llu)\n", usec, (unsigned long long) o->start_delay);
-	printf("rate:\t%.2fKB/sec\n", ((float) o->kb * 1000.0) / ((float) usec / 1000.0));
 
 	printf("files:\t");
 	for (i = 0; i < p->nr_files; i++)
@@ -566,6 +624,10 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 		log_err("fio: trace has both read/write and trim\n");
 		return 1;
 	}
+	if (!p->nr_files) {
+		log_err("fio: no devices found\n");
+		return 1;
+	}
 
 	printf("[pid%u]\n", p->pid);
 	printf("direct=1\n");
@@ -613,7 +675,7 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 
 	printf("startdelay=%llus\n", o->start_delay / 1000000ULL);
 
-	time = o->last_ttime - o->first_ttime;
+	time = o_longest_ttime(o);
 	time = (time + 1000000000ULL - 1) / 1000000000ULL;
 	printf("runtime=%llus\n", time);
 
@@ -637,8 +699,23 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 				printf("%u/%u", bs->bs, (int) perc);
 		}
 	}
-	printf("\n\n");
+	printf("\n");
 
+	if (set_rate) {
+		printf("rate=");
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			unsigned long rate;
+
+			rate = o_to_kb_rate(o, i);
+			if (i)
+				printf(",");
+			if (rate)
+				printf("%luk", rate);
+		}
+		printf("\n");
+	}
+
+	printf("\n");
 	return 0;
 }
 
@@ -667,17 +744,39 @@ static int __output_p(struct btrace_pid *p, unsigned long *ios)
 	return ret;
 }
 
+static void remove_ddir(struct btrace_out *o, int rw)
+{
+	o->ios[rw] = 0;
+}
+
 static int prune_entry(struct btrace_out *o)
 {
+	unsigned long rate;
 	uint64_t time;
+	int i;
 
 	if (ddir_rw_sum(o->ios) < ios_threshold)
 		return 1;
 
-	time = (o->last_ttime - o->first_ttime) / 1000ULL;
+	time = o_longest_ttime(o) / 1000ULL;
 	if (time < rt_threshold)
 		return 1;
 
+	rate = 0;
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		unsigned long this_rate;
+
+		this_rate = o_to_kb_rate(o, i);
+		if (this_rate < rate_threshold) {
+			remove_ddir(o, i);
+			this_rate = 0;
+		}
+		rate += this_rate;
+	}
+
+	if (rate < rate_threshold)
+		return 1;
+
 	return 0;
 }
 
@@ -722,7 +821,7 @@ static int output_p(void)
 			free_p(p);
 			continue;
 		}
-		p->o.start_delay = (p->o.first_ttime / 1000ULL) - first_ttime;
+		p->o.start_delay = (o_first_ttime(&p->o) / 1000ULL) - first_ttime;
 	}
 
 	memset(ios, 0, sizeof(ios));
@@ -734,6 +833,8 @@ static int output_p(void)
 
 		p = flist_entry(e, struct btrace_pid, pid_list);
 		ret |= __output_p(p, ios);
+		if (ret && !output_ascii)
+			break;
 	}
 
 	if (output_ascii)
@@ -749,6 +850,8 @@ static int usage(char *argv[])
 	log_err("\t-n\tNumber IOS threshold to ignore task\n");
 	log_err("\t-f\tFio job file output\n");
 	log_err("\t-d\tUse this file/device for replay\n");
+	log_err("\t-r\tIgnore jobs with less than this KB/sec rate\n");
+	log_err("\t-R\tSet rate in fio job\n");
 	return 1;
 }
 
@@ -802,8 +905,14 @@ int main(int argc, char *argv[])
 	if (argc < 2)
 		return usage(argv);
 
-	while ((c = getopt(argc, argv, "t:n:fd:")) != -1) {
+	while ((c = getopt(argc, argv, "t:n:fd:r:R")) != -1) {
 		switch (c) {
+		case 'R':
+			set_rate = 1;
+			break;
+		case 'r':
+			rate_threshold = atoi(optarg);
+			break;
 		case 't':
 			rt_threshold = atoi(optarg);
 			break;
