Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730111AbgIIMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Sep 2020 08:00:15 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC09C06179F
        for <fio@vger.kernel.org>; Wed,  9 Sep 2020 05:00:05 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFylf-0000uE-94
        for fio@vger.kernel.org; Wed, 09 Sep 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200909120001.E94EA1BC01EC@kernel.dk>
Date: Wed,  9 Sep 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit be23e6be4fadb723f925824f88fbaedbd3502251:

  Kill off old GUASI IO engine (2020-09-07 13:38:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ca8ff0968cec7ee47ca7fe5b40f592c2b332b062:

  Merge branch 'zbd' of https://github.com/bvanassche/fio into master (2020-09-08 10:25:48 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      zbd: Add a missing pthread_mutex_unlock() call

Jens Axboe (2):
      engines/io_uring: allow setting of IOSQE_ASYNC
      Merge branch 'zbd' of https://github.com/bvanassche/fio into master

 engines/io_uring.c | 16 ++++++++++++++++
 zbd.c              |  1 +
 2 files changed, 17 insertions(+)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index ca5b90c9..e2b5e6ee 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -66,6 +66,7 @@ struct ioring_data {
 	unsigned iodepth;
 	bool ioprio_class_set;
 	bool ioprio_set;
+	int prepped;
 
 	struct ioring_mmap mmap[3];
 };
@@ -82,6 +83,7 @@ struct ioring_options {
 	unsigned int nonvectored;
 	unsigned int uncached;
 	unsigned int nowait;
+	unsigned int force_async;
 };
 
 static const int ddir_to_op[2][2] = {
@@ -197,6 +199,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "force_async",
+		.lname	= "Force async",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, force_async),
+		.help	= "Set IOSQE_ASYNC every N requests",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -277,6 +288,11 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		}
 	}
 
+	if (o->force_async && ++ld->prepped == o->force_async) {
+		ld->prepped = 0;
+		sqe->flags |= IOSQE_ASYNC;
+	}
+
 	sqe->user_data = (unsigned long) io_u;
 	return 0;
 }
diff --git a/zbd.c b/zbd.c
index e8ecbb6f..905c0c2b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1546,6 +1546,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING && td_write(td)) {
 			zb = zbd_replay_write_order(td, io_u, zb);
+			pthread_mutex_unlock(&zb->mutex);
 			goto accept;
 		}
 		/*

