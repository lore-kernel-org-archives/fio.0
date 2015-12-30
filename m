Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49732 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbbL3NAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Dec 2015 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aEGMF-0006vI-M8
	for fio@vger.kernel.org; Wed, 30 Dec 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151230130002.10B262C00B6@kernel.dk>
Date: Wed, 30 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2c2c93d8bd89c0cb15fc2430f9838744153a3946:

  t/genzipf: fix for strcasestr missing (2015-12-28 17:39:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to de26b8245b06c99ec64d9f88cfde1ed9627f871a:

  configure: add --enable-lex (2015-12-29 20:58:13 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      t/dedupe: silence bogus warning on 'bytes' being used uninitialized
      configure: check if lex requires/fails with -o for output
      configure: add --enable-lex

 Makefile   |  4 ++++
 configure  | 26 ++++++++++++++++++++++++--
 t/dedupe.c |  2 +-
 3 files changed, 29 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 510e257..1b5c9a6 100644
--- a/Makefile
+++ b/Makefile
@@ -297,7 +297,11 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 
 ifdef CONFIG_ARITHMETIC
 lex.yy.c: exp/expression-parser.l
+ifdef CONFIG_LEX_USE_O
 	$(QUIET_LEX)$(LEX) -o $@ $<
+else
+	$(QUIET_LEX)$(LEX) $<
+endif
 
 lex.yy.o: lex.yy.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
diff --git a/configure b/configure
index af26165..e92e96b 100755
--- a/configure
+++ b/configure
@@ -135,7 +135,7 @@ show_help="no"
 exit_val=0
 gfio_check="no"
 libhdfs="no"
-disable_lex="no"
+disable_lex=""
 prefix=/usr/local
 
 # parse options
@@ -171,6 +171,8 @@ for opt do
   ;;
   --disable-lex) disable_lex="yes"
   ;;
+  --enable-lex) disable_lex="no"
+  ;;
   --disable-shm) no_shm="yes"
   ;;
   --disable-optimizations) disable_opt="yes"
@@ -198,6 +200,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-gfapi        Disable gfapi"
   echo "--enable-libhdfs       Enable hdfs support"
   echo "--disable-lex          Disable use of lex/yacc for math"
+  echo "--enable-lex           Enable use of lex/yacc for math"
   echo "--disable-shm          Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
   exit $exit_val
@@ -240,6 +243,12 @@ fi
 # cross-compiling to one of these OSes then you'll need to specify
 # the correct CPU with the --cpu option.
 case $targetos in
+AIX)
+  # Unless explicitly enabled, turn off lex.
+  if test -z "$disable_lex" ; then
+    disable_lex="yes"
+  fi
+  ;;
 Darwin)
   # on Leopard most of the system is 32-bit, so we have to ask the kernel if
   # we can run 64-bit userspace code.
@@ -1455,7 +1464,7 @@ yacc="no"
 yacc_is_bison="no"
 lex="no"
 arith="no"
-if test "$disable_lex" = "no"; then
+if test "$disable_lex" = "no" || test -z "$disable_lex" ; then
 if test "$targetos" != "SunOS" ; then
 LEX=$(which lex 2> /dev/null)
 if test -x "$LEX" ; then
@@ -1494,6 +1503,16 @@ fi
 fi
 fi
 
+# Check if lex fails using -o
+if test "$arith" = "yes" ; then
+$LEX -o lex.yy.c exp/expression-parser.l 2> /dev/null
+if test "$?" = "0" ; then
+  lex_use_o="yes"
+else
+  lex_use_o="no"
+fi
+fi
+
 echo "lex/yacc for arithmetic       $arith"
 
 ##########################################
@@ -1756,6 +1775,9 @@ if test "$arith" = "yes" ; then
   else
     echo "YACC=$YACC" >> $config_host_mak
   fi
+  if test "$lex_use_o" = "yes" ; then
+    echo "CONFIG_LEX_USE_O=y" >> $config_host_mak
+  fi
 fi
 if test "$getmntent" = "yes" ; then
   output_sym "CONFIG_GETMNTENT"
diff --git a/t/dedupe.c b/t/dedupe.c
index e1cea50..3a66820 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -84,7 +84,7 @@ static uint64_t get_size(struct fio_file *f, struct stat *sb)
 	uint64_t ret;
 
 	if (S_ISBLK(sb->st_mode)) {
-		unsigned long long bytes;
+		unsigned long long bytes = 0;
 
 		if (blockdev_size(f, &bytes)) {
 			log_err("dedupe: failed getting bdev size\n");
