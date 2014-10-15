Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Oct 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XeNFM-0006TZ-6t
	for fio@vger.kernel.org; Wed, 15 Oct 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141015120003.205FD401DC@lyth.info>
Date: Wed, 15 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e5c9093db2c18166bd572f2ab40d5eba16a25b07:

  server/client: don't use __ conversion functions if not needed (2014-10-13 16:05:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to de06a46881e1a8876b5fd1de5e002d6189a90a30:

  Get rid if --header-file argument for lex (2014-10-14 21:12:22 -0600)

----------------------------------------------------------------
Jens Axboe (7):
      engines/libaio: fix wrong setting of wait_start
      crc/test: fix potential div by zero
      sha256: cast shift to uint64_t
      t/dedupe: fix bogus items NULL compare
      t/btrace2fio: fix fd leak on error
      client: fix potential NULL dereference
      Get rid if --header-file argument for lex

 .gitignore              |    1 -
 Makefile                |    2 +-
 client.c                |    3 +++
 crc/sha256.c            |    2 +-
 crc/test.c              |   17 ++++++++++-------
 engines/libaio.c        |    2 +-
 exp/expression-parser.l |    4 ++--
 exp/expression-parser.y |    3 +--
 t/btrace2fio.c          |    2 ++
 t/dedupe.c              |    3 +--
 10 files changed, 22 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index f13ec27..c9d90fb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -9,4 +9,3 @@
 /fio
 y.tab.*
 lex.yy.c
-lexer.h
diff --git a/Makefile b/Makefile
index 750eccd..0f77df9 100644
--- a/Makefile
+++ b/Makefile
@@ -267,7 +267,7 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 
 ifdef CONFIG_ARITHMETIC
 lex.yy.c: exp/expression-parser.l
-	$(QUIET_LEX)$(LEX) --header-file=lexer.h exp/expression-parser.l
+	$(QUIET_LEX)$(LEX) exp/expression-parser.l
 
 lex.yy.o: lex.yy.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
diff --git a/client.c b/client.c
index 6b9fdd8..edc02a0 100644
--- a/client.c
+++ b/client.c
@@ -271,6 +271,9 @@ int fio_client_add_ini_file(void *cookie, const char *ini_file, int remote)
 	size_t new_size;
 	void *new_files;
 
+	if (!client)
+		return 1;
+
 	dprint(FD_NET, "client <%s>: add ini %s\n", client->hostname, ini_file);
 
 	new_size = (client->nr_files + 1) * sizeof(struct client_file);
diff --git a/crc/sha256.c b/crc/sha256.c
index ae9ff4d..2fd17a3 100644
--- a/crc/sha256.c
+++ b/crc/sha256.c
@@ -277,7 +277,7 @@ void fio_sha256_final(struct fio_sha256_ctx *sctx)
 	static const uint8_t padding[64] = { 0x80, };
 
 	/* Save number of bits */
-	bits = sctx->count << 3;
+	bits = (uint64_t) sctx->count << 3;
 
 	/* Pad out to 56 mod 64. */
 	index = sctx->count & 0x3f;
diff --git a/crc/test.c b/crc/test.c
index bca46f2..bc5cc45 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -329,13 +329,16 @@ int fio_crctest(const char *type)
 		t[i].fn(&t[i], buf, CHUNK);
 		usec = utime_since_now(&tv);
 
-		mb_sec = (double) mb / (double) usec;
-		mb_sec /= (1.024 * 1.024);
-		if (strlen(t[i].name) >= 7)
-			sprintf(pre, "\t");
-		else
-			sprintf(pre, "\t\t");
-		printf("%s:%s%8.2f MB/sec\n", t[i].name, pre, mb_sec);
+		if (usec) {
+			mb_sec = (double) mb / (double) usec;
+			mb_sec /= (1.024 * 1.024);
+			if (strlen(t[i].name) >= 7)
+				sprintf(pre, "\t");
+			else
+				sprintf(pre, "\t\t");
+			printf("%s:%s%8.2f MB/sec\n", t[i].name, pre, mb_sec);
+		} else
+			printf("%s:inf MB/sec\n", t[i].name);
 		first = 0;
 	}
 
diff --git a/engines/libaio.c b/engines/libaio.c
index 12f3b36..f7e2f89 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -281,7 +281,7 @@ static int fio_libaio_commit(struct thread_data *td)
 			}
 			if (!wait_start) {
 				fio_gettime(&tv, NULL);
-				wait_start = 0;
+				wait_start = 1;
 			} else if (mtime_since_now(&tv) > 30000) {
 				log_err("fio: aio appears to be stalled, giving up\n");
 				break;
diff --git a/exp/expression-parser.l b/exp/expression-parser.l
index 16e3873..856596a 100644
--- a/exp/expression-parser.l
+++ b/exp/expression-parser.l
@@ -24,13 +24,13 @@
 
 #define YYSTYPE PARSER_VALUE_TYPE
 
-extern int lexer_input(char *buffer, size_t *nbytes, int buffersize);
+extern int lexer_input(char *buffer, unsigned int *nbytes, int buffersize);
 
 #undef YY_INPUT
 #define YY_INPUT(buffer, bytes_read, bytes_requested)			\
 ({									\
 	int __ret;							\
-	size_t __bread = bytes_read;					\
+	unsigned int __bread = bytes_read;				\
 	__ret = lexer_input((buffer), &__bread, (bytes_requested));	\
 	bytes_read = __bread;						\
 	__ret;								\
diff --git a/exp/expression-parser.y b/exp/expression-parser.y
index 83b5b30..8ae0c01 100644
--- a/exp/expression-parser.y
+++ b/exp/expression-parser.y
@@ -21,7 +21,6 @@
 #include <stdio.h>
 #include <string.h>
 #include <math.h>
-#include "lexer.h"
 
 struct parser_value_type {
 	double dval;
@@ -188,7 +187,7 @@ expression:	expression '+' expression {
 static int lexer_read_offset = 0;
 static char lexer_input_buffer[1000];
 
-int lexer_input(char* buffer, yy_size_t *bytes_read, int bytes_requested)
+int lexer_input(char* buffer, unsigned int *bytes_read, int bytes_requested)
 {
 	int bytes_left = strlen(lexer_input_buffer) - lexer_read_offset;
 
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index 5666a56..baf29ac 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -870,9 +870,11 @@ static int trace_needs_swap(const char *trace_file, int *swap)
 
 	ret = read(fd, &t, sizeof(t));
 	if (ret < 0) {
+		close(fd);
 		perror("read");
 		return 1;
 	} else if (ret != sizeof(t)) {
+		close(fd);
 		log_err("fio: short read on trace file\n");
 		return 1;
 	}
diff --git a/t/dedupe.c b/t/dedupe.c
index 030b4fc..b43b677 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -294,8 +294,7 @@ static int do_work(struct worker_thread *thread, void *buf)
 	for (i = 0; i < nblocks; i++) {
 		void *thisptr = buf + (i * blocksize);
 
-		if (items)
-			items[i].offset = offset;
+		items[i].offset = offset;
 		crc_buf(thisptr, items[i].hash);
 		offset += blocksize;
 		nitems++;
