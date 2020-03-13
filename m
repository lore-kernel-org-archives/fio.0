Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42298 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Mar 2020 08:00:06 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCiyy-0007wp-46
        for fio@vger.kernel.org; Fri, 13 Mar 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200313120001.D369A1BC00EA@kernel.dk>
Date: Fri, 13 Mar 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8324e5d5ffbe87080eebec1cd0c3c8a0751257de:

  Merge branch 'patch-1' of https://github.com/felixonmars/fio (2020-03-03 08:11:08 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f75248a9d9554b668484b089713e7c2b0a154ad6:

  Fio 3.19 (2020-03-12 11:12:50 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.19

Xiaoguang Wang (1):
      engines/io_uring: delete fio_option_is_set() calls when submitting sqes

 FIO-VERSION-GEN    |  2 +-
 engines/io_uring.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 6c2bcc8a..3220aaa1 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.18
+DEF_VER=fio-3.19
 
 LF='
 '
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1efc6cff..ac57af8f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -63,6 +63,8 @@ struct ioring_data {
 	int queued;
 	int cq_ring_off;
 	unsigned iodepth;
+	bool ioprio_class_set;
+	bool ioprio_set;
 
 	struct ioring_mmap mmap[3];
 };
@@ -233,9 +235,9 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		}
 		if (!td->o.odirect && o->uncached)
 			sqe->rw_flags = RWF_UNCACHED;
-		if (fio_option_is_set(&td->o, ioprio_class))
+		if (ld->ioprio_class_set)
 			sqe->ioprio = td->o.ioprio_class << 13;
-		if (fio_option_is_set(&td->o, ioprio))
+		if (ld->ioprio_set)
 			sqe->ioprio |= td->o.ioprio;
 		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
@@ -685,6 +687,12 @@ static int fio_ioring_init(struct thread_data *td)
 		td_verror(td, EINVAL, "fio_io_uring_init");
 		return 1;
 	}
+
+	if (fio_option_is_set(&td->o, ioprio_class))
+		ld->ioprio_class_set = true;
+	if (fio_option_is_set(&td->o, ioprio))
+		ld->ioprio_set = true;
+
 	return 0;
 }
 

