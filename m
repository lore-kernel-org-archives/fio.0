Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58520 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161066AbbEOMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 15 May 2015 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YtEHd-0000Ks-IA
	for fio@vger.kernel.org; Fri, 15 May 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150515120002.2E7552C1079@kernel.dk>
Date: Fri, 15 May 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2378826d96532b390bd4cb08d3946b497a9b0e51:

  Add 'allow_file_create' option (2015-05-12 11:31:32 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3e55d40fb5a68773b07cebb4a74870338eab81d4:

  Change (blank)cpu affinity macros to inline functions (2015-05-15 05:18:23 +0900)

----------------------------------------------------------------
Jens Axboe (1):
      stat: add comment on why we need return

Tomohiro Kusumi (2):
      Fix warning from gmake on BSD
      Change (blank)cpu affinity macros to inline functions

 gettime-thread.c |  2 --
 os/os.h          | 18 +++++++++++++++---
 stat.c           |  2 ++
 3 files changed, 17 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/gettime-thread.c b/gettime-thread.c
index 2dc976f..9bf85f0 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -9,9 +9,7 @@
 struct timeval *fio_tv = NULL;
 int fio_gtod_offload = 0;
 static pthread_t gtod_thread;
-#ifdef FIO_HAVE_CPU_AFFINITY
 static os_cpu_mask_t fio_gtod_cpumask;
-#endif
 
 void fio_gtod_init(void)
 {
diff --git a/os/os.h b/os/os.h
index 7cb8121..250b71f 100644
--- a/os/os.h
+++ b/os/os.h
@@ -79,12 +79,24 @@ typedef struct aiocb os_aiocb_t;
 #endif
 
 #ifndef FIO_HAVE_CPU_AFFINITY
-#define fio_setaffinity(pid, mask)	(0)
 #define fio_getaffinity(pid, mask)	do { } while (0)
 #define fio_cpu_clear(mask, cpu)	do { } while (0)
-#define fio_cpuset_exit(mask)		(-1)
-#define fio_cpus_split(mask, cpu)	(0)
 typedef unsigned long os_cpu_mask_t;
+
+static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
+{
+	return 0;
+}
+
+static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
+{
+	return -1;
+}
+
+static inline int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu_index)
+{
+	return 0;
+}
 #else
 extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
diff --git a/stat.c b/stat.c
index 9a30bea..7d6ee63 100644
--- a/stat.c
+++ b/stat.c
@@ -510,7 +510,9 @@ static int block_state_category(int block_state)
 	case BLOCK_STATE_TRIM_FAILURE:
 		return 2;
 	default:
+		/* Silence compile warning on some BSDs and have a return */
 		assert(0);
+		return -1;
 	}
 }
 
