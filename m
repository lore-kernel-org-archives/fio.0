Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5/5] t/run-fio-tests.py: Accept a wider range of IOPS values
Date: Sun,  7 Jun 2020 12:11:04 -0700
Message-Id: <20200607191104.17550-6-bvanassche@acm.org>
In-Reply-To: <20200607191104.17550-1-bvanassche@acm.org>
References: <20200607191104.17550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>, Vincent Fu <vincent.fu@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

This patch prevents that test 11 sporadically fails as follows:

DEBUG:root:Test 11: return code: 0
DEBUG:root:Test 11: skipped 0 lines decoding JSON data
DEBUG:root:Test 11: iops1: 997.670549
DEBUG:root:Test 11: ratio: 8.163684

Test 11 FAILED:  iops value mismatch,

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 t/run-fio-tests.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index e7063d3eb63a..c2352d80c2bf 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -438,7 +438,7 @@ class FioJobTest_t0011(FioJobTest):
         logging.debug("Test %d: iops1: %f", self.testnum, iops1)
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
-        if iops1 < 998 or iops1 > 1002:
+        if iops1 < 997 or iops1 > 1003:
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
             self.passed = False
 

