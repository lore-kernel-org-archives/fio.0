Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD57C433F5
	for <fio@archiver.kernel.org>; Sat, 13 Nov 2021 13:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F9DB60ED7
	for <fio@archiver.kernel.org>; Sat, 13 Nov 2021 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhKMNDA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 13 Nov 2021 08:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbhKMNDA (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 13 Nov 2021 08:03:00 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0378C061766
        for <fio@vger.kernel.org>; Sat, 13 Nov 2021 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=0yMdBQLS7nD+b2ZZjNpGU1+7z1YCoLJYVsl3u0mu1a0=; b=Z1lfSRmKVUNDadyVWVRibby12D
        +SdFwEPyzeOyH7V+wHGO/HaRit4Oeif0CItkXm3pwy2KvtW+T08iLoKEIQalGCV5E30L9lZbNhBeC
        9mAzVardEf0P1xYrz9aOjmqJhP5kF0xDwhvNOQdnalNQSCDxL9QDeJNL/S1HOSYP9Iv35gJbHBswn
        xDqXO4Ut3hEDr0oTGi90T4oD153NBtnC1ZyD+JvYbWwWPxwZHAxLRfpQjle6RKud/zDL/ONBxBtaM
        lNI3Psf+mdfDvvXmz68KN7mtyIHYbWvKkZvRtDUdczxHVU/yr/UehU8ZYW8hew8nFptu4FmsokttG
        ZDIjjgHQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlsdY-00Foap-PW
        for fio@vger.kernel.org; Sat, 13 Nov 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C48661BC0139; Sat, 13 Nov 2021 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211113130001.C48661BC0139@kernel.dk>
Date:   Sat, 13 Nov 2021 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6619fc32c413c4ff3a24c819037fb9227af3f876:

  stat: create a init_thread_stat_min_vals() helper (2021-11-08 06:24:48 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f7c3f31db877d30056d19761e48499f5b0bfa0b6:

  Merge branch 'jf_readme_typo' of https://github.com/jfpanisset/fio (2021-11-12 09:22:21 -0700)

----------------------------------------------------------------
Jean-Francois Panisset (1):
      Small typo fix

Jens Axboe (1):
      Merge branch 'jf_readme_typo' of https://github.com/jfpanisset/fio

Niklas Cassel (8):
      docs: update cmdprio_percentage documentation
      cmdprio: move cmdprio function definitions to a new cmdprio.c file
      cmdprio: do not allocate memory for unused data direction
      io_uring: set async IO priority to td->ioprio in fio_ioring_prep()
      libaio,io_uring: rename prio_prep() to include cmdprio in the name
      libaio,io_uring: move common cmdprio_prep() code to cmdprio
      cmdprio: add mode to make the logic easier to reason about
      libaio,io_uring: make it possible to cleanup cmdprio malloced data

 HOWTO              |   5 +-
 Makefile           |   6 ++
 README             |   2 +-
 engines/cmdprio.c  | 243 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 engines/cmdprio.h  | 150 ++++++---------------------------
 engines/io_uring.c | 100 ++++++++--------------
 engines/libaio.c   |  72 +++++-----------
 fio.1              |   3 +-
 8 files changed, 333 insertions(+), 248 deletions(-)
 create mode 100644 engines/cmdprio.c

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 297a0485..196bca6c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2167,9 +2167,8 @@ with the caveat that when used on the command line, they must come after the
 
     Set the percentage of I/O that will be issued with the highest priority.
     Default: 0. A single value applies to reads and writes. Comma-separated
-    values may be specified for reads and writes. This option cannot be used
-    with the :option:`prio` or :option:`prioclass` options. For this option
-    to be effective, NCQ priority must be supported and enabled, and `direct=1'
+    values may be specified for reads and writes. For this option to be
+    effective, NCQ priority must be supported and enabled, and `direct=1'
     option must be used. fio must also be run as the root user.
 
 .. option:: cmdprio_class=int[,int] : [io_uring] [libaio]
diff --git a/Makefile b/Makefile
index 4ae5a371..e9028dce 100644
--- a/Makefile
+++ b/Makefile
@@ -98,6 +98,7 @@ else ifdef CONFIG_32BIT
 endif
 ifdef CONFIG_LIBAIO
   libaio_SRCS = engines/libaio.c
+  cmdprio_SRCS = engines/cmdprio.c
   libaio_LIBS = -laio
   ENGINES += libaio
 endif
@@ -225,6 +226,7 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c
+  cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
 endif
@@ -281,6 +283,10 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   FIO_CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
 endif
 
+ifdef cmdprio_SRCS
+  SOURCE += $(cmdprio_SRCS)
+endif
+
 ifdef CONFIG_DYNAMIC_ENGINES
  DYNAMIC_ENGS := $(ENGINES)
 define engine_template =
diff --git a/README b/README
index 52eca5c3..d566fae3 100644
--- a/README
+++ b/README
@@ -10,7 +10,7 @@ tailored test case again and again.
 
 A test work load is difficult to define, though. There can be any number of
 processes or threads involved, and they can each be using their own way of
-generating I/O. You could have someone dirtying large amounts of memory in an
+generating I/O. You could have someone dirtying large amounts of memory in a
 memory mapped file, or maybe several threads issuing reads using asynchronous
 I/O. fio needed to be flexible enough to simulate both of these cases, and many
 more.
diff --git a/engines/cmdprio.c b/engines/cmdprio.c
new file mode 100644
index 00000000..92b752ae
--- /dev/null
+++ b/engines/cmdprio.c
@@ -0,0 +1,243 @@
+/*
+ * IO priority handling helper functions common to the libaio and io_uring
+ * engines.
+ */
+
+#include "cmdprio.h"
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
+int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
+			      struct cmdprio *cmdprio)
+{
+	char *str, *p;
+	int ret = 0;
+
+	p = str = strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio,
+			      false);
+
+	free(p);
+	return ret;
+}
+
+static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
+{
+	enum fio_ddir ddir = io_u->ddir;
+	struct cmdprio_options *options = cmdprio->options;
+	int i;
+
+	switch (cmdprio->mode) {
+	case CMDPRIO_MODE_PERC:
+		return options->percentage[ddir];
+	case CMDPRIO_MODE_BSSPLIT:
+		for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
+			if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
+				return cmdprio->bssplit[ddir][i].perc;
+		}
+		break;
+	default:
+		/*
+		 * An I/O engine should never call this function if cmdprio
+		 * is not is use.
+		 */
+		assert(0);
+	}
+
+	return 0;
+}
+
+/**
+ * fio_cmdprio_set_ioprio - Set an io_u ioprio according to cmdprio options
+ *
+ * Generates a random percentage value to determine if an io_u ioprio needs
+ * to be set. If the random percentage value is within the user specified
+ * percentage of I/Os that should use a cmdprio priority value (rather than
+ * the default priority), then this function updates the io_u with an ioprio
+ * value as defined by the cmdprio/cmdprio_class or cmdprio_bssplit options.
+ *
+ * Return true if the io_u ioprio was changed and false otherwise.
+ */
+bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
+			    struct io_u *io_u)
+{
+	enum fio_ddir ddir = io_u->ddir;
+	struct cmdprio_options *options = cmdprio->options;
+	unsigned int p;
+	unsigned int cmdprio_value =
+		ioprio_value(options->class[ddir], options->level[ddir]);
+
+	p = fio_cmdprio_percentage(cmdprio, io_u);
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		io_u->ioprio = cmdprio_value;
+		if (!td->ioprio || cmdprio_value < td->ioprio) {
+			/*
+			 * The async IO priority is higher (has a lower value)
+			 * than the default priority (which is either 0 or the
+			 * value set by "prio" and "prioclass" options).
+			 */
+			io_u->flags |= IO_U_F_HIGH_PRIO;
+		}
+		return true;
+	}
+
+	if (td->ioprio && td->ioprio < cmdprio_value) {
+		/*
+		 * The IO will be executed with the default priority (which is
+		 * either 0 or the value set by "prio" and "prioclass options),
+		 * and this priority is higher (has a lower value) than the
+		 * async IO priority.
+		 */
+		io_u->flags |= IO_U_F_HIGH_PRIO;
+	}
+
+	return false;
+}
+
+static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
+					     struct cmdprio *cmdprio)
+{
+	struct cmdprio_options *options = cmdprio->options;
+	int ret;
+
+	ret = fio_cmdprio_bssplit_parse(td, options->bssplit_str, cmdprio);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	fio_cmdprio_cleanup(cmdprio);
+
+	return ret;
+}
+
+static int fio_cmdprio_parse_and_gen(struct thread_data *td,
+				     struct cmdprio *cmdprio)
+{
+	struct cmdprio_options *options = cmdprio->options;
+	int i, ret;
+
+	switch (cmdprio->mode) {
+	case CMDPRIO_MODE_BSSPLIT:
+		ret = fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
+		break;
+	case CMDPRIO_MODE_PERC:
+		ret = 0;
+		break;
+	default:
+		assert(0);
+		return 1;
+	}
+
+	/*
+	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
+	 * is not set, default to RT priority class.
+	 */
+	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
+		if (options->percentage[i] || cmdprio->bssplit_nr[i]) {
+			if (!options->class[i])
+				options->class[i] = IOPRIO_CLASS_RT;
+		}
+	}
+
+	return ret;
+}
+
+void fio_cmdprio_cleanup(struct cmdprio *cmdprio)
+{
+	int ddir;
+
+	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
+		free(cmdprio->bssplit[ddir]);
+		cmdprio->bssplit[ddir] = NULL;
+		cmdprio->bssplit_nr[ddir] = 0;
+	}
+
+	/*
+	 * options points to a cmdprio_options struct that is part of td->eo.
+	 * td->eo itself will be freed by free_ioengine().
+	 */
+	cmdprio->options = NULL;
+}
+
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     struct cmdprio_options *options)
+{
+	struct thread_options *to = &td->o;
+	bool has_cmdprio_percentage = false;
+	bool has_cmdprio_bssplit = false;
+	int i;
+
+	cmdprio->options = options;
+
+	if (options->bssplit_str && strlen(options->bssplit_str))
+		has_cmdprio_bssplit = true;
+
+	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
+		if (options->percentage[i])
+			has_cmdprio_percentage = true;
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
+	if (has_cmdprio_bssplit)
+		cmdprio->mode = CMDPRIO_MODE_BSSPLIT;
+	else if (has_cmdprio_percentage)
+		cmdprio->mode = CMDPRIO_MODE_PERC;
+	else
+		cmdprio->mode = CMDPRIO_MODE_NONE;
+
+	/* Nothing left to do if cmdprio is not used */
+	if (cmdprio->mode == CMDPRIO_MODE_NONE)
+		return 0;
+
+	return fio_cmdprio_parse_and_gen(td, cmdprio);
+}
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 0edc4365..0c7bd6cf 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -8,137 +8,35 @@
 
 #include "../fio.h"
 
