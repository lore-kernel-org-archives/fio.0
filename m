Return-Path: <prvs=439ee04d1=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 6/8] t/zbd: Combine write and read fio commands for test case #16
Date: Fri, 26 Jun 2020 18:43:29 +0900
Message-Id: <20200626094331.418309-7-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
References: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The test case #16 checks result of read job which runs after write job of
test case #15. It does not work if test case #16 is executed alone with
the -t option and the target device has all zones empty.

Specify both the write job and the read job to a single fio command using
write_and_run_one_fio_job() helper function instead of run_one_fio_job().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index cd8492ff..a3ecec1f 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -369,15 +369,25 @@ test15() {
     check_read $((size / 2))
 }
 
-# Random read on a mix of empty and full zones. Must be run after test15.
+# Random read on a mix of empty and full zones.
 test16() {
     local off size
+    local i w_off w_size
 
+    for ((i=0;i<4;i++)); do
+	[ -n "$is_zbd" ] &&
+	    reset_zone "$dev" $((first_sequential_zone_sector +
+				 i*sectors_per_zone))
+    done
+    w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
+    w_size=$((2 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
-    run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randread --bs=16K \
+    write_and_run_one_fio_job "${w_off}" "${w_size}" \
+		    "$(ioengine "libaio")" --iodepth=64 --rw=randread --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$size >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $w_size || return $?
     check_read $size || return $?
 }
 
-- 
2.26.2


