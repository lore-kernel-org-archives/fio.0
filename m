Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgAJNAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Jan 2020 08:00:08 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipttX-00080B-Nv
        for fio@vger.kernel.org; Fri, 10 Jan 2020 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200110130002.2497E1BC015C@kernel.dk>
Date: Fri, 10 Jan 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2198a6b5a9f40726b40aced24cf2dcdb3b639898:

  Merge branch 'master' of https://github.com/bvanassche/fio (2020-01-06 18:38:02 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b7ed2a862ddafa7dbaa6299ee8633b6f8221e283:

  io_uring: set sqe iopriority, if prio/prioclass is set (2020-01-09 14:58:51 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: set sqe iopriority, if prio/prioclass is set

 engines/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 7c19294b..4f6a9678 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -206,6 +206,10 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		}
 		if (!td->o.odirect && o->uncached)
 			sqe->rw_flags = RWF_UNCACHED;
+		if (fio_option_is_set(&td->o, ioprio_class))
+			sqe->ioprio = td->o.ioprio_class << 13;
+		if (fio_option_is_set(&td->o, ioprio))
+			sqe->ioprio |= td->o.ioprio;
 		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
 		if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {

