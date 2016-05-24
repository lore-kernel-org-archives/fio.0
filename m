Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541AbcEXPD2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 May 2016 11:03:28 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6F1D9AC23
	for <fio@vger.kernel.org>; Tue, 24 May 2016 15:03:26 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] Fix occasional hangs on mutexes
Date: Tue, 24 May 2016 17:03:22 +0200
Message-Id: <1464102202-16724-2-git-send-email-jack@suse.cz>
In-Reply-To: <1464102202-16724-1-git-send-email-jack@suse.cz>
References: <1464102202-16724-1-git-send-email-jack@suse.cz>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>

When running xfstest generic/299 using fio on my test machine using
ramdisk as a backing store, I have noticed that fio often hangs waiting
for td->io_u_lock. After some debugging I have found out the reason is
that mutexes are created as process-private by default and but this
mutex is actually manipulated from several processes. The hang is not
obvious immediately as the mutex is located in shared memory and thus
while the locking is resolved in userspace, everything works as
expected. Only once we use kernel futexes, the process is not properly
woken up when futex is released.

Fix the problem by marking all mutexes and conditional variables that
are located in shared memory as shared.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 backend.c       | 29 +++++++++++++++++++++++++++--
 helper_thread.c | 28 ++++++++++++++++++++++++++--
 iolog.c         |  7 ++++++-
 workqueue.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 106 insertions(+), 10 deletions(-)

diff --git a/backend.c b/backend.c
index 95385bc0b8b3..4cdeb930a3e8 100644
--- a/backend.c
+++ b/backend.c
@@ -1426,6 +1426,7 @@ static void *thread_main(void *data)
 	struct thread_options *o = &td->o;
 	struct sk_out *sk_out = fd->sk_out;
 	pthread_condattr_t attr;
+	pthread_mutexattr_t mattr;
 	int clear_state;
 	int ret;
 
@@ -1450,10 +1451,34 @@ static void *thread_main(void *data)
 	INIT_FLIST_HEAD(&td->verify_list);
 	INIT_FLIST_HEAD(&td->trim_list);
 	INIT_FLIST_HEAD(&td->next_rand_list);
-	pthread_mutex_init(&td->io_u_lock, NULL);
 	td->io_hist_tree = RB_ROOT;
 
-	pthread_condattr_init(&attr);
+	ret = pthread_mutexattr_init(&mattr);
+	if (ret) {
+		td_verror(td, ret, "pthread_mutexattr_init");
+		goto err;
+	}
+#ifdef FIO_HAVE_PSHARED_MUTEX
+	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		td_verror(td, ret, "pthread_mutexattr_setpshared");
+		goto err;
+	}
+#endif
+	pthread_mutex_init(&td->io_u_lock, &mattr);
+
+	ret = pthread_condattr_init(&attr);
+	if (ret) {
+		td_verror(td, ret, "pthread_condattr_init");
+		goto err;
+	}
+#ifdef FIO_HAVE_PSHARED_MUTEX
+	ret = pthread_condattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		td_verror(td, ret, "pthread_condattr_setpshared");
+		goto err;
+	}
+#endif
 	pthread_cond_init(&td->verify_cond, &attr);
 	pthread_cond_init(&td->free_cond, &attr);
 
diff --git a/helper_thread.c b/helper_thread.c
index 1befabfca7a0..c14296fb51a2 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -142,14 +142,38 @@ int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
 {
 	struct helper_data *hd;
 	int ret;
+	pthread_condattr_t cattr;
+	pthread_mutexattr_t mattr;
 
 	hd = smalloc(sizeof(*hd));
 
 	setup_disk_util();
 
 	hd->sk_out = sk_out;
-	pthread_cond_init(&hd->cond, NULL);
-	pthread_mutex_init(&hd->lock, NULL);
+	ret = pthread_mutexattr_init(&mattr);
+	if (ret) {
+		log_err("pthread_mutexattr_init: %s\n", strerror(ret));
+		return 1;
+	}
+	ret = pthread_condattr_init(&cattr);
+	if (ret) {
+		log_err("pthread_condattr_init: %s\n", strerror(ret));
+		return 1;
+	}
+#ifdef FIO_HAVE_PSHARED_MUTEX
+	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		log_err("pthread_mutexattr_setpshared: %s\n", strerror(ret));
+		return 1;
+	}
+	ret = pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		log_err("pthread_mutexattr_setpshared: %s\n", strerror(ret));
+		return 1;
+	}
+#endif
+	pthread_cond_init(&hd->cond, &cattr);
+	pthread_mutex_init(&hd->lock, &mattr);
 	hd->startup_mutex = startup_mutex;
 
 	ret = pthread_create(&hd->thread, NULL, helper_thread_main, hd);
