Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761637;
	b=YmvwNCTRqrYx/kOJPmcjSsxbzPrcGi11XY43vKddX0qPN6Zstjsdr0NJataN790O30Uz
	 vMF5x6qbjGve9Qi8yTTGaCGi3gHcyqAFacE9el+oii8Ff4QShmYqXE/NArJ4SiY6ZPiJm
	 VEd8koejoKaA6kCM+zwrVb5Yt3bKI2fTrulRIg2OlGq7ctTKMOerWWPMZgMTSXAMz7trH
	 /zsxN+TwW5cjUj3d2qhz3IO/y6un1dHzFYrddD5ewsv7RNJS/SaSdqCJqdS/9br9QjSKU
	 sbTxZrtqLxw+JtkRZBHwmD3kZfk+KKxRMFesMALFGykSSeEKWLS8QWpR/+eVA2BEwBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761637;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9S1/W/D6BGigY1l7QhlGr2pYDMdkFI0PpbbSawcpWGc=;
	b=wzR+WwA+kgkwiXPCr2t9Fsd7hsh47mXJMaWp5jE19/Zf+ZZ9CXmv4xazoYRv7fBfFH1x
	 gziQeZThjp23DGfvhDmIzXk00AUJ3CHRM+DlVS6UQF+fjoYUXB3XJy0Lix//AXMiT0WhN
	 z1zKBcpYlXV7M10rmqbzMAt4e1w+oyodxMPokbC2t7OZJiKWYCC0FKYGk1DXNGrGuTSW4
	 iXXl3k3BvkgXlQBKH4M0Ix0GH0mo+WCTr/HpkETIsYfVyZXlkNLD+AV9EAZkcH9Ip/ilq
	 /maqbt1LmRdvq8+Z46H49ifd6X2tOvjLiHVKUD70qYfvSBLr3DTdFU9iAIh1mEtQSbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=YP9Kyflf;
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74284606A31C
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74284606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=YP9Kyflf
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761645; x=1827297645;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e0l4c6St1+4WZA046uRylG/csFRn6jlKXMeRy9yDwNs=;
  b=YP9KyflfzlYkeh9jPJc4tQKp89skh1ASj3y4Kbb1PnqBPS9C/PwQI7NP
   L3GfZV9CqukiVAIAO7ZfY6Q9JRlT/euzf+ljcohnT7xcWPv6KNzjeUFsa
   YMWYhsC8XnZqhcuPBiIiOqXewui/lOaPfpwy/kjX1QGFD5uadTxZsLE2r
   CWAQkf294kMGibDYUYFY9o+SMJUfCco45MLKFQ+I45kRnGTFPCFwG8xOW
   QEPwvpGbZshINuxHe9qQgz2dV9/lkfk+7/wsLUTf4uUxQesiv3SwaxqlQ
   zIH8W5ypqYHL0IsuAT4jGMq82mG6B2dS0T0Da5cYWv4CyjfGRanwbHRPr
   Q==;
X-CSE-ConnectionGUID: MeIeJ2OdTzqGjGNefuo4UQ==
X-CSE-MsgGUID: vi5MZ5BqRY+XELOPPr7Gbw==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815452"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:45 +0800
X-CSE-ConnectionGUID: iRBHSP05TAmgPGsZmgr72g==
X-CSE-MsgGUID: hAecsjnmQPqyJ5SaDgXBEg==
IronPort-SDR: 6b0925e5_i+Ml6/lP+QG2bVLCHG6ZNaSAulRKROswNk5OpBL4snuwsgy
 0kv+A+C636OuN2JtmG6c/13ri3ZDjPdr9fDQuGA==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:37 -0800
X-CSE-ConnectionGUID: 0AvTKjrdSKy4V5st9NxxiA==
X-CSE-MsgGUID: 0my97RqrSl6oQ0x2ftsz1g==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:36 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 7/8] t/blktrace_merge: add a test for merging blktrace files
Date: Fri, 27 Nov 2026 15:40:26 +0900
Message-ID: <20261127064027.1909326-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261127064027.1909326-1-shinichiro.kawasaki@wdc.com>
References: <20261127064027.1909326-1-shinichiro.kawasaki@wdc.com>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test script for the merge_blktrace_file option and register it in
t/run-fio-tests.py as test 1026.

