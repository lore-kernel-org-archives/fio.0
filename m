Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72A4C7EE24
	for <fio@archiver.kernel.org>; Fri,  2 Jun 2023 12:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbjFBMAV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 2 Jun 2023 08:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbjFBMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Jun 2023 08:00:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DC51AD
        for <fio@vger.kernel.org>; Fri,  2 Jun 2023 05:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=9e+e/LxnFNteHFRsLNO1x2WpP0LWwn3xjy8kvtC+6qQ=; b=bX+j400VOewtZaisrV0bCH3Eiw
        pgMrUpXWyOwjAUYhSsePJu+qyte7p2f5el22Yl/br6IcHjiU4gmFna/AZL5T5P9ft50HiuQc1t5KN
        2TTRO9ofNKKRIOFDU0B7c0OBNTB0X/CjhOFzkRZO8Nwua76GCMez8RLSLdbF81//mwZS+MXoIlq1k
        5UrinC6QKUgNg+iBucOnixCWpsz0wMFKPV/V55SebkW465fIqzvI7eFoLjUiy292bTegrvoeu0PW8
        nLSiCUP3ukLR/S0J3i4rdu6hgy3yoHgmNcpjEK7aFkXicYzYMfQWXDVH1qFBH89OJdlo4VTXGp3p8
        aAXtZYYg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q53Rz-009BMb-9b
        for fio@vger.kernel.org; Fri, 02 Jun 2023 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id EB17F1BC0161; Fri,  2 Jun 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230602120001.EB17F1BC0161@kernel.dk>
