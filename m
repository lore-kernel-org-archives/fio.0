Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbbANNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Jan 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YBNYL-00083E-9m
	for fio@vger.kernel.org; Wed, 14 Jan 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150114130003.67BD940153@lyth.info>
Date: Wed, 14 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 36bb0880c7f7f48abb86e3a16d3168343dda9b75:

  Fix disk utils being updated too often (2015-01-07 15:04:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f9a33cc03d70ff34b740629cbde4cef22a120338:

  client: take better care to return failure from fio_handle_clients() (2015-01-13 21:47:43 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      filelock: fix segfault on some use cases of log file locking
      axmap: random maps are private, don't get them from smalloc
      smalloc: limit to 1 pool, and bump size to 16MB
      client: take better care to return failure from fio_handle_clients()

Yoshinori Sato (1):
      mmap backend invalidate fix

 client.c       |    8 ++-
 engines/mmap.c |   25 ++++----
 filelock.c     |  174 ++++++++++++++++++++++++++++++++++++++++++--------------
 lib/axmap.c    |   17 +++---
 smalloc.c      |    4 +-
 5 files changed, 158 insertions(+), 70 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 74c9c76..760ec85 100644
--- a/client.c
+++ b/client.c
@@ -62,6 +62,8 @@ static struct json_object *root = NULL;
 static struct json_array *clients_array = NULL;
 static struct json_array *du_array = NULL;
 
+static int error_clients;
+
 #define FIO_CLIENT_HASH_BITS	7
 #define FIO_CLIENT_HASH_SZ	(1 << FIO_CLIENT_HASH_BITS)
 #define FIO_CLIENT_HASH_MASK	(FIO_CLIENT_HASH_SZ - 1)
@@ -176,6 +178,9 @@ void fio_put_client(struct fio_client *client)
 	if (!client->did_stat)
 		sum_stat_clients--;
 
+	if (client->error)
+		error_clients++;
+
 	free(client);
 }
 
@@ -1616,6 +1621,7 @@ static int fio_check_clients_timed_out(void)
 		else
 			log_err("fio: client %s timed out\n", client->hostname);
 
+		client->error = ETIMEDOUT;
 		remove_client(client);
 		ret = 1;
 	}
@@ -1709,5 +1715,5 @@ int fio_handle_clients(struct client_ops *ops)
 	fio_client_json_fini();
 
 	free(pfds);
-	return retval;
+	return retval || error_clients;
 }
diff --git a/engines/mmap.c b/engines/mmap.c
index 8bcd42c..69add78 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -62,6 +62,16 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 			goto err;
 		}
 	}
+	if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_DONTNEED) < 0) {
+		td_verror(td, errno, "madvise");
+		goto err;
+	}
+
+#ifdef FIO_MADV_FREE
+	if (f->filetype == FIO_TYPE_BD)
+		(void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, FIO_MADV_FREE);
+#endif
+
 
 err:
 	if (td->error && fmd->mmap_ptr)
@@ -252,20 +262,6 @@ static int fio_mmapio_close_file(struct thread_data *td, struct fio_file *f)
 	return generic_close_file(td, f);
 }
 
