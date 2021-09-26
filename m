Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CED0C433EF
	for <fio@archiver.kernel.org>; Sun, 26 Sep 2021 12:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E24E961038
	for <fio@archiver.kernel.org>; Sun, 26 Sep 2021 12:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhIZMCH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 26 Sep 2021 08:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhIZMCH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Sep 2021 08:02:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8922FC061570
        for <fio@vger.kernel.org>; Sun, 26 Sep 2021 05:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Un/vx3YCUnBaDRlc+wg6is22w4lH3ihyun4sGrM81R4=; b=QsGwQJN+wcxTusjhiVwDGhlHm8
        6W7aSRFyBt4p1i+4aQkWtMqRA5mBpy+tE8sOLUZXY9BrNYgeJJmxvmZAmo9QB1LTKM76XJ4UOoKHz
        VwQ7RcDCd+2d0YWVojoPxOs7JsexrIlKgc5S3hH+YhUFTxvDIS5j7ZOQqeGkvS38y4nm2GUrLGYQE
        FK1YkeQWeCDqUwQCT352u+6rbzhwoRbrm2LI+MvWqXtEx0F1vvfxqIWXR+c7UfIuSUYKnMK8cjeM4
        qMQx7vzfy4RK8aiIrmq2nbuQ9Yu4uvWRR21ARwLVdToWvVgpKtQzJZjqRM4Cg4YYEcF4NoQo0cB/F
        soira5ww==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUSpF-008sOy-VX
        for fio@vger.kernel.org; Sun, 26 Sep 2021 12:00:18 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6C1631BC0155; Sun, 26 Sep 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210926120002.6C1631BC0155@kernel.dk>
Date:   Sun, 26 Sep 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6c5d3a1c08bda1bbf22187c7b80573400e1c1053:

  t/io_uring: don't print BW numbers for do_nop (2021-09-24 15:17:44 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0b2114e7b46d047271d8d404beaae7006e89f8ef:

  Merge branch 'evelu-uring' of https://github.com/ErwanAliasr1/fio (2021-09-25 14:56:14 -0600)

----------------------------------------------------------------
Erwan Velu (1):
      t/io_uring.c: Adding \n on help

Jens Axboe (3):
      t/io_uring: add support for latency tracking
      t/io_uring: batch stat updates
      Merge branch 'evelu-uring' of https://github.com/ErwanAliasr1/fio

 t/io_uring.c | 298 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 289 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index d5636380..f22c504a 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -5,6 +5,7 @@
 #include <stddef.h>
 #include <signal.h>
 #include <inttypes.h>
+#include <math.h>
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -22,10 +23,10 @@
 
 #include "../arch/arch.h"
 #include "../lib/types.h"
+#include "../lib/roundup.h"
+#include "../minmax.h"
 #include "../os/linux/io_uring.h"
 
