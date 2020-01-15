Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgAONAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jan 2020 08:00:06 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iriHG-0002kr-Aa
        for fio@vger.kernel.org; Wed, 15 Jan 2020 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200115130002.005B91BC0CE2@kernel.dk>
Date: Wed, 15 Jan 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7eff05d723d1330a5407b2bdd9145f1bfb6dd0e1:

  time: limit usec_sleep() to maximum intervals of 1 second (2020-01-13 14:51:35 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3f1e3af7cff07d4aedcd9a58ae00cb1a2189fcc2:

  engines/io_uring: use fixed opcodes for pre-mapped buffers (2020-01-14 14:27:22 -0700)

----------------------------------------------------------------
Keith Busch (1):
      engines/io_uring: use fixed opcodes for pre-mapped buffers

 engines/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 4f6a9678..329f2f07 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -84,6 +84,11 @@ static const int ddir_to_op[2][2] = {
 	{ IORING_OP_WRITEV, IORING_OP_WRITE }
 };
 
+static const int fixed_ddir_to_op[2] = {
+	IORING_OP_READ_FIXED,
+	IORING_OP_WRITE_FIXED
+};
+
 static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 {
 	struct ioring_options *o = data;
@@ -189,12 +194,13 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
-		sqe->opcode = ddir_to_op[io_u->ddir][!!o->nonvectored];
 		if (o->fixedbufs) {
+			sqe->opcode = fixed_ddir_to_op[io_u->ddir];
 			sqe->addr = (unsigned long) io_u->xfer_buf;
 			sqe->len = io_u->xfer_buflen;
 			sqe->buf_index = io_u->index;
 		} else {
+			sqe->opcode = ddir_to_op[io_u->ddir][!!o->nonvectored];
 			if (o->nonvectored) {
 				sqe->addr = (unsigned long)
 						ld->iovecs[io_u->index].iov_base;

