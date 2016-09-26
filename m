Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35316 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034085AbcIZMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Sep 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1boUZn-0000eM-Jh
        for fio@vger.kernel.org; Mon, 26 Sep 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160926120001.C0ACE2C00B3@kernel.dk>
Date: Mon, 26 Sep 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0a301e93062df3735f9bb87c445e18d98a4b6efb:

  bloom: add string version (2016-09-23 11:57:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 63a26e05622b0ced2cc685f545f493e794ccc325:

  filehash: move to separate allocation (2016-09-26 01:40:52 -0600)

----------------------------------------------------------------
Jens Axboe (8):
      bloom: allow to pass in whether to set bits for strings
      smalloc: fixup --alloc-size
      init: re-call sinit() if we change the smallc pool size
      file: add bloom filter to avoid quadratic lookup behavior
      bloom: don't enforce minimum entry count
      smalloc: OOM fixups
      fio: bump max jobs to 4k
      filehash: move to separate allocation

 README      |  4 ++--
 diskutil.c  |  4 +---
 filehash.c  | 21 ++++++++++++++++++---
 filehash.h  |  5 +++--
 filesetup.c | 21 +++++++++------------
 fio.h       |  2 +-
 flow.c      |  1 -
 init.c      |  8 ++++----
 lib/bloom.c |  8 +++-----
 lib/bloom.h |  2 +-
 os/os.h     |  2 +-
 server.c    | 12 +++++++-----
 smalloc.c   | 24 ++++++++++++++++--------
 workqueue.c |  2 ++
 14 files changed, 68 insertions(+), 48 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index 5fa37f3..a69a578 100644
--- a/README
+++ b/README
@@ -169,7 +169,7 @@ $ fio
 	--status-interval=t	Force full status dump every 't' period passed
 	--section=name		Only run specified section in job file.
 				Multiple sections can be specified.
-	--alloc-size=kb		Set smalloc pool to this size in kb (def 1024)
+	--alloc-size=kb		Set smalloc pool to this size in kb (def 16384)
 	--warnings-fatal	Fio parser warnings are fatal
 	--max-jobs		Maximum number of threads/processes to support
 	--server=args		Start backend server. See Client/Server section.
@@ -233,7 +233,7 @@ sections.  The reserved 'global' section is always parsed and used.
 The --alloc-size switch allows one to use a larger pool size for smalloc.
 If running large jobs with randommap enabled, fio can run out of memory.
 Smalloc is an internal allocator for shared structures from a fixed size
-memory pool. The pool size defaults to 1024k and can grow to 128 pools.
+memory pool. The pool size defaults to 16M and can grow to 8 pools.
 
 NOTE: While running .fio_smalloc.* backing store files are visible in /tmp.
 
diff --git a/diskutil.c b/diskutil.c
index 0f7a642..27ddb46 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -292,10 +292,8 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 	dprint(FD_DISKUTIL, "add maj/min %d/%d: %s\n", majdev, mindev, path);
 
 	du = smalloc(sizeof(*du));
-	if (!du) {
-		log_err("fio: smalloc() pool exhausted\n");
+	if (!du)
 		return NULL;
-	}
 
 	memset(du, 0, sizeof(*du));
 	INIT_FLIST_HEAD(&du->list);
diff --git a/filehash.c b/filehash.c
index 0d61f54..edeeab4 100644
--- a/filehash.c
+++ b/filehash.c
@@ -5,14 +5,19 @@
 #include "flist.h"
 #include "hash.h"
 #include "filehash.h"
+#include "smalloc.h"
+#include "lib/bloom.h"
 
 #define HASH_BUCKETS	512
 #define HASH_MASK	(HASH_BUCKETS - 1)
 
-unsigned int file_hash_size = HASH_BUCKETS * sizeof(struct flist_head);
+#define BLOOM_SIZE	16*1024*1024
+
+static unsigned int file_hash_size = HASH_BUCKETS * sizeof(struct flist_head);
 
 static struct flist_head *file_hash;
 static struct fio_mutex *hash_lock;
+static struct bloom *file_bloom;
 
 static unsigned short hash(const char *name)
 {
@@ -95,6 +100,11 @@ struct fio_file *add_file_hash(struct fio_file *f)
 	return alias;
 }
 
+bool file_bloom_exists(const char *fname, bool set)
+{
+	return bloom_string(file_bloom, fname, strlen(fname), set);
+}
+
 void file_hash_exit(void)
 {
 	unsigned int i, has_entries = 0;
@@ -107,18 +117,23 @@ void file_hash_exit(void)
 	if (has_entries)
 		log_err("fio: file hash not empty on exit\n");
 
+	sfree(file_hash);
 	file_hash = NULL;
 	fio_mutex_remove(hash_lock);
 	hash_lock = NULL;
+	bloom_free(file_bloom);
+	file_bloom = NULL;
 }
 
-void file_hash_init(void *ptr)
+void file_hash_init(void)
 {
 	unsigned int i;
 
-	file_hash = ptr;
+	file_hash = smalloc(file_hash_size);
+
 	for (i = 0; i < HASH_BUCKETS; i++)
 		INIT_FLIST_HEAD(&file_hash[i]);
 
 	hash_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+	file_bloom = bloom_new(BLOOM_SIZE);
 }
diff --git a/filehash.h b/filehash.h
index f316b20..5fecc3b 100644
--- a/filehash.h
+++ b/filehash.h
@@ -1,14 +1,15 @@
 #ifndef FIO_FILE_HASH_H
 #define FIO_FILE_HASH_H
 
-extern unsigned int file_hash_size;
+#include "lib/types.h"
 
-extern void file_hash_init(void *);
+extern void file_hash_init(void);
 extern void file_hash_exit(void);
 extern struct fio_file *lookup_file_hash(const char *);
 extern struct fio_file *add_file_hash(struct fio_file *);
 extern void remove_file_hash(struct fio_file *);
 extern void fio_file_hash_lock(void);
 extern void fio_file_hash_unlock(void);
+extern bool file_bloom_exists(const char *, bool);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index c6ef3bf..a3bbbb2 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1242,12 +1242,14 @@ static void get_file_type(struct fio_file *f)
 	}
 }
 
