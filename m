Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625D3C433F5
	for <fio@archiver.kernel.org>; Tue, 11 Jan 2022 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbiAKNAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Jan 2022 08:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236707AbiAKNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jan 2022 08:00:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183E2C06173F
        for <fio@vger.kernel.org>; Tue, 11 Jan 2022 05:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=VIDGgNDe9Nu1T07AOUDDPG2ncYyPzHbWpNS690BotOs=; b=Ir/s4IXNkwkQiWbF3W4o2PIvF3
        Hctz35Uy9mA+rf1qk7NK4r/ZqwCnbp2JrZM0tZ+VFRPTDqB3tsRZeG+dUZv5fsFk+aR5yheWOtHTE
        7G3IplbS+4+NczUVO8yV8Qdk4NzlGXjCjeAgbHUszQndTEGgvPGhIUkGQjl/MhUzweqH2Fms22Iey
        sdv09jm4jLSjFqg8/sth9TwdqhS5uTEANfk5DvZFB7yPN8+ryHgLY+vtyQuSLE3kKA3vprDhqfkyw
        YYtHGkzZN06gb3ntKKuFNxg60wKUfc5WtmfgADVbKDrjZRlB+va8hDhBJlGMwyd5U+YrpasgtiKzm
        vIOv4Brg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7Gkx-000bxI-02
        for fio@vger.kernel.org; Tue, 11 Jan 2022 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id ED05A1BC0126; Tue, 11 Jan 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220111130001.ED05A1BC0126@kernel.dk>
Date:   Tue, 11 Jan 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b5e99df6ec605b4dc6a3488203f32d5c5bfce8df:

  engines/io_uring: don't set CQSIZE clamp unconditionally (2022-01-09 19:34:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 016869bebe9bef7cae5a7f9dc0762162b0612226:

  stat: remove unnecessary bool parameter to sum_thread_stats() (2022-01-10 09:22:14 -0700)

----------------------------------------------------------------
Niklas Cassel (1):
      stat: remove unnecessary bool parameter to sum_thread_stats()

 client.c      |  2 +-
 gclient.c     |  2 +-
 rate-submit.c |  2 +-
 stat.c        | 53 +++++++++++++++++++++++------------------------------
 stat.h        |  2 +-
 5 files changed, 27 insertions(+), 34 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 8b230617..be8411d8 100644
--- a/client.c
+++ b/client.c
@@ -1111,7 +1111,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 	if (sum_stat_clients <= 1)
 		return;
 
-	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr == 1);
+	sum_thread_stats(&client_ts, &p->ts);
 	sum_group_stats(&client_gs, &p->rs);
 
 	client_ts.members++;
diff --git a/gclient.c b/gclient.c
index e0e0e7bf..ac063536 100644
--- a/gclient.c
+++ b/gclient.c
@@ -292,7 +292,7 @@ static void gfio_thread_status_op(struct fio_client *client,
 	if (sum_stat_clients == 1)
 		return;
 
-	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr == 1);
+	sum_thread_stats(&client_ts, &p->ts);
 	sum_group_stats(&client_gs, &p->rs);
 
 	client_ts.members++;
diff --git a/rate-submit.c b/rate-submit.c
index 13dbe7a2..752c30a5 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -195,7 +195,7 @@ static void io_workqueue_exit_worker_fn(struct submit_worker *sw,
 	struct thread_data *td = sw->priv;
 
 	(*sum_cnt)++;
-	sum_thread_stats(&sw->wq->td->ts, &td->ts, *sum_cnt == 1);
+	sum_thread_stats(&sw->wq->td->ts, &td->ts);
 
 	fio_options_free(td);
 	close_and_free_files(td);
diff --git a/stat.c b/stat.c
index 99de1294..36742a25 100644
--- a/stat.c
+++ b/stat.c
@@ -495,7 +495,7 @@ static void show_mixed_ddir_status(struct group_run_stats *rs,
 	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
 	init_thread_stat_min_vals(ts_lcl);
 
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
 
 	assert(ddir_rw(ddir));
 
@@ -1479,7 +1479,7 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
 	ts_lcl->percentile_precision = ts->percentile_precision;
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
 	
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
 
 	/* add the aggregated stats to json parent */
 	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
@@ -1677,7 +1677,7 @@ static void add_mixed_ddir_status_json(struct thread_stat *ts,
 	ts_lcl->percentile_precision = ts->percentile_precision;
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
 
-	sum_thread_stats(ts_lcl, ts, 1);
+	sum_thread_stats(ts_lcl, ts);
 
 	/* add the aggregated stats to json parent */
 	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
@@ -2089,9 +2089,10 @@ static void __sum_stat(struct io_stat *dst, struct io_stat *src, bool first)
  * numbers. For group_reporting, we should just add those up, not make
  * them the mean of everything.
  */
-static void sum_stat(struct io_stat *dst, struct io_stat *src, bool first,
-		     bool pure_sum)
+static void sum_stat(struct io_stat *dst, struct io_stat *src, bool pure_sum)
 {
+	bool first = dst->samples == 0;
+
 	if (src->samples == 0)
 		return;
 
@@ -2141,49 +2142,41 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->sig_figs = src->sig_figs;
 }
 
-void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
-		      bool first)
+void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
 {
 	int k, l, m;
 
-	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
-
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
 		if (dst->unified_rw_rep != UNIFIED_MIXED) {
-			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
-			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], first, false);
-			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], first, false);
-			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first, false);
-			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first, false);
-			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first, true);
-			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], first, true);
+			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], false);
+			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], false);
+			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], false);
+			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], false);
+			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], false);
+			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], true);
+			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], true);
 
 			dst->io_bytes[l] += src->io_bytes[l];
 
 			if (dst->runtime[l] < src->runtime[l])
 				dst->runtime[l] = src->runtime[l];
 		} else {
-			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], first, false);
-			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], first, false);
-			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], first, false);
-			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first, false);
-			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first, false);
-			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first, true);
-			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], first, true);
+			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], false);
+			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], false);
+			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], false);
+			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], false);
+			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], false);
+			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], true);
+			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], true);
 
 			dst->io_bytes[0] += src->io_bytes[l];
 
 			if (dst->runtime[0] < src->runtime[l])
 				dst->runtime[0] = src->runtime[l];
-
-			/*
-			 * We're summing to the same destination, so override
-			 * 'first' after the first iteration of the loop
-			 */
-			first = false;
 		}
 	}
 
+	sum_stat(&dst->sync_stat, &src->sync_stat, false);
 	dst->usr_time += src->usr_time;
 	dst->sys_time += src->sys_time;
 	dst->ctx += src->ctx;
@@ -2417,7 +2410,7 @@ void __show_run_stats(void)
 		for (k = 0; k < ts->nr_block_infos; k++)
 			ts->block_infos[k] = td->ts.block_infos[k];
 
-		sum_thread_stats(ts, &td->ts, idx == 1);
+		sum_thread_stats(ts, &td->ts);
 
 		if (td->o.ss_dur) {
 			ts->ss_state = td->ss.state;
diff --git a/stat.h b/stat.h
index 9ef8caa4..15ca4eff 100644
--- a/stat.h
+++ b/stat.h
@@ -325,7 +325,7 @@ extern void __show_run_stats(void);
 extern int __show_running_run_stats(void);
 extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
-extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, bool first);
+extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src);
 extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src);
 extern void init_thread_stat_min_vals(struct thread_stat *ts);
 extern void init_thread_stat(struct thread_stat *ts);
