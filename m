Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50109 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaB0NAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 27 Feb 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WJ0ZJ-00044m-Cl
	for fio@vger.kernel.org; Thu, 27 Feb 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140227130003.6231841EF8@strynoevaenget.dk>
Date: Thu, 27 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bcd27f7ae1ccebd2ac1778752bf8f13fa99600e9:

  Fixup ->open_files if not given (2014-02-25 14:01:26 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 225ba9e3433cf27d8ff7b213d9f78b7ef2776c70:

  Branch and cache miss speedups (2014-02-26 14:31:15 -0800)

----------------------------------------------------------------
Jens Axboe (2):
      blktrace: load improvements
      Branch and cache miss speedups

 blktrace.c          |    9 ++++++++-
 compiler/compiler.h |    2 ++
 engines/net.c       |    2 +-
 engines/rbd.c       |    2 +-
 file.h              |    2 +-
 filesetup.c         |   12 +++++++-----
 gettime.c           |    2 +-
 init.c              |    4 ++--
 io_u.c              |    2 +-
 ioengine.h          |   38 +++++++++++++++++++-------------------
 iolog.c             |    3 +--
 lib/lfsr.c          |    9 ++++-----
 options.c           |    3 +--
 13 files changed, 49 insertions(+), 41 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index 9e4e599..107a65b 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -217,6 +217,8 @@ static int trace_add_file(struct thread_data *td, __u32 device)
 
 		dprint(FD_BLKTRACE, "add devices %s\n", dev);
 		fileno = add_file_exclusive(td, dev);
+		td->files[fileno]->major = maj;
+		td->files[fileno]->minor = min;
 		trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
 		last_fileno = fileno;
 	}
@@ -369,7 +371,7 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	unsigned int cpu;
 	unsigned int rw_bs[2];
 	struct fifo *fifo;
-	int fd, i;
+	int fd, i, old_state;
 	struct fio_file *f;
 
 	fd = open(filename, O_RDONLY);
@@ -380,6 +382,9 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 
 	fifo = fifo_alloc(TRACE_FIFO_SIZE);
 
+	old_state = td->runstate;
+	td_set_runstate(td, TD_SETTING_UP);
+
 	td->o.size = 0;
 
 	cpu = 0;
@@ -458,6 +463,8 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	fifo_free(fifo);
 	close(fd);
 
+	td_set_runstate(td, old_state);
+
 	if (!td->files_index) {
 		log_err("fio: did not find replay device(s)\n");
 		return 1;
diff --git a/compiler/compiler.h b/compiler/compiler.h
index 036ba20..0a0213b 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -20,4 +20,6 @@
 #define fio_init	__attribute__((constructor))
 #define fio_exit	__attribute__((destructor))
 
+#define fio_unlikely(x)	__builtin_expect(!!(x), 0)
+
 #endif
diff --git a/engines/net.c b/engines/net.c
index dd06861..1df8d06 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1194,7 +1194,7 @@ static int fio_netio_setup(struct thread_data *td)
 	struct netio_data *nd;
 
 	if (!td->files_index) {
-		add_file(td, td->o.filename ?: "net", 0);
+		add_file(td, td->o.filename ?: "net", 0, 0);
 		td->o.nr_files = td->o.nr_files ?: 1;
 	}
 
diff --git a/engines/rbd.c b/engines/rbd.c
index 39fa0ce..5a4a3e2 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -377,7 +377,7 @@ static int fio_rbd_setup(struct thread_data *td)
 	 * The size of the RBD is set instead of a artificial file.
 	 */
 	if (!td->files_index) {
-		add_file(td, td->o.filename ? : "rbd", 0);
+		add_file(td, td->o.filename ? : "rbd", 0, 0);
 		td->o.nr_files = td->o.nr_files ? : 1;
 	}
 	f = td->files[0];
diff --git a/file.h b/file.h
index d065a25..c929d1d 100644
--- a/file.h
+++ b/file.h
@@ -167,7 +167,7 @@ extern int __must_check generic_close_file(struct thread_data *, struct fio_file
 extern int __must_check generic_get_file_size(struct thread_data *, struct fio_file *);
 extern int __must_check file_lookup_open(struct fio_file *f, int flags);
 extern int __must_check pre_read_files(struct thread_data *);
-extern int add_file(struct thread_data *, const char *, int);
+extern int add_file(struct thread_data *, const char *, int, int);
 extern int add_file_exclusive(struct thread_data *, const char *);
 extern void get_file(struct fio_file *);
 extern int __must_check put_file(struct thread_data *, struct fio_file *);
diff --git a/filesetup.c b/filesetup.c
index 7669d70..2744d4f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1010,7 +1010,7 @@ int init_random_map(struct thread_data *td)
 
 			seed = td->rand_seeds[FIO_RAND_BLOCK_OFF];
 			
-			if (!lfsr_init(&f->lfsr, blocks, seed, seed & 0xF))
+			if (!lfsr_init(&f->lfsr, blocks, seed, 0))
 				continue;
 		} else if (!td->o.norandommap) {
 			f->io_axmap = axmap_new(blocks);
@@ -1145,7 +1145,7 @@ static void free_already_allocated() {
 	}
 }
 
-int add_file(struct thread_data *td, const char *fname, int numjob)
+int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 {
 	int cur_files = td->files_index;
 	char file_name[PATH_MAX];
@@ -1237,6 +1237,9 @@ int add_file(struct thread_data *td, const char *fname, int numjob)
 	if (!td->o.open_files)
 		td->o.open_files = 1;
 
+	if (inc)
+		td->o.nr_files++;
+
 	dprint(FD_FILE, "file %p \"%s\" added at %d\n", f, f->file_name,
 							cur_files);
 
@@ -1253,7 +1256,7 @@ int add_file_exclusive(struct thread_data *td, const char *fname)
 			return i;
 	}
 
-	return add_file(td, fname, 0);
+	return add_file(td, fname, 0, 1);
 }
 
 void get_file(struct fio_file *f)
