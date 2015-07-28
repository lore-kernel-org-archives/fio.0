Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbG1MAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jul 2015 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZK3YE-0001ca-0w
	for fio@vger.kernel.org; Tue, 28 Jul 2015 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150728120001.96E062C0069@kernel.dk>
Date: Tue, 28 Jul 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1520f26e713a2fded6728ad372af0d7b8c197adf:

  Re-seed random generator correctly between loops (2015-07-16 14:56:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 61054f0d5c2ccb945c240704fc4bfa6a708eaf46:

  configure: add --disable-optimizations (2015-07-27 15:10:00 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      libfio: add runstate names
      configure: make __sync_fetch_and_add() test use 64-bit types
      Fix potential divide-by-zero in calc_rate()
      Fix potential divide-by-zero in calc_iops()
      configure: add --disable-optimizations

 Makefile  |  6 +++++-
 configure | 18 +++++++++++++++---
 eta.c     | 22 ++++++++++++++++------
 fio.h     |  1 +
 libfio.c  | 29 +++++++++++++++++++++++++++--
 5 files changed, 64 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 7fe7d4d..24663a4 100644
--- a/Makefile
+++ b/Makefile
@@ -22,12 +22,16 @@ endif
 
 DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
-OPTFLAGS= -O3 -g -ffast-math
+OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio)
 
+ifndef CONFIG_FIO_NO_OPT
+  CFLAGS += -O3
+endif
+
 ifdef CONFIG_GFIO
   PROGS += gfio
 endif
diff --git a/configure b/configure
index 6807679..4fb65e6 100755
--- a/configure
+++ b/configure
@@ -168,7 +168,9 @@ for opt do
   ;;
   --enable-libhdfs) libhdfs="yes"
   ;;
-  --disable-shm) output_sym "CONFIG_NO_SHM"
+  --disable-shm) no_shm="yes"
+  ;;
+  --disable-optimizations) disable_opt="yes"
   ;;
   --help)
     show_help="yes"
@@ -193,6 +195,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-gfapi        Disable gfapi"
   echo "--enable-libhdfs       Enable hdfs support"
   echo "--disable-shm          Disable SHM support"
+  echo "--disable-optimizations Don't enable compiler optimizations"
   exit $exit_val
 fi
 
@@ -220,6 +223,14 @@ printf " '%s'" "$0" "$@" >> $config_host_mak
 echo >> $config_host_mak
 echo "CONFIG_TARGET_OS=$targetos" >> $config_host_mak
 
+if test "$no_shm" = "yes" ; then
+  output_sym "CONFIG_NO_SHM"
+fi
+
+if test "$disable_opt" = "yes" ; then
+  output_sym "CONFIG_FIO_NO_OPT"
+fi
+
 # Some host OSes need non-standard checks for which CPU to use.
 # Note that these checks are broken for cross-compilation: if you're
 # cross-compiling to one of these OSes then you'll need to specify
@@ -550,14 +561,15 @@ echo "Solaris AIO support           $solaris_aio"
 # __sync_fetch_and_add test
 sfaa="no"
 cat > $TMPC << EOF
-static int sfaa(int *ptr)
+#include <inttypes.h>
+static int sfaa(uint64_t *ptr)
 {
   return __sync_fetch_and_add(ptr, 0);
 }
 
 int main(int argc, char **argv)
 {
-  int val = 42;
+  uint64_t val = 42;
   sfaa(&val);
   return val;
 }
diff --git a/eta.c b/eta.c
index aed61ec..db045cb 100644
--- a/eta.c
+++ b/eta.c
@@ -290,14 +290,19 @@ static void calc_rate(int unified_rw_rep, unsigned long mtime,
 	int i;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		unsigned long long diff;
+		unsigned long long diff, this_rate;
 
 		diff = io_bytes[i] - prev_io_bytes[i];
+		if (mtime)
+			this_rate = ((1000 * diff) / mtime) / 1024;
+		else
+			this_rate = 0;
+
 		if (unified_rw_rep) {
 			rate[i] = 0;
-			rate[0] += ((1000 * diff) / mtime) / 1024;
+			rate[0] += this_rate;
 		} else
-			rate[i] = ((1000 * diff) / mtime) / 1024;
+			rate[i] = this_rate;
 
 		prev_io_bytes[i] = io_bytes[i];
 	}
@@ -310,14 +315,19 @@ static void calc_iops(int unified_rw_rep, unsigned long mtime,
 	int i;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		unsigned long long diff;
+		unsigned long long diff, this_iops;
 
 		diff = io_iops[i] - prev_io_iops[i];
+		if (mtime)
+			this_iops = (diff * 1000) / mtime;
+		else
+			this_iops = 0;
+
 		if (unified_rw_rep) {
 			iops[i] = 0;
-			iops[0] += (diff * 1000) / mtime;
+			iops[0] += this_iops;
 		} else
-			iops[i] = (diff * 1000) / mtime;
+			iops[i] = this_iops;
 
 		prev_io_iops[i] = io_iops[i];
 	}
diff --git a/fio.h b/fio.h
index 744d994..81d58e8 100644
--- a/fio.h
+++ b/fio.h
@@ -517,6 +517,7 @@ enum {
 	TD_FINISHING,
 	TD_EXITED,
 	TD_REAPED,
+	TD_LAST,
 };
 
 extern void td_set_runstate(struct thread_data *, int);
diff --git a/libfio.c b/libfio.c
index 30a3acb..b0141a7 100644
--- a/libfio.c
+++ b/libfio.c
@@ -169,13 +169,38 @@ const char *fio_get_arch_string(int nr)
 	return NULL;
 }
 
+static const char *td_runstates[] = {
+	"NOT_CREATED",
+	"CREATED",
+	"INITIALIZED",
+	"RAMP",
+	"SETTING_UP",
+	"RUNNING",
+	"PRE_READING",
+	"VERIFYING",
+	"FSYNCING",
+	"FINISHING",
+	"EXITED",
+	"REAPED",
+};
+
+static const char *runstate_to_name(int runstate)
+{
+	compiletime_assert(TD_LAST == 12, "td runstate list");
+	if (runstate >= 0 && runstate < TD_LAST)
+		return td_runstates[runstate];
+
+	return "invalid";
+}
+
 void td_set_runstate(struct thread_data *td, int runstate)
 {
 	if (td->runstate == runstate)
 		return;
 
-	dprint(FD_PROCESS, "pid=%d: runstate %d -> %d\n", (int) td->pid,
-						td->runstate, runstate);
+	dprint(FD_PROCESS, "pid=%d: runstate %s -> %s\n", (int) td->pid,
+						runstate_to_name(td->runstate),
+						runstate_to_name(runstate));
 	td->runstate = runstate;
 }
 
