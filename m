Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 07/11] libaio: introduce aioprio and aioprioclass options
Date: Tue,  6 Jul 2021 09:17:39 +0900
Message-Id: <20210706001743.10818-8-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

When the cmdprio_percentage option is used, the specified percentage of
IO will be issued with the highest priority class IOPRIO_CLASS_RT. This
priority class maps to the ATA NCQ "high" priority level and allows
exercising a SATA device to measure its command latency characteristics
in the presence of low and high priority commands.

Beside ATA NCQ commands, Linux block IO schedulers also support IO
priorities and will behave differently in the presence of IOs with
different IO priority classes and values. However, cmdprio_percentage
does not allow specifying all possible priority classes and values.

To solve this, introduce the libaio engine specific options
aioprioclass and aioprio. These new options are the equivalent of the
prio and prioclass options and allow specifying the priority class and
priority value to use for asynchronous I/Os when the aioprio_percentage
option is used. If not specified, the I/O priority class defaults to
IOPRIO_CLASS_RT and the I/O priority value to 0, as before. Similarly
to the cmdprio_percentage option, these options can specify different
values for reads and writes using a comma separated list.

To allow scripts to be written with a consistent set of option names,
add the aioprio_percentage alias for the cmdprio_percentage option.

The manpage, HOWTO and fiograph configuration file are updated to
document these new options.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 HOWTO                        | 32 ++++++++++++++--
 engines/libaio.c             | 71 +++++++++++++++++++++++++++++++-----
 fio.1                        | 27 +++++++++++++-
 tools/fiograph/fiograph.conf |  2 +-
 4 files changed, 115 insertions(+), 17 deletions(-)

diff --git a/HOWTO b/HOWTO
index 36ad8176..aaf87d95 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2162,6 +2162,30 @@ with the caveat that when used on the command line, they must come after the
 	When :option:`sqthread_poll` is set, this option provides a way to
 	define which CPU should be used for the polling thread.
 
+.. option:: aioprio_percentage=int[,int] : [libaio]
+
+	Alias for :option:`cmdprio_percentage`.
+
+.. option:: aioprioclass=int[,int] : [libaio]
+
+	Set the I/O priority class to use for I/Os that must be issued with
+	a priority when :option:`aioprio_percentage` is set. If not specified
+	when :option:`aioprio_percentage` is set, this defaults to the highest
+	priority class. A single value applies to reads and writes.
+	Comma-separated values may be specified for reads and writes.See
+	:manpage:`ionice(1)`. See also the :option:`prioclass` option.
+
+.. option:: aioprio=int[,int] : [libaio]
+
+	Set the I/O priority value to use for I/Os that must be issued with
+	a priority when :option:`aioprio_percentage` is set. If not specified
+	when :option:`aioprio_percentage` is set, this defaults to 0.
+	Linux limits us to a positive value between 0 and 7, with 0 being the
+	highest. A single value applies to reads and writes. Comma-separated
+	values may be specified for reads and writes. See :manpage:`ionice(1)`.
+	Refer to an appropriate manpage for other operating systems since
+	meaning of priority may differ. See also the :option:`prio` option.
+
 .. option:: userspace_reap : [libaio]
 
 	Normally, with the libaio engine in use, fio will use the
@@ -2906,14 +2930,14 @@ Threads, processes and job synchronization
 	between 0 and 7, with 0 being the highest.  See man
 	:manpage:`ionice(1)`. Refer to an appropriate manpage for other operating
 	systems since meaning of priority may differ. For per-command priority
-	setting, see I/O engine specific `cmdprio_percentage` and `hipri_percentage`
-	options.
+	setting, see I/O engine specific :option:`cmdprio_percentage`,
+	:option:`aioprio` and :option:`hipri_percentage` options.
 
 .. option:: prioclass=int
 
 	Set the I/O priority class. See man :manpage:`ionice(1)`. For per-command
