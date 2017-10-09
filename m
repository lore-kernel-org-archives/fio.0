Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 2/2] stat: update json+ output format for --lat_percentiles option
Date: Mon,  9 Oct 2017 10:47:12 -0400
Message-Id: <1507560432-28946-3-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1507560432-28946-1-git-send-email-vincentfu@gmail.com>
References: <1507560432-28946-1-git-send-email-vincentfu@gmail.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

If --lat_percentiles is set to 1, change the json+ output format
so that the bins are inside the 'lat_ns' object.

Also update fio_jsonplus_clat2csv to look in the two possible
locations.
---
 stat.c                      |  9 +++++++--
 tools/fio_jsonplus_clat2csv | 12 ++++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/stat.c b/stat.c
index 09afa5b..c5a68ad 100644
--- a/stat.c
+++ b/stat.c
@@ -962,7 +962,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	unsigned int len;
 	int i;
 	const char *ddirname[] = {"read", "write", "trim"};
-	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object;
+	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object = NULL;
 	char buf[120];
 	double p_of_agg = 100.0;
 
@@ -1036,7 +1036,9 @@ static void add_ddir_status_json(struct thread_stat *ts,
 
 	if (output_format & FIO_OUTPUT_JSON_PLUS) {
 		clat_bins_object = json_create_object();
-		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+		if (ts->clat_percentiles)
+			json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+
 		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
 			if (ts->io_u_plat[ddir][i]) {
 				snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
@@ -1055,6 +1057,9 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_int(tmp_object, "max", max);
 	json_object_add_value_float(tmp_object, "mean", mean);
 	json_object_add_value_float(tmp_object, "stddev", dev);
+	if (output_format & FIO_OUTPUT_JSON_PLUS && ts->lat_percentiles)
+		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+
 	if (ovals)
 		free(ovals);
 
diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
index d4ac16e..64fdc9f 100755
--- a/tools/fio_jsonplus_clat2csv
+++ b/tools/fio_jsonplus_clat2csv
@@ -107,8 +107,16 @@ def main():
 
         prev_ddir = None
         for ddir in ddir_set:
+            if 'bins' in jsondata['jobs'][jobnum][ddir]['clat_ns']:
+                bins_loc = 'clat_ns'
+            elif 'bins' in jsondata['jobs'][jobnum][ddir]['lat_ns']:
+                bins_loc = 'lat_ns'
+            else:
+                raise RuntimeError("Latency bins not found. "
+                                   "Are you sure you are using json+ output?")
+
             bins[ddir] = [[int(key), value] for key, value in
-                          jsondata['jobs'][jobnum][ddir]['clat_ns']
+                          jsondata['jobs'][jobnum][ddir][bins_loc]
                           ['bins'].iteritems()]
             bins[ddir] = sorted(bins[ddir], key=lambda bin: bin[0])
 
@@ -123,7 +131,7 @@ def main():
         outfile = stub + '_job' + str(jobnum) + ext
 
         with open(outfile, 'w') as output:
-            output.write("clat_nsec, ")
+            output.write("{0}ec, ".format(bins_loc))
             ddir_list = list(ddir_set)
             for ddir in ddir_list:
                 output.write("{0}_count, {0}_cumulative, {0}_percentile, ".
-- 
2.7.4


