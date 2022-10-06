Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EE1C433FE
	for <fio@archiver.kernel.org>; Thu,  6 Oct 2022 12:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJFMAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Oct 2022 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJFMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Oct 2022 08:00:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EF826ADD
        for <fio@vger.kernel.org>; Thu,  6 Oct 2022 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qk+gEELCueV3TRHGv3gbmZco7TRLxY4hkIWx9YnpygI=; b=QTlBn+/R92uvd7vScXbKBb1NEc
        mn60jEXUWoeVDdMY1gf7sIx1I2/BEAI6Us9xqIwl1W0zNn+xx8iQLAeL2UgBhyOmOCpsW/gHZs6ZT
        ETb5XTjE4k4NHJhdPSji2aPm63ZVk99dQDFHyoHE/fdcaugnbCasUsGbTiXBDg42sZvdFwNP+wDjw
        cTOxF9vvMvE5diQ8Eqz9UKriY4g9+tMA7luYwsCMeklrboFfmC6YGTEYWVugqmY50SqwpsT0gX+hM
        DPunPy6wIk8rrz+yUnB1ef2EgnSyrmgsAuRZbADlVtmEGupEPmz6I3L+nNYPuFlWXqzYHgPg6LDIt
        nAc3N65w==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ogPXs-0017gz-S2
        for fio@vger.kernel.org; Thu, 06 Oct 2022 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 11CB61BC0140; Thu,  6 Oct 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221006120002.11CB61BC0140@kernel.dk>
Date:   Thu,  6 Oct 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 0474b83f022f1f1cc14208c05b7ccda682e01263:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-10-04 14:25:09 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7aeb498947d6f2d6c96b571520f12b80365fa8a1:

  test: make t0014.fio time_based (2022-10-05 18:34:41 -0400)

----------------------------------------------------------------
Vincent Fu (7):
      test: clean up randtrimwrite test
      test: check all offsets touched for randtrimwrite
      test: fix style issues in run-fio-tests.py
      test: add basic tests for trimwrite workloads
      test: fix t/run-fio-tests.py style issues identified by pylint
      test: improve run-fio-tests.py file open method
      test: make t0014.fio time_based

 t/jobs/t0014.fio   |   1 +
 t/jobs/t0023.fio   |  16 +---
 t/jobs/t0024.fio   |  36 +++++++++
 t/run-fio-tests.py | 209 ++++++++++++++++++++++++++++++++++++++---------------
 4 files changed, 190 insertions(+), 72 deletions(-)
 create mode 100644 t/jobs/t0024.fio

---

Diff of recent changes:

diff --git a/t/jobs/t0014.fio b/t/jobs/t0014.fio
index d9b45651..eb13478b 100644
--- a/t/jobs/t0014.fio
+++ b/t/jobs/t0014.fio
@@ -17,6 +17,7 @@ flow_id=1
 thread
 log_avg_msec=1000
 write_iops_log=t0014.fio
+time_based
 
 [flow1]
 flow=1
diff --git a/t/jobs/t0023.fio b/t/jobs/t0023.fio
index 0250ee1a..4f0bef89 100644
--- a/t/jobs/t0023.fio
+++ b/t/jobs/t0023.fio
@@ -6,29 +6,26 @@ rw=randtrimwrite
 log_offset=1
 per_job_logs=0
 randrepeat=0
-stonewall
+write_bw_log
 
 # Expected result: 	trim issued to random offset followed by write to same offset
 # 			all offsets touched
 # 			block sizes match
 # Buggy result: 	something else
 [basic]
-write_bw_log
 
 # Expected result: 	trim issued to random offset followed by write to same offset
 # 			all offsets trimmed
 # 			block sizes 8k for both write and trim
 # Buggy result: 	something else
 [bs]
-write_bw_log
-bs=4k,4k,8k
+bs=8k,8k,8k
 
 # Expected result: 	trim issued to random offset followed by write to same offset
 # 			all offsets trimmed
 # 			block sizes match
 # Buggy result: 	something else
 [bsrange]
