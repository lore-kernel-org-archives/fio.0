Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39970 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfKZNA0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Nov 2019 08:00:26 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iZaRy-00013u-Tp
        for fio@vger.kernel.org; Tue, 26 Nov 2019 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191126130001.AF6DA1BC016A@kernel.dk>
Date: Tue, 26 Nov 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b048455fef67dad4ef96ce0393937322e3165b58:

  t/run-fio-tests: improve error handling (2019-11-14 14:07:25 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5a9d5c4ab5f7cea83dc94e7cd23ecceb45b68134:

  Merge branch 'rados-now-use-completion-callbacks' of https://github.com/aclamk/fio (2019-11-25 21:40:38 -0700)

----------------------------------------------------------------
Adam Kupczyk (1):
      engines/rados: changed polling to completion callbacks methodology

Jens Axboe (2):
      Merge branch 'const1' of https://github.com/kusumi/fio
      Merge branch 'rados-now-use-completion-callbacks' of https://github.com/aclamk/fio

Tomohiro Kusumi (1):
      parse: Silence discard-const warning on OpenBSD

 engines/rados.c | 105 +++++++++++++++++++++++++++++---------------------------
 parse.c         |  15 +++++++-
 2 files changed, 68 insertions(+), 52 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rados.c b/engines/rados.c
index 86100dc4..cde538b9 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -11,20 +11,24 @@
 #include "fio.h"
 #include "../optgroup.h"
 
+struct rados_data {
+        rados_t cluster;
+        rados_ioctx_t io_ctx;
+        struct io_u **aio_events;
+        bool connected;
+        pthread_mutex_t completed_lock;
+        pthread_cond_t completed_more_io;
+        struct flist_head completed_operations;
+};
+
 struct fio_rados_iou {
+	struct flist_head list;
 	struct thread_data *td;
 	struct io_u *io_u;
 	rados_completion_t completion;
 	rados_write_op_t write_op;
 };
 
-struct rados_data {
-	rados_t cluster;
-	rados_ioctx_t io_ctx;
-	struct io_u **aio_events;
-	bool connected;
-};
-
 /* fio configuration options read from the job file */
 struct rados_options {
 	void *pad;
@@ -94,6 +98,9 @@ static int _fio_setup_rados_data(struct thread_data *td,
 	rados->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!rados->aio_events)
 		goto failed;
+	pthread_mutex_init(&rados->completed_lock, NULL);
+	pthread_cond_init(&rados->completed_more_io, NULL);
+	INIT_FLIST_HEAD(&rados->completed_operations);
 	*rados_data_ptr = rados;
 	return 0;
 
@@ -229,6 +236,18 @@ static void fio_rados_cleanup(struct thread_data *td)
 	}
 }
 
