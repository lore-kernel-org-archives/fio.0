Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44792 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756140AbdKCMAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Nov 2017 08:00:21 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAae4-0002Lo-AQ
        for fio@vger.kernel.org; Fri, 03 Nov 2017 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171103120002.7EB242C02AF@kernel.dk>
Date: Fri,  3 Nov 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c89daa4a98e6f3749ffc75b727a77cc061a0a454:

  io_u: reset file to initial offset (2017-11-01 14:51:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 34851ad5ffacf9f4f8a7f23ee2edb17281b917a0:

  io_u_queue: convert rings to bool (2017-11-02 12:26:39 -0600)

----------------------------------------------------------------
Jens Axboe (9):
      filesetup: don't print non-debug error on native fallocate failure
      filesetup: don't inline native_fallocate()
      filesetup: pre_read_files() can use a bool
      filesetup: __init_rand_distribution() can be void
      filesetup: change random file init to be bool based
      filesetup: create_work_dirs() can return bool
      filesetup: recurse_dir() can use bool
      filesetup: allocate 'r' locally in fallocate_file()
      io_u_queue: convert rings to bool

 backend.c    | 14 +++++-----
 file.h       |  4 +--
 filesetup.c  | 85 ++++++++++++++++++++++++++++++------------------------------
 io_u_queue.c | 12 ++++-----
 io_u_queue.h |  5 ++--
 5 files changed, 59 insertions(+), 61 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index c14f37c..7cf9b38 100644
--- a/backend.c
+++ b/backend.c
@@ -1203,9 +1203,9 @@ static int init_io_u(struct thread_data *td)
 		data_xfer = 0;
 
 	err = 0;
-	err += io_u_rinit(&td->io_u_requeues, td->o.iodepth);
-	err += io_u_qinit(&td->io_u_freelist, td->o.iodepth);
-	err += io_u_qinit(&td->io_u_all, td->o.iodepth);
+	err += !io_u_rinit(&td->io_u_requeues, td->o.iodepth);
+	err += !io_u_qinit(&td->io_u_freelist, td->o.iodepth);
+	err += !io_u_qinit(&td->io_u_all, td->o.iodepth);
 
 	if (err) {
 		log_err("fio: failed setting up IO queues\n");
@@ -1692,16 +1692,14 @@ static void *thread_main(void *data)
 	if (td_io_init(td))
 		goto err;
 
-	if (init_random_map(td))
+	if (!init_random_map(td))
 		goto err;
 
 	if (o->exec_prerun && exec_string(o, o->exec_prerun, (const char *)"prerun"))
 		goto err;
 
-	if (o->pre_read) {
-		if (pre_read_files(td) < 0)
-			goto err;
-	}
+	if (o->pre_read && !pre_read_files(td))
+		goto err;
 
 	fio_verify_init(td);
 
diff --git a/file.h b/file.h
index e3864ee..cc721ee 100644
--- a/file.h
+++ b/file.h
@@ -198,7 +198,7 @@ extern int __must_check generic_get_file_size(struct thread_data *, struct fio_f
 }
 #endif
 extern int __must_check file_lookup_open(struct fio_file *f, int flags);
-extern int __must_check pre_read_files(struct thread_data *);
+extern bool __must_check pre_read_files(struct thread_data *);
 extern unsigned long long get_rand_file_size(struct thread_data *td);
 extern int add_file(struct thread_data *, const char *, int, int);
 extern int add_file_exclusive(struct thread_data *, const char *);
@@ -209,7 +209,7 @@ extern void lock_file(struct thread_data *, struct fio_file *, enum fio_ddir);
 extern void unlock_file(struct thread_data *, struct fio_file *);
 extern void unlock_file_all(struct thread_data *, struct fio_file *);
 extern int add_dir_files(struct thread_data *, const char *);
-extern int init_random_map(struct thread_data *);
+extern bool init_random_map(struct thread_data *);
 extern void dup_files(struct thread_data *, struct thread_data *);
 extern int get_fileno(struct thread_data *, const char *);
 extern void free_release_files(struct thread_data *);
diff --git a/filesetup.c b/filesetup.c
index 5d7ea5c..4d29b70 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -38,7 +38,7 @@ static inline void clear_error(struct thread_data *td)
 	td->verror[0] = '\0';
 }
 
-static inline int native_fallocate(struct thread_data *td, struct fio_file *f)
+static int native_fallocate(struct thread_data *td, struct fio_file *f)
 {
 	bool success;
 
@@ -49,32 +49,29 @@ static inline int native_fallocate(struct thread_data *td, struct fio_file *f)
 			!success ? "un": "");
 
 	if (success)
-		return 0;
+		return false;
 
 	if (errno == ENOSYS)
 		dprint(FD_FILE, "native fallocate is not implemented\n");
 
-	return -1;
+	return true;
 }
 
 static void fallocate_file(struct thread_data *td, struct fio_file *f)
 {
-	int r;
-
 	if (td->o.fill_device)
 		return;
 
 	switch (td->o.fallocate_mode) {
 	case FIO_FALLOCATE_NATIVE:
-		r = native_fallocate(td, f);
-		if (r != 0 && errno != ENOSYS)
-			log_err("fio: native_fallocate call failed: %s\n",
-					strerror(errno));
+		native_fallocate(td, f);
 		break;
 	case FIO_FALLOCATE_NONE:
 		break;
 #ifdef CONFIG_POSIX_FALLOCATE
-	case FIO_FALLOCATE_POSIX:
+	case FIO_FALLOCATE_POSIX: {
+		int r;
+
 		dprint(FD_FILE, "posix_fallocate file %s size %llu\n",
 				 f->file_name,
 				 (unsigned long long) f->real_file_size);
@@ -83,9 +80,12 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 		if (r > 0)
 			log_err("fio: posix_fallocate fails: %s\n", strerror(r));
 		break;
+		}
 #endif /* CONFIG_POSIX_FALLOCATE */
 #ifdef CONFIG_LINUX_FALLOCATE
-	case FIO_FALLOCATE_KEEP_SIZE:
+	case FIO_FALLOCATE_KEEP_SIZE: {
+		int r;
+
 		dprint(FD_FILE, "fallocate(FALLOC_FL_KEEP_SIZE) "
 				"file %s size %llu\n", f->file_name,
 				(unsigned long long) f->real_file_size);
@@ -95,6 +95,7 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 			td_verror(td, errno, "fallocate");
 
 		break;
+		}
 #endif /* CONFIG_LINUX_FALLOCATE */
 	default:
 		log_err("fio: unknown fallocate mode: %d\n", td->o.fallocate_mode);
@@ -258,24 +259,25 @@ err:
 	return 1;
 }
 
-static int pre_read_file(struct thread_data *td, struct fio_file *f)
+static bool pre_read_file(struct thread_data *td, struct fio_file *f)
 {
-	int ret = 0, r, did_open = 0, old_runstate;
+	int r, did_open = 0, old_runstate;
 	unsigned long long left;
 	unsigned int bs;
+	bool ret = true;
 	char *b;
 
 	if (td_ioengine_flagged(td, FIO_PIPEIO) ||
 	    td_ioengine_flagged(td, FIO_NOIO))
-		return 0;
+		return true;
 
 	if (f->filetype == FIO_TYPE_CHAR)
-		return 0;
+		return true;
 
 	if (!fio_file_open(f)) {
 		if (td->io_ops->open_file(td, f)) {
 			log_err("fio: cannot pre-read, failed to open file\n");
-			return 1;
+			return false;
 		}
 		did_open = 1;
 	}
@@ -290,7 +292,7 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 	b = malloc(bs);
 	if (!b) {
 		td_verror(td, errno, "malloc");
-		ret = 1;
+		ret = false;
 		goto error;
 	}
 	memset(b, 0, bs);
@@ -298,7 +300,7 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 	if (lseek(f->fd, f->file_offset, SEEK_SET) < 0) {
 		td_verror(td, errno, "lseek");
 		log_err("fio: failed to lseek pre-read file\n");
-		ret = 1;
+		ret = false;
 		goto error;
 	}
 
@@ -1177,7 +1179,7 @@ err_out:
 	return 1;
 }
 
-int pre_read_files(struct thread_data *td)
+bool pre_read_files(struct thread_data *td)
 {
 	struct fio_file *f;
 	unsigned int i;
@@ -1185,14 +1187,14 @@ int pre_read_files(struct thread_data *td)
 	dprint(FD_FILE, "pre_read files\n");
 
 	for_each_file(td, f, i) {
-		if (pre_read_file(td, f))
-			return -1;
+		if (!pre_read_file(td, f))
+			return false;
 	}
 
-	return 0;
+	return true;
 }
 
-static int __init_rand_distribution(struct thread_data *td, struct fio_file *f)
+static void __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 {
 	unsigned int range_size, seed;
 	unsigned long nranges;
@@ -1213,18 +1215,16 @@ static int __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 		pareto_init(&f->zipf, nranges, td->o.pareto_h.u.f, seed);
 	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
 		gauss_init(&f->gauss, nranges, td->o.gauss_dev.u.f, seed);
-
-	return 1;
 }
 
-static int init_rand_distribution(struct thread_data *td)
+static bool init_rand_distribution(struct thread_data *td)
 {
 	struct fio_file *f;
 	unsigned int i;
 	int state;
 
 	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM)
-		return 0;
+		return false;
 
 	state = td_bump_runstate(td, TD_SETTING_UP);
 
@@ -1232,8 +1232,7 @@ static int init_rand_distribution(struct thread_data *td)
 		__init_rand_distribution(td, f);
 
 	td_restore_runstate(td, state);
-
-	return 1;
+	return true;
 }
 
 /*
@@ -1273,16 +1272,16 @@ static int check_rand_gen_limits(struct thread_data *td, struct fio_file *f,
 	return 0;
 }
 
-int init_random_map(struct thread_data *td)
+bool init_random_map(struct thread_data *td)
 {
 	unsigned long long blocks;
 	struct fio_file *f;
 	unsigned int i;
 
 	if (init_rand_distribution(td))
-		return 0;
+		return true;
 	if (!td_random(td))
-		return 0;
+		return true;
 
 	for_each_file(td, f, i) {
 		uint64_t fsize = min(f->real_file_size, f->io_size);
@@ -1290,7 +1289,7 @@ int init_random_map(struct thread_data *td)
 		blocks = fsize / (unsigned long long) td->o.rw_min_bs;
 
 		if (check_rand_gen_limits(td, f, blocks))
-			return 1;
+			return false;
 
 		if (td->o.random_generator == FIO_RAND_GEN_LFSR) {
 			unsigned long seed;
@@ -1315,14 +1314,14 @@ int init_random_map(struct thread_data *td)
 				" a large number of jobs, try the 'norandommap'"
 				" option or set 'softrandommap'. Or give"
 				" a larger --alloc-size to fio.\n");
-			return 1;
+			return false;
 		}
 
 		log_info("fio: file %s failed allocating random map. Running "
 			 "job without.\n", f->file_name);
 	}
 
-	return 0;
+	return true;
 }
 
 void close_files(struct thread_data *td)
@@ -1521,7 +1520,7 @@ bool exists_and_not_regfile(const char *filename)
 	return true;
 }
 
-static int create_work_dirs(struct thread_data *td, const char *fname)
+static bool create_work_dirs(struct thread_data *td, const char *fname)
 {
 	char path[PATH_MAX];
 	char *start, *end;
@@ -1548,13 +1547,13 @@ static int create_work_dirs(struct thread_data *td, const char *fname)
 #endif
 			log_err("fio: failed to create dir (%s): %d\n",
 				start, errno);
-			return 1;
+			return false;
 		}
 		*end = FIO_OS_PATH_SEPARATOR;
 		end++;
 	}
 	td->flags |= TD_F_DIRS_CREATED;
-	return 0;
+	return true;
 }
 
 int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
@@ -1574,7 +1573,7 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 
 	if (strchr(fname, FIO_OS_PATH_SEPARATOR) &&
 	    !(td->flags & TD_F_DIRS_CREATED) &&
-	    create_work_dirs(td, fname))
+	    !create_work_dirs(td, fname))
 		return 1;
 
 	/* clean cloned siblings using existing files */
@@ -1742,10 +1741,10 @@ void unlock_file_all(struct thread_data *td, struct fio_file *f)
 		unlock_file(td, f);
 }
 
-static int recurse_dir(struct thread_data *td, const char *dirname)
+static bool recurse_dir(struct thread_data *td, const char *dirname)
 {
 	struct dirent *dir;
-	int ret = 0;
+	bool ret = false;
 	DIR *D;
 
 	D = opendir(dirname);
@@ -1754,7 +1753,7 @@ static int recurse_dir(struct thread_data *td, const char *dirname)
 
 		snprintf(buf, FIO_VERROR_SIZE, "opendir(%s)", dirname);
 		td_verror(td, errno, buf);
-		return 1;
+		return true;
 	}
 
 	while ((dir = readdir(D)) != NULL) {
@@ -1769,7 +1768,7 @@ static int recurse_dir(struct thread_data *td, const char *dirname)
 		if (lstat(full_path, &sb) == -1) {
 			if (errno != ENOENT) {
 				td_verror(td, errno, "stat");
-				ret = 1;
+				ret = true;
 				break;
 			}
 		}
diff --git a/io_u_queue.c b/io_u_queue.c
index 9994c78..8cf4c8c 100644
--- a/io_u_queue.c
+++ b/io_u_queue.c
@@ -1,15 +1,15 @@
 #include <stdlib.h>
 #include "io_u_queue.h"
 
-int io_u_qinit(struct io_u_queue *q, unsigned int nr)
+bool io_u_qinit(struct io_u_queue *q, unsigned int nr)
 {
 	q->io_us = calloc(nr, sizeof(struct io_u *));
 	if (!q->io_us)
-		return 1;
+		return false;
 
 	q->nr = 0;
 	q->max = nr;
-	return 0;
+	return true;
 }
 
 void io_u_qexit(struct io_u_queue *q)
@@ -17,7 +17,7 @@ void io_u_qexit(struct io_u_queue *q)
 	free(q->io_us);
 }
 
