Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42748 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbgEUMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 21 May 2020 08:00:09 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbjrr-0003wR-6l
        for fio@vger.kernel.org; Thu, 21 May 2020 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200521120002.3683B1BC1056@kernel.dk>
Date: Thu, 21 May 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 26949a8bbc544094740c61f79b4ea778978e7d8e:

  Merge branch '32-bit-fixes' of https://github.com/sitsofe/fio (2020-05-19 16:14:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0e21f5c6f64a73bcede20e1a29a885845e453b8e:

  Merge branch 'testing' of https://github.com/vincentkfu/fio (2020-05-20 14:19:12 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'issue-989' of https://github.com/Nordix/fio
      Merge branch 'testing' of https://github.com/vincentkfu/fio

Lars Ekman (1):
      Corrected scope of for-loop

Vincent Fu (6):
      t/jsonplus2csv_test: reduce file size
      t/run-fio-tests: better catch file errors
      t/latency_percentiles: run cmdprio_percentage tests only if root
      docs: update cmdprio_percentage with note about root user
      testing: use max-jobs to speed up testing
      t/zbd: improve error handling for test scripts

 HOWTO                                 |  3 ++-
 fio.1                                 |  3 ++-
 t/jsonplus2csv_test.py                |  5 ++++-
 t/latency_percentiles.py              |  5 +++--
 t/readonly.py                         |  1 +
 t/run-fio-tests.py                    | 37 +++++++++++++++++++++++------------
 t/steadystate_tests.py                |  2 +-
 t/strided.py                          |  1 +
 t/zbd/run-tests-against-regular-nullb |  4 ++--
 t/zbd/run-tests-against-zoned-nullb   |  2 +-
 tools/plot/fio2gnuplot                |  8 ++++----
 11 files changed, 45 insertions(+), 26 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 430c7b62..cd628552 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2040,7 +2040,8 @@ with the caveat that when used on the command line, they must come after the
     the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentage``.
     This option cannot be used with the `prio` or `prioclass` options. For this
     option to set the priority bit properly, NCQ priority must be supported and
-    enabled and :option:`direct`\=1 option must be used.
+    enabled and :option:`direct`\=1 option must be used. fio must also be run as
+    the root user.
 
 .. option:: fixedbufs : [io_uring]
 
diff --git a/fio.1 b/fio.1
index a2379f98..9e9e1b1a 100644
--- a/fio.1
+++ b/fio.1
@@ -1806,7 +1806,8 @@ Set the percentage of I/O that will be issued with higher priority by setting
 the priority bit. Non-read I/O is likely unaffected by ``cmdprio_percentage``.
 This option cannot be used with the `prio` or `prioclass` options. For this
 option to set the priority bit properly, NCQ priority must be supported and
-enabled and `direct=1' option must be used.
+enabled and `direct=1' option must be used. fio must also be run as the root
+user.
 .TP
 .BI (io_uring)fixedbufs
 If fio is asked to do direct IO, then Linux will map pages for each IO call, and
diff --git a/t/jsonplus2csv_test.py b/t/jsonplus2csv_test.py
index 2b34ef25..f01a9f32 100755
--- a/t/jsonplus2csv_test.py
+++ b/t/jsonplus2csv_test.py
@@ -44,6 +44,7 @@ def run_fio(fio):
         fio     path to fio executable.
     """
 
+# We need an async ioengine to get submission latencies
     if platform.system() == 'Linux':
         aio = 'libaio'
     elif platform.system() == 'Windows':
@@ -52,13 +53,14 @@ def run_fio(fio):
         aio = 'posixaio'
 
     fio_args = [
+        "--max-jobs=4",
         "--output=fio-output.json",
         "--output-format=json+",
         "--filename=fio_jsonplus_clat2csv.test",
         "--ioengine=" + aio,
         "--time_based",
         "--runtime=3s",
-        "--size=1G",
+        "--size=1M",
         "--slat_percentiles=1",
         "--clat_percentiles=1",
         "--lat_percentiles=1",
@@ -87,6 +89,7 @@ def check_output(fio_output, script_path):
     """
 
     if fio_output.returncode != 0:
+        print("ERROR: fio run failed")
         return False
 
     if platform.system() == 'Windows':
diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
index 5cdd49cf..6ce4579a 100755
--- a/t/latency_percentiles.py
+++ b/t/latency_percentiles.py
@@ -109,6 +109,7 @@ class FioLatTest():
         """Run a test."""
 
         fio_args = [
+            "--max-jobs=16",
             "--name=latency",
             "--randrepeat=0",
             "--norandommap",
@@ -1303,9 +1304,9 @@ def main():
            (args.run_only and test['test_id'] not in args.run_only):
             skipped = skipped + 1
             outcome = 'SKIPPED (User request)'
-        elif platform.system() != 'Linux' and 'cmdprio_percentage' in test:
+        elif (platform.system() != 'Linux' or os.geteuid() != 0) and 'cmdprio_percentage' in test:
             skipped = skipped + 1
-            outcome = 'SKIPPED (Linux required for cmdprio_percentage tests)'
+            outcome = 'SKIPPED (Linux root required for cmdprio_percentage tests)'
         else:
             test_obj = test['test_obj'](artifact_root, test, args.debug)
             status = test_obj.run_fio(fio)
diff --git a/t/readonly.py b/t/readonly.py
index 43686c9c..464847c6 100755
--- a/t/readonly.py
+++ b/t/readonly.py
@@ -36,6 +36,7 @@ def parse_args():
 
 def run_fio(fio, test, index):
     fio_args = [
+                "--max-jobs=16",
                 "--name=readonly",
                 "--ioengine=null",
                 "--time_based",
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 8e326ed5..763e0103 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -226,6 +226,7 @@ class FioJobTest(FioExeTest):
         self.json_data = None
         self.fio_output = "{0}.output".format(os.path.basename(self.fio_job))
         self.fio_args = [
+            "--max-jobs=16",
             "--output-format={0}".format(self.output_format),
             "--output={0}".format(self.fio_output),
             self.fio_job,
@@ -273,6 +274,20 @@ class FioJobTest(FioExeTest):
         else:
             logging.debug("Test %d: precondition step failed", self.testnum)
 
+    @classmethod
+    def get_file(cls, filename):
+        """Safely read a file."""
+        file_data = ''
+        success = True
+
+        try:
+            with open(filename, "r") as output_file:
+                file_data = output_file.read()
+        except OSError:
+            success = False
+
+        return file_data, success
+
     def check_result(self):
         """Check fio job results."""
 
@@ -289,10 +304,8 @@ class FioJobTest(FioExeTest):
         if 'json' not in self.output_format:
             return
 
-        try:
-            with open(os.path.join(self.test_dir, self.fio_output), "r") as output_file:
-                file_data = output_file.read()
-        except EnvironmentError:
+        file_data, success = self.get_file(os.path.join(self.test_dir, self.fio_output))
+        if not success:
             self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
             self.passed = False
             return
@@ -457,11 +470,9 @@ class Requirements(object):
         Requirements._linux = platform.system() == "Linux"
 
         if Requirements._linux:
-            try:
-                config_file = os.path.join(fio_root, "config-host.h")
-                with open(config_file, "r") as config:
-                    contents = config.read()
-            except Exception:
+            config_file = os.path.join(fio_root, "config-host.h")
+            contents, success = FioJobTest.get_file(config_file)
+            if not success:
                 print("Unable to open {0} to check requirements".format(config_file))
                 Requirements._zbd = True
             else:
@@ -899,10 +910,10 @@ def main():
         else:
             result = "FAILED: {0}".format(test.failure_reason)
             failed = failed + 1
-            with open(test.stderr_file, "r") as stderr_file:
-                logging.debug("Test %d: stderr:\n%s", config['test_id'], stderr_file.read())
-            with open(test.stdout_file, "r") as stdout_file:
-                logging.debug("Test %d: stdout:\n%s", config['test_id'], stdout_file.read())
+            contents, _ = FioJobTest.get_file(test.stderr_file)
+            logging.debug("Test %d: stderr:\n%s", config['test_id'], contents)
+            contents, _ = FioJobTest.get_file(test.stdout_file)
+            logging.debug("Test %d: stdout:\n%s", config['test_id'], contents)
         print("Test {0} {1}".format(config['test_id'], result))
 
     print("{0} test(s) passed, {1} failed, {2} skipped".format(passed, failed, skipped))
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index b55a67ac..e99b655c 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -122,7 +122,7 @@ if __name__ == '__main__':
     for job in reads:
 
         tf = "steadystate_job{0}.json".format(jobnum)
-        parameters = [ "--name=job{0}".format(jobnum) ]
+        parameters = [ "--max-jobs=16", "--name=job{0}".format(jobnum) ]
         parameters.extend([ "--thread",
                             "--output-format=json",
                             "--output={0}".format(tf),
diff --git a/t/strided.py b/t/strided.py
index aac15d10..6d34be8a 100755
--- a/t/strided.py
+++ b/t/strided.py
@@ -52,6 +52,7 @@ def parse_args():
 def run_fio(fio, test, index):
     filename = "strided"
     fio_args = [
+                "--max-jobs=16",
                 "--name=strided",
                 "--zonemode=strided",
                 "--log_offset=1",
diff --git a/t/zbd/run-tests-against-regular-nullb b/t/zbd/run-tests-against-regular-nullb
index 0f6e4b66..5b7b4009 100755
--- a/t/zbd/run-tests-against-regular-nullb
+++ b/t/zbd/run-tests-against-regular-nullb
@@ -8,7 +8,7 @@ scriptdir="$(cd "$(dirname "$0")" && pwd)"
 
 for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
 modprobe -r null_blk
-modprobe null_blk nr_devices=0 || return $?
+modprobe null_blk nr_devices=0 || exit $?
 for d in /sys/kernel/config/nullb/*; do
     [ -d "$d" ] && rmdir "$d"
 done
@@ -22,6 +22,6 @@ modprobe null_blk nr_devices=0 &&
     echo 4096 > blocksize &&
     echo 1024 > size &&
     echo 1 > memory_backed &&
-    echo 1 > power
+    echo 1 > power || exit $?
 
 "${scriptdir}"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
index 0952011c..53aee3e8 100755
--- a/t/zbd/run-tests-against-zoned-nullb
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -8,7 +8,7 @@ scriptdir="$(cd "$(dirname "$0")" && pwd)"
 
 for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
 modprobe -r null_blk
-modprobe null_blk nr_devices=0 || return $?
+modprobe null_blk nr_devices=0 || exit $?
 for d in /sys/kernel/config/nullb/*; do
     [ -d "$d" ] && rmdir "$d"
 done
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index cc4ea4c7..69aa791e 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -93,10 +93,10 @@ set style line 1 lt 1 lw 3 pt 3 linecolor rgb "green"
 		compare_smooth.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
 		compare_trend.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
 
-		pos=0
-		# Let's create a temporary file for each selected fio file
-		for file in fio_data_file:
-			tmp_filename = "gnuplot_temp_file.%d" % pos
+	pos=0
+	# Let's create a temporary file for each selected fio file
+	for file in fio_data_file:
+		tmp_filename = "gnuplot_temp_file.%d" % pos
 
 		# Plotting comparing graphs doesn't have a meaning unless if there is at least 2 traces
 		if len(fio_data_file) > 1:

