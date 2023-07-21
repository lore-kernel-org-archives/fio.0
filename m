Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355FCC001DC
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 11:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjGULIv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjGULIT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 07:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0AF30FF
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 04:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DC94619E6
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 11:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B07C433C8;
        Fri, 21 Jul 2023 11:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689937514;
        bh=q05+NFsQ2oVbo/dLKIfeu64HeKaDzyHH7PLEpG+6zuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCEIew8NE9VW+0UZwBXpwMGG0xmwWBAoCca2qEe+jUuuU2cixwG4vYOoAO6Y9oVsf
         QtKrv/GtSWAnlCjqAF5n8kevLn2lJpDZYzPuaes72ca57LKAk77EFTE1b4jm0Xhr2p
         sWMN7dh6cowq5xHW+0HRkYk7GrbGjszEGvszQ/Bp0F5R59GR+pJjtR73h8dcmkrCW+
         oNk1YTkR6F+N4Euo7LEIBSnGPBRya4HbNmP2G9mQ5F7KnX6ge/34fa6SBXojI5Rgcg
         b9laDDRmAGFvhvgrWYtsI2QRC0SFVdpye2zB/Ad//xA01Uo0mXu5iBslAKCwMss0xG
         goEjgfyh+9vag==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 3/6] os-linux: add initial support for IO priority hints
Date:   Fri, 21 Jul 2023 20:05:07 +0900
Message-ID: <20230721110510.44772-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721110510.44772-1-dlemoal@kernel.org>
References: <20230721110510.44772-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add initial support for Linux to allow specifying a hint for any
priority value. With this change, a priority value becomes the
combination of a priority class, a priority level and a hint.
The generic os.h ioprio manipulation macros, as well as the
os-dragonfly.h ioprio manipulation macros are modified to ignore this
hint.

For all other OSes that do not support priority classes, priotity hints
are ignored and always equal to 0.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 backend.c         |  5 +++--
 engines/cmdprio.c |  4 ++--
 options.c         |  2 +-
 os/os-dragonfly.h |  4 ++--
 os/os-linux.h     | 19 +++++++++++++++----
 os/os.h           |  7 +++++--
 6 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/backend.c b/backend.c
index b06a11a5..268b7825 100644
--- a/backend.c
+++ b/backend.c
@@ -1800,12 +1800,13 @@ static void *thread_main(void *data)
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
index 0f739317..143d3583 100644
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
index 72727ac3..c5cd6515 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -125,16 +125,24 @@ enum {
 #define IOPRIO_BITS		16
 #define IOPRIO_CLASS_SHIFT	13
 
+#define IOPRIO_HINT_BITS	10
+#define IOPRIO_HINT_SHIFT	3
+
 #define IOPRIO_MIN_PRIO		0	/* highest priority */
 #define IOPRIO_MAX_PRIO		7	/* lowest priority */
 
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
 
+#define IOPRIO_MIN_PRIO_HINT	0
+#define IOPRIO_MAX_PRIO_HINT	((1 << IOPRIO_HINT_BITS) - 1)
+
 #define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
 #define ioprio(ioprio)		((ioprio) & IOPRIO_MAX_PRIO)
+#define ioprio_hint(ioprio)	\
+	(((ioprio) >> IOPRIO_HINT_SHIFT) & IOPRIO_MAX_PRIO_HINT)
 
-static inline int ioprio_value(int ioprio_class, int ioprio)
+static inline int ioprio_value(int ioprio_class, int ioprio, int ioprio_hint)
 {
 	/*
 	 * If no class is set, assume BE
@@ -142,7 +150,9 @@ static inline int ioprio_value(int ioprio_class, int ioprio)
         if (!ioprio_class)
                 ioprio_class = IOPRIO_CLASS_BE;
 
-	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
+	return (ioprio_class << IOPRIO_CLASS_SHIFT) |
+		(ioprio_hint << IOPRIO_HINT_SHIFT) |
+		ioprio;
 }
 
 static inline bool ioprio_value_is_class_rt(unsigned int priority)
@@ -150,10 +160,11 @@ static inline bool ioprio_value_is_class_rt(unsigned int priority)
 	return ioprio_class(priority) == IOPRIO_CLASS_RT;
 }
 
-static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
+static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio,
+			     int ioprio_hint)
 {
 	return syscall(__NR_ioprio_set, which, who,
-		       ioprio_value(ioprio_class, ioprio));
+		       ioprio_value(ioprio_class, ioprio, ioprio_hint));
 }
 
 #ifndef CONFIG_HAVE_GETTID
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
-- 
2.41.0

