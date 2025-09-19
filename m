Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA78F30E0EF
	for <fio@vger.kernel.org>; Fri, 19 Sep 2025 12:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758283221; cv=none; b=F9P1GXzgwQk8Z1p5T1Y8OBUN3loDNd9LG0EpMn0wCWSuNMMnV3BsKu8dei4AQVNnDkD+wgSePY7cYiFkeeOvaEKdAkXIwcqa4hSKDAeQIS1JGqvmbYC7nX+mEQ7cM4+o3LXcmEeRsCp1+dNPPiPtV+v1mFTla0xMrS3Y569evxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758283221; c=relaxed/simple;
	bh=QpGQ6kk9qoCukBreibNL9P/blxT4gpz3a4Aa0ze5S3o=;
	h=Subject:From:To:Message-Id:Date; b=pauwewqFN4h5w76i/xhy110Za22Ml/oW52NtL0Mep0LK1YgAqf360qbjw2Kgbg/U21y9HddJmr7bATu+IWXJ/tdIUmpFuQIfva5Bs0IrFMlL0EuhVvcZJh5G6xnvFQ44JyB/7xZJ5KKzM+UANs8JUKFVsNp+octtwzi9V1D2t78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pGNj36Qv; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pGNj36Qv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=/Uk6whan0Iv/+LnE1g1wkj9ZcklsmzTjLZyqRn5x0zE=; b=pGNj36QvkD4rk5PHZ8JgJ+eVym
	GO8999YvWNHKoEwP9zmLHQwXBn8aYR0FM14K21bZTRhX2DvNE/pE64A/nmd5oTn+HgZICo5LTm/IG
	kdcr4bh1t2WqkkYumghe2M2X32LVRsxIicoPlM8ttidhf6k3oWKi3iIpmPzjBonyHyx2ukCuKuC9e
	UWrmNCCAeR17AMnuAxTeux+yfhNpmpckvCK8fvB7k4qaOS3o60Sqxz6GvZl8MuHCLELwHziuQP1K/
	cpSDigSCoU9CnZBw29bH9vKQE3pnvEyU1gm9wRuZ8mzXBLDHGiv0EZ6TIGH6qdRVaU/Al9nQH+nbS
	TYI8y34w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzZma-00000007Kl3-2CB4
	for fio@vger.kernel.org;
	Fri, 19 Sep 2025 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3B0BD1BC013B; Fri, 19 Sep 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250919120001.3B0BD1BC013B@kernel.dk>
Date: Fri, 19 Sep 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 80d72cb05a6c54ea1b256dcd69e3e4fdc9294f4f:

  t/io_uring: Vectored fixed buffer test support for nvme passthrough path (2025-09-17 07:19:51 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f2c1d8f9d0c80d9e882a74c1e74fba7dfe1cd9f1:

  Merge branch 'sprandom-log-fix' of https://github.com/tomas-winkler-sndk/fio (2025-09-18 11:42:56 -0400)

----------------------------------------------------------------
Tomas Winkler (2):
      tests: add sprandom test cases
      sprandom: fix warning: comparison will always evaluate as true

Vincent Fu (2):
      Merge branch 'sprandom-tests' of https://github.com/tomas-winkler-sndk/fio
      Merge branch 'sprandom-log-fix' of https://github.com/tomas-winkler-sndk/fio

 sprandom.c         |  12 ++--
 t/run-fio-tests.py |   8 +++
 t/sprandom.py      | 158 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+), 6 deletions(-)
 create mode 100755 t/sprandom.py

---

Diff of recent changes:

diff --git a/sprandom.c b/sprandom.c
index 7262eee3..5565b1a1 100644
--- a/sprandom.c
+++ b/sprandom.c
@@ -120,11 +120,11 @@ static void print_d_array(const char *hdr, double *darray, size_t len)
 
 	buf_output_init(&out);
 
-	log_buf(&out, "[");
+	__log_buf(&out, "[");
 	for (i = 0; i < len - 1; i++)
-		log_buf(&out, "%.2f, ", darray[i]);
+		__log_buf(&out, "%.2f, ", darray[i]);
 
-	log_buf(&out, "%.2f]\n", darray[len - 1]);
+	__log_buf(&out, "%.2f]\n", darray[len - 1]);
 	if (hdr)
 		dprint(FD_SPRANDOM, "%s: ", hdr);
 
@@ -139,11 +139,11 @@ static void print_d_points(struct point *parray, size_t len)
 
 	buf_output_init(&out);
 
