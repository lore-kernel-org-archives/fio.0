Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795006810;
	b=LNXpfHWpuKC9O3sfFDC6xrhQf/UhzRtzFSAkuTaTHM0a7oBmWkRF8cd6XEG+qg+FGfxc
	 qjDA9LttkPIxmnyqn3/fnUgs0jey7d80XrIE+bQ5fejM4EEA9jIXVDG551SJX4zaZ3zcB
	 +wmWr1EzthWEihZ+OG6QCqgb7yEB7L/5u+YVzm1s0rqVqLX4XdYiuGxJVOtCPFwPNh1I/
	 RvElK1PTvnLN8jCnYrYFFjfYsqmVy9eWMf+7vBFwn+M/V29BKqTIIJ4is2bNhVOmMQoHn
	 N0Uw6mgEV4cMvHhmmBPCRfrSsk1aoXi1oSls/qa0lMEHDhUkUALrT/JPQd2aWZtoSaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795006810;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=LmNdYBU6YCQhPFGSMZibEO28xH9ShFuytYBQSECq9fs=;
	b=1vBU9/131W9ax/pyc63UYuXtOB8PdQn3mCekG3f4dWrHhnSsbQc7S+Mk4b2l7i/GUH3g
	 XTYdqfdO7yFzfRQwIPQEN8ySkcGbM3gpI24MJ4z4ALCFC+sVzbUftGs/Dz/Npv3CoDf7A
	 nZha35an+Q14i6BlS8/RUdcsTgYUQTChc1J9xT00g/6fS/Hl2gRiw8yhi6zJwQgT8Ohor
	 Y8kHJddJooIuTnL3SQ9Rm6zwg3Rbg1Z87873DVwFrNWnboRTHL0OyZ8w5e0NwfeHV3MR2
	 5Jc1BM9I6SrY9JUwTFHU2+nvffMF6oXAYdMB7Xy7+MYutU6mUKWCl/za/xvAhNHIahQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=hTr1JYUh;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D835606A339
	for <fio@vger.kernel.org>; Wed, 18 Nov 2026 13:00:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D835606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=hTr1JYUh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=LmNdYBU6YCQhPFGSMZibEO28xH9ShFuytYBQSECq9fs=; b=hTr1JYUhqknd0aeVrym+pw5ETd
	9DjcUfV4zxfiQc35jARGouMeCWYnWolDnazrxconjnJqCyCBGF+QfUr/YM+/eMaQhLK4NmtoT8WMA
	wNIIDdQgU589WvGWnw2yBNw8bauEbMDiTGIp95V8XBuXNpoux/h2i7+7HVJZO3qAIb3T6lPUSzsky
	zHDeV47+3LvKz4l6ipz/RgXuEquZwFbkVQFUugeh06UXTle1mi55sHHkbjD+oTl10nmRFaIa5j4AQ
	Z4526qSLbii2Ygic4q11hNCnvGpGbtKTQvxT0fSro+iWcpE+DLEp2u9vX6bNEL29eVXTt2fnL8zX7
	W6YmQtiw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTfGf-0000000DZ5n-2idS
	for fio@vger.kernel.org;
	Wed, 18 Nov 2026 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E2E681BC016B; Wed, 18 Nov 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 18 Nov 2026 06:00:01 -0700
Message-Id: <20261118130001.E2E681BC016B@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 6abe06547f4ad296ea62cd1a2d55fc5274059c77:

  Merge branch 'fix/verify-default-stack-20261111' of https://github.com/ooonea/fio (2026-11-16 11:25:16 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to af034f21a61a1e9eb3af281fafdfe93fbf783c36:

  lib/rand: start every seed bucket odd in __fill_random_buf() (2026-11-16 21:42:29 -0500)

----------------------------------------------------------------
Vincent Fu (2):
      test: add test for compressible random buffers
      lib/rand: start every seed bucket odd in __fill_random_buf()

 lib/rand.c         | 12 ++++++++++--
 t/jobs/t0039.fio   | 21 +++++++++++++++++++++
 t/run-fio-tests.py | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 2 deletions(-)
 create mode 100644 t/jobs/t0039.fio

---

Diff of recent changes:

