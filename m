Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219312DA74C
	for <fio@vger.kernel.org>; Tue,  2 Jun 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780401612; cv=none; b=E/aIqO9Jp4r2/E6cUK15UqV2SHvxjntzkIkXpFvW7uZmIz3AHKzIPKCHVHf66DVSvnlrYslfk8cBsLbadREQATg5IU1keoXFuHUpbijynb800uIzAznVHGRlPvOa38z80jaMzyPvh8tCWUhr35rQm1aIjUJO1c3Qsd3FXbzHKq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780401612; c=relaxed/simple;
	bh=KiRX8FjsRS8Xb3b8ff9M4WyjLaxGSHX454jbLy6JcHM=;
	h=Subject:From:To:Date:Message-Id; b=N8wvmmdaDmxaKmp0exOsN0gEa+gjguziaE/veJdhLygE15Ke1o6IZjuTw+8RF5ZJK4U5PMrnsOAAYoymI/pFkPh1o00kw/2mDHlfBgEJFKB9e+Lj5Y1slbJKd6a2F267dmXbvuOVaq0A++LNETAikDhimdNZlXJOHg/trupLf6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ocVOXnq9; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ocVOXnq9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=AkHQdcrwnaGT3qfhrAZAVr6eq/OUgTefnoHDgBlovaQ=; b=ocVOXnq9BIkzWauQmTMQs9NCyZ
	MAWIIiNIBSuTgfn5uoOMbFTrxENWFysRdsHEdJ08yrORjq3NGOsY7l82bKULa97KLsGRRwgNJQwbA
	kswSeu/F0shn1tMXl3TsU6rtwlIsXJH428UMhmDL0lkHoDDprw9PugRIijSpO5SfwmjTseuSXc8id
	qaa2x3YoSw3J9cSdMmn74oeNDnBmgFo3mLW2ALEwdqgHJMYJC39H0OyPJDQfu/w5l744JtX78NvV/
	NnqXMjHloSMzmJr5CmkcAjGgJZYLYrKjZJTgN7W+kWlqjexeo6TmZGX0KwTaWB6JKQbwP1YuGQJ/n
	b2SCGFYQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUNmu-00000001tbb-25dC
	for fio@vger.kernel.org;
	Tue, 02 Jun 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D42651BC0171; Tue,  2 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue,  2 Jun 2026 06:00:01 -0600
Message-Id: <20260602120001.D42651BC0171@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6a66cccb6cb2b321e107b97733faac4db4d95ebc:

  Merge branch 'fix-musl-prctl-conflict' of https://github.com/lucashecht/fio (2026-05-28 10:30:47 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e682f9b3406e35a28a87f39789e3a0c6138b30b4:

  ci: add nvmept_write_mode.py to test harness (2026-06-01 14:38:22 -0400)

----------------------------------------------------------------
Swarna Prabhu (1):
      engines/nvme: fix addr/data_len for no data nvme commands

Vincent Fu (3):
      Merge branch 'fio_5_27' of https://github.com/swarnagh6/fio
      t/nvmept_write_mode.py: test script for io_uring_cmd write modes
      ci: add nvmept_write_mode.py to test harness

 .github/workflows/qemu.yml |   2 +-
 engines/nvme.c             |  20 +++-
 t/nvmept_write_mode.py     | 282 +++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py         |   8 ++
 4 files changed, 306 insertions(+), 6 deletions(-)
 create mode 100755 t/nvmept_write_mode.py

---

Diff of recent changes:

diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index 8160d43e..ba0a00ac 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -18,7 +18,7 @@ jobs:
               -device nvme,id=nvme0,serial=deadbeef
               -drive id=nvm-0,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
               -device nvme-ns,id=nvm-0,drive=nvm-0,bus=nvme0,nsid=1
-            test_cmd: "python3 t/run-fio-tests.py --nvmecdev /dev/ng0n1 --run-only 1014 1015"
+            test_cmd: "python3 t/run-fio-tests.py --nvmecdev /dev/ng0n1 --run-only 1014 1015 1022 -p '1022:--skip 30 31 32 33 34'"
             extra_pkgs: "nvme-cli"
           - config: 16-bit Guard PI tests (long)
             device: >-
