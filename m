Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 5/9] t/run-fio-tests: identify test id for debug messages
Date: Tue, 10 Dec 2019 12:54:38 -0500
Message-Id: <20191210175442.2975-6-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

---
 t/run-fio-tests.py | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 7fc3e4cd..4c7cc3a4 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -137,7 +137,7 @@ class FioExeTest(FioTest):
                                     universal_newlines=True)
             proc.communicate(timeout=self.success['timeout'])
             exticode_file.write('{0}\n'.format(proc.returncode))
-            logging.debug("return code: %d" % proc.returncode)
+            logging.debug("Test %d: return code: %d" % (self.testnum, proc.returncode))
             self.output['proc'] = proc
         except subprocess.TimeoutExpired:
             proc.terminate()
@@ -254,7 +254,7 @@ class FioJobTest(FioExeTest):
         if not self.precon_failed:
             super(FioJobTest, self).run()
         else:
-            logging.debug("precondition step failed")
+            logging.debug("Test %d: precondition step failed" % self.testnum)
 
     def check_result(self):
         if self.precon_failed:
@@ -291,7 +291,7 @@ class FioJobTest(FioExeTest):
             except json.JSONDecodeError:
                 continue
             else:
-                logging.debug("skipped %d lines decoding JSON data" % i)
+                logging.debug("Test %d: skipped %d lines decoding JSON data" % (self.testnum, i))
                 return
 
         self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
@@ -328,7 +328,7 @@ class FioJobTest_t0006(FioJobTest):
 
         ratio = self.json_data['jobs'][0]['read']['io_kbytes'] \
             / self.json_data['jobs'][0]['write']['io_kbytes']
-        logging.debug("ratio: %f" % ratio)
+        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
         if ratio < 1.99 or ratio > 2.01:
             self.failure_reason = "{0} read/write ratio mismatch,".format(self.failure_reason)
             self.passed = False
@@ -364,7 +364,7 @@ class FioJobTest_t0008(FioJobTest):
             return
 
         ratio = self.json_data['jobs'][0]['write']['io_kbytes'] / 16568
-        logging.debug("ratio: %f" % ratio)
+        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
 
         if ratio < 0.99 or ratio > 1.01:
             self.failure_reason = "{0} bytes written mismatch,".format(self.failure_reason)
@@ -384,7 +384,7 @@ class FioJobTest_t0009(FioJobTest):
         if not self.passed:
             return
 
-        logging.debug('elapsed: %d' % self.json_data['jobs'][0]['elapsed'])
+        logging.debug('Test %d: elapsed: %d' % (self.testnum, self.json_data['jobs'][0]['elapsed']))
 
         if self.json_data['jobs'][0]['elapsed'] < 60:
             self.failure_reason = "{0} elapsed time mismatch,".format(self.failure_reason)
@@ -406,7 +406,7 @@ class FioJobTest_t0011(FioJobTest):
         iops1 = self.json_data['jobs'][0]['read']['iops']
         iops2 = self.json_data['jobs'][1]['read']['iops']
         ratio = iops2 / iops1
-        logging.debug("ratio: %f" % ratio)
+        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
 
         if iops1 < 999 or iops1 > 1001:
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
@@ -473,7 +473,7 @@ class Requirements(object):
                     Requirements.cpucount4]
         for req in req_list:
             value, desc = req()
-            logging.debug("Requirement '%s' met? %s" % (desc, value))
+            logging.debug("Requirements: Requirement '%s' met? %s" % (desc, value))
 
     def linux():
         return Requirements._linux, "Linux required"
@@ -818,7 +818,7 @@ def main():
             for req in config['requirements']:
                 ok, reason = req()
                 skip = not ok
-                logging.debug("Requirement '%s' met? %s" % (reason, ok))
+                logging.debug("Test %d: Requirement '%s' met? %s" % (config['test_id'], reason, ok))
                 if skip:
                     break
             if skip:
@@ -836,9 +836,9 @@ def main():
             result = "FAILED: {0}".format(test.failure_reason)
             failed = failed + 1
             with open(test.stderr_file, "r") as stderr_file:
-                logging.debug("stderr:\n%s" % stderr_file.read())
+                logging.debug("Test %d: stderr:\n%s" % (config['test_id'], stderr_file.read()))
             with open(test.stdout_file, "r") as stdout_file:
-                logging.debug("stdout:\n%s" % stdout_file.read())
+                logging.debug("Test %d: stdout:\n%s" % (config['test_id'], stdout_file.read()))
         print("Test {0} {1}".format(config['test_id'], result))
 
     print("{0} test(s) passed, {1} failed, {2} skipped".format(passed, failed, skipped))
-- 
2.17.1


