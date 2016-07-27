Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 03/15] Use default CPU_COUNT() function in DragonFlyBSD
Date: Wed, 27 Jul 2016 22:37:08 +0900
Message-Id: <1469626640-13335-3-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

os/os.h has a default CPU_COUNT() inline function for those that
are expected to have CPU_COUNT() macro, but not in certain versions.
This seems to have been added for RHEL5 (or older?) and variants,
but use this in os/os-dragonfly.h since it's essentially the same
as its own fio_cpu_count() implementation.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 os/os-dragonfly.h | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index d4a9579..c799817 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -81,6 +81,9 @@ typedef cpumask_t os_cpu_mask_t;
 #define USCHED_GET_CPUMASK	5
 #endif
 
+/* No CPU_COUNT(), but use the default function defined in os/os.h */
+#define fio_cpu_count(mask)             CPU_COUNT((mask))
+
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
 	CPUMASK_ASSZERO(*mask);
@@ -110,17 +113,6 @@ static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
 	return 0;
 }
 
-static inline int fio_cpu_count(os_cpu_mask_t *mask)
-{
-	int i, n = 0;
-
-	for (i = 0; i < FIO_MAX_CPUS; i++)
-		if (CPUMASK_TESTBIT(*mask, i))
-			n++;
-
-	return n;
-}
-
 static inline int fio_setaffinity(int pid, os_cpu_mask_t mask)
 {
 	int i, firstcall = 1;
-- 
2.5.5


