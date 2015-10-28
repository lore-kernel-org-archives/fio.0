Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbbJ1MAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 28 Oct 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZrPOc-0002We-TF
	for fio@vger.kernel.org; Wed, 28 Oct 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151028120002.128002C00C1@kernel.dk>
Date: Wed, 28 Oct 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 01cfefcc6255420a9e19d5774053ed2fb705b150:

  client/backend: fix incomplete output_format checks (2015-10-27 18:34:33 +0900)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 09c782bbe1c62d016c8b165f304c7085a7ff9ffd:

  Update documentation for mmapshared (MMAP_SHARED) (2015-10-28 14:04:24 +0900)

----------------------------------------------------------------
Jens Axboe (4):
      Fixup -Wshadow warnings
      Merge branch 'mmap_shared' of git://github.com/lsgunth/fio
      Fixup bw/iops logging for short runs
      Update documentation for mmapshared (MMAP_SHARED)

Logan Gunthorpe (1):
      Add mmapshared option to use mmaped files with the MAP_SHARED flag.

 HOWTO            |  3 +++
 backend.c        | 29 +++++++++++++++--------------
 engines/mmap.c   |  4 ++--
 engines/mtd.c    |  4 ++--
 filesetup.c      |  2 +-
 fio.1            |  3 +++
 fio.h            |  2 +-
 libfio.c         | 31 +++++++++++++++++--------------
 memory.c         | 10 +++++++---
 options.c        |  7 ++++++-
 stat.c           |  2 +-
 t/btrace2fio.c   |  4 ++--
 thread_options.h |  1 +
 workqueue.c      |  2 +-
 14 files changed, 62 insertions(+), 42 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 40233bd..81217b7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1177,6 +1177,9 @@ mem=str		Fio can use various types of memory as the io unit buffer.
 				backing. Append filename after mmaphuge, ala
 				mem=mmaphuge:/hugetlbfs/file
 
+			mmapshared	Same as mmap, but use a MMAP_SHARED
+				mapping.
+
 		The area allocated is a function of the maximum allowed
 		bs size for the job, multiplied by the io depth given. Note
 		that for shmhuge and mmaphuge to work, the system must have
diff --git a/backend.c b/backend.c
index b180196..0a42da3 100644
--- a/backend.c
+++ b/backend.c
@@ -1559,27 +1559,28 @@ static void *thread_main(void *data)
 
 	fio_gettime(&td->epoch, NULL);
 	fio_getrusage(&td->ru_start);
+	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
+	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
+
+	if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||
+			o->ratemin[DDIR_TRIM]) {
+	        memcpy(&td->lastrate[DDIR_READ], &td->bw_sample_time,
+					sizeof(td->bw_sample_time));
+	        memcpy(&td->lastrate[DDIR_WRITE], &td->bw_sample_time,
+					sizeof(td->bw_sample_time));
+	        memcpy(&td->lastrate[DDIR_TRIM], &td->bw_sample_time,
+					sizeof(td->bw_sample_time));
+	}
+
 	clear_state = 0;
 	while (keep_running(td)) {
 		uint64_t verify_bytes;
 
 		fio_gettime(&td->start, NULL);
-		memcpy(&td->bw_sample_time, &td->start, sizeof(td->start));
-		memcpy(&td->iops_sample_time, &td->start, sizeof(td->start));
 		memcpy(&td->tv_cache, &td->start, sizeof(td->start));
 
-		if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||
-				o->ratemin[DDIR_TRIM]) {
-		        memcpy(&td->lastrate[DDIR_READ], &td->bw_sample_time,
-						sizeof(td->bw_sample_time));
-		        memcpy(&td->lastrate[DDIR_WRITE], &td->bw_sample_time,
-						sizeof(td->bw_sample_time));
-		        memcpy(&td->lastrate[DDIR_TRIM], &td->bw_sample_time,
-						sizeof(td->bw_sample_time));
-		}
-
 		if (clear_state)
-			clear_io_state(td);
+			clear_io_state(td, 0);
 
 		prune_io_piece_log(td);
 
@@ -1617,7 +1618,7 @@ static void *thread_main(void *data)
 		    (td->io_ops->flags & FIO_UNIDIR))
 			continue;
 
-		clear_io_state(td);
+		clear_io_state(td, 0);
 
 		fio_gettime(&td->start, NULL);
 
diff --git a/engines/mmap.c b/engines/mmap.c
index 69add78..14e4013 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -242,8 +242,8 @@ static int fio_mmapio_open_file(struct thread_data *td, struct fio_file *f)
 
 	fmd = calloc(1, sizeof(*fmd));
 	if (!fmd) {
-		int fio_unused ret;
-		ret = generic_close_file(td, f);
+		int fio_unused __ret;
+		__ret = generic_close_file(td, f);
 		return 1;
 	}
 
