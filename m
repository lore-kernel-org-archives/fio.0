Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8CA86328
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753290356; cv=none; b=gaZXOMn+t4sBdFXI5WnnNy5o77VtsSjbqnzr1+QK9JQbWnF3i9lwS8wbfERZssROTqJSF4hgHoR9dK/xiydF+lRBvPomWIl8DCYuHr/TmpFMB2MsFhA38ZAnwkftyS0HuISacroa9aCAVjDCK5hs3IKHJDlPILYUXGb0ZZBCuaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753290356; c=relaxed/simple;
	bh=5hU767KSVAZrqOCdfMom9BO0uhqrm11PciBL8lPC8pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZJGOHRr/9qL1sgpsEzPmXySdhyDjVHD2JxZpwVgiKW8XlS/eDvFMaiMgqV3YwSJcMAV50xaNS63ZZ1mQhaPu0Dz+FnWjmttMpBeqqEgCjroTGStfVUGyMPaemA+DMo3sF4qgbl1xsg/SPuoIBpDgJq5iGjZm+HteUv2pIuRatU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gW35qEbd; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gW35qEbd"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e1f3b95449so121637885a.1
        for <fio@vger.kernel.org>; Wed, 23 Jul 2025 10:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753290354; x=1753895154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3eb9oWDW587rFkJHfW0hQakiCOY4UTSJjXEhXcs44m0=;
        b=gW35qEbdHCwOPCe/srCOD5vZSouqLoCJPgDNMtHJNhxOg2qui8rhJV+UX2i8EmZBdi
         AaSANcAiPfdsmE4FY99/9pXcgKYlnE8jFzs7bE5CQG6KrwhPeIkKf2m+xtA/duVsTwLs
         dnnb4NlRZvlvHspL5GWnNUGd9ufAxUnusGWDbIyr4E1LL5wAx7mhX+iy/jrH/MIKrMY+
         ZaZ94m/JKWdR9bUJDRo6zhX5IqjTmYy63gcPg+S6tskMYeM5+K00bWjQf3Jxm5S/XtjO
         9gjrRsq448rpAcMMXqFoPNidF0L9WypzDHjKgamqefEQoGo5thkdEJ60b5VPKsdJ4vqc
         ZAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753290354; x=1753895154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3eb9oWDW587rFkJHfW0hQakiCOY4UTSJjXEhXcs44m0=;
        b=X0Iea98HJjAyuJT7Uj6pAkHO5TfRAadi3kQmiN3ccDFEJR0aFkaBA5a3Oxc3axxHZE
         9AdAFNJ5DBvNmf6OQHAhWdhqxTHDHICAqyukoRIWquVZZi+y4q6gPUmTu/WhhkcNi0uC
         vp+nmIPuQgRsJ1JTSxEf3mNlry1XsphdafAMbezYbWaSTEwOl3HgE3e5qv5o5xPaFJlc
         00iXOcthEbKIbsGeTfcCBTDRQThZzUfOZIVYpAmvcKABV19YuxFHqpWY9IftNqloTEgk
         qPDLzx3m6ta1JJzVny6fw5jdnbGI9RriAx4Ze+SkonTdR9W+HuGxQDsMHAiIr5AODrTk
         dJzw==
X-Forwarded-Encrypted: i=1; AJvYcCVKFHtl3mPxNztmEx74oVXpM2OuBG/n/8s268Uc986sqcFZieQ5O1jgdW53hQkUGS/izQw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1qtbBZ9XIUUURXxMfA2z/Us5aClV/sdhz+ipGBbsje4ubM0yO
	Lu2d2kIyasJlztybqUQ1GoHJRiOBtuduLUsA642GEsii+BGUTupTYGWI
