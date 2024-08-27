Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7488155322
	for <fio@vger.kernel.org>; Tue, 27 Aug 2024 07:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742547; cv=none; b=GilE4PbYsQ6xumvNEW0vN0AWMZ/rU3WNmkKaWnrUKRXEh59CxgvaetuqfRzQF7At+o4fFUPEtWOT2JFUmAtY8rEB2lD8qpVO07HARWAmU1X0LpxalP4Ai3WL3nw/RmRghRv3Eqku4Xvkb7wAcxIhdQKAVNCmmWESWR5VnUFIv8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742547; c=relaxed/simple;
	bh=nPbgPmy+tfqzpw7ov5rQReADRFnxhQy4KikKCP158EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvhSxCEJDnDEKzP8/ryu7mdEeTEAE6rYk4AV49jfIJW/encT8SzrDiz5JyWe/rtZ7nE/NscHXNPfEwhf7ZmQQLFBULmXBDZvbheWsE5SzSO/7V7ngZiCUHbHUSOxIBDwGaX5qw3tBubG5XOUM3aT2ErNMqkqWOZmPv4uoDQZV+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NbSl4MPu; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NbSl4MPu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724742545; x=1756278545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nPbgPmy+tfqzpw7ov5rQReADRFnxhQy4KikKCP158EQ=;
  b=NbSl4MPuGPe7gQd019nkL/zkDl0G6szyMf5d09g+HJJnWnwxv3RqV7nA
   80+Fa1bONsrvV8D5Ct7WxYetiH2Hhi6uFpkziOfohBkv0OYzWegVztUIM
   jxi4ylOL1UKf8LvI3lNIzMJ3rpHzC8hcfQPOtvWJzLcTv/yT640eNmRv9
   tSFtvQZpJvuBTq/oGQxMwNpexPMt/kRauAbPB3kepqgdxUm4giU7we+H5
   +w5RwFOYbv3UHWOjkrVHxbbpasM/eAt0i5WdsP8YURx6JsADOtC5fpvei
   Svj9xYLm8LwZVWexLHj7pkSKx4ugs8V3FpBui9u/h+ydKrRjHkx7I2cOT
   g==;
X-CSE-ConnectionGUID: SUX/sSZKRBq5S3EP/xsYkw==
X-CSE-MsgGUID: d4gkm6fLReyV4ZanTm2KOQ==
X-IronPort-AV: E=Sophos;i="6.10,179,1719849600"; 
   d="scan'208";a="25297881"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2024 15:09:01 +0800
IronPort-SDR: 66cd6ecf_4sFwwiVruBGYeHUgYE2NG0GGJQTVZbfKyfcRs7WjknJb29O
 LltR81ie/jgvjOpH4pKjNLCHEvWVxOS2maVspfg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2024 23:14:39 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2024 00:09:00 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 9/9] t/jobs/t0034: add test for the log_issue_time option
Date: Tue, 27 Aug 2024 16:08:50 +0900
Message-ID: <20240827070850.947037-10-shinichiro.kawasaki@wdc.com>
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
index 00000000..ca71b775
--- /dev/null
+++ b/t/jobs/t0034.fio
@@ -0,0 +1,27 @@
+[global]
+rw=read
+filename=t0034file
+size=8k
+time_based
+runtime=100ms
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
+log_avg_msec=20
+log_window_value=both
+
+[job3]
+write_lat_log=log
+write_bw_log=log
+write_iops_log=log
+log_offset=1
+log_issue_time=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 8bc343cd..525f78ff 100755
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
         'requirements':     [],
     },
+    {
+        'test_id':          34,
+        'test_class':       FioJobFileTest_t0034,
+        'job':              't0034.fio',
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

