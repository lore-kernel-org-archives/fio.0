Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35658 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG0MAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 Jul 2019 08:00:07 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hrLMr-0008DC-Lj
        for fio@vger.kernel.org; Sat, 27 Jul 2019 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190727120002.53D0E2C00FD@kernel.dk>
Date: Sat, 27 Jul 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fc220349e45144360917db48010b503a9874930d:

  Merge branch 'dev' of https://github.com/smartxworks/fio (2019-07-12 10:44:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 029b42ace698eae477c5e261d2f82b191507526b:

  Document io_uring feature (2019-07-26 09:53:43 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      engines/libaio: remove remnants of abandoned aio features
      Document io_uring feature

 HOWTO            | 34 ++++++++++++++++++++++++++++++++
 engines/libaio.c | 60 +++-----------------------------------------------------
 fio.1            | 23 ++++++++++++++++++++++
 3 files changed, 60 insertions(+), 57 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 142b83e5..81244064 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1805,6 +1805,11 @@ I/O engine
 		**pvsync2**
 			Basic :manpage:`preadv2(2)` or :manpage:`pwritev2(2)` I/O.
 
+		**io_uring**
+			Fast Linux native asynchronous I/O. Supports async IO
+			for both direct and buffered IO.
+			This engine defines engine specific options.
+
 		**libaio**
 			Linux native asynchronous I/O. Note that Linux may only support
 			queued behavior with non-buffered I/O (set ``direct=1`` or
@@ -2002,6 +2007,35 @@ In addition, there are some parameters which are only valid when a specific
 with the caveat that when used on the command line, they must come after the
 :option:`ioengine` that defines them is selected.
 
+.. option:: hipri : [io_uring]
+
+	If this option is set, fio will attempt to use polled IO completions.
+	Normal IO completions generate interrupts to signal the completion of
+	IO, polled completions do not. Hence they are require active reaping
+	by the application. The benefits are more efficient IO for high IOPS
+	scenarios, and lower latencies for low queue depth IO.
+
+.. option:: fixedbufs : [io_uring]
+
+	If fio is asked to do direct IO, then Linux will map pages for each
+	IO call, and release them when IO is done. If this option is set, the
+	pages are pre-mapped before IO is started. This eliminates the need to
+	map and release for each IO. This is more efficient, and reduces the
+	IO latency as well.
+
+.. option:: sqthread_poll : [io_uring]
+
+	Normally fio will submit IO by issuing a system call to notify the
+	kernel of available items in the SQ ring. If this option is set, the
+	act of submitting IO will be done by a polling thread in the kernel.
+	This frees up cycles for fio, at the cost of using more CPU in the
+	system.
+
+.. option:: sqthread_poll_cpu : [io_uring]
+
+	When :option:`sqthread_poll` is set, this option provides a way to
+	define which CPU should be used for the polling thread.
+
 .. option:: userspace_reap : [libaio]
 
 	Normally, with the libaio engine in use, fio will use the
diff --git a/engines/libaio.c b/engines/libaio.c
index cc6ca66b..cd5b89f9 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -16,14 +16,6 @@
 #include "../optgroup.h"
 #include "../lib/memalign.h"
 
-#ifndef IOCB_FLAG_HIPRI
-#define IOCB_FLAG_HIPRI	(1 << 2)
-#endif
-
-#ifndef IOCTX_FLAG_IOPOLL
-#define IOCTX_FLAG_IOPOLL	(1 << 0)
-#endif
-
 static int fio_libaio_commit(struct thread_data *td);
 
 struct libaio_data {
@@ -65,15 +57,6 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
-	{
-		.name	= "hipri",
-		.lname	= "High Priority",
-		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct libaio_options, hipri),
-		.help	= "Use polled IO completions",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
-	},
 	{
 		.name	= NULL,
 	},
@@ -91,19 +74,12 @@ static inline void ring_inc(struct libaio_data *ld, unsigned int *val,
 static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	struct libaio_options *o = td->eo;
-	struct iocb *iocb;
-
-	iocb = &io_u->iocb;
+	struct iocb *iocb = &io_u->iocb;
 
 	if (io_u->ddir == DDIR_READ) {
 		io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-		if (o->hipri)
-			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
 	} else if (io_u->ddir == DDIR_WRITE) {
 		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-		if (o->hipri)
-			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
@@ -366,42 +342,12 @@ static void fio_libaio_cleanup(struct thread_data *td)
 	}
 }
 
-static int fio_libaio_old_queue_init(struct libaio_data *ld, unsigned int depth,
-				     bool hipri)
-{
-	if (hipri) {
-		log_err("fio: polled aio not available on your platform\n");
-		return 1;
-	}
-
-	return io_queue_init(depth, &ld->aio_ctx);
-}
-
-static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
-				 bool hipri)
-{
-#ifdef __NR_sys_io_setup2
-	int ret, flags = 0;
-
-	if (hipri)
-		flags |= IOCTX_FLAG_IOPOLL;
-
-	ret = syscall(__NR_sys_io_setup2, depth, flags, NULL, NULL,
-			&ld->aio_ctx);
-	if (!ret)
-		return 0;
-	/* fall through to old syscall */
-#endif
-	return fio_libaio_old_queue_init(ld, depth, hipri);
-}
-
 static int fio_libaio_post_init(struct thread_data *td)
 {
 	struct libaio_data *ld = td->io_ops_data;
-	struct libaio_options *o = td->eo;
-	int err = 0;
+	int err;
 
-	err = fio_libaio_queue_init(ld, td->o.iodepth, o->hipri);
+	err = io_queue_init(td->o.iodepth, &ld->aio_ctx);
 	if (err) {
 		td_verror(td, -err, "io_queue_init");
 		return 1;
diff --git a/fio.1 b/fio.1
index 156201ad..2966d9d5 100644
--- a/fio.1
+++ b/fio.1
@@ -1762,6 +1762,29 @@ In addition, there are some parameters which are only valid when a specific
 with the caveat that when used on the command line, they must come after the
 \fBioengine\fR that defines them is selected.
 .TP
+.BI (io_uring)hipri
+If this option is set, fio will attempt to use polled IO completions. Normal IO
+completions generate interrupts to signal the completion of IO, polled
+completions do not. Hence they are require active reaping by the application.
+The benefits are more efficient IO for high IOPS scenarios, and lower latencies
+for low queue depth IO.
+.TP
+.BI (io_uring)fixedbufs
+If fio is asked to do direct IO, then Linux will map pages for each IO call, and
+release them when IO is done. If this option is set, the pages are pre-mapped
+before IO is started. This eliminates the need to map and release for each IO.
+This is more efficient, and reduces the IO latency as well.
+.TP
+.BI (io_uring)sqthread_poll
+Normally fio will submit IO by issuing a system call to notify the kernel of
+available items in the SQ ring. If this option is set, the act of submitting IO
+will be done by a polling thread in the kernel. This frees up cycles for fio, at
+the cost of using more CPU in the system.
+.TP
+.BI (io_uring)sqthread_poll_cpu
+When `sqthread_poll` is set, this option provides a way to define which CPU
+should be used for the polling thread.
+.TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
 \fBio_getevents\fR\|(3) system call to reap newly returned events. With