Date:   Fri,  2 Jun 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 4820d46cef75f806d8c95afaa77f86ded4e3603e:

  ci: disable tls for msys2 builds (2023-05-26 20:09:53 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1b4ba547cf45377fffc7a1e60728369997cc7a9b:

  t/run-fio-tests: address issues identified by pylint (2023-06-01 14:12:41 -0400)

----------------------------------------------------------------
Vincent Fu (3):
      t/nvmept.py: test script for io_uring_cmd NVMe pass through
      t/run-fio-tests: integrate t/nvmept.py
      t/run-fio-tests: address issues identified by pylint

 t/nvmept.py        | 414 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py | 191 +++++++++++++-----------
 2 files changed, 521 insertions(+), 84 deletions(-)
 create mode 100755 t/nvmept.py

---

Diff of recent changes:

diff --git a/t/nvmept.py b/t/nvmept.py
new file mode 100755
index 00000000..a25192f2
--- /dev/null
+++ b/t/nvmept.py
@@ -0,0 +1,414 @@
+#!/usr/bin/env python3
+"""
+# nvmept.py
+#
+# Test fio's io_uring_cmd ioengine with NVMe pass-through commands.
+#
+# USAGE
+# see python3 nvmept.py --help
+#
+# EXAMPLES
+# python3 t/nvmept.py --dut /dev/ng0n1
+# python3 t/nvmept.py --dut /dev/ng1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+import os
+import sys
+import json
+import time
+import locale
+import argparse
+import subprocess
+from pathlib import Path
+
+class FioTest():
+    """fio test."""
+
+    def __init__(self, artifact_root, test_opts, debug):
+        """
+        artifact_root   root directory for artifacts (subdirectory will be created under here)
+        test            test specification
+        """
+        self.artifact_root = artifact_root
+        self.test_opts = test_opts
+        self.debug = debug
+        self.filename_stub = None
+        self.filenames = {}
+        self.json_data = None
+
+        self.test_dir = os.path.abspath(os.path.join(self.artifact_root,
+                                     f"{self.test_opts['test_id']:03d}"))
+        if not os.path.exists(self.test_dir):
+            os.mkdir(self.test_dir)
+
+        self.filename_stub = f"pt{self.test_opts['test_id']:03d}"
+        self.filenames['command'] = os.path.join(self.test_dir, f"{self.filename_stub}.command")
+        self.filenames['stdout'] = os.path.join(self.test_dir, f"{self.filename_stub}.stdout")
+        self.filenames['stderr'] = os.path.join(self.test_dir, f"{self.filename_stub}.stderr")
+        self.filenames['exitcode'] = os.path.join(self.test_dir, f"{self.filename_stub}.exitcode")
+        self.filenames['output'] = os.path.join(self.test_dir, f"{self.filename_stub}.output")
+
+    def run_fio(self, fio_path):
+        """Run a test."""
+
+        fio_args = [
+            "--name=nvmept",
+            "--ioengine=io_uring_cmd",
+            "--cmd_type=nvme",
+            "--iodepth=8",
+            "--iodepth_batch=4",
+            "--iodepth_batch_complete=4",
+            f"--filename={self.test_opts['filename']}",
+            f"--rw={self.test_opts['rw']}",
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.test_opts['output-format']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size']:
+            if opt in self.test_opts:
+                option = f"--{opt}={self.test_opts[opt]}"
+                fio_args.append(option)
+
+        command = [fio_path] + fio_args
+        with open(self.filenames['command'], "w+",
+                  encoding=locale.getpreferredencoding()) as command_file:
+            command_file.write(" ".join(command))
+
+        passed = True
+
+        try:
+            with open(self.filenames['stdout'], "w+",
+                      encoding=locale.getpreferredencoding()) as stdout_file, \
+                open(self.filenames['stderr'], "w+",
+                     encoding=locale.getpreferredencoding()) as stderr_file, \
+                open(self.filenames['exitcode'], "w+",
+                     encoding=locale.getpreferredencoding()) as exitcode_file:
+                proc = None
+                # Avoid using subprocess.run() here because when a timeout occurs,
+                # fio will be stopped with SIGKILL. This does not give fio a
+                # chance to clean up and means that child processes may continue
+                # running and submitting IO.
+                proc = subprocess.Popen(command,
+                                        stdout=stdout_file,
+                                        stderr=stderr_file,
+                                        cwd=self.test_dir,
+                                        universal_newlines=True)
+                proc.communicate(timeout=300)
+                exitcode_file.write(f'{proc.returncode}\n')
+                passed &= (proc.returncode == 0)
+        except subprocess.TimeoutExpired:
+            proc.terminate()
+            proc.communicate()
+            assert proc.poll()
+            print("Timeout expired")
+            passed = False
+        except Exception:
+            if proc:
+                if not proc.poll():
+                    proc.terminate()
+                    proc.communicate()
+            print(f"Exception: {sys.exc_info()}")
+            passed = False
+
+        if passed:
+            if 'output-format' in self.test_opts and 'json' in \
+                    self.test_opts['output-format']:
+                if not self.get_json():
+                    print('Unable to decode JSON data')
+                    passed = False
+
+        return passed
+
+    def get_json(self):
+        """Convert fio JSON output into a python JSON object"""
+
+        filename = self.filenames['output']
+        with open(filename, 'r', encoding=locale.getpreferredencoding()) as file:
+            file_data = file.read()
+
+        #
+        # Sometimes fio informational messages are included at the top of the
+        # JSON output, especially under Windows. Try to decode output as JSON
+        # data, lopping off up to the first four lines
+        #
+        lines = file_data.splitlines()
+        for i in range(5):
+            file_data = '\n'.join(lines[i:])
+            try:
+                self.json_data = json.loads(file_data)
+            except json.JSONDecodeError:
+                continue
+            else:
+                return True
+
+        return False
+
+    @staticmethod
+    def check_empty(job):
+        """
+        Make sure JSON data is empty.
+
+        Some data structures should be empty. This function makes sure that they are.
+
+        job         JSON object that we need to check for emptiness
+        """
+
+        return job['total_ios'] == 0 and \
+                job['slat_ns']['N'] == 0 and \
+                job['clat_ns']['N'] == 0 and \
+                job['lat_ns']['N'] == 0
+
+    def check_all_ddirs(self, ddir_nonzero, job):
+        """
+        Iterate over the data directions and check whether each is
+        appropriately empty or not.
+        """
+
+        retval = True
+        ddirlist = ['read', 'write', 'trim']
+
+        for ddir in ddirlist:
+            if ddir in ddir_nonzero:
+                if self.check_empty(job[ddir]):
+                    print(f"Unexpected zero {ddir} data found in output")
+                    retval = False
+            else:
+                if not self.check_empty(job[ddir]):
+                    print(f"Unexpected {ddir} data found in output")
+                    retval = False
+
+        return retval
+
+    def check(self):
+        """Check test output."""
+
+        raise NotImplementedError()
+
+
+class PTTest(FioTest):
+    """
+    NVMe pass-through test class. Check to make sure output for selected data
+    direction(s) is non-zero and that zero data appears for other directions.
+    """
+
+    def check(self):
+        if 'rw' not in self.test_opts:
+            return True
+
+        job = self.json_data['jobs'][0]
+        retval = True
+
+        if self.test_opts['rw'] in ['read', 'randread']:
+            retval = self.check_all_ddirs(['read'], job)
+        elif self.test_opts['rw'] in ['write', 'randwrite']:
+            if 'verify' not in self.test_opts:
+                retval = self.check_all_ddirs(['write'], job)
+            else:
+                retval = self.check_all_ddirs(['read', 'write'], job)
+        elif self.test_opts['rw'] in ['trim', 'randtrim']:
+            retval = self.check_all_ddirs(['trim'], job)
+        elif self.test_opts['rw'] in ['readwrite', 'randrw']:
+            retval = self.check_all_ddirs(['read', 'write'], job)
+        elif self.test_opts['rw'] in ['trimwrite', 'randtrimwrite']:
+            retval = self.check_all_ddirs(['trim', 'write'], job)
+        else:
+            print(f"Unhandled rw value {self.test_opts['rw']}")
+            retval = False
+
+        return retval
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-d', '--debug', help='enable debug output', action='store_true')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('--dut', help='target NVMe character device to test '
+                        '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    """Run tests using fio's io_uring_cmd ioengine to send NVMe pass through commands."""
+
+    args = parse_args()
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"nvmept-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio = str(Path(args.fio).absolute())
+    else:
+        fio = 'fio'
+    print(f"fio path is {fio}")
+
+    test_list = [
+        {
+            "test_id": 1,
+            "rw": 'read',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 2,
+            "rw": 'randread',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 3,
+            "rw": 'write',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 4,
+            "rw": 'randwrite',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 5,
+            "rw": 'trim',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 6,
+            "rw": 'randtrim',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 7,
+            "rw": 'write',
+            "io_size": 1024*1024,
+            "verify": "crc32c",
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 8,
+            "rw": 'randwrite',
+            "io_size": 1024*1024,
+            "verify": "crc32c",
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 9,
+            "rw": 'readwrite',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 10,
+            "rw": 'randrw',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 11,
+            "rw": 'trimwrite',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 12,
+            "rw": 'randtrimwrite',
+            "timebased": 1,
+            "runtime": 3,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 13,
+            "rw": 'randread',
+            "timebased": 1,
+            "runtime": 3,
+            "fixedbufs": 1,
+            "nonvectored": 1,
+            "force_async": 1,
+            "registerfiles": 1,
+            "sqthread_poll": 1,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+        {
+            "test_id": 14,
+            "rw": 'randwrite',
+            "timebased": 1,
+            "runtime": 3,
+            "fixedbufs": 1,
+            "nonvectored": 1,
+            "force_async": 1,
+            "registerfiles": 1,
+            "sqthread_poll": 1,
+            "output-format": "json",
+            "test_obj": PTTest,
+        },
+    ]
+
+    passed = 0
+    failed = 0
+    skipped = 0
+
+    for test in test_list:
+        if (args.skip and test['test_id'] in args.skip) or \
+           (args.run_only and test['test_id'] not in args.run_only):
+            skipped = skipped + 1
+            outcome = 'SKIPPED (User request)'
+        else:
+            test['filename'] = args.dut
+            test_obj = test['test_obj'](artifact_root, test, args.debug)
+            status = test_obj.run_fio(fio)
+            if status:
+                status = test_obj.check()
+            if status:
+                passed = passed + 1
+                outcome = 'PASSED'
+            else:
+                failed = failed + 1
+                outcome = 'FAILED'
+
+        print(f"**********Test {test['test_id']} {outcome}**********")
+
+    print(f"{passed} tests passed, {failed} failed, {skipped} skipped")
+
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 71e3e5a6..c91deed4 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -79,22 +79,22 @@ class FioTest():
 
         self.artifact_root = artifact_root
         self.testnum = testnum
-        self.test_dir = os.path.join(artifact_root, "{:04d}".format(testnum))
+        self.test_dir = os.path.join(artifact_root, f"{testnum:04d}")
         if not os.path.exists(self.test_dir):
             os.mkdir(self.test_dir)
 
         self.command_file = os.path.join(
             self.test_dir,
-            "{0}.command".format(os.path.basename(self.exe_path)))
+            f"{os.path.basename(self.exe_path)}.command")
         self.stdout_file = os.path.join(
             self.test_dir,
-            "{0}.stdout".format(os.path.basename(self.exe_path)))
+            f"{os.path.basename(self.exe_path)}.stdout")
         self.stderr_file = os.path.join(
             self.test_dir,
-            "{0}.stderr".format(os.path.basename(self.exe_path)))
+            f"{os.path.basename(self.exe_path)}.stderr")
         self.exitcode_file = os.path.join(
             self.test_dir,
-            "{0}.exitcode".format(os.path.basename(self.exe_path)))
+            f"{os.path.basename(self.exe_path)}.exitcode")
 
     def run(self):
         """Run the test."""
