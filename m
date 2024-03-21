Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E396579C2
	for <fio@vger.kernel.org>; Thu, 21 Mar 2024 03:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710990627; cv=none; b=N+36aZs1s6waNMfg2njfTXPBE0PX1wngm65oaadMJCjB6RDFbkIDjcul84kVTnFW4UM/wvTDPtArHooAv/MeIS1PBAIuPqi1w5qE5LTS94Jxj7fKPoCmhpML57fwbgJWDqeRg7+CN4rAr3uKha5TcNuGPHeQuUVVPxZHQDs6oY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710990627; c=relaxed/simple;
	bh=Bbafph+lLtIF7MzGv4ACZcHBQP/gU5GO3K0FwjqyJmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpKMAJqyb/52vETJKwPFZ24FKWP+RaJdHS3nEdmyK7lkDnfBbOZgv47Ii9KOS0wIV9JUjfFu5oYgLPqyYpdZp+6F5QfHyBjnvdQR7MVCQeym4ALSKVh1Ouu3EFEbiUr0WlINUJ8Stk5kvXMyvgYhNJUD0xVcXSR87PjaaszNa7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mrtOvnTa; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mrtOvnTa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1710990622; x=1742526622;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bbafph+lLtIF7MzGv4ACZcHBQP/gU5GO3K0FwjqyJmY=;
  b=mrtOvnTaXOblxH+9pELqq6IFf8M80rivI4J/9LtLhluySEFctIPyN9lA
   5tmmrnQc3rv5bajzteVfyILCjTkCppATbZrntd2vvE9RHuSPxntc25VcE
   PzGpWsC82py/x72KrKyO7aUWyLs6Mnrg4gXAa+9UvDnzq1Rg2tDAMaM+7
   w6dL5L+soIa6rMBmGA4h6dxe/gXeti6mTqSeezAccqIwet569ZYq0y847
   sW3E5lbpK9IYOBqs7dV88PaokrDY6q8diGxDuyg2Cij1cADcLlRYIqPEH
   bbabu2IFvT0DUhCJXRjJC4Mh5sm8OU/1q+ZdTV+yC28RBhx1HXkwdTaQb
   A==;
X-CSE-ConnectionGUID: 2Q9rPluETO6WzLJh8VrQEQ==
X-CSE-MsgGUID: BX9oc+bqQvq2vIj5W/UXQg==
X-IronPort-AV: E=Sophos;i="6.07,141,1708358400"; 
   d="scan'208";a="12730330"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Mar 2024 11:10:15 +0800
IronPort-SDR: 7L863OuUs/Ryyxo0Pe6xlJMGvD+ZJg5+yVhaAX+qZmi1XxUBvGLK4G+wGsUVoDKuIZY5ztgf6T
 m2aBzDkzbxVA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Mar 2024 19:19:07 -0700
IronPort-SDR: z37Q8YcEXkX+WxcJNl+XLUlwMJ1fr0RTUtasgJhS3tpQNfKkoTVsFreBty78NMu5tcbPOI0BO8
 lX9ebTnjsYuA==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Mar 2024 20:10:15 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Kookoo Gu <Zhimin.Gu@solidigm.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] test: add the test for regrow logs with asynchronous I/O replay
Date: Thu, 21 Mar 2024 12:10:11 +0900
Message-ID: <20240321031011.4140040-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240321031011.4140040-1-shinichiro.kawasaki@wdc.com>
References: <20240321031011.4140040-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add t/jobs/t0031-pre.fio and t/jobs/t0031.fio to test that the log
space is regrown for the asynchronous I/O replay jobs. This test case
confirms the fix by the previous commit titled "iolog: regrow logs in
iolog_delay()".

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/jobs/t0031-pre.fio | 8 ++++++++
 t/jobs/t0031.fio     | 7 +++++++
 t/run-fio-tests.py   | 9 +++++++++
 3 files changed, 24 insertions(+)
 create mode 100644 t/jobs/t0031-pre.fio
 create mode 100644 t/jobs/t0031.fio

diff --git a/t/jobs/t0031-pre.fio b/t/jobs/t0031-pre.fio
new file mode 100644
index 00000000..ce4ee3b6
--- /dev/null
+++ b/t/jobs/t0031-pre.fio
@@ -0,0 +1,8 @@
+[job]
+rw=write
+ioengine=libaio
+size=1mb
+time_based=1
+runtime=1
+filename=t0030file
+write_iolog=iolog
diff --git a/t/jobs/t0031.fio b/t/jobs/t0031.fio
new file mode 100644
index 00000000..ae8f7442
--- /dev/null
+++ b/t/jobs/t0031.fio
@@ -0,0 +1,7 @@
+[job]
+rw=read
+ioengine=libaio
+iodepth=128
+filename=t0030file
+read_iolog=iolog
+write_lat_log=lat_log
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index acdbbf88..1b884d87 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -869,6 +869,15 @@ TEST_LIST = [
         'parameters':       ['--bandwidth-log'],
         'requirements':     [],
     },
+    {
+        'test_id':          31,
+        'test_class':       FioJobFileTest,
+        'job':              't0031.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          't0031-pre.fio',
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
-- 
2.44.0

