Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 9/9] t/run-fio-tests: relax acceptance criterion for t0011
Date: Tue, 10 Dec 2019 12:54:42 -0500
Message-Id: <20191210175442.2975-10-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

I saw a handful of benign failures for t0011 when run on
travis/appveyor. This patch allows the test to still pass with a
measured IOPS of 998 to 1002 and adds a debug print for the value
actually observed.
---
 t/run-fio-tests.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 4c7cc3a4..a0a1e8fa 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -406,9 +406,10 @@ class FioJobTest_t0011(FioJobTest):
         iops1 = self.json_data['jobs'][0]['read']['iops']
         iops2 = self.json_data['jobs'][1]['read']['iops']
         ratio = iops2 / iops1
+        logging.debug("Test %d: iops1: %f" % (self.testnum, iops1))
         logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
 
-        if iops1 < 999 or iops1 > 1001:
+        if iops1 < 998 or iops1 > 1002:
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
             self.passed = False
 
-- 
2.17.1


