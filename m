Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Sep 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XWlEp-0007LL-Sw
	for fio@vger.kernel.org; Wed, 24 Sep 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140924120002.D3B28401F3@lyth.info>
Date: Wed, 24 Sep 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c0b69b92fb155424946b19228da9be0924e9e96c:

  dedupe: if percentage is 100, don't go through random + math (2014-09-22 14:20:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4877c1ab380b199ba6d9207b689bb1df127b0b4b:

  t/dedupe: Linux only for now (2014-09-23 18:36:52 -0600)

----------------------------------------------------------------
Jens Axboe (10):
      fifo: use minmax.h instead of rolling its own min/max
      Fix min/max typeof warnings
      memalign: fix off-by-one bug in alignment
      Checksumming updates
      Add small tool to check for dedupable contents in a file/device
      dedupe: improve wording in output
      dedupe: print progress indicator
      Build t/ tools by default
      Fix 32-bit compile warnings
      t/dedupe: Linux only for now

 Makefile       |   14 ++
 crc/md5.c      |   20 +++
 crc/md5.h      |    1 +
 crc/sha256.c   |   64 +++++---
 crc/sha256.h   |    8 +-
 crc/test.c     |    4 +
 fifo.h         |   19 +--
 lib/axmap.c    |    2 +-
 lib/zipf.c     |    4 +-
 memalign.c     |    2 +-
 minmax.h       |   13 +-
 parse.c        |    2 +-
 t/btrace2fio.c |    2 +-
 t/dedupe.c     |  481 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 t/lfsr-test.c  |   11 +-
 15 files changed, 595 insertions(+), 52 deletions(-)
 create mode 100644 t/dedupe.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 4350e5a..fe439c1 100644
--- a/Makefile
+++ b/Makefile
@@ -189,12 +189,20 @@ T_BTRACE_FIO_OBJS += fifo.o lib/flist_sort.o t/log.o lib/linux-dev-lookup.o
 T_BTRACE_FIO_PROGS = t/btrace2fio
 endif
 
+ifeq ($(CONFIG_TARGET_OS), Linux)
+T_DEDUPE_OBJS = t/dedupe.o
+T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
+		memalign.o
+T_DEDUPE_PROGS = t/dedupe
+endif
+
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
 T_OBJS += $(T_ZIPF_OBJS)
 T_OBJS += $(T_AXMAP_OBJS)
 T_OBJS += $(T_LFSR_TEST_OBJS)
 T_OBJS += $(T_BTRACE_FIO_OBJS)
+T_OBJS += $(T_DEDUPE_OBJS)
 
 T_PROGS = $(T_SMALLOC_PROGS)
 T_PROGS += $(T_IEEE_PROGS)
@@ -202,6 +210,9 @@ T_PROGS += $(T_ZIPF_PROGS)
 T_PROGS += $(T_AXMAP_PROGS)
 T_PROGS += $(T_LFSR_TEST_PROGS)
 T_PROGS += $(T_BTRACE_FIO_PROGS)
+T_PROGS += $(T_DEDUPE_PROGS)
+
+PROGS += $(T_PROGS)
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
@@ -303,6 +314,9 @@ t/btrace2fio: $(T_BTRACE_FIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_BTRACE_FIO_OBJS) $(LIBS)
 endif
 
