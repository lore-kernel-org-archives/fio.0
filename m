Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 30/38] t/zbd: test random I/O direction in all-conventional case
Date: Wed, 27 Jan 2021 13:19:37 +0900
Message-Id: <20210127041945.36909-31-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

The number of 'sectors with data' is counted and used to determine the
direction of the first I/O of a random read/write ZBD workload. To
initialize the number, min_zone and max_zone fields in struct fio_file
are referred. There was a code bug that was recently fixed where
min_zone and max_zone fields were not initialized when all zones in I/O
region were conventional zones. This led to an uninitialized number of
sectors with data, and the write direction was always set for random
workloads.

Add a test case to perform random read/write workload on an I/O region
with both sequential and conventional zones. Check that both read and
write I/Os are executed.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 217fdd10..80763561 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1079,6 +1079,34 @@ test52() {
 	check_reset_count -eq 0 || return $?
 }
 
+# Check both reads and writes are executed by random I/O to conventional zones.
+test53() {
+	local off capacity io read_b=0 written_b=0
+
+	require_zbd || return $SKIP_TESTCASE
+	require_conv_zones 4 || return $SKIP_TESTCASE
+
+	off=$((first_sequential_zone_sector * 512 - 4 * zone_size))
+	capacity=$(total_zone_capacity 4 $off $dev)
+	run_fio --name=job --filename=${dev} --rw=randrw --bs=64K \
+		--size=$((4 * zone_size)) "$(ioengine "psync")" --offset=${off}\
+		--zonemode=zbd --direct=1 --zonesize=${zone_size} \
+		${job_var_opts[@]} \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+
+	written_b=$(fio_written <"${logfile}.${test_number}")
+	read_b=$(fio_read <"${logfile}.${test_number}")
+	io=$((written_b + read_b))
+	echo "Number of bytes read: $read_b" >>"${logfile}.${test_number}"
+	echo "Number of bytes written: $written_b" >>"${logfile}.${test_number}"
+	echo "Total number of bytes read and written: $io <> $capacity" \
+	     >>"${logfile}.${test_number}"
+	if ((io==capacity && written_b != 0 && read_b != 0)); then
+		return 0
+	fi
+	return 1
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.28.0