-struct cmdprio {
-	unsigned int percentage[DDIR_RWDIR_CNT];
-	unsigned int class[DDIR_RWDIR_CNT];
-	unsigned int level[DDIR_RWDIR_CNT];
-	unsigned int bssplit_nr[DDIR_RWDIR_CNT];
-	struct bssplit *bssplit[DDIR_RWDIR_CNT];
-};
-
-static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_arg,
-				    enum fio_ddir ddir, char *str, bool data)
-{
-	struct cmdprio *cmdprio = cb_arg;
-	struct split split;
-	unsigned int i;
-
-	if (ddir == DDIR_TRIM)
-		return 0;
-
-	memset(&split, 0, sizeof(split));
-
-	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
-		return 1;
-	if (!split.nr)
-		return 0;
-
-	cmdprio->bssplit_nr[ddir] = split.nr;
-	cmdprio->bssplit[ddir] = malloc(split.nr * sizeof(struct bssplit));
-	if (!cmdprio->bssplit[ddir])
-		return 1;
-
-	for (i = 0; i < split.nr; i++) {
-		cmdprio->bssplit[ddir][i].bs = split.val1[i];
-		if (split.val2[i] == -1U) {
-			cmdprio->bssplit[ddir][i].perc = 0;
-		} else {
-			if (split.val2[i] > 100)
-				cmdprio->bssplit[ddir][i].perc = 100;
-			else
-				cmdprio->bssplit[ddir][i].perc = split.val2[i];
-		}
-	}
-
-	return 0;
-}
-
-static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
-				     struct cmdprio *cmdprio)
-{
-	char *str, *p;
-	int i, ret = 0;
-
-	p = str = strdup(input);
+/* read and writes only, no trim */
+#define CMDPRIO_RWDIR_CNT 2
 
-	strip_blank_front(&str);
-	strip_blank_end(str);
-
-	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false);
-
-	if (parse_dryrun()) {
-		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-			free(cmdprio->bssplit[i]);
-			cmdprio->bssplit[i] = NULL;
-			cmdprio->bssplit_nr[i] = 0;
-		}
-	}
-
-	free(p);
-	return ret;
-}
-
-static inline int fio_cmdprio_percentage(struct cmdprio *cmdprio,
-					 struct io_u *io_u)
-{
-	enum fio_ddir ddir = io_u->ddir;
-	unsigned int p = cmdprio->percentage[ddir];
-	int i;
-
-	/*
-	 * If cmdprio_percentage option was specified, then use that
-	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
-	 * on the IO size.
-	 */
-	if (p)
-		return p;
-
-	for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
-		if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
-			return cmdprio->bssplit[ddir][i].perc;
-	}
-
-	return 0;
-}
+enum {
+	CMDPRIO_MODE_NONE,
+	CMDPRIO_MODE_PERC,
+	CMDPRIO_MODE_BSSPLIT,
+};
 
