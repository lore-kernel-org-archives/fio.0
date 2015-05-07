Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbbEGMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 7 May 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YqKTF-0002CI-4I
	for fio@vger.kernel.org; Thu, 07 May 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150507120002.450DF2C1077@kernel.dk>
Date: Thu,  7 May 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 83b2850d223f2bb91783ac5a0fa657ea60d1eff7:

  libmtd: ->name and ->type_str can't be constant (2015-05-05 12:11:55 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 477bd5ab362b65fe9c7749735236e6ed0d4346f8:

  server: bump version (2015-05-06 15:21:19 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      HOWTO: clarify the 'wait' statement in iologs
      Merge branch 'master' of git://github.com/iuliur/fio
      Add support for options being a power-of-2
      blktrace: add support for scaling and aligning replays
      cconv: add missing conversions of block_error_hist and skip_bad
      server: bump version

Julius Rus (1):
      Make windowsaio match iometer performance. Without this, we see around 60k on local flash while iometer does 100k.

 HOWTO                |  7 +++++++
 backend.c            |  2 +-
 blktrace.c           | 27 ++++++++++++++++++++++++++-
 cconv.c              |  8 ++++++++
 engines/libaio.c     |  1 +
 engines/windowsaio.c | 21 ++++++---------------
 eta.c                |  1 +
 fio.1                |  6 ++++++
 fio.h                |  5 -----
 gclient.c            |  1 +
 io_u.c               |  1 +
 lib/pow2.h           | 11 +++++++++++
 options.c            | 22 ++++++++++++++++++++++
 parse.c              |  5 +++++
 parse.h              |  1 +
 server.h             |  2 +-
 stat.c               |  1 +
 thread_options.h     |  6 ++++++
 18 files changed, 105 insertions(+), 23 deletions(-)
 create mode 100644 lib/pow2.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index bcc72b5..0808cc3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1433,6 +1433,12 @@ replay_redirect=str While replaying I/O patterns using read_iolog the
 		independent fio invocations.  Unfortuantely this also breaks
 		the strict time ordering between multiple device accesses.
 
+replay_align=int	Force alignment of IO offsets and lengths in a trace
+		to this power of 2 value.
+
+replay_scale=int	Scale sector offsets down by this factor when
+		replaying traces.
+
 write_bw_log=str If given, write a bandwidth log of the jobs in this job
 		file. Can be used to store data of the bandwidth of the
 		jobs in their lifetime. The included fio_generate_plots
@@ -2010,6 +2016,7 @@ before it can be used with this format. The offset and length are given in
 bytes. The action can be one of these:
 
 wait       Wait for 'offset' microseconds. Everything below 100 is discarded.
+	   The time is relative to the previous wait statement.
 read       Read 'length' bytes beginning from 'offset'
 write      Write 'length' bytes beginning from 'offset'
 sync       fsync() the file
diff --git a/backend.c b/backend.c
index e87c5f8..1dcdcf0 100644
--- a/backend.c
+++ b/backend.c
@@ -442,7 +442,7 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time)
 	 * if the queue is full, we MUST reap at least 1 event
 	 */
 	min_evts = min(td->o.iodepth_batch_complete, td->cur_depth);