diff --git a/lib/rand.c b/lib/rand.c
index 0e787a62..35981741 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -112,8 +112,8 @@ void __fill_random_buf_small(void *buf, unsigned int len, uint64_t seed)
 
 void __fill_random_buf(void *buf, unsigned int len, uint64_t seed)
 {
-	static uint64_t prime[] = {1, 2, 3, 5, 7, 11, 13, 17,
-				   19, 23, 29, 31, 37, 41, 43, 47};
+	static uint64_t prime[] = {1, 3, 5, 7, 11, 13, 17, 19,
+				   23, 29, 31, 37, 41, 43, 47, 53};
 	uint64_t *b, *e, s[CONFIG_SEED_BUCKETS];
 	unsigned int rest;
 	int p;
@@ -128,6 +128,14 @@ void __fill_random_buf(void *buf, unsigned int len, uint64_t seed)
 
 	rest = len - (rest * sizeof(*b));
 
+	/*
+	 * Each bucket advances by s *= GOLDEN_RATIO_64, which preserves the
+	 * number of trailing zero bits in s. Start every bucket odd (an odd
+	 * seed times an odd multiplier), otherwise a seed with several
+	 * trailing zeros leaves the low byte of every word with only a few
+	 * distinct values and the buffer becomes compressible.
+	 */
+	seed |= 1;
 	for (p = 0; p < CONFIG_SEED_BUCKETS; p++)
 		s[p] = seed * prime[p];
 
diff --git a/t/jobs/t0039.fio b/t/jobs/t0039.fio
new file mode 100644
index 00000000..3a92e4a8
--- /dev/null
+++ b/t/jobs/t0039.fio
@@ -0,0 +1,21 @@
+#
+# Make sure buffers filled with random data are not compressible.
+#
+# A weakness in __fill_random_buf() (GitHub issue #2157) let seeds with
+# several trailing zero bits carry those zeros into every 64-bit word,
+# leaving the low byte of each word with only a few distinct values.
+# About 11% of 8 KiB buffers then compressed by hundreds of bytes.
+#
+# Expected result: (almost) no 8 KiB block compresses by >= 128 bytes
+# Buggy result: roughly 11% of blocks compress by >= 128 bytes
+#
+# run-fio-tests.py checks the contents of the written file.
+#
+
+[test]
+filename=t0039file
+rw=write
+bs=8k
+size=16M
+refill_buffers=1
+buffer_compress_percentage=0
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index d3683a1b..7fe7143b 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -48,6 +48,7 @@ import shutil
 import logging
 import argparse
 import re
+import zlib
 from pathlib import Path
 from statsmodels.sandbox.stats.runs import runstest_1samp
 from fiotestlib import FioExeTest, FioJobFileTest, run_fio_tests
@@ -637,6 +638,46 @@ class FioJobFileTest_t0038(FioJobFileTest):
         shutil.copy(src, self.paths['test_dir'])
 
 
+class FioJobFileTest_t0039(FioJobFileTest):
+    """
+    Make sure random buffers are not compressible. Compress each 8 KiB
+    block written by t0039.fio on its own and count the blocks that
+    shrink by at least 128 bytes. With the bug about 11% of blocks do; with
+    the fix almost none do.
+    """
+    BLOCK_SIZE = 8192
+    MIN_SAVING = 128
+    MAX_FRACTION = 0.01
+
+    def check_result(self):
+        super().check_result()
+
+        if not self.passed:
+            return
+
+        output_file = os.path.join(self.paths['test_dir'], "t0039file")
+        with open(output_file, "rb") as f:
+            data = f.read()
+
+        blocks = len(data) // self.BLOCK_SIZE
+        if blocks == 0:
+            self.failure_reason += " no data written,"
+            self.passed = False
+            return
+
+        compressible = 0
+        for i in range(blocks):
+            block = data[i * self.BLOCK_SIZE:(i + 1) * self.BLOCK_SIZE]
+            if len(zlib.compress(block, 1)) <= self.BLOCK_SIZE - self.MIN_SAVING:
+                compressible += 1
+
+        logging.debug("Test %d: %d/%d blocks compressible", self.testnum,
+                      compressible, blocks)
+        if compressible > blocks * self.MAX_FRACTION:
+            self.failure_reason += f" {compressible}/{blocks} blocks compressible,"
+            self.passed = False
+
+
 TEST_LIST = [
     {
         'test_id':          1,
@@ -988,6 +1029,15 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          39,
+        'test_class':       FioJobFileTest_t0039,
+        'job':              't0039.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
