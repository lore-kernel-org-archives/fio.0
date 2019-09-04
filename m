Return-Path: <axboe@kernel.dk>
Subject: Re: io_uring engine -- sqthread_poll option can't work as implemented
From: Jens Axboe <axboe@kernel.dk>
References: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
 <6adaa1ad-93b6-48b1-6fe0-7a0cceab9eda@kernel.dk>
 <x498sr5txag.fsf@segfault.boston.devel.redhat.com>
 <0f8ba952-418c-d63d-6b3e-021cae4cfecc@kernel.dk>
Message-ID: <0edfb602-184c-f33b-485e-221be543b069@kernel.dk>
Date: Wed, 4 Sep 2019 14:43:28 -0600
MIME-Version: 1.0
In-Reply-To: <0f8ba952-418c-d63d-6b3e-021cae4cfecc@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/4/19 2:10 PM, Jens Axboe wrote:
> On 9/3/19 5:49 AM, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> On 8/29/19 10:38 AM, Jeff Moyer wrote:
>>>> Hi,
>>>>
>>>> sqthread_poll requires registered files in order to work.  That's not
>>>> implemented in fio, and I don't see how one would go about it (but I'm
>>>> not all that familiar with fio's architecture).  We basically need all
>>>> files to be opened before we can register them.  It looks to me as
>>>> though the files are opened on demand, after the io engine is
>>>> initialized.
>>>>
>>>> Any suggestions?
>>>
>>> Leftover from previously, when that requirement wasn't there... Using
>>> it from fio would require a little bit of footwork, but it's not
>>> impossible.
>>
>> OK, if you can point me in the right direction, I'll take a stab at it.
> 
> I think if we impose the restriction that the total number of files used
> must fit in a registered file set, it isn't too hard. Just have the
> engine open the files when it starts, and provide a new ->open_file()
> (and ->close_file()) in the engine ops.
> 
> I'll take a stab at it.

Here's a quick 10 min hack to get this going, if you want to run with
this, that'd be great. What is still needed:

1) Test it... I just ran a basic test to verify it does what I think it
   should, that's all.
2) Keep the standalone option, but make sqthread_poll imply this option
   as well.
3) Probably add a check whether o->nr_files fits in a set. Or maybe it's
   fine not to, the system call will complain anyway.
4) Ensure it works with things like loops= that restart things.
5) Probably various things I didn't think of yet.


diff --git a/engines/io_uring.c b/engines/io_uring.c
index 9bcfec1726b0..5d051c62d0ea 100644
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
@@ -102,6 +105,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name	= "registerfiles",
+		.lname	= "Register file set",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct ioring_options, registerfiles),
+		.help	= "Pre-open/register files",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
 	{
 		.name	= "sqthread_poll",
 		.lname	= "Kernel SQ thread polling",
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
@@ -476,9 +494,44 @@ static int fio_ioring_queue_init(struct thread_data *td)
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
+	 * Pretend the file is closed again
+	 */
+	for_each_file(td, f, i)
+		f->fd = -1;
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
 
@@ -496,6 +549,14 @@ static int fio_ioring_post_init(struct thread_data *td)
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
 
@@ -530,6 +591,29 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
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
@@ -543,8 +627,8 @@ static struct ioengine_ops ioengine = {
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

-- 
Jens Axboe


