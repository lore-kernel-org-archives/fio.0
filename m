Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 04/11] os: introduce ioprio_value() helper
Date: Tue,  6 Jul 2021 09:17:36 +0900
Message-Id: <20210706001743.10818-5-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Introduce the ioprio_value() helper function to calculate a priority
value based on a priority class and priority level. For Linux and
Android, this is defined as an integer equal to the priority class
shifted left by 13 bits and or-ed with the priority level. For
Dragonfly, ioprio_value() simply return the priority level as their is
no concept of priority class.

Use this new helper in the io_uring and libaio engines to set IO
priority when the cmdprio_percentage option is used.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 engines/io_uring.c |  2 +-
 engines/libaio.c   |  2 +-
 os/os-android.h    | 19 ++++++++++++-------
 os/os-dragonfly.h  |  1 +
 os/os-linux.h      | 19 ++++++++++++-------
 os/os.h            |  1 +
 6 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 9c091e37..1ab1406f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -381,7 +381,7 @@ static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld = td->io_ops_data;
 	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
-		ld->sqes[io_u->index].ioprio = IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
+		ld->sqes[io_u->index].ioprio = ioprio_value(IOPRIO_CLASS_RT, 0);
 		io_u->flags |= IO_U_F_PRIORITY;
 	}
 	return;
diff --git a/engines/libaio.c b/engines/libaio.c
index b909b79e..b12b6ffc 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -136,7 +136,7 @@ static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct libaio_options *o = td->eo;
 	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
-		io_u->iocb.aio_reqprio = IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
+		io_u->iocb.aio_reqprio = ioprio_value(IOPRIO_CLASS_RT, 0);
 		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
 		io_u->flags |= IO_U_F_PRIORITY;
 	}
diff --git a/os/os-android.h b/os/os-android.h
index a81cd815..6801b8a8 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -173,16 +173,21 @@ enum {
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
 
-static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+static inline int ioprio_value(int ioprio_class, int ioprio)
 {
 	/*
-	 * If no class is set, assume BE
-	 */
-	if (!ioprio_class)
-		ioprio_class = IOPRIO_CLASS_BE;
+         * If no class is set, assume BE
+         */
+        if (!ioprio_class)
+                ioprio_class = IOPRIO_CLASS_BE;
+
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+}
 
-	ioprio |= ioprio_class << IOPRIO_CLASS_SHIFT;
-	return syscall(__NR_ioprio_set, which, who, ioprio);
+static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+{
+	return syscall(__NR_ioprio_set, which, who,
+		       ioprio_value(ioprio_class, ioprio));
 }
 
 #ifndef BLKGETSIZE64
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 6e465894..5b37a37e 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -171,6 +171,7 @@ static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
  * ioprio_set() with 4 arguments, so define fio's ioprio_set() as a macro.
  * Note that there is no idea of class within ioprio_set(2) unlike Linux.
  */
+#define ioprio_value(ioprio_class, ioprio)	(ioprio)
 #define ioprio_set(which, who, ioprio_class, ioprio)	\
 	ioprio_set(which, who, ioprio)
 
diff --git a/os/os-linux.h b/os/os-linux.h
index f7137abe..87bed43b 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -120,16 +120,21 @@ enum {
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
 
-static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+static inline int ioprio_value(int ioprio_class, int ioprio)
 {
 	/*
-	 * If no class is set, assume BE
-	 */
-	if (!ioprio_class)
-		ioprio_class = IOPRIO_CLASS_BE;
+         * If no class is set, assume BE
+         */
+        if (!ioprio_class)
+                ioprio_class = IOPRIO_CLASS_BE;
+
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+}
 
-	ioprio |= ioprio_class << IOPRIO_CLASS_SHIFT;
-	return syscall(__NR_ioprio_set, which, who, ioprio);
+static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+{
+	return syscall(__NR_ioprio_set, which, who,
+		       ioprio_value(ioprio_class, ioprio));
 }
 
 #ifndef CONFIG_HAVE_GETTID
diff --git a/os/os.h b/os/os.h
index e47d3d97..7bf7c53c 100644
--- a/os/os.h
+++ b/os/os.h
@@ -118,6 +118,7 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
 #ifndef FIO_HAVE_IOPRIO
+#define ioprio_value(prioclass, prio)	(0)
 #define ioprio_set(which, who, prioclass, prio)	(0)
 #endif
 
-- 
2.31.1


