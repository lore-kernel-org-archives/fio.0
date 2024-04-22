Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643A5154BF9
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808554; cv=none; b=rAKxn5gstduaJZM4jQ4qOMQncbmE8Gy469VkDDajf0abMnJLGmZHSPepivaIAnezEOVex5G1Z8I7MJBNLFq9Nidod6zLPtb89igtdFRG2ac9GBIa4Qbyw/LRN+8Flv4dVfE0zB5sXG9VtEBzEK1kkj4EHh7qrU5kvsYblrnskGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808554; c=relaxed/simple;
	bh=h0/WfvAAZHPfWtkSHCuPu/Lc9KhU0sOW6MtWV0r7tYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlOqkuUV7snGdxVjOHlSwAJhTMqcQQipfaWaZnq33IqXCUlmux5zkXKotVg+QIlAiB21C8IWYRzkzM9Moz5iczIz9fugAbtPk0YfxHP/oTjsUjC4F9q8kIHI0NpLja/oupws4YrPPiaOnXzQMKHV0vcgZtZVg6aJCbmOd/ZgI2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QDIfq1iD; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDIfq1iD"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-de45d4ca525so4672953276.0
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808551; x=1714413351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJ1SWcCbem4sr9r+t1vtljj+cK1ksTLObgQnuFSYnoU=;
        b=QDIfq1iDYWBTcmTUNVAzi2KTGV/eKaBvRYjWZTVdlZLm4p9qd2aMlY1/0zZe4MWX80
         n1nneNCR9QS6yMa8vswptLtDmR3CiG35wjofXz/yPqPyjhQ4IowrTXaeiP1LIkjEzKn2
         BRrFii5Eaz+yV8YknjiHz1xMrTX1NRaU7E4zt7gMvlh7GqqcLbfeIy1aoNpgsVlRVaj2
         bZ94Bbs8g/75neFmY5z+VQSyLwf8tGyXxx8roP9KGcv/nQsYYQmK7rWV8earsRUH/7oz
         0R1d+QU37rYFAhu1g9TvJTX4hVwpQzF0sePEv3x/ZdXxImeJ6lB812vehCyHpqGezV6n
         EC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808551; x=1714413351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJ1SWcCbem4sr9r+t1vtljj+cK1ksTLObgQnuFSYnoU=;
        b=Sck9/kVB5iBct8iiMUQBNPgfC/96QHd3O7umPgGWj16syosrViiAo7XSwdySTWEUdG
         TebXAIGUXYsMiXf1dhPGsDILJ/pozJhq+Eja5XTEVNRT7dCB5/yJXWw/qpMn7wKmQnad
         SwrGPlGOzZ6L5rMLTPuSKT1zXVuqX0WslAJseKN1mrbWf808GTd81AzEA9u7oC6DRg8g
         hRDQjA2eIAa6yYT2y7dygiPtiEmF/4MKPNRxsZfxUHj6xuI3LaNNOPubqUupLeHDNQcY
         qJz8wG/iK0T9k1NwW16EBLhHZar16+NYrmxx+RjjomKw4NtkzcR0xkI3rQYhkOgIlCxU
         IuBA==
X-Forwarded-Encrypted: i=1; AJvYcCWTug7RU360k39RQpSluYhnSR2Bo0AZ6DCW9PlTO/q5B3AEmE23vPrphcDvPnkfmTj6kq4a8LmJUSBs4UTSuUYmcRmh
X-Gm-Message-State: AOJu0YzNM45mF2CLtfwBL0oop9hNx+Nna9OcPF0QNsd/N3QDz14pb6JM
	sEwpllJ1ExHQ1g3wWeeqMaSfc1lLoShFN+L8HEmf4rnOSHaSrGx7ZRFfLA==
X-Google-Smtp-Source: AGHT+IFJxSzESRUH9383T3TsYDdnfCU7AhkK8J9UkIp++VZF0jDv2KaygrbtYPI9JNSMRdwt0SbIGw==
X-Received: by 2002:a25:ae9a:0:b0:dc6:fee4:e889 with SMTP id b26-20020a25ae9a000000b00dc6fee4e889mr12111993ybj.13.1713808551156;
        Mon, 22 Apr 2024 10:55:51 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:50 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 8/9] t/nvmept_streams: test NVMe streams support
Date: Mon, 22 Apr 2024 13:49:54 -0400
Message-ID: <20240422175522.4614-9-vincent.fu@samsung.com>
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

