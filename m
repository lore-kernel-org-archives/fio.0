Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138ABCCA47B
	for <fio@archiver.kernel.org>; Thu,  2 Jun 2022 12:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiFBMAV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 2 Jun 2022 08:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiFBMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Jun 2022 08:00:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE21012635
        for <fio@vger.kernel.org>; Thu,  2 Jun 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=aEICryqlEI9TPp/Alv0J/UsHZ2DT1uT6aJTBgli2p6s=; b=EmpIZhq+m4LkQff0rE4GvJb6Nh
        YYic2zi3RKmGY3E7Co75sEWJOJxPf2Cg0C5L4+EFhUeXA/hMBzcUdqUrTY56r0k0SUzQI86yNK62Z
        4FpGYbHMqVdlivowIFtKtPWpg7DurjsoZMcktUYu6vW+W3D6Xy2rP6H/gsl14GP+FrmwwS6ZLM0t3
        Th0PSVfgcNBaE5PlqSfnvWiqVm4okvQ2/BVe/1eFkk7H/OxvbPIkYqUQGrJZ4Dq0PUy4lsaFwoYet
        o1NQ03DUWUaVGCN86pnpssj4JKuNuYRwtHSFWy2PYP1yEjxd54XHZ9Kr2aMZeBAPkGPqivud1lIJl
        7oCBIKAQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwjUi-00461k-9c
        for fio@vger.kernel.org; Thu, 02 Jun 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 1DAF21BC0124; Thu,  2 Jun 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220602120002.1DAF21BC0124@kernel.dk>
