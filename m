Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 08/11] libaio: introduce aioprio_bssplit
Date: Tue,  6 Jul 2021 09:17:40 +0900
Message-Id: <20210706001743.10818-9-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

The cmdprio_percentage, aioprioclass and aioprio options allow
specifying different values for read and write operations. This enables
various IO priority issuing patterns even uner a mixed read-write
workload but does not allow differentiation within read and write
operation types of IOs with different sizes when the bssplit option is
used.

Add the aioprio_bssplit to complement the use of the bssplit option.
This new option has the same format as the bssplit option, but the
percentage value indicates the percentage of IO operation with a
cparticular block size that must be issued with the priority class and
value specified by aioprioclass and aioprio.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 HOWTO                        |  11 +++
 engines/libaio.c             | 130 +++++++++++++++++++++++++++++++++--
 fio.1                        |  10 +++
 tools/fiograph/fiograph.conf |   2 +-
 4 files changed, 145 insertions(+), 8 deletions(-)

diff --git a/HOWTO b/HOWTO
index aaf87d95..9a7158aa 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2186,6 +2186,17 @@ with the caveat that when used on the command line, they must come after the
 	Refer to an appropriate manpage for other operating systems since
 	meaning of priority may differ. See also the :option:`prio` option.
 
+.. option:: aioprio_bssplit=str[,str]
+	To get a finer control over AIO priority, this option allows
+	specifying the percentage of IOs that must have a priority set
+	depending on the block size of the IO. This option is useful only
+	when used together with the :option:`bssplit` option, that is,
+	multiple different block sizes are used for reads and writes.
+	The format for this option is the same as the format of the
+	:option:`bssplit` option, with the exception that values for
+	trim IOs are ignored. This option is mutually exclusive with the
+	:option:`cmdprio_percentage` option.
+
 .. option:: userspace_reap : [libaio]
 
 	Normally, with the libaio engine in use, fio will use the
diff --git a/engines/libaio.c b/engines/libaio.c
index 96f799de..e0f8a3d3 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -50,17 +50,84 @@ struct libaio_data {
 	unsigned int queued;
 	unsigned int head;
 	unsigned int tail;
+
+	bool use_aioprio;
 };
 
 struct libaio_options {
-	void *pad;
+	struct thread_data *td;
 	unsigned int userspace_reap;
 	unsigned int aioprio_percentage[DDIR_RWDIR_CNT];
 	unsigned int aioprio_class[DDIR_RWDIR_CNT];
 	unsigned int aioprio[DDIR_RWDIR_CNT];
+	unsigned int aioprio_bssplit_nr[DDIR_RWDIR_CNT];
+	struct bssplit *aioprio_bssplit[DDIR_RWDIR_CNT];
 	unsigned int nowait;
 };
 
