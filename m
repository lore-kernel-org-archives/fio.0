Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DAB432BFF
	for <fio@vger.kernel.org>; Tue, 28 Jul 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785240012; cv=none; b=CJqblhYsmL/DyRREWFil3kyhmo30Y7pCfDLo/qayN+ZUlnT9lq7v5ch6M81SoGMite7D+XzngMkj8ZEEJdP2ANqNfgI4jMXVF3svZMVzso0+MKsgzM+2q/MbxPSUaWgq9pGML9FPwbnk6B9aHCBvo9EfcLpSCQJdDOVmcdA2Zcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785240012; c=relaxed/simple;
	bh=LgtxaixhDjFBmLKgFiATuUIfJrnhZ/qRBoSm4L/sMnk=;
	h=Subject:From:To:Date:Message-Id; b=oNLZfE7io/JYkCgYNgh8Rg9GEIPzhxXc8TrU+6pw5buVyRQrIKtLz8/LB8M/6aLSAE9iuQD6RO/lzBQhZCDCWIMql+JIhYg2kO/VPp5UY6H1i3vZETSFSt27fO1Rm9+T65zKiPNaiKwxDsvHqRfpvJUPSH0xYo0MFaJ91Un8f/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X6VzxrE8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X6VzxrE8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Nj0Ro6n2NCcqKXKCCzD34eBx1MzlxTpw0euAElbKH/g=; b=X6VzxrE8LcpLdx5nAz4RxOu4Oz
	9UiDqjGcFQsRUw7WejKrBE6Wsb/bg2ywVCXif9sr09ttcclWzJbpX2TdTXk7qPolwjTvZ6yylONMC
	0J5VuiyJczrhDa1wS5mq4suAUzOLS5xaZzC9Vj/uAi8s1mPC/d2Xj2h1BWf8UW1lNfawI337c54y/
	eNqNU/OBor+xCcXgKbUo6al0C5165DrYNmb8vATFRlVH42IdP0j434sJVf2t6DqOGH57/bnZUvE8V
	AbyqpYy6G4UHGlrmeUgmxa/Ff7NQuzg9wEOmCznceFFsGAjmVzMJ5ftGX0GGwGvbZp3CmuILFhf+s
	6o3R6pMA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wogTe-00000004tdF-0Tbr
	for fio@vger.kernel.org;
	Tue, 28 Jul 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C47C61BC0165; Tue, 28 Jul 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 28 Jul 2026 06:00:01 -0600
Message-Id: <20260728120001.C47C61BC0165@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit b384f4d3472e9dae62122c631899bac86368df63:

  ci: add Alpine Linux container test platform (2026-07-23 14:28:28 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c76c61b0fbe1b90a7886b8790805cf9903285074:

  ci: add a test for OOM issue with large iolog trims (2026-07-27 12:19:07 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      ci: add a test for OOM issue with large iolog trims

 t/jobs/t0038-397f1338.fio | 16 ++++++++++++++++
 t/jobs/t0038.iolog        | 24 ++++++++++++++++++++++++
 t/run-fio-tests.py        | 19 +++++++++++++++++++
 3 files changed, 59 insertions(+)
 create mode 100644 t/jobs/t0038-397f1338.fio
 create mode 100644 t/jobs/t0038.iolog

---

Diff of recent changes:

diff --git a/t/jobs/t0038-397f1338.fio b/t/jobs/t0038-397f1338.fio
new file mode 100644
index 00000000..80e16c96
--- /dev/null
+++ b/t/jobs/t0038-397f1338.fio
@@ -0,0 +1,16 @@
+#
+# Make sure that Fio appropriately ignores the sizes of trim commands when
+# determining how much memory to allocate when reading an iolog.
+#
+# The iolog issues large trim and small write commands. Since trim is a
+# metadata-only command in this context Fio does not need to size the data
+# buffer to accommodate the sizes of the trims.
+#
+# Expected result: Job completes without issue
+# Buggy result: Job fails with out-of-memory error
+#
+
+[test]
+read_iolog=t0038.iolog
+ioengine=null
+iodepth=128
diff --git a/t/jobs/t0038.iolog b/t/jobs/t0038.iolog
new file mode 100644
index 00000000..362dc7d0
--- /dev/null
+++ b/t/jobs/t0038.iolog
@@ -0,0 +1,24 @@
+fio version 3 iolog
+30 /dev/null add
+10731 /dev/null open
+10736 /dev/null trim 0 2147483648
+10752 /dev/null write 0 4096
+10780 /dev/null trim 4096 2147483648
+10782 /dev/null write 4096 4096
+10784 /dev/null trim 8192 2147483648
+10785 /dev/null write 8192 4096
+10787 /dev/null trim 12288 2147483648
+10788 /dev/null write 12288 4096
+10791 /dev/null trim 16384 2147483648
+10793 /dev/null write 16384 4096
+10795 /dev/null trim 20480 2147483648
+10797 /dev/null write 20480 4096
+10798 /dev/null trim 24576 2147483648
+10799 /dev/null write 24576 4096
+10801 /dev/null trim 28672 2147483648
+10802 /dev/null write 28672 4096
+10804 /dev/null trim 32768 2147483648
+10806 /dev/null write 32768 4096
+10808 /dev/null trim 36864 2147483648
+10809 /dev/null write 36864 4096
+10892 /dev/null close
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index c2f73edb..d3683a1b 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -626,6 +626,16 @@ class FioJobFileTest_iops_rate(FioJobFileTest):
             self.failure_reason = f"{self.failure_reason} iops ratio mismatch,"
             self.passed = False
 
+class FioJobFileTest_t0038(FioJobFileTest):
+    """
+    Make sure t0034 can find the iolog by copying it to the test directory.
+    """
+    def setup(self, *args, **kws):
+        super().setup(*args, **kws)
+
+        src = os.path.join(os.path.dirname(self.fio_job), 't0038.iolog')
+        shutil.copy(src, self.paths['test_dir'])
+
 
 TEST_LIST = [
     {
@@ -969,6 +979,15 @@ TEST_LIST = [
         'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
+    {
+        'test_id':          38,
+        'test_class':       FioJobFileTest_t0038,
+        'job':              't0038-397f1338.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
