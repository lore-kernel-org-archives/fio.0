Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA089EB64DD
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 22:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjGEWNJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjGEWNI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 18:13:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA220171E
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 15:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82AF061782
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 22:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40203C433C8;
        Wed,  5 Jul 2023 22:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688595186;
        bh=ZJKfHuGliRFuiKPTrr36kvYHvfYMqlAmEcbR9jEvA4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM05s9IyNE/JvIRZI7t+O2Em1hpuic5seGEJNeAZUe6jgZqYf5VFlhZwp63b5sljV
         8YoV8d0uZ1EFGltfCy7Tp/vt+QKaqs+gU72WqV3PrBQAZzrSkoGzk1bFflYHhcu39j
         4dHrwgQdc4qTvq5+2o/gicXfg+IQbPDN7HB5IpCVyFS/Bp7FVZ7dWzqGbxFo5POfmU
         2odgWiQ13zs8Jk36ToxIjVkzlO85r5ixpbKHHkDZ6xM6zHsrvtMS+foVrBAif47pc1
         1lyrH0gzb2lxVwUPa3WXDJZMIXvt5F2XmKpQxNajTz03mIBqzEP/qG25df4TeX54Q/
         WyA7PVIScSbLQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH 2/4] options: add priohint option
Date:   Thu,  6 Jul 2023 07:13:00 +0900
Message-ID: <20230705221302.430678-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230705221302.430678-1-dlemoal@kernel.org>
References: <20230705221302.430678-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the new option priohint to allow a user to specify an I/O
priority hint applying to all IOs issued by a job.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 HOWTO.rst        |  6 ++++++
 backend.c        |  8 +++++---
 cconv.c          |  2 ++
 fio.1            |  4 ++++
 options.c        | 18 ++++++++++++++++++
 thread_options.h |  3 ++-
 6 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 2e1e55c2..359d606b 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3409,6 +3409,12 @@ Threads, processes and job synchronization
 	priority setting, see I/O engine specific :option:`cmdprio_percentage`
 	and :option:`cmdprio_class` options.
 
+.. option:: priohint=int
+
+	Set the I/O priority hint. See man :manpage:`ionice(1)`. For per-command
+	priority setting, see the I/O engine specific :option:`cmdprio_hint`
+	option.
+
 .. option:: cpus_allowed=str
 
 	Controls the same options as :option:`cpumask`, but accepts a textual
diff --git a/backend.c b/backend.c
index 6641441c..8e7bb70d 100644
--- a/backend.c
+++ b/backend.c
@@ -1790,14 +1790,16 @@ static void *thread_main(void *data)
 
 	/* ioprio_set() has to be done before td_io_init() */
 	if (fio_option_is_set(o, ioprio) ||
-	    fio_option_is_set(o, ioprio_class)) {
+	    fio_option_is_set(o, ioprio_class) ||
+	    fio_option_is_set(o, ioprio_hint)) {
 		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class,
-				 o->ioprio, 0);
+				 o->ioprio, o->ioprio_hint);
 		if (ret == -1) {
 			td_verror(td, errno, "ioprio_set");
 			goto err;
 		}
-		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio, 0);
+		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio,
+					  o->ioprio_hint);
 		td->ts.ioprio = td->ioprio;
 	}
 
diff --git a/cconv.c b/cconv.c
index 9095d519..9ad8d6bb 100644
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
@@ -495,6 +496,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->nice = cpu_to_le32(o->nice);
 	top->ioprio = cpu_to_le32(o->ioprio);
 	top->ioprio_class = cpu_to_le32(o->ioprio_class);
+	top->ioprio_hint = cpu_to_le32(o->ioprio_hint);
 	top->file_service_type = cpu_to_le32(o->file_service_type);
 	top->group_reporting = cpu_to_le32(o->group_reporting);
 	top->stats = cpu_to_le32(o->stats);
diff --git a/fio.1 b/fio.1
index 73b7e8c9..6dbdb293 100644
--- a/fio.1
+++ b/fio.1
@@ -3116,6 +3116,10 @@ Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
 priority setting, see the I/O engine specific `cmdprio_percentage` and
 `cmdprio_class` options.
 .TP
+.BI priohint \fR=\fPint
+Set the I/O priority hint. See man \fBionice\fR\|(1). For per-command
+priority setting, see the I/O engine specific `cmdprio_hint` option.
+.TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
 specification of the permitted CPUs instead and CPUs are indexed from 0. So
diff --git a/options.c b/options.c
index c5343d4b..c1246297 100644
--- a/options.c
+++ b/options.c
@@ -3786,6 +3786,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
@@ -3793,6 +3805,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
diff --git a/thread_options.h b/thread_options.h
index a24ebee6..4fb72651 100644
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
@@ -567,6 +568,7 @@ struct thread_options_pack {
 	uint32_t nice;
 	uint32_t ioprio;
 	uint32_t ioprio_class;
+	uint32_t ioprio_hint;
 	uint32_t file_service_type;
 	uint32_t group_reporting;
 	uint32_t stats;
@@ -600,7 +602,6 @@ struct thread_options_pack {
 	uint32_t lat_percentiles;
 	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad5;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
-- 
2.41.0

