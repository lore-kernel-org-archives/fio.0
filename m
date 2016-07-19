Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 5/7] Add ioprio_set() support for DragonFlyBSD
Date: Wed, 20 Jul 2016 01:33:45 +0900
Message-Id: <1468946027-22580-5-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

It basically has the same interface as Linux kernel's ioprio_set(2),
but needed to workaround a compile issue by defining it as a macro
as mentioned in a comment (it can be called without syscall(NR, ...)).

This commit is based on the last two commits which made I/O priority
option more generic for non Linux environment.

 # uname
 DragonFly
 # fio --cmdhelp | grep prioclass -B1
 prio                    : Set job IO priority value
 prioclass               : Your platform does not support IO priority classes

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 HOWTO             |  3 ++-
 os/os-dragonfly.h | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 2a4f4d0..ab25cb2 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1064,7 +1064,8 @@ nice=int	Run the job with the given nice value. See man nice(2).
 
 prio=int	Set the io priority value of this job. Linux limits us to
 		a positive value between 0 and 7, with 0 being the highest.
-		See man ionice(1).
+		See man ionice(1). Refer to an appropriate manpage for
+		other operating systems since meaning of priority may differ.
 
 prioclass=int	Set the io priority class. See man ionice(1).
 
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 57958ca..187330b 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -11,6 +11,7 @@
 #include <sys/diskslice.h>
 #include <sys/ioctl_compat.h>
 #include <sys/usched.h>
+#include <sys/resource.h>
 
 #include "../file.h"
 
@@ -22,6 +23,7 @@
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
+#define FIO_HAVE_IOPRIO
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -151,6 +153,22 @@ static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
 	usched_set(pid, USCHED_GET_CPUMASK, mask, sizeof(*mask));
 }
 
+/* fio code is Linux based, so rename macros to Linux style */
+#define IOPRIO_WHO_PROCESS	PRIO_PROCESS
+#define IOPRIO_WHO_PGRP		PRIO_PGRP
+#define IOPRIO_WHO_USER		PRIO_USER
+
+#define IOPRIO_MIN_PRIO		1	/* lowest priority */
+#define IOPRIO_MAX_PRIO		10	/* highest priority */
+
+/*
+ * Prototypes declared in sys/sys/resource.h are preventing from defining
+ * ioprio_set() with 4 arguments, so define fio's ioprio_set() as a macro.
+ * Note that there is no idea of class within ioprio_set(2) unlike Linux.
+ */
+#define ioprio_set(which, who, ioprio_class, ioprio)	\
+	ioprio_set(which, who, ioprio)
+
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
 	struct partinfo pi;
-- 
2.5.5


