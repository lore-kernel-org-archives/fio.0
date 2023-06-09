Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56479C7EE29
	for <fio@archiver.kernel.org>; Fri,  9 Jun 2023 12:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbjFIMA2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 9 Jun 2023 08:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjFIMAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Jun 2023 08:00:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010DE1A2
        for <fio@vger.kernel.org>; Fri,  9 Jun 2023 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=evl6T1wXx9XTdrNJm//45friXdP3iJg+4pWqJDWuQuE=; b=G026wI/I8YdYCxxQo0G/KGbHU0
        sQNkzbn0QCIcBzSWMttbbNvZz+iRJl2awE/MF+AteJj241I4zEmcNaauWTH/kS0/zeHqq3GjkRTbb
        BqQKj6oA3xxOg3rUO/vxCtXedXwoczd/ipFMFR758UNWvmqzzbE73U5++Y1P645kWnoRpL2GoFTEg
        rSBfvfiDer1Mfxtj4M7qFuSgRTJWG9PQirOaIkighBjIpgSu9ld8Mvwekdo5HspOeujIhSUakcla4
        ZAI251Q9ehEyz+NJFxiY2LjA9Dr/CKvnhOokYilez1AVeXJbWlOM8x0C0aTCYtqlmO8oTQouVv4ZY
        aWdXwjYg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q7amm-00GWdp-Ku
        for fio@vger.kernel.org; Fri, 09 Jun 2023 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 505481BC0158; Fri,  9 Jun 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230609120002.505481BC0158@kernel.dk>
Date:   Fri,  9 Jun 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1b4ba547cf45377fffc7a1e60728369997cc7a9b:

  t/run-fio-tests: address issues identified by pylint (2023-06-01 14:12:41 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to edaee5b96fd87c3c5fe7f64ec917a175cd9237fc:

  t/zbd: test write zone accounting of trim workload (2023-06-08 14:39:07 -0400)

----------------------------------------------------------------
Shin'ichiro Kawasaki (7):
      zbd: rename 'open zones' to 'write zones'
      zbd: do not reset extra zones in open conditions
      zbd: fix write zone accounting of almost full zones
      zbd: fix write zone accounting of trim workload
      t/zbd: reset zones before tests with max_open_zones option
      t/zbd: test write zone accounting of almost full zones
      t/zbd: test write zone accounting of trim workload

Vincent Fu (17):
      t/run-fio-tests: split source file
      t/run-fio-tests: rename FioJobTest to FioJobFileTest
      t/run-fio-tests: move get_file outside of FioJobFileTest
      t/fiotestlib: use dictionaries for filenames and paths
      t/fiotestlib: use 'with' for opening files
      t/fiotestlib: use f-string for formatting
      t/fiotestlib: rearrange constructor and setup steps
      t/fiotestlib: record test command in more useful format
      t/fiotestlib: add class for command-line fio job
      t/random_seed: use logging module for debug prints
      t/random_seed: use methods provided in fiotestlib to run tests
      t/random_seed: fixes from pylint
      t/readonly: adapt to use fiotestlib
      t/nvmept: adapt to use fiotestlib
      t/fiotestlib: add ability to ingest iops logs
      t/strided: adapt to use fiotestlib
      t/strided: increase minumum recommended size to 64MiB

 engines/io_uring.c     |   2 +-
 fio.h                  |   2 +-
 io_u.c                 |   2 +-
 io_u.h                 |   2 +-
 options.c              |   4 +-
 t/fiotestcommon.py     | 176 +++++++++++++
 t/fiotestlib.py        | 485 ++++++++++++++++++++++++++++++++++
 t/nvmept.py            | 447 ++++++++++++--------------------
 t/random_seed.py       | 300 +++++++++------------
 t/readonly.py          | 220 +++++++++-------
 t/run-fio-tests.py     | 644 +++++----------------------------------------
 t/strided.py           | 691 ++++++++++++++++++++++++++++---------------------
 t/zbd/test-zbd-support |  64 ++++-
 zbd.c                  | 292 ++++++++++++---------
 zbd.h                  |  25 +-
 zbd_types.h            |   2 +-
 16 files changed, 1771 insertions(+), 1587 deletions(-)
 create mode 100644 t/fiotestcommon.py
 create mode 100755 t/fiotestlib.py

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index ff64fc9f..73e4a27a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -561,7 +561,7 @@ static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
 		ld->sqes[io_u->index].ioprio = io_u->ioprio;
 }
 
