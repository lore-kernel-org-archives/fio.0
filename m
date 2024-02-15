Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1889712D74E
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708002017; cv=none; b=YhhUKcwny7cjjjnb8fbETCZZRQixpRsBt570ouQKEIrsFSk9z6UuWOsPP4SrIKFHVMeRRARo6wjfPJggLOMBQffG4qCb00IzrdF4VSi83tB0i2fhJfyvfGFJSM9w0ERBlpXi+z7y09UU8uM+ILC0zdEjCICmG3gIeVIB5EOk7U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708002017; c=relaxed/simple;
	bh=xOZS6VCK/Z41sKE551R9LBZM4FY9COC0pIQ57RyNy4I=;
	h=Subject:From:To:Message-Id:Date; b=TYfc6d58f7yXeNb3Z8OFAA+r3dl6j+RH/U5r1OLt1qC7C/GYSdGoa7RZpTCLnE/vBYjDLp+BOcmrfLyLieGV9nCyzGVyJVvEa5Cyn7kO5eZ988yjMEE/qrWqWigNkobwWAZTHvuW6R2N4reuHvG1Fz2vL+pfc4Jxe58Keyhph7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rOBJz7sy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rOBJz7sy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Xd6LTy8H302VpvyxxUTKlu7ArUWMNM1oq5JtWCTaX4g=; b=rOBJz7syaHprLe8Jr36xWnyUZo
	SgIXjFN9mvNcY/Mh3IsYeKARa5li+hDzkmVDo6mrQjPef5nh05p7ioldRQIY4VGm8x5FhAyQeRMHO
	K8g1OQainVzyyZz9pL2IlaldynT3gCUAMCwDpOuOeW6NsRSd5HI9TG93FOebe5rQEumDs7VnhO2kD
	P35II5+1a1AvLi+rJCD1VjlDor5kPNRZaMQlnsJ8uKUmvgxfn0YHgG/LFTmT+vTBfu6Xa8IR56uFL
	5zgQVJTYGuZwWEVOANCMxGrjlFaBm7rf+vM4N0gWj0FvailisylboWHDnsFZe+AYJmvKB+FLUaWkO
	yStOFJfA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rabLP-00000001tdr-1vB7
	for fio@vger.kernel.org;
	Thu, 15 Feb 2024 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id BCFF51BC0185; Thu, 15 Feb 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240215130001.BCFF51BC0185@kernel.dk>
Date: Thu, 15 Feb 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a99bd37f690ab246caa9b9d65adfa65a25967190:

  examples: add PI example with xnvme ioengine (2024-02-13 14:24:59 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7aec5ac0bdd1adcaeba707f26d5bc583de6ab6c9:

  test: add the test for loops option and read-verify workloads (2024-02-14 07:39:48 -0700)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      verify: fix loops option behavior of read-verify workloads
      test: add the test for loops option and read-verify workloads

 io_u.c             |  3 ++-
 t/jobs/t0029.fio   | 14 ++++++++++++++
 t/run-fio-tests.py | 21 +++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 t/jobs/t0029.fio

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 13187882..4254675a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2151,7 +2151,8 @@ static void io_u_update_bytes_done(struct thread_data *td,
 
 	if (td->runstate == TD_VERIFYING) {
 		td->bytes_verified += icd->bytes_done[DDIR_READ];
-		return;
+		if (td_write(td))
+			return;
 	}
 
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
diff --git a/t/jobs/t0029.fio b/t/jobs/t0029.fio
new file mode 100644
index 00000000..481de6f3
--- /dev/null
+++ b/t/jobs/t0029.fio
@@ -0,0 +1,14 @@
+[global]
+filename=t0029file
+size=4k
+verify=md5
+
+[write]
+rw=write
+do_verify=0
+
+[read]
+stonewall=1
+rw=read
+loops=2
+do_verify=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 1448f7cb..2f76d3fc 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -542,6 +542,17 @@ class FioJobFileTest_t0027(FioJobFileTest):
         if data != self.pattern:
             self.passed = False
 
+class FioJobFileTest_t0029(FioJobFileTest):
+    """Test loops option works with read-verify workload."""
+    def check_result(self):
+        super().check_result()
+
+        if not self.passed:
+            return
+
+        if self.json_data['jobs'][1]['read']['io_kbytes'] != 8:
+            self.passed = False
+
 class FioJobFileTest_iops_rate(FioJobFileTest):
     """Test consists of fio test job t0011
     Confirm that job0 iops == 1000
@@ -838,6 +849,16 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          29,
+        'test_class':       FioJobFileTest_t0029,
+        'job':              't0029.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
