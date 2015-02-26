Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbbBZNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Feb 2015 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YQy2v-0000JY-Vo
	for fio@vger.kernel.org; Thu, 26 Feb 2015 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150226130002.E761E4018E@lyth.info>
Date: Thu, 26 Feb 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cf8a46a75f38afe07ebf823210f95543999e3116:

  Make 'loops' honor full write+verify loops (2015-02-24 14:50:57 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 93eeb5582d56fe5e36f455c8de26c302e317fdeb:

  Fix implicit function declaration on Android (2015-02-25 14:00:01 -0700)

----------------------------------------------------------------
Lars Marowsky-Bree (1):
      Add --output-format option to manpage.

Raphael Silva (1):
      Add missing pre-defined ARM arch compiler macro

enh (1):
      Fix implicit function declaration on Android

 arch/arch-arm.h |    3 ++-
 fio.1           |    3 +++
 os/os-android.h |   12 ++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index 7cd9502..bab886e 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -19,7 +19,8 @@
 #endif
 
 #if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) \
-	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
+	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5E__)\
+	|| defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
 	|| defined(__ARM_ARCH_6__)  || defined(__ARM_ARCH_6J__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6ZK__)
 #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
diff --git a/fio.1 b/fio.1
index 33b26cc..b746da1 100644
--- a/fio.1
+++ b/fio.1
@@ -20,6 +20,9 @@ list all available tracing options.
 .BI \-\-output \fR=\fPfilename
 Write output to \fIfilename\fR.
 .TP
+.BI \-\-output-format \fR=\fPformat
+Set the reporting format to \fInormal\fR, \fIterse\fR, or \fIjosn\fR.
+.TP
 .BI \-\-runtime \fR=\fPruntime
 Limit run time to \fIruntime\fR seconds.
 .TP
diff --git a/os/os-android.h b/os/os-android.h
index 954178d..b4f4f13 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -4,6 +4,7 @@
 #define	FIO_OS	os_android
 
 #include <sys/ioctl.h>
+#include <sys/mman.h>
 #include <sys/uio.h>
 #include <sys/syscall.h>
 #include <sys/vfs.h>
@@ -37,10 +38,13 @@
 
 #define OS_MAP_ANON		MAP_ANONYMOUS
 
+#ifndef POSIX_MADV_DONTNEED
 #define posix_madvise   madvise
 #define POSIX_MADV_DONTNEED MADV_DONTNEED
 #define POSIX_MADV_SEQUENTIAL	MADV_SEQUENTIAL
 #define POSIX_MADV_RANDOM	MADV_RANDOM
+#endif
+
 #ifdef MADV_REMOVE
 #define FIO_MADV_FREE	MADV_REMOVE
 #endif
@@ -261,4 +265,12 @@ static inline int os_trim(int fd, unsigned long long start,
 	return errno;
 }
 
+#ifdef CONFIG_SCHED_IDLE
+static inline int fio_set_sched_idle(void)
+{
+        struct sched_param p = { .sched_priority = 0, };
+        return sched_setscheduler(gettid(), SCHED_IDLE, &p);
+}
+#endif
+
 #endif
