Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E950BC04FE0
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 11:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjGULIt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjGULIT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 07:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B322C359A
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 04:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32E24619EC
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 11:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5762C433CB;
        Fri, 21 Jul 2023 11:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689937513;
        bh=L+FRg/VCAkLAcr4TvRiqxpCuxX63edRShCzZZQ297WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLBGB5veLkxtgtQzLenIgbuyXDCmd8Iz8PMPx7wR9wvXd5kiFiVytGEUtNxn4SQC1
         Jvitu11ZcrkglyN7bSHNEouGioJmlAV/4xJ1XzRHD6JeCIUBz4jHnCRmPNKSeUVHX6
         jx/dqbcMnWflyTpwQctbrQp8hzrEl9jaqO7nry9mwgwFvsl/Pez3c+Q/GdGNMnbU4s
         eLRTnJjqkxYFi+XsnGB21T3+Wq8x5/yOBkvl9H9BBCng8us2YBbu+RNsVinZgJm+9o
         xBHKs0zkUkF2C52N3uEYeCaEuJh/uOvsLg/dZDAv45svdlPyZzuw8qxUuPhoTktny3
         5iEXi5R5nJnJw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 2/6] cmdprio: Introduce generic option definitions
Date:   Fri, 21 Jul 2023 20:05:06 +0900
Message-ID: <20230721110510.44772-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721110510.44772-1-dlemoal@kernel.org>
References: <20230721110510.44772-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The definition of the per-I/O priority options for the io_uring and
libaio I/O engines are almost identical, differing only by the option
group and option data structure used.

Introduce the CMDPRIO_OPTIONS macro in engines/cmdprio.h to generically
define these options in the io_uring and libaio engines to simplify the
code.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/cmdprio.h  | 84 ++++++++++++++++++++++++++++++++++++++++++++++
 engines/io_uring.c | 82 +-------------------------------------------
 engines/libaio.c   | 82 +-------------------------------------------
 3 files changed, 86 insertions(+), 162 deletions(-)

diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 755da8d0..2c9d87bc 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -7,6 +7,7 @@
 #define FIO_CMDPRIO_H
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 /* read and writes only, no trim */
 #define CMDPRIO_RWDIR_CNT 2
@@ -42,6 +43,89 @@ struct cmdprio_options {
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
index f30a3c00..5613c4c6 100644
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
-- 
2.41.0

