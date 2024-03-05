Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874AC4F211
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 09:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629229; cv=none; b=KP36EMIYL1PsNFPnat/2XbohGu588QKBZrCECEiOGomSLQ639gO2Ow9l7F+0TzeQa4Ho0e284KQCyRmmIeFOius9TJonQDD5j5NXQE1jwxv1EYZb8B1Tbgpiz/YNsxUlgTb7KvAsaLz/jyw2Kop/WTd6FdJ0+h+ENF5LdVZ0ODM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629229; c=relaxed/simple;
	bh=ITMU1/D8ZLV2EYNldAPaz4yz+cbb2ck1anTUnrl2yy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAnPVTnmxOncYIyBySYPW26TzHwHNMJ0tMSz7fNCtAdhICTqRjm1uvyiw4+gvngpMkMADBM3MebMCwGCdoZbjeIxYq9NzEZAf6MTxc6cIohabMdGswy5YPiK9oDGCynFi8JVi5umd4t4zvjhoPI/1pMllagKoRihbjYz9mWLqLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cL2Ce3I9; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cL2Ce3I9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709629228; x=1741165228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ITMU1/D8ZLV2EYNldAPaz4yz+cbb2ck1anTUnrl2yy0=;
  b=cL2Ce3I99UnFEhokV9J55JtyvnQgr6Os2mi1vrvh4EeE/W2t1fDc6Zk0
   TdDwI1B/OrN88UGw0FGOIwk0YPQV9L5zP8JSAbFXtpfDiRN2oZGX6mcVP
   ne+BNjkR7qBtKYjZAvcsiuFf5LyesWrmoSdKM1pxSN65V6M4caNun7Cia
   sw4QX2UPJBk3D/BQp4uwTFJSsAdPqDAKot1xhjzFDurxBdu0+EU/Me3Gr
   lfFnTrCQNAjqhTFpGBB03apkC96IzXzBovF2mitjM5+V6yhVQ7UR7E7JU
   32WpU9RoZ2Q1OIIE5W+VkawONCXnwSqeXN5PUxBzSuhiUGiSFk5GI41nX
   w==;
X-CSE-ConnectionGUID: KjSbZXDHTNWSasOED1m17A==
X-CSE-MsgGUID: X/nGnbX2QtacgmFEMku74w==
X-IronPort-AV: E=Sophos;i="6.06,205,1705334400"; 
   d="scan'208";a="10678205"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2024 17:00:28 +0800
IronPort-SDR: GfNbTArDYsdXhcSO+WHeJfJ/ENQL/hFO6wv4q1tf7Iufj8U+tTOAeelB1Vd6KzHPFgJ5kvQdEw
 GYXUghXjRPWQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2024 00:09:39 -0800
IronPort-SDR: hRYvRMVz++mF3ILO7zSq1itlFdHnp4YMII+s/cOznstCOMtzEicQc6pqVJYlQ+SZ3Id49bZD3Q
 A5Nf9nI/+5Ew==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2024 01:00:27 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 3/5] t/jobs: Rename test job 15
Date: Tue,  5 Mar 2024 11:00:06 +0200
Message-ID: <20240305090008.1216-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240305090008.1216-1-avri.altman@wdc.com>
References: <20240305090008.1216-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it designate the correct fixing commit.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} | 0
 t/run-fio-tests.py                                | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} (100%)

diff --git a/t/jobs/t0015-e78980ff.fio b/t/jobs/t0015-4e7e7898.fio
similarity index 100%
rename from t/jobs/t0015-e78980ff.fio
rename to t/jobs/t0015-4e7e7898.fio
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index d4742e96..08134e50 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -722,7 +722,7 @@ TEST_LIST = [
     {
         'test_id':          15,
         'test_class':       FioJobFileTest_t0015,
-        'job':              't0015-e78980ff.fio',
+        'job':              't0015-4e7e7898.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
         'pre_success':      None,
-- 
2.42.0

