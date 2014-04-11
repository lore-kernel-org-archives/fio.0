Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38309 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbaDKMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Apr 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=rt116.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYa7n-0002ni-Td
	for fio@vger.kernel.org; Fri, 11 Apr 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140411120003.605D9400AB@rt116.dk>
Date: Fri, 11 Apr 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 12d02717a293cdd0c85504c958f7bf57411bb30b:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-04-09 13:58:43 -0600)

are available in the git repository at:


  git://git.kernel.dk/fio.git master

for you to fetch changes up to 499b43c1dc1c07ef87c0736e65e357c93fc6e99e:

  Fio 2.1.8 (2014-04-10 16:50:39 -0600)

----------------------------------------------------------------
fio v2.1.8

----------------------------------------------------------------
Christian Ehrhardt (1):
      fio: fix s390 timing for older machines/binutils

Jens Axboe (4):
      Make cache invalidation a soft error
      iolog: check for thread termination in long delays
      blktrace: fix missing line return in dprint()
      Fio 2.1.8

 FIO-VERSION-GEN        |    2 +-
 arch/arch-s390.h       |   12 ++++++++----
 blktrace.c             |    2 +-
 configure              |   34 ++++++++++++++++++++++++++++++++++
 filesetup.c            |   20 ++++++++++----------
 iolog.c                |   10 +++++++++-
 os/windows/install.wxs |    2 +-
 7 files changed, 64 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 918a9df..b126baf 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.7
+DEF_VER=fio-2.1.8
 
 LF='
 '
diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index 56cb230..169282b 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -22,15 +22,19 @@
 #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
 #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
 
-/*
- * Fio needs monotonic (never lower), but not strict monotonic (never the same)
- * so store clock fast is enough
- */
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned long long clk;
 
+#ifdef CONFIG_S390_Z196_FACILITIES
+	/*
+	 * Fio needs monotonic (never lower), but not strict monotonic (never
+	 * the same) so store clock fast is enough.
+	 */
 	__asm__ __volatile__("stckf %0" : "=Q" (clk) : : "cc");
+#else
+	__asm__ __volatile__("stck %0" : "=Q" (clk) : : "cc");
+#endif
 	return clk>>12;
 }
 
diff --git a/blktrace.c b/blktrace.c
index 52f0c71..29eed50 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -150,7 +150,7 @@ static int lookup_device(struct thread_data *td, char *path, unsigned int maj,
 		 */
 		if (td->o.replay_redirect) {
 			dprint(FD_BLKTRACE, "device lookup: %d/%d\n overridden"
-					" with: %s", maj, min,
+					" with: %s\n", maj, min,
 					td->o.replay_redirect);
 			strcpy(path, td->o.replay_redirect);
 			found = 1;
diff --git a/configure b/configure
index 05f985b..4757d67 100755
--- a/configure
+++ b/configure
@@ -1181,6 +1181,36 @@ if compile_prog "" "" "setvbuf"; then
 fi
 echo "setvbuf                       $setvbuf"
 
+##########################################
+# Check if we support stckf on s390
+s390_z196_facilities="no"
+cat > $TMPC << EOF
+#define STFLE_BITS_Z196 45 /* various z196 facilities ... */
+int main(int argc, char **argv)
+{
+    /* We want just 1 double word to be returned.  */
+    register unsigned long reg0 asm("0") = 0;
+    unsigned long stfle_bits;
+    asm volatile(".machine push"        "\n\t"
+                 ".machine \"z9-109\""  "\n\t"
+                 "stfle %0"             "\n\t"
+                 ".machine pop"         "\n"
+                 : "=QS" (stfle_bits), "+d" (reg0)
+                 : : "cc");
+
+    if ((stfle_bits & (1UL << (63 - STFLE_BITS_Z196))) != 0)
+      return 0;
+    else
+      return -1;
+}
+EOF
+if compile_prog "" "" "s390_z196_facilities"; then
+  $TMPE
+  if [[ $? -eq 0 ]]; then
+  	s390_z196_facilities="yes"
+  fi
+fi
+echo "s390_z196_facilities          $s390_z196_facilities"
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1311,6 +1341,10 @@ fi
 if test "$setvbuf" = "yes" ; then
   output_sym "CONFIG_SETVBUF"
 fi
+if test "$s390_z196_facilities" = "yes" ; then
+  output_sym "CONFIG_S390_Z196_FACILITIES"
+  CFLAGS="$CFLAGS -march=z9-109"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CFLAGS+=$CFLAGS" >> $config_host_mak
diff --git a/filesetup.c b/filesetup.c
index abea1e6..1c52979 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -395,9 +395,6 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	dprint(FD_IO, "invalidate cache %s: %llu/%llu\n", f->file_name, off,
 								len);
 
-	/*
-	 * FIXME: add blockdev flushing too
-	 */
 	if (f->mmap_ptr) {
 		ret = posix_madvise(f->mmap_ptr, f->mmap_sz, POSIX_MADV_DONTNEED);
 #ifdef FIO_MADV_FREE
@@ -419,15 +416,18 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	} else if (f->filetype == FIO_TYPE_CHAR || f->filetype == FIO_TYPE_PIPE)
 		ret = 0;
 
-	if (ret < 0) {
-		td_verror(td, errno, "invalidate_cache");
-		return 1;
-	} else if (ret > 0) {
-		td_verror(td, ret, "invalidate_cache");
-		return 1;
+	/*
+	 * Cache flushing isn't a fatal condition, and we know it will
+	 * happen on some platforms where we don't have the proper
+	 * function to flush eg block device caches. So just warn and
+	 * continue on our way.
+	 */
+	if (ret) {
+		log_info("fio: cache invalidation of %s failed: %s\n", f->file_name, strerror(errno));
+		ret = 0;
 	}
 
-	return ret;
+	return 0;
 
 }
 
diff --git a/iolog.c b/iolog.c
index 1eb89b2..f498959 100644
--- a/iolog.c
+++ b/iolog.c
@@ -58,6 +58,7 @@ void log_file(struct thread_data *td, struct fio_file *f,
 static void iolog_delay(struct thread_data *td, unsigned long delay)
 {
 	unsigned long usec = utime_since_now(&td->last_issue);
+	unsigned long this_delay;
 
 	if (delay < usec)
 		return;
@@ -70,7 +71,14 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 	if (delay < 100)
 		return;
 
-	usec_sleep(td, delay);
+	while (delay && !td->terminate) {
+		this_delay = delay;
+		if (this_delay > 500000)
+			this_delay = 500000;
+
+		usec_sleep(td, this_delay);
+		delay -= this_delay;
+	}
 }
 
 static int ipo_special(struct thread_data *td, struct io_piece *ipo)
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 7820449..e78bb30 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.7">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.8">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