@@ -126,7 +126,7 @@ class FioExeTest(FioTest):
 
         command = [self.exe_path] + self.parameters
         command_file = open(self.command_file, "w+")
-        command_file.write("%s\n" % command)
+        command_file.write(f"{command}\n")
         command_file.close()
 
         stdout_file = open(self.stdout_file, "w+")
@@ -144,7 +144,7 @@ class FioExeTest(FioTest):
                                     cwd=self.test_dir,
                                     universal_newlines=True)
             proc.communicate(timeout=self.success['timeout'])
-            exitcode_file.write('{0}\n'.format(proc.returncode))
+            exitcode_file.write(f'{proc.returncode}\n')
             logging.debug("Test %d: return code: %d", self.testnum, proc.returncode)
             self.output['proc'] = proc
         except subprocess.TimeoutExpired:
@@ -169,7 +169,7 @@ class FioExeTest(FioTest):
 
         if 'proc' not in self.output:
             if self.output['failure'] == 'timeout':
-                self.failure_reason = "{0} timeout,".format(self.failure_reason)
+                self.failure_reason = f"{self.failure_reason} timeout,"
             else:
                 assert self.output['failure'] == 'exception'
                 self.failure_reason = '{0} exception: {1}, {2}'.format(
@@ -183,21 +183,21 @@ class FioExeTest(FioTest):
             if self.success['zero_return']:
                 if self.output['proc'].returncode != 0:
                     self.passed = False
-                    self.failure_reason = "{0} non-zero return code,".format(self.failure_reason)
+                    self.failure_reason = f"{self.failure_reason} non-zero return code,"
             else:
                 if self.output['proc'].returncode == 0:
-                    self.failure_reason = "{0} zero return code,".format(self.failure_reason)
+                    self.failure_reason = f"{self.failure_reason} zero return code,"
                     self.passed = False
 
         stderr_size = os.path.getsize(self.stderr_file)
         if 'stderr_empty' in self.success:
             if self.success['stderr_empty']:
                 if stderr_size != 0:
-                    self.failure_reason = "{0} stderr not empty,".format(self.failure_reason)
+                    self.failure_reason = f"{self.failure_reason} stderr not empty,"
                     self.passed = False
             else:
                 if stderr_size == 0:
-                    self.failure_reason = "{0} stderr empty,".format(self.failure_reason)
+                    self.failure_reason = f"{self.failure_reason} stderr empty,"
                     self.passed = False
 
 
@@ -223,11 +223,11 @@ class FioJobTest(FioExeTest):
         self.output_format = output_format
         self.precon_failed = False
         self.json_data = None
-        self.fio_output = "{0}.output".format(os.path.basename(self.fio_job))
+        self.fio_output = f"{os.path.basename(self.fio_job)}.output"
         self.fio_args = [
             "--max-jobs=16",
-            "--output-format={0}".format(self.output_format),
-            "--output={0}".format(self.fio_output),
+            f"--output-format={self.output_format}",
+            f"--output={self.fio_output}",
             self.fio_job,
             ]
         FioExeTest.__init__(self, fio_path, self.fio_args, success)
@@ -235,20 +235,20 @@ class FioJobTest(FioExeTest):
     def setup(self, artifact_root, testnum):
         """Setup instance variables for fio job test."""
 
-        super(FioJobTest, self).setup(artifact_root, testnum)
+        super().setup(artifact_root, testnum)
 
         self.command_file = os.path.join(
             self.test_dir,
-            "{0}.command".format(os.path.basename(self.fio_job)))
+            f"{os.path.basename(self.fio_job)}.command")
         self.stdout_file = os.path.join(
             self.test_dir,
-            "{0}.stdout".format(os.path.basename(self.fio_job)))
+            f"{os.path.basename(self.fio_job)}.stdout")
         self.stderr_file = os.path.join(
             self.test_dir,
-            "{0}.stderr".format(os.path.basename(self.fio_job)))
+            f"{os.path.basename(self.fio_job)}.stderr")
         self.exitcode_file = os.path.join(
             self.test_dir,
-            "{0}.exitcode".format(os.path.basename(self.fio_job)))
+            f"{os.path.basename(self.fio_job)}.exitcode")
 
     def run_pre_job(self):
         """Run fio job precondition step."""
