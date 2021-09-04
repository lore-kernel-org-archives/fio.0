Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbhIDMBJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Sep 2021 08:01:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D18C061575
        for <fio@vger.kernel.org>; Sat,  4 Sep 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mMUL7-000alj-3I
        for fio@vger.kernel.org; Sat, 04 Sep 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210904120002.353061BC015D@kernel.dk>
Date: Sat,  4 Sep 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f3463241727215e228a60dc3b9a1ba2996f149a1:

  oslib: Fix blkzoned_get_max_open_zones() (2021-09-02 20:56:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 63176c21beb68ec54787eb2fd6be5b3c9132113b:

  examples: add examples for cmdprio_* IO priority options (2021-09-03 10:12:25 -0600)

----------------------------------------------------------------
Damien Le Moal (11):
      manpage: fix formatting
      manpage: fix definition of prio and prioclass options
      tools: fiograph: do not overwrite input script file
      os: introduce ioprio_value() helper
      options: make parsing functions available to ioengines
      libaio,io_uring: improve cmdprio_percentage option
      libaio,io_uring: introduce cmdprio_class and cmdprio options
      libaio,io_uring: introduce cmdprio_bssplit
      libaio,io_uring: relax cmdprio_percentage constraints
      fio: Introduce the log_prio option
      examples: add examples for cmdprio_* IO priority options

 HOWTO                           |  59 ++++++++++++----
 backend.c                       |   1 +
 cconv.c                         |   2 +
 client.c                        |   2 +
 engines/cmdprio.h               | 144 +++++++++++++++++++++++++++++++++++++
 engines/filecreate.c            |   2 +-
 engines/filedelete.c            |   2 +-
 engines/filestat.c              |   2 +-
 engines/io_uring.c              | 152 ++++++++++++++++++++++++++++++++--------
 engines/libaio.c                | 125 ++++++++++++++++++++++++++++-----
 eta.c                           |   2 +-
 examples/cmdprio-bssplit.fio    |  17 +++++
 examples/cmdprio-bssplit.png    | Bin 0 -> 45606 bytes
 examples/cmdprio-percentage.fio |  17 +++++
 examples/cmdprio-percentage.png | Bin 0 -> 46271 bytes
 fio.1                           |  73 ++++++++++++++-----
 fio.h                           |   5 ++
 init.c                          |   4 ++
 io_u.c                          |  14 ++--
 io_u.h                          |  10 ++-
 iolog.c                         |  45 +++++++++---
 iolog.h                         |  16 ++++-
 options.c                       |  50 ++++++-------
 os/os-android.h                 |  20 ++++--
 os/os-dragonfly.h               |   1 +
 os/os-linux.h                   |  20 ++++--
 os/os.h                         |   4 ++
 server.h                        |   3 +-
 stat.c                          |  75 ++++++++++----------
 stat.h                          |   9 ++-
 thread_options.h                |  19 +++++
 tools/fiograph/fiograph.conf    |   4 +-
 tools/fiograph/fiograph.py      |   4 +-
 33 files changed, 724 insertions(+), 179 deletions(-)
 create mode 100644 engines/cmdprio.h
 create mode 100644 examples/cmdprio-bssplit.fio
 create mode 100644 examples/cmdprio-bssplit.png
 create mode 100644 examples/cmdprio-percentage.fio
 create mode 100644 examples/cmdprio-percentage.png

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a2cf20f6..1853f56a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2163,14 +2163,49 @@ In addition, there are some parameters which are only valid when a specific
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
+
+.. option:: cmdprio_class=int[,int] : [io_uring] [libaio]
+
+	Set the I/O priority class to use for I/Os that must be issued with
+	a priority when :option:`cmdprio_percentage` or
+	:option:`cmdprio_bssplit` is set. If not specified when
+	:option:`cmdprio_percentage` or :option:`cmdprio_bssplit` is set,
+	this defaults to the highest priority class. A single value applies
+	to reads and writes. Comma-separated values may be specified for
+	reads and writes. See :manpage:`ionice(1)`. See also the
+	:option:`prioclass` option.
+
+.. option:: cmdprio=int[,int] : [io_uring] [libaio]
+
+	Set the I/O priority value to use for I/Os that must be issued with
+	a priority when :option:`cmdprio_percentage` or
+	:option:`cmdprio_bssplit` is set. If not specified when
+	:option:`cmdprio_percentage` or :option:`cmdprio_bssplit` is set,
+	this defaults to 0.
+	Linux limits us to a positive value between 0 and 7, with 0 being the
+	highest. A single value applies to reads and writes. Comma-separated
+	values may be specified for reads and writes. See :manpage:`ionice(1)`.
+	Refer to an appropriate manpage for other operating systems since
+	meaning of priority may differ. See also the :option:`prio` option.
+
+.. option:: cmdprio_bssplit=str[,str] : [io_uring] [libaio]
+	To get a finer control over I/O priority, this option allows
+	specifying the percentage of IOs that must have a priority set
+	depending on the block size of the IO. This option is useful only
+	when used together with the :option:`bssplit` option, that is,
+	multiple different block sizes are used for reads and writes.
+	The format for this option is the same as the format of the
+	:option:`bssplit` option, with the exception that values for
+	trim IOs are ignored. This option is mutually exclusive with the
+	:option:`cmdprio_percentage` option.
 
 .. option:: fixedbufs : [io_uring]
 
@@ -2974,14 +3009,14 @@ Threads, processes and job synchronization
 	between 0 and 7, with 0 being the highest.  See man
 	:manpage:`ionice(1)`. Refer to an appropriate manpage for other operating
 	systems since meaning of priority may differ. For per-command priority
-	setting, see I/O engine specific `cmdprio_percentage` and `hipri_percentage`
-	options.
+	setting, see I/O engine specific :option:`cmdprio_percentage` and
+	:option:`cmdprio` options.
 
 .. option:: prioclass=int
 
 	Set the I/O priority class. See man :manpage:`ionice(1)`. For per-command
-	priority setting, see I/O engine specific `cmdprio_percentage` and
-	`hipri_percentage` options.
+	priority setting, see I/O engine specific :option:`cmdprio_percentage`
+	and :option:`cmdprio_class` options.
 
 .. option:: cpus_allowed=str
 
diff --git a/backend.c b/backend.c
index 808e4362..1bcb035a 100644
--- a/backend.c
+++ b/backend.c
@@ -1760,6 +1760,7 @@ static void *thread_main(void *data)
 			td_verror(td, errno, "ioprio_set");
 			goto err;
 		}
+		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
 	}
 
 	if (o->cgroup && cgroup_setup(td, cgroup_list, &cgroup_mnt))
diff --git a/cconv.c b/cconv.c
index e3a8c27c..2dc5274e 100644
--- a/cconv.c
+++ b/cconv.c
@@ -192,6 +192,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->log_hist_coarseness = le32_to_cpu(top->log_hist_coarseness);
 	o->log_max = le32_to_cpu(top->log_max);
 	o->log_offset = le32_to_cpu(top->log_offset);
+	o->log_prio = le32_to_cpu(top->log_prio);
 	o->log_gz = le32_to_cpu(top->log_gz);
 	o->log_gz_store = le32_to_cpu(top->log_gz_store);
 	o->log_unix_epoch = le32_to_cpu(top->log_unix_epoch);
@@ -417,6 +418,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
 	top->log_max = cpu_to_le32(o->log_max);
 	top->log_offset = cpu_to_le32(o->log_offset);
+	top->log_prio = cpu_to_le32(o->log_prio);
 	top->log_gz = cpu_to_le32(o->log_gz);
 	top->log_gz_store = cpu_to_le32(o->log_gz_store);
 	top->log_unix_epoch = cpu_to_le32(o->log_unix_epoch);
