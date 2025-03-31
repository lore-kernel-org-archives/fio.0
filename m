Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89B9213248
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429763; cv=none; b=iIp66hFraId4uY3r/1VJQSja/EIY4z96qjYLoumWzOtA/hWsq0mTCUuTYGjgW3nOSc3J7fkkF2857h2yzlht4dzfTAAk3xonhlZ2JDi/h6vjQQ+3npFsWTcJGi8UBsAhzXOXUVG4s3BDAxMkjHy7emwzQEopSmLbyfPZqHupRMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429763; c=relaxed/simple;
	bh=uEMM5505ypYU6nWztoKCgW/YOzxOaM8wANk7tPOmf58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQcYL+9Q95EdEPPxntl6uROVEYFuNjhGIQ9MZaRkng47AVN2xhbFxsH8GKjc44XYlLKjZWL3DycfhaSgMuT8x14R0k+oeoa+U0LSZ8pg30imVgkP//PRRP88UDzpJeLZ40nN2J7iuSN3ZEcp/bf+RqAdTd2PsP4AZw25c6iKJxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TfK1zE2F; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfK1zE2F"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6ecfc7fb2aaso41670656d6.0
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743429760; x=1744034560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cT6j0rPbAbPsia52rvNpkCDiiATRg6f5C89jWMS7csM=;
        b=TfK1zE2FMrH7mAhxz7DlH9gjjJNNIn1Ziu1mWUOG0EewpvpxiRAMz7YDtUC5ttD2y1
         9b6waLGFin4y6Ak/FfSbWH342sS4erBugo+JzWolDbmV0br/bRFbeHJgUzT4e6jF2RaX
         pG4AQDk9r0VLerU2NOKFUnVBpJLlRQvCNbt3gtJ7e1QVd9W5WssrNPE6kNyLYodR/Fm2
         xJmWwcVURGIX+qcwPHDk461E9XaTEu8jN1zWppw982gE1r5XdfHFMI2k6EorBKqUHIom
         YaXd0teJgUWo/KtUiKzhdwcnsO4ZFatR0GfYaSDtnwJl0jgnmVWA44CMgmEVSTIYbFPA
         FH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429760; x=1744034560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cT6j0rPbAbPsia52rvNpkCDiiATRg6f5C89jWMS7csM=;
        b=Pa6r8iVumiYfq+uoz/OQcjsfyb+GWT4E+K50EfK/9XKQ8whKGhNlxEj9Ueq50dl3zv
         GzPcbgwI2mPuu0r/NTlK4n3xNl5E6wyySAnnfjWkntOFV60tIR84yTxOgVJ6BvCt0hxX
         J8TFNfVypmfIrAwXqUX0WdqNe+AJBUiti6EtDyX6/bm1PjkF1+q+s1c8SQbh/dcdVBQL
         5HypRP9R/1aI+CJnJSgIIIzaiRpm/GSk9bjVPHLOGGWZpoHzE/0qn1GM8akT9xMbi7z0
         VZx3BDhprEA8EMsHfVvk4GHHh8Vza7UmM7wGVhG67u91Tezu0TPU26Fd3Wop5j6v+bP7
         KOMw==
X-Gm-Message-State: AOJu0YwMu+/d6/g5dQihphIkTI5euP7/AXEHBGmz4nzI3aaCbyF/TmAK
	S8zAUIbmSWr64tDC4hyarwsuvyFJv4/1+CfVyx2DOAPHtsLEhw8ZTJTO+w==
X-Gm-Gg: ASbGncuuI2HkG8sXRYy0Q2eUUd9f+Uw5sfnJy3r7Or9KoRWOK/+0sBbgO38GDuiYc9u
	sQMoqhEhlAUMMqMQtst61qpfde1h78w7Nz8RLmguOs00IXX1EikRlU97rNGTs0Ow2CF7AIEoHvk
	s+II9JZnd8dFJHLIcJoiz0ZBGpyUzMkKfaq/Is7blCRHvLmvPU1XZ5FjGA1iX7ZmQ+d1uy9KHjg
	WYzS37ec+Onm1Nb8JaRaVE4MaxyWKLcNKZpyvgZLvnkbJoOWO3mS77xswtPyaA9CeY/JjsNr0Lf
	UYQXCWvcyX1azofXqGUM7skG4J8fD5qAL3E5ieGibnO4nr2/pRsOPOyBfB3VHe+ncvldrf89wCr
	sGH0ykmtjsqrRAR40J1fUcrcMHCqkWze8OPrjEUFxyd78
X-Google-Smtp-Source: AGHT+IEyEMQ29R7iJWsyeMoiHNRKTpTxJkC7z1ct9bFk1tx1zWM3LLQi4sSi88mCIjNHv5KGiJd7BQ==
X-Received: by 2002:a05:6214:2508:b0:6ed:1651:e8dc with SMTP id 6a1803df08f44-6eed5fc8470mr140444906d6.11.1743429759520;
        Mon, 31 Mar 2025 07:02:39 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6eec965a7d0sm47231246d6.62.2025.03.31.07.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:02:37 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 6/7] t/verify-trim.py: superficial test script for verify/trim
Date: Mon, 31 Mar 2025 10:01:33 -0400
Message-ID: <20250331140204.1971-7-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250331140204.1971-1-vincent.fu@samsung.com>
References: <20250331140204.1971-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fio can verify trim operations. This script adds some simple test cases
for this feature.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/verify-trim.py | 309 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 309 insertions(+)
 create mode 100755 t/verify-trim.py

