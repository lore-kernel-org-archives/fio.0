Return-Path: <prvs=35932a8d3=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4/4] t/zbd: Add support for libzbc IO engine tests
Date: Tue,  7 Apr 2020 10:59:00 +0900
Message-Id: <20200407015900.1335019-5-damien.lemoal@wdc.com>
In-Reply-To: <20200407015900.1335019-1-damien.lemoal@wdc.com>
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Modify the test-zbd-support script to accept SG node device files for
tests with the libzbc IO engine. This IO engine can also be tested with
a block device file using the new -l option which forces all test cases
to have the option --ioengine=libzbc.

New helper functions are added to discover the capacity, logical block
size etc of devices specified using an SG node file.

To facilitate troubleshooting of problems, the option -z is also added
to automatically add the option --debug=zbd to all test cases.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/functions        |  38 ++++++-
 t/zbd/test-zbd-support | 221 ++++++++++++++++++++++++++---------------
 2 files changed, 178 insertions(+), 81 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index d49555a8..35087b15 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -4,18 +4,27 @@ blkzone=$(type -p blkzone 2>/dev/null)
 sg_inq=$(type -p sg_inq 2>/dev/null)
 zbc_report_zones=$(type -p zbc_report_zones 2>/dev/null)
 zbc_reset_zone=$(type -p zbc_reset_zone 2>/dev/null)
+zbc_info=$(type -p zbc_info 2>/dev/null)
 if [ -z "${blkzone}" ] &&
        { [ -z "${zbc_report_zones}" ] || [ -z "${zbc_reset_zone}" ]; }; then
     echo "Error: neither blkzone nor zbc_report_zones is available"
     exit 1
 fi
 
