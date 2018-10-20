Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbeJTUKX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 20 Oct 2018 16:10:23 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gDpvO-0008Kp-Cp
        for fio@vger.kernel.org; Sat, 20 Oct 2018 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181020120001.D36CA2C0083@kernel.dk>
Date: Sat, 20 Oct 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8eb142ddd8bc3fe9428cd46b9fd98f32b2bc8c67:

  fio: reset more counters when ramp time has elapsed (2018-10-18 15:33:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 307f2246d65d9dbea7e5f56cd17734cb68c2817f:

  docs: serialize_overlap=1 with io_submit_mode=offload no longer requires threads (2018-10-19 11:09:23 -0600)

----------------------------------------------------------------
Adam Kupczyk (1):
      iolog: Fix problem with setup() not invoked when read_iolog is used.

Ben England (1):
      add rsp. time samples as column 2, use meaningful pctile names

Jens Axboe (3):
      Merge branch 'fix-init-read-iolog' of https://github.com/aclamk/fio
      filesetup: fix whitespace damage introduced by previous patch
      Merge branch 'samples-colnames' of https://github.com/parallel-fs-utils/fio

Vincent Fu (4):
      fio: add function to check for serialize_overlap with offload submission
      fio: enable cross-thread overlap checking with processes
      fio: document locking for overlap checking in offload mode
      docs: serialize_overlap=1 with io_submit_mode=offload no longer requires threads

 HOWTO                               |  2 +-
 backend.c                           | 21 +++++++++++++--------
 filesetup.c                         |  6 +++---
 fio.1                               |  2 +-
 fio.h                               |  5 +++++
 io_u_queue.c                        | 17 +++++++++++++----
 io_u_queue.h                        |  4 ++--
 ioengines.c                         |  9 ++++++++-
 lib/memalign.c                      | 16 ++++++++++++----
 lib/memalign.h                      |  5 +++--
 rate-submit.c                       |  8 ++++++++
 t/dedupe.c                          | 12 ++++++------
 tools/hist/fio-histo-log-pctiles.py | 23 ++++++++++++++++++++---
 13 files changed, 95 insertions(+), 35 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 72ef872..468772d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2343,7 +2343,7 @@ I/O depth
 	This option only applies to I/Os issued for a single job except when it is
 	enabled along with :option:`io_submit_mode`=offload. In offload mode, fio
 	will check for overlap among all I/Os submitted by offload jobs with :option:`serialize_overlap`
-	enabled. Threads must be used for all such jobs.
+	enabled.
 
 	Default: false.
 
diff --git a/backend.c b/backend.c
index cc3c4e7..d6450ba 100644
--- a/backend.c
+++ b/backend.c
@@ -1189,14 +1189,14 @@ static void cleanup_io_u(struct thread_data *td)
 		if (td->io_ops->io_u_free)
 			td->io_ops->io_u_free(td, io_u);
 
-		fio_memfree(io_u, sizeof(*io_u));
+		fio_memfree(io_u, sizeof(*io_u), td_offload_overlap(td));
 	}
 
 	free_io_mem(td);
 
 	io_u_rexit(&td->io_u_requeues);
-	io_u_qexit(&td->io_u_freelist);
-	io_u_qexit(&td->io_u_all);
+	io_u_qexit(&td->io_u_freelist, false);
+	io_u_qexit(&td->io_u_all, td_offload_overlap(td));
 
 	free_file_completion_logging(td);
 }
@@ -1211,8 +1211,8 @@ static int init_io_u(struct thread_data *td)
 
 	err = 0;
 	err += !io_u_rinit(&td->io_u_requeues, td->o.iodepth);
