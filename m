Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16AA18A921
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724921919; cv=none; b=sB/oUcO2LhkM7RF3xKzVK7aa0T5r5ixbkpDvFpRVkqxz8BxRd1vhUPhewmWl7CVl2d3vHuaSpLIbQD7iY+wgQjq+3WT/Uo5pqS6Emvfjw+I/ZG5gITemKaa9xVjWh6+TENijXhpOwBTP5AIhx2UbGS8Dpt6L6Y2HgfByc1t9Es8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724921919; c=relaxed/simple;
	bh=xn4BoE93l4hfbLWd3PRafNinOhr+R0AzVfvhhVPhD1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rypoylAr54fzpnc8qiexL0zT1+pkyGug+4NZOqOnTFDSG//wywAQhAtj50h5q8/cFesFGBoZEoc7AKSLJNC18VAZkiX8xuXQRK6/KlRurIlfzyU4slZRngXCaLGNm3GUotuIZLNoUILG0fUnHMmhGSJgb7/G4kJW7GnpmBvB53A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cjADoalG; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cjADoalG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724921918; x=1756457918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xn4BoE93l4hfbLWd3PRafNinOhr+R0AzVfvhhVPhD1w=;
  b=cjADoalG15ynclSrkeYYclm9CU7hU8ZDGAuBuLXMBvhQfeOLne3wASYR
   P1zt62ZiwQa421qngkNuiOEFuTB2OvOy2AmmlvS2cwGSYIlTn+vIVqh4r
   0qXZJOxjdowYMbcvSNtaMNE3rUF9rFz92V7Hg6HIyAk5vUmTG29pkk9+n
   06f0+NkMJrW05JsKUC6bIc/tGMyS33W0/apOb/QBDMmsHRGd5Sw1myGHb
   56392opC9mBuaNlS5rFDV8Gm0IG0mBv+CwHIgAGg5clhLAr7PoC/nHRLR
   TVgl+C7P9daDDDZ2kEuh0Irx8uV9Q+/Ntf1NvyRyq7xpsnAfVf50xB4wN
   w==;
X-CSE-ConnectionGUID: NLXsN+QoTrG/nlFhC+40iA==
X-CSE-MsgGUID: XX/tNy4fQKeP9yslvs0nHA==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="24854845"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:58:37 +0800
IronPort-SDR: 66d02a28_qq0fTUQKpReN7fDdLVAgmuIDKpR2bdJhwQf16BJomZrklE/
 zIbAkrrYXsmPj2HGc8WUL41xZE7bf+0cMDA3Brg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Aug 2024 00:58:32 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Aug 2024 01:58:36 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Nick Neumann <nick@pcpartpicker.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 8/9] t/jobs/t0033: add test for the log file format
Date: Thu, 29 Aug 2024 17:58:25 +0900
Message-ID: <20240829085826.999859-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
References: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
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
index 00000000..156bdadc
--- /dev/null
+++ b/t/jobs/t0033.fio
@@ -0,0 +1,28 @@
+[global]
+rw=read
+filename=t0033file
+size=8k
+time_based
+runtime=2s
+ioengine=libaio
+iodepth=1
+
+[job1]
+write_bw_log=log
+log_prio=1
+
+[job2]
+write_lat_log=log
+log_avg_msec=100
+log_window_value=both
+
+[job3]
+write_iops_log=log
+log_offset=1
+log_prio=1
+
+[job4]
+write_iops_log=log
+log_avg_msec=100
+log_window_value=both
+log_offset=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 22580613..dfd5eac9 100755
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
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.45.2

