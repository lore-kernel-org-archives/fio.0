Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6674A21D599
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639873; cv=none; b=s5S2k+urY8OzzyCYp4ZR301+FCilOOVCZNWa4JT/jhBRUMU4S8R+5noEA1njsR0CsgHaDET8T4kpMeyfzo1LbgobzNDRIswHBx/xmfN72tooxF5CkIcDDwWwRW4dY4UFjRFSFmP3XJAuvlRo/oeU9x4PqkMBrT1Y/rZnbIACMNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639873; c=relaxed/simple;
	bh=NvJJCBYFgNcqe5t16RXU1JD5F430HpkgaoRMPfVpGu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=jOb2YTIb5Mg51GwoU8exQU4e3VVodHMgW0YPIccKEKWQ1kWCQz9WhGASr4tufH3r9aQt9DCIyAtg8snvSMYIbyZCkJt+jblcaFjrQLPwjrPcRvgHJQ3gLf/1JHqXl3rhiTGnFm4itTpTsUwOC7mJ1KLNgvqcs7XpzpGmtAX4X7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RoK9hF59; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RoK9hF59"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250227070429epoutp0131cbb0cbe1a196dc4b709b1b7ea0a79c~n-r0_b-982773727737epoutp01m
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:04:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250227070429epoutp0131cbb0cbe1a196dc4b709b1b7ea0a79c~n-r0_b-982773727737epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740639869;
	bh=UPJJiooMKpDSA+WILZyeTCVRQjYhjToXOUBCAlcaSko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoK9hF59rUqwGYQr4A6rytvcjvxwcegVZb99/8ly7eNBnK6/pafar4HDOZdGdCsal
	 Oov2okwZiVJyxJiZDeZ6aPubDAfHApbI5ilxNlL3ZTcajaZiqgMuPiukAhAghQtPaq
	 iqvjlTfgsDCBmerWM+EQIOUxg4Bj0sOWPwh8RQR0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250227070429epcas5p424b392524cdfa8c3b9a3c5d66cb12623~n-r0v12qz1979319793epcas5p4B;
	Thu, 27 Feb 2025 07:04:29 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z3MlZ6lZtz4x9QG; Thu, 27 Feb
	2025 07:04:26 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A8.E1.20052.77E00C76; Thu, 27 Feb 2025 16:04:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053406epcas5p277bce682f776d623590b28c681f45c6d~n_c6hHbrF2346023460epcas5p2S;
	Thu, 27 Feb 2025 05:34:06 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250227053406epsmtrp1515778219b68d4296736128454146093~n_c6gGTXc1040510405epsmtrp1r;
	Thu, 27 Feb 2025 05:34:06 +0000 (GMT)
X-AuditID: b6c32a49-bb50c24000004e54-33-67c00e772653
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A2.5A.18949.E49FFB76; Thu, 27 Feb 2025 14:34:06 +0900 (KST)
Received: from unvme-desktop.samsungds.net (unknown [107.99.41.39]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250227053405epsmtip25ced4db6d6dfe2af370d3b9d5f482286~n_c5mNLzQ1753517535epsmtip2B;
	Thu, 27 Feb 2025 05:34:05 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH 18/21] t/verify.py: Add verify test script
