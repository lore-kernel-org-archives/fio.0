Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34210 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdCOMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Mar 2017 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1co7b4-0005kc-UC
        for fio@vger.kernel.org; Wed, 15 Mar 2017 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170315120002.54C982C27A6@kernel.dk>
Date: Wed, 15 Mar 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1df28a3960734e1e00cb2e5fe0e261fcba30f7c7:

  Conditionally enable FIO_HAVE_PSHARED_MUTEX on FreeBSD (2017-03-13 12:54:18 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 06eac6b2318da7759a055c4a3ac01c2c1e8aa764:

  configure: add generic pshared mutex test (2017-03-14 10:52:42 +0000)

----------------------------------------------------------------
Sitsofe Wheeler (1):
      configure: add generic pshared mutex test

 README          |  8 ++++----
 configure       | 31 +++++++++++++++++++++++++++++++
 init.c          |  2 +-
 mutex.c         |  6 +++---
 os/os-aix.h     |  2 --
 os/os-android.h |  1 -
 os/os-freebsd.h |  4 ----
 os/os-hpux.h    |  1 -
 os/os-linux.h   |  1 -
 os/os-solaris.h |  1 -
 10 files changed, 39 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index 9493c2a..951550b 100644
--- a/README
+++ b/README
@@ -205,10 +205,10 @@ implemented, I'd be happy to take patches for that. An example of that is disk
 utility statistics and (I think) huge page support, support for that does exist
 in FreeBSD/Solaris.
 
-Fio uses pthread mutexes for signalling and locking and FreeBSD does not
-support process shared pthread mutexes. As a result, only threads are
-supported on FreeBSD. This could be fixed with sysv ipc locking or
-other locking alternatives.
+Fio uses pthread mutexes for signalling and locking and some platforms do not
+support process shared pthread mutexes. As a result, on such platforms only
+threads are supported. This could be fixed with sysv ipc locking or other
+locking alternatives.
 
 Other \*BSD platforms are untested, but fio should work there almost out of the
 box. Since I don't do test runs or even compiles on those platforms, your
diff --git a/configure b/configure
index a7610b1..9335124 100755
--- a/configure
+++ b/configure
@@ -605,6 +605,34 @@ fi
 echo "POSIX AIO fsync               $posix_aio_fsync"
 
 ##########################################
+# POSIX pshared attribute probe
+posix_pshared="no"
+cat > $TMPC <<EOF
+#include <unistd.h>
+int main(void)
+{
+#if defined(_POSIX_THREAD_PROCESS_SHARED) && ((_POSIX_THREAD_PROCESS_SHARED + 0) > 0)
+# if defined(__CYGWIN__)
+#  error "_POSIX_THREAD_PROCESS_SHARED is buggy on Cygwin"
+# elif defined(__APPLE__)
+#  include <AvailabilityMacros.h>
+#  include <TargetConditionals.h>
+#  if TARGET_OS_MAC && MAC_OS_X_VERSION_MIN_REQUIRED < 1070
+#   error "_POSIX_THREAD_PROCESS_SHARED is buggy/unsupported prior to OSX 10.7"
+#  endif
+# endif
+#else
+# error "_POSIX_THREAD_PROCESS_SHARED is unsupported"
+#endif
+  return 0;
+}
+EOF
+if compile_prog "" "$LIBS" "posix_pshared" ; then
+  posix_pshared=yes
+fi
+echo "POSIX pshared support         $posix_pshared"
+
+##########################################
 # solaris aio probe
 if test "$solaris_aio" != "yes" ; then
   solaris_aio="no"
@@ -1986,6 +2014,9 @@ fi
 if test "$posix_aio_fsync" = "yes" ; then
   output_sym "CONFIG_POSIXAIO_FSYNC"
 fi
+if test "$posix_pshared" = "yes" ; then
+  output_sym "CONFIG_PSHARED"
+fi
 if test "$linux_fallocate" = "yes" ; then
   output_sym "CONFIG_LINUX_FALLOCATE"
 fi
diff --git a/init.c b/init.c
index 18538de..54fdb92 100644
--- a/init.c
+++ b/init.c
@@ -586,7 +586,7 @@ static int fixup_options(struct thread_data *td)
 	struct thread_options *o = &td->o;
 	int ret = 0;
 
-#ifndef FIO_HAVE_PSHARED_MUTEX
+#ifndef CONFIG_PSHARED
 	if (!o->use_thread) {
 		log_info("fio: this platform does not support process shared"
 			 " mutexes, forcing use of threads. Use the 'thread'"
diff --git a/mutex.c b/mutex.c
index 5e5a064..d8c4825 100644
--- a/mutex.c
+++ b/mutex.c
@@ -47,7 +47,7 @@ int cond_init_pshared(pthread_cond_t *cond)
 		return ret;
 	}
 
-#ifdef FIO_HAVE_PSHARED_MUTEX
+#ifdef CONFIG_PSHARED
 	ret = pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
 	if (ret) {
 		log_err("pthread_condattr_setpshared: %s\n", strerror(ret));
@@ -77,7 +77,7 @@ int mutex_init_pshared(pthread_mutex_t *mutex)
 	/*
 	 * Not all platforms support process shared mutexes (FreeBSD)
 	 */
-#ifdef FIO_HAVE_PSHARED_MUTEX
+#ifdef CONFIG_PSHARED
 	ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
 	if (ret) {
 		log_err("pthread_mutexattr_setpshared: %s\n", strerror(ret));
@@ -287,7 +287,7 @@ struct fio_rwlock *fio_rwlock_init(void)
 		log_err("pthread_rwlockattr_init: %s\n", strerror(ret));
 		goto err;
 	}
-#ifdef FIO_HAVE_PSHARED_MUTEX
+#ifdef CONFIG_PSHARED
 	ret = pthread_rwlockattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
 	if (ret) {
 		log_err("pthread_rwlockattr_setpshared: %s\n", strerror(ret));
diff --git a/os/os-aix.h b/os/os-aix.h
index bdc190a..e204d6f 100644
--- a/os/os-aix.h
+++ b/os/os-aix.h
@@ -14,8 +14,6 @@
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 
-#define FIO_HAVE_PSHARED_MUTEX
-
 #define OS_MAP_ANON		MAP_ANON
 #define OS_MSG_DONTWAIT		0
 
diff --git a/os/os-android.h b/os/os-android.h
index cdae703..b59fac1 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -27,7 +27,6 @@
 #define FIO_HAVE_ODIRECT
 #define FIO_HAVE_HUGETLB
 #define FIO_HAVE_BLKTRACE
-#define FIO_HAVE_PSHARED_MUTEX
 #define FIO_HAVE_CL_SIZE
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_TRIM
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 3d7dbe6..c7863b5 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -24,10 +24,6 @@
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_SHM_ATTACH_REMOVED
 
-#if _POSIX_THREAD_PROCESS_SHARED > 0
-#define FIO_HAVE_PSHARED_MUTEX
-#endif
-
 #define OS_MAP_ANON		MAP_ANON
 
 #define fio_swap16(x)	bswap16(x)
diff --git a/os/os-hpux.h b/os/os-hpux.h
index 1707ddd..6a240b0 100644
--- a/os/os-hpux.h
+++ b/os/os-hpux.h
@@ -22,7 +22,6 @@
 #define FIO_HAVE_ODIRECT
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
-#define FIO_HAVE_PSHARED_MUTEX
 #define FIO_HAVE_CHARDEV_SIZE
 
 #define OS_MAP_ANON		MAP_ANONYMOUS
diff --git a/os/os-linux.h b/os/os-linux.h
index 7be833b..7b328dc 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -32,7 +32,6 @@
 #define FIO_HAVE_HUGETLB
 #define FIO_HAVE_RAWBIND
 #define FIO_HAVE_BLKTRACE
-#define FIO_HAVE_PSHARED_MUTEX
 #define FIO_HAVE_CL_SIZE
 #define FIO_HAVE_CGROUPS
 #define FIO_HAVE_FS_STAT
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 73ad84a..8f8f53b 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -16,7 +16,6 @@
 #include "../file.h"
 
 #define FIO_HAVE_CPU_AFFINITY
-#define FIO_HAVE_PSHARED_MUTEX
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