-static int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
-			    bool *has_cmdprio)
-{
-	struct thread_options *to = &td->o;
-	bool has_cmdprio_percentage = false;
-	bool has_cmdprio_bssplit = false;
-	int i;
+struct cmdprio_options {
+	unsigned int percentage[CMDPRIO_RWDIR_CNT];
+	unsigned int class[CMDPRIO_RWDIR_CNT];
+	unsigned int level[CMDPRIO_RWDIR_CNT];
+	char *bssplit_str;
+};
 
-	/*
-	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
-	 * is not set, default to RT priority class.
-	 */
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		if (cmdprio->percentage[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] = IOPRIO_CLASS_RT;
-			has_cmdprio_percentage = true;
-		}
-		if (cmdprio->bssplit_nr[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] = IOPRIO_CLASS_RT;
-			has_cmdprio_bssplit = true;
-		}
-	}
+struct cmdprio {
+	struct cmdprio_options *options;
+	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
+	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
+	unsigned int mode;
+};
 
-	/*
-	 * Check for option conflicts
-	 */
-	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
-		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
-			"are mutually exclusive\n",
-			to->name);
-		return 1;
-	}
+bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
+			    struct io_u *io_u);
 
-	*has_cmdprio = has_cmdprio_percentage || has_cmdprio_bssplit;
+void fio_cmdprio_cleanup(struct cmdprio *cmdprio);
 
