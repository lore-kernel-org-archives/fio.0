Return-Path: <prvs=4448e3298=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/6] t/zbd: Support testing zone capacity smaller than zone size
Date: Wed,  1 Jul 2020 17:30:27 +0900
Message-Id: <20200701083029.140741-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200701083029.140741-1-shinichiro.kawasaki@wdc.com>
References: <20200701083029.140741-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Hans Holmberg <hans.holmberg@wdc.com>

Add support for testing zoned block devices where zone capacity is less
than zone size. If the test case runs sequential workloads or workloads
with verify, use zone capacity instead of zone size to complete.

To use zone capacity of the test target zones, introduce a helper
function total_zone_capacity() which sums up zone capacity numbers of the
test target zones.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions        |  37 +++++++++++++++
 t/zbd/test-zbd-support | 100 ++++++++++++++++++++++++++---------------
 2 files changed, 102 insertions(+), 35 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 344836c8..82d64f5c 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -84,6 +84,43 @@ first_sequential_zone() {
     fi
 }
 
+# Reports the summed zone capacity of $1 number of zones starting from offset $2
+# on device $3.
+total_zone_capacity() {
+	local nr_zones=$1
+	local sector=$(($2 / 512))
+	local dev=$3
+	local capacity=0 num
+	local grep_str
+
+	if [ -z "$is_zbd" ]; then
+		# For regular block devices, handle zone size as zone capacity.
+		echo $((zone_size * nr_zones))
+		return
+	fi
+
+	if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
+		if blkzone_reports_capacity "${dev}"; then
+			grep_str='cap \K[0-9a-zA-Z]*'
+		else
+			# If zone capacity is not reported, refer zone length.
+			grep_str='len \K[0-9a-zA-Z]*'
+		fi
+		while read num; do
+			capacity=$((capacity + num))
+		done < <(${blkzone} report -c "$nr_zones" -o "$sector" "$dev" |
+				grep -Po "${grep_str}")
+	else
+		# ZBC devices do not have zone capacity. Use zone size.
+		while read num; do
+			capacity=$((capacity + num))
+		done < <(${zbc_report_zones} -nz "$nr_zones" -start "$sector" \
+				"$dev" | grep -Po 'sector [0-9]*, \K[0-9]*')
+	fi
+
+	echo $((capacity * 512))
+}
+
 max_open_zones() {
     local dev=$1
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index f086bd10..31718c95 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -204,55 +204,64 @@ test4() {
 
 # Sequential write to sequential zones.
 test5() {
-    local size
+    local size off capacity
 
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Sequential read from sequential zones.
 test6() {
-    local size
+    local size off capacity
 
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
     write_and_run_one_fio_job \
 	    $((first_sequential_zone_sector * 512)) "${size}" \
-	    --offset=$((first_sequential_zone_sector * 512)) \
+	    --offset="${off}" \
 	    --size="${size}" --zonemode=zbd --zonesize="${zone_size}" \
 	    "$(ioengine "psync")" --iodepth=1 --rw=read \
 	    --bs="$(max $((zone_size / 64)) "$logical_block_size")" \
 	    >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_read $size || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, libaio, queue depth 1.
 test7() {
     local size=$((zone_size))
+    local off capacity
 
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 1 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=1 --rw=randwrite	\
 		   --bs="$(min 16384 "${zone_size}")"			\
 		   --do_verify=1 --verify=md5 --size="$size"		\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, libaio, queue depth 64.
 test8() {
-    local size
+    local size off capacity
 
     size=$((4 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite	\
 		   --bs="$(min 16384 "${zone_size}")"			\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, sg, queue depth 1.
@@ -293,39 +302,45 @@ test10() {
 
 # Random write to sequential zones, libaio, queue depth 64, random block size.
 test11() {
-    local size
+    local size off capacity
 
     size=$((4 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite	\
 		   --bsrange=4K-64K --do_verify=1 --verify=md5		\
 		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, libaio, queue depth 64, max 1 open zone.
 test12() {
-    local size
+    local size off capacity
 
     size=$((8 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 8 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		   --max_open_zones=1 --size=$size --do_verify=1 --verify=md5 \
 		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, libaio, queue depth 64, max 4 open zones.
 test13() {
-    local size
+    local size off capacity
 
     size=$((8 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 8 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		   --max_open_zones=4 --size=$size --do_verify=1 --verify=md5 \
 		   --debug=zbd						      \
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to conventional zones.
@@ -349,7 +364,7 @@ test14() {
 # Sequential read on a mix of empty and full zones.
 test15() {
     local i off size
-    local w_off w_size
+    local w_off w_size w_capacity
 
     for ((i=0;i<4;i++)); do
 	[ -n "$is_zbd" ] &&
@@ -358,6 +373,7 @@ test15() {
     done
     w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     w_size=$((2 * zone_size))
+    w_capacity=$(total_zone_capacity 2 $w_off $dev)
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
     write_and_run_one_fio_job "${w_off}" "${w_size}" \
@@ -365,14 +381,14 @@ test15() {
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$((size)) >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
-    check_written $((w_size)) || return $?
-    check_read $((size / 2))
+    check_written $((w_capacity)) || return $?
+    check_read $((w_capacity))
 }
 
 # Random read on a mix of empty and full zones.
 test16() {
     local off size
-    local i w_off w_size
+    local i w_off w_size w_capacity
 
     for ((i=0;i<4;i++)); do
 	[ -n "$is_zbd" ] &&
@@ -381,13 +397,14 @@ test16() {
     done
     w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     w_size=$((2 * zone_size))
+    w_capacity=$(total_zone_capacity 2 $w_off $dev)
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
     write_and_run_one_fio_job "${w_off}" "${w_size}" \
 		    "$(ioengine "libaio")" --iodepth=64 --rw=randread --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$size >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $w_size || return $?
+    check_written $w_capacity || return $?
     check_read $size || return $?
 }
 
@@ -451,13 +468,17 @@ test23() {
 
 test24() {
     local bs loops=9 size=$((zone_size))
+    local off capacity
+
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 1 $off $dev)
 
     bs=$(min $((256*1024)) "$zone_size")
     run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs"		\
 		   --size=$size --loops=$loops				\
 		   --zone_reset_frequency=.01 --zone_reset_threshold=.90 \
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((size * loops)) || return $?
+    check_written $((capacity * loops)) || return $?
     check_reset_count -eq 8 ||
 	check_reset_count -eq 9 ||
 	check_reset_count -eq 10 || return $?
@@ -483,15 +504,19 @@ test25() {
 
 write_to_first_seq_zone() {
     local loops=4 r
+    local off capacity
+
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 1 $off $dev)
 
     r=$(((RANDOM << 16) | RANDOM))
     run_fio --name="$dev" --filename="$dev" "$(ioengine "psync")" --rw="$1" \
 	    --thread=1 --do_verify=1 --verify=md5 --direct=1 --bs=4K	\
-	    --offset=$((first_sequential_zone_sector * 512))		\
-	    "--size=$zone_size" --loops=$loops --randseed="$r"		\
+	    --offset=$off						\
+	    --size=$zone_size --loops=$loops --randseed="$r"		\
 	    --zonemode=zbd --zonesize="${zone_size}" --group_reporting=1	\
 	    --gtod_reduce=1 >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((loops * zone_size)) || return $?
+    check_written $((loops * capacity)) || return $?
 }
 
 # Overwrite the first sequential zone four times sequentially.
@@ -511,15 +536,16 @@ test28() {
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts=("--debug=zbd")
+    capacity=$(total_zone_capacity 1 $off $dev)
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
-	opts+=("--size=$zone_size" "$(ioengine "psync")" "--rw=randwrite")
+	opts+=("--size=$zone_size" "--io_size=$capacity" "$(ioengine "psync")" "--rw=randwrite")
 	opts+=("--thread=1" "--direct=1" "--zonemode=zbd")
 	opts+=("--zonesize=${zone_size}" "--group_reporting=1")
 	opts+=(${var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((jobs * zone_size)) || return $?
+    check_written $((jobs * $capacity)) || return $?
     check_reset_count -eq $jobs ||
 	check_reset_count -eq $((jobs - 1)) ||
 	return $?
@@ -608,10 +634,13 @@ test32() {
 # zone size.
 test33() {
     local bs io_size size
+    local off capacity=0;
 
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 1 $off $dev)
     size=$((2 * zone_size))
-    io_size=$((5 * zone_size))
-    bs=$((3 * zone_size / 4))
+    io_size=$((5 * capacity))
+    bs=$((3 * capacity / 4))
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
@@ -660,8 +689,9 @@ test36() {
 
 # Test 3/4 for the I/O boundary rounding code: $size > $zone_size.
 test37() {
-    local bs off size
+    local bs off size capacity
 
+    capacity=$(total_zone_capacity 1 $first_sequential_zone_sector $dev)
     if [ "$first_sequential_zone_sector" = 0 ]; then
 	off=0
     else
@@ -673,7 +703,7 @@ test37() {
 		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
 		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1
-    check_written $((zone_size)) || return $?
+    check_written $capacity || return $?
 }
 
 # Test 4/4 for the I/O boundary rounding code: $offset > $disk_size - $zone_size
-- 
2.26.2


