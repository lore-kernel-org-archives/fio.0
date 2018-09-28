Return-Path: <bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/6] t/zbd/test-zbd-support: Report a test summary when finished
Date: Fri, 28 Sep 2018 14:51:31 -0700
Message-Id: <20180928215133.35222-5-bvanassche@acm.org>
In-Reply-To: <20180928215133.35222-1-bvanassche@acm.org>
References: <20180928215133.35222-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index fd30f5c6ecca..2d7279109af9 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -801,18 +801,26 @@ fi
 
 logfile=$0.log
 
+passed=0
+failed=0
 rc=0
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
     echo -n "Running test $test_number ... "
     if eval "test$test_number"; then
 	status="PASS"
+	((passed++))
     else
 	status="FAIL"
+	((failed++))
 	rc=1
     fi
     echo "$status"
     echo "$status" >> "${logfile}.${test_number}"
 done
 
+echo "$passed tests passed"
+if [ $failed -gt 0 ]; then
+    echo " and $failed tests failed"
+fi
 exit $rc
-- 
2.19.0.605.g01d371f741-goog