-static bool __is_already_allocated(const char *fname)
+static bool __is_already_allocated(const char *fname, bool set)
 {
 	struct flist_head *entry;
+	bool ret;
 
-	if (flist_empty(&filename_list))
-		return false;
+	ret = file_bloom_exists(fname, set);
+	if (!ret)
+		return ret;
 
 	flist_for_each(entry, &filename_list) {
 		struct file_name *fn;
@@ -1266,7 +1268,7 @@ static bool is_already_allocated(const char *fname)
 	bool ret;
 
 	fio_file_hash_lock();
-	ret = __is_already_allocated(fname);
+	ret = __is_already_allocated(fname, false);
 	fio_file_hash_unlock();
 
 	return ret;
@@ -1280,7 +1282,7 @@ static void set_already_allocated(const char *fname)
 	fn->filename = strdup(fname);
 
 	fio_file_hash_lock();
-	if (!__is_already_allocated(fname)) {
+	if (!__is_already_allocated(fname, true)) {
 		flist_add_tail(&fn->list, &filename_list);
 		fn = NULL;
 	}
@@ -1317,7 +1319,6 @@ static struct fio_file *alloc_new_file(struct thread_data *td)
 
 	f = smalloc(sizeof(*f));
 	if (!f) {
-		log_err("fio: smalloc OOM\n");
 		assert(0);
 		return NULL;
 	}
@@ -1400,10 +1401,8 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 		f->real_file_size = -1ULL;
 
 	f->file_name = smalloc_strdup(file_name);
-	if (!f->file_name) {
-		log_err("fio: smalloc OOM\n");
+	if (!f->file_name)
 		assert(0);
-	}
 
 	get_file_type(f);
 
@@ -1606,10 +1605,8 @@ void dup_files(struct thread_data *td, struct thread_data *org)
 
 		if (f->file_name) {
 			__f->file_name = smalloc_strdup(f->file_name);
-			if (!__f->file_name) {
-				log_err("fio: smalloc OOM\n");
+			if (!__f->file_name)
 				assert(0);
-			}
 
 			__f->filetype = f->filetype;
 		}
diff --git a/fio.h b/fio.h
index df4fbb1..080842a 100644
--- a/fio.h
+++ b/fio.h
@@ -476,7 +476,7 @@ static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 	assert(!(io_u->ddir == DDIR_WRITE && !td_write(td)));
 }
 
-#define REAL_MAX_JOBS		2048
+#define REAL_MAX_JOBS		4096
 
 static inline int should_fsync(struct thread_data *td)
 {
diff --git a/flow.c b/flow.c
index e0ac135..42b6dd7 100644
--- a/flow.c
+++ b/flow.c
@@ -58,7 +58,6 @@ static struct fio_flow *flow_get(unsigned int id)
 	if (!flow) {
 		flow = smalloc(sizeof(*flow));
 		if (!flow) {
-			log_err("fio: smalloc pool exhausted\n");
 			fio_mutex_up(flow_lock);
 			return NULL;
 		}
diff --git a/init.c b/init.c
index 6b6e386..5151ff1 100644
--- a/init.c
+++ b/init.c
@@ -334,7 +334,6 @@ static int setup_thread_area(void)
 	do {
 		size_t size = max_jobs * sizeof(struct thread_data);
 
-		size += file_hash_size;
 		size += sizeof(unsigned int);
 
 #ifndef CONFIG_NO_SHM
@@ -366,11 +365,10 @@ static int setup_thread_area(void)
 #endif
 
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
-	hash = (void *) threads + max_jobs * sizeof(struct thread_data);
-	fio_debug_jobp = (void *) hash + file_hash_size;
+	fio_debug_jobp = (void *) threads + max_jobs * sizeof(struct thread_data);
 	*fio_debug_jobp = -1;
-	file_hash_init(hash);
 
+	file_hash_init();
 	flow_init();
 
 	return 0;
@@ -2308,6 +2306,8 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		switch (c) {
 		case 'a':
 			smalloc_pool_size = atoi(optarg);
+			smalloc_pool_size <<= 10;
+			sinit();
 			break;
 		case 't':
 			if (check_str_time(optarg, &def_timeout, 1)) {
diff --git a/lib/bloom.c b/lib/bloom.c
index c2e6c11..fa38db9 100644
--- a/lib/bloom.c
+++ b/lib/bloom.c
@@ -60,8 +60,6 @@ static struct bloom_hash hashes[] = {
 
 #define N_HASHES	5
 
-#define MIN_ENTRIES	1073741824UL
-
 struct bloom *bloom_new(uint64_t entries)
 {
 	struct bloom *b;
@@ -72,7 +70,6 @@ struct bloom *bloom_new(uint64_t entries)
 	b = malloc(sizeof(*b));
 	b->nentries = entries;
 	no_uints = (entries + BITS_PER_INDEX - 1) / BITS_PER_INDEX;
-	no_uints = max((unsigned long) no_uints, MIN_ENTRIES);
 	b->map = calloc(no_uints, sizeof(uint32_t));
 	if (!b->map) {
 		free(b);
@@ -118,7 +115,8 @@ bool bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords)
 	return __bloom_check(b, data, nwords * sizeof(uint32_t), true);
 }
 
-bool bloom_set_string(struct bloom *b, const char *data, unsigned int len)
+bool bloom_string(struct bloom *b, const char *data, unsigned int len,
+		  bool set)
 {
-	return __bloom_check(b, data, len, true);
+	return __bloom_check(b, data, len, set);
 }
diff --git a/lib/bloom.h b/lib/bloom.h
index d40d9f6..141ead9 100644
--- a/lib/bloom.h
+++ b/lib/bloom.h
@@ -9,6 +9,6 @@ struct bloom;
 struct bloom *bloom_new(uint64_t entries);
 void bloom_free(struct bloom *b);
 bool bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords);
-bool bloom_set_string(struct bloom *b, const char *data, unsigned int len);
+bool bloom_string(struct bloom *b, const char *data, unsigned int len, bool);
 
 #endif
diff --git a/os/os.h b/os/os.h
index 4f267c2..16bca68 100644
--- a/os/os.h
+++ b/os/os.h
@@ -171,7 +171,7 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
 #ifndef FIO_MAX_JOBS
-#define FIO_MAX_JOBS		2048
+#define FIO_MAX_JOBS		4096
 #endif
 
 #ifndef CONFIG_SOCKLEN_T
diff --git a/server.c b/server.c
index 3862699..091c161 100644
--- a/server.c
+++ b/server.c
@@ -578,8 +578,12 @@ static int fio_net_queue_cmd(uint16_t opcode, void *buf, off_t size,
 	struct sk_entry *entry;
 
 	entry = fio_net_prep_cmd(opcode, buf, size, tagptr, flags);
-	fio_net_queue_entry(entry);
-	return 0;
+	if (entry) {
+		fio_net_queue_entry(entry);
+		return 0;
+	}
+
+	return 1;
 }
 
 static int fio_net_send_simple_stack_cmd(int sk, uint16_t opcode, uint64_t tag)
@@ -1999,10 +2003,8 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	dprint(FD_NET, "server: request verify state\n");
 
 	rep = smalloc(sizeof(*rep));
-	if (!rep) {
-		log_err("fio: smalloc pool too small\n");
+	if (!rep)
 		return ENOMEM;
-	}
 
 	__fio_mutex_init(&rep->lock, FIO_MUTEX_LOCKED);
 	rep->data = NULL;
diff --git a/smalloc.c b/smalloc.c
index 6f647c0..d038ac6 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -26,7 +26,9 @@
 #define SMALLOC_BPL	(SMALLOC_BPB * SMALLOC_BPI)
 
 #define INITIAL_SIZE	16*1024*1024	/* new pool size */
-#define MAX_POOLS	8		/* maximum number of pools to setup */
+#define INITIAL_POOLS	8		/* maximum number of pools to setup */
+
+#define MAX_POOLS	16
 
 #define SMALLOC_PRE_RED		0xdeadbeefU
 #define SMALLOC_POST_RED	0x5aa55aa5U
@@ -149,12 +151,15 @@ static int find_next_zero(int word, int start)
 	return ffz(word) + start;
 }
 
-static int add_pool(struct pool *pool, unsigned int alloc_size)
+static bool add_pool(struct pool *pool, unsigned int alloc_size)
 {
 	int bitmap_blocks;
 	int mmap_flags;
 	void *ptr;
 
+	if (nr_pools == MAX_POOLS)
+		return false;
+
 #ifdef SMALLOC_REDZONE
 	alloc_size += sizeof(unsigned int);
 #endif
@@ -191,21 +196,22 @@ static int add_pool(struct pool *pool, unsigned int alloc_size)
 		goto out_fail;
 
 	nr_pools++;
-	return 0;
+	return true;
 out_fail:
 	log_err("smalloc: failed adding pool\n");
 	if (pool->map)
 		munmap(pool->map, pool->mmap_size);
-	return 1;
+	return false;
 }
 
 void sinit(void)
 {
-	int i, ret;
+	bool ret;
+	int i;
 
-	for (i = 0; i < MAX_POOLS; i++) {
-		ret = add_pool(&mp[i], smalloc_pool_size);
-		if (ret)
+	for (i = 0; i < INITIAL_POOLS; i++) {
+		ret = add_pool(&mp[nr_pools], smalloc_pool_size);
+		if (!ret)
 			break;
 	}
 
@@ -444,6 +450,8 @@ void *smalloc(size_t size)
 		break;
 	} while (1);
 
+	log_err("smalloc: OOM. Consider using --alloc-size to increase the "
+		"shared memory available.\n");
 	return NULL;
 }
 
diff --git a/workqueue.c b/workqueue.c
index 013087e..1131400 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -323,6 +323,8 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 		goto err;
 
 	wq->workers = smalloc(wq->max_workers * sizeof(struct submit_worker));
+	if (!wq->workers)
+		goto err;
 
 	for (i = 0; i < wq->max_workers; i++)
 		if (start_worker(wq, i, sk_out))
