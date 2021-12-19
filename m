Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFF8C433F5
	for <fio@archiver.kernel.org>; Sun, 19 Dec 2021 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhLSNAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 19 Dec 2021 08:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbhLSNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 19 Dec 2021 08:00:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEEBC061574
        for <fio@vger.kernel.org>; Sun, 19 Dec 2021 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=pZrubykCYw6ComLIqu/XDDeI7O7jsoag0HQo4C9xRg4=; b=up1PTb64VDI0nhikFm2rFh4lS+
        BQ898Koylt08ZpPMf85UlK/0iLB/j/bF5Iy5KBl5z87YxUCSS4DeAswUYAtDXAQ40i8YNmVYyehXp
        3mEm5C8j7Bzmxk7L/DHuA0yTr4YHLHNXxaDpHyPTaDw281C4YXdbxComwtnZvbdHRiua+KVd2bkOs
        1OOK8EjNypOSSrxtGcivAUBgapFzxq2xLAfDkFvO8boLn6teESBJHCqcNDEC01Ue4woVciRIWP+1h
        iI7OL+Fh+7efDHhza2K0UdPMjju0DsJRTMdzKkRVsesIupzwPN22BquKlJ0bQyw+jIz0XvAtoxJLx
        Hr6mwAAA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1myvnI-000kde-7E
        for fio@vger.kernel.org; Sun, 19 Dec 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 13D601BC0179; Sun, 19 Dec 2021 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211219130002.13D601BC0179@kernel.dk>
Date:   Sun, 19 Dec 2021 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit e86afa536b175a90546e20d7d19f2418ee1bca78:

  stat: sum sync_stat before reassigning bool first (2021-12-15 08:45:32 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9b46661c289d01dbfe5182189a7abea9ce2f9e04:

  Fio 3.29 (2021-12-18 07:09:32 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      stat: code cleanup and leak free
      Fio 3.29

 FIO-VERSION-GEN |  2 +-
 stat.c          | 84 ++++++++++++++++++++++++++++++++++-----------------------
 2 files changed, 51 insertions(+), 35 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index e9d563c1..60f7bb21 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.28
+DEF_VER=fio-3.29
 
 LF='
 '
diff --git a/stat.c b/stat.c
index ec44c79e..99de1294 100644
--- a/stat.c
+++ b/stat.c
@@ -289,9 +289,10 @@ void show_mixed_group_stats(struct group_run_stats *rs, struct buf_output *out)
 {
 	char *io, *agg, *min, *max;
 	char *ioalt, *aggalt, *minalt, *maxalt;
-	uint64_t io_mix = 0, agg_mix = 0, min_mix = -1, max_mix = 0, min_run = -1, max_run = 0;
-	int i;
+	uint64_t io_mix = 0, agg_mix = 0, min_mix = -1, max_mix = 0;
+	uint64_t min_run = -1, max_run = 0;
 	const int i2p = is_power_of_2(rs->kb_base);
+	int i;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		if (!rs->max_run[i])
@@ -363,9 +364,9 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		free(minalt);
 		free(maxalt);
 	}
-	
+
 	/* Need to aggregate statisitics to show mixed values */
-	if (rs->unified_rw_rep == UNIFIED_BOTH) 
+	if (rs->unified_rw_rep == UNIFIED_BOTH)
 		show_mixed_group_stats(rs, out);
 }
 
@@ -473,30 +474,35 @@ static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, i
 	return p_of_agg;
 }
 
