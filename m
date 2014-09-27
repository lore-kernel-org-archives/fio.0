Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaI0MAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 27 Sep 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XXqfV-0005iK-Gr
	for fio@vger.kernel.org; Sat, 27 Sep 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140927120003.17799401E7@lyth.info>
Date: Sat, 27 Sep 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b5b571a3f01c17ddb39fd0306cb425a11e216f3d:

  Fix compile for FIO_INC_DEBUG not set (2014-09-24 09:54:24 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1066358aebafb7221732bedd6fb9fde56b14be7b:

  Improve dedupe/compression buffer filling for mixed block sizes (2014-09-26 15:04:58 -0600)

----------------------------------------------------------------
Andrey Kuzmin (2):
      Add ability to use an include file in a fio job file
      Add HOWTO section on include files

Jens Axboe (10):
      Add bloom filter
      dedupe: default to using a bloom filter to save memory
      Add debug helper stub for t/ programs
      t/lfsr-test: fixup time
      dedupe: fix warning and segfault on -B0
      dedupe: read in larger chunks at the time
      bloom: always use a larger minimum size for bloom filter
      Clarify that include files may not contain job sections
      bloom: use independent hashes
      Improve dedupe/compression buffer filling for mixed block sizes

 HOWTO         |   35 +++++++++++++
 Makefile      |    9 ++--
 crc/xxhash.c  |    2 +-
 crc/xxhash.h  |    2 +-
 fio_time.h    |    1 +
 init.c        |  162 +++++++++++++++++++++++++++++++++++++++------------------
 io_u.c        |   32 +++++++-----
 lib/bloom.c   |  107 +++++++++++++++++++++++++++++++++++++
 lib/bloom.h   |   13 +++++
 t/debug.c     |   14 +++++
 t/debug.h     |    6 +++
 t/dedupe.c    |  150 ++++++++++++++++++++++++++++++++++++----------------
 t/lfsr-test.c |   13 ++---
 t/stest.c     |   12 +----
 14 files changed, 430 insertions(+), 128 deletions(-)
 create mode 100644 lib/bloom.c
 create mode 100644 lib/bloom.h
 create mode 100644 t/debug.c
 create mode 100644 t/debug.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 23746ce..aaa46f8 100644
--- a/HOWTO
+++ b/HOWTO
@@ -159,6 +159,41 @@ specify:
 
 $ fio --name=random-writers --ioengine=libaio --iodepth=4 --rw=randwrite --bs=32k --direct=0 --size=64m --numjobs=4
 
+When fio is utilized as a basis of any reasonably large test suite, it might be
+desirable to share a set of standardized settings across multiple job files.
+Instead of copy/pasting such settings, any section may pull in an external
+.fio file with 'include filename' directive, as in the following example:
+
+; -- start job file including.fio --
+[global]
+filename=/tmp/test
+filesize=1m
+include glob-include.fio
+
+[test]
+rw=randread
+bs=4k
+time_based=1
+runtime=10
+include test-include.fio
+; -- end job file including.fio --
+
+; -- start job file glob-include.fio --
+thread=1
+group_reporting=1
+; -- end job file glob-include.fio --
+
+; -- start job file test-include.fio --
+ioengine=libaio
+iodepth=4
+; -- end job file test-include.fio --
+
+Settings pulled into a section apply to that section only (except global
+section). Include directives may be nested in that any included file may
+contain further include directive(s). Include files may not contain []
+sections.
+
+
 4.1 Environment variables
 -------------------------
 
diff --git a/Makefile b/Makefile
index fe439c1..8c424e3 100644
--- a/Makefile
+++ b/Makefile
@@ -36,7 +36,7 @@ SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		lib/tp.c
+		lib/tp.c lib/bloom.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
@@ -164,7 +164,7 @@ GFIO_OBJS = $(OBJS) gfio.o graph.o tickmarks.o ghelpers.o goptions.o gerror.o \
 -include $(OBJS:.o=.d)
 
 T_SMALLOC_OBJS = t/stest.o
-T_SMALLOC_OBJS += gettime.o mutex.o smalloc.o t/log.o
+T_SMALLOC_OBJS += gettime.o mutex.o smalloc.o t/log.o t/debug.o
 T_SMALLOC_PROGS = t/stest
 
 T_IEEE_OBJS = t/ieee754.o
@@ -180,7 +180,7 @@ T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o
 T_AXMAP_PROGS = t/axmap
 
 T_LFSR_TEST_OBJS = t/lfsr-test.o
-T_LFSR_TEST_OBJS += lib/lfsr.o
+T_LFSR_TEST_OBJS += lib/lfsr.o gettime.o t/log.o t/debug.o
 T_LFSR_TEST_PROGS = t/lfsr-test
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
@@ -192,7 +192,8 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
 T_DEDUPE_OBJS = t/dedupe.o
 T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
-		memalign.o
+		memalign.o lib/bloom.o t/debug.o crc/xxhash.o crc/crc32c.o \
+		crc/crc32c-intel.o
 T_DEDUPE_PROGS = t/dedupe
 endif
 
diff --git a/crc/xxhash.c b/crc/xxhash.c
index eedaecb..4736c52 100644
--- a/crc/xxhash.c
+++ b/crc/xxhash.c
@@ -221,7 +221,7 @@ static uint32_t XXH32_endian_align(const void* input, int len, uint32_t seed, XX
 }
 
 
-uint32_t XXH32(const void* input, int len, uint32_t seed)
+uint32_t XXH32(const void* input, uint32_t len, uint32_t seed)
 {
 #if 0
     // Simple version, good for code maintenance, but unfortunately slow for small inputs
diff --git a/crc/xxhash.h b/crc/xxhash.h
index e80a91d..8850d20 100644
--- a/crc/xxhash.h
+++ b/crc/xxhash.h
@@ -88,7 +88,7 @@ typedef enum { XXH_OK=0, XXH_ERROR } XXH_errorcode;
 // Simple Hash Functions
 //****************************
 
-unsigned int XXH32 (const void* input, int len, unsigned int seed);
+uint32_t XXH32 (const void* input, uint32_t len, uint32_t seed);
 
 /*
 XXH32() :
diff --git a/fio_time.h b/fio_time.h
index c550a55..9f7d209 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -1,6 +1,7 @@
 #ifndef FIO_TIME_H
 #define FIO_TIME_H
 
+struct thread_data;
 extern uint64_t utime_since(struct timeval *, struct timeval *);
 extern uint64_t utime_since_now(struct timeval *);
 extern uint64_t mtime_since(struct timeval *, struct timeval *);
diff --git a/init.c b/init.c
index 5b0290d..e208451 100644
--- a/init.c
+++ b/init.c
@@ -1397,11 +1397,12 @@ static int is_empty_or_comment(char *line)
 /*
  * This is our [ini] type file parser.
  */
-int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
+int __parse_jobs_ini(struct thread_data *td,
+		char *file, int is_buf, int stonewall_flag, int type,
+		int nested, char *name, char ***popts, int *aopts, int *nopts)
 {
-	unsigned int global;
-	struct thread_data *td;
-	char *string, *name;
+	unsigned int global = 0;
+	char *string;
 	FILE *f;
 	char *p;
 	int ret = 0, stonewall;
@@ -1411,6 +1412,9 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 	char **opts;
 	int i, alloc_opts, num_opts;
 
+	dprint(FD_PARSE, "Parsing ini file %s\n", file);
+	assert(td || !nested);
+
 	if (is_buf)
 		f = NULL;
 	else {
@@ -1430,12 +1434,23 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 	/*
 	 * it's really 256 + small bit, 280 should suffice
 	 */
-	name = malloc(280);
-	memset(name, 0, 280);
+	if (!nested) {
+		name = malloc(280);
+		memset(name, 0, 280);
+	}
 
-	alloc_opts = 8;
-	opts = malloc(sizeof(char *) * alloc_opts);
-	num_opts = 0;
+	opts = NULL;
+	if (nested && popts) {
+		opts = *popts;
+		alloc_opts = *aopts;
+		num_opts = *nopts;
+	}
+
+	if (!opts) {
+		alloc_opts = 8;
+		opts = malloc(sizeof(char *) * alloc_opts);
+		num_opts = 0;
+	}
 
 	stonewall = stonewall_flag;
 	do {
@@ -1456,58 +1471,72 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 		strip_blank_front(&p);
 		strip_blank_end(p);
 
+		dprint(FD_PARSE, "%s\n", p);
 		if (is_empty_or_comment(p))
 			continue;
-		if (sscanf(p, "[%255[^\n]]", name) != 1) {
-			if (inside_skip)
+
+		if (!nested) {
+			if (sscanf(p, "[%255[^\n]]", name) != 1) {
+				if (inside_skip)
+					continue;
+
+				log_err("fio: option <%s> outside of "
+					"[] job section\n", p);
+				break;
+			}
+
+			name[strlen(name) - 1] = '\0';
+
+			if (skip_this_section(name)) {
+				inside_skip = 1;
 				continue;
-			log_err("fio: option <%s> outside of [] job section\n",
-									p);
-			break;
-		}
+			} else
+				inside_skip = 0;
 
-		name[strlen(name) - 1] = '\0';
+			dprint(FD_PARSE, "Parsing section [%s]\n", name);
 
-		if (skip_this_section(name)) {
-			inside_skip = 1;
-			continue;
-		} else
-			inside_skip = 0;
+			global = !strncmp(name, "global", 6);
 
-		global = !strncmp(name, "global", 6);
+			if (dump_cmdline) {
+				if (first_sect)
+					log_info("fio ");
+				if (!global)
+					log_info("--name=%s ", name);
+				first_sect = 0;
+			}
 
-		if (dump_cmdline) {
-			if (first_sect)
-				log_info("fio ");
-			if (!global)
-				log_info("--name=%s ", name);
-			first_sect = 0;
-		}
+			td = get_new_job(global, &def_thread, 0, name);
+			if (!td) {
+				ret = 1;
+				break;
+			}
 
-		td = get_new_job(global, &def_thread, 0, name);
-		if (!td) {
-			ret = 1;
-			break;
-		}
+			/*
+			 * Separate multiple job files by a stonewall
+			 */
+			if (!global && stonewall) {
+				td->o.stonewall = stonewall;
+				stonewall = 0;
+			}
 
-		/*
-		 * Separate multiple job files by a stonewall
-		 */
-		if (!global && stonewall) {
-			td->o.stonewall = stonewall;
-			stonewall = 0;
+			num_opts = 0;
+			memset(opts, 0, alloc_opts * sizeof(char *));
 		}
-
-		num_opts = 0;
-		memset(opts, 0, alloc_opts * sizeof(char *));
+		else
+			skip_fgets = 1;
 
 		while (1) {
-			if (is_buf)
-				p = strsep(&file, "\n");
+			if (!skip_fgets) {
+				if (is_buf)
+					p = strsep(&file, "\n");
+				else
+					p = fgets(string, 4096, f);
+				if (!p)
+					break;
+				dprint(FD_PARSE, "%s", p);
+			}
 			else
-				p = fgets(string, 4096, f);
-			if (!p)
-				break;
+				skip_fgets = 0;
 
 			if (is_empty_or_comment(p))
 				continue;
@@ -1519,12 +1548,30 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 			 * fgets() a new line at the top.
 			 */
 			if (p[0] == '[') {
+				if (nested) {
+					log_err("No new sections in included files\n");
+					return 1;
+				}
+
 				skip_fgets = 1;
 				break;
 			}
 
 			strip_blank_end(p);
 
+			if (!strncmp(p, "include", strlen("include"))) {
+				char *filename = p + strlen("include") + 1;
+
+				if ((ret = __parse_jobs_ini(td, filename,
+						is_buf, stonewall_flag, type, 1,
+						name, &opts, &alloc_opts, &num_opts))) {
+					log_err("Error %d while parsing include file %s\n",
+						ret, filename);
+					break;
+				}
+				continue;
+			}
+
 			if (num_opts == alloc_opts) {
 				alloc_opts <<= 1;
 				opts = realloc(opts,
@@ -1535,6 +1582,13 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 			num_opts++;
 		}
 
+		if (nested) {
+			*popts = opts;
+			*aopts = alloc_opts;
+			*nopts = num_opts;
+			goto out;
+		}
+
 		ret = fio_options_parse(td, opts, num_opts, dump_cmdline);
 		if (!ret)
 			ret = add_job(td, name, 0, 0, type);
@@ -1557,14 +1611,22 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 		i++;
 	}
 
-	free(string);
-	free(name);
 	free(opts);
+out:
+	free(string);
+	if (!nested)
+		free(name);
 	if (!is_buf && f != stdin)
 		fclose(f);
 	return ret;
 }
 
+int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
+{
+	return __parse_jobs_ini(NULL, file, is_buf, stonewall_flag, type,
+			0, NULL, NULL, NULL, NULL);
+}
+
 static int fill_def_thread(void)
 {
 	memset(&def_thread, 0, sizeof(def_thread));
diff --git a/io_u.c b/io_u.c
index eac871b..8546899 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1487,7 +1487,8 @@ struct io_u *get_io_u(struct thread_data *td)
 		if (io_u->ddir == DDIR_WRITE) {
 			if (td->flags & TD_F_REFILL_BUFFERS) {
 				io_u_fill_buffer(td, io_u,
-					io_u->xfer_buflen, io_u->xfer_buflen);
+					td->o.min_bs[DDIR_WRITE],
+					io_u->xfer_buflen);
 			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
 				   !(td->flags & TD_F_COMPRESS))
 				do_scramble = 1;
@@ -1864,22 +1865,29 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 	else if (!td->o.zero_buffers) {
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
+		unsigned int left = max_bs;
 
-		rs = get_buf_state(td);
+		do {
+			rs = get_buf_state(td);
 
-		if (perc) {
-			unsigned int seg = min_write;
+			min_write = min(min_write, left);
 
-			seg = min(min_write, td->o.compress_chunk);
-			if (!seg)
-				seg = min_write;
+			if (perc) {
+				unsigned int seg = min_write;
 
-			fill_random_buf_percentage(rs, buf, perc, seg,max_bs);
-			save_buf_state(td, rs);
-		} else {
-			fill_random_buf(rs, buf, max_bs);
+				seg = min(min_write, td->o.compress_chunk);
+				if (!seg)
+					seg = min_write;
+
+				fill_random_buf_percentage(rs, buf, perc, seg,
+								min_write);
+			} else
+				fill_random_buf(rs, buf, min_write);
+
+			buf += min_write;
+			left -= min_write;
 			save_buf_state(td, rs);
-		}
+		} while (left);
 	} else
 		memset(buf, 0, max_bs);
 }
diff --git a/lib/bloom.c b/lib/bloom.c
new file mode 100644
index 0000000..b469fde
--- /dev/null
+++ b/lib/bloom.c
@@ -0,0 +1,107 @@
+#include <stdlib.h>
+#include <inttypes.h>
+
+#include "bloom.h"
+#include "../hash.h"
+#include "../minmax.h"
+#include "../crc/xxhash.h"
+#include "../crc/crc32c.h"
+
+struct bloom {
+	uint64_t nentries;
+
+	uint32_t *map;
+};
+
+#define BITS_PER_INDEX	(sizeof(uint32_t) * 8)
+#define BITS_INDEX_MASK	(BITS_PER_INDEX - 1)
+
+struct bloom_hash {
+	unsigned int seed;
+	uint32_t (*fn)(const void *, uint32_t, uint32_t);
+};
+
+static uint32_t b_crc32c(const void *buf, uint32_t len, uint32_t seed)
+{
+	return fio_crc32c(buf, len);
+}
+
+struct bloom_hash hashes[] = {
+	{
+		.seed = 0x8989,
+		.fn = jhash,
+	},
+	{
+		.seed = 0x8989,
+		.fn = XXH32,
+	},
+	{
+		.seed = 0,
+		.fn = b_crc32c,
+	},
+};
+
+#define N_HASHES	3
+
+#define MIN_ENTRIES	1073741824UL
+
+struct bloom *bloom_new(uint64_t entries)
+{
+	struct bloom *b;
+	size_t no_uints;
+
+	crc32c_intel_probe();
+
+	b = malloc(sizeof(*b));
+	b->nentries = entries;
+	no_uints = (entries + BITS_PER_INDEX - 1) / BITS_PER_INDEX;
+	no_uints = max((unsigned long) no_uints, MIN_ENTRIES);
+	b->map = calloc(no_uints, sizeof(uint32_t));
+	if (!b->map) {
+		free(b);
+		return NULL;
+	}
+
+	return b;
+}
+
+void bloom_free(struct bloom *b)
+{
+	free(b->map);
+	free(b);
+}
+
+static int __bloom_check(struct bloom *b, uint32_t *data, unsigned int nwords,
+			 int set)
+{
+	uint32_t hash[N_HASHES];
+	int i, was_set;
+
+	for (i = 0; i < N_HASHES; i++) {
+		hash[i] = hashes[i].fn(data, nwords, hashes[i].seed);
+		hash[i] = hash[i] % b->nentries;
+	}
+
+	was_set = 0;
+	for (i = 0; i < N_HASHES; i++) {
+		const unsigned int index = hash[i] / BITS_PER_INDEX;
+		const unsigned int bit = hash[i] & BITS_INDEX_MASK;
+
+		if (b->map[index] & (1U << bit))
+			was_set++;
+		if (set)
+			b->map[index] |= 1U << bit;
+	}
+
+	return was_set == N_HASHES;
+}
+
+int bloom_check(struct bloom *b, uint32_t *data, unsigned int nwords)
+{
+	return __bloom_check(b, data, nwords, 0);
+}
+
+int bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords)
+{
+	return __bloom_check(b, data, nwords, 1);
+}
diff --git a/lib/bloom.h b/lib/bloom.h
new file mode 100644
index 0000000..b3cde95
--- /dev/null
+++ b/lib/bloom.h
@@ -0,0 +1,13 @@
+#ifndef FIO_BLOOM_H
+#define FIO_BLOOM_H
+
+#include <inttypes.h>
+
+struct bloom;
+
+struct bloom *bloom_new(uint64_t entries);
+void bloom_free(struct bloom *b);
+int bloom_check(struct bloom *b, uint32_t *data, unsigned int nwords);
+int bloom_set(struct bloom *b, uint32_t *data, unsigned int nwords);
+
+#endif
diff --git a/t/debug.c b/t/debug.c
new file mode 100644
index 0000000..c297d61
--- /dev/null
+++ b/t/debug.c
@@ -0,0 +1,14 @@
+#include <stdio.h>
+
+FILE *f_err;
+struct timeval *fio_tv = NULL;
+unsigned int fio_debug = 0;
+
+void __dprint(int type, const char *str, ...)
+{
+}
+
+void debug_init(void)
+{
+	f_err = stderr;
+}
diff --git a/t/debug.h b/t/debug.h
new file mode 100644
index 0000000..9d1d415
--- /dev/null
+++ b/t/debug.h
@@ -0,0 +1,6 @@
+#ifndef FIO_DEBUG_INC_H
+#define FIO_DEBUG_INC_H
+
+extern void debug_init(void);
+
+#endif
diff --git a/t/dedupe.c b/t/dedupe.c
index b81e98a..5998138 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -27,13 +27,8 @@
 #include "../gettime.h"
 #include "../fio_time.h"
 
-FILE *f_err;
-struct timeval *fio_tv = NULL;
-unsigned int fio_debug = 0;
-
-void __dprint(int type, const char *str, ...)
-{
-}
+#include "../lib/bloom.h"
+#include "debug.h"
 
 struct worker_thread {
 	pthread_t thread;
@@ -45,6 +40,7 @@ struct worker_thread {
 	uint64_t size;
 
 	unsigned long items;
+	unsigned long dupes;
 	int err;
 };
 
@@ -66,6 +62,7 @@ struct item {
 };
 
 static struct rb_root rb_root;
+static struct bloom *bloom;
 static struct fio_mutex *rb_lock;
 
 static unsigned int blocksize = 4096;
@@ -75,6 +72,7 @@ static unsigned int dump_output;
 static unsigned int odirect;
 static unsigned int collision_check;
 static unsigned int print_progress = 1;
+static unsigned int use_bloom = 1;
 
 static uint64_t total_size;
 static uint64_t cur_offset;
@@ -116,17 +114,17 @@ static int get_work(uint64_t *offset, uint64_t *size)
 	return ret;
 }
 
-static int read_block(int fd, void *buf, off_t offset)
+static int __read_block(int fd, void *buf, off_t offset, size_t count)
 {
 	ssize_t ret;
 
-	ret = pread(fd, buf, blocksize, offset);
+	ret = pread(fd, buf, count, offset);
 	if (ret < 0) {
 		perror("pread");
 		return 1;
 	} else if (!ret)
 		return 1;
-	else if (ret != blocksize) {
+	else if (ret != count) {
 		log_err("dedupe: short read on block\n");
 		return 1;
 	}
@@ -134,6 +132,11 @@ static int read_block(int fd, void *buf, off_t offset)
 	return 0;
 }
 
+static int read_block(int fd, void *buf, off_t offset)
+{
+	return __read_block(fd, buf, offset, blocksize);
+}
+
 static void add_item(struct chunk *c, struct item *i)
 {
 	/*	
@@ -231,14 +234,24 @@ add:
 	add_item(c, i);
 }
 
-static void insert_chunks(struct item *items, unsigned int nitems)
+static void insert_chunks(struct item *items, unsigned int nitems,
+			  uint64_t *ndupes)
 {
 	int i;
 
 	fio_mutex_down(rb_lock);
 
-	for (i = 0; i < nitems; i++)
-		insert_chunk(&items[i]);
+	for (i = 0; i < nitems; i++) {
+		if (bloom) {
+			unsigned int s;
+			int r;
+
+			s = sizeof(items[i].hash) / sizeof(uint32_t);
+			r = bloom_set(bloom, items[i].hash, s);
+			*ndupes += r;
+		} else
+			insert_chunk(&items[i]);
+	}
 
 	fio_mutex_up(rb_lock);
 }
@@ -252,30 +265,46 @@ static void crc_buf(void *buf, uint32_t *hash)
 	fio_md5_final(&ctx);
 }
 
+static unsigned int read_blocks(int fd, void *buf, off_t offset, size_t size)
+{
+	if (__read_block(fd, buf, offset, size))
+		return 0;
+
+	return size / blocksize;
+}
+
 static int do_work(struct worker_thread *thread, void *buf)
 {
 	unsigned int nblocks, i;
 	off_t offset;
-	int err = 0, nitems = 0;
+	int nitems = 0;
+	uint64_t ndupes = 0;
 	struct item *items;
 
-	nblocks = thread->size / blocksize;
 	offset = thread->cur_offset;
+
+	nblocks = read_blocks(thread->fd, buf, offset, min(thread->size, (uint64_t)chunk_size));
+	if (!nblocks)
+		return 1;
+
 	items = malloc(sizeof(*items) * nblocks);
 
 	for (i = 0; i < nblocks; i++) {
-		if (read_block(thread->fd, buf, offset))
-			break;
-		items[i].offset = offset;
-		crc_buf(buf, items[i].hash);
+		void *thisptr = buf + (i * blocksize);
+
+		if (items)
+			items[i].offset = offset;
+		crc_buf(thisptr, items[i].hash);
 		offset += blocksize;
 		nitems++;
 	}
 
-	insert_chunks(items, nitems);
-	thread->items += nitems;
+	insert_chunks(items, nitems, &ndupes);
+
 	free(items);
-	return err;
+	thread->items += nitems;
+	thread->dupes += ndupes;
+	return 0;
 }
 
 static void *thread_fn(void *data)
@@ -283,7 +312,7 @@ static void *thread_fn(void *data)
 	struct worker_thread *thread = data;
 	void *buf;
 
-	buf = fio_memalign(blocksize, blocksize);
+	buf = fio_memalign(blocksize, chunk_size);
 
 	do {
 		if (get_work(&thread->cur_offset, &thread->size)) {
@@ -297,7 +326,7 @@ static void *thread_fn(void *data)
 	} while (1);
 
 	thread->done = 1;
-	fio_memfree(buf, blocksize);
+	fio_memfree(buf, chunk_size);
 	return NULL;
 }
 
@@ -343,7 +372,8 @@ static void show_progress(struct worker_thread *threads, unsigned long total)
 	};
 }
 
-static int run_dedupe_threads(int fd, uint64_t dev_size)
+static int run_dedupe_threads(int fd, uint64_t dev_size, uint64_t *nextents,
+				uint64_t *nchunks)
 {
 	struct worker_thread *threads;
 	unsigned long nitems, total_items;
@@ -371,20 +401,27 @@ static int run_dedupe_threads(int fd, uint64_t dev_size)
 	show_progress(threads, total_items);
 
 	nitems = 0;
+	*nextents = 0;
+	*nchunks = 1;
 	for (i = 0; i < num_threads; i++) {
 		void *ret;
 		pthread_join(threads[i].thread, &ret);
 		nitems += threads[i].items;
+		*nchunks += threads[i].dupes;
 	}
 
 	printf("Threads(%u): %lu items processed\n", num_threads, nitems);
 
+	*nextents = nitems;
+	*nchunks = nitems - *nchunks;
+
 	fio_mutex_remove(size_lock);
 	free(threads);
 	return err;
 }
 
-static int dedupe_check(const char *filename)
+static int dedupe_check(const char *filename, uint64_t *nextents,
+			uint64_t *nchunks)
 {
 	uint64_t dev_size;
 	struct stat sb;
@@ -412,9 +449,16 @@ static int dedupe_check(const char *filename)
 		return 1;
 	}
 
+	if (use_bloom) {
+		uint64_t bloom_entries;
+
+		bloom_entries = (3 * dev_size ) / (blocksize * 2);
+		bloom = bloom_new(bloom_entries);
+	}
+
 	printf("Will check <%s>, size <%llu>, using %u threads\n", filename, (unsigned long long) dev_size, num_threads);
 
-	return run_dedupe_threads(dev_fd, dev_size);
+	return run_dedupe_threads(dev_fd, dev_size, nextents, nchunks);
 }
 
 static void show_chunk(struct chunk *c)
@@ -429,14 +473,24 @@ static void show_chunk(struct chunk *c)
 	}
 }
 
-static void iter_rb_tree(void)
+static void show_stat(uint64_t nextents, uint64_t nchunks)
 {
-	struct rb_node *n;
-	uint64_t nchunks;
-	uint64_t nextents;
 	double perc;
 
-	nchunks = nextents = 0;
+	printf("Extents=%lu, Unique extents=%lu\n", (unsigned long) nextents, (unsigned long) nchunks);
+	printf("De-dupe factor: %3.2f\n", (double) nextents / (double) nchunks);
+
+	perc = 1.00 - ((double) nchunks / (double) nextents);
+	perc *= 100.0;
+	printf("Fio setting: dedupe_percentage=%u\n", (int) (perc + 0.50));
+
+}
+
+static void iter_rb_tree(uint64_t *nextents, uint64_t *nchunks)
+{
+	struct rb_node *n;
+
+	*nchunks = *nextents = 0;
 
 	n = rb_first(&rb_root);
 	if (!n)
@@ -446,20 +500,13 @@ static void iter_rb_tree(void)
 		struct chunk *c;
 
 		c = rb_entry(n, struct chunk, rb_node);
-		nchunks++;
-		nextents += c->count;
+		(*nchunks)++;
+		*nextents += c->count;
 
 		if (dump_output)
 			show_chunk(c);
 
 	} while ((n = rb_next(n)) != NULL);
-
-	printf("Extents=%lu, Unique extents=%lu\n", (unsigned long) nextents, (unsigned long) nchunks);
-	printf("De-dupe factor: %3.2f\n", (double) nextents / (double) nchunks);
-
-	perc = 1.00 - ((double) nchunks / (double) nextents);
-	perc *= 100.0;
-	printf("Fio setting: dedupe_percentage=%u\n", (int) (perc + 0.50));
 }
 
 static int usage(char *argv[])
@@ -471,15 +518,19 @@ static int usage(char *argv[])
 	log_err("\t-d\tFull extent/chunk debug output\n");
 	log_err("\t-o\tUse O_DIRECT\n");
 	log_err("\t-c\tFull collision check\n");
+	log_err("\t-B\tUse probabilistic bloom filter\n");
 	log_err("\t-p\tPrint progress indicator\n");
 	return 1;
 }
 
 int main(int argc, char *argv[])
 {
+	uint64_t nextents = 0, nchunks = 0;
 	int c, ret;
 
-	while ((c = getopt(argc, argv, "b:t:d:o:c:p:")) != -1) {
+	debug_init();
+
+	while ((c = getopt(argc, argv, "b:t:d:o:c:p:B:")) != -1) {
 		switch (c) {
 		case 'b':
 			blocksize = atoi(optarg);
@@ -499,12 +550,18 @@ int main(int argc, char *argv[])
 		case 'p':
 			print_progress = atoi(optarg);
 			break;
+		case 'B':
+			use_bloom = atoi(optarg);
+			break;
 		case '?':
 		default:
 			return usage(argv);
 		}
 	}
 
+	if (collision_check || dump_output)
+		use_bloom = 0;
+
 	if (!num_threads)
 		num_threads = cpus_online();
 
@@ -516,11 +573,16 @@ int main(int argc, char *argv[])
 	rb_root = RB_ROOT;
 	rb_lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
 
-	ret = dedupe_check(argv[optind]);
+	ret = dedupe_check(argv[optind], &nextents, &nchunks);
+
+	if (!bloom)
+		iter_rb_tree(&nextents, &nchunks);
 
-	iter_rb_tree();
+	show_stat(nextents, nchunks);
 
 	fio_mutex_remove(rb_lock);
+	if (bloom)
+		bloom_free(bloom);
 	scleanup();
 	return ret;
 }
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 481f37e..4b54248 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -8,6 +8,8 @@
 #include <sys/stat.h>
 
 #include "../lib/lfsr.h"
+#include "../gettime.h"
+#include "../fio_time.h"
 
 void usage()
 {
@@ -25,7 +27,7 @@ void usage()
 int main(int argc, char *argv[])
 {
 	int r;
-	struct timespec start, end;
+	struct timeval start, end;
 	struct fio_lfsr *fl;
 	int verify = 0;
 	unsigned int spin = 0;
@@ -86,12 +88,12 @@ int main(int argc, char *argv[])
 	 * negligible overhead.
 	 */
 	fprintf(stderr, "\nTest initiated... ");
-	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
+	fio_gettime(&start, NULL);
 	while (!lfsr_next(fl, &i, fl->max_val)) {
 		if (verify)
 			*(uint8_t *)(v + i) += 1;
 	}
-	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
+	fio_gettime(&end, NULL);
 	fprintf(stderr, "finished.\n");
 
 
@@ -113,8 +115,7 @@ int main(int argc, char *argv[])
 	}
 
 	/* Calculate elapsed time and mean time per number */
-	total = (end.tv_sec - start.tv_sec) * pow(10,9) +
-		end.tv_nsec - start.tv_nsec;
+	total = utime_since(&start, &end);
 	mean = total / fl->num_vals;
 
 	printf("\nTime results ");
@@ -122,7 +123,7 @@ int main(int argc, char *argv[])
 		printf("(slower due to verification)");
 	printf("\n==============================\n");
 	printf("Elapsed: %lf s\n", total / pow(10,9));
-	printf("Mean:    %lf ns\n", mean);
+	printf("Mean:    %lf us\n", mean);
 
 	free(v_start);
 	free(fl);
diff --git a/t/stest.c b/t/stest.c
index 0da8f2c..efb256e 100644
--- a/t/stest.c
+++ b/t/stest.c
@@ -4,10 +4,7 @@
 
 #include "../smalloc.h"
 #include "../flist.h"
-
-FILE *f_err;
-struct timeval *fio_tv = NULL;
-unsigned int fio_debug = 0;
+#include "debug.h"
 
 #define MAGIC1	0xa9b1c8d2
 #define MAGIC2	0xf0a1e9b3
@@ -72,9 +69,8 @@ static int do_specific_alloc(unsigned long size)
 
 int main(int argc, char *argv[])
 {
-	f_err = stderr;
-
 	sinit();
+	debug_init();
 
 	do_rand_allocs();
 
@@ -84,7 +80,3 @@ int main(int argc, char *argv[])
 	scleanup();
 	return 0;
 }
-
-void __dprint(int type, const char *str, ...)
-{
-}