-int io_u_rinit(struct io_u_ring *ring, unsigned int nr)
+bool io_u_rinit(struct io_u_ring *ring, unsigned int nr)
 {
 	ring->max = nr + 1;
 	if (ring->max & (ring->max - 1)) {
@@ -32,10 +32,10 @@ int io_u_rinit(struct io_u_ring *ring, unsigned int nr)
 
 	ring->ring = calloc(ring->max, sizeof(struct io_u *));
 	if (!ring->ring)
-		return 1;
+		return false;
 
 	ring->head = ring->tail = 0;
-	return 0;
+	return true;
 }
 
 void io_u_rexit(struct io_u_ring *ring)
diff --git a/io_u_queue.h b/io_u_queue.h
index 118e593..b5b8d2f 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -2,6 +2,7 @@
 #define FIO_IO_U_QUEUE
 
 #include <assert.h>
+#include "lib/types.h"
 
 struct io_u;
 
@@ -42,7 +43,7 @@ static inline int io_u_qempty(const struct io_u_queue *q)
 #define io_u_qiter(q, io_u, i)	\
 	for (i = 0; i < (q)->nr && (io_u = (q)->io_us[i]); i++)
 
-int io_u_qinit(struct io_u_queue *q, unsigned int nr);
+bool io_u_qinit(struct io_u_queue *q, unsigned int nr);
 void io_u_qexit(struct io_u_queue *q);
 
 struct io_u_ring {
@@ -52,7 +53,7 @@ struct io_u_ring {
 	struct io_u **ring;
 };
 
-int io_u_rinit(struct io_u_ring *ring, unsigned int nr);
+bool io_u_rinit(struct io_u_ring *ring, unsigned int nr);
 void io_u_rexit(struct io_u_ring *ring);
 
 static inline void io_u_rpush(struct io_u_ring *r, struct io_u *io_u)
