Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58043 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619AbaDBMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Apr 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WVJpt-0001LE-5j
	for fio@vger.kernel.org; Wed, 02 Apr 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140402120003.C3964400AB@strynoevaenget.dk>
Date: Wed,  2 Apr 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f42557f8ba1fc6bbf6b5fce4ae3a53cfc8bbb35b:

  Fio 2.1.7 (2014-03-31 09:05:54 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 10aa136bddbaa7c845ab4eacb4a9a4a88d6657a3:

  Cleanup symbols that should be static (2014-04-01 21:10:36 -0600)

----------------------------------------------------------------
Andrey Kuzmin (1):
      Fix bug in freeing of duplicated files

Jens Axboe (6):
      Properly initialize shadow_fd to -1
      Properly protect already-allocated file list
      Ensure we inherit global latency/bw log settings
      Add alloc_new_file()
      File pre-read lseek error check
      Cleanup symbols that should be static

 cconv.c             |    2 +-
 crc/crc32c.c        |    2 +
 crc/xxhash.c        |   10 ++---
 diskutil.c          |    4 +-
 engines/falloc.c    |    2 +-
 engines/net.c       |    2 +-
 engines/rbd.c       |    2 +-
 filehash.c          |   11 +++++
 filehash.h          |    2 +
 filesetup.c         |  120 +++++++++++++++++++++++++++++++++------------------
 gettime.c           |    2 +-
 idletime.c          |    2 +-
 init.c              |   25 +++++------
 lib/lfsr.c          |    2 +-
 lib/num2str.c       |    2 +
 lib/prio_tree.c     |    2 +-
 log.c               |   19 --------
 profiles/tiobench.c |    2 +-
 smalloc.c           |    3 +-
 stat.c              |    5 ++-
 20 files changed, 129 insertions(+), 92 deletions(-)

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index 2843a71..5b9c3be 100644
--- a/cconv.c
+++ b/cconv.c
@@ -18,7 +18,7 @@ static void string_to_net(uint8_t *dst, const char *src)
 		dst[0] = '\0';
 }
 
