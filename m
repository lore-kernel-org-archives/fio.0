Return-Path: <prvs=407053df0=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 3/4] t/zbd: beautify test script output
Date: Tue, 26 May 2020 06:32:55 +0900
Message-Id: <20200525213256.7476-4-dmitry.fomichev@wdc.com>
In-Reply-To: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

The test printout columns are better aligned now. Also, the test
result, PASS/FAIL, is now color-coded and that makes it easier
to spot failures.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index de05f438..51b05dfd 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -929,19 +929,31 @@ logfile=$0.log
 
 passed=0
 failed=0
+if [ -t 1 ]; then
+    red="\e[1;31m"
+    green="\e[1;32m"
+    end="\e[m"
+else
+    red=""
+    green=""
+    end=""
+fi
 rc=0
+
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
-    echo -n "Running test $test_number ... "
+    echo -n "Running test $(printf "%02d" $test_number) ... "
     if eval "test$test_number"; then
 	status="PASS"
+	cc_status="${green}${status}${end}"
 	((passed++))
     else
 	status="FAIL"
+	cc_status="${red}${status}${end}"
 	((failed++))
 	rc=1
     fi
-    echo "$status"
+    echo -e "$cc_status"
     echo "$status" >> "${logfile}.${test_number}"
 done
 
-- 
2.21.0