@@ -1362,8 +1365,7 @@ static int recurse_dir(struct thread_data *td, const char *dirname)
 		}
 
 		if (S_ISREG(sb.st_mode)) {
-			add_file(td, full_path, 0);
-			td->o.nr_files++;
+			add_file(td, full_path, 0, 1);
 			continue;
 		}
 		if (!S_ISDIR(sb.st_mode))
diff --git a/gettime.c b/gettime.c
index 277f2cf..8991703 100644
--- a/gettime.c
+++ b/gettime.c
@@ -205,7 +205,7 @@ void fio_gettime(struct timeval *tp, void fio_unused *caller)
 
 	gtod_log_caller(caller);
 #endif
-	if (fio_tv) {
+	if (fio_unlikely(fio_tv)) {
 		memcpy(tp, fio_tv, sizeof(*tp));
 		return;
 	}
diff --git a/init.c b/init.c
index 6a65e55..73ec9eb 100644
--- a/init.c
+++ b/init.c
@@ -1026,10 +1026,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		file_alloced = 1;
 
 		if (o->nr_files == 1 && exists_and_not_file(jobname))
-			add_file(td, jobname, job_add_num);
+			add_file(td, jobname, job_add_num, 0);
 		else {
 			for (i = 0; i < o->nr_files; i++)
-				add_file(td, make_filename(fname, o, jobname, job_add_num, i), job_add_num);
+				add_file(td, make_filename(fname, o, jobname, job_add_num, i), job_add_num, 0);
 		}
 	}
 
diff --git a/io_u.c b/io_u.c
index a69efb7..77557df 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1307,9 +1307,9 @@ again:
 	else if (!queue_full(td)) {
 		io_u = io_u_qpop(&td->io_u_freelist);
 
+		io_u->file = NULL;
 		io_u->buflen = 0;
 		io_u->resid = 0;
-		io_u->file = NULL;
 		io_u->end_io = NULL;
 	}
 
diff --git a/ioengine.h b/ioengine.h
index abf2b46..7e0707b 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -73,6 +73,25 @@ struct io_u {
 
 	struct io_piece *ipo;
 
+	unsigned int resid;
+	unsigned int error;
+
+	/*
+	 * io engine private data
+	 */
+	union {
+		unsigned int index;
+		unsigned int seen;
+		void *engine_data;
+	};
+
+	struct flist_head verify_list;
+
+	/*
+	 * Callback for io completion
+	 */
+	int (*end_io)(struct thread_data *, struct io_u *);
+
 	union {
 #ifdef CONFIG_LIBAIO
 		struct iocb iocb;
@@ -97,25 +116,6 @@ struct io_u {
 #endif
 		void *mmap_data;
 	};
-
-	unsigned int resid;
-	unsigned int error;
-
-	/*
-	 * io engine private data
-	 */
-	union {
-		unsigned int index;
-		unsigned int seen;
-		void *engine_data;
-	};
-
-	struct flist_head verify_list;
-
-	/*
-	 * Callback for io completion
-	 */
-	int (*end_io)(struct thread_data *, struct io_u *);
 };
 
 /*
diff --git a/iolog.c b/iolog.c
index eeaca29..b8ee067 100644
--- a/iolog.c
+++ b/iolog.c
@@ -323,8 +323,7 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 		} else if (r == 2) {
 			rw = DDIR_INVAL;
 			if (!strcmp(act, "add")) {
-				td->o.nr_files++;
-				fileno = add_file(td, fname, 0);
+				fileno = add_file(td, fname, 0, 1);
 				file_action = FIO_LOG_ADD_FILE;
 				continue;
 			} else if (!strcmp(act, "open")) {
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 927b2a1..9771318 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -2,6 +2,7 @@
 #include <math.h>
 
 #include "lfsr.h"
+#include "../compiler/compiler.h"
 
 /*
  * LFSR taps retrieved from:
@@ -132,11 +133,9 @@ int lfsr_next(struct fio_lfsr *fl, uint64_t *off, uint64_t last)
 		if (fl->cycle_length && !--fl->cycle_length) {
 			__lfsr_next(fl, fl->spin + 1);
 			fl->cycle_length = fl->cached_cycle_length;
-			goto check;
-		}
-		__lfsr_next(fl, fl->spin);
-check: ;
-	} while (fl->last_val > fl->max_val);
+		} else
+			__lfsr_next(fl, fl->spin);
+	} while (fio_unlikely(fl->last_val > fl->max_val));
 
 	*off = fl->last_val;
 	return 0;
diff --git a/options.c b/options.c
index 625d3a2..6d3956e 100644
--- a/options.c
+++ b/options.c
@@ -827,8 +827,7 @@ static int str_filename_cb(void *data, const char *input)
 	while ((fname = get_next_name(&str)) != NULL) {
 		if (!strlen(fname))
 			break;
-		add_file(td, fname, 0);
-		td->o.nr_files++;
+		add_file(td, fname, 0, 1);
 	}
 
 	free(p);
