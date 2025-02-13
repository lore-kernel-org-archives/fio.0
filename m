Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537282063CD
	for <fio@vger.kernel.org>; Thu, 13 Feb 2025 05:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739424322; cv=none; b=CQ3HXzwMxJTh3JXhv6CjIAwL947WT/ESWIvCJhg7W6VsgIqOdVVFuA0eyM5v0Dk2AtjPcigFr4iHTwcwkPOU0gcYmPpdnEKk66mFW6rWcH1MXkcNnAepfAElyigPw8DDER8KvCJF1T/h/KcOuDx2AXJnTOE9LGIZXAq37VoShDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739424322; c=relaxed/simple;
	bh=1+blsOPs5yL1ED7YiGLSSTPjzQQJ0ljoEqC2zb8OU44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDjA3hCW3wSwWbDAfRKB82z+5K0j59N8iYe0xmAzawoPNGJ7D+Uj0FngkdCMIi1a4TQUT6KTykuRi0g5bWnovSlibcQcfj+a7rnV9JmeIzZewOLPHdLLatwxRKICaTyewLDJ3GWEq+XILqs+d1ehdwBh8zMa1reQqxanQDkUMgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bCNBDi//; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bCNBDi//"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739424321; x=1770960321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1+blsOPs5yL1ED7YiGLSSTPjzQQJ0ljoEqC2zb8OU44=;
  b=bCNBDi//saSBaXVfQa1sV+jO9ok+O3qrqu/+bpbN+PmC9gTf8+0VFBCm
   rEX9299ns4G1XC6hg6FLhd0iGhpi6ThA+eRuEw7P7kuRaFPvk7tR/wIKX
   yrDjvtSDlAk0p35sPRqm4L1+zbBh9NX0KO9is5PDpnP0gtETGit6A+lBa
   VBvNTzIp+R1nSIKBi327ctoWcYkVTRGcOIl57gkSNGcXUqrV3E/303hg5
   NK35DeWdleaa8D1E4aJoQCVU/MVs9if3ipNm62sRQ2Nt3y4GNHz/aTVbd
   v1gT//HDZ2MCZLjPYtg7WhS/m8ivbfheGq1uxPqLVhe006PoGsZ5iM06N
   A==;
X-CSE-ConnectionGUID: iJXzK59BQ/WSHzCUYZs9sQ==
X-CSE-MsgGUID: 5rvarIiLSRSshJoiTWf/Gw==
X-IronPort-AV: E=Sophos;i="6.13,282,1732550400"; 
   d="scan'208";a="38948607"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2025 13:25:13 +0800
IronPort-SDR: 67ad7486_LMNYQUgGo9/UTIIpFoG7y9iCYM0XSxHCUVUQ0ANKUnjYana
 7+j1D90PDKAVTpS9AdZZTrN6URHS6Oz7gJ/2t3Q==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Feb 2025 20:26:46 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Feb 2025 21:25:12 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/3] verify: print message when verify_state_should_stop() returns false
Date: Thu, 13 Feb 2025 14:25:08 +0900
Message-ID: <20250213052510.1474423-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
References: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When verify workloads with the verify_state_load option target an offset
that is not saved in the verify state file, verify_state_should_stop()
function returns false and it stops the verify workloads. This workloads
stop is made without providing a message to users, making it difficult
for them to understand why they stopped. Print a message to inform users
why the verify workloads stopped.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 verify.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/verify.c b/verify.c
index 2e113862..63b63718 100644
--- a/verify.c
+++ b/verify.c
@@ -1892,5 +1892,7 @@ int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * Not found, we have to stop
 	 */
+	log_info("Stop verify because offset %llu in %s is not recorded in verify state\n",
+		 io_u->verify_offset, f->file_name);
 	return 1;
 }
-- 
2.47.0

