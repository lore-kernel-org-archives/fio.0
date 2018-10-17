Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH v2 2/4] fio: enable cross-thread overlap checking with processes
Date: Wed, 17 Oct 2018 10:52:23 -0400
Message-Id: <20181017145225.14546-3-vincentfu@gmail.com>
In-Reply-To: <20181017145225.14546-1-vincentfu@gmail.com>
References: <20181017145225.14546-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Overlap checking with io_submit_mode=offload requires relevant jobs to
access each other's io_u's and io_u_all members. This patch modifies the
fio_memalign and io_u_queue helpers to include an indicator signifying
whether operations should use the shared memory pool. When fio is
carrying out cross-job overlap checking in offload submission mode,
these variables will be allocated from shared memory so that processes
can be used and threads will no longer be required.
---
 backend.c      | 12 ++++++------
 io_u_queue.c   | 19 +++++++++++++++----
 io_u_queue.h   |  4 ++--
 lib/memalign.c | 16 ++++++++++++----
 lib/memalign.h |  5 +++--
 t/dedupe.c     | 12 ++++++------
 6 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/backend.c b/backend.c
index f0a45bc8..1c60138c 100644
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
diff --git a/io_u_queue.c b/io_u_queue.c
index 8cf4c8c3..f293cfa3 100644
--- a/io_u_queue.c
+++ b/io_u_queue.c
@@ -1,9 +1,17 @@
 #include <stdlib.h>
+#include <string.h>
 #include "io_u_queue.h"
+#include "smalloc.h"
 
-bool io_u_qinit(struct io_u_queue *q, unsigned int nr)
+bool io_u_qinit(struct io_u_queue *q, unsigned int nr, bool shared)
 {
-	q->io_us = calloc(nr, sizeof(struct io_u *));
+	if (shared) {
+		q->io_us = smalloc(nr * sizeof(struct io_u *));
+		memset(q->io_us, 0, nr * sizeof(struct io_u *));
+	}
+	else
+		q->io_us = calloc(nr, sizeof(struct io_u *));
+
 	if (!q->io_us)
 		return false;
 
@@ -12,9 +20,12 @@ bool io_u_qinit(struct io_u_queue *q, unsigned int nr)
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
index 545e2c41..87de894a 100644
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
diff --git a/lib/memalign.c b/lib/memalign.c
index e774c19c..537bb9fb 100644
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
index c2eb1702..d7030870 100644
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
diff --git a/t/dedupe.c b/t/dedupe.c
index 37120e18..2ef8dc53 100644
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
 
-- 
2.17.1


