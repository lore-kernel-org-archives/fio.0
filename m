Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:60066 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754276AbcLVGHa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 01:07:30 -0500
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id A599660395
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:07:29 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id 7470368
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:29 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 04/12] tests, profiles: Use IEC prefixes for binary multiples
Date: Thu, 22 Dec 2016 00:08:45 -0600
Message-Id: <20161222060853.64104-5-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Use IEC 80000-13 prefixes for binary multiples of bytes
(KiB, MiB, etc.) rather than SI prefixes for decimal multiples
of bytes (KB, MB, etc.) in places in which the code has fixed
divide by 1024, 1024*1024, >>20, etc.  and is clearly always
using binary multiples.
---
 crc/test.c             |  4 ++--
 profiles/act.c         |  8 ++++----
 profiles/tiobench.c    |  4 ++--
 t/btrace2fio.c         | 18 +++++++++---------
 t/dedupe.c             |  2 +-
 t/genzipf.c            | 13 +++++++------
 t/lfsr-test.c          |  2 +-
 t/memlock.c            | 14 +++++++-------
 t/read-to-pipe-async.c |  4 ++--
 9 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/crc/test.c b/crc/test.c
index 213b5d5..300000d 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -338,9 +338,9 @@ int fio_crctest(const char *type)
 				sprintf(pre, "\t");
 			else
 				sprintf(pre, "\t\t");
-			printf("%s:%s%8.2f MB/sec\n", t[i].name, pre, mb_sec);
+			printf("%s:%s%8.2f MiB/sec\n", t[i].name, pre, mb_sec);
 		} else
-			printf("%s:inf MB/sec\n", t[i].name);
+			printf("%s:inf MiB/sec\n", t[i].name);
 		first = 0;
 	}
 
diff --git a/profiles/act.c b/profiles/act.c
index 58ae7af..643f8a8 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -130,20 +130,20 @@ static struct fio_option options[] = {
 	},
 	{
 		.name	= "read-req-num-512-blocks",
-		.lname	= "Number of 512b blocks to read",
+		.lname	= "Number of 512B blocks to read",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct act_options, num_read_blocks),
-		.help	= "Number of 512b blocks to read at the time",
+		.help	= "Number of 512B blocks to read at the time",
 		.def	= "3",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_ACT,
 	},
 	{
 		.name	= "large-block-op-kbytes",
-		.lname	= "Size of large block ops (writes)",
+		.lname	= "Size of large block ops in KiB (writes)",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct act_options, write_size),
-		.help	= "Size of large block ops (writes)",
+		.help	= "Size of large block ops in KiB (writes)",
 		.def	= "131072",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_ACT,
diff --git a/profiles/tiobench.c b/profiles/tiobench.c
index 17229b9..9d9885a 100644
--- a/profiles/tiobench.c
+++ b/profiles/tiobench.c
@@ -39,7 +39,7 @@ static struct fio_option options[] = {
 		.lname	= "Tiobench size",
 		.type	= FIO_OPT_STR_VAL,
 		.off1	= offsetof(struct tiobench_options, size),
-		.help	= "Size in MB",
+		.help	= "Size in MiB",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
 	},