-static int fio_mmapio_invalidate(struct thread_data *td, struct fio_file *f)
-{
-	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
-	int ret;
-
-	ret = posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, POSIX_MADV_DONTNEED);
-#ifdef FIO_MADV_FREE
-	if (f->filetype == FIO_TYPE_BD)
-		(void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, FIO_MADV_FREE);
-#endif
-
-	return ret;
-}
-
 static struct ioengine_ops ioengine = {
 	.name		= "mmap",
 	.version	= FIO_IOOPS_VERSION,
@@ -274,7 +270,6 @@ static struct ioengine_ops ioengine = {
 	.queue		= fio_mmapio_queue,
 	.open_file	= fio_mmapio_open_file,
 	.close_file	= fio_mmapio_close_file,
-	.invalidate	= fio_mmapio_invalidate,
 	.get_file_size	= generic_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_NOEXTEND,
 };
diff --git a/filelock.c b/filelock.c
index 18e8875..17b5a85 100644
--- a/filelock.c
+++ b/filelock.c
@@ -5,6 +5,7 @@
  */
 #include <inttypes.h>
 #include <string.h>
+#include <unistd.h>
 #include <assert.h>
 
 #include "flist.h"
@@ -20,36 +21,99 @@ struct fio_filelock {
 	struct flist_head list;
 	unsigned int references;
 };
+
+#define MAX_FILELOCKS	128
 	
-static struct flist_head *filelock_list;
-static struct fio_mutex *filelock_lock;
+static struct filelock_data {
+	struct flist_head list;
+	struct fio_mutex lock;
+
+	struct flist_head free_list;
+	struct fio_filelock ffs[MAX_FILELOCKS];
+} *fld;
+
+static void put_filelock(struct fio_filelock *ff)
+{
+	flist_add(&ff->list, &fld->free_list);
+}
+
+static struct fio_filelock *__get_filelock(void)
+{
+	struct fio_filelock *ff;
+
+	if (flist_empty(&fld->free_list))
+		return NULL;
+
+	ff = flist_first_entry(&fld->free_list, struct fio_filelock, list);
+	flist_del_init(&ff->list);
+	return ff;
+}
+
+static struct fio_filelock *get_filelock(int trylock, int *retry)
+{
+	struct fio_filelock *ff;
+
+	do {
+		ff = __get_filelock();
+		if (ff || trylock)
+			break;
+
+		fio_mutex_up(&fld->lock);
+		usleep(1000);
+		fio_mutex_down(&fld->lock);
+		*retry = 1;
+	} while (1);
+
+	return ff;
+}
 
 int fio_filelock_init(void)
 {
-	filelock_list = smalloc(sizeof(*filelock_list));
-	if (!filelock_list)
-		return 1;
+	int i;
 
-	INIT_FLIST_HEAD(filelock_list);
-	filelock_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
-	if (!filelock_lock) {
-		sfree(filelock_list);
+	fld = smalloc(sizeof(*fld));
+	if (!fld)
 		return 1;
+
+	INIT_FLIST_HEAD(&fld->list);
+	INIT_FLIST_HEAD(&fld->free_list);
+
+	if (__fio_mutex_init(&fld->lock, FIO_MUTEX_UNLOCKED))
+		goto err;
+
+	for (i = 0; i < MAX_FILELOCKS; i++) {
+		struct fio_filelock *ff = &fld->ffs[i];
+
+		if (__fio_mutex_init(&ff->lock, FIO_MUTEX_UNLOCKED))
+			goto err;
+		flist_add_tail(&ff->list, &fld->free_list);
 	}
 
 	return 0;
+err:
+	fio_filelock_exit();
+	return 1;
 }
 
 void fio_filelock_exit(void)
 {
-	if (!filelock_list)
+	if (!fld)
 		return;
 
-	assert(flist_empty(filelock_list));
-	sfree(filelock_list);
-	filelock_list = NULL;
-	fio_mutex_remove(filelock_lock);
-	filelock_lock = NULL;
+	assert(flist_empty(&fld->list));
+	fio_mutex_remove(&fld->lock);
+
+	while (!flist_empty(&fld->free_list)) {
+		struct fio_filelock *ff;
+
+		ff = flist_first_entry(&fld->free_list, struct fio_filelock, list);
+
+		flist_del_init(&ff->list);
+		fio_mutex_remove(&ff->lock);
+	}
+
+	sfree(fld);
+	fld = NULL;
 }
 
 static struct fio_filelock *fio_hash_find(uint32_t hash)
@@ -57,7 +121,7 @@ static struct fio_filelock *fio_hash_find(uint32_t hash)
 	struct flist_head *entry;
 	struct fio_filelock *ff;
 
-	flist_for_each(entry, filelock_list) {
+	flist_for_each(entry, &fld->list) {
 		ff = flist_entry(entry, struct fio_filelock, list);
 		if (ff->hash == hash)
 			return ff;
@@ -66,38 +130,68 @@ static struct fio_filelock *fio_hash_find(uint32_t hash)
 	return NULL;
 }
 
-static struct fio_filelock *fio_hash_get(uint32_t hash)
+static struct fio_filelock *fio_hash_get(uint32_t hash, int trylock)
 {
 	struct fio_filelock *ff;
 
 	ff = fio_hash_find(hash);
 	if (!ff) {
-		ff = smalloc(sizeof(*ff));
+		int retry = 0;
+
+		ff = get_filelock(trylock, &retry);
+		if (!ff)
+			return NULL;
+
+		/*
+		 * If we dropped the main lock, re-lookup the hash in case
+		 * someone else added it meanwhile. If it's now there,
+		 * just return that.
+		 */
+		if (retry) {
+			struct fio_filelock *__ff;
+
+			__ff = fio_hash_find(hash);
+			if (__ff) {
+				put_filelock(ff);
+				return __ff;
+			}
+		}
+
 		ff->hash = hash;
-		__fio_mutex_init(&ff->lock, FIO_MUTEX_UNLOCKED);
 		ff->references = 0;
-		flist_add(&ff->list, filelock_list);
+		flist_add(&ff->list, &fld->list);
 	}
 
 	return ff;
 }
 
-int fio_trylock_file(const char *fname)
+static int __fio_lock_file(const char *fname, int trylock)
 {
 	struct fio_filelock *ff;
 	uint32_t hash;
 
 	hash = jhash(fname, strlen(fname), 0);
 
-	fio_mutex_down(filelock_lock);
-	ff = fio_hash_get(hash);
-	ff->references++;
-	fio_mutex_up(filelock_lock);
+	fio_mutex_down(&fld->lock);
+	ff = fio_hash_get(hash, trylock);
+	if (ff)
+		ff->references++;
+	fio_mutex_up(&fld->lock);
+
+	if (!ff) {
+		assert(!trylock);
+		return 1;
+	}
+
+	if (!trylock) {
+		fio_mutex_down(&ff->lock);
+		return 0;
+	}
 
 	if (!fio_mutex_down_trylock(&ff->lock))
 		return 0;
 
-	fio_mutex_down(filelock_lock);
+	fio_mutex_down(&fld->lock);
 
 	/*
 	 * If we raced and the only reference to the lock is us, we can
@@ -108,7 +202,7 @@ int fio_trylock_file(const char *fname)
 		ff = NULL;
 	}
 
-	fio_mutex_up(filelock_lock);
+	fio_mutex_up(&fld->lock);
 
 	if (ff) {
 		fio_mutex_down(&ff->lock);
@@ -118,19 +212,14 @@ int fio_trylock_file(const char *fname)
 	return 1;
 }
 
-void fio_lock_file(const char *fname)
+int fio_trylock_file(const char *fname)
 {
-	struct fio_filelock *ff;
-	uint32_t hash;
-
-	hash = jhash(fname, strlen(fname), 0);
-
-	fio_mutex_down(filelock_lock);
-	ff = fio_hash_get(hash);
-	ff->references++;
-	fio_mutex_up(filelock_lock);
+	return __fio_lock_file(fname, 1);
+}
 
-	fio_mutex_down(&ff->lock);
+void fio_lock_file(const char *fname)
+{
+	__fio_lock_file(fname, 0);
 }
 
 void fio_unlock_file(const char *fname)
@@ -140,19 +229,18 @@ void fio_unlock_file(const char *fname)
 
 	hash = jhash(fname, strlen(fname), 0);
 
-	fio_mutex_down(filelock_lock);
+	fio_mutex_down(&fld->lock);
 
 	ff = fio_hash_find(hash);
 	if (ff) {
 		int refs = --ff->references;
 		fio_mutex_up(&ff->lock);
 		if (!refs) {
-			flist_del(&ff->list);
-			__fio_mutex_remove(&ff->lock);
-			sfree(ff);
+			flist_del_init(&ff->list);
+			put_filelock(ff);
 		}
 	} else
 		log_err("fio: file not found for unlocking\n");
 
-	fio_mutex_up(filelock_lock);
+	fio_mutex_up(&fld->lock);
 }
diff --git a/lib/axmap.c b/lib/axmap.c
index 68096d8..164300f 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -22,7 +22,6 @@
 
 #include "../arch/arch.h"
 #include "axmap.h"
-#include "../smalloc.h"
 #include "../minmax.h"
 
 #if BITS_PER_LONG == 64
@@ -80,10 +79,10 @@ void axmap_free(struct axmap *axmap)
 		return;
 
 	for (i = 0; i < axmap->nr_levels; i++)
-		sfree(axmap->levels[i].map);
+		free(axmap->levels[i].map);
 
-	sfree(axmap->levels);
-	sfree(axmap);
+	free(axmap->levels);
+	free(axmap);
 }
 
 struct axmap *axmap_new(unsigned long nr_bits)
@@ -91,7 +90,7 @@ struct axmap *axmap_new(unsigned long nr_bits)
 	struct axmap *axmap;
 	unsigned int i, levels;
 
-	axmap = smalloc(sizeof(*axmap));
+	axmap = malloc(sizeof(*axmap));
 	if (!axmap)
 		return NULL;
 
@@ -103,7 +102,7 @@ struct axmap *axmap_new(unsigned long nr_bits)
 	}
 
 	axmap->nr_levels = levels;
-	axmap->levels = smalloc(axmap->nr_levels * sizeof(struct axmap_level));
+	axmap->levels = malloc(axmap->nr_levels * sizeof(struct axmap_level));
 	axmap->nr_bits = nr_bits;
 
 	for (i = 0; i < axmap->nr_levels; i++) {
@@ -111,7 +110,7 @@ struct axmap *axmap_new(unsigned long nr_bits)
 
 		al->level = i;
 		al->map_size = (nr_bits + BLOCKS_PER_UNIT - 1) >> UNIT_SHIFT;
-		al->map = smalloc(al->map_size * sizeof(unsigned long));
+		al->map = malloc(al->map_size * sizeof(unsigned long));
 		if (!al->map)
 			goto err;
 
@@ -123,9 +122,9 @@ struct axmap *axmap_new(unsigned long nr_bits)
 err:
 	for (i = 0; i < axmap->nr_levels; i++)
 		if (axmap->levels[i].map)
-			sfree(axmap->levels[i].map);
+			free(axmap->levels[i].map);
 
-	sfree(axmap->levels);
+	free(axmap->levels);
 	return NULL;
 }
 
diff --git a/smalloc.c b/smalloc.c
index 1ba9353..67cb7cc 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -25,8 +25,8 @@
 #define SMALLOC_BPI	(sizeof(unsigned int) * 8)
 #define SMALLOC_BPL	(SMALLOC_BPB * SMALLOC_BPI)
 
-#define INITIAL_SIZE	8192*1024	/* new pool size */
-#define MAX_POOLS	128		/* maximum number of pools to setup */
+#define INITIAL_SIZE	16*1024*1024	/* new pool size */
+#define MAX_POOLS	1		/* maximum number of pools to setup */
 
 #define SMALLOC_PRE_RED		0xdeadbeefU
 #define SMALLOC_POST_RED	0x5aa55aa5U
