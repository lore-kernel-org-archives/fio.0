Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670FEC19F28
	for <fio@archiver.kernel.org>; Wed,  3 Aug 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbiHCMAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 3 Aug 2022 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237606AbiHCMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Aug 2022 08:00:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0B652E6E
        for <fio@vger.kernel.org>; Wed,  3 Aug 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=iXTdhAUfnNnbLslyvI31dM9ddmu6SJa/xbEoQASrN0s=; b=UNPgwYimJ+HOnW88j73PEVY3tu
        DRpaoxKhS6MJq3lR2QrOZcKmcSm0EKQ+cFyXwYPV3oNHlbfzTaYYdqdO3tpOY4SqYvf1bsO5XR9k+
        13yv9bcgZe2fpweMt9SoXLGALyaaTJbbJdaamI0DyFUUYj1/phgMeShYkL4e5X3gCcUCzIdjIYyuf
        5ahZENPumpM4N0wbn4+hx/e4Fceou9AteHK01nhOEYzvQKsFb3DKyYoTBsxFClyAFkTfe6PhAfV+E
        WBu8qq27ETthbKi7Vayt5Ghoj7Z2i5ktIHpABzYMiWzAkMImR28+QQ9BC+G3496OTatSh+PAUQv/K
        w23HmGbA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oJD2j-002k6O-77
        for fio@vger.kernel.org; Wed, 03 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 8EBA51BC0162; Wed,  3 Aug 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220803120001.8EBA51BC0162@kernel.dk>