Date:   Thu,  2 Jun 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5ceed0be62f3ce8903d5747674f9f70f44e736d6:

  docs: update language setting for Sphinx build (2022-05-31 20:58:00 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 26faead0f3c6e7608b89a51373f1455b91377fcb:

  t/zbd: skip test case #13 when max_open_zones is too small (2022-06-02 03:58:31 -0600)

----------------------------------------------------------------
Ankit Kumar (5):
      configure: check nvme uring command support
      nvme: add nvme opcodes, structures and helper functions
      docs: document options for io_uring_cmd I/O engine
      zbd: Check for direct flag only if its block device
      engines/io_uring: Enable zone device support for io_uring_cmd I/O engine

Anuj Gupta (4):
      io_uring.h: add IORING_SETUP_SQE128 and IORING_SETUP_CQE32
      init: return error incase an invalid value is passed as option
      engines/io_uring: add new I/O engine for uring passthrough support
      examples: add 2 example job file for io_uring_cmd engine

Jens Axboe (3):
      engines/io_uring: cleanup supported case
      engines/nvme: fix 'fd' leak in error handling
      engines/nvme: ioctl return value is an int

Shin'ichiro Kawasaki (1):
      t/zbd: skip test case #13 when max_open_zones is too small

 HOWTO.rst                    |  41 +++--
 Makefile                     |   4 +-
 configure                    |  21 +++
 engines/io_uring.c           | 346 +++++++++++++++++++++++++++++++++++++++++-
 engines/nvme.c               | 347 +++++++++++++++++++++++++++++++++++++++++++
 engines/nvme.h               | 214 ++++++++++++++++++++++++++
 examples/uring-cmd-ng.fio    |  25 ++++
 examples/uring-cmd-zoned.fio |  31 ++++
 file.h                       |  12 +-
 fio.1                        |  33 +++-
 init.c                       |   9 ++
 os/linux/io_uring.h          |  45 +++++-
 t/zbd/test-zbd-support       |  23 ++-
 zbd.c                        |   4 +-
 14 files changed, 1123 insertions(+), 32 deletions(-)
 create mode 100644 engines/nvme.c
 create mode 100644 engines/nvme.h
 create mode 100644 examples/uring-cmd-ng.fio
 create mode 100644 examples/uring-cmd-zoned.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 8ab3ac4b..28ac2b7c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1952,6 +1952,10 @@ I/O engine
 			for both direct and buffered IO.
 			This engine defines engine specific options.
 
+		**io_uring_cmd**
+			Fast Linux native asynchronous I/O for pass through commands.
+			This engine defines engine specific options.
+
 		**libaio**
 			Linux native asynchronous I/O. Note that Linux may only support
 			queued behavior with non-buffered I/O (set ``direct=1`` or
@@ -2255,22 +2259,34 @@ with the caveat that when used on the command line, they must come after the
 	values for trim IOs are ignored. This option is mutually exclusive with
 	the :option:`cmdprio_percentage` option.
 
-.. option:: fixedbufs : [io_uring]
+.. option:: fixedbufs : [io_uring] [io_uring_cmd]
+
+	If fio is asked to do direct IO, then Linux will map pages for each
+	IO call, and release them when IO is done. If this option is set, the
+	pages are pre-mapped before IO is started. This eliminates the need to
+	map and release for each IO. This is more efficient, and reduces the
+	IO latency as well.
+
+.. option:: nonvectored : [io_uring] [io_uring_cmd]
 
-    If fio is asked to do direct IO, then Linux will map pages for each
-    IO call, and release them when IO is done. If this option is set, the
-    pages are pre-mapped before IO is started. This eliminates the need to
-    map and release for each IO. This is more efficient, and reduces the
-    IO latency as well.
+	With this option, fio will use non-vectored read/write commands, where
+	address must contain the address directly. Default is -1.
 
-.. option:: registerfiles : [io_uring]
+.. option:: force_async=int : [io_uring] [io_uring_cmd]
+
+	Normal operation for io_uring is to try and issue an sqe as
+	non-blocking first, and if that fails, execute it in an async manner.
+	With this option set to N, then every N request fio will ask sqe to
+	be issued in an async manner. Default is 0.
+
+.. option:: registerfiles : [io_uring] [io_uring_cmd]
 
 	With this option, fio registers the set of files being used with the
 	kernel. This avoids the overhead of managing file counts in the kernel,
 	making the submission and completion part more lightweight. Required
 	for the below :option:`sqthread_poll` option.
 
-.. option:: sqthread_poll : [io_uring] [xnvme]
+.. option:: sqthread_poll : [io_uring] [io_uring_cmd] [xnvme]
 
 	Normally fio will submit IO by issuing a system call to notify the
 	kernel of available items in the SQ ring. If this option is set, the
@@ -2278,14 +2294,19 @@ with the caveat that when used on the command line, they must come after the
 	This frees up cycles for fio, at the cost of using more CPU in the
 	system.
 
-.. option:: sqthread_poll_cpu : [io_uring]
+.. option:: sqthread_poll_cpu : [io_uring] [io_uring_cmd]
 
 	When :option:`sqthread_poll` is set, this option provides a way to
 	define which CPU should be used for the polling thread.
 
+.. option:: cmd_type=str : [io_uring_cmd]
+
+	Specifies the type of uring passthrough command to be used. Supported
+	value is nvme. Default is nvme.
+
 .. option:: hipri
 
-   [io_uring], [xnvme]
+   [io_uring] [io_uring_cmd] [xnvme]
 
         If this option is set, fio will attempt to use polled IO completions.
         Normal IO completions generate interrupts to signal the completion of
diff --git a/Makefile b/Makefile
index ed66305a..188a74d7 100644
--- a/Makefile
+++ b/Makefile
@@ -231,7 +231,7 @@ ifdef CONFIG_LIBXNVME
 endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
-		oslib/linux-dev-lookup.c engines/io_uring.c
+		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c
   cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
@@ -241,7 +241,7 @@ endif
 endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
-		oslib/linux-dev-lookup.c engines/io_uring.c
+		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c
   cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
diff --git a/configure b/configure
index 4ee536a0..8182322b 100755
--- a/configure
+++ b/configure
@@ -2587,6 +2587,27 @@ if test "$libzbc" != "no" ; then
 fi
 print_config "libzbc engine" "$libzbc"
 
+if test "$targetos" = "Linux" ; then
+##########################################
+# Check NVME_URING_CMD support
+cat > $TMPC << EOF
+#include <linux/nvme_ioctl.h>
+int main(void)
+{
+  struct nvme_uring_cmd *cmd;
+
+  return sizeof(struct nvme_uring_cmd);
+}
+EOF
+if compile_prog "" "" "nvme uring cmd"; then
+  output_sym "CONFIG_NVME_URING_CMD"
+  nvme_uring_cmd="yes"
+else
+  nvme_uring_cmd="no"
+fi
+print_config "NVMe uring command support" "$nvme_uring_cmd"
+fi
+
 ##########################################
 # Check if we have xnvme
 if test "$xnvme" != "yes" ; then
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1e15647e..cceafe69 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -24,6 +24,13 @@
 #include "../lib/types.h"
 #include "../os/linux/io_uring.h"
 #include "cmdprio.h"
+#include "nvme.h"
+
+#include <sys/stat.h>
+
+enum uring_cmd_type {
+	FIO_URING_CMD_NVME = 1,
+};
 
 struct io_sq_ring {
 	unsigned *head;
@@ -85,6 +92,7 @@ struct ioring_options {
 	unsigned int uncached;
 	unsigned int nowait;
 	unsigned int force_async;
+	enum uring_cmd_type cmd_type;
 };
 
 static const int ddir_to_op[2][2] = {
@@ -270,6 +278,22 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "cmd_type",
+		.lname	= "Uring cmd type",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, cmd_type),
+		.help	= "Specify uring-cmd type",
+		.def	= "nvme",
+		.posval = {
+			  { .ival = "nvme",
+			    .oval = FIO_URING_CMD_NVME,
+			    .help = "Issue nvme-uring-cmd",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -373,6 +397,48 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct fio_file *f = io_u->file;
+	struct nvme_uring_cmd *cmd;
+	struct io_uring_sqe *sqe;
+
+	/* only supports nvme_uring_cmd */
+	if (o->cmd_type != FIO_URING_CMD_NVME)
+		return -EINVAL;
+
+	sqe = &ld->sqes[(io_u->index) << 1];
+
+	if (o->registerfiles) {
+		sqe->fd = f->engine_pos;
+		sqe->flags = IOSQE_FIXED_FILE;
+	} else {
+		sqe->fd = f->fd;
+	}
+	sqe->rw_flags = 0;
+	if (!td->o.odirect && o->uncached)
+		sqe->rw_flags |= RWF_UNCACHED;
+	if (o->nowait)
+		sqe->rw_flags |= RWF_NOWAIT;
+
+	sqe->opcode = IORING_OP_URING_CMD;
+	sqe->user_data = (unsigned long) io_u;
+	if (o->nonvectored)
+		sqe->cmd_op = NVME_URING_CMD_IO;
+	else
+		sqe->cmd_op = NVME_URING_CMD_IO_VEC;
+	if (o->force_async && ++ld->prepped == o->force_async) {
+		ld->prepped = 0;
+		sqe->flags |= IOSQE_ASYNC;
+	}
+
+	cmd = (struct nvme_uring_cmd *)sqe->cmd;
+	return fio_nvme_uring_cmd_prep(cmd, io_u,
+			o->nonvectored ? NULL : &ld->iovecs[io_u->index]);
+}
+
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -396,6 +462,29 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	return io_u;
 }
 
+static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct io_uring_cqe *cqe;
+	struct io_u *io_u;
+	unsigned index;
+
+	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
+	if (o->cmd_type == FIO_URING_CMD_NVME)
+		index <<= 1;
+
+	cqe = &ld->cq_ring.cqes[index];
+	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
+
+	if (cqe->res != 0)
+		io_u->error = -cqe->res;
+	else
+		io_u->error = 0;
+
+	return io_u;
+}
+
 static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
 				   unsigned int max)
 {
@@ -622,14 +711,22 @@ static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
 	sring->array = ptr + p->sq_off.array;
 	ld->sq_ring_mask = *sring->ring_mask;
 
-	ld->mmap[1].len = p->sq_entries * sizeof(struct io_uring_sqe);
+	if (p->flags & IORING_SETUP_SQE128)
+		ld->mmap[1].len = 2 * p->sq_entries * sizeof(struct io_uring_sqe);
+	else
+		ld->mmap[1].len = p->sq_entries * sizeof(struct io_uring_sqe);
 	ld->sqes = mmap(0, ld->mmap[1].len, PROT_READ | PROT_WRITE,
 				MAP_SHARED | MAP_POPULATE, ld->ring_fd,
 				IORING_OFF_SQES);
 	ld->mmap[1].ptr = ld->sqes;
 
-	ld->mmap[2].len = p->cq_off.cqes +
-				p->cq_entries * sizeof(struct io_uring_cqe);
+	if (p->flags & IORING_SETUP_CQE32) {
+		ld->mmap[2].len = p->cq_off.cqes +
+					2 * p->cq_entries * sizeof(struct io_uring_cqe);
+	} else {
+		ld->mmap[2].len = p->cq_off.cqes +
+					p->cq_entries * sizeof(struct io_uring_cqe);
+	}
 	ptr = mmap(0, ld->mmap[2].len, PROT_READ | PROT_WRITE,
 			MAP_SHARED | MAP_POPULATE, ld->ring_fd,
 			IORING_OFF_CQ_RING);
@@ -728,6 +825,61 @@ retry:
 	return fio_ioring_mmap(ld, &p);
 }
 
+static int fio_ioring_cmd_queue_init(struct thread_data *td)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	int depth = td->o.iodepth;
+	struct io_uring_params p;
+	int ret;
+
+	memset(&p, 0, sizeof(p));
+
+	if (o->hipri)
+		p.flags |= IORING_SETUP_IOPOLL;
+	if (o->sqpoll_thread) {
+		p.flags |= IORING_SETUP_SQPOLL;
+		if (o->sqpoll_set) {
+			p.flags |= IORING_SETUP_SQ_AFF;
+			p.sq_thread_cpu = o->sqpoll_cpu;
+		}
+	}
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		p.flags |= IORING_SETUP_SQE128;
+		p.flags |= IORING_SETUP_CQE32;
+	}
+
+	/*
+	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
+	 * than that.
+	 */
+	p.flags |= IORING_SETUP_CQSIZE;
+	p.cq_entries = depth;
+
+retry:
+	ret = syscall(__NR_io_uring_setup, depth, &p);
+	if (ret < 0) {
+		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
+			p.flags &= ~IORING_SETUP_CQSIZE;
+			goto retry;
+		}
+		return ret;
+	}
+
+	ld->ring_fd = ret;
+
+	fio_ioring_probe(td);
+
+	if (o->fixedbufs) {
+		ret = syscall(__NR_io_uring_register, ld->ring_fd,
+				IORING_REGISTER_BUFFERS, ld->iovecs, depth);
+		if (ret < 0)
+			return ret;
+	}
+
+	return fio_ioring_mmap(ld, &p);
+}
+
 static int fio_ioring_register_files(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -811,6 +963,52 @@ static int fio_ioring_post_init(struct thread_data *td)
 	return 0;
 }
 