diff --git a/client.c b/client.c
index 29d8750a..8b230617 100644
--- a/client.c
+++ b/client.c
@@ -1679,6 +1679,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 	ret->log_type		= le32_to_cpu(ret->log_type);
 	ret->compressed		= le32_to_cpu(ret->compressed);
 	ret->log_offset		= le32_to_cpu(ret->log_offset);
+	ret->log_prio		= le32_to_cpu(ret->log_prio);
 	ret->log_hist_coarseness = le32_to_cpu(ret->log_hist_coarseness);
 
 	if (*store_direct)
@@ -1696,6 +1697,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		s->data.val	= le64_to_cpu(s->data.val);
 		s->__ddir	= __le32_to_cpu(s->__ddir);
 		s->bs		= le64_to_cpu(s->bs);
+		s->priority	= le16_to_cpu(s->priority);
 
 		if (ret->log_offset) {
 			struct io_sample_offset *so = (void *) s;
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
new file mode 100644
index 00000000..0edc4365
--- /dev/null
+++ b/engines/cmdprio.h
@@ -0,0 +1,144 @@
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
+	unsigned int class[DDIR_RWDIR_CNT];
+	unsigned int level[DDIR_RWDIR_CNT];
+	unsigned int bssplit_nr[DDIR_RWDIR_CNT];
+	struct bssplit *bssplit[DDIR_RWDIR_CNT];
+};
+
+static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_arg,
+				    enum fio_ddir ddir, char *str, bool data)
+{
+	struct cmdprio *cmdprio = cb_arg;
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
+	cmdprio->bssplit_nr[ddir] = split.nr;
+	cmdprio->bssplit[ddir] = malloc(split.nr * sizeof(struct bssplit));
+	if (!cmdprio->bssplit[ddir])
+		return 1;
+
+	for (i = 0; i < split.nr; i++) {
+		cmdprio->bssplit[ddir][i].bs = split.val1[i];
+		if (split.val2[i] == -1U) {
+			cmdprio->bssplit[ddir][i].perc = 0;
+		} else {
+			if (split.val2[i] > 100)
+				cmdprio->bssplit[ddir][i].perc = 100;
+			else
+				cmdprio->bssplit[ddir][i].perc = split.val2[i];
+		}
+	}
+
+	return 0;
+}
+
+static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
+				     struct cmdprio *cmdprio)
+{
+	char *str, *p;
+	int i, ret = 0;
+
+	p = str = strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false);
+
+	if (parse_dryrun()) {
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			free(cmdprio->bssplit[i]);
+			cmdprio->bssplit[i] = NULL;
+			cmdprio->bssplit_nr[i] = 0;
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
+	enum fio_ddir ddir = io_u->ddir;
+	unsigned int p = cmdprio->percentage[ddir];
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
+	for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
+		if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
+			return cmdprio->bssplit[ddir][i].perc;
+	}
+
+	return 0;
+}
+
+static int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+			    bool *has_cmdprio)
+{
+	struct thread_options *to = &td->o;
+	bool has_cmdprio_percentage = false;
+	bool has_cmdprio_bssplit = false;
+	int i;
+
+	/*
+	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
+	 * is not set, default to RT priority class.
+	 */
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		if (cmdprio->percentage[i]) {
+			if (!cmdprio->class[i])
+				cmdprio->class[i] = IOPRIO_CLASS_RT;
+			has_cmdprio_percentage = true;
+		}
+		if (cmdprio->bssplit_nr[i]) {
+			if (!cmdprio->class[i])
+				cmdprio->class[i] = IOPRIO_CLASS_RT;
+			has_cmdprio_bssplit = true;
+		}
+	}
+
+	/*
+	 * Check for option conflicts
+	 */
+	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
+		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
+			"are mutually exclusive\n",
+			to->name);
+		return 1;
+	}
+
+	*has_cmdprio = has_cmdprio_percentage || has_cmdprio_bssplit;
+
+	return 0;
+}
+
+#endif
diff --git a/engines/filecreate.c b/engines/filecreate.c
index 16c64928..4bb13c34 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -49,7 +49,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
 	}
 
 	return 0;
diff --git a/engines/filedelete.c b/engines/filedelete.c
index 64c58639..e882ccf0 100644
--- a/engines/filedelete.c
+++ b/engines/filedelete.c
@@ -51,7 +51,7 @@ static int delete_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
 	}
 
 	return 0;
diff --git a/engines/filestat.c b/engines/filestat.c
index 405f028d..00311247 100644
--- a/engines/filestat.c
+++ b/engines/filestat.c
@@ -125,7 +125,7 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
 	}
 
 	return 0;
diff --git a/engines/io_uring.c b/engines/io_uring.c
index b8d4cf91..27a4a678 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -23,6 +23,7 @@
 
 #include "../lib/types.h"
 #include "../os/linux/io_uring.h"
