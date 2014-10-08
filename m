Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60996 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbaJHMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Oct 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XbpuW-0006tH-OY
	for fio@vger.kernel.org; Wed, 08 Oct 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141008120003.6C0CC40162@lyth.info>
Date: Wed,  8 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 15e3ca5b72b03f485abdda06bee9a9458dbd26a5:

  t/dedupe: avoid div-by-zero for all identical chunks (2014-10-06 21:07:25 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c05da82c1a427ce535af0c1b3e7a795330cf5061:

  gfio: remove warning on g_type_init() being deprecated (2014-10-07 20:46:26 -0600)

----------------------------------------------------------------
Jens Axboe (9):
      t/dedupe: use generic blockdev_size() to get size
      t/dedupe: remove leftover linux/fs.h include
      t/dedupe: use fio abstracted OS_O_DIRECT
      Ignore lexer.h auto-generated file
      exp: fix issues around int vs size_t
      exp: small code cleanup
      libaio: commit on EAGAIN
      Makefile: fix gfio link for CONFIG_ARITHMETIC
      gfio: remove warning on g_type_init() being deprecated

Slava Pestov (1):
      libaio: retry on -EINTR

 .gitignore              |    1 +
 Makefile                |   11 +++++-----
 engines/libaio.c        |    7 +++++--
 exp/expression-parser.l |   14 +++++++++----
 gfio.c                  |    2 ++
 t/dedupe.c              |   53 +++++++++++++++++++++++++++--------------------
 6 files changed, 53 insertions(+), 35 deletions(-)

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index c9d90fb..f13ec27 100644
--- a/.gitignore
+++ b/.gitignore
@@ -9,3 +9,4 @@
 /fio
 y.tab.*
 lex.yy.c
+lexer.h
diff --git a/Makefile b/Makefile
index 5662015..5b03ec4 100644
--- a/Makefile
+++ b/Makefile
@@ -159,13 +159,14 @@ OBJS = $(SOURCE:.c=.o)
 
 FIO_OBJS = $(OBJS) fio.o
 
+GFIO_OBJS = $(OBJS) gfio.o graph.o tickmarks.o ghelpers.o goptions.o gerror.o \
+			gclient.o gcompat.o cairo_text_helpers.o printing.o
+
 ifdef CONFIG_ARITHMETIC
 FIO_OBJS += lex.yy.o y.tab.o
+GFIO_OBJS += lex.yy.o y.tab.o
 endif
 
-GFIO_OBJS = $(OBJS) gfio.o graph.o tickmarks.o ghelpers.o goptions.o gerror.o \
-			gclient.o gcompat.o cairo_text_helpers.o printing.o
-
 -include $(OBJS:.o=.d)
 
 T_SMALLOC_OBJS = t/stest.o
@@ -194,13 +195,11 @@ T_BTRACE_FIO_OBJS += fifo.o lib/flist_sort.o t/log.o lib/linux-dev-lookup.o
 T_BTRACE_FIO_PROGS = t/btrace2fio
 endif
 
-ifeq ($(CONFIG_TARGET_OS), Linux)
 T_DEDUPE_OBJS = t/dedupe.o
 T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
 		memalign.o lib/bloom.o t/debug.o crc/xxhash.o crc/murmur3.o \
 		crc/crc32c.o crc/crc32c-intel.o crc/fnv.o
 T_DEDUPE_PROGS = t/dedupe
-endif
 
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
@@ -351,7 +350,7 @@ t/dedupe: $(T_DEDUPE_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
 
 clean: FORCE
-	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do]
+	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 
 distclean: clean FORCE
 	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf
diff --git a/engines/libaio.c b/engines/libaio.c
index 6c5d73e..7c3a42a 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -13,6 +13,8 @@
 
 #include "../fio.h"
 
+static int fio_libaio_commit(struct thread_data *td);
+
 struct libaio_data {
 	io_context_t aio_ctx;
 	struct io_event *aio_events;
@@ -165,9 +167,10 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 		}
 		if (r >= 0)
 			events += r;
-		else if (r == -EAGAIN)
+		else if (r == -EAGAIN) {
+			fio_libaio_commit(td);
 			usleep(100);
-		else
+		} else if (r != -EINTR)
 			break;
 	} while (events < min);
 
diff --git a/exp/expression-parser.l b/exp/expression-parser.l
index 7d5e787..16e3873 100644
--- a/exp/expression-parser.l
+++ b/exp/expression-parser.l
@@ -24,16 +24,22 @@
 
 #define YYSTYPE PARSER_VALUE_TYPE
 
-extern int lexer_input(char* buffer, int *nbytes, int buffersize);
+extern int lexer_input(char *buffer, size_t *nbytes, int buffersize);
 
 #undef YY_INPUT
-#define YY_INPUT(buffer, bytes_read, bytes_requested) \
-		lexer_input((buffer), &(bytes_read), (bytes_requested))
+#define YY_INPUT(buffer, bytes_read, bytes_requested)			\
+({									\
+	int __ret;							\
+	size_t __bread = bytes_read;					\
+	__ret = lexer_input((buffer), &__bread, (bytes_requested));	\
+	bytes_read = __bread;						\
+	__ret;								\
+})
 
 extern int yyerror(long long *result, double *dresult,
 		int *has_error, int *units_specified, const char *msg);
 
