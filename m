Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31050 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfBTHSO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 20 Feb 2019 02:18:14 -0500
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 8/8] t/zbd: Add multi-job libaio test
Date: Wed, 20 Feb 2019 16:17:25 +0900
Message-Id: <20190220071725.8487-9-damien.lemoal@wdc.com>
In-Reply-To: <20190220071725.8487-1-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>

Introduce test case 46 to verify that write ordering is correct and that
no job deadlock occurs in the case of a multi job run with an
asynchronous I/O engine (libaio).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c6391169..2a470397 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -731,6 +731,17 @@ test45() {
 	grep -q "fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
 }
 
+# Random write to sequential zones, libaio, 8 jobs, queue depth 64 per job
+test46() {
+    local size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=4K \
+		   --group_reporting=1 --numjobs=8 \
+		   >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((size * 8)) || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
@@ -802,7 +813,7 @@ case "$(<"/sys/class/block/$basename/queue/zoned")" in
 esac
 
 if [ "${#tests[@]}" = 0 ]; then
-    for ((i=1;i<=45;i++)); do
+    for ((i=1;i<=46;i++)); do
 	tests+=("$i")
     done
 fi
-- 
2.20.1