Date: Thu, 27 Feb 2025 16:17:24 +0530
Message-Id: <20250227104727.1794982-19-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmhm4534F0g/uX2SzWXPnNbrH6bj+b
	xcdZL5gtHnd3MFpsaBN0YPXYOesuu8fls6UefVtWMXp83iQXwBKVbZORmpiSWqSQmpecn5KZ
	l26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFVJoSwxpxQoFJBYXKykb2dTlF9a
	kqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ3xeOtdpoK2u4wV3y78YWlg
	PDyJsYuRk0NCwETi/L0Z7F2MXBxCArsZJR4s/sAEkhAS+MQoseecOETiG6PEk7ObWWA6Jhzd
	zgqR2Mso8WPrGiYI5wejxJdXE1lBqtgEtCVevb3B3MXIwSEioCGx5m4qiMkskCqx/rgESIWw
	gJXEo7u32EFsFgFViSevn4JdxCtgL9G+ro0VYpe8xMxL38FqOIHibzobWSBqBCVOznwCZjMD
	1TRvnc0McoKEwDl2iYZvS5lAdkkIuEgcmh8OMUdY4tXxLewQtpTEy/42KDtbYtPDn0wQdoHE
	kRe9zBC2vUTrqX5miJM1Jdbv0ocIy0pMPbWOCWItn0Tv7ydQrbwSO+bB2KoSf+/dhgaVtMTN
	d1ehbA+JpxvXM0JCahKjROvyg2wTGBVmIXlnFpJ3ZiGsXsDIvIpRMrWgODc9tdi0wDAvtRwe
	ycn5uZsYwQlRy3MH490HH/QOMTJxMB5ilOBgVhLh5czcky7Em5JYWZValB9fVJqTWnyI0RQY
	3hOZpUST84EpOa8k3tDE0sDEzMzMxNLYzFBJnLd5Z0u6kEB6YklqdmpqQWoRTB8TB6dUA9Pc
	jyfuaRVNKGBctOjYBC/+JWHiQk5PXqSv3uMX8N724eSuBGUd1b99DBW1cw/d/5PH+WmW4JLt
	q37zvQkRUm2I85JerBsbIZH79uuq4A51zrWzt6denF/Q3m83acHSPTUp2yc+0jUyXL3k0IoN
	Djk8F3dv3nZ1vnTL3WXuM7w1eC+JeQt+Pj/NjGmRXZWP94cS3Ym9wQ9T63x0F/8Ikqpo1X30
	LdF8hWnt8YSgombRHc/X6TS+WVxbF1PfvzMn6E/vTfFZPxKeznu2z2bVNxfd/61y12QV3BWm
	GFw05ufiSgwP6KsKEVI82s36n6diKqviOR/7LxfrOlxaROP5+CPM9hnl2hn4ZSh9qmuSV2Ip
	zkg01GIuKk4EACOGn08RBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvK7fz/3pBl9+alusufKb3WL13X42
	i4+zXjBbPO7uYLTY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+Px
	1rtMBW13GSu+XfjD0sB4eBJjFyMnh4SAicSEo9tZQWwhgd2MEje3+ncxcgDFpSUWrk+EKBGW
	WPnvOXsXIxdQyTdGiVMH3oLVswloS7x6e4MZxBYR0JI4tq6JDcRmFkiXOHfpNth8YQEriUd3
	b7GD2CwCqhJPXj8Fi/MK2Eu0r2tjhVggLzHz0newGk6g+JvORhaIe+wkFkz8xgRRLyhxcuYT
	Foj58hLNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOCg
	1dLawbhn1Qe9Q4xMHIyHGCU4mJVEeDkz96QL8aYkVlalFuXHF5XmpBYfYpTmYFES5/32ujdF
	SCA9sSQ1OzW1ILUIJsvEwSnVwLTkWbZKQ3b9FFNh8y0no8zKPlxecCrN5PFljrdCb47eSn+8
	NNU/bFdGwu2CwMOrF1RXL5I1OHHe87+yYpqWZo5oX8yKTdyqHBszn4Tduikjdijpml8Hp+MX
	T/Z5U2q7v3DFHUw9kh1W4LBjR0/ZMm+f7a9uR8b8maPFN01+xnKZbzel924Lkboxp9Unsnyj
	Rx17weWWkp/NG6Rb89nnM3HvWMjVWOzDe2nDzQquhFave0te1Jf6iW/ebeolVM/OMWvj3vZ5
	7CbLbOc/XLRuyT6x6wWLsvibvCY1ij95fSM89ttGebclHfbvjrHHP6phWVBi/P0zw6S9Rgr9
	iu5xBm+d+eReF6wTY/iWsK+dT4mlOCPRUIu5qDgRAObN9/zJAgAA
X-CMS-MailID: 20250227053406epcas5p277bce682f776d623590b28c681f45c6d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250227053406epcas5p277bce682f776d623590b28c681f45c6d
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
	<CGME20250227053406epcas5p277bce682f776d623590b28c681f45c6d@epcas5p2.samsung.com>

From: Vincent Fu <vincent.fu@samsung.com>

The script contains three sets of tests. The first set of tests
exercises fio's decision making about checking the verify header's
sequence number and random seed. The second set of tests are aimed at
making sure that the checksum functions can detect data mismatches. The
final set of tests exercise fio's verify-related options such as
verify_backlog and verify_inteval.

