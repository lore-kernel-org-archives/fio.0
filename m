Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfBHNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Feb 2019 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gs5lD-0001pS-Jh
        for fio@vger.kernel.org; Fri, 08 Feb 2019 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190208130001.C82A52C01B5@kernel.dk>
Date: Fri,  8 Feb 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fda82fda074d910fd2939d004b3a73c06da40445:

  Improve wording in REPORTING-BUGS (2019-02-04 09:01:48 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e5eb6fbf91617be0c7d74147165909a493c90136:

  stat: put 'percentiles' object in appropriate 'clat_ns' or 'lat_ns' parent (2019-02-07 09:48:46 -0700)

----------------------------------------------------------------
Vincent Fu (2):
      stat: clean up calc_clat_percentiles
      stat: put 'percentiles' object in appropriate 'clat_ns' or 'lat_ns' parent

 stat.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 351c49cc..c1f46e1d 100644
--- a/stat.c
+++ b/stat.c
@@ -139,7 +139,6 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 {
 	unsigned long long sum = 0;
 	unsigned int len, i, j = 0;
-	unsigned int oval_len = 0;
 	unsigned long long *ovals = NULL;
 	bool is_last;
 
@@ -161,6 +160,10 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 	if (len > 1)
 		qsort((void *)plist, len, sizeof(plist[0]), double_cmp);
 
+	ovals = malloc(len * sizeof(*ovals));
+	if (!ovals)
+		return 0;
+
 	/*
 	 * Calculate bucket values, note down max and min values
 	 */
@@ -170,11 +173,6 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 		while (sum >= (plist[j].u.f / 100.0 * nr)) {
 			assert(plist[j].u.f <= 100.0);
 
-			if (j == oval_len) {
-				oval_len += 100;
-				ovals = realloc(ovals, oval_len * sizeof(*ovals));
-			}
-
 			ovals[j] = plat_idx_to_val(i);
 			if (ovals[j] < *minv)
 				*minv = ovals[j];
@@ -1090,7 +1088,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		len = 0;
 
 	percentile_object = json_create_object();
-	json_object_add_value_object(tmp_object, "percentile", percentile_object);
+	if (ts->clat_percentiles)
+		json_object_add_value_object(tmp_object, "percentile", percentile_object);
 	for (i = 0; i < len; i++) {
 		snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
 		json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
@@ -1129,6 +1128,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_int(tmp_object, "max", max);
 	json_object_add_value_float(tmp_object, "mean", mean);
 	json_object_add_value_float(tmp_object, "stddev", dev);
+	if (ts->lat_percentiles)
+		json_object_add_value_object(tmp_object, "percentile", percentile_object);
 	if (output_format & FIO_OUTPUT_JSON_PLUS && ts->lat_percentiles)
 		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
 