@@ -269,7 +269,7 @@ class FioJobTest(FioExeTest):
             self.run_pre_job()
 
         if not self.precon_failed:
-            super(FioJobTest, self).run()
+            super().run()
         else:
             logging.debug("Test %d: precondition step failed", self.testnum)
 
@@ -295,7 +295,7 @@ class FioJobTest(FioExeTest):
             with open(filename, "r") as output_file:
                 file_data = output_file.read()
         except OSError:
-            self.failure_reason += " unable to read file {0}".format(filename)
+            self.failure_reason += f" unable to read file {filename}"
             self.passed = False
 
         return file_data
@@ -305,10 +305,10 @@ class FioJobTest(FioExeTest):
 
         if self.precon_failed:
             self.passed = False
-            self.failure_reason = "{0} precondition step failed,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} precondition step failed,"
             return
 
-        super(FioJobTest, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -330,7 +330,7 @@ class FioJobTest(FioExeTest):
         try:
             self.json_data = json.loads(file_data)
         except json.JSONDecodeError:
-            self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} unable to decode JSON data,"
             self.passed = False
 
 
@@ -339,16 +339,16 @@ class FioJobTest_t0005(FioJobTest):
     Confirm that read['io_kbytes'] == write['io_kbytes'] == 102400"""
 
     def check_result(self):
-        super(FioJobTest_t0005, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
 
         if self.json_data['jobs'][0]['read']['io_kbytes'] != 102400:
-            self.failure_reason = "{0} bytes read mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} bytes read mismatch,"
             self.passed = False
         if self.json_data['jobs'][0]['write']['io_kbytes'] != 102400:
-            self.failure_reason = "{0} bytes written mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} bytes written mismatch,"
             self.passed = False
 
 
@@ -357,7 +357,7 @@ class FioJobTest_t0006(FioJobTest):
     Confirm that read['io_kbytes'] ~ 2*write['io_kbytes']"""
 
     def check_result(self):
