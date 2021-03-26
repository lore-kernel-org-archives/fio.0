Return-Path: <prvs=712406085=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 2/2] t/zbd: test repeated async write with block size unaligned to zone size
Date: Fri, 26 Mar 2021 13:59:05 +0900
Message-Id: <20210326045905.1541264-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210326045905.1541264-1-shinichiro.kawasaki@wdc.com>
References: <20210326045905.1541264-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

A recently fixed bug was caused by zone reset during asynchronous IOs
in-flight. The bug symptom was unaligned command error which was
observed using random write workload with libaio engine and block size
not a divisor of zone size. To confirm the bug fix and to prevent future
regression, add a test case which runs the workload.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index be129615..26aff373 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1201,6 +1201,24 @@ test56() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test that repeated async write job does not cause zone reset during writes
+# in-flight, when the block size is not a divisor of the zone size.
+test57() {
+	local bs off
+
+	require_zbd || return $SKIP_TESTCASE
+
+	bs=$((4096 * 7))
+	off=$((first_sequential_zone_sector * 512))
+
+	run_fio --name=job --filename="${dev}" --rw=randwrite --bs="${bs}" \
+		--offset="${off}" --size=$((4 * zone_size)) --iodepth=256 \
+		"$(ioengine "libaio")" --time_based=1 --runtime=30s \
+		--zonemode=zbd --direct=1 --zonesize="${zone_size}" \
+		${job_var_opts[@]} \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.29.2


