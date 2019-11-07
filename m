Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfKGNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Nov 2019 08:00:07 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iShOM-0001Uv-Nu
        for fio@vger.kernel.org; Thu, 07 Nov 2019 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191107130002.069012C01F8@kernel.dk>
Date: Thu,  7 Nov 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d5c4f97458d59689c3d1a13831519617d000fb19:

  arch-arm: Consider armv7ve arch as well (2019-11-05 06:41:55 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cc16261082a4d0f027cef9d019ad023129bf6012:

  Merge branch 'testing' of https://github.com/vincentkfu/fio (2019-11-06 17:04:17 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'testing' of https://github.com/vincentkfu/fio

Vincent Fu (12):
      t/iee754: add return value
      t/readonly: replace shell script with python script
      t/strided.py: change LFSR tests
      t/steadystate_tests: better support automated testing
      t/sgunmap-test.py: drop six.moves dependency
      t/stest: non-zero exit value on failure
      t/jobs: fixup t0002 test jobs
      t/jobs: use current directory for test file for t0003 and t0004
      t/jobs: drop time_based in t0007
      t/jobs: clean up t0009 and use only 4 CPUs
      t/jobs: fix t0011 syntax error
      t/run-fio-tests: a script to automate running fio tests

 t/ieee754.c                                        |  15 +-
 t/jobs/readonly-r.fio                              |   5 -
 t/jobs/readonly-t.fio                              |   5 -
 t/jobs/readonly-w.fio                              |   5 -
 ...t0002-13af05ae-post => t0002-13af05ae-post.fio} |  48 +-
 .../{t0002-13af05ae-pre => t0002-13af05ae-pre.fio} |  46 +-
 t/jobs/t0003-0ae2c6e1-post.fio                     |   2 +-
 t/jobs/t0003-0ae2c6e1-pre.fio                      |   2 +-
 t/jobs/t0004-8a99fdf6.fio                          |   2 +-
 t/jobs/t0007-37cf9e3c.fio                          |   1 -
 t/jobs/t0009-f8b0bd10.fio                          |   6 +-
 t/jobs/t0011-5d2788d5.fio                          |   2 +-
 t/readonly.py                                      | 138 +++++
 t/readonly.sh                                      |  84 ---
 t/run-fio-tests.py                                 | 676 +++++++++++++++++++++
 t/sgunmap-test.py                                  |   1 -
 t/steadystate_tests.py                             |  40 +-
 t/stest.c                                          |  15 +-
 t/strided.py                                       |  36 +-
 19 files changed, 936 insertions(+), 193 deletions(-)
 delete mode 100644 t/jobs/readonly-r.fio
 delete mode 100644 t/jobs/readonly-t.fio
 delete mode 100644 t/jobs/readonly-w.fio
 rename t/jobs/{t0002-13af05ae-post => t0002-13af05ae-post.fio} (85%)
 rename t/jobs/{t0002-13af05ae-pre => t0002-13af05ae-pre.fio} (85%)
 create mode 100755 t/readonly.py
 delete mode 100755 t/readonly.sh
 create mode 100755 t/run-fio-tests.py

---

Diff of recent changes:

diff --git a/t/ieee754.c b/t/ieee754.c
index 3898ab74..b6526394 100644
--- a/t/ieee754.c
+++ b/t/ieee754.c
@@ -1,21 +1,26 @@
 #include <stdio.h>
 #include "../lib/ieee754.h"
 
-static double values[] = { -17.23, 17.23, 123.4567, 98765.4321, 0.0 };
+static double values[] = { -17.23, 17.23, 123.4567, 98765.4321,
+	3.14159265358979323, 0.0 };
 
 int main(int argc, char *argv[])
 {
 	uint64_t i;
-	double f;
-	int j;
+	double f, delta;
+	int j, differences = 0;
 
 	j = 0;
 	do {
 		i = fio_double_to_uint64(values[j]);
 		f = fio_uint64_to_double(i);
-		printf("%f -> %f\n", values[j], f);
+		delta = values[j] - f;
+		printf("%26.20lf -> %26.20lf, delta = %26.20lf\n", values[j],
+			f, delta);
+		if (f != values[j])
+			differences++;
 		j++;
 	} while (values[j] != 0.0);
 
-	return 0;
+	return differences;
 }
