Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C08C433F5
	for <fio@archiver.kernel.org>; Thu, 11 Nov 2021 13:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE2A9611C9
	for <fio@archiver.kernel.org>; Thu, 11 Nov 2021 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhKKNC6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 11 Nov 2021 08:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhKKNC4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Nov 2021 08:02:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03CBC061766
        for <fio@vger.kernel.org>; Thu, 11 Nov 2021 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=pY7VnMRnYPSyBa2naJhSc6X8q4lANk17qmsoODqvBm4=; b=UVLR1SljRjiCz5yo4ar42myGjl
        lcdrSryavnrRzrSdLl6LcteosNu8N+Yu/2qtc3vOhm79QWm9UFE80vXD0wio+nKsXPyIN1MkLVyFw
        4URefWqNoqK7b1KfrNndPKecP/+d1N0JyWWoA4GgGc6fz1tmTQvsnFMWJnAD8gEq9RHh7L8owt72x
        9/yjLKiIss6hU1eXJXXBA01uFN0PE/hGgA4xUw/FhWTUuJIZwCs2B2LfLKahIHFcOX8LiW7sMUlm6
        rgLloP68XQg+VID/Ni/VzG0dBtkJ36TQaIyRkJtz7jF1yFwRDBXFArVa1oawK+LLdP1utFzhQVBCr
        pjzmFoXQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml9gT-002jpH-8z
        for fio@vger.kernel.org; Thu, 11 Nov 2021 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 655561BC0184; Thu, 11 Nov 2021 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211111130002.655561BC0184@kernel.dk>
Date:   Thu, 11 Nov 2021 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a87ea1a869595ca57052e7645431a397d3c7d5ac:

  Merge branch 'evelu-peak' of https://github.com/ErwanAliasr1/fio (2021-10-25 12:38:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6619fc32c413c4ff3a24c819037fb9227af3f876:

  stat: create a init_thread_stat_min_vals() helper (2021-11-08 06:24:48 -0700)

----------------------------------------------------------------
Niklas Cassel (1):
      stat: create a init_thread_stat_min_vals() helper

 init.c | 11 +----------
 stat.c | 66 +++++++++++++++++++++---------------------------------------------
 stat.h |  1 +
 3 files changed, 23 insertions(+), 55 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index ec1a2cac..5f069d9a 100644
--- a/init.c
+++ b/init.c
@@ -1548,16 +1548,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	memcpy(td->ts.percentile_list, o->percentile_list, sizeof(o->percentile_list));
 	td->ts.sig_figs = o->sig_figs;
 
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		td->ts.clat_stat[i].min_val = ULONG_MAX;
-		td->ts.slat_stat[i].min_val = ULONG_MAX;
-		td->ts.lat_stat[i].min_val = ULONG_MAX;
-		td->ts.bw_stat[i].min_val = ULONG_MAX;
-		td->ts.iops_stat[i].min_val = ULONG_MAX;
-		td->ts.clat_high_prio_stat[i].min_val = ULONG_MAX;
-		td->ts.clat_low_prio_stat[i].min_val = ULONG_MAX;
-	}
-	td->ts.sync_stat.min_val = ULONG_MAX;
+	init_thread_stat_min_vals(&td->ts);
 	td->ddir_seq_nr = o->ddir_seq_nr;
 
 	if ((o->stonewall || o->new_group) && prev_group_jobs) {
diff --git a/stat.c b/stat.c
index 30f9b5c1..cd35b114 100644
--- a/stat.c
+++ b/stat.c
@@ -483,22 +483,13 @@ static void show_mixed_ddir_status(struct group_run_stats *rs, struct thread_sta
 	struct thread_stat *ts_lcl;
 
 	int i2p;
-	int ddir = 0, i;
+	int ddir = 0;
 
 	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
 	ts_lcl = malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
 	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		ts_lcl->clat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->slat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->lat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->bw_stat[i].min_val = ULONG_MAX;
-		ts_lcl->iops_stat[i].min_val = ULONG_MAX;
-		ts_lcl->clat_high_prio_stat[i].min_val = ULONG_MAX;
-		ts_lcl->clat_low_prio_stat[i].min_val = ULONG_MAX;
-	}
-	ts_lcl->sync_stat.min_val = ULONG_MAX;
+	init_thread_stat_min_vals(ts_lcl);
 
 	sum_thread_stats(ts_lcl, ts, 1);
 
@@ -1466,22 +1457,12 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
 				   int ver, struct buf_output *out)
 {
 	struct thread_stat *ts_lcl;
-	int i;
 
 	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
 	ts_lcl = malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
 	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		ts_lcl->clat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->slat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->lat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->bw_stat[i].min_val = ULONG_MAX;
-		ts_lcl->iops_stat[i].min_val = ULONG_MAX;
-		ts_lcl->clat_high_prio_stat[i].min_val = ULONG_MAX;
-		ts_lcl->clat_low_prio_stat[i].min_val = ULONG_MAX;
-	}
-	ts_lcl->sync_stat.min_val = ULONG_MAX;
+	init_thread_stat_min_vals(ts_lcl);
 	ts_lcl->lat_percentiles = ts->lat_percentiles;
 	ts_lcl->clat_percentiles = ts->clat_percentiles;
 	ts_lcl->slat_percentiles = ts->slat_percentiles;
@@ -1668,22 +1649,12 @@ static void add_mixed_ddir_status_json(struct thread_stat *ts,
 		struct group_run_stats *rs, struct json_object *parent)
 {
 	struct thread_stat *ts_lcl;
-	int i;
 
 	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
 	ts_lcl = malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
 	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		ts_lcl->clat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->slat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->lat_stat[i].min_val = ULONG_MAX;
-		ts_lcl->bw_stat[i].min_val = ULONG_MAX;
-		ts_lcl->iops_stat[i].min_val = ULONG_MAX;
-		ts_lcl->clat_high_prio_stat[i].min_val = ULONG_MAX;
-		ts_lcl->clat_low_prio_stat[i].min_val = ULONG_MAX;
-	}
-	ts_lcl->sync_stat.min_val = ULONG_MAX;
+	init_thread_stat_min_vals(ts_lcl);
 	ts_lcl->lat_percentiles = ts->lat_percentiles;
 	ts_lcl->clat_percentiles = ts->clat_percentiles;
 	ts_lcl->slat_percentiles = ts->slat_percentiles;
@@ -2270,22 +2241,27 @@ void init_group_run_stat(struct group_run_stats *gs)
 		gs->min_bw[i] = gs->min_run[i] = ~0UL;
 }
 
-void init_thread_stat(struct thread_stat *ts)
+void init_thread_stat_min_vals(struct thread_stat *ts)
 {
-	int j;
+	int i;
 
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		ts->clat_stat[i].min_val = ULONG_MAX;
+		ts->slat_stat[i].min_val = ULONG_MAX;
+		ts->lat_stat[i].min_val = ULONG_MAX;
+		ts->bw_stat[i].min_val = ULONG_MAX;
+		ts->iops_stat[i].min_val = ULONG_MAX;
+		ts->clat_high_prio_stat[i].min_val = ULONG_MAX;
+		ts->clat_low_prio_stat[i].min_val = ULONG_MAX;
+	}
+	ts->sync_stat.min_val = ULONG_MAX;
+}
+
+void init_thread_stat(struct thread_stat *ts)
+{
 	memset(ts, 0, sizeof(*ts));
 
-	for (j = 0; j < DDIR_RWDIR_CNT; j++) {
-		ts->lat_stat[j].min_val = -1UL;
-		ts->clat_stat[j].min_val = -1UL;
-		ts->slat_stat[j].min_val = -1UL;
-		ts->bw_stat[j].min_val = -1UL;
-		ts->iops_stat[j].min_val = -1UL;
-		ts->clat_high_prio_stat[j].min_val = -1UL;
-		ts->clat_low_prio_stat[j].min_val = -1UL;
-	}
-	ts->sync_stat.min_val = -1UL;
+	init_thread_stat_min_vals(ts);
 	ts->groupid = -1;
 }
 
diff --git a/stat.h b/stat.h
index a06237e7..9ef8caa4 100644
--- a/stat.h
+++ b/stat.h
@@ -327,6 +327,7 @@ extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
 extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, bool first);
 extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src);
+extern void init_thread_stat_min_vals(struct thread_stat *ts);
 extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
 extern void eta_to_str(char *str, unsigned long eta_sec);
