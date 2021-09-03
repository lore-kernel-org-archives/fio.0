Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 07/11] libaio,io_uring: introduce cmdprio_class and cmdprio
 options
Date: Fri, 3 Sep 2021 15:20:24 +0000
Message-ID: <20210903152012.18035-8-Niklas.Cassel@wdc.com>
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

When the cmdprio_percentage option is used, the specified percentage of
IO will be issued with the highest priority class IOPRIO_CLASS_RT. This
priority class maps to the ATA NCQ "high" priority level and allows
exercising a SATA device to measure its command latency characteristics
in the presence of low and high priority commands.

Beside ATA NCQ commands, Linux block IO schedulers also support IO
priorities and will behave differently in the presence of IOs with
different IO priority classes and values. However, cmdprio_percentage
does not allow specifying all possible priority classes and values.

To solve this, introduce libaio and io_uring engine specific options
cmdprio_class and cmdprio. These new options are the equivalent
of the prioclass and prio options and allow specifying the priority
class and priority value to use for asynchronous I/Os when the
cmdprio_percentage option is used. If not specified, the I/O priority
class defaults to IOPRIO_CLASS_RT and the I/O priority value to 0,
as before. Similarly to the cmdprio_percentage option, these options
can specify different values for read and write I/Os using a comma
separated list.

The manpage, HOWTO and fiograph configuration file are updated to
document these new options.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 HOWTO                        | 26 +++++++++++++++++--
 engines/cmdprio.h            | 11 ++++++++-
 engines/io_uring.c           | 48 ++++++++++++++++++++++++++++++++++--
 engines/libaio.c             | 48 ++++++++++++++++++++++++++++++++++--
 fio.1                        | 24 ++++++++++++++++--
 tools/fiograph/fiograph.conf |  4 +--
 6 files changed, 150 insertions(+), 11 deletions(-)

