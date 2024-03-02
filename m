Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EC210953
	for <fio@vger.kernel.org>; Sat,  2 Mar 2024 08:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709368626; cv=none; b=lQveIGEosRKlQB1hXst5H4jW7zzfsqfC7xNL3Djd8LJj1JL7EYN940U/FxrucIz/eAZ+lFZHq6tuQ3TFkTS3vOXIXGErjpA7FGjzpLLotfUY60/VPdvuyVr37UOV5H3mRltlrKy6y8KzqZiJe5VIZrzb0zoF4FgecmVAgSikdX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709368626; c=relaxed/simple;
	bh=DXpnxbAmOHvD4+sYK5pf6bqpyd6F/h4O/uopcblPHxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibtg7EJlHV1IDXCSzUDcwZF+goJYweCMSxgWCE6oSgrOoeEPsat6Eitm3lXTFjXJoH5sbotjoASBo9zOQn30AhLoI2ZYaE0+LX3N+i7ATwXwyB8oVr3HubhqlZoBG+7702NTeBICGC/F15KVDA+XWfmWpR6IArydqseLZRL8bTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oxKL0WGw; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oxKL0WGw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709368625; x=1740904625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DXpnxbAmOHvD4+sYK5pf6bqpyd6F/h4O/uopcblPHxE=;
  b=oxKL0WGwZMLuVkKCTXxrpY+aL+eUM+1fL5Nx+nrSM/kfJnn+gitHFdqJ
   ajFYvQJBACmZrN2N7EMOvmWMxTIi1ZLgXREiahDDFE0wlnCR7YBsTlPpR
   osHPZla/HcBQn+i8HBtjpvnWVwxQmHUh5ke9qbCsBpV0ovocx6EfY5ZhH
   3h0lfc/yEik9y2rumgmJdV3r7Vb81vZ8R5j/YfWzHzpXxtKjVKYU990W6
   Rryb3d0s+h85GdW+ZxaCffxZvTSGXDiuZY4Hh8OUa3hIWVvKZ1i/fjyKU
   Dxkv78GNpNnAQLr9vX4aCvWVafRhhQSYIFQGT2Pks+OPNOD5rNTqkaL6n
   A==;
X-CSE-ConnectionGUID: 8Zd4AyrQSBa+0K8cOt8n+Q==
X-CSE-MsgGUID: NinatK1rSjCrGtrgpVfZzw==
X-IronPort-AV: E=Sophos;i="6.06,199,1705334400"; 
   d="scan'208";a="10496861"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2024 16:37:05 +0800
IronPort-SDR: ++qLTIKXSBNIqeaLWMWJMdR5+uG0STpcw0oLi5MYQMbzILKB0TeR9DnzKC+p1D51OAtunIDDP6
 XgWnkE9hzjTg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2024 23:40:38 -0800
IronPort-SDR: XReRenPc0P2MiWK3Wdhmu1xpZzRGZ6zn8JSF+Z8EYkBxkYXpFpsE2s/WXcXBTLtWVjlSdPh+ki
 4k+1EgmKGKnQ==
WDCIronportException: Internal
Received: from 87h6l33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.8])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2024 00:37:02 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 5/6] t/jobs: Fix a typo in jobs 23 & 24
Date: Sat,  2 Mar 2024 10:36:12 +0200
Message-ID: <20240302083613.602-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240302083613.602-1-avri.altman@wdc.com>
References: <20240302083613.602-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

s/bsrange/bssplit

Fixes: commit c37183f8a161 (test: test job for randtrimwrite)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/t0023.fio | 4 ++--
 t/jobs/t0024.fio | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/t/jobs/t0023.fio b/t/jobs/t0023.fio
index 4f0bef89..b051fef2 100644
--- a/t/jobs/t0023.fio
+++ b/t/jobs/t0023.fio
@@ -33,7 +33,7 @@ bsrange=512-4k
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:/4k
 
 # Expected result: 	trim issued to random offset followed by write to same offset
 # 			block sizes match
@@ -59,5 +59,5 @@ norandommap=1
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit_no_rm]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
 norandommap=1
diff --git a/t/jobs/t0024.fio b/t/jobs/t0024.fio
index 393a2b70..2b3dc94c 100644
--- a/t/jobs/t0024.fio
+++ b/t/jobs/t0024.fio
@@ -33,4 +33,4 @@ bsrange=512-4k
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
-- 
2.42.0

