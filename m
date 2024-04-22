Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92271153BF2
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808549; cv=none; b=YSfCVVcOUBWAgSENFDf6fqkitfupYLNe0zznTO0G/Z2vwehLHME2U7rNes32TkUNgkL5Z1UOPoAIhuxkgYVfj1EwGJquBOW+CmzwXJOkTfzAsQgqF64irVfGx3JJJhCnPdptduFjZoG/Xp3ygkOOGqWQ92vLxcyBYXAzmJMncaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808549; c=relaxed/simple;
	bh=73LfmRyGz+UAIErihq1HzMqJpQS95yR8Dk9CJiFUWFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shRUBLbHbbKp1xqWZB2Ff9VXVPcHnzteBby473HevWkUU7Qot8VLl5GWJjYlCD6q+ZOuQniybXzuLj2OoBoV+t7EY2wMPuH3PXzXRJuAak4nDuDeYyvHBH5101BTB8cuYNd1DiyvZukOueGO0ntHFIyYHunu3gpWo8vZsj+aSdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWLPPRIp; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWLPPRIp"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-69b7d2de292so16427766d6.2
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808546; x=1714413346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IEpmkFgNs5ILaFry229E7qip9xSewByzchGC0bj6aLY=;
        b=GWLPPRIpdjQS99Wfjsz36KqeSx0HO0j4w9aA+p1odR45AsDsait0kBMKn/Q8hSeveY
         F9mEu1nrDPEf3aVlS3GUWG08I7B0eN42Guon6tL8emGb26ElG08RVEi4Y7VpPHM2T3UX
         Io8HdDEZ3wBh9JJAdOPnynoTSONy3d3ZdPofAwwhWgYfYjcwtFxWAt9hQ6jv78fq0kwo
         FD02GjMsWVKmtZ/DSai4nKh+gR3pK9hAP6QfCbp6mVNrR9TZ4UZ1mcD1vOUkgnp6mE/o
         5KdNieLyNi/M7tBGHqS7kIDYEhyalDnw9Bk5OsBmLNiGaDyIMmjoV4yPOloRmNW3XqP8
         ToGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808546; x=1714413346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IEpmkFgNs5ILaFry229E7qip9xSewByzchGC0bj6aLY=;
        b=aDoW0abQoyv0VnrAIHs4HyIMbsJpncfEqJhmSc0q43TsD5NvnhczfEBIAfr1uGAhWg
         5XNkBCaasmAzIovgvJzTG1T8y+zTyBuxmguQk3vhpWxtQxb3VLu+OML+ogncFoO9ng8g
         X5fwK52uQBQx16s/idKHP3KD2D+VDEMzs2gOm0JDtWi40fPxzYtQgw/IXozrxxTUlvED
         R9ZcEtAXPMgnSjqlj8D3W+ELu4hKkhQWbF0AAASar6+hQk7QoIj3NLGYXN/hszthnwFx
         K6qBdbrGZ5zlH408bIOraeDUBlH/OfWKQVfeDm0vqynGPo//k063BhCK802C3ulpBYoN
         M0Fw==
X-Forwarded-Encrypted: i=1; AJvYcCVF+r638WQZyuXuvxcdsL48rAICs5FMycFe4Nzz6p97zJr8AhB+nPXGKnW2ZICfJtlLOmvOuRmgTZU+0hVigw1tk2Yj
X-Gm-Message-State: AOJu0Ywjc7k/f6MT3u43/kDI1F24GdPzNM02azGw9yp6cjK7bLZ8pzf+
	Dy3XJBIcFwIOsAhaBL9kb2k4JevnLY/60HKo+KzJFOYdLWU9GfZG
X-Google-Smtp-Source: AGHT+IEJmLgshEaZvv0J8gWWfjKQev3eeuLC1QN/J48CJhx0YxUy/k/HGukygJEwX4Ymy8Wmv8N0cw==
X-Received: by 2002:a05:6214:1742:b0:699:2760:b44 with SMTP id dc2-20020a056214174200b0069927600b44mr10223595qvb.8.1713808546329;
        Mon, 22 Apr 2024 10:55:46 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:45 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 3/9] t/nvmept_fdp.py: test script for FDP
Date: Mon, 22 Apr 2024 13:49:49 -0400
Message-ID: <20240422175522.4614-4-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240422175522.4614-1-vincent.fu@samsung.com>
References: <20240422175522.4614-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test script uses the io_uring pass-through ioengine to test fio's
FDP support. This uses both the orignal and the new fdp-related options.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/nvmept_fdp.py | 745 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 745 insertions(+)
 create mode 100755 t/nvmept_fdp.py