X-Gm-Gg: ASbGnctemsCuFS/sX20PDO8PpwZj5HjW/7aupUXNBJVPdjOJV7JZOvLzw0kAoUfddAo
	sPGxNb3bVFKP+XLKCFjLx1hnjLWSUhKD/jmxMNtQ9hF95S/OMfsKM3Ig1bZg/blkG7suuJlSp9k
	P+JNn1tOrFAcSir3nV3nxmR+NC671p9DWWMX5a6PKQK3ZXYZ7DgmEj1/kSgB2PGeWeyxQlf25UK
	T6/QVCoPk54Cilf0wY5LDaHb0WJS719VdkFqLP2dlaiqv2611LoPVJPtAWFWv9MMTtpCvsfVt/d
	+oUTjOonGmn8Y4botoWSeOIo7lfNOuMHPtBYYI7VXlWr5QX5GNtJuTrupZXtAL8clUqv8OLy5RJ
	qtBTuaPqiRHFse/5Om7OJCHCuJx82LHZQFyNIuGEPCC4a6x7XxDDNA/0bjQyg3xdfP71RpCtknV
	vC3imvoT06
X-Google-Smtp-Source: AGHT+IEm5jBsqyzBJHbRzV1glOznp62gGPL6ohxqYwO5i0+1Ylps0pGENtOvv9ZQYhb668TaXcbltw==
X-Received: by 2002:a05:620a:438b:b0:7e0:e2d7:e03 with SMTP id af79cd13be357-7e62a8af300mr451489585a.7.1753290353163;
        Wed, 23 Jul 2025 10:05:53 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e356cbfad9sm675482785a.110.2025.07.23.10.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 10:05:52 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: anuj1072538@gmail.com,
	axboe@kernel.dk,
	hch@infradead.org,
	joshi.k@samsung.com,
	anuj20.g@samsung.com,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/2] t/io_uring_pi: test script for io_uring PI
Date: Wed, 23 Jul 2025 13:04:57 -0400
Message-ID: <bfd3869a5446ecfdbc4096e1d893df382bf31b98.1753282479.git.vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1753282479.git.vincent.fu@samsung.com>
References: <cover.1753282479.git.vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test io_uring metadata support on NVMe devices.
Limited to direct=1 and metadata in a separate buffer.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/io_uring_pi.py | 408 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 408 insertions(+)
 create mode 100644 t/io_uring_pi.py

