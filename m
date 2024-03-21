Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22D459147
	for <fio@vger.kernel.org>; Thu, 21 Mar 2024 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711022417; cv=none; b=OWFqmh3HEIyfVGsQ5Wfa6rQIK56eCRgfGnFn4L2Xk7o/kHyMfliO/5Ujz9Dbn3SNZrh82kVag5EpTEhYubhR/zTLfUJdUi2o1WQRsKufICZENGvFU3615wu3J+62POu3EvdTXwqVYo9oyQM9ydS6wIXtaarqU+xoHUpJGmj8uj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711022417; c=relaxed/simple;
	bh=7/3i6m4xhP3dnWvDY3Ne8t1Fpok48ULag0m8OLDlhnw=;
	h=Subject:From:To:Message-Id:Date; b=ruuooSd6yRHg1Ni+MakO4ChYTyYJWEOU4/VUHMRAeasE9ncMPA0IetISxBrKjt3q+Lq9VgieWEQL9UH2wAxauxVwSgR3/UJIa9sSMbWZBGhwgohif/3na47iuFkSSSVWkQDiq7ChI2nt77JKFV1xd8LFtlSR5IsxxapxcWoMhYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EoXS13SF; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EoXS13SF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zBeggRS3CuUZw4FLUeOD1kRK0Mfmt/lE6VVy1Yz02vY=; b=EoXS13SFHREAAtwqCMAFQopJkL
	Elfhnv9mp0v+zCBCBGrkXRs94fA4tpIA9IuaaZWvQdCvjMRvQ8QRBpiOZA/toShriTPs2dDYFtREj
	ozc9CbxScmKQQEvnoPNSxDVc6brMrLQ6cYYnR0jp2OvnBPTL2GK0na7czvMqiFbGjZNvX08j2bvkj
	ofhpjBZNBj2TKy32Ecj641Eq0IN9ePnKoPrY+bB4kSCSeTBJeUi5t7aLMMWyz76aYwTF0WHcWka5F
	Ewqh2l7SM9WkkI4S9c9K9uK6Il/VKTVZpV0KP5j+X8aLbgWzx6hj8KguW3SjCQVBG8VGS7gmwMguH
	WjUAq8hw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rnH5f-00000006f9T-2RFa
	for fio@vger.kernel.org;
	Thu, 21 Mar 2024 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 548921BC019C; Thu, 21 Mar 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240321120001.548921BC019C@kernel.dk>
Date: Thu, 21 Mar 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7d6c99e917f7d68ffebbd1750802f7aed9c3d461:

  docs: fix documentation for rate_cycle (2024-03-18 14:51:10 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 140c58beeee44a10358a817c7699b66c5c7290f9:

  test: add the test for regrow logs with asynchronous I/O replay (2024-03-21 05:57:54 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      iolog: regrow logs in iolog_delay()
      test: add the test for regrow logs with asynchronous I/O replay

Vincent Fu (2):
      t/fiotestlib: pass command-line options to FioJobFileTest
      t/jobs/t0030: add test for --bandwidth-log option

 iolog.c              |  2 ++
 t/fiotestlib.py      |  8 +++++---
 t/jobs/t0030.fio     | 10 ++++++++++
 t/jobs/t0031-pre.fio |  8 ++++++++
 t/jobs/t0031.fio     |  7 +++++++
 t/run-fio-tests.py   | 19 +++++++++++++++++++
 6 files changed, 51 insertions(+), 3 deletions(-)
 create mode 100644 t/jobs/t0030.fio
 create mode 100644 t/jobs/t0031-pre.fio
 create mode 100644 t/jobs/t0031.fio

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index f52a9a80..251e9d7f 100644
--- a/iolog.c
+++ b/iolog.c
@@ -102,6 +102,8 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 		ret = io_u_queued_complete(td, 0);
 		if (ret < 0)
 			td_verror(td, -ret, "io_u_queued_complete");
+		if (td->flags & TD_F_REGROW_LOGS)
+			regrow_logs(td);
 		if (utime_since_now(&ts) > delay)
 			break;
 	}
diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index a96338a3..466e482d 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -175,7 +175,7 @@ class FioJobFileTest(FioExeTest):
 
         super().__init__(fio_path, success, testnum, artifact_root)
 
-    def setup(self, parameters=None):
+    def setup(self, parameters):
         """Setup instance variables for fio job test."""
 
         self.filenames['fio_output'] = f"{os.path.basename(self.fio_job)}.output"
@@ -185,6 +185,8 @@ class FioJobFileTest(FioExeTest):
             f"--output={self.filenames['fio_output']}",
             self.fio_job,
             ]
+        if parameters:
+            fio_args += parameters
 
         super().setup(fio_args)
 
@@ -206,7 +208,7 @@ class FioJobFileTest(FioExeTest):
                             self.testnum,
                             self.paths['artifacts'],
                             output_format=self.output_format)
-        precon.setup()
+        precon.setup(None)
         precon.run()
         precon.check_result()
         self.precon_failed = not precon.passed
@@ -412,7 +414,7 @@ def run_fio_tests(test_list, test_env, args):
                 fio_pre_success=fio_pre_success,
                 output_format=output_format)
             desc = config['job']
-            parameters = []
+            parameters = config['parameters'] if 'parameters' in config else None
         elif issubclass(config['test_class'], FioJobCmdTest):
             if not 'success' in config:
                 config['success'] = SUCCESS_DEFAULT
diff --git a/t/jobs/t0030.fio b/t/jobs/t0030.fio
new file mode 100644
index 00000000..8bbc810e
--- /dev/null
+++ b/t/jobs/t0030.fio
@@ -0,0 +1,10 @@
+# run with --bandwidth-log
+# broken behavior: seg fault
+# successful behavior: test runs to completion with 0 as the exit code
+
+[test]
+ioengine=null
+filesize=1T
+rw=read
+time_based
+runtime=2s
diff --git a/t/jobs/t0031-pre.fio b/t/jobs/t0031-pre.fio
new file mode 100644
index 00000000..ce4ee3b6
--- /dev/null
+++ b/t/jobs/t0031-pre.fio
@@ -0,0 +1,8 @@
+[job]
+rw=write
+ioengine=libaio
+size=1mb
+time_based=1
+runtime=1
+filename=t0030file
+write_iolog=iolog
diff --git a/t/jobs/t0031.fio b/t/jobs/t0031.fio
new file mode 100644
index 00000000..ae8f7442
--- /dev/null
+++ b/t/jobs/t0031.fio
@@ -0,0 +1,7 @@
+[job]
+rw=read
+ioengine=libaio
+iodepth=128
+filename=t0030file
+read_iolog=iolog
+write_lat_log=lat_log
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 08134e50..1b884d87 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -859,6 +859,25 @@ TEST_LIST = [
         'output_format':    'json',
         'requirements':     [],
     },
+    {
+        'test_id':          30,
+        'test_class':       FioJobFileTest,
+        'job':              't0030.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'parameters':       ['--bandwidth-log'],
+        'requirements':     [],
+    },
+    {
+        'test_id':          31,
+        'test_class':       FioJobFileTest,
+        'job':              't0031.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          't0031-pre.fio',
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
