Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbeKUXed (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Nov 2018 18:34:33 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gPS76-0006o4-IW
        for fio@vger.kernel.org; Wed, 21 Nov 2018 13:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181121130001.90D1C2C01EB@kernel.dk>
Date: Wed, 21 Nov 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a1b006fe1cd3aa7e1b567f55e5a4c827d54f7c41:

  engines/libaio: fix new aio poll API (2018-11-19 19:41:53 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e65ef9593436f0f62df366f506f7c4d318b5cd71:

  engines/libaio: fallback to old io_setup() system call (2018-11-21 05:53:38 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      Kill "No I/O performed by ..." message
      backend: initialize io engine before io_u buffers
      engines/libaio: add support for user mapped iocbs
      engines/libaio: fallback to old io_setup() system call

 backend.c        |  25 ++----------
 engines/libaio.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 105 insertions(+), 38 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index a92ec45..2f103b3 100644
--- a/backend.c
+++ b/backend.c
@@ -1542,7 +1542,7 @@ static void *thread_main(void *data)
 	struct sk_out *sk_out = fd->sk_out;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 	int deadlock_loop_cnt;
-	bool clear_state, did_some_io;
+	bool clear_state;
 	int ret;
 
 	sk_out_assign(sk_out);
@@ -1698,6 +1698,9 @@ static void *thread_main(void *data)
 	if (!init_iolog(td))
 		goto err;
 
+	if (td_io_init(td))
+		goto err;
+
 	if (init_io_u(td))
 		goto err;
 
@@ -1728,9 +1731,6 @@ static void *thread_main(void *data)
 	if (!o->create_serialize && setup_files(td))
 		goto err;
 
-	if (td_io_init(td))
-		goto err;
-
 	if (!init_random_map(td))
 		goto err;
 
@@ -1763,7 +1763,6 @@ static void *thread_main(void *data)
 
 	memset(bytes_done, 0, sizeof(bytes_done));
 	clear_state = false;
-	did_some_io = false;
 
 	while (keep_running(td)) {
 		uint64_t verify_bytes;
@@ -1841,9 +1840,6 @@ static void *thread_main(void *data)
 		    td_ioengine_flagged(td, FIO_UNIDIR))
 			continue;
 
-		if (ddir_rw_sum(bytes_done))
-			did_some_io = true;
-
 		clear_io_state(td, 0);
 
 		fio_gettime(&td->start, NULL);
@@ -1865,19 +1861,6 @@ static void *thread_main(void *data)
 	}
 
 	/*
-	 * If td ended up with no I/O when it should have had,
-	 * then something went wrong unless FIO_NOIO or FIO_DISKLESSIO.
-	 * (Are we not missing other flags that can be ignored ?)
-	 */
-	if (!td->error && (td->o.size || td->o.io_size) &&
-	    !ddir_rw_sum(bytes_done) && !did_some_io && !td->o.create_only &&
-	    !(td_ioengine_flagged(td, FIO_NOIO) ||
-	      td_ioengine_flagged(td, FIO_DISKLESSIO)))
-		log_err("%s: No I/O performed by %s, "
-			 "perhaps try --debug=io option for details?\n",
-			 td->o.name, td->io_ops->name);
-
-	/*
 	 * Acquire this lock if we were doing overlap checking in
 	 * offload mode so that we don't clean up this job while
 	 * another thread is checking its io_u's for overlap
diff --git a/engines/libaio.c b/engines/libaio.c
index 2a4d653..991d588 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -19,6 +19,10 @@
 #ifndef IOCTX_FLAG_IOPOLL
 #define IOCTX_FLAG_IOPOLL	(1 << 0)
 #endif
+#ifndef IOCTX_FLAG_USERIOCB
+#define IOCTX_FLAG_USERIOCB	(1 << 1)
+#endif
+
 
 static int fio_libaio_commit(struct thread_data *td);
 
@@ -28,6 +32,9 @@ struct libaio_data {
 	struct iocb **iocbs;
 	struct io_u **io_us;
 
+	struct iocb *user_iocbs;
+	struct io_u **io_u_index;
+
 	/*
 	 * Basic ring buffer. 'head' is incremented in _queue(), and
 	 * 'tail' is incremented in _commit(). We keep 'queued' so
@@ -47,6 +54,7 @@ struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
 	unsigned int hipri;
+	unsigned int useriocb;
 };
 
 static struct fio_option options[] = {
@@ -69,6 +77,15 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_LIBAIO,
 	},
 	{
+		.name	= "useriocb",
+		.lname	= "User IOCBs",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct libaio_options, useriocb),
+		.help	= "Use user mapped IOCBs",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -84,19 +101,26 @@ static inline void ring_inc(struct libaio_data *ld, unsigned int *val,
 
 static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 {
+	struct libaio_data *ld = td->io_ops_data;
 	struct fio_file *f = io_u->file;
 	struct libaio_options *o = td->eo;
+	struct iocb *iocb;
+
+	if (o->useriocb)
+		iocb = &ld->user_iocbs[io_u->index];
+	else
+		iocb = &io_u->iocb;
 
 	if (io_u->ddir == DDIR_READ) {
-		io_prep_pread(&io_u->iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 		if (o->hipri)
-			io_u->iocb.u.c.flags |= IOCB_FLAG_HIPRI;
+			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
 	} else if (io_u->ddir == DDIR_WRITE) {
-		io_prep_pwrite(&io_u->iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 		if (o->hipri)
-			io_u->iocb.u.c.flags |= IOCB_FLAG_HIPRI;
+			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
 	} else if (ddir_sync(io_u->ddir))
-		io_prep_fsync(&io_u->iocb, f->fd);
+		io_prep_fsync(iocb, f->fd);
 
 	return 0;
 }
@@ -104,11 +128,16 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 static struct io_u *fio_libaio_event(struct thread_data *td, int event)
 {
 	struct libaio_data *ld = td->io_ops_data;
+	struct libaio_options *o = td->eo;
 	struct io_event *ev;
 	struct io_u *io_u;
 
 	ev = ld->aio_events + event;
-	io_u = container_of(ev->obj, struct io_u, iocb);
+	if (o->useriocb) {
+		int index = (int) (uintptr_t) ev->obj;
+		io_u = ld->io_u_index[index];
+	} else
+		io_u = container_of(ev->obj, struct io_u, iocb);
 
 	if (ev->res != io_u->xfer_buflen) {
 		if (ev->res > io_u->xfer_buflen)
@@ -204,6 +233,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld = td->io_ops_data;
+	struct libaio_options *o = td->eo;
 
 	fio_ro_check(td, io_u);
 
@@ -234,7 +264,11 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	ld->iocbs[ld->head] = &io_u->iocb;
+	if (o->useriocb)
+		ld->iocbs[ld->head] = (struct iocb *) (uintptr_t) io_u->index;
+	else
+		ld->iocbs[ld->head] = &io_u->iocb;
+
 	ld->io_us[ld->head] = io_u;
 	ring_inc(ld, &ld->head, 1);
 	ld->queued++;
@@ -353,26 +387,46 @@ static void fio_libaio_cleanup(struct thread_data *td)
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
+		if (ld->user_iocbs)
+			free(ld->user_iocbs);
 		free(ld);
 	}
 }
 
+static int fio_libaio_old_queue_init(struct libaio_data *ld, unsigned int depth,
+				     bool hipri, bool useriocb)
+{
+	if (hipri) {
+		log_err("fio: polled aio not available on your platform\n");
+		return 1;
+	}
+	if (useriocb) {
+		log_err("fio: user mapped iocbs not available on your platform\n");
+		return 1;
+	}
+
+	return io_queue_init(depth, &ld->aio_ctx);
+}
+
 static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
-				 bool hipri)
+				 bool hipri, bool useriocb)
 {
 #ifdef __NR_sys_io_setup2
-	int flags = 0;
+	int ret, flags = 0;
 
 	if (hipri)
-		flags = IOCTX_FLAG_IOPOLL;
+		flags |= IOCTX_FLAG_IOPOLL;
+	if (useriocb)
+		flags |= IOCTX_FLAG_USERIOCB;
 
-	return syscall(__NR_sys_io_setup2, depth, flags, &ld->aio_ctx);
+	ret = syscall(__NR_sys_io_setup2, depth, flags, ld->user_iocbs,
+			&ld->aio_ctx);
+	if (!ret)
+		return 0;
+
+	return fio_libaio_old_queue_init(ld, depth, hipri, useriocb);
 #else
-	if (hipri) {
-		log_err("fio: polled aio not available on your platform\n");
-		return 1;
-	}
-	return io_queue_init(depth, &ld->aio_ctx);
+	return fio_libaio_old_queue_init(ld, depth, hipri, useriocb);
 #endif
 }
 
@@ -384,15 +438,31 @@ static int fio_libaio_init(struct thread_data *td)
 
 	ld = calloc(1, sizeof(*ld));
 
+	if (o->useriocb) {
+		size_t size;
+		void *p;
+
+		ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
+		size = td->o.iodepth * sizeof(struct iocb);
+		if (posix_memalign(&p, page_size, size)) {
+			log_err("fio: libaio iocb allocation failure\n");
+			free(ld);
+			return 1;
+		}
+		ld->user_iocbs = p;
+	}
+
 	/*
 	 * First try passing in 0 for queue depth, since we don't
 	 * care about the user ring. If that fails, the kernel is too old
 	 * and we need the right depth.
 	 */
-	err = fio_libaio_queue_init(ld, td->o.iodepth, o->hipri);
+	err = fio_libaio_queue_init(ld, td->o.iodepth, o->hipri, o->useriocb);
 	if (err) {
 		td_verror(td, -err, "io_queue_init");
 		log_err("fio: check /proc/sys/fs/aio-max-nr\n");
+		if (ld->user_iocbs)
+			free(ld->user_iocbs);
 		free(ld);
 		return 1;
 	}
@@ -407,10 +477,24 @@ static int fio_libaio_init(struct thread_data *td)
 	return 0;
 }
 
+static int fio_libaio_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	struct libaio_options *o = td->eo;
+
+	if (o->useriocb) {
+		struct libaio_data *ld = td->io_ops_data;
+
+		ld->io_u_index[io_u->index] = io_u;
+	}
+
+	return 0;
+}
+
 static struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.init			= fio_libaio_init,
+	.io_u_init		= fio_libaio_io_u_init,
 	.prep			= fio_libaio_prep,
 	.queue			= fio_libaio_queue,
 	.commit			= fio_libaio_commit,