-        super(FioJobTest_t0006, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -366,7 +366,7 @@ class FioJobTest_t0006(FioJobTest):
             / self.json_data['jobs'][0]['write']['io_kbytes']
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
         if ratio < 1.99 or ratio > 2.01:
-            self.failure_reason = "{0} read/write ratio mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} read/write ratio mismatch,"
             self.passed = False
 
 
@@ -375,13 +375,13 @@ class FioJobTest_t0007(FioJobTest):
     Confirm that read['io_kbytes'] = 87040"""
 
     def check_result(self):
-        super(FioJobTest_t0007, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
 
         if self.json_data['jobs'][0]['read']['io_kbytes'] != 87040:
-            self.failure_reason = "{0} bytes read mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} bytes read mismatch,"
             self.passed = False
 
 
@@ -397,7 +397,7 @@ class FioJobTest_t0008(FioJobTest):
     the blocks originally written will be read."""
 
     def check_result(self):
-        super(FioJobTest_t0008, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -406,10 +406,10 @@ class FioJobTest_t0008(FioJobTest):
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
         if ratio < 0.97 or ratio > 1.03:
-            self.failure_reason = "{0} bytes written mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} bytes written mismatch,"
             self.passed = False
         if self.json_data['jobs'][0]['read']['io_kbytes'] != 32768:
-            self.failure_reason = "{0} bytes read mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} bytes read mismatch,"
             self.passed = False
 
 
@@ -418,7 +418,7 @@ class FioJobTest_t0009(FioJobTest):
     Confirm that runtime >= 60s"""
 
     def check_result(self):
-        super(FioJobTest_t0009, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -426,7 +426,7 @@ class FioJobTest_t0009(FioJobTest):
         logging.debug('Test %d: elapsed: %d', self.testnum, self.json_data['jobs'][0]['elapsed'])
 
         if self.json_data['jobs'][0]['elapsed'] < 60:
-            self.failure_reason = "{0} elapsed time mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} elapsed time mismatch,"
             self.passed = False
 
 
@@ -436,7 +436,7 @@ class FioJobTest_t0012(FioJobTest):
     job1,job2,job3 respectively"""
 
     def check_result(self):
-        super(FioJobTest_t0012, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -484,7 +484,7 @@ class FioJobTest_t0014(FioJobTest):
     re-calibrate the activity dynamically"""
 
     def check_result(self):
-        super(FioJobTest_t0014, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -539,7 +539,7 @@ class FioJobTest_t0015(FioJobTest):
     Confirm that mean(slat) + mean(clat) = mean(tlat)"""
 
     def check_result(self):
-        super(FioJobTest_t0015, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -560,7 +560,7 @@ class FioJobTest_t0019(FioJobTest):
     Confirm that all offsets were touched sequentially"""
 
     def check_result(self):
-        super(FioJobTest_t0019, self).check_result()
+        super().check_result()
 
         bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
         file_data = self.get_file_fail(bw_log_filename)
@@ -576,13 +576,13 @@ class FioJobTest_t0019(FioJobTest):
             cur = int(line.split(',')[4])
             if cur - prev != 4096:
                 self.passed = False
-                self.failure_reason = "offsets {0}, {1} not sequential".format(prev, cur)
+                self.failure_reason = f"offsets {prev}, {cur} not sequential"
                 return
             prev = cur
 
         if cur/4096 != 255:
             self.passed = False
-            self.failure_reason = "unexpected last offset {0}".format(cur)
+            self.failure_reason = f"unexpected last offset {cur}"
 
 
 class FioJobTest_t0020(FioJobTest):
@@ -590,7 +590,7 @@ class FioJobTest_t0020(FioJobTest):
     Confirm that almost all offsets were touched non-sequentially"""
 
     def check_result(self):
-        super(FioJobTest_t0020, self).check_result()
+        super().check_result()
 
         bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
         file_data = self.get_file_fail(bw_log_filename)
@@ -611,14 +611,14 @@ class FioJobTest_t0020(FioJobTest):
 
         if len(offsets) != 256:
             self.passed = False
-            self.failure_reason += " number of offsets is {0} instead of 256".format(len(offsets))
+            self.failure_reason += f" number of offsets is {len(offsets)} instead of 256"
 
         for i in range(256):
             if not i in offsets:
                 self.passed = False
-                self.failure_reason += " missing offset {0}".format(i*4096)
+                self.failure_reason += f" missing offset {i * 4096}"
 
-        (z, p) = runstest_1samp(list(offsets))
+        (_, p) = runstest_1samp(list(offsets))
         if p < 0.05:
             self.passed = False
             self.failure_reason += f" runs test failed with p = {p}"
@@ -628,7 +628,7 @@ class FioJobTest_t0022(FioJobTest):
     """Test consists of fio test job t0022"""
 
     def check_result(self):
-        super(FioJobTest_t0022, self).check_result()
+        super().check_result()
 
         bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
         file_data = self.get_file_fail(bw_log_filename)
@@ -655,7 +655,7 @@ class FioJobTest_t0022(FioJobTest):
         # 10 is an arbitrary threshold
         if seq_count > 10:
             self.passed = False
-            self.failure_reason = "too many ({0}) consecutive offsets".format(seq_count)
+            self.failure_reason = f"too many ({seq_count}) consecutive offsets"
 
         if len(offsets) == filesize/bs:
             self.passed = False
@@ -690,7 +690,7 @@ class FioJobTest_t0023(FioJobTest):
                         bw_log_filename, line)
                     break
             else:
-                if ddir != 1:
+                if ddir != 1:   # pylint: disable=no-else-break
                     self.passed = False
                     self.failure_reason += " {0}: trim not preceeded by write: {1}".format(
                         bw_log_filename, line)
@@ -701,11 +701,13 @@ class FioJobTest_t0023(FioJobTest):
                         self.failure_reason += " {0}: block size does not match: {1}".format(
                             bw_log_filename, line)
                         break
+
                     if prev_offset != offset:
                         self.passed = False
                         self.failure_reason += " {0}: offset does not match: {1}".format(
                             bw_log_filename, line)
                         break
+
             prev_ddir = ddir
             prev_bs = bs
             prev_offset = offset
@@ -750,7 +752,7 @@ class FioJobTest_t0023(FioJobTest):
 
 
     def check_result(self):
-        super(FioJobTest_t0023, self).check_result()
+        super().check_result()
 
         filesize = 1024*1024
 
@@ -792,7 +794,7 @@ class FioJobTest_t0024(FioJobTest_t0023):
 class FioJobTest_t0025(FioJobTest):
     """Test experimental verify read backs written data pattern."""
     def check_result(self):
-        super(FioJobTest_t0025, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -802,7 +804,7 @@ class FioJobTest_t0025(FioJobTest):
 
 class FioJobTest_t0027(FioJobTest):
     def setup(self, *args, **kws):
-        super(FioJobTest_t0027, self).setup(*args, **kws)
+        super().setup(*args, **kws)
         self.pattern_file = os.path.join(self.test_dir, "t0027.pattern")
         self.output_file = os.path.join(self.test_dir, "t0027file")
         self.pattern = os.urandom(16 << 10)
@@ -810,7 +812,7 @@ class FioJobTest_t0027(FioJobTest):
             f.write(self.pattern)
 
     def check_result(self):
-        super(FioJobTest_t0027, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -828,7 +830,7 @@ class FioJobTest_iops_rate(FioJobTest):
     With two runs of fio-3.16 I observed a ratio of 8.3"""
 
     def check_result(self):
-        super(FioJobTest_iops_rate, self).check_result()
+        super().check_result()
 
         if not self.passed:
             return
@@ -841,11 +843,11 @@ class FioJobTest_iops_rate(FioJobTest):
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
         if iops1 < 950 or iops1 > 1050:
-            self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} iops value mismatch,"
             self.passed = False
 
         if ratio < 6 or ratio > 10:
-            self.failure_reason = "{0} iops ratio mismatch,".format(self.failure_reason)
+            self.failure_reason = f"{self.failure_reason} iops ratio mismatch,"
             self.passed = False
 
 
@@ -863,8 +865,9 @@ class Requirements():
     _not_windows = False
     _unittests = False
     _cpucount4 = False
+    _nvmecdev = False
 
-    def __init__(self, fio_root):
+    def __init__(self, fio_root, args):
         Requirements._not_macos = platform.system() != "Darwin"
         Requirements._not_windows = platform.system() != "Windows"
         Requirements._linux = platform.system() == "Linux"
@@ -873,7 +876,7 @@ class Requirements():
             config_file = os.path.join(fio_root, "config-host.h")
             contents, success = FioJobTest.get_file(config_file)
             if not success:
-                print("Unable to open {0} to check requirements".format(config_file))
+                print(f"Unable to open {config_file} to check requirements")
                 Requirements._zbd = True
             else:
                 Requirements._zbd = "CONFIG_HAS_BLKZONED" in contents
@@ -885,7 +888,7 @@ class Requirements():
             else:
                 Requirements._io_uring = "io_uring_setup" in contents
 
-            Requirements._root = (os.geteuid() == 0)
+            Requirements._root = os.geteuid() == 0
             if Requirements._zbd and Requirements._root:
                 try:
                     subprocess.run(["modprobe", "null_blk"],
@@ -904,17 +907,21 @@ class Requirements():
         Requirements._unittests = os.path.exists(unittest_path)
 
         Requirements._cpucount4 = multiprocessing.cpu_count() >= 4
-
-        req_list = [Requirements.linux,
-                    Requirements.libaio,
-                    Requirements.io_uring,
-                    Requirements.zbd,
-                    Requirements.root,
-                    Requirements.zoned_nullb,
-                    Requirements.not_macos,
-                    Requirements.not_windows,
-                    Requirements.unittests,
-                    Requirements.cpucount4]
+        Requirements._nvmecdev = args.nvmecdev
+
+        req_list = [
+                Requirements.linux,
+                Requirements.libaio,
+                Requirements.io_uring,
+                Requirements.zbd,
+                Requirements.root,
+                Requirements.zoned_nullb,
+                Requirements.not_macos,
+                Requirements.not_windows,
+                Requirements.unittests,
+                Requirements.cpucount4,
+                Requirements.nvmecdev,
+                    ]
         for req in req_list:
             value, desc = req()
             logging.debug("Requirements: Requirement '%s' met? %s", desc, value)
@@ -969,6 +976,11 @@ class Requirements():
         """Do we have at least 4 CPUs?"""
         return Requirements._cpucount4, "4+ CPUs required"
 
+    @classmethod
+    def nvmecdev(cls):
+        """Do we have an NVMe character device to test?"""
+        return Requirements._nvmecdev, "NVMe character device test target required"
+
 
 SUCCESS_DEFAULT = {
     'zero_return': True,
@@ -1367,6 +1379,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [],
     },
+    {
+        'test_id':          1014,
+        'test_class':       FioExeTest,
+        'exe':              't/nvmept.py',
+        'parameters':       ['-f', '{fio_path}', '--dut', '{nvmecdev}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.nvmecdev],
+    },
 ]
 
 
@@ -1390,6 +1410,8 @@ def parse_args():
                         help='skip requirements checking')
     parser.add_argument('-p', '--pass-through', action='append',
                         help='pass-through an argument to an executable test')
+    parser.add_argument('--nvmecdev', action='store', default=None,
+                        help='NVMe character device for **DESTRUCTIVE** testing (e.g., /dev/ng0n1)')
     args = parser.parse_args()
 
     return args
@@ -1408,7 +1430,7 @@ def main():
     if args.pass_through:
         for arg in args.pass_through:
             if not ':' in arg:
-                print("Invalid --pass-through argument '%s'" % arg)
+                print(f"Invalid --pass-through argument '{arg}'")
                 print("Syntax for --pass-through is TESTNUMBER:ARGUMENT")
                 return
             split = arg.split(":", 1)
@@ -1419,7 +1441,7 @@ def main():
         fio_root = args.fio_root
     else:
         fio_root = str(Path(__file__).absolute().parent.parent)
-    print("fio root is %s" % fio_root)
+    print(f"fio root is {fio_root}")
 
     if args.fio:
         fio_path = args.fio
@@ -1429,17 +1451,17 @@ def main():
         else:
             fio_exe = "fio"
         fio_path = os.path.join(fio_root, fio_exe)
-    print("fio path is %s" % fio_path)
+    print(f"fio path is {fio_path}")
     if not shutil.which(fio_path):
         print("Warning: fio executable not found")
 
     artifact_root = args.artifact_root if args.artifact_root else \
-        "fio-test-{0}".format(time.strftime("%Y%m%d-%H%M%S"))
+        f"fio-test-{time.strftime('%Y%m%d-%H%M%S')}"
     os.mkdir(artifact_root)
-    print("Artifact directory is %s" % artifact_root)
+    print(f"Artifact directory is {artifact_root}")
 
     if not args.skip_req:
-        req = Requirements(fio_root)
+        req = Requirements(fio_root, args)
 
     passed = 0
     failed = 0
@@ -1449,7 +1471,7 @@ def main():
         if (args.skip and config['test_id'] in args.skip) or \
            (args.run_only and config['test_id'] not in args.run_only):
             skipped = skipped + 1
-            print("Test {0} SKIPPED (User request)".format(config['test_id']))
+            print(f"Test {config['test_id']} SKIPPED (User request)")
             continue
 
         if issubclass(config['test_class'], FioJobTest):
@@ -1477,7 +1499,8 @@ def main():
         elif issubclass(config['test_class'], FioExeTest):
             exe_path = os.path.join(fio_root, config['exe'])
             if config['parameters']:
-                parameters = [p.format(fio_path=fio_path) for p in config['parameters']]
+                parameters = [p.format(fio_path=fio_path, nvmecdev=args.nvmecdev)
+                              for p in config['parameters']]
             else:
                 parameters = []
             if Path(exe_path).suffix == '.py' and platform.system() == "Windows":
@@ -1489,7 +1512,7 @@ def main():
                                         config['success'])
             desc = config['exe']
         else:
-            print("Test {0} FAILED: unable to process test config".format(config['test_id']))
+            print(f"Test {config['test_id']} FAILED: unable to process test config")
             failed = failed + 1
             continue
 
@@ -1502,7 +1525,7 @@ def main():
                 if not reqs_met:
                     break
             if not reqs_met:
-                print("Test {0} SKIPPED ({1}) {2}".format(config['test_id'], reason, desc))
+                print(f"Test {config['test_id']} SKIPPED ({reason}) {desc}")
                 skipped = skipped + 1
                 continue
 
@@ -1520,15 +1543,15 @@ def main():
             result = "PASSED"
             passed = passed + 1
         else:
-            result = "FAILED: {0}".format(test.failure_reason)
+            result = f"FAILED: {test.failure_reason}"
             failed = failed + 1
             contents, _ = FioJobTest.get_file(test.stderr_file)
             logging.debug("Test %d: stderr:\n%s", config['test_id'], contents)
             contents, _ = FioJobTest.get_file(test.stdout_file)
             logging.debug("Test %d: stdout:\n%s", config['test_id'], contents)
-        print("Test {0} {1} {2}".format(config['test_id'], result, desc))
+        print(f"Test {config['test_id']} {result} {desc}")
 
-    print("{0} test(s) passed, {1} failed, {2} skipped".format(passed, failed, skipped))
+    print(f"{passed} test(s) passed, {failed} failed, {skipped} skipped")
 
     sys.exit(failed)
 
