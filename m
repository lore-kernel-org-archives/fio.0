Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40032 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732044AbeKVXj3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Nov 2018 18:39:29 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gPoaa-0001QS-4d
        for fio@vger.kernel.org; Thu, 22 Nov 2018 13:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181122130001.DBBF02C00EE@kernel.dk>
Date: Thu, 22 Nov 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e65ef9593436f0f62df366f506f7c4d318b5cd71:

  engines/libaio: fallback to old io_setup() system call (2018-11-21 05:53:38 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0fcbc00994f49f73fe815b9dc074bd6a15eab522:

  engines/libaio: cleanup new vs old io_setup() system call path (2018-11-21 11:33:22 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      engines/libaio: the IOCTX_FLAG_* flags changed
      engines/libaio: use fio_memalign() helper for user iocbs
      engines/libaio: cleanup new vs old io_setup() system call path

 engines/libaio.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libaio.c b/engines/libaio.c
index 991d588..74238e4 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -12,17 +12,18 @@
 #include "../fio.h"
 #include "../lib/pow2.h"
 #include "../optgroup.h"
+#include "../lib/memalign.h"
 
 #ifndef IOCB_FLAG_HIPRI
 #define IOCB_FLAG_HIPRI	(1 << 2)
 #endif
-#ifndef IOCTX_FLAG_IOPOLL
-#define IOCTX_FLAG_IOPOLL	(1 << 0)
-#endif
+
 #ifndef IOCTX_FLAG_USERIOCB
-#define IOCTX_FLAG_USERIOCB	(1 << 1)
+#define IOCTX_FLAG_USERIOCB	(1 << 0)
+#endif
+#ifndef IOCTX_FLAG_IOPOLL
+#define IOCTX_FLAG_IOPOLL	(1 << 1)
 #endif
-
 
 static int fio_libaio_commit(struct thread_data *td);
 
@@ -111,6 +112,8 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 	else
 		iocb = &io_u->iocb;
 
+	iocb->u.c.flags = 0;
+
 	if (io_u->ddir == DDIR_READ) {
 		io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 		if (o->hipri)
@@ -387,8 +390,10 @@ static void fio_libaio_cleanup(struct thread_data *td)
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
-		if (ld->user_iocbs)
-			free(ld->user_iocbs);
+		if (ld->user_iocbs) {
+			size_t size = td->o.iodepth * sizeof(struct iocb);
+			fio_memfree(ld->user_iocbs, size, false);
+		}
 		free(ld);
 	}
 }
@@ -423,11 +428,9 @@ static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
 			&ld->aio_ctx);
 	if (!ret)
 		return 0;
-
-	return fio_libaio_old_queue_init(ld, depth, hipri, useriocb);
-#else
-	return fio_libaio_old_queue_init(ld, depth, hipri, useriocb);
+	/* fall through to old syscall */
 #endif
+	return fio_libaio_old_queue_init(ld, depth, hipri, useriocb);
 }
 
 static int fio_libaio_init(struct thread_data *td)
@@ -440,16 +443,11 @@ static int fio_libaio_init(struct thread_data *td)
 
 	if (o->useriocb) {
 		size_t size;
-		void *p;
 
 		ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
 		size = td->o.iodepth * sizeof(struct iocb);
-		if (posix_memalign(&p, page_size, size)) {
-			log_err("fio: libaio iocb allocation failure\n");
-			free(ld);
-			return 1;
-		}
-		ld->user_iocbs = p;
+		ld->user_iocbs = fio_memalign(page_size, size, false);
+		memset(ld->user_iocbs, 0, size);
 	}
 
 	/*
@@ -461,8 +459,10 @@ static int fio_libaio_init(struct thread_data *td)
 	if (err) {
 		td_verror(td, -err, "io_queue_init");
 		log_err("fio: check /proc/sys/fs/aio-max-nr\n");
-		if (ld->user_iocbs)
-			free(ld->user_iocbs);
+		if (ld->user_iocbs) {
+			size_t size = td->o.iodepth * sizeof(struct iocb);
+			fio_memfree(ld->user_iocbs, size, false);
+		}
 		free(ld);
 		return 1;
 	}