+static void complete_callback(rados_completion_t cb, void *arg)
+{
+	struct fio_rados_iou *fri = (struct fio_rados_iou *)arg;
+	struct rados_data *rados = fri->td->io_ops_data;
+	assert(fri->completion);
+	assert(rados_aio_is_complete(fri->completion));
+	pthread_mutex_lock(&rados->completed_lock);
+	flist_add_tail(&fri->list, &rados->completed_operations);
+	pthread_mutex_unlock(&rados->completed_lock);
+	pthread_cond_signal(&rados->completed_more_io);
+}
+
 static enum fio_q_status fio_rados_queue(struct thread_data *td,
 					 struct io_u *io_u)
 {
@@ -240,7 +259,7 @@ static enum fio_q_status fio_rados_queue(struct thread_data *td,
 	fio_ro_check(td, io_u);
 
 	if (io_u->ddir == DDIR_WRITE) {
-		 r = rados_aio_create_completion(fri, NULL,
+		 r = rados_aio_create_completion(fri, complete_callback,
 			NULL, &fri->completion);
 		if (r < 0) {
 			log_err("rados_aio_create_completion failed.\n");
@@ -255,7 +274,7 @@ static enum fio_q_status fio_rados_queue(struct thread_data *td,
 		}
 		return FIO_Q_QUEUED;
 	} else if (io_u->ddir == DDIR_READ) {
-		r = rados_aio_create_completion(fri, NULL,
+		r = rados_aio_create_completion(fri, complete_callback,
 			NULL, &fri->completion);
 		if (r < 0) {
 			log_err("rados_aio_create_completion failed.\n");
@@ -269,7 +288,7 @@ static enum fio_q_status fio_rados_queue(struct thread_data *td,
 		}
 		return FIO_Q_QUEUED;
 	} else if (io_u->ddir == DDIR_TRIM) {
-		r = rados_aio_create_completion(fri, NULL,
+		r = rados_aio_create_completion(fri, complete_callback,
 			NULL , &fri->completion);
 		if (r < 0) {
 			log_err("rados_aio_create_completion failed.\n");
@@ -313,50 +332,33 @@ int fio_rados_getevents(struct thread_data *td, unsigned int min,
 	unsigned int max, const struct timespec *t)
 {
 	struct rados_data *rados = td->io_ops_data;
-	struct rados_options *o = td->eo;
-	int busy_poll = o->busy_poll;
 	unsigned int events = 0;
-	struct io_u *u;
 	struct fio_rados_iou *fri;
-	unsigned int i;
-	rados_completion_t first_unfinished;
-	int observed_new = 0;
-
-	/* loop through inflight ios until we find 'min' completions */
-	do {
-		first_unfinished = NULL;
-		io_u_qiter(&td->io_u_all, u, i) {
-			if (!(u->flags & IO_U_F_FLIGHT))
-				continue;
-
-			fri = u->engine_data;
-			if (fri->completion) {
-				if (rados_aio_is_complete(fri->completion)) {
-					if (fri->write_op != NULL) {
-						rados_release_write_op(fri->write_op);
-						fri->write_op = NULL;
-					}
-					rados_aio_release(fri->completion);
-					fri->completion = NULL;
-					rados->aio_events[events] = u;
-					events++;
-					observed_new = 1;
-				} else if (first_unfinished == NULL) {
-					first_unfinished = fri->completion;
-				}
-			}
-			if (events >= max)
-				break;
+
+	pthread_mutex_lock(&rados->completed_lock);
+	while (events < min) {
+		while (flist_empty(&rados->completed_operations)) {
+			pthread_cond_wait(&rados->completed_more_io, &rados->completed_lock);
 		}
-		if (events >= min)
-			return events;
-		if (first_unfinished == NULL || busy_poll)
-			continue;
-
-		if (!observed_new)
-			rados_aio_wait_for_complete(first_unfinished);
-	} while (1);
-  return events;
+		assert(!flist_empty(&rados->completed_operations));
+		
+		fri = flist_last_entry(&rados->completed_operations, struct fio_rados_iou, list);
+		assert(fri->completion);
+		assert(rados_aio_is_complete(fri->completion));
+		if (fri->write_op != NULL) {
+			rados_release_write_op(fri->write_op);
+			fri->write_op = NULL;
+		}
+		rados_aio_release(fri->completion);
+		fri->completion = NULL;
+
+		rados->aio_events[events] = fri->io_u;
+		events ++;
+		flist_del(&fri->list);
+		if (events >= max) break;
+	}
+	pthread_mutex_unlock(&rados->completed_lock);
+	return events;
 }
 
 static int fio_rados_setup(struct thread_data *td)
@@ -425,6 +427,7 @@ static int fio_rados_io_u_init(struct thread_data *td, struct io_u *io_u)
 	fri = calloc(1, sizeof(*fri));
 	fri->io_u = io_u;
 	fri->td = td;
+	INIT_FLIST_HEAD(&fri->list);
 	io_u->engine_data = fri;
 	return 0;
 }
diff --git a/parse.c b/parse.c
index 483a62f6..04b2e198 100644
--- a/parse.c
+++ b/parse.c
@@ -1048,7 +1048,20 @@ struct fio_option *find_option(struct fio_option *options, const char *opt)
 const struct fio_option *
 find_option_c(const struct fio_option *options, const char *opt)
 {
-	return find_option((struct fio_option *)options, opt);
+	const struct fio_option *o;
+
+	for (o = &options[0]; o->name; o++) {
+		if (!o_match(o, opt))
+			continue;
+		if (o->type == FIO_OPT_UNSUPPORTED) {
+			log_err("Option <%s>: %s\n", o->name, o->help);
+			continue;
+		}
+
+		return o;
+	}
+
+	return NULL;
 }
 
 static const struct fio_option *

