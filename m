Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55973 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcGMMAc (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 Jul 2016 08:00:32 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bNIpf-00058W-8S
	for fio@vger.kernel.org; Wed, 13 Jul 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160713120002.5EC0D2C23FD@kernel.dk>
Date: Wed, 13 Jul 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 60a257279f249d65d9905e77d3a2fa54ac5aa881:

  iolog: flush_log() can be bool (2016-07-11 11:51:58 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b86ad8f1c3845419742715e94526f60e1e2bf596:

  workqueue: rename private to priv for compiling as c++ (2016-07-11 16:52:34 -0400)

----------------------------------------------------------------
Casey Bodley (1):
      workqueue: rename private to priv for compiling as c++

 rate-submit.c | 18 +++++++++---------
 workqueue.h   |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/rate-submit.c b/rate-submit.c
index 92cb622..0c31f29 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -14,7 +14,7 @@ static int io_workqueue_fn(struct submit_worker *sw,
 {
 	struct io_u *io_u = container_of(work, struct io_u, work);
 	const enum fio_ddir ddir = io_u->ddir;
-	struct thread_data *td = sw->private;
+	struct thread_data *td = sw->priv;
 	int ret;
 
 	dprint(FD_RATE, "io_u %p queued by %u\n", io_u, gettid());
@@ -61,7 +61,7 @@ static int io_workqueue_fn(struct submit_worker *sw,
 
 static bool io_workqueue_pre_sleep_flush_fn(struct submit_worker *sw)
 {
-	struct thread_data *td = sw->private;
+	struct thread_data *td = sw->priv;
 
 	if (td->io_u_queued || td->cur_depth || td->io_u_in_flight)
 		return true;
@@ -71,7 +71,7 @@ static bool io_workqueue_pre_sleep_flush_fn(struct submit_worker *sw)
 
 static void io_workqueue_pre_sleep_fn(struct submit_worker *sw)
 {
-	struct thread_data *td = sw->private;
+	struct thread_data *td = sw->priv;
 	int ret;
 
 	ret = io_u_quiesce(td);
@@ -84,20 +84,20 @@ static int io_workqueue_alloc_fn(struct submit_worker *sw)
 	struct thread_data *td;
 
 	td = calloc(1, sizeof(*td));
-	sw->private = td;
+	sw->priv = td;
 	return 0;
 }
 
 static void io_workqueue_free_fn(struct submit_worker *sw)
 {
-	free(sw->private);
-	sw->private = NULL;
+	free(sw->priv);
+	sw->priv = NULL;
 }
 
 static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 {
 	struct thread_data *parent = sw->wq->td;
-	struct thread_data *td = sw->private;
+	struct thread_data *td = sw->priv;
 	int fio_unused ret;
 
 	memcpy(&td->o, &parent->o, sizeof(td->o));
@@ -145,7 +145,7 @@ err:
 static void io_workqueue_exit_worker_fn(struct submit_worker *sw,
 					unsigned int *sum_cnt)
 {
-	struct thread_data *td = sw->private;
+	struct thread_data *td = sw->priv;
 
 	(*sum_cnt)++;
 	sum_thread_stats(&sw->wq->td->ts, &td->ts, *sum_cnt == 1);
@@ -213,7 +213,7 @@ static void sum_ddir(struct thread_data *dst, struct thread_data *src,
 
 static void io_workqueue_update_acct_fn(struct submit_worker *sw)
 {
-	struct thread_data *src = sw->private;
+	struct thread_data *src = sw->priv;
 	struct thread_data *dst = sw->wq->td;
 
 	if (td_read(src))
diff --git a/workqueue.h b/workqueue.h
index 1961b2a..e35c181 100644
--- a/workqueue.h
+++ b/workqueue.h
@@ -16,7 +16,7 @@ struct submit_worker {
 	unsigned int index;
 	uint64_t seq;
 	struct workqueue *wq;
-	void *private;
+	void *priv;
 	struct sk_out *sk_out;
 };
 
