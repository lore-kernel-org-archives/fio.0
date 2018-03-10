Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932130AbeCJNAY (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Mar 2018 08:00:24 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eue6p-0004eI-Qw
        for fio@vger.kernel.org; Sat, 10 Mar 2018 13:00:23 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180310130002.598382C1D65@kernel.dk>
Date: Sat, 10 Mar 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 582e2fd9acae207400bed4226ceda4ee02464136:

  Merge branch 'disable_opt' of https://github.com/sitsofe/fio (2018-03-07 10:22:28 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e0b3258bde6f39ab3a9d178b56526b65e0e32a8d:

  filesetup: Initialize all members of struct fio_file (2018-03-09 21:34:44 -0700)

----------------------------------------------------------------
Bart Van Assche (5):
      Remove prof_io_ops.fill_io_u_off(), .fill_io_u_size() and .get_next_file()
      Makefile: Rerun the configure script if it has been modified
      Declare debug_levels[] const
      helper_thread: Initialize all helper_data members before using it
      filesetup: Initialize all members of struct fio_file

Jens Axboe (5):
      mutex: ensure that fio_mutex_up() holds mutex lock during wakeup
      mutex: fix other locations where we are not waking within the lock
      io_u: kill get_next_{offset,buflen} wrappers
      io_u: 'is_random' can be a boolean
      filesetup: don't round/adjust size for size_percent == 100

 Makefile        | 23 +++++++++++------------
 debug.h         |  2 +-
 filesetup.c     |  4 ++--
 helper_thread.c |  2 +-
 init.c          |  6 +++---
 io_u.c          | 57 ++++++++++++---------------------------------------------
 mutex.c         |  3 ++-
 profile.h       |  4 ----
 verify.c        |  2 +-
 workqueue.c     |  2 +-
 10 files changed, 34 insertions(+), 71 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 19ba40a..d73b944 100644
--- a/Makefile
+++ b/Makefile
@@ -4,19 +4,18 @@ endif
 
 VPATH := $(SRCDIR)
 
-ifneq ($(wildcard config-host.mak),)
-all:
-include config-host.mak
-config-host-mak: configure
-	@echo $@ is out-of-date, running configure
-	@sed -n "/.*Configured with/s/[^:]*: //p" $@ | sh
-else
-config-host.mak:
+all: fio
+
+config-host.mak: configure
+	@if [ ! -e "$@" ]; then					\
+	  echo "Running configure ...";				\
+	  ./configure;						\
+	else							\
+	  echo "$@ is out-of-date, running configure";		\
+	  sed -n "/.*Configured with/s/[^:]*: //p" "$@" | sh;	\
+	fi
+
 ifneq ($(MAKECMDGOALS),clean)
-	@echo "Running configure for you..."
-	@./configure
-endif
-all:
 include config-host.mak
 endif
 
diff --git a/debug.h b/debug.h
index ac5f2cc..b8718dd 100644
--- a/debug.h
+++ b/debug.h
@@ -53,7 +53,7 @@ struct debug_level {
 	unsigned long shift;
 	unsigned int jobno;
 };
-extern struct debug_level debug_levels[];
+extern const struct debug_level debug_levels[];
 
 extern unsigned long fio_debug;
 
diff --git a/filesetup.c b/filesetup.c
index cced556..1a187ff 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1036,7 +1036,7 @@ int setup_files(struct thread_data *td)
 		if (f->io_size == -1ULL)
 			total_size = -1ULL;
 		else {
-                        if (o->size_percent) {
+                        if (o->size_percent && o->size_percent != 100) {
 				uint64_t file_size;
 
 				file_size = f->io_size + f->file_offset;
@@ -1481,7 +1481,7 @@ static struct fio_file *alloc_new_file(struct thread_data *td)
 	if (td_ioengine_flagged(td, FIO_NOFILEHASH))
 		f = calloc(1, sizeof(*f));
 	else
-		f = smalloc(sizeof(*f));
+		f = scalloc(1, sizeof(*f));
 	if (!f) {
 		assert(0);
 		return NULL;
diff --git a/helper_thread.c b/helper_thread.c
index 64e5a3c..b05f821 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -156,7 +156,7 @@ int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
 	struct helper_data *hd;
 	int ret;
 
-	hd = smalloc(sizeof(*hd));
+	hd = scalloc(1, sizeof(*hd));
 
 	setup_disk_util();
 	steadystate_setup();
diff --git a/init.c b/init.c
index 28061db..bb0627b 100644
--- a/init.c
+++ b/init.c
@@ -2094,7 +2094,7 @@ static int fill_def_thread(void)
 static void show_debug_categories(void)
 {
 #ifdef FIO_INC_DEBUG
-	struct debug_level *dl = &debug_levels[0];
+	const struct debug_level *dl = &debug_levels[0];
 	int curlen, first = 1;
 
 	curlen = 0;
@@ -2184,7 +2184,7 @@ static void usage(const char *name)
 }
 
 #ifdef FIO_INC_DEBUG
-struct debug_level debug_levels[] = {
+const struct debug_level debug_levels[] = {
 	{ .name = "process",
 	  .help = "Process creation/exit logging",
 	  .shift = FD_PROCESS,
@@ -2262,7 +2262,7 @@ struct debug_level debug_levels[] = {
 
 static int set_debug(const char *string)
 {
-	struct debug_level *dl;
+	const struct debug_level *dl;
 	char *p = (char *) string;
 	char *opt;
 	int i;
diff --git a/io_u.c b/io_u.c
index 61d09ba..a37b723 100644
--- a/io_u.c
+++ b/io_u.c
@@ -470,7 +470,7 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 
 static int get_next_block(struct thread_data *td, struct io_u *io_u,
 			  enum fio_ddir ddir, int rw_seq,
-			  unsigned int *is_random)
+			  bool *is_random)
 {
 	struct fio_file *f = io_u->file;
 	uint64_t b, offset;
@@ -484,27 +484,27 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 		if (td_random(td)) {
 			if (should_do_random(td, ddir)) {
 				ret = get_next_rand_block(td, f, ddir, &b);
-				*is_random = 1;
+				*is_random = true;
 			} else {
-				*is_random = 0;
+				*is_random = false;
 				io_u_set(td, io_u, IO_U_F_BUSY_OK);
 				ret = get_next_seq_offset(td, f, ddir, &offset);
 				if (ret)
 					ret = get_next_rand_block(td, f, ddir, &b);
 			}
 		} else {
-			*is_random = 0;
+			*is_random = false;
 			ret = get_next_seq_offset(td, f, ddir, &offset);
 		}
 	} else {
 		io_u_set(td, io_u, IO_U_F_BUSY_OK);
-		*is_random = 0;
+		*is_random = false;
 
 		if (td->o.rw_seq == RW_SEQ_SEQ) {
 			ret = get_next_seq_offset(td, f, ddir, &offset);
 			if (ret) {
 				ret = get_next_rand_block(td, f, ddir, &b);
-				*is_random = 0;
+				*is_random = false;
 			}
 		} else if (td->o.rw_seq == RW_SEQ_IDENT) {
 			if (f->last_start[ddir] != -1ULL)
@@ -537,8 +537,8 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
  * until we find a free one. For sequential io, just return the end of
  * the last io issued.
  */
-static int __get_next_offset(struct thread_data *td, struct io_u *io_u,
-			     unsigned int *is_random)
+static int get_next_offset(struct thread_data *td, struct io_u *io_u,
+			   bool *is_random)
 {
 	struct fio_file *f = io_u->file;
 	enum fio_ddir ddir = io_u->ddir;
@@ -572,19 +572,6 @@ static int __get_next_offset(struct thread_data *td, struct io_u *io_u,
 	return 0;
 }
 
-static int get_next_offset(struct thread_data *td, struct io_u *io_u,
-			   unsigned int *is_random)
-{
-	if (td->flags & TD_F_PROFILE_OPS) {
-		struct prof_io_ops *ops = &td->prof_io_ops;
-
-		if (ops->fill_io_u_off)
-			return ops->fill_io_u_off(td, io_u, is_random);
-	}
-
-	return __get_next_offset(td, io_u, is_random);
-}
-
 static inline bool io_u_fits(struct thread_data *td, struct io_u *io_u,
 			     unsigned int buflen)
 {
@@ -593,8 +580,8 @@ static inline bool io_u_fits(struct thread_data *td, struct io_u *io_u,
 	return io_u->offset + buflen <= f->io_size + get_start_offset(td, f);
 }
 
-static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
-				      unsigned int is_random)
+static unsigned int get_next_buflen(struct thread_data *td, struct io_u *io_u,
+				    bool is_random)
 {
 	int ddir = io_u->ddir;
 	unsigned int buflen = 0;
@@ -605,7 +592,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	assert(ddir_rw(ddir));
 
 	if (td->o.bs_is_seq_rand)
-		ddir = is_random ? DDIR_WRITE: DDIR_READ;
+		ddir = is_random ? DDIR_WRITE : DDIR_READ;
 
 	minbs = td->o.min_bs[ddir];
 	maxbs = td->o.max_bs[ddir];
@@ -655,19 +642,6 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	return buflen;
 }
 
-static unsigned int get_next_buflen(struct thread_data *td, struct io_u *io_u,
-				    unsigned int is_random)
-{
-	if (td->flags & TD_F_PROFILE_OPS) {
-		struct prof_io_ops *ops = &td->prof_io_ops;
-
-		if (ops->fill_io_u_size)
-			return ops->fill_io_u_size(td, io_u, is_random);
-	}
-
-	return __get_next_buflen(td, io_u, is_random);
-}
-
 static void set_rwmix_bytes(struct thread_data *td)
 {
 	unsigned int diff;
@@ -957,7 +931,7 @@ static void __fill_io_u_zone(struct thread_data *td, struct io_u *io_u)
 
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
-	unsigned int is_random;
+	bool is_random;
 
 	if (td_ioengine_flagged(td, FIO_NOIO))
 		goto out;
@@ -1387,13 +1361,6 @@ out:
 
 static struct fio_file *get_next_file(struct thread_data *td)
 {
-	if (td->flags & TD_F_PROFILE_OPS) {
-		struct prof_io_ops *ops = &td->prof_io_ops;
-
-		if (ops->get_next_file)
-			return ops->get_next_file(td);
-	}
-
 	return __get_next_file(td);
 }
 
diff --git a/mutex.c b/mutex.c
index 63229ed..acc88dc 100644
--- a/mutex.c
+++ b/mutex.c
@@ -240,10 +240,11 @@ void fio_mutex_up(struct fio_mutex *mutex)
 	if (!mutex->value && mutex->waiters)
 		do_wake = 1;
 	mutex->value++;
-	pthread_mutex_unlock(&mutex->lock);
 
 	if (do_wake)
 		pthread_cond_signal(&mutex->cond);
+
+	pthread_mutex_unlock(&mutex->lock);
 }
 
 void fio_rwlock_write(struct fio_rwlock *lock)
diff --git a/profile.h b/profile.h
index 8d1f757..414151e 100644
--- a/profile.h
+++ b/profile.h
@@ -10,10 +10,6 @@ struct prof_io_ops {
 	int (*td_init)(struct thread_data *);
 	void (*td_exit)(struct thread_data *);
 
-	int (*fill_io_u_off)(struct thread_data *, struct io_u *, unsigned int *);
-	int (*fill_io_u_size)(struct thread_data *, struct io_u *, unsigned int);
-	struct fio_file *(*get_next_file)(struct thread_data *);
-
 	int (*io_u_lat)(struct thread_data *, uint64_t);
 };
 
diff --git a/verify.c b/verify.c
index aeafdb5..d070f33 100644
--- a/verify.c
+++ b/verify.c
@@ -748,9 +748,9 @@ int verify_io_u_async(struct thread_data *td, struct io_u **io_u_ptr)
 	}
 	flist_add_tail(&io_u->verify_list, &td->verify_list);
 	*io_u_ptr = NULL;
-	pthread_mutex_unlock(&td->io_u_lock);
 
 	pthread_cond_signal(&td->verify_cond);
+	pthread_mutex_unlock(&td->io_u_lock);
 	return 0;
 }
 
diff --git a/workqueue.c b/workqueue.c
index 1131400..18ec198 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -109,9 +109,9 @@ void workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work)
 	flist_add_tail(&work->list, &sw->work_list);
 	sw->seq = ++wq->work_seq;
 	sw->flags &= ~SW_F_IDLE;
-	pthread_mutex_unlock(&sw->lock);
 
 	pthread_cond_signal(&sw->cond);
+	pthread_mutex_unlock(&sw->lock);
 }
 
 static void handle_list(struct submit_worker *sw, struct flist_head *list)
