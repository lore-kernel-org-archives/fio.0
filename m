Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FBE18C900
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724921920; cv=none; b=Ijt3FsFqhRDs9WCheMCrV/DEKtZ21kFfi9YTYq6g3U30xvIv2qRRkIr+ge7R+5YqfphZtzVkDsVg6Zd6IQfvXV0kWE6FSoNb9gyqC+Pb9pFFQz48ElpLo07+29QMqAoVdjlpZmwwG0wE12ZKRIZ1dn2gfIn07NGjGpN5/ojNbHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724921920; c=relaxed/simple;
	bh=JMeuFGI4QkxhtXfEgCMUd3N1d839cV/ZvYXSTpfuMu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqAglCXDnSBY1L1fC8h87A51WJKvgsZHDl9FPtF7St5VLZQxbAvzpTKOvo87rdulEB34q+88CaNtD25tPSM2EWdQ3rqDwWj8X4F9fATXQEsgy2+evZPqgVIdkWt/EtDSgUUiaFDY/u0rqpRovf2ulsfo2qs2KDKUWnVLUCl4KJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WZ1qg3rY; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WZ1qg3rY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724921919; x=1756457919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JMeuFGI4QkxhtXfEgCMUd3N1d839cV/ZvYXSTpfuMu0=;
  b=WZ1qg3rY8wexuHV8MSk6CqTON/eVV07LwwwqhC+QRJnzD/eJIki6TxhN
   o3UUTXXPOND1NNvv+z9o8smTph1YLtmB7i5WVwFJCUNGxNhA4nR3zdC3Q
   kXkuHYd8anZ3gYCqtPPnPk0+KnFOEt2f7BnNoiHQu1YzjHnnwsr11tjOi
   ny7zi/uwnqbloYQLJHPRhhAerEoyNnfSEo5UQwU9ulcTYzkQ0sxNQZIuT
   X0xYl7ABR/T34AUjs2OqI5Pl1tKrezg4lC2Rp8GM4ovWhRmb1nJ21H7OV
   8MxVDUfudWbMnSrqNa3HUErzzytYhgcG2SZvZp7IlicAAj1ooIM0Ig0sW
   g==;
X-CSE-ConnectionGUID: +vV0YJDmTJKI9cx5poRyBg==
X-CSE-MsgGUID: uUnadtL2QYGTUKXFL5M0XQ==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="24854850"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:58:38 +0800
IronPort-SDR: 66d02a29_XA/J0lsySvR/6Xu9E06Yq7XCUwwByMkP9YRCe5DMkBr77sq
 aSBjNraxf0eJyERZKPALb57N+u5ZlDd0/lYozcg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Aug 2024 00:58:33 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Aug 2024 01:58:37 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Nick Neumann <nick@pcpartpicker.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 9/9] t/jobs/t0034: add test for the log_issue_time option
Date: Thu, 29 Aug 2024 17:58:26 +0900
Message-ID: <20240829085826.999859-10-shinichiro.kawasaki@wdc.com>
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

Add a test to check the newly added option 'log_issue_time'. Generate
log files using the option and check that lines in the log files have
the format described in the "Log File Format" section in HOWTO.rst.

This test case has the logic same as t0033 except the log file names and
matching patterns. Factor out the logic to the new class
FioJobFileTest_LogFileFormat.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/jobs/t0034.fio   | 27 ++++++++++++++++++++++++
 t/run-fio-tests.py | 51 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 68 insertions(+), 10 deletions(-)
 create mode 100644 t/jobs/t0034.fio

diff --git a/t/jobs/t0034.fio b/t/jobs/t0034.fio
new file mode 100644
index 00000000..2b6c4b2d
--- /dev/null
+++ b/t/jobs/t0034.fio
@@ -0,0 +1,27 @@
+[global]
+rw=read
+filename=t0034file
+size=8k
+time_based
+runtime=2s
+ioengine=libaio
+iodepth=1
+
+[job1]
+write_lat_log=log
+log_offset=1
+log_issue_time=1
+
+[job2]
+write_lat_log=log
+log_offset=1
+log_issue_time=1
+log_avg_msec=100
+log_window_value=both
+
+[job3]
+write_lat_log=log
+write_bw_log=log
+write_iops_log=log
+log_offset=1
+log_issue_time=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index dfd5eac9..47482144 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -554,29 +554,50 @@ class FioJobFileTest_t0029(FioJobFileTest):
         if self.json_data['jobs'][1]['read']['io_kbytes'] != 8:
             self.passed = False
 
-class FioJobFileTest_t0033(FioJobFileTest):
+class FioJobFileTest_LogFileFormat(FioJobFileTest):
     """Test log file format"""
+    def setup(self, *args, **kws):
+        super().setup(*args, **kws)
+        self.patterns = {}
+
     def check_result(self):
         super().check_result()
 
         if not self.passed:
             return
 
-        patterns = {
+        for logfile in self.patterns.keys():
+            file_path = os.path.join(self.paths['test_dir'], logfile)
+            with open(file_path, "r") as f:
+                line = f.readline()
+                if not re.match(self.patterns[logfile], line):
+                    self.passed = False
+                    self.failure_reason = "wrong log file format: " + logfile
+                    return
+
+class FioJobFileTest_t0033(FioJobFileTest_LogFileFormat):
+    """Test log file format"""
+    def setup(self, *args, **kws):
+        super().setup(*args, **kws)
+        self.patterns = {
             'log_bw.1.log': '\\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
             'log_clat.2.log': '\\d+, \\d+, \\d+, \\d+, 0, \\d+\\n',
             'log_iops.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, 0x[\\da-f]+\\n',
             'log_iops.4.log': '\\d+, \\d+, \\d+, \\d+, 0, 0, \\d+\\n',
         }
 
-        for logfile in patterns.keys():
-            file_path = os.path.join(self.paths['test_dir'], logfile)
-            with open(file_path, "r") as f:
-                line = f.readline()
-                if not re.match(patterns[logfile], line):
-                    self.passed = False
-                    self.failure_reason = "wrong log file format: " + logfile
-                    return
+class FioJobFileTest_t0034(FioJobFileTest_LogFileFormat):
+    """Test log file format"""
+    def setup(self, *args, **kws):
+        super().setup(*args, **kws)
+        self.patterns = {
+            'log_clat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, \\d+\\n',
+            'log_slat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, \\d+\\n',
+            'log_lat.1.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
+            'log_clat.2.log': '\\d+, \\d+, \\d+, \\d+, 0, 0, \\d+, 0\\n',
+            'log_bw.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
+            'log_iops.3.log': '\\d+, \\d+, \\d+, \\d+, \\d+, \\d+, 0\\n',
+        }
 
 class FioJobFileTest_iops_rate(FioJobFileTest):
     """Test consists of fio test job t0011
@@ -913,6 +934,16 @@ TEST_LIST = [
         'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
+    {
+        'test_id':          34,
+        'test_class':       FioJobFileTest_t0034,
+        'job':              't0034.fio',
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

