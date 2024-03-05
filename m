Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8A150A72
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 09:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629234; cv=none; b=hv3BEyTczEn05/566M9ueXwmR/OqYoAQkDVnXa20br6+s+Xn6qVY6Tr+WnnZjcQC49Bum+lmdHakaNyJkF+Ix10cJVAy8T9ST0HKeSVIuBfN8en4MMb50J9K2tIZYpYjXlKMKzXNZ08wimaeojfzvth7fE1fs9jMl8MksImLmN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629234; c=relaxed/simple;
	bh=xY5gsfCTN0+3GjqhSxeBDvxkYn4tzs+U1PSxnu6kzkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNj2mKGccmT8zSIOvXGZHLGqkQmEi2um3tretIikQ1TYyU6NJjz65IfHgCtZa+huLkzgQS4nZ+lEGLSmACyYAerRah/HE/FryfTnqDTw25IwIvvltT1xSg+2vQrGZL77x4kbQaXZqD++ISyfhoMhWB0NOX4d8WOBWokGpnV7qjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nsRHxvVS; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nsRHxvVS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709629233; x=1741165233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xY5gsfCTN0+3GjqhSxeBDvxkYn4tzs+U1PSxnu6kzkg=;
  b=nsRHxvVSB+ZEQ1NzxlRLi5j00WXhV7bCIfGq0hYGrSjF/cl9OII1ff09
   M2F01SC9obyC5wXuzhe3kg1cCvBUCMRRoB+vRvyFx0b2mbM5NN/4EHX3U
   nNV/wK2bt7iTGNS1Z+PcYlJHe2Nrd2rd+hNj5bWf5T3IXQ4hgT/+eNppv
   8T5FbSOeKvBkH/njwUUQAiPIMWV0zMBUYISOtY0dBTTVLtF10KGdoaDlZ
   ShHH/GiavikYvssnQWA53c0yu5KvRnZUvTsMxC98zYi4Jcw6+ixo0iuBz
   zBKtSACi2i6Gx+YOVinurZ2xLLROFhE2tIPi14o1+8pRNFjML87ifAH41
   w==;
X-CSE-ConnectionGUID: hKW9U9b2S5e9f2uIRYj8xg==
X-CSE-MsgGUID: O3vZlraLSSuyXyqMluFwAA==
X-IronPort-AV: E=Sophos;i="6.06,205,1705334400"; 
   d="scan'208";a="10678210"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2024 17:00:33 +0800
IronPort-SDR: Ij5bBtyfJtWUxzPDG4qSiPzURzWLalOPA8OjeZWSzsX8liWzRZw08o1FE2b/m4u0AnS1wjxgxC
 TV+Cn896Oanw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2024 00:09:44 -0800
IronPort-SDR: vi0l6fpFz5w57EEo4AV6XY1OcHC7zHQ6FobiUqbkEXEMEVoZC9x/uNSOsor1LwR81ngZudO7AK
 LGX28utnM1cw==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2024 01:00:31 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 4/5] t/jobs: Fix a typo in jobs 23 & 24
Date: Tue,  5 Mar 2024 11:00:07 +0200
Message-ID: <20240305090008.1216-5-avri.altman@wdc.com>
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

s/bsrange/bssplit

Fixes: commit c37183f8a161 (test: test job for randtrimwrite)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/t0023.fio | 4 ++--
 t/jobs/t0024.fio | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/t/jobs/t0023.fio b/t/jobs/t0023.fio
index 4f0bef89..8e14a110 100644
--- a/t/jobs/t0023.fio
+++ b/t/jobs/t0023.fio
@@ -33,7 +33,7 @@ bsrange=512-4k
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
 
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

