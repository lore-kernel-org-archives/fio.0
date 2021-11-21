Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91970C433FE
	for <fio@archiver.kernel.org>; Sun, 21 Nov 2021 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbhKUNDM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 21 Nov 2021 08:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237803AbhKUNDM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 21 Nov 2021 08:03:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794FEC061574
        for <fio@vger.kernel.org>; Sun, 21 Nov 2021 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=lA6GY6Ip9mPDvPqGcyXcUDvLMXgT09HeSlRiuczmKN0=; b=NDctqt1zirZBd2CQb86+8Suo8V
        pGVo+7cI7Jx/vrD7LvlBNhLb/XXStwXx8Er40Cz9iYIldjB5dxdGWv9sMVf25hogrpGnxDGFvDuxx
        ebF7jAvvp8KxoRO9tr2/tOuRbNGRjpwU7eLwE+R4L42jYnwlCaAQIYg6s3Ir9XAdHM+dv18BbFcuV
        58uFdugVJsMzYHDmNmN0QK8zwAJdCuzPeTbedYVYT2NIkqFLkJEmvHIDRTvCucx4jWNl3o/SPOLp0
        CaEmC9eH9lFAEbr3qQpoomsNyg8GS25AKFajv+/iRJMsRu1eLbrxSybKBp8Ps2VYiHLVL79//xjah
        wqXCV62g==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1momRw-00C4GK-G8
        for fio@vger.kernel.org; Sun, 21 Nov 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6DDE71BC0145; Sun, 21 Nov 2021 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211121130002.6DDE71BC0145@kernel.dk>
Date:   Sun, 21 Nov 2021 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit beda9d8d9e9148ff34eaa0eeb0cde19a36f47494:

  t/io_uring: add -R option for random/sequential IO (2021-11-19 10:44:15 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9f51d89c683d70cd8ab23ba09ec6e628a548af5a:

  Sync io_uring header with the kernel (2021-11-20 07:31:20 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      io_uring: clamp CQ size to SQ size
      Sync io_uring header with the kernel

 engines/io_uring.c  |   7 ++
 os/linux/io_uring.h | 186 ++++++++++++++++++++++++++++++++++++++++++----------
 t/io_uring.c        |   7 ++
 3 files changed, 167 insertions(+), 33 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 8b8f35f1..00ae3482 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -692,6 +692,13 @@ static int fio_ioring_queue_init(struct thread_data *td)
 		}
 	}
 
+	/*
+	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
+	 * than that.
+	 */
+	p.flags |= IORING_SETUP_CQSIZE;
+	p.cq_entries = depth;
+
 	ret = syscall(__NR_io_uring_setup, depth, &p);
 	if (ret < 0)
 		return ret;
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index d39b45fd..c45b5e9a 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -11,10 +11,6 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 /*
  * IO submission data structure (Submission Queue Entry)
  */
