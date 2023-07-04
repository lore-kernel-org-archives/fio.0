Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BB8EB64D9
	for <fio@archiver.kernel.org>; Tue,  4 Jul 2023 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjGDMAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 4 Jul 2023 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjGDMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 4 Jul 2023 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1FE10A
        for <fio@vger.kernel.org>; Tue,  4 Jul 2023 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=P4dcwE0qbZEOZaYsFX+4gNCJpV/6aozHltdW9OhZhaM=; b=GyahK+R2zSGGejHHLLI4gNUEyQ
        u6k5k6HycCIzkGPngwAnrLJn2SVSHLjWUoI3Ih8HZaZPlGT3dXwuFPlowehkmyFy1hLhleGUBroZy
        1jnQvj51xCjwahIxt+eojQAJhfLwA6hehXkIou4egwqEvjJIndxQaQN39quIBASQbKSRQrFPx7IVb
        47mz+WpdHOiImWZG9qw0uK9qJN3X1IEutBiWDBNUDcaYbBAyBros3H9qV7okwVpRrccKTsXldDgwc
        AfdNuOhllFGyML+Jwj7tFTHKh69aORPUbGs4/qCUT6D326y831kBZRsIse5ydBPJwJlOAdJg5W3mr
        PYlN8QxQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qGehR-0097Zq-3D
        for fio@vger.kernel.org; Tue, 04 Jul 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id A35E61BC0167; Tue,  4 Jul 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230704120001.A35E61BC0167@kernel.dk>
Date:   Tue,  4 Jul 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5087502fb05b2b4d756045c594a2e09c2ffc97dc:

  init: don't adjust time units again for subjobs (2023-06-20 14:11:36 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 41508de67c06661ff1d473d108a8a01912ade114:

  fio/server: fix confusing sk_out check (2023-07-03 09:16:45 -0600)

----------------------------------------------------------------
Denis Pronin (3):
      fixed compiler warnings if NDEBUG enabled in core code
      fixed compiler warnings if NDEBUG enabled in test code
      use 'min' macro to find out next value of actual_min in libaio

Jens Axboe (3):
      Merge branch 'libaio/actual_min_algo_update' of https://github.com/dpronin/fio
      Merge branch 'improvement/fix-warnings-if-NDEBUG-enabled' of https://github.com/dpronin/fio
      fio/server: fix confusing sk_out check

 backend.c              | 18 ++++++++++++++----
 engines/libaio.c       |  2 +-
 helper_thread.c        |  8 +++++++-
 io_u.c                 |  7 ++++---
 ioengines.c            | 10 ++++++++--
 rate-submit.c          | 18 +++++++++++++++---
 server.c               |  7 ++++++-
 t/read-to-pipe-async.c | 30 +++++++++++++++++++++++-------
 zbd.c                  | 18 ++++++++----------
 9 files changed, 86 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index f541676c..d67a4a07 100644
--- a/backend.c
+++ b/backend.c
@@ -1633,7 +1633,7 @@ static void *thread_main(void *data)
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 	int deadlock_loop_cnt;
 	bool clear_state;
-	int res, ret;
+	int ret;
 
 	sk_out_assign(sk_out);
 	free(fd);
@@ -1974,13 +1974,23 @@ static void *thread_main(void *data)
 	 * another thread is checking its io_u's for overlap
 	 */
 	if (td_offload_overlap(td)) {
-		int res = pthread_mutex_lock(&overlap_check);
-		assert(res == 0);
+		int res;
+
+		res = pthread_mutex_lock(&overlap_check);
+		if (res) {
+			td->error = errno;
+			goto err;
+		}
 	}
 	td_set_runstate(td, TD_FINISHING);
 	if (td_offload_overlap(td)) {
+		int res;
+
 		res = pthread_mutex_unlock(&overlap_check);
-		assert(res == 0);
+		if (res) {
+			td->error = errno;
+			goto err;
+		}
 	}
 
 	update_rusage_stat(td);
diff --git a/engines/libaio.c b/engines/libaio.c
index 1b82c90b..6a0745aa 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -296,7 +296,7 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 		}
 		if (r > 0) {
 			events += r;
-			actual_min = actual_min > events ? actual_min - events : 0;
+			actual_min -= min((unsigned int)events, actual_min);
 		}
 		else if ((min && r == 0) || r == -EAGAIN) {
 			fio_libaio_commit(td);
diff --git a/helper_thread.c b/helper_thread.c
index 77016638..53dea44b 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -1,4 +1,7 @@
+#include <errno.h>
 #include <signal.h>
+#include <stdio.h>
+#include <string.h>
 #include <unistd.h>
 #ifdef CONFIG_HAVE_TIMERFD_CREATE
 #include <sys/timerfd.h>
@@ -122,7 +125,10 @@ static void submit_action(enum action a)
 		return;
 
 	ret = write_to_pipe(helper_data->pipe[1], &data, sizeof(data));
-	assert(ret == 1);
+	if (ret != 1) {
+		log_err("failed to write action into pipe, err %i:%s", errno, strerror(errno));
+		assert(0);
+	}
 }
 
 void helper_reset(void)
