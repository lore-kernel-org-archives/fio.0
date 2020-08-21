Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48370 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgHUGhv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Aug 2020 02:37:51 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 6/7] t/zbd: Reset all zones before test when max open zones is specified
Date: Fri, 21 Aug 2020 15:37:38 +0900
Message-Id: <20200821063739.390353-7-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
References: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

When the test target device has maximum open zones limit, the zones in
test target region may not be opened up to the limit, because the zones
out of the test target region may have open zones. To ensure that the
test target zones can be opened up to the limit, reset all zones of the
test target device before the test cases with write work load starts.
Introduce the helper function prep_write() to check if all zone reset is
required and do the reset.

Also remove unnecessary reset_zone calls for test case #29 and #48. These
are no longer required by virtue of the improvement in zbd_setup_files()
to set up zones to meet max_open_zones limit.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c21d6aad..248423bb 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -181,6 +181,15 @@ run_fio_on_seq() {
     run_one_fio_job "${opts[@]}" "$@"
 }
 
+# Prepare for write test by resetting zones. When max_open_zones option is
+# specified, reset all zones of the test target to ensure that zones out of the
+# test target range do not have open zones. This allows the write test to the
+# target range to be able to open zones up to max_open_zones.
+prep_write() {
+	[[ -n "${max_open_zones_opt}" && -n "${is_zbd}" ]] &&
+		reset_zone "${dev}" -1
+}
+
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
@@ -252,6 +261,7 @@ test4() {
 test5() {
     local size off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
@@ -267,6 +277,7 @@ test5() {
 test6() {
     local size off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
@@ -285,6 +296,7 @@ test7() {
     local size=$((zone_size))
     local off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=1 --rw=randwrite	\
@@ -299,6 +311,7 @@ test7() {
 test8() {
     local size off capacity
 
+    prep_write
     size=$((4 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
@@ -319,6 +332,7 @@ test9() {
 	return 0
     fi
 
+    prep_write
     size=$((4 * zone_size))
     run_fio_on_seq --ioengine=sg					\
 		   --iodepth=1 --rw=randwrite --bs=16K			\
@@ -337,6 +351,7 @@ test10() {
 	return 0
     fi
 
+    prep_write
     size=$((4 * zone_size))
     run_fio_on_seq --ioengine=sg 					\
 		   --iodepth=64 --rw=randwrite --bs=16K			\
@@ -350,6 +365,7 @@ test10() {
 test11() {
     local size off capacity
 
+    prep_write
     size=$((4 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
@@ -364,6 +380,7 @@ test11() {
 test12() {
     local size off capacity
 
+    prep_write
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 8 $off $dev)
@@ -378,6 +395,7 @@ test12() {
 test13() {
     local size off capacity
 
+    prep_write
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 8 $off $dev)
@@ -393,6 +411,7 @@ test13() {
 test14() {
     local size
 
+    prep_write
     size=$((16 * 2**20)) # 20 MB
     if [ $size -gt $((first_sequential_zone_sector * 512)) ]; then
 	echo "$dev does not have enough sequential zones" \
@@ -417,6 +436,7 @@ test15() {
 	    reset_zone "$dev" $((first_sequential_zone_sector +
 				 i*sectors_per_zone))
     done
+    prep_write
     w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     w_size=$((2 * zone_size))
     w_capacity=$(total_zone_capacity 2 $w_off $dev)
@@ -441,6 +461,7 @@ test16() {
 	    reset_zone "$dev" $((first_sequential_zone_sector +
 				 i*sectors_per_zone))
     done
+    prep_write
     w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     w_size=$((2 * zone_size))
     w_capacity=$(total_zone_capacity 2 $w_off $dev)
@@ -463,6 +484,7 @@ test17() {
     if [ -n "$is_zbd" ]; then
 	reset_zone "$dev" $((off / 512)) || return $?
     fi
+    prep_write
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw --bs=4K \
 		    --zonemode=zbd --zonesize="${zone_size}"		\
 		    --offset=$off --loops=2 --norandommap=1\
@@ -516,6 +538,7 @@ test24() {
     local bs loops=9 size=$((zone_size))
     local off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
 
@@ -538,6 +561,7 @@ test25() {
         [ -n "$is_zbd" ] &&
 	    reset_zone "$dev" $((first_sequential_zone_sector + i*sectors_per_zone))
     done
+    prep_write
     for ((i=0;i<16;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--thread=1" "--direct=1")
 	opts+=("--offset=$((first_sequential_zone_sector*512 + zone_size*i))")
@@ -552,6 +576,7 @@ write_to_first_seq_zone() {
     local loops=4 r
     local off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
 
@@ -581,6 +606,7 @@ test28() {
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    prep_write
     opts=("--debug=zbd")
     capacity=$(total_zone_capacity 1 $off $dev)
     for ((i=0;i<jobs;i++)); do
@@ -604,7 +630,7 @@ test29() {
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    prep_write
     opts=("--debug=zbd")
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
@@ -623,6 +649,7 @@ test29() {
 test30() {
     local off
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw	\
 		    --bs="$(max $((zone_size / 128)) "$logical_block_size")"\
@@ -636,6 +663,7 @@ test30() {
 test31() {
     local bs inc nz off opts size
 
+    prep_write
     # Start with writing 128 KB to 128 sequential zones.
     bs=128K
     nz=128
@@ -668,6 +696,7 @@ test31() {
 test32() {
     local off opts=() size
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
@@ -684,6 +713,7 @@ test33() {
     local bs io_size size
     local off capacity=0;
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
     size=$((2 * zone_size))
@@ -700,6 +730,7 @@ test33() {
 test34() {
     local size
 
+    prep_write
     size=$((2 * zone_size))
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write --size=$size \
 		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
@@ -711,6 +742,7 @@ test34() {
 test35() {
     local bs off io_size size
 
+    prep_write
     off=$(((first_sequential_zone_sector + 1) * 512))
     size=$((zone_size - 2 * 512))
     bs=$((zone_size / 4))
@@ -725,6 +757,7 @@ test35() {
 test36() {
     local bs off io_size size
 
+    prep_write
     off=$(((first_sequential_zone_sector) * 512))
     size=$((zone_size - 512))
     bs=$((zone_size / 4))
@@ -739,6 +772,7 @@ test36() {
 test37() {
     local bs off size capacity
 
+    prep_write
     capacity=$(total_zone_capacity 1 $first_sequential_zone_sector $dev)
     if [ "$first_sequential_zone_sector" = 0 ]; then
 	off=0
@@ -758,6 +792,7 @@ test37() {
 test38() {
     local bs off size
 
+    prep_write
     size=$((logical_block_size))
     off=$((disk_size - logical_block_size))
     bs=$((logical_block_size))
@@ -828,6 +863,7 @@ test45() {
     local bs i
 
     [ -z "$is_zbd" ] && return 0
+    prep_write
     bs=$((logical_block_size))
     run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
 		    --offset=$((first_sequential_zone_sector * 512)) \
@@ -840,6 +876,7 @@ test45() {
 test46() {
     local size
 
+    prep_write
     size=$((4 * zone_size))
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=4K \
 		   --group_reporting=1 --numjobs=8 \
@@ -851,6 +888,7 @@ test46() {
 test47() {
     local bs
 
+    prep_write
     bs=$((logical_block_size))
     run_fio_on_seq "$(ioengine "psync")" --rw=write --bs=$bs --zoneskip=1 \
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
@@ -865,7 +903,7 @@ test48() {
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    prep_write
     opts=("--aux-path=/tmp" "--allow_file_create=0" "--significant_figures=10")
     opts+=("--debug=zbd")
     opts+=("$(ioengine "libaio")" "--rw=randwrite" "--direct=1")
-- 
2.26.2


