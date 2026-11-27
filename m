Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761639;
	b=2ohhwz7Q2ncugFrDYGTeE4snxP7KHnSfSzzrghF/1g/0rhATal8A+OslMJjGvFkt+Qhk
	 zcBzGC/uiEPZkv/SvgAyg394AeA/7yVEuZCdL6hpIoNsRNZrCbVQnViKeRMS5qikAuMzR
	 bs5bqRuCGA93CLL6Nxn3lFRE1l5iUJAU6TsREOpktS1OKcwk1rAoDzw8crDdzpwi/IH34
	 ImqO1BVN92+ZRSS3PK8hInUcKEkbMKS3TPMDeNY2pZV2+DzQ7frw99ymOibL+5uaLfZjn
	 Ax2sIHcc4Y6DBkKa20kcCbyOpBhFt4jF59qipsj/6lnzBsH+pXE2d5aQ0a6ibaov4Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761639;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WkzJcDTZmofKkN2foQ4MPKTTjKaLPswMqZWED7xjW6g=;
	b=Ve1TPJNoUkQO7sDaYbN+Sh7jAHn8oU1NajTNv4HllcbNob7mBBxO4PmBT57TfXIuMZnJ
	 6Zm1ElFrGyD+il9bgNyVD+UJAgardoYBxRpmHtcV3+TYF6AF2V/1/2OF5TcUKlE0ziJqy
	 ubsr778tyL0eINk15vGtFJ/fKh1bjh7NFoLb2GZGwvbqZOg+mWi08XaXzgoHWOLgb0xM2
	 DwFGG1oqxn6vPFzNt/dxY6zqPgsKhbtbvouFLtYsOz/W0lr+ElRYJahJghrYWwcyRBRc3
	 yA6emIoMQs+SvFMzpxNNpcnAHlby5UukgeSREVt4Rkc6V8+mHQIULrDEGVYLMT7CCVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BOveWzPF;
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A557D606A31C
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A557D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BOveWzPF
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761646; x=1827297646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l008FZ4WvbaCpHybfWm2p7XaOwMpfhC1OFmEqM9Vcfc=;
  b=BOveWzPF1nMujl3yz+b6Mwyqd/R9xLeichYCudpbT/t8wfdzPlwCnLct
   rPAI+CENgBFUL51vgM06flYRsTyR7Iua7hqsnswSYl5dz3TFsaC0abMf8
   M9SSZUpg2Hy+l/xbnh94uCRJ7lk4Wjp2oyhzD7G4Dlt5wag7iBZ/p6+qV
   ZAx8qlFtY711grH3ZrFrXHOslNzZQ0vGeapyRPeZN6EA3evx4KUyOAdvB
   GqvQG57eqHXEIPqG89rLTT8P+NCTZ5BXviFXPvO2QUqjV+UxrVjmwB8xJ
   HrTZmp/zRh3jXtd+3YF3ej17iv7jmjgaA15SWekclWE5qNkzsmkaz9ILn
   A==;
X-CSE-ConnectionGUID: zJDC5v2JRdSL6hu+1Yi10Q==
X-CSE-MsgGUID: fVkKZIZLQuOFadgwzdHfSw==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815457"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:46 +0800
X-CSE-ConnectionGUID: oeuF0aVwRTK8fukfmo/1Wg==
X-CSE-MsgGUID: N2OqK7/DQQiZc8b1UXsf8w==
IronPort-SDR: 6b0925e6_yVDQ94OLJt5uluamVZ4SEZnB0XTO8D1qnI1hEacq5V1lQq4
 RcsbvSDPE711yjlXE/U6h3xEqteVwBLlbq/HBVA==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:38 -0800
X-CSE-ConnectionGUID: kYVpHqjTQCWpI/JIatrrng==
X-CSE-MsgGUID: W89GVVbNRG+qM1ecMjUbww==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:38 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 8/8] t/blktrace_merge: add tests for the merge fixes
Date: Fri, 27 Nov 2026 15:40:27 +0900
Message-ID: <20261127064027.1909326-9-shinichiro.kawasaki@wdc.com>
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

Add test items that confirm the recent fixes of the merge_blktrace_file
feature. Extend the expected merge result by the merge_blktrace_scalars
and the merge_blktrace_iters options: each input is repeated the given
number of times, each iteration is offset by the unscaled time of the
last record of the input that is not a notify record, and the timestamps
are then scaled. Add the option 'partial' to append the given number of
bytes of a trace record to the first input. This allows testing the
partial trace short read fix. Also add the option 'stderr' to check for
a message while also checking the merged trace.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/blktrace_merge.py | 114 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 109 insertions(+), 5 deletions(-)