This test script uses the io_uring pass-through ioengine to test NVMe
streams support.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/nvmept_streams.py | 520 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 520 insertions(+)
 create mode 100755 t/nvmept_streams.py

diff --git a/t/nvmept_streams.py b/t/nvmept_streams.py
new file mode 100755
index 00000000..e5425506
--- /dev/null
+++ b/t/nvmept_streams.py
@@ -0,0 +1,520 @@
+#!/usr/bin/env python3
+#
+# Copyright 2024 Samsung Electronics Co., Ltd All Rights Reserved
+#
+# For conditions of distribution and use, see the accompanying COPYING file.
+#
+"""
+# nvmept_streams.py
+#
+# Test fio's NVMe streams support using the io_uring_cmd ioengine with NVMe
+# pass-through commands.
+#
+# USAGE
+# see python3 nvmept_streams.py --help
+#
+# EXAMPLES
+# python3 t/nvmept_streams.py --dut /dev/ng0n1
+# python3 t/nvmept_streams.py --dut /dev/ng1n1 -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+# WARNING
+# This is a destructive test
+#
+# Enable streams with
+# nvme dir-send -D 0 -O 1 -e 1 -T 1 /dev/nvme0n1
+#
+# See streams directive status with
+# nvme dir-receive -D 0 -O 1 -H /dev/nvme0n1
+"""
+import os
+import sys
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
+class StreamsTest(FioJobCmdTest):
+    """
+    NVMe pass-through test class for streams. Check to make sure output for
+    selected data direction(s) is non-zero and that zero data appears for other
+    directions.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=nvmept-streams",
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
+                    'buffer_pattern', 'verify_pattern', 'offset', 'dataplacement',
+                    'plids', 'plid_select' ]:
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
+            release_all_streams(self.fio_opts['filename'])
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
+        stream_ids = [int(stream) for stream in self.fio_opts['plids'].split(',')]
+        if not self.check_streams(self.fio_opts['filename'], stream_ids):
+            self.passed = False
+            logging.error("Streams not as expected")
+        else:
+            logging.debug("Streams created as expected")
+
+
+    def check_streams(self, dut, stream_ids):
+        """
+        Confirm that the specified stream IDs exist on the specified device.
+        """
+
+        id_list = get_device_stream_ids(dut)
+        if not id_list:
+            return False
+
+        for stream in stream_ids:
+            if stream in id_list:
+                logging.debug("Stream ID %d found active on device", stream)
+                id_list.remove(stream)
+            else:
+                if self.__class__.__name__ != "StreamsTestRand":
+                    logging.error("Stream ID %d not found on device", stream)
+                else:
+                    logging.debug("Stream ID %d not found on device", stream)
+                return False
+
+        if len(id_list) != 0:
+            logging.error("Extra stream IDs %s found on device", str(id_list))
+            return False
+
+        return True
+
+
+class StreamsTestRR(StreamsTest):
+    """
+    NVMe pass-through test class for streams. Check to make sure output for
+    selected data direction(s) is non-zero and that zero data appears for other
+    directions. Check that Stream IDs are accessed in round robin order.
+    """
+
+    def check_streams(self, dut, stream_ids):
+        """
+        The number of IOs is less than the number of stream IDs provided. Let N
+        be the number of IOs. Make sure that the device only has the first N of
+        the stream IDs provided.
+
+        This will miss some cases where some other selection algorithm happens
+        to select the first N stream IDs. The solution would be to repeat this
+        test multiple times. Multiple trials passing would be evidence that
+        round robin is working correctly.
+        """
+
+        id_list = get_device_stream_ids(dut)
+        if not id_list:
+            return False
+
+        num_streams = int(self.fio_opts['io_size'] / self.fio_opts['bs'])
+        stream_ids = sorted(stream_ids)[0:num_streams]
+
+        return super().check_streams(dut, stream_ids)
+
+
+class StreamsTestRand(StreamsTest):
+    """
+    NVMe pass-through test class for streams. Check to make sure output for
+    selected data direction(s) is non-zero and that zero data appears for other
+    directions. Check that Stream IDs are accessed in random order.
+    """
+
+    def check_streams(self, dut, stream_ids):
+        """
+        The number of IOs is less than the number of stream IDs provided. Let N
+        be the number of IOs. Confirm that the stream IDs on the device are not
+        the first N stream IDs.
+
+        This will produce false positives because it is possible for the first
+        N stream IDs to be randomly selected. We can reduce the probability of
+        false positives by increasing N and increasing the number of streams
+        IDs to choose from, although fio has a max of 16 placement IDs.
+        """
+
+        id_list = get_device_stream_ids(dut)
+        if not id_list:
+            return False
+
+        num_streams = int(self.fio_opts['io_size'] / self.fio_opts['bs'])
+        stream_ids = sorted(stream_ids)[0:num_streams]
+
+        return not super().check_streams(dut, stream_ids)
+
+
+def get_device_stream_ids(dut):
+    cmd = f"sudo nvme dir-receive -D 1 -O 2 -H {dut}"
+    logging.debug("check streams command: %s", cmd)
+    cmd = cmd.split(' ')
+    cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                encoding=locale.getpreferredencoding())
+
+    logging.debug(cmd_result.stdout)
+
+    if cmd_result.returncode != 0:
+        logging.error("Error obtaining device %s stream IDs: %s", dut, cmd_result.stderr)
+        return False
+
+    id_list = []
+    for line in cmd_result.stdout.split('\n'):
+        if not 'Stream Identifier' in line:
+            continue
+        tokens = line.split(':')
+        id_list.append(int(tokens[1]))
+
+    return id_list
+
+
+def release_stream(dut, stream_id):
+    """
+    Release stream on given device with selected ID.
+    """
+    cmd = f"nvme dir-send -D 1 -O 1 -S {stream_id} {dut}"
+    logging.debug("release stream command: %s", cmd)
+    cmd = cmd.split(' ')
+    cmd_result = subprocess.run(cmd, capture_output=True, check=False,
+                                encoding=locale.getpreferredencoding())
+
+    if cmd_result.returncode != 0:
+        logging.error("Error releasing %s stream %d", dut, stream_id)
+        return False
+
+    return True
+
+
+def release_all_streams(dut):
+    """
+    Release all streams on specified device.
+    """
+
+    id_list = get_device_stream_ids(dut)
+    if not id_list:
+        return False
+
+    for stream in id_list:
+        if not release_stream(dut, stream):
+            return False
+
+    return True
+
+
+TEST_LIST = [
+    # 4k block size
+    # {seq write, rand write} x {single stream, four streams}
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "8",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "3",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "1,2,3,4",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 4096,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "5,6,7,8",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    # 256KiB block size
+    # {seq write, rand write} x {single stream, four streams}
+    {
+        "test_id": 10,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 256*1024,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "88",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 11,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 256*1024,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "20",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 12,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 256*1024,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "16,32,64,128",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    {
+        "test_id": 13,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "bs": 256*1024,
+            "io_size": 256*1024*1024,
+            "verify": "crc32c",
+            "plids": "10,20,40,82",
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTest,
+    },
+    # Test placement ID selection patterns
+    # default is round robin
+    {
+        "test_id": 20,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": '88,99,100,123,124,125,126,127,128,129,130,131,132,133,134,135',
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTestRR,
+    },
+    {
+        "test_id": 21,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": '12,88,99,100,123,124,125,126,127,128,129,130,131,132,133,11',
+            "dataplacement": "streams",
+            "output-format": "json",
+            },
+        "test_class": StreamsTestRR,
+    },
+    # explicitly select round robin
+    {
+        "test_id": 22,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": '22,88,99,100,123,124,125,126,127,128,129,130,131,132,133,134',
+            "dataplacement": "streams",
+            "output-format": "json",
+            "plid_select": "roundrobin",
+            },
+        "test_class": StreamsTestRR,
+    },
+    # explicitly select random
+    {
+        "test_id": 23,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16',
+            "dataplacement": "streams",
+            "output-format": "json",
+            "plid_select": "random",
+            },
+        "test_class": StreamsTestRand,
+    },
+    # Error case with placement ID > 0xFFFF
+    {
+        "test_id": 30,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "plids": "1,2,3,0x10000",
+            "dataplacement": "streams",
+            "output-format": "normal",
+            "plid_select": "random",
+            },
+        "test_class": StreamsTestRand,
+        "success": SUCCESS_NONZERO,
+    },
+    # Error case with no stream IDs provided
+    {
+        "test_id": 31,
+        "fio_opts": {
+            "rw": 'write',
+            "bs": 4096,
+            "io_size": 8192,
+            "dataplacement": "streams",
+            "output-format": "normal",
+            },
+        "test_class": StreamsTestRand,
+        "success": SUCCESS_NONZERO,
+    },
+
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
+        f"nvmept-streams-test-{time.strftime('%Y%m%d-%H%M%S')}"
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
+    release_all_streams(args.dut)
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'nvmept-streams',
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