Date:   Wed,  3 Aug 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 55037c4839c65612fa388ae937e63661d8192ed9:

  t/io_uring: switch to GiB/sec if numbers get large (2022-07-31 12:06:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7006d70c7c8b9a39cf3dfdd839d1975295c10527:

  Merge branch 'io_uring-numa' (2022-08-02 10:20:31 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      t/io_uring: support NUMA placement
      Merge branch 'io_uring-numa'

 t/io_uring.c | 446 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 252 insertions(+), 194 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 335a06ed..35bf1956 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -11,6 +11,10 @@
 #include <libaio.h>
 #endif
 
+#ifdef CONFIG_LIBNUMA
+#include <numa.h>
+#endif
+
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
@@ -100,6 +104,9 @@ struct submitter {
 	io_context_t aio_ctx;
 #endif
 
+	int numa_node;
+	const char *filename;
+
 	struct file files[MAX_FDS];
 	unsigned nr_files;
 	unsigned cur_file;
@@ -110,6 +117,7 @@ static struct submitter *submitter;
 static volatile int finish;
 static int stats_running;
 static unsigned long max_iops;
+static long page_size;
 
 static int depth = DEPTH;
 static int batch_submit = BATCH_SUBMIT;
@@ -130,6 +138,7 @@ static int runtime = 0;		/* runtime */
 static int random_io = 1;	/* random or sequential IO */
 static int register_ring = 1;	/* register ring */
 static int use_sync = 0;	/* use preadv2 */
+static int numa_placement = 0;	/* set to node of device */
 
 static unsigned long tsc_rate;
 
@@ -611,12 +620,191 @@ static int reap_events_uring(struct submitter *s)
 	return reaped;
 }
 
+static void set_affinity(struct submitter *s)
+{
+#ifdef CONFIG_LIBNUMA
+	struct bitmask *mask;
+
+	if (s->numa_node == -1)
+		return;
+
+	numa_set_preferred(s->numa_node);
+
+	mask = numa_allocate_cpumask();
+	numa_node_to_cpus(s->numa_node, mask);
+	numa_sched_setaffinity(s->tid, mask);
+#endif
+}
+
+static int detect_node(struct submitter *s, const char *name)
+{
+#ifdef CONFIG_LIBNUMA
+	const char *base = basename(name);
+	char str[128];
+	int ret, fd, node;
+
+	sprintf(str, "/sys/block/%s/device/numa_node", base);
+	fd = open(str, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	ret = read(fd, str, sizeof(str));
+	if (ret < 0) {
+		close(fd);
+		return -1;
+	}
+	node = atoi(str);
+	s->numa_node = node;
+	close(fd);
+#else
+	s->numa_node = -1;
+#endif
+	return 0;
+}
+
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
+	return io_queue_init(roundup_pow2(depth), &s->aio_ctx);
+#else
+	fprintf(stderr, "Legacy AIO not available on this system/build\n");
+	errno = EINVAL;
+	return -1;
+#endif
+}
+
+static int setup_ring(struct submitter *s)
+{
+	struct io_sq_ring *sring = &s->sq_ring;
+	struct io_cq_ring *cring = &s->cq_ring;
+	struct io_uring_params p;
+	int ret, fd;
+	void *ptr;
+
+	memset(&p, 0, sizeof(p));
+
+	if (polled && !do_nop)
+		p.flags |= IORING_SETUP_IOPOLL;
+	if (sq_thread_poll) {
+		p.flags |= IORING_SETUP_SQPOLL;
+		if (sq_thread_cpu != -1) {
+			p.flags |= IORING_SETUP_SQ_AFF;
+			p.sq_thread_cpu = sq_thread_cpu;
+		}
+	}
+
+	fd = io_uring_setup(depth, &p);
+	if (fd < 0) {
+		perror("io_uring_setup");
+		return 1;
+	}
+	s->ring_fd = s->enter_ring_fd = fd;
+
+	io_uring_probe(fd);
+
+	if (fixedbufs) {
+		struct rlimit rlim;
+
+		rlim.rlim_cur = RLIM_INFINITY;
+		rlim.rlim_max = RLIM_INFINITY;
+		/* ignore potential error, not needed on newer kernels */
+		setrlimit(RLIMIT_MEMLOCK, &rlim);
+
+		ret = io_uring_register_buffers(s);
+		if (ret < 0) {
+			perror("io_uring_register_buffers");
+			return 1;
+		}
+
+		if (dma_map) {
+			ret = io_uring_map_buffers(s);
+			if (ret < 0) {
+				perror("io_uring_map_buffers");
+				return 1;
+			}
+		}
+	}
+
+	if (register_files) {
+		ret = io_uring_register_files(s);
+		if (ret < 0) {
+			perror("io_uring_register_files");
+			return 1;
+		}
+	}
+
+	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(__u32),
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
+			IORING_OFF_SQ_RING);
+	sring->head = ptr + p.sq_off.head;
+	sring->tail = ptr + p.sq_off.tail;
+	sring->ring_mask = ptr + p.sq_off.ring_mask;
+	sring->ring_entries = ptr + p.sq_off.ring_entries;
+	sring->flags = ptr + p.sq_off.flags;
+	sring->array = ptr + p.sq_off.array;
+	sq_ring_mask = *sring->ring_mask;
+
+	s->sqes = mmap(0, p.sq_entries * sizeof(struct io_uring_sqe),
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
+			IORING_OFF_SQES);
+
+	ptr = mmap(0, p.cq_off.cqes + p.cq_entries * sizeof(struct io_uring_cqe),
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
+			IORING_OFF_CQ_RING);
+	cring->head = ptr + p.cq_off.head;
+	cring->tail = ptr + p.cq_off.tail;
+	cring->ring_mask = ptr + p.cq_off.ring_mask;
+	cring->ring_entries = ptr + p.cq_off.ring_entries;
+	cring->cqes = ptr + p.cq_off.cqes;
+	cq_ring_mask = *cring->ring_mask;
+	return 0;
+}
+
+static void *allocate_mem(struct submitter *s, int size)
+{
+	void *buf;
+
+#ifdef CONFIG_LIBNUMA
+	if (s->numa_node != -1)
+		return numa_alloc_onnode(size, s->numa_node);
+#endif
+
+	if (posix_memalign(&buf, page_size, bs)) {
+		printf("failed alloc\n");
+		return NULL;
+	}
+
+	return buf;
+}
+
 static int submitter_init(struct submitter *s)
 {
-	int i, nr_batch;
+	int i, nr_batch, err;
+	static int init_printed;
+	char buf[80];
 
 	s->tid = gettid();
-	printf("submitter=%d, tid=%d\n", s->index, s->tid);
+	printf("submitter=%d, tid=%d, file=%s, node=%d\n", s->index, s->tid,
+							s->filename, s->numa_node);
+
+	set_affinity(s);
 
 	__init_rand64(&s->rand_state, pthread_self());
 	srand48(pthread_self());
@@ -624,6 +812,37 @@ static int submitter_init(struct submitter *s)
 	for (i = 0; i < MAX_FDS; i++)
 		s->files[i].fileno = i;
 
+	for (i = 0; i < roundup_pow2(depth); i++) {
+		void *buf;
+
+		buf = allocate_mem(s, bs);
+		if (!buf)
+			return 1;
+		s->iovecs[i].iov_base = buf;
+		s->iovecs[i].iov_len = bs;
+	}
+
+	if (use_sync) {
+		sprintf(buf, "Engine=preadv2\n");
+		err = 0;
+	} else if (!aio) {
+		err = setup_ring(s);
+		sprintf(buf, "Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
+	} else {
+		sprintf(buf, "Engine=aio\n");
+		err = setup_aio(s);
+	}
+	if (err) {
+		printf("queue setup failed: %s, %d\n", strerror(errno), err);
+		return 1;
+	}
+
+	if (!init_printed) {
+		printf("polled=%d, fixedbufs=%d/%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, dma_map, register_files, buffered, depth);
+		printf("%s", buf);
+		init_printed = 1;
+	}
+
 	if (stats) {
 		nr_batch = roundup_pow2(depth / batch_submit);
 		if (nr_batch < 2)
@@ -1026,15 +1245,21 @@ static struct submitter *get_submitter(int offset)
 static void do_finish(const char *reason)
 {
 	int j;
+
 	printf("Exiting on %s\n", reason);
 	for (j = 0; j < nthreads; j++) {
 		struct submitter *s = get_submitter(j);
 		s->finish = 1;
 	}
-	if (max_iops > 100000)
-		printf("Maximum IOPS=%luK\n", max_iops / 1000);
-	else if (max_iops)
+	if (max_iops > 1000000) {
+		double miops = (double) max_iops / 1000000.0;
+		printf("Maximum IOPS=%.2fM\n", miops);
+	} else if (max_iops > 100000) {
+		double kiops = (double) max_iops / 1000.0;
+		printf("Maximum IOPS=%.2fK\n", kiops);
+	} else {
 		printf("Maximum IOPS=%lu\n", max_iops);
+	}
 	finish = 1;
 }
 
@@ -1058,144 +1283,6 @@ static void arm_sig_int(void)
 #endif
 }
 
-static int setup_aio(struct submitter *s)
-{
-#ifdef CONFIG_LIBAIO
-	if (polled) {
-		fprintf(stderr, "aio does not support polled IO\n");
-		polled = 0;
-	}
-	if (sq_thread_poll) {
-		fprintf(stderr, "aio does not support SQPOLL IO\n");
-		sq_thread_poll = 0;
-	}
-	if (do_nop) {
-		fprintf(stderr, "aio does not support polled IO\n");
-		do_nop = 0;
-	}
-	if (fixedbufs || register_files) {
-		fprintf(stderr, "aio does not support registered files or buffers\n");
-		fixedbufs = register_files = 0;
-	}
-
-	return io_queue_init(roundup_pow2(depth), &s->aio_ctx);
-#else
-	fprintf(stderr, "Legacy AIO not available on this system/build\n");
-	errno = EINVAL;
-	return -1;
-#endif
-}
-
-static int setup_ring(struct submitter *s)
-{
-	struct io_sq_ring *sring = &s->sq_ring;
-	struct io_cq_ring *cring = &s->cq_ring;
-	struct io_uring_params p;
-	int ret, fd;
-	void *ptr;
-
-	memset(&p, 0, sizeof(p));
-
-	if (polled && !do_nop)
-		p.flags |= IORING_SETUP_IOPOLL;
-	if (sq_thread_poll) {
-		p.flags |= IORING_SETUP_SQPOLL;
-		if (sq_thread_cpu != -1) {
-			p.flags |= IORING_SETUP_SQ_AFF;
-			p.sq_thread_cpu = sq_thread_cpu;
-		}
-	}
-
-	fd = io_uring_setup(depth, &p);
-	if (fd < 0) {
-		perror("io_uring_setup");
-		return 1;
-	}
-	s->ring_fd = s->enter_ring_fd = fd;
-
-	io_uring_probe(fd);
-
-	if (fixedbufs) {
-		struct rlimit rlim;
-
-		rlim.rlim_cur = RLIM_INFINITY;
-		rlim.rlim_max = RLIM_INFINITY;
-		/* ignore potential error, not needed on newer kernels */
-		setrlimit(RLIMIT_MEMLOCK, &rlim);
-
-		ret = io_uring_register_buffers(s);
-		if (ret < 0) {
-			perror("io_uring_register_buffers");
-			return 1;
-		}
-
-		if (dma_map) {
-			ret = io_uring_map_buffers(s);
-			if (ret < 0) {
-				perror("io_uring_map_buffers");
-				return 1;
-			}
-		}
-	}
-
-	if (register_files) {
-		ret = io_uring_register_files(s);
-		if (ret < 0) {
-			perror("io_uring_register_files");
-			return 1;
-		}
-	}
-
-	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(__u32),
-			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
-			IORING_OFF_SQ_RING);
-	sring->head = ptr + p.sq_off.head;
-	sring->tail = ptr + p.sq_off.tail;
-	sring->ring_mask = ptr + p.sq_off.ring_mask;
-	sring->ring_entries = ptr + p.sq_off.ring_entries;
-	sring->flags = ptr + p.sq_off.flags;
-	sring->array = ptr + p.sq_off.array;
-	sq_ring_mask = *sring->ring_mask;
-
-	s->sqes = mmap(0, p.sq_entries * sizeof(struct io_uring_sqe),
-			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
-			IORING_OFF_SQES);
-
-	ptr = mmap(0, p.cq_off.cqes + p.cq_entries * sizeof(struct io_uring_cqe),
-			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
-			IORING_OFF_CQ_RING);
-	cring->head = ptr + p.cq_off.head;
-	cring->tail = ptr + p.cq_off.tail;
-	cring->ring_mask = ptr + p.cq_off.ring_mask;
-	cring->ring_entries = ptr + p.cq_off.ring_entries;
-	cring->cqes = ptr + p.cq_off.cqes;
-	cq_ring_mask = *cring->ring_mask;
-	return 0;
-}
-
-static void file_depths(char *buf)
-{
-	bool prev = false;
-	char *p;
-	int i, j;
-
-	buf[0] = '\0';
-	p = buf;
-	for (j = 0; j < nthreads; j++) {
-		struct submitter *s = get_submitter(j);
-
-		for (i = 0; i < s->nr_files; i++) {
-			struct file *f = &s->files[i];
-
-			if (prev)
-				p += sprintf(p, " %d", f->pending_ios);
-			else
-				p += sprintf(p, "%d", f->pending_ios);
-			prev = true;
-		}
-	}
-}
-
 static void usage(char *argv, int status)
 {
 	char runtime_str[16];
@@ -1218,11 +1305,12 @@ static void usage(char *argv, int status)
 		" -R <bool> : Use random IO, default %d\n"
 		" -a <bool> : Use legacy aio, default %d\n"
 		" -S <bool> : Use sync IO (preadv2), default %d\n"
-		" -X <bool> : Use registered ring %d\n",
+		" -X <bool> : Use registered ring %d\n"
+		" -P <bool> : Automatically place on device home node %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
 		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
-		use_sync, register_ring);
+		use_sync, register_ring, numa_placement);
 	exit(status);
 }
 
@@ -1274,16 +1362,14 @@ int main(int argc, char *argv[])
 {
 	struct submitter *s;
 	unsigned long done, calls, reap;
-	int err, i, j, flags, fd, opt, threads_per_f, threads_rem = 0, nfiles;
-	long page_size;
+	int i, j, flags, fd, opt, threads_per_f, threads_rem = 0, nfiles;
 	struct file f;
-	char *fdepths;
 	void *ret;
 
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1361,6 +1447,9 @@ int main(int argc, char *argv[])
 			exit(1);
 #endif
 			break;
+		case 'P':
+			numa_placement = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -1383,6 +1472,7 @@ int main(int argc, char *argv[])
 				roundup_pow2(depth) * sizeof(struct iovec));
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
+		s->numa_node = -1;
 		s->index = j;
 		s->done = s->calls = s->reaps = 0;
 	}