-	return 0;
-}
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     struct cmdprio_options *options);
 
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 27a4a678..8b8f35f1 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -69,13 +69,13 @@ struct ioring_data {
 
 	struct ioring_mmap mmap[3];
 
-	bool use_cmdprio;
+	struct cmdprio cmdprio;
 };
 
 struct ioring_options {
 	struct thread_data *td;
 	unsigned int hipri;
-	struct cmdprio cmdprio;
+	struct cmdprio_options cmdprio_options;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
 	unsigned int sqpoll_thread;
@@ -106,15 +106,6 @@ static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 	return 0;
 }
 
-static int str_cmdprio_bssplit_cb(void *data, const char *input)
-{
-	struct ioring_options *o = data;
-	struct thread_data *td = o->td;
-	struct cmdprio *cmdprio = &o->cmdprio;
-
-	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
-}
-
 static struct fio_option options[] = {
 	{
 		.name	= "hipri",
@@ -131,9 +122,9 @@ static struct fio_option options[] = {
 		.lname	= "high priority percentage",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct ioring_options,
-				   cmdprio.percentage[DDIR_READ]),
+				   cmdprio_options.percentage[DDIR_READ]),
 		.off2	= offsetof(struct ioring_options,
-				   cmdprio.percentage[DDIR_WRITE]),
+				   cmdprio_options.percentage[DDIR_WRITE]),
 		.minval	= 0,
 		.maxval	= 100,
 		.help	= "Send high priority I/O this percentage of the time",