diff --git a/engines/mtd.c b/engines/mtd.c
index db9c539..9381089 100644
--- a/engines/mtd.c
+++ b/engines/mtd.c
@@ -152,8 +152,8 @@ err_free:
 	free(fmd);
 err_close:
 	{
-		int fio_unused ret;
-		ret = generic_close_file(td, f);
+		int fio_unused __ret;
+		__ret = generic_close_file(td, f);
 		return 1;
 	}
 }
diff --git a/filesetup.c b/filesetup.c
index 634d556..b5628ce 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -917,7 +917,7 @@ int setup_files(struct thread_data *td)
 		}
 
 		td->ts.nr_block_infos = len;
-		for (int i = 0; i < len; i++)
+		for (i = 0; i < len; i++)
 			td->ts.block_infos[i] =
 				BLOCK_INFO(0, BLOCK_STATE_UNINIT);
 	} else
diff --git a/fio.1 b/fio.1
index 2ba36f9..3bd3318 100644
--- a/fio.1
+++ b/fio.1
@@ -1084,6 +1084,9 @@ is given after the option in the format `:\fIfile\fR'.
 .TP
 .B mmaphuge
 Same as \fBmmap\fR, but use huge files as backing.
+.TP
+.B mmapshared
+Same as \fBmmap\fR, but use a MMAP_SHARED mapping.
 .RE
 .P
 The amount of memory allocated is the maximum allowed \fBblocksize\fR for the
diff --git a/fio.h b/fio.h
index 2dc445e..8daf975 100644
--- a/fio.h
+++ b/fio.h
@@ -464,7 +464,7 @@ extern int parse_jobs_ini(char *, int, int, int);
 extern int parse_cmd_line(int, char **, int);
 extern int fio_backend(void);
 extern void reset_fio_state(void);
-extern void clear_io_state(struct thread_data *);
+extern void clear_io_state(struct thread_data *, int);
 extern int fio_options_parse(struct thread_data *, char **, int, int);
 extern void fio_keywords_init(void);
 extern void fio_keywords_exit(void);
diff --git a/libfio.c b/libfio.c
index d4cad3e..09591a1 100644
--- a/libfio.c
+++ b/libfio.c
@@ -77,21 +77,24 @@ static const char *fio_arch_strings[arch_nr] = {
 	"generic"
 };
 
-static void reset_io_counters(struct thread_data *td)
+static void reset_io_counters(struct thread_data *td, int all)
 {
 	int ddir;
 
-	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
-		td->stat_io_bytes[ddir] = 0;
-		td->this_io_bytes[ddir] = 0;
-		td->stat_io_blocks[ddir] = 0;
-		td->this_io_blocks[ddir] = 0;
-		td->rate_bytes[ddir] = 0;
-		td->rate_blocks[ddir] = 0;
-		td->bytes_done[ddir] = 0;
-		td->rate_io_issue_bytes[ddir] = 0;
-		td->rate_next_io_time[ddir] = 0;
+	if (all) {
+		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
+			td->stat_io_bytes[ddir] = 0;
+			td->this_io_bytes[ddir] = 0;
+			td->stat_io_blocks[ddir] = 0;
+			td->this_io_blocks[ddir] = 0;
+			td->rate_bytes[ddir] = 0;
+			td->rate_blocks[ddir] = 0;
+			td->bytes_done[ddir] = 0;
+			td->rate_io_issue_bytes[ddir] = 0;
+			td->rate_next_io_time[ddir] = 0;
+		}
 	}
+
 	td->zone_bytes = 0;
 
 	td->last_was_sync = 0;
@@ -104,12 +107,12 @@ static void reset_io_counters(struct thread_data *td)
 		td->nr_done_files = 0;
 }
 
-void clear_io_state(struct thread_data *td)
+void clear_io_state(struct thread_data *td, int all)
 {
 	struct fio_file *f;
 	unsigned int i;
 
-	reset_io_counters(td);
+	reset_io_counters(td, all);
 
 	close_files(td);
 	for_each_file(td, f, i) {
@@ -129,7 +132,7 @@ void reset_all_stats(struct thread_data *td)
 	struct timeval tv;
 	int i;
 
-	reset_io_counters(td);
+	reset_io_counters(td, 1);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		td->io_bytes[i] = 0;
diff --git a/memory.c b/memory.c
index 23a0d94..5060223 100644
--- a/memory.c
+++ b/memory.c
@@ -146,12 +146,14 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 			return 1;
 		}
 		if (td->o.mem_type != MEM_MMAPHUGE &&
+		    td->o.mem_type != MEM_MMAPSHARED &&
 		    ftruncate(td->mmapfd, total_mem) < 0) {
 			td_verror(td, errno, "truncate mmap file");
 			td->orig_buffer = NULL;
 			return 1;
 		}
-		if (td->o.mem_type == MEM_MMAPHUGE)
+		if (td->o.mem_type == MEM_MMAPHUGE ||
+		    td->o.mem_type == MEM_MMAPSHARED)
 			flags |= MAP_SHARED;
 		else
 			flags |= MAP_PRIVATE;
@@ -231,7 +233,8 @@ int allocate_io_mem(struct thread_data *td)
 		ret = alloc_mem_malloc(td, total_mem);
 	else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
 		ret = alloc_mem_shm(td, total_mem);
-	else if (td->o.mem_type == MEM_MMAP || td->o.mem_type == MEM_MMAPHUGE)
+	else if (td->o.mem_type == MEM_MMAP || td->o.mem_type == MEM_MMAPHUGE ||
+		 td->o.mem_type == MEM_MMAPSHARED)
 		ret = alloc_mem_mmap(td, total_mem);
 	else {
 		log_err("fio: bad mem type: %d\n", td->o.mem_type);
@@ -256,7 +259,8 @@ void free_io_mem(struct thread_data *td)
 		free_mem_malloc(td);
 	else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
 		free_mem_shm(td);
-	else if (td->o.mem_type == MEM_MMAP || td->o.mem_type == MEM_MMAPHUGE)
+	else if (td->o.mem_type == MEM_MMAP || td->o.mem_type == MEM_MMAPHUGE ||
+		 td->o.mem_type == MEM_MMAPSHARED)
 		free_mem_mmap(td, total_mem);
 	else
 		log_err("Bad memory type %u\n", td->o.mem_type);
diff --git a/options.c b/options.c
index 0169ca2..5584413 100644
--- a/options.c
+++ b/options.c
@@ -351,7 +351,8 @@ static int str_mem_cb(void *data, const char *mem)
 {
 	struct thread_data *td = data;
 
-	if (td->o.mem_type == MEM_MMAPHUGE || td->o.mem_type == MEM_MMAP)
+	if (td->o.mem_type == MEM_MMAPHUGE || td->o.mem_type == MEM_MMAP ||
+	    td->o.mem_type == MEM_MMAPSHARED)
 		td->o.mmapfile = get_opt_postfix(mem);
 
 	return 0;
@@ -2228,6 +2229,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = MEM_MMAP,
 			    .help = "Use mmap(2) (file or anon) for IO buffers",
 			  },
+			  { .ival = "mmapshared",
+			    .oval = MEM_MMAPSHARED,
+			    .help = "Like mmap, but use the shared flag",
+			  },
 #ifdef FIO_HAVE_HUGETLB
 			  { .ival = "mmaphuge",
 			    .oval = MEM_MMAPHUGE,
diff --git a/stat.c b/stat.c
index 2a65fed..091d6fb 100644
--- a/stat.c
+++ b/stat.c
@@ -1173,7 +1173,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 
 		if (len) {
 			struct json_object *block, *percentile_object, *states;
-			int state, i;
+			int state;
 			block = json_create_object();
 			json_object_add_value_object(root, "block", block);
 
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index d0b7e09..04b6abe 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -937,14 +937,14 @@ static int merge_entries(struct btrace_pid *pida, struct btrace_pid *pidb)
 	return 1;
 }
 
-static void check_merges(struct btrace_pid *p, struct flist_head *pid_list)
+static void check_merges(struct btrace_pid *p, struct flist_head *pidlist)
 {
 	struct flist_head *e, *tmp;
 
 	if (p->ignore)
 		return;
 
-	flist_for_each_safe(e, tmp, pid_list) {
+	flist_for_each_safe(e, tmp, pidlist) {
 		struct btrace_pid *pidb;
 
 		pidb = flist_entry(e, struct btrace_pid, pid_list);
diff --git a/thread_options.h b/thread_options.h
index 5ef560e..ed960ee 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -19,6 +19,7 @@ enum fio_memtype {
 	MEM_SHMHUGE,	/* use shared memory segments with huge pages */
 	MEM_MMAP,	/* use anonynomous mmap */
 	MEM_MMAPHUGE,	/* memory mapped huge file */
+	MEM_MMAPSHARED, /* use mmap with shared flag */
 };
 
 #define ERROR_STR_MAX	128
diff --git a/workqueue.c b/workqueue.c
index 60e6ab2..7a69be2 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -186,7 +186,7 @@ static int init_submit_worker(struct submit_worker *sw)
 
 	fio_gettime(&td->epoch, NULL);
 	fio_getrusage(&td->ru_start);
-	clear_io_state(td);
+	clear_io_state(td, 1);
 
 	td_set_runstate(td, TD_RUNNING);
 	td->flags |= TD_F_CHILD;
