Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFADC001B0
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 22:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjGEWNI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjGEWNH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 18:13:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C431722
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 15:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 875926177F
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 22:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E115C433C7;
        Wed,  5 Jul 2023 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688595186;
        bh=Q2tntWmI90VjL6j/3WV+brqHn728r25y69SJ6i4u37Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwmusRkv5gMmq1i0MtzmGbAesD2DV+ozTu58hYrYo1MJW7fGmGPZGVKANsylz/d9r
         /xhlt4VZ+JqM5L2o5/x4L7QfXQHJeO3yHSqlO8z3gjOlK0o/+3hj4kSN8K3JZDVALm
         h/9FxbrnWT3Xf1vLwrmXmRtjMZY9BjTiVCSEb7Iod17nEL5Pc6G2lHBPgw6DjWIqWV
         sFkF/v2Zr91mB3n+Um2wVGvNc9sHZjvjrV2hpK6mk9yHoU1St8NmpYNo8VKwHLwEJr
         D6Y14niULWw/2dSrMn6GK73yTNB5FrYp8ZeVqfQzvthEVRqiq4mqJ9Z34B8ONjzFM/
         OsIj/1v7kQVjg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH 1/4] os-linux: add initial support for IO priority hints
Date:   Thu,  6 Jul 2023 07:12:59 +0900
Message-ID: <20230705221302.430678-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230705221302.430678-1-dlemoal@kernel.org>
References: <20230705221302.430678-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Add initial support for Linux to allow specifying a hint for any
priority value. With this change, a priority value becomes the
combination of a priority class, a priority level and a hint.
The generic os.h ioprio manipulation macros, as well as the
os-dragonfly.h ioprio manipulation macros  are modified to ignore this
hint.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 backend.c         |  5 +++--
 engines/cmdprio.c |  4 ++--
 options.c         |  2 +-
 os/os-dragonfly.h |  4 ++--
 os/os-linux.h     | 17 +++++++++++++----
 os/os.h           |  4 ++--
 6 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/backend.c b/backend.c
index d67a4a07..6641441c 100644
--- a/backend.c
+++ b/backend.c
@@ -1791,12 +1791,13 @@ static void *thread_main(void *data)
 	/* ioprio_set() has to be done before td_io_init() */
 	if (fio_option_is_set(o, ioprio) ||
 	    fio_option_is_set(o, ioprio_class)) {
-		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
+		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class,
+				 o->ioprio, 0);
 		if (ret == -1) {
 			td_verror(td, errno, "ioprio_set");
 			goto err;
 		}
-		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
+		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio, 0);
 		td->ts.ioprio = td->ioprio;
 	}
 
diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 979a81b6..e6ff1fc2 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -342,7 +342,7 @@ static int fio_cmdprio_gen_perc(struct thread_data *td, struct cmdprio *cmdprio)
 		prio = &cmdprio->perc_entry[ddir];
 		prio->perc = options->percentage[ddir];
 		prio->prio = ioprio_value(options->class[ddir],
-					  options->level[ddir]);
+					  options->level[ddir], 0);
 		assign_clat_prio_index(prio, &values[ddir]);
 
 		ret = init_ts_clat_prio(ts, ddir, &values[ddir]);
@@ -400,7 +400,7 @@ static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
 			goto err;
 
 		implicit_cmdprio = ioprio_value(options->class[ddir],
-						options->level[ddir]);
+						options->level[ddir], 0);
 
 		ret = fio_cmdprio_generate_bsprio_desc(&cmdprio->bsprio_desc[ddir],
 						       &parse_res[ddir],
diff --git a/options.c b/options.c
index a7c4ef6e..c5343d4b 100644
--- a/options.c
+++ b/options.c
@@ -344,7 +344,7 @@ static int parse_cmdprio_bssplit_entry(struct thread_options *o,
 	case 4: /* bs/perc/class/level case */
 		class = min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
 		level = min(level, (unsigned int) IOPRIO_MAX_PRIO);
-		entry->prio = ioprio_value(class, level);
+		entry->prio = ioprio_value(class, level, 0);
 		break;
 	default:
 		log_err("fio: invalid cmdprio_bssplit format\n");
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
index 2f9f7e79..6f241d09 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -125,13 +125,19 @@ enum {
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
+static inline int ioprio_value(int ioprio_class, int ioprio, int ioprio_hint)
 {
 	/*
 	 * If no class is set, assume BE
@@ -139,7 +145,9 @@ static inline int ioprio_value(int ioprio_class, int ioprio)
         if (!ioprio_class)
                 ioprio_class = IOPRIO_CLASS_BE;
 
-	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) |
+		(ioprio_hint << IOPRIO_HINT_SHIFT) |
+		ioprio;
 }
 
 static inline bool ioprio_value_is_class_rt(unsigned int priority)
@@ -147,10 +155,11 @@ static inline bool ioprio_value_is_class_rt(unsigned int priority)
 	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
 }
 
-static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio,
+			     int ioprio_hint)
 {
 	return syscall(__NR_ioprio_set, which, who,
-		       ioprio_value(ioprio_class, ioprio));
+		       ioprio_value(ioprio_class, ioprio, ioprio_hint));
 }
 
 #define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
diff --git a/os/os.h b/os/os.h
index 036fc233..2217d5f8 100644
--- a/os/os.h
+++ b/os/os.h
@@ -122,9 +122,9 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #define IOPRIO_MAX_PRIO_CLASS		0
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
-- 
2.41.0

