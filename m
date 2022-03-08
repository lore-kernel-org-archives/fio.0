Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36ADC433EF
	for <fio@archiver.kernel.org>; Tue,  8 Mar 2022 13:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347072AbiCHNBJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Mar 2022 08:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243572AbiCHNBG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Mar 2022 08:01:06 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063222C104
        for <fio@vger.kernel.org>; Tue,  8 Mar 2022 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+ByDq+pb1iV1d1qbzytUfFyalzMscDpfzL3dA4Cq3tc=; b=hxn2T3BT2C4JiSNIMRufVmx8xa
        M3RP5nsGPKhx7ZOuWQyJuQ+ajaPuI978ttFE+pG+psA9TvXbumkppAIwRcV49YNq2hPlPey8OJBRx
        /AqrM1qHel2dWKqf+KuVSAQFhxh9mphIavO7+KSlDrXFdxKQ8G62A+/NabuG4FrVCTxC9JBpheGVq
        98lUbeLXzggz9tgef2JhAxljq+ETmrj/3uWsbEsas+l88Vl6XHPi5jxmVC0vEty6PVOR8KGKK+kL8
        rJoSA/XPAnZ5HIRxM9/7Uctz3g1MV74tLcz7XSKgxQhSQ4a5azHtMPqNtsWdEeo/MuVUH1X8RFtnE
        VTpvXFJA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRZRd-00GSwr-3l
        for fio@vger.kernel.org; Tue, 08 Mar 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id BCD3B1BC013A; Tue,  8 Mar 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220308130001.BCD3B1BC013A@kernel.dk>
Date:   Tue,  8 Mar 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c3773c171dffb79f771d213d94249cefc4b9b6de:

  windowsaio: open file for write if we have syncs (2022-02-26 10:43:20 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dc44588f2e445edd7a4ca7dc9bf05bb3b4b2789e:

  Makefile: get rid of fortify source (2022-03-07 09:16:39 -0700)

----------------------------------------------------------------
Jens Axboe (7):
      t/io_uring: change map buffers registration opcode
      t/io_uring: change fatal map buffers condition with multiple files
      io_uring.h: sync with 5.18 kernel bits
      t/io_uring: add support for registering the ring fd
      t/io_uring: support using preadv2
      t/io_uring: add missing CR
      Makefile: get rid of fortify source

 Makefile            |   2 +-
 os/linux/io_uring.h |  17 ++++--
 t/io_uring.c        | 148 ++++++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 147 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 0ab4f82c..6ffd3d13 100644
--- a/Makefile
+++ b/Makefile
@@ -28,7 +28,7 @@ PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/hist/fio-histo-log-pctiles.py tools/fio_jsonplus_clat2csv)
 
 ifndef CONFIG_FIO_NO_OPT
-  FIO_CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
+  FIO_CFLAGS += -O3
 endif
 ifdef CONFIG_BUILD_NATIVE
   FIO_CFLAGS += -march=native
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index c45b5e9a..42b2fe84 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -70,6 +70,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_CQE_SKIP_SUCCESS_BIT,
 };
 
 /*
@@ -87,6 +88,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* don't post CQE if request succeeded */
+#define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
 
 /*
  * io_uring_setup() flags
@@ -254,10 +257,11 @@ struct io_cqring_offsets {
 /*
  * io_uring_enter(2) flags
  */
-#define IORING_ENTER_GETEVENTS	(1U << 0)
-#define IORING_ENTER_SQ_WAKEUP	(1U << 1)
-#define IORING_ENTER_SQ_WAIT	(1U << 2)
-#define IORING_ENTER_EXT_ARG	(1U << 3)
+#define IORING_ENTER_GETEVENTS		(1U << 0)
+#define IORING_ENTER_SQ_WAKEUP		(1U << 1)
+#define IORING_ENTER_SQ_WAIT		(1U << 2)
+#define IORING_ENTER_EXT_ARG		(1U << 3)
+#define IORING_ENTER_REGISTERED_RING	(1U << 4)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -289,6 +293,7 @@ struct io_uring_params {
 #define IORING_FEAT_EXT_ARG		(1U << 8)
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
+#define IORING_FEAT_CQE_SKIP		(1U << 11)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -321,6 +326,10 @@ enum {
 	/* set/get max number of io-wq workers */
 	IORING_REGISTER_IOWQ_MAX_WORKERS	= 19,
 
