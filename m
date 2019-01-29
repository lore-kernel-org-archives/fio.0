Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfA2NAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 29 Jan 2019 08:00:08 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1goSzn-0002Yo-Tj
        for fio@vger.kernel.org; Tue, 29 Jan 2019 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190129130002.1491B2C0199@kernel.dk>
Date: Tue, 29 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4c085cf20f5c0d083aca18680c4323a1fb2b7a1f:

  rate-submit: call ioengine post_init when starting workers (2019-01-24 13:58:00 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b532dd6d476679b08e4a56a60e8a7dd958779df9:

  io_uring: sync with kernel (2019-01-28 11:42:20 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'hygon-support' of https://github.com/hygonsoc/fio
      io_uring: sync with kernel

hygonsoc (1):
      Add Hygon SoC support to enable tsc_reliable feature

 arch/arch-x86-common.h | 2 +-
 engines/io_uring.c     | 3 ++-
 os/linux/io_uring.h    | 9 ++++++++-
 t/io_uring.c           | 2 ++
 4 files changed, 13 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index 7c07a61c..87925bdc 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -81,7 +81,7 @@ static inline void arch_init(char *envp[])
 	str[12] = '\0';
 	if (!strcmp(str, "GenuineIntel"))
 		arch_init_intel();
-	else if (!strcmp(str, "AuthenticAMD"))
+	else if (!strcmp(str, "AuthenticAMD") || !strcmp(str, "HygonGenuine"))
 		arch_init_amd();
 }
 
diff --git a/engines/io_uring.c b/engines/io_uring.c
index c759ec19..5279b1d0 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -340,7 +340,8 @@ static int fio_ioring_commit(struct thread_data *td)
 
 		read_barrier();
 		if (*ring->flags & IORING_SQ_NEED_WAKEUP)
-			io_uring_enter(ld, ld->queued, 0, 0);
+			io_uring_enter(ld, ld->queued, 0,
+					IORING_ENTER_SQ_WAKEUP);
 		ld->queued = 0;
 		return 0;
 	}
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 9bb71816..589b6402 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -11,6 +11,8 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 
+#define IORING_MAX_ENTRIES	4096
+
 /*
  * IO submission data structure (Submission Queue Entry)
  */
@@ -25,6 +27,7 @@ struct io_uring_sqe {
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
+		__u16		poll_events;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -51,6 +54,8 @@ struct io_uring_sqe {
 #define IORING_OP_FSYNC		3
 #define IORING_OP_READ_FIXED	4
 #define IORING_OP_WRITE_FIXED	5
+#define IORING_OP_POLL_ADD	6
+#define IORING_OP_POLL_REMOVE	7
 
 /*
  * sqe->fsync_flags
@@ -111,6 +116,7 @@ struct io_cqring_offsets {
  * io_uring_enter(2) flags
  */
 #define IORING_ENTER_GETEVENTS	(1 << 0)
+#define IORING_ENTER_SQ_WAKEUP	(1 << 1)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -120,7 +126,8 @@ struct io_uring_params {
 	__u32 cq_entries;
 	__u32 flags;
 	__u16 sq_thread_cpu;
-	__u16 resv[9];
+	__u16 sq_thread_idle;
+	__u16 resv[8];
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
diff --git a/t/io_uring.c b/t/io_uring.c
index da3b4d1f..9ded1590 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -315,6 +315,8 @@ submit:
 
 			if (to_wait)
 				flags = IORING_ENTER_GETEVENTS;
+			if (*ring->flags & IORING_SQ_NEED_WAKEUP)
+				flags |= IORING_ENTER_SQ_WAKEUP;
 			ret = io_uring_enter(s, to_submit, to_wait, flags);
 			s->calls++;
 		}

