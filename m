Return-Path: <prvs=8148fed87=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/4] t/zbd: Add test #58 to test zone reset by trim workload
Date: Tue,  6 Jul 2021 09:59:26 +0900
Message-Id: <20210706005926.303890-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210706005926.303890-1-shinichiro.kawasaki@wdc.com>
References: <20210706005926.303890-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

To exercise zone reset by trim workload, add the test case #58. As the
precondition, it fills several zones. After that, a trim job and a write
job run in parallel for 30 seconds. The ratio of trim commands and write
commands is controlled by --flow option.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 57e6d05e..5103c406 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1215,6 +1215,32 @@ test57() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Random writes and random trims to sequential write required zones for 30s.
+test58() {
+    local off size bs
+
+    require_seq_zones 128 || return $SKIP_TESTCASE
+
+    size=$((zone_size * 128))
+    bs="$(max $((zone_size / 128)) "$logical_block_size")"
+    prep_write
+    off=$((first_sequential_zone_sector * 512))
+    run_fio --zonemode=zbd --direct=1 --zonesize="${zone_size}" --thread=1 \
+	    --filename="${dev}" --norandommap=1 \
+            --name="precondition"  --rw=write "$(ioengine "psync")" \
+            --offset="${off}" --size=$((zone_size * 16)) --bs="${bs}" \
+	    "${job_var_opts[@]}" \
+	    --name=wjob --wait_for="precondition" --rw=randwrite \
+	    "$(ioengine "libaio")" --iodepth=8 \
+	    --offset="${off}" --size="${size}" --bs="${bs}" \
+	    --time_based --runtime=30s --flow=128 "${job_var_opts[@]}" \
+	    --name=trimjob --wait_for="precondition" --rw=randtrim \
+	    "$(ioengine "psync")" \
+	    --offset="${off}" --size="${size}" --bs="${zone_size}" \
+	    --time_based --runtime=30s --flow=1 "${job_var_opts[@]}" \
+	    >>"${logfile}.${test_number}" 2>&1
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.31.1


