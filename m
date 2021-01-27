Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 26/38] t/zbd: skip tests when test prerequisites are not met
Date: Wed, 27 Jan 2021 13:19:33 +0900
Message-Id: <20210127041945.36909-27-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Some of the test cases in t/zbd/test-zbd-support require test target
devices to have certain features. When these prerequisites are not met,
they skip the actual test and report the test result to be "PASS".
This does not help users to understand the true test outcome.
As the tests expand to cover a wider variety of zoned devices and
layouts, reporting skipped tests becomes more and more beneficial.

Modify test-zbd-support script to report skipped test cases.
Introduce helper functions require_*() to check test target
prerequisites. If they are not met, set the variable SKIP_REASON and
return the constant SKIP_TESTCASE from the test function. In the main
loo, print "SKIP" status and SKIP_REASON if the test case is skipped.
Also, output the total number of skipped cases at the end of the test
script  run.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 93 ++++++++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 26 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 652dddfc..d94b5125 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -190,6 +190,42 @@ prep_write() {
 		reset_zone "${dev}" -1
 }
 
+SKIP_TESTCASE=255
+
+require_scsi_dev() {
+	if ! is_scsi_device "$dev"; then
+		SKIP_REASON="$dev is not a SCSI device"
+		return 1
+	fi
+	return 0
+}
+
+require_conv_zone_bytes() {
+	local req_bytes=${1}
+
+	if ((req_bytes > first_sequential_zone_sector * 512)); then
+		SKIP_REASON="$dev does not have enough conventional zones"
+		return 1
+	fi
+	return 0
+}
+
+require_zbd() {
+	if [[ -z ${is_zbd} ]]; then
+		SKIP_REASON="$dev is not a zoned block device"
+		return 1
+	fi
+	return 0
+}
+
+require_regular_block_dev() {
+	if [[ -n ${is_zbd} ]]; then
+		SKIP_REASON="$dev is not a regular block device"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
@@ -327,10 +363,7 @@ test8() {
 test9() {
     local size
 
-    if ! is_scsi_device "$dev"; then
-	echo "$dev is not a SCSI device" >>"${logfile}.${test_number}"
-	return 0
-    fi
+    require_scsi_dev || return $SKIP_TESTCASE
 
     prep_write
     size=$((4 * zone_size))
@@ -346,10 +379,7 @@ test9() {
 test10() {
     local size
 
-    if ! is_scsi_device "$dev"; then
-	echo "$dev is not a SCSI device" >>"${logfile}.${test_number}"
-	return 0
-    fi
+    require_scsi_dev || return $SKIP_TESTCASE
 
     prep_write
     size=$((4 * zone_size))
@@ -413,11 +443,8 @@ test14() {
 
     prep_write
     size=$((16 * 2**20)) # 20 MB
-    if [ $size -gt $((first_sequential_zone_sector * 512)) ]; then
-	echo "$dev does not have enough sequential zones" \
-	     >>"${logfile}.${test_number}"
-	return 0
-    fi
+    require_conv_zone_bytes "${size}" || return $SKIP_TESTCASE
+
     run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
 		    --verify=md5 --size=$size				   \
@@ -696,6 +723,8 @@ test31() {
 test32() {
     local off opts=() size
 
+    require_zbd || return $SKIP_TESTCASE
+
     prep_write
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
@@ -814,7 +843,7 @@ read_one_block() {
 
 # Check whether fio accepts --zonemode=none for zoned block devices.
 test39() {
-    [ -n "$is_zbd" ] || return 0
+    require_zbd || return $SKIP_TESTCASE
     read_one_block --zonemode=none >/dev/null || return $?
     check_read $((logical_block_size)) || return $?
 }
@@ -824,7 +853,7 @@ test40() {
     local bs
 
     bs=$((logical_block_size))
-    [ -n "$is_zbd" ] || return 0
+    require_zbd || return $SKIP_TESTCASE
     read_one_block --zonemode=strided |
 	grep -q 'fio: --zonesize must be specified when using --zonemode=strided' ||
 	return $?
@@ -834,21 +863,21 @@ test40() {
 
 # Check whether fio checks the zone size for zoned block devices.
 test41() {
-    [ -n "$is_zbd" ] || return 0
+    require_zbd || return $SKIP_TESTCASE
     read_one_block --zonemode=zbd --zonesize=$((2 * zone_size)) |
 	grep -q 'job parameter zonesize.*does not match disk zone size'
 }
 
 # Check whether fio handles --zonesize=0 correctly for regular block devices.
 test42() {
-    [ -n "$is_zbd" ] && return 0
+    require_regular_block_dev || return $SKIP_TESTCASE
     read_one_block --zonemode=zbd --zonesize=0 |
 	grep -q 'Specifying the zone size is mandatory for regular block devices with --zonemode=zbd'
 }
 
 # Check whether fio handles --zonesize=1 correctly for regular block devices.
 test43() {
-    [ -n "$is_zbd" ] && return 0
+    require_regular_block_dev || return $SKIP_TESTCASE
     read_one_block --zonemode=zbd --zonesize=1 |
 	grep -q 'zone size must be at least 512 bytes for --zonemode=zbd'
 }
@@ -862,7 +891,7 @@ test44() {
 test45() {
     local bs i
 
-    [ -z "$is_zbd" ] && return 0
+    require_zbd || return $SKIP_TESTCASE
     prep_write
     bs=$((logical_block_size))
     run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
@@ -901,6 +930,8 @@ test47() {
 test48() {
     local i jobs=16 off opts=()
 
+    require_zbd || return $SKIP_TESTCASE
+
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
     prep_write
@@ -930,11 +961,7 @@ test48() {
 # Check if fio handles --zonecapacity on a normal block device correctly
 test49() {
 
-    if [ -n "$is_zbd" ]; then
-	echo "$dev is not a regular block device" \
-	     >>"${logfile}.${test_number}"
-	return 0
-    fi
+    require_regular_block_dev || return $SKIP_TESTCASE
 
     size=$((2 * zone_size))
     capacity=$((zone_size * 3 / 4))
@@ -1087,10 +1114,12 @@ fi
 logfile=$0.log
 
 passed=0
+skipped=0
 failed=0
 if [ -t 1 ]; then
     red="\e[1;31m"
     green="\e[1;32m"
+    cyan="\e[1;36m"
     end="\e[m"
 else
     red=""
@@ -1101,14 +1130,23 @@ rc=0
 
 intr=0
 trap 'intr=1' SIGINT
+ret=0
 
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
+    unset SKIP_REASON
     echo -n "Running test $(printf "%02d" $test_number) ... "
-    if eval "test$test_number" && check_log $test_number; then
+    eval "test$test_number"
+    ret=$?
+    if ((!ret)) && check_log $test_number; then
 	status="PASS"
 	cc_status="${green}${status}${end}"
 	((passed++))
+    elif ((ret==SKIP_TESTCASE)); then
+	status="SKIP"
+	echo "${SKIP_REASON}" >> "${logfile}.${test_number}"
+	cc_status="${cyan}${status}${end}    ${SKIP_REASON}"
+	((skipped++))
     else
 	status="FAIL"
 	cc_status="${red}${status}${end}"
@@ -1121,7 +1159,10 @@ for test_number in "${tests[@]}"; do
 done
 
 echo "$passed tests passed"
+if [ $skipped -gt 0 ]; then
+    echo " $skipped tests skipped"
+fi
 if [ $failed -gt 0 ]; then
-    echo " and $failed tests failed"
+    echo " $failed tests failed"
 fi
 exit $rc
-- 
2.28.0