diff --git a/t/jobs/readonly-r.fio b/t/jobs/readonly-r.fio
deleted file mode 100644
index 34ba9b5e..00000000
--- a/t/jobs/readonly-r.fio
+++ /dev/null
@@ -1,5 +0,0 @@
-[test]
-filename=${DUT}
-rw=randread
-time_based
-runtime=1s
diff --git a/t/jobs/readonly-t.fio b/t/jobs/readonly-t.fio
deleted file mode 100644
index f3e093c1..00000000
--- a/t/jobs/readonly-t.fio
+++ /dev/null
@@ -1,5 +0,0 @@
-[test]
-filename=${DUT}
-rw=randtrim
-time_based
-runtime=1s
diff --git a/t/jobs/readonly-w.fio b/t/jobs/readonly-w.fio
deleted file mode 100644
index 26029ef2..00000000
--- a/t/jobs/readonly-w.fio
+++ /dev/null
@@ -1,5 +0,0 @@
-[test]
-filename=${DUT}
-rw=randwrite
-time_based
-runtime=1s
diff --git a/t/jobs/t0002-13af05ae-post b/t/jobs/t0002-13af05ae-post.fio
similarity index 85%
rename from t/jobs/t0002-13af05ae-post
rename to t/jobs/t0002-13af05ae-post.fio
index b7d5bab9..d141d406 100644
--- a/t/jobs/t0002-13af05ae-post
+++ b/t/jobs/t0002-13af05ae-post.fio
@@ -1,24 +1,24 @@
-[global]
-ioengine=libaio
-direct=1
-filename=/dev/fioa
-iodepth=128
-size=1G
-loops=1
-group_reporting=1
-readwrite=read
-do_verify=1
-verify=md5
-verify_fatal=1
-numjobs=1
-thread
-bssplit=512/50:1M/50
-
-[thread0]
-offset=0G
-
-[thread-mix0]
-offset=4G
-size=1G
-readwrite=rw
-bsrange=512:1M
+[global]
+ioengine=libaio
+direct=1
+filename=t0002file
+iodepth=128
+size=1G
+loops=1
+group_reporting=1
+readwrite=read
+do_verify=1
+verify=md5
+verify_fatal=1
+numjobs=1
+thread
+bssplit=512/50:1M/50
+
+[thread0]
+offset=0G
+
+[thread-mix0]
+offset=4G
+size=1G
+readwrite=rw
+bsrange=512:1M
diff --git a/t/jobs/t0002-13af05ae-pre b/t/jobs/t0002-13af05ae-pre.fio
similarity index 85%
rename from t/jobs/t0002-13af05ae-pre
rename to t/jobs/t0002-13af05ae-pre.fio
index 77dd48fd..0e044d47 100644
--- a/t/jobs/t0002-13af05ae-pre
+++ b/t/jobs/t0002-13af05ae-pre.fio
@@ -1,23 +1,23 @@
-[global]
-ioengine=libaio
-direct=1
-filename=/dev/fioa
-iodepth=128
-size=1G
-loops=1
-group_reporting=1
-readwrite=write
-do_verify=0
-verify=md5
-numjobs=1
-thread
-bssplit=512/50:1M/50
-
-[thread0]
-offset=0G
-
-[thread-mix0]
-offset=4G
-readwrite=rw
-size=1G
-bsrange=512:1M
+[global]
+ioengine=libaio
+direct=1
+filename=t0002file
+iodepth=128
+size=1G
+loops=1
+group_reporting=1
+readwrite=write
+do_verify=0
+verify=md5
+numjobs=1
+thread
+bssplit=512/50:1M/50
+
+[thread0]
+offset=0G
+
+[thread-mix0]
+offset=4G
+readwrite=rw
+size=1G
+bsrange=512:1M
diff --git a/t/jobs/t0003-0ae2c6e1-post.fio b/t/jobs/t0003-0ae2c6e1-post.fio
index 8bc4f05a..4e7887a3 100644
--- a/t/jobs/t0003-0ae2c6e1-post.fio
+++ b/t/jobs/t0003-0ae2c6e1-post.fio
@@ -3,7 +3,7 @@
 [global]
 ioengine=libaio
 direct=1
-filename=/tmp/foo
+filename=foo
 iodepth=128
 size=1M
 loops=1
diff --git a/t/jobs/t0003-0ae2c6e1-pre.fio b/t/jobs/t0003-0ae2c6e1-pre.fio
index 46f452cb..a9a9f319 100644
--- a/t/jobs/t0003-0ae2c6e1-pre.fio
+++ b/t/jobs/t0003-0ae2c6e1-pre.fio
@@ -1,7 +1,7 @@
 [global]
 ioengine=libaio
 direct=1
-filename=/tmp/foo
+filename=foo
 iodepth=128
 size=10M
 loops=1
diff --git a/t/jobs/t0004-8a99fdf6.fio b/t/jobs/t0004-8a99fdf6.fio
index 09ae9b26..0fc3e0de 100644
--- a/t/jobs/t0004-8a99fdf6.fio
+++ b/t/jobs/t0004-8a99fdf6.fio
@@ -3,7 +3,7 @@
 [global]
 ioengine=libaio
 direct=1
-filename=/tmp/foo
+filename=foo
 iodepth=128
 size=10M
 loops=1
diff --git a/t/jobs/t0007-37cf9e3c.fio b/t/jobs/t0007-37cf9e3c.fio
index fd70c21c..d3c98751 100644
--- a/t/jobs/t0007-37cf9e3c.fio
+++ b/t/jobs/t0007-37cf9e3c.fio
@@ -4,7 +4,6 @@
 size=128mb
 rw=read:512k
 bs=1m
-time_based
 norandommap
 write_iolog=log
 direct=1
diff --git a/t/jobs/t0009-f8b0bd10.fio b/t/jobs/t0009-f8b0bd10.fio
index 90e07ad8..20f376e6 100644
--- a/t/jobs/t0009-f8b0bd10.fio
+++ b/t/jobs/t0009-f8b0bd10.fio
@@ -16,21 +16,21 @@ numjobs=1
 #numjobs=24
 # number_ios=1
 # runtime=216000
-runtime=3600
+#runtime=3600
 time_based=1
 group_reporting=1
 thread
 gtod_reduce=1
 iodepth_batch=4
 iodepth_batch_complete=4
-cpus_allowed=0-5
+cpus_allowed=0-3
 cpus_allowed_policy=split
 rw=randwrite
 verify=crc32c-intel
 verify_backlog=1m
 do_verify=1
 verify_async=6
-verify_async_cpus=0-5
+verify_async_cpus=0-3
 runtime=1m
 
 [4_KiB_RR_drive_r]
diff --git a/t/jobs/t0011-5d2788d5.fio b/t/jobs/t0011-5d2788d5.fio
index 09861f7f..50daf612 100644
--- a/t/jobs/t0011-5d2788d5.fio
+++ b/t/jobs/t0011-5d2788d5.fio
@@ -1,7 +1,7 @@
 # Expected results: no parse warnings, runs and with roughly 1/8 iops between
 #			the two jobs.
 # Buggy result: parse warning on flow value overflow, no 1/8 division between
-			jobs.
+#			jobs.
 #
 [global]
 bs=4k