-	err += !io_u_qinit(&td->io_u_freelist, td->o.iodepth);
-	err += !io_u_qinit(&td->io_u_all, td->o.iodepth);
+	err += !io_u_qinit(&td->io_u_freelist, td->o.iodepth, false);
+	err += !io_u_qinit(&td->io_u_all, td->o.iodepth, td_offload_overlap(td));
 
 	if (err) {
 		log_err("fio: failed setting up IO queues\n");
@@ -1227,7 +1227,7 @@ static int init_io_u(struct thread_data *td)
 		if (td->terminate)
 			return 1;
 
-		ptr = fio_memalign(cl_align, sizeof(*io_u));
+		ptr = fio_memalign(cl_align, sizeof(*io_u), td_offload_overlap(td));
 		if (!ptr) {
 			log_err("fio: unable to allocate aligned memory\n");
 			break;
@@ -1874,10 +1874,15 @@ static void *thread_main(void *data)
 			 "perhaps try --debug=io option for details?\n",
 			 td->o.name, td->io_ops->name);
 
-	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
+	/*
+	 * Acquire this lock if we were doing overlap checking in
+	 * offload mode so that we don't clean up this job while
+	 * another thread is checking its io_u's for overlap
+	 */
+	if (td_offload_overlap(td))
 		pthread_mutex_lock(&overlap_check);
 	td_set_runstate(td, TD_FINISHING);
-	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
+	if (td_offload_overlap(td))
 		pthread_mutex_unlock(&overlap_check);
 
 	update_rusage_stat(td);
diff --git a/filesetup.c b/filesetup.c
index c0fa3cd..aa1a394 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -908,9 +908,6 @@ int setup_files(struct thread_data *td)
 
 	old_state = td_bump_runstate(td, TD_SETTING_UP);
 
-	if (o->read_iolog_file)
-		goto done;
-
 	/*
 	 * Find out physical size of files or devices for this thread,
 	 * before we determine I/O size and range of our targets.
@@ -926,6 +923,9 @@ int setup_files(struct thread_data *td)
 	if (err)
 		goto err_out;
 
+	if (o->read_iolog_file)
+		goto done;
+
 	/*
 	 * check sizes. if the files/devices do not exist and the size
 	 * isn't passed to fio, abort.
diff --git a/fio.1 b/fio.1
index 7691b2b..ed49268 100644
--- a/fio.1
+++ b/fio.1
@@ -2075,7 +2075,7 @@ this option can reduce both performance and the \fBiodepth\fR achieved.
 This option only applies to I/Os issued for a single job except when it is
 enabled along with \fBio_submit_mode\fR=offload. In offload mode, fio
 will check for overlap among all I/Os submitted by offload jobs with \fBserialize_overlap\fR
-enabled. Threads must be used for all such jobs.
+enabled.
 .P
 Default: false.
 .RE
diff --git a/fio.h b/fio.h
index e394e16..b3ba5db 100644
--- a/fio.h
+++ b/fio.h
@@ -772,6 +772,11 @@ static inline bool td_async_processing(struct thread_data *td)
 	return (td->flags & TD_F_NEED_LOCK) != 0;
 }
 
+static inline bool td_offload_overlap(struct thread_data *td)
+{
+	return td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD;
+}
+
 /*
  * We currently only need to do locking if we have verifier threads
  * accessing our internal structures too
diff --git a/io_u_queue.c b/io_u_queue.c
index 8cf4c8c..41f98bc 100644
--- a/io_u_queue.c
+++ b/io_u_queue.c
@@ -1,9 +1,15 @@
 #include <stdlib.h>
+#include <string.h>
 #include "io_u_queue.h"
+#include "smalloc.h"
 
-bool io_u_qinit(struct io_u_queue *q, unsigned int nr)
+bool io_u_qinit(struct io_u_queue *q, unsigned int nr, bool shared)
 {
-	q->io_us = calloc(nr, sizeof(struct io_u *));
+	if (shared)
+		q->io_us = smalloc(nr * sizeof(struct io_u *));
+	else
+		q->io_us = calloc(nr, sizeof(struct io_u *));
+
 	if (!q->io_us)
 		return false;
 
@@ -12,9 +18,12 @@ bool io_u_qinit(struct io_u_queue *q, unsigned int nr)
 	return true;
 }
 
-void io_u_qexit(struct io_u_queue *q)
+void io_u_qexit(struct io_u_queue *q, bool shared)
 {
-	free(q->io_us);
+	if (shared)
+		sfree(q->io_us);
+	else
+		free(q->io_us);
 }
 
 bool io_u_rinit(struct io_u_ring *ring, unsigned int nr)
diff --git a/io_u_queue.h b/io_u_queue.h
index 545e2c4..87de894 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -45,8 +45,8 @@ static inline int io_u_qempty(const struct io_u_queue *q)
 #define io_u_qiter(q, io_u, i)	\
 	for (i = 0; i < (q)->nr && (io_u = (q)->io_us[i]); i++)
 
-bool io_u_qinit(struct io_u_queue *q, unsigned int nr);
-void io_u_qexit(struct io_u_queue *q);
+bool io_u_qinit(struct io_u_queue *q, unsigned int nr, bool shared);
+void io_u_qexit(struct io_u_queue *q, bool shared);
 
 struct io_u_ring {
 	unsigned int head;
diff --git a/ioengines.c b/ioengines.c
index 47f606a..b7df860 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -288,7 +288,14 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 
 	assert((io_u->flags & IO_U_F_FLIGHT) == 0);
 	io_u_set(td, io_u, IO_U_F_FLIGHT);
-	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
+
+	/*
+	 * If overlap checking was enabled in offload mode we
+	 * can release this lock that was acquired when we
+	 * started the overlap check because the IO_U_F_FLIGHT
+	 * flag is now set
+	 */
+	if (td_offload_overlap(td))
 		pthread_mutex_unlock(&overlap_check);
 
 	assert(fio_file_open(io_u->file));
diff --git a/lib/memalign.c b/lib/memalign.c
index e774c19..537bb9f 100644
--- a/lib/memalign.c
+++ b/lib/memalign.c
@@ -2,6 +2,7 @@
 #include <stdlib.h>
 
 #include "memalign.h"
+#include "smalloc.h"
 
 #define PTR_ALIGN(ptr, mask)   \
 	(char *)((uintptr_t)((ptr) + (mask)) & ~(mask))
@@ -10,14 +11,18 @@ struct align_footer {
 	unsigned int offset;
 };
 
-void *fio_memalign(size_t alignment, size_t size)
+void *fio_memalign(size_t alignment, size_t size, bool shared)
 {
 	struct align_footer *f;
 	void *ptr, *ret = NULL;
 
 	assert(!(alignment & (alignment - 1)));
 
-	ptr = malloc(size + alignment + sizeof(*f) - 1);
+	if (shared)
+		ptr = smalloc(size + alignment + sizeof(*f) - 1);
+	else
+		ptr = malloc(size + alignment + sizeof(*f) - 1);
+
 	if (ptr) {
 		ret = PTR_ALIGN(ptr, alignment - 1);
 		f = ret + size;
@@ -27,9 +32,12 @@ void *fio_memalign(size_t alignment, size_t size)
 	return ret;
 }
 
-void fio_memfree(void *ptr, size_t size)
+void fio_memfree(void *ptr, size_t size, bool shared)
 {
 	struct align_footer *f = ptr + size;
 
-	free(ptr - f->offset);
+	if (shared)
+		sfree(ptr - f->offset);
+	else
+		free(ptr - f->offset);
 }
diff --git a/lib/memalign.h b/lib/memalign.h
index c2eb170..d703087 100644
--- a/lib/memalign.h
+++ b/lib/memalign.h
@@ -2,8 +2,9 @@
 #define FIO_MEMALIGN_H
 
 #include <inttypes.h>
+#include <stdbool.h>
 
-extern void *fio_memalign(size_t alignment, size_t size);
-extern void fio_memfree(void *ptr, size_t size);
+extern void *fio_memalign(size_t alignment, size_t size, bool shared);
+extern void fio_memfree(void *ptr, size_t size, bool shared);
 
 #endif
diff --git a/rate-submit.c b/rate-submit.c
index 68ad755..e5c6204 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -21,6 +21,14 @@ static void check_overlap(struct io_u *io_u)
 		 * time to prevent two threads from thinking the coast
 		 * is clear and then submitting IOs that overlap with
 		 * each other
+		 *
+		 * If an overlap is found, release the lock and
+		 * re-acquire it before checking again to give other
+		 * threads a chance to make progress
+		 *
+		 * If an overlap is not found, release the lock when the
+		 * io_u's IO_U_F_FLIGHT flag is set so that this io_u
+		 * can be checked by other threads as they assess overlap
 		 */
 		pthread_mutex_lock(&overlap_check);
 		for_each_td(td, i) {
diff --git a/t/dedupe.c b/t/dedupe.c
index 37120e1..2ef8dc5 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -158,8 +158,8 @@ static int col_check(struct chunk *c, struct item *i)
 	char *cbuf, *ibuf;
 	int ret = 1;
 
-	cbuf = fio_memalign(blocksize, blocksize);
-	ibuf = fio_memalign(blocksize, blocksize);
+	cbuf = fio_memalign(blocksize, blocksize, false);
+	ibuf = fio_memalign(blocksize, blocksize, false);
 
 	e = flist_entry(c->extent_list[0].next, struct extent, list);
 	if (read_block(file.fd, cbuf, e->offset))
@@ -170,8 +170,8 @@ static int col_check(struct chunk *c, struct item *i)
 
 	ret = memcmp(ibuf, cbuf, blocksize);
 out:
-	fio_memfree(cbuf, blocksize);
-	fio_memfree(ibuf, blocksize);
+	fio_memfree(cbuf, blocksize, false);
+	fio_memfree(ibuf, blocksize, false);
 	return ret;
 }
 
@@ -309,7 +309,7 @@ static void *thread_fn(void *data)
 	struct worker_thread *thread = data;
 	void *buf;
 
-	buf = fio_memalign(blocksize, chunk_size);
+	buf = fio_memalign(blocksize, chunk_size, false);
 
 	do {
 		if (get_work(&thread->cur_offset, &thread->size)) {
@@ -323,7 +323,7 @@ static void *thread_fn(void *data)
 	} while (1);
 
 	thread->done = 1;
-	fio_memfree(buf, chunk_size);
+	fio_memfree(buf, chunk_size, false);
 	return NULL;
 }
 
diff --git a/tools/hist/fio-histo-log-pctiles.py b/tools/hist/fio-histo-log-pctiles.py
index 7f08f6e..f9df2a3 100755
--- a/tools/hist/fio-histo-log-pctiles.py
+++ b/tools/hist/fio-histo-log-pctiles.py
@@ -272,6 +272,13 @@ def add_to_histo_from( target, source ):
     for b in range(0, len(source)):
         target[b] += source[b]
 
+
+# calculate total samples in the histogram buckets
+
+def get_samples(buckets):
+    return reduce( lambda x,y: x + y, buckets)
+
+
 # compute percentiles
 # inputs:
 #   buckets: histogram bucket array 
@@ -453,14 +460,24 @@ def compute_percentiles_from_logs():
     # calculate percentiles across aggregate histogram for all threads
     # print CSV header just like fiologparser_hist does
 
-    header = 'msec-since-start, '
+    header = 'msec-since-start, samples, '
     for p in args.pctiles_wanted:
-        header += '%3.1f, ' % p
+        if p == 0.:
+            next_pctile_header = 'min'
+        elif p == 100.:
+            next_pctile_header = 'max'
+        elif p == 50.:
+            next_pctile_header = 'median'
+        else:
+            next_pctile_header = '%3.1f' % p
+        header += '%s, ' % next_pctile_header
+
     print('time (millisec), percentiles in increasing order with values in ' + args.output_unit)
     print(header)
 
     for (t_msec, all_threads_histo_t) in all_threads_histograms:
-        record = '%8d, ' % t_msec
+        samples = get_samples(all_threads_histo_t)
+        record = '%8d, %8d, ' % (t_msec, samples)
         pct = get_pctiles(all_threads_histo_t, args.pctiles_wanted, bucket_times)
         if not pct:
             for w in args.pctiles_wanted:

