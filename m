Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D60AC001DF
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 11:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjGULIx (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbjGULIU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 07:08:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793A830C7
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 04:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52E99619E3
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 11:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1382AC433C7;
        Fri, 21 Jul 2023 11:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689937516;
        bh=0jbHwWaG/Rzefk1bBkk5TLVKyMidDelHPLtaoJqChV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxgBNQ+ryG9NxZ7+a3fG8sVG0i2Y24WPuKQ7IyolMsNSd/3RZ5b4h2NkmWIDGLL+h
         jrGGaz2oLruEysbgcYztGdDWH58zFHpEyVweHhrDAFBxW3AXjHcQKvVzi3ftCT/Z4V
         BEuhfUkGRZTxJxKi3F3CBTjjHR8q75he6SaNyfp6HP2m2l+oyCg4ZDJSQX0Q2yQGt9
         S/feuRG1ItOWgFBD6E42VP6b1fsCMFx67xDfIf8MTgFVRz6oIWeY5jHXbyi3LrTFfB
         eckValc9+ya6KwCRexfvMVdJJ5dp4AdZ7fIMpJSrr357ymzVJAOxqUwfjpCcLimRCf
         xBVnaQqBIJ/zQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 6/6] stats: Add hint information to per priority level stats
Date:   Fri, 21 Jul 2023 20:05:10 +0900
Message-ID: <20230721110510.44772-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721110510.44772-1-dlemoal@kernel.org>
References: <20230721110510.44772-1-dlemoal@kernel.org>
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

