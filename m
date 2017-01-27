Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33062 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754799AbdA0NAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 Jan 2017 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cX68K-00077x-MG
        for fio@vger.kernel.org; Fri, 27 Jan 2017 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170127130002.5F5F42C0167@kernel.dk>
Date: Fri, 27 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bd4d9bdc5097c3b35b5172508e1a2828296e01c2:

  Remove/Move Linux specific sysfs_root field from thread_data (2017-01-23 08:26:12 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f0ac17190989b4ada1d4d74be8d7a4ef3a76dfbb:

  Merge branch 'shm_rm' of https://github.com/sitsofe/fio (2017-01-26 10:07:48 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'sphinx-doc' of https://github.com/termim/fio
      Merge branch 'shm_rm' of https://github.com/sitsofe/fio

Mikhail Terekhov (1):
      fix manpage heading issue

Sitsofe Wheeler (1):
      shm: have os remove shared memory if fio dies unexpectedly

 doc/fio_man.rst   | 3 ++-
 init.c            | 3 +++
 os/os-dragonfly.h | 2 ++
 os/os-freebsd.h   | 3 +++
 os/os-linux.h     | 1 +
 os/os-openbsd.h   | 3 +++
 6 files changed, 14 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/doc/fio_man.rst b/doc/fio_man.rst
index 7eae05e..c6a6438 100644
--- a/doc/fio_man.rst
+++ b/doc/fio_man.rst
@@ -1,6 +1,7 @@
 :orphan:
 
-
+Fio Manpage
+===========
 
 (rev. |release|)
 
diff --git a/init.c b/init.c
index c3cc3e5..34ed20f 100644
--- a/init.c
+++ b/init.c
@@ -356,6 +356,9 @@ static int setup_thread_area(void)
 		perror("shmat");
 		return 1;
 	}
+#ifdef FIO_HAVE_SHM_ATTACH_REMOVED
+	shmctl(shm_id, IPC_RMID, NULL);
+#endif
 #endif
 
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index c799817..5e94855 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -24,6 +24,8 @@
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_IOPRIO
+/* Only have attach-to-open-removed when kern.ipc.shm_allow_removed is 1 */
+#undef  FIO_HAVE_SHM_ATTACH_REMOVED
 
 #define OS_MAP_ANON		MAP_ANON
 
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index ac408c9..aa90954 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -22,6 +22,9 @@
 #define FIO_HAVE_TRIM
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
+/* Only have attach-to-open-removed when kern.ipc.shm_allow_removed is 1 */
+#undef  FIO_HAVE_SHM_ATTACH_REMOVED
+
 
 #define OS_MAP_ANON		MAP_ANON
 
diff --git a/os/os-linux.h b/os/os-linux.h
index 06235ab..1829829 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -41,6 +41,7 @@
 #define FIO_HAVE_GETTID
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_PWRITEV2
+#define FIO_HAVE_SHM_ATTACH_REMOVED
 
 #ifdef MAP_HUGETLB
 #define FIO_HAVE_MMAP_HUGE
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 3343cbd..4700572 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -25,6 +25,9 @@
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
 
+/* Only OpenBSD 5.1 and above have attach-to-open-removed semantics */
+#undef  FIO_HAVE_SHM_ATTACH_REMOVED
+
 #define OS_MAP_ANON		MAP_ANON
 
 #ifndef PTHREAD_STACK_MIN
