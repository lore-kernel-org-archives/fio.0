Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8172C001DE
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 01:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjGTBbX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGTBbW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 21:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587482108
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 18:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAF19617CF
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 01:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EEEC433C8;
        Thu, 20 Jul 2023 01:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689816679;
        bh=wTLJ9UF9zEeOqr4q7LJcrdebCmQq+/teZyEUOdtsRVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC/JHX61XFHuXd16YPRg7+NqTu7lbmI8f4Nki50uN9kTN7px/vExlKpDK81Q2kMqv
         gknn1lrVCNATEc22N8nFhFwBqXJUUodKneHdfHRnyA44YZHCpj3EF0hAebkNKxiEGB
         BEtKJOh/da3NF0MLzhsuTWh6LeHvCaV2aWZ9C/AK8LeE0KbK/ROWiqmssQ0m0j1OvF
         Fz2kqX+GXcZBQ7ism65M1Zjoq5hT9Ou8aFotYp7I0lAdJhd+jsQiBgYnkpp4/SXe26
         OcQ5MTp3UTGbcAC87RS4a5K5PuTFt1wu5lHqu0rmglGwL6AKJUqdD7ipdOnhzsLLpr
         TQcx77fJ6ZqKg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 4/5] cmdprio: Add support for per I/O priority hint
Date:   Thu, 20 Jul 2023 10:31:13 +0900
Message-ID: <20230720013114.28158-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720013114.28158-1-dlemoal@kernel.org>
References: <20230720013114.28158-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Introduce the new option cmdprio_hint to allow specifying I/O priority
hints per IO with the iouring and libaio IO engines. A third acceptable
format for the cmdprio_bssplit option is also introduced to allow
specifying an IO hint in addition to a priority class and level.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 HOWTO.rst          | 28 +++++++++++++++++++++++-----
 engines/cmdprio.c  |  9 ++++++---
 engines/cmdprio.h  |  1 +
 engines/io_uring.c | 25 +++++++++++++++++++++++--
 engines/libaio.c   | 21 +++++++++++++++++++++
 fio.1              | 27 +++++++++++++++++++++++----
 options.c          | 13 ++++++++++---
 7 files changed, 107 insertions(+), 17 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 9b9472a8..a3b5bf2e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2275,6 +2275,16 @@ with the caveat that when used on the command line, they must come after the
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
@@ -2301,9 +2311,9 @@ with the caveat that when used on the command line, they must come after the
 
 		cmdprio_bssplit=blocksize/percentage:blocksize/percentage
 
-	In this case, each entry will use the priority class and priority
-	level defined by the options :option:`cmdprio_class` and
-	:option:`cmdprio` respectively.
+	In this case, each entry will use the priority class, priority hint
+	and priority level defined by the options :option:`cmdprio_class`,
+        :option:`cmdprio` and :option:`cmdprio_hint` respectively.
 
 	The second accepted format for this option is:
 
@@ -2314,7 +2324,14 @@ with the caveat that when used on the command line, they must come after the
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
 
@@ -3428,7 +3445,8 @@ Threads, processes and job synchronization
 
 	Set the I/O priority hint. This has effects only for devices with
 	features controlled through priority hints (e.g. block devices
-	supporting command duration limits).
+	supporting command duration limits). For per-I/O priority hint
+	setting, see the I/O engine specific :option:`cmdprio_hint` option.
 
 .. option:: cpus_allowed=str
 
diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index e6ff1fc2..153e3691 100644
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
-					  options->level[ddir], 0);
+					  options->level[ddir],
+					  options->hint[ddir]);
 		assign_clat_prio_index(prio, &values[ddir]);
 
 		ret = init_ts_clat_prio(ts, ddir, &values[ddir]);
