Return-Path: <prvs=94868c4cd=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 9/9] t/zbd: Add multi-job libaio test
Date: Thu, 21 Feb 2019 13:11:07 +0900
Message-Id: <20190221041107.8576-10-damien.lemoal@wdc.com>
In-Reply-To: <20190221041107.8576-1-damien.lemoal@wdc.com>
References: <20190221041107.8576-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Introduce test case 46 to verify that write ordering is correct and that
no job deadlock occurs in the case of a multi job run with an
asynchronous I/O engine (libaio).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 03d61b70..10c78e9a 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -730,6 +730,17 @@ test45() {
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
@@ -801,7 +812,7 @@ case "$(<"/sys/class/block/$basename/queue/zoned")" in
 esac
 
 if [ "${#tests[@]}" = 0 ]; then
-    for ((i=1;i<=45;i++)); do
+    for ((i=1;i<=46;i++)); do
 	tests+=("$i")
     done
 fi
-- 
2.20.1


