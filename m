Return-Path: <prvs=47212d7a9=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 4/4] t/zbd: check log file for failed assertions
Date: Thu, 30 Jul 2020 06:04:15 +0900
Message-Id: <20200729210415.4166-5-dmitry.fomichev@wdc.com>
In-Reply-To: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Currently, a ZBD test can succeed even if an fio assertion is raised
during its run. Search every ZBD test log file for failed assertions
and fail the test if any were found.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 471a3487..139495d3 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -77,6 +77,13 @@ check_reset_count() {
     eval "[ '$reset_count' '$1' '$2' ]"
 }
 
+# Check log for failed assertions and crashes. Without these checks,
+# a test can succeed even when these events happen, but it must fail.
+check_log() {
+     [ ! -f "${logfile}.${1}" ] && return 0
+     ! grep -q -e "Assertion " -e "Aborted " "${logfile}.${1}"
+}
+
 # Whether or not $1 (/dev/...) is a SCSI device.
 is_scsi_device() {
     local d f
@@ -1008,7 +1015,7 @@ trap 'intr=1' SIGINT
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
     echo -n "Running test $(printf "%02d" $test_number) ... "
-    if eval "test$test_number"; then
+    if eval "test$test_number" && check_log $test_number; then
 	status="PASS"
 	cc_status="${green}${status}${end}"
 	((passed++))
-- 
2.21.0


