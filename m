Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45541 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3E2EAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 29 May 2013 00:00:05 -0400
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1UhXYT-0004Bl-1A
	for fio@vger.kernel.org; Wed, 29 May 2013 04:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20130529040002.5E1EE20A61@kernel.dk>
Date: Wed, 29 May 2013 04:00:02 +0000 (UTC)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6e5c4b8e46c95ca75e30e1110a0d24b2df9c47e9:

  Catch NULL td->o.ioengine (2013-05-27 09:50:31 +0200)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Jens Axboe (2):
      Replace list based free/busy/requeue list with FIFO + ring
      Bump IO engine version number

 Makefile           |    2 +-
 backend.c          |   52 +++++++++++++++++++----------------
 engines/posixaio.c |    8 +++---
 fio.h              |    7 +++--
 io_u.c             |   20 ++++++-------
 io_u_queue.c       |   43 +++++++++++++++++++++++++++++
 io_u_queue.h       |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioengine.h         |   55 +++++++++++++++++++------------------
 verify.c           |    7 ++---
 9 files changed, 195 insertions(+), 74 deletions(-)
 create mode 100644 io_u_queue.c
 create mode 100644 io_u_queue.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index d78be34..57f3f82 100644
--- a/Makefile
+++ b/Makefile
@@ -33,7 +33,7 @@ SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		cconv.c lib/prio_tree.c json.c lib/zipf.c lib/axmap.c \
 		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
-		profiles/tiobench.c profiles/act.c
+		profiles/tiobench.c profiles/act.c io_u_queue.c
 
 ifdef CONFIG_64BIT_LLP64
   CFLAGS += -DBITS_PER_LONG=32
