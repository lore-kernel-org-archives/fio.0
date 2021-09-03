Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 06/11] libaio,io_uring: improve cmdprio_percentage option
Date: Fri, 3 Sep 2021 15:20:24 +0000
Message-ID: <20210903152012.18035-7-Niklas.Cassel@wdc.com>
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

The cmdprio_percentage option of the libaio and io_uring engines defines
a single percentage that applies to all IO operations, regardless of
their direction. This prevents defining different high priority IO
percentages for reads and writes operations. This differentiation can
however be useful in the case of a mixed read-write workload (rwmixread
and rwmixwrite options).

Change the option definition to allow specifying a comma separated list
of percentages, 2 at most, one for reads and one for writes. If only a
single percentage is defined, it applies to both reads and writes as
before. The cmdprio_percentage option becomes an array of DDIR_RWDIR_CNT
elements indexed with enum fio_ddir values. The last entry of the array
(for DDIR_TRIM) is always 0.

Also create a new cmdprio helper file, engines/cmdprio.h,
such that we can avoid code duplication between io_uring and libaio
io engines. This helper file will be extended in subsequent patches.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 HOWTO              | 16 ++++++++--------
 engines/cmdprio.h  | 44 ++++++++++++++++++++++++++++++++++++++++++++
 engines/io_uring.c | 40 ++++++++++++++++++++++------------------
 engines/libaio.c   | 35 ++++++++++++++++++++---------------
 fio.1              | 14 +++++++-------
 5 files changed, 101 insertions(+), 48 deletions(-)
 create mode 100644 engines/cmdprio.h

diff --git a/HOWTO b/HOWTO
index 96b680dd..916f5191 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2163,14 +2163,14 @@ In addition, there are some parameters which are on=
ly valid when a specific
 with the caveat that when used on the command line, they must come after t=
he
 :option:`ioengine` that defines them is selected.
=20
-.. option:: cmdprio_percentage=3Dint : [io_uring] [libaio]
-
-    Set the percentage of I/O that will be issued with higher priority by =
setting
-    the priority bit. Non-read I/O is likely unaffected by ``cmdprio_perce=
ntage``.
-    This option cannot be used with the `prio` or `prioclass` options. For=
 this
