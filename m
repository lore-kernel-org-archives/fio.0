Return-Path: <prvs=947609abe=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4/8] t/zbd: Fix test 2 and 3 result handling
Date: Wed, 20 Feb 2019 16:17:21 +0900
Message-Id: <20190220071725.8487-5-damien.lemoal@wdc.com>
In-Reply-To: <20190220071725.8487-1-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Removal of the message "No I/O performed" when fio does not execute any
I/O broke zbd tests 2 and 3 as this message is looked after to test for
success. Fix this by looking for a "Run status" line starting with
"WRITE:" for test 2 and "READ:" for test 3. The run status lines are not
printed when no I/O is performed. Testing for the absence of these
strings thus allows to easily test if I/Os where executed or not.

Fixes: ff3aa922570c ("Kill "No I/O performed by ..." message")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index d316d880..c6391169 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -141,9 +141,9 @@ test2() {
     if [ -z "$is_zbd" ]; then
 	opts+=("--zonesize=${zone_size}")
     fi
-    run_fio "${opts[@]}" 2>&1 |
-	tee -a "${logfile}.${test_number}" |
-	grep -q 'No I/O performed'
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+    grep -q 'WRITE:' "${logfile}.${test_number}"
+    [ $? != 0 ]
 }
 
 # Run fio against an empty zone. This causes fio to report "No I/O performed".
@@ -160,12 +160,12 @@ test3() {
 	opts+=("--zonesize=${zone_size}")
     fi
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    grep -q "No I/O performed" "${logfile}.${test_number}"
+    grep -q 'READ:' "${logfile}.${test_number}"
     rc=$?
     if [ -n "$is_zbd" ]; then
-	[ $rc = 0 ]
-    else
 	[ $rc != 0 ]
+    else
+	[ $rc = 0 ]
     fi
 }
 
-- 
2.20.1


