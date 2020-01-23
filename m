Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60666 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAWNAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Jan 2020 08:00:18 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iuc5p-0006w9-SS
        for fio@vger.kernel.org; Thu, 23 Jan 2020 13:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200123130002.793151BC0CAF@kernel.dk>
Date: Thu, 23 Jan 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d9b7596a1fad5adf7f6731d067e1513c56eabe96:

  Merge branch 'master' of https://github.com/bvanassche/fio (2020-01-18 09:35:25 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4ee9c375b64de236356cc97843d84978edeba491:

  stat: ensure we align correctly (2020-01-22 19:53:14 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'priorityQueuing' of https://github.com/Seagate/fio
      stat: ensure we align correctly

Phillip Chen (2):
      Whitespace standardization
      Per-command priority: Priority logging and libaio/io_uring cmdprio_percentage

Su, Friendy (1):
      engines: add engine for file stat

 HOWTO                          |  43 +++++---
 Makefile                       |   2 +-
 client.c                       |  10 +-
 engines/filecreate.c           |   2 +-
 engines/filestat.c             | 116 +++++++++++++++++++++
 engines/io_uring.c             |  47 +++++++++
 engines/libaio.c               |  54 ++++++++++
 eta.c                          |   6 +-
 examples/filestat-ioengine.fio |  19 ++++
 fio.1                          |  32 ++++--
 fio.h                          |   4 +-
 init.c                         |   3 +
 io_u.c                         |   8 +-
 io_u.h                         |   3 +
 ioengines.c                    |   1 +
 iolog.c                        |   8 +-
 iolog.h                        |   1 +
 server.c                       |  13 ++-
 server.h                       |   2 +-
 stat.c                         | 229 +++++++++++++++++++++++++++++++++++------
 stat.h                         |  14 ++-
 21 files changed, 541 insertions(+), 76 deletions(-)
 create mode 100644 engines/filestat.c
 create mode 100644 examples/filestat-ioengine.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 41d32c04..0a366168 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1996,6 +1996,11 @@ I/O engine
 			set  `filesize` so that all the accounting still occurs, but no
 			actual I/O will be done other than creating the file.
 
+		**filestat**
+			Simply do stat() and do no I/O to the file. You need to set 'filesize'
+			and 'nrfiles', so that files will be created.
+			This engine is to measure file lookup and meta data access.
+
 		**libpmem**
 			Read and write using mmap I/O to a file on a filesystem
 			mounted with DAX on a persistent memory device through the PMDK
@@ -2029,21 +2034,29 @@ In addition, there are some parameters which are only valid when a specific
 with the caveat that when used on the command line, they must come after the
 :option:`ioengine` that defines them is selected.
 
-.. option:: hipri : [io_uring]
+.. option:: cmdprio_percentage=int : [io_uring] [libaio]
 
-	If this option is set, fio will attempt to use polled IO completions.
-	Normal IO completions generate interrupts to signal the completion of
-	IO, polled completions do not. Hence they are require active reaping
-	by the application. The benefits are more efficient IO for high IOPS
-	scenarios, and lower latencies for low queue depth IO.
+    Set the percentage of I/O that will be issued with higher priority by setting
+    the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentage``.
+    This option cannot be used with the `prio` or `prioclass` options. For this
+    option to set the priority bit properly, NCQ priority must be supported and
+    enabled and :option:`direct`\=1 option must be used.
 
 .. option:: fixedbufs : [io_uring]
 
-	If fio is asked to do direct IO, then Linux will map pages for each
-	IO call, and release them when IO is done. If this option is set, the
-	pages are pre-mapped before IO is started. This eliminates the need to
-	map and release for each IO. This is more efficient, and reduces the
-	IO latency as well.
+    If fio is asked to do direct IO, then Linux will map pages for each
+    IO call, and release them when IO is done. If this option is set, the
+    pages are pre-mapped before IO is started. This eliminates the need to
+    map and release for each IO. This is more efficient, and reduces the
+    IO latency as well.
+
+.. option:: hipri : [io_uring]
+
+    If this option is set, fio will attempt to use polled IO completions.
+    Normal IO completions generate interrupts to signal the completion of
+    IO, polled completions do not. Hence they are require active reaping
+    by the application. The benefits are more efficient IO for high IOPS
+    scenarios, and lower latencies for low queue depth IO.
 
 .. option:: registerfiles : [io_uring]
 
@@ -2687,11 +2700,15 @@ Threads, processes and job synchronization
 	Set the I/O priority value of this job. Linux limits us to a positive value
 	between 0 and 7, with 0 being the highest.  See man
 	:manpage:`ionice(1)`. Refer to an appropriate manpage for other operating
-	systems since meaning of priority may differ.
+	systems since meaning of priority may differ. For per-command priority
+	setting, see I/O engine specific `cmdprio_percentage` and `hipri_percentage`
+	options.
 
 .. option:: prioclass=int
 
-	Set the I/O priority class. See man :manpage:`ionice(1)`.
+	Set the I/O priority class. See man :manpage:`ionice(1)`. For per-command
+	priority setting, see I/O engine specific `cmdprio_percentage` and
+	`hipri_percentage` options.
 
 .. option:: cpus_allowed=str
 
diff --git a/Makefile b/Makefile
index 3c5e0f5b..027b62bc 100644
--- a/Makefile
+++ b/Makefile
@@ -45,7 +45,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c engines/filecreate.c \
+		engines/ftruncate.c engines/filecreate.c engines/filestat.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/client.c b/client.c
index 93bca5df..4aed39e7 100644
--- a/client.c
+++ b/client.c
@@ -1032,6 +1032,14 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->nr_block_infos	= le64_to_cpu(src->nr_block_infos);
 	for (i = 0; i < dst->nr_block_infos; i++)
 		dst->block_infos[i] = le32_to_cpu(src->block_infos[i]);
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
+			dst->io_u_plat_high_prio[i][j] = le64_to_cpu(src->io_u_plat_high_prio[i][j]);
+			dst->io_u_plat_prio[i][j] = le64_to_cpu(src->io_u_plat_prio[i][j]);
+		}
+		convert_io_stat(&dst->clat_high_prio_stat[i], &src->clat_high_prio_stat[i]);
+		convert_io_stat(&dst->clat_prio_stat[i], &src->clat_prio_stat[i]);
+	}
 
 	dst->ss_dur		= le64_to_cpu(src->ss_dur);
 	dst->ss_state		= le32_to_cpu(src->ss_state);
