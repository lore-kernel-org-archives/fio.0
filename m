Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 35/38] t/zbd: add test #54 to exercise ZBD verification
Date: Thu,  7 Jan 2021 06:57:36 +0900
Message-Id: <20210106215739.264524-36-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Add a new test case to perform 75/25 read/write workload with varying
i/o size and verification on. It is very important to use a good random
generator for this test. Setting experimental_verify=1 is required for
this test to operate correctly.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 0b8015df..0230f1af 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1135,6 +1135,24 @@ test53() {
 	return 1
 }
 
+# Test read/write mix with verify.
+test54() {
+	require_zbd || return $SKIP_TESTCASE
+	require_seq_zones 8 || return $SKIP_TESTCASE
+
+	run_fio --name=job --filename=${dev} "$(ioengine "libaio")" \
+		--time_based=1 --runtime=30s --continue_on_error=0 \
+		--offset=$((first_sequential_zone_sector * 512)) \
+		--size=$((8*zone_size)) --direct=1 --iodepth=1 \
+		--rw=randrw:2 --rwmixwrite=25 --bsrange=4k-${zone_size} \
+		--zonemode=zbd --zonesize=${zone_size} \
+		--verify=crc32c --do_verify=1 --verify_backlog=2 \
+		--experimental_verify=1 \
+		--alloc-size=65536 --random_generator=tausworthe64 \
+		${job_var_opts[@]} --debug=zbd \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.28.0


