Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55046 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbaDJSzD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Apr 2014 14:55:03 -0400
Received: from [54.225.238.116] (helo=rt116.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYDeG-0004kV-BG
	for fio@vger.kernel.org; Thu, 10 Apr 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140410120003.B2BF140164@rt116.dk>
Date: Thu, 10 Apr 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 42793d9467cc45d08ced5211c3797bf68a3d24cc:

  iolog: skip max_bs[rw] increment for rw == DDIR_INVAL (2014-04-08 21:18:37 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 12d02717a293cdd0c85504c958f7bf57411bb30b:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-04-09 13:58:43 -0600)

----------------------------------------------------------------

Jens Axboe (2):
      Add exit_on_io_done option to the CPU IO engine
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio

 HOWTO         |    2 ++
 engines/cpu.c |   16 ++++++++++++++++
 fio.1         |   11 +++--------
 fio.h         |    2 ++
 ioengines.c   |    3 +++
 libfio.c      |   15 +++++++++++++++
 6 files changed, 41 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 7db7b89..f74360d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1505,6 +1505,8 @@ that defines them is selected.
 [cpu] cpuchunks=int Split the load into cycles of the given time. In
 		microseconds.
 
+[cpu] exit_on_io_done=bool Detect when IO threads are done, then exit.
+
 [netsplice] hostname=str
 [net] hostname=str The host name or IP address to use for TCP or UDP based IO.
 		If the job is a TCP listener or UDP reader, the hostname is not
diff --git a/engines/cpu.c b/engines/cpu.c
index c798f18..85598ef 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -11,6 +11,7 @@ struct cpu_options {
 	struct thread_data *td;
 	unsigned int cpuload;
 	unsigned int cpucycle;
+	unsigned int exit_io_done;
 };
 
 static struct fio_option options[] = {
@@ -36,6 +37,16 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "exit_on_io_done",
+		.lname	= "Exit when IO threads are done",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct cpu_options, exit_io_done),
+		.help	= "Exit when IO threads finish",
+		.def	= "0",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -45,6 +56,11 @@ static int fio_cpuio_queue(struct thread_data *td, struct io_u fio_unused *io_u)
 {
 	struct cpu_options *co = td->eo;
 
+	if (co->exit_io_done && !fio_running_or_pending_io_threads()) {
+		td->done = 1;
+		return FIO_Q_BUSY;
+	}
+
 	usec_spin(co->cpucycle);
 	return FIO_Q_COMPLETED;
 }
diff --git a/fio.1 b/fio.1
index 91f96e0..8cf3778 100644
--- a/fio.1
+++ b/fio.1
@@ -1226,14 +1226,6 @@ Output is redirected in a file called \fBjobname.postrun.txt\fR
 .BI ioscheduler \fR=\fPstr
 Attempt to switch the device hosting the file to the specified I/O scheduler.
 .TP
-.BI cpuload \fR=\fPint
-If the job is a CPU cycle-eater, attempt to use the specified percentage of
-CPU cycles.
-.TP
-.BI cpuchunks \fR=\fPint
-If the job is a CPU cycle-eater, split the load into cycles of the
-given time in milliseconds.
-.TP
 .BI disk_util \fR=\fPbool
 Generate disk utilization statistics if the platform supports it. Default: true.
 .TP
@@ -1375,6 +1367,9 @@ Attempt to use the specified percentage of CPU cycles.
 .BI (cpu)cpuchunks \fR=\fPint
 Split the load into cycles of the given time. In microseconds.
 .TP
+.BI (cpu)exit_on_io_done \fR=\fPbool
+Detect when IO threads are done, then exit.
+.TP
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use
 the io_getevents system call to reap newly returned events.
diff --git a/fio.h b/fio.h
index a539f21..3df5bd9 100644
--- a/fio.h
+++ b/fio.h
@@ -72,6 +72,7 @@ enum {
 	TD_F_VER_NONE		= 32,
 	TD_F_PROFILE_OPS	= 64,
 	TD_F_COMPRESS		= 128,
+	TD_F_NOIO		= 256,
 };
 
 enum {
@@ -439,6 +440,7 @@ extern void add_job_opts(const char **, int);
 extern char *num2str(unsigned long, int, int, int, int);
 extern int ioengine_load(struct thread_data *);
 extern int parse_dryrun(void);
+extern int fio_running_or_pending_io_threads(void);
 
 extern uintptr_t page_mask;
 extern uintptr_t page_size;
diff --git a/ioengines.c b/ioengines.c
index 3c75fa6..0f94d0d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -375,6 +375,9 @@ int td_io_init(struct thread_data *td)
 			td->error = ret;
 	}
 
+	if (!ret && (td->io_ops->flags & FIO_NOIO))
+		td->flags |= TD_F_NOIO;
+
 	return ret;
 }
 
diff --git a/libfio.c b/libfio.c
index 1fd77e4..3fde492 100644
--- a/libfio.c
+++ b/libfio.c
@@ -218,6 +218,21 @@ void fio_terminate_threads(int group_id)
 	}
 }
 
+int fio_running_or_pending_io_threads(void)
+{
+	struct thread_data *td;
+	int i;
+
+	for_each_td(td, i) {
+		if (td->flags & TD_F_NOIO)
+			continue;
+		if (td->runstate < TD_EXITED)
+			return 1;
+	}
+
+	return 0;
+}
+
 static int endian_check(void)
 {
 	union {