@@ -145,9 +136,9 @@ static struct fio_option options[] = {
 		.lname	= "Asynchronous I/O priority class",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct ioring_options,
-				   cmdprio.class[DDIR_READ]),
+				   cmdprio_options.class[DDIR_READ]),
 		.off2	= offsetof(struct ioring_options,
-				   cmdprio.class[DDIR_WRITE]),
+				   cmdprio_options.class[DDIR_WRITE]),
 		.help	= "Set asynchronous IO priority class",
 		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
 		.maxval	= IOPRIO_MAX_PRIO_CLASS,
@@ -160,9 +151,9 @@ static struct fio_option options[] = {
 		.lname	= "Asynchronous I/O priority level",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct ioring_options,
-				   cmdprio.level[DDIR_READ]),
+				   cmdprio_options.level[DDIR_READ]),
 		.off2	= offsetof(struct ioring_options,
-				   cmdprio.level[DDIR_WRITE]),
+				   cmdprio_options.level[DDIR_WRITE]),
 		.help	= "Set asynchronous IO priority level",
 		.minval	= IOPRIO_MIN_PRIO,
 		.maxval	= IOPRIO_MAX_PRIO,
@@ -173,9 +164,9 @@ static struct fio_option options[] = {
 	{
 		.name   = "cmdprio_bssplit",
 		.lname  = "Priority percentage block size split",
-		.type   = FIO_OPT_STR_ULL,
-		.cb     = str_cmdprio_bssplit_cb,
-		.off1   = offsetof(struct ioring_options, cmdprio.bssplit),
+		.type   = FIO_OPT_STR_STORE,
+		.off1   = offsetof(struct ioring_options,
+				   cmdprio_options.bssplit_str),
 		.help   = "Set priority percentages for different block sizes",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
@@ -338,6 +329,18 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->rw_flags |= RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |= RWF_NOWAIT;
+
+		/*
+		 * Since io_uring can have a submission context (sqthread_poll)
+		 * that is different from the process context, we cannot rely on
+		 * the IO priority set by ioprio_set() (option prio/prioclass)
+		 * to be inherited.
+		 * td->ioprio will have the value of the "default prio", so set
+		 * this unconditionally. This value might get overridden by
+		 * fio_ioring_cmdprio_prep() if the option cmdprio_percentage or
+		 * cmdprio_bssplit is used.
+		 */
+		sqe->ioprio = td->ioprio;
 		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
 		sqe->ioprio = 0;
@@ -444,41 +447,14 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 	return r < 0 ? r : events;
 }
 
-static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
+static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
+					   struct io_u *io_u)
 {
-	struct ioring_options *o = td->eo;
 	struct ioring_data *ld = td->io_ops_data;
-	struct io_uring_sqe *sqe = &ld->sqes[io_u->index];
-	struct cmdprio *cmdprio = &o->cmdprio;
-	enum fio_ddir ddir = io_u->ddir;
-	unsigned int p = fio_cmdprio_percentage(cmdprio, io_u);
-	unsigned int cmdprio_value =
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
-
-	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		sqe->ioprio = cmdprio_value;
-		if (!td->ioprio || cmdprio_value < td->ioprio) {
-			/*
-			 * The async IO priority is higher (has a lower value)
-			 * than the priority set by "prio" and "prioclass"
-			 * options.
-			 */
-			io_u->flags |= IO_U_F_HIGH_PRIO;
-		}
-	} else {
-		sqe->ioprio = td->ioprio;
-		if (cmdprio_value && td->ioprio && td->ioprio < cmdprio_value) {
-			/*
-			 * The IO will be executed with the priority set by
-			 * "prio" and "prioclass" options, and this priority
-			 * is higher (has a lower value) than the async IO
-			 * priority.
-			 */
-			io_u->flags |= IO_U_F_HIGH_PRIO;
-		}
-	}
+	struct cmdprio *cmdprio = &ld->cmdprio;
 
