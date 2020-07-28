Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 3/3] t/zbd: Add support to verify Zone Append command with
 libaio tests
Date: Tue, 28 Jul 2020 18:06:55 +0530
Message-Id: <20200728123655.30780-4-krish.reddy@samsung.com>
In-Reply-To: <20200728123655.30780-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20200728123655.30780-1-krish.reddy@samsung.com>
	<CGME20200728124030epcas5p47d085c6ca8d92406e2a543bfe1e2e23b@epcas5p4.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Krishna Kanth Reddy <krish.reddy@samsung.com>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

Added a new FIO option zone_append.
When zone_append option is enabled and when the zonemode is ZBD,
the existing write path will send Zone Append command with offset as start of the Zone.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 471a3487..048daaf5 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -860,6 +860,35 @@ test49() {
     check_read $((capacity * 2)) || return $?
 }
 
+# Zone append to sequential zones, libaio, 1 job, queue depth 1
+test50() {
+    local size capacity
+
+    [ -n "$use_libzbc" ] && return 0
+    size=$((8 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 8 $off $dev)
+
+    run_fio_on_seq --ioengine=libaio --iodepth=1 --rw=write --zone_append=1 \
+                   --bs=65536 --size=$size --do_verify=1 --verify=md5 \
+                   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
+}
+
+# Random zone append to sequential zones, libaio, 8 jobs, queue depth 64 per job
+test51() {
+    local capacity
+
+    [ -n "$use_libzbc" ] && return 0
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite \
+		   --bs=4096 --group_reporting=1 --numjobs=8 --zone_append=1 \
+                   >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((capacity * 8)) || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.17.1


