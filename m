Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38258 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfEUMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 May 2019 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT3R5-0002YX-Qh
        for fio@vger.kernel.org; Tue, 21 May 2019 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190521120001.A38D32C00A7@kernel.dk>
Date: Tue, 21 May 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d5495f0b72f8fbecb97192da430720aa56f8feb9:

  stat: remove terse v2 blank lines with description not set (2019-05-16 08:42:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a819dfb6b6b1e1e1339bbd8c3a446b52b5e7575c:

  io_uring: sync with liburing/kernel (2019-05-20 08:49:49 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: sync with liburing/kernel

 os/linux/io_uring.h | 6 ++++++
 1 file changed, 6 insertions(+)

---

Diff of recent changes:

diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index e2340869..ce03151e 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -26,6 +26,7 @@ struct io_uring_sqe {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
 		__u16		poll_events;
+		__u32		sync_range_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -38,6 +39,8 @@ struct io_uring_sqe {
  * sqe->flags
  */
 #define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
+#define IOSQE_IO_DRAIN		(1U << 1)	/* issue after inflight IO */
+#define IOSQE_IO_LINK		(1U << 2)	/* next IO depends on this one */
 
 /*
  * io_uring_setup() flags
@@ -54,6 +57,7 @@ struct io_uring_sqe {
 #define IORING_OP_WRITE_FIXED	5
 #define IORING_OP_POLL_ADD	6
 #define IORING_OP_POLL_REMOVE	7
+#define IORING_OP_SYNC_FILE_RANGE	8
 
 /*
  * sqe->fsync_flags
@@ -133,5 +137,7 @@ struct io_uring_params {
 #define IORING_UNREGISTER_BUFFERS	1
 #define IORING_REGISTER_FILES		2
 #define IORING_UNREGISTER_FILES		3
+#define IORING_REGISTER_EVENTFD		4
+#define IORING_UNREGISTER_EVENTFD	5
 
 #endif