@@ -46,23 +42,25 @@ struct io_uring_sqe {
 		__u32		statx_flags;
 		__u32		fadvise_advice;
 		__u32		splice_flags;
+		__u32		rename_flags;
+		__u32		unlink_flags;
+		__u32		hardlink_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
+	/* pack this to avoid bogus arm OABI complaints */
 	union {
-		struct {
-			/* pack this to avoid bogus arm OABI complaints */
-			union {
-				/* index into fixed buffers, if used */
-				__u16	buf_index;
-				/* for grouped buffer selection */
-				__u16	buf_group;
-			} __attribute__((packed));
-			/* personality to use, if used */
-			__u16	personality;
-			__s32	splice_fd_in;
-		};
-		__u64	__pad2[3];
+		/* index into fixed buffers, if used */
+		__u16	buf_index;
+		/* for grouped buffer selection */
+		__u16	buf_group;
+	} __attribute__((packed));
+	/* personality to use, if used */
+	__u16	personality;
+	union {
+		__s32	splice_fd_in;
+		__u32	file_index;
 	};
+	__u64	__pad2[2];
 };
 
 enum {
@@ -99,6 +97,7 @@ enum {
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
+#define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 
 enum {
 	IORING_OP_NOP,
@@ -135,6 +134,12 @@ enum {
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
+	IORING_OP_SHUTDOWN,
+	IORING_OP_RENAMEAT,
+	IORING_OP_UNLINKAT,
+	IORING_OP_MKDIRAT,
+	IORING_OP_SYMLINKAT,
+	IORING_OP_LINKAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -148,14 +153,35 @@ enum {
 /*
  * sqe->timeout_flags
  */
-#define IORING_TIMEOUT_ABS	(1U << 0)
-
+#define IORING_TIMEOUT_ABS		(1U << 0)
+#define IORING_TIMEOUT_UPDATE		(1U << 1)
+#define IORING_TIMEOUT_BOOTTIME		(1U << 2)
+#define IORING_TIMEOUT_REALTIME		(1U << 3)
+#define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
+#define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
+#define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
+#define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
  * sqe->splice_flags
  * extends splice(2) flags
  */
 #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
 
+/*
+ * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
+ * command flags for POLL_ADD are stored in sqe->len.
+ *
+ * IORING_POLL_ADD_MULTI	Multishot poll. Sets IORING_CQE_F_MORE if
+ *				the poll handler will continue to report
+ *				CQEs on behalf of the same SQE.
+ *
+ * IORING_POLL_UPDATE		Update existing poll request, matching
+ *				sqe->addr as the old user_data field.
+ */
+#define IORING_POLL_ADD_MULTI	(1U << 0)
+#define IORING_POLL_UPDATE_EVENTS	(1U << 1)
+#define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
@@ -169,8 +195,10 @@ struct io_uring_cqe {
  * cqe->flags
  *
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
+ * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
+#define IORING_CQE_F_MORE		(1U << 1)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,
@@ -228,6 +256,8 @@ struct io_cqring_offsets {
  */
 #define IORING_ENTER_GETEVENTS	(1U << 0)
 #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
+#define IORING_ENTER_SQ_WAIT	(1U << 2)
+#define IORING_ENTER_EXT_ARG	(1U << 3)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -255,28 +285,85 @@ struct io_uring_params {
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
 #define IORING_FEAT_FAST_POLL		(1U << 5)
 #define IORING_FEAT_POLL_32BITS 	(1U << 6)
+#define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
+#define IORING_FEAT_EXT_ARG		(1U << 8)
+#define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
+#define IORING_FEAT_RSRC_TAGS		(1U << 10)
 
 /*
  * io_uring_register(2) opcodes and arguments
  */
-#define IORING_REGISTER_BUFFERS		0
-#define IORING_UNREGISTER_BUFFERS	1
-#define IORING_REGISTER_FILES		2
-#define IORING_UNREGISTER_FILES		3
-#define IORING_REGISTER_EVENTFD		4
-#define IORING_UNREGISTER_EVENTFD	5
-#define IORING_REGISTER_FILES_UPDATE	6
-#define IORING_REGISTER_EVENTFD_ASYNC	7
-#define IORING_REGISTER_PROBE		8
-#define IORING_REGISTER_PERSONALITY	9
-#define IORING_UNREGISTER_PERSONALITY	10
+enum {
+	IORING_REGISTER_BUFFERS			= 0,
+	IORING_UNREGISTER_BUFFERS		= 1,
+	IORING_REGISTER_FILES			= 2,
+	IORING_UNREGISTER_FILES			= 3,
+	IORING_REGISTER_EVENTFD			= 4,
+	IORING_UNREGISTER_EVENTFD		= 5,
+	IORING_REGISTER_FILES_UPDATE		= 6,
+	IORING_REGISTER_EVENTFD_ASYNC		= 7,
+	IORING_REGISTER_PROBE			= 8,
+	IORING_REGISTER_PERSONALITY		= 9,
+	IORING_UNREGISTER_PERSONALITY		= 10,
+	IORING_REGISTER_RESTRICTIONS		= 11,
+	IORING_REGISTER_ENABLE_RINGS		= 12,
+
+	/* extended with tagging */
+	IORING_REGISTER_FILES2			= 13,
+	IORING_REGISTER_FILES_UPDATE2		= 14,
+	IORING_REGISTER_BUFFERS2		= 15,
+	IORING_REGISTER_BUFFERS_UPDATE		= 16,
+
+	/* set/clear io-wq thread affinities */
+	IORING_REGISTER_IOWQ_AFF		= 17,
+	IORING_UNREGISTER_IOWQ_AFF		= 18,
+
+	/* set/get max number of io-wq workers */
+	IORING_REGISTER_IOWQ_MAX_WORKERS	= 19,
 
+	/* this goes last */
+	IORING_REGISTER_LAST
+};
+
+/* io-wq worker categories */
+enum {
+	IO_WQ_BOUND,
+	IO_WQ_UNBOUND,
+};
+
+/* deprecated, see struct io_uring_rsrc_update */
 struct io_uring_files_update {
 	__u32 offset;
 	__u32 resv;
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+struct io_uring_rsrc_register {
+	__u32 nr;
+	__u32 resv;
+	__u64 resv2;
+	__aligned_u64 data;
+	__aligned_u64 tags;
+};
+
+struct io_uring_rsrc_update {
+	__u32 offset;
+	__u32 resv;
+	__aligned_u64 data;
+};
+
+struct io_uring_rsrc_update2 {
+	__u32 offset;
+	__u32 resv;
+	__aligned_u64 data;
+	__aligned_u64 tags;
+	__u32 nr;
+	__u32 resv2;
+};
+
+/* Skip updating fd indexes set to this value in the fd table */
+#define IORING_REGISTER_FILES_SKIP	(-2)
+
 #define IO_URING_OP_SUPPORTED	(1U << 0)
 
 struct io_uring_probe_op {
@@ -294,8 +381,41 @@ struct io_uring_probe {
 	struct io_uring_probe_op ops[0];
 };
 
-#ifdef __cplusplus
-}
-#endif
+struct io_uring_restriction {
+	__u16 opcode;
+	union {
+		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
+		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
+		__u8 sqe_flags;   /* IORING_RESTRICTION_SQE_FLAGS_* */
+	};
+	__u8 resv;
+	__u32 resv2[3];
+};
+
+/*
+ * io_uring_restriction->opcode values
+ */
+enum {
+	/* Allow an io_uring_register(2) opcode */
+	IORING_RESTRICTION_REGISTER_OP		= 0,
+
+	/* Allow an sqe opcode */
+	IORING_RESTRICTION_SQE_OP		= 1,
+
+	/* Allow sqe flags */
+	IORING_RESTRICTION_SQE_FLAGS_ALLOWED	= 2,
+
+	/* Require sqe flags (these flags must be set on each submission) */
+	IORING_RESTRICTION_SQE_FLAGS_REQUIRED	= 3,
+
+	IORING_RESTRICTION_LAST
+};
+
+struct io_uring_getevents_arg {
+	__u64	sigmask;
+	__u32	sigmask_sz;
+	__u32	pad;
+	__u64	ts;
+};
 
 #endif
diff --git a/t/io_uring.c b/t/io_uring.c
index b79822d7..7bf215c7 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -384,6 +384,13 @@ static int io_uring_register_files(struct submitter *s)
 
 static int io_uring_setup(unsigned entries, struct io_uring_params *p)
 {
+	/*
+	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
+	 * than that.
+	 */
+	p->flags |= IORING_SETUP_CQSIZE;
+	p->cq_entries = entries;
+
 	return syscall(__NR_io_uring_setup, entries, p);
 }
 
