Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbbGIMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Jul 2015 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZDAUl-0005gR-Q6
	for fio@vger.kernel.org; Thu, 09 Jul 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150709120002.042BB2C005F@kernel.dk>
Date: Thu,  9 Jul 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 56d50ff3fccfd841921c799f6958ca1e33483959:

  t/debug: fix 'fio_debug' declaration (2015-07-03 14:26:08 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 59d8f4125b0871cc26ad60150bcf4cd29f7daac7:

  configure: don't be so eager to overwrite an existing Makefile (2015-07-08 13:50:35 -0700)

----------------------------------------------------------------
Jeremy Fitzhardinge (2):
      fio: allow for build in separate build directory
      configure: don't be so eager to overwrite an existing Makefile

 Makefile  | 58 +++++++++++++++++++++++++++++++++-------------------------
 configure |  7 +++++++
 2 files changed, 40 insertions(+), 25 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index b3acbcf..7fe7d4d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,3 +1,9 @@
+ifeq ($(SRCDIR),)
+SRCDIR := .
+endif
+
+VPATH := $(SRCDIR)
+
 ifneq ($(wildcard config-host.mak),)
 all:
 include config-host.mak
@@ -17,26 +23,27 @@ endif
 DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -O3 -g -ffast-math
-CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
+CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
-SCRIPTS = tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio
+SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio)
 
 ifdef CONFIG_GFIO
   PROGS += gfio
 endif
 
-SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
+SOURCE :=	gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		lib/rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
-		lib/num2str.c lib/ieee754.c $(wildcard crc/*.c) engines/cpu.c \
+		lib/num2str.c lib/ieee754.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		memalign.c server.c client.c iolog.c backend.c libfio.c flow.c \
 		cconv.c lib/prio_tree.c json.c lib/zipf.c lib/axmap.c \
 		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		lib/tp.c lib/bloom.c lib/gauss.c lib/mountcheck.c workqueue.c
+		lib/tp.c lib/bloom.c lib/gauss.c lib/mountcheck.c workqueue.c \
+		$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c))
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
@@ -164,7 +171,7 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format -static
 endif
 
-OBJS = $(SOURCE:.c=.o)
+OBJS := $(SOURCE:.c=.o)
 
 FIO_OBJS = $(OBJS) fio.o
 
@@ -266,14 +273,15 @@ all: $(PROGS) $(T_TEST_PROGS) $(SCRIPTS) FORCE
 .PHONY: FORCE cscope
 
 FIO-VERSION-FILE: FORCE
-	@$(SHELL) ./FIO-VERSION-GEN
+	@$(SHELL) $(SRCDIR)/FIO-VERSION-GEN
 -include FIO-VERSION-FILE
 
 override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 
 %.o : %.c
+	@mkdir -p $(dir $@)
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
-	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $*.c > $*.d
+	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
 	@mv -f $*.d $*.d.tmp
 	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
 	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
@@ -282,7 +290,7 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 
 ifdef CONFIG_ARITHMETIC
 lex.yy.c: exp/expression-parser.l
-	$(QUIET_LEX)$(LEX) exp/expression-parser.l
+	$(QUIET_LEX)$(LEX) -o $@ $<
 
 lex.yy.o: lex.yy.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
@@ -291,7 +299,7 @@ y.tab.o: y.tab.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
 
 y.tab.c: exp/expression-parser.y
-	$(QUIET_YACC)$(YACC) -l -d -b y exp/expression-parser.y
+	$(QUIET_YACC)$(YACC) -o $@ -l -d -b y $<
 
 y.tab.h: y.tab.c
 
@@ -305,35 +313,35 @@ exp/test-expression-parser: exp/test-expression-parser.o
 parse.o: lex.yy.o y.tab.o
 endif
 
-init.o: FIO-VERSION-FILE init.c
-	$(QUIET_CC)$(CC) -o init.o $(CFLAGS) $(CPPFLAGS) -c init.c
+init.o: init.c FIO-VERSION-FILE
+	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
 
 gcompat.o: gcompat.c gcompat.h
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c gcompat.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 goptions.o: goptions.c goptions.h
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c goptions.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 ghelpers.o: ghelpers.c ghelpers.h
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c ghelpers.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 gerror.o: gerror.c gerror.h
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c gerror.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 gclient.o: gclient.c gclient.h
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c gclient.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 gfio.o: gfio.c ghelpers.c
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c gfio.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 graph.o: graph.c graph.h
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c graph.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 cairo_text_helpers.o: cairo_text_helpers.c cairo_text_helpers.h
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c cairo_text_helpers.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 printing.o: printing.c printing.h
-	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c printing.c
+	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
 t/stest: $(T_SMALLOC_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_SMALLOC_OBJS) $(LIBS)
@@ -385,8 +393,8 @@ install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
 	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
-	$(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
-	$(INSTALL) -m 644 tools/fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
-	$(INSTALL) -m 644 tools/plot/fio2gnuplot.1 $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 $(SRCDIR)/fio.1 $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 $(SRCDIR)/tools/fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 $(SRCDIR)/tools/plot/fio2gnuplot.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 755 -d $(DESTDIR)$(sharedir)
-	$(INSTALL) -m 644 tools/plot/*gpm $(DESTDIR)$(sharedir)/
+	$(INSTALL) -m 644 $(SRCDIR)/tools/plot/*gpm $(DESTDIR)$(sharedir)/
diff --git a/configure b/configure
index a3f83d3..6807679 100755
--- a/configure
+++ b/configure
@@ -1717,3 +1717,10 @@ echo "LDFLAGS+=$LDFLAGS" >> $config_host_mak
 echo "CC=$cc" >> $config_host_mak
 echo "BUILD_CFLAGS=$BUILD_CFLAGS $CFLAGS" >> $config_host_mak
 echo "INSTALL_PREFIX=$prefix" >> $config_host_mak
+
+if [ `dirname $0` != "." -a ! -e Makefile ]; then
+    cat > Makefile <<EOF
+SRCDIR:=`dirname $0`
+include \$(SRCDIR)/Makefile
+EOF
+fi