-write_bw_log
 bsrange=512-4k
 
 # Expected result: 	trim issued to random offset followed by write to same offset
@@ -36,40 +33,31 @@ bsrange=512-4k
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit]
-write_bw_log
 bsrange=512/25:1k:25:2k:25:4k/25
 
 # Expected result: 	trim issued to random offset followed by write to same offset
-# 			all offsets touched
 # 			block sizes match
 # Buggy result: 	something else
 [basic_no_rm]
-write_bw_log
 norandommap=1
 
 # Expected result: 	trim issued to random offset followed by write to same offset
-# 			all offsets trimmed
 # 			block sizes 8k for both write and trim
 # Buggy result: 	something else
 [bs_no_rm]
-write_bw_log
 bs=4k,4k,8k
 norandommap=1
 
 # Expected result: 	trim issued to random offset followed by write to same offset
-# 			all offsets trimmed
 # 			block sizes match
 # Buggy result: 	something else
 [bsrange_no_rm]
-write_bw_log
 bsrange=512-4k
 norandommap=1
 
 # Expected result: 	trim issued to random offset followed by write to same offset
-# 			all offsets trimmed
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit_no_rm]
-write_bw_log
 bsrange=512/25:1k:25:2k:25:4k/25
 norandommap=1
diff --git a/t/jobs/t0024.fio b/t/jobs/t0024.fio
new file mode 100644
index 00000000..393a2b70
--- /dev/null
+++ b/t/jobs/t0024.fio
@@ -0,0 +1,36 @@
+# trimwrite data direction tests
+[global]
+filesize=1M
+ioengine=null
+rw=trimwrite
+log_offset=1
+per_job_logs=0
+randrepeat=0
+write_bw_log
+
+# Expected result: 	trim issued to sequential offsets followed by write to same offset
+# 			all offsets touched
+# 			block sizes match
+# Buggy result: 	something else
+[basic]
+
+# Expected result: 	trim issued to sequential offsets followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes 8k for both write and trim
+# Buggy result: 	something else
+[bs]
+bs=8k,8k,8k
+
+# Expected result: 	trim issued to sequential offsets followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bsrange]
+bsrange=512-4k
+
+# Expected result: 	trim issued to sequential offsets followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bssplit]
+bsrange=512/25:1k:25:2k:25:4k/25
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index a2b036d9..df87ae72 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -55,7 +55,7 @@ import multiprocessing
 from pathlib import Path
 
 
-class FioTest(object):
+class FioTest():
     """Base for all fio tests."""
 
     def __init__(self, exe_path, parameters, success):
@@ -286,6 +286,19 @@ class FioJobTest(FioExeTest):
 
         return file_data, success
 
+    def get_file_fail(self, filename):
+        """Safely read a file and fail the test upon error."""
+        file_data = None
+
+        try:
+            with open(filename, "r") as output_file:
+                file_data = output_file.read()
+        except OSError:
+            self.failure_reason += " unable to read file {0}".format(filename)
+            self.passed = False
+
+        return file_data
+
     def check_result(self):
         """Check fio job results."""
 
@@ -302,10 +315,8 @@ class FioJobTest(FioExeTest):
         if 'json' not in self.output_format:
             return
 
-        file_data, success = self.get_file(os.path.join(self.test_dir, self.fio_output))
-        if not success:
-            self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
-            self.passed = False
+        file_data = self.get_file_fail(os.path.join(self.test_dir, self.fio_output))
+        if not file_data:
             return
 
         #
@@ -427,12 +438,11 @@ class FioJobTest_t0012(FioJobTest):
             return
 
         iops_files = []
-        for i in range(1,4):
-            file_data, success = self.get_file(os.path.join(self.test_dir, "{0}_iops.{1}.log".format(os.path.basename(self.fio_job), i)))
-
-            if not success:
-                self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
-                self.passed = False
+        for i in range(1, 4):
+            filename = os.path.join(self.test_dir, "{0}_iops.{1}.log".format(os.path.basename(
+                self.fio_job), i))
+            file_data = self.get_file_fail(filename)
+            if not file_data:
                 return
 
             iops_files.append(file_data.splitlines())