-	if (full && !min_evts)
+    if ((full && !min_evts) || !td->o.iodepth_batch_complete)
 		min_evts = 1;
 
 	if (time && (__should_check_rate(td, DDIR_READ) ||
diff --git a/blktrace.c b/blktrace.c
index 2d4dc1b..562e126 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -208,6 +208,23 @@ out:
 	return last_fileno;
 }
 
+static void t_bytes_align(struct thread_options *o, struct blk_io_trace *t)
+{
+	if (!o->replay_align)
+		return;
+
+	t->bytes = (t->bytes + o->replay_align - 1) & ~(o->replay_align - 1);
+}
+
+static void ipo_bytes_align(struct thread_options *o, struct io_piece *ipo)
+{
+	if (!o->replay_align)
+		return;
+
+	ipo->offset &= ~(o->replay_align - 1);
+}
+
+
 /*
  * Store blk_io_trace data in an ipo for later retrieval.
  */
@@ -220,6 +237,9 @@ static void store_ipo(struct thread_data *td, unsigned long long offset,
 	init_ipo(ipo);
 
 	ipo->offset = offset * bs;
+	if (td->o.replay_scale)
+		ipo->offset = ipo->offset / td->o.replay_scale;
+	ipo_bytes_align(&td->o, ipo);
 	ipo->len = bytes;
 	ipo->delay = ttime / 1000;
 	if (rw)
@@ -275,6 +295,9 @@ static void handle_trace_discard(struct thread_data *td,
 	INIT_FLIST_HEAD(&ipo->list);
 
 	ipo->offset = t->sector * bs;
+	if (td->o.replay_scale)
+		ipo->offset = ipo->offset / td->o.replay_scale;
+	ipo_bytes_align(&td->o, ipo);
 	ipo->len = t->bytes;
 	ipo->delay = ttime / 1000;
 	ipo->ddir = DDIR_TRIM;
@@ -314,7 +337,7 @@ static void handle_trace(struct thread_data *td, struct blk_io_trace *t,
 			 unsigned long *ios, unsigned int *bs)
 {
 	static unsigned long long last_ttime;
-	unsigned long long delay;
+	unsigned long long delay = 0;
 
 	if ((t->action & 0xffff) != __BLK_TA_QUEUE)
 		return;
@@ -329,6 +352,8 @@ static void handle_trace(struct thread_data *td, struct blk_io_trace *t,
 		}
 	}
 
+	t_bytes_align(&td->o, t);
+
 	if (t->action & BLK_TC_ACT(BLK_TC_NOTIFY))
 		handle_trace_notify(t);
 	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
diff --git a/cconv.c b/cconv.c
index 976059c..1e095af 100644
--- a/cconv.c
+++ b/cconv.c
@@ -244,6 +244,10 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
 	o->compress_chunk = le32_to_cpu(top->compress_chunk);
 	o->dedupe_percentage = le32_to_cpu(top->dedupe_percentage);
+	o->skip_bad = le32_to_cpu(top->skip_bad);
+	o->block_error_hist = le32_to_cpu(top->block_error_hist);
+	o->replay_align = le32_to_cpu(top->replay_align);
+	o->replay_scale = le32_to_cpu(top->replay_scale);
 
 	o->trim_backlog = le64_to_cpu(top->trim_backlog);
 
@@ -407,6 +411,10 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->compress_percentage = cpu_to_le32(o->compress_percentage);
 	top->compress_chunk = cpu_to_le32(o->compress_chunk);
 	top->dedupe_percentage = cpu_to_le32(o->dedupe_percentage);
+	top->block_error_hist = cpu_to_le32(o->block_error_hist);
+	top->skip_bad = cpu_to_le32(o->skip_bad);
+	top->replay_align = cpu_to_le32(o->replay_align);
+	top->replay_scale = cpu_to_le32(o->replay_scale);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		top->bs[i] = cpu_to_le32(o->bs[i]);
diff --git a/engines/libaio.c b/engines/libaio.c
index 8ba21f8..9685c99 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -12,6 +12,7 @@
 #include <libaio.h>
 
 #include "../fio.h"
+#include "../lib/pow2.h"
 
 static int fio_libaio_commit(struct thread_data *td);
 
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index ec8222c..cbbed6a 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -284,14 +284,13 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 
 			if (fov->io_complete) {
 				fov->io_complete = FALSE;
-				ResetEvent(fov->o.hEvent);
 				wd->aio_events[dequeued] = io_u;
 				dequeued++;
 			}
 
-			if (dequeued >= min)
-				break;
 		}
+		if (dequeued >= min)
+			break;
 
 		if (dequeued < min) {
 			status = WaitForSingleObject(wd->iocomplete_event, mswait);
@@ -310,23 +309,22 @@ static int fio_windowsaio_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_overlapped *o = io_u->engine_data;
 	LPOVERLAPPED lpOvl = &o->o;
-	DWORD iobytes;
 	BOOL success = FALSE;
 	int rc = FIO_Q_COMPLETED;
 
 	fio_ro_check(td, io_u);
 
-	lpOvl->Internal = STATUS_PENDING;
+	lpOvl->Internal = 0;
 	lpOvl->InternalHigh = 0;
 	lpOvl->Offset = io_u->offset & 0xFFFFFFFF;
 	lpOvl->OffsetHigh = io_u->offset >> 32;
 
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
-		success = WriteFile(io_u->file->hFile, io_u->xfer_buf, io_u->xfer_buflen, &iobytes, lpOvl);
+		success = WriteFile(io_u->file->hFile, io_u->xfer_buf, io_u->xfer_buflen, NULL, lpOvl);
 		break;
 	case DDIR_READ:
-		success = ReadFile(io_u->file->hFile, io_u->xfer_buf, io_u->xfer_buflen, &iobytes, lpOvl);
+		success = ReadFile(io_u->file->hFile, io_u->xfer_buf, io_u->xfer_buflen, NULL, lpOvl);
 		break;
 	case DDIR_SYNC:
 	case DDIR_DATASYNC:
@@ -403,7 +401,6 @@ static void fio_windowsaio_io_u_free(struct thread_data *td, struct io_u *io_u)
 	struct fio_overlapped *o = io_u->engine_data;
 
 	if (o) {
-		CloseHandle(o->o.hEvent);
 		io_u->engine_data = NULL;
 		free(o);
 	}
@@ -416,13 +413,7 @@ static int fio_windowsaio_io_u_init(struct thread_data *td, struct io_u *io_u)
 	o = malloc(sizeof(*o));
 	o->io_complete = FALSE;
 	o->io_u = io_u;
-	o->o.hEvent = CreateEvent(NULL, TRUE, FALSE, NULL);
-	if (o->o.hEvent == NULL) {
-		log_err("windowsaio: failed to create event handle\n");
-		free(o);
-		return 1;
-	}
-
+	o->o.hEvent = NULL;
 	io_u->engine_data = o;
 	return 0;
 }
diff --git a/eta.c b/eta.c
index 167bf5f..e458457 100644
--- a/eta.c
+++ b/eta.c
@@ -6,6 +6,7 @@
 #include <string.h>
 
 #include "fio.h"
+#include "lib/pow2.h"
 
 static char __run_str[REAL_MAX_JOBS + 1];
 static char run_str[__THREAD_RUNSTR_SZ(REAL_MAX_JOBS)];
diff --git a/fio.1 b/fio.1
index a77c71c..e54e419 100644
--- a/fio.1
+++ b/fio.1
@@ -1265,6 +1265,12 @@ is to replay the IOPS onto the major/minor device that each IOP was recorded
 from.  Setting \fBreplay_redirect\fR causes all IOPS to be replayed onto the
 single specified device regardless of the device it was recorded from.
 .TP
+.BI replay_align \fR=\fPint
+Force alignment of IO offsets and lengths in a trace to this power of 2 value.
+.TP
+.BI replay_scale \fR=\fPint
+Scale sector offsets down by this factor when replaying traces.
+.TP
 .BI write_bw_log \fR=\fPstr
 If given, write a bandwidth log of the jobs in this job file. Can be used to
 store data of the bandwidth of the jobs in their lifetime. The included
diff --git a/fio.h b/fio.h
index a4637bb..0d5a0ef 100644
--- a/fio.h
+++ b/fio.h
@@ -631,11 +631,6 @@ static inline unsigned int td_min_bs(struct thread_data *td)
 	return min(td->o.min_bs[DDIR_TRIM], min_bs);
 }
 
-static inline int is_power_of_2(uint64_t val)
-{
-	return (val != 0 && ((val & (val - 1)) == 0));
-}
-
 static inline int td_async_processing(struct thread_data *td)
 {
 	return (td->flags & TD_F_NEED_LOCK) != 0;
diff --git a/gclient.c b/gclient.c
index 42bc761..d7d9616 100644
--- a/gclient.c
+++ b/gclient.c
@@ -13,6 +13,7 @@
 #include "graph.h"
 #include "gclient.h"
 #include "printing.h"
+#include "lib/pow2.h"
 
 static void gfio_display_ts(struct fio_client *client, struct thread_stat *ts,
 			    struct group_run_stats *rs);
diff --git a/io_u.c b/io_u.c
index d00e6e3..e67149d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -12,6 +12,7 @@
 #include "lib/rand.h"
 #include "lib/axmap.h"
 #include "err.h"
+#include "lib/pow2.h"
 
 struct io_completion_data {
 	int nr;				/* input */
diff --git a/lib/pow2.h b/lib/pow2.h
new file mode 100644
index 0000000..f3ca4d7
--- /dev/null
+++ b/lib/pow2.h
@@ -0,0 +1,11 @@
+#ifndef FIO_POW2_H
+#define FIO_POW2_H
+
+#include <inttypes.h>
+
+static inline int is_power_of_2(uint64_t val)
+{
+	return (val != 0 && ((val & (val - 1)) == 0));
+}
+
+#endif
diff --git a/options.c b/options.c
index 3de1248..40b69ed 100644
--- a/options.c
+++ b/options.c
@@ -2662,6 +2662,28 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IOLOG,
 	},
 	{
+		.name	= "replay_scale",
+		.lname	= "Replace offset scale factor",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(replay_scale),
+		.parent	= "read_iolog",
+		.def	= "1",
+		.help	= "Align offsets to this blocksize",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IOLOG,
+	},
+	{
+		.name	= "replay_align",
+		.lname	= "Replace alignment",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(replay_align),
+		.parent	= "read_iolog",
+		.help	= "Scale offset down by this factor",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IOLOG,
+		.pow2	= 1,
+	},
+	{
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
 		.type	= FIO_OPT_STR_STORE,
diff --git a/parse.c b/parse.c
index 7912212..745056b 100644
--- a/parse.c
+++ b/parse.c
@@ -17,6 +17,7 @@
 #include "options.h"
 #include "minmax.h"
 #include "lib/ieee754.h"
+#include "lib/pow2.h"
 
 #ifdef CONFIG_ARITHMETIC
 #include "y.tab.h"
@@ -521,6 +522,10 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 
 		if (ret)
 			break;
+		if (o->pow2 && !is_power_of_2(ull)) {
+			log_err("%s: must be a power-of-2\n", o->name);
+			return 1;
+		}
 
 		if (o->maxval && ull > o->maxval) {
 			log_err("max value out of range: %llu"
diff --git a/parse.h b/parse.h
index 15f2e06..264243b 100644
--- a/parse.h
+++ b/parse.h
@@ -75,6 +75,7 @@ struct fio_option {
 	int is_seconds;			/* time value with seconds base */
 	int is_time;			/* time based value */
 	int no_warn_def;
+	int pow2;			/* must be a power-of-2 */
 };
 
 typedef int (str_cb_fn)(void *, char *);
diff --git a/server.h b/server.h
index da12ae0..b0cea15 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 43,
+	FIO_SERVER_VER			= 44,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index d143d36..9a30bea 100644
--- a/stat.c
+++ b/stat.c
@@ -13,6 +13,7 @@
 #include "json.h"
 #include "lib/getrusage.h"
 #include "idletime.h"
+#include "lib/pow2.h"
 
 struct fio_mutex *stat_mutex;
 
diff --git a/thread_options.h b/thread_options.h
index aa7f3f2..1c48bd8 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -265,6 +265,9 @@ struct thread_options {
 
 	unsigned block_error_hist;
 	unsigned int skip_bad;
+
+	unsigned int replay_align;
+	unsigned int replay_scale;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -495,6 +498,9 @@ struct thread_options_pack {
 
 	uint32_t block_error_hist;
 	uint32_t skip_bad;
+
+	uint32_t replay_align;
+	uint32_t replay_scale;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
