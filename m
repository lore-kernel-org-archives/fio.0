Return-Path: <prvs=782ebe97f=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 3/3] t/zbd: Fix write target zones counting in test case #31
Date: Fri,  4 Jun 2021 14:33:51 +0900
Message-Id: <20210604053351.763028-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210604053351.763028-1-shinichiro.kawasaki@wdc.com>
References: <20210604053351.763028-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The test case #31 in t/zbd/test-zbd-support writes 128KB data to
sequential write required zones as the preparation for the following
random read test. The data write leaves the target zones in open status.
The test case refers the variable 'nz', which has max_open_zones value,
to decide how many zones to write the data. However, the end condition
of the write target zone loop has a bug. The disk end offset is used as
the loop end condition, which does not match the last target zone when
number of sequential write required zones divided by nz has remainder.
This results in write to more zones than nz=max_open_zones limit and the
test case failure. To fix the bug and to simplify the script, avoid the
loop and utilize zonemode strided to achieve the same data write
pattern. Also specify size and io_size using nz to reliably count the
write target zones.

Even with the fix above, still the number of open zones may exceed
max_open_zones since other test cases executed before the test case 31
may leave open zones on the test target device. To avoid this failure,
reset all zones before the data write.

The failures were observed with libzbc I/O engine after the commit
e8267436fd7a ("engines/libzbc: add support for the get_max_open_zones io
op"), which changed the max_open_zones value fio refers.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 015fa1dc..a684f988 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -731,32 +731,28 @@ test30() {
 test31() {
     local bs inc nz off opts size
 
-    prep_write
-    # Start with writing 128 KB to max_open_zones sequential zones.
-    bs=128K
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+    # As preparation, write 128 KB to sequential write required zones. Limit
+    # write target zones up to max_open_zones to keep test time reasonable.
+    # To distribute the write target zones evenly, skip certain zones for every
+    # write. Utilize zonemode strided for such write patterns.
+    bs=$((128 * 1024))
     nz=$((max_open_zones))
     if [[ $nz -eq 0 ]]; then
 	nz=128
     fi
-    # shellcheck disable=SC2017
-    inc=$(((disk_size - (first_sequential_zone_sector * 512)) / (nz * zone_size)
-	   * zone_size))
-    if [ "$inc" -eq 0 ]; then
-	require_seq_zones $nz || return $SKIP_TESTCASE
-    fi
-    opts=()
-    for ((off = first_sequential_zone_sector * 512; off < disk_size;
-	  off += inc)); do
-	opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--io_size=$bs")
-	opts+=("--bs=$bs" "--size=$zone_size" "$(ioengine "libaio")")
-	opts+=("--rw=write" "--direct=1" "--thread=1" "--stats=0")
-	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-	opts+=(${job_var_opts[@]})
-    done
-    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
-    # Next, run the test.
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
+    inc=$(((size / nz / zone_size) * zone_size))
+    opts=("--name=$dev" "--filename=$dev" "--rw=write" "--bs=${bs}")
+    opts+=("--offset=$off" "--size=$((inc * nz))" "--io_size=$((bs * nz))")
+    opts+=("--zonemode=strided" "--zonesize=${bs}" "--zonerange=${inc}")
+    opts+=("--direct=1")
+    echo "fio ${opts[@]}" >> "${logfile}.${test_number}"
+    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
+
+    # Next, run the test.
     opts=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
     opts+=("--bs=$bs" "$(ioengine "psync")" "--rw=randread" "--direct=1")
     opts+=("--thread=1" "--time_based" "--runtime=30" "--zonemode=zbd")
-- 
2.31.1


