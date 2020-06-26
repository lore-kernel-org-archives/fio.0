Return-Path: <prvs=439ee04d1=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 5/8] t/zbd: Combine write and read fio commands for test case #15
Date: Fri, 26 Jun 2020 18:43:28 +0900
Message-Id: <20200626094331.418309-6-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
References: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The test case #15 called fio twice. Once with write job to prepare data
to read. The other with read job for testing. But the first run has no
effect on the second run when the zone status is reinitialized.

Specify both the write job and the read job to a single fio command using
write_and_run_one_fio_job() helper function instead of run_one_fio_job().

Also apply same test pass condition for both regular block devices and
zoned block devices.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index eccb5178..cd8492ff 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -349,30 +349,24 @@ test14() {
 # Sequential read on a mix of empty and full zones.
 test15() {
     local i off size
+    local w_off w_size
 
     for ((i=0;i<4;i++)); do
 	[ -n "$is_zbd" ] &&
 	    reset_zone "$dev" $((first_sequential_zone_sector +
 				 i*sectors_per_zone))
     done
-    off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
-    size=$((2 * zone_size))
-    run_one_fio_job "$(ioengine "psync")" --rw=write --bs=$((zone_size / 16))\
-		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
-		    --size=$size >>"${logfile}.${test_number}" 2>&1 ||
-	return $?
-    check_written $size || return $?
+    w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
+    w_size=$((2 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
-    run_one_fio_job "$(ioengine "psync")" --rw=read --bs=$((zone_size / 16)) \
+    write_and_run_one_fio_job "${w_off}" "${w_size}" \
+		    "$(ioengine "psync")" --rw=read --bs=$((zone_size / 16)) \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$((size)) >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
-    if [ -n "$is_zbd" ]; then
-	check_read $((size / 2))
-    else
-	check_read $size
-    fi
+    check_written $((w_size)) || return $?
+    check_read $((size / 2))
 }
 
 # Random read on a mix of empty and full zones. Must be run after test15.
-- 
2.26.2