-    option to set the priority bit properly, NCQ priority must be supporte=
d and
-    enabled and :option:`direct`\=3D1 option must be used. fio must also b=
e run as
-    the root user.
+.. option:: cmdprio_percentage=3Dint[,int] : [io_uring] [libaio]
+
+    Set the percentage of I/O that will be issued with the highest priorit=
y.
+    Default: 0. A single value applies to reads and writes. Comma-separate=
d
+    values may be specified for reads and writes. This option cannot be us=
ed
+    with the :option:`prio` or :option:`prioclass` options. For this optio=
n
+    to be effective, NCQ priority must be supported and enabled, and `dire=
ct=3D1'
+    option must be used. fio must also be run as the root user.
=20
 .. option:: fixedbufs : [io_uring]
=20
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
new file mode 100644
index 00000000..19120d78
--- /dev/null
+++ b/engines/cmdprio.h
@@ -0,0 +1,44 @@
+/*
+ * IO priority handling declarations and helper functions common to the
+ * libaio and io_uring engines.
+ */
+
+#ifndef FIO_CMDPRIO_H
+#define FIO_CMDPRIO_H
+
+#include "../fio.h"
+
+struct cmdprio {
+	unsigned int percentage[DDIR_RWDIR_CNT];
+};
+
+static int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdpri=
o,
+			    bool *has_cmdprio)
+{
+	struct thread_options *to =3D &td->o;
+	bool has_cmdprio_percentage =3D false;
+	int i;
+
+	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+		if (cmdprio->percentage[i])
+			has_cmdprio_percentage =3D true;
+	}
+
+	/*
+	 * Check for option conflicts
+	 */
+	if (has_cmdprio_percentage &&
+	    (fio_option_is_set(to, ioprio) ||
+	     fio_option_is_set(to, ioprio_class))) {
+		log_err("%s: cmdprio_percentage option and mutually exclusive "
+			"prio or prioclass option is set, exiting\n",
+			to->name);
+		return 1;
+	}
+
+	*has_cmdprio =3D has_cmdprio_percentage;
+
+	return 0;
+}
+
+#endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 4f8b5582..1731eb24 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -23,6 +23,7 @@
=20
 #include "../lib/types.h"
 #include "../os/linux/io_uring.h"
+#include "cmdprio.h"
=20
 struct io_sq_ring {
 	unsigned *head;
@@ -69,12 +70,14 @@ struct ioring_data {
 	int prepped;
=20
 	struct ioring_mmap mmap[3];
+
+	bool use_cmdprio;
 };
=20
 struct ioring_options {
 	void *pad;
 	unsigned int hipri;
-	unsigned int cmdprio_percentage;
+	struct cmdprio cmdprio;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
 	unsigned int sqpoll_thread;
@@ -120,8 +123,11 @@ static struct fio_option options[] =3D {
 		.name	=3D "cmdprio_percentage",
 		.lname	=3D "high priority percentage",
 		.type	=3D FIO_OPT_INT,
-		.off1	=3D offsetof(struct ioring_options, cmdprio_percentage),
-		.minval	=3D 1,
+		.off1	=3D offsetof(struct ioring_options,
+				   cmdprio.percentage[DDIR_READ]),
+		.off2	=3D offsetof(struct ioring_options,
+				   cmdprio.percentage[DDIR_WRITE]),
+		.minval	=3D 0,
 		.maxval	=3D 100,
 		.help	=3D "Send high priority I/O this percentage of the time",
 		.category =3D FIO_OPT_C_ENGINE,
@@ -381,13 +387,16 @@ static void fio_ioring_prio_prep(struct thread_data *=
td, struct io_u *io_u)
 {
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld =3D td->io_ops_data;
-	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
-		ld->sqes[io_u->index].ioprio =3D ioprio_value(IOPRIO_CLASS_RT, 0);
+	struct io_uring_sqe *sqe =3D &ld->sqes[io_u->index];
+	struct cmdprio *cmdprio =3D &o->cmdprio;
+	unsigned int p =3D cmdprio->percentage[io_u->ddir];
+
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		sqe->ioprio =3D ioprio_value(IOPRIO_CLASS_RT, 0);
 		io_u->flags |=3D IO_U_F_PRIORITY;
 	} else {
-		ld->sqes[io_u->index].ioprio =3D 0;
+		sqe->ioprio =3D 0;
 	}
-	return;
 }
=20
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
@@ -395,7 +404,6 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 {
 	struct ioring_data *ld =3D td->io_ops_data;
 	struct io_sq_ring *ring =3D &ld->sq_ring;
-	struct ioring_options *o =3D td->eo;
 	unsigned tail, next_tail;
=20
 	fio_ro_check(td, io_u);
@@ -418,7 +426,7 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 	if (next_tail =3D=3D atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
=20
-	if (o->cmdprio_percentage)
+	if (ld->use_cmdprio)
 		fio_ioring_prio_prep(td, io_u);
 	ring->array[tail & ld->sq_ring_mask] =3D io_u->index;
 	atomic_store_release(ring->tail, next_tail);
@@ -729,7 +737,8 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld;
-	struct thread_options *to =3D &td->o;
+	struct cmdprio *cmdprio =3D &o->cmdprio;
+	int ret;
=20
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
@@ -753,14 +762,9 @@ static int fio_ioring_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	/*
-	 * Check for option conflicts
-	 */
-	if ((fio_option_is_set(to, ioprio) || fio_option_is_set(to, ioprio_class)=
) &&
-			o->cmdprio_percentage !=3D 0) {
-		log_err("%s: cmdprio_percentage option and mutually exclusive "
-				"prio or prioclass option is set, exiting\n", to->name);
-		td_verror(td, EINVAL, "fio_io_uring_init");
+	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	if (ret) {
+		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
 	}
=20
diff --git a/engines/libaio.c b/engines/libaio.c
index b12b6ffc..8cf560c5 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -15,6 +15,7 @@
 #include "../lib/pow2.h"
 #include "../optgroup.h"
 #include "../lib/memalign.h"
+#include "cmdprio.h"
=20
 /* Should be defined in newest aio_abi.h */
 #ifndef IOCB_FLAG_IOPRIO
@@ -50,12 +51,14 @@ struct libaio_data {
 	unsigned int queued;
 	unsigned int head;
 	unsigned int tail;
+
+	bool use_cmdprio;
 };
=20
 struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
-	unsigned int cmdprio_percentage;
+	struct cmdprio cmdprio;
 	unsigned int nowait;
 };
=20
@@ -74,8 +77,11 @@ static struct fio_option options[] =3D {
 		.name	=3D "cmdprio_percentage",
 		.lname	=3D "high priority percentage",
 		.type	=3D FIO_OPT_INT,
-		.off1	=3D offsetof(struct libaio_options, cmdprio_percentage),
-		.minval	=3D 1,
+		.off1	=3D offsetof(struct libaio_options,
+				   cmdprio.percentage[DDIR_READ]),
+		.off2	=3D offsetof(struct libaio_options,
+				   cmdprio.percentage[DDIR_WRITE]),
+		.minval	=3D 0,
 		.maxval	=3D 100,
 		.help	=3D "Send high priority I/O this percentage of the time",
 		.category =3D FIO_OPT_C_ENGINE,
@@ -135,12 +141,14 @@ static int fio_libaio_prep(struct thread_data *td, st=
ruct io_u *io_u)
 static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u=
)
 {
 	struct libaio_options *o =3D td->eo;
-	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
+	struct cmdprio *cmdprio =3D &o->cmdprio;
+	unsigned int p =3D cmdprio->percentage[io_u->ddir];
+
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		io_u->iocb.aio_reqprio =3D ioprio_value(IOPRIO_CLASS_RT, 0);
 		io_u->iocb.u.c.flags |=3D IOCB_FLAG_IOPRIO;
 		io_u->flags |=3D IO_U_F_PRIORITY;
 	}
-	return;
 }
=20
 static struct io_u *fio_libaio_event(struct thread_data *td, int event)
@@ -246,7 +254,6 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld =3D td->io_ops_data;
-	struct libaio_options *o =3D td->eo;
=20
 	fio_ro_check(td, io_u);
=20
@@ -277,7 +284,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 		return FIO_Q_COMPLETED;
 	}
=20
-	if (o->cmdprio_percentage)
+	if (ld->use_cmdprio)
 		fio_libaio_prio_prep(td, io_u);
=20
 	ld->iocbs[ld->head] =3D &io_u->iocb;
@@ -420,8 +427,9 @@ static int fio_libaio_post_init(struct thread_data *td)
 static int fio_libaio_init(struct thread_data *td)
 {
 	struct libaio_data *ld;
-	struct thread_options *to =3D &td->o;
 	struct libaio_options *o =3D td->eo;
+	struct cmdprio *cmdprio =3D &o->cmdprio;
+	int ret;
=20
 	ld =3D calloc(1, sizeof(*ld));
=20
@@ -432,16 +440,13 @@ static int fio_libaio_init(struct thread_data *td)
 	ld->io_us =3D calloc(ld->entries, sizeof(struct io_u *));
=20
 	td->io_ops_data =3D ld;
-	/*
-	 * Check for option conflicts
-	 */
-	if ((fio_option_is_set(to, ioprio) || fio_option_is_set(to, ioprio_class)=
) &&
-			o->cmdprio_percentage !=3D 0) {
-		log_err("%s: cmdprio_percentage option and mutually exclusive "
-				"prio or prioclass option is set, exiting\n", to->name);
+
+	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	if (ret) {
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
 	}
+
 	return 0;
 }
=20
diff --git a/fio.1 b/fio.1
index 87ca8e73..3611da98 100644
--- a/fio.1
+++ b/fio.1
@@ -1962,13 +1962,13 @@ In addition, there are some parameters which are on=
ly valid when a specific
 with the caveat that when used on the command line, they must come after t=
he
 \fBioengine\fR that defines them is selected.
 .TP
-.BI (io_uring,libaio)cmdprio_percentage \fR=3D\fPint
-Set the percentage of I/O that will be issued with higher priority by sett=
ing
-the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentag=
e``.
-This option cannot be used with the `prio` or `prioclass` options. For thi=
s
-option to set the priority bit properly, NCQ priority must be supported an=
d
-enabled and `direct=3D1' option must be used. fio must also be run as the =
root
-user.
+.BI (io_uring,libaio)cmdprio_percentage \fR=3D\fPint[,int]
+Set the percentage of I/O that will be issued with the highest priority.
+Default: 0. A single value applies to reads and writes. Comma-separated
+values may be specified for reads and writes. This option cannot be used
+with the `prio` or `prioclass` options. For this option to be effective,
+NCQ priority must be supported and enabled, and `direct=3D1' option must b=
e
+used. fio must also be run as the root user.
 .TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO cal=
l, and
--=20
2.31.1