diff --git a/backend.c b/backend.c
index 8787cce..8d16fe2 100644
--- a/backend.c
+++ b/backend.c
@@ -238,8 +238,6 @@ static int check_min_rate(struct thread_data *td, struct timeval *now,
  */
 static void cleanup_pending_aio(struct thread_data *td)
 {
-	struct flist_head *entry, *n;
-	struct io_u *io_u;
 	int r;
 
 	/*
@@ -253,18 +251,11 @@ static void cleanup_pending_aio(struct thread_data *td)
 	 * now cancel remaining active events
 	 */
 	if (td->io_ops->cancel) {
-		flist_for_each_safe(entry, n, &td->io_u_busylist) {
-			io_u = flist_entry(entry, struct io_u, list);
+		struct io_u *io_u;
+		int i;
 
-			/*
-			 * if the io_u isn't in flight, then that generally
-			 * means someone leaked an io_u. complain but fix
-			 * it up, so we don't stall here.
-			 */
-			if ((io_u->flags & IO_U_F_FLIGHT) == 0) {
-				log_err("fio: non-busy IO on busy list\n");
-				put_io_u(td, io_u);
-			} else {
+		io_u_qiter(&td->io_u_all, io_u, i) {
+			if (io_u->flags & IO_U_F_FLIGHT) {
 				r = td->io_ops->cancel(td, io_u);
 				if (!r)
 					put_io_u(td, io_u);
@@ -878,13 +869,9 @@ sync_done:
 
 static void cleanup_io_u(struct thread_data *td)
 {
-	struct flist_head *entry, *n;
 	struct io_u *io_u;
 
-	flist_for_each_safe(entry, n, &td->io_u_freelist) {
-		io_u = flist_entry(entry, struct io_u, list);
-
-		flist_del(&io_u->list);
+	while ((io_u = io_u_qpop(&td->io_u_freelist)) != NULL) {
 
 		if (td->io_ops->io_u_free)
 			td->io_ops->io_u_free(td, io_u);
@@ -893,6 +880,10 @@ static void cleanup_io_u(struct thread_data *td)
 	}
 
 	free_io_mem(td);
+
+	io_u_rexit(&td->io_u_requeues);
+	io_u_qexit(&td->io_u_freelist);
+	io_u_qexit(&td->io_u_all);
 }
 
 static int init_io_u(struct thread_data *td)
@@ -900,7 +891,7 @@ static int init_io_u(struct thread_data *td)
 	struct io_u *io_u;
 	unsigned int max_bs, min_write;
 	int cl_align, i, max_units;
-	int data_xfer = 1;
+	int data_xfer = 1, err;
 	char *p;
 
 	max_units = td->o.iodepth;
@@ -912,6 +903,16 @@ static int init_io_u(struct thread_data *td)
 	if ((td->io_ops->flags & FIO_NOIO) || !(td_read(td) || td_write(td)))
 		data_xfer = 0;
 
+	err = 0;
+	err += io_u_rinit(&td->io_u_requeues, td->o.iodepth);
+	err += io_u_qinit(&td->io_u_freelist, td->o.iodepth);
+	err += io_u_qinit(&td->io_u_all, td->o.iodepth);
+
+	if (err) {
+		log_err("fio: failed setting up IO queues\n");
+		return 1;
+	}
+
 	/*
 	 * if we may later need to do address alignment, then add any
 	 * possible adjustment here so that we don't cause a buffer
@@ -958,7 +959,7 @@ static int init_io_u(struct thread_data *td)
 
 		io_u = ptr;
 		memset(io_u, 0, sizeof(*io_u));
-		INIT_FLIST_HEAD(&io_u->list);
+		INIT_FLIST_HEAD(&io_u->verify_list);
 		dprint(FD_MEM, "io_u alloc %p, index %u\n", io_u, i);
 
 		if (data_xfer) {
@@ -978,7 +979,13 @@ static int init_io_u(struct thread_data *td)
 
 		io_u->index = i;
 		io_u->flags = IO_U_F_FREE;
-		flist_add(&io_u->list, &td->io_u_freelist);
+		io_u_qpush(&td->io_u_freelist, io_u);
+
+		/*
+		 * io_u never leaves this stack, used for iteration of all
+		 * io_u buffers.
+		 */
+		io_u_qpush(&td->io_u_all, io_u);
 
 		if (td->io_ops->io_u_init) {
 			int ret = td->io_ops->io_u_init(td, io_u);
@@ -1121,9 +1128,6 @@ static void *thread_main(void *data)
 	if (is_backend)
 		fio_server_send_start(td);
 
-	INIT_FLIST_HEAD(&td->io_u_freelist);
-	INIT_FLIST_HEAD(&td->io_u_busylist);
-	INIT_FLIST_HEAD(&td->io_u_requeues);
 	INIT_FLIST_HEAD(&td->io_log_list);
 	INIT_FLIST_HEAD(&td->io_hist_list);
 	INIT_FLIST_HEAD(&td->verify_list);
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 1858e52..a2b5387 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -95,11 +95,12 @@ static int fio_posixaio_getevents(struct thread_data *td, unsigned int min,
 {
 	struct posixaio_data *pd = td->io_ops->data;
 	os_aiocb_t *suspend_list[SUSPEND_ENTRIES];
-	struct flist_head *entry;
 	struct timespec start;
 	int have_timeout = 0;
 	int suspend_entries;
+	struct io_u *io_u;
 	unsigned int r;
+	int i;
 
 	if (t && !fill_timespec(&start))
 		have_timeout = 1;
@@ -110,11 +111,10 @@ static int fio_posixaio_getevents(struct thread_data *td, unsigned int min,
 restart:
 	memset(suspend_list, 0, sizeof(*suspend_list));
 	suspend_entries = 0;
-	flist_for_each(entry, &td->io_u_busylist) {
-		struct io_u *io_u = flist_entry(entry, struct io_u, list);
+	io_u_qiter(&td->io_u_all, io_u, i) {
 		int err;
 
-		if (io_u->seen)
+		if (io_u->seen || !(io_u->flags & IO_U_F_FLIGHT))
 			continue;
 
 		err = aio_error(&io_u->aiocb);
diff --git a/fio.h b/fio.h
index 965d7d9..8c67fcc 100644
--- a/fio.h
+++ b/fio.h
@@ -39,6 +39,7 @@
 #include "server.h"
 #include "stat.h"
 #include "flow.h"
+#include "io_u_queue.h"
 
 #ifdef CONFIG_SOLARISAIO
 #include <sys/asynch.h>
@@ -193,9 +194,9 @@ struct thread_data {
 	/*
 	 * List of free and busy io_u's
 	 */
-	struct flist_head io_u_freelist;
-	struct flist_head io_u_busylist;
-	struct flist_head io_u_requeues;
+	struct io_u_ring io_u_requeues;
+	struct io_u_queue io_u_freelist;
+	struct io_u_queue io_u_all;
 	pthread_mutex_t io_u_lock;
 	pthread_cond_t free_cond;
 
diff --git a/io_u.c b/io_u.c
index 645a680..11672cf 100644
--- a/io_u.c
+++ b/io_u.c
@@ -676,8 +676,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH)
 		td->cur_depth--;
-	flist_del_init(&io_u->list);
-	flist_add(&io_u->list, &td->io_u_freelist);
+	io_u_qpush(&td->io_u_freelist, io_u);
 	td_io_u_unlock(td);
 	td_io_u_free_notify(td);
 }
@@ -704,8 +703,8 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 	__io_u->flags &= ~IO_U_F_FLIGHT;
 	if (__io_u->flags & IO_U_F_IN_CUR_DEPTH)
 		td->cur_depth--;
-	flist_del(&__io_u->list);
-	flist_add_tail(&__io_u->list, &td->io_u_requeues);
+
+	io_u_rpush(&td->io_u_requeues, __io_u);
 	td_io_u_unlock(td);
 	*io_u = NULL;
 }
@@ -1107,16 +1106,17 @@ static int set_io_u_file(struct thread_data *td, struct io_u *io_u)
 
 struct io_u *__get_io_u(struct thread_data *td)
 {
-	struct io_u *io_u = NULL;
+	struct io_u *io_u;
 
 	td_io_u_lock(td);
 
 again:
-	if (!flist_empty(&td->io_u_requeues))
-		io_u = flist_entry(td->io_u_requeues.next, struct io_u, list);
-	else if (!queue_full(td)) {
-		io_u = flist_entry(td->io_u_freelist.next, struct io_u, list);
+	if (!io_u_rempty(&td->io_u_requeues))
+		io_u = io_u_rpop(&td->io_u_requeues);
+	else if (!io_u_qempty(&td->io_u_freelist))
+		io_u = io_u_qpop(&td->io_u_freelist);
 
+	if (io_u) {
 		io_u->buflen = 0;
 		io_u->resid = 0;
 		io_u->file = NULL;
@@ -1131,8 +1131,6 @@ again:
 
 		io_u->error = 0;
 		io_u->acct_ddir = -1;
-		flist_del(&io_u->list);
-		flist_add_tail(&io_u->list, &td->io_u_busylist);
 		td->cur_depth++;
 		io_u->flags |= IO_U_F_IN_CUR_DEPTH;
 	} else if (td->o.verify_async) {
diff --git a/io_u_queue.c b/io_u_queue.c
new file mode 100644
index 0000000..5734e9c
--- /dev/null
+++ b/io_u_queue.c
@@ -0,0 +1,43 @@
+#include <stdlib.h>
+#include "io_u_queue.h"
+
+int io_u_qinit(struct io_u_queue *q, unsigned int nr)
+{
+	q->io_us = calloc(sizeof(struct io_u *), nr);
+	if (!q->io_us)
+		return 1;
+
+	q->nr = 0;
+	return 0;
+}
+
+void io_u_qexit(struct io_u_queue *q)
+{
+	free(q->io_us);
+}
+
+int io_u_rinit(struct io_u_ring *ring, unsigned int nr)
+{
+	ring->max = nr + 1;
+	if (ring->max & (ring->max - 1)) {
+		ring->max--;
+		ring->max |= ring->max >> 1;
+		ring->max |= ring->max >> 2;
+		ring->max |= ring->max >> 4;
+		ring->max |= ring->max >> 8;
+		ring->max |= ring->max >> 16;
+		ring->max++;
+	}
+
+	ring->ring = calloc(sizeof(struct io_u *), ring->max);
+	if (!ring->ring)
+		return 1;
+
+	ring->head = ring->tail = 0;
+	return 0;
+}
+
+void io_u_rexit(struct io_u_ring *ring)
+{
+	free(ring->ring);
+}
diff --git a/io_u_queue.h b/io_u_queue.h
new file mode 100644
index 0000000..4f6e8e6
--- /dev/null
+++ b/io_u_queue.h
@@ -0,0 +1,75 @@
+#ifndef FIO_IO_U_QUEUE
+#define FIO_IO_U_QUEUE
+
+#include <assert.h>
+
+struct io_u;
+
+struct io_u_queue {
+	struct io_u **io_us;
+	unsigned int nr;
+};
+
+static inline struct io_u *io_u_qpop(struct io_u_queue *q)
+{
+	if (q->nr)
+		return q->io_us[--q->nr];
+
+	return NULL;
+}
+
+static inline void io_u_qpush(struct io_u_queue *q, struct io_u *io_u)
+{
+	q->io_us[q->nr++] = io_u;
+}
+
+static inline int io_u_qempty(struct io_u_queue *q)
+{
+	return !q->nr;
+}
+
+#define io_u_qiter(q, io_u, i)	\
+	for (i = 0, io_u = (q)->io_us[0]; i < (q)->nr; i++, io_u = (q)->io_us[i])
+
+int io_u_qinit(struct io_u_queue *q, unsigned int nr);
+void io_u_qexit(struct io_u_queue *q);
+
+struct io_u_ring {
+	unsigned int head;
+	unsigned int tail;
+	unsigned int max;
+	struct io_u **ring;
+};
+
+int io_u_rinit(struct io_u_ring *ring, unsigned int nr);
+void io_u_rexit(struct io_u_ring *ring);
+
+static inline void io_u_rpush(struct io_u_ring *r, struct io_u *io_u)
+{
+	if (r->head + 1 != r->tail) {
+		r->ring[r->head] = io_u;
+		r->head = (r->head + 1) & (r->max - 1);
+		return;
+	}
+
+	assert(0);
+}
+
+static inline struct io_u *io_u_rpop(struct io_u_ring *r)
+{
+	if (r->head != r->tail) {
+		struct io_u *io_u = r->ring[r->tail];
+
+		r->tail = (r->tail + 1) & (r->max - 1);
+		return io_u;
+	}
+
+	return NULL;
+}
+
+static inline int io_u_rempty(struct io_u_ring *ring)
+{
+	return ring->head == ring->tail;
+}
+
+#endif
diff --git a/ioengine.h b/ioengine.h
index 0be905f..31662eb 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -15,7 +15,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	15
+#define FIO_IOOPS_VERSION	16
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -32,30 +32,6 @@ enum {
  * The io unit
  */
 struct io_u {
-	union {
-#ifdef CONFIG_LIBAIO
-		struct iocb iocb;
-#endif
-#ifdef CONFIG_POSIXAIO
-		os_aiocb_t aiocb;
-#endif
-#ifdef FIO_HAVE_SGIO
-		struct sg_io_hdr hdr;
-#endif
-#ifdef CONFIG_GUASI
-		guasi_req_t greq;
-#endif
-#ifdef CONFIG_SOLARISAIO
-		aio_result_t resultp;
-#endif
-#ifdef FIO_HAVE_BINJECT
-		struct b_user_cmd buc;
-#endif
-#ifdef CONFIG_RDMA
-		struct ibv_mr *mr;
-#endif
-		void *mmap_data;
-	};
 	struct timeval start_time;
 	struct timeval issue_time;
 
@@ -94,6 +70,31 @@ struct io_u {
 	 */
 	unsigned long buf_filled_len;
 
+	union {
+#ifdef CONFIG_LIBAIO
+		struct iocb iocb;
+#endif
+#ifdef CONFIG_POSIXAIO
+		os_aiocb_t aiocb;
+#endif
+#ifdef FIO_HAVE_SGIO
+		struct sg_io_hdr hdr;
+#endif
+#ifdef CONFIG_GUASI
+		guasi_req_t greq;
+#endif
+#ifdef CONFIG_SOLARISAIO
+		aio_result_t resultp;
+#endif
+#ifdef FIO_HAVE_BINJECT
+		struct b_user_cmd buc;
+#endif
+#ifdef CONFIG_RDMA
+		struct ibv_mr *mr;
+#endif
+		void *mmap_data;
+	};
+
 	unsigned int resid;
 	unsigned int error;
 
@@ -106,7 +107,7 @@ struct io_u {
 		void *engine_data;
 	};
 
-	struct flist_head list;
+	struct flist_head verify_list;
 
 	/*
 	 * Callback for io completion
@@ -187,7 +188,7 @@ extern int fio_show_ioengine_help(const char *engine);
 /*
  * io unit handling
  */
-#define queue_full(td)	flist_empty(&(td)->io_u_freelist)
+#define queue_full(td)	io_u_qempty(&(td)->io_u_freelist)
 extern struct io_u *__get_io_u(struct thread_data *);
 extern struct io_u *get_io_u(struct thread_data *);
 extern void put_io_u(struct thread_data *, struct io_u *);
diff --git a/verify.c b/verify.c
index 787cc37..b3cd402 100644
--- a/verify.c
+++ b/verify.c
@@ -595,8 +595,7 @@ int verify_io_u_async(struct thread_data *td, struct io_u *io_u)
 		td->cur_depth--;
 		io_u->flags &= ~IO_U_F_IN_CUR_DEPTH;
 	}
-	flist_del(&io_u->list);
-	flist_add_tail(&io_u->list, &td->verify_list);
+	flist_add_tail(&io_u->verify_list, &td->verify_list);
 	io_u->flags |= IO_U_F_FREE_DEF;
 	pthread_mutex_unlock(&td->io_u_lock);
 
@@ -1052,8 +1051,8 @@ static void *verify_async_thread(void *data)
 			continue;
 
 		while (!flist_empty(&list)) {
-			io_u = flist_entry(list.next, struct io_u, list);
-			flist_del_init(&io_u->list);
+			io_u = flist_entry(list.next, struct io_u, verify_list);
+			flist_del(&io_u->verify_list);
 
 			ret = verify_io_u(td, io_u);
 			put_io_u(td, io_u);
