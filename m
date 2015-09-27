Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36110 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbbI0TZF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 27 Sep 2015 15:25:05 -0400
Received: by wicgb1 with SMTP id gb1so78097996wic.1
        for <fio@vger.kernel.org>; Sun, 27 Sep 2015 12:25:04 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [PATCH 2/2] Introduce new option: iodepth_batch_complete_max
Date: Sun, 27 Sep 2015 21:24:55 +0200
Message-Id: <1443381895-21287-2-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1443381895-21287-1-git-send-email-r.peniaev@gmail.com>
References: <1443381895-21287-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

By now there is an option which is called 'iodepth_batch_complete'.
This option provides a possibility to read exact amount of events
of completed IOs, e.g. by default it is set to 1, so only 1 event
will be read on each io_getevents system call:

 7945  io_getevents(139876985688064, 1, 1, {...}NULL) = 1

This option can be set to any desired amount, say the whole iodepth
size can be used, e.g. 128:

 7952  io_getevents(140303500259328, 128, 128, {...}NULL) = 128

We will not exit the system call till the whole queue will be completed.
Sounds not so efficient.

In this patch I add the 'iodepth_batch_complete_max' option and rename
'iodepth_batch_complete' to 'iodepth_batch_complete_min' to have a
possibility to specify a range of events which I want to read.
(of course because of compatibility's sake 'iodepth_batch_complete_min'
 is an alias for 'iodepth_batch_complete').

So finally if options are set to:

 # or iodepth_batch_complete_min=1
 iodepth_batch_complete=1
 # take the iodepth value
 iodepth_batch_complete_max=128

The io_getevents call will look like:

 7961  io_getevents(140173245206528, 1, 128, {...}NULL) = 73

and we will exit the system call with any amount of completed
IOs >= 1.

What are the benefits? Fetching events from the queue can be
done more efficiently on some testing on specific configurations,
e.g. stacked block devices based on null_blk devices, where
completion happens immediately and events should be retried from
the queue ASAP.

Let's take a simple example.

BASE CONFIG:

[global]
fadvise_hint=0
rw=randrw:2
direct=1
size=256M
ioengine=libaio
iodepth=128

time_based=1
runtime=60
ramp_time=10

[job1]
filename=/dev/nullb0

[job2]
filename=/dev/nullb1

[job3]
filename=/dev/nullb2

[job4]
filename=/dev/nullb3

--- FIO OUT ---
Run status group 0 (all jobs):
   READ: io=2451.5MB, aggrb=41837KB/s, minb=10348KB/s, maxb=10536KB/s, mint=60000msec, maxt=60001msec
  WRITE: io=2447.2MB, aggrb=41764KB/s, minb=10328KB/s, maxb=10515KB/s, mint=60000msec, maxt=60001msec
---------------

ADDITION TO BASE CONFIG #1:

iodepth_batch_submit=128
iodepth_batch_complete=128

--- FIO OUT ---
Run status group 0 (all jobs):
   READ: io=4038.8MB, aggrb=68922KB/s, minb=17083KB/s, maxb=17399KB/s, mint=60001msec, maxt=60004msec
  WRITE: io=4028.9MB, aggrb=68754KB/s, minb=17046KB/s, maxb=17358KB/s, mint=60001msec, maxt=60004msec
---------------

ADDITION TO BASE CONFIG #2:
(usage of new 'iodepth_batch_complete_max')

iodepth_batch_complete=1
iodepth_batch_complete_max=128
iodepth_batch_submit=128

--- FIO OUT ---
Run status group 0 (all jobs):
   READ: io=4086.2MB, aggrb=69733KB/s, minb=17254KB/s, maxb=17593KB/s, mint=60002msec, maxt=60003msec
  WRITE: io=4076.7MB, aggrb=69571KB/s, minb=17210KB/s, maxb=17556KB/s, mint=60002msec, maxt=60003msec
---------------

Also, in polling mode now it is possible to fetch as many
events as set in 'iodepth_batch_complete_max', and not only 1
as was by default, e.g. configuration:

iodepth_batch_complete=0
iodepth_batch_complete_max=128

