Return-Path: <prvs=7094d7b7f=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] t/zbd: test repeated async write to sequential write required zones
Date: Tue, 23 Mar 2021 10:13:24 +0900
Message-Id: <20210323011324.1365343-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
References: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

A recently fixed bug was caused by conflict between asynchronous IOs
to a zone and zone reset for file reset. To confirm the bug fix and to
prevent future regression, add a test case which triggers the bug. The
test case repeats random write to multiple zones with libaio engine. The
bug was observed when block size is equal to max_sectors_kb sysfs
attribute. Add a new helper function get_sysfs_bdev() to get the
attribute of the test target device.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions        | 12 ++++++++++++
 t/zbd/test-zbd-support | 18 ++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/t/zbd/functions b/t/zbd/functions
index 40ffe1de..56ac2952 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -84,6 +84,18 @@ first_sequential_zone() {
     fi
 }
 
+# Get sysfs block device attribute. The given device must be a block device.
+get_bdev_sysfs() {
+	local dev=${1}
+	local attr=${2}
+	local major minro
+
+	major=$((0x$(stat -L -c '%t' "$dev"))) || exit $?
+	minor=$((0x$(stat -L -c '%T' "$dev"))) || exit $?
+
+	cat "/sys/dev/block/${major}:${minor}/${attr}"
+}
+
 # Reports the summed zone capacity of $1 number of zones starting from offset $2
 # on device $3.
 total_zone_capacity() {
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index be129615..bf9e8e07 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1201,6 +1201,24 @@ test56() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test that async writes to zones and zone reset to them for repeated workload
+# do not conflict.
+test57() {
+	local bs off
+
+	require_zbd || return $SKIP_TESTCASE
+
+	bs=$(($(get_bdev_sysfs "${dev}" queue/max_sectors_kb) * 1024))
+	off=$((first_sequential_zone_sector * 512))
+
+	run_fio --name=job --filename="${dev}" --rw=randwrite --bs="${bs}" \
+		--offset="${off}" --size=$((4 * zone_size)) --iodepth=256 \
+		"$(ioengine "libaio")" --numjob=4 --time_based=1 --runtime=30s \
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