+static int fio_ioring_cmd_post_init(struct thread_data *td)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct io_u *io_u;
+	int err, i;
+
+	for (i = 0; i < td->o.iodepth; i++) {
+		struct iovec *iov = &ld->iovecs[i];
+
+		io_u = ld->io_u_index[i];
+		iov->iov_base = io_u->buf;
+		iov->iov_len = td_max_bs(td);
+	}
+
+	err = fio_ioring_cmd_queue_init(td);
+	if (err) {
+		int init_err = errno;
+
+		td_verror(td, init_err, "io_queue_init");
+		return 1;
+	}
+
+	for (i = 0; i < td->o.iodepth; i++) {
+		struct io_uring_sqe *sqe;
+
+		if (o->cmd_type == FIO_URING_CMD_NVME) {
+			sqe = &ld->sqes[i << 1];
+			memset(sqe, 0, 2 * sizeof(*sqe));
+		} else {
+			sqe = &ld->sqes[i];
+			memset(sqe, 0, sizeof(*sqe));
+		}
+	}
+
+	if (o->registerfiles) {
+		err = fio_ioring_register_files(td);
+		if (err) {
+			td_verror(td, errno, "ioring_register_files");
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
@@ -868,6 +1066,38 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_data *data = NULL;
+		unsigned int nsid, lba_size = 0;
+		unsigned long long nlba = 0;
+		int ret;
+
+		/* Store the namespace-id and lba size. */
+		data = FILE_ENG_DATA(f);
+		if (data == NULL) {
+			ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
+			if (ret)
+				return ret;
+
+			data = calloc(1, sizeof(struct nvme_data));
+			data->nsid = nsid;
+			data->lba_shift = ilog2(lba_size);
+
+			FILE_SET_ENG_DATA(f, data);
+		}
+	}
+	if (!ld || !o->registerfiles)
+		return generic_open_file(td, f);
+
+	f->fd = ld->fds[f->engine_pos];
+	return 0;
+}
+
 static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -880,7 +1110,85 @@ static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+static int fio_ioring_cmd_close_file(struct thread_data *td,
+				     struct fio_file *f)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_data *data = FILE_ENG_DATA(f);
+
+		FILE_SET_ENG_DATA(f, NULL);
+		free(data);
+	}
+	if (!ld || !o->registerfiles)
+		return generic_close_file(td, f);
+
+	f->fd = -1;
+	return 0;
+}
+
+static int fio_ioring_cmd_get_file_size(struct thread_data *td,
+					struct fio_file *f)
+{
+	struct ioring_options *o = td->eo;
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_data *data = NULL;
+		unsigned int nsid, lba_size = 0;
+		unsigned long long nlba = 0;
+		int ret;
+
+		ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
+		if (ret)
+			return ret;
+
+		data = calloc(1, sizeof(struct nvme_data));
+		data->nsid = nsid;
+		data->lba_shift = ilog2(lba_size);
+
+		f->real_file_size = lba_size * nlba;
+		fio_file_set_size_known(f);
+
+		FILE_SET_ENG_DATA(f, data);
+		return 0;
+	}
+	return generic_get_file_size(td, f);
+}
+
+static int fio_ioring_cmd_get_zoned_model(struct thread_data *td,
+					  struct fio_file *f,
+					  enum zbd_zoned_model *model)
+{
+	return fio_nvme_get_zoned_model(td, f, model);
+}
+
+static int fio_ioring_cmd_report_zones(struct thread_data *td,
+				       struct fio_file *f, uint64_t offset,
+				       struct zbd_zone *zbdz,
+				       unsigned int nr_zones)
+{
+	return fio_nvme_report_zones(td, f, offset, zbdz, nr_zones);
+}
+
+static int fio_ioring_cmd_reset_wp(struct thread_data *td, struct fio_file *f,
+				   uint64_t offset, uint64_t length)
+{
+	return fio_nvme_reset_wp(td, f, offset, length);
+}
+
+static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
+					     struct fio_file *f,
+					     unsigned int *max_open_zones)
+{
+	return fio_nvme_get_max_open_zones(td, f, max_open_zones);
+}
+
+static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD,
@@ -900,13 +1208,39 @@ static struct ioengine_ops ioengine = {
 	.option_struct_size	= sizeof(struct ioring_options),
 };
 