will produce 'io_getevents' system call with params:

 8102  io_getevents(140011302801408, 0, 128, {...}NULL) = 128

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: fio@vger.kernel.org
---
 HOWTO            | 26 ++++++++++++++++++++++++++
 backend.c        | 14 ++++++++++----
 cconv.c          |  6 ++++--
 engines/libaio.c |  2 +-
 fio.1            | 34 +++++++++++++++++++++++++++++++++-
 init.c           |  7 +++++++
 io_u.c           |  4 +++-
 options.c        | 22 ++++++++++++++++++----
 thread_options.h |  7 +++++--
 9 files changed, 107 insertions(+), 15 deletions(-)

diff --git a/HOWTO b/HOWTO
index 3049316..40233bd 100644
--- a/HOWTO
+++ b/HOWTO
@@ -815,6 +815,7 @@ iodepth_batch=int This defines how many pieces of IO to submit at once.
 		bigger batches of IO at the time. If it is set to 0 the iodepth
 		value will be used.
 
+iodepth_batch_complete_min=int
 iodepth_batch_complete=int This defines how many pieces of IO to retrieve
 		at once. It defaults to 1 which means that we'll ask
 		for a minimum of 1 IO in the retrieval process from
@@ -824,6 +825,31 @@ iodepth_batch_complete=int This defines how many pieces of IO to retrieve
 		events before queuing more IO. This helps reduce
 		IO latency, at the cost of more retrieval system calls.
 
+iodepth_batch_complete_max=int This defines maximum pieces of IO to
+		retrieve at once. This variable should be used along with
+		iodepth_batch_complete_min=int variable, specifying the range
+		of min and max amount of IO which should be retrieved. By default
+		it is equal to iodepth_batch_complete_min value.
+
+		Example #1:
+
+		iodepth_batch_complete_min=1
+		iodepth_batch_complete_max=<iodepth>
+
+		which means that we will retrieve at leat 1 IO and up to the
+		whole submitted queue depth. If none of IO has been completed
+		yet, we will wait.
+
+		Example #2:
+
+		iodepth_batch_complete_min=0
+		iodepth_batch_complete_max=<iodepth>
+
+		which means that we can retrieve up to the whole submitted
+		queue depth, but if none of IO has been completed yet, we will
+		NOT wait and immediately exit the system call. In this example
+		we simply do polling.
+
 iodepth_low=int	The low water mark indicating when to start filling
 		the queue again. Defaults to the same as iodepth, meaning
 		that fio will attempt to keep the queue full at all times.
diff --git a/backend.c b/backend.c
index dec0d55..b1477df 100644
--- a/backend.c
+++ b/backend.c
@@ -446,8 +446,8 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time)
 	/*
 	 * if the queue is full, we MUST reap at least 1 event
 	 */
-	min_evts = min(td->o.iodepth_batch_complete, td->cur_depth);
-    if ((full && !min_evts) || !td->o.iodepth_batch_complete)
+	min_evts = min(td->o.iodepth_batch_complete_min, td->cur_depth);
+    if ((full && !min_evts) || !td->o.iodepth_batch_complete_min)
 		min_evts = 1;
 
 	if (time && (__should_check_rate(td, DDIR_READ) ||
@@ -551,6 +551,12 @@ sync_done:
 	return 0;
 }
 
+static inline int io_in_polling(struct thread_data *td)
+{
+	return !td->o.iodepth_batch_complete_min &&
+		   !td->o.iodepth_batch_complete_max;
+}
+
 /*
  * The main verify engine. Runs over the writes we previously submitted,
  * reads the blocks back in, and checks the crc/md5 of the data.
@@ -684,7 +690,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 		 */
 reap:
 		full = queue_full(td) || (ret == FIO_Q_BUSY && td->cur_depth);
-		if (full || !td->o.iodepth_batch_complete)
+		if (full || io_in_polling(td))
 			ret = wait_for_completions(td, NULL);
 
 		if (ret < 0)
@@ -932,7 +938,7 @@ static uint64_t do_io(struct thread_data *td)
 reap:
 			full = queue_full(td) ||
 				(ret == FIO_Q_BUSY && td->cur_depth);
-			if (full || !td->o.iodepth_batch_complete)
+			if (full || io_in_polling(td))
 				ret = wait_for_completions(td, &comp_time);
 		}
 		if (ret < 0)