diff --git a/io_u.c b/io_u.c
index faf512e5..27b6c92a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1613,7 +1613,6 @@ struct io_u *__get_io_u(struct thread_data *td)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct io_u *io_u = NULL;
-	int ret;
 
 	if (td->stop_io)
 		return NULL;
@@ -1647,14 +1646,16 @@ again:
 		io_u_set(td, io_u, IO_U_F_IN_CUR_DEPTH);
 		io_u->ipo = NULL;
 	} else if (td_async_processing(td)) {
+		int ret;
 		/*
 		 * We ran out, wait for async verify threads to finish and
 		 * return one
 		 */
 		assert(!(td->flags & TD_F_CHILD));
 		ret = pthread_cond_wait(&td->free_cond, &td->io_u_lock);
-		assert(ret == 0);
-		if (!td->error)
+		if (fio_unlikely(ret != 0)) {
+			td->error = errno;
+		} else if (!td->error)
 			goto again;
 	}
 
diff --git a/ioengines.c b/ioengines.c
index 742f97dd..36172725 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -17,6 +17,7 @@
 #include <assert.h>
 #include <sys/types.h>
 #include <dirent.h>
+#include <errno.h>
 
 #include "fio.h"
 #include "diskutil.h"
@@ -342,8 +343,13 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	 * flag is now set
 	 */
 	if (td_offload_overlap(td)) {
-		int res = pthread_mutex_unlock(&overlap_check);
-		assert(res == 0);
+		int res;
+
+		res = pthread_mutex_unlock(&overlap_check);
+		if (fio_unlikely(res != 0)) {
+			log_err("failed to unlock overlap check mutex, err: %i:%s", errno, strerror(errno));
+			abort();
+		}
 	}
 
 	assert(fio_file_open(io_u->file));
diff --git a/rate-submit.c b/rate-submit.c
index 103a80aa..6f6d15bd 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -5,6 +5,9 @@
  *
  */
 #include <assert.h>
+#include <errno.h>
+#include <pthread.h>
+
 #include "fio.h"
 #include "ioengines.h"
 #include "lib/getrusage.h"
@@ -27,7 +30,10 @@ static void check_overlap(struct io_u *io_u)
 	 * threads as they assess overlap.
 	 */
 	res = pthread_mutex_lock(&overlap_check);
-	assert(res == 0);
+	if (fio_unlikely(res != 0)) {
+		log_err("failed to lock overlap check mutex, err: %i:%s", errno, strerror(errno));
+		abort();
+	}
 
 retry:
 	for_each_td(td) {
@@ -41,9 +47,15 @@ retry:
 			continue;
 
 		res = pthread_mutex_unlock(&overlap_check);
-		assert(res == 0);
+		if (fio_unlikely(res != 0)) {
+			log_err("failed to unlock overlap check mutex, err: %i:%s", errno, strerror(errno));
+			abort();
+		}
 		res = pthread_mutex_lock(&overlap_check);
-		assert(res == 0);
+		if (fio_unlikely(res != 0)) {
+			log_err("failed to lock overlap check mutex, err: %i:%s", errno, strerror(errno));
+			abort();
+		}
 		goto retry;
 	} end_for_each();
 }
diff --git a/server.c b/server.c
index a6347efd..bb423702 100644
--- a/server.c
+++ b/server.c
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <unistd.h>
 #include <errno.h>
 #include <poll.h>
@@ -2343,7 +2344,11 @@ void fio_server_send_start(struct thread_data *td)
 {
 	struct sk_out *sk_out = pthread_getspecific(sk_out_key);
 
-	assert(sk_out->sk != -1);
+	if (sk_out->sk == -1) {
+		log_err("pthread getting specific for key failed, sk_out %p, sk %i, err: %i:%s",
+			sk_out, sk_out->sk, errno, strerror(errno));
+		abort();
+	}
 
 	fio_net_queue_cmd(FIO_NET_CMD_SERVER_START, NULL, 0, NULL, SK_F_SIMPLE);
 }
diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index 569fc62a..de98d032 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -36,6 +36,8 @@
 
 #include "../flist.h"
 
+#include "compiler/compiler.h"
+
 static int bs = 4096;
 static int max_us = 10000;
 static char *file;
@@ -47,6 +49,18 @@ static int separate_writer = 1;
 #define PLAT_NR		(PLAT_GROUP_NR * PLAT_VAL)
 #define PLAT_LIST_MAX	20
 