@@ -1440,7 +1530,10 @@ int main(int argc, char *argv[])
 
 			memcpy(&s->files[s->nr_files], &f, sizeof(f));
 
-			printf("Added file %s (submitter %d)\n", argv[i], s->index);
+			if (numa_placement)
+				detect_node(s, argv[i]);
+
+			s->filename = argv[i];
 			s->nr_files++;
 		}
 		threads_rem--;
@@ -1454,43 +1547,6 @@ int main(int argc, char *argv[])
 	if (page_size < 0)
 		page_size = 4096;
 
-	for (j = 0; j < nthreads; j++) {
-		s = get_submitter(j);
-		for (i = 0; i < roundup_pow2(depth); i++) {
-			void *buf;
-
-			if (posix_memalign(&buf, page_size, bs)) {
-				printf("failed alloc\n");
-				return 1;
-			}
-			s->iovecs[i].iov_base = buf;
-			s->iovecs[i].iov_len = bs;
-		}
-	}
-
-	for (j = 0; j < nthreads; j++) {
-		s = get_submitter(j);
-
-		if (use_sync)
-			continue;
-		else if (!aio)
-			err = setup_ring(s);
-		else
-			err = setup_aio(s);
-		if (err) {
-			printf("ring setup failed: %s, %d\n", strerror(errno), err);
-			return 1;
-		}
-	}
-	s = get_submitter(0);
-	printf("polled=%d, fixedbufs=%d/%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, dma_map, register_files, buffered, depth);
-	if (use_sync)
-		printf("Engine=preadv2\n");
-	else if (!aio)
-		printf("Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
-	else
-		printf("Engine=aio\n");
-
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
 		if (use_sync)
@@ -1503,7 +1559,6 @@ int main(int argc, char *argv[])
 #endif
 	}
 
-	fdepths = malloc(8 * s->nr_files * nthreads);
 	reap = calls = done = 0;
 	do {
 		unsigned long this_done = 0;
@@ -1535,16 +1590,20 @@ int main(int argc, char *argv[])
 			ipc = (this_reap - reap) / (this_call - calls);
 		} else
 			rpc = ipc = -1;
-		file_depths(fdepths);
 		iops = this_done - done;
 		if (bs > 1048576)
 			bw = iops * (bs / 1048576);
 		else
 			bw = iops / (1048576 / bs);
-		if (iops > 100000)
-			printf("IOPS=%luK, ", iops / 1000);
-		else
+		if (iops > 1000000) {
+			double miops = (double) iops / 1000000.0;
+			printf("IOPS=%.2fM, ", miops);
+		} else if (iops > 100000) {
+			double kiops = (double) iops / 1000.0;
+			printf("IOPS=%.2fK, ", kiops);
+		} else {
 			printf("IOPS=%lu, ", iops);
+		}
 		max_iops = max(max_iops, iops);
 		if (!do_nop) {
 			if (bw > 2000) {
@@ -1555,7 +1614,7 @@ int main(int argc, char *argv[])
 				printf("BW=%luMiB/s, ", bw);
 			}
 		}
-		printf("IOS/call=%ld/%ld, inflight=(%s)\n", rpc, ipc, fdepths);
+		printf("IOS/call=%ld/%ld\n", rpc, ipc);
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;
@@ -1578,7 +1637,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	free(fdepths);
 	free(submitter);
 	return 0;
 }
