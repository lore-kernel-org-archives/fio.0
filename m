Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B453C001B0
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 01:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjGTBbV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGTBbU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 21:31:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEC02107
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 18:31:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 349A061892
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 01:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15326C433C7;
        Thu, 20 Jul 2023 01:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689816678;
        bh=atzX5c4PXt5QzTYCHTGjGH8GD8P9Pu7c039MUEV7rKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GK5SyW0mxwbpc3DxFR39s45DpquWgzvJ3t/gszeLMQAn49f08R0eWZe4sI6pOexjZ
         599mtgmcYdP1OJxwzex99wQuFYyM8NXNRpynJhlT5nfGhT9IYDH7HAZGGOKu4PtvUq
         ham9l5UMS0QBBYpYdGZnLa/MzLSfbJeMS/a/AEUTl8+YaeaHz7jKtcj7YB+6uYbsaO
         Ps3prYzYupnNVyk9BCwFVg8AHj6dAhTLt65D600Y10o/AW2tsG+DSqHcQSeY9mcJW9
         SkLDEirmesz5LfzQM43d8H8+xwXR0Y07FrtiQKsp/T29wymKAwwPmcXmRq+w8FJDYn
         f5dADAE2XpdVw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 3/5] options: add priohint option
Date:   Thu, 20 Jul 2023 10:31:12 +0900
Message-ID: <20230720013114.28158-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720013114.28158-1-dlemoal@kernel.org>
References: <20230720013114.28158-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Introduce the new option priohint to allow a user to specify an I/O
priority hint applying to all IOs issued by a job. This increases fio
server version (FIO_SERVER_VER) to 101.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 HOWTO.rst        |  6 ++++++
 backend.c        |  8 +++++---
 cconv.c          |  2 ++
 fio.1            |  5 +++++
 options.c        | 18 ++++++++++++++++++
 server.h         |  2 +-
 thread_options.h |  3 ++-
 7 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 7ae8ea7b..9b9472a8 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3424,6 +3424,12 @@ Threads, processes and job synchronization
 	priority setting, see I/O engine specific :option:`cmdprio_percentage`
 	and :option:`cmdprio_class` options.
 
+.. option:: priohint=int
+
+	Set the I/O priority hint. This has effects only for devices with
+	features controlled through priority hints (e.g. block devices
+	supporting command duration limits).
+
 .. option:: cpus_allowed=str
 
 	Controls the same options as :option:`cpumask`, but accepts a textual
diff --git a/backend.c b/backend.c
index 268b7825..624d7c6f 100644
--- a/backend.c
+++ b/backend.c
@@ -1799,14 +1799,16 @@ static void *thread_main(void *data)
 
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
diff --git a/fio.1 b/fio.1
index da875276..0f7ebc7f 100644
--- a/fio.1
+++ b/fio.1
@@ -3132,6 +3132,11 @@ Set the I/O priority class. See man \fBionice\fR\|(1). For per-command
 priority setting, see the I/O engine specific `cmdprio_percentage` and
 `cmdprio_class` options.
 .TP
+.BI priohint \fR=\fPint
+Set the I/O priority hint. This has effects only for devices with
+features controlled through priority hints (e.g. block devices supporting
+command duration limits).
+.TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
 specification of the permitted CPUs instead and CPUs are indexed from 0. So
diff --git a/options.c b/options.c
index 143d3583..56672960 100644
--- a/options.c
+++ b/options.c
@@ -3806,6 +3806,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
@@ -3813,6 +3825,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
-- 
2.41.0

