Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 34/38] t/zbd: add checks for offline zone condition
Date: Wed, 27 Jan 2021 13:19:41 +0900
Message-Id: <20210127041945.36909-35-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Some tests, e.g. #39 an #40, try to read the first zone of the drive.
It is assumed that the first zone is readable. However, if the first
zone is offline, the read fails along with the entire test.

This commit adds two functions to perform zone report and find the
first and the last zones that are not offline. Several test cases
now call these functions to avoid test failures described above.

Fixes for two more test failures are included in this commit -

Test #14 tries to write to conventional zones if they are found at
the beginning of the LBA range of the drive, but it assumes that
these zones are online. This may not always be the case. Add "offset"
to avoid the i/o to be attempted to run against any preceding offline
zones.

Similarly, in test #17, the script tries to find the last zone.
Check for the case when the last zone is offline. The test doesn't
set the i/o file size, but it works OK in most of the cases because
typically this test operates on the last physical zone. With the
online lookup in place, this may not always be the case and if there
are any offline zones that trail the last non-offline zone,
then the i/o will try to access that zone and fail. Add the "size"
to avoid the i/o to be attempted to run against any trailing offline
zones.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions        | 56 ++++++++++++++++++++++++++++++++++++++++--
 t/zbd/test-zbd-support | 31 +++++++++++++++++++----
 2 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 1a64a215..40ffe1de 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -71,7 +71,7 @@ first_sequential_zone() {
 
     if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
 	${blkzone} report "$dev" |
-	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*type:[[:blank:]]2(.*/\1 \2/p' |
+	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:blank:]]\([2]\)(.*/\1 \2/p' |
 	    {
 		read -r starting_sector length &&
 		    # Convert from hex to decimal
@@ -79,7 +79,7 @@ first_sequential_zone() {
 	    }
     else
 	${zbc_report_zones} "$dev" |
-	    sed -n 's/^Zone [0-9]*: type 0x2 .*, sector \([0-9]*\), \([0-9]*\) sectors,.*$/\1 \2/p' |
+	    sed -n 's/^Zone [0-9]*: type 0x2 .*,[[:blank:]]cond[[:blank:]]0x[0-4e][[:blank:]].*, sector \([0-9]*\), \([0-9]*\) sectors.*$/\1 \2/p' |
 	    head -n1
     fi
 }
@@ -121,6 +121,58 @@ total_zone_capacity() {
 	echo $((capacity * 512))
 }
 
+# Reports the starting sector and length of the first zone of device $1
+# that is not in offline (or similar) condition.
+first_online_zone() {
+    local dev=$1
+
+    if [ -z "$is_zbd" ]; then
+	echo 0
+	return
+    fi
+
+    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
+	${blkzone} report "$dev" |
+	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:blank:]][12](.*/\1/p' |
+	    head -n1 |
+	    {
+		read -r starting_sector &&
+		    # Convert from hex to decimal
+		    echo $((starting_sector))
+	    }
+    else
+	${zbc_report_zones} "$dev" |
+	    sed -n 's/^Zone[[:blank:]][0-9]*:[[:blank:]]type[[:blank:]]0x[12][[:blank:]].*,[[:blank:]]cond[[:blank:]]0x[0-4e][[:blank:]].*,[[:blank:]]sector[[:blank:]]\([0-9]*\),.*$/\1/p' |
+	    head -n1
+    fi
+}
+
+# Reports the starting sector and length of the last zone of device $1
+# that is not in offline (or similar) condition.
+last_online_zone() {
+    local dev=$1
+
+    if [ -z "$is_zbd" ]; then
+	echo 0
+	return
+    fi
+
+    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
+	${blkzone} report "$dev" |
+	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:blank:]][12](.*/\1/p' |
+	    tail -1 |
+	    {
+		read -r starting_sector &&
+		    # Convert from hex to decimal
+		    echo $((starting_sector))
+	    }
+    else
+	${zbc_report_zones} "$dev" |
+	    sed -n 's/^Zone[[:blank:]][0-9]*:[[:blank:]]type[[:blank:]]0x[12][[:blank:]].*,[[:blank:]]cond[[:blank:]]0x[0-4e][[:blank:]].*,[[:blank:]]sector[[:blank:]]\([0-9]*\),.*$/\1/p' |
+	    tail -1
+    fi
+}
+
 max_open_zones() {
     local dev=$1
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 033c2ebc..0b8015df 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -464,15 +464,20 @@ test13() {
 
 # Random write to conventional zones.
 test14() {
-    local size
+    local off size
 
+    if ! result=($(first_online_zone "$dev")); then
+	echo "Failed to determine first online zone"
+	exit 1
+    fi
+    off=${result[0]}
     prep_write
     size=$((16 * 2**20)) # 20 MB
     require_conv_zone_bytes "${size}" || return $SKIP_TESTCASE
 
     run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
-		    --verify=md5 --size=$size				   \
+		    --verify=md5 --offset=$off --size=$size\
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $((size)) || return $?
     check_read $((size)) || return $?
@@ -529,17 +534,26 @@ test16() {
 
 # Random reads and writes in the last zone.
 test17() {
-    local io off read size written
+    local io off last read size written
 
     off=$(((disk_size / zone_size - 1) * zone_size))
     size=$((disk_size - off))
+    if ! last=($(last_online_zone "$dev")); then
+	echo "Failed to determine last online zone"
+	exit 1
+    fi
+    if [[ "$((last * 512))" -lt "$off" ]]; then
+	off=$((last * 512))
+	size=$zone_size
+    fi
     if [ -n "$is_zbd" ]; then
 	reset_zone "$dev" $((off / 512)) || return $?
     fi
     prep_write
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw --bs=4K \
 		    --zonemode=zbd --zonesize="${zone_size}"		\
-		    --offset=$off --loops=2 --norandommap=1\
+		    --offset=$off --loops=2 --norandommap=1 \
+		    --size="$size"\
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
     written=$(fio_written <"${logfile}.${test_number}")
     read=$(fio_read <"${logfile}.${test_number}")
@@ -867,10 +881,17 @@ test38() {
 
 # Read one block from a block device.
 read_one_block() {
+    local off
     local bs
 
+    if ! result=($(first_online_zone "$dev")); then
+	echo "Failed to determine first online zone"
+	exit 1
+    fi
+    off=${result[0]}
     bs=$((logical_block_size))
-    run_one_fio_job --rw=read "$(ioengine "psync")" --bs=$bs --size=$bs "$@" 2>&1 |
+    run_one_fio_job --rw=read "$(ioengine "psync")" --offset=$off --bs=$bs \
+		    --size=$bs "$@" 2>&1 |
 	tee -a "${logfile}.${test_number}"
 }
 
-- 
2.28.0


