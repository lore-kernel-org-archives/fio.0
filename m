Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 29/38] t/zbd: test that zone_reset_threshold calculation is correct
Date: Thu,  7 Jan 2021 06:57:30 +0900
Message-Id: <20210106215739.264524-30-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

The option "zone_reset_threshold" specifies the ratio of logical blocks
with data to trigger zone resets. When the I/O range includes
conventional zones, only blocks in sequential zones must be used to
track this value. A recently fixed bug has uncovered that the number of
blocks in conventional zones were erroneously counted as the blocks
with data.

To prevent future regressions, add a test case to confirm that the
logical blocks accounting does not include conventional zones.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4ad55381..217fdd10 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1047,6 +1047,38 @@ test51() {
 	run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Verify that zone_reset_threshold only takes logical blocks from seq
+# zones into account, and logical blocks of conv zones are not counted.
+test52() {
+	local off io_size
+
+	require_zbd || return $SKIP_TESTCASE
+	require_conv_zones 8 || return $SKIP_TESTCASE
+	require_seq_zones 8 || return $SKIP_TESTCASE
+
+	reset_zone "${dev}" -1
+
+	# Total I/O size is 1/8 = 0.125 of the I/O range of cont + seq zones.
+	# Set zone_reset_threshold as 0.1. The threshold size is less than
+	# 0.125, then, reset count zero is expected.
+	# On the other hand, half of the I/O range is covered by conv zones.
+	# If fio would count the conv zones for zone_reset_threshold, the ratio
+	# were more than 0.5 and would trigger zone resets.
+
+	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
+	io_size=$((zone_size * 16 / 8))
+	run_fio --name=job --filename=$dev --rw=randwrite --bs=$((zone_size/16))\
+		--size=$((zone_size * 16)) --softrandommap=1 \
+		--io_size=$((io_size)) "$(ioengine "psync")" --offset=$off \
+		--zonemode=zbd --direct=1 --zonesize=${zone_size} \
+		--zone_reset_threshold=.1 --zone_reset_frequency=1.0 \
+		${job_var_opts[@]} --debug=zbd \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+
+	check_written ${io_size} || return $?
+	check_reset_count -eq 0 || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.28.0