diff --git a/iolog.c b/iolog.c
index d9a17a5bcc44..e2f9776e3b5c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -576,6 +576,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 	       const char *filename)
 {
 	struct io_log *l;
+	pthread_mutexattr_t mattr;
 
 	l = scalloc(1, sizeof(*l));
 	INIT_FLIST_HEAD(&l->io_logs);
@@ -604,7 +605,11 @@ void setup_log(struct io_log **log, struct log_params *p,
 	if (l->log_gz && !p->td)
 		l->log_gz = 0;
 	else if (l->log_gz || l->log_gz_store) {
-		pthread_mutex_init(&l->chunk_lock, NULL);
+		pthread_mutexattr_init(&mattr);
+#ifdef FIO_HAVE_PSHARED_MUTEX
+		pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
+#endif
+		pthread_mutex_init(&l->chunk_lock, &mattr);
 		p->td->flags |= TD_F_COMPRESS_LOG;
 	}
 
diff --git a/workqueue.c b/workqueue.c
index 4f9c414ac119..13edafae38ca 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -276,10 +276,26 @@ static int start_worker(struct workqueue *wq, unsigned int index,
 {
 	struct submit_worker *sw = &wq->workers[index];
 	int ret;
+	pthread_condattr_t cattr;
+	pthread_mutexattr_t mattr;
 
 	INIT_FLIST_HEAD(&sw->work_list);
-	pthread_cond_init(&sw->cond, NULL);
-	pthread_mutex_init(&sw->lock, NULL);
+	ret = pthread_condattr_init(&cattr);
+	if (ret)
+		return ret;
+	ret = pthread_mutexattr_init(&mattr);
+	if (ret)
+		return ret;
+#ifdef FIO_HAVE_PSHARED_MUTEX
+	ret = pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
+	if (ret)
+		return ret;
+	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
+	if (ret)
+		return ret;
+#endif
+	pthread_cond_init(&sw->cond, &cattr);
+	pthread_mutex_init(&sw->lock, &mattr);
 	sw->wq = wq;
 	sw->index = index;
 	sw->sk_out = sk_out;
@@ -308,15 +324,41 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 {
 	unsigned int running;
 	int i, error;
+	int ret;
+	pthread_condattr_t cattr;
+	pthread_mutexattr_t mattr;
 
 	wq->max_workers = max_workers;
 	wq->td = td;
 	wq->ops = *ops;
 	wq->work_seq = 0;
 	wq->next_free_worker = 0;
-	pthread_cond_init(&wq->flush_cond, NULL);
-	pthread_mutex_init(&wq->flush_lock, NULL);
-	pthread_mutex_init(&wq->stat_lock, NULL);
+
+	ret = pthread_condattr_init(&cattr);
+	if (ret) {
+		td_verror(td, ret, "pthread_condattr_init");
+		goto err;
+	}
+	ret = pthread_mutexattr_init(&mattr);
+	if (ret) {
+		td_verror(td, ret, "pthread_mutexattr_init");
+		goto err;
+	}
+#ifdef FIO_HAVE_PSHARED_MUTEX
+	ret = pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		td_verror(td, ret, "pthread_condattr_setpshared");
+		goto err;
+	}
+	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		td_verror(td, ret, "pthread_mutexattr_setpshared");
+		goto err;
+	}
+#endif
+	pthread_cond_init(&wq->flush_cond, &cattr);
+	pthread_mutex_init(&wq->flush_lock, &mattr);
+	pthread_mutex_init(&wq->stat_lock, &mattr);
 
 	wq->workers = smalloc(wq->max_workers * sizeof(struct submit_worker));
 
-- 
2.6.6