@@ -400,7 +402,8 @@ static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
 			goto err;
 
 		implicit_cmdprio = ioprio_value(options->class[ddir],
-						options->level[ddir], 0);
+						options->level[ddir],
+						options->hint[ddir]);
 
 		ret = fio_cmdprio_generate_bsprio_desc(&cmdprio->bsprio_desc[ddir],
 						       &parse_res[ddir],
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 755da8d0..9b351828 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -39,6 +39,7 @@ struct cmdprio_options {
 	unsigned int percentage[CMDPRIO_RWDIR_CNT];
 	unsigned int class[CMDPRIO_RWDIR_CNT];
 	unsigned int level[CMDPRIO_RWDIR_CNT];
+	unsigned int hint[CMDPRIO_RWDIR_CNT];
 	char *bssplit_str;
 };
 
diff --git a/engines/io_uring.c b/engines/io_uring.c
index f30a3c00..d55af6bc 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -157,6 +157,21 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "cmdprio_hint",
+		.lname	= "Asynchronous I/O priority hint",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options,
+				   cmdprio_options.hint[DDIR_READ]),
+		.off2	= offsetof(struct ioring_options,
+				   cmdprio_options.hint[DDIR_WRITE]),
+		.help	= "Set asynchronous IO priority hint",
+		.minval	= IOPRIO_MIN_PRIO_HINT,
+		.maxval	= IOPRIO_MAX_PRIO_HINT,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= "cmdprio",
 		.lname	= "Asynchronous I/O priority level",
@@ -195,6 +210,12 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support I/O priority classes",
 	},
+	{
+		.name	= "cmdprio_hint",
+		.lname	= "Asynchronous I/O priority hint",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
 	{
 		.name	= "cmdprio",
 		.lname	= "Asynchronous I/O priority level",
@@ -365,8 +386,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
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
index 6a0745aa..c52d05fe 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -102,6 +102,21 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name	= "cmdprio_hint",
+		.lname	= "Asynchronous I/O priority hint",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct libaio_options,
+				   cmdprio_options.hint[DDIR_READ]),
+		.off2	= offsetof(struct libaio_options,
+				   cmdprio_options.hint[DDIR_WRITE]),
+		.help	= "Set asynchronous IO priority hint",
+		.minval	= IOPRIO_MIN_PRIO_HINT,
+		.maxval	= IOPRIO_MAX_PRIO_HINT,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
 	{
 		.name	= "cmdprio",
 		.lname	= "Asynchronous I/O priority level",
@@ -140,6 +155,12 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support I/O priority classes",
 	},
+	{
+		.name	= "cmdprio_hint",
+		.lname	= "Asynchronous I/O priority hint",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support I/O priority classes",
+	},
 	{
 		.name	= "cmdprio",
 		.lname	= "Asynchronous I/O priority level",
diff --git a/fio.1 b/fio.1
index 0f7ebc7f..c53cb27c 100644
--- a/fio.1
+++ b/fio.1
@@ -2072,6 +2072,14 @@ is set, this defaults to the highest priority class. A single value applies
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
@@ -2097,8 +2105,9 @@ The first accepted format for this option is the same as the format of the
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
@@ -2111,7 +2120,16 @@ entry. In comparison with the first accepted format, the second accepted format
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
@@ -3135,7 +3153,8 @@ priority setting, see the I/O engine specific `cmdprio_percentage` and
 .BI priohint \fR=\fPint
 Set the I/O priority hint. This has effects only for devices with
 features controlled through priority hints (e.g. block devices supporting
-command duration limits).
+command duration limits). For per-I/O priority hint setting, see the I/O
+engine specific \fBcmdprio_hint\fB option.
 .TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
diff --git a/options.c b/options.c
index 56672960..48aa0d7b 100644
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
-		entry->prio = ioprio_value(class, level, 0);
+		if (matches == 5)
+			hint = min(hint, (unsigned int) IOPRIO_MAX_PRIO_HINT);
+		else
+			hint = 0;
+		entry->prio = ioprio_value(class, level, hint);
 		break;
 	default:
 		log_err("fio: invalid cmdprio_bssplit format\n");
-- 
2.41.0