+t/dedupe: $(T_DEDUPE_OBJS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
+
 clean: FORCE
 	-rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h
 
diff --git a/crc/md5.c b/crc/md5.c
index 0da85e4..64fe48a 100644
--- a/crc/md5.c
+++ b/crc/md5.c
@@ -125,3 +125,23 @@ void fio_md5_update(struct fio_md5_ctx *mctx, const uint8_t *data,
 
 	memcpy(mctx->block, data, len);
 }
+
+void fio_md5_final(struct fio_md5_ctx *mctx)
+{
+	const unsigned int offset = mctx->byte_count & 0x3f;
+	char *p = (char *)mctx->block + offset;
+	int padding = 56 - (offset + 1);
+
+	*p++ = 0x80;
+	if (padding < 0) {
+		memset(p, 0x00, padding + sizeof (uint64_t));
+		md5_transform(mctx->hash, mctx->block);
+		p = (char *)mctx->block;
+		padding = 56;
+	}
+
+	memset(p, 0, padding);
+	mctx->block[14] = mctx->byte_count << 3;
+	mctx->block[15] = mctx->byte_count >> 29;
+	md5_transform(mctx->hash, mctx->block);
+}
diff --git a/crc/md5.h b/crc/md5.h
index 668f0e9..54e350c 100644
--- a/crc/md5.h
+++ b/crc/md5.h
@@ -23,6 +23,7 @@ struct fio_md5_ctx {
 };
 
 extern void fio_md5_update(struct fio_md5_ctx *, const uint8_t *, unsigned int);
+extern void fio_md5_final(struct fio_md5_ctx *);
 extern void fio_md5_init(struct fio_md5_ctx *);
 
 #endif
diff --git a/crc/sha256.c b/crc/sha256.c
index 3a72a5b..ae9ff4d 100644
--- a/crc/sha256.c
+++ b/crc/sha256.c
@@ -237,37 +237,57 @@ void fio_sha256_init(struct fio_sha256_ctx *sctx)
 	sctx->state[5] = H5;
 	sctx->state[6] = H6;
 	sctx->state[7] = H7;
-	sctx->count[0] = sctx->count[1] = 0;
+	sctx->count = 0;
 }
 
 void fio_sha256_update(struct fio_sha256_ctx *sctx, const uint8_t *data,
 		       unsigned int len)
 {
-	unsigned int i, idx, part_len;
+	unsigned int partial, done;
+	const uint8_t *src;
 
-	/* Compute number of bytes mod 128 */
-	idx = (unsigned int)((sctx->count[0] >> 3) & 0x3f);
+	partial = sctx->count & 0x3f;
+	sctx->count += len;
+	done = 0;
+	src = data;
 
-	/* Update number of bits */
-	if ((sctx->count[0] += (len << 3)) < (len << 3)) {
-		sctx->count[1]++;
-		sctx->count[1] += (len >> 29);
+	if ((partial + len) > 63) {
+		if (partial) {
+			done = -partial;
+			memcpy(sctx->buf + partial, data, done + 64);
+			src = sctx->buf;
+		}
+
+		do {
+			sha256_transform(sctx->state, src);
+			done += 64;
+			src = data + done;
+		} while (done + 63 < len);
+
+		partial = 0;
 	}
+	memcpy(sctx->buf + partial, src, len - done);
+}
+
+void fio_sha256_final(struct fio_sha256_ctx *sctx)
+{
+	uint64_t bits;
+	unsigned int index, pad_len;
+	int i;
+	static const uint8_t padding[64] = { 0x80, };
 
-	part_len = 64 - idx;
+	/* Save number of bits */
+	bits = sctx->count << 3;
 
-	/* Transform as many times as possible. */
-	if (len >= part_len) {
-		memcpy(&sctx->buf[idx], data, part_len);
-		sha256_transform(sctx->state, sctx->buf);
+	/* Pad out to 56 mod 64. */
+	index = sctx->count & 0x3f;
+	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
+	fio_sha256_update(sctx, padding, pad_len);
 
-		for (i = part_len; i + 63 < len; i += 64)
-			sha256_transform(sctx->state, &data[i]);
-		idx = 0;
-	} else {
-		i = 0;
-	}
-	
-	/* Buffer remaining input */
-	memcpy(&sctx->buf[idx], &data[i], len-i);
+	/* Append length (before padding) */
+	fio_sha256_update(sctx, (const uint8_t *)&bits, sizeof(bits));
+
+	/* Store state in digest */
+	for (i = 0; i < 8; i++)
+		sctx->buf[i] = sctx->state[i];
 }
diff --git a/crc/sha256.h b/crc/sha256.h
index c7aa28f..b636033 100644
--- a/crc/sha256.h
+++ b/crc/sha256.h
@@ -1,13 +1,17 @@
 #ifndef FIO_SHA256_H
 #define FIO_SHA256_H
 
+#define SHA256_DIGEST_SIZE	32
+#define SHA256_BLOCK_SIZE	64
+
 struct fio_sha256_ctx {
-	uint32_t count[2];
-	uint32_t state[8];
+	uint32_t count;
+	uint32_t state[SHA256_DIGEST_SIZE / 4];
 	uint8_t *buf;
 };
 
 void fio_sha256_init(struct fio_sha256_ctx *);
 void fio_sha256_update(struct fio_sha256_ctx *, const uint8_t *, unsigned int);
+void fio_sha256_final(struct fio_sha256_ctx *);
 
 #endif
diff --git a/crc/test.c b/crc/test.c
index 0c3b2da..36054e6 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -52,6 +52,8 @@ static void t_md5(void *buf, size_t size)
 
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_md5_update(&ctx, buf, size);
+
+	fio_md5_final(&ctx);
 }
 
 static void t_crc64(void *buf, size_t size)
