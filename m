Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 3/9] t/run-fio-tests: detect requirements and skip tests accordingly
Date: Tue, 10 Dec 2019 12:54:36 -0500
Message-Id: <20191210175442.2975-4-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Also provide an option to skip requirement checking

Suggested-by: <shinichiro.kawasaki@wdc.com>
---
 t/run-fio-tests.py | 129 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 126 insertions(+), 3 deletions(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 72314505..40b85310 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -21,7 +21,7 @@
 #
 #
 # REQUIREMENTS
-# - Python 3
+# - Python 3.5 (subprocess.run)
 # - Linux (libaio ioengine, zbd tests, etc)
 # - The artifact directory must be on a file system that accepts 512-byte IO
 #   (t0002, t0003, t0004).
@@ -39,7 +39,6 @@
 #
 # TODO  run multiple tests simultaneously
 # TODO  Add sgunmap tests (requires SAS SSD)
-# TODO  automatically detect dependencies and skip tests accordingly
 #
 
 import os
@@ -49,7 +48,9 @@ import time
 import shutil
 import logging
 import argparse
+import platform
 import subprocess
+import multiprocessing
 from pathlib import Path
 
 
@@ -400,6 +401,85 @@ class FioJobTest_t0011(FioJobTest):
             self.passed = False
 
 
+class Requirements(object):
+    """Requirements consists of multiple run environment characteristics.
+    These are to determine if a particular test can be run"""
+
+    _linux = False
+    _libaio = False
+    _zbd = False
+    _root = False
+    _zoned_nullb = False
+    _not_macos = False
+    _unittests = False
+    _cpucount4 = False
+
+    def __init__(self, fio_root):
+        Requirements._not_macos = platform.system() != "Darwin"
+        Requirements._linux = platform.system() == "Linux"
+
+        if Requirements._linux:
+            try:
+                config_file = os.path.join(fio_root, "config-host.h")
+                with open(config_file, "r") as config:
+                    contents = config.read()
+            except Exception:
+                print("Unable to open {0} to check requirements".format(config_file))
+                Requirements._zbd = True
+            else:
+                Requirements._zbd = "CONFIG_LINUX_BLKZONED" in contents
+                Requirements._libaio = "CONFIG_LIBAIO" in contents
+
+            Requirements._root = (os.geteuid() == 0)
+            if Requirements._zbd and Requirements._root:
+                    subprocess.run(["modprobe", "null_blk"],
+                                   stdout=subprocess.PIPE,
+                                   stderr=subprocess.PIPE)
+                    if os.path.exists("/sys/module/null_blk/parameters/zoned"):
+                        Requirements._zoned_nullb = True
+
+        unittest_path = os.path.join(fio_root, "unittests", "unittest")
+        Requirements._unittests = os.path.exists(unittest_path)
+
+        Requirements._cpucount4 = multiprocessing.cpu_count() >= 4
+
+        req_list = [Requirements.linux,
+                    Requirements.libaio,
+                    Requirements.zbd,
+                    Requirements.root,
+                    Requirements.zoned_nullb,
+                    Requirements.not_macos,
+                    Requirements.unittests,
+                    Requirements.cpucount4]
+        for req in req_list:
+            value, desc = req()
+            logging.debug("Requirement '%s' met? %s" % (desc, value))
+
+    def linux():
+        return Requirements._linux, "Linux required"
+
+    def libaio():
+        return Requirements._libaio, "libaio required"
+
+    def zbd():
+        return Requirements._zbd, "Zoned block device support required"
+
+    def root():
+        return Requirements._root, "root required"
+
+    def zoned_nullb():
+        return Requirements._zoned_nullb, "Zoned null block device support required"
+
+    def not_macos():
+        return Requirements._not_macos, "platform other than macOS required"
+
+    def unittests():
+        return Requirements._unittests, "Unittests support required"
+
+    def cpucount4():
+        return Requirements._cpucount4, "4+ CPUs required"
+
+
 SUCCESS_DEFAULT = {
         'zero_return': True,
         'stderr_empty': True,
@@ -423,6 +503,7 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'pre_job':          None,
             'pre_success':      None,
+            'requirements':     [],
         },
         {
             'test_id':          2,
@@ -431,6 +512,7 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'pre_job':          't0002-13af05ae-pre.fio',
             'pre_success':      None,
+            'requirements':     [Requirements.linux, Requirements.libaio],
         },
         {
             'test_id':          3,
@@ -439,6 +521,7 @@ TEST_LIST = [
             'success':          SUCCESS_NONZERO,
             'pre_job':          't0003-0ae2c6e1-pre.fio',
             'pre_success':      SUCCESS_DEFAULT,
+            'requirements':     [Requirements.linux, Requirements.libaio],
         },
         {
             'test_id':          4,
@@ -447,6 +530,7 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'pre_job':          None,
             'pre_success':      None,
+            'requirements':     [Requirements.linux, Requirements.libaio],
         },
         {
             'test_id':          5,
@@ -456,6 +540,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [],
         },
         {
             'test_id':          6,
@@ -465,6 +550,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [Requirements.linux, Requirements.libaio],
         },
         {
             'test_id':          7,
@@ -474,6 +560,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [],
         },
         {
             'test_id':          8,
@@ -483,6 +570,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [],
         },
         {
             'test_id':          9,
@@ -492,6 +580,9 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [Requirements.not_macos,
+                                 Requirements.cpucount4],
+                                # mac os does not support CPU affinity
         },
         {
             'test_id':          10,
@@ -500,6 +591,7 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'pre_job':          None,
             'pre_success':      None,
+            'requirements':     [],
         },
         {
             'test_id':          11,
@@ -509,6 +601,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [],
         },
         {
             'test_id':          1000,
@@ -516,6 +609,7 @@ TEST_LIST = [
             'exe':              't/axmap',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1001,
@@ -523,6 +617,7 @@ TEST_LIST = [
             'exe':              't/ieee754',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1002,
@@ -530,6 +625,7 @@ TEST_LIST = [
             'exe':              't/lfsr-test',
             'parameters':       ['0xFFFFFF', '0', '0', 'verify'],
             'success':          SUCCESS_STDERR,
+            'requirements':     [],
         },
         {
             'test_id':          1003,
@@ -537,6 +633,7 @@ TEST_LIST = [
             'exe':              't/readonly.py',
             'parameters':       ['-f', '{fio_path}'],
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1004,
@@ -544,6 +641,7 @@ TEST_LIST = [
             'exe':              't/steadystate_tests.py',
             'parameters':       ['{fio_path}'],
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1005,
@@ -551,6 +649,7 @@ TEST_LIST = [
             'exe':              't/stest',
             'parameters':       None,
             'success':          SUCCESS_STDERR,
+            'requirements':     [],
         },
         {
             'test_id':          1006,
@@ -558,6 +657,7 @@ TEST_LIST = [
             'exe':              't/strided.py',
             'parameters':       ['{fio_path}'],
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1007,
@@ -565,6 +665,8 @@ TEST_LIST = [
             'exe':              't/zbd/run-tests-against-regular-nullb',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [Requirements.linux, Requirements.zbd,
+                                 Requirements.root],
         },
         {
             'test_id':          1008,
@@ -572,6 +674,8 @@ TEST_LIST = [
             'exe':              't/zbd/run-tests-against-zoned-nullb',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [Requirements.linux, Requirements.zbd,
+                                 Requirements.root, Requirements.zoned_nullb],
         },
         {
             'test_id':          1009,
@@ -579,6 +683,7 @@ TEST_LIST = [
             'exe':              'unittests/unittest',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [Requirements.unittests],
         },
 ]
 
@@ -597,6 +702,8 @@ def parse_args():
                         help='list of test(s) to run, skipping all others')
     parser.add_argument('-d', '--debug', action='store_true',
                         help='provide debug output')
+    parser.add_argument('-k', '--skip-req', action='store_true',
+                        help='skip requirements checking')
     args = parser.parse_args()
 
     return args
@@ -628,6 +735,9 @@ def main():
     os.mkdir(artifact_root)
     print("Artifact directory is %s" % artifact_root)
 
+    if not args.skip_req:
+        req = Requirements(fio_root)
+
     passed = 0
     failed = 0
     skipped = 0
@@ -636,7 +746,7 @@ def main():
         if (args.skip and config['test_id'] in args.skip) or \
            (args.run_only and config['test_id'] not in args.run_only):
             skipped = skipped + 1
-            print("Test {0} SKIPPED".format(config['test_id']))
+            print("Test {0} SKIPPED (User request)".format(config['test_id']))
             continue
 
         if issubclass(config['test_class'], FioJobTest):
@@ -673,6 +783,19 @@ def main():
             failed = failed + 1
             continue
 
+        if not args.skip_req:
+            skip = False
+            for req in config['requirements']:
+                ok, reason = req()
+                skip = not ok
+                logging.debug("Requirement '%s' met? %s" % (reason, ok))
+                if skip:
+                    break
+            if skip:
+                print("Test {0} SKIPPED ({1})".format(config['test_id'], reason))
+                skipped = skipped + 1
+                continue
+
         test.setup(artifact_root, config['test_id'])
         test.run()
         test.check_result()
-- 
2.17.1