-static void __attribute__((unused)) yyunput(int c,char *buf_ptr);
+static void __attribute__((unused)) yyunput(int c, char *buf_ptr);
 static int __attribute__((unused)) input(void);
 
 #define set_suffix_value(yylval, i_val, d_val, has_d_val) \
diff --git a/gfio.c b/gfio.c
index 37c1db6..0e22cba 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1687,7 +1687,9 @@ static void init_ui(int *argc, char **argv[], struct gui *ui)
 	gtk_init(argc, argv);
 	settings = gtk_settings_get_default();
 	gtk_settings_set_long_property(settings, "gtk_tooltip_timeout", 10, "gfio setting");
+#if !GLIB_CHECK_VERSION(2, 36, 0)
 	g_type_init();
+#endif
 	gdk_color_parse("#fffff4", &gfio_color_lightyellow);
 	gdk_color_parse("white", &gfio_color_white);
 
diff --git a/t/dedupe.c b/t/dedupe.c
index 1577a69..030b4fc 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -11,7 +11,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
-#include <linux/fs.h>
 #include <fcntl.h>
 #include <string.h>
 
@@ -78,17 +77,20 @@ static uint64_t total_size;
 static uint64_t cur_offset;
 static struct fio_mutex *size_lock;
 
-static int dev_fd;
+static struct fio_file file;
 
-static uint64_t get_size(int fd, struct stat *sb)
+static uint64_t get_size(struct fio_file *f, struct stat *sb)
 {
 	uint64_t ret;
 
 	if (S_ISBLK(sb->st_mode)) {
-		if (ioctl(fd, BLKGETSIZE64, &ret) < 0) {
-			perror("ioctl");
+		unsigned long long bytes;
+
+		if (blockdev_size(f, &bytes)) {
+			log_err("dedupe: failed getting bdev size\n");
 			return 0;
 		}
+		ret = bytes;
 	} else
 		ret = sb->st_size;
 
@@ -164,10 +166,10 @@ static int col_check(struct chunk *c, struct item *i)
 	ibuf = fio_memalign(blocksize, blocksize);
 
 	e = flist_entry(c->extent_list[0].next, struct extent, list);
-	if (read_block(dev_fd, cbuf, e->offset))
+	if (read_block(file.fd, cbuf, e->offset))
 		goto out;
 
-	if (read_block(dev_fd, ibuf, i->offset))
+	if (read_block(file.fd, ibuf, i->offset))
 		goto out;
 
 	ret = memcmp(ibuf, cbuf, blocksize);
@@ -372,8 +374,8 @@ static void show_progress(struct worker_thread *threads, unsigned long total)
 	};
 }
 
-static int run_dedupe_threads(int fd, uint64_t dev_size, uint64_t *nextents,
-				uint64_t *nchunks)
+static int run_dedupe_threads(struct fio_file *f, uint64_t dev_size,
+			      uint64_t *nextents, uint64_t *nchunks)
 {
 	struct worker_thread *threads;
 	unsigned long nitems, total_items;
@@ -386,7 +388,7 @@ static int run_dedupe_threads(int fd, uint64_t dev_size, uint64_t *nextents,
 
 	threads = malloc(num_threads * sizeof(struct worker_thread));
 	for (i = 0; i < num_threads; i++) {
-		threads[i].fd = fd;
+		threads[i].fd = f->fd;
 		threads[i].items = 0;
 		threads[i].err = 0;
 		threads[i].done = 0;
@@ -429,25 +431,25 @@ static int dedupe_check(const char *filename, uint64_t *nextents,
 
 	flags = O_RDONLY;
 	if (odirect)
-		flags |= O_DIRECT;
+		flags |= OS_O_DIRECT;
+
+	memset(&file, 0, sizeof(file));
+	file.file_name = strdup(filename);
 
-	dev_fd = open(filename, flags);
-	if (dev_fd == -1) {
+	file.fd = open(filename, flags);
+	if (file.fd == -1) {
 		perror("open");
-		return 1;
+		goto err;
 	}
 
-	if (fstat(dev_fd, &sb) < 0) {
+	if (fstat(file.fd, &sb) < 0) {
 		perror("fstat");
-		close(dev_fd);
-		return 1;
+		goto err;
 	}
 
-	dev_size = get_size(dev_fd, &sb);
-	if (!dev_size) {
-		close(dev_fd);
-		return 1;
-	}
+	dev_size = get_size(&file, &sb);
+	if (!dev_size)
+		goto err;
 
 	if (use_bloom) {
 		uint64_t bloom_entries;
@@ -458,7 +460,12 @@ static int dedupe_check(const char *filename, uint64_t *nextents,
 
 	printf("Will check <%s>, size <%llu>, using %u threads\n", filename, (unsigned long long) dev_size, num_threads);
 
-	return run_dedupe_threads(dev_fd, dev_size, nextents, nchunks);
+	return run_dedupe_threads(&file, dev_size, nextents, nchunks);
+err:
+	if (file.fd != -1)
+		close(file.fd);
+	free(file.file_name);
+	return 1;
 }
 
 static void show_chunk(struct chunk *c)