@@ -448,17 +458,15 @@ class FioJobTest_t0012(FioJobTest):
 
             ratio1 = iops3/iops2
             ratio2 = iops3/iops1
-            logging.debug(
-                "sample {0}: job1 iops={1} job2 iops={2} job3 iops={3} job3/job2={4:.3f} job3/job1={5:.3f}".format(
-                    i, iops1, iops2, iops3, ratio1, ratio2
-                )
-            )
+            logging.debug("sample {0}: job1 iops={1} job2 iops={2} job3 iops={3} " \
+                "job3/job2={4:.3f} job3/job1={5:.3f}".format(i, iops1, iops2, iops3, ratio1,
+                                                             ratio2))
 
         # test job1 and job2 succeeded to recalibrate
         if ratio1 < 1 or ratio1 > 3 or ratio2 < 7 or ratio2 > 13:
-            self.failure_reason = "{0} iops ratio mismatch iops1={1} iops2={2} iops3={3} expected r1~2 r2~10 got r1={4:.3f} r2={5:.3f},".format(
-                self.failure_reason, iops1, iops2, iops3, ratio1, ratio2
-            )
+            self.failure_reason += " iops ratio mismatch iops1={0} iops2={1} iops3={2} " \
+                "expected r1~2 r2~10 got r1={3:.3f} r2={4:.3f},".format(iops1, iops2, iops3,
+                                                                        ratio1, ratio2)
             self.passed = False
             return
 
@@ -478,12 +486,11 @@ class FioJobTest_t0014(FioJobTest):
             return
 
         iops_files = []
-        for i in range(1,4):
-            file_data, success = self.get_file(os.path.join(self.test_dir, "{0}_iops.{1}.log".format(os.path.basename(self.fio_job), i)))
-
-            if not success:
-                self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
-                self.passed = False
+        for i in range(1, 4):
+            filename = os.path.join(self.test_dir, "{0}_iops.{1}.log".format(os.path.basename(
+                self.fio_job), i))
+            file_data = self.get_file_fail(filename)
+            if not file_data:
                 return
 
             iops_files.append(file_data.splitlines())
@@ -501,10 +508,9 @@ class FioJobTest_t0014(FioJobTest):
 
 
                 if ratio1 < 0.43 or ratio1 > 0.57 or ratio2 < 0.21 or ratio2 > 0.45:
-                    self.failure_reason = "{0} iops ratio mismatch iops1={1} iops2={2} iops3={3}\
-                                                expected r1~0.5 r2~0.33 got r1={4:.3f} r2={5:.3f},".format(
-                        self.failure_reason, iops1, iops2, iops3, ratio1, ratio2
-                    )
+                    self.failure_reason += " iops ratio mismatch iops1={0} iops2={1} iops3={2} " \
+                                           "expected r1~0.5 r2~0.33 got r1={3:.3f} r2={4:.3f},".format(
+                                               iops1, iops2, iops3, ratio1, ratio2)
                     self.passed = False
 
             iops1 = iops1 + float(iops_files[0][i].split(',')[1])
@@ -512,17 +518,14 @@ class FioJobTest_t0014(FioJobTest):
 
             ratio1 = iops1/iops2
             ratio2 = iops1/iops3
-            logging.debug(
-                "sample {0}: job1 iops={1} job2 iops={2} job3 iops={3} job1/job2={4:.3f} job1/job3={5:.3f}".format(
-                    i, iops1, iops2, iops3, ratio1, ratio2
-                )
-            )
+            logging.debug("sample {0}: job1 iops={1} job2 iops={2} job3 iops={3} " \
+                          "job1/job2={4:.3f} job1/job3={5:.3f}".format(i, iops1, iops2, iops3,
+                                                                       ratio1, ratio2))
 
         # test job1 and job2 succeeded to recalibrate
         if ratio1 < 0.43 or ratio1 > 0.57:
-            self.failure_reason = "{0} iops ratio mismatch iops1={1} iops2={2} expected ratio~0.5 got ratio={3:.3f},".format(
-                self.failure_reason, iops1, iops2, ratio1
-            )
+            self.failure_reason += " iops ratio mismatch iops1={0} iops2={1} expected ratio~0.5 " \
+                                   "got ratio={2:.3f},".format(iops1, iops2, ratio1)
             self.passed = False
             return
 
@@ -556,7 +559,10 @@ class FioJobTest_t0019(FioJobTest):
         super(FioJobTest_t0019, self).check_result()
 
         bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
-        file_data, success = self.get_file(bw_log_filename)
+        file_data = self.get_file_fail(bw_log_filename)
+        if not file_data:
+            return
+
         log_lines = file_data.split('\n')
 
         prev = -4096
@@ -583,7 +589,10 @@ class FioJobTest_t0020(FioJobTest):
         super(FioJobTest_t0020, self).check_result()
 
         bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
-        file_data, success = self.get_file(bw_log_filename)
+        file_data = self.get_file_fail(bw_log_filename)
+        if not file_data:
+            return
+
         log_lines = file_data.split('\n')
 
         seq_count = 0
@@ -621,7 +630,10 @@ class FioJobTest_t0022(FioJobTest):
         super(FioJobTest_t0022, self).check_result()
 
         bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
-        file_data, success = self.get_file(bw_log_filename)
+        file_data = self.get_file_fail(bw_log_filename)
+        if not file_data:
+            return
+
         log_lines = file_data.split('\n')
 
         filesize = 1024*1024
@@ -646,15 +658,20 @@ class FioJobTest_t0022(FioJobTest):
 
         if len(offsets) == filesize/bs:
             self.passed = False
-            self.failure_reason += " no duplicate offsets found with norandommap=1".format(len(offsets))
+            self.failure_reason += " no duplicate offsets found with norandommap=1"
 
 
 class FioJobTest_t0023(FioJobTest):
-    """Test consists of fio test job t0023"""
+    """Test consists of fio test job t0023 randtrimwrite test."""
+
+    def check_trimwrite(self, filename):
+        """Make sure that trims are followed by writes of the same size at the same offset."""
 
-    def check_seq(self, filename):
         bw_log_filename = os.path.join(self.test_dir, filename)
-        file_data, success = self.get_file(bw_log_filename)
+        file_data = self.get_file_fail(bw_log_filename)
+        if not file_data:
+            return
+
         log_lines = file_data.split('\n')
 
         prev_ddir = 1
@@ -668,40 +685,107 @@ class FioJobTest_t0023(FioJobTest):
             if prev_ddir == 1:
                 if ddir != 2:
                     self.passed = False
-                    self.failure_reason += " {0}: write not preceeded by trim: {1}".format(bw_log_filename, line)
+                    self.failure_reason += " {0}: write not preceeded by trim: {1}".format(
+                        bw_log_filename, line)
                     break
             else:
                 if ddir != 1:
                     self.passed = False
-                    self.failure_reason += " {0}: trim not preceeded by write: {1}".format(bw_log_filename, line)
+                    self.failure_reason += " {0}: trim not preceeded by write: {1}".format(
+                        bw_log_filename, line)
                     break
                 else:
                     if prev_bs != bs:
                         self.passed = False
-                        self.failure_reason += " {0}: block size does not match: {1}".format(bw_log_filename, line)
+                        self.failure_reason += " {0}: block size does not match: {1}".format(
+                            bw_log_filename, line)
                         break
                     if prev_offset != offset:
                         self.passed = False
-                        self.failure_reason += " {0}: offset does not match: {1}".format(bw_log_filename, line)
+                        self.failure_reason += " {0}: offset does not match: {1}".format(
+                            bw_log_filename, line)
                         break
             prev_ddir = ddir
             prev_bs = bs
             prev_offset = offset
 
 