diff --git a/t/io_uring_pi.py b/t/io_uring_pi.py
new file mode 100644
index 00000000..bd92edfd
--- /dev/null
+++ b/t/io_uring_pi.py
@@ -0,0 +1,408 @@
+#!/usr/bin/env python3
+
+"""
+# io_uring_pi.py
+#
+# Test metadata support using the io_uring ioengine.
+#
+# USAGE
+# See python3 io_uring_pi.py --help
+#
+# EXAMPLES (THIS IS A DESTRUCTIVE TEST!!)
+# python3 t/io_uring_pi.py --dut /dev/nvme1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+
+import os
+import sys
+import json
+import time
+import locale
+import logging
+import argparse
+import itertools
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+
+NUMBER_IOS = 8192
+BS_LOW = 1
+BS_HIGH = 16
+
+class DifDixTest(FioJobCmdTest):
+    """
+    NVMe DIF/DIX test class.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=io_uring_pi",
+            "--ioengine=io_uring",
+            "--direct=1",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--bsrange={self.fio_opts['bsrange']}",
+            f"--output={os.path.basename(self.filenames['output'])}",
+            f"--md_per_io_size={self.fio_opts['md_per_io_size']}",
+            "--pi_act=0",
+            f"--pi_chk={self.fio_opts['pi_chk']}",
+            f"--apptag={self.fio_opts['apptag']}",
+            f"--apptag_mask={self.fio_opts['apptag_mask']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'offset', 'number_ios',
+                    'output-format']:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+TEST_LIST = [
+#
+# Write data with pi_act=0 and then read the data back
+#
+    {
+        # Write workload with variable IO sizes
+        # pi_act=0
+        "test_id": 101,
+        "fio_opts": {
+            "rw": 'write',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with fixed small IO size
+        # pi_act=0
+        "test_id": 102,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_LOW,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO size
+        # pi_act=0
+        "test_id": 103,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0x8888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO size
+        # trigger apptag mismatch error
+        # pi_act=0
+        "test_id": 104,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0xA888",
+            "apptag_mask": "0xFFFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+    {
+        # Read workload with variable IO size
+        # fails because apptag mask must be 0xFFFF
+        # pi_act=0
+        "test_id": 105,
+        "fio_opts": {
+            "rw": 'read',
+            "number_ios": NUMBER_IOS,
+            "output-format": "json",
+            "apptag": "0xF888",
+            "apptag_mask": "0x0FFF",
+            "pi_act": 0,
+            },
+        "pi_chk": "GUARD,REFTAG,APPTAG",
+        "bs_low": BS_LOW,
+        "bs_high": BS_HIGH,
+        "success": SUCCESS_NONZERO,
+        "test_class": DifDixTest,
+    },
+]
+
+
+def get_lbafs(args):
+    """
+    Determine which LBA formats to use. Use either the ones specified on the
+    command line or if none are specified query the device and use all lba
+    formats with metadata.
+    """
+    lbaf_list = []
+    id_ns_cmd = f"sudo nvme id-ns --output-format=json {args.dut}".split(' ')
+    id_ns_output = subprocess.check_output(id_ns_cmd)
+    lbafs = json.loads(id_ns_output)['lbafs']
+    if args.lbaf:
+        for lbaf in args.lbaf:
+            lbaf_list.append({'lbaf': lbaf, 'ds': 2 ** lbafs[lbaf]['ds'],
+                              'ms': lbafs[lbaf]['ms'], })
+            if lbafs[lbaf]['ms'] == 0:
+                print(f'Error: lbaf {lbaf} has metadata size zero')
+                sys.exit(1)
+    else:
+        for lbaf_num, lbaf in enumerate(lbafs):
+            if lbaf['ms'] != 0:
+                lbaf_list.append({'lbaf': lbaf_num, 'ds': 2 ** lbaf['ds'],
+                                  'ms': lbaf['ms'], })
+
+    return lbaf_list
+
+
+def get_guard_pi(lbaf_list, args):
+    """
+    Find out how many bits of guard protection information are associated with
+    each lbaf to be used. If this is not available assume 16-bit guard pi.
+    Also record the bytes of protection information associated with the number
+    of guard PI bits.
+    """
+    nvm_id_ns_cmd = f"sudo nvme nvm-id-ns --output-format=json {args.dut}".split(' ')
+    try:
+        nvm_id_ns_output = subprocess.check_output(nvm_id_ns_cmd)
+    except subprocess.CalledProcessError:
+        print(f"Non-zero return code from {' '.join(nvm_id_ns_cmd)}; " \
+                "assuming all lbafs use 16b Guard Protection Information")
+        for lbaf in lbaf_list:
+            lbaf['guard_pi_bits'] = 16
+    else:
+        elbafs = json.loads(nvm_id_ns_output)['elbafs']
+        for elbaf_num, elbaf in enumerate(elbafs):
+            for lbaf in lbaf_list:
+                if lbaf['lbaf'] == elbaf_num:
+                    lbaf['guard_pi_bits'] = 16 << elbaf['pif']
+
+    # For 16b Guard Protection Information, the PI requires 8 bytes
+    # For 32b and 64b Guard PI, the PI requires 16 bytes
+    for lbaf in lbaf_list:
+        if lbaf['guard_pi_bits'] == 16:
+            lbaf['pi_bytes'] = 8
+        else:
+            lbaf['pi_bytes'] = 16
+
+
+def get_capabilities(args):
+    """
+    Determine what end-to-end data protection features the device supports.
+    """
+    caps = { 'pil': [], 'pitype': [], 'elba': [] }
+    id_ns_cmd = f"sudo nvme id-ns --output-format=json {args.dut}".split(' ')
+    id_ns_output = subprocess.check_output(id_ns_cmd)
+    id_ns_json = json.loads(id_ns_output)
+
+    mc = id_ns_json['mc']
+    if mc & 1:
+        caps['elba'].append(1)
+    if mc & 2:
+        caps['elba'].append(0)
+
+    dpc = id_ns_json['dpc']
+    if dpc & 1:
+        caps['pitype'].append(1)
+    if dpc & 2:
+        caps['pitype'].append(2)
+    if dpc & 4:
+        caps['pitype'].append(3)
+    if dpc & 8:
+        caps['pil'].append(1)
+    if dpc & 16:
+        caps['pil'].append(0)
+
+    for _, value in caps.items():
+        if len(value) == 0:
+            logging.error("One or more end-to-end data protection features unsupported: %s", caps)
+            sys.exit(-1)
+
+    return caps
+
+
+def format_device(args, lbaf, pitype, pil, elba):
+    """
+    Format device using specified lba format with specified pitype, pil, and
+    elba values.
+    """
+
+    format_cmd = f"sudo nvme format {args.dut} --lbaf={lbaf['lbaf']} " \
+                 f"--pi={pitype} --pil={pil} --ms={elba} --force"
+    logging.debug("Format command: %s", format_cmd)
+    format_cmd = format_cmd.split(' ')
+    format_cmd_result = subprocess.run(format_cmd, capture_output=True, check=False,
+                                       encoding=locale.getpreferredencoding())
+
+    # Sometimes nvme-cli may format the device successfully but fail to
+    # rescan the namespaces after the format. Continue if this happens but
+    # abort if some other error occurs.
+    if format_cmd_result.returncode != 0:
+        if 'failed to rescan namespaces' not in format_cmd_result.stderr \
+                or 'Success formatting namespace' not in format_cmd_result.stdout:
+            logging.error(format_cmd_result.stdout)
+            logging.error(format_cmd_result.stderr)
+            print("Unable to format device; skipping this configuration")
+            return False
+
+    logging.debug(format_cmd_result.stdout)
+    return True
+
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
+    parser.add_argument('--dut', help='target device to test '
+                        '(e.g., /dev/nvme1n1). WARNING: THIS IS A DESTRUCTIVE TEST', required=True)
+    parser.add_argument('-l', '--lbaf', nargs='+', type=int,
+                        help='list of lba formats to test')
+    args = parser.parse_args()
+
+    return args
+
+
+def difdix_test(test_env, args, lbaf, pitype):
+    """
+    Adjust test arguments based on values of lbaf, and pitype.  Then run
+    the tests.
+    """
+    for test in TEST_LIST:
+        test['force_skip'] = False
+
+        blocksize = lbaf['ds']
+        # Set fio blocksize parameter at runtime
+        test['fio_opts']['md_per_io_size'] = lbaf['ms'] * test['bs_high']
+
+        test['fio_opts']['bsrange'] = f"{blocksize * test['bs_low']}-{blocksize * test['bs_high']}"
+
+        # Set fio pi_chk parameter at runtime. If the device is formatted
+        # with Type 3 protection information, this means that the reference
+        # tag is not checked and I/O commands may throw an error if they
+        # are submitted with the REFTAG bit set in pi_chk. Make sure fio
+        # does not set pi_chk's REFTAG bit if the device is formatted with
+        # Type 3 PI.
+        if 'pi_chk' in test:
+            if pitype == 3 and 'REFTAG' in test['pi_chk']:
+                test['fio_opts']['pi_chk'] = test['pi_chk'].replace('REFTAG','')
+                logging.debug("Type 3 PI: dropping REFTAG bit")
+            else:
+                test['fio_opts']['pi_chk'] = test['pi_chk']
+
+        logging.debug("Test %d: pi_act=%d, bsrange=%s, md_per_io_size=%d", test['test_id'],
+                      test['fio_opts']['pi_act'], test['fio_opts']['bsrange'],
+                      test['fio_opts']['md_per_io_size'])
+
+    return run_fio_tests(TEST_LIST, test_env, args)
+
+
+def main():
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"io_uring_pi-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path is {fio_path}")
+
+    lbaf_list = get_lbafs(args)
+    get_guard_pi(lbaf_list, args)
+    caps = get_capabilities(args)
+    print("Device capabilities:", caps)
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'io_uring_pi',
+              }
+
+    total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
+
+    try:
+        for lbaf, pil, pitype in itertools.product(lbaf_list, caps['pil'], caps['pitype']):
+            if lbaf['ms'] == 0:
+                continue
+
+            print("\n")
+            print("-" * 120)
+            print(f"lbaf: {lbaf}, pil: {pil}, pitype: {pitype}")
+            print("-" * 120)
+
+            if not format_device(args, lbaf, pitype, pil, 0):
+                print("Formatting failed")
+                continue
+
+            test_env['artifact_root'] = \
+                os.path.join(artifact_root, f"lbaf{lbaf['lbaf']}pil{pil}pitype{pitype}")
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = difdix_test(test_env, args, lbaf, pitype)
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
2.47.2