+if [ -n "${use_libzbc}" ] &&
+       { [ -z "${zbc_report_zones}" ] || [ -z "${zbc_reset_zone}" ] ||
+         [ -z "${zbc_info}" ]; }; then
+    echo "Error: zbc_report_zones, or zbc_reset_zone or zbc_info is not available"
+    echo "Error: reinstall libzbc tools"
+    exit 1
+fi
+
 # Reports the starting sector and length of the first sequential zone of device
 # $1.
 first_sequential_zone() {
     local dev=$1
 
-    if [ -n "${blkzone}" ]; then
+    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
 	${blkzone} report "$dev" |
 	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*type:[[:blank:]]2(.*/\1 \2/p' |
 	    {
@@ -33,7 +42,7 @@ first_sequential_zone() {
 max_open_zones() {
     local dev=$1
 
-    if [ -n "${sg_inq}" ]; then
+    if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
 	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" 2> /dev/null; then
 	    # Non scsi device such as null_blk can not return max open zones.
 	    # Use default value.
@@ -56,13 +65,36 @@ max_open_zones() {
     fi
 }
 
+is_zbc() {
+	local dev=$1
+
+	[[ -z "$(${zbc_info} "$dev" | grep "is not a zoned block device")" ]]
+}
+
+zbc_logical_block_size() {
+	local dev=$1
+
+	${zbc_info} "$dev" |
+		grep "logical blocks" |
+		sed -n 's/^[[:blank:]]*[0-9]* logical blocks of[[:blank:]]*//p' |
+		sed 's/ B//'
+}
+
+zbc_disk_sectors() {
+        local dev=$1
+
+	zbc_info "$dev" |
+		grep "512-bytes sectors" |
+		sed -e 's/[[:blank:]]*\([0-9]*\)512-bytes sectors.*/\1/'
+}
+
 # Reset the write pointer of one zone on device $1 at offset $2. The offset
 # must be specified in units of 512 byte sectors. Offset -1 means reset all
 # zones.
 reset_zone() {
     local dev=$1 offset=$2 sectors
 
-    if [ -n "${blkzone}" ]; then
+    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
 	if [ "$offset" -lt 0 ]; then
 	    sectors=$(<"/sys/class/block/${dev#/dev/}/size")
 	    ${blkzone} reset -o "${offset}" -l "$sectors" "$dev"
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index bd41fffb..be889f34 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -5,7 +5,7 @@
 # This file is released under the GPL.
 
 usage() {
-    echo "Usage: $(basename "$0") [-d] [-e] [-r] [-v] [-t <test>] <SMR drive device node>"
+    echo "Usage: $(basename "$0") [-d] [-e] [-l] [-r] [-v] [-t <test>] [-z] <SMR drive device node>"
 }
 
 max() {
@@ -24,6 +24,14 @@ min() {
     fi
 }
 
+ioengine() {
+	if [ -n "$use_libzbc" ]; then
+		echo -n "--ioengine=libzbc"
+	else
+		echo -n "--ioengine=$1"
+	fi
+}
+
 set_io_scheduler() {
     local dev=$1 sched=$2
 
@@ -87,6 +95,7 @@ run_fio() {
 
     opts=("--aux-path=/tmp" "--allow_file_create=0" \
 			    "--significant_figures=10" "$@")
+    opts+=(${var_opts[@]})
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
     "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
@@ -115,7 +124,7 @@ run_fio_on_seq() {
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
-	    --size="${zone_size}" --thread=1				\
+	    "$(ioengine "psync")" --size="${zone_size}" --thread=1	\
 	    --zonemode=zbd --zonesize="${zone_size}" 2>&1 |
 	tee -a "${logfile}.${test_number}" |
 	grep -q 'Using direct I/O is mandatory for writing to ZBD drives'
@@ -137,6 +146,7 @@ test2() {
 
     off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     bs=$((2 * zone_size))
+    opts+=("$(ioengine "psync")")
     opts+=("--name=job1" "--filename=$dev" "--rw=write" "--direct=1")
     opts+=("--zonemode=zbd" "--offset=$off" "--bs=$bs" "--size=$bs")
     if [ -z "$is_zbd" ]; then
@@ -155,7 +165,7 @@ test3() {
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--bs=4K")
     opts+=("--size=$size" "--zonemode=zbd")
-    opts+=("--ioengine=psync" "--rw=read" "--direct=1" "--thread=1")
+    opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--thread=1")
     if [ -z "$is_zbd" ]; then
 	opts+=("--zonesize=${zone_size}")
     fi
@@ -178,7 +188,7 @@ test4() {
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--bs=$size")
     opts+=("--size=$size" "--thread=1" "--read_beyond_wp=1")
-    opts+=("--ioengine=psync" "--rw=read" "--direct=1" "--disable_lat=1")
+    opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--disable_lat=1")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_read $size || return $?
@@ -189,7 +199,7 @@ test5() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write		\
+    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -202,7 +212,7 @@ test6() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=read		\
+    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=read	\
 		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
     check_read $size || return $?
@@ -212,7 +222,7 @@ test6() {
 test7() {
     local size=$((zone_size))
 
-    run_fio_on_seq --ioengine=libaio --iodepth=1 --rw=randwrite		\
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=1 --rw=randwrite	\
 		   --bs="$(min 16384 "${zone_size}")"			\
 		   --do_verify=1 --verify=md5 --size="$size"		\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -225,7 +235,7 @@ test8() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite	\
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite	\
 		   --bs="$(min 16384 "${zone_size}")"			\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -243,7 +253,8 @@ test9() {
     fi
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=sg --iodepth=1 --rw=randwrite --bs=16K	\
+    run_fio_on_seq --ioengine=sg					\
+		   --iodepth=1 --rw=randwrite --bs=16K			\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $size || return $?
@@ -260,7 +271,8 @@ test10() {
     fi
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=sg --iodepth=64 --rw=randwrite --bs=16K	\
+    run_fio_on_seq --ioengine=sg 					\
+		   --iodepth=64 --rw=randwrite --bs=16K			\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $size || return $?
@@ -272,7 +284,7 @@ test11() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite	\
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite	\
 		   --bsrange=4K-64K --do_verify=1 --verify=md5		\
 		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $size || return $?
@@ -284,7 +296,7 @@ test12() {
     local size
 
     size=$((8 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K     \
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		   --max_open_zones=1 --size=$size --do_verify=1 --verify=md5 \
 		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $size || return $?
@@ -296,7 +308,7 @@ test13() {
     local size
 
     size=$((8 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K     \
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		   --max_open_zones=4 --size=$size --do_verify=1 --verify=md5 \
 		   --debug=zbd						      \
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -314,7 +326,7 @@ test14() {
 	     >>"${logfile}.${test_number}"
 	return 0
     fi
-    run_one_fio_job --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K \
+    run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
 		    --verify=md5 --size=$size				   \
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -333,14 +345,14 @@ test15() {
     done
     off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     size=$((2 * zone_size))
-    run_one_fio_job --ioengine=psync --rw=write --bs=$((zone_size / 16))\
+    run_one_fio_job "$(ioengine "psync")" --rw=write --bs=$((zone_size / 16))\
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$size >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
     check_written $size || return $?
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
-    run_one_fio_job --ioengine=psync --rw=read --bs=$((zone_size / 16))	\
+    run_one_fio_job "$(ioengine "psync")" --rw=read --bs=$((zone_size / 16)) \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$((size)) >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
@@ -357,7 +369,7 @@ test16() {
 
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
-    run_one_fio_job --ioengine=libaio --iodepth=64 --rw=randread --bs=16K \
+    run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randread --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$size >>"${logfile}.${test_number}" 2>&1 || return $?
     check_read $size || return $?
@@ -373,12 +385,12 @@ test17() {
     if [ -n "$is_zbd" ]; then
 	reset_zone "$dev" $((off / 512)) || return $?
     fi
-    run_one_fio_job --ioengine=psync --rw=write --offset="$off"		\
+    run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off"	\
 		    --zonemode=zbd --zonesize="${zone_size}"		\
 		    --bs="$zone_size" --size="$zone_size"		\
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written "$zone_size" || return $?
-    run_one_fio_job --ioengine=libaio --iodepth=8 --rw=randrw --bs=4K	\
+    run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw --bs=4K \
 		    --zonemode=zbd --zonesize="${zone_size}"		\
 		    --offset=$off --loops=2 --norandommap=1\
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -431,8 +443,8 @@ test24() {
     local bs loops=9 size=$((zone_size))
 
     bs=$(min $((256*1024)) "$zone_size")
-    run_fio_on_seq --ioengine=psync --rw=write --bs="$bs" --size=$size	 \
-		   --loops=$loops					 \
+    run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs"		\
+		   --size=$size --loops=$loops				\
 		   --zone_reset_frequency=.01 --zone_reset_threshold=.90 \
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((size * loops)) || return $?
@@ -452,8 +464,9 @@ test25() {
     for ((i=0;i<16;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--thread=1" "--direct=1")
 	opts+=("--offset=$((first_sequential_zone_sector*512 + zone_size*i))")
-	opts+=("--size=$zone_size" "--ioengine=psync" "--rw=write" "--bs=16K")
+	opts+=("--size=$zone_size" "$(ioengine "psync")" "--rw=write" "--bs=16K")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}" "--group_reporting=1")
+	opts+=(${var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
@@ -462,7 +475,7 @@ write_to_first_seq_zone() {
     local loops=4 r
 
     r=$(((RANDOM << 16) | RANDOM))
-    run_fio --name="$dev" --filename="$dev" --ioengine=psync --rw="$1"	\
+    run_fio --name="$dev" --filename="$dev" "$(ioengine "psync")" --rw="$1" \
 	    --thread=1 --do_verify=1 --verify=md5 --direct=1 --bs=4K	\
 	    --offset=$((first_sequential_zone_sector * 512))		\
 	    "--size=$zone_size" --loops=$loops --randseed="$r"		\
@@ -490,9 +503,10 @@ test28() {
     opts=("--debug=zbd")
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
-	opts+=("--size=$zone_size" "--ioengine=psync" "--rw=randwrite")
+	opts+=("--size=$zone_size" "$(ioengine "psync")" "--rw=randwrite")
 	opts+=("--thread=1" "--direct=1" "--zonemode=zbd")
 	opts+=("--zonesize=${zone_size}" "--group_reporting=1")
+	opts+=(${var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((jobs * zone_size)) || return $?
@@ -513,9 +527,10 @@ test29() {
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
 	opts+=("--size=$size" "--io_size=$zone_size" "--thread=1")
-	opts+=("--ioengine=psync" "--rw=randwrite" "--direct=1")
+	opts+=("$(ioengine "psync")" "--rw=randwrite" "--direct=1")
 	opts+=("--max_open_zones=4" "--group_reporting=1")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+	opts+=(${var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((jobs * zone_size)) || return $?
@@ -526,7 +541,7 @@ test30() {
     local off
 
     off=$((first_sequential_zone_sector * 512))
-    run_one_fio_job --ioengine=libaio --iodepth=8 --rw=randrw		\
+    run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw	\
 		    --bs="$(max $((zone_size / 128)) "$logical_block_size")"\
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off\
 		    --loops=2 --time_based --runtime=30s --norandommap=1\
@@ -548,16 +563,17 @@ test31() {
     for ((off = first_sequential_zone_sector * 512; off < disk_size;
 	  off += inc)); do
 	opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--io_size=$bs")
-	opts+=("--bs=$bs" "--size=$zone_size" "--ioengine=libaio")
+	opts+=("--bs=$bs" "--size=$zone_size" "$(ioengine "libaio")")
 	opts+=("--rw=write" "--direct=1" "--thread=1" "--stats=0")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+	opts+=(${var_opts[@]})
     done
     "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
     # Next, run the test.
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
     opts=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
-    opts+=("--bs=$bs" "--ioengine=psync" "--rw=randread" "--direct=1")
+    opts+=("--bs=$bs" "$(ioengine "psync")" "--rw=randread" "--direct=1")
     opts+=("--thread=1" "--time_based" "--runtime=30" "--zonemode=zbd")
     opts+=("--zonesize=${zone_size}")
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
@@ -571,7 +587,7 @@ test32() {
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
-    opts+=("--bs=128K" "--ioengine=psync" "--rw=randwrite" "--direct=1")
+    opts+=("--bs=128K" "$(ioengine "psync")" "--rw=randwrite" "--direct=1")
     opts+=("--thread=1" "--time_based" "--runtime=30")
     opts+=("--max_open_zones=$max_open_zones" "--zonemode=zbd")
     opts+=("--zonesize=${zone_size}")
@@ -586,8 +602,8 @@ test33() {
     size=$((2 * zone_size))
     io_size=$((5 * zone_size))
     bs=$((3 * zone_size / 4))
-    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write --size=$size	\
-		   --io_size=$io_size --bs=$bs				\
+    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
+		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $(((io_size + bs - 1) / bs * bs)) || return $?
 }
@@ -598,7 +614,7 @@ test34() {
     local size
 
     size=$((2 * zone_size))
-    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write --size=$size	  \
+    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write --size=$size \
 		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
 		   >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'not a divisor of' "${logfile}.${test_number}"
@@ -611,9 +627,9 @@ test35() {
     off=$(((first_sequential_zone_sector + 1) * 512))
     size=$((zone_size - 2 * 512))
     bs=$((zone_size / 4))
-    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
-		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
-		    --zonemode=zbd --zonesize="${zone_size}"		    \
+    run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
+		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
+		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
 }
@@ -625,9 +641,9 @@ test36() {
     off=$(((first_sequential_zone_sector) * 512))
     size=$((zone_size - 512))
     bs=$((zone_size / 4))
-    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
-		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
-		    --zonemode=zbd --zonesize="${zone_size}"		    \
+    run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
+		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
+		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
 }
@@ -643,9 +659,9 @@ test37() {
     fi
     size=$((zone_size + 2 * 512))
     bs=$((zone_size / 4))
-    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
-		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
-		    --zonemode=zbd --zonesize="${zone_size}"		    \
+    run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
+		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
+		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1
     check_written $((zone_size)) || return $?
 }
@@ -657,9 +673,9 @@ test38() {
     size=$((logical_block_size))
     off=$((disk_size - logical_block_size))
     bs=$((logical_block_size))
-    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
-		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
-		    --zonemode=zbd --zonesize="${zone_size}"		    \
+    run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
+		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
+		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
 }
@@ -669,7 +685,7 @@ read_one_block() {
     local bs
 
     bs=$((logical_block_size))
-    run_one_fio_job --rw=read --ioengine=psync --bs=$bs --size=$bs "$@" 2>&1 |
+    run_one_fio_job --rw=read "$(ioengine "psync")" --bs=$bs --size=$bs "$@" 2>&1 |
 	tee -a "${logfile}.${test_number}"
 }
 
@@ -725,7 +741,7 @@ test45() {
 
     [ -z "$is_zbd" ] && return 0
     bs=$((logical_block_size))
-    run_one_fio_job --ioengine=psync --iodepth=1 --rw=randwrite --bs=$bs\
+    run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
 		    --offset=$((first_sequential_zone_sector * 512)) \
 		    --size="$zone_size" --do_verify=1 --verify=md5 2>&1 |
 	tee -a "${logfile}.${test_number}" |
@@ -737,7 +753,7 @@ test46() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=4K \
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=4K \
 		   --group_reporting=1 --numjobs=8 \
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((size * 8)) || return $?
@@ -749,7 +765,7 @@ test47() {
 
     [ -z "$is_zbd" ] && return 0
     bs=$((logical_block_size))
-    run_one_fio_job --ioengine=psync --rw=write --bs=$bs \
+    run_one_fio_job "$(ioengine "psync")" --rw=write --bs=$bs \
 		    --zonemode=zbd --zoneskip=1		 \
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'zoneskip 1 is not a multiple of the device zone size' "${logfile}.${test_number}"
@@ -766,7 +782,7 @@ test48() {
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts=("--aux-path=/tmp" "--allow_file_create=0" "--significant_figures=10")
     opts+=("--debug=zbd")
-    opts+=("--ioengine=libaio" "--rw=randwrite" "--direct=1")
+    opts+=("$(ioengine "libaio")" "--rw=randwrite" "--direct=1")
     opts+=("--time_based" "--runtime=30")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
     opts+=("--max_open_zones=4")
@@ -788,6 +804,8 @@ test48() {
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
+use_libzbc=
+zbd_debug=
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -796,10 +814,12 @@ while [ "${1#-}" != "$1" ]; do
 	shift;;
     -e) dynamic_analyzer=(valgrind "--read-var-info=yes" "--tool=helgrind");
 	shift;;
+    -l) use_libzbc=1; shift;;
     -r) reset_all_zones=1; shift;;
     -t) tests+=("$2"); shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
 	shift;;
+    -z) zbd_debug=1; shift;;
     --) shift; break;;
   esac
 done
@@ -812,48 +832,93 @@ fi
 # shellcheck source=functions
 source "$(dirname "$0")/functions" || exit $?
 
+var_opts=()
+if [ -n "$zbd_debug" ]; then
+    var_opts+=("--debug=zbd")
+fi
 dev=$1
 realdev=$(readlink -f "$dev")
 basename=$(basename "$realdev")
-major=$((0x$(stat -L -c '%t' "$realdev"))) || exit $?
-minor=$((0x$(stat -L -c '%T' "$realdev"))) || exit $?
-disk_size=$(($(<"/sys/dev/block/$major:$minor/size")*512))
-# When the target is a partition device, get basename of its holder device to
-# access sysfs path of the holder device
-if [[ -r "/sys/dev/block/$major:$minor/partition" ]]; then
-	realsysfs=$(readlink "/sys/dev/block/$major:$minor")
-	basename=$(basename "${realsysfs%/*}")
-fi
-logical_block_size=$(<"/sys/block/$basename/queue/logical_block_size")
-case "$(<"/sys/class/block/$basename/queue/zoned")" in
-    host-managed|host-aware)
+
+if [[ -b "$realdev" ]]; then
+	major=$((0x$(stat -L -c '%t' "$realdev"))) || exit $?
+	minor=$((0x$(stat -L -c '%T' "$realdev"))) || exit $?
+	disk_size=$(($(<"/sys/dev/block/$major:$minor/size")*512))
+
+	# When the target is a partition device, get basename of its
+	# holder device to access sysfs path of the holder device
+	if [[ -r "/sys/dev/block/$major:$minor/partition" ]]; then
+		realsysfs=$(readlink "/sys/dev/block/$major:$minor")
+		basename=$(basename "${realsysfs%/*}")
+	fi
+	logical_block_size=$(<"/sys/block/$basename/queue/logical_block_size")
+	case "$(<"/sys/class/block/$basename/queue/zoned")" in
+	host-managed|host-aware)
+		is_zbd=true
+		if ! result=($(first_sequential_zone "$dev")); then
+			echo "Failed to determine first sequential zone"
+			exit 1
+		fi
+		first_sequential_zone_sector=${result[0]}
+		sectors_per_zone=${result[1]}
+		zone_size=$((sectors_per_zone * 512))
+		if ! max_open_zones=$(max_open_zones "$dev"); then
+			echo "Failed to determine maximum number of open zones"
+			exit 1
+		fi
+		set_io_scheduler "$basename" deadline || exit $?
+		if [ -n "$reset_all_zones" ]; then
+			reset_zone "$dev" -1
+		fi
+		;;
+	*)
+		first_sequential_zone_sector=$(((disk_size / 2) &
+						(logical_block_size - 1)))
+		zone_size=$(max 65536 "$logical_block_size")
+		sectors_per_zone=$((zone_size / 512))
+		max_open_zones=128
+		set_io_scheduler "$basename" none || exit $?
+		;;
+	esac
+elif [[ -c "$realdev" ]]; then
+	# For an SG node, we must have libzbc option specified
+	if [[ ! -n "$use_libzbc" ]]; then
+		echo "Character device files can only be used with -l (libzbc) option"
+		exit 1
+	fi
+
+	if ! $(is_zbc "$dev"); then
+		echo "Device is not a ZBC disk"
+		exit 1
+	fi
 	is_zbd=true
+
+	if ! disk_size=($(( $(zbc_disk_sectors "$dev") * 512))); then
+		echo "Failed to determine disk size"
+		exit 1
+	fi
+	if ! logical_block_size=($(zbc_logical_block_size "$dev")); then
+		echo "Failed to determine logical block size"
+		exit 1
+	fi
 	if ! result=($(first_sequential_zone "$dev")); then
-	    echo "Failed to determine first sequential zone"
-	    exit 1
+		echo "Failed to determine first sequential zone"
+		exit 1
 	fi
 	first_sequential_zone_sector=${result[0]}
 	sectors_per_zone=${result[1]}
 	zone_size=$((sectors_per_zone * 512))
 	if ! max_open_zones=$(max_open_zones "$dev"); then
-	    echo "Failed to determine maximum number of open zones"
-	    exit 1
+		echo "Failed to determine maximum number of open zones"
+		exit 1
 	fi
-	echo "First sequential zone starts at sector $first_sequential_zone_sector; zone size: $((zone_size >> 20)) MB"
-	set_io_scheduler "$basename" deadline || exit $?
 	if [ -n "$reset_all_zones" ]; then
-	    reset_zone "$dev" -1
+		reset_zone "$dev" -1
 	fi
-	;;
-    *)
-	first_sequential_zone_sector=$(((disk_size / 2) &
-					(logical_block_size - 1)))
-	zone_size=$(max 65536 "$logical_block_size")
-	sectors_per_zone=$((zone_size / 512))
-	max_open_zones=128
-	set_io_scheduler "$basename" none || exit $?
-	;;
-esac
+fi
+
+echo -n "First sequential zone starts at sector $first_sequential_zone_sector;"
+echo " zone size: $((zone_size >> 20)) MB"
 
 if [ "${#tests[@]}" = 0 ]; then
     readarray -t tests < <(declare -F | grep "test[0-9]*" | \
-- 
2.25.1