diff --git a/HOWTO b/HOWTO
index 916f5191..8b7d4957 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2172,6 +2172,26 @@ with the caveat that when used on the command line, =
they must come after the
     to be effective, NCQ priority must be supported and enabled, and `dire=
ct=3D1'
     option must be used. fio must also be run as the root user.
=20
+.. option:: cmdprio_class=3Dint[,int] : [io_uring] [libaio]
+
+	Set the I/O priority class to use for I/Os that must be issued with
+	a priority when :option:`cmdprio_percentage` is set. If not specified
+	when :option:`cmdprio_percentage` is set, this defaults to the highest
+	priority class. A single value applies to reads and writes.
+	Comma-separated values may be specified for reads and writes. See
+	:manpage:`ionice(1)`. See also the :option:`prioclass` option.
+
+.. option:: cmdprio=3Dint[,int] : [io_uring] [libaio]
+
+	Set the I/O priority value to use for I/Os that must be issued with
+	a priority when :option:`cmdprio_percentage` is set. If not specified
+	when :option:`cmdprio_percentage` is set, this defaults to 0.
+	Linux limits us to a positive value between 0 and 7, with 0 being the
+	highest. A single value applies to reads and writes. Comma-separated
+	values may be specified for reads and writes. See :manpage:`ionice(1)`.
+	Refer to an appropriate manpage for other operating systems since
+	meaning of priority may differ. See also the :option:`prio` option.
+
 .. option:: fixedbufs : [io_uring]
=20
     If fio is asked to do direct IO, then Linux will map pages for each
@@ -2974,12 +2994,14 @@ Threads, processes and job synchronization
 	between 0 and 7, with 0 being the highest.  See man
 	:manpage:`ionice(1)`. Refer to an appropriate manpage for other operating
 	systems since meaning of priority may differ. For per-command priority
-	setting, see I/O engine specific `cmdprio_percentage` option.
+	setting, see I/O engine specific :option:`cmdprio_percentage` and
+	:option:`cmdprio` options.
=20
 .. option:: prioclass=3Dint
=20
 	Set the I/O priority class. See man :manpage:`ionice(1)`. For per-command
-	priority setting, see I/O engine specific `cmdprio_percentage` option.
+	priority setting, see I/O engine specific :option:`cmdprio_percentage`
+	and :option:`cmdprio_class` options.
=20
 .. option:: cpus_allowed=3Dstr
=20
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 19120d78..e3b42182 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -10,6 +10,8 @@
=20
 struct cmdprio {
 	unsigned int percentage[DDIR_RWDIR_CNT];
+	unsigned int class[DDIR_RWDIR_CNT];
+	unsigned int level[DDIR_RWDIR_CNT];
 };
=20
 static int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdpri=
o,
@@ -19,9 +21,16 @@ static int fio_cmdprio_init(struct thread_data *td, stru=
ct cmdprio *cmdprio,
 	bool has_cmdprio_percentage =3D false;
 	int i;
=20
+	/*
+	 * If cmdprio_percentage is set and cmdprio_class is not set,
+	 * default to RT priority class.
+	 */
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		if (cmdprio->percentage[i])
+		if (cmdprio->percentage[i]) {
+			if (!cmdprio->class[i])
+				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
 			has_cmdprio_percentage =3D true;
+		}
 	}
=20
 	/*
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1731eb24..1591ee4e 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -133,6 +133,36 @@ static struct fio_option options[] =3D {
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_IOURING,
 	},
+	{
+		.name	=3D "cmdprio_class",
+		.lname	=3D "Asynchronous I/O priority class",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct ioring_options,
+				   cmdprio.class[DDIR_READ]),
+		.off2	=3D offsetof(struct ioring_options,
+				   cmdprio.class[DDIR_WRITE]),
+		.help	=3D "Set asynchronous IO priority class",
+		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,
+		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,
+		.interval =3D 1,
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_IOURING,
+	},
+	{
+		.name	=3D "cmdprio",
+		.lname	=3D "Asynchronous I/O priority level",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct ioring_options,
+				   cmdprio.level[DDIR_READ]),
+		.off2	=3D offsetof(struct ioring_options,
+				   cmdprio.level[DDIR_WRITE]),
+		.help	=3D "Set asynchronous IO priority level",
+		.minval	=3D IOPRIO_MIN_PRIO,
+		.maxval	=3D IOPRIO_MAX_PRIO,
+		.interval =3D 1,
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_IOURING,
+	},
 #else
 	{
 		.name	=3D "cmdprio_percentage",
@@ -140,6 +170,18 @@ static struct fio_option options[] =3D {
 		.type	=3D FIO_OPT_UNSUPPORTED,
 		.help	=3D "Your platform does not support I/O priority classes",
 	},
+	{
+		.name	=3D "cmdprio_class",
+		.lname	=3D "Asynchronous I/O priority class",
+		.type	=3D FIO_OPT_UNSUPPORTED,
+		.help	=3D "Your platform does not support I/O priority classes",
+	},
+	{
+		.name	=3D "cmdprio",
+		.lname	=3D "Asynchronous I/O priority level",
+		.type	=3D FIO_OPT_UNSUPPORTED,
+		.help	=3D "Your platform does not support I/O priority classes",
+	},
 #endif
 	{
 		.name	=3D "fixedbufs",
@@ -389,10 +431,12 @@ static void fio_ioring_prio_prep(struct thread_data *=
td, struct io_u *io_u)
 	struct ioring_data *ld =3D td->io_ops_data;
 	struct io_uring_sqe *sqe =3D &ld->sqes[io_u->index];
 	struct cmdprio *cmdprio =3D &o->cmdprio;
-	unsigned int p =3D cmdprio->percentage[io_u->ddir];
+	enum fio_ddir ddir =3D io_u->ddir;
+	unsigned int p =3D cmdprio->percentage[ddir];
=20
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		sqe->ioprio =3D ioprio_value(IOPRIO_CLASS_RT, 0);
+		sqe->ioprio =3D
+			ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
 		io_u->flags |=3D IO_U_F_PRIORITY;
 	} else {
 		sqe->ioprio =3D 0;
diff --git a/engines/libaio.c b/engines/libaio.c
index 8cf560c5..8b965fe2 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -87,6 +87,36 @@ static struct fio_option options[] =3D {
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name	=3D "cmdprio_class",
+		.lname	=3D "Asynchronous I/O priority class",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct libaio_options,
+				   cmdprio.class[DDIR_READ]),
+		.off2	=3D offsetof(struct libaio_options,
+				   cmdprio.class[DDIR_WRITE]),
+		.help	=3D "Set asynchronous IO priority class",
+		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,
+		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,
+		.interval =3D 1,
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name	=3D "cmdprio",
+		.lname	=3D "Asynchronous I/O priority level",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct libaio_options,
+				   cmdprio.level[DDIR_READ]),
+		.off2	=3D offsetof(struct libaio_options,
+				   cmdprio.level[DDIR_WRITE]),
+		.help	=3D "Set asynchronous IO priority level",
+		.minval	=3D IOPRIO_MIN_PRIO,
+		.maxval	=3D IOPRIO_MAX_PRIO,
+		.interval =3D 1,
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_LIBAIO,
+	},
 #else
 	{
 		.name	=3D "cmdprio_percentage",
@@ -94,6 +124,18 @@ static struct fio_option options[] =3D {
 		.type	=3D FIO_OPT_UNSUPPORTED,
 		.help	=3D "Your platform does not support I/O priority classes",
 	},
+	{
+		.name	=3D "cmdprio_class",
+		.lname	=3D "Asynchronous I/O priority class",
+		.type	=3D FIO_OPT_UNSUPPORTED,
+		.help	=3D "Your platform does not support I/O priority classes",
+	},
+	{
+		.name	=3D "cmdprio",
+		.lname	=3D "Asynchronous I/O priority level",
+		.type	=3D FIO_OPT_UNSUPPORTED,
+		.help	=3D "Your platform does not support I/O priority classes",
+	},
 #endif
 	{
 		.name	=3D "nowait",
@@ -142,10 +184,12 @@ static void fio_libaio_prio_prep(struct thread_data *=
td, struct io_u *io_u)
 {
 	struct libaio_options *o =3D td->eo;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
-	unsigned int p =3D cmdprio->percentage[io_u->ddir];
+	enum fio_ddir ddir =3D io_u->ddir;
+	unsigned int p =3D cmdprio->percentage[ddir];
=20
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->iocb.aio_reqprio =3D ioprio_value(IOPRIO_CLASS_RT, 0);
+		io_u->iocb.aio_reqprio =3D
+			ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
 		io_u->iocb.u.c.flags |=3D IOCB_FLAG_IOPRIO;
 		io_u->flags |=3D IO_U_F_PRIORITY;
 	}
diff --git a/fio.1 b/fio.1
index 3611da98..09b97de3 100644
--- a/fio.1
+++ b/fio.1
@@ -1970,6 +1970,24 @@ with the `prio` or `prioclass` options. For this opt=
ion to be effective,
 NCQ priority must be supported and enabled, and `direct=3D1' option must b=