@@ -1693,7 +1701,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 
 		s->time		= le64_to_cpu(s->time);
 		s->data.val	= le64_to_cpu(s->data.val);
-		s->__ddir	= le32_to_cpu(s->__ddir);
+		s->__ddir	= __le32_to_cpu(s->__ddir);
 		s->bs		= le64_to_cpu(s->bs);
 
 		if (ret->log_offset) {
diff --git a/engines/filecreate.c b/engines/filecreate.c
index 39a29502..5fec8544 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -49,7 +49,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 		uint64_t nsec;
 
 		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
 	}
 
 	return 0;
diff --git a/engines/filestat.c b/engines/filestat.c
new file mode 100644
index 00000000..79525934
--- /dev/null
+++ b/engines/filestat.c
@@ -0,0 +1,116 @@
+/*
+ * filestat engine
+ *
+ * IO engine that doesn't do any IO, just stat files and tracks the latency
+ * of the file stat.
+ */
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include "../fio.h"
+
+struct fc_data {
+	enum fio_ddir stat_ddir;
+};
+
+static int stat_file(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start;
+	int do_lat = !td->o.disable_lat;
+	struct stat statbuf;
+	int ret;
+
+	dprint(FD_FILE, "fd stat %s\n", f->file_name);
+
+	if (f->filetype != FIO_TYPE_FILE) {
+		log_err("fio: only files are supported\n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+	if (do_lat)
+		fio_gettime(&start, NULL);
+
+	ret = stat(f->file_name, &statbuf);
+
+	if (ret == -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e = errno;
+
+		snprintf(buf, sizeof(buf), "stat(%s)", f->file_name);
+		td_verror(td, e, buf);
+		return 1;
+	}
+
+	if (do_lat) {
+		struct fc_data *data = td->io_ops_data;
+		uint64_t nsec;
+
+		nsec = ntime_since_now(&start);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
+	}
+
+	return 0;
+}
+
+static enum fio_q_status queue_io(struct thread_data *td, struct io_u fio_unused *io_u)
+{
+	return FIO_Q_COMPLETED;
+}
+
+static int init(struct thread_data *td)
+{
+	struct fc_data *data;
+
+	data = calloc(1, sizeof(*data));
+
+	if (td_read(td))
+		data->stat_ddir = DDIR_READ;
+	else if (td_write(td))
+		data->stat_ddir = DDIR_WRITE;
+
+	td->io_ops_data = data;
+	return 0;
+}
+
+static void cleanup(struct thread_data *td)
+{
+	struct fc_data *data = td->io_ops_data;
+
+	free(data);
+}
+
+static int stat_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	/* do nothing because file not opened */
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "filestat",
+	.version	= FIO_IOOPS_VERSION,
+	.init		= init,
+	.cleanup	= cleanup,
+	.queue		= queue_io,
+	.invalidate	= stat_invalidate,
+	.get_file_size	= generic_get_file_size,
+	.open_file	= stat_file,
+	.flags		=  FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+static void fio_init fio_filestat_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_filestat_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 329f2f07..f1ffc712 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -70,6 +70,7 @@ struct ioring_data {
 struct ioring_options {
 	void *pad;
 	unsigned int hipri;
+	unsigned int cmdprio_percentage;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
 	unsigned int sqpoll_thread;
@@ -108,6 +109,26 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+#ifdef FIO_HAVE_IOPRIO_CLASS
+	{
+		.name	= "cmdprio_percentage",
+		.lname	= "high priority percentage",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, cmdprio_percentage),
+		.minval	= 1,
+		.maxval	= 100,
+		.help	= "Send high priority I/O this percentage of the time",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+#else
+	{
+		.name	= "cmdprio_percentage",
+		.lname	= "high priority percentage",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
+#endif
 	{
 		.name	= "fixedbufs",
 		.lname	= "Fixed (pre-mapped) IO buffers",
@@ -313,11 +334,23 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 	return r < 0 ? r : events;
 }
 
+static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_options *o = td->eo;
+	struct ioring_data *ld = td->io_ops_data;
+	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
+		ld->sqes[io_u->index].ioprio = IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
+		io_u->flags |= IO_U_F_PRIORITY;
+	}
+	return;
+}
+
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct io_sq_ring *ring = &ld->sq_ring;
+	struct ioring_options *o = td->eo;
 	unsigned tail, next_tail;
 
 	fio_ro_check(td, io_u);
@@ -343,6 +376,8 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 
 	/* ensure sqe stores are ordered with tail update */
 	write_barrier();
+	if (o->cmdprio_percentage)
+		fio_ioring_prio_prep(td, io_u);
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	*ring->tail = next_tail;
 	write_barrier();
@@ -618,6 +653,7 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
+	struct thread_options *to = &td->o;
 
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
@@ -640,6 +676,17 @@ static int fio_ioring_init(struct thread_data *td)
 	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
 
 	td->io_ops_data = ld;
+
+	/*
+	 * Check for option conflicts
+	 */
+	if ((fio_option_is_set(to, ioprio) || fio_option_is_set(to, ioprio_class)) &&
+			o->cmdprio_percentage != 0) {
+		log_err("%s: cmdprio_percentage option and mutually exclusive "
+				"prio or prioclass option is set, exiting\n", to->name);
+		td_verror(td, EINVAL, "fio_io_uring_init");
+		return 1;
+	}
 	return 0;
 }
 
diff --git a/engines/libaio.c b/engines/libaio.c
index b047b746..299798ae 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -16,7 +16,13 @@
 #include "../optgroup.h"
 #include "../lib/memalign.h"
 
+/* Should be defined in newest aio_abi.h */
+#ifndef IOCB_FLAG_IOPRIO
+#define IOCB_FLAG_IOPRIO    (1 << 1)
+#endif
+
 static int fio_libaio_commit(struct thread_data *td);
+static int fio_libaio_init(struct thread_data *td);
 
 struct libaio_data {
 	io_context_t aio_ctx;
@@ -44,6 +50,7 @@ struct libaio_data {
 struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
+	unsigned int cmdprio_percentage;
 };
 
 static struct fio_option options[] = {
@@ -56,6 +63,26 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+#ifdef FIO_HAVE_IOPRIO_CLASS
+	{
+		.name	= "cmdprio_percentage",
+		.lname	= "high priority percentage",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct libaio_options, cmdprio_percentage),
+		.minval	= 1,
+		.maxval	= 100,
+		.help	= "Send high priority I/O this percentage of the time",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+#else
+	{
+		.name	= "cmdprio_percentage",
+		.lname	= "high priority percentage",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
+#endif
 	{
 		.name	= NULL,
 	},
@@ -85,6 +112,17 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 	return 0;
 }
 
+static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct libaio_options *o = td->eo;
+	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
+		io_u->iocb.aio_reqprio = IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
+		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
+		io_u->flags |= IO_U_F_PRIORITY;
+	}
+	return;
+}
+
 static struct io_u *fio_libaio_event(struct thread_data *td, int event)
 {
 	struct libaio_data *ld = td->io_ops_data;
@@ -188,6 +226,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld = td->io_ops_data;
+	struct libaio_options *o = td->eo;
 
 	fio_ro_check(td, io_u);
 
@@ -218,6 +257,9 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
+	if (o->cmdprio_percentage)
+		fio_libaio_prio_prep(td, io_u);
+
 	ld->iocbs[ld->head] = &io_u->iocb;
 	ld->io_us[ld->head] = io_u;
 	ring_inc(ld, &ld->head, 1);
@@ -358,6 +400,8 @@ static int fio_libaio_post_init(struct thread_data *td)
 static int fio_libaio_init(struct thread_data *td)
 {
 	struct libaio_data *ld;
+	struct thread_options *to = &td->o;
+	struct libaio_options *o = td->eo;
 
 	ld = calloc(1, sizeof(*ld));
 
@@ -368,6 +412,16 @@ static int fio_libaio_init(struct thread_data *td)
 	ld->io_us = calloc(ld->entries, sizeof(struct io_u *));
 
 	td->io_ops_data = ld;
+	/*
+	 * Check for option conflicts
+	 */
+	if ((fio_option_is_set(to, ioprio) || fio_option_is_set(to, ioprio_class)) &&
+			o->cmdprio_percentage != 0) {
+		log_err("%s: cmdprio_percentage option and mutually exclusive "
+				"prio or prioclass option is set, exiting\n", to->name);
+		td_verror(td, EINVAL, "fio_libaio_init");
+		return 1;
+	}
 	return 0;
 }
 
diff --git a/eta.c b/eta.c
index 9950ef30..13f61ba4 100644
--- a/eta.c
+++ b/eta.c
@@ -509,9 +509,9 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
 				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
-		add_agg_sample(sample_val(je->rate[DDIR_READ]), DDIR_READ, 0);
-		add_agg_sample(sample_val(je->rate[DDIR_WRITE]), DDIR_WRITE, 0);
-		add_agg_sample(sample_val(je->rate[DDIR_TRIM]), DDIR_TRIM, 0);
+		add_agg_sample(sample_val(je->rate[DDIR_READ]), DDIR_READ, 0, 0);
+		add_agg_sample(sample_val(je->rate[DDIR_WRITE]), DDIR_WRITE, 0, 0);
+		add_agg_sample(sample_val(je->rate[DDIR_TRIM]), DDIR_TRIM, 0, 0);
 	}
 
 	disp_time = mtime_since(&disp_prev_time, &now);
diff --git a/examples/filestat-ioengine.fio b/examples/filestat-ioengine.fio
new file mode 100644
index 00000000..932fced8
--- /dev/null
+++ b/examples/filestat-ioengine.fio
@@ -0,0 +1,19 @@
+# Example filestat job
+
+# 'filestat' engine only do 'stat(filename)', file will not be open().
+# 'filesize' must be set, then files will be created at setup stage.
+
+[global]
+ioengine=filestat
+numjobs=1
+filesize=4k
+nrfiles=200
+thread
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
+
diff --git a/fio.1 b/fio.1
index cf5dd853..05896e61 100644
--- a/fio.1
+++ b/fio.1
@@ -1760,6 +1760,11 @@ Simply create the files and do no I/O to them.  You still need to set
 \fBfilesize\fR so that all the accounting still occurs, but no actual I/O will be
 done other than creating the file.
 .TP
+.B filestat
+Simply do stat() and do no I/O to the file. You need to set 'filesize'
+and 'nrfiles', so that files will be created.
+This engine is to measure file lookup and meta data access.
+.TP
 .B libpmem
 Read and write using mmap I/O to a file on a filesystem
 mounted with DAX on a persistent memory device through the PMDK
@@ -1790,12 +1795,12 @@ In addition, there are some parameters which are only valid when a specific
 with the caveat that when used on the command line, they must come after the
 \fBioengine\fR that defines them is selected.
 .TP
-.BI (io_uring)hipri
-If this option is set, fio will attempt to use polled IO completions. Normal IO
-completions generate interrupts to signal the completion of IO, polled
-completions do not. Hence they are require active reaping by the application.
-The benefits are more efficient IO for high IOPS scenarios, and lower latencies
-for low queue depth IO.
+.BI (io_uring, libaio)cmdprio_percentage \fR=\fPint
+Set the percentage of I/O that will be issued with higher priority by setting
+the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentage``.
+This option cannot be used with the `prio` or `prioclass` options. For this
+option to set the priority bit properly, NCQ priority must be supported and
+enabled and `direct=1' option must be used.
 .TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO call, and
@@ -1803,6 +1808,13 @@ release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
+.BI (io_uring)hipri
+If this option is set, fio will attempt to use polled IO completions. Normal IO
+completions generate interrupts to signal the completion of IO, polled
+completions do not. Hence they are require active reaping by the application.
+The benefits are more efficient IO for high IOPS scenarios, and lower latencies
+for low queue depth IO.
+.TP
 .BI (io_uring)registerfiles
 With this option, fio registers the set of files being used with the kernel.
 This avoids the overhead of managing file counts in the kernel, making the
@@ -2381,10 +2393,14 @@ priority class.
 Set the I/O priority value of this job. Linux limits us to a positive value
 between 0 and 7, with 0 being the highest. See man
 \fBionice\fR\|(1). Refer to an appropriate manpage for other operating
-systems since meaning of priority may differ.
+systems since meaning of priority may differ. For per-command priority
+setting, see I/O engine specific `cmdprio_percentage` and `hipri_percentage`
+options.
 .TP
 .BI prioclass \fR=\fPint
-Set the I/O priority class. See man \fBionice\fR\|(1).
+Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
+priority setting, see I/O engine specific `cmdprio_percentage` and `hipri_percent`
+options.
 .TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
diff --git a/fio.h b/fio.h
index 6a5ead4d..2a9eef45 100644
--- a/fio.h
+++ b/fio.h
@@ -139,6 +139,7 @@ enum {
 	FIO_RAND_ZONE_OFF,
 	FIO_RAND_POISSON2_OFF,
 	FIO_RAND_POISSON3_OFF,
+	FIO_RAND_PRIO_CMDS,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -258,6 +259,7 @@ struct thread_data {
 	struct frand_state buf_state_prev;
 	struct frand_state dedupe_state;
 	struct frand_state zone_state;
+	struct frand_state prio_state;
 
 	struct zone_split_index **zone_state_index;
 
@@ -460,7 +462,7 @@ struct thread_data {
 	CUdevice  cu_dev;
 	CUcontext cu_ctx;
 	CUdeviceptr dev_mem_ptr;
-#endif	
+#endif
 
 };
 
diff --git a/init.c b/init.c
index 2f64726c..dca44bca 100644
--- a/init.c
+++ b/init.c
@@ -1042,6 +1042,7 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	init_rand_seed(&td->poisson_state[2], td->rand_seeds[FIO_RAND_POISSON3_OFF], 0);
 	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], false);
 	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], false);
+	init_rand_seed(&td->prio_state, td->rand_seeds[FIO_RAND_PRIO_CMDS], false);
 
 	if (!td_random(td))
 		return;
@@ -1518,6 +1519,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td->ts.lat_stat[i].min_val = ULONG_MAX;
 		td->ts.bw_stat[i].min_val = ULONG_MAX;
 		td->ts.iops_stat[i].min_val = ULONG_MAX;
+		td->ts.clat_high_prio_stat[i].min_val = ULONG_MAX;
+		td->ts.clat_prio_stat[i].min_val = ULONG_MAX;
 	}
 	td->ts.sync_stat.min_val = ULONG_MAX;
 	td->ddir_seq_nr = o->ddir_seq_nr;
diff --git a/io_u.c b/io_u.c
index 03f5c21f..bcb893c5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1541,7 +1541,7 @@ again:
 		assert(io_u->flags & IO_U_F_FREE);
 		io_u_clear(td, io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
 				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
-				 IO_U_F_VER_LIST);
+				 IO_U_F_VER_LIST | IO_U_F_PRIORITY);
 
 		io_u->error = 0;
 		io_u->acct_ddir = -1;
@@ -1830,7 +1830,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		unsigned long long tnsec;
 
 		tnsec = ntime_since(&io_u->start_time, &icd->time);
-		add_lat_sample(td, idx, tnsec, bytes, io_u->offset);
+		add_lat_sample(td, idx, tnsec, bytes, io_u->offset, io_u_is_prio(io_u));
 
 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops = &td->prof_io_ops;
@@ -1849,7 +1849,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 	if (ddir_rw(idx)) {
 		if (!td->o.disable_clat) {
-			add_clat_sample(td, idx, llnsec, bytes, io_u->offset);
+			add_clat_sample(td, idx, llnsec, bytes, io_u->offset, io_u_is_prio(io_u));
 			io_u_mark_latency(td, llnsec);
 		}
 
@@ -2091,7 +2091,7 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 			td = td->parent;
 
 		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen,
-				io_u->offset);
+				io_u->offset, io_u_is_prio(io_u));
 	}
 }
 
diff --git a/io_u.h b/io_u.h
index e75993bd..0f63cdd0 100644
--- a/io_u.h
+++ b/io_u.h
@@ -24,6 +24,7 @@ enum {
 	IO_U_F_TRIMMED		= 1 << 5,
 	IO_U_F_BARRIER		= 1 << 6,
 	IO_U_F_VER_LIST		= 1 << 7,
+	IO_U_F_PRIORITY		= 1 << 8,
 };
 
 /*
@@ -193,5 +194,7 @@ static inline enum fio_ddir acct_ddir(struct io_u *io_u)
 	td_flags_clear((td), &(io_u->flags), (val))
 #define io_u_set(td, io_u, val)		\
 	td_flags_set((td), &(io_u)->flags, (val))
+#define io_u_is_prio(io_u)	\
+	(io_u->flags & (unsigned int) IO_U_F_PRIORITY) != 0
 
 #endif
diff --git a/ioengines.c b/ioengines.c
index b9200ba9..2c7a0df9 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -318,6 +318,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 					sizeof(io_u->issue_time));
 	}
 
+
 	if (ddir_rw(ddir)) {
 		if (!(io_u->flags & IO_U_F_VER_LIST)) {
 			td->io_issues[ddir]++;
diff --git a/iolog.c b/iolog.c
index b72dcf97..917a446c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -896,18 +896,18 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 		s = __get_sample(samples, log_offset, i);
 
 		if (!log_offset) {
-			fprintf(f, "%lu, %" PRId64 ", %u, %llu\n",
+			fprintf(f, "%lu, %" PRId64 ", %u, %llu, %u\n",
 					(unsigned long) s->time,
 					s->data.val,
-					io_sample_ddir(s), (unsigned long long) s->bs);
+					io_sample_ddir(s), (unsigned long long) s->bs, s->priority_bit);
 		} else {
 			struct io_sample_offset *so = (void *) s;
 
-			fprintf(f, "%lu, %" PRId64 ", %u, %llu, %llu\n",
+			fprintf(f, "%lu, %" PRId64 ", %u, %llu, %llu, %u\n",
 					(unsigned long) s->time,
 					s->data.val,
 					io_sample_ddir(s), (unsigned long long) s->bs,
-					(unsigned long long) so->offset);
+					(unsigned long long) so->offset, s->priority_bit);
 		}
 	}
 }
diff --git a/iolog.h b/iolog.h
index 17be908f..981081f9 100644
--- a/iolog.h
+++ b/iolog.h
@@ -42,6 +42,7 @@ struct io_sample {
 	uint64_t time;
 	union io_sample_data data;
 	uint32_t __ddir;
+	uint8_t priority_bit;
 	uint64_t bs;
 };
 
diff --git a/server.c b/server.c
index 1a070e56..a5af5e74 100644
--- a/server.c
+++ b/server.c
@@ -1262,7 +1262,7 @@ static int handle_connection(struct sk_out *sk_out)
 	_exit(ret);
 }
 
-/* get the address on this host bound by the input socket, 
+/* get the address on this host bound by the input socket,
  * whether it is ipv6 or ipv4 */
 
 static int get_my_addr_str(int sk)
@@ -1574,6 +1574,15 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.cachehit		= cpu_to_le64(ts->cachehit);
 	p.ts.cachemiss		= cpu_to_le64(ts->cachemiss);
 
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
+			p.ts.io_u_plat_high_prio[i][j] = cpu_to_le64(ts->io_u_plat_high_prio[i][j]);
+			p.ts.io_u_plat_prio[i][j] = cpu_to_le64(ts->io_u_plat_prio[i][j]);
+		}
+		convert_io_stat(&p.ts.clat_high_prio_stat[i], &ts->clat_high_prio_stat[i]);
+		convert_io_stat(&p.ts.clat_prio_stat[i], &ts->clat_prio_stat[i]);
+	}
+
 	convert_gs(&p.rs, rs);
 
 	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
@@ -1998,7 +2007,7 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 
 			s->time		= cpu_to_le64(s->time);
 			s->data.val	= cpu_to_le64(s->data.val);
-			s->__ddir	= cpu_to_le32(s->__ddir);
+			s->__ddir	= __cpu_to_le32(s->__ddir);
 			s->bs		= cpu_to_le64(s->bs);
 
 			if (log->log_offset) {
diff --git a/server.h b/server.h
index de1d7f9b..6ac75366 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 80,
+	FIO_SERVER_VER			= 81,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 4d3b728c..9d93dcd1 100644
--- a/stat.c
+++ b/stat.c
@@ -482,9 +482,12 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		display_lat("clat", min, max, mean, dev, out);
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
 		display_lat(" lat", min, max, mean, dev, out);
+	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev))
+		display_lat("prio_clat", min, max, mean, dev, out);
 
 	if (ts->clat_percentiles || ts->lat_percentiles) {
 		const char *name = ts->clat_percentiles ? "clat" : " lat";
+		char prio_name[32];
 		uint64_t samples;
 
 		if (ts->clat_percentiles)
@@ -496,6 +499,27 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 					samples,
 					ts->percentile_list,
 					ts->percentile_precision, name, out);
+
+		/* Only print this if some high and low priority stats were collected */
+		if (ts->clat_high_prio_stat[ddir].samples > 0 &&
+			ts->clat_prio_stat[ddir].samples > 0)
+		{
+			sprintf(prio_name, "high prio (%.2f%%) %s",
+					100. * (double) ts->clat_high_prio_stat[ddir].samples / (double) samples,
+					name);
+			show_clat_percentiles(ts->io_u_plat_high_prio[ddir],
+						ts->clat_high_prio_stat[ddir].samples,
+						ts->percentile_list,
+						ts->percentile_precision, prio_name, out);
+
+			sprintf(prio_name, "low prio (%.2f%%) %s",
+					100. * (double) ts->clat_prio_stat[ddir].samples / (double) samples,
+					name);
+			show_clat_percentiles(ts->io_u_plat_prio[ddir],
+						ts->clat_prio_stat[ddir].samples,
+						ts->percentile_list,
+						ts->percentile_precision, prio_name, out);
+		}
 	}
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
@@ -1009,7 +1033,7 @@ static void show_thread_status_normal(struct thread_stat *ts,
 
 	if (!ddir_rw_sum(ts->io_bytes) && !ddir_rw_sum(ts->total_io_u))
 		return;
-		
+
 	memset(time_buf, 0, sizeof(time_buf));
 
 	time(&time_p);
@@ -1335,6 +1359,112 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		}
 	}
 
+
+	/* Only print PRIO latencies if some high priority samples were gathered */
+	if (ts->clat_high_prio_stat[ddir].samples > 0) {
+		/* START OF HIGH PRIO CLAT */
+	    if (!calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
+			min = max = 0;
+			mean = dev = 0.0;
+		}
+		tmp_object = json_create_object();
+		json_object_add_value_object(dir_object, "clat_prio",
+				tmp_object);
+		json_object_add_value_int(tmp_object, "samples",
+				ts->clat_high_prio_stat[ddir].samples);
+		json_object_add_value_int(tmp_object, "min", min);
+		json_object_add_value_int(tmp_object, "max", max);
+		json_object_add_value_float(tmp_object, "mean", mean);
+		json_object_add_value_float(tmp_object, "stddev", dev);
+
+		if (ts->clat_percentiles) {
+			len = calc_clat_percentiles(ts->io_u_plat_high_prio[ddir],
+						ts->clat_high_prio_stat[ddir].samples,
+						ts->percentile_list, &ovals, &maxv,
+						&minv);
+		} else
+			len = 0;
+
+		percentile_object = json_create_object();
+		json_object_add_value_object(tmp_object, "percentile", percentile_object);
+		for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
+			if (i >= len) {
+				json_object_add_value_int(percentile_object, "0.00", 0);
+				continue;
+			}
+			snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
+			json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
+		}
+
+		if (output_format & FIO_OUTPUT_JSON_PLUS) {
+			clat_bins_object = json_create_object();
+			json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+			for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
+				snprintf(buf, sizeof(buf), "%d", i);
+				json_object_add_value_int(clat_bins_object, (const char *)buf,
+						ts->io_u_plat_high_prio[ddir][i]);
+			}
+			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_BITS",
+					FIO_IO_U_PLAT_BITS);
+			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_VAL",
+					FIO_IO_U_PLAT_VAL);
+			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_NR",
+					FIO_IO_U_PLAT_NR);
+		}
+		/* END OF HIGH PRIO CLAT */
+
+		/* START OF PRIO CLAT */
+	    if (!calc_lat(&ts->clat_prio_stat[ddir], &min, &max, &mean, &dev)) {
+			min = max = 0;
+			mean = dev = 0.0;
+		}
+		tmp_object = json_create_object();
+		json_object_add_value_object(dir_object, "clat_low_prio",
+				tmp_object);
+		json_object_add_value_int(tmp_object, "samples",
+				ts->clat_prio_stat[ddir].samples);
+		json_object_add_value_int(tmp_object, "min", min);
+		json_object_add_value_int(tmp_object, "max", max);
+		json_object_add_value_float(tmp_object, "mean", mean);
+		json_object_add_value_float(tmp_object, "stddev", dev);
+
+		if (ts->clat_percentiles) {
+			len = calc_clat_percentiles(ts->io_u_plat_prio[ddir],
+						ts->clat_prio_stat[ddir].samples,
+						ts->percentile_list, &ovals, &maxv,
+						&minv);
+		} else
+			len = 0;
+
+		percentile_object = json_create_object();
+		json_object_add_value_object(tmp_object, "percentile", percentile_object);
+		for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
+			if (i >= len) {
+				json_object_add_value_int(percentile_object, "0.00", 0);
+				continue;
+			}
+			snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
+			json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
+		}
+
+		if (output_format & FIO_OUTPUT_JSON_PLUS) {
+			clat_bins_object = json_create_object();
+			json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+			for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
+				snprintf(buf, sizeof(buf), "%d", i);
+				json_object_add_value_int(clat_bins_object, (const char *)buf,
+						ts->io_u_plat_prio[ddir][i]);
+			}
+			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_BITS",
+					FIO_IO_U_PLAT_BITS);
+			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_VAL",
+					FIO_IO_U_PLAT_VAL);
+			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_NR",
+					FIO_IO_U_PLAT_NR);
+		}
+		/* END OF PRIO CLAT */
+	}
+
 	if (!ddir_rw(ddir))
 		return;
 
@@ -1856,6 +1986,8 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
 		if (!dst->unified_rw_rep) {
 			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
+			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], first, false);
+			sum_stat(&dst->clat_prio_stat[l], &src->clat_prio_stat[l], first, false);
 			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first, false);
 			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first, false);
 			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first, true);
@@ -1867,6 +1999,8 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 				dst->runtime[l] = src->runtime[l];
 		} else {
 			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], first, false);
+			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], first, false);
+			sum_stat(&dst->clat_prio_stat[l], &src->clat_prio_stat[l], first, false);
 			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first, false);
 			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first, false);
 			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first, true);
@@ -1926,10 +2060,16 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		int m;
 
 		for (m = 0; m < FIO_IO_U_PLAT_NR; m++) {
-			if (!dst->unified_rw_rep)
+			if (!dst->unified_rw_rep) {
 				dst->io_u_plat[k][m] += src->io_u_plat[k][m];
-			else
+				dst->io_u_plat_high_prio[k][m] += src->io_u_plat_high_prio[k][m];
+				dst->io_u_plat_prio[k][m] += src->io_u_plat_prio[k][m];
+			} else {
 				dst->io_u_plat[0][m] += src->io_u_plat[k][m];
+				dst->io_u_plat_high_prio[0][m] += src->io_u_plat_high_prio[k][m];
+				dst->io_u_plat_prio[0][m] += src->io_u_plat_prio[k][m];
+			}
+
 		}
 	}
 
@@ -1962,6 +2102,8 @@ void init_thread_stat(struct thread_stat *ts)
 		ts->slat_stat[j].min_val = -1UL;
 		ts->bw_stat[j].min_val = -1UL;
 		ts->iops_stat[j].min_val = -1UL;
+		ts->clat_high_prio_stat[j].min_val = -1UL;
+		ts->clat_prio_stat[j].min_val = -1UL;
 	}
 	ts->sync_stat.min_val = -1UL;
 	ts->groupid = -1;
@@ -2542,7 +2684,7 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 
 static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 			     enum fio_ddir ddir, unsigned long long bs,
-			     unsigned long t, uint64_t offset)
+			     unsigned long t, uint64_t offset, uint8_t priority_bit)
 {
 	struct io_logs *cur_log;
 
@@ -2561,6 +2703,7 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 		s->time = t + (iolog->td ? iolog->td->unix_epoch : 0);
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
+		s->priority_bit = priority_bit;
 
 		if (iolog->log_offset) {
 			struct io_sample_offset *so = (void *) s;
@@ -2588,6 +2731,8 @@ void reset_io_stats(struct thread_data *td)
 	int i, j;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		reset_io_stat(&ts->clat_high_prio_stat[i]);
+		reset_io_stat(&ts->clat_prio_stat[i]);
 		reset_io_stat(&ts->clat_stat[i]);
 		reset_io_stat(&ts->slat_stat[i]);
 		reset_io_stat(&ts->lat_stat[i]);
@@ -2602,6 +2747,8 @@ void reset_io_stats(struct thread_data *td)
 
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
 			ts->io_u_plat[i][j] = 0;
+			ts->io_u_plat_high_prio[i][j] = 0;
+			ts->io_u_plat_prio[i][j] = 0;
 			if (!i)
 				ts->io_u_sync_plat[j] = 0;
 		}
@@ -2629,7 +2776,7 @@ void reset_io_stats(struct thread_data *td)
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
-			      unsigned long elapsed, bool log_max)
+			      unsigned long elapsed, bool log_max, uint8_t priority_bit)
 {
 	/*
 	 * Note an entry in the log. Use the mean from the logged samples,
@@ -2644,26 +2791,26 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 		else
 			data.val = iolog->avg_window[ddir].mean.u.f + 0.50;
 
-		__add_log_sample(iolog, data, ddir, 0, elapsed, 0);
+		__add_log_sample(iolog, data, ddir, 0, elapsed, 0, priority_bit);
 	}
 
 	reset_io_stat(&iolog->avg_window[ddir]);
 }
 
 static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
-			     bool log_max)
+			     bool log_max, uint8_t priority_bit)
 {
 	int ddir;
 
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-		__add_stat_to_log(iolog, ddir, elapsed, log_max);
+		__add_stat_to_log(iolog, ddir, elapsed, log_max, priority_bit);
 }
 
 static unsigned long add_log_sample(struct thread_data *td,
 				    struct io_log *iolog,
 				    union io_sample_data data,
 				    enum fio_ddir ddir, unsigned long long bs,
-				    uint64_t offset)
+				    uint64_t offset, uint8_t priority_bit)
 {
 	unsigned long elapsed, this_window;
 
@@ -2676,7 +2823,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * If no time averaging, just add the log sample.
 	 */
 	if (!iolog->avg_msec) {
-		__add_log_sample(iolog, data, ddir, bs, elapsed, offset);
+		__add_log_sample(iolog, data, ddir, bs, elapsed, offset, priority_bit);
 		return 0;
 	}
 
@@ -2700,7 +2847,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 			return diff;
 	}
 
-	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0);
+	_add_stat_to_log(iolog, elapsed, td->o.log_max != 0, priority_bit);
 
 	iolog->avg_last[ddir] = elapsed - (this_window - iolog->avg_msec);
 	return iolog->avg_msec;
@@ -2713,18 +2860,19 @@ void finalize_logs(struct thread_data *td, bool unit_logs)
 	elapsed = mtime_since_now(&td->epoch);
 
 	if (td->clat_log && unit_logs)
-		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0, 0);
 	if (td->slat_log && unit_logs)
-		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0, 0);
 	if (td->lat_log && unit_logs)
-		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0, 0);
 	if (td->bw_log && (unit_logs == per_unit_log(td->bw_log)))
-		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0, 0);
 	if (td->iops_log && (unit_logs == per_unit_log(td->iops_log)))
-		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0, 0);
 }
 
-void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned long long bs)
+void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned long long bs,
+					uint8_t priority_bit)
 {
 	struct io_log *iolog;
 
@@ -2732,7 +2880,7 @@ void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned long
 		return;
 
 	iolog = agg_io_log[ddir];
-	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0);
+	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0, priority_bit);
 }
 
 void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
@@ -2745,17 +2893,23 @@ void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
 }
 
 static void add_clat_percentile_sample(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir)
+				unsigned long long nsec, enum fio_ddir ddir, uint8_t priority_bit)
 {
 	unsigned int idx = plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
 
 	ts->io_u_plat[ddir][idx]++;
+
+	if (!priority_bit) {
+		ts->io_u_plat_prio[ddir][idx]++;
+	} else {
+		ts->io_u_plat_high_prio[ddir][idx]++;
+	}
 }
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long long nsec, unsigned long long bs,
-		     uint64_t offset)
+		     uint64_t offset, uint8_t priority_bit)
 {
 	const bool needs_lock = td_async_processing(td);
 	unsigned long elapsed, this_window;
@@ -2767,12 +2921,19 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
+	if (priority_bit) {
+		add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
+	} else {
+		add_stat_sample(&ts->clat_prio_stat[ddir], nsec);
+	}
+
 	if (td->clat_log)
 		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
-			       offset);
+			       offset, priority_bit);
 
-	if (ts->clat_percentiles)
-		add_clat_percentile_sample(ts, nsec, ddir);
+	if (ts->clat_percentiles) {
+		add_clat_percentile_sample(ts, nsec, ddir, priority_bit);
+	}
 
 	if (iolog && iolog->hist_msec) {
 		struct io_hist *hw = &iolog->hist_window[ddir];
@@ -2782,7 +2943,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		if (!hw->hist_last)
 			hw->hist_last = elapsed;
 		this_window = elapsed - hw->hist_last;
-		
+
 		if (this_window >= iolog->hist_msec) {
 			uint64_t *io_u_plat;
 			struct io_u_plat_entry *dst;
@@ -2800,7 +2961,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 				FIO_IO_U_PLAT_NR * sizeof(uint64_t));
 			flist_add(&dst->list, &hw->list);
 			__add_log_sample(iolog, sample_plat(dst), ddir, bs,
-						elapsed, offset);
+						elapsed, offset, priority_bit);
 
 			/*
 			 * Update the last time we recorded as being now, minus
@@ -2817,7 +2978,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long usec, unsigned long long bs, uint64_t offset)
+			unsigned long usec, unsigned long long bs, uint64_t offset,
+			uint8_t priority_bit)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -2831,7 +2993,8 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->slat_stat[ddir], usec);
 
 	if (td->slat_log)
-		add_log_sample(td, td->slat_log, sample_val(usec), ddir, bs, offset);
+		add_log_sample(td, td->slat_log, sample_val(usec), ddir, bs, offset,
+			priority_bit);
 
 	if (needs_lock)
 		__td_io_u_unlock(td);
@@ -2839,7 +3002,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		    unsigned long long nsec, unsigned long long bs,
-		    uint64_t offset)
+		    uint64_t offset, uint8_t priority_bit)
 {
 	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
@@ -2854,10 +3017,10 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->lat_log)
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
-			       offset);
+			       offset, priority_bit);
 
 	if (ts->lat_percentiles)
-		add_clat_percentile_sample(ts, nsec, ddir);
+		add_clat_percentile_sample(ts, nsec, ddir, priority_bit);
 
 	if (needs_lock)
 		__td_io_u_unlock(td);
@@ -2882,7 +3045,7 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 
 	if (td->bw_log)
 		add_log_sample(td, td->bw_log, sample_val(rate), io_u->ddir,
-			       bytes, io_u->offset);
+			       bytes, io_u->offset, io_u_is_prio(io_u));
 
 	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
 
@@ -2936,7 +3099,7 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			next = add_log_sample(td, log, sample_val(rate), ddir, bs, 0);
+			next = add_log_sample(td, log, sample_val(rate), ddir, bs, 0, 0);
 			next_log = min(next_log, next);
 		}
 
@@ -2976,7 +3139,7 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 
 	if (td->iops_log)
 		add_log_sample(td, td->iops_log, sample_val(1), io_u->ddir,
-			       bytes, io_u->offset);
+			       bytes, io_u->offset, io_u_is_prio(io_u));
 
 	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
 
diff --git a/stat.h b/stat.h
index 2ce91ff0..9320c6bd 100644
--- a/stat.h
+++ b/stat.h
@@ -239,6 +239,11 @@ struct thread_stat {
 	fio_fp64_t ss_deviation;
 	fio_fp64_t ss_criterion;
 
+	uint64_t io_u_plat_high_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] __attribute__((aligned(8)));;
+	uint64_t io_u_plat_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
+	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned(8)));
+	struct io_stat clat_prio_stat[DDIR_RWDIR_CNT];
+
 	union {
 		uint64_t *ss_iops_data;
 		uint64_t pad4;
@@ -323,12 +328,13 @@ extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
 
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t);
+				unsigned long long, uint64_t, uint8_t);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
-				unsigned long long, uint64_t);
+				unsigned long long, uint64_t, uint8_t);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned long long, uint64_t);
-extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long);
+				unsigned long long, uint64_t, uint8_t);
+extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long bs,
+				uint8_t priority_bit);
 extern void add_iops_sample(struct thread_data *, struct io_u *,
 				unsigned int);
 extern void add_bw_sample(struct thread_data *, struct io_u *,

