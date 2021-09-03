Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 09/11] libaio,io_uring: relax cmdprio_percentage
 constraints
Date: Fri, 3 Sep 2021 15:20:26 +0000
Message-ID: <20210903152012.18035-10-Niklas.Cassel@wdc.com>
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

In fio, a job IO priority is controlled with the prioclass and prio
options and these options cannot be used together with the
cmdprio_percentage option.

Allow a user to have async IO priorities default to the job defined
IO priority by removing the mutual exclusion between the options
cmdprio_percentage and prioclass/prio.

With the introduction of the cmdprio_class option, an async IO priority
may be lower than the job default priority, resulting in reversed clat
statistics showed for high and low priority IOs when fio completes.
Solve this by setting an io_u IO_U_F_PRIORITY flag depending on a
comparison between the async IO priority and job default IO priority.

When an async IO is issued without a priority set, Linux kernel will
execute it using the IO priority of the issuing context set with
ioprio_set(). This works fine for libaio, where the context will be
the same as the context that submitted the IO.

However, io_uring can be used with a kernel thread that performs
block device IO submissions (sqthread_poll). Therefore, for io_uring,
an IO sqe ioprio field must be set to the job default priority unless
the IO priority is set according to the job cmdprio_percentage value.

Because of this, IO uring already did set sqe->ioprio even when only
prio/prioclass was used. See commit b7ed2a862dda ("io_uring: set sqe
iopriority, if prio/prioclass is set"). In order to make the code easier
to maintain, handle all I/O priority preparations in the same function.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 backend.c          |  1 +
 engines/cmdprio.h  | 16 ----------------
 engines/io_uring.c | 47 +++++++++++++++++++++++++++++++---------------
 engines/libaio.c   | 18 ++++++++++++++++--
 fio.h              |  5 +++++
 5 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/backend.c b/backend.c
index 808e4362..1bcb035a 100644
--- a/backend.c
+++ b/backend.c
@@ -1760,6 +1760,7 @@ static void *thread_main(void *data)
 			td_verror(td, errno, "ioprio_set");
 			goto err;
 		}
+		td->ioprio =3D ioprio_value(o->ioprio_class, o->ioprio);
 	}
=20
 	if (o->cgroup && cgroup_setup(td, cgroup_list, &cgroup_mnt))
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 8acdb0b3..0edc4365 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -129,22 +129,6 @@ static int fio_cmdprio_init(struct thread_data *td, st=
ruct cmdprio *cmdprio,
 	/*
 	 * Check for option conflicts
 	 */
-	if (has_cmdprio_percentage &&
-	    (fio_option_is_set(to, ioprio) ||
-	     fio_option_is_set(to, ioprio_class))) {
-		log_err("%s: cmdprio_percentage option and mutually exclusive "
-			"prio or prioclass option is set, exiting\n",
-			to->name);
-		return 1;
-	}
-	if (has_cmdprio_bssplit &&
-	    (fio_option_is_set(to, ioprio) ||
-	     fio_option_is_set(to, ioprio_class))) {
-		log_err("%s: cmdprio_bssplit option and mutually exclusive "
-			"prio or prioclass option is set, exiting\n",
-			to->name);
-		return 1;
-	}
 	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
 		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
 			"are mutually exclusive\n",
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 57124d22..df2d6c4c 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -65,8 +65,6 @@ struct ioring_data {
 	int queued;
 	int cq_ring_off;
 	unsigned iodepth;
-	bool ioprio_class_set;
-	bool ioprio_set;
 	int prepped;
=20
 	struct ioring_mmap mmap[3];
@@ -340,10 +338,6 @@ static int fio_ioring_prep(struct thread_data *td, str=
uct io_u *io_u)
 			sqe->rw_flags |=3D RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |=3D RWF_NOWAIT;
-		if (ld->ioprio_class_set)
-			sqe->ioprio =3D td->o.ioprio_class << 13;
-		if (ld->ioprio_set)
-			sqe->ioprio |=3D td->o.ioprio;
 		sqe->off =3D io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
 		sqe->ioprio =3D 0;
@@ -458,13 +452,30 @@ static void fio_ioring_prio_prep(struct thread_data *=
td, struct io_u *io_u)
 	struct cmdprio *cmdprio =3D &o->cmdprio;
 	enum fio_ddir ddir =3D io_u->ddir;
 	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int cmdprio_value =3D
+		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
=20
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		sqe->ioprio =3D
-			ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
-		io_u->flags |=3D IO_U_F_PRIORITY;
+		sqe->ioprio =3D cmdprio_value;
+		if (!td->ioprio || cmdprio_value < td->ioprio) {
+			/*
+			 * The async IO priority is higher (has a lower value)
+			 * than the priority set by "prio" and "prioclass"
+			 * options.
+			 */
+			io_u->flags |=3D IO_U_F_PRIORITY;
+		}
 	} else {
-		sqe->ioprio =3D 0;
+		sqe->ioprio =3D td->ioprio;
+		if (cmdprio_value && td->ioprio && td->ioprio < cmdprio_value) {
+			/*
+			 * The IO will be executed with the priority set by
+			 * "prio" and "prioclass" options, and this priority
+			 * is higher (has a lower value) than the async IO
+			 * priority.
+			 */
+			io_u->flags |=3D IO_U_F_PRIORITY;
+		}
 	}
 }