-	io_u->ioprio = sqe->ioprio;
+	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u))
+		ld->sqes[io_u->index].ioprio = io_u->ioprio;
 }
 
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
@@ -508,8 +484,9 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (next_tail == atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
 
-	if (ld->use_cmdprio)
-		fio_ioring_prio_prep(td, io_u);
+	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
+		fio_ioring_cmdprio_prep(td, io_u);
+
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	atomic_store_release(ring->tail, next_tail);
 
@@ -613,6 +590,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		if (!(td->flags & TD_F_CHILD))
 			fio_ioring_unmap(ld);
 
+		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->io_u_index);
 		free(ld->iovecs);
 		free(ld->fds);
@@ -819,8 +797,6 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
-	struct cmdprio *cmdprio = &o->cmdprio;
-	bool has_cmdprio = false;
 	int ret;
 
 	/* sqthread submission requires registered files */
@@ -845,22 +821,12 @@ static int fio_ioring_init(struct thread_data *td)
 
 	td->io_ops_data = ld;
 
-	ret = fio_cmdprio_init(td, cmdprio, &has_cmdprio);
+	ret = fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
 	}
 
-	/*
-	 * Since io_uring can have a submission context (sqthread_poll) that is
-	 * different from the process context, we cannot rely on the the IO
-	 * priority set by ioprio_set() (option prio/prioclass) to be inherited.
-	 * Therefore, we set the sqe->ioprio field when prio/prioclass is used.
-	 */
-	ld->use_cmdprio = has_cmdprio ||
-		fio_option_is_set(&td->o, ioprio_class) ||
-		fio_option_is_set(&td->o, ioprio);
-
 	return 0;
 }
 
diff --git a/engines/libaio.c b/engines/libaio.c
index dd655355..9c278d06 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -52,25 +52,16 @@ struct libaio_data {
 	unsigned int head;
 	unsigned int tail;
 
-	bool use_cmdprio;
+	struct cmdprio cmdprio;
 };
 
 struct libaio_options {
 	struct thread_data *td;
 	unsigned int userspace_reap;
-	struct cmdprio cmdprio;
+	struct cmdprio_options cmdprio_options;
 	unsigned int nowait;
 };
 
-static int str_cmdprio_bssplit_cb(void *data, const char *input)
-{
-	struct libaio_options *o = data;
-	struct thread_data *td = o->td;
-	struct cmdprio *cmdprio = &o->cmdprio;
-
-	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
-}
-
 static struct fio_option options[] = {
 	{
 		.name	= "userspace_reap",
@@ -87,9 +78,9 @@ static struct fio_option options[] = {
 		.lname	= "high priority percentage",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct libaio_options,
-				   cmdprio.percentage[DDIR_READ]),
+				   cmdprio_options.percentage[DDIR_READ]),
 		.off2	= offsetof(struct libaio_options,
-				   cmdprio.percentage[DDIR_WRITE]),
+				   cmdprio_options.percentage[DDIR_WRITE]),
 		.minval	= 0,
 		.maxval	= 100,
 		.help	= "Send high priority I/O this percentage of the time",
@@ -101,9 +92,9 @@ static struct fio_option options[] = {
 		.lname	= "Asynchronous I/O priority class",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct libaio_options,
-				   cmdprio.class[DDIR_READ]),
+				   cmdprio_options.class[DDIR_READ]),
 		.off2	= offsetof(struct libaio_options,
-				   cmdprio.class[DDIR_WRITE]),
+				   cmdprio_options.class[DDIR_WRITE]),
 		.help	= "Set asynchronous IO priority class",
 		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
 		.maxval	= IOPRIO_MAX_PRIO_CLASS,
