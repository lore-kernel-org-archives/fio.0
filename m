Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488DEC001DF
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 22:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjGEWNM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjGEWNL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 18:13:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B55919A1
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 15:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FA7E61782
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 22:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58138C433C9;
        Wed,  5 Jul 2023 22:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688595188;
        bh=WHIp51FJaeVb8+BgLyNjNagqkh9sjpGAIso9ap5CQzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cx4RHLvstTc34OLYDywQs5o5M6qI+SK1e1ILbD5cUadzdQ5cC0HDiDg5BieZnKFRu
         E0hmjkWYwQ+Oq87U7DsMsUAeSndyeLnat60umNW1PHftoCn1LT6lJR4vT48ChcSpcD
         swA1DSnhG8cykAYUr7ooH1tWhM2XACPZ0suY0rYr31qhGm4V+BTp5faSM0eJJwt/12
         D7q5fgM5a2zTGB7SQ7eHhZ10kyT66tpbIuKc9wsCoICAguieYRDq7PsvTmdmd7kg/P
         i/K7QsFOxJ0OypgjQR5+eWOzu5deEUEw06SJGFshP8wLttiWas+oIptk3RgoTRoHKF
         pMTqdQQMjnjNg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH 4/4] stats: Add hint information to per priority level stats
Date:   Thu,  6 Jul 2023 07:13:02 +0900
Message-ID: <20230705221302.430678-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230705221302.430678-1-dlemoal@kernel.org>
References: <20230705221302.430678-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the OS dependent ioprio_hint() macro to extract an IO
priority hint from an ioprio value. This macro defaults to always
returning 0 for OSes that do not support IO priority hints.

The json and standard output stats are modified to display the hint
value together with the priority class and level.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 os/os-linux.h |  4 ++++
 os/os.h       |  3 +++
 stat.c        | 10 +++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/os/os-linux.h b/os/os-linux.h
index 6f241d09..b9c07891 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -150,6 +150,10 @@ static inline int ioprio_value(int ioprio_class, int ioprio, int ioprio_hint)
 		ioprio;
 }
 
+#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
+#define ioprio_hint(ioprio)	(((ioprio) >> IOPRIO_HINT_SHIFT) & 0x3ff)
+#define ioprio(ioprio)		((ioprio) & 7)
+
 static inline bool ioprio_value_is_class_rt(unsigned int priority)
 {
 	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
diff --git a/os/os.h b/os/os.h
index 2217d5f8..0f182324 100644
--- a/os/os.h
+++ b/os/os.h
@@ -120,6 +120,9 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #define ioprio_value_is_class_rt(prio)	(false)
 #define IOPRIO_MIN_PRIO_CLASS		0
 #define IOPRIO_MAX_PRIO_CLASS		0
+#define ioprio_hint(prio)		0
+#define IOPRIO_MIN_PRIO_HINT		0
+#define IOPRIO_MAX_PRIO_HINT		0
 #endif
 #ifndef FIO_HAVE_IOPRIO
 #define ioprio_value(prioclass, prio, priohint)	(0)
diff --git a/stat.c b/stat.c
index 015b8e28..4f943602 100644
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
@@ -1522,6 +1524,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 				ioprio_class(ts->clat_prio[ddir][i].ioprio));
 			json_object_add_value_int(obj, "prio",
 				ioprio(ts->clat_prio[ddir][i].ioprio));
+			json_object_add_value_int(obj, "priohint",
+				ioprio_hint(ts->clat_prio[ddir][i].ioprio));
 
 			tmp_object = add_ddir_lat_json(ts,
 					ts->clat_percentiles | ts->lat_percentiles,
-- 
2.41.0

