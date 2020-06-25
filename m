Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 4/4] t/zbd: Add support to verify Zone Append command with
 libaio, io_uring IO engine tests
Date: Thu, 25 Jun 2020 23:08:52 +0530
Message-Id: <1593106733-19596-5-git-send-email-krish.reddy@samsung.com>
In-Reply-To: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
	<CGME20200625174133epcas5p1eace8f03319bee805b93c50fe6c690c7@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Krishna Kanth Reddy <krish.reddy@samsung.com>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

Modify the test-zbd-support script to verify the Zone Append command
for NVMe Zoned Namespaces (ZNS) defined in NVM Express TP4053.
Added a new FIO option zone_append.
When zone_append option is enabled, the existing write path will
send Zone Append command with LBA offset as start of the Zone.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 t/zbd/test-zbd-support | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4001be3..ddade22 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -801,6 +801,54 @@ test48() {
 	    >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Zone append to sequential zones, libaio, 1 job, queue depth 1
+test49() {
+    local i size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=libaio --iodepth=1 --rw=write --zone_append=1 \
+                   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
+                   --do_verify=1 --verify=md5                           \
+                   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random zone append to sequential zones, libaio, 8 jobs, queue depth 64 per job
+test50() {
+    local size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=4K \
+                   --group_reporting=1 --numjobs=8 --zone_append=1 \
+                   >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((size * 8)) || return $?
+}
+
+# Zone append to sequential zones, io_uring, 1 job, queue depth 1
+test51() {
+    local i size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=io_uring --iodepth=1 --rw=write --zone_append=1 \
+                   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
+                   --do_verify=1 --verify=md5                           \
+                   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random zone append to sequential zones, io_uring, 8 jobs, queue depth 64 per job
+test52() {
+    local size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=io_uring --iodepth=64 --rw=randwrite --bs=4K \
+                   --group_reporting=1 --numjobs=8 --zone_append=1 \
+                   >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((size * 8)) || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.7.4


