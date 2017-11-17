Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47600 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934522AbdKQNAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Nov 2017 08:00:12 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eFgFd-0000AJ-Om
        for fio@vger.kernel.org; Fri, 17 Nov 2017 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171117130002.EC2F32C009D@kernel.dk>
Date: Fri, 17 Nov 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 522c29f69a31542170d94611e05e1780e4c08dbd:

  man page: fix bad case for 'pre-reading file' state (2017-11-15 09:53:14 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to adf075fa89a7f3bbb45237f1440de0583833bd80:

  ioengines: remove pointless list initializations (2017-11-16 20:03:15 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      os: make fio_cpu_isset() return a bool
      ioengines: remove pointless list initializations

Robert Elliott (2):
      .gitignore: ignore .exe files (for Windows)
      os-windows: fix cpumask operations

 .gitignore        |  1 +
 ioengines.c       |  4 +---
 os/os-dragonfly.h |  8 +++-----
 os/os-freebsd.h   |  2 +-
 os/os-linux.h     |  2 +-
 os/os-solaris.h   | 12 +++++++-----
 os/os-windows.h   |  7 ++++---
 7 files changed, 18 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index a07a324..463b53a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,5 +1,6 @@
 *.d
 *.o
+*.exe
 /.depend
 /FIO-VERSION-FILE
 /config-host.h
diff --git a/ioengines.c b/ioengines.c
index 1bfc06f..02eaee8 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -52,14 +52,12 @@ static bool check_engine_ops(struct ioengine_ops *ops)
 void unregister_ioengine(struct ioengine_ops *ops)
 {
 	dprint(FD_IO, "ioengine %s unregistered\n", ops->name);
-	flist_del(&ops->list);
-	INIT_FLIST_HEAD(&ops->list);
+	flist_del_init(&ops->list);
 }
 
 void register_ioengine(struct ioengine_ops *ops)
 {
 	dprint(FD_IO, "ioengine %s registered\n", ops->name);
-	INIT_FLIST_HEAD(&ops->list);
 	flist_add_tail(&ops->list, &engine_list);
 }
 
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 423b236..713046f 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -15,6 +15,7 @@
 #include <sys/resource.h>
 
 #include "../file.h"
+#include "../lib/types.h"
 
 #define FIO_HAVE_ODIRECT
 #define FIO_USE_GENERIC_RAND
@@ -107,12 +108,9 @@ static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
 	CPUMASK_ORBIT(*mask, cpu);
 }
 
-static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
+static inline bool fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
 {
-	if (CPUMASK_TESTBIT(*mask, cpu))
-		return 1;
-
-	return 0;
+	return CPUMASK_TESTBIT(*mask, cpu) != 0;
 }
 
 static inline int fio_setaffinity(int pid, os_cpu_mask_t mask)
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 4a7cdeb..97bc8ae 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -37,7 +37,7 @@ typedef cpuset_t os_cpu_mask_t;
 
 #define fio_cpu_clear(mask, cpu)        (void) CPU_CLR((cpu), (mask))
 #define fio_cpu_set(mask, cpu)          (void) CPU_SET((cpu), (mask))
-#define fio_cpu_isset(mask, cpu)	CPU_ISSET((cpu), (mask))
+#define fio_cpu_isset(mask, cpu)	(CPU_ISSET((cpu), (mask)) != 0)
 #define fio_cpu_count(mask)		CPU_COUNT((mask))
 
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
diff --git a/os/os-linux.h b/os/os-linux.h
index 1ad6ebd..894dc85 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -71,7 +71,7 @@ typedef struct drand48_data os_random_state_t;
 
 #define fio_cpu_clear(mask, cpu)	(void) CPU_CLR((cpu), (mask))
 #define fio_cpu_set(mask, cpu)		(void) CPU_SET((cpu), (mask))
-#define fio_cpu_isset(mask, cpu)	CPU_ISSET((cpu), (mask))
+#define fio_cpu_isset(mask, cpu)	(CPU_ISSET((cpu), (mask)) != 0)
 #define fio_cpu_count(mask)		CPU_COUNT((mask))
 
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 2f13723..db03546 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -16,6 +16,7 @@
 #include <pthread.h>
 
 #include "../file.h"
+#include "../lib/types.h"
 
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_CHARDEV_SIZE
@@ -126,24 +127,25 @@ static inline int fio_set_odirect(struct fio_file *f)
 #define fio_cpu_clear(mask, cpu)	pset_assign(PS_NONE, (cpu), NULL)
 #define fio_cpu_set(mask, cpu)		pset_assign(*(mask), (cpu), NULL)
 
-static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
+static inline bool fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
 {
 	const unsigned int max_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	unsigned int num_cpus;
 	processorid_t *cpus;
-	int i, ret;
+	bool ret;
+	int i;
 
 	cpus = malloc(sizeof(*cpus) * max_cpus);
 
 	if (pset_info(*mask, NULL, &num_cpus, cpus) < 0) {
 		free(cpus);
-		return 0;
+		return false;
 	}
 
-	ret = 0;
+	ret = false;
 	for (i = 0; i < num_cpus; i++) {
 		if (cpus[i] == cpu) {
-			ret = 1;
+			ret = true;
 			break;
 		}
 	}
diff --git a/os/os-windows.h b/os/os-windows.h
index 520da19..9b04579 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -17,6 +17,7 @@
 #include "../log.h"
 #include "../lib/hweight.h"
 #include "../oslib/strcasestr.h"
+#include "../lib/types.h"
 
 #include "windows/posix.h"
 
@@ -209,17 +210,17 @@ static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 
 static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
 {
-	*mask ^= 1 << (cpu-1);
+	*mask &= ~(1ULL << cpu);
 }
 
 static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
 {
-	*mask |= 1 << cpu;
+	*mask |= 1ULL << cpu;
 }
 
 static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
 {
-	return (*mask & (1U << cpu));
+	return (*mask & (1ULL << cpu)) != 0;
 }
 
 static inline int fio_cpu_count(os_cpu_mask_t *mask)