-void free_thread_options_to_cpu(struct thread_options *o)
+static void free_thread_options_to_cpu(struct thread_options *o)
 {
 	free(o->description);
 	free(o->name);
diff --git a/crc/crc32c.c b/crc/crc32c.c
index b830b9f..f6fc688 100644
--- a/crc/crc32c.c
+++ b/crc/crc32c.c
@@ -32,6 +32,8 @@
  */
 #include <inttypes.h>
 
+#include "crc32c.h"
+
 /*
  * This is the CRC-32C table
  * Generated with:
diff --git a/crc/xxhash.c b/crc/xxhash.c
index db7890b..eedaecb 100644
--- a/crc/xxhash.c
+++ b/crc/xxhash.c
@@ -148,7 +148,7 @@ typedef enum { XXH_bigEndian=0, XXH_littleEndian=1 } XXH_endianess;
 //****************************
 typedef enum { XXH_aligned, XXH_unaligned } XXH_alignment;
 
-uint32_t XXH_readLE32_align(const uint32_t* ptr, XXH_endianess endian, XXH_alignment align)
+static uint32_t XXH_readLE32_align(const uint32_t* ptr, XXH_endianess endian, XXH_alignment align)
 {
     if (align==XXH_unaligned)
         return endian==XXH_littleEndian ? A32(ptr) : XXH_swap32(A32(ptr));
@@ -156,13 +156,13 @@ uint32_t XXH_readLE32_align(const uint32_t* ptr, XXH_endianess endian, XXH_align
         return endian==XXH_littleEndian ? *ptr : XXH_swap32(*ptr);
 }
 
-uint32_t XXH_readLE32(const uint32_t* ptr, XXH_endianess endian) { return XXH_readLE32_align(ptr, endian, XXH_unaligned); }
+static uint32_t XXH_readLE32(const uint32_t* ptr, XXH_endianess endian) { return XXH_readLE32_align(ptr, endian, XXH_unaligned); }
 
 
 //****************************
 // Simple Hash Functions
 //****************************
-uint32_t XXH32_endian_align(const void* input, int len, uint32_t seed, XXH_endianess endian, XXH_alignment align)
+static uint32_t XXH32_endian_align(const void* input, int len, uint32_t seed, XXH_endianess endian, XXH_alignment align)
 {
     const uint8_t *p = (const uint8_t *)input;
     const uint8_t * const bEnd = p + len;
@@ -282,7 +282,7 @@ void* XXH32_init (uint32_t seed)
 }
 
 
-XXH_errorcode XXH32_update_endian (void* state_in, const void* input, int len, XXH_endianess endian)
+static XXH_errorcode XXH32_update_endian (void* state_in, const void* input, int len, XXH_endianess endian)
 {
     struct XXH_state32_t * state = (struct XXH_state32_t *) state_in;
     const uint8_t *p = (const uint8_t *)input;
@@ -358,7 +358,7 @@ XXH_errorcode XXH32_update (void* state_in, const void* input, int len)
 
 
 
-uint32_t XXH32_intermediateDigest_endian (void* state_in, XXH_endianess endian)
+static uint32_t XXH32_intermediateDigest_endian (void* state_in, XXH_endianess endian)
 {
     struct XXH_state32_t * state = (struct XXH_state32_t *) state_in;
     const uint8_t *p = (const uint8_t *)state->memory;
diff --git a/diskutil.c b/diskutil.c
index bc12b02..9aa1fa1 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -652,8 +652,8 @@ void json_array_add_disk_util(struct disk_util_stat *dus,
 	json_object_add_value_float(obj, "aggr_util", agg->max_util.u.f);
 }
 
-void json_object_add_disk_utils(struct json_object *obj,
-		struct flist_head *head)
+static void json_object_add_disk_utils(struct json_object *obj,
+				       struct flist_head *head)
 {
 	struct json_array *array = json_create_array();
 	struct flist_head *entry;
diff --git a/engines/falloc.c b/engines/falloc.c
index 17a901a..2b00d52 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -23,7 +23,7 @@
  * generic_open_file is not appropriate because does not allow to perform
  * TRIM in to file
  */
-int open_file(struct thread_data *td, struct fio_file *f)
+static int open_file(struct thread_data *td, struct fio_file *f)
 {
 	int from_hash = 0;
 
diff --git a/engines/net.c b/engines/net.c
index 1df8d06..110e158 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -392,7 +392,7 @@ static int fio_netio_send(struct thread_data *td, struct io_u *io_u)
 
 	do {
 		if (is_udp(o)) {
-			struct sockaddr *to;
+			const struct sockaddr *to;
 			socklen_t len;
 
 			if (is_ipv6(o)) {
diff --git a/engines/rbd.c b/engines/rbd.c
index 5a4a3e2..9d64efd 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -422,7 +422,7 @@ static int fio_rbd_io_u_init(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
-struct ioengine_ops ioengine = {
+static struct ioengine_ops ioengine = {
 	.name               = "rbd",
 	.version            = FIO_IOOPS_VERSION,
 	.setup              = fio_rbd_setup,
diff --git a/filehash.c b/filehash.c
index 392464e..c6ebe76 100644
--- a/filehash.c
+++ b/filehash.c
@@ -4,6 +4,7 @@
 #include "fio.h"
 #include "flist.h"
 #include "hash.h"
+#include "filehash.h"
 
 #define HASH_BUCKETS	512
 #define HASH_MASK	(HASH_BUCKETS - 1)
@@ -18,6 +19,16 @@ static unsigned short hash(const char *name)
 	return jhash(name, strlen(name), 0) & HASH_MASK;
 }
 
+void fio_file_hash_lock(void)
+{
+	fio_mutex_down(hash_lock);
+}
+
+void fio_file_hash_unlock(void)
+{
+	fio_mutex_up(hash_lock);
+}
+
 void remove_file_hash(struct fio_file *f)
 {
 	fio_mutex_down(hash_lock);
diff --git a/filehash.h b/filehash.h
index 993943a..f316b20 100644
--- a/filehash.h
+++ b/filehash.h
@@ -8,5 +8,7 @@ extern void file_hash_exit(void);
 extern struct fio_file *lookup_file_hash(const char *);
 extern struct fio_file *add_file_hash(struct fio_file *);
 extern void remove_file_hash(struct fio_file *);
+extern void fio_file_hash_lock(void);
+extern void fio_file_hash_unlock(void);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index db80a8b..fa09219 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -194,7 +194,7 @@ err:
 
 static int pre_read_file(struct thread_data *td, struct fio_file *f)
 {
-	int r, did_open = 0, old_runstate;
+	int ret = 0, r, did_open = 0, old_runstate;
 	unsigned long long left;
 	unsigned int bs;
 	char *b;
@@ -216,7 +216,13 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 	b = malloc(bs);
 	memset(b, 0, bs);
 
-	lseek(f->fd, f->file_offset, SEEK_SET);
+	if (lseek(f->fd, f->file_offset, SEEK_SET) < 0) {
+		td_verror(td, errno, "lseek");
+		log_err("fio: failed to lseek pre-read file\n");
+		ret = 1;
+		goto error;
+	}
+
 	left = f->io_size;
 
 	while (left && !td->terminate) {
@@ -234,12 +240,14 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
+error:
 	td_restore_runstate(td, old_runstate);
 
 	if (did_open)
 		td->io_ops->close_file(td, f);
+
 	free(b);
-	return 0;
+	return ret;
 }
 
 static unsigned long long get_rand_file_size(struct thread_data *td)
@@ -1109,47 +1117,89 @@ static void get_file_type(struct fio_file *f)
 	}
 }
 
-static void set_already_allocated(const char *fname)
+static int __is_already_allocated(const char *fname)
 {
-	struct file_name *fn;
+	struct flist_head *entry;
+	char *filename;
 
-	fn = malloc(sizeof(struct file_name));
-	fn->filename = strdup(fname);
-	flist_add_tail(&fn->list, &filename_list);
+	if (flist_empty(&filename_list))
+		return 0;
+
+	flist_for_each(entry, &filename_list) {
+		filename = flist_entry(entry, struct file_name, list)->filename;
+
+		if (strcmp(filename, fname) == 0)
+			return 1;
+	}
+
+	return 0;
 }
 
 static int is_already_allocated(const char *fname)
 {
-	struct flist_head *entry;
-	char *filename;
+	int ret;
 
-	if (!flist_empty(&filename_list))
-	{
-		flist_for_each(entry, &filename_list) {
-			filename = flist_entry(entry, struct file_name, list)->filename;
+	fio_file_hash_lock();
+	ret = __is_already_allocated(fname);
+	fio_file_hash_unlock();
+	return ret;
+}
 
-			if (strcmp(filename, fname) == 0)
-				return 1;
-		}
+static void set_already_allocated(const char *fname)
+{
+	struct file_name *fn;
+
+	fn = malloc(sizeof(struct file_name));
+	fn->filename = strdup(fname);
+
+	fio_file_hash_lock();
+	if (!__is_already_allocated(fname)) {
+		flist_add_tail(&fn->list, &filename_list);
+		fn = NULL;
 	}
+	fio_file_hash_unlock();
 
-	return 0;
+	if (fn) {
+		free(fn->filename);
+		free(fn);
+	}
 }
 
+
 static void free_already_allocated(void)
 {
 	struct flist_head *entry, *tmp;
 	struct file_name *fn;
 
-	if (!flist_empty(&filename_list))
-	{
-		flist_for_each_safe(entry, tmp, &filename_list) {
-			fn = flist_entry(entry, struct file_name, list);
-			free(fn->filename);
-			flist_del(&fn->list);
-			free(fn);
-		}
+	if (flist_empty(&filename_list))
+		return;
+
+	fio_file_hash_lock();
+	flist_for_each_safe(entry, tmp, &filename_list) {
+		fn = flist_entry(entry, struct file_name, list);
+		free(fn->filename);
+		flist_del(&fn->list);
+		free(fn);
 	}
+
+	fio_file_hash_unlock();
+}
+
+static struct fio_file *alloc_new_file(struct thread_data *td)
+{
+	struct fio_file *f;
+
+	f = smalloc(sizeof(*f));
+	if (!f) {
+		log_err("fio: smalloc OOM\n");
+		assert(0);
+		return NULL;
+	}
+
+	f->fd = -1;
+	f->shadow_fd = -1;
+	fio_file_reset(td, f);
+	return f;
 }
 
 int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
@@ -1170,15 +1220,7 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	if (numjob && is_already_allocated(file_name))
 		return 0;
 
-	f = smalloc(sizeof(*f));
-	if (!f) {
-		log_err("fio: smalloc OOM\n");
-		assert(0);
-	}
-
-	f->fd = -1;
-	f->shadow_fd = -1;
-	fio_file_reset(td, f);
+	f = alloc_new_file(td);
 
 	if (td->files_size <= td->files_index) {
 		unsigned int new_size = td->o.nr_files + 1;
@@ -1415,13 +1457,7 @@ void dup_files(struct thread_data *td, struct thread_data *org)
 	for_each_file(org, f, i) {
 		struct fio_file *__f;
 
-		__f = smalloc(sizeof(*__f));
-		if (!__f) {
-			log_err("fio: smalloc OOM\n");
-			assert(0);
-		}
-		__f->fd = -1;
-		fio_file_reset(td, __f);
+		__f = alloc_new_file(td);
 
 		if (f->file_name) {
 			__f->file_name = smalloc_strdup(f->file_name);
diff --git a/gettime.c b/gettime.c
index 8991703..b89cd46 100644
--- a/gettime.c
+++ b/gettime.c
@@ -32,7 +32,7 @@ static pthread_key_t tv_tls_key;
 
 enum fio_cs fio_clock_source = FIO_PREFERRED_CLOCK_SOURCE;
 int fio_clock_source_set = 0;
-enum fio_cs fio_clock_source_inited = CS_INVAL;
+static enum fio_cs fio_clock_source_inited = CS_INVAL;
 
 #ifdef FIO_DEBUG_TIME
 
diff --git a/idletime.c b/idletime.c
index 9e69607..c0bc0bf 100644
--- a/idletime.c
+++ b/idletime.c
@@ -379,7 +379,7 @@ static double fio_idle_prof_cpu_stat(int cpu)
 	return p * 100.0;
 }
 
-void fio_idle_prof_cleanup(void)
+static void fio_idle_prof_cleanup(void)
 {
 	if (ipc.ipts) {
 		free(ipc.ipts);
diff --git a/init.c b/init.c
index adb9066..c3996a7 100644
--- a/init.c
+++ b/init.c
@@ -28,6 +28,8 @@
 #include "lib/getopt.h"
 #include "lib/strcasestr.h"
 
+#include "crc/test.h"
+
 const char fio_version_string[] = FIO_VERSION;
 
 #define FIO_RANDSEED		(0xb1899bedUL)
@@ -40,6 +42,8 @@ static int parse_only;
 
 static struct thread_data def_thread;
 struct thread_data *threads = NULL;
+static char **job_sections;
+static int nr_job_sections;
 
 int exitall_on_terminate = 0;
 int output_format = FIO_OUTPUT_NORMAL;
@@ -48,8 +52,6 @@ int eta_print = FIO_ETA_AUTO;
 int eta_new_line = 0;
 FILE *f_out = NULL;
 FILE *f_err = NULL;
-char **job_sections = NULL;
-int nr_job_sections = 0;
 char *exec_profile = NULL;
 int warnings_fatal = 0;
 int terse_version = 3;
@@ -247,7 +249,7 @@ void free_threads_shm(void)
 	}
 }
 
-void free_shm(void)
+static void free_shm(void)
 {
 	if (threads) {
 		file_hash_exit();
@@ -1087,12 +1089,12 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (setup_rate(td))
 		goto err;
 
-	if (o->lat_log_file) {
+	if (o->lat_log_file || write_lat_log) {
 		setup_log(&td->lat_log, o->log_avg_msec, IO_LOG_TYPE_LAT);
 		setup_log(&td->slat_log, o->log_avg_msec, IO_LOG_TYPE_SLAT);
 		setup_log(&td->clat_log, o->log_avg_msec, IO_LOG_TYPE_CLAT);
 	}
-	if (o->bw_log_file)
+	if (o->bw_log_file || write_bw_log)
 		setup_log(&td->bw_log, o->log_avg_msec, IO_LOG_TYPE_BW);
 	if (o->iops_log_file)
 		setup_log(&td->iops_log, o->log_avg_msec, IO_LOG_TYPE_IOPS);
@@ -1160,17 +1162,18 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td_new->o.new_group = 0;
 
 		if (file_alloced) {
-			td_new->files_index = 0;
-			td_new->files_size = 0;
 			if (td_new->files) {
 				struct fio_file *f;
 				for_each_file(td_new, f, i) {
 					if (f->file_name)
-						free(f->file_name);
-					free(f);
+						sfree(f->file_name);
+					sfree(f);
 				}
+				free(td_new->files);
 				td_new->files = NULL;
 			}
+			td_new->files_index = 0;
+			td_new->files_size = 0;
 			if (td_new->o.filename) {
 				free(td_new->o.filename);
 				td_new->o.filename = NULL;
@@ -1657,13 +1660,11 @@ static int client_flag_set(char c)
 	return 0;
 }
 
-void parse_cmd_client(void *client, char *opt)
+static void parse_cmd_client(void *client, char *opt)
 {
 	fio_client_add_cmd_option(client, opt);
 }
 
-extern int fio_crctest(const char *);
-
 int parse_cmd_line(int argc, char *argv[], int client_type)
 {
 	struct thread_data *td = NULL;
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 9771318..329ef85 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -186,7 +186,7 @@ static uint8_t *find_lfsr(uint64_t size)
  * Thus, [1] is equivalent to (y * i) % (spin + 1) == 0;
  * Also, the cycle's length will be (x * i) + (y * i) / (spin + 1)
  */
-int prepare_spin(struct fio_lfsr *fl, unsigned int spin)
+static int prepare_spin(struct fio_lfsr *fl, unsigned int spin)
 {
 	uint64_t max = (fl->cached_bit << 1) - 1;
 	uint64_t x, y;
diff --git a/lib/num2str.c b/lib/num2str.c
index a104192..12d6f39 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -2,6 +2,8 @@
 #include <stdio.h>
 #include <string.h>
 
+#include "../fio.h"
+
 /*
  * Cheesy number->string conversion, complete with carry rounding error.
  */
diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index b0e935c..e18ae32 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -49,7 +49,7 @@ static void get_index(const struct prio_tree_node *node,
 
 static unsigned long index_bits_to_maxindex[BITS_PER_LONG];
 
-void fio_init prio_tree_init(void)
+static void fio_init prio_tree_init(void)
 {
 	unsigned int i;
 
diff --git a/log.c b/log.c
index a05a7ec..c4a3b52 100644
--- a/log.c
+++ b/log.c
@@ -34,25 +34,6 @@ int log_local_buf(const char *buf, size_t len)
 	return len;
 }
 
-int log_local(const char *format, ...)
-{
-	char buffer[1024];
-	va_list args;
-	size_t len;
-
-	va_start(args, format);
-	len = vsnprintf(buffer, sizeof(buffer), format, args);
-	va_end(args);
-	len = min(len, sizeof(buffer) - 1);
-
-	if (log_syslog)
-		syslog(LOG_INFO, "%s", buffer);
-	else
-		len = fwrite(buffer, len, 1, f_out);
-
-	return len;
-}
-
 int log_info(const char *format, ...)
 {
 	char buffer[1024];
diff --git a/profiles/tiobench.c b/profiles/tiobench.c
index 7a7030a..b4331d7 100644
--- a/profiles/tiobench.c
+++ b/profiles/tiobench.c
@@ -8,7 +8,7 @@ static unsigned int bs = 4096;
 static unsigned int nthreads = 1;
 static char *dir;
 
-char sz_idx[80], bs_idx[80], loop_idx[80], dir_idx[80], t_idx[80];
+static char sz_idx[80], bs_idx[80], loop_idx[80], dir_idx[80], t_idx[80];
 
 static const char *tb_opts[] = {
 	"buffered=0", sz_idx, bs_idx, loop_idx, dir_idx, t_idx,
diff --git a/smalloc.c b/smalloc.c
index 5dae7e7..c8f1642 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -16,6 +16,7 @@
 #include "mutex.h"
 #include "arch/arch.h"
 #include "os/os.h"
+#include "smalloc.h"
 
 #define SMALLOC_REDZONE		/* define to detect memory corruption */
 
@@ -30,7 +31,7 @@
 #define SMALLOC_POST_RED	0x5aa55aa5U
 
 unsigned int smalloc_pool_size = INITIAL_SIZE;
-const int int_mask = sizeof(int) - 1;
+static const int int_mask = sizeof(int) - 1;
 
 struct pool {
 	struct fio_mutex *lock;			/* protects this pool */
diff --git a/stat.c b/stat.c
index f84ce53..4529f69 100644
--- a/stat.c
+++ b/stat.c
@@ -497,7 +497,8 @@ static void show_latencies(struct thread_stat *ts)
 	show_lat_m(io_u_lat_m);
 }
 
-void show_thread_status_normal(struct thread_stat *ts, struct group_run_stats *rs)
+static void show_thread_status_normal(struct thread_stat *ts,
+				      struct group_run_stats *rs)
 {
 	double usr_cpu, sys_cpu;
 	unsigned long runtime;
@@ -1012,7 +1013,7 @@ struct json_object *show_thread_status(struct thread_stat *ts,
 	if (output_format == FIO_OUTPUT_TERSE)
 		show_thread_status_terse(ts, rs);
 	else if (output_format == FIO_OUTPUT_JSON)
-		return(show_thread_status_json(ts, rs));
+		return show_thread_status_json(ts, rs);
 	else
 		show_thread_status_normal(ts, rs);
 	return NULL;
