Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/9] t/run-fio-tests: a few small improvements
Date: Tue, 10 Dec 2019 12:54:35 -0500
Message-Id: <20191210175442.2975-3-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

- add debug option that changes logging level
- improve error handling
- more output on test failures
- Python 3.5 compatibility with pathlib.Path and os.path.join
- warn if fio executable not found but don't abort because some tests
can run without the fio executable
---
 t/run-fio-tests.py | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index cf8de093..72314505 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -46,6 +46,7 @@ import os
 import sys
 import json
 import time
+import shutil
 import logging
 import argparse
 import subprocess
@@ -177,8 +178,8 @@ class FioExeTest(FioTest):
                     self.failure_reason = "{0} zero return code,".format(self.failure_reason)
                     self.passed = False
 
+        stderr_size = os.path.getsize(self.stderr_file)
         if 'stderr_empty' in self.success:
-            stderr_size = os.path.getsize(self.stderr_file)
             if self.success['stderr_empty']:
                 if stderr_size != 0:
                     self.failure_reason = "{0} stderr not empty,".format(self.failure_reason)
@@ -262,15 +263,22 @@ class FioJobTest(FioExeTest):
 
         super(FioJobTest, self).check_result()
 
+        if not self.passed:
+            return
+
         if 'json' in self.output_format:
-            output_file = open(os.path.join(self.test_dir, self.fio_output), "r")
-            file_data = output_file.read()
-            output_file.close()
             try:
-                self.json_data = json.loads(file_data)
-            except json.JSONDecodeError:
-                self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
+                with open(os.path.join(self.test_dir, self.fio_output), "r") as output_file:
+                    file_data = output_file.read()
+            except EnvironmentError:
+                self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
                 self.passed = False
+            else:
+                try:
+                    self.json_data = json.loads(file_data)
+                except json.JSONDecodeError:
+                    self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
+                    self.passed = False
 
 
 class FioJobTest_t0005(FioJobTest):
@@ -587,26 +595,33 @@ def parse_args():
                         help='list of test(s) to skip')
     parser.add_argument('-o', '--run-only', nargs='+', type=int,
                         help='list of test(s) to run, skipping all others')
+    parser.add_argument('-d', '--debug', action='store_true',
+                        help='provide debug output')
     args = parser.parse_args()
 
     return args
 
 
 def main():
-    logging.basicConfig(level=logging.INFO)
-
     args = parse_args()
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
     if args.fio_root:
         fio_root = args.fio_root
     else:
-        fio_root = Path(__file__).absolute().parent.parent
-    logging.debug("fio_root: %s" % fio_root)
+        fio_root = str(Path(__file__).absolute().parent.parent)
+    print("fio root is %s" % fio_root)
 
     if args.fio:
         fio_path = args.fio
     else:
         fio_path = os.path.join(fio_root, "fio")
-    logging.debug("fio_path: %s" % fio_path)
+    print("fio path is %s" % fio_path)
+    if not shutil.which(fio_path):
+        print("Warning: fio executable not found")
 
     artifact_root = args.artifact_root if args.artifact_root else \
         "fio-test-{0}".format(time.strftime("%Y%m%d-%H%M%S"))
@@ -667,6 +682,10 @@ def main():
         else:
             result = "FAILED: {0}".format(test.failure_reason)
             failed = failed + 1
+            with open(test.stderr_file, "r") as stderr_file:
+                logging.debug("stderr:\n%s" % stderr_file.read())
+            with open(test.stdout_file, "r") as stdout_file:
+                logging.debug("stdout:\n%s" % stdout_file.read())
         print("Test {0} {1}".format(config['test_id'], result))
 
     print("{0} test(s) passed, {1} failed, {2} skipped".format(passed, failed, skipped))
-- 
2.17.1


