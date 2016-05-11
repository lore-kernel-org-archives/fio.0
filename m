Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbcEKMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 11 May 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1b0So7-0004GY-8H
	for fio@vger.kernel.org; Wed, 11 May 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160511120002.4895C2C00C4@kernel.dk>
Date: Wed, 11 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit df96a39edc86394bca0643e9aa2a8f4dfc76c7c9:

  Change default IO engine from sync to psync (2016-05-09 13:35:09 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5c8f0ba56837a0b848cbbbc5a8673589d099ded3:

  verify: unroll string copy (2016-05-10 19:50:00 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      engines/pmemblk: more cleanups
      ioengines: cleanup
      verify: increase state file name and log error on failure
      verify: escape '/' in state file name to '.'
      verify: only escape 'name', not prefix+name
      verify: unroll string copy

 engines/pmemblk.c | 165 ++++++++++++++++++++++++------------------------------
 ioengines.c       |  20 +++----
 verify-state.h    |  20 ++++++-
 verify.c          |   3 +-
 4 files changed, 102 insertions(+), 106 deletions(-)

---

Diff of recent changes:

diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index ab4b769..6d19864 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -75,52 +75,59 @@
 struct PMEMblkpool_s;
 typedef struct PMEMblkpool_s PMEMblkpool;
 
-PMEMblkpool *(*pmemblk_create) (const char *, size_t, size_t, mode_t) = NULL;
-PMEMblkpool *(*pmemblk_open) (const char *, size_t) = NULL;
-void (*pmemblk_close) (PMEMblkpool *) = NULL;
-size_t(*pmemblk_nblock) (PMEMblkpool *) = NULL;
-size_t(*pmemblk_bsize) (PMEMblkpool *) = NULL;
-int (*pmemblk_read) (PMEMblkpool *, void *, off_t) = NULL;
-int (*pmemblk_write) (PMEMblkpool *, const void *, off_t) = NULL;
+static PMEMblkpool *(*pmemblk_create) (const char *, size_t, size_t, mode_t);
+static PMEMblkpool *(*pmemblk_open) (const char *, size_t);
+static void (*pmemblk_close) (PMEMblkpool *);
+static size_t(*pmemblk_nblock) (PMEMblkpool *);
+static size_t(*pmemblk_bsize) (PMEMblkpool *);
+static int (*pmemblk_read) (PMEMblkpool *, void *, off_t);
+static int (*pmemblk_write) (PMEMblkpool *, const void *, off_t);
 
 int load_libpmemblk(const char *path)
 {
 	void *dl;
 
-	if (NULL == path)
+	if (!path)
 		path = "libpmemblk.so";
 
 	dl = dlopen(path, RTLD_NOW | RTLD_NODELETE);
-	if (NULL == dl)
+	if (!dl)
 		goto errorout;
 
-	if (NULL == (pmemblk_create = dlsym(dl, "pmemblk_create")))
+	pmemblk_create = dlsym(dl, "pmemblk_create");
+	if (!pmemblk_create)
 		goto errorout;
-	if (NULL == (pmemblk_open = dlsym(dl, "pmemblk_open")))
+	pmemblk_open = dlsym(dl, "pmemblk_open");
+	if (!pmemblk_open)
 		goto errorout;
-	if (NULL == (pmemblk_close = dlsym(dl, "pmemblk_close")))
+	pmemblk_close = dlsym(dl, "pmemblk_close");
+	if (!pmemblk_close)
 		goto errorout;
-	if (NULL == (pmemblk_nblock = dlsym(dl, "pmemblk_nblock")))
+	pmemblk_nblock = dlsym(dl, "pmemblk_nblock");
+	if (!pmemblk_nblock)
 		goto errorout;
-	if (NULL == (pmemblk_bsize = dlsym(dl, "pmemblk_bsize")))
+	pmemblk_bsize = dlsym(dl, "pmemblk_bsize");
+	if (!pmemblk_bsize)
 		goto errorout;
-	if (NULL == (pmemblk_read = dlsym(dl, "pmemblk_read")))
+	pmemblk_read = dlsym(dl, "pmemblk_read");
+	if (!pmemblk_read)
 		goto errorout;
-	if (NULL == (pmemblk_write = dlsym(dl, "pmemblk_write")))
+	pmemblk_write = dlsym(dl, "pmemblk_write");
+	if (!pmemblk_write)
 		goto errorout;
 
 	return 0;
 
 errorout:
 	log_err("fio: unable to load libpmemblk: %s\n", dlerror());
-	if (NULL != dl)
+	if (dl)
 		dlclose(dl);
 
-	return (-1);
-
-}				/* load_libpmemblk() */
+	return -1;
+}
 
 typedef struct fio_pmemblk_file *fio_pmemblk_file_t;
+
 struct fio_pmemblk_file {
 	fio_pmemblk_file_t pmb_next;
 	char *pmb_filename;
@@ -134,7 +141,7 @@ struct fio_pmemblk_file {
 } while(0)
 #define FIOFILEPMBGET(_f)  ((fio_pmemblk_file_t)((_f)->engine_data))
 
-static fio_pmemblk_file_t Cache = NULL;
+static fio_pmemblk_file_t Cache;
 
 static pthread_mutex_t CacheLock = PTHREAD_MUTEX_INITIALIZER;
 
@@ -145,21 +152,17 @@ fio_pmemblk_file_t fio_pmemblk_cache_lookup(const char *filename)
 	fio_pmemblk_file_t i;
 
 	for (i = Cache; i != NULL; i = i->pmb_next)
-		if (0 == strcmp(filename, i->pmb_filename))
+		if (!strcmp(filename, i->pmb_filename))
 			return i;
 
 	return NULL;
-
-}				/* fio_pmemblk_cache_lookup() */
+}
 
 static void fio_pmemblk_cache_insert(fio_pmemblk_file_t pmb)
 {
 	pmb->pmb_next = Cache;
 	Cache = pmb;
-
-	return;
-
-}				/* fio_pmemblk_cache_insert() */
+}
 
 static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
 {
@@ -177,10 +180,7 @@ static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
 			pmb->pmb_next = NULL;
 			return;
 		}