diff --git a/t/blktrace_merge.py b/t/blktrace_merge.py
index 61767803..c285dbc7 100755
--- a/t/blktrace_merge.py
+++ b/t/blktrace_merge.py
@@ -4,13 +4,18 @@
 """
 # blktrace_merge.py
 #
-# Test merging of blktrace files with merge_blktrace_file.
+# Test merging of blktrace files with merge_blktrace_file,
+# merge_blktrace_scalars and merge_blktrace_iters.
 #
 # The blktrace input files are generated by this script. The merged trace
 # written by fio is decoded and compared with the result expected from the
 # merge rules:
 #
 #  - only queue events for reads, writes and discards are merged
+#  - each input is repeated merge_blktrace_iters times, and each iteration
+#    is offset by the unscaled time of the last record of the input that is
+#    not a notify record
+#  - timestamps are then scaled by merge_blktrace_scalars percent
 #  - records of all inputs are ordered by timestamp
 #  - pdu data is dropped
 #
@@ -31,10 +36,12 @@ import os
 import sys
 import time
 import struct
+import locale
 import argparse
 from collections import namedtuple
 from pathlib import Path
 from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO, SUCCESS_STDERR
 
 
 BLK_IO_TRACE_MAGIC = 0x65617400
@@ -47,13 +54,17 @@ BLK_TC_READ = 1 << 0
 BLK_TC_WRITE = 1 << 1
 BLK_TC_QUEUE = 1 << 4
 BLK_TC_COMPLETE = 1 << 7
+BLK_TC_NOTIFY = 1 << 10
 BLK_TC_DISCARD = 1 << 13
 __BLK_TA_QUEUE = 1
 __BLK_TA_COMPLETE = 8
+__BLK_TN_TIMESTAMP = 1
 
 QUEUE_READ = __BLK_TA_QUEUE | ((BLK_TC_QUEUE | BLK_TC_READ) << BLK_TC_SHIFT)
 QUEUE_WRITE = __BLK_TA_QUEUE | ((BLK_TC_QUEUE | BLK_TC_WRITE) << BLK_TC_SHIFT)
 COMPLETE_READ = __BLK_TA_COMPLETE | ((BLK_TC_COMPLETE | BLK_TC_READ) << BLK_TC_SHIFT)
+COMPLETE_WRITE = __BLK_TA_COMPLETE | ((BLK_TC_COMPLETE | BLK_TC_WRITE) << BLK_TC_SHIFT)
+NOTIFY_TIMESTAMP = __BLK_TN_TIMESTAMP | (BLK_TC_NOTIFY << BLK_TC_SHIFT)
 
 DEVICE = 8 << 20
 
@@ -78,6 +89,17 @@ TRACES = {
         trace(1, 2900, 100008, QUEUE_WRITE),
         trace(2, 4700, 100016, QUEUE_READ),
     ],
+    'blkparse': [
+        trace(0, 2843953433229520, 0, NOTIFY_TIMESTAMP, pdu_len=8),
+        trace(1, 1000, 0, QUEUE_READ),
+        trace(2, 1500, 0, COMPLETE_READ),
+        trace(3, 2000, 8, QUEUE_WRITE),
+        trace(4, 2600, 8, COMPLETE_WRITE),
+        trace(0, 2843953433239520, 0, NOTIFY_TIMESTAMP, pdu_len=8),
+    ],
+    'idle': [
+        trace(0, 2843953433229520, 0, NOTIFY_TIMESTAMP, pdu_len=8),
+    ],
 }
 
 
@@ -115,6 +137,11 @@ def is_merged(r):
     return (r.action & 0xffff) == __BLK_TA_QUEUE and r.action & ddir_mask
 
 
+def is_notify(r):
+    """Return True if this trace record is a notify record."""
+    return r.action & (BLK_TC_NOTIFY << BLK_TC_SHIFT)
+
+
 class BlktraceMergeTest(FioJobCmdTest):
     """Merge blktrace files and check the merged trace."""
 
@@ -130,24 +157,45 @@ class BlktraceMergeTest(FioJobCmdTest):
         for name in self.fio_opts['inputs']:
             filename = os.path.abspath(f"{stub}.{name}.bin")
             write_trace_file(filename, TRACES[name])
+            if not inputs and 'partial' in self.fio_opts:
+                with open(filename, "ab") as f:
+                    f.write(struct.pack("=" + BLK_IO_TRACE_FMT,
+                                        BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION,
+                                        *TRACES[name][0])[:self.fio_opts['partial']])
             inputs.append(filename)
 
         self.merge_file = os.path.abspath(f"{stub}.merged.bin")
 
         fio_args = [
                     "--name=merge",
-                    "--merge-blktrace-only",
-                    f"--read_iolog={':'.join(inputs)}",
                     f"--merge_blktrace_file={self.merge_file}",
                     f"--output={self.filenames['output']}",
                    ]
+        if inputs:
+            fio_args.append(f"--read_iolog={':'.join(inputs)}")
+        for opt in ['merge_blktrace_scalars', 'merge_blktrace_iters']:
+            if opt in self.fio_opts:
+                fio_args.append(f"--{opt}={self.fio_opts[opt]}")
+        fio_args.append("--merge-blktrace-only")
 
         super().setup(fio_args)
 
     def expected_records(self):
         """Return the records expected in the merged trace."""
-        merged = [r._replace(pdu_len=0) for name in self.fio_opts['inputs']
-                  for r in TRACES[name] if is_merged(r)]
+        names = self.fio_opts['inputs']
+        scalars = self.fio_opts.get('merge_blktrace_scalars', ':'.join(['100'] * len(names)))
+        iters = self.fio_opts.get('merge_blktrace_iters', ':'.join(['1'] * len(names)))
+
+        merged = []
+        for name, scalar, nr_iter in zip(names, scalars.split(':'), iters.split(':')):
+            records = [r for r in TRACES[name] if is_merged(r)]
+            if not records:
+                continue
+            length = [r.time for r in TRACES[name] if not is_notify(r)][-1]
+            for i in range(int(nr_iter)):
+                merged += [r._replace(time=(r.time + i * length) * int(scalar) // 100,
+                                      pdu_len=0) for r in records]
+
         return sorted(merged, key=lambda r: r.time)
 
     def fail(self, reason):
@@ -160,6 +208,20 @@ class BlktraceMergeTest(FioJobCmdTest):
         if not self.passed:
             return
 
+        if 'stderr' in self.fio_opts:
+            with open(self.filenames['stderr'], "r",
+                      encoding=locale.getpreferredencoding()) as f:
+                if self.fio_opts['stderr'] not in f.read():
+                    self.fail(f"expected message '{self.fio_opts['stderr']}' not found")
+                    return
+
+        if 'error' in self.fio_opts:
+            with open(self.filenames['stderr'], "r",
+                      encoding=locale.getpreferredencoding()) as f:
+                if self.fio_opts['error'] not in f.read():
+                    self.fail(f"expected error '{self.fio_opts['error']}' not found")
+            return
+
         expected = self.expected_records()
         try:
             merged = read_trace_file(self.merge_file)
@@ -191,6 +253,48 @@ TEST_LIST = [
             },
         "test_class": BlktraceMergeTest,
     },
+    # Scale and repeat a trace that ends with a queue event and a trace that
+    # ends with completion and notify events like blkparse output.
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "inputs": ['a', 'blkparse'],
+            "merge_blktrace_scalars": "50:50",
+            "merge_blktrace_iters": "2:2",
+            },
+        "test_class": BlktraceMergeTest,
+    },
+    # Repeat a trace with only a notify record, like the trace of an idle
+    # device, before another trace.
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "inputs": ['idle', 'a'],
+            "merge_blktrace_iters": "2:1",
+            },
+        "test_class": BlktraceMergeTest,
+    },
+    # Run merge_blktrace_file without read_iolog.
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "inputs": [],
+            "error": "merge_blktrace_file requires read_iolog",
+            },
+        "test_class": BlktraceMergeTest,
+        "success": SUCCESS_NONZERO,
+    },
+    # Merge a trace that ends with a partial trace record, which is ignored.
+    {
+        "test_id": 5,
+        "fio_opts": {
+            "inputs": ['a', 'b'],
+            "partial": 20,
+            "stderr": "fio: iolog short read",
+            },
+        "test_class": BlktraceMergeTest,
+        "success": SUCCESS_STDERR,
+    },
 ]
 
 
-- 
2.56.0