+	/* register/unregister io_uring fd with the ring */
+	IORING_REGISTER_RING_FDS		= 20,
+	IORING_UNREGISTER_RING_FDS		= 21,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
diff --git a/t/io_uring.c b/t/io_uring.c
index b8fcffe8..157eea9e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -76,6 +76,7 @@ struct file {
 struct submitter {
 	pthread_t thread;
 	int ring_fd;
+	int enter_ring_fd;
 	int index;
 	struct io_sq_ring sq_ring;
 	struct io_uring_sqe *sqes;
@@ -127,6 +128,8 @@ static int stats = 0;		/* generate IO stats */
 static int aio = 0;		/* use libaio */
 static int runtime = 0;		/* runtime */
 static int random_io = 1;	/* random or sequential IO */
+static int register_ring = 1;	/* register ring */
+static int use_sync = 0;	/* use preadv2 */
 
 static unsigned long tsc_rate;
 
@@ -139,7 +142,7 @@ static float plist[] = { 1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0,
 static int plist_len = 17;
 
 #ifndef IORING_REGISTER_MAP_BUFFERS
-#define IORING_REGISTER_MAP_BUFFERS	20
+#define IORING_REGISTER_MAP_BUFFERS	22
 struct io_uring_map_buffers {
 	__s32	fd;
 	__u32	buf_start;
@@ -349,10 +352,8 @@ static int io_uring_map_buffers(struct submitter *s)
 
 	if (do_nop)
 		return 0;
-	if (s->nr_files > 1) {
-		fprintf(stderr, "Can't map buffers with multiple files\n");
-		return -1;
-	}
+	if (s->nr_files > 1)
+		fprintf(stdout, "Mapping buffers may not work with multiple files\n");
 
 	return syscall(__NR_io_uring_register, s->ring_fd,
 			IORING_REGISTER_MAP_BUFFERS, &map, 1);
@@ -422,12 +423,14 @@ out:
 static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 			  unsigned int min_complete, unsigned int flags)
 {
+	if (register_ring)
+		flags |= IORING_ENTER_REGISTERED_RING;
 #ifdef FIO_ARCH_HAS_SYSCALL
-	return __do_syscall6(__NR_io_uring_enter, s->ring_fd, to_submit,
+	return __do_syscall6(__NR_io_uring_enter, s->enter_ring_fd, to_submit,
 				min_complete, flags, NULL, 0);
 #else
-	return syscall(__NR_io_uring_enter, s->ring_fd, to_submit, min_complete,
-			flags, NULL, 0);
+	return syscall(__NR_io_uring_enter, s->enter_ring_fd, to_submit,
+			min_complete, flags, NULL, 0);
 #endif
 }
 
@@ -795,6 +798,34 @@ static void *submitter_aio_fn(void *data)
 }
 #endif
 
+static void io_uring_unregister_ring(struct submitter *s)
+{
+	struct io_uring_rsrc_update up = {
+		.offset	= s->enter_ring_fd,
+	};
+
+	syscall(__NR_io_uring_register, s->ring_fd, IORING_UNREGISTER_RING_FDS,
+		&up, 1);
+}
+
+static int io_uring_register_ring(struct submitter *s)
+{
+	struct io_uring_rsrc_update up = {
+		.data	= s->ring_fd,
+		.offset	= -1U,
+	};
+	int ret;
+
+	ret = syscall(__NR_io_uring_register, s->ring_fd,
+			IORING_REGISTER_RING_FDS, &up, 1);
+	if (ret == 1) {
+		s->enter_ring_fd = up.offset;
+		return 0;
+	}
+	register_ring = 0;
+	return -1;
+}
+
 static void *submitter_uring_fn(void *data)
 {
 	struct submitter *s = data;
@@ -806,6 +837,9 @@ static void *submitter_uring_fn(void *data)
 	submitter_init(s);
 #endif
 
+	if (register_ring)
+		io_uring_register_ring(s);
+
 	prepped = 0;
 	do {
 		int to_wait, to_submit, this_reap, to_prep;
@@ -898,6 +932,75 @@ submit:
 		}
 	} while (!s->finish);
 
+	if (register_ring)
+		io_uring_unregister_ring(s);
+
+	finish = 1;
+	return NULL;
+}
+
+static void *submitter_sync_fn(void *data)
+{
+	struct submitter *s = data;
+	int ret;
+
+	submitter_init(s);
+
+	do {
+		uint64_t offset;
+		struct file *f;
+		long r;
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
+		if (random_io) {
+			r = __rand64(&s->rand_state);
+			offset = (r % (f->max_blocks - 1)) * bs;
+		} else {
+			offset = f->cur_off;
+			f->cur_off += bs;
+			if (f->cur_off + bs > f->max_size)
+				f->cur_off = 0;
+		}
+
+#ifdef ARCH_HAVE_CPU_CLOCK
+		if (stats)
+			s->clock_batch[s->clock_index] = get_cpu_clock();
+#endif
+
+		s->inflight++;
+		s->calls++;
+
+		if (polled)
+			ret = preadv2(f->real_fd, &s->iovecs[0], 1, offset, RWF_HIPRI);
+		else
+			ret = preadv2(f->real_fd, &s->iovecs[0], 1, offset, 0);
+
+		if (ret < 0) {
+			perror("preadv2");
+			break;
+		} else if (ret != bs) {
+			break;
+		}
+
+		s->done++;
+		s->inflight--;
+		f->pending_ios--;
+		if (stats)
+			add_stat(s, s->clock_index, 1);
+	} while (!s->finish);
+
 	finish = 1;
 	return NULL;
 }
@@ -1000,7 +1103,7 @@ static int setup_ring(struct submitter *s)
 		perror("io_uring_setup");
 		return 1;
 	}
-	s->ring_fd = fd;
+	s->ring_fd = s->enter_ring_fd = fd;
 
 	io_uring_probe(fd);
 
@@ -1105,10 +1208,13 @@ static void usage(char *argv, int status)
 		" -T <int>  : TSC rate in HZ\n"
 		" -r <int>  : Runtime in seconds, default %s\n"
 		" -R <bool> : Use random IO, default %d\n"
-		" -a <bool> : Use legacy aio, default %d\n",
+		" -a <bool> : Use legacy aio, default %d\n"
+		" -S <bool> : Use sync IO (preadv2), default %d\n"
+		" -X <bool> : Use registered ring %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
-		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio);
+		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
+		use_sync, register_ring);
 	exit(status);
 }
 
@@ -1169,7 +1275,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1236,6 +1342,12 @@ int main(int argc, char *argv[])
 		case 'R':
 			random_io = !!atoi(optarg);
 			break;
+		case 'X':
+			register_ring = !!atoi(optarg);
+			break;
+		case 'S':
+			use_sync = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -1346,7 +1458,9 @@ int main(int argc, char *argv[])
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
 
-		if (!aio)
+		if (use_sync)
+			continue;
+		else if (!aio)
 			err = setup_ring(s);
 		else
 			err = setup_aio(s);
@@ -1357,14 +1471,18 @@ int main(int argc, char *argv[])
 	}
 	s = get_submitter(0);
 	printf("polled=%d, fixedbufs=%d/%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, dma_map, register_files, buffered, depth);
-	if (!aio)
+	if (use_sync)
+		printf("Engine=preadv2\n");
+	else if (!aio)
 		printf("Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
 	else
 		printf("Engine=aio\n");
 
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
-		if (!aio)
+		if (use_sync)
+			pthread_create(&s->thread, NULL, submitter_sync_fn, s);
+		else if (!aio)
 			pthread_create(&s->thread, NULL, submitter_uring_fn, s);
 #ifdef CONFIG_LIBAIO
 		else
