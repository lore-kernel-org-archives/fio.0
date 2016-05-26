Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbcEZMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 May 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1b5txL-0005gl-PL
	for fio@vger.kernel.org; Thu, 26 May 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160526120002.5DBF52C00B5@kernel.dk>
Date: Thu, 26 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 97e1fe78db572a48a44c2a8511f8393a8643fc28:

  Fio 2.11 (2016-05-24 18:42:04 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 34febb23fa9c7b9b0d54c324effff1a808a8fe6e:

  mutex: abstract out cond/lock pshared init (2016-05-25 13:55:48 -0600)

----------------------------------------------------------------
Jan Kara (2):
      fio: Simplify forking of processes
      Fix occasional hangs on mutexes

Jens Axboe (2):
      hash: make 64-bit even on 32-bit
      mutex: abstract out cond/lock pshared init

 backend.c       | 61 +++++++++++++--------------------------------
 hash.h          |  6 ++---
 helper_thread.c |  7 ++++--
 iolog.c         |  2 +-
 mutex.c         | 77 ++++++++++++++++++++++++++++++++++++++++++++-------------
 mutex.h         |  4 +++
 workqueue.c     | 18 ++++++++++----
 7 files changed, 103 insertions(+), 72 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index f132222..d8f4f4c 100644
--- a/backend.c
+++ b/backend.c
@@ -1428,7 +1428,6 @@ static void *thread_main(void *data)
 	struct thread_data *td = fd->td;
 	struct thread_options *o = &td->o;
 	struct sk_out *sk_out = fd->sk_out;
-	pthread_condattr_t attr;
 	int clear_state;
 	int ret;
 
@@ -1453,12 +1452,18 @@ static void *thread_main(void *data)
 	INIT_FLIST_HEAD(&td->verify_list);
 	INIT_FLIST_HEAD(&td->trim_list);
 	INIT_FLIST_HEAD(&td->next_rand_list);
-	pthread_mutex_init(&td->io_u_lock, NULL);
 	td->io_hist_tree = RB_ROOT;
 
-	pthread_condattr_init(&attr);
-	pthread_cond_init(&td->verify_cond, &attr);
-	pthread_cond_init(&td->free_cond, &attr);
+	ret = mutex_cond_init_pshared(&td->io_u_lock, &td->free_cond);
+	if (ret) {
+		td_verror(td, ret, "mutex_cond_init_pshared");
+		goto err;
+	}
+	ret = cond_init_pshared(&td->verify_cond);
+	if (ret) {
+		td_verror(td, ret, "mutex_cond_pshared");
+		goto err;
+	}
 
 	td_set_runstate(td, TD_INITIALIZED);
 	dprint(FD_MUTEX, "up startup_mutex\n");
@@ -1794,39 +1799,6 @@ err:
 	return (void *) (uintptr_t) td->error;
 }
 