diff --git a/engines/nvme.c b/engines/nvme.c
index 528b2a29..e480fce0 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -390,12 +390,22 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		cmd->addr = (__u64)(uintptr_t)iov;
 		cmd->data_len = 1;
 	} else {
-		/* no buffer for write zeroes */
-		if (cmd->opcode != nvme_cmd_write_zeroes)
+		/* use buffer only for data transfer commands */
+		switch (cmd->opcode) {
+		case nvme_cmd_read:
+		case nvme_cmd_write:
+		case nvme_cmd_compare:
 			cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
-		else
-			cmd->addr = (__u64)(uintptr_t)NULL;
-		cmd->data_len = io_u->xfer_buflen;
+			cmd->data_len = io_u->xfer_buflen;
+			break;
+		case nvme_cmd_write_zeroes:
+		case nvme_cmd_write_uncor:
+		case nvme_cmd_verify:
+			/* since cmd->addr and cmd->data_len is set to 0 by memset */
+			break;
+		default:
+			return -ENOTSUP;
+		}
 	}
 	if (data->lba_shift && data->ms) {
 		cmd->metadata = (__u64)(uintptr_t)io_u->mmap_data;
diff --git a/t/nvmept_write_mode.py b/t/nvmept_write_mode.py
new file mode 100755
index 00000000..b52bd8b0
--- /dev/null
+++ b/t/nvmept_write_mode.py
@@ -0,0 +1,282 @@
+#!/usr/bin/env python3
+#
+# Copyright 2026 Samsung Electronics Co., Ltd All Rights Reserved
+#
+# For conditions of distribution and use, see the accompanying COPYING file.
+#
+"""
+# nvmept_write_mode.py
+#
+# Test fio's io_uring_cmd ioengine with NVMe pass-through write modes
+#
+# USAGE
+# see python3 nvmept_write_mode.py --help
+#
+# EXAMPLES
+# python3 t/nvmept_write_mode.py --dut /dev/ng0n1
+# python3 t/nvmept_write_mode.py --dut /dev/ng1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+import os
+import sys
+import time
+import logging
+import argparse
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+
+class WriteModeTest(FioJobCmdTest):
+    """
+    NVMe pass-through test class. Check to make sure output for selected data
+    direction(s) is non-zero and that zero data appears for other directions.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=nvmept-write-mode",
+            "--ioengine=io_uring_cmd",
+            "--cmd_type=nvme",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.fio_opts['output-format']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'num_range',
+                    'iodepth', 'iodepth_batch', 'iodepth_batch_complete',
+                    'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
+                    'buffer_pattern', 'verify_pattern', 'verify', 'offset',
+                    'filesize', 'write_mode', ]:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+    def check_result(self):
+
+        super().check_result()
+
+        if 'rw' not in self.fio_opts or \
+                not self.passed or \
+                'json' not in self.fio_opts['output-format']:
+            return
+
+        job = self.json_data['jobs'][0]
+
+        if self.fio_opts['rw'] in ['read', 'randread']:
+            self.passed = self.check_all_ddirs(['read'], job)
+        elif self.fio_opts['rw'] in ['write', 'randwrite']:
+            if 'verify' not in self.fio_opts:
+                self.passed = self.check_all_ddirs(['write'], job)
+            else:
+                self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trim', 'randtrim']:
+            self.passed = self.check_all_ddirs(['trim'], job)
+        elif self.fio_opts['rw'] in ['readwrite', 'randrw']:
+            self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trimwrite', 'randtrimwrite']:
+            self.passed = self.check_all_ddirs(['trim', 'write'], job)
+        else:
+            logging.error("Unhandled rw value %s", self.fio_opts['rw'])
+            self.passed = False
+
+TEST_SIZE="16M"
+
+TEST_LIST = [
+    {
+        # Use write_mode=write to precondition device for write_mode=verify
+        # which just tells the device to check the integrity of the stored data
+        "test_id": 10,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "write",
+            "randrepeat": 0,
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+    },
+    {
+        "test_id": 11,
+        "fio_opts": {
+            "rw": 'write',
+            "filesize": TEST_SIZE,
+            "write_mode": "verify",
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+    },
+    {
+        "test_id": 12,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "verify",
+            "randrepeat": 0,
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+    },
+
+    {
+        # Precondition device using write zeroes. Then use pattern verification
+        # to read everything back
+        "test_id": 20,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "zeroes",
+            "randrepeat": 0,
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+    },
+    {
+        "test_id": 21,
+        "fio_opts": {
+            "rw": 'read',
+            "filesize": TEST_SIZE,
+            "verify": "pattern",
+            "verify_pattern": 0,
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+    },
+    {
+        "test_id": 22,
+        "fio_opts": {
+            "rw": 'randread',
+            "filesize": TEST_SIZE,
+            "verify": "pattern",
+            "verify_pattern": 0,
+            "randrepeat": 0,
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+    },
+
+    {
+        # Precondition device for write_mode=verify which just tells the device
+        # to check the integrity of the stored data
+        # Issue write uncorrectable commands which instruct the device to
+        # return an uncorrectable error when reading back the data
+        "test_id": 30,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "uncor",
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+    },
+    {
+        "test_id": 31,
+        "fio_opts": {
+            "rw": 'write',
+            "filesize": TEST_SIZE,
+            "write_mode": "verify",
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 32,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "filesize": TEST_SIZE,
+            "write_mode": "verify",
+            "output-format": "json",
+            "randrepeat": 0,
+            },
+        "test_class": WriteModeTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 33,
+        "fio_opts": {
+            "rw": 'read',
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            },
+        "test_class": WriteModeTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        "test_id": 34,
+        "fio_opts": {
+            "rw": 'randread',
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "randrepeat": 0,
+            },
+        "test_class": WriteModeTest,
+        "success": SUCCESS_NONZERO,
+    },
+]
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
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
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"nvmept-write-mode-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_root = str(Path(__file__).absolute().parent.parent)
+    print(f"fio path is {fio_path}")
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'nvmept-write-mode',
+              }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index c3545dd6..afecd67d 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1147,6 +1147,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [],
     },
+    {
+        'test_id':          1022,
+        'test_class':       FioExeTest,
+        'exe':              't/nvmept_write_mode.py',
+        'parameters':       ['-f', '{fio_path}', '--dut', '{nvmecdev}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.nvmecdev],
+    },
 ]
 
 
