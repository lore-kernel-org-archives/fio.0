Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbgHOVwM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Aug 2020 17:52:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CA1C02B8EB
        for <fio@vger.kernel.org>; Sat, 15 Aug 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k6uqy-0002ie-Hz
        for fio@vger.kernel.org; Sat, 15 Aug 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200815120001.5AAE31BC0162@kernel.dk>
Date: Sat, 15 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5c79c32f6afb39fae910912475e8fea786c3353e:

  zbd: use ->min_zone, ->max_zone in more places (2020-08-13 16:06:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0ce7e3e584be6f4f834fb2fec8e52deb23e1dd12:

  Merge branch 'issue-1065' of https://github.com/XeS0r/fio into master (2020-08-14 16:02:37 -0700)

----------------------------------------------------------------
Andr�� Wild (1):
      thread_options: Use unsigned int type for exit_what and stonewall

Jens Axboe (2):
      Fixup examples/exitwhat.fio
      Merge branch 'issue-1065' of https://github.com/XeS0r/fio into master

 cconv.c               |  8 ++++----
 examples/exitwhat.fio |  8 ++++----
 fio.1                 | 29 +++++++++++++++++++++--------
 server.h              |  2 +-
 thread_options.h      |  9 ++++-----
 5 files changed, 34 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index 2469389b..4b0c3490 100644
--- a/cconv.c
+++ b/cconv.c
@@ -237,8 +237,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->loops = le32_to_cpu(top->loops);
 	o->mem_type = le32_to_cpu(top->mem_type);
 	o->mem_align = le32_to_cpu(top->mem_align);
-	o->exit_what = le16_to_cpu(top->exit_what);
-	o->stonewall = le16_to_cpu(top->stonewall);
+	o->exit_what = le32_to_cpu(top->exit_what);
+	o->stonewall = le32_to_cpu(top->stonewall);
 	o->new_group = le32_to_cpu(top->new_group);
 	o->numjobs = le32_to_cpu(top->numjobs);
 	o->cpus_allowed_policy = le32_to_cpu(top->cpus_allowed_policy);
@@ -437,8 +437,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->loops = cpu_to_le32(o->loops);
 	top->mem_type = cpu_to_le32(o->mem_type);
 	top->mem_align = cpu_to_le32(o->mem_align);
-	top->exit_what = cpu_to_le16(o->exit_what);
-	top->stonewall = cpu_to_le16(o->stonewall);
+	top->exit_what = cpu_to_le32(o->exit_what);
+	top->stonewall = cpu_to_le32(o->stonewall);
 	top->new_group = cpu_to_le32(o->new_group);
 	top->numjobs = cpu_to_le32(o->numjobs);
 	top->cpus_allowed_policy = cpu_to_le32(o->cpus_allowed_policy);
diff --git a/examples/exitwhat.fio b/examples/exitwhat.fio
index a1099f0f..c91d7375 100644
--- a/examples/exitwhat.fio
+++ b/examples/exitwhat.fio
@@ -1,7 +1,7 @@
 # We want to run fast1 as long as slow1 is running, but also have a cumulative
 # report of fast1 (group_reporting=1/new_group=1).  exitall=1 would not cause
 # fast1 to stop after slow1 is done. Setting exit_what=stonewall will cause
-# alls jobs up until the next stonewall=1 setting to be stopped, when job slow1
+# alls jobs up until the next stonewall setting to be stopped, when job slow1
 # finishes.
 # In this example skipping forward to slow2/fast2. slow2 has exit_what=all set,
 # which means all jobs will be cancelled when slow2 finishes. In particular,
@@ -15,7 +15,7 @@ group_reporting=1
 exitall=1
 
 [slow1]
-rw=r
+rw=read
 numjobs=1
 ioengine=sync
 new_group=1
@@ -32,8 +32,8 @@ iodepth=32
 rate=300,300,300
 
 [slow2]
-stonewall=1
-rw=w
+stonewall
+rw=write
 numjobs=1
 ioengine=sync
 new_group=1
diff --git a/fio.1 b/fio.1
index cdd105d7..1c90e4a5 100644
--- a/fio.1
+++ b/fio.1
@@ -2569,7 +2569,8 @@ been exceeded before retrying operations.
 Wait for preceding jobs in the job file to exit, before starting this
 one. Can be used to insert serialization points in the job file. A stone
 wall also implies starting a new reporting group, see
-\fBgroup_reporting\fR.
+\fBgroup_reporting\fR. Optionally you can use `stonewall=0` to disable or
+`stonewall=1` to enable it.
 .TP
 .BI exitall
 By default, fio will continue running all other jobs when one job finishes.
@@ -2577,15 +2578,27 @@ Sometimes this is not the desired action. Setting \fBexitall\fR will instead
 make fio terminate all jobs in the same group, as soon as one job of that
 group finishes.
 .TP
-.BI exit_what
+.BI exit_what \fR=\fPstr
 By default, fio will continue running all other jobs when one job finishes.
-Sometimes this is not the desired action. Setting \fBexit_all\fR will instead
+Sometimes this is not the desired action. Setting \fBexitall\fR will instead
 make fio terminate all jobs in the same group. The option \fBexit_what\fR
-allows to control which jobs get terminated when \fBexitall\fR is enabled. The
-default is \fBgroup\fR and does not change the behaviour of \fBexitall\fR. The
-setting \fBall\fR terminates all jobs. The setting \fBstonewall\fR terminates
-all currently running jobs across all groups and continues execution with the
-next stonewalled group.
+allows you to control which jobs get terminated when \fBexitall\fR is enabled.
+The default value is \fBgroup\fR.
+The allowed values are:
+.RS
+.RS
+.TP
+.B all
+terminates all jobs.
+.TP
+.B group
+is the default and does not change the behaviour of \fBexitall\fR.
+.TP
+.B stonewall
+terminates all currently running jobs across all groups and continues
+execution with the next stonewalled group.
+.RE
+.RE
 .TP
 .BI exec_prerun \fR=\fPstr
 Before running this job, issue the command specified through
diff --git a/server.h b/server.h
index de01a5c8..efa70e7c 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 83,
+	FIO_SERVER_VER			= 84,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 3fe48ecc..14f1cbe9 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -202,8 +202,8 @@ struct thread_options {
 
 	unsigned long long max_latency;
 
-	unsigned short exit_what;
-	unsigned short stonewall;
+	unsigned int exit_what;
+	unsigned int stonewall;
 	unsigned int new_group;
 	unsigned int numjobs;
 	os_cpu_mask_t cpumask;
@@ -494,8 +494,8 @@ struct thread_options_pack {
 	uint32_t mem_type;
 	uint32_t mem_align;
 
-	uint16_t exit_what;
-	uint16_t stonewall;
+	uint32_t exit_what;
+	uint32_t stonewall;
 	uint32_t new_group;
 	uint32_t numjobs;
 	/*
@@ -546,7 +546,6 @@ struct thread_options_pack {
 	uint32_t lat_percentiles;
 	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad3;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];

