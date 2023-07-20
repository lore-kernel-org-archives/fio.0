Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C0BC00528
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 01:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjGTBbW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjGTBbV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 21:31:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B672106
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 18:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B7761896
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 01:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3880C433C9;
        Thu, 20 Jul 2023 01:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689816680;
        bh=0jbHwWaG/Rzefk1bBkk5TLVKyMidDelHPLtaoJqChV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WcYPKI7uu6T8fyKaSGoR5q6tMzACg3lfLHhwLK3+talGm5XoeDm9jjmlkGHQWN3R5
         ujf+9dM4JvLT24+FCBqUUYAzrKzs7rEsVvVgXAU2TvEzCqjaJpZ90yuM/4JiAhU6AN
         U0FvhxOx6V3Fuiik678b4AFPAkas27wFA/41VCoTxv4d/hVSwTih9dgN1Gos/RaLKw
         Z34HMnHoFBoXETUlwcsqrTqbAINQ9mEby3ASKzDSs9brLQH/z3/ualBqooqYqZLLsv
         s/h5jUItBOviJUM3TyYrjaJNkgEUHYGUxbZpibRoJ96051rOo7gUP+hrnCMMyZWdWe
         nqIttY4j2c7RA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 5/5] stats: Add hint information to per priority level stats
Date:   Thu, 20 Jul 2023 10:31:14 +0900
Message-ID: <20230720013114.28158-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720013114.28158-1-dlemoal@kernel.org>
References: <20230720013114.28158-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Modify the json and standard per-priority output stats to display the
hint value together with the priority class and level.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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
-- 
2.41.0

