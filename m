Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 01/17] Add runtime handlers for 97900ebf for FreeBSD/DragonFlyBSD
Date: Tue,  7 Mar 2017 22:12:52 +0200
Message-Id: <20170307201308.66814-2-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

As 97900ebf itself explains, this is a runtime tunable on FreeBSD
and DragonFlyBSD, so they need to check the sysctl on runtime.

Not sure if OpenBSD has any tunable for this as the original commit
only says about >=5.1, but afaik recent versions of OpenBSD can't
even compile fio anyway. Also not sure how it works on NetBSD, and
the original commit said nothing about it too. Also see below url.

http://www.spinics.net/lists/fio/msg05586.html
http://www.spinics.net/lists/fio/msg05588.html

--
 # uname -r
 11.0-RELEASE-p1
 # cat ./test1.c
 #include <stdio.h>
 #include "./os/os-freebsd.h"
 int main(void) {
         printf("%d\n", shm_attach_to_open_removed());
         return 0;
 }
 # clang -Wall -g ./test1.c
 # sysctl kern.ipc.shm_allow_removed
 kern.ipc.shm_allow_removed: 1
 # ./a.out
 1
 # sysctl kern.ipc.shm_allow_removed=123
 kern.ipc.shm_allow_removed: 1 -> 123
 # ./a.out
 1
 # sysctl kern.ipc.shm_allow_removed=0
 kern.ipc.shm_allow_removed: 123 -> 0
 # ./a.out
 0

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c            |  5 ++---
 os/os-dragonfly.h | 14 ++++++++++++--
 os/os-freebsd.h   | 15 ++++++++++++---
 os/os-linux.h     |  5 +++++
 os/os-openbsd.h   | 12 +++++++++---
 os/os.h           |  7 +++++++
 6 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/init.c b/init.c
index fabc887..acdc659 100644
--- a/init.c
+++ b/init.c
@@ -356,9 +356,8 @@ static int setup_thread_area(void)
 		perror("shmat");
 		return 1;
 	}
-#ifdef FIO_HAVE_SHM_ATTACH_REMOVED
-	shmctl(shm_id, IPC_RMID, NULL);
-#endif
+	if (shm_attach_to_open_removed())
+		shmctl(shm_id, IPC_RMID, NULL);
 #endif
 
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 5e94855..97452ca 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -24,8 +24,7 @@
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_IOPRIO
-/* Only have attach-to-open-removed when kern.ipc.shm_allow_removed is 1 */
-#undef  FIO_HAVE_SHM_ATTACH_REMOVED
+#define FIO_HAVE_SHM_ATTACH_REMOVED
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -234,4 +233,15 @@ static inline int os_trim(int fd, unsigned long long start,
 #define FIO_MADV_FREE	MADV_FREE
 #endif
 
+static inline int shm_attach_to_open_removed(void)
+{
+	int x;
+	size_t len = sizeof(x);
+
+	if (sysctlbyname("kern.ipc.shm_allow_removed", &x, &len, NULL, 0) < 0)
+		return 0;
+
+	return x > 0 ? 1 : 0;
+}
+
 #endif
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index aa90954..9d1af3b 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -22,9 +22,7 @@
 #define FIO_HAVE_TRIM
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
-/* Only have attach-to-open-removed when kern.ipc.shm_allow_removed is 1 */
-#undef  FIO_HAVE_SHM_ATTACH_REMOVED
-
+#define FIO_HAVE_SHM_ATTACH_REMOVED
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -136,4 +134,15 @@ static inline int os_trim(int fd, unsigned long long start,
 #define FIO_MADV_FREE	MADV_FREE
 #endif
 
+static inline int shm_attach_to_open_removed(void)
+{
+	int x;
+	size_t len = sizeof(x);
+
+	if (sysctlbyname("kern.ipc.shm_allow_removed", &x, &len, NULL, 0) < 0)
+		return 0;
+
+	return x > 0 ? 1 : 0;
+}
+
 #endif
diff --git a/os/os-linux.h b/os/os-linux.h
index 1829829..7be833b 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -350,4 +350,9 @@ static inline ssize_t pwritev2(int fd, const struct iovec *iov, int iovcnt,
 #endif /* __NR_preadv2 */
 #endif /* CONFIG_PWRITEV2 */
 
+static inline int shm_attach_to_open_removed(void)
+{
+	return 1;
+}
+
 #endif
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 4700572..3b19483 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -22,12 +22,10 @@
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
+#define FIO_HAVE_SHM_ATTACH_REMOVED
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
 
-/* Only OpenBSD 5.1 and above have attach-to-open-removed semantics */
-#undef  FIO_HAVE_SHM_ATTACH_REMOVED
-
 #define OS_MAP_ANON		MAP_ANON
 
 #ifndef PTHREAD_STACK_MIN
@@ -90,4 +88,12 @@ static inline unsigned long long get_fs_free_size(const char *path)
 #define FIO_MADV_FREE	MADV_FREE
 #endif
 
+static inline int shm_attach_to_open_removed(void)
+{
+	/*
+	 * XXX: Return 1 if >= OpenBSD 5.1 according to 97900ebf.
+	 */
+	return 0;
+}
+
 #endif
diff --git a/os/os.h b/os/os.h
index 4178e6f..5e3c813 100644
--- a/os/os.h
+++ b/os/os.h
@@ -386,4 +386,11 @@ static inline int gettid(void)
 }
 #endif
 
+#ifndef FIO_HAVE_SHM_ATTACH_REMOVED
+static inline int shm_attach_to_open_removed(void)
+{
+	return 0;
+}
+#endif
+
 #endif
-- 
2.9.3


