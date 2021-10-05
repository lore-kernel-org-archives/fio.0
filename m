Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C6CC433F5
	for <fio@archiver.kernel.org>; Tue,  5 Oct 2021 12:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38E861425
	for <fio@archiver.kernel.org>; Tue,  5 Oct 2021 12:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhJEMCw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 5 Oct 2021 08:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbhJEMCw (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Oct 2021 08:02:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D589CC061749
        for <fio@vger.kernel.org>; Tue,  5 Oct 2021 05:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=/Ac5cYXepo/w5HXYTctyDEDmea3H4W6jqefuPqZldJs=; b=AUQWzoP54vsZF4tfy9NqmYgXGI
        wFJCGpn+mNrpzgmny5qcoderBuOJv35r4eok7iqdORFKmNwmXcglwc/QwIYWdx1nfsaMYJSuVPN0K
        SXuDV4IbtLHD+vy54Qt7F0HQciD2LNk+K2dHml2qME9mXYFiFsKfK8IYBJj/Fj5v8VRaLyCk4w2CV
        +QehUrZ6a9qIp2s6ISjFNtcr5GghR69X5qF4wPCXJays8EHnw7Qql9kCLbREWcc/POhDwqkou6Mea
        GpfogLs4oS70nsQRFbzCMytbiLDjxsxW+y1hsETfYLs5vfStlmuNPXO9zy6UBUhE9sVX+oSg//kXz
        FGl9StJg==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mXj78-000PcX-Hg
        for fio@vger.kernel.org; Tue, 05 Oct 2021 12:00:23 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 18B731BC0168; Tue,  5 Oct 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211005120002.18B731BC0168@kernel.dk>
Date:   Tue,  5 Oct 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit ca4eefc1b55d7f9fc03bf113d63e3d0b2d7b38ae:

  Merge branch 'evelu-fixes2' of https://github.com/ErwanAliasr1/fio (2021-10-01 13:55:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 24a24c12a04c45174c2d68ffb7fcb3f367e40dee:

  t/io_uring: clean up aio wait loop (2021-10-04 17:04:04 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      t/io_uring: remove extra add_stat() call
      t/io_uring: add support for legacy AIO
      t/io_uring: don't print partial IOPS etc output if exit signal was received
      t/io_uring: don't track IO latencies the first second of runtime
      t/io_uring: check for valid clock_index and finish state for stats
      t/io_uring: clean up aio wait loop

 t/io_uring.c | 277 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 253 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 2ec4caeb..f27a12c7 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -7,6 +7,10 @@
 #include <inttypes.h>
 #include <math.h>
 
+#ifdef CONFIG_LIBAIO
+#include <libaio.h>
+#endif
+
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
@@ -86,6 +90,10 @@ struct submitter {
 	int clock_index;
 	unsigned long *plat;
 
+#ifdef CONFIG_LIBAIO
+	io_context_t aio_ctx;
+#endif
+
 	struct file files[MAX_FDS];
 	unsigned nr_files;
 	unsigned cur_file;
@@ -94,6 +102,7 @@ struct submitter {
 
 static struct submitter *submitter;
 static volatile int finish;
+static int stats_running;
 
 static int depth = DEPTH;
 static int batch_submit = BATCH_SUBMIT;
@@ -108,6 +117,8 @@ static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
 static int do_nop = 0;		/* no-op SQ ring commands */
 static int nthreads = 1;
 static int stats = 0;		/* generate IO stats */
+static int aio = 0;		/* use libaio */
+
 static unsigned long tsc_rate;
 
 #define TSC_RATE_FILE	"tsc-rate"
@@ -298,10 +309,12 @@ static void add_stat(struct submitter *s, int clock_index, int nr)
 	unsigned long cycles;
 	unsigned int pidx;
 
-	cycles = get_cpu_clock();
-	cycles -= s->clock_batch[clock_index];
-	pidx = plat_val_to_idx(cycles);
-	s->plat[pidx] += nr;
+	if (!s->finish && clock_index) {
+		cycles = get_cpu_clock();
+		cycles -= s->clock_batch[clock_index];
+		pidx = plat_val_to_idx(cycles);
+		s->plat[pidx] += nr;
+	}
 #endif
 }
 
@@ -432,11 +445,11 @@ static void init_io(struct submitter *s, unsigned index)
 	sqe->ioprio = 0;
 	sqe->off = offset;
 	sqe->user_data = (unsigned long) f->fileno;
-	if (stats)
+	if (stats && stats_running)
 		sqe->user_data |= ((unsigned long)s->clock_index << 32);
 }
 
-static int prep_more_ios(struct submitter *s, int max_ios)
+static int prep_more_ios_uring(struct submitter *s, int max_ios)
 {
 	struct io_sq_ring *ring = &s->sq_ring;
 	unsigned index, tail, next_tail, prepped = 0;
@@ -481,7 +494,7 @@ static int get_file_size(struct file *f)
 	return -1;
 }
 
-static int reap_events(struct submitter *s)
+static int reap_events_uring(struct submitter *s)
 {
 	struct io_cq_ring *ring = &s->cq_ring;
 	struct io_uring_cqe *cqe;
@@ -517,9 +530,8 @@ static int reap_events(struct submitter *s)
 					stat_nr = 0;
 				}
 				last_idx = clock_index;
-			}
-			stat_nr++;
-			add_stat(s, clock_index, 1);
+			} else if (clock_index)
+				stat_nr++;
 		}
 		reaped++;
 		head++;
