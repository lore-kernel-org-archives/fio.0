Return-Path: <fio-owner@vger.kernel.org>
Received: from www7149u.sakura.ne.jp ([59.106.184.187]:54251 "EHLO
	i.rakugaki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab1ILFdD (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 12 Sep 2011 01:33:03 -0400
Received: from [10.253.0.10] (KD125053235206.ppp-bb.dion.ne.jp [125.53.235.206])
	by i.rakugaki.org (Postfix) with ESMTPSA id 87A2D202FB
	for <fio@vger.kernel.org>; Mon, 12 Sep 2011 14:32:59 +0900 (JST)
Message-ID: <4E6D98DB.7020106@rakugaki.org>
Date: Mon, 12 Sep 2011 14:30:03 +0900
From: Taisuke Yamada <tai@rakugaki.org>
MIME-Version: 1.0
Subject: [PATCH 1/2] Added replay_rebase option to run multi-threaded log
 replay on different disk sectors.
Content-Type: multipart/mixed;
 boundary="------------080804000607020501000605"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------080804000607020501000605
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> But since I also wanted to have each thread accessing different
> parts of the disk to increase a load, but still following the
> access pattern of the original, I added "replay_rebase" option to
> shift offset of IO request for each thread.
>
>> Thanks, I can see this being handy. I can apply this, but I would
>> much prefer if you resend it with the proper updates to HOWTO and
>> fio.1 adding the new option. Otherwise nobody is going to learn about it.

Yes, you're right.
Here's an updated patch with documentation.

Best Regards,

Signed-off-by: Taisuke Yamada <tai@rakugaki.org>
---
 HOWTO     |    9 +++++++++
 fio.1     |    9 +++++++++
 fio.h     |    1 +
 log.c     |    2 +-
 options.c |    8 ++++++++
 5 files changed, 28 insertions(+), 1 deletions(-)



--------------080804000607020501000605
Content-Type: text/x-patch;
 name="0001-Added-replay_rebase-option-to-run-multi-threaded-log.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Added-replay_rebase-option-to-run-multi-threaded-log.pa";
 filename*1="tch"

diff --git a/HOWTO b/HOWTO
index 724b604..132dc4a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1078,6 +1078,15 @@ replay_redirect=str While replaying I/O patterns using read_iolog the
 		independent fio invocations.  Unfortuantely this also breaks
 		the strict time ordering between multiple device accesses.
 
+replay_rebase=int While replaying I/O patterns using read_iolog, the
+		default behavior is to replay the log as-is, even when
+		multiple threads are replaying the same log. This means
+		all threads are accessing the same sector on the device.
+		By specifying this option, each thread will be accessing
+		different sector by adding extra rebase offset. Offset is
+		simply given by "replay_rebase * internal thread number",
+		so IO access pattern itself is preserved.
+
 write_bw_log=str If given, write a bandwidth log of the jobs in this job
 		file. Can be used to store data of the bandwidth of the
 		jobs in their lifetime. The included fio_generate_plots
diff --git a/fio.1 b/fio.1
index ffc97c9..702e4e3 100644
--- a/fio.1
+++ b/fio.1
@@ -823,6 +823,15 @@ is to replay the IOPS onto the major/minor device that each IOP was recorded
 from.  Setting \fBreplay_redirect\fR causes all IOPS to be replayed onto the
 single specified device regardless of the device it was recorded from.
 .TP
+.BI replay_rebase \fR=\fPint
+While replaying I/O patterns using read_iolog, the default behavior
+is to replay the log as-is, even when multiple threads are replaying
+the same log. This means all threads are accessing the same sector
+on the device. By specifying this option, each thread will be accessing
+different sector by adding extra rebase offset. Offset is simply given
+by "replay_rebase * internal thread number", so IO access pattern itself
+is preserved.
+.TP
 .B write_bw_log \fR=\fPstr
 If given, write a bandwidth log of the jobs in this job file. Can be used to
 store data of the bandwidth of the jobs in their lifetime. The included
diff --git a/fio.h b/fio.h
index 6eb270d..b28e0ae 100644
--- a/fio.h
+++ b/fio.h
@@ -358,6 +358,7 @@ struct thread_options {
 	unsigned int gtod_offload;
 	enum fio_cs clocksource;
 	unsigned int no_stall;
+	unsigned int replay_rebase;
 	unsigned int trim_percentage;
 	unsigned int trim_batch;
 	unsigned int trim_zero;
diff --git a/log.c b/log.c
index f962864..57fc0f4 100644
--- a/log.c
+++ b/log.c
@@ -129,7 +129,7 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 
 		io_u->ddir = ipo->ddir;
 		if (ipo->ddir != DDIR_WAIT) {
-			io_u->offset = ipo->offset;
+			io_u->offset = ipo->offset + td->o.replay_rebase * td->thread_number;
 			io_u->buflen = ipo->len;
 			io_u->file = td->files[ipo->fileno];
 			get_file(io_u->file);
diff --git a/options.c b/options.c
index 74c24d0..aba14b1 100644
--- a/options.c
+++ b/options.c
@@ -1654,6 +1654,14 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "Replay all I/O onto this device, regardless of trace device",
 	},
 	{
+		.name	= "replay_rebase",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(replay_rebase),
+		.def	= "0",
+		.parent	= "read_iolog",
+		.help	= "Apply given offset for IO replay. Mainly for parallel replay.",
+	},
+	{
 		.name	= "exec_prerun",
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= td_var_offset(exec_prerun),


--------------080804000607020501000605--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


