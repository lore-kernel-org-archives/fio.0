Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA191B958
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913215; cv=none; b=VmrBVX969jqYsfpT1mb2Ps5QJBiX/Nm6oan9T2yVZXD2Z4+Yvawkf0Chgn32GPCe9uhk2+IMLhGxn6EyAHLt+hqXYyyJe6J/aLfzHVCloSHgvSTeACKHu6GEttkTk4wB/DHdrGFgTQvhVQYAOAyKP5/DLbGkPjHXEpnp60PYq8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913215; c=relaxed/simple;
	bh=mrPUbysyDD3WB99xqhDX/kTAKN0z9QnK/vLY7XFpFHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dpo7TIYl48NIU2x2Nn8mlXl2Ah5z6Tzvpfoge/SIS9IXcca6hXPKg8fuYtHEQ05VgjHqDoTuxApQmW9C9a2uwH2gV591YfrwtSHNaV15eIRbzFH6Nh8uf4XWBNUyMxLAZo69qamKKNJadEopHSWJAfSi0P5rSTqd2wxHCsKsmZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qjG/09Y2; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qjG/09Y2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707913213; x=1739449213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mrPUbysyDD3WB99xqhDX/kTAKN0z9QnK/vLY7XFpFHQ=;
  b=qjG/09Y2656oypruZ2OGGr1wOhaFah08Xwd7unKVv6qzbS7rdn1PnIPa
   x60TkegUp+J0Laszg77UYkqm86j2CKk3OndTDNHUtZWIj1+kIgc6BPIea
   jxXo3/Y1b0/89Fsq/rEX+Bq0RlP8o/wFJ8idXFKWxt7t6TOSHnqVf8/QL
   U21W9Yt7rasWOnxcoM1I/of+8j3hkRJKVQTFW6v3IVGunRgL8ef0yX6d+
   zoraJqBeLBywcsAfqNT/W7EmVuJPmH8tLcTXs5gMhC6T1wfOclMp0mMjb
   4+NHiHrFWFaMmUOZ6qlIyVRxXOurbinn/IHGtcQjA+6GptRMcdnKF70Zg
   A==;
X-CSE-ConnectionGUID: ZGSQRw4WSwqcbRILPei/qw==
X-CSE-MsgGUID: g5hz+OmcTKW4n41Xo4QRsQ==
X-IronPort-AV: E=Sophos;i="6.06,159,1705334400"; 
   d="scan'208";a="9479626"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2024 20:20:13 +0800
IronPort-SDR: qYbJeIiIxX0C7k2yz41dTO51ZbEUcTTmhaDtVQkYqKpf4r9gSB4Lgz3OMtWklWchQNrQ11aYQB
 /c8+ULqpfXyw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2024 03:29:49 -0800
IronPort-SDR: bv0oDClmVltgTZiRdjNAFcKwC4UN4qq2c40WJexy0BEcePKd78+CYTN2FfTpXFGTgOXd8M5AXK
 +RuW3GY5TL9g==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Feb 2024 04:20:11 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] test: add the test for loops option and read-verify workloads
Date: Wed, 14 Feb 2024 21:20:08 +0900
Message-ID: <20240214122008.4123286-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240214122008.4123286-1-shinichiro.kawasaki@wdc.com>
References: <20240214122008.4123286-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add t/jobs/t0029.fio to test that the loops option works together with
read-verify workloads.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/jobs/t0029.fio   | 14 ++++++++++++++
 t/run-fio-tests.py | 21 +++++++++++++++++++++
 2 files changed, 35 insertions(+)
 create mode 100644 t/jobs/t0029.fio

diff --git a/t/jobs/t0029.fio b/t/jobs/t0029.fio
new file mode 100644
index 00000000..481de6f3
--- /dev/null
+++ b/t/jobs/t0029.fio
@@ -0,0 +1,14 @@
+[global]
+filename=t0029file
+size=4k
+verify=md5
+
+[write]
+rw=write
+do_verify=0
+
+[read]
+stonewall=1
+rw=read
+loops=2
+do_verify=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 1448f7cb..2f76d3fc 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -542,6 +542,17 @@ class FioJobFileTest_t0027(FioJobFileTest):
         if data != self.pattern:
             self.passed = False
 
+class FioJobFileTest_t0029(FioJobFileTest):
+    """Test loops option works with read-verify workload."""
+    def check_result(self):
+        super().check_result()
+
+        if not self.passed:
+            return
+
+        if self.json_data['jobs'][1]['read']['io_kbytes'] != 8:
+            self.passed = False
+
 class FioJobFileTest_iops_rate(FioJobFileTest):
     """Test consists of fio test job t0011
     Confirm that job0 iops == 1000
@@ -838,6 +849,16 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          29,
+        'test_class':       FioJobFileTest_t0029,
+        'job':              't0029.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.43.0

