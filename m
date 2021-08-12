Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbhHLMAf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Aug 2021 08:00:35 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103CAC061765
        for <fio@vger.kernel.org>; Thu, 12 Aug 2021 05:00:10 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE9NW-008Q7D-2u
        for fio@vger.kernel.org; Thu, 12 Aug 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210812120002.36A581BC0167@kernel.dk>
Date: Thu, 12 Aug 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit faff87e6f0da68853908652a95f0ec40dd12869d:

  t/zbd: Add test #58 to test zone reset by trim workload (2021-08-06 16:39:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 543196617ce45b6a04fb039a3b9c6d06c9b58309:

  t/io_uring: allow multiple IO threads (2021-08-11 16:57:19 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: allow multiple IO threads

 t/io_uring.c | 115 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 33 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index ff4c7a7c..538cc7d4 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -62,6 +62,7 @@ struct file {
 struct submitter {
 	pthread_t thread;
 	int ring_fd;
+	int index;
 	struct io_sq_ring sq_ring;
 	struct io_uring_sqe *sqes;
 	struct io_cq_ring cq_ring;
@@ -93,6 +94,7 @@ static int buffered = 0;	/* use buffered IO, not O_DIRECT */
 static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
 static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
 static int do_nop = 0;		/* no-op SQ ring commands */
+static int nthreads = 1;
 
 static int vectored = 1;
 
@@ -404,10 +406,25 @@ submit:
 	return NULL;
 }
 
+static struct submitter *get_submitter(int offset)
+{
+	void *ret;
+
+	ret = submitter;
+	if (offset)
+		ret += offset * (sizeof(*submitter) + depth * sizeof(struct iovec));
+	return ret;
+}
+
 static void sig_int(int sig)
 {
+	int j;
+
 	printf("Exiting on signal %d\n", sig);
-	submitter->finish = 1;
+	for (j = 0; j < nthreads; j++) {
+		struct submitter *s = get_submitter(j);
+		s->finish = 1;
+	}
 	finish = 1;
 }
 
@@ -498,19 +515,22 @@ static int setup_ring(struct submitter *s)
 
 static void file_depths(char *buf)
 {
-	struct submitter *s = submitter;
 	char *p;
-	int i;
+	int i, j;
 
 	buf[0] = '\0';
 	p = buf;
-	for (i = 0; i < s->nr_files; i++) {
-		struct file *f = &s->files[i];
+	for (j = 0; j < nthreads; j++) {
+		struct submitter *s = get_submitter(j);
 
-		if (i + 1 == s->nr_files)
-			p += sprintf(p, "%d", f->pending_ios);
-		else
-			p += sprintf(p, "%d, ", f->pending_ios);
+		for (i = 0; i < s->nr_files; i++) {
+			struct file *f = &s->files[i];
+
+			if (i + 1 == s->nr_files)
+				p += sprintf(p, "%d", f->pending_ios);
+			else
+				p += sprintf(p, "%d, ", f->pending_ios);
+		}
 	}
 }
 
@@ -530,7 +550,7 @@ int main(int argc, char *argv[])
 {
 	struct submitter *s;
 	unsigned long done, calls, reap;
-	int err, i, flags, fd, opt;
+	int err, i, j, flags, fd, opt;
 	char *fdepths;
 	void *ret;
 
@@ -539,7 +559,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:h?")) != -1) {
 		switch (opt) {
 		case 'd':
 			depth = atoi(optarg);
@@ -562,6 +582,9 @@ int main(int argc, char *argv[])
 		case 'F':
 			register_files = !!atoi(optarg);
 			break;
+		case 'n':
+			nthreads = atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -570,18 +593,25 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	submitter = malloc(sizeof(*submitter) + depth * sizeof(struct iovec));
-	memset(submitter, 0, sizeof(*submitter) + depth * sizeof(struct iovec));
-	s = submitter;
+	submitter = calloc(nthreads, sizeof(*submitter) +
+				depth * sizeof(struct iovec));
+	for (j = 0; j < nthreads; j++) {
+		s = get_submitter(j);
+		s->index = j;
+		s->done = s->calls = s->reaps = 0;
+	}
 
 	flags = O_RDONLY | O_NOATIME;
 	if (!buffered)
 		flags |= O_DIRECT;
 
+	j = 0;
 	i = optind;
+	printf("i %d, argc %d\n", i, argc);
 	while (!do_nop && i < argc) {
 		struct file *f;
 
+		s = get_submitter(j);
 		if (s->nr_files == MAX_FDS) {
 			printf("Max number of files (%d) reached\n", MAX_FDS);
 			break;
@@ -604,9 +634,11 @@ int main(int argc, char *argv[])
 		}
 		f->max_blocks--;
 
-		printf("Added file %s\n", argv[i]);
+		printf("Added file %s (submitter %d)\n", argv[i], s->index);
 		s->nr_files++;
 		i++;
+		if (++j >= nthreads)
+			j = 0;
 	}
 
 	if (fixedbufs) {
@@ -622,28 +654,39 @@ int main(int argc, char *argv[])
 
 	arm_sig_int();
 
-	for (i = 0; i < depth; i++) {
-		void *buf;
+	for (j = 0; j < nthreads; j++) {
+		s = get_submitter(j);
+		for (i = 0; i < depth; i++) {
+			void *buf;
 
-		if (posix_memalign(&buf, bs, bs)) {
-			printf("failed alloc\n");
-			return 1;
+			if (posix_memalign(&buf, bs, bs)) {
+				printf("failed alloc\n");
+				return 1;
+			}
+			s->iovecs[i].iov_base = buf;
+			s->iovecs[i].iov_len = bs;
 		}
-		s->iovecs[i].iov_base = buf;
-		s->iovecs[i].iov_len = bs;
 	}
 
-	err = setup_ring(s);
-	if (err) {
-		printf("ring setup failed: %s, %d\n", strerror(errno), err);
-		return 1;
+	for (j = 0; j < nthreads; j++) {
+		s = get_submitter(j);
+
+		err = setup_ring(s);
+		if (err) {
+			printf("ring setup failed: %s, %d\n", strerror(errno), err);
+			return 1;
+		}
 	}
+	s = get_submitter(0);
 	printf("polled=%d, fixedbufs=%d, register_files=%d, buffered=%d", polled, fixedbufs, register_files, buffered);
 	printf(" QD=%d, sq_ring=%d, cq_ring=%d\n", depth, *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
 
-	pthread_create(&s->thread, NULL, submitter_fn, s);
+	for (j = 0; j < nthreads; j++) {
+		s = get_submitter(j);
+		pthread_create(&s->thread, NULL, submitter_fn, s);
+	}
 
-	fdepths = malloc(8 * s->nr_files);
+	fdepths = malloc(8 * s->nr_files * nthreads);
 	reap = calls = done = 0;
 	do {
 		unsigned long this_done = 0;
@@ -652,9 +695,11 @@ int main(int argc, char *argv[])
 		unsigned long rpc = 0, ipc = 0;
 
 		sleep(1);
-		this_done += s->done;
-		this_call += s->calls;
-		this_reap += s->reaps;
+		for (j = 0; j < nthreads; j++) {
+			this_done += s->done;
+			this_call += s->calls;
+			this_reap += s->reaps;
+		}
 		if (this_call - calls) {
 			rpc = (this_done - done) / (this_call - calls);
 			ipc = (this_reap - reap) / (this_call - calls);
@@ -669,8 +714,12 @@ int main(int argc, char *argv[])
 		reap = this_reap;
 	} while (!finish);
 
-	pthread_join(s->thread, &ret);
-	close(s->ring_fd);
+	for (j = 0; j < nthreads; j++) {
+		s = get_submitter(j);
+		pthread_join(s->thread, &ret);
+		close(s->ring_fd);
+	}
 	free(fdepths);
+	free(submitter);
 	return 0;
 }