-	priority setting, see I/O engine specific `cmdprio_percentage` and
-	`hipri_percentage` options.
+	priority setting, see I/O engine specific :option:`cmdprio_percentage`,
+	:option:`aioprioclass` and :option:`hipri_percentage` options.
 
 .. option:: cpus_allowed=str
 
diff --git a/engines/libaio.c b/engines/libaio.c
index 1e997cce..96f799de 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -55,7 +55,9 @@ struct libaio_data {
 struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
-	unsigned int cmdprio_percentage[DDIR_RWDIR_CNT];
+	unsigned int aioprio_percentage[DDIR_RWDIR_CNT];
+	unsigned int aioprio_class[DDIR_RWDIR_CNT];
+	unsigned int aioprio[DDIR_RWDIR_CNT];
 	unsigned int nowait;
 };
 
@@ -72,16 +74,43 @@ static struct fio_option options[] = {
 #ifdef FIO_HAVE_IOPRIO_CLASS
 	{
 		.name	= "cmdprio_percentage",
+		.alias	= "aioprio_percentage",
 		.lname	= "high priority percentage",
 		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct libaio_options, cmdprio_percentage[DDIR_READ]),
-		.off2	= offsetof(struct libaio_options, cmdprio_percentage[DDIR_WRITE]),
+		.off1	= offsetof(struct libaio_options, aioprio_percentage[DDIR_READ]),
+		.off2	= offsetof(struct libaio_options, aioprio_percentage[DDIR_WRITE]),
 		.minval	= 0,
 		.maxval	= 100,
 		.help	= "Send high priority I/O this percentage of the time",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name	= "aioprioclass",
+		.lname	= "Asynchronous I/O priority class",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct libaio_options, aioprio_class[DDIR_READ]),
+		.off2	= offsetof(struct libaio_options, aioprio_class[DDIR_WRITE]),
+		.help	= "Set asynchronous IO priority class",
+		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
+		.maxval	= IOPRIO_MAX_PRIO_CLASS,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_CRED,
+	},
+	{
+		.name	= "aioprio",
+		.lname	= "Asynchronous I/O priority value",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct libaio_options, aioprio[DDIR_READ]),
+		.off2	= offsetof(struct libaio_options, aioprio[DDIR_WRITE]),
+		.help	= "Set asynchronous IO priority value",
+		.minval	= IOPRIO_MIN_PRIO,
+		.maxval	= IOPRIO_MAX_PRIO,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_CRED,
+	},
 #else
 	{
 		.name	= "cmdprio_percentage",
@@ -89,6 +118,18 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support I/O priority classes",
 	},