+static struct ioengine_ops ioengine_uring_cmd = {
+	.name			= "io_uring_cmd",
+	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO,
+	.init			= fio_ioring_init,
+	.post_init		= fio_ioring_cmd_post_init,
+	.io_u_init		= fio_ioring_io_u_init,
+	.prep			= fio_ioring_cmd_prep,
+	.queue			= fio_ioring_queue,
+	.commit			= fio_ioring_commit,
+	.getevents		= fio_ioring_getevents,
+	.event			= fio_ioring_cmd_event,
+	.cleanup		= fio_ioring_cleanup,
+	.open_file		= fio_ioring_cmd_open_file,
+	.close_file		= fio_ioring_cmd_close_file,
+	.get_file_size		= fio_ioring_cmd_get_file_size,
+	.get_zoned_model	= fio_ioring_cmd_get_zoned_model,
+	.report_zones		= fio_ioring_cmd_report_zones,
+	.reset_wp		= fio_ioring_cmd_reset_wp,
+	.get_max_open_zones	= fio_ioring_cmd_get_max_open_zones,
+	.options		= options,
+	.option_struct_size	= sizeof(struct ioring_options),
+};
+
 static void fio_init fio_ioring_register(void)
 {
-	register_ioengine(&ioengine);
+	register_ioengine(&ioengine_uring);
+	register_ioengine(&ioengine_uring_cmd);
 }
 
 static void fio_exit fio_ioring_unregister(void)
 {
-	unregister_ioengine(&ioengine);
+	unregister_ioengine(&ioengine_uring);
+	unregister_ioengine(&ioengine_uring_cmd);
 }
 #endif
