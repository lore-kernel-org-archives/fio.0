Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/7] Add CPU affinity support for DragonFlyBSD
Date: Wed, 20 Jul 2016 01:33:42 +0900
Message-Id: <1468946027-22580-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Confirmed that the cpu affinity works using cpuio engine.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 os/os-dragonfly.h | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 2 deletions(-)

diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index d776d1f..57958ca 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -10,6 +10,7 @@
 #include <sys/statvfs.h>
 #include <sys/diskslice.h>
 #include <sys/ioctl_compat.h>
+#include <sys/usched.h>
 
 #include "../file.h"
 
@@ -20,8 +21,7 @@
 #define FIO_HAVE_TRIM
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_GETTID
-
-#undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
+#define FIO_HAVE_CPU_AFFINITY
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -33,7 +33,123 @@
 #define fio_swap32(x)	bswap32(x)
 #define fio_swap64(x)	bswap64(x)
 
+/* This is supposed to equal (sizeof(cpumask_t)*8) */
+#define FIO_MAX_CPUS	SMP_MAXCPU
+
 typedef off_t off64_t;
+typedef cpumask_t os_cpu_mask_t;
+
+/*
+ * These macros are copied from sys/cpu/x86_64/include/types.h.
+ * It's okay to copy from arch dependent header because x86_64 is the only
+ * supported arch, and no other arch is going to be supported any time soon.
+ *
+ * These are supposed to be able to be included from userspace by defining
+ * _KERNEL_STRUCTURES, however this scheme is badly broken that enabling it
+ * causes compile-time conflicts with other headers. Although the current
+ * upstream code no longer requires _KERNEL_STRUCTURES, they should be kept
+ * here for compatibility with older versions.
+ */
+#ifndef CPUMASK_SIMPLE
+#define CPUMASK_SIMPLE(cpu)		((uint64_t)1 << (cpu))
+#define CPUMASK_TESTBIT(val, i)		((val).ary[((i) >> 6) & 3] & \
+					 CPUMASK_SIMPLE((i) & 63))
+#define CPUMASK_ORBIT(mask, i)		((mask).ary[((i) >> 6) & 3] |= \
+					 CPUMASK_SIMPLE((i) & 63))
+#define CPUMASK_NANDBIT(mask, i)	((mask).ary[((i) >> 6) & 3] &= \
+					 ~CPUMASK_SIMPLE((i) & 63))
+#define CPUMASK_ASSZERO(mask)		do {				\
+					(mask).ary[0] = 0;		\
+					(mask).ary[1] = 0;		\
+					(mask).ary[2] = 0;		\
+					(mask).ary[3] = 0;		\
+					} while(0)
+#endif
+
+/*
+ * Define USCHED_GET_CPUMASK as the macro didn't exist until release 4.5.
+ * usched_set(2) returns EINVAL if the kernel doesn't support it, though
+ * fio_getaffinity() returns void.
+ *
+ * Also note usched_set(2) works only for the current thread regardless of
+ * the command type. It doesn't work against another thread regardless of
+ * a caller's privilege. A caller would generally specify 0 for pid for the
+ * current thread though that's the only choice. See BUGS in usched_set(2).
+ */
+#ifndef USCHED_GET_CPUMASK
+#define USCHED_GET_CPUMASK	5
+#endif
+
+static inline int fio_cpuset_init(os_cpu_mask_t *mask)
+{
+	CPUMASK_ASSZERO(*mask);
+	return 0;
+}
+
+static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
+{
+	return 0;
+}
+
+static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
+{
+	CPUMASK_NANDBIT(*mask, cpu);
+}
+
+static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
+{
+	CPUMASK_ORBIT(*mask, cpu);
+}
+
+static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
+{
+	if (CPUMASK_TESTBIT(*mask, cpu))
+		return 1;
+
+	return 0;
+}
+
+static inline int fio_cpu_count(os_cpu_mask_t *mask)
+{
+	int i, n = 0;
+
+	for (i = 0; i < FIO_MAX_CPUS; i++)
+		if (CPUMASK_TESTBIT(*mask, i))
+			n++;
+
+	return n;
+}
+
+static inline int fio_setaffinity(int pid, os_cpu_mask_t mask)
+{
+	int i, firstcall = 1;
+
+	/* 0 for the current thread, see BUGS in usched_set(2) */
+	pid = 0;
+
+	for (i = 0; i < FIO_MAX_CPUS; i++) {
+		if (!CPUMASK_TESTBIT(mask, i))
+			continue;
+		if (firstcall) {
+			if (usched_set(pid, USCHED_SET_CPU, &i, sizeof(int)))
+				return -1;
+			firstcall = 0;
+		} else {
+			if (usched_set(pid, USCHED_ADD_CPU, &i, sizeof(int)))
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
+static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
+{
+	/* 0 for the current thread, see BUGS in usched_set(2) */
+	pid = 0;
+
+	usched_set(pid, USCHED_GET_CPUMASK, mask, sizeof(*mask));
+}
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
-- 
2.5.5


