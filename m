Return-Path: <prvs=439ee04d1=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/8] t/zbd: Combine write and read fio commands for test case #6
Date: Fri, 26 Jun 2020 18:43:27 +0900
Message-Id: <20200626094331.418309-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
References: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The test case #6 checks result of the read job which reads data written
by the write job of test case #5. It does not work if test case #6 is
executed alone with the -t option and the target device has all zones
empty.

Specify both the write job and the read job to a single fio command
using write_and_run_one_fio_job() helper function instead of
run_fio_on_seq() helper function.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 55363357..eccb5178 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -215,14 +215,18 @@ test5() {
     check_read $size || return $?
 }
 
-# Sequential read from sequential zones. Must be run after test5.
+# Sequential read from sequential zones.
 test6() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=read	\
-		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
-		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    write_and_run_one_fio_job \
+	    $((first_sequential_zone_sector * 512)) "${size}" \
+	    --offset=$((first_sequential_zone_sector * 512)) \
+	    --size="${size}" --zonemode=zbd --zonesize="${zone_size}" \
+	    "$(ioengine "psync")" --iodepth=1 --rw=read \
+	    --bs="$(max $((zone_size / 64)) "$logical_block_size")" \
+	    >>"${logfile}.${test_number}" 2>&1 || return $?
     check_read $size || return $?
 }
 
-- 
2.26.2