+static int libaio_aioprio_bssplit_ddir(struct thread_options *to, void *eo,
+				       enum fio_ddir ddir, char *str, bool data)
+{
+	struct libaio_options *o = eo;
+	struct split split;
+	unsigned int i;
+
+	if (ddir == DDIR_TRIM)
+		return 0;
+
+	memset(&split, 0, sizeof(split));
+
+	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
+		return 1;
+	if (!split.nr)
+		return 0;
+
+	o->aioprio_bssplit_nr[ddir] = split.nr;
+	o->aioprio_bssplit[ddir] = malloc(split.nr * sizeof(struct bssplit));
+	if (!o->aioprio_bssplit[ddir])
+		return 1;
+
+	for (i = 0; i < split.nr; i++) {
+		o->aioprio_bssplit[ddir][i].bs = split.val1[i];
+		if (split.val2[i] == -1U) {
+			o->aioprio_bssplit[ddir][i].perc = 0;
+		} else {
+			if (split.val2[i] > 100)
+				o->aioprio_bssplit[ddir][i].perc = 100;
+			else
+				o->aioprio_bssplit[ddir][i].perc = split.val2[i];
+		}
+	}
+
+	return 0;
+}
+
+static int str_aioprio_bssplit_cb(void *data, const char *input)
+{
+	struct libaio_options *o = data;
+	struct thread_data *td = o->td;
+	char *str, *p;
+	int i, ret = 0;
+
+	p = str = strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	ret = str_split_parse(td, str, libaio_aioprio_bssplit_ddir, o, false);
+
+	if (parse_dryrun()) {
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			free(o->aioprio_bssplit[i]);
+			o->aioprio_bssplit[i] = NULL;
+			o->aioprio_bssplit_nr[i] = 0;
+		}
+	}
+
+	free(p);
+	return ret;
+}
+
 static struct fio_option options[] = {
 	{
 		.name	= "userspace_reap",
@@ -96,7 +163,7 @@ static struct fio_option options[] = {
 		.maxval	= IOPRIO_MAX_PRIO_CLASS,
 		.interval = 1,
 		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_CRED,
+		.group	= FIO_OPT_G_LIBAIO,
 	},
 	{
 		.name	= "aioprio",
@@ -109,7 +176,17 @@ static struct fio_option options[] = {
 		.maxval	= IOPRIO_MAX_PRIO,
 		.interval = 1,
 		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_CRED,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name   = "aioprio_bssplit",
+		.lname  = "Priority percentage block size split",
+		.type   = FIO_OPT_STR_ULL,
+		.cb     = str_aioprio_bssplit_cb,
+		.off1   = offsetof(struct libaio_options, aioprio_bssplit),
+		.help   = "Set priority percentages for different block sizes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
 	},
 #else
 	{
@@ -130,6 +207,12 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support I/O priority classes",
 	},
+	{
+		.name   = "aioprio_bssplit",
+		.lname  = "Priority percentage block size split",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
 #endif
 	{
 		.name	= "nowait",
@@ -174,11 +257,33 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+static int fio_libaio_need_prio(struct libaio_options *o, struct io_u *io_u)
+{
+	enum fio_ddir ddir = io_u->ddir;
+	unsigned int p = o->aioprio_percentage[ddir];
+	int i;
+
+	/*
+	 * If cmdprio_percentage option was specified, then use that
+	 * percentage. Otherwise, use aioprio_bssplit percentages depending
+	 * on the IO size.
+	 */
+	if (p)
+		return p;
+
+	for (i = 0; i < o->aioprio_bssplit_nr[ddir]; i++) {
+		if (o->aioprio_bssplit[ddir][i].bs == io_u->buflen)
+			return o->aioprio_bssplit[ddir][i].perc;
+	}
+
+	return 0;
+}
+
 static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct libaio_options *o = td->eo;
 	enum fio_ddir ddir = io_u->ddir;
-	unsigned int p = o->aioprio_percentage[ddir];
+	unsigned int p = fio_libaio_need_prio(o, io_u);
 
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		io_u->iocb.aio_reqprio =
@@ -291,7 +396,6 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld = td->io_ops_data;
-	struct libaio_options *o = td->eo;
 
 	fio_ro_check(td, io_u);
 
@@ -322,7 +426,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	if (o->aioprio_percentage[io_u->ddir])
+	if (ld->use_aioprio)
 		fio_libaio_prio_prep(td, io_u);
 
 	ld->iocbs[ld->head] = &io_u->iocb;
@@ -464,9 +568,10 @@ static int fio_libaio_post_init(struct thread_data *td)
 
 static int fio_libaio_init(struct thread_data *td)
 {
+	struct thread_options *to = &td->o;
 	struct libaio_options *o = td->eo;
 	struct libaio_data *ld;
-	struct thread_options *to = &td->o;
+	int nr_aioprio_bssplits = 0;
 	int i, p = 0;
 
 	ld = calloc(1, sizeof(*ld));
@@ -487,11 +592,19 @@ static int fio_libaio_init(struct thread_data *td)
 		if (o->aioprio_percentage[i] && !o->aioprio_class[i])
 			o->aioprio_class[i] = IOPRIO_CLASS_RT;
 		p += o->aioprio_percentage[i];
+		nr_aioprio_bssplits += o->aioprio_bssplit_nr[i];
 	}
 
 	/*
 	 * Check for option conflicts
 	 */
+	if (p && nr_aioprio_bssplits) {
+		log_err("%s: cmdprio_percentage and aioprio_bssplit options "
+			"are mutually exclusive\n",
+			to->name);
+		td_verror(td, EINVAL, "fio_libaio_init");
+		return 1;
+	}
 	if (p &&
 	    (fio_option_is_set(to, ioprio) ||
 	     fio_option_is_set(to, ioprio_class))) {
@@ -501,6 +614,9 @@ static int fio_libaio_init(struct thread_data *td)
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
 	}
+
+	ld->use_aioprio = p || nr_aioprio_bssplits;
+
 	return 0;
 }
 
diff --git a/fio.1 b/fio.1
index 0f4b9ff7..129aeb94 100644
--- a/fio.1
+++ b/fio.1
@@ -1976,6 +1976,16 @@ for reads and writes. See man \fBionice\fR\|(1). Refer to an appropriate
 manpage for other operating systems since the meaning of priority may differ.
 See also the \fBprio\fR option.
 .TP
+.BI (libaio)aioprio_bssplit \fR=\fPstr[,str]
+To get a finer control over AIO priority, this option allows specifying
+the percentage of IOs that must have a priority set depending on the block
+size of the IO. This option is useful only when used together with the option
+\fBbssplit\fR, that is, multiple different block sizes are used for reads and
+writes. The format for this option is the same as the format of the
+\fBbssplit\fR option, with the exception that values for trim IOs are
+ignored. This option is mutually exclusive with the \fBcmdprio_percentage\fR
+option.
+.TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
 \fBio_getevents\fR\|(3) system call to reap newly returned events. With
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 7f0434d5..4bfecdd8 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,7 +51,7 @@ specific_options=ime_psync  ime_psyncv
 specific_options=hipri  cmdprio_percentage  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
 
 [ioengine_libaio]
-specific_options=userspace_reap  cmdprio_percentage  aioprio_percentage  nowait aioprioclass aioprio
+specific_options=userspace_reap  cmdprio_percentage  aioprio_percentage  nowait aioprioclass aiopri0  aioprio_bssplit
 
 [ioengine_libcufile]
 specific_options=gpu_dev_ids  cuda_io
-- 
2.31.1