@@ -116,6 +118,8 @@ static void t_sha256(void *buf, size_t size)
 
 	for (i = 0; i < NR_CHUNKS; i++)
 		fio_sha256_update(&ctx, buf, size);
+
+	fio_sha256_final(&ctx);
 }
 
 static void t_sha512(void *buf, size_t size)
diff --git a/fifo.h b/fifo.h
index 7491365..4b775b0 100644
--- a/fifo.h
+++ b/fifo.h
@@ -1,3 +1,5 @@
+#ifndef FIO_FIFO_H
+#define FIO_FIFO_H
 /*
  * A simple FIFO implementation.
  *
@@ -18,6 +20,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */
+#include "minmax.h"
+
 struct fifo {
 	unsigned char *buffer;	/* the buffer holding the data */
 	unsigned int size;	/* the size of the allocated buffer */
@@ -40,19 +44,4 @@ static inline unsigned int fifo_room(struct fifo *fifo)
 	return fifo->size - fifo->in + fifo->out;
 }
 
-#ifndef min
-#define min(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x < _y ? _x : _y; })
-#endif
-
-#ifndef max
-#define max(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x > _y ? _x : _y; })
-
 #endif
diff --git a/lib/axmap.c b/lib/axmap.c
index 15cd635..5b8cb30 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -33,7 +33,7 @@
 #error "Number of arch bits unknown"
 #endif
 
-#define BLOCKS_PER_UNIT		(1UL << UNIT_SHIFT)
+#define BLOCKS_PER_UNIT		(1U << UNIT_SHIFT)
 #define BLOCKS_PER_UNIT_MASK	(BLOCKS_PER_UNIT - 1)
 
 #define firstfree_valid(b)	((b)->first_free != (uint64_t) -1)
diff --git a/lib/zipf.c b/lib/zipf.c
index 9b6ce63..c691bc5 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -11,7 +11,7 @@
 #include "../minmax.h"
 #include "../hash.h"
 
-#define ZIPF_MAX_GEN	10000000
+#define ZIPF_MAX_GEN	10000000UL
 
 static void zipf_update(struct zipf_state *zs)
 {
@@ -23,7 +23,7 @@ static void zipf_update(struct zipf_state *zs)
 	 * 10M max, that should be doable in 1-2s on even slow machines.
 	 * Precision will take a slight hit, but nothing major.
 	 */
-	to_gen = min(zs->nranges, ZIPF_MAX_GEN);
+	to_gen = min(zs->nranges, (uint64_t) ZIPF_MAX_GEN);
 
 	for (i = 0; i < to_gen; i++)
 		zs->zetan += pow(1.0 / (double) (i + 1), zs->theta);
diff --git a/memalign.c b/memalign.c
index 7a04ffd..cfd6e46 100644
--- a/memalign.c
+++ b/memalign.c
@@ -20,7 +20,7 @@ void *fio_memalign(size_t alignment, size_t size)
 
 	ptr = malloc(size + alignment + size + sizeof(*f) - 1);
 	if (ptr) {
-		ret = PTR_ALIGN(ptr, alignment);
+		ret = PTR_ALIGN(ptr, alignment - 1);
 		f = ret + size;
 		f->offset = (uintptr_t) ret - (uintptr_t) ptr;
 	}
diff --git a/minmax.h b/minmax.h
index e5c2f58..97957c8 100644
--- a/minmax.h
+++ b/minmax.h
@@ -2,10 +2,19 @@
 #define FIO_MIN_MAX_H
 
 #ifndef min
-#define min(a, b)	((a) < (b) ? (a) : (b))
+#define min(x,y) ({ \
+	typeof(x) _x = (x);	\
+	typeof(y) _y = (y);	\
+	(void) (&_x == &_y);		\
+	_x < _y ? _x : _y; })
 #endif
