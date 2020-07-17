Return-Path: <prvs=460e8bdd2=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 6/6] t/zbd: Add test case to check zonecapacity option
Date: Fri, 17 Jul 2020 18:36:37 +0900
Message-Id: <20200717093637.139565-7-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200717093637.139565-1-shinichiro.kawasaki@wdc.com>
References: <20200717093637.139565-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Hans Holmberg <hans.holmberg@wdc.com>

Add test case #49 which confirms the newly introduced zonecapacity
option is working as expected with regular block devices.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 31718c95..e53a20c5 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -839,6 +839,26 @@ test48() {
 	    >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Check if fio handles --zonecapacity on a normal block device correctly
+test49() {
+
+    if [ -n "$is_zbd" ]; then
+	echo "$dev is not a regular block device" \
+	     >>"${logfile}.${test_number}"
+	return 0
+    fi
+
+    size=$((2 * zone_size))
+    capacity=$((zone_size * 3 / 4))
+
+    run_one_fio_job "$(ioengine "psync")" --rw=write \
+		    --zonemode=zbd --zonesize="${zone_size}" \
+		    --zonecapacity=${capacity} \
+		    --verify=md5  --size=${size} >>"${logfile}.${test_number}" 2>&1 ||
+	return $?
+    check_read $((capacity * 2)) || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.26.2


