Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430391552E4
	for <fio@vger.kernel.org>; Tue, 27 Aug 2024 07:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742547; cv=none; b=apUE3X0XJiC4feTTWqq3v33/k3ZWM5gUSYRcc9cwuePdDx/ZHwx7b2GJ7MKQebFQU+kp4ZVjiCeQvIwltiszzmp4Ozd+gUwK+vkVj/VhGQWOHSy/kjzK5qbIYC8Tgw9D7fdMjX7W14MJSdeJ8mnxZr1FU3dAsRsgQqmK9o+ZB9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742547; c=relaxed/simple;
	bh=33EsBYi4w94qeVIl8azyn0ILmuGlmmHRauwqXKK9x3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdneCfNvlxz1FOj1HLn8OS3KF1uHXli65yJohulXTUgkKyOgGbg4liLpv4eUG0ami76BpNuBeqIdaU+/xqPagItNJbh2qCQ4a5X2LgXwHTd9VqHGDXlEAwfyaKYlSUiYL+neq5i/8iYgcunLUNpDc76G9pKrqyct3RlvY29nQ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JRpXbUDK; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JRpXbUDK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724742545; x=1756278545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=33EsBYi4w94qeVIl8azyn0ILmuGlmmHRauwqXKK9x3o=;
  b=JRpXbUDKcxGPcwP7OFCIXt77Wuf7oR1iOgsIzhLFj6NVb3MpY9k11A/9
   R/71TjSBIHFazTFmahP11O6k5rIkjfkkhqLdy61ryk2uGBQRxTWq2+OJb
   gFEYwbWspDk9vXeYa3ZwLNlcyCof58IuFUN7SLPQKnC4GAgQqZCbBgjjf
   +/S78a1YIvP4mE5+hNSB7QkS6+62n9bZAWzpnNsUPefeT7LOGQiwVOqlo
   1l+S5mNzJwx7y24xuCzkDs+YNFPkDz0z3EbnKNE0Z8+P1jvjt488jEIzJ
   hFjEMGqpfmchVeROizMXBq7Vl+mGbeg5WIuS65HWYA7aS+7oFG29AclCD
   Q==;
X-CSE-ConnectionGUID: hFSx0e0aTmeim/AVS6KEyQ==
X-CSE-MsgGUID: 2bR+UuqBStqLmsHnOzJJNQ==
X-IronPort-AV: E=Sophos;i="6.10,179,1719849600"; 
   d="scan'208";a="25297880"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2024 15:09:00 +0800
IronPort-SDR: 66cd6ece_v+2R5cRVc0fydkG8CiKf0znfCDPnR1wG8d3dkMT24Tzm+LF
 eFIZELNcR4vvXkdK4JHD4tDf3yyOQhFMVl3MRMg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2024 23:14:38 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2024 00:08:59 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 8/9] t/jobs/t0033: add test for the log file format
Date: Tue, 27 Aug 2024 16:08:49 +0900
Message-ID: <20240827070850.947037-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test to check the log file format which is described in the "Log
File Format" section in HOWTO.rst. Generate log files using combination
of options relevant to log files, and check that lines in log files have
the format expected. This test helps to confirm that the changes in the
log file related functions do not cause regressions.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/jobs/t0033.fio   | 28 ++++++++++++++++++++++++++++
 t/run-fio-tests.py | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 t/jobs/t0033.fio

diff --git a/t/jobs/t0033.fio b/t/jobs/t0033.fio
new file mode 100644
index 00000000..038e388f
--- /dev/null
+++ b/t/jobs/t0033.fio
@@ -0,0 +1,28 @@
+[global]
+rw=read
+filename=t0033file
+size=8k
+time_based
+runtime=100ms
+ioengine=libaio
+iodepth=1
+
+[job1]
+write_bw_log=log
+log_prio=1
+
+[job2]
+write_lat_log=log
+log_avg_msec=20
+log_window_value=both
+
+[job3]
+write_iops_log=log
+log_offset=1
+log_prio=1
+
+[job4]
+write_iops_log=log
+log_avg_msec=20
+log_window_value=both
+log_offset=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 22580613..8bc343cd 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -47,6 +47,7 @@ import time
 import shutil
 import logging
 import argparse
+import re
 from pathlib import Path
 from statsmodels.sandbox.stats.runs import runstest_1samp
 from fiotestlib import FioExeTest, FioJobFileTest, run_fio_tests
@@ -553,6 +554,30 @@ class FioJobFileTest_t0029(FioJobFileTest):
         if self.json_data['jobs'][1]['read']['io_kbytes'] != 8:
             self.passed = False
 
+class FioJobFileTest_t0033(FioJobFileTest):
+    """Test log file format"""
+    def check_result(self):
+        super().check_result()
+
+        if not self.passed:
+            return
+
+        patterns = {
+            'log_bw.1.log': '\\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
+            'log_clat.2.log': '\\d+, \\d+, \\d+, \\d+, 0, \\d+\\n',
+            'log_iops.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
+            'log_iops.4.log': '\\d+, \\d+, \\d+, \\d+, 0, 0, \\d+\\n',
+        }
+
+        for logfile in patterns.keys():
+            file_path = os.path.join(self.paths['test_dir'], logfile)
+            with open(file_path, "r") as f:
+                line = f.readline()
+                if not re.match(patterns[logfile], line):
+                    self.passed = False
+                    self.failure_reason = "wrong log file format: " + logfile
+                    return
+
 class FioJobFileTest_iops_rate(FioJobFileTest):
     """Test consists of fio test job t0011
     Confirm that job0 iops == 1000
@@ -878,6 +903,16 @@ TEST_LIST = [
         'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
+    {
+        'test_id':          33,
+        'test_class':       FioJobFileTest_t0033,
+        'job':              't0033.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.45.2

