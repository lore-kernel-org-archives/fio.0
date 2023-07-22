Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20E3EB64DC
	for <fio@archiver.kernel.org>; Sat, 22 Jul 2023 12:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjGVMA3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 22 Jul 2023 08:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjGVMA3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 22 Jul 2023 08:00:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8635C1722
        for <fio@vger.kernel.org>; Sat, 22 Jul 2023 05:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=C8EKY/LqWizUQWCMCMOWsvK7J2+cJswOxjTCwe7PXK0=; b=ga/pB5qtIrJr3icsUSjHMPicAv
        +Ot5+V1gS0ZZq4mFWbE3yBWQyJisXJoI55OE4ky++c4ApKEvVM/Cca/yUqJ2TMdBVMaW7vHJv/PGY
        GTGMpoVVbHCGi/Hafam71y0mJMi1K/45OuzXOYx5zG1L7nJaSz/BKNVvy3Tp9/nglbJWnQgIS/FeR
        ytr98Y4FT+PFFe7r2enhdtOZHHl/DkLIunauq/HYdANvZ6v9oerpSLw68XVaVCTb07YOTfQWVx2DY
        UE0vwKxYeAVxUq8fjQrMTkW2EOC6viVDmpG8q8Cb2ta1vHqJ+oxgDZmDcoWUIyIx4QMwvXglidzN3
        j16x4t5Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qNBHR-00207z-Tw
        for fio@vger.kernel.org; Sat, 22 Jul 2023 12:00:14 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 1DD511BC0186; Sat, 22 Jul 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230722120002.1DD511BC0186@kernel.dk>
Date:   Sat, 22 Jul 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit caf7ac7ef000097765b1c56404adb5e68b227977:

  t/zbd: add max_active configs to run-tests-against-nullb (2023-07-20 09:52:37 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0b47b2cf3dab1d26d72f52ed8c19f782a8277d3a:

  Merge branch 'prio-hints' (2023-07-21 15:23:40 -0600)

----------------------------------------------------------------
Damien Le Moal (6):
      os-linux: Cleanup IO priority class and value macros
      cmdprio: Introduce generic option definitions
      os-linux: add initial support for IO priority hints
      options: add priohint option
      cmdprio: Add support for per I/O priority hint
      stats: Add hint information to per priority level stats

Jens Axboe (1):
      Merge branch 'prio-hints'

Shin'ichiro Kawasaki (1):
      backend: clear IO_U_F_FLIGHT flag in zero byte read path

 HOWTO.rst          |  37 +++++++++++++++++--
 backend.c          |  11 ++++--
 cconv.c            |   2 +
 engines/cmdprio.c  |   9 +++--
 engines/cmdprio.h  | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 engines/io_uring.c |  86 ++-----------------------------------------
 engines/libaio.c   |  82 +----------------------------------------
 fio.1              |  33 +++++++++++++++--
 options.c          |  31 ++++++++++++++--
 os/os-dragonfly.h  |   4 +-
 os/os-linux.h      |  27 ++++++++++----
 os/os.h            |   7 +++-
 server.h           |   2 +-
 stat.c             |  10 +++--
 thread_options.h   |   3 +-
 15 files changed, 252 insertions(+), 198 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 7fe70fbd..ac8314f3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2287,6 +2287,16 @@ with the caveat that when used on the command line, they must come after the
 	reads and writes. See :manpage:`ionice(1)`. See also the
 	:option:`prioclass` option.
 
+.. option:: cmdprio_hint=int[,int] : [io_uring] [libaio]
+
+	Set the I/O priority hint to use for I/Os that must be issued with
+	a priority when :option:`cmdprio_percentage` or
+	:option:`cmdprio_bssplit` is set. If not specified when
+	:option:`cmdprio_percentage` or :option:`cmdprio_bssplit` is set,
+	this defaults to 0 (no hint). A single value applies to reads and
+	writes. Comma-separated values may be specified for reads and writes.
+	See also the :option:`priohint` option.
+
 .. option:: cmdprio=int[,int] : [io_uring] [libaio]
 
 	Set the I/O priority value to use for I/Os that must be issued with
@@ -2313,9 +2323,9 @@ with the caveat that when used on the command line, they must come after the
 
 		cmdprio_bssplit=blocksize/percentage:blocksize/percentage
 
-	In this case, each entry will use the priority class and priority
-	level defined by the options :option:`cmdprio_class` and
-	:option:`cmdprio` respectively.
+	In this case, each entry will use the priority class, priority hint
+	and priority level defined by the options :option:`cmdprio_class`,
+        :option:`cmdprio` and :option:`cmdprio_hint` respectively.
 
 	The second accepted format for this option is:
 
@@ -2326,7 +2336,14 @@ with the caveat that when used on the command line, they must come after the
 	accepted format does not restrict all entries to have the same priority
 	class and priority level.
 
-	For both formats, only the read and write data directions are supported,
+	The third accepted format for this option is:
+
+		cmdprio_bssplit=blocksize/percentage/class/level/hint:...
+
+	This is an extension of the second accepted format that allows to also
+	specify a priority hint.
+
+	For all formats, only the read and write data directions are supported,
 	values for trim IOs are ignored. This option is mutually exclusive with
 	the :option:`cmdprio_percentage` option.
 
@@ -3436,6 +3453,18 @@ Threads, processes and job synchronization
 	priority setting, see I/O engine specific :option:`cmdprio_percentage`
 	and :option:`cmdprio_class` options.
 
+.. option:: priohint=int
+
+	Set the I/O priority hint. This is only applicable to platforms that
+	support I/O priority classes and to devices with features controlled
+	through priority hints, e.g. block devices supporting command duration
+	limits, or CDL. CDL is a way to indicate the desired maximum latency
+	of I/Os so that the device can optimize its internal command scheduling
+	according to the latency limits indicated by the user.
+
+	For per-I/O priority hint setting, see the I/O engine specific
+	:option:`cmdprio_hint` option.
+
 .. option:: cpus_allowed=str
 
 	Controls the same options as :option:`cpumask`, but accepts a textual
diff --git a/backend.c b/backend.c
index b06a11a5..5f074039 100644
--- a/backend.c
+++ b/backend.c
@@ -466,7 +466,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 				if (!from_verify)
 					unlog_io_piece(td, io_u);
 				td_verror(td, EIO, "full resid");
-				put_io_u(td, io_u);
+				clear_io_u(td, io_u);
 				break;
 			}
 