diff --git a/cconv.c b/cconv.c
index 44f17da..fde8c6d 100644
--- a/cconv.c
+++ b/cconv.c
@@ -83,7 +83,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->iodepth = le32_to_cpu(top->iodepth);
 	o->iodepth_low = le32_to_cpu(top->iodepth_low);
 	o->iodepth_batch = le32_to_cpu(top->iodepth_batch);
-	o->iodepth_batch_complete = le32_to_cpu(top->iodepth_batch_complete);
+	o->iodepth_batch_complete_min = le32_to_cpu(top->iodepth_batch_complete_min);
+	o->iodepth_batch_complete_max = le32_to_cpu(top->iodepth_batch_complete_max);
 	o->size = le64_to_cpu(top->size);
 	o->io_limit = le64_to_cpu(top->io_limit);
 	o->size_percent = le32_to_cpu(top->size_percent);
@@ -300,7 +301,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->iodepth = cpu_to_le32(o->iodepth);
 	top->iodepth_low = cpu_to_le32(o->iodepth_low);
 	top->iodepth_batch = cpu_to_le32(o->iodepth_batch);
-	top->iodepth_batch_complete = cpu_to_le32(o->iodepth_batch_complete);
+	top->iodepth_batch_complete_min = cpu_to_le32(o->iodepth_batch_complete_min);
+	top->iodepth_batch_complete_max = cpu_to_le32(o->iodepth_batch_complete_max);
 	top->size_percent = cpu_to_le32(o->size_percent);
 	top->fill_device = cpu_to_le32(o->fill_device);
 	top->file_append = cpu_to_le32(o->file_append);
