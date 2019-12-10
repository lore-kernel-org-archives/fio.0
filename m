Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 4/9] t/run-fio-tests: improve Windows support
Date: Tue, 10 Dec 2019 12:54:37 -0500
Message-Id: <20191210175442.2975-5-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
References: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

- add .exe extension for fio and unittest
- for python scripts use 'python.exe script.py' instead of ./script.py
- make JSON decoding more resilient by lopping off up to four of the
first lines when encountering decoding errors. This helps Windows
because for some jobs fio prints an informational message about
requiring threads
---
 t/run-fio-tests.py | 56 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 40b85310..7fc3e4cd 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -267,19 +267,35 @@ class FioJobTest(FioExeTest):
         if not self.passed:
             return
 
-        if 'json' in self.output_format:
+        if not 'json' in self.output_format:
+            return
+
+        try:
+            with open(os.path.join(self.test_dir, self.fio_output), "r") as output_file:
+                file_data = output_file.read()
+        except EnvironmentError:
+            self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
+            self.passed = False
+            return
+
+        #
+        # Sometimes fio informational messages are included at the top of the
+        # JSON output, especially under Windows. Try to decode output as JSON
+        # data, lopping off up to the first four lines
+        #
+        lines = file_data.splitlines()
+        for i in range(5):
+            file_data = '\n'.join(lines[i:])
             try:
-                with open(os.path.join(self.test_dir, self.fio_output), "r") as output_file:
-                    file_data = output_file.read()
-            except EnvironmentError:
-                self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
-                self.passed = False
+                self.json_data = json.loads(file_data)
+            except json.JSONDecodeError:
+                continue
             else:
-                try:
-                    self.json_data = json.loads(file_data)
-                except json.JSONDecodeError:
-                    self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
-                    self.passed = False
+                logging.debug("skipped %d lines decoding JSON data" % i)
+                return
+
+        self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
+        self.passed = False
 
 
 class FioJobTest_t0005(FioJobTest):
@@ -438,7 +454,11 @@ class Requirements(object):
                     if os.path.exists("/sys/module/null_blk/parameters/zoned"):
                         Requirements._zoned_nullb = True
 
-        unittest_path = os.path.join(fio_root, "unittests", "unittest")
+        if platform.system() == "Windows":
+            utest_exe = "unittest.exe"
+        else:
+            utest_exe = "unittest"
+        unittest_path = os.path.join(fio_root, "unittests", utest_exe)
         Requirements._unittests = os.path.exists(unittest_path)
 
         Requirements._cpucount4 = multiprocessing.cpu_count() >= 4
@@ -725,7 +745,11 @@ def main():
     if args.fio:
         fio_path = args.fio
     else:
-        fio_path = os.path.join(fio_root, "fio")
+        if platform.system() == "Windows":
+            fio_exe = "fio.exe"
+        else:
+            fio_exe = "fio"
+        fio_path = os.path.join(fio_root, fio_exe)
     print("fio path is %s" % fio_path)
     if not shutil.which(fio_path):
         print("Warning: fio executable not found")
@@ -776,6 +800,12 @@ def main():
                 parameters = [p.format(fio_path=fio_path) for p in config['parameters']]
             else:
                 parameters = None
+            if Path(exe_path).suffix == '.py' and platform.system() == "Windows":
+                if parameters:
+                    parameters.insert(0, exe_path)
+                else:
+                    parameters = [exe_path]
+                exe_path = "python.exe"
             test = config['test_class'](exe_path, parameters,
                                         config['success'])
         else:
-- 
2.17.1


