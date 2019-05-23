Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbfEWMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 May 2019 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTmOJ-0000Xd-VX
        for fio@vger.kernel.org; Thu, 23 May 2019 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190523120002.56F4F2C00A7@kernel.dk>
Date: Thu, 23 May 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a819dfb6b6b1e1e1339bbd8c3a446b52b5e7575c:

  io_uring: sync with liburing/kernel (2019-05-20 08:49:49 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to de5ed0e4d398bc9d4576f9b2b82d7686989c27e1:

  configure: add gettid() test (2019-05-22 17:12:55 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fio 3.14
      configure: add gettid() test

 FIO-VERSION-GEN   |  2 +-
 configure         | 18 ++++++++++++++++++
 os/os-dragonfly.h |  2 ++
 os/os-linux.h     |  2 ++
 os/os-mac.h       |  2 ++
 os/os-netbsd.h    |  2 ++
 os/os-openbsd.h   |  2 ++
 os/os-solaris.h   |  2 ++
 os/os-windows.h   |  2 ++
 os/os.h           |  2 ++
 10 files changed, 35 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 37fb1a7a..69222008 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.13
+DEF_VER=fio-3.14
 
 LF='
 '
diff --git a/configure b/configure
index d71387c0..ee421663 100755
--- a/configure
+++ b/configure
@@ -2374,6 +2374,21 @@ EOF
 fi
 print_config "MADV_HUGEPAGE" "$thp"
 
+##########################################
+# check for gettid()
+gettid="no"
+cat > $TMPC << EOF
+#include <unistd.h>
+int main(int argc, char **argv)
+{
+  return gettid();
+}
+EOF
+if compile_prog "" "" "gettid"; then
+  gettid="yes"
+fi
+print_config "gettid" "$gettid"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2645,6 +2660,9 @@ fi
 if test "$__kernel_rwf_t" = "yes"; then
   output_sym "CONFIG_HAVE_KERNEL_RWF_T"
 fi
+if test "$gettid" = "yes"; then
+  output_sym "CONFIG_HAVE_GETTID"
+fi
 if test "$fallthrough" = "yes"; then
   CFLAGS="$CFLAGS -Wimplicit-fallthrough"
 fi
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index eb92521f..3c460ae2 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -202,10 +202,12 @@ static inline unsigned long long os_phys_mem(void)
 	return mem;
 }
 
+#ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
 	return (int) lwp_gettid();
 }
+#endif
 
 static inline unsigned long long get_fs_free_size(const char *path)
 {
diff --git a/os/os-linux.h b/os/os-linux.h
index ba58bf7d..36339ef3 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -124,10 +124,12 @@ static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 	return syscall(__NR_ioprio_set, which, who, ioprio);
 }
 
+#ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
 	return syscall(__NR_gettid);
 }
+#endif
 
 #define SPLICE_DEF_SIZE	(64*1024)
 
diff --git a/os/os-mac.h b/os/os-mac.h
index 0b9c8707..a073300c 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -90,10 +90,12 @@ static inline unsigned long long os_phys_mem(void)
 	return mem;
 }
 
+#ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
 	return mach_thread_self();
 }
+#endif
 
 /*
  * For some reason, there's no header definition for fdatasync(), even
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index c06261d4..88fb3ef1 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -65,10 +65,12 @@ static inline unsigned long long os_phys_mem(void)
 	return mem;
 }
 
+#ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
 	return (int) _lwp_self();
 }
+#endif
 
 static inline unsigned long long get_fs_free_size(const char *path)
 {
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 70f58b49..43a649d4 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -65,10 +65,12 @@ static inline unsigned long long os_phys_mem(void)
 	return mem;
 }
 
+#ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
 	return (int)(intptr_t) pthread_self();
 }
+#endif
 
 static inline unsigned long long get_fs_free_size(const char *path)
 {
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 1a411af6..f1966f44 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -164,10 +164,12 @@ static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
 	return 0;
 }
 
+#ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
 	return pthread_self();
 }
+#endif
 
 /*
  * Should be enough, not aware of what (if any) restrictions Solaris has
diff --git a/os/os-windows.h b/os/os-windows.h
index dc958f5c..3e9f7341 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -162,10 +162,12 @@ static inline unsigned long long os_phys_mem(void)
 	return (unsigned long long) pages * (unsigned long long) pagesize;
 }
 
+#ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
 	return GetCurrentThreadId();
 }
+#endif
 
 static inline int init_random_seeds(uint64_t *rand_seeds, int size)
 {
diff --git a/os/os.h b/os/os.h
index 756ece4b..e4729680 100644
--- a/os/os.h
+++ b/os/os.h
@@ -373,11 +373,13 @@ static inline int CPU_COUNT(os_cpu_mask_t *mask)
 #endif
 
 #ifndef FIO_HAVE_GETTID
+#ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
 	return getpid();
 }
 #endif
+#endif
 
 #ifndef FIO_HAVE_SHM_ATTACH_REMOVED
 static inline int shm_attach_to_open_removed(void)