-
-	return;
-
-}				/* fio_pmemblk_cache_remove() */
+}
 
 /*
  * to control block size and gross file size at the libpmemblk
@@ -200,9 +200,8 @@ static void fio_pmemblk_cache_remove(fio_pmemblk_file_t pmb)
  * note that the user should specify the file size in MiB, but
  * we return bytes from here.
  */
-static void
-pmb_parse_path(const char *pathspec,
-	       char **ppath, uint64_t * pbsize, uint64_t * pfsize)
+static void pmb_parse_path(const char *pathspec, char **ppath, uint64_t *pbsize,
+			   uint64_t *pfsize)
 {
 	char *path;
 	char *s;
@@ -210,7 +209,7 @@ pmb_parse_path(const char *pathspec,
 	uint64_t fsizemb;
 
 	path = strdup(pathspec);
-	if (NULL == path) {
+	if (!path) {
 		*ppath = NULL;
 		return;
 	}
@@ -234,12 +233,9 @@ pmb_parse_path(const char *pathspec,
 	*ppath = path;
 	*pbsize = 0;
 	*pfsize = 0;
-	return;
-
-}				/* pmb_parse_path() */
+}
 
-static
- fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
+static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
 {
 	fio_pmemblk_file_t pmb;
 	char *path = NULL;
@@ -247,32 +243,30 @@ static
 	uint64_t fsize = 0;
 
 	pmb_parse_path(pathspec, &path, &bsize, &fsize);
-	if (NULL == path)
+	if (!path)
 		return NULL;
 
 	pthread_mutex_lock(&CacheLock);
 
 	pmb = fio_pmemblk_cache_lookup(path);
-
-	if (NULL == pmb) {
+	if (!pmb) {
 		/* load libpmemblk if needed */
-		if (NULL == pmemblk_open)
-			if (0 != load_libpmemblk(getenv("FIO_PMEMBLK_LIB")))
+		if (!pmemblk_open)
+			if (load_libpmemblk(getenv("FIO_PMEMBLK_LIB")))
 				goto error;
 
 		pmb = malloc(sizeof(*pmb));
-		if (NULL == pmb)
+		if (!pmb)
 			goto error;
 
 		/* try opening existing first, create it if needed */
 		pmb->pmb_pool = pmemblk_open(path, bsize);
-		if ((NULL == pmb->pmb_pool) &&
-		    (ENOENT == errno) &&
+		if (!pmb->pmb_pool && (errno == ENOENT) &&
 		    (flags & PMB_CREATE) && (0 < fsize) && (0 < bsize)) {
 			pmb->pmb_pool =
 			    pmemblk_create(path, bsize, fsize, 0644);
 		}
-		if (NULL == pmb->pmb_pool) {
+		if (!pmb->pmb_pool) {
 			log_err
 			    ("fio: enable to open pmemblk pool file (errno %d)\n",
 			     errno);
@@ -295,28 +289,27 @@ static
 	return pmb;
 
 error:
-	if (NULL != pmb) {
-		if (NULL != pmb->pmb_pool)
+	if (pmb) {
+		if (pmb->pmb_pool)
 			pmemblk_close(pmb->pmb_pool);
 		pmb->pmb_pool = NULL;
 		pmb->pmb_filename = NULL;
 		free(pmb);
 	}
-	if (NULL != path)
+	if (path)
 		free(path);
 
 	pthread_mutex_unlock(&CacheLock);
 	return NULL;
+}
 
-}				/* pmb_open() */
-
-static void pmb_close(fio_pmemblk_file_t pmb, const int keep)
+static void pmb_close(fio_pmemblk_file_t pmb, const bool keep)
 {
 	pthread_mutex_lock(&CacheLock);
 
 	pmb->pmb_refcnt--;
 
-	if (!keep && (0 == pmb->pmb_refcnt)) {
+	if (!keep && !pmb->pmb_refcnt) {
 		pmemblk_close(pmb->pmb_pool);
 		pmb->pmb_pool = NULL;
 		free(pmb->pmb_filename);
@@ -326,10 +319,9 @@ static void pmb_close(fio_pmemblk_file_t pmb, const int keep)
 	}
 
 	pthread_mutex_unlock(&CacheLock);
+}
 
-}				/* pmb_close() */
-
-static int pmb_get_flags(struct thread_data *td, uint64_t * pflags)
+static int pmb_get_flags(struct thread_data *td, uint64_t *pflags)
 {
 	static int thread_warned = 0;
 	static int odirect_warned = 0;
@@ -354,40 +346,35 @@ static int pmb_get_flags(struct thread_data *td, uint64_t * pflags)
 
 	(*pflags) = flags;
 	return 0;
-
-}				/* pmb_get_flags() */
+}
 
 static int fio_pmemblk_open_file(struct thread_data *td, struct fio_file *f)
 {
 	uint64_t flags = 0;
 	fio_pmemblk_file_t pmb;
 
-	if (0 != pmb_get_flags(td, &flags))
+	if (pmb_get_flags(td, &flags))
 		return 1;
 
 	pmb = pmb_open(f->file_name, flags);
-	if (NULL == pmb)
+	if (!pmb)
 		return 1;
 
 	FIOFILEPMBSET(f, pmb);
-
 	return 0;
+}
 
-}				/* fio_pmemblk_open_file() */
-
-static int
-fio_pmemblk_close_file(struct thread_data fio_unused * td, struct fio_file *f)
+static int fio_pmemblk_close_file(struct thread_data fio_unused *td,
+				  struct fio_file *f)
 {
 	fio_pmemblk_file_t pmb = FIOFILEPMBGET(f);
 
 	if (pmb)
-		pmb_close(pmb, 0);
+		pmb_close(pmb, false);
 
 	FIOFILEPMBSET(f, NULL);
-
 	return 0;
-
-}				/* fio_pmemblk_close_file() */
+}
 
 static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 {
@@ -397,11 +384,11 @@ static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 	if (fio_file_size_known(f))
 		return 0;
 
-	if (NULL == pmb) {
-		if (0 != pmb_get_flags(td, &flags))
+	if (!pmb) {
+		if (pmb_get_flags(td, &flags))
 			return 1;
 		pmb = pmb_open(f->file_name, flags);
-		if (NULL == pmb)
+		if (!pmb)
 			return 1;
 	}
 
@@ -409,12 +396,11 @@ static int fio_pmemblk_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	fio_file_set_size_known(f);
 
-	if (NULL == FIOFILEPMBGET(f))
-		pmb_close(pmb, 1);
+	if (!FIOFILEPMBGET(f))
+		pmb_close(pmb, true);
 
 	return 0;
-
-}				/* fio_pmemblk_get_file_size() */
+}
 
 static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
 {
@@ -437,9 +423,9 @@ static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
 		len = io_u->xfer_buflen;
 
 		io_u->error = EINVAL;
-		if (0 != (off % pmb->pmb_bsize))
+		if (off % pmb->pmb_bsize)
 			break;
-		if (0 != (len % pmb->pmb_bsize))
+		if (len % pmb->pmb_bsize)
 			break;
 		if ((off + len) / pmb->pmb_bsize > pmb->pmb_nblocks)
 			break;
@@ -473,8 +459,7 @@ static int fio_pmemblk_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	return FIO_Q_COMPLETED;
-
-}				/* fio_pmemblk_queue() */
+}
 
 static int fio_pmemblk_unlink_file(struct thread_data *td, struct fio_file *f)
 {
@@ -489,15 +474,13 @@ static int fio_pmemblk_unlink_file(struct thread_data *td, struct fio_file *f)
 	 */
 
 	pmb_parse_path(f->file_name, &path, &bsize, &fsize);
-	if (NULL == path)
+	if (!path)
 		return 1;
 
 	unlink(path);
 	free(path);
-
 	return 0;
-
-}				/* fio_pmemblk_unlink_file() */
+}
 
 struct ioengine_ops ioengine = {
 	.name = "pmemblk",
@@ -510,14 +493,12 @@ struct ioengine_ops ioengine = {
 	.flags = FIO_SYNCIO | FIO_DISKLESSIO | FIO_NOEXTEND | FIO_NODISKUTIL,
 };
 
-static void
-fio_init fio_pmemblk_register(void)
+static void fio_init fio_pmemblk_register(void)
 {
 	register_ioengine(&ioengine);
 }
 
-static void
-fio_exit fio_pmemblk_unregister(void)
+static void fio_exit fio_pmemblk_unregister(void)
 {
 	unregister_ioengine(&ioengine);
 }
diff --git a/ioengines.c b/ioengines.c
index b89a121..e2e7280 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -22,35 +22,31 @@
 
 static FLIST_HEAD(engine_list);
 
-static int check_engine_ops(struct ioengine_ops *ops)
+static bool check_engine_ops(struct ioengine_ops *ops)
 {
 	if (ops->version != FIO_IOOPS_VERSION) {
 		log_err("bad ioops version %d (want %d)\n", ops->version,
 							FIO_IOOPS_VERSION);
-		return 1;
+		return true;
 	}
 
 	if (!ops->queue) {
 		log_err("%s: no queue handler\n", ops->name);
-		return 1;
+		return true;
 	}
 
 	/*
 	 * sync engines only need a ->queue()
 	 */
 	if (ops->flags & FIO_SYNCIO)
-		return 0;
+		return false;
 
-	if (!ops->event) {
-		log_err("%s: no event handler\n", ops->name);
-		return 1;
-	}
-	if (!ops->getevents) {
-		log_err("%s: no getevents handler\n", ops->name);
-		return 1;
+	if (!ops->event || !ops->getevents) {
+		log_err("%s: no event/getevents handler\n", ops->name);
+		return true;
 	}
 
-	return 0;
+	return false;
 }
 
 void unregister_ioengine(struct ioengine_ops *ops)
diff --git a/verify-state.h b/verify-state.h
index f1dc069..901aa0a 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -2,6 +2,7 @@
 #define FIO_VERIFY_STATE_H
 
 #include <stdint.h>
+#include <string.h>
 
 struct thread_rand32_state {
 	uint32_t s[4];
@@ -82,7 +83,24 @@ static inline void verify_state_gen_name(char *out, size_t size,
 					 const char *name, const char *prefix,
 					 int num)
 {
-	snprintf(out, size, "%s-%s-%d-verify.state", prefix, name, num);
+	char ename[PATH_MAX];
+	char *ptr;
+
+	/*
+	 * Escape '/', just turn them into '.'
+	 */
+	ptr = ename;
+	do {
+		*ptr = *name;
+		if (*ptr == '\0')
+			break;
+		else if (*ptr == '/')
+			*ptr = '.';
+		ptr++;
+		name++;
+	} while (1);
+
+	snprintf(out, size, "%s-%s-%d-verify.state", prefix, ename, num);
 	out[size - 1] = '\0';
 }
 
diff --git a/verify.c b/verify.c
index 838db10..58f37ae 100644
--- a/verify.c
+++ b/verify.c
@@ -1471,7 +1471,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 static int open_state_file(const char *name, const char *prefix, int num,
 			   int for_write)
 {
-	char out[64];
+	char out[PATH_MAX];
 	int flags;
 	int fd;
 
@@ -1485,6 +1485,7 @@ static int open_state_file(const char *name, const char *prefix, int num,
 	fd = open(out, flags, 0644);
 	if (fd == -1) {
 		perror("fio: open state file");
+		log_err("fio: state file: %s (for_write=%d)\n", out, for_write);
 		return -1;
 	}
 