+    def check_all_offsets(self, filename, sectorsize, filesize):
+        """Make sure all offsets were touched."""
+
+        file_data = self.get_file_fail(os.path.join(self.test_dir, filename))
+        if not file_data:
+            return
+
+        log_lines = file_data.split('\n')
+
+        offsets = set()
+
+        for line in log_lines:
+            if len(line.strip()) == 0:
+                continue
+            vals = line.split(',')
+            bs = int(vals[3])
+            offset = int(vals[4])
+            if offset % sectorsize != 0:
+                self.passed = False
+                self.failure_reason += " {0}: offset {1} not a multiple of sector size {2}".format(
+                    filename, offset, sectorsize)
+                break
+            if bs % sectorsize != 0:
+                self.passed = False
+                self.failure_reason += " {0}: block size {1} not a multiple of sector size " \
+                    "{2}".format(filename, bs, sectorsize)
+                break
+            for i in range(int(bs/sectorsize)):
+                offsets.add(offset/sectorsize + i)
+
+        if len(offsets) != filesize/sectorsize:
+            self.passed = False
+            self.failure_reason += " {0}: only {1} offsets touched; expected {2}".format(
+                filename, len(offsets), filesize/sectorsize)
+        else:
+            logging.debug("%s: %d sectors touched", filename, len(offsets))
+
+
+    def check_result(self):
+        super(FioJobTest_t0023, self).check_result()
+
+        filesize = 1024*1024
+
+        self.check_trimwrite("basic_bw.log")
+        self.check_trimwrite("bs_bw.log")
+        self.check_trimwrite("bsrange_bw.log")
+        self.check_trimwrite("bssplit_bw.log")
+        self.check_trimwrite("basic_no_rm_bw.log")
+        self.check_trimwrite("bs_no_rm_bw.log")
+        self.check_trimwrite("bsrange_no_rm_bw.log")
+        self.check_trimwrite("bssplit_no_rm_bw.log")
+
+        self.check_all_offsets("basic_bw.log", 4096, filesize)
+        self.check_all_offsets("bs_bw.log", 8192, filesize)
+        self.check_all_offsets("bsrange_bw.log", 512, filesize)
+        self.check_all_offsets("bssplit_bw.log", 512, filesize)
+
+
+class FioJobTest_t0024(FioJobTest_t0023):
+    """Test consists of fio test job t0024 trimwrite test."""
+
     def check_result(self):
+        # call FioJobTest_t0023's parent to skip checks done by t0023
         super(FioJobTest_t0023, self).check_result()
 
-        self.check_seq("basic_bw.log")
-        self.check_seq("bs_bw.log")
-        self.check_seq("bsrange_bw.log")
-        self.check_seq("bssplit_bw.log")
-        self.check_seq("basic_no_rm_bw.log")
-        self.check_seq("bs_no_rm_bw.log")
-        self.check_seq("bsrange_no_rm_bw.log")
-        self.check_seq("bssplit_no_rm_bw.log")
+        filesize = 1024*1024
 
-        # TODO make sure all offsets were touched
+        self.check_trimwrite("basic_bw.log")
+        self.check_trimwrite("bs_bw.log")
+        self.check_trimwrite("bsrange_bw.log")
+        self.check_trimwrite("bssplit_bw.log")
+
+        self.check_all_offsets("basic_bw.log", 4096, filesize)
+        self.check_all_offsets("bs_bw.log", 8192, filesize)
+        self.check_all_offsets("bsrange_bw.log", 512, filesize)
+        self.check_all_offsets("bssplit_bw.log", 512, filesize)
 
 
 class FioJobTest_iops_rate(FioJobTest):
@@ -732,7 +816,7 @@ class FioJobTest_iops_rate(FioJobTest):
             self.passed = False
 
 
-class Requirements(object):
+class Requirements():
     """Requirements consists of multiple run environment characteristics.
     These are to determine if a particular test can be run"""
 
@@ -1090,6 +1174,15 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          24,
+        'test_class':       FioJobTest_t0024,
+        'job':              't0024.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
