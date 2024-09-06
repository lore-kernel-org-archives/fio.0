Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE0127450
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 02:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725590250; cv=none; b=BTHPZrIOFBLS6lqooZ1RLPZ8gLXgzSObIxi0n59Do8WCtjSFe4lg/Fa/ra4+eGpW4n1O0d/zxaLS8KrQtQQsAznOnxh2Pt6yQmVugckRRQxMkfhmatSfG53Ttp/NqfT/+YFbQzsjlciAXQrhNCEjSehkJlF+mdcXtE6mLEiXXuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725590250; c=relaxed/simple;
	bh=ft/WGU5w4g7S9yNkdLq/ymRrG78mWf7GIsyZp1C8FrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2aceTUZ5yx04bd5zHUGkR0ofMA4qd6Lpr3xnNhAFkJHMHsNPAWyMEHjNTegTFP4aw0kpzmccZ2+gRAeQ7nOpVKX529KrsVAoEzU0VeVnUMJc7ZaIF1lwT5s3xq2e8waNPFEzCgZe47+W9rEn36SL4myvXS8XeT5WJ/q4L2U9Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Bz27l7sc; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Bz27l7sc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1725590248; x=1757126248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ft/WGU5w4g7S9yNkdLq/ymRrG78mWf7GIsyZp1C8FrU=;
  b=Bz27l7scpUe3el+4x1PSBEzg8tkgqY/VZOTSLgXzz2ZsUIWbAUptUgii
   zqKMjEjg6x7myUPUo1gHpCbx6dZrVP17w39ZVCxlXn1gzDXD/mzJisU1W
   upvXcbAd1l1eF/cjUXJ4vX2G1H/M1eMKN+kvabmHRSFqYwPQwJYRThgwN
   nKwPygC+dNoZPB+6nUTKrXDnmXFVA6M+eAE4GfBMiuTzmnAYpDeGMSyNT
   TKBTf6qDv/7JfajMZhIeeNto9zqzzFUg0EYDGk85rcRKTeqwuGXUUS4db
   mVaTcYkbBorF/glXDcGOzQIbB1/vVOn4wIvEPuYbUGH1CjnazBPPJosv+
   Q==;
X-CSE-ConnectionGUID: lLH1tvZXRQuB9DJMauV2oQ==
X-CSE-MsgGUID: CyD2i6soTLG61mQ1nhgXWQ==
X-IronPort-AV: E=Sophos;i="6.10,206,1719849600"; 
   d="scan'208";a="26440246"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2024 10:37:21 +0800
IronPort-SDR: 66da5cc2_VxsFrdcViqS3fKJqff6zsVM8rz5BlrjUc9tATUVlnwJp2P3
 i+C8YBPtyBazwxZbr5SPUVfR8C2ne8w9EVh/AQg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2024 18:37:07 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2024 19:37:21 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] t/jobs/t0035: add test for the file operations IO engine
Date: Fri,  6 Sep 2024 11:37:17 +0900
Message-ID: <20240906023717.1464031-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240906023717.1464031-1-shinichiro.kawasaki@wdc.com>
References: <20240906023717.1464031-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous commit fixed the NULL pointer dereference which happened
when the write_lat_log option is specified for the file operations IO
engine. Add a new test case to confirm the fix. This test case also
covers the basic use cases of the file operations IO engine.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/jobs/t0035.fio   | 27 +++++++++++++++++++++++++++
 t/run-fio-tests.py | 10 ++++++++++
 2 files changed, 37 insertions(+)
 create mode 100644 t/jobs/t0035.fio

diff --git a/t/jobs/t0035.fio b/t/jobs/t0035.fio
new file mode 100644
index 00000000..fd3488f9
--- /dev/null
+++ b/t/jobs/t0035.fio
@@ -0,0 +1,27 @@
+[global]
+size=4k
+write_lat_log=log
+
+[job1]
+ioengine=filecreate
+filename=t0035file1
+
+[job2]
+ioengine=filestat
+filename=t0035file2
+
+[job3]
+ioengine=filedelete
+filename=t0035file3
+
+[job4]
+ioengine=dircreate
+filename=t0035dir1
+
+[job5]
+ioengine=dirstat
+filename=t0035dir2
+
+[job6]
+ioengine=dirdelete
+filename=t0035dir3
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 47482144..d713c1c4 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -944,6 +944,16 @@ TEST_LIST = [
         'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
+    {
+        'test_id':          35,
+        'test_class':       FioJobFileTest,
+        'job':              't0035.fio',
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

