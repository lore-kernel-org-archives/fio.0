Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 1/6] stat: change json+ output format so that instead of printing the raw clat data structure, use actual durations instead of array indices and print only bins with nonzero counts
Date: Sun, 16 Apr 2017 15:04:23 -0400
Message-Id: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@sandisk.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <Vincent.Fu@sandisk.com>

---
 stat.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/stat.c b/stat.c
index fde7af2..4a6e1b9 100644
--- a/stat.c
+++ b/stat.c
@@ -98,7 +98,7 @@ static unsigned int plat_val_to_idx(unsigned int val)
  * Convert the given index of the bucket array to the value
  * represented by the bucket
  */
-static unsigned int plat_idx_to_val(unsigned int idx)
+static unsigned long long plat_idx_to_val(unsigned int idx)
 {
 	unsigned int error_bits, k, base;
 
@@ -972,12 +972,11 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		clat_bins_object = json_create_object();
 		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
 		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
-			snprintf(buf, sizeof(buf), "%d", i);
-			json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
+			if (ts->io_u_plat[ddir][i]) {
+				snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
+				json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
+			}
 		}
-		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_BITS", FIO_IO_U_PLAT_BITS);
-		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_VAL", FIO_IO_U_PLAT_VAL);
-		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_NR", FIO_IO_U_PLAT_NR);
 	}
 
 	if (!calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev)) {
-- 
2.7.4


