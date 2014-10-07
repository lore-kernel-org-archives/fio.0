Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54788 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaJGMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Oct 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XbTQz-0001Lb-9n
	for fio@vger.kernel.org; Tue, 07 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141007120003.1B41F401CA@lyth.info>
Date: Tue,  7 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b220c6d6f37fc55760d66728f6f9f521ea2f9b46:

  Merge branch 'expression-parser' (2014-10-03 13:20:16 -0600)

are available in the git repository at:


  git://git.kernel.dk/fio.git master

for you to fetch changes up to 15e3ca5b72b03f485abdda06bee9a9458dbd26a5:

  t/dedupe: avoid div-by-zero for all identical chunks (2014-10-06 21:07:25 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      init: set fail error return on bad parse
      t/dedupe: fix off-by 1.024 in bandwidth
      t/dedupe: avoid div-by-zero for all identical chunks

Stephen M. Cameron (2):
      fix problem with yy_size_t vs int param to lexer_input
      Fix bison parsing

 Makefile                |    6 ++++--
 configure               |    6 +++---
 exp/expression-parser.y |    4 +++-
 init.c                  |    1 +
 t/dedupe.c              |   10 +++++++---
 5 files changed, 18 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index d735ec7..5662015 100644
--- a/Makefile
+++ b/Makefile
@@ -268,7 +268,7 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 
 ifdef CONFIG_ARITHMETIC
 lex.yy.c: exp/expression-parser.l
-	$(QUIET_LEX)$(LEX) exp/expression-parser.l
+	$(QUIET_LEX)$(LEX) --header-file=lexer.h exp/expression-parser.l
 
 lex.yy.o: lex.yy.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
@@ -277,10 +277,12 @@ y.tab.o: y.tab.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
 
 y.tab.c: exp/expression-parser.y
-	$(QUIET_YACC)$(YACC) --no-lines -d exp/expression-parser.y
+	$(QUIET_YACC)$(YACC) --no-lines -d -b y exp/expression-parser.y
 
 y.tab.h: y.tab.c
 
+lexer.h: lex.yy.c
+
 exp/test-expression-parser.o: exp/test-expression-parser.c
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
 exp/test-expression-parser: exp/test-expression-parser.o
diff --git a/configure b/configure
index f7d8ff9..e3ec252 100755
--- a/configure
+++ b/configure
@@ -1279,14 +1279,14 @@ LEX=$(which lex 2> /dev/null)
 if test -x "$LEX" ; then
   lex="yes"
 fi
-YACC=$(which yacc 2> /dev/null)
+YACC=$(which bison 2> /dev/null)
 if test -x "$YACC" ; then
   yacc="yes"
+  yacc_is_bison="yes"
 else
-  YACC=$(which bison 2> /dev/null)
+  YACC=$(which yacc 2> /dev/null)
   if test -x "$YACC" ; then
     yacc="yes"
-    yacc_is_bison="yes"
   fi
 fi
 if test "$yacc" = "yes" && test "$lex" = "yes" ; then
diff --git a/exp/expression-parser.y b/exp/expression-parser.y
index e4373d4..83b5b30 100644
--- a/exp/expression-parser.y
+++ b/exp/expression-parser.y
@@ -21,6 +21,8 @@
 #include <stdio.h>
 #include <string.h>
 #include <math.h>
+#include "lexer.h"
+
 struct parser_value_type {
 	double dval;
 	long long ival;
@@ -186,7 +188,7 @@ expression:	expression '+' expression {
 static int lexer_read_offset = 0;
 static char lexer_input_buffer[1000];
 
-int lexer_input(char* buffer, int *bytes_read, int bytes_requested)
+int lexer_input(char* buffer, yy_size_t *bytes_read, int bytes_requested)
 {
 	int bytes_left = strlen(lexer_input_buffer) - lexer_read_offset;
 
diff --git a/init.c b/init.c
index e208451..861b1f5 100644
--- a/init.c
+++ b/init.c
@@ -1482,6 +1482,7 @@ int __parse_jobs_ini(struct thread_data *td,
 
 				log_err("fio: option <%s> outside of "
 					"[] job section\n", p);
+				ret = 1;
 				break;
 			}
 
diff --git a/t/dedupe.c b/t/dedupe.c
index 69ebc8a..1577a69 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -361,7 +361,7 @@ static void show_progress(struct worker_thread *threads, unsigned long total)
 		this_items *= blocksize;
 		tdiff = mtime_since_now(&last_tv);
 		if (tdiff) {
-			this_items /= tdiff;
+			this_items = (this_items * 1000) / (tdiff * 1024);
 			printf("%3.2f%% done (%luKB/sec)\r", perc, this_items);
 			last_nitems = nitems;
 			fio_gettime(&last_tv, NULL);
@@ -478,8 +478,12 @@ static void show_stat(uint64_t nextents, uint64_t nchunks)
 	double perc, ratio;
 
 	printf("Extents=%lu, Unique extents=%lu\n", (unsigned long) nextents, (unsigned long) nchunks);
-	ratio = (double) nextents / (double) nchunks;
-	printf("De-dupe ratio: 1:%3.2f\n", ratio - 1.0);
+
+	if (nchunks) {
+		ratio = (double) nextents / (double) nchunks;
+		printf("De-dupe ratio: 1:%3.2f\n", ratio - 1.0);
+	} else
+		printf("De-dupe ratio: 1:infinite\n");
 
 	perc = 1.00 - ((double) nchunks / (double) nextents);
 	perc *= 100.0;
