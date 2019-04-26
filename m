Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Apr 2019 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJzWN-0008SS-0n
        for fio@vger.kernel.org; Fri, 26 Apr 2019 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190426120001.AA1A62C0104@kernel.dk>
Date: Fri, 26 Apr 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit afc22c98609ee80a99fbed24231181bdab2bc659:

  Merge branch 'libiscsi' of https://github.com/smartxworks/fio (2019-04-22 08:38:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 051382218cbe5101a5caa83eab55ed04608f8475:

  io_uring: remove cachehit information (2019-04-25 13:27:54 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fix __FIO_OPT_G_ISCSI numbering
      io_uring: remove cachehit information

Phillip Chen (1):
      zbd random read conventional zones

 engines/io_uring.c  | 13 -------------
 optgroup.h          |  2 +-
 os/linux/io_uring.h |  5 -----
 t/io_uring.c        | 28 ++++------------------------
 zbd.c               |  2 --
 5 files changed, 5 insertions(+), 45 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 014f954e..5b3509a9 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -62,9 +62,6 @@ struct ioring_data {
 	int cq_ring_off;
 	unsigned iodepth;
 
-	uint64_t cachehit;
-	uint64_t cachemiss;
-
 	struct ioring_mmap mmap[3];
 };
 
@@ -197,13 +194,6 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	} else
 		io_u->error = 0;
 
-	if (io_u->ddir == DDIR_READ) {
-		if (cqe->flags & IOCQE_FLAG_CACHEHIT)
-			ld->cachehit++;
-		else
-			ld->cachemiss++;
-	}
-
 	return io_u;
 }
 
@@ -391,9 +381,6 @@ static void fio_ioring_cleanup(struct thread_data *td)
 	struct ioring_data *ld = td->io_ops_data;
 
 	if (ld) {
-		td->ts.cachehit += ld->cachehit;
-		td->ts.cachemiss += ld->cachemiss;
-
 		if (!(td->flags & TD_F_CHILD))
 			fio_ioring_unmap(ld);
 
diff --git a/optgroup.h b/optgroup.h
index 483adddd..148c8da1 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -62,8 +62,8 @@ enum opt_category_group {
 	__FIO_OPT_G_HDFS,
 	__FIO_OPT_G_SG,
 	__FIO_OPT_G_MMAP,
-	__FIO_OPT_G_NR,
 	__FIO_OPT_G_ISCSI,
+	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 24906e99..e2340869 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -69,11 +69,6 @@ struct io_uring_cqe {
 	__u32	flags;
 };
 
-/*
- * io_uring_event->flags
- */
-#define IOCQE_FLAG_CACHEHIT	(1U << 0)	/* IO did not hit media */
-
 /*
  * Magic offsets for the application to mmap the data it needs
  */
diff --git a/t/io_uring.c b/t/io_uring.c
index 363cba3e..79a92311 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -71,7 +71,6 @@ struct submitter {
 	unsigned long reaps;
 	unsigned long done;
 	unsigned long calls;
-	unsigned long cachehit, cachemiss;
 	volatile int finish;
 
 	__s32 *fds;
@@ -269,10 +268,6 @@ static int reap_events(struct submitter *s)
 				return -1;
 			}
 		}
-		if (cqe->flags & IOCQE_FLAG_CACHEHIT)
-			s->cachehit++;
-		else
-			s->cachemiss++;
 		reaped++;
 		head++;
 	} while (1);
@@ -497,7 +492,7 @@ static void usage(char *argv)
 int main(int argc, char *argv[])
 {
 	struct submitter *s;
-	unsigned long done, calls, reap, cache_hit, cache_miss;
+	unsigned long done, calls, reap;
 	int err, i, flags, fd, opt;
 	char *fdepths;
 	void *ret;
@@ -600,44 +595,29 @@ int main(int argc, char *argv[])
 	pthread_create(&s->thread, NULL, submitter_fn, s);
 
 	fdepths = malloc(8 * s->nr_files);
-	cache_hit = cache_miss = reap = calls = done = 0;
+	reap = calls = done = 0;
 	do {
 		unsigned long this_done = 0;
 		unsigned long this_reap = 0;
 		unsigned long this_call = 0;
-		unsigned long this_cache_hit = 0;
-		unsigned long this_cache_miss = 0;
 		unsigned long rpc = 0, ipc = 0;
-		double hit = 0.0;
 
 		sleep(1);
 		this_done += s->done;
 		this_call += s->calls;
 		this_reap += s->reaps;
-		this_cache_hit += s->cachehit;
-		this_cache_miss += s->cachemiss;
-		if (this_cache_hit && this_cache_miss) {
-			unsigned long hits, total;
-
-			hits = this_cache_hit - cache_hit;
-			total = hits + this_cache_miss - cache_miss;
-			hit = (double) hits / (double) total;
-			hit *= 100.0;
-		}
 		if (this_call - calls) {
 			rpc = (this_done - done) / (this_call - calls);
 			ipc = (this_reap - reap) / (this_call - calls);
 		} else
 			rpc = ipc = -1;
 		file_depths(fdepths);
-		printf("IOPS=%lu, IOS/call=%ld/%ld, inflight=%u (%s), Cachehit=%0.2f%%\n",
+		printf("IOPS=%lu, IOS/call=%ld/%ld, inflight=%u (%s)\n",
 				this_done - done, rpc, ipc, s->inflight,
-				fdepths, hit);
+				fdepths);
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;
-		cache_hit = s->cachehit;
-		cache_miss = s->cachemiss;
 	} while (!finish);
 
 	pthread_join(s->thread, &ret);
diff --git a/zbd.c b/zbd.c
index 1c46b452..d7e91e37 100644
--- a/zbd.c
+++ b/zbd.c
@@ -426,8 +426,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			p->start = z->start << 9;
 			switch (z->cond) {
 			case BLK_ZONE_COND_NOT_WP:
-				p->wp = p->start;
-				break;
 			case BLK_ZONE_COND_FULL:
 				p->wp = p->start + zone_size;
 				break;