diff --git a/engines/nvme.c b/engines/nvme.c
new file mode 100644
index 00000000..9ffc5303
--- /dev/null
+++ b/engines/nvme.c
@@ -0,0 +1,347 @@
+/*
+ * nvme structure declarations and helper functions for the
+ * io_uring_cmd engine.
+ */
+
+#include "nvme.h"
+
+int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+			    struct iovec *iov)
+{
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	__u64 slba;
+	__u32 nlb;
+
+	memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+
+	if (io_u->ddir == DDIR_READ)
+		cmd->opcode = nvme_cmd_read;
+	else if (io_u->ddir == DDIR_WRITE)
+		cmd->opcode = nvme_cmd_write;
+	else
+		return -ENOTSUP;
+
+	slba = io_u->offset >> data->lba_shift;
+	nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
+
+	/* cdw10 and cdw11 represent starting lba */
+	cmd->cdw10 = slba & 0xffffffff;
+	cmd->cdw11 = slba >> 32;
+	/* cdw12 represent number of lba's for read/write */
+	cmd->cdw12 = nlb;
+	if (iov) {
+		iov->iov_base = io_u->xfer_buf;
+		iov->iov_len = io_u->xfer_buflen;
+		cmd->addr = (__u64)(uintptr_t)iov;
+		cmd->data_len = 1;
+	} else {
+		cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
+		cmd->data_len = io_u->xfer_buflen;
+	}
+	cmd->nsid = data->nsid;
+	return 0;
+}
+
+static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
+			 enum nvme_csi csi, void *data)
+{
+	struct nvme_passthru_cmd cmd = {
+		.opcode         = nvme_admin_identify,
+		.nsid           = nsid,
+		.addr           = (__u64)(uintptr_t)data,
+		.data_len       = NVME_IDENTIFY_DATA_SIZE,
+		.cdw10          = cns,
+		.cdw11          = csi << NVME_IDENTIFY_CSI_SHIFT,
+		.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
+	};
+
+	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
+}
+
+int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
+		      __u64 *nlba)
+{
+	struct nvme_id_ns ns;
+	int namespace_id;
+	int fd, err;
+
+	if (f->filetype != FIO_TYPE_CHAR) {
+		log_err("ioengine io_uring_cmd only works with nvme ns "
+			"generic char devices (/dev/ngXnY)\n");
+		return 1;
+	}
+
+	fd = open(f->file_name, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	namespace_id = ioctl(fd, NVME_IOCTL_ID);
+	if (namespace_id < 0) {
+		log_err("failed to fetch namespace-id");
+		close(fd);
+		return -errno;
+	}
+
+	/*
+	 * Identify namespace to get namespace-id, namespace size in LBA's
+	 * and LBA data size.
+	 */
+	err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_NS,
+				NVME_CSI_NVM, &ns);
+	if (err) {
+		log_err("failed to fetch identify namespace\n");
+		close(fd);
+		return err;
+	}
+
+	*nsid = namespace_id;
+	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
+	*nlba = ns.nsze;
+
+	close(fd);
+	return 0;
+}
+
+int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			     enum zbd_zoned_model *model)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_id_ns ns;
+	struct nvme_passthru_cmd cmd;
+	int fd, ret = 0;
+
+	if (f->filetype != FIO_TYPE_CHAR)
+		return -EINVAL;
+
+	/* File is not yet opened */
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	/* Using nvme_id_ns for data as sizes are same */
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_CTRL,
+				NVME_CSI_ZNS, &ns);
+	if (ret) {
+		*model = ZBD_NONE;
+		goto out;
+	}
+
+	memset(&cmd, 0, sizeof(struct nvme_passthru_cmd));
+
+	/* Using nvme_id_ns for data as sizes are same */
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_NS,
+				NVME_CSI_ZNS, &ns);
+	if (ret) {
+		*model = ZBD_NONE;
+		goto out;
+	}
+
+	*model = ZBD_HOST_MANAGED;
+out:
+	close(fd);
+	return 0;
+}
+
+static int nvme_report_zones(int fd, __u32 nsid, __u64 slba, __u32 zras_feat,
+			     __u32 data_len, void *data)
+{
+	struct nvme_passthru_cmd cmd = {
+		.opcode         = nvme_zns_cmd_mgmt_recv,
+		.nsid           = nsid,
+		.addr           = (__u64)(uintptr_t)data,
+		.data_len       = data_len,
+		.cdw10          = slba & 0xffffffff,
+		.cdw11          = slba >> 32,
+		.cdw12		= (data_len >> 2) - 1,
+		.cdw13		= NVME_ZNS_ZRA_REPORT_ZONES | zras_feat,
+		.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
+	};
+
+	return ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
+}
+
+int fio_nvme_report_zones(struct thread_data *td, struct fio_file *f,
+			  uint64_t offset, struct zbd_zone *zbdz,
+			  unsigned int nr_zones)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_zone_report *zr;
+	struct nvme_zns_id_ns zns_ns;
+	struct nvme_id_ns ns;
+	unsigned int i = 0, j, zones_fetched = 0;
+	unsigned int max_zones, zones_chunks = 1024;
+	int fd, ret = 0;
+	__u32 zr_len;
+	__u64 zlen;
+
+	/* File is not yet opened */
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	zones_fetched = 0;
+	zr_len = sizeof(*zr) + (zones_chunks * sizeof(struct nvme_zns_desc));
+	zr = calloc(1, zr_len);
+	if (!zr) {
+		close(fd);
+		return -ENOMEM;
+	}
+
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_NS,
+				NVME_CSI_NVM, &ns);
+	if (ret) {
+		log_err("%s: nvme_identify_ns failed, err=%d\n", f->file_name,
+			ret);
+		goto out;
+	}
+
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_NS,
+				NVME_CSI_ZNS, &zns_ns);
+	if (ret) {
+		log_err("%s: nvme_zns_identify_ns failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+	zlen = zns_ns.lbafe[ns.flbas & 0x0f].zsze << data->lba_shift;
+
+	max_zones = (f->real_file_size - offset) / zlen;
+	if (max_zones < nr_zones)
+		nr_zones = max_zones;
+
+	if (nr_zones < zones_chunks)
+		zones_chunks = nr_zones;
+
+	while (zones_fetched < nr_zones) {
+		if (zones_fetched + zones_chunks >= nr_zones) {
+			zones_chunks = nr_zones - zones_fetched;
+			zr_len = sizeof(*zr) + (zones_chunks * sizeof(struct nvme_zns_desc));
+		}
+		ret = nvme_report_zones(fd, data->nsid, offset >> data->lba_shift,
+					NVME_ZNS_ZRAS_FEAT_ERZ, zr_len, (void *)zr);
+		if (ret) {
+			log_err("%s: nvme_zns_report_zones failed, err=%d\n",
+				f->file_name, ret);
+			goto out;
+		}
+
+		/* Transform the zone-report */
+		for (j = 0; j < zr->nr_zones; j++, i++) {
+			struct nvme_zns_desc *desc = (struct nvme_zns_desc *)&(zr->entries[j]);
+
+			zbdz[i].start = desc->zslba << data->lba_shift;
+			zbdz[i].len = zlen;
+			zbdz[i].wp = desc->wp << data->lba_shift;
+			zbdz[i].capacity = desc->zcap << data->lba_shift;
+
+			/* Zone Type is stored in first 4 bits. */
+			switch (desc->zt & 0x0f) {
+			case NVME_ZONE_TYPE_SEQWRITE_REQ:
+				zbdz[i].type = ZBD_ZONE_TYPE_SWR;
+				break;
+			default:
+				log_err("%s: invalid type for zone at offset %llu.\n",
+					f->file_name, desc->zslba);
+				ret = -EIO;
+				goto out;
+			}
+
+			/* Zone State is stored in last 4 bits. */
+			switch (desc->zs >> 4) {
+			case NVME_ZNS_ZS_EMPTY:
+				zbdz[i].cond = ZBD_ZONE_COND_EMPTY;
+				break;
+			case NVME_ZNS_ZS_IMPL_OPEN:
+				zbdz[i].cond = ZBD_ZONE_COND_IMP_OPEN;
+				break;
+			case NVME_ZNS_ZS_EXPL_OPEN:
+				zbdz[i].cond = ZBD_ZONE_COND_EXP_OPEN;
+				break;
+			case NVME_ZNS_ZS_CLOSED:
+				zbdz[i].cond = ZBD_ZONE_COND_CLOSED;
+				break;
+			case NVME_ZNS_ZS_FULL:
+				zbdz[i].cond = ZBD_ZONE_COND_FULL;
+				break;
+			case NVME_ZNS_ZS_READ_ONLY:
+			case NVME_ZNS_ZS_OFFLINE:
+			default:
+				/* Treat all these conditions as offline (don't use!) */
+				zbdz[i].cond = ZBD_ZONE_COND_OFFLINE;
+				zbdz[i].wp = zbdz[i].start;
+			}
+		}
+		zones_fetched += zr->nr_zones;
+		offset += zr->nr_zones * zlen;
+	}
+
+	ret = zones_fetched;
+out:
+	free(zr);
+	close(fd);
+
+	return ret;
+}
+
+int fio_nvme_reset_wp(struct thread_data *td, struct fio_file *f,
+		      uint64_t offset, uint64_t length)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	unsigned int nr_zones;
+	unsigned long long zslba;
+	int i, fd, ret = 0;
+
+	/* If the file is not yet opened, open it for this function. */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
+		if (fd < 0)
+			return -errno;
+	}
+
+	zslba = offset >> data->lba_shift;
+	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
+
+	for (i = 0; i < nr_zones; i++, zslba += (td->o.zone_size >> data->lba_shift)) {
+		struct nvme_passthru_cmd cmd = {
+			.opcode         = nvme_zns_cmd_mgmt_send,
+			.nsid           = data->nsid,
+			.cdw10          = zslba & 0xffffffff,
+			.cdw11          = zslba >> 32,
+			.cdw13          = NVME_ZNS_ZSA_RESET,
+			.addr           = (__u64)(uintptr_t)NULL,
+			.data_len       = 0,
+			.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
+		};
+
+		ret = ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
+	}
+
+	if (f->fd < 0)
+		close(fd);
+	return -ret;
+}
+
+int fio_nvme_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+				unsigned int *max_open_zones)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_zns_id_ns zns_ns;
+	int fd, ret = 0;
+
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_NS,
+				NVME_CSI_ZNS, &zns_ns);
+	if (ret) {
+		log_err("%s: nvme_zns_identify_ns failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+
+	*max_open_zones = zns_ns.mor + 1;
+out:
+	close(fd);
+	return ret;
+}
diff --git a/engines/nvme.h b/engines/nvme.h
new file mode 100644
index 00000000..70a89b74
--- /dev/null
+++ b/engines/nvme.h
@@ -0,0 +1,214 @@
+/*
+ * nvme structure declarations and helper functions for the
+ * io_uring_cmd engine.
+ */
+
+#ifndef FIO_NVME_H
+#define FIO_NVME_H
+
+#include <linux/nvme_ioctl.h>
+#include "../fio.h"
+
+/*
+ * If the uapi headers installed on the system lacks nvme uring command
+ * support, use the local version to prevent compilation issues.
+ */
+#ifndef CONFIG_NVME_URING_CMD
+struct nvme_uring_cmd {
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u32	nsid;
+	__u32	cdw2;
+	__u32	cdw3;
+	__u64	metadata;
+	__u64	addr;
+	__u32	metadata_len;
+	__u32	data_len;
+	__u32	cdw10;
+	__u32	cdw11;
+	__u32	cdw12;
+	__u32	cdw13;
+	__u32	cdw14;
+	__u32	cdw15;
+	__u32	timeout_ms;
+	__u32   rsvd2;
+};
+
+#define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_uring_cmd)
+#define NVME_URING_CMD_IO_VEC	_IOWR('N', 0x81, struct nvme_uring_cmd)
+#endif /* CONFIG_NVME_URING_CMD */
+
+#define NVME_DEFAULT_IOCTL_TIMEOUT 0
+#define NVME_IDENTIFY_DATA_SIZE 4096
+#define NVME_IDENTIFY_CSI_SHIFT 24
+
+#define NVME_ZNS_ZRA_REPORT_ZONES 0
+#define NVME_ZNS_ZRAS_FEAT_ERZ (1 << 16)
+#define NVME_ZNS_ZSA_RESET 0x4
+#define NVME_ZONE_TYPE_SEQWRITE_REQ 0x2
+
+enum nvme_identify_cns {
+	NVME_IDENTIFY_CNS_NS		= 0x00,
+	NVME_IDENTIFY_CNS_CSI_NS	= 0x05,
+	NVME_IDENTIFY_CNS_CSI_CTRL	= 0x06,
+};
+
+enum nvme_csi {
+	NVME_CSI_NVM			= 0,
+	NVME_CSI_KV			= 1,
+	NVME_CSI_ZNS			= 2,
+};
+
+enum nvme_admin_opcode {
+	nvme_admin_identify		= 0x06,
+};
+
+enum nvme_io_opcode {
+	nvme_cmd_write			= 0x01,
+	nvme_cmd_read			= 0x02,
+	nvme_zns_cmd_mgmt_send		= 0x79,
+	nvme_zns_cmd_mgmt_recv		= 0x7a,
+};
+
+enum nvme_zns_zs {
+	NVME_ZNS_ZS_EMPTY		= 0x1,
+	NVME_ZNS_ZS_IMPL_OPEN		= 0x2,
+	NVME_ZNS_ZS_EXPL_OPEN		= 0x3,
+	NVME_ZNS_ZS_CLOSED		= 0x4,
+	NVME_ZNS_ZS_READ_ONLY		= 0xd,
+	NVME_ZNS_ZS_FULL		= 0xe,
+	NVME_ZNS_ZS_OFFLINE		= 0xf,
+};
+
+struct nvme_data {
+	__u32 nsid;
+	__u32 lba_shift;
+};
+
+struct nvme_lbaf {
+	__le16			ms;
+	__u8			ds;
+	__u8			rp;
+};
+
+struct nvme_id_ns {
+	__le64			nsze;
+	__le64			ncap;
+	__le64			nuse;
+	__u8			nsfeat;
+	__u8			nlbaf;
+	__u8			flbas;
+	__u8			mc;
+	__u8			dpc;
+	__u8			dps;
+	__u8			nmic;
+	__u8			rescap;
+	__u8			fpi;
+	__u8			dlfeat;
+	__le16			nawun;
+	__le16			nawupf;
+	__le16			nacwu;
+	__le16			nabsn;
+	__le16			nabo;
+	__le16			nabspf;
+	__le16			noiob;
+	__u8			nvmcap[16];
+	__le16			npwg;
+	__le16			npwa;
+	__le16			npdg;
+	__le16			npda;
+	__le16			nows;
+	__le16			mssrl;
+	__le32			mcl;
+	__u8			msrc;
+	__u8			rsvd81[11];
+	__le32			anagrpid;
+	__u8			rsvd96[3];
+	__u8			nsattr;
+	__le16			nvmsetid;
+	__le16			endgid;
+	__u8			nguid[16];
+	__u8			eui64[8];
+	struct nvme_lbaf	lbaf[16];
+	__u8			rsvd192[192];
+	__u8			vs[3712];
+};
+
+static inline int ilog2(uint32_t i)
+{
+	int log = -1;
+
+	while (i) {
+		i >>= 1;
+		log++;
+	}
+	return log;
+}
+
+struct nvme_zns_lbafe {
+	__le64	zsze;
+	__u8	zdes;
+	__u8	rsvd9[7];
+};
+
+struct nvme_zns_id_ns {
+	__le16			zoc;
+	__le16			ozcs;
+	__le32			mar;
+	__le32			mor;
+	__le32			rrl;
+	__le32			frl;
+	__le32			rrl1;
+	__le32			rrl2;
+	__le32			rrl3;
+	__le32			frl1;
+	__le32			frl2;
+	__le32			frl3;
+	__le32			numzrwa;
+	__le16			zrwafg;
+	__le16			zrwasz;
+	__u8			zrwacap;
+	__u8			rsvd53[2763];
+	struct nvme_zns_lbafe	lbafe[64];
+	__u8			vs[256];
+};
+
+struct nvme_zns_desc {
+	__u8	zt;
+	__u8	zs;
+	__u8	za;
+	__u8	zai;
+	__u8	rsvd4[4];
+	__le64	zcap;
+	__le64	zslba;
+	__le64	wp;
+	__u8	rsvd32[32];
+};
+
+struct nvme_zone_report {
+	__le64			nr_zones;
+	__u8			rsvd8[56];
+	struct nvme_zns_desc	entries[];
+};
+
+int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
+		      __u64 *nlba);
+
+int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+			    struct iovec *iov);
+
+int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			     enum zbd_zoned_model *model);
+
+int fio_nvme_report_zones(struct thread_data *td, struct fio_file *f,
+			  uint64_t offset, struct zbd_zone *zbdz,
+			  unsigned int nr_zones);
+
+int fio_nvme_reset_wp(struct thread_data *td, struct fio_file *f,
+		      uint64_t offset, uint64_t length);
+
+int fio_nvme_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+				unsigned int *max_open_zones);
+
+#endif
diff --git a/examples/uring-cmd-ng.fio b/examples/uring-cmd-ng.fio
new file mode 100644
index 00000000..b2888a00
--- /dev/null
+++ b/examples/uring-cmd-ng.fio
@@ -0,0 +1,25 @@
+# io_uring_cmd I/O engine for nvme-ns generic character device
+
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+size=1G
+iodepth=32
+bs=4K
+thread=1
+stonewall=1
+
+[rand-write]
+rw=randwrite
+sqthread_poll=1
+
+[rand-read]
+rw=randread
+
+[write-opts]
+rw=write
+sqthread_poll=1
+sqthread_poll_cpu=0
+nonvectored=1
+registerfiles=1
diff --git a/examples/uring-cmd-zoned.fio b/examples/uring-cmd-zoned.fio
new file mode 100644
index 00000000..58e8f79e
--- /dev/null
+++ b/examples/uring-cmd-zoned.fio
@@ -0,0 +1,31 @@
+# io_uring_cmd I/O engine for nvme-ns generic zoned character device
+#
+# NOTE: with write workload iodepth must be set to 1 as there is no IO
+# scheduler.
+
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+zonemode=zbd
+size=1G
+iodepth=1
+bs=256K
+verify=crc32c
+stonewall=1
+
+[rand-write]
+rw=randwrite
+
+[write-opts]
+rw=write
+registerfiles=1
+sqthread_poll=1
+sqthread_poll_cpu=0
+
+[randwrite-opts]
+rw=randwrite
+sqthread_poll=1
+sqthread_poll_cpu=0
+nonvectored=1
+registerfiles=1
diff --git a/file.h b/file.h
index faf65a2a..da1b8947 100644
--- a/file.h
+++ b/file.h
@@ -126,12 +126,14 @@ struct fio_file {
 	unsigned int last_write_idx;
 
 	/*
-	 * For use by the io engine for offset or private data storage
+	 * For use by the io engine to store offset
 	 */
-	union {
-		uint64_t engine_pos;
-		void *engine_data;
-	};
+	uint64_t engine_pos;
+
+	/*
+	 * For use by the io engine for private data storage
+	 */
+	void *engine_data;
 
 	/*
 	 * if io is protected by a semaphore, this is set
diff --git a/fio.1 b/fio.1
index bdba3142..948c01f9 100644
--- a/fio.1
+++ b/fio.1
@@ -1739,6 +1739,15 @@ Basic \fBpreadv\fR\|(2) or \fBpwritev\fR\|(2) I/O.
 .B pvsync2
 Basic \fBpreadv2\fR\|(2) or \fBpwritev2\fR\|(2) I/O.
 .TP
+.B io_uring
+Fast Linux native asynchronous I/O. Supports async IO
+for both direct and buffered IO.
+This engine defines engine specific options.
+.TP
+.B io_uring_cmd
+Fast Linux native asynchronous I/O for passthrough commands.
+This engine defines engine specific options.
+.TP
 .B libaio
 Linux native asynchronous I/O. Note that Linux may only support
 queued behavior with non-buffered I/O (set `direct=1' or
@@ -2040,35 +2049,49 @@ for trim IOs are ignored. This option is mutually exclusive with the
 \fBcmdprio_percentage\fR option.
 .RE
 .TP
-.BI (io_uring)fixedbufs
+.BI (io_uring,io_uring_cmd)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO call, and
 release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
-.BI (io_uring,xnvme)hipri
+.BI (io_uring,io_uring_cmd)nonvectored
+With this option, fio will use non-vectored read/write commands, where address
+must contain the address directly. Default is -1.
+.TP
+.BI (io_uring,io_uring_cmd)force_async
+Normal operation for io_uring is to try and issue an sqe as non-blocking first,
+and if that fails, execute it in an async manner. With this option set to N,
+then every N request fio will ask sqe to be issued in an async manner. Default
+is 0.
+.TP
+.BI (io_uring,io_uring_cmd,xnvme)hipri
 If this option is set, fio will attempt to use polled IO completions. Normal IO
 completions generate interrupts to signal the completion of IO, polled
 completions do not. Hence they are require active reaping by the application.
 The benefits are more efficient IO for high IOPS scenarios, and lower latencies
 for low queue depth IO.
 .TP
-.BI (io_uring)registerfiles
+.BI (io_uring,io_uring_cmd)registerfiles
 With this option, fio registers the set of files being used with the kernel.
 This avoids the overhead of managing file counts in the kernel, making the
 submission and completion part more lightweight. Required for the below
 sqthread_poll option.
 .TP
-.BI (io_uring,xnvme)sqthread_poll
+.BI (io_uring,io_uring_cmd,xnvme)sqthread_poll
 Normally fio will submit IO by issuing a system call to notify the kernel of
 available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
 the cost of using more CPU in the system.
 .TP
-.BI (io_uring)sqthread_poll_cpu
+.BI (io_uring,io_uring_cmd)sqthread_poll_cpu
 When `sqthread_poll` is set, this option provides a way to define which CPU
 should be used for the polling thread.
 .TP
+.BI (io_uring_cmd)cmd_type \fR=\fPstr
+Specifies the type of uring passthrough command to be used. Supported
+value is nvme. Default is nvme.
+.TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
 \fBio_getevents\fR\|(3) system call to reap newly returned events. With
diff --git a/init.c b/init.c
index f7d702f8..da800776 100644
--- a/init.c
+++ b/init.c
@@ -2810,6 +2810,15 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				break;
 
 			ret = fio_cmd_ioengine_option_parse(td, opt, val);
+
+			if (ret) {
+				if (td) {
+					put_job(td);
+					td = NULL;
+				}
+				do_exit++;
+				exit_val = 1;
+			}
 			break;
 		}
 		case 'w':
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 42b2fe84..929997f8 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -22,6 +22,7 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u32	cmd_op;
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
@@ -60,7 +61,17 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	__pad2[2];
+	union {
+		struct {
+			__u64	addr3;
+			__u64	__pad2[1];
+		};
+		/*
+		 * If the ring is initialized with IORING_SETUP_SQE128, then
+		 * this field is used for 80 bytes of arbitrary command data
+		 */
+		__u8	cmd[0];
+	};
 };
 
 enum {
@@ -101,6 +112,24 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+/*
+ * Cooperative task running. When requests complete, they often require
+ * forcing the submitter to transition to the kernel to complete. If this
+ * flag is set, work will be done when the task transitions anyway, rather
+ * than force an inter-processor interrupt reschedule. This avoids interrupting
+ * a task running in userspace, and saves an IPI.
+ */
+#define IORING_SETUP_COOP_TASKRUN	(1U << 8)
+/*
+ * If COOP_TASKRUN is set, get notified if task work is available for
+ * running and a kernel transition would be needed to run it. This sets
+ * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
+ */
+#define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
+
+#define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
+#define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
 
 enum {
 	IORING_OP_NOP,
@@ -143,6 +172,14 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_MSG_RING,
+	IORING_OP_FSETXATTR,
+	IORING_OP_SETXATTR,
+	IORING_OP_FGETXATTR,
+	IORING_OP_GETXATTR,
+	IORING_OP_SOCKET,
+	IORING_OP_URING_CMD,
+
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -192,6 +229,12 @@ struct io_uring_cqe {
 	__u64	user_data;	/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
+
+	/*
+	 * If the ring is initialized with IORING_SETUP_CQE32, then this field
+	 * contains 16-bytes of padding, doubling the size of the CQE.
+	 */
+	__u64 big_cqe[];
 };
 
 /*
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 7e2fff00..d4aaa813 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -229,6 +229,14 @@ require_regular_block_dev() {
 	return 0
 }
 
+require_block_dev() {
+	if [[ -b "$realdev" ]]; then
+		return 0
+	fi
+	SKIP_REASON="$dev is not a block device"
+	return 1
+}
+
 require_seq_zones() {
 	local req_seq_zones=${1}
 	local seq_bytes=$((disk_size - first_sequential_zone_sector * 512))
@@ -251,8 +259,19 @@ require_conv_zones() {
 	return 0
 }
 
-# Check whether buffered writes are refused.
+require_max_open_zones() {
+	local min=${1}
+
+	if ((max_open_zones !=0 && max_open_zones < min)); then
+		SKIP_REASON="max_open_zones of $dev is smaller than $min"
+		return 1
+	fi
+	return 0
+}
+
+# Check whether buffered writes are refused for block devices.
 test1() {
+    require_block_dev || return $SKIP_TESTCASE
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
 	    "$(ioengine "psync")" --size="${zone_size}" --thread=1	\
 	    --zonemode=zbd --zonesize="${zone_size}" 2>&1 |
@@ -453,6 +472,8 @@ test12() {
 test13() {
     local size off capacity
 
+    require_max_open_zones 4 || return $SKIP_TESTCASE
+
     prep_write
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
diff --git a/zbd.c b/zbd.c
index b1fd6b4b..627fb968 100644
--- a/zbd.c
+++ b/zbd.c
@@ -466,7 +466,7 @@ out:
 	return res;
 }
 
-/* Verify whether direct I/O is used for all host-managed zoned drives. */
+/* Verify whether direct I/O is used for all host-managed zoned block drives. */
 static bool zbd_using_direct_io(void)
 {
 	struct thread_data *td;
@@ -477,7 +477,7 @@ static bool zbd_using_direct_io(void)
 		if (td->o.odirect || !(td->o.td_ddir & TD_DDIR_WRITE))
 			continue;
 		for_each_file(td, f, j) {
-			if (f->zbd_info &&
+			if (f->zbd_info && f->filetype == FIO_TYPE_BLOCK &&
 			    f->zbd_info->model == ZBD_HOST_MANAGED)
 				return false;
 		}