-static void show_mixed_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
-			     struct buf_output *out)
+static void show_mixed_ddir_status(struct group_run_stats *rs,
+				   struct thread_stat *ts,
+				   struct buf_output *out)
 {
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
 	double mean, dev;
 	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st = NULL;
 	struct thread_stat *ts_lcl;
-
 	int i2p;
 	int ddir = 0;
 
-	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
+	/*
+	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
+	 * Trims (ddir = 2) */
 	ts_lcl = malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
+	/* calculate mixed stats  */
+	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
 	init_thread_stat_min_vals(ts_lcl);
 
 	sum_thread_stats(ts_lcl, ts, 1);
 
 	assert(ddir_rw(ddir));
 
-	if (!ts_lcl->runtime[ddir])
+	if (!ts_lcl->runtime[ddir]) {
+		free(ts_lcl);
 		return;
+	}
 
 	i2p = is_power_of_2(rs->kb_base);
 	runt = ts_lcl->runtime[ddir];
@@ -560,10 +566,9 @@ static void show_mixed_ddir_status(struct group_run_stats *rs, struct thread_sta
 		else
 			samples = ts_lcl->clat_stat[ddir].samples;
 
-		/* Only print this if some high and low priority stats were collected */
+		/* Only print if high and low priority stats were collected */
 		if (ts_lcl->clat_high_prio_stat[ddir].samples > 0 &&
-				ts_lcl->clat_low_prio_stat[ddir].samples > 0)
-		{
+				ts_lcl->clat_low_prio_stat[ddir].samples > 0) {
 			sprintf(prio_name, "high prio (%.2f%%) %s",
 					100. * (double) ts_lcl->clat_high_prio_stat[ddir].samples / (double) samples,
 					name);
@@ -1222,9 +1227,8 @@ void show_disk_util(int terse, struct json_object *parent,
 	if (!is_running_backend())
 		return;
 
-	if (flist_empty(&disk_list)) {
+	if (flist_empty(&disk_list))
 		return;
-	}
 
 	if ((output_format & FIO_OUTPUT_JSON) && parent)
 		do_json = true;
@@ -1234,9 +1238,9 @@ void show_disk_util(int terse, struct json_object *parent,
 	if (!terse && !do_json)
 		log_buf(out, "\nDisk stats (read/write):\n");
 
-	if (do_json)
+	if (do_json) {
 		json_object_add_disk_utils(parent, &disk_list);
-	else if (output_format & ~(FIO_OUTPUT_JSON | FIO_OUTPUT_JSON_PLUS)) {
+	} else if (output_format & ~(FIO_OUTPUT_JSON | FIO_OUTPUT_JSON_PLUS)) {
 		flist_for_each(entry, &disk_list) {
 			du = flist_entry(entry, struct disk_util, list);
 
@@ -1396,19 +1400,20 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	else
 		log_buf(out, ";%llu;%llu;%f;%f", 0ULL, 0ULL, 0.0, 0.0);
 
-	if (ts->lat_percentiles)
+	if (ts->lat_percentiles) {
 		len = calc_clat_percentiles(ts->io_u_plat[FIO_LAT][ddir],
 					ts->lat_stat[ddir].samples,
 					ts->percentile_list, &ovals, &maxv,
 					&minv);
-	else if (ts->clat_percentiles)
+	} else if (ts->clat_percentiles) {
 		len = calc_clat_percentiles(ts->io_u_plat[FIO_CLAT][ddir],
 					ts->clat_stat[ddir].samples,
 					ts->percentile_list, &ovals, &maxv,
 					&minv);
-	else
+	} else {
 		len = 0;
-	
+	}
+
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
 		if (i >= len) {
 			log_buf(out, ";0%%=0");
@@ -1435,8 +1440,9 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 		}
 
 		log_buf(out, ";%llu;%llu;%f%%;%f;%f", min, max, p_of_agg, mean, dev);
-	} else
+	} else {
 		log_buf(out, ";%llu;%llu;%f%%;%f;%f", 0ULL, 0ULL, 0.0, 0.0, 0.0);
+	}
 
 	if (ver == 5) {
 		if (bw_stat)
@@ -1458,15 +1464,19 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
 {
 	struct thread_stat *ts_lcl;
 
-	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
+	/*
+	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
+	 * Trims (ddir = 2)
+	 */
 	ts_lcl = malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
+	/* calculate mixed stats  */
+	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
 	init_thread_stat_min_vals(ts_lcl);
 	ts_lcl->lat_percentiles = ts->lat_percentiles;
 	ts_lcl->clat_percentiles = ts->clat_percentiles;
 	ts_lcl->slat_percentiles = ts->slat_percentiles;
-	ts_lcl->percentile_precision = ts->percentile_precision;		
+	ts_lcl->percentile_precision = ts->percentile_precision;
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
 	
 	sum_thread_stats(ts_lcl, ts, 1);
@@ -1476,8 +1486,10 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
 	free(ts_lcl);
 }
 
-static struct json_object *add_ddir_lat_json(struct thread_stat *ts, uint32_t percentiles,
-		struct io_stat *lat_stat, uint64_t *io_u_plat)
+static struct json_object *add_ddir_lat_json(struct thread_stat *ts,
+					     uint32_t percentiles,
+					     struct io_stat *lat_stat,
+					     uint64_t *io_u_plat)
 {
 	char buf[120];
 	double mean, dev;
@@ -1650,15 +1662,19 @@ static void add_mixed_ddir_status_json(struct thread_stat *ts,
 {
 	struct thread_stat *ts_lcl;
 
-	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
+	/*
+	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
+	 * Trims (ddir = 2)
+	 */
 	ts_lcl = malloc(sizeof(struct thread_stat));
 	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
-	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
+	/* calculate mixed stats  */
+	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
 	init_thread_stat_min_vals(ts_lcl);
 	ts_lcl->lat_percentiles = ts->lat_percentiles;
 	ts_lcl->clat_percentiles = ts->clat_percentiles;
 	ts_lcl->slat_percentiles = ts->slat_percentiles;
-	ts_lcl->percentile_precision = ts->percentile_precision;		
+	ts_lcl->percentile_precision = ts->percentile_precision;
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
 
 	sum_thread_stats(ts_lcl, ts, 1);
@@ -2133,7 +2149,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
 
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
-		if (!(dst->unified_rw_rep == UNIFIED_MIXED)) {
+		if (dst->unified_rw_rep != UNIFIED_MIXED) {
 			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
 			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], first, false);
 			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], first, false);
@@ -2188,7 +2204,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
 
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
-		if (!(dst->unified_rw_rep == UNIFIED_MIXED)) {
+		if (dst->unified_rw_rep != UNIFIED_MIXED) {
 			dst->total_io_u[k] += src->total_io_u[k];
 			dst->short_io_u[k] += src->short_io_u[k];
 			dst->drop_io_u[k] += src->drop_io_u[k];
@@ -2204,7 +2220,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	for (k = 0; k < FIO_LAT_CNT; k++)
 		for (l = 0; l < DDIR_RWDIR_CNT; l++)
 			for (m = 0; m < FIO_IO_U_PLAT_NR; m++)
-				if (!(dst->unified_rw_rep == UNIFIED_MIXED))
+				if (dst->unified_rw_rep != UNIFIED_MIXED)
 					dst->io_u_plat[k][l][m] += src->io_u_plat[k][l][m];
 				else
 					dst->io_u_plat[k][0][m] += src->io_u_plat[k][l][m];
@@ -2214,7 +2230,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
 		for (m = 0; m < FIO_IO_U_PLAT_NR; m++) {
-			if (!(dst->unified_rw_rep == UNIFIED_MIXED)) {
+			if (dst->unified_rw_rep != UNIFIED_MIXED) {
 				dst->io_u_plat_high_prio[k][m] += src->io_u_plat_high_prio[k][m];
 				dst->io_u_plat_low_prio[k][m] += src->io_u_plat_low_prio[k][m];
 			} else {