@@ -535,11 +547,9 @@ static int reap_events(struct submitter *s)
 	return reaped;
 }
 
-static void *submitter_fn(void *data)
+static int submitter_init(struct submitter *s)
 {
-	struct submitter *s = data;
-	struct io_sq_ring *ring = &s->sq_ring;
-	int i, ret, prepped, nr_batch;
+	int i, nr_batch;
 
 	s->tid = gettid();
 	printf("submitter=%d\n", s->tid);
@@ -552,7 +562,7 @@ static void *submitter_fn(void *data)
 	if (stats) {
 		nr_batch = roundup_pow2(depth / batch_submit);
 		s->clock_batch = calloc(nr_batch, sizeof(unsigned long));
-		s->clock_index = 0;
+		s->clock_index = 1;
 
 		s->plat = calloc(PLAT_NR, sizeof(unsigned long));
 	} else {
@@ -561,6 +571,170 @@ static void *submitter_fn(void *data)
 		nr_batch = 0;
 	}
 
+	return nr_batch;
+}
+
+#ifdef CONFIG_LIBAIO
+static int prep_more_ios_aio(struct submitter *s, int max_ios, struct iocb *iocbs)
+{
+	unsigned long offset, data;
+	struct file *f;
+	unsigned index;
+	long r;
+
+	index = 0;
+	while (index < max_ios) {
+		struct iocb *iocb = &iocbs[index];
+
+		if (s->nr_files == 1) {
+			f = &s->files[0];
+		} else {
+			f = &s->files[s->cur_file];
+			if (f->pending_ios >= file_depth(s)) {
+				s->cur_file++;
+				if (s->cur_file == s->nr_files)
+					s->cur_file = 0;
+				f = &s->files[s->cur_file];
+			}
+		}
+		f->pending_ios++;
+
+		r = lrand48();
+		offset = (r % (f->max_blocks - 1)) * bs;
+		io_prep_pread(iocb, f->real_fd, s->iovecs[index].iov_base,
+				s->iovecs[index].iov_len, offset);
+
+		data = f->fileno;
+		if (stats && stats_running)
+			data |= ((unsigned long) s->clock_index << 32);
+		iocb->data = (void *) (uintptr_t) data;
+		index++;
+	}
+	return index;
+}
+
+static int reap_events_aio(struct submitter *s, struct io_event *events, int evs)
+{
+	int last_idx = -1, stat_nr = 0;
+	int reaped = 0;
+
+	while (evs) {
+		unsigned long data = (uintptr_t) events[reaped].data;
+		struct file *f = &s->files[data & 0xffffffff];
+
+		f->pending_ios--;
+		if (events[reaped].res != bs) {
+			printf("io: unexpected ret=%ld\n", events[reaped].res);
+			return -1;
+		}
+		if (stats) {
+			int clock_index = data >> 32;
+
+			if (last_idx != clock_index) {
+				if (last_idx != -1) {
+					add_stat(s, last_idx, stat_nr);
+					stat_nr = 0;
+				}
+				last_idx = clock_index;
+			} else if (clock_index)
+				stat_nr++;
+		}
+		reaped++;
+		evs--;
+	}
+
+	if (stat_nr)
+		add_stat(s, last_idx, stat_nr);
+
+	s->inflight -= reaped;
+	s->done += reaped;
+	return reaped;
+}
+
+static void *submitter_aio_fn(void *data)
+{
+	struct submitter *s = data;
+	int i, ret, prepped, nr_batch;
+	struct iocb **iocbsptr;
+	struct iocb *iocbs;
+	struct io_event *events;
+
+	nr_batch = submitter_init(s);
+
+	iocbsptr = calloc(depth, sizeof(struct iocb *));
+	iocbs = calloc(depth, sizeof(struct iocb));
+	events = calloc(depth, sizeof(struct io_event));
+
+	for (i = 0; i < depth; i++)
+		iocbsptr[i] = &iocbs[i];
+
+	prepped = 0;
+	do {
+		int to_wait, to_submit, to_prep;
+
+		if (!prepped && s->inflight < depth) {
+			to_prep = min(depth - s->inflight, batch_submit);
+			prepped = prep_more_ios_aio(s, to_prep, iocbs);
+#ifdef ARCH_HAVE_CPU_CLOCK
+			if (prepped && stats) {
+				s->clock_batch[s->clock_index] = get_cpu_clock();
+				s->clock_index = (s->clock_index + 1) & (nr_batch - 1);
+			}
+#endif
+		}
+		s->inflight += prepped;
+		to_submit = prepped;
+
+		if (to_submit && (s->inflight + to_submit <= depth))
+			to_wait = 0;
+		else
+			to_wait = min(s->inflight + to_submit, batch_complete);
+
+		ret = io_submit(s->aio_ctx, to_submit, iocbsptr);
+		s->calls++;
+		if (ret < 0) {
+			perror("io_submit");
+			break;
+		} else if (ret != to_submit) {
+			printf("submitted %d, wanted %d\n", ret, to_submit);
+			break;
+		}
+		prepped = 0;
+
+		while (to_wait) {
+			int r;
+
+			s->calls++;
+			r = io_getevents(s->aio_ctx, to_wait, to_wait, events, NULL);
+			if (r < 0) {
+				perror("io_getevents");
+				break;
+			} else if (r != to_wait) {
+				printf("r=%d, wait=%d\n", r, to_wait);
+				break;
+			}
+			r = reap_events_aio(s, events, r);
+			s->reaps += r;
+			to_wait -= r;
+		}
+	} while (!s->finish);
+
+	free(iocbsptr);
+	free(iocbs);
+	free(events);
+	finish = 1;
+	return NULL;
+}
+#endif
+
+static void *submitter_uring_fn(void *data)
+{
+	struct submitter *s = data;
+	struct io_sq_ring *ring = &s->sq_ring;
+	int ret, prepped, nr_batch;
+
+	nr_batch = submitter_init(s);
+
 	prepped = 0;
 	do {
 		int to_wait, to_submit, this_reap, to_prep;
@@ -568,7 +742,7 @@ static void *submitter_fn(void *data)
 
 		if (!prepped && s->inflight < depth) {
 			to_prep = min(depth - s->inflight, batch_submit);
-			prepped = prep_more_ios(s, to_prep);
+			prepped = prep_more_ios_uring(s, to_prep);
 #ifdef ARCH_HAVE_CPU_CLOCK
 			if (prepped && stats) {
 				s->clock_batch[s->clock_index] = get_cpu_clock();
@@ -613,7 +787,8 @@ submit:
 		this_reap = 0;
 		do {
 			int r;
-			r = reap_events(s);
+
+			r = reap_events_uring(s);
 			if (r == -1) {
 				s->finish = 1;
 				break;
@@ -693,6 +868,34 @@ static void arm_sig_int(void)
 #endif
 }
 
+static int setup_aio(struct submitter *s)
+{
+#ifdef CONFIG_LIBAIO
+	if (polled) {
+		fprintf(stderr, "aio does not support polled IO\n");
+		polled = 0;
+	}
+	if (sq_thread_poll) {
+		fprintf(stderr, "aio does not support SQPOLL IO\n");
+		sq_thread_poll = 0;
+	}
+	if (do_nop) {
+		fprintf(stderr, "aio does not support polled IO\n");
+		do_nop = 0;
+	}
+	if (fixedbufs || register_files) {
+		fprintf(stderr, "aio does not support registered files or buffers\n");
+		fixedbufs = register_files = 0;
+	}
+
+	return io_queue_init(depth, &s->aio_ctx);
+#else
+	fprintf(stderr, "Legacy AIO not available on this system/build\n");
+	errno = EINVAL;
+	return -1;
+#endif
+}
+
 static int setup_ring(struct submitter *s)
 {
 	struct io_sq_ring *sring = &s->sq_ring;
@@ -812,9 +1015,10 @@ static void usage(char *argv, int status)
 		" -O <bool> : Use O_DIRECT, default %d\n"
 		" -N <bool> : Perform just no-op requests, default %d\n"
 		" -t <bool> : Track IO latencies, default %d\n"
-		" -T <int>  : TSC rate in HZ\n",
+		" -T <int>  : TSC rate in HZ\n"
+		" -a <bool> : Use legacy aio, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
-		fixedbufs, register_files, nthreads, !buffered, do_nop, stats);
+		fixedbufs, register_files, nthreads, !buffered, do_nop, stats, aio);
 	exit(status);
 }
 
@@ -874,8 +1078,11 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:h?")) != -1) {
 		switch (opt) {
+		case 'a':
+			aio = !!atoi(optarg);
+			break;
 		case 'd':
 			depth = atoi(optarg);
 			break;
@@ -1033,19 +1240,32 @@ int main(int argc, char *argv[])
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
 
-		err = setup_ring(s);
+		if (!aio)
+			err = setup_ring(s);
+		else
+			err = setup_aio(s);
 		if (err) {
 			printf("ring setup failed: %s, %d\n", strerror(errno), err);
 			return 1;
 		}
 	}
 	s = get_submitter(0);
-	printf("polled=%d, fixedbufs=%d, register_files=%d, buffered=%d", polled, fixedbufs, register_files, buffered);
-	printf(" QD=%d, sq_ring=%d, cq_ring=%d\n", depth, *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
+	printf("polled=%d, fixedbufs=%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, register_files, buffered, depth);
+	if (!aio)
+		printf("Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
+#ifdef CONFIG_LIBAIO
+	else
+		printf("Engine=aio, ctx=%p\n", &s->aio_ctx);
+#endif
 
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
-		pthread_create(&s->thread, NULL, submitter_fn, s);
+		if (!aio)
+			pthread_create(&s->thread, NULL, submitter_uring_fn, s);
+#ifdef CONFIG_LIBAIO
+		else
+			pthread_create(&s->thread, NULL, submitter_aio_fn, s);
+#endif
 	}
 
 	fdepths = malloc(8 * s->nr_files * nthreads);
@@ -1058,6 +1278,15 @@ int main(int argc, char *argv[])
 		unsigned long iops, bw;
 
 		sleep(1);
+
+		/* don't print partial run, if interrupted by signal */
+		if (finish)
+			break;
+
+		/* one second in to the run, enable stats */
+		if (stats)
+			stats_running = 1;
+
 		for (j = 0; j < nthreads; j++) {
 			this_done += s->done;
 			this_call += s->calls;
