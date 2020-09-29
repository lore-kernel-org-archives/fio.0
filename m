Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 3/3] t/zbd: Add support to verify Zone Explicit Open
Date: Tue, 29 Sep 2020 18:29:50 +0530
Message-Id: <20200929125950.20343-4-krish.reddy@samsung.com>
In-Reply-To: <20200929125950.20343-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20200929125950.20343-1-krish.reddy@samsung.com>
	<CGME20200929130329epcas5p1c170f7010a73df8c1cdb79ccf6662428@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Krishna Kanth Reddy <krish.reddy@samsung.com>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

Modify the test-zbd-support script to verify the Zone Explicit Open.
Added a new FIO option zone_open.
When zone_open option is set to explicit, zones are opened explicitly.
If it is set to implicit, zones are opened implicitly.
Default value is implicit for the zone_open option.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 t/zbd/test-zbd-support | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 248423bb..c1f35165 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -948,6 +948,33 @@ test49() {
     check_read $((capacity * 2)) || return $?
 }
 
+# Explicit zone open to sequential zones, libaio, 1 job, queue depth 1
+test50() {
+    local size capacity
+
+    size=$((8 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 8 $off $dev)
+
+    run_fio_on_seq --ioengine=libaio --iodepth=1 --rw=write --zone_open=explicit \
+                   --bs=65536 --size=$size --do_verify=1 --verify=md5 \
+                   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
+}
+
+# Random zone write to sequential zones, libaio, 8 jobs, queue depth 64 per job, Explicit open
+test51() {
+    local capacity
+
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite \
+		   --bs=4096 --group_reporting=1 --numjobs=8 --zone_open=explicit \
+                   >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((capacity * 8)) || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.17.1