+
 #ifndef max
-#define max(a, b)	((a) > (b) ? (a) : (b))
+#define max(x,y) ({ \
+	typeof(x) _x = (x);	\
+	typeof(y) _y = (y);	\
+	(void) (&_x == &_y);		\
+	_x > _y ? _x : _y; })
 #endif
 
 #endif
diff --git a/parse.c b/parse.c
index e6d9406..40cd465 100644
--- a/parse.c
+++ b/parse.c
@@ -380,7 +380,7 @@ static int check_int(const char *p, int *val)
 	return 1;
 }
 
-static int opt_len(const char *str)
+static size_t opt_len(const char *str)
 {
 	char *postfix;
 
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index e4e05ca..5666a56 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -589,7 +589,7 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 		perc = ((float) o->merges[i] * 100.0) / (float) total;
 		printf("\tmerges: %lu (perc=%3.2f%%)\n", o->merges[i], perc);
 		perc = ((float) o->seq[i] * 100.0) / (float) o->ios[i];
-		printf("\tseq:    %lu (perc=%3.2f%%)\n", o->seq[i], perc);
+		printf("\tseq:    %lu (perc=%3.2f%%)\n", (unsigned long) o->seq[i], perc);
 		printf("\trate:   %lu KB/sec\n", o_to_kb_rate(o, i));
 
 		for (j = 0; j < o->nr_bs[i]; j++) {
diff --git a/t/dedupe.c b/t/dedupe.c
new file mode 100644
index 0000000..e51e444
--- /dev/null
+++ b/t/dedupe.c
@@ -0,0 +1,481 @@
+/*
+ * Small tool to check for dedupable blocks in a file or device. Basically
+ * just scans the filename for extents of the given size, checksums them,
+ * and orders them up.
+ */
+#include <stdio.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <inttypes.h>
+#include <assert.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+#include <fcntl.h>
+#include <string.h>
+
+#include "../lib/rbtree.h"
+#include "../flist.h"
+#include "../log.h"
+#include "../mutex.h"
+#include "../smalloc.h"
+#include "../minmax.h"
+#include "../crc/md5.h"
+#include "../memalign.h"
+#include "../os/os.h"
+
+FILE *f_err;
+struct timeval *fio_tv = NULL;
+unsigned int fio_debug = 0;
+
+void __dprint(int type, const char *str, ...)
+{
+}
+
+struct worker_thread {
+	pthread_t thread;
+
+	volatile int done;
+
+	int fd;
+	uint64_t cur_offset;
+	uint64_t size;
+
+	unsigned long items;
+	int err;
+};
+
+struct extent {
+	struct flist_head list;
+	uint64_t offset;
+};
+
+struct chunk {
+	struct rb_node rb_node;
+	struct flist_head extent_list;
+	uint64_t count;
+	uint32_t hash[MD5_HASH_WORDS];
+};
+
+struct item {
+	uint64_t offset;
+	uint32_t hash[MD5_HASH_WORDS];
+};
+
+static struct rb_root rb_root;
+static struct fio_mutex *rb_lock;
+
+static unsigned int blocksize = 4096;
+static unsigned int num_threads;
+static unsigned int chunk_size = 1048576;
+static unsigned int dump_output;
+static unsigned int odirect;
+static unsigned int collision_check;
+static unsigned int print_progress = 1;
+
+static uint64_t total_size;
+static uint64_t cur_offset;
+static struct fio_mutex *size_lock;
+
+static int dev_fd;
+
+static uint64_t get_size(int fd, struct stat *sb)
+{
+	uint64_t ret;
+
+	if (S_ISBLK(sb->st_mode)) {
+		if (ioctl(fd, BLKGETSIZE64, &ret) < 0) {
+			perror("ioctl");
+			return 0;
+		}
+	} else
+		ret = sb->st_size;
+
+	return (ret & ~((uint64_t)blocksize - 1));
+}
+
+static int get_work(uint64_t *offset, uint64_t *size)
+{
+	uint64_t this_chunk;
+	int ret = 1;
+
+	fio_mutex_down(size_lock);
+
+	if (cur_offset < total_size) {
+		*offset = cur_offset;
+		this_chunk = min((uint64_t)chunk_size, total_size - cur_offset);
+		*size = this_chunk;
+		cur_offset += this_chunk;
+		ret = 0;
+	}
+
+	fio_mutex_up(size_lock);
+	return ret;
+}
+
+static int read_block(int fd, void *buf, off_t offset)
+{
+	ssize_t ret;
+
+	ret = pread(fd, buf, blocksize, offset);
+	if (ret < 0) {
+		perror("pread");
+		return 1;
+	} else if (!ret)
+		return 1;
+	else if (ret != blocksize) {
+		log_err("dedupe: short read on block\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+static void add_item(struct chunk *c, struct item *i)
+{
+	struct extent *e;
+
+	e = malloc(sizeof(*e));
+	e->offset = i->offset;
+	flist_add_tail(&e->list, &c->extent_list);
+	c->count++;
+}
+
+static int col_check(struct chunk *c, struct item *i)
+{
+	struct extent *e;
+	char *cbuf, *ibuf;
+	int ret = 1;
+
+	cbuf = fio_memalign(blocksize, blocksize);
+	ibuf = fio_memalign(blocksize, blocksize);
+
+	e = flist_entry(c->extent_list.next, struct extent, list);
+	if (read_block(dev_fd, cbuf, e->offset))
+		goto out;
+
+	if (read_block(dev_fd, ibuf, i->offset))
+		goto out;
+
+	ret = memcmp(ibuf, cbuf, blocksize);
+out:
+	fio_memfree(cbuf, blocksize);
+	fio_memfree(ibuf, blocksize);
+	return ret;
+}
+
+static void insert_chunk(struct item *i)
+{
+	struct rb_node **p, *parent;
+	struct chunk *c;
+	int diff;
+
+	p = &rb_root.rb_node;
+	parent = NULL;
+	while (*p) {
+		parent = *p;
+
+		c = rb_entry(parent, struct chunk, rb_node);
+		diff = memcmp(i->hash, c->hash, sizeof(i->hash));
+		if (diff < 0)
+			p = &(*p)->rb_left;
+		else if (diff > 0)
+			p = &(*p)->rb_right;
+		else {
+			int ret;
+
+			if (!collision_check)
+				goto add;
+
+			fio_mutex_up(rb_lock);
+			ret = col_check(c, i);
+			fio_mutex_down(rb_lock);
+
+			if (!ret)
+				goto add;
+
+			p = &(*p)->rb_right;
+		}
+	}
+
+	c = malloc(sizeof(*c));
+	RB_CLEAR_NODE(&c->rb_node);
+	INIT_FLIST_HEAD(&c->extent_list);
+	c->count = 0;
+	memcpy(c->hash, i->hash, sizeof(i->hash));
+	rb_link_node(&c->rb_node, parent, p);
+	rb_insert_color(&c->rb_node, &rb_root);
+add:
+	add_item(c, i);
+}
+
+static void insert_chunks(struct item *items, unsigned int nitems)
+{
+	int i;
+
+	fio_mutex_down(rb_lock);
+
+	for (i = 0; i < nitems; i++)
+		insert_chunk(&items[i]);
+
+	fio_mutex_up(rb_lock);
+}
+
+static void crc_buf(void *buf, uint32_t *hash)
+{
+	struct fio_md5_ctx ctx = { .hash = hash };
+
+	fio_md5_init(&ctx);
+	fio_md5_update(&ctx, buf, blocksize);
+	fio_md5_final(&ctx);
+}
+
+static int do_work(struct worker_thread *thread, void *buf)
+{
+	unsigned int nblocks, i;
+	off_t offset;
+	int err = 0, nitems = 0;
+	struct item *items;
+
+	nblocks = thread->size / blocksize;
+	offset = thread->cur_offset;
+	items = malloc(sizeof(*items) * nblocks);
+
+	for (i = 0; i < nblocks; i++) {
+		if (read_block(thread->fd, buf, offset))
+			break;
+		items[i].offset = offset;
+		crc_buf(buf, items[i].hash);
+		offset += blocksize;
+		nitems++;
+	}
+
+	insert_chunks(items, nitems);
+	thread->items += nitems;
+	free(items);
+	return err;
+}
+
+static void *thread_fn(void *data)
+{
+	struct worker_thread *thread = data;
+	void *buf;
+
+	buf = fio_memalign(blocksize, blocksize);
+
+	do {
+		if (get_work(&thread->cur_offset, &thread->size)) {
+			thread->err = 1;
+			break;
+		}
+		if (do_work(thread, buf)) {
+			thread->err = 1;
+			break;
+		}
+	} while (1);
+
+	thread->done = 1;
+	fio_memfree(buf, blocksize);
+	return NULL;
+}
+
+static int __dedupe_check(int fd, uint64_t dev_size)
+{
+	struct worker_thread *threads;
+	unsigned long nitems, total_items;
+	int i, err = 0;
+
+	total_size = dev_size;
+	total_items = dev_size / blocksize;
+	cur_offset = 0;
+	size_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+
+	threads = malloc(num_threads * sizeof(struct worker_thread));
+	for (i = 0; i < num_threads; i++) {
+		threads[i].fd = fd;
+		threads[i].items = 0;
+		threads[i].err = 0;
+		threads[i].done = 0;
+
+		err = pthread_create(&threads[i].thread, NULL, thread_fn, &threads[i]);
+		if (err) {
+			log_err("fio: thread startup failed\n");
+			break;
+		}
+	}
+
+	while (print_progress) {
+		float perc;
+		int some_done;
+
+		nitems = 0;
+		for (i = 0; i < num_threads; i++) {
+			nitems += threads[i].items;
+			some_done = threads[i].done;
+			if (some_done)
+				break;
+		}
+
+		if (some_done)
+			break;
+
+		perc = (float) nitems / (float) total_items;
+		perc *= 100.0;
+		printf("%3.2f%% done\r", perc);
+		fflush(stdout);
+		usleep(200000);
+	};
+
+	nitems = 0;
+	for (i = 0; i < num_threads; i++) {
+		void *ret;
+		pthread_join(threads[i].thread, &ret);
+		nitems += threads[i].items;
+	}
+
+	printf("Threads(%u): %lu items processed\n", num_threads, nitems);
+
+	fio_mutex_remove(size_lock);
+	return err;
+}
+
+static int dedupe_check(const char *filename)
+{
+	uint64_t dev_size;
+	struct stat sb;
+	int flags;
+
+	flags = O_RDONLY;
+	if (odirect)
+		flags |= O_DIRECT;
+
+	dev_fd = open(filename, flags);
+	if (dev_fd == -1) {
+		perror("open");
+		return 1;
+	}
+
+	if (fstat(dev_fd, &sb) < 0) {
+		perror("fstat");
+		close(dev_fd);
+		return 1;
+	}
+
+	dev_size = get_size(dev_fd, &sb);
+	if (!dev_size) {
+		close(dev_fd);
+		return 1;
+	}
+
+	printf("Will check <%s>, size <%llu>\n", filename, (unsigned long long) dev_size);
+
+	return __dedupe_check(dev_fd, dev_size);
+}
+
+static void show_chunk(struct chunk *c)
+{
+	struct flist_head *n;
+	struct extent *e;
+
+	printf("c hash %8x %8x %8x %8x, count %lu\n", c->hash[0], c->hash[1], c->hash[2], c->hash[3], (unsigned long) c->count);
+	flist_for_each(n, &c->extent_list) {
+		e = flist_entry(n, struct extent, list);
+		printf("\toffset %llu\n", (unsigned long long) e->offset);
+	}
+}
+
+static void iter_rb_tree(void)
+{
+	struct rb_node *n;
+	uint64_t nchunks;
+	uint64_t nextents;
+	double perc;
+
+	nchunks = nextents = 0;
+
+	n = rb_first(&rb_root);
+	if (!n)
+		return;
+
+	do {
+		struct chunk *c;
+
+		c = rb_entry(n, struct chunk, rb_node);
+		nchunks++;
+		nextents += c->count;
+
+		if (dump_output)
+			show_chunk(c);
+
+	} while ((n = rb_next(n)) != NULL);
+
+	printf("Extents=%lu, Unique extents=%lu\n", (unsigned long) nextents, (unsigned long) nchunks);
+	printf("De-dupe factor: %3.2f\n", (double) nextents / (double) nchunks);
+
+	perc = 1.00 - ((double) nchunks / (double) nextents);
+	perc *= 100.0;
+	printf("Fio setting: dedupe_percentage=%u\n", (int) (perc + 0.50));
+}
+
+static int usage(char *argv[])
+{
+	log_err("Check for dedupable blocks on a device/file\n\n");
+	log_err("%s: [options] <device or file>\n", argv[0]);
+	log_err("\t-b\tChunk size to use\n");
+	log_err("\t-t\tNumber of threads to use\n");
+	log_err("\t-d\tFull extent/chunk debug output\n");
+	log_err("\t-o\tUse O_DIRECT\n");
+	log_err("\t-c\tFull collision check\n");
+	log_err("\t-p\tPrint progress indicator\n");
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	int c, ret;
+
+	while ((c = getopt(argc, argv, "b:t:d:o:c:p:")) != -1) {
+		switch (c) {
+		case 'b':
+			blocksize = atoi(optarg);
+			break;
+		case 't':
+			num_threads = atoi(optarg);
+			break;
+		case 'd':
+			dump_output = atoi(optarg);
+			break;
+		case 'o':
+			odirect = atoi(optarg);
+			break;
+		case 'c':
+			collision_check = atoi(optarg);
+			break;
+		case 'p':
+			print_progress = atoi(optarg);
+			break;
+		case '?':
+		default:
+			return usage(argv);
+		}
+	}
+
+	if (!num_threads)
+		num_threads = cpus_online();
+
+	if (argc == optind)
+		return usage(argv);
+
+	sinit();
+
+	rb_root = RB_ROOT;
+	rb_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+
+	ret = dedupe_check(argv[optind]);
+
+	iter_rb_tree();
+
+	scleanup();
+	return ret;
+}
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index d371087..481f37e 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -65,11 +65,11 @@ int main(int argc, char *argv[])
 	printf("LFSR specs\n");
 	printf("==========================\n");
 	printf("Size is         %u\n", 64 - __builtin_clzl(fl->cached_bit));
-	printf("Max val is      %lu\n", fl->max_val);
-	printf("XOR-mask is     0x%lX\n", fl->xormask);
-	printf("Seed is         %lu\n", fl->last_val);
+	printf("Max val is      %lu\n", (unsigned long) fl->max_val);
+	printf("XOR-mask is     0x%lX\n", (unsigned long) fl->xormask);
+	printf("Seed is         %lu\n", (unsigned long) fl->last_val);
 	printf("Spin is         %u\n", fl->spin);
-	printf("Cycle length is %lu\n", fl->cycle_length);
+	printf("Cycle length is %lu\n", (unsigned long) fl->cycle_length);
 
 	/* Create verification table */
 	if (verify) {
@@ -102,7 +102,8 @@ int main(int argc, char *argv[])
 		for (i = 0; i < numbers; i++) {
 			if (*(uint8_t *)(v + i) != 1) {
 				fprintf(stderr, "failed (%lu = %d).\n",
-						i, *(uint8_t *)(v + i));
+						(unsigned long) i,
+						*(uint8_t *)(v + i));
 				r = 1;
 				break;
 			}