=20
@@ -807,6 +818,7 @@ static int fio_ioring_init(struct thread_data *td)
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
+	bool has_cmdprio =3D false;
 	int ret;
=20
 	/* sqthread submission requires registered files */
@@ -831,16 +843,21 @@ static int fio_ioring_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	ret =3D fio_cmdprio_init(td, cmdprio, &has_cmdprio);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
 	}
=20
-	if (fio_option_is_set(&td->o, ioprio_class))
-		ld->ioprio_class_set =3D true;
-	if (fio_option_is_set(&td->o, ioprio))
-		ld->ioprio_set =3D true;
+	/*
+	 * Since io_uring can have a submission context (sqthread_poll) that is
+	 * different from the process context, we cannot rely on the the IO
+	 * priority set by ioprio_set() (option prio/prioclass) to be inherited.
+	 * Therefore, we set the sqe->ioprio field when prio/prioclass is used.
+	 */
+	ld->use_cmdprio =3D has_cmdprio ||
+		fio_option_is_set(&td->o, ioprio_class) ||
+		fio_option_is_set(&td->o, ioprio);
=20
 	return 0;
 }
diff --git a/engines/libaio.c b/engines/libaio.c
index 9fba3b12..62c8aed7 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -211,11 +211,25 @@ static void fio_libaio_prio_prep(struct thread_data *=
td, struct io_u *io_u)
 	struct cmdprio *cmdprio =3D &o->cmdprio;
 	enum fio_ddir ddir =3D io_u->ddir;
 	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int cmdprio_value =3D
+		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
=20
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->iocb.aio_reqprio =3D
-			ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
+		io_u->iocb.aio_reqprio =3D cmdprio_value;
 		io_u->iocb.u.c.flags |=3D IOCB_FLAG_IOPRIO;
+		if (!td->ioprio || cmdprio_value < td->ioprio) {
+			/*
+			 * The async IO priority is higher (has a lower value)
+			 * than the default context priority.
+			 */
+			io_u->flags |=3D IO_U_F_PRIORITY;
+		}
+	} else if (td->ioprio && td->ioprio < cmdprio_value) {
+		/*
+		 * The IO will be executed with the default context priority,
+		 * and this priority is higher (has a lower value) than the
+		 * async IO priority.
+		 */
 		io_u->flags |=3D IO_U_F_PRIORITY;
 	}
 }
diff --git a/fio.h b/fio.h
index 6f6b211b..da1fe085 100644
--- a/fio.h
+++ b/fio.h
@@ -280,6 +280,11 @@ struct thread_data {
=20
 	int shm_id;
=20
+	/*
+	 * Job default IO priority set with prioclass and prio options.
+	 */
+	unsigned int ioprio;
+
 	/*
 	 * IO engine hooks, contains everything needed to submit an io_u
 	 * to any of the available IO engines.
--=20
2.31.1

