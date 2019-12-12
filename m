Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729064AbfLLNAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Dec 2019 08:00:08 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifO4d-0005Jb-VZ
        for fio@vger.kernel.org; Thu, 12 Dec 2019 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191212130001.831EA1BC0155@kernel.dk>
Date: Thu, 12 Dec 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fd9882facefa0f5b09c09d2bc5cb3a2b6eabda1a:

  filesetup: ensure to setup random generator properly (2019-12-06 22:03:04 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 41ceb6c79aea52bd46ea13c5036722a294bb719e:

  t/run-fio-tests: relax acceptance criterion for t0011 (2019-12-11 20:55:07 -0700)

----------------------------------------------------------------
Vincent Fu (9):
      .gitignore: ignore zbd test output files
      t/run-fio-tests: a few small improvements
      t/run-fio-tests: detect requirements and skip tests accordingly
      t/run-fio-tests: improve Windows support
      t/run-fio-tests: identify test id for debug messages
      t/steadystate_tests: use null ioengine for tests
      .travis.yml: run t/run-fio.tests.py as part of build
      .appveyor.yml: run run-fio-tests.py
      t/run-fio-tests: relax acceptance criterion for t0011

 .appveyor.yml          |   6 +-
 .gitignore             |   1 +
 .travis.yml            |  26 +++---
 t/run-fio-tests.py     | 219 +++++++++++++++++++++++++++++++++++++++++++------
 t/steadystate_tests.py |  21 +----
 5 files changed, 219 insertions(+), 54 deletions(-)

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index ca8b2ab1..f6934096 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -13,8 +13,9 @@ environment:
       CONFIGURE_OPTIONS: --build-32bit-win --target-win-ver=xp
 
 install:
-  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib" > NUL'
-  - SET PATH=%CYG_ROOT%\bin;%PATH% #��NB: Changed env variables persist to later sections
+  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib,mingw64-%PACKAGE_ARCH%-CUnit" > NUL'
+  - SET PATH=C:\Python38-x64;%CYG_ROOT%\bin;%PATH% #��NB: Changed env variables persist to later sections
+  - python.exe -m pip install scipy
 
 build_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --disable-native --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
@@ -24,6 +25,7 @@ after_build:
 
 test_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && python.exe t/run-fio-tests.py --skip 5 --debug'
 
 artifacts:
   - path: os\windows\*.msi
diff --git a/.gitignore b/.gitignore
index f86bec64..b228938d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,3 +25,4 @@ lex.yy.c
 doc/output
 /tags
 /TAGS
+/t/zbd/test-zbd-support.log.*
diff --git a/.travis.yml b/.travis.yml
index 4a87fe6c..0017db56 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -15,19 +15,13 @@ matrix:
     - os: osx
       compiler: clang # Workaround travis setting CC=["clang", "gcc"]
       env: BUILD_ARCH="x86_64"
-    # Build using the 10.12 SDK but target and run on OSX 10.11
-#   - os: osx
-#     compiler: clang
-#     osx_image: xcode8
-#     env: SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk MACOSX_DEPLOYMENT_TARGET=10.11
-    # Build on the latest OSX version (will eventually become obsolete)
     - os: osx
       compiler: clang
-      osx_image: xcode8.3
+      osx_image: xcode9.4
       env: BUILD_ARCH="x86_64"
     - os: osx
       compiler: clang
-      osx_image: xcode9.4
+      osx_image: xcode11.2
       env: BUILD_ARCH="x86_64"
   exclude:
     - os: osx
@@ -39,17 +33,27 @@ matrix:
 before_install:
   - EXTRA_CFLAGS="-Werror"
   - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
-        pkgs=(libaio-dev libnuma-dev libz-dev librbd-dev libibverbs-dev librdmacm-dev);
+        pkgs=(libaio-dev libnuma-dev libz-dev librbd-dev libibverbs-dev librdmacm-dev libcunit1 libcunit1-dev);
         if [[ "$BUILD_ARCH" == "x86" ]]; then
             pkgs=("${pkgs[@]/%/:i386}");
-            pkgs+=(gcc-multilib);
+            pkgs+=(gcc-multilib python-scipy);
             EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32";
         else
-            pkgs+=(glusterfs-common);
+            pkgs+=(glusterfs-common python-scipy);
         fi;
         sudo apt-get -qq update;
         sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}";
     fi
