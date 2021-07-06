Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 06/11] libaio,io_uring: improve cmdprio_percentage option
Date: Tue,  6 Jul 2021 09:17:38 +0900
Message-Id: <20210706001743.10818-7-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

The cmdprio_percentage option of the libaio and io_uring engines defines
a single percentage that applies to all IO operations, regardless of
their direction. This prevents defining different high priority IO
percentages for reads and writes operations. This differentiation can
however be useful in the case of a mixed read-write workload (rwmixread
and rwmixwrite options).

Change the option definition to allow specifying a comma separated list
of percentages, 2 at most, one for read and one for writes. If only a
single percentage is defined, it applies to both reads and writes as
before. The cmdprio_percentage option becomes an array of DDIR_RWDIR_CNT
elements indexed with enum fio_ddir values. The last entry of the array
(for DDIR_TRIM) is always 0.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 HOWTO              | 16 ++++++++--------
 engines/io_uring.c | 27 +++++++++++++++++----------
 engines/libaio.c   | 26 +++++++++++++++++---------
 fio.1              | 14 +++++++-------
 4 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/HOWTO b/HOWTO
index 86fb2964..36ad8176 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2117,14 +2117,14 @@ In addition, there are some parameters which are only valid when a specific
 with the caveat that when used on the command line, they must come after the
 :option:`ioengine` that defines them is selected.
 