-#define min(a, b)		((a < b) ? (a) : (b))
-
 struct io_sq_ring {
 	unsigned *head;
 	unsigned *tail;
@@ -57,8 +58,14 @@ struct file {
 	unsigned pending_ios;
 	int real_fd;
 	int fixed_fd;
+	int fileno;
 };
 
+#define PLAT_BITS		6
+#define PLAT_VAL		(1 << PLAT_BITS)
+#define PLAT_GROUP_NR		29
+#define PLAT_NR			(PLAT_GROUP_NR * PLAT_VAL)
+
 struct submitter {
 	pthread_t thread;
 	int ring_fd;
@@ -67,6 +74,7 @@ struct submitter {
 	struct io_uring_sqe *sqes;
 	struct io_cq_ring cq_ring;
 	int inflight;
+	int tid;
 	unsigned long reaps;
 	unsigned long done;
 	unsigned long calls;
@@ -74,6 +82,10 @@ struct submitter {
 
 	__s32 *fds;
 
+	unsigned long *clock_batch;
+	int clock_index;
+	unsigned long *plat;
+
 	struct file files[MAX_FDS];
 	unsigned nr_files;
 	unsigned cur_file;
@@ -95,9 +107,202 @@ static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
 static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
 static int do_nop = 0;		/* no-op SQ ring commands */
 static int nthreads = 1;
+static int stats = 0;		/* generate IO stats */
+static unsigned long tsc_rate;
 
 static int vectored = 1;
 
+static float plist[] = { 1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0,
+			80.0, 90.0, 95.0, 99.9, 99.5, 99.9, 99.95, 99.99 };
+static int plist_len = 17;
+
+static unsigned long cycles_to_nsec(unsigned long cycles)
+{
+	uint64_t val;
+
+	if (!tsc_rate)
+		return cycles;
+
+	val = cycles * 1000000000ULL;
+	return val / tsc_rate;
+}
+
+static unsigned long plat_idx_to_val(unsigned int idx)
+{
+	unsigned int error_bits;
+	unsigned long k, base;
+
+	assert(idx < PLAT_NR);
+
+	/* MSB <= (PLAT_BITS-1), cannot be rounded off. Use
+	 * all bits of the sample as index */
+	if (idx < (PLAT_VAL << 1))
+		return cycles_to_nsec(idx);
+
+	/* Find the group and compute the minimum value of that group */
+	error_bits = (idx >> PLAT_BITS) - 1;
+	base = ((unsigned long) 1) << (error_bits + PLAT_BITS);
+
+	/* Find its bucket number of the group */
+	k = idx % PLAT_VAL;
+
+	/* Return the mean of the range of the bucket */
+	return cycles_to_nsec(base + ((k + 0.5) * (1 << error_bits)));
+}
+
+unsigned int calc_clat_percentiles(unsigned long *io_u_plat, unsigned long nr,
+				   unsigned long **output,
+				   unsigned long *maxv, unsigned long *minv)
+{
+	unsigned long sum = 0;
+	unsigned int len = plist_len, i, j = 0;
+	unsigned long *ovals = NULL;
+	bool is_last;
+
+	*minv = -1ULL;
+	*maxv = 0;
+
+	ovals = malloc(len * sizeof(*ovals));
+	if (!ovals)
+		return 0;
+
+	/*
+	 * Calculate bucket values, note down max and min values
+	 */
+	is_last = false;
+	for (i = 0; i < PLAT_NR && !is_last; i++) {
+		sum += io_u_plat[i];
+		while (sum >= ((long double) plist[j] / 100.0 * nr)) {
+			assert(plist[j] <= 100.0);
+
+			ovals[j] = plat_idx_to_val(i);
+			if (ovals[j] < *minv)
+				*minv = ovals[j];
+			if (ovals[j] > *maxv)
+				*maxv = ovals[j];
+
+			is_last = (j == len - 1) != 0;
+			if (is_last)
+				break;
+
+			j++;
+		}
+	}
+
+	if (!is_last)
+		fprintf(stderr, "error calculating latency percentiles\n");
+
+	*output = ovals;
+	return len;
+}
+
+static void show_clat_percentiles(unsigned long *io_u_plat, unsigned long nr,
+				  unsigned int precision)
+{
+	unsigned int divisor, len, i, j = 0;
+	unsigned long minv, maxv;
+	unsigned long *ovals;
+	int per_line, scale_down, time_width;
+	bool is_last;
+	char fmt[32];
+
+	len = calc_clat_percentiles(io_u_plat, nr, &ovals, &maxv, &minv);
+	if (!len || !ovals)
+		goto out;
+
+	if (!tsc_rate) {
+		scale_down = 0;
+		divisor = 1;
+		printf("    percentiles (tsc ticks):\n     |");
+	} else if (minv > 2000 && maxv > 99999) {
+		scale_down = 1;
+		divisor = 1000;
+		printf("    percentiles (usec):\n     |");
+	} else {
+		scale_down = 0;
+		divisor = 1;
+		printf("    percentiles (nsec):\n     |");
+	}
+
+	time_width = max(5, (int) (log10(maxv / divisor) + 1));
+	snprintf(fmt, sizeof(fmt), " %%%u.%ufth=[%%%dllu]%%c", precision + 3,
+			precision, time_width);
+	/* fmt will be something like " %5.2fth=[%4llu]%c" */
+	per_line = (80 - 7) / (precision + 10 + time_width);
+
+	for (j = 0; j < len; j++) {
+		/* for formatting */
+		if (j != 0 && (j % per_line) == 0)
+			printf("     |");
+
+		/* end of the list */
+		is_last = (j == len - 1) != 0;
+
+		for (i = 0; i < scale_down; i++)
+			ovals[j] = (ovals[j] + 999) / 1000;
+
+		printf(fmt, plist[j], ovals[j], is_last ? '\n' : ',');
+
+		if (is_last)
+			break;
+
+		if ((j % per_line) == per_line - 1)	/* for formatting */
+			printf("\n");
+	}
+
+out:
+	free(ovals);
+}
+
+static unsigned int plat_val_to_idx(unsigned long val)
+{
+	unsigned int msb, error_bits, base, offset, idx;
+
+	/* Find MSB starting from bit 0 */
+	if (val == 0)
+		msb = 0;
+	else
+		msb = (sizeof(val)*8) - __builtin_clzll(val) - 1;
+
+	/*
+	 * MSB <= (PLAT_BITS-1), cannot be rounded off. Use
+	 * all bits of the sample as index
+	 */
+	if (msb <= PLAT_BITS)
+		return val;
+
+	/* Compute the number of error bits to discard*/
+	error_bits = msb - PLAT_BITS;
+
+	/* Compute the number of buckets before the group */
+	base = (error_bits + 1) << PLAT_BITS;
+
+	/*
+	 * Discard the error bits and apply the mask to find the
+	 * index for the buckets in the group
+	 */
+	offset = (PLAT_VAL - 1) & (val >> error_bits);
+
+	/* Make sure the index does not exceed (array size - 1) */
+	idx = (base + offset) < (PLAT_NR - 1) ?
+		(base + offset) : (PLAT_NR - 1);
+
+	return idx;
+}
+
+static void add_stat(struct submitter *s, int clock_index, int nr)
+{
+#ifdef ARCH_HAVE_CPU_CLOCK
+	unsigned long cycles;
+	unsigned int pidx;
+
+	cycles = get_cpu_clock();
+	cycles -= s->clock_batch[clock_index];
+	pidx = plat_val_to_idx(cycles);
+	s->plat[pidx] += nr;
+#endif
+}
+
 static int io_uring_register_buffers(struct submitter *s)
 {
 	if (do_nop)
@@ -224,7 +429,9 @@ static void init_io(struct submitter *s, unsigned index)
 	}
 	sqe->ioprio = 0;
 	sqe->off = offset;
-	sqe->user_data = (unsigned long) f;
+	sqe->user_data = (unsigned long) f->fileno;
+	if (stats)
+		sqe->user_data |= ((unsigned long)s->clock_index << 32);
 }
 
 static int prep_more_ios(struct submitter *s, int max_ios)
@@ -277,6 +484,7 @@ static int reap_events(struct submitter *s)
 	struct io_cq_ring *ring = &s->cq_ring;
 	struct io_uring_cqe *cqe;
 	unsigned head, reaped = 0;
+	int last_idx = -1, stat_nr = 0;
 
 	head = *ring->head;
 	do {
@@ -287,7 +495,9 @@ static int reap_events(struct submitter *s)
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
 		if (!do_nop) {
-			f = (struct file *) (uintptr_t) cqe->user_data;
+			int fileno = cqe->user_data & 0xffffffff;
+
+			f = &s->files[fileno];
 			f->pending_ios--;
 			if (cqe->res != bs) {
 				printf("io: unexpected ret=%d\n", cqe->res);
@@ -296,10 +506,26 @@ static int reap_events(struct submitter *s)
 				return -1;
 			}
 		}
+		if (stats) {
+			int clock_index = cqe->user_data >> 32;
+
+			if (last_idx != clock_index) {
+				if (last_idx != -1) {
+					add_stat(s, last_idx, stat_nr);
+					stat_nr = 0;
+				}
+				last_idx = clock_index;
+			}
+			stat_nr++;
+			add_stat(s, clock_index, 1);
+		}
 		reaped++;
 		head++;
 	} while (1);
 
+	if (stat_nr)
+		add_stat(s, last_idx, stat_nr);
+
 	if (reaped) {
 		s->inflight -= reaped;
 		atomic_store_release(ring->head, head);
@@ -311,12 +537,28 @@ static void *submitter_fn(void *data)
 {
 	struct submitter *s = data;
 	struct io_sq_ring *ring = &s->sq_ring;
-	int ret, prepped;
+	int i, ret, prepped, nr_batch;
 
-	printf("submitter=%d\n", gettid());
+	s->tid = gettid();
+	printf("submitter=%d\n", s->tid);
 
 	srand48(pthread_self());
 
+	for (i = 0; i < MAX_FDS; i++)
+		s->files[i].fileno = i;
+
+	if (stats) {
+		nr_batch = roundup_pow2(depth / batch_submit);
+		s->clock_batch = calloc(nr_batch, sizeof(unsigned long));
+		s->clock_index = 0;
+
+		s->plat = calloc(PLAT_NR, sizeof(unsigned long));
+	} else {
+		s->clock_batch = NULL;
+		s->plat = NULL;
+		nr_batch = 0;
+	}
+
 	prepped = 0;
 	do {
 		int to_wait, to_submit, this_reap, to_prep;
@@ -325,6 +567,12 @@ static void *submitter_fn(void *data)
 		if (!prepped && s->inflight < depth) {
 			to_prep = min(depth - s->inflight, batch_submit);
 			prepped = prep_more_ios(s, to_prep);
+#ifdef ARCH_HAVE_CPU_CLOCK
+			if (prepped && stats) {
+				s->clock_batch[s->clock_index] = get_cpu_clock();
+				s->clock_index = (s->clock_index + 1) & (nr_batch - 1);
+			}
+#endif
 		}
 		s->inflight += prepped;
 submit_more:
@@ -555,9 +803,11 @@ static void usage(char *argv, int status)
 		" -F <bool> : Register files, default %d\n"
 		" -n <int>  : Number of threads, default %d\n"
 		" -O <bool> : Use O_DIRECT, default %d\n"
-		" -N <bool> : Perform just no-op requests, default %d\n",
+		" -N <bool> : Perform just no-op requests, default %d\n"
+		" -t <bool> : Track IO latencies, default %d\n"
+		" -T <int>  : TSC rate in HZ\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
-		fixedbufs, register_files, nthreads, !buffered, do_nop);
+		fixedbufs, register_files, nthreads, !buffered, do_nop, stats);
 	exit(status);
 }
 
@@ -573,16 +823,20 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:h?")) != -1) {
 		switch (opt) {
 		case 'd':
 			depth = atoi(optarg);
 			break;
 		case 's':
 			batch_submit = atoi(optarg);
+			if (!batch_submit)
+				batch_submit = 1;
 			break;
 		case 'c':
 			batch_complete = atoi(optarg);
+			if (!batch_complete)
+				batch_complete = 1;
 			break;
 		case 'b':
 			bs = atoi(optarg);
@@ -609,6 +863,20 @@ int main(int argc, char *argv[])
 		case 'O':
 			buffered = !atoi(optarg);
 			break;
+		case 't':
+#ifndef ARCH_HAVE_CPU_CLOCK
+			fprintf(stderr, "Stats not supported on this CPU\n");
+			return 1;
+#endif
+			stats = !!atoi(optarg);
+			break;
+		case 'T':
+#ifndef ARCH_HAVE_CPU_CLOCK
+			fprintf(stderr, "Stats not supported on this CPU\n");
+			return 1;
+#endif
+			tsc_rate = strtoul(optarg, NULL, 10);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -764,7 +1032,19 @@ int main(int argc, char *argv[])
 		s = get_submitter(j);
 		pthread_join(s->thread, &ret);
 		close(s->ring_fd);
+
+		if (stats) {
+			unsigned long nr;
+
+			printf("%d: Latency percentiles:\n", s->tid);
+			for (i = 0, nr = 0; i < PLAT_NR; i++)
+				nr += s->plat[i];
+			show_clat_percentiles(s->plat, nr, 4);
+			free(s->clock_batch);
+			free(s->plat);
+		}
 	}
+
 	free(fdepths);
 	free(submitter);
 	return 0;
