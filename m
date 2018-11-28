Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60522 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbeK2ACA (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Nov 2018 19:02:00 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gRzS5-0001xJ-6G
        for fio@vger.kernel.org; Wed, 28 Nov 2018 13:00:25 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181128130002.0C7FE2C0119@kernel.dk>
Date: Wed, 28 Nov 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4cf30b66c62f3f5e6501390d564cf0d966823591:

  workqueue: update IO counters promptly after handling IO (2018-11-26 09:16:52 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c36210b443a37c53978bbea88f1dabb0b61799d7:

  engines/libaio: use maximum buffer size for fixed user bufs (2018-11-27 19:43:30 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      engines/libaio: add preliminary support for pre-mapped IO buffers
      engines/libaio: use maximum buffer size for fixed user bufs

 backend.c        |  3 +++
 engines/libaio.c | 73 ++++++++++++++++++++++++++++++++++++++++----------------
 ioengines.h      |  3 ++-
 3 files changed, 57 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 2f103b3..2f46329 100644
--- a/backend.c
+++ b/backend.c
@@ -1704,6 +1704,9 @@ static void *thread_main(void *data)
 	if (init_io_u(td))
 		goto err;
 
+	if (td->io_ops->post_init && td->io_ops->post_init(td))
+		goto err;
+
 	if (o->verify_async && verify_async_init(td))
 		goto err;
 
diff --git a/engines/libaio.c b/engines/libaio.c
index 74238e4..d386d14 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -24,6 +24,9 @@
 #ifndef IOCTX_FLAG_IOPOLL
 #define IOCTX_FLAG_IOPOLL	(1 << 1)
 #endif
+#ifndef IOCTX_FLAG_FIXEDBUFS
+#define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
+#endif
 
 static int fio_libaio_commit(struct thread_data *td);
 
@@ -56,6 +59,7 @@ struct libaio_options {
 	unsigned int userspace_reap;
 	unsigned int hipri;
 	unsigned int useriocb;
+	unsigned int fixedbufs;
 };
 
 static struct fio_option options[] = {
@@ -87,6 +91,15 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_LIBAIO,
 	},
 	{
+		.name	= "fixedbufs",
+		.lname	= "Fixed (pre-mapped) IO buffers",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct libaio_options, fixedbufs),
+		.help	= "Pre map IO buffers",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -399,7 +412,7 @@ static void fio_libaio_cleanup(struct thread_data *td)
 }
 
 static int fio_libaio_old_queue_init(struct libaio_data *ld, unsigned int depth,
-				     bool hipri, bool useriocb)
+				     bool hipri, bool useriocb, bool fixedbufs)
 {
 	if (hipri) {
 		log_err("fio: polled aio not available on your platform\n");
@@ -409,12 +422,16 @@ static int fio_libaio_old_queue_init(struct libaio_data *ld, unsigned int depth,
 		log_err("fio: user mapped iocbs not available on your platform\n");
 		return 1;
 	}
+	if (fixedbufs) {
+		log_err("fio: fixed buffers not available on your platform\n");
+		return 1;
+	}
 
 	return io_queue_init(depth, &ld->aio_ctx);
 }
 
 static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
-				 bool hipri, bool useriocb)
+				 bool hipri, bool useriocb, bool fixedbufs)
 {
 #ifdef __NR_sys_io_setup2
 	int ret, flags = 0;
@@ -423,6 +440,8 @@ static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
 		flags |= IOCTX_FLAG_IOPOLL;
 	if (useriocb)
 		flags |= IOCTX_FLAG_USERIOCB;
+	if (fixedbufs)
+		flags |= IOCTX_FLAG_FIXEDBUFS;
 
 	ret = syscall(__NR_sys_io_setup2, depth, flags, ld->user_iocbs,
 			&ld->aio_ctx);
@@ -430,14 +449,42 @@ static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
 		return 0;
 	/* fall through to old syscall */
 #endif
-	return fio_libaio_old_queue_init(ld, depth, hipri, useriocb);
+	return fio_libaio_old_queue_init(ld, depth, hipri, useriocb, fixedbufs);
+}
+
+static int fio_libaio_post_init(struct thread_data *td)
+{
+	struct libaio_data *ld = td->io_ops_data;
+	struct libaio_options *o = td->eo;
+	struct io_u *io_u;
+	struct iocb *iocb;
+	int err = 0;
+
+	if (o->fixedbufs) {
+		int i;
+
+		for (i = 0; i < td->o.iodepth; i++) {
+			io_u = ld->io_u_index[i];
+			iocb = &ld->user_iocbs[i];
+			iocb->u.c.buf = io_u->buf;
+			iocb->u.c.nbytes = td_max_bs(td);
+		}
+	}
+
+	err = fio_libaio_queue_init(ld, td->o.iodepth, o->hipri, o->useriocb,
+					o->fixedbufs);
+	if (err) {
+		td_verror(td, -err, "io_queue_init");
+		return 1;
+	}
+
+	return 0;
 }
 
 static int fio_libaio_init(struct thread_data *td)
 {
 	struct libaio_options *o = td->eo;
 	struct libaio_data *ld;
-	int err = 0;
 
 	ld = calloc(1, sizeof(*ld));
 
@@ -450,23 +497,6 @@ static int fio_libaio_init(struct thread_data *td)
 		memset(ld->user_iocbs, 0, size);
 	}
 
-	/*
-	 * First try passing in 0 for queue depth, since we don't
-	 * care about the user ring. If that fails, the kernel is too old
-	 * and we need the right depth.
-	 */
-	err = fio_libaio_queue_init(ld, td->o.iodepth, o->hipri, o->useriocb);
-	if (err) {
-		td_verror(td, -err, "io_queue_init");
-		log_err("fio: check /proc/sys/fs/aio-max-nr\n");
-		if (ld->user_iocbs) {
-			size_t size = td->o.iodepth * sizeof(struct iocb);
-			fio_memfree(ld->user_iocbs, size, false);
-		}
-		free(ld);
-		return 1;
-	}
-
 	ld->entries = td->o.iodepth;
 	ld->is_pow2 = is_power_of_2(ld->entries);
 	ld->aio_events = calloc(ld->entries, sizeof(struct io_event));
@@ -494,6 +524,7 @@ static struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.init			= fio_libaio_init,
+	.post_init		= fio_libaio_post_init,
 	.io_u_init		= fio_libaio_io_u_init,
 	.prep			= fio_libaio_prep,
 	.queue			= fio_libaio_queue,
diff --git a/ioengines.h b/ioengines.h
index feb21db..b9cd33d 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -7,7 +7,7 @@
 #include "flist.h"
 #include "io_u.h"
 
-#define FIO_IOOPS_VERSION	24
+#define FIO_IOOPS_VERSION	25
 
 /*
  * io_ops->queue() return values
@@ -25,6 +25,7 @@ struct ioengine_ops {
 	int flags;
 	int (*setup)(struct thread_data *);
 	int (*init)(struct thread_data *);
+	int (*post_init)(struct thread_data *);
 	int (*prep)(struct thread_data *, struct io_u *);
 	enum fio_q_status (*queue)(struct thread_data *, struct io_u *);
 	int (*commit)(struct thread_data *);