The script generates small blktrace files itself, so that no binary test
files are needed. It runs fio with merge_blktrace_file option, decodes
the merged trace and compares it with the records expected from the
merge rules: only queue events for reads, writes and discards are kept,
pdu data is dropped, and the records of all inputs are ordered by time.

This first test item just merges two traces. More test items will be
added to confirm the bug fixes. This test script will be extended when
fio supports the latest blktrace struct blk_io_trace2.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/blktrace_merge.py | 236 ++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py  |   8 ++
 2 files changed, 244 insertions(+)
 create mode 100755 t/blktrace_merge.py

diff --git a/t/blktrace_merge.py b/t/blktrace_merge.py
new file mode 100755
index 00000000..61767803
--- /dev/null
+++ b/t/blktrace_merge.py
@@ -0,0 +1,236 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+
+"""
+# blktrace_merge.py
+#
+# Test merging of blktrace files with merge_blktrace_file.
+#
+# The blktrace input files are generated by this script. The merged trace
+# written by fio is decoded and compared with the result expected from the
+# merge rules:
+#
+#  - only queue events for reads, writes and discards are merged
+#  - records of all inputs are ordered by timestamp
+#  - pdu data is dropped
+#
+# USAGE
+# see python3 blktrace_merge.py --help
+#
+# EXAMPLES
+# python3 t/blktrace_merge.py
+# python3 t/blktrace_merge.py -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+# Linux
+#
+"""
+
+import os
+import sys
+import time
+import struct
+import argparse
+from collections import namedtuple
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+
+
+BLK_IO_TRACE_MAGIC = 0x65617400
+BLK_IO_TRACE_VERSION = 0x07
+BLK_IO_TRACE_FMT = "IIQQIIIIIHH"
+BLK_IO_TRACE_SIZE = struct.calcsize("=" + BLK_IO_TRACE_FMT)
+
+BLK_TC_SHIFT = 16
+BLK_TC_READ = 1 << 0
+BLK_TC_WRITE = 1 << 1
+BLK_TC_QUEUE = 1 << 4
+BLK_TC_COMPLETE = 1 << 7
+BLK_TC_DISCARD = 1 << 13
+__BLK_TA_QUEUE = 1
+__BLK_TA_COMPLETE = 8
+
+QUEUE_READ = __BLK_TA_QUEUE | ((BLK_TC_QUEUE | BLK_TC_READ) << BLK_TC_SHIFT)
+QUEUE_WRITE = __BLK_TA_QUEUE | ((BLK_TC_QUEUE | BLK_TC_WRITE) << BLK_TC_SHIFT)
+COMPLETE_READ = __BLK_TA_COMPLETE | ((BLK_TC_COMPLETE | BLK_TC_READ) << BLK_TC_SHIFT)
+
+DEVICE = 8 << 20
+
+Trace = namedtuple("Trace", "sequence time sector bytes action pid device cpu error pdu_len")
+
+
+def trace(sequence, time_ns, sector, action, pdu_len=0):
+    """Create a 4KiB trace record for DEVICE."""
+    return Trace(sequence, time_ns, sector, 4096, action, 1234, DEVICE, 0, 0, pdu_len)
+
+
+TRACES = {
+    'a': [
+        trace(0, 1000, 0, QUEUE_READ),
+        trace(1, 1100, 0, COMPLETE_READ, pdu_len=16),
+        trace(2, 2000, 8, QUEUE_WRITE, pdu_len=8),
+        trace(3, 3000, 16, QUEUE_READ),
+        trace(4, 4000, 24, QUEUE_WRITE),
+    ],
+    'b': [
+        trace(0, 1700, 100000, QUEUE_READ),
+        trace(1, 2900, 100008, QUEUE_WRITE),
+        trace(2, 4700, 100016, QUEUE_READ),
+    ],
+}
+
+
+def write_trace_file(filename, records):
+    """Write records to a native endian binary blktrace file."""
+    with open(filename, "wb") as f:
+        for r in records:
+            f.write(struct.pack("=" + BLK_IO_TRACE_FMT,
+                                BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION, *r))
+            f.write(b'\0' * r.pdu_len)
+
+
+def read_trace_file(filename):
+    """Read a native endian binary blktrace file without pdu data."""
+    with open(filename, "rb") as f:
+        data = f.read()
+
+    if len(data) % BLK_IO_TRACE_SIZE:
+        raise ValueError(f"{filename}: size {len(data)} is not a multiple of "
+                         f"{BLK_IO_TRACE_SIZE}")
+
+    records = []
+    for off in range(0, len(data), BLK_IO_TRACE_SIZE):
+        magic, *fields = struct.unpack_from("=" + BLK_IO_TRACE_FMT, data, off)
+        if magic != BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION:
+            raise ValueError(f"{filename}: bad magic {magic:#x} at offset {off}")
+        records.append(Trace(*fields))
+
+    return records
+
+
+def is_merged(r):
+    """Return True if fio merges this trace record."""
+    ddir_mask = (BLK_TC_READ | BLK_TC_WRITE | BLK_TC_DISCARD) << BLK_TC_SHIFT
+    return (r.action & 0xffff) == __BLK_TA_QUEUE and r.action & ddir_mask
+
+
+class BlktraceMergeTest(FioJobCmdTest):
+    """Merge blktrace files and check the merged trace."""
+
+    def __init__(self, *args, **kwargs):
+        super().__init__(*args, **kwargs)
+        self.merge_file = None
+
+    def setup(self, parameters):
+        os.makedirs(self.paths['test_dir'], exist_ok=True)
+        stub = os.path.join(self.paths['test_dir'], f"{self.basename}{self.testnum:03d}")
+
+        inputs = []
+        for name in self.fio_opts['inputs']:
+            filename = os.path.abspath(f"{stub}.{name}.bin")
+            write_trace_file(filename, TRACES[name])
+            inputs.append(filename)
+
+        self.merge_file = os.path.abspath(f"{stub}.merged.bin")
+
+        fio_args = [
+                    "--name=merge",
+                    "--merge-blktrace-only",
+                    f"--read_iolog={':'.join(inputs)}",
+                    f"--merge_blktrace_file={self.merge_file}",
+                    f"--output={self.filenames['output']}",
+                   ]
+
+        super().setup(fio_args)
+
+    def expected_records(self):
+        """Return the records expected in the merged trace."""
+        merged = [r._replace(pdu_len=0) for name in self.fio_opts['inputs']
+                  for r in TRACES[name] if is_merged(r)]
+        return sorted(merged, key=lambda r: r.time)
+
+    def fail(self, reason):
+        """Mark the test as failed."""
+        self.failure_reason += f" {reason},"
+        self.passed = False
+
+    def check_result(self):
+        super().check_result()
+        if not self.passed:
+            return
+
+        expected = self.expected_records()
+        try:
+            merged = read_trace_file(self.merge_file)
+        except (OSError, ValueError) as e:
+            self.fail(f"cannot read merged trace: {e}")
+            return
+
+        if sorted(merged) != sorted(expected):
+            self.fail(f"merged trace has {len(merged)} records, expected "
+                      f"{len(expected)}, or records differ")
+            for r in merged:
+                print(f"merged:   {r}")
+            for r in expected:
+                print(f"expected: {r}")
+            return
+
+        times = [r.time for r in merged]
+        if times != sorted(times):
+            self.fail(f"merged trace is not ordered by time: {times}")
+
+
+TEST_LIST = [
+    # Merge two traces. One of them also has a completion event and
+    # records with pdu data, which are not merged.
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "inputs": ['a', 'b'],
+            },
+        "test_class": BlktraceMergeTest,
+    },
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    return parser.parse_args()
+
+
+def main():
+    """Run blktrace merge tests."""
+    args = parse_args()
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path is {fio_path}")
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"blktrace-merge-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'blktrace_merge',
+              }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index d3683a1b..895fca4f 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1198,6 +1198,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.nvmebdev],
     },
+    {
+        'test_id':          1026,
+        'test_class':       FioExeTest,
+        'exe':              't/blktrace_merge.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux],
+    },
 ]
 
 
-- 
2.56.0