+#include "cmdprio.h"
 
 struct io_sq_ring {
 	unsigned *head;
@@ -64,17 +65,17 @@ struct ioring_data {
 	int queued;
 	int cq_ring_off;
 	unsigned iodepth;
-	bool ioprio_class_set;
-	bool ioprio_set;
 	int prepped;
 
 	struct ioring_mmap mmap[3];
+
+	bool use_cmdprio;
 };
 
 struct ioring_options {
-	void *pad;
+	struct thread_data *td;
 	unsigned int hipri;
-	unsigned int cmdprio_percentage;
+	struct cmdprio cmdprio;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
 	unsigned int sqpoll_thread;
@@ -105,6 +106,15 @@ static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 	return 0;
 }
 
+static int str_cmdprio_bssplit_cb(void *data, const char *input)
+{
+	struct ioring_options *o = data;
+	struct thread_data *td = o->td;
+	struct cmdprio *cmdprio = &o->cmdprio;
+
+	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
+}
+
 static struct fio_option options[] = {
 	{
 		.name	= "hipri",
@@ -120,13 +130,56 @@ static struct fio_option options[] = {
 		.name	= "cmdprio_percentage",
 		.lname	= "high priority percentage",
 		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct ioring_options, cmdprio_percentage),
-		.minval	= 1,
+		.off1	= offsetof(struct ioring_options,
+				   cmdprio.percentage[DDIR_READ]),
+		.off2	= offsetof(struct ioring_options,
+				   cmdprio.percentage[DDIR_WRITE]),
+		.minval	= 0,
 		.maxval	= 100,
 		.help	= "Send high priority I/O this percentage of the time",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "cmdprio_class",
+		.lname	= "Asynchronous I/O priority class",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options,
+				   cmdprio.class[DDIR_READ]),
+		.off2	= offsetof(struct ioring_options,
+				   cmdprio.class[DDIR_WRITE]),
+		.help	= "Set asynchronous IO priority class",
+		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
+		.maxval	= IOPRIO_MAX_PRIO_CLASS,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "cmdprio",
+		.lname	= "Asynchronous I/O priority level",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options,
+				   cmdprio.level[DDIR_READ]),
+		.off2	= offsetof(struct ioring_options,
+				   cmdprio.level[DDIR_WRITE]),
+		.help	= "Set asynchronous IO priority level",
+		.minval	= IOPRIO_MIN_PRIO,
+		.maxval	= IOPRIO_MAX_PRIO,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name   = "cmdprio_bssplit",
+		.lname  = "Priority percentage block size split",
+		.type   = FIO_OPT_STR_ULL,
+		.cb     = str_cmdprio_bssplit_cb,
+		.off1   = offsetof(struct ioring_options, cmdprio.bssplit),
+		.help   = "Set priority percentages for different block sizes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 #else
 	{
 		.name	= "cmdprio_percentage",
@@ -134,6 +187,24 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support I/O priority classes",
 	},
+	{
+		.name	= "cmdprio_class",
+		.lname	= "Asynchronous I/O priority class",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
+	{
+		.name	= "cmdprio",
+		.lname	= "Asynchronous I/O priority level",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
+	{
+		.name   = "cmdprio_bssplit",
+		.lname  = "Priority percentage block size split",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
 #endif
 	{
 		.name	= "fixedbufs",
@@ -267,10 +338,6 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->rw_flags |= RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |= RWF_NOWAIT;
-		if (ld->ioprio_class_set)
-			sqe->ioprio = td->o.ioprio_class << 13;
-		if (ld->ioprio_set)
-			sqe->ioprio |= td->o.ioprio;
 		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
 		sqe->ioprio = 0;
@@ -381,13 +448,37 @@ static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld = td->io_ops_data;
-	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
-		ld->sqes[io_u->index].ioprio = IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
-		io_u->flags |= IO_U_F_PRIORITY;
+	struct io_uring_sqe *sqe = &ld->sqes[io_u->index];
+	struct cmdprio *cmdprio = &o->cmdprio;
+	enum fio_ddir ddir = io_u->ddir;
+	unsigned int p = fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int cmdprio_value =
+		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
+
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		sqe->ioprio = cmdprio_value;
+		if (!td->ioprio || cmdprio_value < td->ioprio) {
+			/*
+			 * The async IO priority is higher (has a lower value)
+			 * than the priority set by "prio" and "prioclass"
+			 * options.
+			 */
+			io_u->flags |= IO_U_F_HIGH_PRIO;
+		}
 	} else {
-		ld->sqes[io_u->index].ioprio = 0;
+		sqe->ioprio = td->ioprio;
+		if (cmdprio_value && td->ioprio && td->ioprio < cmdprio_value) {
+			/*
+			 * The IO will be executed with the priority set by
+			 * "prio" and "prioclass" options, and this priority
+			 * is higher (has a lower value) than the async IO
+			 * priority.
+			 */
+			io_u->flags |= IO_U_F_HIGH_PRIO;
+		}
 	}
-	return;
+
+	io_u->ioprio = sqe->ioprio;
 }
 
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
@@ -395,7 +486,6 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct io_sq_ring *ring = &ld->sq_ring;
-	struct ioring_options *o = td->eo;
 	unsigned tail, next_tail;
 
 	fio_ro_check(td, io_u);
@@ -418,7 +508,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (next_tail == atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
 
-	if (o->cmdprio_percentage)
+	if (ld->use_cmdprio)
 		fio_ioring_prio_prep(td, io_u);
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	atomic_store_release(ring->tail, next_tail);
@@ -729,7 +819,9 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
-	struct thread_options *to = &td->o;
+	struct cmdprio *cmdprio = &o->cmdprio;
+	bool has_cmdprio = false;
+	int ret;
 
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
@@ -753,21 +845,21 @@ static int fio_ioring_init(struct thread_data *td)
 
 	td->io_ops_data = ld;
 
-	/*
-	 * Check for option conflicts
-	 */
-	if ((fio_option_is_set(to, ioprio) || fio_option_is_set(to, ioprio_class)) &&
-			o->cmdprio_percentage != 0) {
-		log_err("%s: cmdprio_percentage option and mutually exclusive "
-				"prio or prioclass option is set, exiting\n", to->name);
-		td_verror(td, EINVAL, "fio_io_uring_init");
+	ret = fio_cmdprio_init(td, cmdprio, &has_cmdprio);
+	if (ret) {
+		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
 	}
 
-	if (fio_option_is_set(&td->o, ioprio_class))
-		ld->ioprio_class_set = true;
-	if (fio_option_is_set(&td->o, ioprio))
-		ld->ioprio_set = true;
+	/*
+	 * Since io_uring can have a submission context (sqthread_poll) that is
+	 * different from the process context, we cannot rely on the the IO
+	 * priority set by ioprio_set() (option prio/prioclass) to be inherited.
+	 * Therefore, we set the sqe->ioprio field when prio/prioclass is used.
+	 */
+	ld->use_cmdprio = has_cmdprio ||
+		fio_option_is_set(&td->o, ioprio_class) ||
+		fio_option_is_set(&td->o, ioprio);
 
 	return 0;
 }
diff --git a/engines/libaio.c b/engines/libaio.c
index b909b79e..dd655355 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -15,6 +15,7 @@
 #include "../lib/pow2.h"
 #include "../optgroup.h"
 #include "../lib/memalign.h"
+#include "cmdprio.h"
 
 /* Should be defined in newest aio_abi.h */
 #ifndef IOCB_FLAG_IOPRIO
@@ -50,15 +51,26 @@ struct libaio_data {
 	unsigned int queued;
 	unsigned int head;
 	unsigned int tail;
+
+	bool use_cmdprio;
 };
 
 struct libaio_options {
-	void *pad;
+	struct thread_data *td;
 	unsigned int userspace_reap;
-	unsigned int cmdprio_percentage;
+	struct cmdprio cmdprio;
 	unsigned int nowait;
 };
 
+static int str_cmdprio_bssplit_cb(void *data, const char *input)
+{
+	struct libaio_options *o = data;
+	struct thread_data *td = o->td;
+	struct cmdprio *cmdprio = &o->cmdprio;
+
+	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
+}
+
 static struct fio_option options[] = {
 	{
 		.name	= "userspace_reap",
@@ -74,13 +86,56 @@ static struct fio_option options[] = {
 		.name	= "cmdprio_percentage",
 		.lname	= "high priority percentage",
 		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct libaio_options, cmdprio_percentage),
-		.minval	= 1,
+		.off1	= offsetof(struct libaio_options,
+				   cmdprio.percentage[DDIR_READ]),
+		.off2	= offsetof(struct libaio_options,
+				   cmdprio.percentage[DDIR_WRITE]),
+		.minval	= 0,
 		.maxval	= 100,
 		.help	= "Send high priority I/O this percentage of the time",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name	= "cmdprio_class",
+		.lname	= "Asynchronous I/O priority class",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct libaio_options,
+				   cmdprio.class[DDIR_READ]),
+		.off2	= offsetof(struct libaio_options,
+				   cmdprio.class[DDIR_WRITE]),
+		.help	= "Set asynchronous IO priority class",
+		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
+		.maxval	= IOPRIO_MAX_PRIO_CLASS,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name	= "cmdprio",
+		.lname	= "Asynchronous I/O priority level",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct libaio_options,
+				   cmdprio.level[DDIR_READ]),
+		.off2	= offsetof(struct libaio_options,
+				   cmdprio.level[DDIR_WRITE]),
+		.help	= "Set asynchronous IO priority level",
+		.minval	= IOPRIO_MIN_PRIO,
+		.maxval	= IOPRIO_MAX_PRIO,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name   = "cmdprio_bssplit",
+		.lname  = "Priority percentage block size split",
+		.type   = FIO_OPT_STR_ULL,
+		.cb     = str_cmdprio_bssplit_cb,
+		.off1   = offsetof(struct libaio_options, cmdprio.bssplit),
+		.help   = "Set priority percentages for different block sizes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
 #else
 	{
 		.name	= "cmdprio_percentage",
@@ -88,6 +143,24 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support I/O priority classes",
 	},
+	{
+		.name	= "cmdprio_class",
+		.lname	= "Asynchronous I/O priority class",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
+	{
+		.name	= "cmdprio",
+		.lname	= "Asynchronous I/O priority level",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
+	{
+		.name   = "cmdprio_bssplit",
+		.lname  = "Priority percentage block size split",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
 #endif
 	{
 		.name	= "nowait",
@@ -135,12 +208,31 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct libaio_options *o = td->eo;
-	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
-		io_u->iocb.aio_reqprio = IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
+	struct cmdprio *cmdprio = &o->cmdprio;
+	enum fio_ddir ddir = io_u->ddir;
+	unsigned int p = fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int cmdprio_value =
+		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
+
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		io_u->ioprio = cmdprio_value;
+		io_u->iocb.aio_reqprio = cmdprio_value;
 		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
-		io_u->flags |= IO_U_F_PRIORITY;
+		if (!td->ioprio || cmdprio_value < td->ioprio) {
+			/*
+			 * The async IO priority is higher (has a lower value)
+			 * than the default context priority.
+			 */
+			io_u->flags |= IO_U_F_HIGH_PRIO;
+		}
+	} else if (td->ioprio && td->ioprio < cmdprio_value) {
+		/*
+		 * The IO will be executed with the default context priority,
+		 * and this priority is higher (has a lower value) than the
+		 * async IO priority.
+		 */
+		io_u->flags |= IO_U_F_HIGH_PRIO;
 	}
-	return;
 }
 
 static struct io_u *fio_libaio_event(struct thread_data *td, int event)
@@ -246,7 +338,6 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld = td->io_ops_data;
-	struct libaio_options *o = td->eo;
 
 	fio_ro_check(td, io_u);
 
@@ -277,7 +368,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	if (o->cmdprio_percentage)
+	if (ld->use_cmdprio)
 		fio_libaio_prio_prep(td, io_u);
 
 	ld->iocbs[ld->head] = &io_u->iocb;
@@ -420,8 +511,9 @@ static int fio_libaio_post_init(struct thread_data *td)
 static int fio_libaio_init(struct thread_data *td)
 {
 	struct libaio_data *ld;
-	struct thread_options *to = &td->o;
 	struct libaio_options *o = td->eo;
+	struct cmdprio *cmdprio = &o->cmdprio;
+	int ret;
 
 	ld = calloc(1, sizeof(*ld));
 
@@ -432,16 +524,13 @@ static int fio_libaio_init(struct thread_data *td)
 	ld->io_us = calloc(ld->entries, sizeof(struct io_u *));
 
 	td->io_ops_data = ld;
-	/*
-	 * Check for option conflicts
-	 */
-	if ((fio_option_is_set(to, ioprio) || fio_option_is_set(to, ioprio_class)) &&
-			o->cmdprio_percentage != 0) {
-		log_err("%s: cmdprio_percentage option and mutually exclusive "
-				"prio or prioclass option is set, exiting\n", to->name);
+
+	ret = fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	if (ret) {
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
 	}
+
 	return 0;
 }
 
diff --git a/eta.c b/eta.c
index db13cb18..ea1781f3 100644
--- a/eta.c
+++ b/eta.c
@@ -509,7 +509,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		memcpy(&rate_prev_time, &now, sizeof(now));
 		regrow_agg_logs();
 		for_each_rw_ddir(ddir) {
-			add_agg_sample(sample_val(je->rate[ddir]), ddir, 0, 0);
+			add_agg_sample(sample_val(je->rate[ddir]), ddir, 0);
 		}
 	}
 
diff --git a/examples/cmdprio-bssplit.fio b/examples/cmdprio-bssplit.fio
new file mode 100644
index 00000000..47e9a790
--- /dev/null
+++ b/examples/cmdprio-bssplit.fio
@@ -0,0 +1,17 @@
+; Randomly read/write a block device file at queue depth 16.
+; 40 % of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 100% of the 64kB reads are executed at the highest priority and
+; all other IOs executed without a priority set.
+[global]
+filename=/dev/sda
+direct=1
+write_lat_log=prio-run.log
+log_prio=1
+
+[randrw]
+rw=randrw
+bssplit=64k/40:1024k/60,1024k/100
+ioengine=libaio
+iodepth=16
+cmdprio_bssplit=64k/100:1024k/0,1024k/0
+cmdprio_class=1
diff --git a/examples/cmdprio-bssplit.png b/examples/cmdprio-bssplit.png
new file mode 100644
index 00000000..a0bb3ff4
Binary files /dev/null and b/examples/cmdprio-bssplit.png differ
diff --git a/examples/cmdprio-percentage.fio b/examples/cmdprio-percentage.fio
new file mode 100644
index 00000000..e4bc9db8
--- /dev/null
+++ b/examples/cmdprio-percentage.fio
@@ -0,0 +1,17 @@
+; Read a block device file at queue depth 8
+; with 20 % of the IOs using the high priority RT class
+; and the remaining IOs using the idle priority class
+[global]
+filename=/dev/sda
+direct=1
+write_lat_log=prio-run.log
+log_prio=1
+
+[randread]
+rw=randread
+bs=128k
+ioengine=libaio
+iodepth=8
+prioclass=3
+cmdprio_percentage=20
+cmdprio_class=1
diff --git a/examples/cmdprio-percentage.png b/examples/cmdprio-percentage.png
new file mode 100644
index 00000000..e794de0c
Binary files /dev/null and b/examples/cmdprio-percentage.png differ
diff --git a/fio.1 b/fio.1
index 382cebfc..03fddffb 100644
--- a/fio.1
+++ b/fio.1
@@ -1962,13 +1962,41 @@ In addition, there are some parameters which are only valid when a specific
 with the caveat that when used on the command line, they must come after the
 \fBioengine\fR that defines them is selected.
 .TP
-.BI (io_uring, libaio)cmdprio_percentage \fR=\fPint
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
+.TP
+.BI (io_uring,libaio)cmdprio_class \fR=\fPint[,int]
+Set the I/O priority class to use for I/Os that must be issued with a
+priority when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR is set.
+If not specified when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR
+is set, this defaults to the highest priority class. A single value applies
+to reads and writes. Comma-separated values may be specified for reads and
+writes. See man \fBionice\fR\|(1). See also the \fBprioclass\fR option.
+.TP
+.BI (io_uring,libaio)cmdprio \fR=\fPint[,int]
+Set the I/O priority value to use for I/Os that must be issued with a
+priority when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR is set.
+If not specified when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR
+is set, this defaults to 0. Linux limits us to a positive value between
+0 and 7, with 0 being the highest. A single value applies to reads and writes.
+Comma-separated values may be specified for reads and writes. See man
+\fBionice\fR\|(1). Refer to an appropriate manpage for other operating systems
+since the meaning of priority may differ. See also the \fBprio\fR option.
+.TP
+.BI (io_uring,libaio)cmdprio_bssplit \fR=\fPstr[,str]
+To get a finer control over I/O priority, this option allows specifying
+the percentage of IOs that must have a priority set depending on the block
+size of the IO. This option is useful only when used together with the option
+\fBbssplit\fR, that is, multiple different block sizes are used for reads and
+writes. The format for this option is the same as the format of the
+\fBbssplit\fR option, with the exception that values for trim IOs are
+ignored. This option is mutually exclusive with the \fBcmdprio_percentage\fR
+option.
 .TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO call, and
@@ -2043,20 +2071,20 @@ Detect when I/O threads are done, then exit.
 .BI (libhdfs)namenode \fR=\fPstr
 The hostname or IP address of a HDFS cluster namenode to contact.
 .TP
-.BI (libhdfs)port
+.BI (libhdfs)port \fR=\fPint
 The listening port of the HFDS cluster namenode.
 .TP
-.BI (netsplice,net)port
+.BI (netsplice,net)port \fR=\fPint
 The TCP or UDP port to bind to or connect to. If this is used with
 \fBnumjobs\fR to spawn multiple instances of the same job type, then
 this will be the starting port number since fio will use a range of
 ports.
 .TP
-.BI (rdma, librpma_*)port
+.BI (rdma,librpma_*)port \fR=\fPint
 The port to use for RDMA-CM communication. This should be the same
 value on the client and the server side.
 .TP
-.BI (netsplice,net, rdma)hostname \fR=\fPstr
+.BI (netsplice,net,rdma)hostname \fR=\fPstr
 The hostname or IP address to use for TCP, UDP or RDMA-CM based I/O.
 If the job is a TCP listener or UDP reader, the hostname is not used
 and must be omitted unless it is a valid UDP multicast address.
@@ -2693,13 +2721,13 @@ Set the I/O priority value of this job. Linux limits us to a positive value
 between 0 and 7, with 0 being the highest. See man
 \fBionice\fR\|(1). Refer to an appropriate manpage for other operating
 systems since meaning of priority may differ. For per-command priority
-setting, see I/O engine specific `cmdprio_percentage` and `hipri_percentage`
-options.
+setting, see the I/O engine specific `cmdprio_percentage` and
+`cmdprio` options.
 .TP
 .BI prioclass \fR=\fPint
 Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
-priority setting, see I/O engine specific `cmdprio_percentage` and `hipri_percent`
-options.
+priority setting, see the I/O engine specific `cmdprio_percentage` and
+`cmdprio_class` options.
 .TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
@@ -3238,6 +3266,11 @@ If this is set, the iolog options will include the byte offset for the I/O
 entry as well as the other data values. Defaults to 0 meaning that
 offsets are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
 .TP
+.BI log_prio \fR=\fPbool
+If this is set, the iolog options will include the I/O priority for the I/O
+entry as well as the other data values. Defaults to 0 meaning that
+I/O priorities are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
+.TP
 .BI log_compression \fR=\fPint
 If this is set, fio will compress the I/O logs as it goes, to keep the
 memory footprint lower. When a log reaches the specified size, that chunk is
@@ -4171,8 +4204,14 @@ The entry's `block size' is always in bytes. The `offset' is the position in byt
 from the start of the file for that particular I/O. The logging of the offset can be
 toggled with \fBlog_offset\fR.
 .P
-`Command priority` is 0 for normal priority and 1 for high priority. This is controlled
-by the ioengine specific \fBcmdprio_percentage\fR.
+If \fBlog_prio\fR is not set, the entry's `Command priority` is 1 for an IO executed
+with the highest RT priority class (\fBprioclass\fR=1 or \fBcmdprio_class\fR=1) and 0
+otherwise. This is controlled by the \fBprioclass\fR option and the ioengine specific
+\fBcmdprio_percentage\fR \fBcmdprio_class\fR options. If \fBlog_prio\fR is set, the
+entry's `Command priority` is the priority set for the IO, as a 16-bits hexadecimal
+number with the lowest 13 bits indicating the priority value (\fBprio\fR and
+\fBcmdprio\fR options) and the highest 3 bits indicating the IO priority class
+(\fBprioclass\fR and \fBcmdprio_class\fR options).
 .P
 Fio defaults to logging every individual I/O but when windowed logging is set
 through \fBlog_avg_msec\fR, either the average (by default) or the maximum
diff --git a/fio.h b/fio.h
index 6f6b211b..da1fe085 100644
--- a/fio.h
+++ b/fio.h
@@ -280,6 +280,11 @@ struct thread_data {
 
 	int shm_id;
 
+	/*
+	 * Job default IO priority set with prioclass and prio options.
+	 */
+	unsigned int ioprio;
+
 	/*
 	 * IO engine hooks, contains everything needed to submit an io_u
 	 * to any of the available IO engines.
diff --git a/init.c b/init.c
index 871fb5ad..ec1a2cac 100644
--- a/init.c
+++ b/init.c
@@ -1583,6 +1583,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_LAT,
 			.log_offset = o->log_offset,
+			.log_prio = o->log_prio,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
@@ -1616,6 +1617,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_HIST,
 			.log_offset = o->log_offset,
+			.log_prio = o->log_prio,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
@@ -1647,6 +1649,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_BW,
 			.log_offset = o->log_offset,
+			.log_prio = o->log_prio,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
@@ -1678,6 +1681,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_IOPS,
 			.log_offset = o->log_offset,
+			.log_prio = o->log_prio,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
diff --git a/io_u.c b/io_u.c
index 696d25cd..5289b5d1 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1595,7 +1595,7 @@ again:
 		assert(io_u->flags & IO_U_F_FREE);
 		io_u_clear(td, io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
 				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
-				 IO_U_F_VER_LIST | IO_U_F_PRIORITY);
+				 IO_U_F_VER_LIST | IO_U_F_HIGH_PRIO);
 
 		io_u->error = 0;
 		io_u->acct_ddir = -1;
@@ -1799,6 +1799,10 @@ struct io_u *get_io_u(struct thread_data *td)
 	io_u->xfer_buf = io_u->buf;
 	io_u->xfer_buflen = io_u->buflen;
 
+	/*
+	 * Remember the issuing context priority. The IO engine may change this.
+	 */
+	io_u->ioprio = td->ioprio;
 out:
 	assert(io_u->file);
 	if (!td_io_prep(td, io_u)) {
@@ -1884,7 +1888,8 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		unsigned long long tnsec;
 
 		tnsec = ntime_since(&io_u->start_time, &icd->time);
-		add_lat_sample(td, idx, tnsec, bytes, io_u->offset, io_u_is_prio(io_u));
+		add_lat_sample(td, idx, tnsec, bytes, io_u->offset,
+			       io_u->ioprio, io_u_is_high_prio(io_u));
 
 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops = &td->prof_io_ops;
@@ -1905,7 +1910,8 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 	if (ddir_rw(idx)) {
 		if (!td->o.disable_clat) {
-			add_clat_sample(td, idx, llnsec, bytes, io_u->offset, io_u_is_prio(io_u));
+			add_clat_sample(td, idx, llnsec, bytes, io_u->offset,
+					io_u->ioprio, io_u_is_high_prio(io_u));
 			io_u_mark_latency(td, llnsec);
 		}
 
@@ -2162,7 +2168,7 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 			td = td->parent;
 
 		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen,
-				io_u->offset, io_u_is_prio(io_u));
+				io_u->offset, io_u->ioprio);
 	}
 }
 
diff --git a/io_u.h b/io_u.h
index d4c5be43..bdbac525 100644
--- a/io_u.h
+++ b/io_u.h
@@ -21,7 +21,7 @@ enum {
 	IO_U_F_TRIMMED		= 1 << 5,
 	IO_U_F_BARRIER		= 1 << 6,
 	IO_U_F_VER_LIST		= 1 << 7,
-	IO_U_F_PRIORITY		= 1 << 8,
+	IO_U_F_HIGH_PRIO	= 1 << 8,
 };
 
 /*
@@ -46,6 +46,11 @@ struct io_u {
 	 */
 	unsigned short numberio;
 
+	/*
+	 * IO priority.
+	 */
+	unsigned short ioprio;
+
 	/*
 	 * Allocated/set buffer and length
 	 */
@@ -188,7 +193,6 @@ static inline enum fio_ddir acct_ddir(struct io_u *io_u)
 	td_flags_clear((td), &(io_u->flags), (val))
 #define io_u_set(td, io_u, val)		\
 	td_flags_set((td), &(io_u)->flags, (val))
-#define io_u_is_prio(io_u)	\
-	(io_u->flags & (unsigned int) IO_U_F_PRIORITY) != 0
+#define io_u_is_high_prio(io_u)	(io_u->flags & IO_U_F_HIGH_PRIO)
 
 #endif
diff --git a/iolog.c b/iolog.c
index 26501b4a..1aeb7a76 100644
--- a/iolog.c
+++ b/iolog.c
@@ -737,6 +737,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 	INIT_FLIST_HEAD(&l->io_logs);
 	l->log_type = p->log_type;
 	l->log_offset = p->log_offset;
+	l->log_prio = p->log_prio;
 	l->log_gz = p->log_gz;
 	l->log_gz_store = p->log_gz_store;
 	l->avg_msec = p->avg_msec;
@@ -769,6 +770,8 @@ void setup_log(struct io_log **log, struct log_params *p,
 
 	if (l->log_offset)
 		l->log_ddir_mask = LOG_OFFSET_SAMPLE_BIT;
+	if (l->log_prio)
+		l->log_ddir_mask |= LOG_PRIO_SAMPLE_BIT;
 
 	INIT_FLIST_HEAD(&l->chunk_list);
 
@@ -895,33 +898,55 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
-	int log_offset;
+	int log_offset, log_prio;
 	uint64_t i, nr_samples;
+	unsigned int prio_val;
+	const char *fmt;
 
 	if (!sample_size)
 		return;
 
 	s = __get_sample(samples, 0, 0);
 	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
+	log_prio = (s->__ddir & LOG_PRIO_SAMPLE_BIT) != 0;
+
+	if (log_offset) {
+		if (log_prio)
+			fmt = "%lu, %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
+		else
+			fmt = "%lu, %" PRId64 ", %u, %llu, %llu, %u\n";
+	} else {
+		if (log_prio)
+			fmt = "%lu, %" PRId64 ", %u, %llu, 0x%04x\n";
+		else
+			fmt = "%lu, %" PRId64 ", %u, %llu, %u\n";
+	}
 
 	nr_samples = sample_size / __log_entry_sz(log_offset);
 
 	for (i = 0; i < nr_samples; i++) {
 		s = __get_sample(samples, log_offset, i);
 
+		if (log_prio)
+			prio_val = s->priority;
+		else
+			prio_val = ioprio_value_is_class_rt(s->priority);
+
 		if (!log_offset) {
-			fprintf(f, "%lu, %" PRId64 ", %u, %llu, %u\n",
-					(unsigned long) s->time,
-					s->data.val,
-					io_sample_ddir(s), (unsigned long long) s->bs, s->priority_bit);
+			fprintf(f, fmt,
+				(unsigned long) s->time,
+				s->data.val,
+				io_sample_ddir(s), (unsigned long long) s->bs,
+				prio_val);
 		} else {
 			struct io_sample_offset *so = (void *) s;
 
-			fprintf(f, "%lu, %" PRId64 ", %u, %llu, %llu, %u\n",
-					(unsigned long) s->time,
-					s->data.val,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					(unsigned long long) so->offset, s->priority_bit);
+			fprintf(f, fmt,
+				(unsigned long) s->time,
+				s->data.val,
+				io_sample_ddir(s), (unsigned long long) s->bs,
+				(unsigned long long) so->offset,
+				prio_val);
 		}
 	}
 }
diff --git a/iolog.h b/iolog.h
index 9e382cc0..7d66b7c4 100644
--- a/iolog.h
+++ b/iolog.h
@@ -42,7 +42,7 @@ struct io_sample {
 	uint64_t time;
 	union io_sample_data data;
 	uint32_t __ddir;
-	uint8_t priority_bit;
+	uint16_t priority;
 	uint64_t bs;
 };
 
@@ -104,6 +104,11 @@ struct io_log {
 	 */
 	unsigned int log_offset;
 
+	/*
+	 * Log I/O priorities
+	 */
+	unsigned int log_prio;
+
 	/*
 	 * Max size of log entries before a chunk is compressed
 	 */
@@ -145,7 +150,13 @@ struct io_log {
  * If the upper bit is set, then we have the offset as well
  */
 #define LOG_OFFSET_SAMPLE_BIT	0x80000000U
-#define io_sample_ddir(io)	((io)->__ddir & ~LOG_OFFSET_SAMPLE_BIT)
+/*
+ * If the bit following the upper bit is set, then we have the priority
+ */
+#define LOG_PRIO_SAMPLE_BIT	0x40000000U
+
+#define LOG_SAMPLE_BITS		(LOG_OFFSET_SAMPLE_BIT | LOG_PRIO_SAMPLE_BIT)
+#define io_sample_ddir(io)	((io)->__ddir & ~LOG_SAMPLE_BITS)
 
 static inline void io_sample_set_ddir(struct io_log *log,
 				      struct io_sample *io,
@@ -262,6 +273,7 @@ struct log_params {
 	int hist_coarseness;
 	int log_type;
 	int log_offset;
+	int log_prio;
 	int log_gz;
 	int log_gz_store;
 	int log_compress;
diff --git a/options.c b/options.c
index 8c2ab7cc..74ac1f3f 100644
--- a/options.c
+++ b/options.c
@@ -73,13 +73,7 @@ static int bs_cmp(const void *p1, const void *p2)
 	return (int) bsp1->perc - (int) bsp2->perc;
 }
 
-struct split {
-	unsigned int nr;
-	unsigned long long val1[ZONESPLIT_MAX];
-	unsigned long long val2[ZONESPLIT_MAX];
-};
-
-static int split_parse_ddir(struct thread_options *o, struct split *split,
+int split_parse_ddir(struct thread_options *o, struct split *split,
 			    char *str, bool absolute, unsigned int max_splits)
 {
 	unsigned long long perc;
@@ -138,8 +132,8 @@ static int split_parse_ddir(struct thread_options *o, struct split *split,
 	return 0;
 }
 
-static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
-			bool data)
+static int bssplit_ddir(struct thread_options *o, void *eo,
+			enum fio_ddir ddir, char *str, bool data)
 {
 	unsigned int i, perc, perc_missing;
 	unsigned long long max_bs, min_bs;
@@ -211,10 +205,8 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
 	return 0;
 }
 
-typedef int (split_parse_fn)(struct thread_options *, enum fio_ddir, char *, bool);
-
-static int str_split_parse(struct thread_data *td, char *str,
-			   split_parse_fn *fn, bool data)
+int str_split_parse(struct thread_data *td, char *str,
+		    split_parse_fn *fn, void *eo, bool data)
 {
 	char *odir, *ddir;
 	int ret = 0;
@@ -223,37 +215,37 @@ static int str_split_parse(struct thread_data *td, char *str,
 	if (odir) {
 		ddir = strchr(odir + 1, ',');
 		if (ddir) {
-			ret = fn(&td->o, DDIR_TRIM, ddir + 1, data);
+			ret = fn(&td->o, eo, DDIR_TRIM, ddir + 1, data);
 			if (!ret)
 				*ddir = '\0';
 		} else {
 			char *op;
 
 			op = strdup(odir + 1);
-			ret = fn(&td->o, DDIR_TRIM, op, data);
+			ret = fn(&td->o, eo, DDIR_TRIM, op, data);
 
 			free(op);
 		}
 		if (!ret)
-			ret = fn(&td->o, DDIR_WRITE, odir + 1, data);
+			ret = fn(&td->o, eo, DDIR_WRITE, odir + 1, data);
 		if (!ret) {
 			*odir = '\0';
-			ret = fn(&td->o, DDIR_READ, str, data);
+			ret = fn(&td->o, eo, DDIR_READ, str, data);
 		}
 	} else {
 		char *op;
 
 		op = strdup(str);
-		ret = fn(&td->o, DDIR_WRITE, op, data);
+		ret = fn(&td->o, eo, DDIR_WRITE, op, data);
 		free(op);
 
 		if (!ret) {
 			op = strdup(str);
-			ret = fn(&td->o, DDIR_TRIM, op, data);
+			ret = fn(&td->o, eo, DDIR_TRIM, op, data);
 			free(op);
 		}
 		if (!ret)
-			ret = fn(&td->o, DDIR_READ, str, data);
+			ret = fn(&td->o, eo, DDIR_READ, str, data);
 	}
 
 	return ret;
@@ -270,7 +262,7 @@ static int str_bssplit_cb(void *data, const char *input)
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	ret = str_split_parse(td, str, bssplit_ddir, false);
+	ret = str_split_parse(td, str, bssplit_ddir, NULL, false);
 
 	if (parse_dryrun()) {
 		int i;
@@ -906,8 +898,8 @@ static int str_sfr_cb(void *data, const char *str)
 }
 #endif
 
-static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
-			   char *str, bool absolute)
+static int zone_split_ddir(struct thread_options *o, void *eo,
+			   enum fio_ddir ddir, char *str, bool absolute)
 {
 	unsigned int i, perc, perc_missing, sperc, sperc_missing;
 	struct split split;
@@ -1012,7 +1004,7 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input,
 	}
 	str += strlen(pre);
 
-	ret = str_split_parse(td, str, zone_split_ddir, absolute);
+	ret = str_split_parse(td, str, zone_split_ddir, NULL, absolute);
 
 	free(p);
 
@@ -4300,6 +4292,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "log_prio",
+		.lname	= "Log priority of IO",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, log_prio),
+		.help	= "Include priority value of IO for each log entry",
+		.def	= "0",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
 #ifdef CONFIG_ZLIB
 	{
 		.name	= "log_compression",
diff --git a/os/os-android.h b/os/os-android.h
index a81cd815..18eb39ce 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -173,16 +173,26 @@ enum {
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
 
-static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+static inline int ioprio_value(int ioprio_class, int ioprio)
 {
 	/*
 	 * If no class is set, assume BE
 	 */
-	if (!ioprio_class)
-		ioprio_class = IOPRIO_CLASS_BE;
+        if (!ioprio_class)
+                ioprio_class = IOPRIO_CLASS_BE;
+
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+}
+
+static inline bool ioprio_value_is_class_rt(unsigned int priority)
+{
+	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
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
index 16ed5258..808f1d02 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -118,16 +118,26 @@ enum {
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
 
-static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+static inline int ioprio_value(int ioprio_class, int ioprio)
 {
 	/*
 	 * If no class is set, assume BE
 	 */
-	if (!ioprio_class)
-		ioprio_class = IOPRIO_CLASS_BE;
+        if (!ioprio_class)
+                ioprio_class = IOPRIO_CLASS_BE;
+
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+}
+
+static inline bool ioprio_value_is_class_rt(unsigned int priority)
+{
+	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
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
index 17daf91d..827b61e9 100644
--- a/os/os.h
+++ b/os/os.h
@@ -117,7 +117,11 @@ static inline int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu_index)
 extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
+#ifndef FIO_HAVE_IOPRIO_CLASS
+#define ioprio_value_is_class_rt(prio)	(false)
+#endif
 #ifndef FIO_HAVE_IOPRIO
+#define ioprio_value(prioclass, prio)	(0)
 #define ioprio_set(which, who, prioclass, prio)	(0)
 #endif
 
diff --git a/server.h b/server.h
index daed057a..3ff32d9a 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 92,
+	FIO_SERVER_VER			= 93,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -193,6 +193,7 @@ struct cmd_iolog_pdu {
 	uint32_t log_type;
 	uint32_t compressed;
 	uint32_t log_offset;
+	uint32_t log_prio;
 	uint32_t log_hist_coarseness;
 	uint8_t name[FIO_NET_NAME_MAX];
 	struct io_sample samples[0];
diff --git a/stat.c b/stat.c
index a8a96c85..99275620 100644
--- a/stat.c
+++ b/stat.c
@@ -2860,7 +2860,8 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 
 static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 			     enum fio_ddir ddir, unsigned long long bs,
-			     unsigned long t, uint64_t offset, uint8_t priority_bit)
+			     unsigned long t, uint64_t offset,
+			     unsigned int priority)
 {
 	struct io_logs *cur_log;
 
@@ -2879,7 +2880,7 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 		s->time = t + (iolog->td ? iolog->td->unix_epoch : 0);
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
-		s->priority_bit = priority_bit;
+		s->priority = priority;
 
 		if (iolog->log_offset) {
 			struct io_sample_offset *so = (void *) s;
@@ -2956,7 +2957,7 @@ void reset_io_stats(struct thread_data *td)
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
-			      unsigned long elapsed, bool log_max, uint8_t priority_bit)
+			      unsigned long elapsed, bool log_max)
 {
 	/*
 	 * Note an entry in the log. Use the mean from the logged samples,
@@ -2971,26 +2972,26 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 		else
 			data.val = iolog->avg_window[ddir].mean.u.f + 0.50;
 
-		__add_log_sample(iolog, data, ddir, 0, elapsed, 0, priority_bit);
+		__add_log_sample(iolog, data, ddir, 0, elapsed, 0, 0);
 	}
 
 	reset_io_stat(&iolog->avg_window[ddir]);
 }
 
 static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
-			     bool log_max, uint8_t priority_bit)
+			     bool log_max)
 {
 	int ddir;
 
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-		__add_stat_to_log(iolog, ddir, elapsed, log_max, priority_bit);
+		__add_stat_to_log(iolog, ddir, elapsed, log_max);
 }
 
 static unsigned long add_log_sample(struct thread_data *td,
 				    struct io_log *iolog,
 				    union io_sample_data data,
 				    enum fio_ddir ddir, unsigned long long bs,
-				    uint64_t offset, uint8_t priority_bit)
+				    uint64_t offset, unsigned int ioprio)
 {
 	unsigned long elapsed, this_window;
 
@@ -3003,7 +3004,8 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * If no time averaging, just add the log sample.
 	 */
 	if (!iolog->avg_msec) {
-		__add_log_sample(iolog, data, ddir, bs, elapsed, offset, priority_bit);
+		__add_log_sample(iolog, data, ddir, bs, elapsed, offset,
+				 ioprio);
 		return 0;
 	}
 
@@ -3027,7 +3029,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 			return diff;
 	}
 
-	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0, priority_bit);
+	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0);
 
 	iolog->avg_last[ddir] = elapsed - (elapsed % iolog->avg_msec);
 
@@ -3041,19 +3043,19 @@ void finalize_logs(struct thread_data *td, bool unit_logs)
 	elapsed = mtime_since_now(&td->epoch);
 
 	if (td->clat_log && unit_logs)
-		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
 	if (td->slat_log && unit_logs)
-		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
 	if (td->lat_log && unit_logs)
-		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
 	if (td->bw_log && (unit_logs == per_unit_log(td->bw_log)))
-		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
 	if (td->iops_log && (unit_logs == per_unit_log(td->iops_log)))
-		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0, 0);
+		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
 }
 
-void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned long long bs,
-					uint8_t priority_bit)
+void add_agg_sample(union io_sample_data data, enum fio_ddir ddir,
+		    unsigned long long bs)
 {
 	struct io_log *iolog;
 
@@ -3061,7 +3063,7 @@ void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned long
 		return;
 
 	iolog = agg_io_log[ddir];
-	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0, priority_bit);
+	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0, 0);
 }
 
 void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
@@ -3083,14 +3085,14 @@ static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
 }
 
 static void add_lat_percentile_sample(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir, uint8_t priority_bit,
-				enum fio_lat lat)
+				unsigned long long nsec, enum fio_ddir ddir,
+				bool high_prio, enum fio_lat lat)
 {
 	unsigned int idx = plat_val_to_idx(nsec);
 
 	add_lat_percentile_sample_noprio(ts, nsec, ddir, lat);
 
-	if (!priority_bit)
+	if (!high_prio)
 		ts->io_u_plat_low_prio[ddir][idx]++;
 	else
 		ts->io_u_plat_high_prio[ddir][idx]++;
@@ -3098,7 +3100,7 @@ static void add_lat_percentile_sample(struct thread_stat *ts,
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long long nsec, unsigned long long bs,
-		     uint64_t offset, uint8_t priority_bit)
+		     uint64_t offset, unsigned int ioprio, bool high_prio)
 {
 	const bool needs_lock = td_async_processing(td);
 	unsigned long elapsed, this_window;
@@ -3111,7 +3113,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
 	if (!ts->lat_percentiles) {
-		if (priority_bit)
+		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
 			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
@@ -3119,13 +3121,13 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->clat_log)
 		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
-			       offset, priority_bit);
+			       offset, ioprio);
 
 	if (ts->clat_percentiles) {
 		if (ts->lat_percentiles)
 			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
 		else
-			add_lat_percentile_sample(ts, nsec, ddir, priority_bit, FIO_CLAT);
+			add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_CLAT);
 	}
 
 	if (iolog && iolog->hist_msec) {
@@ -3154,7 +3156,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 				FIO_IO_U_PLAT_NR * sizeof(uint64_t));
 			flist_add(&dst->list, &hw->list);
 			__add_log_sample(iolog, sample_plat(dst), ddir, bs,
-						elapsed, offset, priority_bit);
+					 elapsed, offset, ioprio);
 
 			/*
 			 * Update the last time we recorded as being now, minus
@@ -3171,8 +3173,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-			unsigned long long nsec, unsigned long long bs, uint64_t offset,
-			uint8_t priority_bit)
+		     unsigned long long nsec, unsigned long long bs,
+		     uint64_t offset, unsigned int ioprio)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -3186,8 +3188,8 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->slat_stat[ddir], nsec);
 
 	if (td->slat_log)
-		add_log_sample(td, td->slat_log, sample_val(nsec), ddir, bs, offset,
-			priority_bit);
+		add_log_sample(td, td->slat_log, sample_val(nsec), ddir, bs,
+			       offset, ioprio);
 
 	if (ts->slat_percentiles)
 		add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_SLAT);
@@ -3198,7 +3200,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		    unsigned long long nsec, unsigned long long bs,
-		    uint64_t offset, uint8_t priority_bit)
+		    uint64_t offset, unsigned int ioprio, bool high_prio)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -3213,11 +3215,11 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->lat_log)
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
-			       offset, priority_bit);
+			       offset, ioprio);
 
 	if (ts->lat_percentiles) {
-		add_lat_percentile_sample(ts, nsec, ddir, priority_bit, FIO_LAT);
-		if (priority_bit)
+		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
+		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
 			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
@@ -3246,7 +3248,7 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 
 	if (td->bw_log)
 		add_log_sample(td, td->bw_log, sample_val(rate), io_u->ddir,
-			       bytes, io_u->offset, io_u_is_prio(io_u));
+			       bytes, io_u->offset, io_u->ioprio);
 
 	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
 
@@ -3300,7 +3302,8 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			next = add_log_sample(td, log, sample_val(rate), ddir, bs, 0, 0);
+			next = add_log_sample(td, log, sample_val(rate), ddir,
+					      bs, 0, 0);
 			next_log = min(next_log, next);
 		}
 
@@ -3340,7 +3343,7 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 
 	if (td->iops_log)
 		add_log_sample(td, td->iops_log, sample_val(1), io_u->ddir,
-			       bytes, io_u->offset, io_u_is_prio(io_u));
+			       bytes, io_u->offset, io_u->ioprio);
 
 	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
 
diff --git a/stat.h b/stat.h
index d08d4dc0..a06237e7 100644
--- a/stat.h
+++ b/stat.h
@@ -341,13 +341,12 @@ extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
 
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t, uint8_t);
+			   unsigned long long, uint64_t, unsigned int, bool);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t, uint8_t);
+			    unsigned long long, uint64_t, unsigned int, bool);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t, uint8_t);
-extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long bs,
-				uint8_t priority_bit);
+				unsigned long long, uint64_t, unsigned int);
+extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long);
 extern void add_iops_sample(struct thread_data *, struct io_u *,
 				unsigned int);
 extern void add_bw_sample(struct thread_data *, struct io_u *,
diff --git a/thread_options.h b/thread_options.h
index 4b4ecfe1..9990ab9b 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -44,6 +44,12 @@ enum dedupe_mode {
 #define BSSPLIT_MAX	64
 #define ZONESPLIT_MAX	256
 
+struct split {
+	unsigned int nr;
+	unsigned long long val1[ZONESPLIT_MAX];
+	unsigned long long val2[ZONESPLIT_MAX];
+};
+
 struct bssplit {
 	uint64_t bs;
 	uint32_t perc;
@@ -368,6 +374,8 @@ struct thread_options {
 	unsigned int ignore_zone_limits;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
+
+	unsigned int log_prio;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -671,6 +679,8 @@ struct thread_options_pack {
 	uint32_t zone_mode;
 	int32_t max_open_zones;
 	uint32_t ignore_zone_limits;
+
+	uint32_t log_prio;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
@@ -678,4 +688,13 @@ extern void convert_thread_options_to_net(struct thread_options_pack *top, struc
 extern int fio_test_cconv(struct thread_options *);
 extern void options_default_fill(struct thread_options *o);
 
+typedef int (split_parse_fn)(struct thread_options *, void *,
+			     enum fio_ddir, char *, bool);
+
+extern int str_split_parse(struct thread_data *td, char *str,
+			   split_parse_fn *fn, void *eo, bool data);
+
+extern int split_parse_ddir(struct thread_options *o, struct split *split,
+			    char *str, bool absolute, unsigned int max_splits);
+
 #endif
diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 5becc4d9..cfd2fd8e 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -51,10 +51,10 @@ specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_ke
 specific_options=ime_psync  ime_psyncv
 
 [ioengine_io_uring]
-specific_options=hipri  cmdprio_percentage  cmdprio_percentage  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
+specific_options=hipri  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
 
 [ioengine_libaio]
-specific_options=userspace_reap  cmdprio_percentage  cmdprio_percentage  nowait
+specific_options=userspace_reap  cmdprio_percentage  cmdprio_class  cmdprio  cmdprio_bssplit  nowait
 
 [ioengine_libcufile]
 specific_options=gpu_dev_ids  cuda_io
diff --git a/tools/fiograph/fiograph.py b/tools/fiograph/fiograph.py
index 7695c964..b5669a2d 100755
--- a/tools/fiograph/fiograph.py
+++ b/tools/fiograph/fiograph.py
@@ -292,9 +292,11 @@ def setup_commandline():
 def main():
     global config_file
     args = setup_commandline()
-    output_file = args.file
     if args.output is None:
+        output_file = args.file
         output_file = output_file.replace('.fio', '')
+    else:
+        output_file = args.output
     config_file = configparser.RawConfigParser(allow_no_value=True)
     config_file.read(args.config)
     fio_to_graphviz(args.file, args.format).render(output_file, view=args.view)