diff --git a/engines/libaio.c b/engines/libaio.c
index 9685c99..60dc49d 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -146,7 +146,7 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 {
 	struct libaio_data *ld = td->io_ops->data;
 	struct libaio_options *o = td->eo;
-	unsigned actual_min = td->o.iodepth_batch_complete == 0 ? 0 : min;
+	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
 	struct timespec __lt, *lt = NULL;
 	int r, events = 0;
 
diff --git a/fio.1 b/fio.1
index aea9f34..b049790 100644
--- a/fio.1
+++ b/fio.1
@@ -704,7 +704,7 @@ which means that we submit each IO as soon as it is available, but can
 be raised to submit bigger batches of IO at the time. If it is set to 0
 the \fBiodepth\fR value will be used.
 .TP
-.BI iodepth_batch_complete \fR=\fPint
+.BI iodepth_batch_complete_min \fR=\fPint "\fR,\fP iodepth_batch_complete" \fR=\fPint
 This defines how many pieces of IO to retrieve at once. It defaults to 1 which
  means that we'll ask for a minimum of 1 IO in the retrieval process from the
 kernel. The IO retrieval will go on until we hit the limit set by
@@ -712,6 +712,38 @@ kernel. The IO retrieval will go on until we hit the limit set by
 completed events before queuing more IO. This helps reduce IO latency, at the
 cost of more retrieval system calls.
 .TP
+.BI iodepth_batch_complete_max \fR=\fPint
+This defines maximum pieces of IO to
+retrieve at once. This variable should be used along with
+\fBiodepth_batch_complete_min\fR=int variable, specifying the range
+of min and max amount of IO which should be retrieved. By default
+it is equal to \fBiodepth_batch_complete_min\fR value.
+
+Example #1:
+.RS
+.RS
+\fBiodepth_batch_complete_min\fR=1
+.LP
+\fBiodepth_batch_complete_max\fR=<iodepth>
+.RE
+
+which means that we will retrieve at leat 1 IO and up to the
+whole submitted queue depth. If none of IO has been completed
+yet, we will wait.
+
+Example #2:
+.RS
+\fBiodepth_batch_complete_min\fR=0
+.LP
+\fBiodepth_batch_complete_max\fR=<iodepth>
+.RE
+
+which means that we can retrieve up to the whole submitted
+queue depth, but if none of IO has been completed yet, we will
+NOT wait and immediately exit the system call. In this example
+we simply do polling.
+.RE
+.TP
 .BI iodepth_low \fR=\fPint
 Low watermark indicating when to start filling the queue again.  Default:
 \fBiodepth\fR. 
diff --git a/init.c b/init.c
index cdb98c5..cecec94 100644
--- a/init.c
+++ b/init.c
@@ -630,6 +630,13 @@ static int fixup_options(struct thread_data *td)
 	if (o->iodepth_batch > o->iodepth || !o->iodepth_batch)
 		o->iodepth_batch = o->iodepth;
 
+	/*
+	 * If max batch complete number isn't set or set incorrectly,
+	 * default to the same as iodepth_batch_complete_min
+	 */
+	if (o->iodepth_batch_complete_min > o->iodepth_batch_complete_max)
+		o->iodepth_batch_complete_max = o->iodepth_batch_complete_min;
+
 	if (o->nr_files > td->files_index)
 		o->nr_files = td->files_index;
 
diff --git a/io_u.c b/io_u.c
index 9f10206..e411274 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1829,7 +1829,9 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 	else if (min_evts > td->cur_depth)
 		min_evts = td->cur_depth;
 
-	ret = td_io_getevents(td, min_evts, td->o.iodepth_batch_complete, tvp);
+	/* No worries, td_io_getevents fixes min and max if they are
+	 * set incorrectly */
+	ret = td_io_getevents(td, min_evts, td->o.iodepth_batch_complete_max, tvp);
 	if (ret < 0) {
 		td_verror(td, -ret, "td_io_getevents");
 		return ret;
diff --git a/options.c b/options.c
index 1868dfd..0169ca2 100644
--- a/options.c
+++ b/options.c
@@ -1504,11 +1504,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_BASIC,
 	},
 	{
-		.name	= "iodepth_batch_complete",
-		.lname	= "IO Depth batch complete",
+		.name	= "iodepth_batch_complete_min",
+		.lname	= "Min IO depth batch complete",
+		.alias	= "iodepth_batch_complete",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(iodepth_batch_complete),
-		.help	= "Number of IO buffers to retrieve in one go",
+		.off1	= td_var_offset(iodepth_batch_complete_min),
+		.help	= "Min number of IO buffers to retrieve in one go",
 		.parent	= "iodepth",
 		.hide	= 1,
 		.minval	= 0,
@@ -1518,6 +1519,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_BASIC,
 	},
 	{
+		.name	= "iodepth_batch_complete_max",
+		.lname	= "Max IO depth batch complete",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(iodepth_batch_complete_max),
+		.help	= "Max number of IO buffers to retrieve in one go",
+		.parent	= "iodepth",
+		.hide	= 1,
+		.minval	= 0,
+		.interval = 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BASIC,
+	},
+	{
 		.name	= "iodepth_low",
 		.lname	= "IO Depth batch low",
 		.type	= FIO_OPT_INT,
diff --git a/thread_options.h b/thread_options.h
index 38936e9..5ef560e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -54,7 +54,8 @@ struct thread_options {
 	unsigned int iodepth;
 	unsigned int iodepth_low;
 	unsigned int iodepth_batch;
-	unsigned int iodepth_batch_complete;
+	unsigned int iodepth_batch_complete_min;
+	unsigned int iodepth_batch_complete_max;
 
 	unsigned long long size;
 	unsigned long long io_limit;
@@ -299,7 +300,9 @@ struct thread_options_pack {
 	uint32_t iodepth;
 	uint32_t iodepth_low;
 	uint32_t iodepth_batch;
-	uint32_t iodepth_batch_complete;
+	uint32_t iodepth_batch_complete_min;
+	uint32_t iodepth_batch_complete_max;
+	uint32_t __proper_alignment_for_64b;
 
 	uint64_t size;
 	uint64_t io_limit;
-- 
2.5.1

