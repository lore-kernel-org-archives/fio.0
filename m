Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037D812E73
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 07:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536746; cv=none; b=cFlGY0lHS/gvTAEzOaVn2uV3N/xZuAAwfK/s9nrJVTJJBcA/nIEYhApipzfXZ5D2/E3FboX6Z5/4hSFTnxdqfTgzbaQ0mq03Ww4YSLAPkxiPHmihNLimv5VGfdNHjJ/XajXNXE97ukcUYAIdShwfttxror9IcOb1Qw44wUXC5IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536746; c=relaxed/simple;
	bh=wcgPg802Bug2m09ImALM4kEWNZ1pt9SJ3yEAivELcLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzVXD8+nBZpjEOOHRYryYVog1TjVbptPSD4yxzhilcgDKhApv8NqWi4mCrPW7IxgDcNIIrxtG4nObewIFK2lQ8uogptWcbrrvqhL5CIlX6r3hVSQ6OSY5hisR2KkLQ/d4jia17gXvfaezoGMC825DGZy+EMGqEgujvvtQLl6hvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Y1HlYUhg; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Y1HlYUhg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709536745; x=1741072745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wcgPg802Bug2m09ImALM4kEWNZ1pt9SJ3yEAivELcLc=;
  b=Y1HlYUhghYqsCxm3LC/ONIwhbnGc6JoLb3X8CDlxhb2J7uY+YIDfJUtI
   TuV5QhKe6cEp/DrEDbODOHK6Z6Z6NvdGakylVBvNmZ3UCuXQ56KP4Mc25
   OBaD/HwGNS+nZiDL34Ex5uChlC+cmaRPEqZgjAbq71AzKa60c9071n6NA
   oWGDikZoJrKMWW4DBJt1PcLKfC4UZA7EKn38NN95RcaBJbSzJG5WiYCA/
   IpU9zgnAR9QmmLJGQ881va3OBBtzMtXYsvEHiizFaNTBle26XASQiLcvH
   hhz85HUgQwlib5GWd5kvcmmJoMT+aTD8pQ5XDwVp6UdZHuiebVp7Kdc5V
   w==;
X-CSE-ConnectionGUID: JaxtXLjJQvCVHwgTVUy+hw==
X-CSE-MsgGUID: jjR9C8WcSU2IxPfgOsUXtw==
X-IronPort-AV: E=Sophos;i="6.06,203,1705334400"; 
   d="scan'208";a="11318344"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2024 15:19:04 +0800
IronPort-SDR: P/c2iFjdxQKB/UfJUuV9LfcqE7jOoPWxB0ojD4xmqrDdKFyih2Ql18oxc6zZt+3l+Swc5blocw
 fTLfgdO2z9FA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2024 22:28:17 -0800
IronPort-SDR: gU9G7RFd3Ye2OnxNSptoSznX7M+GYq+xqUVthLHySCFSwPZNsL0PswCZVj896ibE3HQ8N4QefH
 FyDHdpjTE8zw==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Mar 2024 23:19:03 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 2/6] t/jobs: Further clarify regression test 7
Date: Mon,  4 Mar 2024 09:18:47 +0200
Message-ID: <20240304071851.982-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304071851.982-1-avri.altman@wdc.com>
References: <20240304071851.982-1-avri.altman@wdc.com>
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