-static int fio_ioring_cmd_io_u_trim(const struct thread_data *td,
+static int fio_ioring_cmd_io_u_trim(struct thread_data *td,
 				    struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
diff --git a/fio.h b/fio.h
index 6fc7fb9c..c5453d13 100644
--- a/fio.h
+++ b/fio.h
@@ -275,7 +275,7 @@ struct thread_data {
 	unsigned long long num_unique_pages;
 
 	struct zone_split_index **zone_state_index;
-	unsigned int num_open_zones;
+	unsigned int num_write_zones;
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
diff --git a/io_u.c b/io_u.c
index 6f5fc94d..faf512e5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2379,7 +2379,7 @@ int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
 	return ret;
 }
 
-int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
+int do_io_u_trim(struct thread_data *td, struct io_u *io_u)
 {
 #ifndef FIO_HAVE_TRIM
 	io_u->error = EINVAL;
diff --git a/io_u.h b/io_u.h
index 55b4d083..b432a540 100644
--- a/io_u.h
+++ b/io_u.h
@@ -162,7 +162,7 @@ void io_u_mark_submit(struct thread_data *, unsigned int);
 bool queue_full(const struct thread_data *);
 
 int do_io_u_sync(const struct thread_data *, struct io_u *);
-int do_io_u_trim(const struct thread_data *, struct io_u *);
+int do_io_u_trim(struct thread_data *, struct io_u *);
 
 #ifdef FIO_INC_DEBUG
 static inline void dprint_io_u(struct io_u *io_u, const char *p)
diff --git a/options.c b/options.c
index 8193fb29..a7c4ef6e 100644
--- a/options.c
+++ b/options.c
@@ -3618,7 +3618,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Per device/file maximum number of open zones",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, max_open_zones),
-		.maxval	= ZBD_MAX_OPEN_ZONES,
+		.maxval	= ZBD_MAX_WRITE_ZONES,
 		.help	= "Limit on the number of simultaneously opened sequential write zones with zonemode=zbd",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
@@ -3629,7 +3629,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Job maximum number of open zones",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, job_max_open_zones),
-		.maxval	= ZBD_MAX_OPEN_ZONES,
+		.maxval	= ZBD_MAX_WRITE_ZONES,
 		.help	= "Limit on the number of simultaneously opened sequential write zones with zonemode=zbd by one thread/process",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
diff --git a/t/fiotestcommon.py b/t/fiotestcommon.py
new file mode 100644
index 00000000..f5012c82
--- /dev/null
+++ b/t/fiotestcommon.py
@@ -0,0 +1,176 @@
+#!/usr/bin/env python3
+"""
+fiotestcommon.py
+
+This contains constant definitions, helpers, and a Requirements class that can
+be used to help with running fio tests.
+"""
+
+import os
+import locale
+import logging
+import platform
+import subprocess
+import multiprocessing
+
+
+SUCCESS_DEFAULT = {
+    'zero_return': True,
+    'stderr_empty': True,
+    'timeout': 600,
+    }
+SUCCESS_NONZERO = {
+    'zero_return': False,
+    'stderr_empty': False,
+    'timeout': 600,
+    }
+SUCCESS_STDERR = {
+    'zero_return': True,
+    'stderr_empty': False,
+    'timeout': 600,
+    }
+
+
+def get_file(filename):
+    """Safely read a file."""
+    file_data = ''
+    success = True
+
+    try:
+        with open(filename, "r", encoding=locale.getpreferredencoding()) as output_file:
+            file_data = output_file.read()
+    except OSError:
+        success = False
+
+    return file_data, success
+
+
+class Requirements():
+    """Requirements consists of multiple run environment characteristics.
+    These are to determine if a particular test can be run"""
+
+    _linux = False
+    _libaio = False
+    _io_uring = False
+    _zbd = False
+    _root = False
+    _zoned_nullb = False
+    _not_macos = False
+    _not_windows = False
+    _unittests = False
+    _cpucount4 = False
+    _nvmecdev = False
+
+    def __init__(self, fio_root, args):
+        Requirements._not_macos = platform.system() != "Darwin"
+        Requirements._not_windows = platform.system() != "Windows"
+        Requirements._linux = platform.system() == "Linux"
+
+        if Requirements._linux:
+            config_file = os.path.join(fio_root, "config-host.h")
+            contents, success = get_file(config_file)
+            if not success:
+                print(f"Unable to open {config_file} to check requirements")
+                Requirements._zbd = True
+            else:
+                Requirements._zbd = "CONFIG_HAS_BLKZONED" in contents
+                Requirements._libaio = "CONFIG_LIBAIO" in contents
+
+            contents, success = get_file("/proc/kallsyms")
+            if not success:
+                print("Unable to open '/proc/kallsyms' to probe for io_uring support")
+            else:
+                Requirements._io_uring = "io_uring_setup" in contents
+
+            Requirements._root = os.geteuid() == 0
+            if Requirements._zbd and Requirements._root:
+                try:
+                    subprocess.run(["modprobe", "null_blk"],
+                                   stdout=subprocess.PIPE,
+                                   stderr=subprocess.PIPE)
+                    if os.path.exists("/sys/module/null_blk/parameters/zoned"):
+                        Requirements._zoned_nullb = True
+                except Exception:
+                    pass
+
+        if platform.system() == "Windows":
+            utest_exe = "unittest.exe"
+        else:
+            utest_exe = "unittest"
+        unittest_path = os.path.join(fio_root, "unittests", utest_exe)
+        Requirements._unittests = os.path.exists(unittest_path)
+
+        Requirements._cpucount4 = multiprocessing.cpu_count() >= 4
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
+        for req in req_list:
+            value, desc = req()
+            logging.debug("Requirements: Requirement '%s' met? %s", desc, value)
+
+    @classmethod
+    def linux(cls):
+        """Are we running on Linux?"""
+        return Requirements._linux, "Linux required"
+
+    @classmethod
+    def libaio(cls):
+        """Is libaio available?"""
+        return Requirements._libaio, "libaio required"
+
+    @classmethod
+    def io_uring(cls):
+        """Is io_uring available?"""
+        return Requirements._io_uring, "io_uring required"
+
+    @classmethod
+    def zbd(cls):
+        """Is ZBD support available?"""
+        return Requirements._zbd, "Zoned block device support required"
+
+    @classmethod
+    def root(cls):
+        """Are we running as root?"""
+        return Requirements._root, "root required"
+
+    @classmethod
+    def zoned_nullb(cls):
+        """Are zoned null block devices available?"""
+        return Requirements._zoned_nullb, "Zoned null block device support required"
+
+    @classmethod
+    def not_macos(cls):
+        """Are we running on a platform other than macOS?"""
+        return Requirements._not_macos, "platform other than macOS required"
+
+    @classmethod
+    def not_windows(cls):
+        """Are we running on a platform other than Windws?"""
+        return Requirements._not_windows, "platform other than Windows required"
+
+    @classmethod
+    def unittests(cls):
+        """Were unittests built?"""
+        return Requirements._unittests, "Unittests support required"
+
+    @classmethod
+    def cpucount4(cls):
+        """Do we have at least 4 CPUs?"""
+        return Requirements._cpucount4, "4+ CPUs required"
+
+    @classmethod
+    def nvmecdev(cls):
+        """Do we have an NVMe character device to test?"""
+        return Requirements._nvmecdev, "NVMe character device test target required"
diff --git a/t/fiotestlib.py b/t/fiotestlib.py
new file mode 100755
index 00000000..0fe17b74
--- /dev/null
+++ b/t/fiotestlib.py
@@ -0,0 +1,485 @@
+#!/usr/bin/env python3
+"""
+fiotestlib.py
+
+This library contains FioTest objects that provide convenient means to run
+different sorts of fio tests.
+
+It also contains a test runner that runs an array of dictionary objects
+describing fio tests.
+"""
+
+import os
+import sys
+import json
+import locale
+import logging
+import platform
+import traceback
+import subprocess
+from pathlib import Path
+from fiotestcommon import get_file, SUCCESS_DEFAULT
+
+
+class FioTest():
+    """Base for all fio tests."""
+
+    def __init__(self, exe_path, success, testnum, artifact_root):
+        self.success = success
+        self.testnum = testnum
+        self.output = {}
+        self.passed = True
+        self.failure_reason = ''
+        self.parameters = None
+        self.paths = {
+                        'exe': exe_path,
+                        'artifacts': artifact_root,
+                        'test_dir': os.path.join(artifact_root, \
+                                f"{testnum:04d}"),
+                        }
+        self.filenames = {
+                            'cmd': os.path.join(self.paths['test_dir'], \
+                                    f"{os.path.basename(self.paths['exe'])}.command"),
+                            'stdout': os.path.join(self.paths['test_dir'], \
+                                    f"{os.path.basename(self.paths['exe'])}.stdout"),
+                            'stderr': os.path.join(self.paths['test_dir'], \
+                                    f"{os.path.basename(self.paths['exe'])}.stderr"),
+                            'exitcode': os.path.join(self.paths['test_dir'], \
+                                    f"{os.path.basename(self.paths['exe'])}.exitcode"),
+                            }
+
+    def setup(self, parameters):
+        """Setup instance variables for test."""
+
+        self.parameters = parameters
+        if not os.path.exists(self.paths['test_dir']):
+            os.mkdir(self.paths['test_dir'])
+
+    def run(self):
+        """Run the test."""
+
+        raise NotImplementedError()
+
+    def check_result(self):
+        """Check test results."""
+
+        raise NotImplementedError()
+
+
+class FioExeTest(FioTest):
+    """Test consists of an executable binary or script"""
+
+    def run(self):
+        """Execute the binary or script described by this instance."""
+
+        command = [self.paths['exe']] + self.parameters
+        with open(self.filenames['cmd'], "w+",
+                  encoding=locale.getpreferredencoding()) as command_file:
+            command_file.write(" ".join(command))
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
+                                        cwd=self.paths['test_dir'],
+                                        universal_newlines=True)
+                proc.communicate(timeout=self.success['timeout'])
+                exitcode_file.write(f'{proc.returncode}\n')
+                logging.debug("Test %d: return code: %d", self.testnum, proc.returncode)
+                self.output['proc'] = proc
+        except subprocess.TimeoutExpired:
+            proc.terminate()
+            proc.communicate()
+            assert proc.poll()
+            self.output['failure'] = 'timeout'
+        except Exception:
+            if proc:
+                if not proc.poll():
+                    proc.terminate()
+                    proc.communicate()
+            self.output['failure'] = 'exception'
+            self.output['exc_info'] = sys.exc_info()
+
+    def check_result(self):
+        """Check results of test run."""
+
+        if 'proc' not in self.output:
+            if self.output['failure'] == 'timeout':
+                self.failure_reason = f"{self.failure_reason} timeout,"
+            else:
+                assert self.output['failure'] == 'exception'
+                self.failure_reason = f'{self.failure_reason} exception: ' + \
+                f'{self.output["exc_info"][0]}, {self.output["exc_info"][1]}'
+
+            self.passed = False
+            return
+
+        if 'zero_return' in self.success:
+            if self.success['zero_return']:
+                if self.output['proc'].returncode != 0:
+                    self.passed = False
+                    self.failure_reason = f"{self.failure_reason} non-zero return code,"
+            else:
+                if self.output['proc'].returncode == 0:
+                    self.failure_reason = f"{self.failure_reason} zero return code,"
+                    self.passed = False
+
+        stderr_size = os.path.getsize(self.filenames['stderr'])
+        if 'stderr_empty' in self.success:
+            if self.success['stderr_empty']:
+                if stderr_size != 0:
+                    self.failure_reason = f"{self.failure_reason} stderr not empty,"
+                    self.passed = False
+            else:
+                if stderr_size == 0:
+                    self.failure_reason = f"{self.failure_reason} stderr empty,"
+                    self.passed = False
+
+
+class FioJobFileTest(FioExeTest):
+    """Test consists of a fio job with options in a job file."""
+
+    def __init__(self, fio_path, fio_job, success, testnum, artifact_root,
+                 fio_pre_job=None, fio_pre_success=None,
+                 output_format="normal"):
+        """Construct a FioJobFileTest which is a FioExeTest consisting of a
+        single fio job file with an optional setup step.
+
+        fio_path:           location of fio executable
+        fio_job:            location of fio job file
+        success:            Definition of test success
+        testnum:            test ID
+        artifact_root:      root directory for artifacts
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
+
+        super().__init__(fio_path, success, testnum, artifact_root)
+
+    def setup(self, parameters=None):
+        """Setup instance variables for fio job test."""
+
+        self.filenames['fio_output'] = f"{os.path.basename(self.fio_job)}.output"
+        fio_args = [
+            "--max-jobs=16",
+            f"--output-format={self.output_format}",
+            f"--output={self.filenames['fio_output']}",
+            self.fio_job,
+            ]
+
+        super().setup(fio_args)
+
+        # Update the filenames from the default
+        self.filenames['cmd'] = os.path.join(self.paths['test_dir'],
+                                             f"{os.path.basename(self.fio_job)}.command")
+        self.filenames['stdout'] = os.path.join(self.paths['test_dir'],
+                                                f"{os.path.basename(self.fio_job)}.stdout")
+        self.filenames['stderr'] = os.path.join(self.paths['test_dir'],
+                                                f"{os.path.basename(self.fio_job)}.stderr")
+        self.filenames['exitcode'] = os.path.join(self.paths['test_dir'],
+                                                  f"{os.path.basename(self.fio_job)}.exitcode")
+
+    def run_pre_job(self):
+        """Run fio job precondition step."""
+
+        precon = FioJobFileTest(self.paths['exe'], self.fio_pre_job,
+                            self.fio_pre_success,
+                            self.testnum,
+                            self.paths['artifacts'],
+                            output_format=self.output_format)
+        precon.setup()
+        precon.run()
+        precon.check_result()
+        self.precon_failed = not precon.passed
+        self.failure_reason = precon.failure_reason
+
+    def run(self):
+        """Run fio job test."""
+
+        if self.fio_pre_job:
+            self.run_pre_job()
+
+        if not self.precon_failed:
+            super().run()
+        else:
+            logging.debug("Test %d: precondition step failed", self.testnum)
+
+    def get_file_fail(self, filename):
+        """Safely read a file and fail the test upon error."""
+        file_data = None
+
+        try:
+            with open(filename, "r", encoding=locale.getpreferredencoding()) as output_file:
+                file_data = output_file.read()
+        except OSError:
+            self.failure_reason += f" unable to read file {filename}"
+            self.passed = False
+
+        return file_data
+
+    def check_result(self):
+        """Check fio job results."""
+
+        if self.precon_failed:
+            self.passed = False
+            self.failure_reason = f"{self.failure_reason} precondition step failed,"
+            return
+
+        super().check_result()
+
+        if not self.passed:
+            return
+
+        if 'json' not in self.output_format:
+            return
+
+        file_data = self.get_file_fail(os.path.join(self.paths['test_dir'],
+                                                    self.filenames['fio_output']))
+        if not file_data:
+            return
+
+        #
+        # Sometimes fio informational messages are included at the top of the
+        # JSON output, especially under Windows. Try to decode output as JSON
+        # data, skipping everything until the first {
+        #
+        lines = file_data.splitlines()
+        file_data = '\n'.join(lines[lines.index("{"):])
+        try:
+            self.json_data = json.loads(file_data)
+        except json.JSONDecodeError:
+            self.failure_reason = f"{self.failure_reason} unable to decode JSON data,"
+            self.passed = False
+
+
+class FioJobCmdTest(FioExeTest):
+    """This runs a fio job with options specified on the command line."""
+
+    def __init__(self, fio_path, success, testnum, artifact_root, fio_opts, basename=None):
+
+        self.basename = basename if basename else os.path.basename(fio_path)
+        self.fio_opts = fio_opts
+        self.json_data = None
+        self.iops_log_lines = None
+
+        super().__init__(fio_path, success, testnum, artifact_root)
+
+        filename_stub = os.path.join(self.paths['test_dir'], f"{self.basename}{self.testnum:03d}")
+        self.filenames['cmd'] = f"{filename_stub}.command"
+        self.filenames['stdout'] = f"{filename_stub}.stdout"
+        self.filenames['stderr'] = f"{filename_stub}.stderr"
+        self.filenames['output'] = os.path.abspath(f"{filename_stub}.output")
+        self.filenames['exitcode'] = f"{filename_stub}.exitcode"
+        self.filenames['iopslog'] = os.path.abspath(f"{filename_stub}")
+
+    def run(self):
+        super().run()
+
+        if 'output-format' in self.fio_opts and 'json' in \
+                self.fio_opts['output-format']:
+            if not self.get_json():
+                print('Unable to decode JSON data')
+                self.passed = False
+
+        if any('--write_iops_log=' in param for param in self.parameters):
+            self.get_iops_log()
+
+    def get_iops_log(self):
+        """Read IOPS log from the first job."""
+
+        log_filename = self.filenames['iopslog'] + "_iops.1.log"
+        with open(log_filename, 'r', encoding=locale.getpreferredencoding()) as iops_file:
+            self.iops_log_lines = iops_file.read()
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
+
+def run_fio_tests(test_list, test_env, args):
+    """
+    Run tests as specified in test_list.
+    """
+
+    passed = 0
+    failed = 0
+    skipped = 0
+
+    for config in test_list:
+        if (args.skip and config['test_id'] in args.skip) or \
+           (args.run_only and config['test_id'] not in args.run_only):
+            skipped = skipped + 1
+            print(f"Test {config['test_id']} SKIPPED (User request)")
+            continue
+
+        if issubclass(config['test_class'], FioJobFileTest):
+            if config['pre_job']:
+                fio_pre_job = os.path.join(test_env['fio_root'], 't', 'jobs',
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
+                test_env['fio_path'],
+                os.path.join(test_env['fio_root'], 't', 'jobs', config['job']),
+                config['success'],
+                config['test_id'],
+                test_env['artifact_root'],
+                fio_pre_job=fio_pre_job,
+                fio_pre_success=fio_pre_success,
+                output_format=output_format)
+            desc = config['job']
+            parameters = []
+        elif issubclass(config['test_class'], FioJobCmdTest):
+            if not 'success' in config:
+                config['success'] = SUCCESS_DEFAULT
+            test = config['test_class'](test_env['fio_path'],
+                                        config['success'],
+                                        config['test_id'],
+                                        test_env['artifact_root'],
+                                        config['fio_opts'],
+                                        test_env['basename'])
+            desc = config['test_id']
+            parameters = config
+        elif issubclass(config['test_class'], FioExeTest):
+            exe_path = os.path.join(test_env['fio_root'], config['exe'])
+            parameters = []
+            if config['parameters']:
+                parameters = [p.format(fio_path=test_env['fio_path'], nvmecdev=args.nvmecdev)
+                              for p in config['parameters']]
+            if Path(exe_path).suffix == '.py' and platform.system() == "Windows":
+                parameters.insert(0, exe_path)
+                exe_path = "python.exe"
+            if config['test_id'] in test_env['pass_through']:
+                parameters += test_env['pass_through'][config['test_id']].split()
+            test = config['test_class'](
+                    exe_path,
+                    config['success'],
+                    config['test_id'],
+                    test_env['artifact_root'])
+            desc = config['exe']
+        else:
+            print(f"Test {config['test_id']} FAILED: unable to process test config")
+            failed = failed + 1
+            continue
+
+        if 'requirements' in config and not args.skip_req:
+            reqs_met = True
+            for req in config['requirements']:
+                reqs_met, reason = req()
+                logging.debug("Test %d: Requirement '%s' met? %s", config['test_id'], reason,
+                              reqs_met)
+                if not reqs_met:
+                    break
+            if not reqs_met:
+                print(f"Test {config['test_id']} SKIPPED ({reason}) {desc}")
+                skipped = skipped + 1
+                continue
+
+        try:
+            test.setup(parameters)
+            test.run()
+            test.check_result()
+        except KeyboardInterrupt:
+            break
+        except Exception as e:
+            test.passed = False
+            test.failure_reason += str(e)
+            logging.debug("Test %d exception:\n%s\n", config['test_id'], traceback.format_exc())
+        if test.passed:
+            result = "PASSED"
+            passed = passed + 1
+        else:
+            result = f"FAILED: {test.failure_reason}"
+            failed = failed + 1
+            contents, _ = get_file(test.filenames['stderr'])
+            logging.debug("Test %d: stderr:\n%s", config['test_id'], contents)
+            contents, _ = get_file(test.filenames['stdout'])
+            logging.debug("Test %d: stdout:\n%s", config['test_id'], contents)
+        print(f"Test {config['test_id']} {result} {desc}")
+
+    print(f"{passed} test(s) passed, {failed} failed, {skipped} skipped")
+
+    return passed, failed, skipped
diff --git a/t/nvmept.py b/t/nvmept.py
index a25192f2..e235d160 100755
--- a/t/nvmept.py
+++ b/t/nvmept.py
@@ -17,42 +17,20 @@
 """
 import os
 import sys
-import json
 import time
-import locale
 import argparse
-import subprocess
 from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
 
-class FioTest():
-    """fio test."""
 
-    def __init__(self, artifact_root, test_opts, debug):
-        """
-        artifact_root   root directory for artifacts (subdirectory will be created under here)
-        test            test specification
-        """
-        self.artifact_root = artifact_root
-        self.test_opts = test_opts
-        self.debug = debug
-        self.filename_stub = None
-        self.filenames = {}
-        self.json_data = None
-
-        self.test_dir = os.path.abspath(os.path.join(self.artifact_root,
-                                     f"{self.test_opts['test_id']:03d}"))
-        if not os.path.exists(self.test_dir):
-            os.mkdir(self.test_dir)
-
-        self.filename_stub = f"pt{self.test_opts['test_id']:03d}"
-        self.filenames['command'] = os.path.join(self.test_dir, f"{self.filename_stub}.command")
-        self.filenames['stdout'] = os.path.join(self.test_dir, f"{self.filename_stub}.stdout")
-        self.filenames['stderr'] = os.path.join(self.test_dir, f"{self.filename_stub}.stderr")
-        self.filenames['exitcode'] = os.path.join(self.test_dir, f"{self.filename_stub}.exitcode")
-        self.filenames['output'] = os.path.join(self.test_dir, f"{self.filename_stub}.output")
+class PassThruTest(FioJobCmdTest):
+    """
+    NVMe pass-through test class. Check to make sure output for selected data
+    direction(s) is non-zero and that zero data appears for other directions.
+    """
 
-    def run_fio(self, fio_path):
-        """Run a test."""
+    def setup(self, parameters):
+        """Setup a test."""
 
         fio_args = [
             "--name=nvmept",
@@ -61,300 +39,172 @@ class FioTest():
             "--iodepth=8",
             "--iodepth_batch=4",
             "--iodepth_batch_complete=4",
-            f"--filename={self.test_opts['filename']}",
-            f"--rw={self.test_opts['rw']}",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
             f"--output={self.filenames['output']}",
-            f"--output-format={self.test_opts['output-format']}",
+            f"--output-format={self.fio_opts['output-format']}",
         ]
         for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
                     'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
                     'time_based', 'runtime', 'verify', 'io_size']:
-            if opt in self.test_opts:
-                option = f"--{opt}={self.test_opts[opt]}"
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
                 fio_args.append(option)
 
-        command = [fio_path] + fio_args
-        with open(self.filenames['command'], "w+",
-                  encoding=locale.getpreferredencoding()) as command_file:
-            command_file.write(" ".join(command))
-
-        passed = True
-
-        try:
-            with open(self.filenames['stdout'], "w+",
-                      encoding=locale.getpreferredencoding()) as stdout_file, \
-                open(self.filenames['stderr'], "w+",
-                     encoding=locale.getpreferredencoding()) as stderr_file, \
-                open(self.filenames['exitcode'], "w+",
-                     encoding=locale.getpreferredencoding()) as exitcode_file:
-                proc = None
-                # Avoid using subprocess.run() here because when a timeout occurs,
-                # fio will be stopped with SIGKILL. This does not give fio a
-                # chance to clean up and means that child processes may continue
-                # running and submitting IO.
-                proc = subprocess.Popen(command,
-                                        stdout=stdout_file,
-                                        stderr=stderr_file,
-                                        cwd=self.test_dir,
-                                        universal_newlines=True)
-                proc.communicate(timeout=300)
-                exitcode_file.write(f'{proc.returncode}\n')
-                passed &= (proc.returncode == 0)
-        except subprocess.TimeoutExpired:
-            proc.terminate()
-            proc.communicate()
-            assert proc.poll()
-            print("Timeout expired")
-            passed = False
-        except Exception:
-            if proc:
-                if not proc.poll():
-                    proc.terminate()
-                    proc.communicate()
-            print(f"Exception: {sys.exc_info()}")
-            passed = False
-
-        if passed:
-            if 'output-format' in self.test_opts and 'json' in \
-                    self.test_opts['output-format']:
-                if not self.get_json():
-                    print('Unable to decode JSON data')
-                    passed = False
-
-        return passed
-
-    def get_json(self):
-        """Convert fio JSON output into a python JSON object"""
-
-        filename = self.filenames['output']
-        with open(filename, 'r', encoding=locale.getpreferredencoding()) as file:
-            file_data = file.read()
-
-        #
-        # Sometimes fio informational messages are included at the top of the
-        # JSON output, especially under Windows. Try to decode output as JSON
-        # data, lopping off up to the first four lines
-        #
-        lines = file_data.splitlines()
-        for i in range(5):
-            file_data = '\n'.join(lines[i:])
-            try:
-                self.json_data = json.loads(file_data)
-            except json.JSONDecodeError:
-                continue
-            else:
-                return True
-
-        return False
-
-    @staticmethod
-    def check_empty(job):
-        """
-        Make sure JSON data is empty.
-
-        Some data structures should be empty. This function makes sure that they are.
-
-        job         JSON object that we need to check for emptiness
-        """
-
-        return job['total_ios'] == 0 and \
-                job['slat_ns']['N'] == 0 and \
-                job['clat_ns']['N'] == 0 and \
-                job['lat_ns']['N'] == 0
-
-    def check_all_ddirs(self, ddir_nonzero, job):
-        """
-        Iterate over the data directions and check whether each is
-        appropriately empty or not.
-        """
-
-        retval = True
-        ddirlist = ['read', 'write', 'trim']
-
-        for ddir in ddirlist:
-            if ddir in ddir_nonzero:
-                if self.check_empty(job[ddir]):
-                    print(f"Unexpected zero {ddir} data found in output")
-                    retval = False
-            else:
-                if not self.check_empty(job[ddir]):
-                    print(f"Unexpected {ddir} data found in output")
-                    retval = False
-
-        return retval
-
-    def check(self):
-        """Check test output."""
-
-        raise NotImplementedError()
+        super().setup(fio_args)
 
 
-class PTTest(FioTest):
-    """
-    NVMe pass-through test class. Check to make sure output for selected data
-    direction(s) is non-zero and that zero data appears for other directions.
-    """
+    def check_result(self):
+        if 'rw' not in self.fio_opts:
+            return
 
-    def check(self):
-        if 'rw' not in self.test_opts:
-            return True
+        if not self.passed:
+            return
 
         job = self.json_data['jobs'][0]
-        retval = True
 
-        if self.test_opts['rw'] in ['read', 'randread']:
-            retval = self.check_all_ddirs(['read'], job)
-        elif self.test_opts['rw'] in ['write', 'randwrite']:
-            if 'verify' not in self.test_opts:
-                retval = self.check_all_ddirs(['write'], job)
+        if self.fio_opts['rw'] in ['read', 'randread']:
+            self.passed = self.check_all_ddirs(['read'], job)
+        elif self.fio_opts['rw'] in ['write', 'randwrite']:
+            if 'verify' not in self.fio_opts:
+                self.passed = self.check_all_ddirs(['write'], job)
             else:
-                retval = self.check_all_ddirs(['read', 'write'], job)
-        elif self.test_opts['rw'] in ['trim', 'randtrim']:
-            retval = self.check_all_ddirs(['trim'], job)
-        elif self.test_opts['rw'] in ['readwrite', 'randrw']:
-            retval = self.check_all_ddirs(['read', 'write'], job)
-        elif self.test_opts['rw'] in ['trimwrite', 'randtrimwrite']:
-            retval = self.check_all_ddirs(['trim', 'write'], job)
+                self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trim', 'randtrim']:
+            self.passed = self.check_all_ddirs(['trim'], job)
+        elif self.fio_opts['rw'] in ['readwrite', 'randrw']:
+            self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trimwrite', 'randtrimwrite']:
+            self.passed = self.check_all_ddirs(['trim', 'write'], job)
         else:
-            print(f"Unhandled rw value {self.test_opts['rw']}")
-            retval = False
-
-        return retval
-
+            print(f"Unhandled rw value {self.fio_opts['rw']}")
+            self.passed = False
 
-def parse_args():
-    """Parse command-line arguments."""
 
-    parser = argparse.ArgumentParser()
-    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
-    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
-    parser.add_argument('-d', '--debug', help='enable debug output', action='store_true')
-    parser.add_argument('-s', '--skip', nargs='+', type=int,
-                        help='list of test(s) to skip')
-    parser.add_argument('-o', '--run-only', nargs='+', type=int,
-                        help='list of test(s) to run, skipping all others')
-    parser.add_argument('--dut', help='target NVMe character device to test '
-                        '(e.g., /dev/ng0n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
-    args = parser.parse_args()
-
-    return args
-
-
-def main():
-    """Run tests using fio's io_uring_cmd ioengine to send NVMe pass through commands."""
-
-    args = parse_args()
-
-    artifact_root = args.artifact_root if args.artifact_root else \
-        f"nvmept-test-{time.strftime('%Y%m%d-%H%M%S')}"
-    os.mkdir(artifact_root)
-    print(f"Artifact directory is {artifact_root}")
-
-    if args.fio:
-        fio = str(Path(args.fio).absolute())
-    else:
-        fio = 'fio'
-    print(f"fio path is {fio}")
-
-    test_list = [
-        {
-            "test_id": 1,
+TEST_LIST = [
+    {
+        "test_id": 1,
+        "fio_opts": {
             "rw": 'read',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 2,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
             "rw": 'randread',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 3,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 3,
+        "fio_opts": {
             "rw": 'write',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 4,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
             "rw": 'randwrite',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 5,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 5,
+        "fio_opts": {
             "rw": 'trim',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 6,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 6,
+        "fio_opts": {
             "rw": 'randtrim',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 7,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 7,
+        "fio_opts": {
             "rw": 'write',
             "io_size": 1024*1024,
             "verify": "crc32c",
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 8,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 8,
+        "fio_opts": {
             "rw": 'randwrite',
             "io_size": 1024*1024,
             "verify": "crc32c",
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 9,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 9,
+        "fio_opts": {
             "rw": 'readwrite',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 10,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 10,
+        "fio_opts": {
             "rw": 'randrw',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 11,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 11,
+        "fio_opts": {
             "rw": 'trimwrite',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 12,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 12,
+        "fio_opts": {
             "rw": 'randtrimwrite',
             "timebased": 1,
             "runtime": 3,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 13,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 13,
+        "fio_opts": {
             "rw": 'randread',
             "timebased": 1,
             "runtime": 3,
@@ -364,10 +214,12 @@ def main():
             "registerfiles": 1,
             "sqthread_poll": 1,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-        {
-            "test_id": 14,
+            },
+        "test_class": PassThruTest,
+    },
+    {
+        "test_id": 14,
+        "fio_opts": {
             "rw": 'randwrite',
             "timebased": 1,
             "runtime": 3,
@@ -377,36 +229,55 @@ def main():
             "registerfiles": 1,
             "sqthread_poll": 1,
             "output-format": "json",
-            "test_obj": PTTest,
-        },
-    ]
+            },
+        "test_class": PassThruTest,
+    },
+]
 
-    passed = 0
-    failed = 0
-    skipped = 0
+def parse_args():
+    """Parse command-line arguments."""
 
-    for test in test_list:
-        if (args.skip and test['test_id'] in args.skip) or \
-           (args.run_only and test['test_id'] not in args.run_only):
-            skipped = skipped + 1
-            outcome = 'SKIPPED (User request)'
-        else:
-            test['filename'] = args.dut
-            test_obj = test['test_obj'](artifact_root, test, args.debug)
-            status = test_obj.run_fio(fio)
-            if status:
-                status = test_obj.check()
-            if status:
-                passed = passed + 1
-                outcome = 'PASSED'
-            else:
-                failed = failed + 1
-                outcome = 'FAILED'
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
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
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = 'fio'
+    print(f"fio path is {fio_path}")
 
-        print(f"**********Test {test['test_id']} {outcome}**********")
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
 
-    print(f"{passed} tests passed, {failed} failed, {skipped} skipped")
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'readonly',
+              }
 
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
     sys.exit(failed)
 
 
diff --git a/t/random_seed.py b/t/random_seed.py
index 86f2eb21..02187046 100755
--- a/t/random_seed.py
+++ b/t/random_seed.py
@@ -23,38 +23,16 @@ import os
 import sys
 import time
 import locale
+import logging
 import argparse
-import subprocess
 from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
 
-class FioRandTest():
+class FioRandTest(FioJobCmdTest):
     """fio random seed test."""
 
-    def __init__(self, artifact_root, test_options, debug):
-        """
-        artifact_root   root directory for artifacts (subdirectory will be created under here)
-        test            test specification
-        """
-        self.artifact_root = artifact_root
-        self.test_options = test_options
-        self.debug = debug
-        self.filename_stub = None
-        self.filenames = {}
-
-        self.test_dir = os.path.abspath(os.path.join(self.artifact_root,
-                                     f"{self.test_options['test_id']:03d}"))
-        if not os.path.exists(self.test_dir):
-            os.mkdir(self.test_dir)
-
-        self.filename_stub = f"random{self.test_options['test_id']:03d}"
-        self.filenames['command'] = os.path.join(self.test_dir, f"{self.filename_stub}.command")
-        self.filenames['stdout'] = os.path.join(self.test_dir, f"{self.filename_stub}.stdout")
-        self.filenames['stderr'] = os.path.join(self.test_dir, f"{self.filename_stub}.stderr")
-        self.filenames['exitcode'] = os.path.join(self.test_dir, f"{self.filename_stub}.exitcode")
-        self.filenames['output'] = os.path.join(self.test_dir, f"{self.filename_stub}.output")
-
-    def run_fio(self, fio_path):
-        """Run a test."""
+    def setup(self, parameters):
+        """Setup the test."""
 
         fio_args = [
             "--debug=random",
@@ -65,52 +43,16 @@ class FioRandTest():
             f"--output={self.filenames['output']}",
         ]
         for opt in ['randseed', 'randrepeat', 'allrandrepeat']:
-            if opt in self.test_options:
-                option = f"--{opt}={self.test_options[opt]}"
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
                 fio_args.append(option)
 
-        command = [fio_path] + fio_args
-        with open(self.filenames['command'], "w+", encoding=locale.getpreferredencoding()) as command_file:
-            command_file.write(" ".join(command))
-
-        passed = True
-
-        try:
-            with open(self.filenames['stdout'], "w+", encoding=locale.getpreferredencoding()) as stdout_file, \
-                open(self.filenames['stderr'], "w+", encoding=locale.getpreferredencoding()) as stderr_file, \
-                open(self.filenames['exitcode'], "w+", encoding=locale.getpreferredencoding()) as exitcode_file:
-                proc = None
-                # Avoid using subprocess.run() here because when a timeout occurs,
-                # fio will be stopped with SIGKILL. This does not give fio a
-                # chance to clean up and means that child processes may continue
-                # running and submitting IO.
-                proc = subprocess.Popen(command,
-                                        stdout=stdout_file,
-                                        stderr=stderr_file,
-                                        cwd=self.test_dir,
-                                        universal_newlines=True)
-                proc.communicate(timeout=300)
-                exitcode_file.write(f'{proc.returncode}\n')
-                passed &= (proc.returncode == 0)
-        except subprocess.TimeoutExpired:
-            proc.terminate()
-            proc.communicate()
-            assert proc.poll()
-            print("Timeout expired")
-            passed = False
-        except Exception:
-            if proc:
-                if not proc.poll():
-                    proc.terminate()
-                    proc.communicate()
-            print(f"Exception: {sys.exc_info()}")
-            passed = False
-
-        return passed
+        super().setup(fio_args)
 
     def get_rand_seeds(self):
         """Collect random seeds from --debug=random output."""
-        with open(self.filenames['output'], "r", encoding=locale.getpreferredencoding()) as out_file:
+        with open(self.filenames['output'], "r",
+                  encoding=locale.getpreferredencoding()) as out_file:
             file_data = out_file.read()
 
             offsets = 0
@@ -136,11 +78,6 @@ class FioRandTest():
 
             return seed_list
 
-    def check(self):
-        """Check test output."""
-
-        raise NotImplementedError()
-
 
 class TestRR(FioRandTest):
     """
@@ -151,41 +88,35 @@ class TestRR(FioRandTest):
     # one set of seeds is for randrepeat=0 and the other is for randrepeat=1
     seeds = { 0: None, 1: None }
 
-    def check(self):
+    def check_result(self):
         """Check output for allrandrepeat=1."""
 
-        retval = True
-        opt = 'randrepeat' if 'randrepeat' in self.test_options else 'allrandrepeat'
-        rr = self.test_options[opt]
+        opt = 'randrepeat' if 'randrepeat' in self.fio_opts else 'allrandrepeat'
+        rr = self.fio_opts[opt]
         rand_seeds = self.get_rand_seeds()
 
         if not TestRR.seeds[rr]:
             TestRR.seeds[rr] = rand_seeds
-            if self.debug:
-                print(f"TestRR: saving rand_seeds for [a]rr={rr}")
+            logging.debug("TestRR: saving rand_seeds for [a]rr=%d", rr)
         else:
             if rr:
                 if TestRR.seeds[1] != rand_seeds:
-                    retval = False
+                    self.passed = False
                     print(f"TestRR: unexpected seed mismatch for [a]rr={rr}")
                 else:
-                    if self.debug:
-                        print(f"TestRR: seeds correctly match for [a]rr={rr}")
+                    logging.debug("TestRR: seeds correctly match for [a]rr=%d", rr)
                 if TestRR.seeds[0] == rand_seeds:
-                    retval = False
+                    self.passed = False
                     print("TestRR: seeds unexpectedly match those from system RNG")
             else:
                 if TestRR.seeds[0] == rand_seeds:
-                    retval = False
+                    self.passed = False
                     print(f"TestRR: unexpected seed match for [a]rr={rr}")
                 else:
-                    if self.debug:
-                        print(f"TestRR: seeds correctly don't match for [a]rr={rr}")
+                    logging.debug("TestRR: seeds correctly don't match for [a]rr=%d", rr)
                 if TestRR.seeds[1] == rand_seeds:
-                    retval = False
-                    print(f"TestRR: random seeds unexpectedly match those from [a]rr=1")
-
-        return retval
+                    self.passed = False
+                    print("TestRR: random seeds unexpectedly match those from [a]rr=1")
 
 
 class TestRS(FioRandTest):
@@ -197,40 +128,33 @@ class TestRS(FioRandTest):
     """
     seeds = {}
 
-    def check(self):
+    def check_result(self):
         """Check output for randseed=something."""
 
-        retval = True
         rand_seeds = self.get_rand_seeds()
-        randseed = self.test_options['randseed']
+        randseed = self.fio_opts['randseed']
 
-        if self.debug:
-            print("randseed = ", randseed)
+        logging.debug("randseed = %s", randseed)
 
         if randseed not in TestRS.seeds:
             TestRS.seeds[randseed] = rand_seeds
-            if self.debug:
-                print("TestRS: saving rand_seeds")
+            logging.debug("TestRS: saving rand_seeds")
         else:
             if TestRS.seeds[randseed] != rand_seeds:
-                retval = False
+                self.passed = False
                 print("TestRS: seeds don't match when they should")
             else:
-                if self.debug:
-                    print("TestRS: seeds correctly match")
+                logging.debug("TestRS: seeds correctly match")
 
         # Now try to find seeds generated using a different randseed and make
         # sure they *don't* match
-        for key in TestRS.seeds:
+        for key, value in TestRS.seeds.items():
             if key != randseed:
-                if TestRS.seeds[key] == rand_seeds:
-                    retval = False
+                if value == rand_seeds:
+                    self.passed = False
                     print("TestRS: randseeds differ but generated seeds match.")
                 else:
-                    if self.debug:
-                        print("TestRS: randseeds differ and generated seeds also differ.")
-
-        return retval
+                    logging.debug("TestRS: randseeds differ and generated seeds also differ.")
 
 
 def parse_args():
@@ -254,139 +178,161 @@ def main():
 
     args = parse_args()
 
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
     artifact_root = args.artifact_root if args.artifact_root else \
         f"random-seed-test-{time.strftime('%Y%m%d-%H%M%S')}"
     os.mkdir(artifact_root)
     print(f"Artifact directory is {artifact_root}")
 
     if args.fio:
-        fio = str(Path(args.fio).absolute())
+        fio_path = str(Path(args.fio).absolute())
     else:
-        fio = 'fio'
-    print(f"fio path is {fio}")
+        fio_path = 'fio'
+    print(f"fio path is {fio_path}")
 
     test_list = [
         {
             "test_id": 1,
-            "randrepeat": 0,
-            "test_obj": TestRR,
+            "fio_opts": {
+                "randrepeat": 0,
+                },
+            "test_class": TestRR,
         },
         {
             "test_id": 2,
-            "randrepeat": 0,
-            "test_obj": TestRR,
+            "fio_opts": {
+                "randrepeat": 0,
+                },
+            "test_class": TestRR,
         },
         {
             "test_id": 3,
-            "randrepeat": 1,
-            "test_obj": TestRR,
+            "fio_opts": {
+                "randrepeat": 1,
+                },
+            "test_class": TestRR,
         },
         {
             "test_id": 4,
-            "randrepeat": 1,
-            "test_obj": TestRR,
+            "fio_opts": {
+                "randrepeat": 1,
+                },
+            "test_class": TestRR,
         },
         {
             "test_id": 5,
-            "allrandrepeat": 0,
-            "test_obj": TestRR,
+            "fio_opts": {
+                "allrandrepeat": 0,
+                },
+            "test_class": TestRR,
         },
         {
             "test_id": 6,
-            "allrandrepeat": 0,
-            "test_obj": TestRR,
+            "fio_opts": {
+                "allrandrepeat": 0,
+                },
+            "test_class": TestRR,
         },
         {
             "test_id": 7,
-            "allrandrepeat": 1,
-            "test_obj": TestRR,
+            "fio_opts": {
+                "allrandrepeat": 1,
+                },
+            "test_class": TestRR,
         },
         {
             "test_id": 8,
-            "allrandrepeat": 1,
-            "test_obj": TestRR,
+            "fio_opts": {
+                "allrandrepeat": 1,
+                },
+            "test_class": TestRR,
         },
         {
             "test_id": 9,
-            "randrepeat": 0,
-            "randseed": "12345",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "randrepeat": 0,
+                "randseed": "12345",
+                },
+            "test_class": TestRS,
         },
         {
             "test_id": 10,
-            "randrepeat": 0,
-            "randseed": "12345",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "randrepeat": 0,
+                "randseed": "12345",
+                },
+            "test_class": TestRS,
         },
         {
             "test_id": 11,
-            "randrepeat": 1,
-            "randseed": "12345",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "randrepeat": 1,
+                "randseed": "12345",
+                },
+            "test_class": TestRS,
         },
         {
             "test_id": 12,
-            "allrandrepeat": 0,
-            "randseed": "12345",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "allrandrepeat": 0,
+                "randseed": "12345",
+                },
+            "test_class": TestRS,
         },
         {
             "test_id": 13,
-            "allrandrepeat": 1,
-            "randseed": "12345",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "allrandrepeat": 1,
+                "randseed": "12345",
+                },
+            "test_class": TestRS,
         },
         {
             "test_id": 14,
-            "randrepeat": 0,
-            "randseed": "67890",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "randrepeat": 0,
+                "randseed": "67890",
+                },
+            "test_class": TestRS,
         },
         {
             "test_id": 15,
-            "randrepeat": 1,
-            "randseed": "67890",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "randrepeat": 1,
+                "randseed": "67890",
+                },
+            "test_class": TestRS,
         },
         {
             "test_id": 16,
-            "allrandrepeat": 0,
-            "randseed": "67890",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "allrandrepeat": 0,
+                "randseed": "67890",
+                },
+            "test_class": TestRS,
         },
         {
             "test_id": 17,
-            "allrandrepeat": 1,
-            "randseed": "67890",
-            "test_obj": TestRS,
+            "fio_opts": {
+                "allrandrepeat": 1,
+                "randseed": "67890",
+                },
+            "test_class": TestRS,
         },
     ]
 
-    passed = 0
-    failed = 0
-    skipped = 0
-
-    for test in test_list:
-        if (args.skip and test['test_id'] in args.skip) or \
-           (args.run_only and test['test_id'] not in args.run_only):
-            skipped = skipped + 1
-            outcome = 'SKIPPED (User request)'
-        else:
-            test_obj = test['test_obj'](artifact_root, test, args.debug)
-            status = test_obj.run_fio(fio)
-            if status:
-                status = test_obj.check()
-            if status:
-                passed = passed + 1
-                outcome = 'PASSED'
-            else:
-                failed = failed + 1
-                outcome = 'FAILED'
-
-        print(f"**********Test {test['test_id']} {outcome}**********")
-
-    print(f"{passed} tests passed, {failed} failed, {skipped} skipped")
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'random',
+              }
 
+    _, failed, _ = run_fio_tests(test_list, test_env, args)
     sys.exit(failed)
 
 
diff --git a/t/readonly.py b/t/readonly.py
index 80fac639..d36faafa 100755
--- a/t/readonly.py
+++ b/t/readonly.py
@@ -2,8 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
 # Copyright (c) 2019 Western Digital Corporation or its affiliates.
-#
-#
+
+"""
 # readonly.py
 #
 # Do some basic tests of the --readonly parameter
@@ -18,122 +18,144 @@
 # REQUIREMENTS
 # Python 3.5+
 #
-#
+"""
 
+import os
 import sys
+import time
 import argparse
-import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_DEFAULT, SUCCESS_NONZERO
+
+
+class FioReadOnlyTest(FioJobCmdTest):
+    """fio read only test."""
+
+    def setup(self, parameters):
+        """Setup the test."""
+
+        fio_args = [
+                    "--name=readonly",
+                    "--ioengine=null",
+                    "--time_based",
+                    "--runtime=1s",
+                    "--size=1M",
+                    f"--rw={self.fio_opts['rw']}",
+                   ]
+        if 'readonly-pre' in parameters:
+            fio_args.insert(0, "--readonly")
+        if 'readonly-post' in parameters:
+            fio_args.append("--readonly")
+
+        super().setup(fio_args)
+
+
+TEST_LIST = [
+            {
+                "test_id": 1,
+                "fio_opts": { "rw": "randread", },
+                "readonly-pre": 1,
+                "success": SUCCESS_DEFAULT,
+                "test_class": FioReadOnlyTest,
+            },
+            {
+                "test_id": 2,
+                "fio_opts": { "rw": "randwrite", },
+                "readonly-pre": 1,
+                "success": SUCCESS_NONZERO,
+                "test_class": FioReadOnlyTest,
+            },
+            {
+                "test_id": 3,
+                "fio_opts": { "rw": "randtrim", },
+                "readonly-pre": 1,
+                "success": SUCCESS_NONZERO,
+                "test_class": FioReadOnlyTest,
+            },
+            {
+                "test_id": 4,
+                "fio_opts": { "rw": "randread", },
+                "readonly-post": 1,
+                "success": SUCCESS_DEFAULT,
+                "test_class": FioReadOnlyTest,
+            },
+            {
+                "test_id": 5,
+                "fio_opts": { "rw": "randwrite", },
+                "readonly-post": 1,
+                "success": SUCCESS_NONZERO,
+                "test_class": FioReadOnlyTest,
+            },
+            {
+                "test_id": 6,
+                "fio_opts": { "rw": "randtrim", },
+                "readonly-post": 1,
+                "success": SUCCESS_NONZERO,
+                "test_class": FioReadOnlyTest,
+            },
+            {
+                "test_id": 7,
+                "fio_opts": { "rw": "randread", },
+                "success": SUCCESS_DEFAULT,
+                "test_class": FioReadOnlyTest,
+            },
+            {
+                "test_id": 8,
+                "fio_opts": { "rw": "randwrite", },
+                "success": SUCCESS_DEFAULT,
+                "test_class": FioReadOnlyTest,
+            },
+            {
+                "test_id": 9,
+                "fio_opts": { "rw": "randtrim", },
+                "success": SUCCESS_DEFAULT,
+                "test_class": FioReadOnlyTest,
+            },
+        ]
 
 
 def parse_args():
+    """Parse command-line arguments."""
+
     parser = argparse.ArgumentParser()
-    parser.add_argument('-f', '--fio',
-                        help='path to fio executable (e.g., ./fio)')
+    parser.add_argument('-f', '--fio', help='path to fio executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
     args = parser.parse_args()
 
     return args
 
 
-def run_fio(fio, test, index):
-    fio_args = [
-                "--max-jobs=16",
-                "--name=readonly",
-                "--ioengine=null",
-                "--time_based",
-                "--runtime=1s",
-                "--size=1M",
-                "--rw={rw}".format(**test),
-               ]
-    if 'readonly-pre' in test:
-        fio_args.insert(0, "--readonly")
-    if 'readonly-post' in test:
-        fio_args.append("--readonly")
-
-    output = subprocess.run([fio] + fio_args, stdout=subprocess.PIPE,
-                            stderr=subprocess.PIPE)
-
-    return output
-
-
-def check_output(output, test):
-    expect_error = False
-    if 'readonly-pre' in test or 'readonly-post' in test:
-        if 'write' in test['rw'] or 'trim' in test['rw']:
-            expect_error = True
-
-#    print(output.stdout)
-#    print(output.stderr)
-
-    if output.returncode == 0:
-        if expect_error:
-            return False
-        else:
-            return True
-    else:
-        if expect_error:
-            return True
-        else:
-            return False
-
+def main():
+    """Run readonly tests."""
 
-if __name__ == '__main__':
     args = parse_args()
 
-    tests = [
-                {
-                    "rw": "randread",
-                    "readonly-pre": 1,
-                },
-                {
-                    "rw": "randwrite",
-                    "readonly-pre": 1,
-                },
-                {
-                    "rw": "randtrim",
-                    "readonly-pre": 1,
-                },
-                {
-                    "rw": "randread",
-                    "readonly-post": 1,
-                },
-                {
-                    "rw": "randwrite",
-                    "readonly-post": 1,
-                },
-                {
-                    "rw": "randtrim",
-                    "readonly-post": 1,
-                },
-                {
-                    "rw": "randread",
-                },
-                {
-                    "rw": "randwrite",
-                },
-                {
-                    "rw": "randtrim",
-                },
-            ]
-
-    index = 1
-    passed = 0
-    failed = 0
-
     if args.fio:
-        fio_path = args.fio
+        fio_path = str(Path(args.fio).absolute())
     else:
         fio_path = 'fio'
+    print(f"fio path is {fio_path}")
 
-    for test in tests:
-        output = run_fio(fio_path, test, index)
-        status = check_output(output, test)
-        print("Test {0} {1}".format(index, ("PASSED" if status else "FAILED")))
-        if status:
-            passed = passed + 1
-        else:
-            failed = failed + 1
-        index = index + 1
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"readonly-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
 
-    print("{0} tests passed, {1} failed".format(passed, failed))
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'readonly',
+              }
 
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
     sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index c91deed4..1448f7cb 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -43,298 +43,17 @@
 
 import os
 import sys
-import json
 import time
 import shutil
 import logging
 import argparse
-import platform
-import traceback
-import subprocess
-import multiprocessing
 from pathlib import Path
 from statsmodels.sandbox.stats.runs import runstest_1samp
+from fiotestlib import FioExeTest, FioJobFileTest, run_fio_tests
+from fiotestcommon import *
 
 
-class FioTest():
-    """Base for all fio tests."""
-
-    def __init__(self, exe_path, parameters, success):
-        self.exe_path = exe_path
-        self.parameters = parameters
-        self.success = success
-        self.output = {}
-        self.artifact_root = None
-        self.testnum = None
-        self.test_dir = None
-        self.passed = True
-        self.failure_reason = ''
-        self.command_file = None
-        self.stdout_file = None
-        self.stderr_file = None
-        self.exitcode_file = None
-
-    def setup(self, artifact_root, testnum):
-        """Setup instance variables for test."""
-
-        self.artifact_root = artifact_root
-        self.testnum = testnum
-        self.test_dir = os.path.join(artifact_root, f"{testnum:04d}")
-        if not os.path.exists(self.test_dir):
-            os.mkdir(self.test_dir)
-
-        self.command_file = os.path.join(
-            self.test_dir,
-            f"{os.path.basename(self.exe_path)}.command")
-        self.stdout_file = os.path.join(
-            self.test_dir,
-            f"{os.path.basename(self.exe_path)}.stdout")
-        self.stderr_file = os.path.join(
-            self.test_dir,
-            f"{os.path.basename(self.exe_path)}.stderr")
-        self.exitcode_file = os.path.join(
-            self.test_dir,
-            f"{os.path.basename(self.exe_path)}.exitcode")
-
-    def run(self):
-        """Run the test."""
-
-        raise NotImplementedError()
-
-    def check_result(self):
-        """Check test results."""
-
-        raise NotImplementedError()
-
-
-class FioExeTest(FioTest):
-    """Test consists of an executable binary or script"""
-
-    def __init__(self, exe_path, parameters, success):
-        """Construct a FioExeTest which is a FioTest consisting of an
-        executable binary or script.
-
-        exe_path:       location of executable binary or script
-        parameters:     list of parameters for executable
-        success:        Definition of test success
-        """
-
-        FioTest.__init__(self, exe_path, parameters, success)
-
-    def run(self):
-        """Execute the binary or script described by this instance."""
-
-        command = [self.exe_path] + self.parameters
-        command_file = open(self.command_file, "w+")
-        command_file.write(f"{command}\n")
-        command_file.close()
-
-        stdout_file = open(self.stdout_file, "w+")
-        stderr_file = open(self.stderr_file, "w+")
-        exitcode_file = open(self.exitcode_file, "w+")
-        try:
-            proc = None
-            # Avoid using subprocess.run() here because when a timeout occurs,
-            # fio will be stopped with SIGKILL. This does not give fio a
-            # chance to clean up and means that child processes may continue
-            # running and submitting IO.
-            proc = subprocess.Popen(command,
-                                    stdout=stdout_file,
-                                    stderr=stderr_file,
-                                    cwd=self.test_dir,
-                                    universal_newlines=True)
-            proc.communicate(timeout=self.success['timeout'])
-            exitcode_file.write(f'{proc.returncode}\n')
-            logging.debug("Test %d: return code: %d", self.testnum, proc.returncode)
-            self.output['proc'] = proc
-        except subprocess.TimeoutExpired:
-            proc.terminate()
-            proc.communicate()
-            assert proc.poll()
-            self.output['failure'] = 'timeout'
-        except Exception:
-            if proc:
-                if not proc.poll():
-                    proc.terminate()
-                    proc.communicate()
-            self.output['failure'] = 'exception'
-            self.output['exc_info'] = sys.exc_info()
-        finally:
-            stdout_file.close()
-            stderr_file.close()
-            exitcode_file.close()
-
-    def check_result(self):
-        """Check results of test run."""
-
-        if 'proc' not in self.output:
-            if self.output['failure'] == 'timeout':
-                self.failure_reason = f"{self.failure_reason} timeout,"
-            else:
-                assert self.output['failure'] == 'exception'
-                self.failure_reason = '{0} exception: {1}, {2}'.format(
-                    self.failure_reason, self.output['exc_info'][0],
-                    self.output['exc_info'][1])
-
-            self.passed = False
-            return
-
-        if 'zero_return' in self.success:
-            if self.success['zero_return']:
-                if self.output['proc'].returncode != 0:
-                    self.passed = False
-                    self.failure_reason = f"{self.failure_reason} non-zero return code,"
-            else:
-                if self.output['proc'].returncode == 0:
-                    self.failure_reason = f"{self.failure_reason} zero return code,"
-                    self.passed = False
-
-        stderr_size = os.path.getsize(self.stderr_file)
-        if 'stderr_empty' in self.success:
-            if self.success['stderr_empty']:
-                if stderr_size != 0:
-                    self.failure_reason = f"{self.failure_reason} stderr not empty,"
-                    self.passed = False
-            else:
-                if stderr_size == 0:
-                    self.failure_reason = f"{self.failure_reason} stderr empty,"
-                    self.passed = False
-
-
-class FioJobTest(FioExeTest):
-    """Test consists of a fio job"""
-
-    def __init__(self, fio_path, fio_job, success, fio_pre_job=None,
-                 fio_pre_success=None, output_format="normal"):
-        """Construct a FioJobTest which is a FioExeTest consisting of a
-        single fio job file with an optional setup step.
-
-        fio_path:           location of fio executable
-        fio_job:            location of fio job file
-        success:            Definition of test success
-        fio_pre_job:        fio job for preconditioning
-        fio_pre_success:    Definition of test success for fio precon job
-        output_format:      normal (default), json, jsonplus, or terse
-        """
-
-        self.fio_job = fio_job
-        self.fio_pre_job = fio_pre_job
-        self.fio_pre_success = fio_pre_success if fio_pre_success else success
-        self.output_format = output_format
-        self.precon_failed = False
-        self.json_data = None
-        self.fio_output = f"{os.path.basename(self.fio_job)}.output"
-        self.fio_args = [
-            "--max-jobs=16",
-            f"--output-format={self.output_format}",
-            f"--output={self.fio_output}",
-            self.fio_job,
-            ]
-        FioExeTest.__init__(self, fio_path, self.fio_args, success)
-
-    def setup(self, artifact_root, testnum):
-        """Setup instance variables for fio job test."""
-
-        super().setup(artifact_root, testnum)
-
-        self.command_file = os.path.join(
-            self.test_dir,
-            f"{os.path.basename(self.fio_job)}.command")
-        self.stdout_file = os.path.join(
-            self.test_dir,
-            f"{os.path.basename(self.fio_job)}.stdout")
-        self.stderr_file = os.path.join(
-            self.test_dir,
-            f"{os.path.basename(self.fio_job)}.stderr")
-        self.exitcode_file = os.path.join(
-            self.test_dir,
-            f"{os.path.basename(self.fio_job)}.exitcode")
-
-    def run_pre_job(self):
-        """Run fio job precondition step."""
-
-        precon = FioJobTest(self.exe_path, self.fio_pre_job,
-                            self.fio_pre_success,
-                            output_format=self.output_format)
-        precon.setup(self.artifact_root, self.testnum)
-        precon.run()
-        precon.check_result()
-        self.precon_failed = not precon.passed
-        self.failure_reason = precon.failure_reason
-
-    def run(self):
-        """Run fio job test."""
-
-        if self.fio_pre_job:
-            self.run_pre_job()
-
-        if not self.precon_failed:
-            super().run()
-        else:
-            logging.debug("Test %d: precondition step failed", self.testnum)
-
-    @classmethod
-    def get_file(cls, filename):
-        """Safely read a file."""
-        file_data = ''
-        success = True
-
-        try:
-            with open(filename, "r") as output_file:
-                file_data = output_file.read()
-        except OSError:
-            success = False
-
-        return file_data, success
-
-    def get_file_fail(self, filename):
-        """Safely read a file and fail the test upon error."""
-        file_data = None
-
-        try:
-            with open(filename, "r") as output_file:
-                file_data = output_file.read()
-        except OSError:
-            self.failure_reason += f" unable to read file {filename}"
-            self.passed = False
-
-        return file_data
-
-    def check_result(self):
-        """Check fio job results."""
-
-        if self.precon_failed:
-            self.passed = False
-            self.failure_reason = f"{self.failure_reason} precondition step failed,"
-            return
-
-        super().check_result()
-
-        if not self.passed:
-            return
-
-        if 'json' not in self.output_format:
-            return
-
-        file_data = self.get_file_fail(os.path.join(self.test_dir, self.fio_output))
-        if not file_data:
-            return
-
-        #
-        # Sometimes fio informational messages are included at the top of the
-        # JSON output, especially under Windows. Try to decode output as JSON
-        # data, skipping everything until the first {
-        #
-        lines = file_data.splitlines()
-        file_data = '\n'.join(lines[lines.index("{"):])
-        try:
-            self.json_data = json.loads(file_data)
-        except json.JSONDecodeError:
-            self.failure_reason = f"{self.failure_reason} unable to decode JSON data,"
-            self.passed = False
-
-
-class FioJobTest_t0005(FioJobTest):
+class FioJobFileTest_t0005(FioJobFileTest):
     """Test consists of fio test job t0005
     Confirm that read['io_kbytes'] == write['io_kbytes'] == 102400"""
 
@@ -352,7 +71,7 @@ class FioJobTest_t0005(FioJobTest):
             self.passed = False
 
 
-class FioJobTest_t0006(FioJobTest):
+class FioJobFileTest_t0006(FioJobFileTest):
     """Test consists of fio test job t0006
     Confirm that read['io_kbytes'] ~ 2*write['io_kbytes']"""
 
@@ -370,7 +89,7 @@ class FioJobTest_t0006(FioJobTest):
             self.passed = False
 
 
-class FioJobTest_t0007(FioJobTest):
+class FioJobFileTest_t0007(FioJobFileTest):
     """Test consists of fio test job t0007
     Confirm that read['io_kbytes'] = 87040"""
 
@@ -385,7 +104,7 @@ class FioJobTest_t0007(FioJobTest):
             self.passed = False
 
 
-class FioJobTest_t0008(FioJobTest):
+class FioJobFileTest_t0008(FioJobFileTest):
     """Test consists of fio test job t0008
     Confirm that read['io_kbytes'] = 32768 and that
                 write['io_kbytes'] ~ 16384
@@ -413,7 +132,7 @@ class FioJobTest_t0008(FioJobTest):
             self.passed = False
 
 
-class FioJobTest_t0009(FioJobTest):
+class FioJobFileTest_t0009(FioJobFileTest):
     """Test consists of fio test job t0009
     Confirm that runtime >= 60s"""
 
@@ -430,7 +149,7 @@ class FioJobTest_t0009(FioJobTest):
             self.passed = False
 
 
-class FioJobTest_t0012(FioJobTest):
+class FioJobFileTest_t0012(FioJobFileTest):
     """Test consists of fio test job t0012
     Confirm ratios of job iops are 1:5:10
     job1,job2,job3 respectively"""
@@ -443,7 +162,7 @@ class FioJobTest_t0012(FioJobTest):
 
         iops_files = []
         for i in range(1, 4):
-            filename = os.path.join(self.test_dir, "{0}_iops.{1}.log".format(os.path.basename(
+            filename = os.path.join(self.paths['test_dir'], "{0}_iops.{1}.log".format(os.path.basename(
                 self.fio_job), i))
             file_data = self.get_file_fail(filename)
             if not file_data:
@@ -475,7 +194,7 @@ class FioJobTest_t0012(FioJobTest):
             return
 
 
-class FioJobTest_t0014(FioJobTest):
+class FioJobFileTest_t0014(FioJobFileTest):
     """Test consists of fio test job t0014
 	Confirm that job1_iops / job2_iops ~ 1:2 for entire duration
 	and that job1_iops / job3_iops ~ 1:3 for first half of duration.
@@ -491,7 +210,7 @@ class FioJobTest_t0014(FioJobTest):
 
         iops_files = []
         for i in range(1, 4):
-            filename = os.path.join(self.test_dir, "{0}_iops.{1}.log".format(os.path.basename(
+            filename = os.path.join(self.paths['test_dir'], "{0}_iops.{1}.log".format(os.path.basename(
                 self.fio_job), i))
             file_data = self.get_file_fail(filename)
             if not file_data:
@@ -534,7 +253,7 @@ class FioJobTest_t0014(FioJobTest):
             return
 
 
-class FioJobTest_t0015(FioJobTest):
+class FioJobFileTest_t0015(FioJobFileTest):
     """Test consists of fio test jobs t0015 and t0016
     Confirm that mean(slat) + mean(clat) = mean(tlat)"""
 
@@ -555,14 +274,14 @@ class FioJobTest_t0015(FioJobTest):
             self.passed = False
 
 
-class FioJobTest_t0019(FioJobTest):
+class FioJobFileTest_t0019(FioJobFileTest):
     """Test consists of fio test job t0019
     Confirm that all offsets were touched sequentially"""
 
     def check_result(self):
         super().check_result()
 
-        bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
+        bw_log_filename = os.path.join(self.paths['test_dir'], "test_bw.log")
         file_data = self.get_file_fail(bw_log_filename)
         if not file_data:
             return
@@ -585,14 +304,14 @@ class FioJobTest_t0019(FioJobTest):
             self.failure_reason = f"unexpected last offset {cur}"
 
 
-class FioJobTest_t0020(FioJobTest):
+class FioJobFileTest_t0020(FioJobFileTest):
     """Test consists of fio test jobs t0020 and t0021
     Confirm that almost all offsets were touched non-sequentially"""
 
     def check_result(self):
         super().check_result()
 
-        bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
+        bw_log_filename = os.path.join(self.paths['test_dir'], "test_bw.log")
         file_data = self.get_file_fail(bw_log_filename)
         if not file_data:
             return
@@ -624,13 +343,13 @@ class FioJobTest_t0020(FioJobTest):
             self.failure_reason += f" runs test failed with p = {p}"
 
 
-class FioJobTest_t0022(FioJobTest):
+class FioJobFileTest_t0022(FioJobFileTest):
     """Test consists of fio test job t0022"""
 
     def check_result(self):
         super().check_result()
 
-        bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
+        bw_log_filename = os.path.join(self.paths['test_dir'], "test_bw.log")
         file_data = self.get_file_fail(bw_log_filename)
         if not file_data:
             return
@@ -662,13 +381,13 @@ class FioJobTest_t0022(FioJobTest):
             self.failure_reason += " no duplicate offsets found with norandommap=1"
 
 
-class FioJobTest_t0023(FioJobTest):
+class FioJobFileTest_t0023(FioJobFileTest):
     """Test consists of fio test job t0023 randtrimwrite test."""
 
     def check_trimwrite(self, filename):
         """Make sure that trims are followed by writes of the same size at the same offset."""
 
-        bw_log_filename = os.path.join(self.test_dir, filename)
+        bw_log_filename = os.path.join(self.paths['test_dir'], filename)
         file_data = self.get_file_fail(bw_log_filename)
         if not file_data:
             return
@@ -716,7 +435,7 @@ class FioJobTest_t0023(FioJobTest):
     def check_all_offsets(self, filename, sectorsize, filesize):
         """Make sure all offsets were touched."""
 
-        file_data = self.get_file_fail(os.path.join(self.test_dir, filename))
+        file_data = self.get_file_fail(os.path.join(self.paths['test_dir'], filename))
         if not file_data:
             return
 
@@ -771,12 +490,12 @@ class FioJobTest_t0023(FioJobTest):
         self.check_all_offsets("bssplit_bw.log", 512, filesize)
 
 
-class FioJobTest_t0024(FioJobTest_t0023):
+class FioJobFileTest_t0024(FioJobFileTest_t0023):
     """Test consists of fio test job t0024 trimwrite test."""
 
     def check_result(self):
-        # call FioJobTest_t0023's parent to skip checks done by t0023
-        super(FioJobTest_t0023, self).check_result()
+        # call FioJobFileTest_t0023's parent to skip checks done by t0023
+        super(FioJobFileTest_t0023, self).check_result()
 
         filesize = 1024*1024
 
@@ -791,7 +510,7 @@ class FioJobTest_t0024(FioJobTest_t0023):
         self.check_all_offsets("bssplit_bw.log", 512, filesize)
 
 
-class FioJobTest_t0025(FioJobTest):
+class FioJobFileTest_t0025(FioJobFileTest):
     """Test experimental verify read backs written data pattern."""
     def check_result(self):
         super().check_result()
@@ -802,11 +521,11 @@ class FioJobTest_t0025(FioJobTest):
         if self.json_data['jobs'][0]['read']['io_kbytes'] != 128:
             self.passed = False
 
-class FioJobTest_t0027(FioJobTest):
+class FioJobFileTest_t0027(FioJobFileTest):
     def setup(self, *args, **kws):
         super().setup(*args, **kws)
-        self.pattern_file = os.path.join(self.test_dir, "t0027.pattern")
-        self.output_file = os.path.join(self.test_dir, "t0027file")
+        self.pattern_file = os.path.join(self.paths['test_dir'], "t0027.pattern")
+        self.output_file = os.path.join(self.paths['test_dir'], "t0027file")
         self.pattern = os.urandom(16 << 10)
         with open(self.pattern_file, "wb") as f:
             f.write(self.pattern)
@@ -823,7 +542,7 @@ class FioJobTest_t0027(FioJobTest):
         if data != self.pattern:
             self.passed = False
 
-class FioJobTest_iops_rate(FioJobTest):
+class FioJobFileTest_iops_rate(FioJobFileTest):
     """Test consists of fio test job t0011
     Confirm that job0 iops == 1000
     and that job1_iops / job0_iops ~ 8
@@ -851,156 +570,10 @@ class FioJobTest_iops_rate(FioJobTest):
             self.passed = False
 
 
-class Requirements():
-    """Requirements consists of multiple run environment characteristics.
-    These are to determine if a particular test can be run"""
-
-    _linux = False
-    _libaio = False
-    _io_uring = False
-    _zbd = False
-    _root = False
-    _zoned_nullb = False
-    _not_macos = False
-    _not_windows = False
-    _unittests = False
-    _cpucount4 = False
-    _nvmecdev = False
-
-    def __init__(self, fio_root, args):
-        Requirements._not_macos = platform.system() != "Darwin"
-        Requirements._not_windows = platform.system() != "Windows"
-        Requirements._linux = platform.system() == "Linux"
-
-        if Requirements._linux:
-            config_file = os.path.join(fio_root, "config-host.h")
-            contents, success = FioJobTest.get_file(config_file)
-            if not success:
-                print(f"Unable to open {config_file} to check requirements")
-                Requirements._zbd = True
-            else:
-                Requirements._zbd = "CONFIG_HAS_BLKZONED" in contents
-                Requirements._libaio = "CONFIG_LIBAIO" in contents
-
-            contents, success = FioJobTest.get_file("/proc/kallsyms")
-            if not success:
-                print("Unable to open '/proc/kallsyms' to probe for io_uring support")
-            else:
-                Requirements._io_uring = "io_uring_setup" in contents
-
-            Requirements._root = os.geteuid() == 0
-            if Requirements._zbd and Requirements._root:
-                try:
-                    subprocess.run(["modprobe", "null_blk"],
-                                   stdout=subprocess.PIPE,
-                                   stderr=subprocess.PIPE)
-                    if os.path.exists("/sys/module/null_blk/parameters/zoned"):
-                        Requirements._zoned_nullb = True
-                except Exception:
-                    pass
-
-        if platform.system() == "Windows":
-            utest_exe = "unittest.exe"
-        else:
-            utest_exe = "unittest"
-        unittest_path = os.path.join(fio_root, "unittests", utest_exe)
-        Requirements._unittests = os.path.exists(unittest_path)
-
-        Requirements._cpucount4 = multiprocessing.cpu_count() >= 4
-        Requirements._nvmecdev = args.nvmecdev
-
-        req_list = [
-                Requirements.linux,
-                Requirements.libaio,
-                Requirements.io_uring,
-                Requirements.zbd,
-                Requirements.root,
-                Requirements.zoned_nullb,
-                Requirements.not_macos,
-                Requirements.not_windows,
-                Requirements.unittests,
-                Requirements.cpucount4,
-                Requirements.nvmecdev,
-                    ]
-        for req in req_list:
-            value, desc = req()
-            logging.debug("Requirements: Requirement '%s' met? %s", desc, value)
-
-    @classmethod
-    def linux(cls):
-        """Are we running on Linux?"""
-        return Requirements._linux, "Linux required"
-
-    @classmethod
-    def libaio(cls):
-        """Is libaio available?"""
-        return Requirements._libaio, "libaio required"
-
-    @classmethod
-    def io_uring(cls):
-        """Is io_uring available?"""
-        return Requirements._io_uring, "io_uring required"
-
-    @classmethod
-    def zbd(cls):
-        """Is ZBD support available?"""
-        return Requirements._zbd, "Zoned block device support required"
-
-    @classmethod
-    def root(cls):
-        """Are we running as root?"""
-        return Requirements._root, "root required"
-
-    @classmethod
-    def zoned_nullb(cls):
-        """Are zoned null block devices available?"""
-        return Requirements._zoned_nullb, "Zoned null block device support required"
-
-    @classmethod
-    def not_macos(cls):
-        """Are we running on a platform other than macOS?"""
-        return Requirements._not_macos, "platform other than macOS required"
-
-    @classmethod
-    def not_windows(cls):
-        """Are we running on a platform other than Windws?"""
-        return Requirements._not_windows, "platform other than Windows required"
-
-    @classmethod
-    def unittests(cls):
-        """Were unittests built?"""
-        return Requirements._unittests, "Unittests support required"
-
-    @classmethod
-    def cpucount4(cls):
-        """Do we have at least 4 CPUs?"""
-        return Requirements._cpucount4, "4+ CPUs required"
-
-    @classmethod
-    def nvmecdev(cls):
-        """Do we have an NVMe character device to test?"""
-        return Requirements._nvmecdev, "NVMe character device test target required"
-
-
-SUCCESS_DEFAULT = {
-    'zero_return': True,
-    'stderr_empty': True,
-    'timeout': 600,
-    }
-SUCCESS_NONZERO = {
-    'zero_return': False,
-    'stderr_empty': False,
-    'timeout': 600,
-    }
-SUCCESS_STDERR = {
-    'zero_return': True,
-    'stderr_empty': False,
-    'timeout': 600,
-    }
 TEST_LIST = [
     {
         'test_id':          1,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0001-52c58027.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1009,7 +582,7 @@ TEST_LIST = [
     },
     {
         'test_id':          2,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0002-13af05ae-post.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          't0002-13af05ae-pre.fio',
@@ -1018,7 +591,7 @@ TEST_LIST = [
     },
     {
         'test_id':          3,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0003-0ae2c6e1-post.fio',
         'success':          SUCCESS_NONZERO,
         'pre_job':          't0003-0ae2c6e1-pre.fio',
@@ -1027,7 +600,7 @@ TEST_LIST = [
     },
     {
         'test_id':          4,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0004-8a99fdf6.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1036,7 +609,7 @@ TEST_LIST = [
     },
     {
         'test_id':          5,
-        'test_class':       FioJobTest_t0005,
+        'test_class':       FioJobFileTest_t0005,
         'job':              't0005-f7078f7b.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1046,7 +619,7 @@ TEST_LIST = [
     },
     {
         'test_id':          6,
-        'test_class':       FioJobTest_t0006,
+        'test_class':       FioJobFileTest_t0006,
         'job':              't0006-82af2a7c.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1056,7 +629,7 @@ TEST_LIST = [
     },
     {
         'test_id':          7,
-        'test_class':       FioJobTest_t0007,
+        'test_class':       FioJobFileTest_t0007,
         'job':              't0007-37cf9e3c.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1066,7 +639,7 @@ TEST_LIST = [
     },
     {
         'test_id':          8,
-        'test_class':       FioJobTest_t0008,
+        'test_class':       FioJobFileTest_t0008,
         'job':              't0008-ae2fafc8.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1076,7 +649,7 @@ TEST_LIST = [
     },
     {
         'test_id':          9,
-        'test_class':       FioJobTest_t0009,
+        'test_class':       FioJobFileTest_t0009,
         'job':              't0009-f8b0bd10.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1088,7 +661,7 @@ TEST_LIST = [
     },
     {
         'test_id':          10,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0010-b7aae4ba.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1097,7 +670,7 @@ TEST_LIST = [
     },
     {
         'test_id':          11,
-        'test_class':       FioJobTest_iops_rate,
+        'test_class':       FioJobFileTest_iops_rate,
         'job':              't0011-5d2788d5.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1107,7 +680,7 @@ TEST_LIST = [
     },
     {
         'test_id':          12,
-        'test_class':       FioJobTest_t0012,
+        'test_class':       FioJobFileTest_t0012,
         'job':              't0012.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1117,7 +690,7 @@ TEST_LIST = [
     },
     {
         'test_id':          13,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0013.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1127,7 +700,7 @@ TEST_LIST = [
     },
     {
         'test_id':          14,
-        'test_class':       FioJobTest_t0014,
+        'test_class':       FioJobFileTest_t0014,
         'job':              't0014.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1137,7 +710,7 @@ TEST_LIST = [
     },
     {
         'test_id':          15,
-        'test_class':       FioJobTest_t0015,
+        'test_class':       FioJobFileTest_t0015,
         'job':              't0015-e78980ff.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1147,7 +720,7 @@ TEST_LIST = [
     },
     {
         'test_id':          16,
-        'test_class':       FioJobTest_t0015,
+        'test_class':       FioJobFileTest_t0015,
         'job':              't0016-d54ae22.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1157,7 +730,7 @@ TEST_LIST = [
     },
     {
         'test_id':          17,
-        'test_class':       FioJobTest_t0015,
+        'test_class':       FioJobFileTest_t0015,
         'job':              't0017.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1167,7 +740,7 @@ TEST_LIST = [
     },
     {
         'test_id':          18,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0018.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1176,7 +749,7 @@ TEST_LIST = [
     },
     {
         'test_id':          19,
-        'test_class':       FioJobTest_t0019,
+        'test_class':       FioJobFileTest_t0019,
         'job':              't0019.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1185,7 +758,7 @@ TEST_LIST = [
     },
     {
         'test_id':          20,
-        'test_class':       FioJobTest_t0020,
+        'test_class':       FioJobFileTest_t0020,
         'job':              't0020.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1194,7 +767,7 @@ TEST_LIST = [
     },
     {
         'test_id':          21,
-        'test_class':       FioJobTest_t0020,
+        'test_class':       FioJobFileTest_t0020,
         'job':              't0021.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1203,7 +776,7 @@ TEST_LIST = [
     },
     {
         'test_id':          22,
-        'test_class':       FioJobTest_t0022,
+        'test_class':       FioJobFileTest_t0022,
         'job':              't0022.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1212,7 +785,7 @@ TEST_LIST = [
     },
     {
         'test_id':          23,
-        'test_class':       FioJobTest_t0023,
+        'test_class':       FioJobFileTest_t0023,
         'job':              't0023.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1221,7 +794,7 @@ TEST_LIST = [
     },
     {
         'test_id':          24,
-        'test_class':       FioJobTest_t0024,
+        'test_class':       FioJobFileTest_t0024,
         'job':              't0024.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1230,7 +803,7 @@ TEST_LIST = [
     },
     {
         'test_id':          25,
-        'test_class':       FioJobTest_t0025,
+        'test_class':       FioJobFileTest_t0025,
         'job':              't0025.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1240,7 +813,7 @@ TEST_LIST = [
     },
     {
         'test_id':          26,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0026.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1249,7 +822,7 @@ TEST_LIST = [
     },
     {
         'test_id':          27,
-        'test_class':       FioJobTest_t0027,
+        'test_class':       FioJobFileTest_t0027,
         'job':              't0027.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1258,7 +831,7 @@ TEST_LIST = [
     },
     {
         'test_id':          28,
-        'test_class':       FioJobTest,
+        'test_class':       FioJobFileTest,
         'job':              't0028-c6cade16.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -1317,7 +890,7 @@ TEST_LIST = [
         'test_id':          1006,
         'test_class':       FioExeTest,
         'exe':              't/strided.py',
-        'parameters':       ['{fio_path}'],
+        'parameters':       ['--fio', '{fio_path}'],
         'success':          SUCCESS_DEFAULT,
         'requirements':     [],
     },
@@ -1461,98 +1034,15 @@ def main():
     print(f"Artifact directory is {artifact_root}")
 
     if not args.skip_req:
-        req = Requirements(fio_root, args)
-
-    passed = 0
-    failed = 0
-    skipped = 0
-
-    for config in TEST_LIST:
-        if (args.skip and config['test_id'] in args.skip) or \
-           (args.run_only and config['test_id'] not in args.run_only):
-            skipped = skipped + 1
-            print(f"Test {config['test_id']} SKIPPED (User request)")
-            continue
-
-        if issubclass(config['test_class'], FioJobTest):
-            if config['pre_job']:
-                fio_pre_job = os.path.join(fio_root, 't', 'jobs',
-                                           config['pre_job'])
-            else:
-                fio_pre_job = None
-            if config['pre_success']:
-                fio_pre_success = config['pre_success']
-            else:
-                fio_pre_success = None
-            if 'output_format' in config:
-                output_format = config['output_format']
-            else:
-                output_format = 'normal'
-            test = config['test_class'](
-                fio_path,
-                os.path.join(fio_root, 't', 'jobs', config['job']),
-                config['success'],
-                fio_pre_job=fio_pre_job,
-                fio_pre_success=fio_pre_success,
-                output_format=output_format)
-            desc = config['job']
-        elif issubclass(config['test_class'], FioExeTest):
-            exe_path = os.path.join(fio_root, config['exe'])
-            if config['parameters']:
-                parameters = [p.format(fio_path=fio_path, nvmecdev=args.nvmecdev)
-                              for p in config['parameters']]
-            else:
-                parameters = []
-            if Path(exe_path).suffix == '.py' and platform.system() == "Windows":
-                parameters.insert(0, exe_path)
-                exe_path = "python.exe"
-            if config['test_id'] in pass_through:
-                parameters += pass_through[config['test_id']].split()
-            test = config['test_class'](exe_path, parameters,
-                                        config['success'])
-            desc = config['exe']
-        else:
-            print(f"Test {config['test_id']} FAILED: unable to process test config")
-            failed = failed + 1
-            continue
-
-        if not args.skip_req:
-            reqs_met = True
-            for req in config['requirements']:
-                reqs_met, reason = req()
-                logging.debug("Test %d: Requirement '%s' met? %s", config['test_id'], reason,
-                              reqs_met)
-                if not reqs_met:
-                    break
-            if not reqs_met:
-                print(f"Test {config['test_id']} SKIPPED ({reason}) {desc}")
-                skipped = skipped + 1
-                continue
-
-        try:
-            test.setup(artifact_root, config['test_id'])
-            test.run()
-            test.check_result()
-        except KeyboardInterrupt:
-            break
-        except Exception as e:
-            test.passed = False
-            test.failure_reason += str(e)
-            logging.debug("Test %d exception:\n%s\n", config['test_id'], traceback.format_exc())
-        if test.passed:
-            result = "PASSED"
-            passed = passed + 1
-        else:
-            result = f"FAILED: {test.failure_reason}"
-            failed = failed + 1
-            contents, _ = FioJobTest.get_file(test.stderr_file)
-            logging.debug("Test %d: stderr:\n%s", config['test_id'], contents)
-            contents, _ = FioJobTest.get_file(test.stdout_file)
-            logging.debug("Test %d: stdout:\n%s", config['test_id'], contents)
-        print(f"Test {config['test_id']} {result} {desc}")
-
-    print(f"{passed} test(s) passed, {failed} failed, {skipped} skipped")
-
+        Requirements(fio_root, args)
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': fio_root,
+              'artifact_root': artifact_root,
+              'pass_through': pass_through,
+              }
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
     sys.exit(failed)
 
 
diff --git a/t/strided.py b/t/strided.py
index 45e6f148..b7655e1e 100755
--- a/t/strided.py
+++ b/t/strided.py
@@ -1,11 +1,12 @@
 #!/usr/bin/env python3
-#
+
+"""
 # strided.py
 #
 # Test zonemode=strided. This uses the null ioengine when no file is
 # specified. If a file is specified, use it for randdom read testing.
 # Some of the zoneranges in the tests are 16MiB. So when using a file
-# a minimum size of 32MiB is recommended.
+# a minimum size of 64MiB is recommended.
 #
 # USAGE
 # python strided.py fio-executable [-f file/device]
@@ -13,12 +14,9 @@
 # EXAMPLES
 # python t/strided.py ./fio
 # python t/strided.py ./fio -f /dev/sda
-# dd if=/dev/zero of=temp bs=1M count=32
+# dd if=/dev/zero of=temp bs=1M count=64
 # python t/strided.py ./fio -f temp
 #
-# REQUIREMENTS
-# Python 2.6+
-#
 # ===TEST MATRIX===
 #
 # --zonemode=strided, zoneskip unset
@@ -28,322 +26,417 @@
 #       zonesize<zonerange  all blocks inside zone
 #
 #   w/o randommap       all blocks inside zone
-#
+"""
 
-from __future__ import absolute_import
-from __future__ import print_function
 import os
 import sys
+import time
 import argparse
-import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
 
 
-def parse_args():
-    parser = argparse.ArgumentParser()
-    parser.add_argument('fio',
-                        help='path to fio executable (e.g., ./fio)')
-    parser.add_argument('-f', '--filename', help="file/device to test")
-    args = parser.parse_args()
+class StridedTest(FioJobCmdTest):
+    """Test zonemode=strided."""
 
-    return args
+    def setup(self, parameters):
+        fio_args = [
+                    "--name=strided",
+                    "--zonemode=strided",
+                    "--log_offset=1",
+                    "--randrepeat=0",
+                    "--rw=randread",
+                    f"--write_iops_log={self.filenames['iopslog']}",
+                    f"--output={self.filenames['output']}",
+                    f"--zonerange={self.fio_opts['zonerange']}",
+                    f"--zonesize={self.fio_opts['zonesize']}",
+                    f"--bs={self.fio_opts['bs']}",
+                   ]
 
+        for opt in ['norandommap', 'random_generator', 'offset']:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
 
-def run_fio(fio, test, index):
-    filename = "strided"
-    fio_args = [
-                "--max-jobs=16",
-                "--name=strided",
-                "--zonemode=strided",
-                "--log_offset=1",
-                "--randrepeat=0",
-                "--rw=randread",
-                "--write_iops_log={0}{1:03d}".format(filename, index),
-                "--output={0}{1:03d}.out".format(filename, index),
-                "--zonerange={zonerange}".format(**test),
-                "--zonesize={zonesize}".format(**test),
-                "--bs={bs}".format(**test),
-               ]
-    if 'norandommap' in test:
-        fio_args.append('--norandommap')
-    if 'random_generator' in test:
-        fio_args.append('--random_generator={random_generator}'.format(**test))
-    if 'offset' in test:
-        fio_args.append('--offset={offset}'.format(**test))
-    if 'filename' in test:
-        fio_args.append('--filename={filename}'.format(**test))
-        fio_args.append('--filesize={filesize})'.format(**test))
-    else:
-        fio_args.append('--ioengine=null')
-        fio_args.append('--size={size}'.format(**test))
-        fio_args.append('--io_size={io_size}'.format(**test))
-        fio_args.append('--filesize={size})'.format(**test))
-
-    output = subprocess.check_output([fio] + fio_args, universal_newlines=True)
-
-    f = open("{0}{1:03d}_iops.1.log".format(filename, index), "r")
-    log = f.read()
-    f.close()
-
-    return log
-
-
-def check_output(iops_log, test):
-    zonestart = 0 if 'offset' not in test else test['offset']
-    iospersize = test['zonesize'] / test['bs']
-    iosperrange = test['zonerange'] / test['bs']
-    iosperzone = 0
-    lines = iops_log.split('\n')
-    zoneset = set()
-
-    for line in lines:
-        if len(line) == 0:
-            continue
-
-        if iosperzone == iospersize:
-            # time to move to a new zone
-            iosperzone = 0
-            zoneset = set()
-            zonestart += test['zonerange']
-            if zonestart >= test['filesize']:
-                zonestart = 0 if 'offset' not in test else test['offset']
-
-        iosperzone = iosperzone + 1
-        tokens = line.split(',')
-        offset = int(tokens[4])
-        if offset < zonestart or offset >= zonestart + test['zonerange']:
-            print("Offset {0} outside of zone starting at {1}".format(
-                    offset, zonestart))
-            return False
-
-        # skip next section if norandommap is enabled with no
-        # random_generator or with a random_generator != lfsr
-        if 'norandommap' in test:
-            if 'random_generator' in test:
-                if test['random_generator'] != 'lfsr':
-                    continue
-            else:
+        if 'filename' in self.fio_opts:
+            for opt in ['filename', 'filesize']:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+        else:
+            fio_args.append('--ioengine=null')
+            for opt in ['size', 'io_size', 'filesize']:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+    def check_result(self):
+        zonestart = 0 if 'offset' not in self.fio_opts else self.fio_opts['offset']
+        iospersize = self.fio_opts['zonesize'] / self.fio_opts['bs']
+        iosperrange = self.fio_opts['zonerange'] / self.fio_opts['bs']
+        iosperzone = 0
+        lines = self.iops_log_lines.split('\n')
+        zoneset = set()
+
+        for line in lines:
+            if len(line) == 0:
                 continue
 
-        # we either have a random map enabled or we
-        # are using an LFSR
-        # so all blocks should be unique and we should have
-        # covered the entire zone when iosperzone % iosperrange == 0
-        block = (offset - zonestart) / test['bs']
-        if block in zoneset:
-            print("Offset {0} in zone already touched".format(offset))
-            return False
-
-        zoneset.add(block)
-        if iosperzone % iosperrange == 0:
-            if len(zoneset) != iosperrange:
-                print("Expected {0} blocks in zone but only saw {1}".format(
-                        iosperrange, len(zoneset)))
+            if iosperzone == iospersize:
+                # time to move to a new zone
+                iosperzone = 0
+                zoneset = set()
+                zonestart += self.fio_opts['zonerange']
+                if zonestart >= self.fio_opts['filesize']:
+                    zonestart = 0 if 'offset' not in self.fio_opts else self.fio_opts['offset']
+
+            iosperzone = iosperzone + 1
+            tokens = line.split(',')
+            offset = int(tokens[4])
+            if offset < zonestart or offset >= zonestart + self.fio_opts['zonerange']:
+                print(f"Offset {offset} outside of zone starting at {zonestart}")
                 return False
-            zoneset = set()
 
-    return True
+            # skip next section if norandommap is enabled with no
+            # random_generator or with a random_generator != lfsr
+            if 'norandommap' in self.fio_opts:
+                if 'random_generator' in self.fio_opts:
+                    if self.fio_opts['random_generator'] != 'lfsr':
+                        continue
+                else:
+                    continue
 
+            # we either have a random map enabled or we
+            # are using an LFSR
+            # so all blocks should be unique and we should have
+            # covered the entire zone when iosperzone % iosperrange == 0
+            block = (offset - zonestart) / self.fio_opts['bs']
+            if block in zoneset:
+                print(f"Offset {offset} in zone already touched")
+                return False
+
+            zoneset.add(block)
+            if iosperzone % iosperrange == 0:
+                if len(zoneset) != iosperrange:
+                    print(f"Expected {iosperrange} blocks in zone but only saw {len(zoneset)}")
+                    return False
+                zoneset = set()
+
+        return True
+
+
+TEST_LIST = [   # randommap enabled
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "zonerange": 4096,
+            "zonesize": 4096,
+            "bs": 4096,
+            "offset": 8*4096,
+            "size": 16*4096,
+            "io_size": 16*4096,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "zonerange": 4096,
+            "zonesize": 4096,
+            "bs": 4096,
+            "size": 16*4096,
+            "io_size": 16*4096,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "zonerange": 16*1024*1024,
+            "zonesize": 16*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*204,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "zonerange": 4096,
+            "zonesize": 4*4096,
+            "bs": 4096,
+            "size": 16*4096,
+            "io_size": 16*4096,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 5,
+        "fio_opts": {
+            "zonerange": 16*1024*1024,
+            "zonesize": 32*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*204,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 6,
+        "fio_opts": {
+            "zonerange": 8192,
+            "zonesize": 4096,
+            "bs": 4096,
+            "size": 16*4096,
+            "io_size": 16*4096,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 7,
+        "fio_opts": {
+            "zonerange": 16*1024*1024,
+            "zonesize": 8*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*204,
+            },
+        "test_class": StridedTest,
+    },
+            # lfsr
+    {
+        "test_id": 8,
+        "fio_opts": {
+            "random_generator": "lfsr",
+            "zonerange": 4096*1024,
+            "zonesize": 4096*1024,
+            "bs": 4096,
+            "offset": 8*4096*1024,
+            "size": 16*4096*1024,
+            "io_size": 16*4096*1024,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 9,
+        "fio_opts": {
+            "random_generator": "lfsr",
+            "zonerange": 4096*1024,
+            "zonesize": 4096*1024,
+            "bs": 4096,
+            "size": 16*4096*1024,
+            "io_size": 16*4096*1024,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 10,
+        "fio_opts": {
+            "random_generator": "lfsr",
+            "zonerange": 16*1024*1024,
+            "zonesize": 16*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*204,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 11,
+        "fio_opts": {
+            "random_generator": "lfsr",
+            "zonerange": 4096*1024,
+            "zonesize": 4*4096*1024,
+            "bs": 4096,
+            "size": 16*4096*1024,
+            "io_size": 16*4096*1024,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 12,
+        "fio_opts": {
+            "random_generator": "lfsr",
+            "zonerange": 16*1024*1024,
+            "zonesize": 32*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*204,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 13,
+        "fio_opts": {
+            "random_generator": "lfsr",
+            "zonerange": 8192*1024,
+            "zonesize": 4096*1024,
+            "bs": 4096,
+            "size": 16*4096*1024,
+            "io_size": 16*4096*1024,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 14,
+        "fio_opts": {
+            "random_generator": "lfsr",
+            "zonerange": 16*1024*1024,
+            "zonesize": 8*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*204,
+            },
+        "test_class": StridedTest,
+    },
+    # norandommap
+    {
+        "test_id": 15,
+        "fio_opts": {
+            "norandommap": 1,
+            "zonerange": 4096,
+            "zonesize": 4096,
+            "bs": 4096,
+            "offset": 8*4096,
+            "size": 16*4096,
+            "io_size": 16*4096,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 16,
+        "fio_opts": {
+            "norandommap": 1,
+            "zonerange": 4096,
+            "zonesize": 4096,
+            "bs": 4096,
+            "size": 16*4096,
+            "io_size": 16*4096,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 17,
+        "fio_opts": {
+            "norandommap": 1,
+            "zonerange": 16*1024*1024,
+            "zonesize": 16*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*204,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 18,
+        "fio_opts": {
+            "norandommap": 1,
+            "zonerange": 4096,
+            "zonesize": 8192,
+            "bs": 4096,
+            "size": 16*4096,
+            "io_size": 16*4096,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 19,
+        "fio_opts": {
+            "norandommap": 1,
+            "zonerange": 16*1024*1024,
+            "zonesize": 32*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*204,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 20,
+        "fio_opts": {
+            "norandommap": 1,
+            "zonerange": 8192,
+            "zonesize": 4096,
+            "bs": 4096,
+            "size": 16*4096,
+            "io_size": 16*4096,
+            },
+        "test_class": StridedTest,
+    },
+    {
+        "test_id": 21,
+        "fio_opts": {
+            "norandommap": 1,
+            "zonerange": 16*1024*1024,
+            "zonesize": 8*1024*1024,
+            "bs": 4096,
+            "size": 256*1024*1024,
+            "io_size": 256*1024*1024,
+            },
+        "test_class": StridedTest,
+    },
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('--dut',
+                        help='target file/device to test.')
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    """Run zonemode=strided tests."""
 
-if __name__ == '__main__':
     args = parse_args()
 
-    tests = [   # randommap enabled
-                {
-                    "zonerange": 4096,
-                    "zonesize": 4096,
-                    "bs": 4096,
-                    "offset": 8*4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
-                },
-                {
-                    "zonerange": 4096,
-                    "zonesize": 4096,
-                    "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
-                },
-                {
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 16*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
-                },
-                {
-                    "zonerange": 4096,
-                    "zonesize": 4*4096,
-                    "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
-                },
-                {
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 32*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
-                },
-                {
-                    "zonerange": 8192,
-                    "zonesize": 4096,
-                    "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
-                },
-                {
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 8*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
-                },
-                # lfsr
-                {
-                    "random_generator": "lfsr",
-                    "zonerange": 4096*1024,
-                    "zonesize": 4096*1024,
-                    "bs": 4096,
-                    "offset": 8*4096*1024,
-                    "size": 16*4096*1024,
-                    "io_size": 16*4096*1024,
-                },
-                {
-                    "random_generator": "lfsr",
-                    "zonerange": 4096*1024,
-                    "zonesize": 4096*1024,
-                    "bs": 4096,
-                    "size": 16*4096*1024,
-                    "io_size": 16*4096*1024,
-                },
-                {
-                    "random_generator": "lfsr",
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 16*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
-                },
-                {
-                    "random_generator": "lfsr",
-                    "zonerange": 4096*1024,
-                    "zonesize": 4*4096*1024,
-                    "bs": 4096,
-                    "size": 16*4096*1024,
-                    "io_size": 16*4096*1024,
-                },
-                {
-                    "random_generator": "lfsr",
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 32*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
-                },
-                {
-                    "random_generator": "lfsr",
-                    "zonerange": 8192*1024,
-                    "zonesize": 4096*1024,
-                    "bs": 4096,
-                    "size": 16*4096*1024,
-                    "io_size": 16*4096*1024,
-                },
-                {
-                    "random_generator": "lfsr",
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 8*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
-                },
-                # norandommap
-                {
-                    "norandommap": 1,
-                    "zonerange": 4096,
-                    "zonesize": 4096,
-                    "bs": 4096,
-                    "offset": 8*4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
-                },
-                {
-                    "norandommap": 1,
-                    "zonerange": 4096,
-                    "zonesize": 4096,
-                    "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
-                },
-                {
-                    "norandommap": 1,
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 16*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
-                },
-                {
-                    "norandommap": 1,
-                    "zonerange": 4096,
-                    "zonesize": 8192,
-                    "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
-                },
-                {
-                    "norandommap": 1,
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 32*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*204,
-                },
-                {
-                    "norandommap": 1,
-                    "zonerange": 8192,
-                    "zonesize": 4096,
-                    "bs": 4096,
-                    "size": 16*4096,
-                    "io_size": 16*4096,
-                },
-                {
-                    "norandommap": 1,
-                    "zonerange": 16*1024*1024,
-                    "zonesize": 8*1024*1024,
-                    "bs": 4096,
-                    "size": 256*1024*1024,
-                    "io_size": 256*1024*1024,
-                },
-
-            ]
-
-    index = 1
-    passed = 0
-    failed = 0
-
-    if args.filename:
-        statinfo = os.stat(args.filename)
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"strided-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = 'fio'
+    print(f"fio path is {fio_path}")
+
+    if args.dut:
+        statinfo = os.stat(args.dut)
         filesize = statinfo.st_size
         if filesize == 0:
-            f = os.open(args.filename, os.O_RDONLY)
+            f = os.open(args.dut, os.O_RDONLY)
             filesize = os.lseek(f, 0, os.SEEK_END)
             os.close(f)
 
-    for test in tests:
-        if args.filename:
-            test['filename'] = args.filename
-            test['filesize'] = filesize
+    for test in TEST_LIST:
+        if args.dut:
+            test['fio_opts']['filename'] = os.path.abspath(args.dut)
+            test['fio_opts']['filesize'] = filesize
         else:
-            test['filesize'] = test['size']
-        iops_log = run_fio(args.fio, test, index)
-        status = check_output(iops_log, test)
-        print("Test {0} {1}".format(index, ("PASSED" if status else "FAILED")))
-        if status:
-            passed = passed + 1
-        else:
-            failed = failed + 1
-        index = index + 1
+            test['fio_opts']['filesize'] = test['fio_opts']['size']
 
-    print("{0} tests passed, {1} failed".format(passed, failed))
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'strided',
+              }
 
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
     sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 996160e7..a3d37a7d 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -460,7 +460,8 @@ test11() {
 test12() {
     local size off capacity
 
-    prep_write
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 8 $off $dev)
@@ -477,7 +478,8 @@ test13() {
 
     require_max_open_zones 4 || return $SKIP_TESTCASE
 
-    prep_write
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 8 $off $dev)
@@ -726,7 +728,9 @@ test29() {
     require_seq_zones 80 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-    prep_write
+
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     opts=("--debug=zbd")
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
@@ -796,7 +800,8 @@ test32() {
 
     require_zbd || return $SKIP_TESTCASE
 
-    prep_write
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
@@ -1024,7 +1029,9 @@ test48() {
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-    prep_write
+
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
+
     opts=("--aux-path=/tmp" "--allow_file_create=0" "--significant_figures=10")
     opts+=("--debug=zbd")
     opts+=("$(ioengine "libaio")" "--rw=randwrite" "--direct=1")
@@ -1094,7 +1101,7 @@ test51() {
 	require_conv_zones 8 || return $SKIP_TESTCASE
 	require_seq_zones 8 || return $SKIP_TESTCASE
 
-	prep_write
+	reset_zone "$dev" -1
 
 	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
 	opts+=("--size=$((16 * zone_size))" "$(ioengine "libaio")")
@@ -1361,6 +1368,51 @@ test63() {
 	check_reset_count -eq 3 || return $?
 }
 
+# Test write zone accounting handles almost full zones correctly. Prepare an
+# almost full, but not full zone. Write to the zone with verify using larger
+# block size. Then confirm fio does not report write zone accounting failure.
+test64() {
+	local bs cap
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	bs=$((zone_size / 8))
+	cap=$(total_zone_capacity 1 $((first_sequential_zone_sector*512)) $dev)
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$((zone_size)) \
+		       --io_size=$((cap - bs)) \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+
+	bs=$((zone_size / 2))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$((zone_size)) --do_verify=1 --verify=md5 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+# Test open zone accounting handles trim workload correctly. Prepare open zones
+# as many as max_open_zones=4. Trim one of the 4 zones. Then write to another
+# zone and check the write amount is expected size.
+test65() {
+	local off capacity
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	off=$((first_sequential_zone_sector * 512))
+	capacity=$(total_zone_capacity 1 $off "$dev")
+	run_fio --zonemode=zbd --direct=1 --zonesize="$zone_size" --thread=1 \
+		--filename="$dev" --group_reporting=1 --max_open_zones=4 \
+		"$(ioengine "psync")" \
+		--name="prep_open_zones" --rw=randwrite --offset="$off" \
+		--size="$((zone_size * 4))" --bs=4096 --io_size="$zone_size" \
+		--name=trimjob --wait_for="prep_open_zones" --rw=trim \
+		--bs="$zone_size" --offset="$off" --size="$zone_size" \
+		--name=write --wait_for="trimjob" --rw=write --bs=4096 \
+		--offset="$((off + zone_size * 4))" --size="$zone_size" \
+		>> "${logfile}.${test_number}" 2>&1
+
+	check_written $((zone_size + capacity))
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/zbd.c b/zbd.c
index 5f1a7d7f..9455140a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -254,7 +254,7 @@ static int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
 }
 
 /**
- * zbd_reset_zone - reset the write pointer of a single zone
+ * __zbd_reset_zone - reset the write pointer of a single zone
  * @td: FIO thread data.
  * @f: FIO file associated with the disk for which to reset a write pointer.
  * @z: Zone to reset.
@@ -263,8 +263,8 @@ static int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
  *
  * The caller must hold z->mutex.
  */
-static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
-			  struct fio_zone_info *z)
+static int __zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			    struct fio_zone_info *z)
 {
 	uint64_t offset = z->start;
 	uint64_t length = (z+1)->start - offset;
@@ -304,39 +304,65 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 }
 
 /**
- * zbd_close_zone - Remove a zone from the open zones array.
+ * zbd_write_zone_put - Remove a zone from the write target zones array.
  * @td: FIO thread data.
- * @f: FIO file associated with the disk for which to reset a write pointer.
+ * @f: FIO file that has the write zones array to remove.
  * @zone_idx: Index of the zone to remove.
  *
  * The caller must hold f->zbd_info->mutex.
  */
-static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
-			   struct fio_zone_info *z)
+static void zbd_write_zone_put(struct thread_data *td, const struct fio_file *f,
+			       struct fio_zone_info *z)
 {
-	uint32_t ozi;
+	uint32_t zi;
 
-	if (!z->open)
+	if (!z->write)
 		return;
 
-	for (ozi = 0; ozi < f->zbd_info->num_open_zones; ozi++) {
-		if (zbd_get_zone(f, f->zbd_info->open_zones[ozi]) == z)
+	for (zi = 0; zi < f->zbd_info->num_write_zones; zi++) {
+		if (zbd_get_zone(f, f->zbd_info->write_zones[zi]) == z)
 			break;
 	}
-	if (ozi == f->zbd_info->num_open_zones)
+	if (zi == f->zbd_info->num_write_zones)
 		return;
 
-	dprint(FD_ZBD, "%s: closing zone %u\n",
+	dprint(FD_ZBD, "%s: removing zone %u from write zone array\n",
 	       f->file_name, zbd_zone_idx(f, z));
 
-	memmove(f->zbd_info->open_zones + ozi,
-		f->zbd_info->open_zones + ozi + 1,
-		(ZBD_MAX_OPEN_ZONES - (ozi + 1)) *
-		sizeof(f->zbd_info->open_zones[0]));
+	memmove(f->zbd_info->write_zones + zi,
+		f->zbd_info->write_zones + zi + 1,
+		(ZBD_MAX_WRITE_ZONES - (zi + 1)) *
+		sizeof(f->zbd_info->write_zones[0]));
+
+	f->zbd_info->num_write_zones--;
+	td->num_write_zones--;
+	z->write = 0;
+}
 
-	f->zbd_info->num_open_zones--;
-	td->num_open_zones--;
-	z->open = 0;
+/**
+ * zbd_reset_zone - reset the write pointer of a single zone and remove the zone
+ *                  from the array of write zones.
+ * @td: FIO thread data.
+ * @f: FIO file associated with the disk for which to reset a write pointer.
+ * @z: Zone to reset.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ *
+ * The caller must hold z->mutex.
+ */
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			  struct fio_zone_info *z)
+{
+	int ret;
+
+	ret = __zbd_reset_zone(td, f, z);
+	if (ret)
+		return ret;
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	zbd_write_zone_put(td, f, z);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	return 0;
 }
 
 /**
@@ -404,9 +430,6 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			continue;
 
 		zone_lock(td, f, z);
-		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, z);
-		pthread_mutex_unlock(&f->zbd_info->mutex);
 
 		if (z->wp != z->start) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
@@ -450,21 +473,19 @@ static int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 }
 
 /**
- * zbd_open_zone - Add a zone to the array of open zones.
+ * __zbd_write_zone_get - Add a zone to the array of write zones.
  * @td: fio thread data.
- * @f: fio file that has the open zones to add.
+ * @f: fio file that has the write zones array to add.
  * @zone_idx: Index of the zone to add.
  *
- * Open a ZBD zone if it is not already open. Returns true if either the zone
- * was already open or if the zone was successfully added to the array of open
- * zones without exceeding the maximum number of open zones. Returns false if
- * the zone was not already open and opening the zone would cause the zone limit
- * to be exceeded.
+ * Do same operation as @zbd_write_zone_get, except it adds the zone at
+ * @zone_idx to write target zones array even when it does not have remainder
+ * space to write one block.
  */
-static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
-			  struct fio_zone_info *z)
+static bool __zbd_write_zone_get(struct thread_data *td,
+				 const struct fio_file *f,
+				 struct fio_zone_info *z)
 {
-	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	uint32_t zone_idx = zbd_zone_idx(f, z);
 	bool res = true;
@@ -476,24 +497,24 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 	 * Skip full zones with data verification enabled because resetting a
 	 * zone causes data loss and hence causes verification to fail.
 	 */
-	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+	if (td->o.verify != VERIFY_NONE && zbd_zone_remainder(z) == 0)
 		return false;
 
 	/*
-	 * zbdi->max_open_zones == 0 means that there is no limit on the maximum
-	 * number of open zones. In this case, do no track open zones in
-	 * zbdi->open_zones array.
+	 * zbdi->max_write_zones == 0 means that there is no limit on the
+	 * maximum number of write target zones. In this case, do no track write
+	 * target zones in zbdi->write_zones array.
 	 */
-	if (!zbdi->max_open_zones)
+	if (!zbdi->max_write_zones)
 		return true;
 
 	pthread_mutex_lock(&zbdi->mutex);
 
-	if (z->open) {
+	if (z->write) {
 		/*
 		 * If the zone is going to be completely filled by writes
-		 * already in-flight, handle it as a full zone instead of an
-		 * open zone.
+		 * already in-flight, handle it as a full zone instead of a
+		 * write target zone.
 		 */
 		if (!zbd_zone_remainder(z))
 			res = false;
@@ -503,17 +524,17 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 	res = false;
 	/* Zero means no limit */
 	if (td->o.job_max_open_zones > 0 &&
-	    td->num_open_zones >= td->o.job_max_open_zones)
+	    td->num_write_zones >= td->o.job_max_open_zones)
 		goto out;
-	if (zbdi->num_open_zones >= zbdi->max_open_zones)
+	if (zbdi->num_write_zones >= zbdi->max_write_zones)
 		goto out;
 
-	dprint(FD_ZBD, "%s: opening zone %u\n",
+	dprint(FD_ZBD, "%s: adding zone %u to write zone array\n",
 	       f->file_name, zone_idx);
 
-	zbdi->open_zones[zbdi->num_open_zones++] = zone_idx;
-	td->num_open_zones++;
-	z->open = 1;
+	zbdi->write_zones[zbdi->num_write_zones++] = zone_idx;
+	td->num_write_zones++;
+	z->write = 1;
 	res = true;
 
 out:
@@ -521,6 +542,33 @@ out:
 	return res;
 }
 
+/**
+ * zbd_write_zone_get - Add a zone to the array of write zones.
+ * @td: fio thread data.
+ * @f: fio file that has the open zones to add.
+ * @zone_idx: Index of the zone to add.
+ *
+ * Add a ZBD zone to write target zones array, if it is not yet added. Returns
+ * true if either the zone was already added or if the zone was successfully
+ * added to the array without exceeding the maximum number of write zones.
+ * Returns false if the zone was not already added and addition of the zone
+ * would cause the zone limit to be exceeded.
+ */
+static bool zbd_write_zone_get(struct thread_data *td, const struct fio_file *f,
+			       struct fio_zone_info *z)
+{
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
+
+	/*
+	 * Skip full zones with data verification enabled because resetting a
+	 * zone causes data loss and hence causes verification to fail.
+	 */
+	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+		return false;
+
+	return __zbd_write_zone_get(td, f, z);
+}
+
 /* Verify whether direct I/O is used for all host-managed zoned block drives. */
 static bool zbd_using_direct_io(void)
 {
@@ -894,7 +942,7 @@ out:
 	return ret;
 }
 
-static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
+static int zbd_set_max_write_zones(struct thread_data *td, struct fio_file *f)
 {
 	struct zoned_block_device_info *zbd = f->zbd_info;
 	unsigned int max_open_zones;
@@ -902,7 +950,7 @@ static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
 
 	if (zbd->model != ZBD_HOST_MANAGED || td->o.ignore_zone_limits) {
 		/* Only host-managed devices have a max open limit */
-		zbd->max_open_zones = td->o.max_open_zones;
+		zbd->max_write_zones = td->o.max_open_zones;
 		goto out;
 	}
 
@@ -913,13 +961,13 @@ static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
 
 	if (!max_open_zones) {
 		/* No device limit */
-		zbd->max_open_zones = td->o.max_open_zones;
+		zbd->max_write_zones = td->o.max_open_zones;
 	} else if (!td->o.max_open_zones) {
 		/* No user limit. Set limit to device limit */
-		zbd->max_open_zones = max_open_zones;
+		zbd->max_write_zones = max_open_zones;
 	} else if (td->o.max_open_zones <= max_open_zones) {
 		/* Both user limit and dev limit. User limit not too large */
-		zbd->max_open_zones = td->o.max_open_zones;
+		zbd->max_write_zones = td->o.max_open_zones;
 	} else {
 		/* Both user limit and dev limit. User limit too large */
 		td_verror(td, EINVAL,
@@ -931,15 +979,15 @@ static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
 
 out:
 	/* Ensure that the limit is not larger than FIO's internal limit */
-	if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
+	if (zbd->max_write_zones > ZBD_MAX_WRITE_ZONES) {
 		td_verror(td, EINVAL, "'max_open_zones' value is too large");
 		log_err("'max_open_zones' value is larger than %u\n",
-			ZBD_MAX_OPEN_ZONES);
+			ZBD_MAX_WRITE_ZONES);
 		return -EINVAL;
 	}
 
-	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",
-	       f->file_name, zbd->max_open_zones);
+	dprint(FD_ZBD, "%s: using max write zones limit: %"PRIu32"\n",
+	       f->file_name, zbd->max_write_zones);
 
 	return 0;
 }
@@ -981,7 +1029,7 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 	assert(f->zbd_info);
 	f->zbd_info->model = zbd_model;
 
-	ret = zbd_set_max_open_zones(td, f);
+	ret = zbd_set_max_write_zones(td, f);
 	if (ret) {
 		zbd_free_zone_info(f);
 		return ret;
@@ -1174,7 +1222,7 @@ int zbd_setup_files(struct thread_data *td)
 			assert(f->min_zone < f->max_zone);
 
 		if (td->o.max_open_zones > 0 &&
-		    zbd->max_open_zones != td->o.max_open_zones) {
+		    zbd->max_write_zones != td->o.max_open_zones) {
 			log_err("Different 'max_open_zones' values\n");
 			return 1;
 		}
@@ -1184,34 +1232,32 @@ int zbd_setup_files(struct thread_data *td)
 		 * global max open zones limit. (As the tracking of open zones
 		 * is disabled when there is no global max open zones limit.)
 		 */
-		if (td->o.job_max_open_zones && !zbd->max_open_zones) {
+		if (td->o.job_max_open_zones && !zbd->max_write_zones) {
 			log_err("'job_max_open_zones' cannot be used without a global open zones limit\n");
 			return 1;
 		}
 
 		/*
-		 * zbd->max_open_zones is the global limit shared for all jobs
+		 * zbd->max_write_zones is the global limit shared for all jobs
 		 * that target the same zoned block device. Force sync the per
 		 * thread global limit with the actual global limit. (The real
 		 * per thread/job limit is stored in td->o.job_max_open_zones).
 		 */
-		td->o.max_open_zones = zbd->max_open_zones;
+		td->o.max_open_zones = zbd->max_write_zones;
 
 		for (zi = f->min_zone; zi < f->max_zone; zi++) {
 			z = &zbd->zone_info[zi];
 			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
 			    z->cond != ZBD_ZONE_COND_EXP_OPEN)
 				continue;
-			if (zbd_open_zone(td, f, z))
+			if (__zbd_write_zone_get(td, f, z))
 				continue;
 			/*
 			 * If the number of open zones exceeds specified limits,
-			 * reset all extra open zones.
+			 * error out.
 			 */
-			if (zbd_reset_zone(td, f, z) < 0) {
-				log_err("Failed to reest zone %d\n", zi);
-				return 1;
-			}
+			log_err("Number of open zones exceeds max_open_zones limit\n");
+			return 1;
 		}
 	}
 
@@ -1284,12 +1330,12 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	zbd_reset_write_cnt(td, f);
 }
 
-/* Return random zone index for one of the open zones. */
+/* Return random zone index for one of the write target zones. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
 {
 	return (io_u->offset - f->file_offset) *
-		f->zbd_info->num_open_zones / f->io_size;
+		f->zbd_info->num_write_zones / f->io_size;
 }
 
 static bool any_io_in_flight(void)
@@ -1303,35 +1349,35 @@ static bool any_io_in_flight(void)
 }
 
 /*
- * Modify the offset of an I/O unit that does not refer to an open zone such
- * that it refers to an open zone. Close an open zone and open a new zone if
- * necessary. The open zone is searched across sequential zones.
+ * Modify the offset of an I/O unit that does not refer to a zone such that
+ * in write target zones array. Add a zone to or remove a zone from the lsit if
+ * necessary. The write target zone is searched across sequential zones.
  * This algorithm can only work correctly if all write pointers are
  * a multiple of the fio block size. The caller must neither hold z->mutex
  * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
  */
-static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
-						      struct io_u *io_u)
+static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
+						       struct io_u *io_u)
 {
 	const uint64_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z;
-	unsigned int open_zone_idx = -1;
+	unsigned int write_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
-	bool wait_zone_close;
+	bool wait_zone_write;
 	bool in_flight;
 	bool should_retry = true;
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (zbdi->max_open_zones || td->o.job_max_open_zones) {
+	if (zbdi->max_write_zones || td->o.job_max_open_zones) {
 		/*
-		 * This statement accesses zbdi->open_zones[] on purpose
+		 * This statement accesses zbdi->write_zones[] on purpose
 		 * without locking.
 		 */
-		zone_idx = zbdi->open_zones[pick_random_zone_idx(f, io_u)];
+		zone_idx = zbdi->write_zones[pick_random_zone_idx(f, io_u)];
 	} else {
 		zone_idx = zbd_offset_to_zone_idx(f, io_u->offset);
 	}
@@ -1361,34 +1407,34 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		if (z->has_wp) {
 			if (z->cond != ZBD_ZONE_COND_OFFLINE &&
-			    zbdi->max_open_zones == 0 &&
+			    zbdi->max_write_zones == 0 &&
 			    td->o.job_max_open_zones == 0)
 				goto examine_zone;
-			if (zbdi->num_open_zones == 0) {
-				dprint(FD_ZBD, "%s(%s): no zones are open\n",
+			if (zbdi->num_write_zones == 0) {
+				dprint(FD_ZBD, "%s(%s): no zone is write target\n",
 				       __func__, f->file_name);
-				goto open_other_zone;
+				goto choose_other_zone;
 			}
 		}
 
 		/*
-		 * List of opened zones is per-device, shared across all
+		 * Array of write target zones is per-device, shared across all
 		 * threads. Start with quasi-random candidate zone. Ignore
 		 * zones which don't belong to thread's offset/size area.
 		 */
-		open_zone_idx = pick_random_zone_idx(f, io_u);
-		assert(!open_zone_idx ||
-		       open_zone_idx < zbdi->num_open_zones);
-		tmp_idx = open_zone_idx;
+		write_zone_idx = pick_random_zone_idx(f, io_u);
+		assert(!write_zone_idx ||
+		       write_zone_idx < zbdi->num_write_zones);
+		tmp_idx = write_zone_idx;
 
-		for (i = 0; i < zbdi->num_open_zones; i++) {
+		for (i = 0; i < zbdi->num_write_zones; i++) {
 			uint32_t tmpz;
 
-			if (tmp_idx >= zbdi->num_open_zones)
+			if (tmp_idx >= zbdi->num_write_zones)
 				tmp_idx = 0;
-			tmpz = zbdi->open_zones[tmp_idx];
+			tmpz = zbdi->write_zones[tmp_idx];
 			if (f->min_zone <= tmpz && tmpz < f->max_zone) {
-				open_zone_idx = tmp_idx;
+				write_zone_idx = tmp_idx;
 				goto found_candidate_zone;
 			}
 
@@ -1406,7 +1452,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		return NULL;
 
 found_candidate_zone:
-		new_zone_idx = zbdi->open_zones[open_zone_idx];
+		new_zone_idx = zbdi->write_zones[write_zone_idx];
 		if (new_zone_idx == zone_idx)
 			break;
 		zone_idx = new_zone_idx;
@@ -1425,32 +1471,32 @@ examine_zone:
 		goto out;
 	}
 
-open_other_zone:
-	/* Check if number of open zones reaches one of limits. */
-	wait_zone_close =
-		zbdi->num_open_zones == f->max_zone - f->min_zone ||
-		(zbdi->max_open_zones &&
-		 zbdi->num_open_zones == zbdi->max_open_zones) ||
+choose_other_zone:
+	/* Check if number of write target zones reaches one of limits. */
+	wait_zone_write =
+		zbdi->num_write_zones == f->max_zone - f->min_zone ||
+		(zbdi->max_write_zones &&
+		 zbdi->num_write_zones == zbdi->max_write_zones) ||
 		(td->o.job_max_open_zones &&
-		 td->num_open_zones == td->o.job_max_open_zones);
+		 td->num_write_zones == td->o.job_max_open_zones);
 
 	pthread_mutex_unlock(&zbdi->mutex);
 
 	/* Only z->mutex is held. */
 
 	/*
-	 * When number of open zones reaches to one of limits, wait for
-	 * zone close before opening a new zone.
+	 * When number of write target zones reaches to one of limits, wait for
+	 * zone write completion to one of them before trying a new zone.
 	 */
-	if (wait_zone_close) {
+	if (wait_zone_write) {
 		dprint(FD_ZBD,
-		       "%s(%s): quiesce to allow open zones to close\n",
+		       "%s(%s): quiesce to remove a zone from write target zones array\n",
 		       __func__, f->file_name);
 		io_u_quiesce(td);
 	}
 
 retry:
-	/* Zone 'z' is full, so try to open a new zone. */
+	/* Zone 'z' is full, so try to choose a new zone. */
 	for (i = f->io_size / zbdi->zone_size; i > 0; i--) {
 		zone_idx++;
 		if (z->has_wp)
@@ -1465,18 +1511,18 @@ retry:
 		if (!z->has_wp)
 			continue;
 		zone_lock(td, f, z);
-		if (z->open)
+		if (z->write)
 			continue;
-		if (zbd_open_zone(td, f, z))
+		if (zbd_write_zone_get(td, f, z))
 			goto out;
 	}
 
 	/* Only z->mutex is held. */
 
-	/* Check whether the write fits in any of the already opened zones. */
+	/* Check whether the write fits in any of the write target zones. */
 	pthread_mutex_lock(&zbdi->mutex);
-	for (i = 0; i < zbdi->num_open_zones; i++) {
-		zone_idx = zbdi->open_zones[i];
+	for (i = 0; i < zbdi->num_write_zones; i++) {
+		zone_idx = zbdi->write_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
 			continue;
 		pthread_mutex_unlock(&zbdi->mutex);
@@ -1492,13 +1538,14 @@ retry:
 
 	/*
 	 * When any I/O is in-flight or when all I/Os in-flight get completed,
-	 * the I/Os might have closed zones then retry the steps to open a zone.
-	 * Before retry, call io_u_quiesce() to complete in-flight writes.
+	 * the I/Os might have removed zones from the write target array then
+	 * retry the steps to choose a zone. Before retry, call io_u_quiesce()
+	 * to complete in-flight writes.
 	 */
 	in_flight = any_io_in_flight();
 	if (in_flight || should_retry) {
 		dprint(FD_ZBD,
-		       "%s(%s): wait zone close and retry open zones\n",
+		       "%s(%s): wait zone write and retry write target zone selection\n",
 		       __func__, f->file_name);
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
@@ -1512,7 +1559,7 @@ retry:
 
 	zone_unlock(z);
 
-	dprint(FD_ZBD, "%s(%s): did not open another zone\n",
+	dprint(FD_ZBD, "%s(%s): did not choose another write zone\n",
 	       __func__, f->file_name);
 
 	return NULL;
@@ -1582,7 +1629,8 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint64_t min_bytes,
  * @io_u: I/O unit
  * @z: zone info pointer
  *
- * If the write command made the zone full, close it.
+ * If the write command made the zone full, remove it from the write target
+ * zones array.
  *
  * The caller must hold z->mutex.
  */
@@ -1594,7 +1642,7 @@ static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
 	if (io_u->ddir == DDIR_WRITE &&
 	    io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, z);
+		zbd_write_zone_put(td, f, z);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 	}
 }
@@ -1954,7 +2002,7 @@ retry:
 		if (zbd_zone_remainder(zb) > 0 &&
 		    zbd_zone_remainder(zb) < min_bs) {
 			pthread_mutex_lock(&f->zbd_info->mutex);
-			zbd_close_zone(td, f, zb);
+			zbd_write_zone_put(td, f, zb);
 			pthread_mutex_unlock(&f->zbd_info->mutex);
 			dprint(FD_ZBD,
 			       "%s: finish zone %d\n",
@@ -1977,11 +2025,11 @@ retry:
 			zone_lock(td, f, zb);
 		}
 
-		if (!zbd_open_zone(td, f, zb)) {
+		if (!zbd_write_zone_get(td, f, zb)) {
 			zone_unlock(zb);
-			zb = zbd_convert_to_open_zone(td, io_u);
+			zb = zbd_convert_to_write_zone(td, io_u);
 			if (!zb) {
-				dprint(FD_IO, "%s: can't convert to open zone",
+				dprint(FD_IO, "%s: can't convert to write target zone",
 				       f->file_name);
 				goto eof;
 			}
@@ -2023,7 +2071,7 @@ retry:
 			 */
 			io_u_quiesce(td);
 			zb->reset_zone = 0;
-			if (zbd_reset_zone(td, f, zb) < 0)
+			if (__zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
 
 			if (zb->capacity < min_bs) {
@@ -2142,7 +2190,7 @@ char *zbd_write_status(const struct thread_stat *ts)
  * Return io_u_completed when reset zone succeeds. Return 0 when the target zone
  * does not have write pointer. On error, return negative errno.
  */
-int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
+int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z;
diff --git a/zbd.h b/zbd.h
index 05189555..f0ac9876 100644
--- a/zbd.h
+++ b/zbd.h
@@ -29,8 +29,8 @@ enum io_u_action {
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
  * @has_wp: whether or not this zone can have a valid write pointer
- * @open: whether or not this zone is currently open. Only relevant if
- *		max_open_zones > 0.
+ * @write: whether or not this zone is the write target at this moment. Only
+ *              relevant if zbd->max_open_zones > 0.
  * @reset_zone: whether or not this zone should be reset before writing to it
  */
 struct fio_zone_info {
@@ -41,16 +41,17 @@ struct fio_zone_info {
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		has_wp:1;
-	unsigned int		open:1;
+	unsigned int		write:1;
 	unsigned int		reset_zone:1;
 };
 
 /**
  * zoned_block_device_info - zoned block device characteristics
  * @model: Device model.
- * @max_open_zones: global limit on the number of simultaneously opened
- *	sequential write zones. A zero value means unlimited open zones,
- *	and that open zones will not be tracked in the open_zones array.
+ * @max_write_zones: global limit on the number of sequential write zones which
+ *      are simultaneously written. A zero value means unlimited zones of
+ *      simultaneous writes and that write target zones will not be tracked in
+ *      the write_zones array.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
@@ -61,10 +62,10 @@ struct fio_zone_info {
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
  * @refcount: number of fio files that share this structure
- * @num_open_zones: number of open zones
+ * @num_write_zones: number of write target zones
  * @write_cnt: Number of writes since the latest zone reset triggered by
  *	       the zone_reset_frequency fio job parameter.
- * @open_zones: zone numbers of open zones
+ * @write_zones: zone numbers of write target zones
  * @zone_info: description of the individual zones
  *
  * Only devices for which all zones have the same size are supported.
@@ -73,7 +74,7 @@ struct fio_zone_info {
  */
 struct zoned_block_device_info {
 	enum zbd_zoned_model	model;
-	uint32_t		max_open_zones;
+	uint32_t		max_write_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		wp_valid_data_bytes;
@@ -82,9 +83,9 @@ struct zoned_block_device_info {
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
-	uint32_t		num_open_zones;
+	uint32_t		num_write_zones;
 	uint32_t		write_cnt;
-	uint32_t		open_zones[ZBD_MAX_OPEN_ZONES];
+	uint32_t		write_zones[ZBD_MAX_WRITE_ZONES];
 	struct fio_zone_info	zone_info[0];
 };
 
@@ -99,7 +100,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 			      enum fio_ddir ddir);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
-int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u);
+int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
 
 static inline void zbd_close_file(struct fio_file *f)
 {
diff --git a/zbd_types.h b/zbd_types.h
index 0a8630cb..5f44f308 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -8,7 +8,7 @@
 
 #include <inttypes.h>
 
-#define ZBD_MAX_OPEN_ZONES	4096
+#define ZBD_MAX_WRITE_ZONES	4096
 
 /*
  * Zoned block device models.