+  - if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
+        brew update;
+        brew install cunit;
+        if [[ "$TRAVIS_OSX_IMAGE" == "xcode11.2" ]]; then
+            pip3 install scipy;
+        else
+            pip install scipy;
+        fi;
+    fi
 script:
   - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
   - make test
+  - sudo python3 t/run-fio-tests.py --skip 6 1007 1008
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index cf8de093..a0a1e8fa 100755
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
@@ -39,16 +39,18 @@
 #
 # TODO  run multiple tests simultaneously
 # TODO  Add sgunmap tests (requires SAS SSD)
-# TODO  automatically detect dependencies and skip tests accordingly
 #
 
 import os
 import sys
 import json
 import time
+import shutil
 import logging
 import argparse
+import platform
 import subprocess
+import multiprocessing
 from pathlib import Path
 
 
@@ -135,7 +137,7 @@ class FioExeTest(FioTest):
                                     universal_newlines=True)
             proc.communicate(timeout=self.success['timeout'])
             exticode_file.write('{0}\n'.format(proc.returncode))
-            logging.debug("return code: %d" % proc.returncode)
+            logging.debug("Test %d: return code: %d" % (self.testnum, proc.returncode))
             self.output['proc'] = proc
         except subprocess.TimeoutExpired:
             proc.terminate()
@@ -177,8 +179,8 @@ class FioExeTest(FioTest):
                     self.failure_reason = "{0} zero return code,".format(self.failure_reason)
                     self.passed = False
 
+        stderr_size = os.path.getsize(self.stderr_file)
         if 'stderr_empty' in self.success:
-            stderr_size = os.path.getsize(self.stderr_file)
             if self.success['stderr_empty']:
                 if stderr_size != 0:
                     self.failure_reason = "{0} stderr not empty,".format(self.failure_reason)
@@ -252,7 +254,7 @@ class FioJobTest(FioExeTest):
         if not self.precon_failed:
             super(FioJobTest, self).run()
         else:
-            logging.debug("precondition step failed")
+            logging.debug("Test %d: precondition step failed" % self.testnum)
 
     def check_result(self):
         if self.precon_failed:
@@ -262,15 +264,38 @@ class FioJobTest(FioExeTest):
 
         super(FioJobTest, self).check_result()
 
-        if 'json' in self.output_format:
-            output_file = open(os.path.join(self.test_dir, self.fio_output), "r")
-            file_data = output_file.read()
-            output_file.close()
+        if not self.passed:
+            return
+
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
                 self.json_data = json.loads(file_data)
             except json.JSONDecodeError:
-                self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
-                self.passed = False
+                continue
+            else:
+                logging.debug("Test %d: skipped %d lines decoding JSON data" % (self.testnum, i))
+                return
+
+        self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
+        self.passed = False
 
 
 class FioJobTest_t0005(FioJobTest):
@@ -303,7 +328,7 @@ class FioJobTest_t0006(FioJobTest):
 
         ratio = self.json_data['jobs'][0]['read']['io_kbytes'] \
             / self.json_data['jobs'][0]['write']['io_kbytes']
-        logging.debug("ratio: %f" % ratio)
+        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
         if ratio < 1.99 or ratio > 2.01:
             self.failure_reason = "{0} read/write ratio mismatch,".format(self.failure_reason)
             self.passed = False
@@ -339,7 +364,7 @@ class FioJobTest_t0008(FioJobTest):
             return
 
         ratio = self.json_data['jobs'][0]['write']['io_kbytes'] / 16568
-        logging.debug("ratio: %f" % ratio)
+        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
 
         if ratio < 0.99 or ratio > 1.01:
             self.failure_reason = "{0} bytes written mismatch,".format(self.failure_reason)
@@ -359,7 +384,7 @@ class FioJobTest_t0009(FioJobTest):
         if not self.passed:
             return
 
-        logging.debug('elapsed: %d' % self.json_data['jobs'][0]['elapsed'])
+        logging.debug('Test %d: elapsed: %d' % (self.testnum, self.json_data['jobs'][0]['elapsed']))
 
         if self.json_data['jobs'][0]['elapsed'] < 60:
             self.failure_reason = "{0} elapsed time mismatch,".format(self.failure_reason)
