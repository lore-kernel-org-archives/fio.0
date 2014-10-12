Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaJLMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 12 Oct 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XdHoi-0005Ni-4n
	for fio@vger.kernel.org; Sun, 12 Oct 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141012120002.CF7B940151@lyth.info>
Date: Sun, 12 Oct 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3441a52d588b95267f31491d4dca5f1418b1dcf5:

  engines/libaio: better protect against a busy loop in getevents() (2014-10-09 20:14:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aa7bc282868ab33ea59b28827041626ef6545c95:

  Makefile: don't install test binaries (2014-10-11 10:19:42 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Makefile: don't install test binaries

 Makefile |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 5b03ec4..750eccd 100644
--- a/Makefile
+++ b/Makefile
@@ -179,7 +179,7 @@ T_IEEE_PROGS = t/ieee754
 
 T_ZIPF_OBS = t/genzipf.o
 T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/zipf.o t/genzipf.o
-T_ZIPF_PROGS = t/genzipf
+T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
 T_AXMAP_OBJS += lib/lfsr.o lib/axmap.o
@@ -192,14 +192,14 @@ T_LFSR_TEST_PROGS = t/lfsr-test
 ifeq ($(CONFIG_TARGET_OS), Linux)
 T_BTRACE_FIO_OBJS = t/btrace2fio.o
 T_BTRACE_FIO_OBJS += fifo.o lib/flist_sort.o t/log.o lib/linux-dev-lookup.o
-T_BTRACE_FIO_PROGS = t/btrace2fio
+T_BTRACE_FIO_PROGS = t/fio-btrace2fio
 endif
 
 T_DEDUPE_OBJS = t/dedupe.o
 T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
 		memalign.o lib/bloom.o t/debug.o crc/xxhash.o crc/murmur3.o \
 		crc/crc32c.o crc/crc32c-intel.o crc/fnv.o
-T_DEDUPE_PROGS = t/dedupe
+T_DEDUPE_PROGS = t/fio-dedupe
 
 T_OBJS = $(T_SMALLOC_OBJS)
 T_OBJS += $(T_IEEE_OBJS)
@@ -209,11 +209,11 @@ T_OBJS += $(T_LFSR_TEST_OBJS)
 T_OBJS += $(T_BTRACE_FIO_OBJS)
 T_OBJS += $(T_DEDUPE_OBJS)
 
-T_PROGS = $(T_SMALLOC_PROGS)
-T_PROGS += $(T_IEEE_PROGS)
+T_TEST_PROGS = $(T_SMALLOC_PROGS)
+T_TEST_PROGS += $(T_IEEE_PROGS)
 T_PROGS += $(T_ZIPF_PROGS)
-T_PROGS += $(T_AXMAP_PROGS)
-T_PROGS += $(T_LFSR_TEST_PROGS)
+T_TEST_PROGS += $(T_AXMAP_PROGS)
+T_TEST_PROGS += $(T_LFSR_TEST_PROGS)
 T_PROGS += $(T_BTRACE_FIO_PROGS)
 T_PROGS += $(T_DEDUPE_PROGS)
 
@@ -245,7 +245,7 @@ mandir = $(prefix)/man
 sharedir = $(prefix)/share/fio
 endif
 
-all: $(PROGS) $(SCRIPTS) FORCE
+all: $(PROGS) $(T_TEST_PROGS) $(SCRIPTS) FORCE
 
 .PHONY: all install clean
 .PHONY: FORCE cscope
@@ -332,7 +332,7 @@ fio: $(FIO_OBJS)
 gfio: $(GFIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o gfio $(GFIO_OBJS) $(LIBS) $(GTK_LDFLAGS)
 
-t/genzipf: $(T_ZIPF_OBJS)
+t/fio-genzipf: $(T_ZIPF_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_ZIPF_OBJS) $(LIBS)
 
 t/axmap: $(T_AXMAP_OBJS)
@@ -342,15 +342,15 @@ t/lfsr-test: $(T_LFSR_TEST_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS)
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
-t/btrace2fio: $(T_BTRACE_FIO_OBJS)
+t/fio-btrace2fio: $(T_BTRACE_FIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_BTRACE_FIO_OBJS) $(LIBS)
 endif
 
-t/dedupe: $(T_DEDUPE_OBJS)
+t/fio-dedupe: $(T_DEDUPE_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
 
 clean: FORCE
-	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
+	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 
 distclean: clean FORCE
 	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf
