Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 08/11] libaio,io_uring: introduce cmdprio_bssplit
Date: Fri, 3 Sep 2021 15:20:25 +0000
Message-ID: <20210903152012.18035-9-Niklas.Cassel@wdc.com>
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

The cmdprio_percentage, cmdprio_class and cmdprio options allow
specifying different values for read and write operations. This enables
various IO priority issuing patterns even uner a mixed read-write
workload but does not allow differentiation within read and write
I/O operation types with different sizes when the bssplit option is
used.

Introduce the cmdprio_bssplit option to complement the use of the
bssplit option.  This new option has the same format as the bssplit
option, but the percentage values indicate the percentage of I/O
operations with a particular block size that must be issued with the
priority class and value specified by cmdprio_class and cmdprio.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 HOWTO                        |  29 ++++++---
 engines/cmdprio.h            | 113 ++++++++++++++++++++++++++++++++++-
 engines/io_uring.c           |  29 ++++++++-
 engines/libaio.c             |  29 ++++++++-
 fio.1                        |  34 +++++++----
 tools/fiograph/fiograph.conf |   4 +-
 6 files changed, 210 insertions(+), 28 deletions(-)

diff --git a/HOWTO b/HOWTO
index 8b7d4957..1853f56a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2175,23 +2175,38 @@ with the caveat that when used on the command line,=
 they must come after the
 .. option:: cmdprio_class=3Dint[,int] : [io_uring] [libaio]
=20
 	Set the I/O priority class to use for I/Os that must be issued with
-	a priority when :option:`cmdprio_percentage` is set. If not specified
-	when :option:`cmdprio_percentage` is set, this defaults to the highest
-	priority class. A single value applies to reads and writes.
-	Comma-separated values may be specified for reads and writes. See
-	:manpage:`ionice(1)`. See also the :option:`prioclass` option.
+	a priority when :option:`cmdprio_percentage` or
+	:option:`cmdprio_bssplit` is set. If not specified when
+	:option:`cmdprio_percentage` or :option:`cmdprio_bssplit` is set,
+	this defaults to the highest priority class. A single value applies
+	to reads and writes. Comma-separated values may be specified for
+	reads and writes. See :manpage:`ionice(1)`. See also the
+	:option:`prioclass` option.
=20
 .. option:: cmdprio=3Dint[,int] : [io_uring] [libaio]
=20
 	Set the I/O priority value to use for I/Os that must be issued with
-	a priority when :option:`cmdprio_percentage` is set. If not specified
-	when :option:`cmdprio_percentage` is set, this defaults to 0.
+	a priority when :option:`cmdprio_percentage` or
+	:option:`cmdprio_bssplit` is set. If not specified when
+	:option:`cmdprio_percentage` or :option:`cmdprio_bssplit` is set,
+	this defaults to 0.
 	Linux limits us to a positive value between 0 and 7, with 0 being the
 	highest. A single value applies to reads and writes. Comma-separated
 	values may be specified for reads and writes. See :manpage:`ionice(1)`.
 	Refer to an appropriate manpage for other operating systems since
 	meaning of priority may differ. See also the :option:`prio` option.
=20
+.. option:: cmdprio_bssplit=3Dstr[,str] : [io_uring] [libaio]
+	To get a finer control over I/O priority, this option allows
+	specifying the percentage of IOs that must have a priority set
+	depending on the block size of the IO. This option is useful only
+	when used together with the :option:`bssplit` option, that is,
+	multiple different block sizes are used for reads and writes.
+	The format for this option is the same as the format of the
+	:option:`bssplit` option, with the exception that values for
+	trim IOs are ignored. This option is mutually exclusive with the
+	:option:`cmdprio_percentage` option.
+
 .. option:: fixedbufs : [io_uring]
=20
     If fio is asked to do direct IO, then Linux will map pages for each
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index e3b42182..8acdb0b3 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -12,18 +12,106 @@ struct cmdprio {
 	unsigned int percentage[DDIR_RWDIR_CNT];
 	unsigned int class[DDIR_RWDIR_CNT];
 	unsigned int level[DDIR_RWDIR_CNT];
+	unsigned int bssplit_nr[DDIR_RWDIR_CNT];
+	struct bssplit *bssplit[DDIR_RWDIR_CNT];
 };
=20
+static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_ar=
g,
+				    enum fio_ddir ddir, char *str, bool data)
+{
+	struct cmdprio *cmdprio =3D cb_arg;
+	struct split split;
+	unsigned int i;
+
+	if (ddir =3D=3D DDIR_TRIM)
+		return 0;
+
+	memset(&split, 0, sizeof(split));
+
+	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
+		return 1;
+	if (!split.nr)
+		return 0;
+
+	cmdprio->bssplit_nr[ddir] =3D split.nr;
+	cmdprio->bssplit[ddir] =3D malloc(split.nr * sizeof(struct bssplit));
+	if (!cmdprio->bssplit[ddir])
+		return 1;
+
+	for (i =3D 0; i < split.nr; i++) {
+		cmdprio->bssplit[ddir][i].bs =3D split.val1[i];
+		if (split.val2[i] =3D=3D -1U) {
+			cmdprio->bssplit[ddir][i].perc =3D 0;
+		} else {
+			if (split.val2[i] > 100)
+				cmdprio->bssplit[ddir][i].perc =3D 100;
+			else
+				cmdprio->bssplit[ddir][i].perc =3D split.val2[i];
+		}
+	}
+
+	return 0;
+}
+
+static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *i=
nput,
+				     struct cmdprio *cmdprio)
+{
+	char *str, *p;
+	int i, ret =3D 0;
+
+	p =3D str =3D strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
+
+	if (parse_dryrun()) {
+		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+			free(cmdprio->bssplit[i]);
+			cmdprio->bssplit[i] =3D NULL;
+			cmdprio->bssplit_nr[i] =3D 0;
+		}
+	}
+
+	free(p);
+	return ret;
+}
+
+static inline int fio_cmdprio_percentage(struct cmdprio *cmdprio,
+					 struct io_u *io_u)
+{
+	enum fio_ddir ddir =3D io_u->ddir;
+	unsigned int p =3D cmdprio->percentage[ddir];
+	int i;
+
+	/*
+	 * If cmdprio_percentage option was specified, then use that
+	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
+	 * on the IO size.
+	 */
+	if (p)
+		return p;
+
+	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
+		if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
+			return cmdprio->bssplit[ddir][i].perc;
+	}
+
+	return 0;
+}
+
 static int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdpri=
o,
 			    bool *has_cmdprio)
 {
 	struct thread_options *to =3D &td->o;
 	bool has_cmdprio_percentage =3D false;
+	bool has_cmdprio_bssplit =3D false;
 	int i;
=20
 	/*
-	 * If cmdprio_percentage is set and cmdprio_class is not set,
-	 * default to RT priority class.
+	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
+	 * is not set, default to RT priority class.
 	 */
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
 		if (cmdprio->percentage[i]) {
@@ -31,6 +119,11 @@ static int fio_cmdprio_init(struct thread_data *td, str=
uct cmdprio *cmdprio,
 				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
 			has_cmdprio_percentage =3D true;
 		}
+		if (cmdprio->bssplit_nr[i]) {
+			if (!cmdprio->class[i])
+				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
+			has_cmdprio_bssplit =3D true;
+		}
 	}
=20
 	/*
@@ -44,8 +137,22 @@ static int fio_cmdprio_init(struct thread_data *td, str=
uct cmdprio *cmdprio,
 			to->name);
 		return 1;
 	}
+	if (has_cmdprio_bssplit &&
+	    (fio_option_is_set(to, ioprio) ||
+	     fio_option_is_set(to, ioprio_class))) {
+		log_err("%s: cmdprio_bssplit option and mutually exclusive "
+			"prio or prioclass option is set, exiting\n",
+			to->name);
+		return 1;
+	}
+	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
+		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
+			"are mutually exclusive\n",
+			to->name);
+		return 1;
+	}
=20
-	*has_cmdprio =3D has_cmdprio_percentage;
+	*has_cmdprio =3D has_cmdprio_percentage || has_cmdprio_bssplit;
=20
 	return 0;
 }
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1591ee4e..57124d22 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -75,7 +75,7 @@ struct ioring_data {
 };
=20
 struct ioring_options {
-	void *pad;
+	struct thread_data *td;
 	unsigned int hipri;
 	struct cmdprio cmdprio;
 	unsigned int fixedbufs;
@@ -108,6 +108,15 @@ static int fio_ioring_sqpoll_cb(void *data, unsigned l=
ong long *val)
 	return 0;
 }
=20
+static int str_cmdprio_bssplit_cb(void *data, const char *input)
+{
+	struct ioring_options *o =3D data;
+	struct thread_data *td =3D o->td;
+	struct cmdprio *cmdprio =3D &o->cmdprio;
+
+	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
+}
+
 static struct fio_option options[] =3D {
 	{
 		.name	=3D "hipri",
@@ -163,6 +172,16 @@ static struct fio_option options[] =3D {
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_IOURING,
 	},
+	{
+		.name   =3D "cmdprio_bssplit",
+		.lname  =3D "Priority percentage block size split",
+		.type   =3D FIO_OPT_STR_ULL,
+		.cb     =3D str_cmdprio_bssplit_cb,
+		.off1   =3D offsetof(struct ioring_options, cmdprio.bssplit),
+		.help   =3D "Set priority percentages for different block sizes",
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_IOURING,
+	},
 #else
 	{
 		.name	=3D "cmdprio_percentage",
@@ -182,6 +201,12 @@ static struct fio_option options[] =3D {
 		.type	=3D FIO_OPT_UNSUPPORTED,
 		.help	=3D "Your platform does not support I/O priority classes",
 	},
+	{
+		.name   =3D "cmdprio_bssplit",
+		.lname  =3D "Priority percentage block size split",
+		.type	=3D FIO_OPT_UNSUPPORTED,
+		.help	=3D "Your platform does not support I/O priority classes",
+	},
 #endif
 	{
 		.name	=3D "fixedbufs",
@@ -432,7 +457,7 @@ static void fio_ioring_prio_prep(struct thread_data *td=
, struct io_u *io_u)
 	struct io_uring_sqe *sqe =3D &ld->sqes[io_u->index];
 	struct cmdprio *cmdprio =3D &o->cmdprio;
 	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D cmdprio->percentage[ddir];
+	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
=20
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		sqe->ioprio =3D
diff --git a/engines/libaio.c b/engines/libaio.c
index 8b965fe2..9fba3b12 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -56,12 +56,21 @@ struct libaio_data {
 };
=20
 struct libaio_options {
-	void *pad;
+	struct thread_data *td;
 	unsigned int userspace_reap;
 	struct cmdprio cmdprio;
 	unsigned int nowait;
 };
=20
+static int str_cmdprio_bssplit_cb(void *data, const char *input)
+{
+	struct libaio_options *o =3D data;
+	struct thread_data *td =3D o->td;
+	struct cmdprio *cmdprio =3D &o->cmdprio;
+
+	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
+}
+
 static struct fio_option options[] =3D {
 	{
 		.name	=3D "userspace_reap",
@@ -117,6 +126,16 @@ static struct fio_option options[] =3D {
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name   =3D "cmdprio_bssplit",
+		.lname  =3D "Priority percentage block size split",
+		.type   =3D FIO_OPT_STR_ULL,
+		.cb     =3D str_cmdprio_bssplit_cb,
+		.off1   =3D offsetof(struct libaio_options, cmdprio.bssplit),
+		.help   =3D "Set priority percentages for different block sizes",
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_LIBAIO,
+	},
 #else
 	{
 		.name	=3D "cmdprio_percentage",
@@ -136,6 +155,12 @@ static struct fio_option options[] =3D {
 		.type	=3D FIO_OPT_UNSUPPORTED,
 		.help	=3D "Your platform does not support I/O priority classes",
 	},
+	{
+		.name   =3D "cmdprio_bssplit",
+		.lname  =3D "Priority percentage block size split",
+		.type	=3D FIO_OPT_UNSUPPORTED,
+		.help	=3D "Your platform does not support I/O priority classes",
+	},
 #endif
 	{
 		.name	=3D "nowait",
@@ -185,7 +210,7 @@ static void fio_libaio_prio_prep(struct thread_data *td=
, struct io_u *io_u)
 	struct libaio_options *o =3D td->eo;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
 	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D cmdprio->percentage[ddir];
+	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
=20
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		io_u->iocb.aio_reqprio =3D
diff --git a/fio.1 b/fio.1
index 09b97de3..415a91bb 100644
--- a/fio.1
+++ b/fio.1
@@ -1972,21 +1972,31 @@ used. fio must also be run as the root user.
 .TP
 .BI (io_uring,libaio)cmdprio_class \fR=3D\fPint[,int]
 Set the I/O priority class to use for I/Os that must be issued with a
-priority when \fBcmdprio_percentage\fR is set. If not specified when
-\fBcmdprio_percentage\fR is set, this defaults to the highest priority
-class. A single value applies to reads and writes. Comma-separated
-values may be specified for reads and writes. See man \fBionice\fR\|(1).
-See also the \fBprioclass\fR option.
+priority when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR is set.
+If not specified when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR
+is set, this defaults to the highest priority class. A single value applie=
s
+to reads and writes. Comma-separated values may be specified for reads and
+writes. See man \fBionice\fR\|(1). See also the \fBprioclass\fR option.
 .TP
 .BI (io_uring,libaio)cmdprio \fR=3D\fPint[,int]
 Set the I/O priority value to use for I/Os that must be issued with a
-priority when \fBcmdprio_percentage\fR is set. If not specified when
-\fBcmdprio_percentage\fR is set, this defaults to 0. Linux limits us to
-a positive value between 0 and 7, with 0 being the highest. A single
-value applies to reads and writes. Comma-separated values may be specified
-for reads and writes. See man \fBionice\fR\|(1). Refer to an appropriate
-manpage for other operating systems since the meaning of priority may diff=
er.
-See also the \fBprio\fR option.
+priority when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR is set.
+If not specified when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR
+is set, this defaults to 0. Linux limits us to a positive value between
+0 and 7, with 0 being the highest. A single value applies to reads and wri=
tes.
+Comma-separated values may be specified for reads and writes. See man
+\fBionice\fR\|(1). Refer to an appropriate manpage for other operating sys=
tems
+since the meaning of priority may differ. See also the \fBprio\fR option.
+.TP
+.BI (io_uring,libaio)cmdprio_bssplit \fR=3D\fPstr[,str]
+To get a finer control over I/O priority, this option allows specifying
+the percentage of IOs that must have a priority set depending on the block
+size of the IO. This option is useful only when used together with the opt=
ion
+\fBbssplit\fR, that is, multiple different block sizes are used for reads =
and
+writes. The format for this option is the same as the format of the
+\fBbssplit\fR option, with the exception that values for trim IOs are
+ignored. This option is mutually exclusive with the \fBcmdprio_percentage\=
fR
+option.
 .TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO cal=
l, and
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 5ba59c52..cfd2fd8e 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,10 +51,10 @@ specific_options=3Dhttps  http_host  http_user  http_pa=
ss  http_s3_key  http_s3_ke
 specific_options=3Dime_psync  ime_psyncv
=20
 [ioengine_io_uring]
-specific_options=3Dhipri  cmdprio_percentage  cmdprio_class  cmdprio  fixe=
dbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncach=
ed  nowait  force_async
+specific_options=3Dhipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdp=
rio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  no=
nvectored  uncached  nowait  force_async
=20
 [ioengine_libaio]
-specific_options=3Duserspace_reap  cmdprio_percentage  cmdprio_class  cmdp=
rio  nowait
+specific_options=3Duserspace_reap  cmdprio_percentage  cmdprio_class  cmdp=
rio  cmdprio_bssplit  nowait
=20
 [ioengine_libcufile]
 specific_options=3Dgpu_dev_ids  cuda_io
--=20
2.31.1