+		{
+		.name	= "aioprioclass",
+		.lname	= "Asynchronous I/O priority class",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
+	{
+		.name	= "aioprio",
+		.lname	= "Asynchronous I/O priority level",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
 #endif
 	{
 		.name	= "nowait",
@@ -136,10 +177,12 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct libaio_options *o = td->eo;
-	unsigned int p = o->cmdprio_percentage[io_u->ddir];
+	enum fio_ddir ddir = io_u->ddir;
+	unsigned int p = o->aioprio_percentage[ddir];
 
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->iocb.aio_reqprio = ioprio_value(IOPRIO_CLASS_RT, 0);
+		io_u->iocb.aio_reqprio =
+			ioprio_value(o->aioprio_class[ddir], o->aioprio[ddir]);
 		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
 		io_u->flags |= IO_U_F_PRIORITY;
 	}
@@ -279,7 +322,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	if (o->cmdprio_percentage[io_u->ddir])
+	if (o->aioprio_percentage[io_u->ddir])
 		fio_libaio_prio_prep(td, io_u);
 
 	ld->iocbs[ld->head] = &io_u->iocb;
@@ -421,10 +464,10 @@ static int fio_libaio_post_init(struct thread_data *td)
 
 static int fio_libaio_init(struct thread_data *td)
 {
+	struct libaio_options *o = td->eo;
 	struct libaio_data *ld;
 	struct thread_options *to = &td->o;
-	struct libaio_options *o = td->eo;
-	int p;
+	int i, p = 0;
 
 	ld = calloc(1, sizeof(*ld));
 
@@ -436,11 +479,19 @@ static int fio_libaio_init(struct thread_data *td)
 
 	td->io_ops_data = ld;
 
+	/*
+	 * If aioprio_percentage is set and aioprio_class is not set,
+	 * default to RT priority class.
+	 */
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		if (o->aioprio_percentage[i] && !o->aioprio_class[i])
+			o->aioprio_class[i] = IOPRIO_CLASS_RT;
+		p += o->aioprio_percentage[i];
+	}
+
 	/*
 	 * Check for option conflicts
 	 */
-	p = o->cmdprio_percentage[DDIR_READ] +
-		o->cmdprio_percentage[DDIR_WRITE];
 	if (p &&
 	    (fio_option_is_set(to, ioprio) ||
 	     fio_option_is_set(to, ioprio_class))) {
diff --git a/fio.1 b/fio.1
index a4b2deb1..0f4b9ff7 100644
--- a/fio.1
+++ b/fio.1
@@ -1955,6 +1955,27 @@ the cost of using more CPU in the system.
 When `sqthread_poll` is set, this option provides a way to define which CPU
 should be used for the polling thread.
 .TP
+.BI (libaio)aioprio_percentage \fR=\fPint[,int]
+Alias for \fBcmdprio_percentage\fR.
+.TP
+.BI (libaio)aioprioclass \fR=\fPint[,int]
+Set the I/O priority class to use for I/Os that must be issued with a
+priority when \fBaioprio_percentage\fR is set. If not specified when
+\fBaioprio_percentage\fR is set, this defaults to the highest priority
+class. A single value applies to reads and writes. Comma-separated
+values may be specified for reads and writes. See man \fBionice\fR\|(1).
+See also the \fBprioclass\fR option.
+.TP
+.BI (libaio)aioprio \fR=\fPint[,int]
+Set the I/O priority value to use for I/Os that must be issued with a
+priority when \fBaioprio_percentage\fR is set. If not specified when
+\fBaioprio_percentage\fR is set, this defaults to 0. Linux limits us to
+a positive value between 0 and 7, with 0 being the highest. A single
+value applies to reads and writes. Comma-separated values may be specified
+for reads and writes. See man \fBionice\fR\|(1). Refer to an appropriate
+manpage for other operating systems since the meaning of priority may differ.
+See also the \fBprio\fR option.
+.TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
 \fBio_getevents\fR\|(3) system call to reap newly returned events. With
@@ -2624,11 +2645,13 @@ Set the I/O priority value of this job. Linux limits us to a positive value
 between 0 and 7, with 0 being the highest. See man
 \fBionice\fR\|(1). Refer to an appropriate manpage for other operating
 systems since meaning of priority may differ. For per-command priority
-setting, see the I/O engine specific `cmdprio_percentage` option.
+setting, see the I/O engine specific `cmdprio_percentage` and
+`aioprio` options.
 .TP
 .BI prioclass \fR=\fPint
 Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
-priority setting, see the I/O engine specific `cmdprio_percentage` option.
+priority setting, see the I/O engine specific `cmdprio_percentage` and
+`aioprioclass` options.
 .TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 1d50d141..7f0434d5 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,7 +51,7 @@ specific_options=ime_psync  ime_psyncv
 specific_options=hipri  cmdprio_percentage  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
 
 [ioengine_libaio]
-specific_options=userspace_reap  cmdprio_percentage  nowait
+specific_options=userspace_reap  cmdprio_percentage  aioprio_percentage  nowait aioprioclass aioprio
 
 [ioengine_libcufile]
 specific_options=gpu_dev_ids  cuda_io
-- 
2.31.1