@@ -1799,13 +1799,16 @@ static void *thread_main(void *data)
 
 	/* ioprio_set() has to be done before td_io_init() */
 	if (fio_option_is_set(o, ioprio) ||
-	    fio_option_is_set(o, ioprio_class)) {
-		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
+	    fio_option_is_set(o, ioprio_class) ||
+	    fio_option_is_set(o, ioprio_hint)) {
+		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class,
+				 o->ioprio, o->ioprio_hint);
 		if (ret == -1) {
 			td_verror(td, errno, "ioprio_set");
 			goto err;
 		}
-		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
+		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio,
+					  o->ioprio_hint);
 		td->ts.ioprio = td->ioprio;
 	}
 
diff --git a/cconv.c b/cconv.c
index 1bfa770f..ce6acbe6 100644
--- a/cconv.c
+++ b/cconv.c
@@ -281,6 +281,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->nice = le32_to_cpu(top->nice);
 	o->ioprio = le32_to_cpu(top->ioprio);
 	o->ioprio_class = le32_to_cpu(top->ioprio_class);
+	o->ioprio_hint = le32_to_cpu(top->ioprio_hint);
 	o->file_service_type = le32_to_cpu(top->file_service_type);
 	o->group_reporting = le32_to_cpu(top->group_reporting);
 	o->stats = le32_to_cpu(top->stats);
@@ -496,6 +497,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->nice = cpu_to_le32(o->nice);
 	top->ioprio = cpu_to_le32(o->ioprio);
 	top->ioprio_class = cpu_to_le32(o->ioprio_class);
+	top->ioprio_hint = cpu_to_le32(o->ioprio_hint);
 	top->file_service_type = cpu_to_le32(o->file_service_type);
 	top->group_reporting = cpu_to_le32(o->group_reporting);
 	top->stats = cpu_to_le32(o->stats);
diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 979a81b6..153e3691 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -267,7 +267,8 @@ static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u,
  * to be set. If the random percentage value is within the user specified
  * percentage of I/Os that should use a cmdprio priority value (rather than
  * the default priority), then this function updates the io_u with an ioprio
- * value as defined by the cmdprio/cmdprio_class or cmdprio_bssplit options.
+ * value as defined by the cmdprio/cmdprio_hint/cmdprio_class or
+ * cmdprio_bssplit options.
  *
  * Return true if the io_u ioprio was changed and false otherwise.
  */
@@ -342,7 +343,8 @@ static int fio_cmdprio_gen_perc(struct thread_data *td, struct cmdprio *cmdprio)
 		prio = &cmdprio->perc_entry[ddir];
 		prio->perc = options->percentage[ddir];
 		prio->prio = ioprio_value(options->class[ddir],
-					  options->level[ddir]);
+					  options->level[ddir],
+					  options->hint[ddir]);
 		assign_clat_prio_index(prio, &values[ddir]);
 
 		ret = init_ts_clat_prio(ts, ddir, &values[ddir]);
@@ -400,7 +402,8 @@ static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
 			goto err;
 
 		implicit_cmdprio = ioprio_value(options->class[ddir],
-						options->level[ddir]);
+						options->level[ddir],
+						options->hint[ddir]);
 
 		ret = fio_cmdprio_generate_bsprio_desc(&cmdprio->bsprio_desc[ddir],
 						       &parse_res[ddir],
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 755da8d0..81e6c390 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -7,6 +7,7 @@
 #define FIO_CMDPRIO_H
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 /* read and writes only, no trim */
 #define CMDPRIO_RWDIR_CNT 2
@@ -39,9 +40,114 @@ struct cmdprio_options {
 	unsigned int percentage[CMDPRIO_RWDIR_CNT];
 	unsigned int class[CMDPRIO_RWDIR_CNT];
 	unsigned int level[CMDPRIO_RWDIR_CNT];
+	unsigned int hint[CMDPRIO_RWDIR_CNT];
 	char *bssplit_str;
 };
 
+#ifdef FIO_HAVE_IOPRIO_CLASS
+#define CMDPRIO_OPTIONS(opt_struct, opt_group)					\
+	{									\
+		.name	= "cmdprio_percentage",					\
+		.lname	= "high priority percentage",				\
+		.type	= FIO_OPT_INT,						\
+		.off1	= offsetof(opt_struct,					\
+				   cmdprio_options.percentage[DDIR_READ]),	\
+		.off2	= offsetof(opt_struct,					\
+				   cmdprio_options.percentage[DDIR_WRITE]),	\
+		.minval	= 0,							\
+		.maxval	= 100,							\
+		.help	= "Send high priority I/O this percentage of the time",	\
+		.category = FIO_OPT_C_ENGINE,					\
+		.group	= opt_group,						\
+	},									\
+	{									\
+		.name	= "cmdprio_class",					\
+		.lname	= "Asynchronous I/O priority class",			\
+		.type	= FIO_OPT_INT,						\
+		.off1	= offsetof(opt_struct,					\
+				   cmdprio_options.class[DDIR_READ]),		\
+		.off2	= offsetof(opt_struct,					\
+				   cmdprio_options.class[DDIR_WRITE]),		\
+		.help	= "Set asynchronous IO priority class",			\
+		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,				\
+		.maxval	= IOPRIO_MAX_PRIO_CLASS,				\
+		.interval = 1,							\
+		.category = FIO_OPT_C_ENGINE,					\
+		.group	= opt_group,						\
+	},									\
+	{									\
+		.name	= "cmdprio_hint",					\
+		.lname	= "Asynchronous I/O priority hint",			\
+		.type	= FIO_OPT_INT,						\
+		.off1	= offsetof(opt_struct,					\
+				   cmdprio_options.hint[DDIR_READ]),		\
+		.off2	= offsetof(opt_struct,					\
+				   cmdprio_options.hint[DDIR_WRITE]),		\
+		.help	= "Set asynchronous IO priority hint",			\
+		.minval	= IOPRIO_MIN_PRIO_HINT,					\
+		.maxval	= IOPRIO_MAX_PRIO_HINT,					\
+		.interval = 1,							\
+		.category = FIO_OPT_C_ENGINE,					\
+		.group	= opt_group,						\
+	},									\
+	{									\
+		.name	= "cmdprio",						\
+		.lname	= "Asynchronous I/O priority level",			\
+		.type	= FIO_OPT_INT,						\
+		.off1	= offsetof(opt_struct,					\
+				   cmdprio_options.level[DDIR_READ]),		\
+		.off2	= offsetof(opt_struct,					\
+				   cmdprio_options.level[DDIR_WRITE]),		\
+		.help	= "Set asynchronous IO priority level",			\
+		.minval	= IOPRIO_MIN_PRIO,					\
+		.maxval	= IOPRIO_MAX_PRIO,					\
+		.interval = 1,							\
+		.category = FIO_OPT_C_ENGINE,					\
+		.group	= opt_group,						\
+	},									\
+	{									\
+		.name   = "cmdprio_bssplit",					\
+		.lname  = "Priority percentage block size split",		\
+		.type   = FIO_OPT_STR_STORE,					\
+		.off1   = offsetof(opt_struct, cmdprio_options.bssplit_str),	\
+		.help   = "Set priority percentages for different block sizes",	\
+		.category = FIO_OPT_C_ENGINE,					\
+		.group	= opt_group,						\
+	}
+#else
+#define CMDPRIO_OPTIONS(opt_struct, opt_group)					\
+	{									\
+		.name	= "cmdprio_percentage",					\
+		.lname	= "high priority percentage",				\
+		.type	= FIO_OPT_UNSUPPORTED,					\
+		.help	= "Platform does not support I/O priority classes",	\
+	},									\
+	{									\
+		.name	= "cmdprio_class",					\
+		.lname	= "Asynchronous I/O priority class",			\
+		.type	= FIO_OPT_UNSUPPORTED,					\
+		.help	= "Platform does not support I/O priority classes",	\
+	},									\
+	{									\
+		.name	= "cmdprio_hint",					\
+		.lname	= "Asynchronous I/O priority hint",			\
+		.type	= FIO_OPT_UNSUPPORTED,					\
+		.help	= "Platform does not support I/O priority classes",	\
+	},									\
+	{									\
+		.name	= "cmdprio",						\
+		.lname	= "Asynchronous I/O priority level",			\
+		.type	= FIO_OPT_UNSUPPORTED,					\
+		.help	= "Platform does not support I/O priority classes",	\
+	},									\
+	{									\
+		.name   = "cmdprio_bssplit",					\
+		.lname  = "Priority percentage block size split",		\
+		.type	= FIO_OPT_UNSUPPORTED,					\
+		.help	= "Platform does not support I/O priority classes",	\
+	}
+#endif
+
 struct cmdprio {
 	struct cmdprio_options *options;
 	struct cmdprio_prio perc_entry[CMDPRIO_RWDIR_CNT];
diff --git a/engines/io_uring.c b/engines/io_uring.c
index f30a3c00..e1abf688 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -127,87 +127,6 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
-#ifdef FIO_HAVE_IOPRIO_CLASS
-	{
-		.name	= "cmdprio_percentage",
-		.lname	= "high priority percentage",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct ioring_options,
-				   cmdprio_options.percentage[DDIR_READ]),
-		.off2	= offsetof(struct ioring_options,
-				   cmdprio_options.percentage[DDIR_WRITE]),
-		.minval	= 0,
-		.maxval	= 100,
-		.help	= "Send high priority I/O this percentage of the time",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_IOURING,
-	},
-	{
-		.name	= "cmdprio_class",
-		.lname	= "Asynchronous I/O priority class",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct ioring_options,
-				   cmdprio_options.class[DDIR_READ]),
-		.off2	= offsetof(struct ioring_options,
-				   cmdprio_options.class[DDIR_WRITE]),
-		.help	= "Set asynchronous IO priority class",
-		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
-		.maxval	= IOPRIO_MAX_PRIO_CLASS,
-		.interval = 1,
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_IOURING,
-	},
-	{
-		.name	= "cmdprio",
-		.lname	= "Asynchronous I/O priority level",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct ioring_options,
-				   cmdprio_options.level[DDIR_READ]),
-		.off2	= offsetof(struct ioring_options,
-				   cmdprio_options.level[DDIR_WRITE]),
-		.help	= "Set asynchronous IO priority level",
-		.minval	= IOPRIO_MIN_PRIO,
-		.maxval	= IOPRIO_MAX_PRIO,
-		.interval = 1,
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_IOURING,
-	},
-	{
-		.name   = "cmdprio_bssplit",
-		.lname  = "Priority percentage block size split",
-		.type   = FIO_OPT_STR_STORE,
-		.off1   = offsetof(struct ioring_options,
-				   cmdprio_options.bssplit_str),
-		.help   = "Set priority percentages for different block sizes",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_IOURING,
-	},
-#else
-	{
-		.name	= "cmdprio_percentage",
-		.lname	= "high priority percentage",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support I/O priority classes",
-	},
-	{
-		.name	= "cmdprio_class",
-		.lname	= "Asynchronous I/O priority class",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support I/O priority classes",
-	},
-	{
-		.name	= "cmdprio",
-		.lname	= "Asynchronous I/O priority level",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support I/O priority classes",
-	},
-	{
-		.name   = "cmdprio_bssplit",
-		.lname  = "Priority percentage block size split",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support I/O priority classes",
-	},
-#endif
 	{
 		.name	= "fixedbufs",
 		.lname	= "Fixed (pre-mapped) IO buffers",
@@ -297,6 +216,7 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	CMDPRIO_OPTIONS(struct ioring_options, FIO_OPT_G_IOURING),
 	{
 		.name	= NULL,
 	},
@@ -365,8 +285,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		/*
 		 * Since io_uring can have a submission context (sqthread_poll)
 		 * that is different from the process context, we cannot rely on
-		 * the IO priority set by ioprio_set() (option prio/prioclass)
-		 * to be inherited.
+		 * the IO priority set by ioprio_set() (options prio, prioclass,
+		 * and priohint) to be inherited.
 		 * td->ioprio will have the value of the "default prio", so set
 		 * this unconditionally. This value might get overridden by
 		 * fio_ioring_cmdprio_prep() if the option cmdprio_percentage or
diff --git a/engines/libaio.c b/engines/libaio.c
index 6a0745aa..aaccc7ce 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -72,87 +72,6 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
-#ifdef FIO_HAVE_IOPRIO_CLASS
-	{
-		.name	= "cmdprio_percentage",
-		.lname	= "high priority percentage",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct libaio_options,
-				   cmdprio_options.percentage[DDIR_READ]),
-		.off2	= offsetof(struct libaio_options,
-				   cmdprio_options.percentage[DDIR_WRITE]),
-		.minval	= 0,
-		.maxval	= 100,
-		.help	= "Send high priority I/O this percentage of the time",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
-	},
-	{
-		.name	= "cmdprio_class",
-		.lname	= "Asynchronous I/O priority class",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct libaio_options,
-				   cmdprio_options.class[DDIR_READ]),
-		.off2	= offsetof(struct libaio_options,
-				   cmdprio_options.class[DDIR_WRITE]),
-		.help	= "Set asynchronous IO priority class",
-		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
-		.maxval	= IOPRIO_MAX_PRIO_CLASS,
-		.interval = 1,
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
-	},
-	{
-		.name	= "cmdprio",
-		.lname	= "Asynchronous I/O priority level",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct libaio_options,
-				   cmdprio_options.level[DDIR_READ]),
-		.off2	= offsetof(struct libaio_options,
-				   cmdprio_options.level[DDIR_WRITE]),
-		.help	= "Set asynchronous IO priority level",
-		.minval	= IOPRIO_MIN_PRIO,
-		.maxval	= IOPRIO_MAX_PRIO,
-		.interval = 1,
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
-	},
-	{
-		.name   = "cmdprio_bssplit",
-		.lname  = "Priority percentage block size split",
-		.type   = FIO_OPT_STR_STORE,
-		.off1   = offsetof(struct libaio_options,
-				   cmdprio_options.bssplit_str),
-		.help   = "Set priority percentages for different block sizes",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
-	},
-#else
-	{
-		.name	= "cmdprio_percentage",
-		.lname	= "high priority percentage",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support I/O priority classes",
-	},
-	{
-		.name	= "cmdprio_class",
-		.lname	= "Asynchronous I/O priority class",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support I/O priority classes",
-	},
-	{
-		.name	= "cmdprio",
-		.lname	= "Asynchronous I/O priority level",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support I/O priority classes",
-	},
-	{
-		.name   = "cmdprio_bssplit",
-		.lname  = "Priority percentage block size split",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support I/O priority classes",
-	},
-#endif
 	{
 		.name	= "nowait",
 		.lname	= "RWF_NOWAIT",
@@ -162,6 +81,7 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+	CMDPRIO_OPTIONS(struct libaio_options, FIO_OPT_G_LIBAIO),
 	{
 		.name	= NULL,
 	},
diff --git a/fio.1 b/fio.1
index 20acd081..f62617e7 100644
--- a/fio.1
+++ b/fio.1
@@ -2084,6 +2084,14 @@ is set, this defaults to the highest priority class. A single value applies
 to reads and writes. Comma-separated values may be specified for reads and
 writes. See man \fBionice\fR\|(1). See also the \fBprioclass\fR option.
 .TP
+.BI (io_uring,libaio)cmdprio_hint \fR=\fPint[,int]
+Set the I/O priority hint to use for I/Os that must be issued with a
+priority when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR is set.
+If not specified when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR
+is set, this defaults to 0 (no hint). A single value applies to reads and
+writes. Comma-separated values may be specified for reads and writes.
+See also the \fBpriohint\fR option.
+.TP
 .BI (io_uring,libaio)cmdprio \fR=\fPint[,int]
 Set the I/O priority value to use for I/Os that must be issued with a
 priority when \fBcmdprio_percentage\fR or \fBcmdprio_bssplit\fR is set.
@@ -2109,8 +2117,9 @@ The first accepted format for this option is the same as the format of the
 cmdprio_bssplit=blocksize/percentage:blocksize/percentage
 .RE
 .P
-In this case, each entry will use the priority class and priority level defined
-by the options \fBcmdprio_class\fR and \fBcmdprio\fR respectively.
+In this case, each entry will use the priority class, priority hint and
+priority level defined by the options \fBcmdprio_class\fR, \fBcmdprio\fR
+and \fBcmdprio_hint\fR respectively.
 .P
 The second accepted format for this option is:
 .RS
@@ -2123,7 +2132,16 @@ entry. In comparison with the first accepted format, the second accepted format
 does not restrict all entries to have the same priority class and priority
 level.
 .P
-For both formats, only the read and write data directions are supported, values
+The third accepted format for this option is:
+.RS
+.P
+cmdprio_bssplit=blocksize/percentage/class/level/hint:...
+.RE
+.P
+This is an extension of the second accepted format that allows to also
+specify a priority hint.
+.P
+For all formats, only the read and write data directions are supported, values
 for trim IOs are ignored. This option is mutually exclusive with the
 \fBcmdprio_percentage\fR option.
 .RE
@@ -3144,6 +3162,15 @@ Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
 priority setting, see the I/O engine specific `cmdprio_percentage` and
 `cmdprio_class` options.
 .TP
+.BI priohint \fR=\fPint
+Set the I/O priority hint. This is only applicable to platforms that support
+I/O priority classes and to devices with features controlled through priority
+hints, e.g. block devices supporting command duration limits, or CDL. CDL is a
+way to indicate the desired maximum latency of I/Os so that the device can
+optimize its internal command scheduling according to the latency limits
+indicated by the user. For per-I/O priority hint setting, see the I/O engine
+specific \fBcmdprio_hint\fB option.
+.TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
 specification of the permitted CPUs instead and CPUs are indexed from 0. So
diff --git a/options.c b/options.c
index 0f739317..48aa0d7b 100644
--- a/options.c
+++ b/options.c
@@ -313,15 +313,17 @@ static int parse_cmdprio_bssplit_entry(struct thread_options *o,
 	int matches = 0;
 	char *bs_str = NULL;
 	long long bs_val;
-	unsigned int perc = 0, class, level;
+	unsigned int perc = 0, class, level, hint;
 
 	/*
 	 * valid entry formats:
 	 * bs/ - %s/ - set perc to 0, prio to -1.
 	 * bs/perc - %s/%u - set prio to -1.
 	 * bs/perc/class/level - %s/%u/%u/%u
+	 * bs/perc/class/level/hint - %s/%u/%u/%u/%u
 	 */
-	matches = sscanf(str, "%m[^/]/%u/%u/%u", &bs_str, &perc, &class, &level);
+	matches = sscanf(str, "%m[^/]/%u/%u/%u/%u",
+			 &bs_str, &perc, &class, &level, &hint);
 	if (matches < 1) {
 		log_err("fio: invalid cmdprio_bssplit format\n");
 		return 1;
@@ -342,9 +344,14 @@ static int parse_cmdprio_bssplit_entry(struct thread_options *o,
 	case 2: /* bs/perc case */
 		break;
 	case 4: /* bs/perc/class/level case */
+	case 5: /* bs/perc/class/level/hint case */
 		class = min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
 		level = min(level, (unsigned int) IOPRIO_MAX_PRIO);
-		entry->prio = ioprio_value(class, level);
+		if (matches == 5)
+			hint = min(hint, (unsigned int) IOPRIO_MAX_PRIO_HINT);
+		else
+			hint = 0;
+		entry->prio = ioprio_value(class, level, hint);
 		break;
 	default:
 		log_err("fio: invalid cmdprio_bssplit format\n");
@@ -3806,6 +3813,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
 	},
+	{
+		.name	= "priohint",
+		.lname	= "I/O nice priority hint",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, ioprio_hint),
+		.help	= "Set job IO priority hint",
+		.minval	= IOPRIO_MIN_PRIO_HINT,
+		.maxval	= IOPRIO_MAX_PRIO_HINT,
+		.interval = 1,
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_CRED,
+	},
 #else
 	{
 		.name	= "prioclass",
@@ -3813,6 +3832,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support IO priority classes",
 	},
+	{
+		.name	= "priohint",
+		.lname	= "I/O nice priority hint",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support IO priority hints",
+	},
 #endif
 	{
 		.name	= "thinktime",
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index bde39101..4ce72539 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -171,8 +171,8 @@ static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
  * ioprio_set() with 4 arguments, so define fio's ioprio_set() as a macro.
  * Note that there is no idea of class within ioprio_set(2) unlike Linux.
  */
-#define ioprio_value(ioprio_class, ioprio)	(ioprio)
-#define ioprio_set(which, who, ioprio_class, ioprio)	\
+#define ioprio_value(ioprio_class, ioprio, ioprio_hint)	(ioprio)
+#define ioprio_set(which, who, ioprio_class, ioprio, ioprio_hint)	\
 	ioprio_set(which, who, ioprio)
 
 #define ioprio(ioprio)		(ioprio)
diff --git a/os/os-linux.h b/os/os-linux.h
index 2f9f7e79..c5cd6515 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -125,13 +125,24 @@ enum {
 #define IOPRIO_BITS		16
 #define IOPRIO_CLASS_SHIFT	13
 
+#define IOPRIO_HINT_BITS	10
+#define IOPRIO_HINT_SHIFT	3
+
 #define IOPRIO_MIN_PRIO		0	/* highest priority */
 #define IOPRIO_MAX_PRIO		7	/* lowest priority */
 
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
 
-static inline int ioprio_value(int ioprio_class, int ioprio)
+#define IOPRIO_MIN_PRIO_HINT	0
+#define IOPRIO_MAX_PRIO_HINT	((1 << IOPRIO_HINT_BITS) - 1)
+
+#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
+#define ioprio(ioprio)		((ioprio) & IOPRIO_MAX_PRIO)
+#define ioprio_hint(ioprio)	\
+	(((ioprio) >> IOPRIO_HINT_SHIFT) & IOPRIO_MAX_PRIO_HINT)
+
+static inline int ioprio_value(int ioprio_class, int ioprio, int ioprio_hint)
 {
 	/*
 	 * If no class is set, assume BE
@@ -139,23 +150,23 @@ static inline int ioprio_value(int ioprio_class, int ioprio)
         if (!ioprio_class)
                 ioprio_class = IOPRIO_CLASS_BE;
 
-	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) |
+		(ioprio_hint << IOPRIO_HINT_SHIFT) |
+		ioprio;
 }
 
 static inline bool ioprio_value_is_class_rt(unsigned int priority)
 {
-	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
+	return ioprio_class(priority) == IOPRIO_CLASS_RT;
 }
 
-static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio,
+			     int ioprio_hint)
 {
 	return syscall(__NR_ioprio_set, which, who,
-		       ioprio_value(ioprio_class, ioprio));
+		       ioprio_value(ioprio_class, ioprio, ioprio_hint));
 }
 
-#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
-#define ioprio(ioprio)		((ioprio) & 7)
-
 #ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
diff --git a/os/os.h b/os/os.h
index 036fc233..0f182324 100644
--- a/os/os.h
+++ b/os/os.h
@@ -120,11 +120,14 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #define ioprio_value_is_class_rt(prio)	(false)
 #define IOPRIO_MIN_PRIO_CLASS		0
 #define IOPRIO_MAX_PRIO_CLASS		0
+#define ioprio_hint(prio)		0
+#define IOPRIO_MIN_PRIO_HINT		0
+#define IOPRIO_MAX_PRIO_HINT		0
 #endif
 #ifndef FIO_HAVE_IOPRIO
-#define ioprio_value(prioclass, prio)	(0)
+#define ioprio_value(prioclass, prio, priohint)	(0)
 #define ioprio(ioprio)			0
-#define ioprio_set(which, who, prioclass, prio)	(0)
+#define ioprio_set(which, who, prioclass, prio, priohint) (0)
 #define IOPRIO_MIN_PRIO			0
 #define IOPRIO_MAX_PRIO			0
 #endif
diff --git a/server.h b/server.h
index 601d3340..ad706118 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 100,
+	FIO_SERVER_VER			= 101,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 7fad73d1..7b791628 100644
--- a/stat.c
+++ b/stat.c
@@ -597,10 +597,11 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 				continue;
 
 			snprintf(buf, sizeof(buf),
-				 "%s prio %u/%u",
+				 "%s prio %u/%u/%u",
 				 clat_type,
 				 ioprio_class(ts->clat_prio[ddir][i].ioprio),
-				 ioprio(ts->clat_prio[ddir][i].ioprio));
+				 ioprio(ts->clat_prio[ddir][i].ioprio),
+				 ioprio_hint(ts->clat_prio[ddir][i].ioprio));
 			display_lat(buf, min, max, mean, dev, out);
 		}
 	}
@@ -640,10 +641,11 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 					continue;
 
 				snprintf(prio_name, sizeof(prio_name),
-					 "%s prio %u/%u (%.2f%% of IOs)",
+					 "%s prio %u/%u/%u (%.2f%% of IOs)",
 					 clat_type,
 					 ioprio_class(ts->clat_prio[ddir][i].ioprio),
 					 ioprio(ts->clat_prio[ddir][i].ioprio),
+					 ioprio_hint(ts->clat_prio[ddir][i].ioprio),
 					 100. * (double) prio_samples / (double) samples);
 				show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
 						prio_samples, ts->percentile_list,
@@ -1533,6 +1535,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 				ioprio_class(ts->clat_prio[ddir][i].ioprio));
 			json_object_add_value_int(obj, "prio",
 				ioprio(ts->clat_prio[ddir][i].ioprio));
+			json_object_add_value_int(obj, "priohint",
+				ioprio_hint(ts->clat_prio[ddir][i].ioprio));
 
 			tmp_object = add_ddir_lat_json(ts,
 					ts->clat_percentiles | ts->lat_percentiles,
diff --git a/thread_options.h b/thread_options.h
index 1715b36c..38a9993d 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -248,6 +248,7 @@ struct thread_options {
 	unsigned int nice;
 	unsigned int ioprio;
 	unsigned int ioprio_class;
+	unsigned int ioprio_hint;
 	unsigned int file_service_type;
 	unsigned int group_reporting;
 	unsigned int stats;
@@ -568,6 +569,7 @@ struct thread_options_pack {
 	uint32_t nice;
 	uint32_t ioprio;
 	uint32_t ioprio_class;
+	uint32_t ioprio_hint;
 	uint32_t file_service_type;
 	uint32_t group_reporting;
 	uint32_t stats;
@@ -601,7 +603,6 @@ struct thread_options_pack {
 	uint32_t lat_percentiles;
 	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad5;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
