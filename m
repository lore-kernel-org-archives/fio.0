Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53310 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfIFMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Sep 2019 08:00:08 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i6CuN-0007ck-2n
        for fio@vger.kernel.org; Fri, 06 Sep 2019 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190906120001.5CDAB2C005C@kernel.dk>
Date: Fri,  6 Sep 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4a479420d50eada0a7b9a972c529d75e2884732d:

  smalloc: use SMALLOC_BPI instead of SMALLOC_BPB in add_pool() (2019-09-03 12:32:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 27f436d9f72a9d2d3da3adfdf712757152eab29e:

  engines/io_uring: use its own option group (2019-09-05 09:15:41 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      engines/io_uring: add support for registered files
      engines/io_uring: use its own option group

 HOWTO              |   6 +++
 engines/io_uring.c | 117 +++++++++++++++++++++++++++++++++++++++++++++++++----
 fio.1              |   6 +++
 optgroup.h         |   2 +
 4 files changed, 123 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4201e2e9..6b449e97 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2033,6 +2033,12 @@ with the caveat that when used on the command line, they must come after the
 	map and release for each IO. This is more efficient, and reduces the
 	IO latency as well.
 
+.. option:: registerfiles : [io_uring]
+	With this option, fio registers the set of files being used with the
+	kernel. This avoids the overhead of managing file counts in the kernel,
+	making the submission and completion part more lightweight. Required
+	for the below :option:`sqthread_poll` option.
+
 .. option:: sqthread_poll : [io_uring]
 
 	Normally fio will submit IO by issuing a system call to notify the
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 9bcfec17..10cfe9f2 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -50,6 +50,8 @@ struct ioring_data {
 
 	struct io_u **io_u_index;
 
+	int *fds;
+
 	struct io_sq_ring sq_ring;
 	struct io_uring_sqe *sqes;
 	struct iovec *iovecs;
@@ -69,6 +71,7 @@ struct ioring_options {
 	void *pad;
 	unsigned int hipri;
 	unsigned int fixedbufs;
+	unsigned int registerfiles;
 	unsigned int sqpoll_thread;
 	unsigned int sqpoll_set;
 	unsigned int sqpoll_cpu;
@@ -91,7 +94,7 @@ static struct fio_option options[] = {
 		.off1	= offsetof(struct ioring_options, hipri),
 		.help	= "Use polled IO completions",
 		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
+		.group	= FIO_OPT_G_IOURING,
 	},
 	{
 		.name	= "fixedbufs",
@@ -100,7 +103,16 @@ static struct fio_option options[] = {
 		.off1	= offsetof(struct ioring_options, fixedbufs),
 		.help	= "Pre map IO buffers",
 		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "registerfiles",
+		.lname	= "Register file set",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct ioring_options, registerfiles),
+		.help	= "Pre-open/register files",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
 	},
 	{
 		.name	= "sqthread_poll",
@@ -109,7 +121,7 @@ static struct fio_option options[] = {
 		.off1	= offsetof(struct ioring_options, sqpoll_thread),
 		.help	= "Offload submission/completion to kernel thread",
 		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
+		.group	= FIO_OPT_G_IOURING,
 	},
 	{
 		.name	= "sqthread_poll_cpu",
@@ -118,7 +130,7 @@ static struct fio_option options[] = {
 		.cb	= fio_ioring_sqpoll_cb,
 		.help	= "What CPU to run SQ thread polling on",
 		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
+		.group	= FIO_OPT_G_IOURING,
 	},
 	{
 		.name	= NULL,
@@ -140,8 +152,13 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	struct io_uring_sqe *sqe;
 
 	sqe = &ld->sqes[io_u->index];
-	sqe->fd = f->fd;
-	sqe->flags = 0;
+	if (o->registerfiles) {
+		sqe->fd = f->engine_pos;
+		sqe->flags = IOSQE_FIXED_FILE;
+	} else {
+		sqe->fd = f->fd;
+		sqe->flags = 0;
+	}
 	sqe->ioprio = 0;
 	sqe->buf_index = 0;
 
@@ -388,6 +405,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 
 		free(ld->io_u_index);
 		free(ld->iovecs);
+		free(ld->fds);
 		free(ld);
 	}
 }
@@ -476,9 +494,50 @@ static int fio_ioring_queue_init(struct thread_data *td)
 	return fio_ioring_mmap(ld, &p);
 }
 
+static int fio_ioring_register_files(struct thread_data *td)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct fio_file *f;
+	unsigned int i;
+	int ret;
+
+	ld->fds = calloc(td->o.nr_files, sizeof(int));
+
+	for_each_file(td, f, i) {
+		ret = generic_open_file(td, f);
+		if (ret)
+			goto err;
+		ld->fds[i] = f->fd;
+		f->engine_pos = i;
+	}
+
+	ret = syscall(__NR_sys_io_uring_register, ld->ring_fd,
+			IORING_REGISTER_FILES, ld->fds, td->o.nr_files);
+	if (ret) {
+err:
+		free(ld->fds);
+		ld->fds = NULL;
+	}
+
+	/*
+	 * Pretend the file is closed again, and really close it if we hit
+	 * an error.
+	 */
+	for_each_file(td, f, i) {
+		if (ret) {
+			int fio_unused ret2;
+			ret2 = generic_close_file(td, f);
+		} else
+			f->fd = -1;
+	}
+
+	return ret;
+}
+
 static int fio_ioring_post_init(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	struct io_u *io_u;
 	int err, i;
 
@@ -496,6 +555,14 @@ static int fio_ioring_post_init(struct thread_data *td)
 		return 1;
 	}
 
+	if (o->registerfiles) {
+		err = fio_ioring_register_files(td);
+		if (err) {
+			td_verror(td, errno, "ioring_register_files");
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -506,8 +573,19 @@ static unsigned roundup_pow2(unsigned depth)
 
 static int fio_ioring_init(struct thread_data *td)
 {
+	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
 
+	/* sqthread submission requires registered files */
+	if (o->sqpoll_thread)
+		o->registerfiles = 1;
+
+	if (o->registerfiles && td->o.nr_files != td->o.open_files) {
+		log_err("fio: io_uring registered files require nr_files to "
+			"be identical to open_files\n");
+		return 1;
+	}
+
 	ld = calloc(1, sizeof(*ld));
 
 	/* ring depth must be a power-of-2 */
@@ -530,6 +608,29 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (!o->registerfiles)
+		return generic_open_file(td, f);
+
+	f->fd = ld->fds[f->engine_pos];
+	return 0;
+}
+
+static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
+{
+	struct ioring_options *o = td->eo;
+
+	if (!o->registerfiles)
+		return generic_close_file(td, f);
+
+	f->fd = -1;
+	return 0;
+}
+
 static struct ioengine_ops ioengine = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
@@ -543,8 +644,8 @@ static struct ioengine_ops ioengine = {
 	.getevents		= fio_ioring_getevents,
 	.event			= fio_ioring_event,
 	.cleanup		= fio_ioring_cleanup,
-	.open_file		= generic_open_file,
-	.close_file		= generic_close_file,
+	.open_file		= fio_ioring_open_file,
+	.close_file		= fio_ioring_close_file,
 	.get_file_size		= generic_get_file_size,
 	.options		= options,
 	.option_struct_size	= sizeof(struct ioring_options),
diff --git a/fio.1 b/fio.1
index 3e872bce..e0283f7f 100644
--- a/fio.1
+++ b/fio.1
@@ -1791,6 +1791,12 @@ release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
+.BI (io_uring)registerfiles
+With this option, fio registers the set of files being used with the kernel.
+This avoids the overhead of managing file counts in the kernel, making the
+submission and completion part more lightweight. Required for the below
+sqthread_poll option.
+.TP
 .BI (io_uring)sqthread_poll
 Normally fio will submit IO by issuing a system call to notify the kernel of
 available items in the SQ ring. If this option is set, the act of submitting IO
diff --git a/optgroup.h b/optgroup.h
index 8009bf25..55ef5934 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -64,6 +64,7 @@ enum opt_category_group {
 	__FIO_OPT_G_MMAP,
 	__FIO_OPT_G_ISCSI,
 	__FIO_OPT_G_NBD,
+	__FIO_OPT_G_IOURING,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
@@ -104,6 +105,7 @@ enum opt_category_group {
 	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
 	FIO_OPT_G_ISCSI         = (1ULL << __FIO_OPT_G_ISCSI),
 	FIO_OPT_G_NBD		= (1ULL << __FIO_OPT_G_NBD),
+	FIO_OPT_G_IOURING	= (1ULL << __FIO_OPT_G_IOURING),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);