@@ -116,9 +107,9 @@ static struct fio_option options[] = {
 		.lname	= "Asynchronous I/O priority level",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct libaio_options,
-				   cmdprio.level[DDIR_READ]),
+				   cmdprio_options.level[DDIR_READ]),
 		.off2	= offsetof(struct libaio_options,
-				   cmdprio.level[DDIR_WRITE]),
+				   cmdprio_options.level[DDIR_WRITE]),
 		.help	= "Set asynchronous IO priority level",
 		.minval	= IOPRIO_MIN_PRIO,
 		.maxval	= IOPRIO_MAX_PRIO,
@@ -129,9 +120,9 @@ static struct fio_option options[] = {
 	{
 		.name   = "cmdprio_bssplit",
 		.lname  = "Priority percentage block size split",
-		.type   = FIO_OPT_STR_ULL,
-		.cb     = str_cmdprio_bssplit_cb,
-		.off1   = offsetof(struct libaio_options, cmdprio.bssplit),
+		.type   = FIO_OPT_STR_STORE,
+		.off1   = offsetof(struct libaio_options,
+				   cmdprio_options.bssplit_str),
 		.help   = "Set priority percentages for different block sizes",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
@@ -205,33 +196,15 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
-static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
+static inline void fio_libaio_cmdprio_prep(struct thread_data *td,
+					   struct io_u *io_u)
 {
-	struct libaio_options *o = td->eo;
-	struct cmdprio *cmdprio = &o->cmdprio;
-	enum fio_ddir ddir = io_u->ddir;
-	unsigned int p = fio_cmdprio_percentage(cmdprio, io_u);
-	unsigned int cmdprio_value =
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
-
-	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->ioprio = cmdprio_value;
-		io_u->iocb.aio_reqprio = cmdprio_value;
+	struct libaio_data *ld = td->io_ops_data;
+	struct cmdprio *cmdprio = &ld->cmdprio;
+
+	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
+		io_u->iocb.aio_reqprio = io_u->ioprio;
 		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
-		if (!td->ioprio || cmdprio_value < td->ioprio) {
-			/*
-			 * The async IO priority is higher (has a lower value)
-			 * than the default context priority.
-			 */
-			io_u->flags |= IO_U_F_HIGH_PRIO;
-		}
-	} else if (td->ioprio && td->ioprio < cmdprio_value) {
-		/*
-		 * The IO will be executed with the default context priority,
-		 * and this priority is higher (has a lower value) than the
-		 * async IO priority.
-		 */
-		io_u->flags |= IO_U_F_HIGH_PRIO;
 	}
 }
 
@@ -368,8 +341,8 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	if (ld->use_cmdprio)
-		fio_libaio_prio_prep(td, io_u);
+	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
+		fio_libaio_cmdprio_prep(td, io_u);
 
 	ld->iocbs[ld->head] = &io_u->iocb;
 	ld->io_us[ld->head] = io_u;
@@ -487,6 +460,8 @@ static void fio_libaio_cleanup(struct thread_data *td)
 		 */
 		if (!(td->flags & TD_F_CHILD))
 			io_destroy(ld->aio_ctx);
+
+		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
@@ -512,7 +487,6 @@ static int fio_libaio_init(struct thread_data *td)
 {
 	struct libaio_data *ld;
 	struct libaio_options *o = td->eo;
-	struct cmdprio *cmdprio = &o->cmdprio;
 	int ret;
 
 	ld = calloc(1, sizeof(*ld));
@@ -525,7 +499,7 @@ static int fio_libaio_init(struct thread_data *td)
 
 	td->io_ops_data = ld;
 
-	ret = fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	ret = fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
diff --git a/fio.1 b/fio.1
index 78988c9e..e3c3feae 100644
--- a/fio.1
+++ b/fio.1
@@ -1965,8 +1965,7 @@ with the caveat that when used on the command line, they must come after the
 .BI (io_uring,libaio)cmdprio_percentage \fR=\fPint[,int]
 Set the percentage of I/O that will be issued with the highest priority.
 Default: 0. A single value applies to reads and writes. Comma-separated
-values may be specified for reads and writes. This option cannot be used
-with the `prio` or `prioclass` options. For this option to be effective,
+values may be specified for reads and writes. For this option to be effective,
 NCQ priority must be supported and enabled, and `direct=1' option must be
 used. fio must also be run as the root user.
 .TP