-.. option:: cmdprio_percentage=int : [io_uring] [libaio]
-
-    Set the percentage of I/O that will be issued with higher priority by setting
-    the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentage``.
-    This option cannot be used with the `prio` or `prioclass` options. For this
-    option to set the priority bit properly, NCQ priority must be supported and
-    enabled and :option:`direct`\=1 option must be used. fio must also be run as
-    the root user.
+.. option:: cmdprio_percentage=int[,int] : [io_uring] [libaio]
+
+    Set the percentage of I/O that will be issued with the highest priority.
+    Default: 0. A single value applies to reads and writes. Comma-separated
+    values may be specified for reads and writes. This option cannot be used
+    with the :option:`prio` or :option:`prioclass` options. For this option
+    to be effective, NCQ priority must be supported and enabled, and `direct=1'
+    option must be used. fio must also be run as the root user.
 
 .. option:: fixedbufs : [io_uring]
 
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1ab1406f..d083a65f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -74,7 +74,7 @@ struct ioring_data {
 struct ioring_options {
 	void *pad;
 	unsigned int hipri;
-	unsigned int cmdprio_percentage;
+	unsigned int cmdprio_percentage[DDIR_RWDIR_CNT];
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
 	unsigned int sqpoll_thread;
@@ -120,8 +120,9 @@ static struct fio_option options[] = {
 		.name	= "cmdprio_percentage",
 		.lname	= "high priority percentage",
 		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct ioring_options, cmdprio_percentage),
-		.minval	= 1,
+		.off1	= offsetof(struct ioring_options, cmdprio_percentage[DDIR_READ]),
+		.off2	= offsetof(struct ioring_options, cmdprio_percentage[DDIR_WRITE]),
+		.minval	= 0,
 		.maxval	= 100,
 		.help	= "Send high priority I/O this percentage of the time",
 		.category = FIO_OPT_C_ENGINE,
@@ -380,11 +381,12 @@ static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld = td->io_ops_data;
-	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
+	unsigned int p = o->cmdprio_percentage[io_u->ddir];
+
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		ld->sqes[io_u->index].ioprio = ioprio_value(IOPRIO_CLASS_RT, 0);
 		io_u->flags |= IO_U_F_PRIORITY;
 	}
-	return;
 }
 
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
@@ -415,7 +417,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (next_tail == atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
 
-	if (o->cmdprio_percentage)
+	if (o->cmdprio_percentage[io_u->ddir])
 		fio_ioring_prio_prep(td, io_u);
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	atomic_store_release(ring->tail, next_tail);
@@ -727,6 +729,7 @@ static int fio_ioring_init(struct thread_data *td)
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
 	struct thread_options *to = &td->o;
+	int p;
 
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
@@ -753,11 +756,15 @@ static int fio_ioring_init(struct thread_data *td)
 	/*
 	 * Check for option conflicts
 	 */
-	if ((fio_option_is_set(to, ioprio) || fio_option_is_set(to, ioprio_class)) &&
-			o->cmdprio_percentage != 0) {
+	p = o->cmdprio_percentage[DDIR_READ] +
+		o->cmdprio_percentage[DDIR_WRITE];
+	if (p &&
+	    (fio_option_is_set(to, ioprio) ||
+	     fio_option_is_set(to, ioprio_class))) {
 		log_err("%s: cmdprio_percentage option and mutually exclusive "
-				"prio or prioclass option is set, exiting\n", to->name);
-		td_verror(td, EINVAL, "fio_io_uring_init");
+			"prio or prioclass option is set, exiting\n",
+			to->name);
+		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
 	}
 
diff --git a/engines/libaio.c b/engines/libaio.c
index b12b6ffc..1e997cce 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -55,7 +55,7 @@ struct libaio_data {
 struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
-	unsigned int cmdprio_percentage;
+	unsigned int cmdprio_percentage[DDIR_RWDIR_CNT];
 	unsigned int nowait;
 };
 
@@ -74,8 +74,9 @@ static struct fio_option options[] = {
 		.name	= "cmdprio_percentage",
 		.lname	= "high priority percentage",
 		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct libaio_options, cmdprio_percentage),
-		.minval	= 1,
+		.off1	= offsetof(struct libaio_options, cmdprio_percentage[DDIR_READ]),
+		.off2	= offsetof(struct libaio_options, cmdprio_percentage[DDIR_WRITE]),
+		.minval	= 0,
 		.maxval	= 100,
 		.help	= "Send high priority I/O this percentage of the time",
 		.category = FIO_OPT_C_ENGINE,
@@ -135,12 +136,13 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct libaio_options *o = td->eo;
-	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
+	unsigned int p = o->cmdprio_percentage[io_u->ddir];
+
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		io_u->iocb.aio_reqprio = ioprio_value(IOPRIO_CLASS_RT, 0);
 		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
 		io_u->flags |= IO_U_F_PRIORITY;
 	}
-	return;
 }
 
 static struct io_u *fio_libaio_event(struct thread_data *td, int event)
@@ -277,7 +279,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	if (o->cmdprio_percentage)
+	if (o->cmdprio_percentage[io_u->ddir])
 		fio_libaio_prio_prep(td, io_u);
 
 	ld->iocbs[ld->head] = &io_u->iocb;
@@ -422,6 +424,7 @@ static int fio_libaio_init(struct thread_data *td)
 	struct libaio_data *ld;
 	struct thread_options *to = &td->o;
 	struct libaio_options *o = td->eo;
+	int p;
 
 	ld = calloc(1, sizeof(*ld));
 
@@ -432,13 +435,18 @@ static int fio_libaio_init(struct thread_data *td)
 	ld->io_us = calloc(ld->entries, sizeof(struct io_u *));
 
 	td->io_ops_data = ld;
+
 	/*
 	 * Check for option conflicts
 	 */
-	if ((fio_option_is_set(to, ioprio) || fio_option_is_set(to, ioprio_class)) &&
-			o->cmdprio_percentage != 0) {
+	p = o->cmdprio_percentage[DDIR_READ] +
+		o->cmdprio_percentage[DDIR_WRITE];
+	if (p &&
+	    (fio_option_is_set(to, ioprio) ||
+	     fio_option_is_set(to, ioprio_class))) {
 		log_err("%s: cmdprio_percentage option and mutually exclusive "
-				"prio or prioclass option is set, exiting\n", to->name);
+			"prio or prioclass option is set, exiting\n",
+			to->name);
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
 	}
diff --git a/fio.1 b/fio.1
index d9a3593e..a4b2deb1 100644
--- a/fio.1
+++ b/fio.1
@@ -1918,13 +1918,13 @@ In addition, there are some parameters which are only valid when a specific
 with the caveat that when used on the command line, they must come after the
 \fBioengine\fR that defines them is selected.
 .TP
-.BI (io_uring,libaio)cmdprio_percentage \fR=\fPint
-Set the percentage of I/O that will be issued with higher priority by setting
-the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentage``.
-This option cannot be used with the `prio` or `prioclass` options. For this
-option to set the priority bit properly, NCQ priority must be supported and
-enabled and `direct=1' option must be used. fio must also be run as the root
-user.
+.BI (io_uring,libaio)cmdprio_percentage \fR=\fPint[,int]
+Set the percentage of I/O that will be issued with the highest priority.
+Default: 0. A single value applies to reads and writes. Comma-separated
+values may be specified for reads and writes. This option cannot be used
+with the `prio` or `prioclass` options. For this option to be effective,
+NCQ priority must be supported and enabled, and `direct=1' option must be
+used. fio must also be run as the root user.
 .TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO call, and
-- 
2.31.1