This test script includes two checksum lists. The first list (default)
contains a subset of the checksum methods offered by fio, whereas the
second list contains the full set of checksum methods. The second, full
set can be run by specifying -c or --complete. Testing all of the
checksum methods can take a long time.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 t/verify.py | 799 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 799 insertions(+)
 create mode 100755 t/verify.py

diff --git a/t/verify.py b/t/verify.py
new file mode 100755
index 00000000..38c07bd1
--- /dev/null
+++ b/t/verify.py
@@ -0,0 +1,799 @@
+#!/usr/bin/env python3
+"""
+# verify.py
+#
+# Test fio's verify options.
+#
+# USAGE
+# see python3 verify.py --help
+#
+# EXAMPLES
+# python3 t/verify.py
+# python3 t/verify.py --fio ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+# - 4 CPUs
+#
+"""
+import os
+import sys
+import time
+import errno
+import logging
+import argparse
+import platform
+import itertools
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_DEFAULT, SUCCESS_NONZERO, Requirements
+
+
+VERIFY_OPT_LIST = [
+    'direct',
+    'iodepth',
+    'filesize',
+    'bs',
+    'time_based',
+    'runtime',
+    'io_size',
+    'offset',
+    'number_ios',
+    'output-format',
+    'directory',
+    'norandommap',
+    'numjobs',
+    'nrfiles',
+    'openfiles',
+    'cpus_allowed',
+    'experimental_verify',
+    'verify_backlog',
+    'verify_backlog_batch',
+    'verify_interval',
+    'verify_offset',
+    'verify_async',
+    'verify_async_cpus',
+    'verify_pattern',
+    'verify_only',
+]
+
+class VerifyTest(FioJobCmdTest):
+    """
+    Verify test class.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=verify",
+            f"--ioengine={self.fio_opts['ioengine']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--verify={self.fio_opts['verify']}",
+            f"--output={self.filenames['output']}",
+        ]
+        for opt in VERIFY_OPT_LIST:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+class VerifyCSUMTest(FioJobCmdTest):
+    """
+    Verify test class. Run standard verify jobs, modify the data, and then run
+    more verify jobs. Hopefully fio will detect that the data has chagned.
+    """
+
+    @staticmethod
+    def add_verify_opts(opt_list, adds):
+        """Add optional options."""
+
+        fio_opts = []
+
+        for opt in adds:
+            if opt in opt_list:
+                option = f"--{opt}={opt_list[opt]}"
+                fio_opts.append(option)
+
+        return fio_opts
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        logging.debug("ioengine is %s", self.fio_opts['ioengine'])
+        fio_args_base = [
+            "--filename=verify",
+            "--stonewall",
+            f"--ioengine={self.fio_opts['ioengine']}",
+        ]
+
+        extra_options = self.add_verify_opts(self.fio_opts, VERIFY_OPT_LIST)
+
+        verify_only = [
+            "--verify_only",
+            f"--rw={self.fio_opts['rw']}",
+            f"--verify={self.fio_opts['verify']}",
+        ] + fio_args_base + extra_options
+
+        verify_read = [
+            "--rw=randread" if 'rand' in self.fio_opts['rw'] else "--rw=read",
+            f"--verify={self.fio_opts['verify']}",
+        ] + fio_args_base + extra_options
+
+        layout = [
+            "--name=layout",
+            f"--rw={self.fio_opts['rw']}",
+            f"--verify={self.fio_opts['verify']}",
+        ] + fio_args_base + extra_options
+
+        success_only = ["--name=success_only"] + verify_only
+        success_read = ["--name=success_read"] + verify_read
+
+        mangle = [
+            "--name=mangle",
+            "--rw=randwrite",
+            "--randrepeat=0",
+            f"--bs={self.fio_opts['mangle_bs']}",
+            "--number_ios=1",
+        ] + fio_args_base + self.add_verify_opts(self.fio_opts, ['filesize'])
+
+        failure_only = ["--name=failure_only"] + verify_only
+        failure_read = ["--name=failure_read"] + verify_read
+
+        fio_args = layout + success_only + success_read + mangle + failure_only + failure_read + [f"--output={self.filenames['output']}"]
+        logging.debug("fio_args: %s", fio_args)
+
+        super().setup(fio_args)
+
+    def check_result(self):
+        super().check_result()
+
+        checked = {}
+
+        for job in self.json_data['jobs']:
+            if job['jobname'] == 'layout':
+                checked[job['jobname']] = True
+                if job['error']:
+                    self.passed = False
+                    self.failure_reason += " layout job failed"
+            elif 'success' in job['jobname']:
+                checked[job['jobname']] = True
+                if job['error']:
+                    self.passed = False
+                    self.failure_reason += f" verify pass {job['jobname']} that should have succeeded actually failed"
+            elif job['jobname'] == 'mangle':
+                checked[job['jobname']] = True
+                if job['error']:
+                    self.passed = False
+                    self.failure_reason += " mangle job failed"
+            elif 'failure' in job['jobname']:
+                checked[job['jobname']] = True
+                if self.fio_opts['verify'] == 'null' and not job['error']:
+                    continue
+                if job['error'] != errno.EILSEQ:
+                    self.passed = False
+                    self.failure_reason += f" verify job {job['jobname']} produced {job['error']} instead of errno {errno.EILSEQ} Illegal byte sequence"
+                    logging.debug(self.json_data)
+            else:
+                self.passed = False
+                self.failure_reason += " unknown job name"
+
+        if len(checked) != 6:
+            self.passed = False
+            self.failure_reason += " six phases not completed"
+
+        with open(self.filenames['stderr'], "r") as se:
+            contents = se.read()
+            logging.debug("stderr: %s", contents)
+
+
+#
+# These tests exercise fio's decisions about verifying the sequence number and
+# random seed in the verify header.
+#
+TEST_LIST_HEADER = [
+    {
+        # Basic test with options at default values
+        "test_id": 2000,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+    {
+        # Basic test with iodepth 16
+        "test_id": 2001,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "iodepth": 16,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+    {
+        # Basic test with 3 files
+        "test_id": 2002,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "nrfiles": 3,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+    {
+        # Basic test with iodepth 16 and 3 files
+        "test_id": 2003,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "iodepth": 16,
+            "nrfiles": 3,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+]
+
+#
+# These tests are mainly intended to assess the checksum functions. They write
+# out data, run some verify jobs, then modify the data, and try to verify the
+# data again, expecting to see failures.
+#
+TEST_LIST_CSUM = [
+    {
+        # basic seq write verify job
+        "test_id": 1000,
+        "fio_opts": {
+            "ioengine": "psync",
+            "filesize": "1M",
+            "bs": 4096,
+            "rw": "write",
+            "output-format": "json",
+            },
+        "test_class": VerifyCSUMTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # basic rand write verify job
+        "test_id": 1001,
+        "fio_opts": {
+            "ioengine": "psync",
+            "filesize": "1M",
+            "bs": 4096,
+            "rw": "randwrite",
+            "output-format": "json",
+            },
+        "test_class": VerifyCSUMTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # basic libaio seq write test
+        "test_id": 1002,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 16,
+            "filesize": "1M",
+            "bs": 4096,
+            "rw": "write",
+            "output-format": "json",
+            },
+        "test_class": VerifyCSUMTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # basic libaio rand write test
+        "test_id": 1003,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 16,
+            "filesize": "1M",
+            "bs": 4096,
+            "rw": "randwrite",
+            "output-format": "json",
+            },
+        "test_class": VerifyCSUMTest,
+        "success": SUCCESS_NONZERO,
+    },
+]
+
+#
+# These tests are run for all combinations of data direction and checksum
+# methods.
+#
+TEST_LIST = [
+    {
+        # norandommap with verify backlog
+        "test_id": 1,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "2M",
+            "norandommap": 1,
+            "bs": 512,
+            "time_based": 1,
+            "runtime": 3,
+            "verify_backlog": 128,
+            "verify_backlog_batch": 64,
+            },
+        "test_class": VerifyTest,
+    },
+    {
+        # norandommap with verify offset and interval
+        "test_id": 2,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "2M",
+            "io_size": "4M",
+            "norandommap": 1,
+            "bs": 4096,
+            "verify_interval": 2048,
+            "verify_offset": 1024,
+            },
+        "test_class": VerifyTest,
+    },
+    {
+        # norandommap with verify offload to async threads
+        "test_id": 3,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "2M",
+            "norandommap": 1,
+            "bs": 4096,
+            "cpus_allowed": "0-3",
+            "verify_async": 2,
+            "verify_async_cpus": "0-1",
+            },
+        "test_class": VerifyTest,
+        "requirements":     [Requirements.not_macos,
+                             Requirements.cpucount4],
+        # mac os does not support CPU affinity
+    },
+    {
+        # tausworthe combine all verify options
+        "test_id": 4,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "4M",
+            "bs": 4096,
+            "cpus_allowed": "0-3",
+            "time_based": 1,
+            "random_generator": "tausworthe",
+            "runtime": 3,
+            "verify_interval": 2048,
+            "verify_offset": 1024,
+            "verify_backlog": 128,
+            "verify_backlog_batch": 128,
+            "verify_async": 2,
+            "verify_async_cpus": "0-1",
+            },
+        "test_class": VerifyTest,
+        "requirements":     [Requirements.not_macos,
+                             Requirements.cpucount4],
+        # mac os does not support CPU affinity
+    },
+    {
+        # norandommap combine all verify options
+        "test_id": 5,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "4M",
+            "norandommap": 1,
+            "bs": 4096,
+            "cpus_allowed": "0-3",
+            "time_based": 1,
+            "runtime": 3,
+            "verify_interval": 2048,
+            "verify_offset": 1024,
+            "verify_backlog": 128,
+            "verify_backlog_batch": 128,
+            "verify_async": 2,
+            "verify_async_cpus": "0-1",
+            },
+        "test_class": VerifyTest,
+        "requirements":     [Requirements.not_macos,
+                             Requirements.cpucount4],
+        # mac os does not support CPU affinity
+    },
+    {
+        # multiple jobs and files with verify
+        "test_id": 6,
+        "fio_opts": {
+            "direct": 1,
+            "ioengine": "libaio",
+            "iodepth": 32,
+            "filesize": "512K",
+            "nrfiles": 3,
+            "openfiles": 2,
+            "numjobs": 2,
+            "norandommap": 1,
+            "bs": 4096,
+            "time_based": 1,
+            "runtime": 20,
+            "verify_interval": 2048,
+            "verify_offset": 1024,
+            "verify_backlog": 16,
+            "verify_backlog_batch": 16,
+            },
+        "test_class": VerifyTest,
+    },
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-r', '--fio-root', help='fio root path')
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-c', '--complete', help='Enable all checksums', action='store_true')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('-k', '--skip-req', action='store_true',
+                        help='skip requirements checking')
+    parser.add_argument('--csum', nargs='+', type=str,
+                        help='list of checksum methods to use, skipping all others')
+    args = parser.parse_args()
+
+    return args
+
+
+def verify_test_header(test_env, args, csum, mode, sequence):
+    """
+    Adjust test arguments based on values of mode and sequence. Then run the
+    tests. This function is intended to run a set of tests that test
+    conditions under which the header random seed and sequence number are
+    checked.
+
+    The result should be a matrix with these combinations:
+        {write, write w/verify_only, read/write, read/write w/verify_only, read} x
+        {sequential, random w/randommap, random w/norandommap, sequence modifiers}
+    """
+    for test in TEST_LIST_HEADER:
+        # experimental_verify does not work in verify_only=1 mode
+        if "_vo" in mode and 'experimental_verify' in test['fio_opts'] and \
+        test['fio_opts']['experimental_verify']:
+            test['force_skip'] = True
+        else:
+            test['force_skip'] = False
+
+        test['fio_opts']['verify'] = csum
+        if csum == 'pattern':
+            test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+        else:
+            test['fio_opts'].pop('verify_pattern', None)
+
+        if 'norandommap' in sequence:
+            test['fio_opts']['norandommap'] = 1
+        else:
+            test['fio_opts']['norandommap'] = 0
+
+        if 'randommap' in sequence:
+            prefix = "rand"
+        else:
+            prefix = ""
+
+        if 'sequence_modifier' in sequence:
+            suffix = ":4096"
+        else:
+            suffix = ""
+
+        if 'readwrite' in mode:
+            fio_ddir = 'rw'
+        elif 'write' in mode:
+            fio_ddir = 'write'
+        elif 'read' in mode:
+            fio_ddir = 'read'
+        else:
+            fio_ddir = ""
+            # TODO throw an exception here
+        test['fio_opts']['rw'] = prefix + fio_ddir + suffix
+        logging.debug("ddir is %s", test['fio_opts']['rw'])
+
+        if '_vo' in mode:
+            vo = 1
+        else:
+            vo = 0
+        test['fio_opts']['verify_only'] = vo
+
+        # For 100% read workloads we need to read a file that was written with
+        # verify enabled. Use a previous test case for this by pointing fio to
+        # write to a file in a specific directory.
+        #
+        # For verify_only tests we also need to point fio to a file that was
+        # written with verify enabled
+        #
+        # Finally, we have observed on Windows platforms that fio may not
+        # create files of the size specified by filesize. This causes false
+        # positive test failures when we later try to run 100% read verify jobs
+        # on the files as the verify job may lay out a file of the size
+        # specified by filesize and overwrite the previously written file,
+        # inducing verificaiton failures. Until this issue is resolved, just
+        # skip these tests on Windows.
+        # https://github.com/axboe/fio/issues/1872
+        if mode == 'read':
+            directory = os.path.join(test_env['artifact_root'].replace(f'mode_{mode}','mode_write'),
+                        f"{test['test_id']:04d}")
+            test['fio_opts']['directory'] = str(Path(directory).absolute()) if \
+                platform.system() != "Windows" else str(Path(directory).absolute()).replace(':', '\\:')
+            if platform.system() == "Windows":
+                test['force_skip'] = True
+        elif vo:
+            directory = os.path.join(test_env['artifact_root'].replace('write_vo','write'),
+                        f"{test['test_id']:04d}")
+            test['fio_opts']['directory'] = str(Path(directory).absolute()) if \
+                platform.system() != "Windows" else str(Path(directory).absolute()).replace(':', '\\:')
+            if platform.system() == "Windows":
+                test['force_skip'] = True
+        else:
+            test['fio_opts'].pop('directory', None)
+
+    return run_fio_tests(TEST_LIST_HEADER, test_env, args)
+
+
+MANGLE_JOB_BS = 0
+def verify_test_csum(test_env, args, mbs, csum):
+    """
+    Adjust test arguments based on values of csum. Then run the tests.
+    This function is designed for a series of tests that check that checksum
+    methods can reliably detect data integrity issues.
+    """
+    for test in TEST_LIST_CSUM:
+        test['force_skip'] = False
+        test['fio_opts']['verify'] = csum
+
+        if csum == 'pattern':
+            test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+        else:
+            test['fio_opts'].pop('verify_pattern', None)
+
+        if mbs == MANGLE_JOB_BS:
+            test['fio_opts']['mangle_bs'] = test['fio_opts']['bs']
+        else:
+            test['fio_opts']['mangle_bs'] = mbs
+
+        # These tests produce verification failures but not when verify=null,
+        # so adjust the success criterion.
+        if csum == 'null':
+            test['success'] = SUCCESS_DEFAULT
+        else:
+            test['success'] = SUCCESS_NONZERO
+
+    return run_fio_tests(TEST_LIST_CSUM, test_env, args)
+
+
+def verify_test(test_env, args, ddir, csum):
+    """
+    Adjust test arguments based on values of ddir and csum.  Then run
+    the tests.
+    """
+    for test in TEST_LIST:
+        test['force_skip'] = False
+
+        test['fio_opts']['rw'] = ddir
+        test['fio_opts']['verify'] = csum
+
+        if csum == 'pattern':
+            test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+        else:
+            test['fio_opts'].pop('verify_pattern', None)
+
+        # For 100% read data directions we need the write file that was written with
+        # verify enabled. Use a previous test case for this by telling fio to
+        # write to a file in a specific directory.
+        if ddir == 'read':
+            directory = os.path.join(test_env['artifact_root'].replace(f'ddir_{ddir}','ddir_write'),
+                        f"{test['test_id']:04d}")
+            test['fio_opts']['directory'] = str(Path(directory).absolute()) if \
+                platform.system() != "Windows" else str(Path(directory).absolute()).replace(':', '\\:')
+        elif ddir == 'randread':
+            directory = os.path.join(test_env['artifact_root'].replace(f'ddir_{ddir}','ddir_randwrite'),
+                        f"{test['test_id']:04d}")
+            test['fio_opts']['directory'] = str(Path(directory).absolute()) if \
+                platform.system() != "Windows" else str(Path(directory).absolute()).replace(':', '\\:')
+        else:
+            test['fio_opts'].pop('directory', None)
+
+        # On Windows we are skipping the tests below because of the filesize
+        # issue noted above.
+        if ddir in [ 'read', 'randread' ] and platform.system() == 'Windows':
+            test['force_skip'] = True
+
+    return run_fio_tests(TEST_LIST, test_env, args)
+
+
+# 100% read workloads below must follow write workloads so that the 100% read
+# workloads will be reading data written with verification enabled.
+DDIR_LIST = [
+        'write',
+        'readwrite',
+        'read',
+        'randwrite',
+        'randrw',
+        'randread',
+             ]
+CSUM_LIST1 = [
+        'md5',
+        'crc64',
+        'pattern',
+             ]
+CSUM_LIST2 = [
+        'md5',
+        'crc64',
+        'crc32c',
+        'crc32c-intel',
+        'crc16',
+        'crc7',
+        'xxhash',
+        'sha512',
+        'sha256',
+        'sha1',
+        'sha3-224',
+        'sha3-384',
+        'sha3-512',
+        'pattern',
+        'null',
+             ]
+
+def main():
+    """
+    Run tests for fio's verify feature.
+    """
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"verify-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path is {fio_path}")
+
+    if args.fio_root:
+        fio_root = args.fio_root
+    else:
+        fio_root = str(Path(__file__).absolute().parent.parent)
+    print(f"fio root is {fio_root}")
+
+    if not args.skip_req:
+        Requirements(fio_root, args)
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'verify',
+              }
+
+    if platform.system() == 'Linux':
+        aio = 'libaio'
+        sync = 'psync'
+    elif platform.system() == 'Windows':
+        aio = 'windowsaio'
+        sync = 'sync'
+    else:
+        aio = 'posixaio'
+        sync = 'psync'
+    for test in TEST_LIST:
+        if 'aio' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = aio
+        if 'sync' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = sync
+    for test in TEST_LIST_CSUM:
+        if 'aio' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = aio
+        if 'sync' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = sync
+    for test in TEST_LIST_HEADER:
+        if 'aio' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = aio
+        if 'sync' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = sync
+
+    total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
+
+    if args.complete:
+        csum_list = CSUM_LIST2
+    else:
+        csum_list = CSUM_LIST1
+
+    if args.csum:
+        csum_list = args.csum
+
+    try:
+        for ddir, csum in itertools.product(DDIR_LIST, csum_list):
+            print(f"\nddir: {ddir}, checksum: {csum}")
+
+            test_env['artifact_root'] = os.path.join(artifact_root,
+                                                     f"ddir_{ddir}_csum_{csum}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = verify_test(test_env, args, ddir, csum)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
+        # MANGLE_JOB_BS means to mangle an entire block which should result in
+        #  a header magic number error
+        # 4 means to mangle 4 bytes which should result in a checksum error
+        #  unless the 4 bytes occur in the verification header
+        mangle_bs = [MANGLE_JOB_BS, 4]
+        for mbs, csum in itertools.product(mangle_bs, csum_list):
+            print(f"\nmangle block size: {mbs}, checksum: {csum}")
+
+            test_env['artifact_root'] = os.path.join(artifact_root,
+                                                     f"mbs_{mbs}_csum_{csum}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = verify_test_csum(test_env, args, mbs, csum)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
+        # The loop below tests combinations of options that exercise fio's
+        # decisions about disabling checks for the sequence number and random
+        # seed in the verify header.
+        mode_list = [ "write", "write_vo", "readwrite", "readwrite_vo", "read" ]
+        sequence_list = [ "sequential", "randommap", "norandommap", "sequence_modifier" ]
+        for mode, sequence in itertools.product(mode_list, sequence_list):
+            print(f"\nmode: {mode}, sequence: {sequence}")
+
+            test_env['artifact_root'] = os.path.join(artifact_root,
+                                                     f"mode_{mode}_seq_{sequence}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = verify_test_header(test_env, args, 'md5', mode, sequence)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
+    except KeyboardInterrupt:
+        pass
+
+    print(f"\n\n{total['passed']} test(s) passed, {total['failed']} failed, " \
+            f"{total['skipped']} skipped")
+    sys.exit(total['failed'])
+
+
+if __name__ == '__main__':
+    main()
-- 
2.25.1