-
-/*
- * We cannot pass the td data into a forked process, so attach the td and
- * pass it to the thread worker.
- */
-static int fork_main(struct sk_out *sk_out, int shmid, int offset)
-{
-	struct fork_data *fd;
-	void *data, *ret;
-
-#if !defined(__hpux) && !defined(CONFIG_NO_SHM)
-	data = shmat(shmid, NULL, 0);
-	if (data == (void *) -1) {
-		int __err = errno;
-
-		perror("shmat");
-		return __err;
-	}
-#else
-	/*
-	 * HP-UX inherits shm mappings?
-	 */
-	data = threads;
-#endif
-
-	fd = calloc(1, sizeof(*fd));
-	fd->td = data + offset * sizeof(struct thread_data);
-	fd->sk_out = sk_out;
-	ret = thread_main(fd);
-	shmdt(data);
-	return (int) (uintptr_t) ret;
-}
-
 static void dump_td_info(struct thread_data *td)
 {
 	log_err("fio: job '%s' (state=%d) hasn't exited in %lu seconds, it "
@@ -2164,6 +2136,7 @@ reap:
 		struct thread_data *map[REAL_MAX_JOBS];
 		struct timeval this_start;
 		int this_jobs = 0, left;
+		struct fork_data *fd;
 
 		/*
 		 * create threads (TD_NOT_CREATED -> TD_CREATED)
@@ -2213,14 +2186,13 @@ reap:
 			map[this_jobs++] = td;
 			nr_started++;
 
+			fd = calloc(1, sizeof(*fd));
+			fd->td = td;
+			fd->sk_out = sk_out;
+
 			if (td->o.use_thread) {
-				struct fork_data *fd;
 				int ret;
 
-				fd = calloc(1, sizeof(*fd));
-				fd->td = td;
-				fd->sk_out = sk_out;
-
 				dprint(FD_PROCESS, "will pthread_create\n");
 				ret = pthread_create(&td->thread, NULL,
 							thread_main, fd);
@@ -2240,8 +2212,9 @@ reap:
 				dprint(FD_PROCESS, "will fork\n");
 				pid = fork();
 				if (!pid) {
-					int ret = fork_main(sk_out, shm_id, i);
+					int ret;
 
+					ret = (int)(uintptr_t)thread_main(fd);
 					_exit(ret);
 				} else if (i == fio_debug_jobno)
 					*fio_debug_jobp = pid;
diff --git a/hash.h b/hash.h
index 1d7608b..d227b93 100644
--- a/hash.h
+++ b/hash.h
@@ -44,15 +44,15 @@
 #define GOLDEN_RATIO_32 0x61C88647
 #define GOLDEN_RATIO_64 0x61C8864680B583EBull
 
-static inline unsigned long __hash_long(unsigned long val)
+static inline unsigned long __hash_long(uint64_t val)
 {
-	unsigned long hash = val;
+	uint64_t hash = val;
 
 #if BITS_PER_LONG == 64
 	hash *= GOLDEN_RATIO_64;
 #else
 	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
-	unsigned long n = hash;
+	uint64_t n = hash;
 	n <<= 18;
 	hash -= n;
 	n <<= 33;
diff --git a/helper_thread.c b/helper_thread.c
index 1befabf..e788af5 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -148,8 +148,11 @@ int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
 	setup_disk_util();
 
 	hd->sk_out = sk_out;
-	pthread_cond_init(&hd->cond, NULL);
-	pthread_mutex_init(&hd->lock, NULL);
+
+	ret = mutex_cond_init_pshared(&hd->lock, &hd->cond);
+	if (ret)
+		return 1;
+
 	hd->startup_mutex = startup_mutex;
 
 	ret = pthread_create(&hd->thread, NULL, helper_thread_main, hd);
diff --git a/iolog.c b/iolog.c
index d9a17a5..9391507 100644
--- a/iolog.c
+++ b/iolog.c
@@ -604,7 +604,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 	if (l->log_gz && !p->td)
 		l->log_gz = 0;
 	else if (l->log_gz || l->log_gz_store) {
-		pthread_mutex_init(&l->chunk_lock, NULL);
+		mutex_init_pshared(&l->chunk_lock);
 		p->td->flags |= TD_F_COMPRESS_LOG;
 	}
 
diff --git a/mutex.c b/mutex.c
index 16107dd..7580922 100644
--- a/mutex.c
+++ b/mutex.c
@@ -30,16 +30,39 @@ void fio_mutex_remove(struct fio_mutex *mutex)
 	munmap((void *) mutex, sizeof(*mutex));
 }
 
-int __fio_mutex_init(struct fio_mutex *mutex, int value)
+int cond_init_pshared(pthread_cond_t *cond)
 {
-	pthread_mutexattr_t attr;
-	pthread_condattr_t cond;
+	pthread_condattr_t cattr;
 	int ret;
 
-	mutex->value = value;
-	mutex->magic = FIO_MUTEX_MAGIC;
+	ret = pthread_condattr_init(&cattr);
+	if (ret) {
+		log_err("pthread_condattr_init: %s\n", strerror(ret));
+		return ret;
+	}
+
+#ifdef FIO_HAVE_PSHARED_MUTEX
+	ret = pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
+	if (ret) {
+		log_err("pthread_condattr_setpshared: %s\n", strerror(ret));
+		return ret;
+	}
+#endif
+	ret = pthread_cond_init(cond, &cattr);
+	if (ret) {
+		log_err("pthread_cond_init: %s\n", strerror(ret));
+		return ret;
+	}
+
+	return 0;
+}
 
-	ret = pthread_mutexattr_init(&attr);
+int mutex_init_pshared(pthread_mutex_t *mutex)
+{
+	pthread_mutexattr_t mattr;
+	int ret;
+
+	ret = pthread_mutexattr_init(&mattr);
 	if (ret) {
 		log_err("pthread_mutexattr_init: %s\n", strerror(ret));
 		return ret;
@@ -49,27 +72,47 @@ int __fio_mutex_init(struct fio_mutex *mutex, int value)
 	 * Not all platforms support process shared mutexes (FreeBSD)
 	 */
 #ifdef FIO_HAVE_PSHARED_MUTEX
-	ret = pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
+	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
 	if (ret) {
 		log_err("pthread_mutexattr_setpshared: %s\n", strerror(ret));
 		return ret;
 	}
 #endif
-
-	pthread_condattr_init(&cond);
-#ifdef FIO_HAVE_PSHARED_MUTEX
-	pthread_condattr_setpshared(&cond, PTHREAD_PROCESS_SHARED);
-#endif
-	pthread_cond_init(&mutex->cond, &cond);
-
-	ret = pthread_mutex_init(&mutex->lock, &attr);
+	ret = pthread_mutex_init(mutex, &mattr);
 	if (ret) {
 		log_err("pthread_mutex_init: %s\n", strerror(ret));
 		return ret;
 	}
 
-	pthread_condattr_destroy(&cond);
-	pthread_mutexattr_destroy(&attr);
+	return 0;
+}
+
+int mutex_cond_init_pshared(pthread_mutex_t *mutex, pthread_cond_t *cond)
+{
+	int ret;
+
+	ret = mutex_init_pshared(mutex);
+	if (ret)
+		return ret;
+
+	ret = cond_init_pshared(cond);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int __fio_mutex_init(struct fio_mutex *mutex, int value)
+{
+	int ret;
+
+	mutex->value = value;
+	mutex->magic = FIO_MUTEX_MAGIC;
+
+	ret = mutex_cond_init_pshared(&mutex->lock, &mutex->cond);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
diff --git a/mutex.h b/mutex.h
index 8c1a711..54009ba 100644
--- a/mutex.h
+++ b/mutex.h
@@ -40,4 +40,8 @@ extern void fio_rwlock_unlock(struct fio_rwlock *);
 extern struct fio_rwlock *fio_rwlock_init(void);
 extern void fio_rwlock_remove(struct fio_rwlock *);
 
+extern int mutex_init_pshared(pthread_mutex_t *);
+extern int cond_init_pshared(pthread_cond_t *);
+extern int mutex_cond_init_pshared(pthread_mutex_t *, pthread_cond_t *);
+
 #endif
diff --git a/workqueue.c b/workqueue.c
index 4f9c414..2e01b58 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -278,8 +278,11 @@ static int start_worker(struct workqueue *wq, unsigned int index,
 	int ret;
 
 	INIT_FLIST_HEAD(&sw->work_list);
-	pthread_cond_init(&sw->cond, NULL);
-	pthread_mutex_init(&sw->lock, NULL);
+
+	ret = mutex_cond_init_pshared(&sw->lock, &sw->cond);
+	if (ret)
+		return ret;
+
 	sw->wq = wq;
 	sw->index = index;
 	sw->sk_out = sk_out;
@@ -308,15 +311,20 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 {
 	unsigned int running;
 	int i, error;
+	int ret;
 
 	wq->max_workers = max_workers;
 	wq->td = td;
 	wq->ops = *ops;
 	wq->work_seq = 0;
 	wq->next_free_worker = 0;
-	pthread_cond_init(&wq->flush_cond, NULL);
-	pthread_mutex_init(&wq->flush_lock, NULL);
-	pthread_mutex_init(&wq->stat_lock, NULL);
+
+	ret = mutex_cond_init_pshared(&wq->flush_lock, &wq->flush_cond);
+	if (ret)
+		goto err;
+	ret = mutex_init_pshared(&wq->stat_lock);
+	if (ret)
+		goto err;
 
 	wq->workers = smalloc(wq->max_workers * sizeof(struct submit_worker));
 
