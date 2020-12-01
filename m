Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 9/9] Add a new test case to test the copy operation.
Date: Tue,  1 Dec 2020 17:10:34 +0530
Message-Id: <20201201114034.8307-10-krish.reddy@samsung.com>
In-Reply-To: <20201201114034.8307-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20201201114034.8307-1-krish.reddy@samsung.com>
	<CGME20201201114113epcas5p328eabe564e0bda24c29e285bba8d8fd2@epcas5p3.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 t/zbd/functions        |  9 +++++++
 t/zbd/test-zbd-support | 54 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/t/zbd/functions b/t/zbd/functions
index 1a64a215..52eb697d 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -26,6 +26,15 @@ blkzone_reports_capacity() {
 		"${blkzone}" report -c 1 -o 0 "${dev}" | grep -q 'cap '
 }
 
+# Check whether or not $1 (/dev/...) supports copy operation
+check_copy_support() {
+	local copy_support
+
+	copy_support=$(<"/sys/block/$(basename "${1}")/queue/max_copy_sectors")
+
+	[[ "$copy_support" -gt 0 ]]
+}
+
 # Whether or not $1 (/dev/...) is a NVME ZNS device.
 is_nvme_zns() {
 	local s
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index acde3b3a..0857034d 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -948,6 +948,60 @@ test49() {
     check_read $((capacity * 2)) || return $?
 }
 
+# Sequential write, copy and read test
+test50() {
+    local i off opts=() size
+
+    if ! $(check_copy_support "$dev"); then
+	echo "$dev doesn't support copy operation" \
+	     >>"${logfile}.${test_number}"
+	return 0
+    fi
+
+    for ((i=0;i<8;i++)); do
+	[ -n "$is_zbd" ] &&
+	    reset_zone "$dev" $((first_sequential_zone_sector +
+				 i*sectors_per_zone))
+    done
+
+    size=$((zone_size * 8))
+    zonesize=$((zone_size * 1))
+    off=$((first_sequential_zone_sector * 512))
+    dest_off=$((off + zone_size * 16))
+    capacity=$(total_zone_capacity 8 $off $dev)
+
+    # Start with writing to 8 zones (0 - 7).
+    opts+=("--name=$dev" "--filename=$dev" "--thread=1" "--direct=1")
+    opts+=("--offset=${off}" "--size=$size" "--ioengine=libaio" "--rw=write" "--bs=16K")
+    opts+=("--buffer_pattern=0xdeadbeef" "--iodepth=32")
+    opts+=("--zonemode=zbd" "--group_reporting=1")
+    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 ||
+	    return $?
+    check_written $capacity || return $?
+
+    # Next, run copy operation. 8 ranges per copy operation and each range is 16K.
+    # Loop around the source and destination offset
+    opts=()
+    opts+=("--name=$dev" "--filename=$dev" "--thread=1" "--direct=1")
+    opts+=("--offset=${off}" "--size=$size" "--ioengine=sctl" "--rw=copy" "--bs=16K")
+    opts+=("--iodepth=1" "--num_range=8")
+    opts+=("--dest_offset=${dest_off}" "--loops=2")
+    opts+=("--zonemode=zbd" "--zonesize=${zonesize}" "--group_reporting=1")
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+
+    # read and verify the copied data pattern. Cannot run with zonemode=zbd
+    off=$((first_sequential_zone_sector * 512 + zone_size * 16))
+
+    opts=()
+    opts+=("--name=$dev" "--filename=$dev" "--thread=1" "--direct=1")
+    opts+=("--offset=${off}" "--size=$size" "--ioengine=libaio" "--rw=read" "--bs=4K")
+    opts+=("--iodepth=32" "--group_reporting=1")
+    opts+=("--do_verify=1" "--verify=pattern" "--verify_pattern=0xdeadbeef")
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_read $capacity || return $?
+}
+
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.17.1


