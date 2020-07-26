Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGZMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Jul 2020 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91159C0619D2
        for <fio@vger.kernel.org>; Sun, 26 Jul 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jzfK1-0006lT-68
        for fio@vger.kernel.org; Sun, 26 Jul 2020 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200726120002.491FB1BC01C4@kernel.dk>
Date: Sun, 26 Jul 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c355011a2509fdf6caa2a220e1534d61f14c4801:

  Merge branch 'sribs-patch-1039' of https://github.com/sribs/fio (2020-07-24 11:05:21 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e235e74dfd0627b17690194f957da509b8ace808:

  Merge branch 'test-cleanup' of https://github.com/vincentkfu/fio (2020-07-25 13:55:16 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      configure: error early on too old compier
      Merge branch 'check-atomics' of https://github.com/sitsofe/fio
      Merge branch 'test-cleanup' of https://github.com/vincentkfu/fio

Sitsofe Wheeler (1):
      configure: check for C11 atomics support

Vincent Fu (4):
      t/run-fio-tests: catch modprobe exceptions
      t/run-fio-tests: fix issues identified by pylint3 and pyflakes3
      ci: set PYTHONUNBUFFERED=TRUE
      t/run-fio-tests: add description to each test result line

 .appveyor.yml       |  1 +
 ci/travis-build.sh  |  1 +
 compiler/compiler.h |  7 -------
 configure           | 19 +++++++++++++++++++
 t/run-fio-tests.py  | 34 ++++++++++++++++------------------
 5 files changed, 37 insertions(+), 25 deletions(-)

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index 5f4a33e2..5c0266a1 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -18,6 +18,7 @@ environment:
 install:
   - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib,mingw64-%PACKAGE_ARCH%-CUnit" > NUL'
   - SET PATH=C:\Python38-x64;%CYG_ROOT%\bin;%PATH% # NB: Changed env variables persist to later sections
+  - SET PYTHONUNBUFFERED=TRUE
   - python.exe -m pip install scipy six
 
 build_script:
diff --git a/ci/travis-build.sh b/ci/travis-build.sh
index fff9c088..06012e89 100755
--- a/ci/travis-build.sh
+++ b/ci/travis-build.sh
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 EXTRA_CFLAGS="-Werror"
+PYTHONUNBUFFERED=TRUE
 
 if [[ "$BUILD_ARCH" == "x86" ]]; then
     EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32"
diff --git a/compiler/compiler.h b/compiler/compiler.h
index 8c0eb9d1..8a784b92 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -1,13 +1,6 @@
 #ifndef FIO_COMPILER_H
 #define FIO_COMPILER_H
 
-/* IWYU pragma: begin_exports */
-#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 9) || __clang_major__ >= 6
-#else
-#error Compiler too old, need at least gcc 4.9
-#endif
-/* IWYU pragma: end_exports */
-
 #define __must_check		__attribute__((warn_unused_result))
 
 #define __compiletime_warning(message)	__attribute__((warning(message)))
diff --git a/configure b/configure
index b079a2a5..25216c63 100755
--- a/configure
+++ b/configure
@@ -550,6 +550,25 @@ else
 fi
 print_config "Static build" "$build_static"
 
+##########################################
+# check for C11 atomics support
+cat > $TMPC <<EOF
+#include <stdatomic.h>
+int main(void)
+{
+  _Atomic unsigned v;
+  atomic_load(&v);
+  return 0;
+}
+EOF
+if ! compile_prog "" "" "C11 atomics"; then
+  echo
+  echo "Your compiler doesn't support C11 atomics. gcc 4.9/clang 3.6 are the"
+  echo "minimum versions with it - perhaps your compiler is too old?"
+  fatal "C11 atomics support not found"
+fi
+
+
 ##########################################
 # check for wordsize
 wordsize="0"
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index c116bf5a..6f1fc092 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -447,13 +447,6 @@ class FioJobTest_iops_rate(FioJobTest):
             self.passed = False
 
 
-class FioJobTest_t0013(FioJobTest):
-    """Runs fio test job t0013"""
-
-    def check_result(self):
-        super(FioJobTest_t0013, self).check_result()
-
-
 class Requirements(object):
     """Requirements consists of multiple run environment characteristics.
     These are to determine if a particular test can be run"""
@@ -485,11 +478,14 @@ class Requirements(object):
 
             Requirements._root = (os.geteuid() == 0)
             if Requirements._zbd and Requirements._root:
-                subprocess.run(["modprobe", "null_blk"],
-                               stdout=subprocess.PIPE,
-                               stderr=subprocess.PIPE)
-                if os.path.exists("/sys/module/null_blk/parameters/zoned"):
-                    Requirements._zoned_nullb = True
+                try:
+                    subprocess.run(["modprobe", "null_blk"],
+                                   stdout=subprocess.PIPE,
+                                   stderr=subprocess.PIPE)
+                    if os.path.exists("/sys/module/null_blk/parameters/zoned"):
+                        Requirements._zoned_nullb = True
+                except Exception:
+                    pass
 
         if platform.system() == "Windows":
             utest_exe = "unittest.exe"
@@ -690,13 +686,13 @@ TEST_LIST = [
         'pre_job':          None,
         'pre_success':      None,
         'output_format':    'json',
-        'requirements':     [],
         'requirements':     [Requirements.not_macos],
         # mac os does not support CPU affinity
+        # which is required for gtod offloading
     },
     {
         'test_id':          13,
-        'test_class':       FioJobTest_t0013,
+        'test_class':       FioJobTest,
         'job':              't0013.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -846,9 +842,9 @@ def main():
                 print("Invalid --pass-through argument '%s'" % arg)
                 print("Syntax for --pass-through is TESTNUMBER:ARGUMENT")
                 return
-            split = arg.split(":",1)
+            split = arg.split(":", 1)
             pass_through[int(split[0])] = split[1]
-        logging.debug("Pass-through arguments: %s" % pass_through)
+        logging.debug("Pass-through arguments: %s", pass_through)
 
     if args.fio_root:
         fio_root = args.fio_root
@@ -908,6 +904,7 @@ def main():
                 fio_pre_job=fio_pre_job,
                 fio_pre_success=fio_pre_success,
                 output_format=output_format)
+            desc = config['job']
         elif issubclass(config['test_class'], FioExeTest):
             exe_path = os.path.join(fio_root, config['exe'])
             if config['parameters']:
@@ -921,6 +918,7 @@ def main():
                 parameters += pass_through[config['test_id']].split()
             test = config['test_class'](exe_path, parameters,
                                         config['success'])
+            desc = config['exe']
         else:
             print("Test {0} FAILED: unable to process test config".format(config['test_id']))
             failed = failed + 1
@@ -935,7 +933,7 @@ def main():
                 if not reqs_met:
                     break
             if not reqs_met:
-                print("Test {0} SKIPPED ({1})".format(config['test_id'], reason))
+                print("Test {0} SKIPPED ({1}) {2}".format(config['test_id'], reason, desc))
                 skipped = skipped + 1
                 continue
 
@@ -952,7 +950,7 @@ def main():
             logging.debug("Test %d: stderr:\n%s", config['test_id'], contents)
             contents, _ = FioJobTest.get_file(test.stdout_file)
             logging.debug("Test %d: stdout:\n%s", config['test_id'], contents)
-        print("Test {0} {1}".format(config['test_id'], result))
+        print("Test {0} {1} {2}".format(config['test_id'], result, desc))
 
     print("{0} test(s) passed, {1} failed, {2} skipped".format(passed, failed, skipped))
 