diff --git a/t/nvmept_fdp.py b/t/nvmept_fdp.py
new file mode 100755
index 00000000..031b439c
--- /dev/null
+++ b/t/nvmept_fdp.py
@@ -0,0 +1,745 @@
+#!/usr/bin/env python3
+#
+# Copyright 2024 Samsung Electronics Co., Ltd All Rights Reserved
+#
+# For conditions of distribution and use, see the accompanying COPYING file.
+#
+"""
+# nvmept_fdp.py
+#
+# Test fio's io_uring_cmd ioengine with NVMe pass-through FDP write commands.
+#
+# USAGE
+# see python3 nvmept_fdp.py --help
+#
+# EXAMPLES
+# python3 t/nvmept_fdp.py --dut /dev/ng0n1
+# python3 t/nvmept_fdp.py --dut /dev/ng1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+# Device formatted with LBA data size 4096 bytes
+# Device with at least five placement IDs
+#
+# WARNING
+# This is a destructive test
+"""
+import os
+import sys
+import json
+import time
+import locale
+import logging
+import argparse
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+
+class FDPTest(FioJobCmdTest):
+    """
+    NVMe pass-through test class. Check to make sure output for selected data
+    direction(s) is non-zero and that zero data appears for other directions.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=nvmept-fdp",
+            "--ioengine=io_uring_cmd",
+            "--cmd_type=nvme",
+            "--randrepeat=0",
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
+                    'buffer_pattern', 'verify_pattern', 'offset', 'fdp',
+                    'fdp_pli', 'fdp_pli_select', 'dataplacement', 'plid_select',
+                    'plids', 'number_ios']:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+    def check_result(self):
+        try:
+            self._check_result()
+        finally:
+            if not update_all_ruhs(self.fio_opts['filename']):
+                logging.error("Could not reset device")
+            if not check_all_ruhs(self.fio_opts['filename']):
+                logging.error("Reclaim units have inconsistent RUAMW values")
+
+
+    def _check_result(self):
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
+        if 'iodepth' in self.fio_opts:
+            # We will need to figure something out if any test uses an iodepth
+            # different from 8
+            if job['iodepth_level']['8'] < 95:
+                logging.error("Did not achieve requested iodepth")
+                self.passed = False
+            else:
+                logging.debug("iodepth 8 target met %s", job['iodepth_level']['8'])
+
+
+class FDPMultiplePLIDTest(FDPTest):
+    """
+    Write to multiple placement IDs.
+    """
+
+    def setup(self, parameters):
+        mapping = {
+                    'nruhsd': FIO_FDP_NUMBER_PLIDS,
+                    'max_ruamw': FIO_FDP_MAX_RUAMW,
+                }
+        if 'number_ios' in self.fio_opts and isinstance(self.fio_opts['number_ios'], str):
+            self.fio_opts['number_ios'] = eval(self.fio_opts['number_ios'].format(**mapping))
+
+        super().setup(parameters)
+
+    def _check_result(self):
+        if 'fdp_pli' in self.fio_opts:
+            plid_list = self.fio_opts['fdp_pli'].split(',')
+        elif 'plids' in self.fio_opts:
+            plid_list = self.fio_opts['plids'].split(',')
+        else:
+            plid_list = list(range(FIO_FDP_NUMBER_PLIDS))
+
+        plid_list = sorted([int(i) for i in plid_list])
+        logging.debug("plid_list: %s", str(plid_list))
+
+        fdp_status = get_fdp_status(self.fio_opts['filename'])
+
+        select = "roundrobin"
+        if 'fdp_pli_select' in self.fio_opts:
+            select = self.fio_opts['fdp_pli_select']
+        elif 'plid_select' in self.fio_opts:
+            select = self.fio_opts['plid_select']
+
+        if select == "roundrobin":
+            self._check_robin(plid_list, fdp_status)
+        elif select == "random":
+            self._check_random(plid_list, fdp_status)
+        else:
+            logging.error("Unknown plid selection strategy %s", select)
+            self.passed = False
+
+        super()._check_result()
+
+    def _check_robin(self, plid_list, fdp_status):
+        """
+        With round robin we can know exactly how many writes each PLID will
+        receive.
+        """
+        ruamw = [FIO_FDP_MAX_RUAMW] * FIO_FDP_NUMBER_PLIDS
+
+        remainder = int(self.fio_opts['number_ios'] % len(plid_list))
+        whole = int((self.fio_opts['number_ios'] - remainder) / len(plid_list))
+        logging.debug("PLIDs in the list should receive %d writes; %d PLIDs will receive one extra",
+                      whole, remainder)
+
+        for plid in plid_list:
+            ruamw[plid] -= whole
+            if remainder:
+                ruamw[plid] -= 1
+                remainder -= 1
+        logging.debug("Expected ruamw values: %s", str(ruamw))
+
+        for idx, ruhs in enumerate(fdp_status['ruhss']):
+            if ruhs['ruamw'] != ruamw[idx]:
+                logging.error("RUAMW mismatch with idx %d, pid %d, expected %d, observed %d", idx,
+                              ruhs['pid'], ruamw[idx], ruhs['ruamw'])
+                self.passed = False
+                break
+
+            logging.debug("RUAMW match with idx %d, pid %d: ruamw=%d", idx, ruhs['pid'], ruamw[idx])
+
+    def _check_random(self, plid_list, fdp_status):
+        """
+        With random selection, a set of PLIDs will receive all the write
+        operations and the remainder will be untouched.
+        """
+
+        total_ruamw = 0
+        for plid in plid_list:
+            total_ruamw += fdp_status['ruhss'][plid]['ruamw']
+
+        expected = len(plid_list) * FIO_FDP_MAX_RUAMW - self.fio_opts['number_ios']
+        if total_ruamw != expected:
+            logging.error("Expected total ruamw %d for plids %s, observed %d", expected,
+                          str(plid_list), total_ruamw)
+            self.passed = False
+        else:
+            logging.debug("Observed expected total ruamw %d for plids %s", expected, str(plid_list))
+
+        for idx, ruhs in enumerate(fdp_status['ruhss']):
+            if idx in plid_list:
+                continue
+            if ruhs['ruamw'] != FIO_FDP_MAX_RUAMW:
+                logging.error("Unexpected ruamw %d for idx %d, pid %d, expected %d", ruhs['ruamw'],
+                              idx, ruhs['pid'], FIO_FDP_MAX_RUAMW)
+                self.passed = False
+            else:
+                logging.debug("Observed expected ruamw %d for idx %d, pid %d", ruhs['ruamw'], idx,
+                              ruhs['pid'])
+
+
+class FDPSinglePLIDTest(FDPTest):
+    """
+    Write to a single placement ID only.
+    """
+
+    def _check_result(self):
+        if 'plids' in self.fio_opts:
+            plid = self.fio_opts['plids']
+        elif 'fdp_pli' in self.fio_opts:
+            plid = self.fio_opts['fdp_pli']
+        else:
+            plid = 0
+
+        fdp_status = get_fdp_status(self.fio_opts['filename'])
+        ruamw = fdp_status['ruhss'][plid]['ruamw']
+        lba_count = self.fio_opts['number_ios']
+
+        if FIO_FDP_MAX_RUAMW - lba_count != ruamw:
+            logging.error("FDP accounting mismatch for plid %d; expected ruamw %d, observed %d",
+                          plid, FIO_FDP_MAX_RUAMW - lba_count, ruamw)
+            self.passed = False
+        else:
+            logging.debug("FDP accounting as expected for plid %d; ruamw = %d", plid, ruamw)
+
+        super()._check_result()
+
+
+class FDPReadTest(FDPTest):
+    """
+    Read workload test.
+    """
+
+    def _check_result(self):
+        ruamw = check_all_ruhs(self.fio_opts['filename'])
+
+        if ruamw != FIO_FDP_MAX_RUAMW:
+            logging.error("Read workload affected FDP ruamw")
+            self.passed = False
+        else:
+            logging.debug("Read workload did not disturb FDP ruamw")
+            super()._check_result()
+
+
+def get_fdp_status(dut):
+    """
+    Run the nvme-cli command to obtain FDP status and return result as a JSON
+    object.
+    """
+
+    cmd = f"sudo nvme fdp status --output-format=json {dut}"
+    cmd = cmd.split(' ')
+    cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                encoding=locale.getpreferredencoding())
+
+    if cmd_result.returncode != 0:
+        logging.error("Error obtaining device %s FDP status: %s", dut, cmd_result.stderr)
+        return False
+
+    return json.loads(cmd_result.stdout)
+
+
+def update_ruh(dut, plid):
+    """
+    Update reclaim unit handles with specified ID(s). This tells the device to
+    point the RUH to a new (empty) reclaim unit.
+    """
+
+    ids = ','.join(plid) if isinstance(plid, list) else plid
+    cmd = f"nvme fdp update --pids={ids} {dut}"
+    cmd = cmd.split(' ')
+    cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                encoding=locale.getpreferredencoding())
+
+    if cmd_result.returncode != 0:
+        logging.error("Error updating RUH %s ID(s) %s", dut, ids)
+        return False
+
+    return True
+
+
+def update_all_ruhs(dut):
+    """
+    Update all reclaim unit handles on the device.
+    """
+
+    fdp_status = get_fdp_status(dut)
+    for ruhs in fdp_status['ruhss']:
+        if not update_ruh(dut, ruhs['pid']):
+            return False
+
+    return True
+
+
+def check_all_ruhs(dut):
+    """
+    Check that all RUHs have the same value for reclaim unit available media
+    writes (RUAMW).  Return the RUAMW value.
+    """
+
+    fdp_status = get_fdp_status(dut)
+    ruh_status = fdp_status['ruhss']
+
+    ruamw = ruh_status[0]['ruamw']
+    for ruhs in ruh_status:
+        if ruhs['ruamw'] != ruamw:
+            logging.error("RUAMW mismatch: found %d, expected %d", ruhs['ruamw'], ruamw)
+            return False
+
+    return ruamw
+
+
+TEST_LIST = [
+    # Write one LBA to one PLID using both the old and new sets of options
+    ## omit fdp_pli_select/plid_select
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 3,
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    ## fdp_pli_select/plid_select=roundrobin
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "fdp_pli_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 3,
+            "plid_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    ## fdp_pli_select/plid_select=random
+    {
+        "test_id": 5,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 6,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 1,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 3,
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    # Write four LBAs to one PLID using both the old and new sets of options
+    ## omit fdp_pli_select/plid_select
+    {
+        "test_id": 7,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 1,
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 8,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 1,
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    ## fdp_pli_select/plid_select=roundrobin
+    {
+        "test_id": 9,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 1,
+            "fdp_pli_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 10,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 1,
+            "plid_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    ## fdp_pli_select/plid_select=random
+    {
+        "test_id": 11,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 1,
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    {
+        "test_id": 12,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 4,
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": 1,
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    # Just a regular write without FDP directive--should land on plid 0
+    {
+        "test_id": 13,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": 19,
+            "verify": "crc32c",
+            "output-format": "json",
+            },
+        "test_class": FDPSinglePLIDTest,
+    },
+    # Read workload
+    {
+        "test_id": 14,
+        "fio_opts": {
+            "rw": 'randread',
+            "bs": 4096,
+            "number_ios": 19,
+            "output-format": "json",
+            },
+        "test_class": FDPReadTest,
+    },
+    # write to multiple PLIDs using round robin to select PLIDs
+    ## write to all PLIDs using old and new sets of options
+    {
+        "test_id": 100,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "2*{nruhsd}+3",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 101,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "2*{nruhsd}+3",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plid_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    ## write to a subset of PLIDs using old and new sets of options
+    {
+        "test_id": 102,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{nruhsd}+1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "1,3",
+            "fdp_pli_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 103,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{nruhsd}+1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": "1,3",
+            "plid_select": "roundrobin",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    # write to multiple PLIDs using random selection of PLIDs
+    ## write to all PLIDs using old and new sets of options
+    {
+        "test_id": 200,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 201,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    ## write to a subset of PLIDs using old and new sets of options
+    {
+        "test_id": 202,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": "1,3,4",
+            "fdp_pli_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    {
+        "test_id": 203,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "number_ios": "{max_ruamw}-1",
+            "verify": "crc32c",
+            "dataplacement": "fdp",
+            "plids": "1,3,4",
+            "plid_select": "random",
+            "output-format": "json",
+            },
+        "test_class": FDPMultiplePLIDTest,
+    },
+    # Specify invalid options fdp=1 and dataplacement=none
+    {
+        "test_id": 300,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "output-format": "normal",
+            "dataplacement": "none",
+            },
+        "test_class": FDPTest,
+        "success": SUCCESS_NONZERO,
+    },
+    # Specify invalid options fdp=1 and dataplacement=streams
+    {
+        "test_id": 301,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 4096,
+            "verify": "crc32c",
+            "fdp": 1,
+            "fdp_pli": 3,
+            "output-format": "normal",
+            "dataplacement": "streams",
+            },
+        "test_class": FDPTest,
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
+FIO_FDP_MAX_RUAMW = 0
+FIO_FDP_NUMBER_PLIDS = 0
+
+def main():
+    """Run tests using fio's io_uring_cmd ioengine to send NVMe pass through commands."""
+    global FIO_FDP_MAX_RUAMW
+    global FIO_FDP_NUMBER_PLIDS
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"nvmept-fdp-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = 'fio'
+    print(f"fio path is {fio_path}")
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+
+    fdp_status = get_fdp_status(args.dut)
+    FIO_FDP_NUMBER_PLIDS = fdp_status['nruhsd']
+    update_all_ruhs(args.dut)
+    FIO_FDP_MAX_RUAMW = check_all_ruhs(args.dut)
+    if not FIO_FDP_MAX_RUAMW:
+        sys.exit(-1)
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'nvmept-fdp',
+              }
+
+    _, failed, _ = run_fio_tests(TEST_LIST, test_env, args)
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
-- 
2.43.0

