Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52078 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727510AbeJBSnC (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 2 Oct 2018 14:43:02 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g7JLQ-0004iV-0h
        for fio@vger.kernel.org; Tue, 02 Oct 2018 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181002120001.EB7072C031B@kernel.dk>
Date: Tue,  2 Oct 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2bce52c621f0e1d7a360e8aedfe23300f8e56bb9:

  engines/cpu: fix potential overflow in thinktime calculation (2018-09-30 08:41:40 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 21f277b89029e7729d2dc631572244361ea7718c:

  engines/rados: use fio provided file names (2018-10-01 08:18:10 -0600)

----------------------------------------------------------------
Adam Kupczyk (1):
      engines/rados: use fio provided file names

 engines/rados.c | 52 +++++++++++++++-------------------------------------
 1 file changed, 15 insertions(+), 37 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rados.c b/engines/rados.c
index c6aec73..86100dc 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -21,8 +21,6 @@ struct fio_rados_iou {
 struct rados_data {
 	rados_t cluster;
 	rados_ioctx_t io_ctx;
-	char **objects;
-	size_t object_count;
 	struct io_u **aio_events;
 	bool connected;
 };
@@ -96,18 +94,11 @@ static int _fio_setup_rados_data(struct thread_data *td,
 	rados->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!rados->aio_events)
 		goto failed;
-
-	rados->object_count = td->o.nr_files;
-	rados->objects = calloc(rados->object_count, sizeof(char*));
-	if (!rados->objects)
-		goto failed;
-
 	*rados_data_ptr = rados;
 	return 0;
 
 failed:
 	if (rados) {
-		rados->object_count = 0;
 		if (rados->aio_events)
 			free(rados->aio_events);
 		free(rados);
@@ -115,15 +106,12 @@ failed:
 	return 1;
 }
 
-static void _fio_rados_rm_objects(struct rados_data *rados)
+static void _fio_rados_rm_objects(struct thread_data *td, struct rados_data *rados)
 {
 	size_t i;
-	for (i = 0; i < rados->object_count; ++i) {
-		if (rados->objects[i]) {
-			rados_remove(rados->io_ctx, rados->objects[i]);
-			free(rados->objects[i]);
-			rados->objects[i] = NULL;
-		}
+	for (i = 0; i < td->o.nr_files; i++) {
+		struct fio_file *f = td->files[i];
+		rados_remove(rados->io_ctx, f->file_name);
 	}
 }
 
@@ -136,7 +124,6 @@ static int _fio_rados_connect(struct thread_data *td)
 		td->o.size / (td->o.nr_files ? td->o.nr_files : 1u);
 	struct fio_file *f;
 	uint32_t i;
-	size_t oname_len = 0;
 
 	if (o->cluster_name) {
 		char *client_name = NULL;
@@ -165,6 +152,11 @@ static int _fio_rados_connect(struct thread_data *td)
 	} else
 		r = rados_create(&rados->cluster, o->client_name);
 
+	if (o->pool_name == NULL) {
+		log_err("rados pool name must be provided.\n");
+		goto failed_early;
+	}
+
 	if (r < 0) {
 		log_err("rados_create failed.\n");
 		goto failed_early;
@@ -188,30 +180,18 @@ static int _fio_rados_connect(struct thread_data *td)
 		goto failed_shutdown;
 	}
 
-	for (i = 0; i < rados->object_count; i++) {
+	for (i = 0; i < td->o.nr_files; i++) {
 		f = td->files[i];
 		f->real_file_size = file_size;
-		f->engine_pos = i;
-
-		oname_len = strlen(f->file_name) + 32;
-		rados->objects[i] = malloc(oname_len);
-		/* vary objects for different jobs */
-		snprintf(rados->objects[i], oname_len - 1,
-			"fio_rados_bench.%s.%x",
-			f->file_name, td->thread_number);
-		r = rados_write(rados->io_ctx, rados->objects[i], "", 0, 0);
+		r = rados_write(rados->io_ctx, f->file_name, "", 0, 0);
 		if (r < 0) {
-			free(rados->objects[i]);
-			rados->objects[i] = NULL;
-			log_err("error creating object.\n");
 			goto failed_obj_create;
 		}
 	}
-
-  return 0;
+	return 0;
 
 failed_obj_create:
-	_fio_rados_rm_objects(rados);
+	_fio_rados_rm_objects(td, rados);
 	rados_ioctx_destroy(rados->io_ctx);
 	rados->io_ctx = NULL;
 failed_shutdown:
@@ -226,8 +206,6 @@ static void _fio_rados_disconnect(struct rados_data *rados)
 	if (!rados)
 		return;
 
-	_fio_rados_rm_objects(rados);
-
 	if (rados->io_ctx) {
 		rados_ioctx_destroy(rados->io_ctx);
 		rados->io_ctx = NULL;
@@ -244,8 +222,8 @@ static void fio_rados_cleanup(struct thread_data *td)
 	struct rados_data *rados = td->io_ops_data;
 
 	if (rados) {
+		_fio_rados_rm_objects(td, rados);
 		_fio_rados_disconnect(rados);
-		free(rados->objects);
 		free(rados->aio_events);
 		free(rados);
 	}
@@ -256,7 +234,7 @@ static enum fio_q_status fio_rados_queue(struct thread_data *td,
 {
 	struct rados_data *rados = td->io_ops_data;
 	struct fio_rados_iou *fri = io_u->engine_data;
-	char *object = rados->objects[io_u->file->engine_pos];
+	char *object = io_u->file->file_name;
 	int r = -1;
 
 	fio_ro_check(td, io_u);