diff --git a/t/readonly.py b/t/readonly.py
new file mode 100755
index 00000000..43686c9c
--- /dev/null
+++ b/t/readonly.py
@@ -0,0 +1,138 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (c) 2019 Western Digital Corporation or its affiliates.
+#
+#
+# readonly.py
+#
+# Do some basic tests of the --readonly paramter
+#
+# USAGE
+# python readonly.py [-f fio-executable]
+#
+# EXAMPLES
+# python t/readonly.py
+# python t/readonly.py -f ./fio
+#
+# REQUIREMENTS
+# Python 3.5+
+#
+#
+
+import sys
+import argparse
+import subprocess
+
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio',
+                        help='path to fio executable (e.g., ./fio)')
+    args = parser.parse_args()
+
+    return args
+
+
+def run_fio(fio, test, index):
+    fio_args = [
+                "--name=readonly",
+                "--ioengine=null",
+                "--time_based",
+                "--runtime=1s",
+                "--size=1M",
+                "--rw={rw}".format(**test),
+               ]
+    if 'readonly-pre' in test:
+        fio_args.insert(0, "--readonly")
+    if 'readonly-post' in test:
+        fio_args.append("--readonly")
+
+    output = subprocess.run([fio] + fio_args, stdout=subprocess.PIPE,
+                            stderr=subprocess.PIPE)
+
+    return output
+
+
+def check_output(output, test):
+    expect_error = False
+    if 'readonly-pre' in test or 'readonly-post' in test:
+        if 'write' in test['rw'] or 'trim' in test['rw']:
+            expect_error = True
+
+#    print(output.stdout)
+#    print(output.stderr)
+
+    if output.returncode == 0:
+        if expect_error:
+            return False
+        else:
+            return True
+    else:
+        if expect_error:
+            return True
+        else:
+            return False
+
+
+if __name__ == '__main__':
+    args = parse_args()
+
+    tests = [
+                {
+                    "rw": "randread",
+                    "readonly-pre": 1,
+                },
+                {
+                    "rw": "randwrite",
+                    "readonly-pre": 1,
+                },
+                {
+                    "rw": "randtrim",
+                    "readonly-pre": 1,
+                },
+                {
+                    "rw": "randread",
+                    "readonly-post": 1,
+                },
+                {
+                    "rw": "randwrite",
+                    "readonly-post": 1,
+                },
+                {
+                    "rw": "randtrim",
+                    "readonly-post": 1,
+                },
+                {
+                    "rw": "randread",
+                },
+                {
+                    "rw": "randwrite",
+                },
+                {
+                    "rw": "randtrim",
+                },
+            ]
+
+    index = 1
+    passed = 0
+    failed = 0
+
+    if args.fio:
+        fio_path = args.fio
+    else:
+        fio_path = 'fio'
+
+    for test in tests:
+        output = run_fio(fio_path, test, index)
+        status = check_output(output, test)
+        print("Test {0} {1}".format(index, ("PASSED" if status else "FAILED")))
+        if status:
+            passed = passed + 1
+        else:
+            failed = failed + 1
+        index = index + 1
+
+    print("{0} tests passed, {1} failed".format(passed, failed))
+
+    sys.exit(failed)
diff --git a/t/readonly.sh b/t/readonly.sh
deleted file mode 100755
index d7094146..00000000
--- a/t/readonly.sh
+++ /dev/null
@@ -1,84 +0,0 @@
-#!/bin/bash
-#
-# Do some basic test of the --readonly parameter
-#
-# DUT should be a device that accepts read, write, and trim operations
-#
-# Example usage:
-#
-# DUT=/dev/fioa t/readonly.sh
-#
-TESTNUM=1
-
-#
-# The first parameter is the return code
-# The second parameter is 0        if the return code should be 0
-#                         positive if the return code should be positive
-#
-check () {
-	echo "********************"
-
-	if [ $2 -gt 0 ]; then
-		if [ $1 -eq 0 ]; then
-			echo "Test $TESTNUM failed"
-			echo "********************"
-			exit 1
-		else
-			echo "Test $TESTNUM passed"
-		fi
-	else
-		if [ $1 -gt 0 ]; then
-			echo "Test $TESTNUM failed"
-			echo "********************"
-			exit 1
-		else
-			echo "Test $TESTNUM passed"
-		fi
-	fi
-
-	echo "********************"
-	echo
-	TESTNUM=$((TESTNUM+1))
-}
-
-./fio --name=test --filename=$DUT --rw=randread  --readonly --time_based --runtime=1s &> /dev/null
-check $? 0
-./fio --name=test --filename=$DUT --rw=randwrite --readonly --time_based --runtime=1s &> /dev/null
-check $? 1
-./fio --name=test --filename=$DUT --rw=randtrim  --readonly --time_based --runtime=1s &> /dev/null
-check $? 1
-
-./fio --name=test --filename=$DUT --readonly --rw=randread  --time_based --runtime=1s &> /dev/null
-check $? 0
-./fio --name=test --filename=$DUT --readonly --rw=randwrite --time_based --runtime=1s &> /dev/null
-check $? 1
-./fio --name=test --filename=$DUT --readonly --rw=randtrim  --time_based --runtime=1s &> /dev/null
-check $? 1
-
-./fio --name=test --filename=$DUT --rw=randread  --time_based --runtime=1s &> /dev/null
-check $? 0
-./fio --name=test --filename=$DUT --rw=randwrite --time_based --runtime=1s &> /dev/null
-check $? 0
-./fio --name=test --filename=$DUT --rw=randtrim  --time_based --runtime=1s &> /dev/null
-check $? 0
-
-./fio t/jobs/readonly-r.fio --readonly &> /dev/null
-check $? 0
-./fio t/jobs/readonly-w.fio --readonly &> /dev/null
-check $? 1
-./fio t/jobs/readonly-t.fio --readonly &> /dev/null
-check $? 1
-
-./fio --readonly t/jobs/readonly-r.fio &> /dev/null
-check $? 0
-./fio --readonly t/jobs/readonly-w.fio &> /dev/null
-check $? 1
-./fio --readonly t/jobs/readonly-t.fio &> /dev/null
-check $? 1
-
-./fio t/jobs/readonly-r.fio &> /dev/null
-check $? 0
-./fio t/jobs/readonly-w.fio &> /dev/null
-check $? 0
-./fio t/jobs/readonly-t.fio &> /dev/null
-check $? 0
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
new file mode 100755
index 00000000..1b8ca0a2
--- /dev/null
+++ b/t/run-fio-tests.py
@@ -0,0 +1,676 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (c) 2019 Western Digital Corporation or its affiliates.
+#
+"""
+# run-fio-tests.py
+#
+# Automate running of fio tests
+#
+# USAGE
+# python3 run-fio-tests.py [-r fio-root] [-f fio-path] [-a artifact-root]
+#                           [--skip # # #...] [--run-only # # #...]
+#
+#
+# EXAMPLE
+# # git clone [fio-repository]
+# # cd fio
+# # make -j
+# # python3 t/run-fio-tests.py
+#
+#
+# REQUIREMENTS
+# - Python 3
+# - Linux (libaio ioengine, zbd tests, etc)
+# - The artifact directory must be on a file system that accepts 512-byte IO
+#   (t0002, t0003, t0004).
+# - The artifact directory needs to be on an SSD. Otherwise tests that carry
+#   out file-based IO will trigger a timeout (t0006).
+# - 4 CPUs (t0009)
+# - SciPy (steadystate_tests.py)
+# - libzbc (zbd tests)
+# - root privileges (zbd test)
+# - kernel 4.19 or later for zoned null block devices (zbd tests)
+# - CUnit support (unittests)
+#
+"""
+
+#
+# TODO  run multiple tests simultaneously
+# TODO  Add sgunmap tests (requires SAS SSD)
+# TODO  automatically detect dependencies and skip tests accordingly
+#
+
+import os
+import sys
+import json
+import time
+import logging
+import argparse
+import subprocess
+from pathlib import Path
+
+
+class FioTest(object):
+    """Base for all fio tests."""
+
+    def __init__(self, exe_path, parameters, success):
+        self.exe_path = exe_path
+        self.parameters = parameters
+        self.success = success
+        self.output = {}
+        self.artifact_root = None
+        self.testnum = None
+        self.test_dir = None
+        self.passed = True
+        self.failure_reason = ''
+
+    def setup(self, artifact_root, testnum):
+        self.artifact_root = artifact_root
+        self.testnum = testnum
+        self.test_dir = os.path.join(artifact_root, "{:04d}".format(testnum))
+        if not os.path.exists(self.test_dir):
+            os.mkdir(self.test_dir)
+
+        self.command_file = os.path.join(
+                self.test_dir,
+                "{0}.command".format(os.path.basename(self.exe_path)))
+        self.stdout_file = os.path.join(
+                self.test_dir,
+                "{0}.stdout".format(os.path.basename(self.exe_path)))
+        self.stderr_file = os.path.join(
+                self.test_dir,
+                "{0}.stderr".format(os.path.basename(self.exe_path)))
+        self.exticode_file = os.path.join(
+                self.test_dir,
+                "{0}.exitcode".format(os.path.basename(self.exe_path)))
+
+    def run(self):
+        raise NotImplementedError()
+
+    def check_result(self):
+        raise NotImplementedError()
+
+
+class FioExeTest(FioTest):
+    """Test consists of an executable binary or script"""
+
+    def __init__(self, exe_path, parameters, success):
+        """Construct a FioExeTest which is a FioTest consisting of an
+        executable binary or script.
+
+        exe_path:       location of executable binary or script
+        parameters:     list of parameters for executable
+        success:        Definition of test success
+        """
+
+        FioTest.__init__(self, exe_path, parameters, success)
+
+    def setup(self, artifact_root, testnum):
+        super(FioExeTest, self).setup(artifact_root, testnum)
+
+    def run(self):
+        if self.parameters:
+            command = [self.exe_path] + self.parameters
+        else:
+            command = [self.exe_path]
+        command_file = open(self.command_file, "w+")
+        command_file.write("%s\n" % command)
+        command_file.close()
+
+        stdout_file = open(self.stdout_file, "w+")
+        stderr_file = open(self.stderr_file, "w+")
+        exticode_file = open(self.exticode_file, "w+")
+        try:
+            # Avoid using subprocess.run() here because when a timeout occurs,
+            # fio will be stopped with SIGKILL. This does not give fio a
+            # chance to clean up and means that child processes may continue
+            # running and submitting IO.
+            proc = subprocess.Popen(command,
+                                    stdout=stdout_file,
+                                    stderr=stderr_file,
+                                    cwd=self.test_dir,
+                                    universal_newlines=True)
+            proc.communicate(timeout=self.success['timeout'])
+            exticode_file.write('{0}\n'.format(proc.returncode))
+            logging.debug("return code: %d" % proc.returncode)
+            self.output['proc'] = proc
+        except subprocess.TimeoutExpired:
+            proc.terminate()
+            proc.communicate()
+            assert proc.poll()
+            self.output['failure'] = 'timeout'
+        except Exception:
+            if not proc.poll():
+                proc.terminate()
+                proc.communicate()
+            self.output['failure'] = 'exception'
+            self.output['exc_info'] = sys.exc_info()
+        finally:
+            stdout_file.close()
+            stderr_file.close()
+            exticode_file.close()
+
+    def check_result(self):
+        if 'proc' not in self.output:
+            if self.output['failure'] == 'timeout':
+                self.failure_reason = "{0} timeout,".format(self.failure_reason)
+            else:
+                assert self.output['failure'] == 'exception'
+                self.failure_reason = '{0} exception: {1}, {2}'.format(
+                        self.failure_reason, self.output['exc_info'][0],
+                        self.output['exc_info'][1])
+
+            self.passed = False
+            return
+
+        if 'zero_return' in self.success:
+            if self.success['zero_return']:
+                if self.output['proc'].returncode != 0:
+                    self.passed = False
+                    self.failure_reason = "{0} non-zero return code,".format(self.failure_reason)
+            else:
+                if self.output['proc'].returncode == 0:
+                    self.failure_reason = "{0} zero return code,".format(self.failure_reason)
+                    self.passed = False
+
+        if 'stderr_empty' in self.success:
+            stderr_size = os.path.getsize(self.stderr_file)
+            if self.success['stderr_empty']:
+                if stderr_size != 0:
+                    self.failure_reason = "{0} stderr not empty,".format(self.failure_reason)
+                    self.passed = False
+            else:
+                if stderr_size == 0:
+                    self.failure_reason = "{0} stderr empty,".format(self.failure_reason)
+                    self.passed = False
+
+
+class FioJobTest(FioExeTest):
+    """Test consists of a fio job"""
+
+    def __init__(self, fio_path, fio_job, success, fio_pre_job=None,
+                 fio_pre_success=None, output_format="normal"):
+        """Construct a FioJobTest which is a FioExeTest consisting of a
+        single fio job file with an optional setup step.
+
+        fio_path:           location of fio executable
+        fio_job:            location of fio job file
+        success:            Definition of test success
+        fio_pre_job:        fio job for preconditioning
+        fio_pre_success:    Definition of test success for fio precon job
+        output_format:      normal (default), json, jsonplus, or terse
+        """
+
+        self.fio_job = fio_job
+        self.fio_pre_job = fio_pre_job
+        self.fio_pre_success = fio_pre_success if fio_pre_success else success
+        self.output_format = output_format
+        self.precon_failed = False
+        self.json_data = None
+        self.fio_output = "{0}.output".format(os.path.basename(self.fio_job))
+        self.fio_args = [
+            "--output-format={0}".format(self.output_format),
+            "--output={0}".format(self.fio_output),
+            self.fio_job,
+            ]
+        FioExeTest.__init__(self, fio_path, self.fio_args, success)
+
+    def setup(self, artifact_root, testnum):
+        super(FioJobTest, self).setup(artifact_root, testnum)
+
+        self.command_file = os.path.join(
+                self.test_dir,
+                "{0}.command".format(os.path.basename(self.fio_job)))
+        self.stdout_file = os.path.join(
+                self.test_dir,
+                "{0}.stdout".format(os.path.basename(self.fio_job)))
+        self.stderr_file = os.path.join(
+                self.test_dir,
+                "{0}.stderr".format(os.path.basename(self.fio_job)))
+        self.exticode_file = os.path.join(
+                self.test_dir,
+                "{0}.exitcode".format(os.path.basename(self.fio_job)))
+
+    def run_pre_job(self):
+        precon = FioJobTest(self.exe_path, self.fio_pre_job,
+                            self.fio_pre_success,
+                            output_format=self.output_format)
+        precon.setup(self.artifact_root, self.testnum)
+        precon.run()
+        precon.check_result()
+        self.precon_failed = not precon.passed
+        self.failure_reason = precon.failure_reason
+
+    def run(self):
+        if self.fio_pre_job:
+            self.run_pre_job()
+
+        if not self.precon_failed:
+            super(FioJobTest, self).run()
+        else:
+            logging.debug("precondition step failed")
+
+    def check_result(self):
+        if self.precon_failed:
+            self.passed = False
+            self.failure_reason = "{0} precondition step failed,".format(self.failure_reason)
+            return
+
+        super(FioJobTest, self).check_result()
+
+        if 'json' in self.output_format:
+            output_file = open(os.path.join(self.test_dir, self.fio_output), "r")
+            file_data = output_file.read()
+            output_file.close()
+            try:
+                self.json_data = json.loads(file_data)
+            except json.JSONDecodeError:
+                self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
+                self.passed = False
+
+
+class FioJobTest_t0005(FioJobTest):
+    """Test consists of fio test job t0005
+    Confirm that read['io_kbytes'] == write['io_kbytes'] == 102400"""
+
+    def check_result(self):
+        super(FioJobTest_t0005, self).check_result()
+
+        if not self.passed:
+            return
+
+        if self.json_data['jobs'][0]['read']['io_kbytes'] != 102400:
+            self.failure_reason = "{0} bytes read mismatch,".format(self.failure_reason)
+            self.passed = False
+        if self.json_data['jobs'][0]['write']['io_kbytes'] != 102400:
+            self.failure_reason = "{0} bytes written mismatch,".format(self.failure_reason)
+            self.passed = False
+
+
+class FioJobTest_t0006(FioJobTest):
+    """Test consists of fio test job t0006
+    Confirm that read['io_kbytes'] ~ 2*write['io_kbytes']"""
+
+    def check_result(self):
+        super(FioJobTest_t0006, self).check_result()
+
+        if not self.passed:
+            return
+
+        ratio = self.json_data['jobs'][0]['read']['io_kbytes'] \
+            / self.json_data['jobs'][0]['write']['io_kbytes']
+        logging.debug("ratio: %f" % ratio)
+        if ratio < 1.99 or ratio > 2.01:
+            self.failure_reason = "{0} read/write ratio mismatch,".format(self.failure_reason)
+            self.passed = False
+
+
+class FioJobTest_t0007(FioJobTest):
+    """Test consists of fio test job t0007
+    Confirm that read['io_kbytes'] = 87040"""
+
+    def check_result(self):
+        super(FioJobTest_t0007, self).check_result()
+
+        if not self.passed:
+            return
+
+        if self.json_data['jobs'][0]['read']['io_kbytes'] != 87040:
+            self.failure_reason = "{0} bytes read mismatch,".format(self.failure_reason)
+            self.passed = False
+
+
+class FioJobTest_t0008(FioJobTest):
+    """Test consists of fio test job t0008
+    Confirm that read['io_kbytes'] = 32768 and that
+                write['io_kbytes'] ~ 16568
+
+    I did runs with fio-ae2fafc8 and saw write['io_kbytes'] values of
+    16585, 16588. With two runs of fio-3.16 I obtained 16568"""
+
+    def check_result(self):
+        super(FioJobTest_t0008, self).check_result()
+
+        if not self.passed:
+            return
+
+        ratio = self.json_data['jobs'][0]['write']['io_kbytes'] / 16568
+        logging.debug("ratio: %f" % ratio)
+
+        if ratio < 0.99 or ratio > 1.01:
+            self.failure_reason = "{0} bytes written mismatch,".format(self.failure_reason)
+            self.passed = False
+        if self.json_data['jobs'][0]['read']['io_kbytes'] != 32768:
+            self.failure_reason = "{0} bytes read mismatch,".format(self.failure_reason)
+            self.passed = False
+
+
+class FioJobTest_t0009(FioJobTest):
+    """Test consists of fio test job t0009
+    Confirm that runtime >= 60s"""
+
+    def check_result(self):
+        super(FioJobTest_t0009, self).check_result()
+
+        if not self.passed:
+            return
+
+        logging.debug('elapsed: %d' % self.json_data['jobs'][0]['elapsed'])
+
+        if self.json_data['jobs'][0]['elapsed'] < 60:
+            self.failure_reason = "{0} elapsed time mismatch,".format(self.failure_reason)
+            self.passed = False
+
+
+class FioJobTest_t0011(FioJobTest):
+    """Test consists of fio test job t0009
+    Confirm that job0 iops == 1000
+    and that job1_iops / job0_iops ~ 8
+    With two runs of fio-3.16 I observed a ratio of 8.3"""
+
+    def check_result(self):
+        super(FioJobTest_t0011, self).check_result()
+
+        if not self.passed:
+            return
+
+        iops1 = self.json_data['jobs'][0]['read']['iops']
+        iops2 = self.json_data['jobs'][1]['read']['iops']
+        ratio = iops2 / iops1
+        logging.debug("ratio: %f" % ratio)
+
+        if iops1 < 999 or iops1 > 1001:
+            self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
+            self.passed = False
+
+        if ratio < 7 or ratio > 9:
+            self.failure_reason = "{0} iops ratio mismatch,".format(self.failure_reason)
+            self.passed = False
+
+
+SUCCESS_DEFAULT = {
+        'zero_return': True,
+        'stderr_empty': True,
+        'timeout': 300,
+        }
+SUCCESS_NONZERO = {
+        'zero_return': False,
+        'stderr_empty': False,
+        'timeout': 300,
+        }
+SUCCESS_STDERR = {
+        'zero_return': True,
+        'stderr_empty': False,
+        'timeout': 300,
+        }
+TEST_LIST = [
+        {
+            'test_id':          1,
+            'test_class':       FioJobTest,
+            'job':              't0001-52c58027.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+        },
+        {
+            'test_id':          2,
+            'test_class':       FioJobTest,
+            'job':              't0002-13af05ae-post.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          't0002-13af05ae-pre.fio',
+            'pre_success':      None,
+        },
+        {
+            'test_id':          3,
+            'test_class':       FioJobTest,
+            'job':              't0003-0ae2c6e1-post.fio',
+            'success':          SUCCESS_NONZERO,
+            'pre_job':          't0003-0ae2c6e1-pre.fio',
+            'pre_success':      SUCCESS_DEFAULT,
+        },
+        {
+            'test_id':          4,
+            'test_class':       FioJobTest,
+            'job':              't0004-8a99fdf6.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+        },
+        {
+            'test_id':          5,
+            'test_class':       FioJobTest_t0005,
+            'job':              't0005-f7078f7b.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+            'output_format':    'json',
+        },
+        {
+            'test_id':          6,
+            'test_class':       FioJobTest_t0006,
+            'job':              't0006-82af2a7c.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+            'output_format':    'json',
+        },
+        {
+            'test_id':          7,
+            'test_class':       FioJobTest_t0007,
+            'job':              't0007-37cf9e3c.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+            'output_format':    'json',
+        },
+        {
+            'test_id':          8,
+            'test_class':       FioJobTest_t0008,
+            'job':              't0008-ae2fafc8.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+            'output_format':    'json',
+        },
+        {
+            'test_id':          9,
+            'test_class':       FioJobTest_t0009,
+            'job':              't0009-f8b0bd10.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+            'output_format':    'json',
+        },
+        {
+            'test_id':          10,
+            'test_class':       FioJobTest,
+            'job':              't0010-b7aae4ba.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+        },
+        {
+            'test_id':          11,
+            'test_class':       FioJobTest_t0011,
+            'job':              't0011-5d2788d5.fio',
+            'success':          SUCCESS_DEFAULT,
+            'pre_job':          None,
+            'pre_success':      None,
+            'output_format':    'json',
+        },
+        {
+            'test_id':          1000,
+            'test_class':       FioExeTest,
+            'exe':              't/axmap',
+            'parameters':       None,
+            'success':          SUCCESS_DEFAULT,
+        },
+        {
+            'test_id':          1001,
+            'test_class':       FioExeTest,
+            'exe':              't/ieee754',
+            'parameters':       None,
+            'success':          SUCCESS_DEFAULT,
+        },
+        {
+            'test_id':          1002,
+            'test_class':       FioExeTest,
+            'exe':              't/lfsr-test',
+            'parameters':       ['0xFFFFFF', '0', '0', 'verify'],
+            'success':          SUCCESS_STDERR,
+        },
+        {
+            'test_id':          1003,
+            'test_class':       FioExeTest,
+            'exe':              't/readonly.py',
+            'parameters':       ['-f', '{fio_path}'],
+            'success':          SUCCESS_DEFAULT,
+        },
+        {
+            'test_id':          1004,
+            'test_class':       FioExeTest,
+            'exe':              't/steadystate_tests.py',
+            'parameters':       ['{fio_path}'],
+            'success':          SUCCESS_DEFAULT,
+        },
+        {
+            'test_id':          1005,
+            'test_class':       FioExeTest,
+            'exe':              't/stest',
+            'parameters':       None,
+            'success':          SUCCESS_STDERR,
+        },
+        {
+            'test_id':          1006,
+            'test_class':       FioExeTest,
+            'exe':              't/strided.py',
+            'parameters':       ['{fio_path}'],
+            'success':          SUCCESS_DEFAULT,
+        },
+        {
+            'test_id':          1007,
+            'test_class':       FioExeTest,
+            'exe':              't/zbd/run-tests-against-regular-nullb',
+            'parameters':       None,
+            'success':          SUCCESS_DEFAULT,
+        },
+        {
+            'test_id':          1008,
+            'test_class':       FioExeTest,
+            'exe':              't/zbd/run-tests-against-zoned-nullb',
+            'parameters':       None,
+            'success':          SUCCESS_DEFAULT,
+        },
+        {
+            'test_id':          1009,
+            'test_class':       FioExeTest,
+            'exe':              'unittests/unittest',
+            'parameters':       None,
+            'success':          SUCCESS_DEFAULT,
+        },
+]
+
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-r', '--fio-root',
+                        help='fio root path')
+    parser.add_argument('-f', '--fio',
+                        help='path to fio executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root',
+                        help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    logging.basicConfig(level=logging.INFO)
+
+    args = parse_args()
+    if args.fio_root:
+        fio_root = args.fio_root
+    else:
+        fio_root = Path(__file__).absolute().parent.parent
+    logging.debug("fio_root: %s" % fio_root)
+
+    if args.fio:
+        fio_path = args.fio
+    else:
+        fio_path = os.path.join(fio_root, "fio")
+    logging.debug("fio_path: %s" % fio_path)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        "fio-test-{0}".format(time.strftime("%Y%m%d-%H%M%S"))
+    os.mkdir(artifact_root)
+    print("Artifact directory is %s" % artifact_root)
+
+    passed = 0
+    failed = 0
+    skipped = 0
+
+    for config in TEST_LIST:
+        if (args.skip and config['test_id'] in args.skip) or \
+           (args.run_only and config['test_id'] not in args.run_only):
+            skipped = skipped + 1
+            print("Test {0} SKIPPED".format(config['test_id']))
+            continue
+
+        if issubclass(config['test_class'], FioJobTest):
+            if config['pre_job']:
+                fio_pre_job = os.path.join(fio_root, 't', 'jobs',
+                                           config['pre_job'])
+            else:
+                fio_pre_job = None
+            if config['pre_success']:
+                fio_pre_success = config['pre_success']
+            else:
+                fio_pre_success = None
+            if 'output_format' in config:
+                output_format = config['output_format']
+            else:
+                output_format = 'normal'
+            test = config['test_class'](
+                fio_path,
+                os.path.join(fio_root, 't', 'jobs', config['job']),
+                config['success'],
+                fio_pre_job=fio_pre_job,
+                fio_pre_success=fio_pre_success,
+                output_format=output_format)
+        elif issubclass(config['test_class'], FioExeTest):
+            exe_path = os.path.join(fio_root, config['exe'])
+            if config['parameters']:
+                parameters = [p.format(fio_path=fio_path) for p in config['parameters']]
+            else:
+                parameters = None
+            test = config['test_class'](exe_path, parameters,
+                                        config['success'])
+        else:
+            print("Test {0} FAILED: unable to process test config".format(config['test_id']))
+            failed = failed + 1
+            continue
+
+        test.setup(artifact_root, config['test_id'])
+        test.run()
+        test.check_result()
+        if test.passed:
+            result = "PASSED"
+            passed = passed + 1
+        else:
+            result = "FAILED: {0}".format(test.failure_reason)
+            failed = failed + 1
+        print("Test {0} {1}".format(config['test_id'], result))
+
+    print("{0} test(s) passed, {1} failed, {2} skipped".format(passed, failed, skipped))
+
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/sgunmap-test.py b/t/sgunmap-test.py
index d2caa5fd..f8f10ab3 100755
--- a/t/sgunmap-test.py
+++ b/t/sgunmap-test.py
@@ -45,7 +45,6 @@ import json
 import argparse
 import traceback
 import subprocess
-from six.moves import range
 
 
 def parse_args():
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index 50254dcc..53b0f35e 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -1,5 +1,5 @@
-#!/usr/bin/python2.7
-# Note: this script is python2 and python 3 compatible.
+#!/usr/bin/env python
+# Note: this script is python2 and python3 compatible.
 #
 # steadystate_tests.py
 #
@@ -24,12 +24,10 @@ from __future__ import print_function
 import os
 import sys
 import json
-import uuid
 import pprint
 import argparse
 import subprocess
 from scipy import stats
-from six.moves import range
 
 def parse_args():
     parser = argparse.ArgumentParser()
@@ -53,7 +51,7 @@ def check(data, iops, slope, pct, limit, dur, criterion):
         m, intercept, r_value, p_value, std_err = stats.linregress(x,data)
         m = abs(m)
         if pct:
-            target = m / mean * 100
+            target = (m / mean * 100) if mean != 0 else 0
             criterion = criterion[:-1]
         else:
             target = m
@@ -68,7 +66,11 @@ def check(data, iops, slope, pct, limit, dur, criterion):
             target = maxdev
 
     criterion = float(criterion)
-    return (abs(target - criterion) / criterion < 0.005), target < limit, mean, target
+    if criterion == 0.0:
+        objsame = False
+    else:
+        objsame = abs(target - criterion) / criterion < 0.005
+    return (objsame, target < limit, mean, target)
 
 
 if __name__ == '__main__':
@@ -76,6 +78,9 @@ if __name__ == '__main__':
 
     pp = pprint.PrettyPrinter(indent=4)
 
+    passed = 0
+    failed = 0
+
 #
 # test option parsing
 #
@@ -96,8 +101,10 @@ if __name__ == '__main__':
         output = subprocess.check_output([args.fio] + test['args'])
         if test['output'] in output.decode():
             print("PASSED '{0}' found with arguments {1}".format(test['output'], test['args']))
+            passed = passed + 1
         else:
             print("FAILED '{0}' NOT found with arguments {1}".format(test['output'], test['args']))
+            failed = failed + 1
 
 #
 # test some read workloads
@@ -119,7 +126,7 @@ if __name__ == '__main__':
     if args.read == None:
         if os.name == 'posix':
             args.read = '/dev/zero'
-            extra = [ "--size=134217728" ]  # 128 MiB
+            extra = [ "--size=128M" ]
         else:
             print("ERROR: file for read testing must be specified on non-posix systems")
             sys.exit(1)
@@ -129,7 +136,7 @@ if __name__ == '__main__':
     jobnum = 0
     for job in reads:
 
-        tf = uuid.uuid4().hex
+        tf = "steadystate_job{0}.json".format(jobnum)
         parameters = [ "--name=job{0}".format(jobnum) ]
         parameters.extend(extra)
         parameters.extend([ "--thread",
@@ -160,10 +167,10 @@ if __name__ == '__main__':
         output = subprocess.call([args.fio] + parameters)
         with open(tf, 'r') as source:
             jsondata = json.loads(source.read())
-        os.remove(tf)
+            source.close()
 
         for jsonjob in jsondata['jobs']:
-            line = "job {0}".format(jsonjob['job options']['name'])
+            line = "{0}".format(jsonjob['job options']['name'])
             if job['s']:
                 if jsonjob['steadystate']['attained'] == 1:
                     # check runtime >= ss_dur + ss_ramp, check criterion, check criterion < limit
@@ -171,6 +178,7 @@ if __name__ == '__main__':
                     actual = jsonjob['read']['runtime']
                     if mintime > actual:
                         line = 'FAILED ' + line + ' ss attained, runtime {0} < ss_dur {1} + ss_ramp {2}'.format(actual, job['ss_dur'], job['ss_ramp'])
+                        failed = failed + 1
                     else:
                         line = line + ' ss attained, runtime {0} > ss_dur {1} + ss_ramp {2},'.format(actual, job['ss_dur'], job['ss_ramp'])
                         objsame, met, mean, target = check(data=jsonjob['steadystate']['data'],
@@ -182,11 +190,14 @@ if __name__ == '__main__':
                             criterion=jsonjob['steadystate']['criterion'])
                         if not objsame:
                             line = 'FAILED ' + line + ' fio criterion {0} != calculated criterion {1} '.format(jsonjob['steadystate']['criterion'], target)
+                            failed = failed + 1
                         else:
                             if met:
                                 line = 'PASSED ' + line + ' target {0} < limit {1}'.format(target, job['ss_limit'])
+                                passed = passed + 1
                             else:
                                 line = 'FAILED ' + line + ' target {0} < limit {1} but fio reports ss not attained '.format(target, job['ss_limit'])
+                                failed = failed + 1
                 else:
                     # check runtime, confirm criterion calculation, and confirm that criterion was not met
                     expected = job['timeout'] * 1000
@@ -205,22 +216,31 @@ if __name__ == '__main__':
                         if not objsame:
                             if actual > (job['ss_dur'] + job['ss_ramp'])*1000:
                                 line = 'FAILED ' + line + ' fio criterion {0} != calculated criterion {1} '.format(jsonjob['steadystate']['criterion'], target)
+                                failed = failed + 1
                             else:
                                 line = 'PASSED ' + line + ' fio criterion {0} == 0.0 since ss_dur + ss_ramp has not elapsed '.format(jsonjob['steadystate']['criterion'])
+                                passed = passed + 1
                         else:
                             if met:
                                 line = 'FAILED ' + line + ' target {0} < threshold {1} but fio reports ss not attained '.format(target, job['ss_limit'])
+                                failed = failed + 1
                             else:
                                 line = 'PASSED ' + line + ' criterion {0} > threshold {1}'.format(target, job['ss_limit'])
+                                passed = passed + 1
             else:
                 expected = job['timeout'] * 1000
                 actual = jsonjob['read']['runtime']
                 if abs(expected - actual) < 10:
                     result = 'PASSED '
+                    passed = passed + 1
                 else:
                     result = 'FAILED '
+                    failed = failed + 1
                 line = result + line + ' no ss, expected runtime {0} ~= actual runtime {1}'.format(expected, actual)
             print(line)
             if 'steadystate' in jsonjob:
                 pp.pprint(jsonjob['steadystate'])
         jobnum += 1
+
+    print("{0} test(s) PASSED, {1} test(s) FAILED".format(passed,failed))
+    sys.exit(failed)
diff --git a/t/stest.c b/t/stest.c
index 515ae5a5..c6bf2d1e 100644
--- a/t/stest.c
+++ b/t/stest.c
@@ -25,7 +25,7 @@ static FLIST_HEAD(list);
 
 static int do_rand_allocs(void)
 {
-	unsigned int size, nr, rounds = 0;
+	unsigned int size, nr, rounds = 0, ret = 0;
 	unsigned long total;
 	struct elem *e;
 	bool error;
@@ -41,6 +41,7 @@ static int do_rand_allocs(void)
 			e = smalloc(size);
 			if (!e) {
 				printf("fail at %lu, size %u\n", total, size);
+				ret++;
 				break;
 			}
 			e->magic1 = MAGIC1;
@@ -65,6 +66,7 @@ static int do_rand_allocs(void)
 				e = smalloc(LARGESMALLOC);
 				if (!e) {
 					error = true;
+					ret++;
 					printf("failure allocating %u bytes at %lu allocated during sfree phase\n",
 						LARGESMALLOC, total);
 				}
@@ -74,18 +76,21 @@ static int do_rand_allocs(void)
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 int main(int argc, char *argv[])
 {
+	int ret;
+
 	arch_init(argv);
 	sinit();
 	debug_init();
 
-	do_rand_allocs();
-	smalloc_debug(0);	/* free and total blocks should match */
+	ret = do_rand_allocs();
+	smalloc_debug(0);	/* TODO: check that free and total blocks
+				** match */
 
 	scleanup();
-	return 0;
+	return ret;
 }
diff --git a/t/strided.py b/t/strided.py
index 47ce5523..c159dc0b 100755
--- a/t/strided.py
+++ b/t/strided.py
@@ -202,20 +202,20 @@ if __name__ == '__main__':
                 # lfsr
                 {
                     "random_generator": "lfsr",
-                    "zonerange": 4096,
-                    "zonesize": 4096,
+                    "zonerange": 4096*1024,
+                    "zonesize": 4096*1024,
                     "bs": 4096,
-                    "offset": 8*4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
+                    "offset": 8*4096*1024,
+                    "size": 16*4096*1024,
+                    "io_size": 16*4096*1024,
                 },
                 {
                     "random_generator": "lfsr",
-                    "zonerange": 4096,
-                    "zonesize": 4096,
+                    "zonerange": 4096*1024,
+                    "zonesize": 4096*1024,
                     "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
+                    "size": 16*4096*1024,
+                    "io_size": 16*4096*1024,
                 },
                 {
                     "random_generator": "lfsr",
@@ -227,11 +227,11 @@ if __name__ == '__main__':
                 },
                 {
                     "random_generator": "lfsr",
-                    "zonerange": 4096,
-                    "zonesize": 4*4096,
+                    "zonerange": 4096*1024,
+                    "zonesize": 4*4096*1024,
                     "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
+                    "size": 16*4096*1024,
+                    "io_size": 16*4096*1024,
                 },
                 {
                     "random_generator": "lfsr",
@@ -243,11 +243,11 @@ if __name__ == '__main__':
                 },
                 {
                     "random_generator": "lfsr",
-                    "zonerange": 8192,
-                    "zonesize": 4096,
+                    "zonerange": 8192*1024,
+                    "zonesize": 4096*1024,
                     "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
+                    "size": 16*4096*1024,
+                    "io_size": 16*4096*1024,
                 },
                 {
                     "random_generator": "lfsr",
@@ -313,7 +313,7 @@ if __name__ == '__main__':
                     "zonesize": 8*1024*1024,
                     "bs": 4096,
                     "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
+                    "io_size": 256*1024*1024,
                 },
 
             ]

