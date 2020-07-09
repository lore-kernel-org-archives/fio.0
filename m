Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgGIMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Jul 2020 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF820C061A0B
        for <fio@vger.kernel.org>; Thu,  9 Jul 2020 05:00:08 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtVDh-0005d3-Tl
        for fio@vger.kernel.org; Thu, 09 Jul 2020 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200709120002.1D9871BC0181@kernel.dk>
Date: Thu,  9 Jul 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 430083bf2a3db52bcb374919140d3a978391fbf0:

  Merge branch 'windows' of https://github.com/bvanassche/fio (2020-07-04 17:29:32 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5bd526f2a614e75a929906c91a5fa3bab293d319:

  t/io_uring: make bs and polled IO configurable at runtime (2020-07-08 15:48:11 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: make bs and polled IO configurable at runtime

 t/io_uring.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index d48db1e9..7fa84f99 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -46,7 +46,6 @@ struct io_cq_ring {
 #define DEPTH			128
 #define BATCH_SUBMIT		32
 #define BATCH_COMPLETE		32
-
 #define BS			4096
 
 #define MAX_FDS			16
@@ -86,6 +85,7 @@ static volatile int finish;
 static int depth = DEPTH;
 static int batch_submit = BATCH_SUBMIT;
 static int batch_complete = BATCH_COMPLETE;
+static int bs = BS;
 static int polled = 1;		/* use IO polling */
 static int fixedbufs = 1;	/* use fixed user buffers */
 static int register_files = 1;	/* use fixed files */
@@ -170,7 +170,7 @@ static void init_io(struct submitter *s, unsigned index)
 	f->pending_ios++;
 
 	r = lrand48();
-	offset = (r % (f->max_blocks - 1)) * BS;
+	offset = (r % (f->max_blocks - 1)) * bs;
 
 	if (register_files) {
 		sqe->flags = IOSQE_FIXED_FILE;
@@ -182,7 +182,7 @@ static void init_io(struct submitter *s, unsigned index)
 	if (fixedbufs) {
 		sqe->opcode = IORING_OP_READ_FIXED;
 		sqe->addr = (unsigned long) s->iovecs[index].iov_base;
-		sqe->len = BS;
+		sqe->len = bs;
 		sqe->buf_index = index;
 	} else {
 		sqe->opcode = IORING_OP_READV;
@@ -233,10 +233,10 @@ static int get_file_size(struct file *f)
 		if (ioctl(f->real_fd, BLKGETSIZE64, &bytes) != 0)
 			return -1;
 
-		f->max_blocks = bytes / BS;
+		f->max_blocks = bytes / bs;
 		return 0;
 	} else if (S_ISREG(st.st_mode)) {
-		f->max_blocks = st.st_size / BS;
+		f->max_blocks = st.st_size / bs;
 		return 0;
 	}
 
@@ -260,7 +260,7 @@ static int reap_events(struct submitter *s)
 		if (!do_nop) {
 			f = (struct file *) (uintptr_t) cqe->user_data;
 			f->pending_ios--;
-			if (cqe->res != BS) {
+			if (cqe->res != bs) {
 				printf("io: unexpected ret=%d\n", cqe->res);
 				if (polled && cqe->res == -EOPNOTSUPP)
 					printf("Your filesystem/driver/kernel doesn't support polled IO\n");
@@ -483,8 +483,10 @@ static void usage(char *argv)
 	printf("%s [options] -- [filenames]\n"
 		" -d <int> : IO Depth, default %d\n"
 		" -s <int> : Batch submit, default %d\n"
-		" -c <int> : Batch complete, default %d\n",
-		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE);
+		" -c <int> : Batch complete, default %d\n"
+		" -b <int> : Block size, default %d\n"
+		" -p <bool> : Polled IO, default %d\n",
+		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled);
 	exit(0);
 }
 
@@ -501,7 +503,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	while ((opt = getopt(argc, argv, "d:s:c:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:h?")) != -1) {
 		switch (opt) {
 		case 'd':
 			depth = atoi(optarg);
@@ -512,6 +514,12 @@ int main(int argc, char *argv[])
 		case 'c':
 			batch_complete = atoi(optarg);
 			break;
+		case 'b':
+			bs = atoi(optarg);
+			break;
+		case 'p':
+			polled = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -575,12 +583,12 @@ int main(int argc, char *argv[])
 	for (i = 0; i < depth; i++) {
 		void *buf;
 
-		if (posix_memalign(&buf, BS, BS)) {
+		if (posix_memalign(&buf, bs, bs)) {
 			printf("failed alloc\n");
 			return 1;
 		}
 		s->iovecs[i].iov_base = buf;
-		s->iovecs[i].iov_len = BS;
+		s->iovecs[i].iov_len = bs;
 	}
 
 	err = setup_ring(s);

