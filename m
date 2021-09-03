Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 04/11] os: introduce ioprio_value() helper
Date: Fri, 3 Sep 2021 15:20:23 +0000
Message-ID: <20210903152012.18035-5-Niklas.Cassel@wdc.com>
References: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Damien Le Moal <damien.lemoal@wdc.com>

Introduce the ioprio_value() helper function to calculate a priority
value based on a priority class and priority level. For Linux and
Android, this is defined as an integer equal to the priority class
shifted left by 13 bits and or-ed with the priority level. For
Dragonfly, ioprio_value() simply returns the priority level as there
is no concept of priority class.

Use this new helper in the io_uring and libaio engines to set IO
priority when the cmdprio_percentage option is used.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/io_uring.c |  2 +-
 engines/libaio.c   |  2 +-
 os/os-android.h    | 15 ++++++++++-----
 os/os-dragonfly.h  |  1 +
 os/os-linux.h      | 15 ++++++++++-----
 os/os.h            |  1 +
 6 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index b8d4cf91..4f8b5582 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -382,7 +382,7 @@ static void fio_ioring_prio_prep(struct thread_data *td=
, struct io_u *io_u)
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld =3D td->io_ops_data;
 	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
-		ld->sqes[io_u->index].ioprio =3D IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
+		ld->sqes[io_u->index].ioprio =3D ioprio_value(IOPRIO_CLASS_RT, 0);
 		io_u->flags |=3D IO_U_F_PRIORITY;
 	} else {
 		ld->sqes[io_u->index].ioprio =3D 0;
diff --git a/engines/libaio.c b/engines/libaio.c
index b909b79e..b12b6ffc 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -136,7 +136,7 @@ static void fio_libaio_prio_prep(struct thread_data *td=
, struct io_u *io_u)
 {
 	struct libaio_options *o =3D td->eo;
 	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
-		io_u->iocb.aio_reqprio =3D IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
+		io_u->iocb.aio_reqprio =3D ioprio_value(IOPRIO_CLASS_RT, 0);
 		io_u->iocb.u.c.flags |=3D IOCB_FLAG_IOPRIO;
 		io_u->flags |=3D IO_U_F_PRIORITY;
 	}
diff --git a/os/os-android.h b/os/os-android.h
index a81cd815..f013172f 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -173,16 +173,21 @@ enum {
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
=20
-static inline int ioprio_set(int which, int who, int ioprio_class, int iop=
rio)
+static inline int ioprio_value(int ioprio_class, int ioprio)
 {
 	/*
 	 * If no class is set, assume BE
 	 */
-	if (!ioprio_class)
-		ioprio_class =3D IOPRIO_CLASS_BE;
+        if (!ioprio_class)
+                ioprio_class =3D IOPRIO_CLASS_BE;
+
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+}
=20
-	ioprio |=3D ioprio_class << IOPRIO_CLASS_SHIFT;
-	return syscall(__NR_ioprio_set, which, who, ioprio);
+static inline int ioprio_set(int which, int who, int ioprio_class, int iop=
rio)
+{
+	return syscall(__NR_ioprio_set, which, who,
+		       ioprio_value(ioprio_class, ioprio));
 }
=20
 #ifndef BLKGETSIZE64
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 6e465894..5b37a37e 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -171,6 +171,7 @@ static inline int fio_getaffinity(int pid, os_cpu_mask_=
t *mask)
  * ioprio_set() with 4 arguments, so define fio's ioprio_set() as a macro.
  * Note that there is no idea of class within ioprio_set(2) unlike Linux.
  */
+#define ioprio_value(ioprio_class, ioprio)	(ioprio)
 #define ioprio_set(which, who, ioprio_class, ioprio)	\
 	ioprio_set(which, who, ioprio)
=20
diff --git a/os/os-linux.h b/os/os-linux.h
index 16ed5258..12886037 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -118,16 +118,21 @@ enum {
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
=20
-static inline int ioprio_set(int which, int who, int ioprio_class, int iop=
rio)
+static inline int ioprio_value(int ioprio_class, int ioprio)
 {
 	/*
 	 * If no class is set, assume BE
 	 */
-	if (!ioprio_class)
-		ioprio_class =3D IOPRIO_CLASS_BE;
+        if (!ioprio_class)
+                ioprio_class =3D IOPRIO_CLASS_BE;
+
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+}
=20
-	ioprio |=3D ioprio_class << IOPRIO_CLASS_SHIFT;
-	return syscall(__NR_ioprio_set, which, who, ioprio);
+static inline int ioprio_set(int which, int who, int ioprio_class, int iop=
rio)
+{
+	return syscall(__NR_ioprio_set, which, who,
+		       ioprio_value(ioprio_class, ioprio));
 }
=20
 #ifndef CONFIG_HAVE_GETTID
diff --git a/os/os.h b/os/os.h
index 17daf91d..f2257a7c 100644
--- a/os/os.h
+++ b/os/os.h
@@ -118,6 +118,7 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned=
 int cpu);
 #endif
=20
 #ifndef FIO_HAVE_IOPRIO
+#define ioprio_value(prioclass, prio)	(0)
 #define ioprio_set(which, who, prioclass, prio)	(0)
 #endif
=20
--=20
2.31.1