e
 used. fio must also be run as the root user.
 .TP
+.BI (io_uring,libaio)cmdprio_class \fR=3D\fPint[,int]
+Set the I/O priority class to use for I/Os that must be issued with a
+priority when \fBcmdprio_percentage\fR is set. If not specified when
+\fBcmdprio_percentage\fR is set, this defaults to the highest priority
+class. A single value applies to reads and writes. Comma-separated
+values may be specified for reads and writes. See man \fBionice\fR\|(1).
+See also the \fBprioclass\fR option.
+.TP
+.BI (io_uring,libaio)cmdprio \fR=3D\fPint[,int]
+Set the I/O priority value to use for I/Os that must be issued with a
+priority when \fBcmdprio_percentage\fR is set. If not specified when
+\fBcmdprio_percentage\fR is set, this defaults to 0. Linux limits us to
+a positive value between 0 and 7, with 0 being the highest. A single
+value applies to reads and writes. Comma-separated values may be specified
+for reads and writes. See man \fBionice\fR\|(1). Refer to an appropriate
+manpage for other operating systems since the meaning of priority may diff=
er.
+See also the \fBprio\fR option.
+.TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO cal=
l, and
 release them when IO is done. If this option is set, the pages are pre-map=
ped
@@ -2693,11 +2711,13 @@ Set the I/O priority value of this job. Linux limit=
s us to a positive value
 between 0 and 7, with 0 being the highest. See man
 \fBionice\fR\|(1). Refer to an appropriate manpage for other operating
 systems since meaning of priority may differ. For per-command priority
-setting, see the I/O engine specific `cmdprio_percentage` option.
+setting, see the I/O engine specific `cmdprio_percentage` and
+`cmdprio` options.
 .TP
 .BI prioclass \fR=3D\fPint
 Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
-priority setting, see the I/O engine specific `cmdprio_percentage` option.
+priority setting, see the I/O engine specific `cmdprio_percentage` and
+`cmdprio_class` options.
 .TP
 .BI cpus_allowed \fR=3D\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 1957e11d..5ba59c52 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,10 +51,10 @@ specific_options=3Dhttps  http_host  http_user  http_pa=
ss  http_s3_key  http_s3_ke
 specific_options=3Dime_psync  ime_psyncv
=20
 [ioengine_io_uring]
-specific_options=3Dhipri  cmdprio_percentage  fixedbufs  registerfiles  sq=
thread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
+specific_options=3Dhipri  cmdprio_percentage  cmdprio_class  cmdprio  fixe=
dbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncach=
ed  nowait  force_async
=20
 [ioengine_libaio]
-specific_options=3Duserspace_reap  cmdprio_percentage  nowait
+specific_options=3Duserspace_reap  cmdprio_percentage  cmdprio_class  cmdp=
rio  nowait
=20
 [ioengine_libcufile]
 specific_options=3Dgpu_dev_ids  cuda_io
--=20
2.31.1

