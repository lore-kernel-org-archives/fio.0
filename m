Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 25/36] t/zbd: skip tests that need too many sequential zones
Date: Thu, 24 Dec 2020 11:12:08 +0900
Message-Id: <20201224021219.189727-26-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Test cases #3, #4, #28, #29 and #48 require rather large numbers of
sequential zones to run properly and they fail if the test target
device has not enough of such zones in its zone configuration.

Check how many sequential zones are present on the test device and
skip any test cases for which this number is not enough.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index d94b5125..fa6a279b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -226,6 +226,17 @@ require_regular_block_dev() {
 	return 0
 }
 
+require_seq_zones() {
+	local req_seq_zones=${1}
+	local seq_bytes=$((disk_size - first_sequential_zone_sector * 512))
+
+	if ((req_seq_zones > seq_bytes / zone_size)); then
+		SKIP_REASON="$dev does not have $req_seq_zones sequential zones"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
@@ -265,6 +276,7 @@ test2() {
 test3() {
     local off opts=() rc
 
+    require_seq_zones 129 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 128 * zone_size))
     size=$((zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
@@ -282,6 +294,7 @@ test3() {
 test4() {
     local off opts=()
 
+    require_seq_zones 130 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 129 * zone_size))
     size=$((zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
@@ -631,6 +644,7 @@ test27() {
 test28() {
     local i jobs=16 off opts
 
+    require_seq_zones 65 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     prep_write
@@ -655,6 +669,7 @@ test28() {
 test29() {
     local i jobs=16 off opts=()
 
+    require_seq_zones 80 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
     prep_write
@@ -931,6 +946,7 @@ test48() {
     local i jobs=16 off opts=()
 
     require_zbd || return $SKIP_TESTCASE
+    require_seq_zones 80 || return $SKIP_TESTCASE
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-- 
2.28.0