+#ifndef NDEBUG
+#define CHECK_ZERO_OR_ABORT(code) assert(code)
+#else
+#define CHECK_ZERO_OR_ABORT(code) 										\
+	do { 																\
+		if (fio_unlikely((code) != 0)) { 								\
+			log_err("failed checking code %i != 0", (code)); 	\
+			abort();													\
+		} 																\
+	} while (0)
+#endif
+
 struct stats {
 	unsigned int plat[PLAT_NR];
 	unsigned int nr_samples;
@@ -121,7 +135,7 @@ uint64_t utime_since(const struct timespec *s, const struct timespec *e)
 	return ret;
 }
 
-static struct work_item *find_seq(struct writer_thread *w, unsigned int seq)
+static struct work_item *find_seq(struct writer_thread *w, int seq)
 {
 	struct work_item *work;
 	struct flist_head *entry;
@@ -224,6 +238,8 @@ static int write_work(struct work_item *work)
 
 	clock_gettime(CLOCK_MONOTONIC, &s);
 	ret = write(STDOUT_FILENO, work->buf, work->buf_size);
+	if (ret < 0)
+		return (int)ret;
 	clock_gettime(CLOCK_MONOTONIC, &e);
 	assert(ret == work->buf_size);
 
@@ -241,10 +257,10 @@ static void *writer_fn(void *data)
 {
 	struct writer_thread *wt = data;
 	struct work_item *work;
-	unsigned int seq = 1;
+	int seq = 1;
 
 	work = NULL;
-	while (!wt->thread.exit || !flist_empty(&wt->list)) {
+	while (!(seq < 0) && (!wt->thread.exit || !flist_empty(&wt->list))) {
 		pthread_mutex_lock(&wt->thread.lock);
 
 		if (work)
@@ -467,10 +483,10 @@ static void init_thread(struct thread_data *thread)
 	int ret;
 
 	ret = pthread_condattr_init(&cattr);
-	assert(ret == 0);
+	CHECK_ZERO_OR_ABORT(ret);
 #ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
 	ret = pthread_condattr_setclock(&cattr, CLOCK_MONOTONIC);
-	assert(ret == 0);
+	CHECK_ZERO_OR_ABORT(ret);
 #endif
 	pthread_cond_init(&thread->cond, &cattr);
 	pthread_cond_init(&thread->done_cond, &cattr);
@@ -624,10 +640,10 @@ int main(int argc, char *argv[])
 	bytes = 0;
 
 	ret = pthread_condattr_init(&cattr);
-	assert(ret == 0);
+	CHECK_ZERO_OR_ABORT(ret);
 #ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
 	ret = pthread_condattr_setclock(&cattr, CLOCK_MONOTONIC);
-	assert(ret == 0);
+	CHECK_ZERO_OR_ABORT(ret);
 #endif
 
 	clock_gettime(CLOCK_MONOTONIC, &s);
diff --git a/zbd.c b/zbd.c
index 7fcf1ec4..d4565215 100644
--- a/zbd.c
+++ b/zbd.c
@@ -11,6 +11,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 
+#include "compiler/compiler.h"
 #include "os/os.h"
 #include "file.h"
 #include "fio.h"
@@ -102,13 +103,13 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 static void zone_lock(struct thread_data *td, const struct fio_file *f,
 		      struct fio_zone_info *z)
 {
+#ifndef NDEBUG
 	struct zoned_block_device_info *zbd = f->zbd_info;
-	uint32_t nz = z - zbd->zone_info;
-
+	uint32_t const nz = z - zbd->zone_info;
 	/* A thread should never lock zones outside its working area. */
 	assert(f->min_zone <= nz && nz < f->max_zone);
-
 	assert(z->has_wp);
+#endif
 
 	/*
 	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
@@ -128,11 +129,8 @@ static void zone_lock(struct thread_data *td, const struct fio_file *f,
 
 static inline void zone_unlock(struct fio_zone_info *z)
 {
-	int ret;
-
 	assert(z->has_wp);
-	ret = pthread_mutex_unlock(&z->mutex);
-	assert(!ret);
+	pthread_mutex_unlock(&z->mutex);
 }
 
 static inline struct fio_zone_info *zbd_get_zone(const struct fio_file *f,
@@ -420,7 +418,8 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 	int res = 0;
 
-	assert(min_bs);
+	if (fio_unlikely(0 == min_bs))
+		return 1;
 
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n",
 	       f->file_name, zbd_zone_idx(f, zb), zbd_zone_idx(f, ze));
@@ -1714,10 +1713,9 @@ unlock:
 static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 {
 	const struct fio_file *f = io_u->file;
-	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
 
-	assert(zbd_info);
+	assert(f->zbd_info);
 
 	z = zbd_offset_to_zone(f, io_u->offset);
 	assert(z->has_wp);
