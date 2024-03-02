Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9C11724
	for <fio@vger.kernel.org>; Sat,  2 Mar 2024 08:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709368614; cv=none; b=UrCZki/ZTJC4lJTJEpb02ZrolOBnMXuyZKlkM/wUYtKVVRJzXQlsRddMjIT60sPNxBhJ/ex3Pk/6VRzMMMs5C+xvhgPN5cZsK5lCtujcLZYPnSlKgQr7pyUlZlPTi+96gsTRbSG8pBn/iKWA08dz1ZuIFWe7mNAi8H/N2/fn/uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709368614; c=relaxed/simple;
	bh=wcgPg802Bug2m09ImALM4kEWNZ1pt9SJ3yEAivELcLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNeu9e1s+i9iE4yN+iSdECf3ObgqTue/YrMvdHXCSc+zTwY1wGArBOl3BY6zmDzgOMmlBdvDabSnCiVhmgno9ZNNy1fz90ukdM5F2y3zSemZNfOfAgA7jCniWIGvW+t8RdCMEAeuLIP/V1jvcSKvYxSXv4b1XCPDiJfxdR0WfxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UpcUr5+m; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UpcUr5+m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709368613; x=1740904613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wcgPg802Bug2m09ImALM4kEWNZ1pt9SJ3yEAivELcLc=;
  b=UpcUr5+msngyjmhNlSLflJqy84gFB7OVY75l8FJkwBbBAVAq5p70VoX3
   7bh5Ey0jvcxyzF0UmfOvDgQLO5KVt7BvDMT2lUNGMLnrR0Fl8UQM7/zdY
   FkCGI50PWfpfalXZ1HbFyJ+uHpwJfkUJ0X27wNFT1/3S1kSDC0eJjRiHz
   SYfQ7RVtK3iFSkCaf1jozEEEKMe3xmSQQeYVI7Vz0GGKzhbbfbxcqmhQR
   JO89UJV7KlBKXfNysZxHmeIa3Gh/JCfW+dNCN6UZi/cKyZnGfzeB3ynjC
   PVchQohShd9g2UijH1nTYpufFMXYt7udnieSPX31Wkm1p8a3jWh1Xg32u
   Q==;
X-CSE-ConnectionGUID: oXLA8UrvSk2vJHRvMzYUKg==
X-CSE-MsgGUID: WuSJXWTbRgeh/85u9LUZcQ==
X-IronPort-AV: E=Sophos;i="6.06,199,1705334400"; 
   d="scan'208";a="10496840"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2024 16:36:53 +0800
IronPort-SDR: 7w+Ix+Ba/KCRJda+9sxJ7aP5cx5/1KKdoFkrLt16gDnTjcC3Fxk4r4cRnpihAIkEeumGA4T1+B
 nTsVtrBensSQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2024 23:40:26 -0800
IronPort-SDR: zS6iC1Zts5dAdJfDYB/miPNebvcJrCHFySXpWuKEC9U2EV1t2kFnL9N/02MFiN52tFTtGEuoWI
 oaWknR5atb7g==
WDCIronportException: Internal
Received: from 87h6l33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.8])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2024 00:36:49 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/6] t/jobs: Further clarify regression test 7
Date: Sat,  2 Mar 2024 10:36:09 +0200
Message-ID: <20240302083613.602-3-avri.altman@wdc.com>
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

Add some more details explaining why the the successful result should be
87,040KB data.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/t0007-37cf9e3c.fio | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/t/jobs/t0007-37cf9e3c.fio b/t/jobs/t0007-37cf9e3c.fio
index d3c98751..a5971759 100644
--- a/t/jobs/t0007-37cf9e3c.fio
+++ b/t/jobs/t0007-37cf9e3c.fio
@@ -1,4 +1,7 @@
-# Expected result: fio reads 87040KB of data
+# Expected result: fio reads 87040KB of data:
+# first read is at offset 0, then 2nd read is at offset 1.5m, then the 3rd
+# read is at offset 3m, and after the last read at offset 127 - we have only
+# read 87,040K data.
 # Buggy result: fio reads the full 128MB of data
 [foo]
 size=128mb
-- 
2.42.0