diff --git a/t/verify-trim.py b/t/verify-trim.py
new file mode 100755
index 00000000..cd98722a
--- /dev/null
+++ b/t/verify-trim.py
@@ -0,0 +1,309 @@
+#!/usr/bin/env python3
+"""
+# verify-trim.c.py
+#
+# Test fio's verify trim feature.
+#
+# USAGE
+# see python3 verify-trim.c.py --help
+#
+# EXAMPLES
+# python3 t/verify-trim.c.py
+# python3 t/verify-trim.c.py --fio ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+# Linux
+#
+"""
+import os
+import sys
+import time
+import logging
+import argparse
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO, Requirements
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
+    'ioengine',
+    'trim_backlog_batch',
+    'trim_verify_zero',
+    'number_ios',
+]
+
+class VerifyTrimTest(FioJobCmdTest):
+    """
+    VerifyTrim test class.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=verifytrim",
+            "--verify=md5",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--trim_percentage={self.fio_opts['trim_percentage']}",
+            f"--trim_backlog={self.fio_opts['trim_backlog']}",
+            f"--output={self.filenames['output']}",
+        ]
+        for opt in VERIFY_OPT_LIST:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+    def check_result(self):
+        super().check_result()
+
+        if self.fio_opts.get('output-format') == 'json':
+            actual = self.json_data['jobs'][0]['trim']['total_ios']
+            expected = self.json_data['jobs'][0]['write']['total_ios'] * self.fio_opts['trim_percentage'] / 100
+            if abs(expected - actual) > 0.1*expected:
+                self.passed = False
+                self.failure_reason += f" large discrepancy between expected {expected} and {actual} actual trims,"
+            else:
+                logging.debug("expected %d trims ~match actual %d trims", expected, actual)
+
+        if not self.passed:
+            with open(self.filenames['stderr'], "r") as se:
+                contents = se.read()
+                logging.info("stderr: %s", contents)
+
+            with open(self.filenames['stdout'], "r") as so:
+                contents = so.read()
+                logging.info("stdout: %s", contents)
+
+            with open(self.filenames['output'], "r") as out:
+                contents = out.read()
+                logging.info("output: %s", contents)
+
+
+TEST_LIST = [
+    # These tests are superficial.
+    #
+    # TODO: add a test case for trim_verify_zero by inducing a failure; the way
+    # to do this would be to write non-zero data to a block after it was
+    # trimmed but before it was read back (how to do this?)
+    {
+        # make sure readonly option triggers error message when
+        # trim_{percentage,backlog} options make trim operations a possibility
+        "test_id": 1,
+        "fio_opts": {
+            "rw": "read",
+            "trim_percentage": 100,
+            "trim_backlog": 1,
+            "readonly": 1,
+            },
+        "test_class": VerifyTrimTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # basic test seq write
+        # trim_backlog=1
+        # trim_percentage=100
+        "test_id": 100,
+        "fio_opts": {
+            "rw": "write",
+            "trim_percentage": 100,
+            "trim_backlog": 1,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test rand write
+        # trim_backlog=1
+        # trim_percentage=100
+        "test_id": 101,
+        "fio_opts": {
+            "rw": "randwrite",
+            "trim_percentage": 100,
+            "trim_backlog": 1,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test seq write
+        # trim_backlog=1
+        # trim_percentage=50
+        "test_id": 102,
+        "fio_opts": {
+            "rw": "write",
+            "trim_percentage": 50,
+            "trim_backlog": 1,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test rand write
+        # trim_backlog=1
+        # trim_percentage=50
+        "test_id": 103,
+        "fio_opts": {
+            "rw": "randwrite",
+            "trim_percentage": 50,
+            "trim_backlog": 1,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test seq write
+        # trim_backlog=16
+        # trim_percentage=50
+        "test_id": 104,
+        "fio_opts": {
+            "rw": "write",
+            "trim_percentage": 50,
+            "trim_backlog": 16,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test rand write
+        # trim_backlog=16
+        # trim_percentage=50
+        "test_id": 105,
+        "fio_opts": {
+            "rw": "randwrite",
+            "trim_percentage": 50,
+            "trim_backlog": 16,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+
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
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('-k', '--skip-req', action='store_true',
+                        help='skip requirements checking')
+    parser.add_argument('--dut',
+                        help='Block device to test against (use null_blk if not provided')
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    """
+    Run tests for fio's verify trim feature.
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
+        f"verify-trim-test-{time.strftime('%Y%m%d-%H%M%S')}"
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
+    cleanup_nullb = False
+    if not args.dut:
+        subprocess.run(["sudo", "modprobe", "-r", "null_blk"],
+                       stdout=subprocess.PIPE,
+                       stderr=subprocess.PIPE)
+        subprocess.run(["sudo", "modprobe", "null_blk", "memory_backed=1", "discard=1"],
+                       stdout=subprocess.PIPE,
+                       stderr=subprocess.PIPE)
+        if os.path.exists('/dev/nullb0'):
+            args.dut = '/dev/nullb0'
+            cleanup_nullb = True
+        else:
+            print("No block device provided and could not create null_blk device for testing")
+            sys.exit(1)
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'verifytrim',
+              }
+
+    total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
+
+    try:
+        total['passed'], total['failed'], total['skipped'] = run_fio_tests(TEST_LIST, test_env, args)
+    except KeyboardInterrupt:
+        pass
+
+    if cleanup_nullb:
+        subprocess.run(["sudo", "modprobe", "-r", "null_blk"],
+                       stdout=subprocess.PIPE,
+                       stderr=subprocess.PIPE)
+
+    sys.exit(total['failed'])
+
+
+if __name__ == '__main__':
+    main()
-- 
2.47.2