-	log_buf(&out, "[");
+	__log_buf(&out, "[");
 	for (i = 0; i < len - 1; i++)
-		log_buf(&out, "(%.2f %.2f), ", parray[i].x, parray[i].y);
+		__log_buf(&out, "(%.2f %.2f), ", parray[i].x, parray[i].y);
 
-	log_buf(&out, "(%.2f %.2f)]\n", parray[len - 1].x, parray[len - 1].y);
+	__log_buf(&out, "(%.2f %.2f)]\n", parray[len - 1].x, parray[len - 1].y);
 	dprint(FD_SPRANDOM, "%s", out.buf);
 	buf_output_free(&out);
 }
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index b4863297..363f2058 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1123,6 +1123,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux],
     },
+    {
+        'test_id':          1019,
+        'test_class':       FioExeTest,
+        'exe':              't/sprandom.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
 ]
 
 
diff --git a/t/sprandom.py b/t/sprandom.py
new file mode 100755
index 00000000..e1b3a5e0
--- /dev/null
+++ b/t/sprandom.py
@@ -0,0 +1,158 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (c) 2025 Sandisk Corporation or its affiliates
+
+"""
+sprandom.py
+-----------
+Tests for fio's sprandom feature.
+
+USAGE:
+  python t/sprandom.py [-f fio-executable]
+
+This script is also invoked by t/run-fio-tests.py.
+"""
+
+import sys
+import argparse
+import time
+from pathlib import Path
+
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_DEFAULT, SUCCESS_NONZERO
+
+SPRANDOM_OPT_LIST = [
+    'spr_op',
+    'spr_num_regions',
+    'size',
+    'norandommap',
+    'random_generator',
+    'rw',
+]
+
+class FioSPrandomTest(FioJobCmdTest):
+    """fio sprandom test wrapper."""
+
+    def setup(self, parameters):
+        """Setup fio arguments for the test."""
+        bs = parameters.get("bs", "4k")
+        fio_args = [
+            "--name=sprandom",
+            "--ioengine=libaio",
+            "--filename=sprandom_testfile",
+            f"--bs={bs}",
+            f"--blockalign={bs}",
+            "--direct=1",
+            "--iodepth=16",
+            "--sprandom=1",
+        ]
+
+        # Add variable parameters if provided
+
+        for opt in SPRANDOM_OPT_LIST:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+        if "rw" not in self.fio_opts:
+            fio_args.append("--rw=randwrite")
+
+        super().setup(fio_args)
+
+
+TEST_LIST = [
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "spr_op": "0.10",
+            "spr_num_regions": "50",
+            "size": "32M",
+        },
+        "success": SUCCESS_DEFAULT,
+        "test_class": FioSPrandomTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "spr_op": "0.25",
+            "spr_num_regions": "100",
+            "size": "64M",
+        },
+        "success": SUCCESS_DEFAULT,
+        "test_class": FioSPrandomTest,
+    },
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "spr_op": "0.50",
+            "spr_num_regions": "200",
+            "size": "128M",
+            "random_generator": "tausworthe",
+        },
+        "success": SUCCESS_NONZERO,
+        "test_class": FioSPrandomTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "spr_op": "0.75",
+            "spr_num_regions": "400",
+            "size": "256M",
+            "norandommap": "0"
+        },
+        "bs": "16K",
+        "success": SUCCESS_NONZERO,
+        "test_class": FioSPrandomTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "spr_op": "0.75",
+            "spr_num_regions": "400",
+            "size": "256M",
+            "rw": "randread",
+        },
+        "bs": "16K",
+        "success": SUCCESS_NONZERO,
+        "test_class": FioSPrandomTest,
+    },
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+    parser = argparse.ArgumentParser()
+    parser.add_argument("-f", "--fio",
+                        help="path to fio executable (default: fio in PATH)")
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+
+    return parser.parse_args()
+
+
+def main():
+    """Run sprandom tests."""
+    args = parse_args()
+
+    fio_path = str(Path(args.fio).absolute()) if args.fio else "fio"
+    artifact_root = args.artifact_root if args.artifact_root else \
+            f"sprandom-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    Path(artifact_root).mkdir(parents=True, exist_ok=True)
+    print(f"Artifact directory is {str(Path(artifact_root).absolute())}")
+
+    test_env = {
+        "fio_path": fio_path,
+        "fio_root": str(Path(__file__).absolute().parent.parent),
+        "artifact_root": artifact_root,
+        "basename": "sprandom"
+    }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+    sys.exit(failed)
+
+
+if __name__ == "__main__":
+    main()