@@ -381,9 +406,10 @@ class FioJobTest_t0011(FioJobTest):
         iops1 = self.json_data['jobs'][0]['read']['iops']
         iops2 = self.json_data['jobs'][1]['read']['iops']
         ratio = iops2 / iops1
-        logging.debug("ratio: %f" % ratio)
+        logging.debug("Test %d: iops1: %f" % (self.testnum, iops1))
+        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
 
-        if iops1 < 999 or iops1 > 1001:
+        if iops1 < 998 or iops1 > 1002:
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
             self.passed = False
 
@@ -392,6 +418,89 @@ class FioJobTest_t0011(FioJobTest):
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
+        if platform.system() == "Windows":
+            utest_exe = "unittest.exe"
+        else:
+            utest_exe = "unittest"
+        unittest_path = os.path.join(fio_root, "unittests", utest_exe)
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
+            logging.debug("Requirements: Requirement '%s' met? %s" % (desc, value))
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
@@ -415,6 +524,7 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'pre_job':          None,
             'pre_success':      None,
+            'requirements':     [],
         },
         {
             'test_id':          2,
@@ -423,6 +533,7 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'pre_job':          't0002-13af05ae-pre.fio',
             'pre_success':      None,
+            'requirements':     [Requirements.linux, Requirements.libaio],
         },
         {
             'test_id':          3,
@@ -431,6 +542,7 @@ TEST_LIST = [
             'success':          SUCCESS_NONZERO,
             'pre_job':          't0003-0ae2c6e1-pre.fio',
             'pre_success':      SUCCESS_DEFAULT,
+            'requirements':     [Requirements.linux, Requirements.libaio],
         },
         {
             'test_id':          4,
@@ -439,6 +551,7 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'pre_job':          None,
             'pre_success':      None,
+            'requirements':     [Requirements.linux, Requirements.libaio],
         },
         {
             'test_id':          5,
@@ -448,6 +561,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [],
         },
         {
             'test_id':          6,
@@ -457,6 +571,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [Requirements.linux, Requirements.libaio],
         },
         {
             'test_id':          7,
@@ -466,6 +581,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [],
         },
         {
             'test_id':          8,
@@ -475,6 +591,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [],
         },
         {
             'test_id':          9,
@@ -484,6 +601,9 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [Requirements.not_macos,
+                                 Requirements.cpucount4],
+                                # mac os does not support CPU affinity
         },
         {
             'test_id':          10,
@@ -492,6 +612,7 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'pre_job':          None,
             'pre_success':      None,
+            'requirements':     [],
         },
         {
             'test_id':          11,
@@ -501,6 +622,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
+            'requirements':     [],
         },
         {
             'test_id':          1000,
@@ -508,6 +630,7 @@ TEST_LIST = [
             'exe':              't/axmap',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1001,
@@ -515,6 +638,7 @@ TEST_LIST = [
             'exe':              't/ieee754',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1002,
@@ -522,6 +646,7 @@ TEST_LIST = [
             'exe':              't/lfsr-test',
             'parameters':       ['0xFFFFFF', '0', '0', 'verify'],
             'success':          SUCCESS_STDERR,
+            'requirements':     [],
         },
         {
             'test_id':          1003,
@@ -529,6 +654,7 @@ TEST_LIST = [
             'exe':              't/readonly.py',
             'parameters':       ['-f', '{fio_path}'],
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1004,
@@ -536,6 +662,7 @@ TEST_LIST = [
             'exe':              't/steadystate_tests.py',
             'parameters':       ['{fio_path}'],
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1005,
@@ -543,6 +670,7 @@ TEST_LIST = [
             'exe':              't/stest',
             'parameters':       None,
             'success':          SUCCESS_STDERR,
+            'requirements':     [],
         },
         {
             'test_id':          1006,
@@ -550,6 +678,7 @@ TEST_LIST = [
             'exe':              't/strided.py',
             'parameters':       ['{fio_path}'],
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
         },
         {
             'test_id':          1007,
@@ -557,6 +686,8 @@ TEST_LIST = [
             'exe':              't/zbd/run-tests-against-regular-nullb',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [Requirements.linux, Requirements.zbd,
+                                 Requirements.root],
         },
         {
             'test_id':          1008,
@@ -564,6 +695,8 @@ TEST_LIST = [
             'exe':              't/zbd/run-tests-against-zoned-nullb',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [Requirements.linux, Requirements.zbd,
+                                 Requirements.root, Requirements.zoned_nullb],
         },
         {
             'test_id':          1009,
@@ -571,6 +704,7 @@ TEST_LIST = [
             'exe':              'unittests/unittest',
             'parameters':       None,
             'success':          SUCCESS_DEFAULT,
+            'requirements':     [Requirements.unittests],
         },
 ]
 
@@ -587,32 +721,48 @@ def parse_args():
                         help='list of test(s) to skip')
     parser.add_argument('-o', '--run-only', nargs='+', type=int,
                         help='list of test(s) to run, skipping all others')
+    parser.add_argument('-d', '--debug', action='store_true',
+                        help='provide debug output')
+    parser.add_argument('-k', '--skip-req', action='store_true',
+                        help='skip requirements checking')
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
-        fio_path = os.path.join(fio_root, "fio")
-    logging.debug("fio_path: %s" % fio_path)
+        if platform.system() == "Windows":
+            fio_exe = "fio.exe"
+        else:
+            fio_exe = "fio"
+        fio_path = os.path.join(fio_root, fio_exe)
+    print("fio path is %s" % fio_path)
+    if not shutil.which(fio_path):
+        print("Warning: fio executable not found")
 
     artifact_root = args.artifact_root if args.artifact_root else \
         "fio-test-{0}".format(time.strftime("%Y%m%d-%H%M%S"))
     os.mkdir(artifact_root)
     print("Artifact directory is %s" % artifact_root)
 
+    if not args.skip_req:
+        req = Requirements(fio_root)
+
     passed = 0
     failed = 0
     skipped = 0
@@ -621,7 +771,7 @@ def main():
         if (args.skip and config['test_id'] in args.skip) or \
            (args.run_only and config['test_id'] not in args.run_only):
             skipped = skipped + 1
-            print("Test {0} SKIPPED".format(config['test_id']))
+            print("Test {0} SKIPPED (User request)".format(config['test_id']))
             continue
 
         if issubclass(config['test_class'], FioJobTest):
@@ -651,6 +801,12 @@ def main():
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
@@ -658,6 +814,19 @@ def main():
             failed = failed + 1
             continue
 
+        if not args.skip_req:
+            skip = False
+            for req in config['requirements']:
+                ok, reason = req()
+                skip = not ok
+                logging.debug("Test %d: Requirement '%s' met? %s" % (config['test_id'], reason, ok))
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
@@ -667,6 +836,10 @@ def main():
         else:
             result = "FAILED: {0}".format(test.failure_reason)
             failed = failed + 1
+            with open(test.stderr_file, "r") as stderr_file:
+                logging.debug("Test %d: stderr:\n%s" % (config['test_id'], stderr_file.read()))
+            with open(test.stdout_file, "r") as stdout_file:
+                logging.debug("Test %d: stdout:\n%s" % (config['test_id'], stdout_file.read()))
         print("Test {0} {1}".format(config['test_id'], result))
 
     print("{0} test(s) passed, {1} failed, {2} skipped".format(passed, failed, skipped))
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index 53b0f35e..9122a60f 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -31,12 +31,7 @@ from scipy import stats
 
 def parse_args():
     parser = argparse.ArgumentParser()
-    parser.add_argument('fio',
-                        help='path to fio executable')
-    parser.add_argument('--read',
-                        help='target for read testing')
-    parser.add_argument('--write',
-                        help='target for write testing')
+    parser.add_argument('fio', help='path to fio executable')
     args = parser.parse_args()
 
     return args
@@ -123,26 +118,16 @@ if __name__ == '__main__':
               {'s': True, 'timeout': 10, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 500, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
             ]
 
-    if args.read == None:
-        if os.name == 'posix':
-            args.read = '/dev/zero'
-            extra = [ "--size=128M" ]
-        else:
-            print("ERROR: file for read testing must be specified on non-posix systems")
-            sys.exit(1)
-    else:
-        extra = []
-
     jobnum = 0
     for job in reads:
 
         tf = "steadystate_job{0}.json".format(jobnum)
         parameters = [ "--name=job{0}".format(jobnum) ]
-        parameters.extend(extra)
         parameters.extend([ "--thread",
                             "--output-format=json",
                             "--output={0}".format(tf),
-                            "--filename={0}".format(args.read),
+                            "--ioengine=null",
+                            "--size=1G",
                             "--rw=randrw",
                             "--rwmixread=100",
                             "--stonewall",

