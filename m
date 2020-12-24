Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 26/36] t/zbd: test that conventional zones are not locked during random i/o
Date: Thu, 24 Dec 2020 11:12:09 +0900
Message-Id: <20201224021219.189727-27-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

A recently fixed bug was caused by an unexpected conventional zone lock
during random I/O adjustment. Only sequential zones are supposed to be
locked, but the conventional zone lock was observed with a random
workload against an I/O region with mixed conventional and sequential
zones.

Add two test cases with the same workload to ensure that no similar
regression happens in the future. One case tests reads and the other
is for writes. As a related change, add the helper function
require_conv_zones() to check that the test target device has enough
conventional zones available.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 56 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index fa6a279b..4ad55381 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -237,6 +237,17 @@ require_seq_zones() {
 	return 0
 }
 
+require_conv_zones() {
+	local req_c_zones=${1}
+	local conv_bytes=$((first_sequential_zone_sector * 512))
+
+	if ((req_c_zones > conv_bytes / zone_size)); then
+		SKIP_REASON="$dev does not have $req_c_zones conventional zones"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
@@ -991,6 +1002,51 @@ test49() {
     check_read $((capacity * 2)) || return $?
 }
 
+# Verify that conv zones are not locked and only seq zones are locked during
+# random read on conv-seq mixed zones.
+test50() {
+	local off
+
+	require_zbd || return $SKIP_TESTCASE
+	require_conv_zones 8 || return $SKIP_TESTCASE
+	require_seq_zones 8 || return $SKIP_TESTCASE
+
+	reset_zone "${dev}" -1
+
+	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
+	run_fio --name=job --filename=${dev} --offset=${off} --bs=64K \
+		--size=$((16 * zone_size)) "$(ioengine "libaio")" --rw=randread\
+		--time_based --runtime=3 --zonemode=zbd --zonesize=${zone_size}\
+		--direct=1 --group_reporting=1 ${job_var_opts[@]} \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+# Verify that conv zones are neither locked nor opened during random write on
+# conv-seq mixed zones. Zone lock and zone open shall happen only on seq zones.
+test51() {
+	local off jobs=16
+	local -a opts
+
+	require_zbd || return $SKIP_TESTCASE
+	require_conv_zones 8 || return $SKIP_TESTCASE
+	require_seq_zones 8 || return $SKIP_TESTCASE
+
+	prep_write
+
+	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
+	opts+=("--size=$((16 * zone_size))" "$(ioengine "libaio")")
+	opts+=("--zonemode=zbd" "--direct=1" "--zonesize=${zone_size}")
+	opts+=("--max_open_zones=2" "--offset=$off")
+	opts+=("--thread=1" "--group_reporting=1")
+	opts+=("--time_based" "--runtime=30" "--rw=randwrite")
+	for ((i=0;i<jobs;i++)); do
+		opts+=("--name=job${i}" "--filename=$dev")
+		opts+=("--bs=$(((i+1)*16))K")
+		opts+=($(job_var_opts_exclude "--max_open_zones"))
+	done
+	run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.28.0


