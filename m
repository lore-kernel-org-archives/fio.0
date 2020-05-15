Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgEOMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 May 2020 08:00:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B82C061A0C
        for <fio@vger.kernel.org>; Fri, 15 May 2020 05:00:10 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZZ0Z-0006Oi-2t
        for fio@vger.kernel.org; Fri, 15 May 2020 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200515120002.077A01BC0163@kernel.dk>
Date: Fri, 15 May 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3ac77f9f5f7e3f2a5f9dababae810565f4c72eb7:

  Merge branch 'helper-thread-select' of https://github.com/vincentkfu/fio (2020-05-13 08:10:32 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 723f9bc5fe77ae8bedc08ed3ec3a25426b48c096:

  Merge branch 'rados' of https://github.com/vincentkfu/fio (2020-05-14 11:47:17 -0600)

----------------------------------------------------------------
Adam Kupczyk (1):
      engines/rados: Added waiting for completion on cleanup.

Jens Axboe (2):
      Merge branch 'rados-cleanup-wait' of https://github.com/aclamk/fio
      Merge branch 'rados' of https://github.com/vincentkfu/fio

Vincent Fu (1):
      engines/rados: fix build issue with thread_cond_t vs pthread_cond_t

 engines/rados.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rados.c b/engines/rados.c
index 30fcebb5..d4413427 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -12,13 +12,15 @@
 #include "../optgroup.h"
 
 struct rados_data {
-        rados_t cluster;
-        rados_ioctx_t io_ctx;
-        struct io_u **aio_events;
-        bool connected;
-        pthread_mutex_t completed_lock;
-        pthread_cond_t completed_more_io;
-        struct flist_head completed_operations;
+	rados_t cluster;
+	rados_ioctx_t io_ctx;
+	struct io_u **aio_events;
+	bool connected;
+	pthread_mutex_t completed_lock;
+	pthread_cond_t completed_more_io;
+	struct flist_head completed_operations;
+	uint64_t ops_scheduled;
+	uint64_t ops_completed;
 };
 
 struct fio_rados_iou {
@@ -101,6 +103,8 @@ static int _fio_setup_rados_data(struct thread_data *td,
 	pthread_mutex_init(&rados->completed_lock, NULL);
 	pthread_cond_init(&rados->completed_more_io, NULL);
 	INIT_FLIST_HEAD(&rados->completed_operations);
+	rados->ops_scheduled = 0;
+	rados->ops_completed = 0;
 	*rados_data_ptr = rados;
 	return 0;
 
@@ -227,8 +231,11 @@ static void _fio_rados_disconnect(struct rados_data *rados)
 static void fio_rados_cleanup(struct thread_data *td)
 {
 	struct rados_data *rados = td->io_ops_data;
-
 	if (rados) {
+		pthread_mutex_lock(&rados->completed_lock);
+		while (rados->ops_scheduled != rados->ops_completed)
+			pthread_cond_wait(&rados->completed_more_io, &rados->completed_lock);
+		pthread_mutex_unlock(&rados->completed_lock);
 		_fio_rados_rm_objects(td, rados);
 		_fio_rados_disconnect(rados);
 		free(rados->aio_events);
@@ -244,6 +251,7 @@ static void complete_callback(rados_completion_t cb, void *arg)
 	assert(rados_aio_is_complete(fri->completion));
 	pthread_mutex_lock(&rados->completed_lock);
 	flist_add_tail(&fri->list, &rados->completed_operations);
+	rados->ops_completed++;
 	pthread_mutex_unlock(&rados->completed_lock);
 	pthread_cond_signal(&rados->completed_more_io);
 }
@@ -272,6 +280,7 @@ static enum fio_q_status fio_rados_queue(struct thread_data *td,
 			log_err("rados_write failed.\n");
 			goto failed_comp;
 		}
+		rados->ops_scheduled++;
 		return FIO_Q_QUEUED;
 	} else if (io_u->ddir == DDIR_READ) {
 		r = rados_aio_create_completion(fri, complete_callback,
@@ -286,6 +295,7 @@ static enum fio_q_status fio_rados_queue(struct thread_data *td,
 			log_err("rados_aio_read failed.\n");
 			goto failed_comp;
 		}
+		rados->ops_scheduled++;
 		return FIO_Q_QUEUED;
 	} else if (io_u->ddir == DDIR_TRIM) {
 		r = rados_aio_create_completion(fri, complete_callback,
@@ -307,6 +317,7 @@ static enum fio_q_status fio_rados_queue(struct thread_data *td,
 			log_err("rados_aio_write_op_operate failed.\n");
 			goto failed_write_op;
 		}
+		rados->ops_scheduled++;
 		return FIO_Q_QUEUED;
 	 }
 