@@ -91,7 +91,7 @@ static struct fio_option options[] = {
 static int tb_prep_cmdline(void)
 {
 	/*
-	 * tiobench uses size as MB, so multiply up
+	 * tiobench uses size as MiB, so multiply up
 	 */
 	size *= 1024 * 1024ULL;
 	if (size)
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index c589cea..4cdb38d 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -62,7 +62,7 @@ struct btrace_out {
 
 	uint64_t first_ttime[DDIR_RWDIR_CNT];
 	uint64_t last_ttime[DDIR_RWDIR_CNT];
-	uint64_t kb[DDIR_RWDIR_CNT];
+	uint64_t kib[DDIR_RWDIR_CNT];
 
 	uint64_t start_delay;
 };
@@ -406,7 +406,7 @@ static int handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
 
 		i = inflight_find(t->sector + (t->bytes >> 9));
 		if (i) {
-			i->p->o.kb[t_to_rwdir(t)] += (t->bytes >> 10);
+			i->p->o.kib[t_to_rwdir(t)] += (t->bytes >> 10);
 			i->p->o.complete_seen = 1;
 			inflight_remove(i);
 		}
@@ -556,7 +556,7 @@ static int bs_cmp(const void *ba, const void *bb)
 	return bsb->nr - bsa->nr;
 }
 
-static unsigned long o_to_kb_rate(struct btrace_out *o, int rw)
+static unsigned long o_to_kib_rate(struct btrace_out *o, int rw)
 {
 	uint64_t usec = (o->last_ttime[rw] - o->first_ttime[rw]) / 1000ULL;
 	uint64_t val;
@@ -568,7 +568,7 @@ static unsigned long o_to_kb_rate(struct btrace_out *o, int rw)
 	if (!usec)
 		return 0;
 
-	val = o->kb[rw] * 1000ULL;
+	val = o->kib[rw] * 1000ULL;
 	return val / usec;
 }
 
@@ -623,7 +623,7 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 		printf("\tmerges: %lu (perc=%3.2f%%)\n", o->merges[i], perc);
 		perc = ((float) o->seq[i] * 100.0) / (float) o->ios[i];
 		printf("\tseq:    %lu (perc=%3.2f%%)\n", (unsigned long) o->seq[i], perc);
-		printf("\trate:   %lu KB/sec\n", o_to_kb_rate(o, i));
+		printf("\trate:   %lu KiB/sec\n", o_to_kib_rate(o, i));
 
 		for (j = 0; j < o->nr_bs[i]; j++) {
 			struct bs *bs = &o->bs[i][j];
@@ -746,7 +746,7 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 			unsigned long rate;
 
-			rate = o_to_kb_rate(o, i);
+			rate = o_to_kib_rate(o, i);
 			if (i)
 				printf(",");
 			if (rate)
@@ -810,7 +810,7 @@ static int prune_entry(struct btrace_out *o)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		unsigned long this_rate;
 
-		this_rate = o_to_kb_rate(o, i);
+		this_rate = o_to_kib_rate(o, i);
 		if (this_rate < rate_threshold) {
 			remove_ddir(o, i);
 			this_rate = 0;
@@ -926,7 +926,7 @@ static int merge_entries(struct btrace_pid *pida, struct btrace_pid *pidb)
 		oa->ios[i] += ob->ios[i];
 		oa->merges[i] += ob->merges[i];
 		oa->seq[i] += ob->seq[i];
-		oa->kb[i] += ob->kb[i];
+		oa->kib[i] += ob->kib[i];
 		oa->first_ttime[i] = min(oa->first_ttime[i], ob->first_ttime[i]);
 		oa->last_ttime[i] = max(oa->last_ttime[i], ob->last_ttime[i]);
 		merge_bs(&oa->bs[i], &oa->nr_bs[i], ob->bs[i], ob->nr_bs[i]);
@@ -1021,7 +1021,7 @@ static int usage(char *argv[])
 	log_err("\t-n\tNumber IOS threshold to ignore task\n");
 	log_err("\t-f\tFio job file output\n");
 	log_err("\t-d\tUse this file/device for replay\n");
-	log_err("\t-r\tIgnore jobs with less than this KB/sec rate\n");
+	log_err("\t-r\tIgnore jobs with less than this KiB/sec rate\n");
 	log_err("\t-R\tSet rate in fio job (def=%u)\n", set_rate);
 	log_err("\t-D\tCap queue depth at this value (def=%u)\n", max_depth);
 	log_err("\t-c\tCollapse \"identical\" jobs (def=%u)\n", collapse_entries);
diff --git a/t/dedupe.c b/t/dedupe.c
index 7856da1..c0e9a69 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -363,7 +363,7 @@ static void show_progress(struct worker_thread *threads, unsigned long total)
 		tdiff = mtime_since_now(&last_tv);
 		if (tdiff) {
 			this_items = (this_items * 1000) / (tdiff * 1024);
-			printf("%3.2f%% done (%luKB/sec)\r", perc, this_items);
+			printf("%3.2f%% done (%luKiB/sec)\r", perc, this_items);
 			last_nitems = nitems;
 			fio_gettime(&last_tv, NULL);
 		} else
diff --git a/t/genzipf.c b/t/genzipf.c
index d8253c3..9faec38 100644
--- a/t/genzipf.c
+++ b/t/genzipf.c
@@ -3,8 +3,8 @@
  * what an access pattern would look like.
  *
  * For instance, the following would generate a zipf distribution
- * with theta 1.2, using 262144 (1 GB / 4096) values and split the reporting into
- * 20 buckets:
+ * with theta 1.2, using 262144 (1 GiB / 4096) values and split the
+ * reporting into 20 buckets:
  *
  *	./t/fio-genzipf -t zipf -i 1.2 -g 1 -b 4096 -o 20
  *
@@ -49,7 +49,7 @@ enum {
 };
 
 static int dist_type = TYPE_ZIPF;
-static unsigned long gb_size = 500;
+static unsigned long gib_size = 500;
 static unsigned long block_size = 4096;
 static unsigned long output_nranges = DEF_NR_OUTPUT;
 static double percentage;
@@ -131,7 +131,7 @@ static int parse_options(int argc, char *argv[])
 			}
 			break;
 		case 'g':
-			gb_size = strtoul(optarg, NULL, 10);
+			gib_size = strtoul(optarg, NULL, 10);
 			break;
 		case 'i':
 			dist_val = atof(optarg);
@@ -291,9 +291,10 @@ int main(int argc, char *argv[])
 		return 1;
 
 	if (output_type != OUTPUT_CSV)
-		printf("Generating %s distribution with %f input and %lu GB size and %lu block_size.\n", dist_types[dist_type], dist_val, gb_size, block_size);
+		printf("Generating %s distribution with %f input and %lu GiB size and %lu block_size.\n",
+		       dist_types[dist_type], dist_val, gib_size, block_size);
 
-	nranges = gb_size * 1024 * 1024 * 1024ULL;
+	nranges = gib_size * 1024 * 1024 * 1024ULL;
 	nranges /= block_size;
 
 	if (dist_type == TYPE_ZIPF)
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index bad5097..7016f26 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -80,7 +80,7 @@ int main(int argc, char *argv[])
 		v_size = numbers * sizeof(uint8_t);
 		v = malloc(v_size);
 		memset(v, 0, v_size);
-		printf("\nVerification table is %lf KBs\n", (double)(v_size) / 1024);
+		printf("\nVerification table is %lf KiB\n", (double)(v_size) / 1024);
 	}
 	v_start = v;
 
diff --git a/t/memlock.c b/t/memlock.c
index d9d586d..3d3579a 100644
--- a/t/memlock.c
+++ b/t/memlock.c
@@ -4,7 +4,7 @@
 #include <pthread.h>
 
 static struct thread_data {
-	unsigned long mb;
+	unsigned long mib;
 } td;
 
 static void *worker(void *data)
@@ -15,14 +15,14 @@ static void *worker(void *data)
 	char *buf;
 	int i, first = 1;
 
-	size = td->mb * 1024UL * 1024UL;
+	size = td->mib * 1024UL * 1024UL;
 	buf = malloc(size);
 
 	for (i = 0; i < 100000; i++) {
 		for (index = 0; index + 4096 < size; index += 4096)
 			memset(&buf[index+512], 0x89, 512);
 		if (first) {
-			printf("loop%d: did %lu MB\n", i+1, size/(1024UL*1024UL));
+			printf("loop%d: did %lu MiB\n", i+1, size/(1024UL*1024UL));
 			first = 0;
 		}
 	}
@@ -31,20 +31,20 @@ static void *worker(void *data)
 
 int main(int argc, char *argv[])
 {
-	unsigned long mb, threads;
+	unsigned long mib, threads;
 	pthread_t *pthreads;
 	int i;
 
 	if (argc < 3) {
-		printf("%s: <mb per thread> <threads>\n", argv[0]);
+		printf("%s: <MiB per thread> <threads>\n", argv[0]);
 		return 1;
 	}
 
-	mb = strtoul(argv[1], NULL, 10);
+	mib = strtoul(argv[1], NULL, 10);
 	threads = strtoul(argv[2], NULL, 10);
 
 	pthreads = calloc(threads, sizeof(pthread_t));
-	td.mb = mb;
+	td.mib = mib;
 
 	for (i = 0; i < threads; i++)
 		pthread_create(&pthreads[i], NULL, worker, &td);
diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index e8bdc85..ebdd8f1 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -661,9 +661,9 @@ int main(int argc, char *argv[])
 
 	bytes /= 1024;
 	rate = (bytes * 1000UL * 1000UL) / utime_since(&s, &re);
-	fprintf(stderr, "Read rate (KB/sec) : %lu\n", rate);
+	fprintf(stderr, "Read rate (KiB/sec) : %lu\n", rate);
 	rate = (bytes * 1000UL * 1000UL) / utime_since(&s, &we);
-	fprintf(stderr, "Write rate (KB/sec): %lu\n", rate);
+	fprintf(stderr, "Write rate (KiB/sec): %lu\n", rate);
 
 	close(fd);
 	return 0;
-- 
2.9.3

