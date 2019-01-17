Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfAQNAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Jan 2019 08:00:19 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gk7HP-0003pS-Jn
        for fio@vger.kernel.org; Thu, 17 Jan 2019 13:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190117130001.9BC5C2C0089@kernel.dk>
Date: Thu, 17 Jan 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2b9415ddc260726c3ea9ae3436826f9181811143:

  engines/io_uring: ensure sqe stores are ordered SQ ring tail update (2019-01-15 22:06:05 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2d644205f56953192d27ccbf193c899ae559fcb7:

  engines/io_uring: cleanup setrlimit() (2019-01-16 09:07:13 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      io_uring: sync with upstream API
      engines/io_uring: cleanup setrlimit()

 engines/io_uring.c  | 24 +++++++++---------------
 os/linux/io_uring.h | 21 +--------------------
 t/io_uring.c        | 16 ++++------------
 3 files changed, 14 insertions(+), 47 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 8c5d9deb..c759ec19 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -154,7 +154,7 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 				sqe->opcode = IORING_OP_READ_FIXED;
 			else
 				sqe->opcode = IORING_OP_WRITE_FIXED;
-			sqe->addr = io_u->xfer_buf;
+			sqe->addr = (unsigned long) io_u->xfer_buf;
 			sqe->len = io_u->xfer_buflen;
 			sqe->buf_index = io_u->index;
 		} else {
@@ -162,7 +162,7 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 				sqe->opcode = IORING_OP_READV;
 			else
 				sqe->opcode = IORING_OP_WRITEV;
-			sqe->addr = &ld->iovecs[io_u->index];
+			sqe->addr = (unsigned long) &ld->iovecs[io_u->index];
 			sqe->len = 1;
 		}
 		sqe->off = io_u->offset;
@@ -462,15 +462,6 @@ static int fio_ioring_queue_init(struct thread_data *td)
 		}
 	}
 
-	if (o->fixedbufs) {
-		struct rlimit rlim = {
-			.rlim_cur = RLIM_INFINITY,
-			.rlim_max = RLIM_INFINITY,
-		};
-
-		setrlimit(RLIMIT_MEMLOCK, &rlim);
-	}
-
 	ret = syscall(__NR_sys_io_uring_setup, depth, &p);
 	if (ret < 0)
 		return ret;
@@ -478,13 +469,16 @@ static int fio_ioring_queue_init(struct thread_data *td)
 	ld->ring_fd = ret;
 
 	if (o->fixedbufs) {
-		struct io_uring_register_buffers reg = {
-			.iovecs = ld->iovecs,
-			.nr_iovecs = depth
+		struct rlimit rlim = {
+			.rlim_cur = RLIM_INFINITY,
+			.rlim_max = RLIM_INFINITY,
 		};
 
+		if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0)
+			return -1;
+
 		ret = syscall(__NR_sys_io_uring_register, ld->ring_fd,
-				IORING_REGISTER_BUFFERS, &reg);
+				IORING_REGISTER_BUFFERS, ld->iovecs, depth);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 71e92026..9bb71816 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -20,10 +20,7 @@ struct io_uring_sqe {
 	__u16	ioprio;		/* ioprio for the request */
 	__s32	fd;		/* file descriptor to do IO on */
 	__u64	off;		/* offset into file */
-	union {
-		void	*addr;	/* buffer or iovecs */
-		__u64	__pad;
-	};
+	__u64	addr;		/* pointer to buffer or iovecs */
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
 		__kernel_rwf_t	rw_flags;
@@ -136,20 +133,4 @@ struct io_uring_params {
 #define IORING_REGISTER_FILES		2
 #define IORING_UNREGISTER_FILES		3
 
-struct io_uring_register_buffers {
-	union {
-		struct iovec *iovecs;
-		__u64 pad;
-	};
-	__u32 nr_iovecs;
-};
-
-struct io_uring_register_files {
-	union {
-		__s32 *fds;
-		__u64 pad;
-	};
-	__u32 nr_fds;
-};
-
 #endif
diff --git a/t/io_uring.c b/t/io_uring.c
index ef5d52d1..da3b4d1f 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -96,21 +96,15 @@ static int do_nop = 0;		/* no-op SQ ring commands */
 
 static int io_uring_register_buffers(struct submitter *s)
 {
-	struct io_uring_register_buffers reg = {
-		.iovecs = s->iovecs,
-		.nr_iovecs = DEPTH
-	};
-
 	if (do_nop)
 		return 0;
 
 	return syscall(__NR_sys_io_uring_register, s->ring_fd,
-			IORING_REGISTER_BUFFERS, &reg);
+			IORING_REGISTER_BUFFERS, s->iovecs, DEPTH);
 }
 
 static int io_uring_register_files(struct submitter *s)
 {
-	struct io_uring_register_files reg;
 	int i;
 
 	if (do_nop)
@@ -121,11 +115,9 @@ static int io_uring_register_files(struct submitter *s)
 		s->fds[i] = s->files[i].real_fd;
 		s->files[i].fixed_fd = i;
 	}
-	reg.fds = s->fds;
-	reg.nr_fds = s->nr_files;
 
 	return syscall(__NR_sys_io_uring_register, s->ring_fd,
-			IORING_REGISTER_FILES, &reg);
+			IORING_REGISTER_FILES, s->fds, s->nr_files);
 }
 
 static int io_uring_setup(unsigned entries, struct io_uring_params *p)
@@ -187,12 +179,12 @@ static void init_io(struct submitter *s, unsigned index)
 	}
 	if (fixedbufs) {
 		sqe->opcode = IORING_OP_READ_FIXED;
-		sqe->addr = s->iovecs[index].iov_base;
+		sqe->addr = (unsigned long) s->iovecs[index].iov_base;
 		sqe->len = BS;
 		sqe->buf_index = index;
 	} else {
 		sqe->opcode = IORING_OP_READV;
-		sqe->addr = &s->iovecs[index];
+		sqe->addr = (unsigned long) &s->iovecs[index];
 		sqe->len = 1;
 		sqe->buf_index = 0;
 	}

