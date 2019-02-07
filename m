Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/2] stat: put 'percentiles' object in appropriate 'clat_ns' or 'lat_ns' parent
Date: Thu,  7 Feb 2019 10:51:07 -0500
Message-Id: <20190207155107.7148-3-vincentfu@gmail.com>
In-Reply-To: <20190207155107.7148-1-vincentfu@gmail.com>
References: <20190207155107.7148-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

In the JSON output, the 'percentiles' object currently always appears within the
'clat_ns' object. Put it inside the 'lat_ns' object when --lat_percentiles=1 is set.
---
 stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index 7c843e6b..c1f46e1d 100644
--- a/stat.c
+++ b/stat.c
@@ -1088,7 +1088,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		len = 0;
 
 	percentile_object = json_create_object();
-	json_object_add_value_object(tmp_object, "percentile", percentile_object);
+	if (ts->clat_percentiles)
+		json_object_add_value_object(tmp_object, "percentile", percentile_object);
 	for (i = 0; i < len; i++) {
 		snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
 		json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
@@ -1127,6 +1128,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_int(tmp_object, "max", max);
 	json_object_add_value_float(tmp_object, "mean", mean);
 	json_object_add_value_float(tmp_object, "stddev", dev);
+	if (ts->lat_percentiles)
+		json_object_add_value_object(tmp_object, "percentile", percentile_object);
 	if (output_format & FIO_OUTPUT_JSON_PLUS && ts->lat_percentiles)
 		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
 
-- 
2.17.1


