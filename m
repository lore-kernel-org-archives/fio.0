Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B364B12EBD2
	for <fio@vger.kernel.org>; Tue,  6 Feb 2024 10:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707217155; cv=none; b=ANI8eTuQXo+MoZh/CymgdDHWOhSn4eoRIRJZ/Xp1ODNiNi86/VGEh3gu4JT12eRegHSsNb+wiDpkU7UY72QQkI8T2jBmXHzvsbdIDjEpooY+AapOvj/sbISZpLCIp83Ovf/R2/k03daBU8SreC/mn25nAWBT+bq+KpcoCncKRMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707217155; c=relaxed/simple;
	bh=GFE0NgHAgzgyV/uCoCvfAGJ2r1qJWqXm6q3YCZlsfhI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rzJKjqN+T7nZK7zzly6rO8xxTul02tV14PHuGgV5nM25DnSCHMs9TJr6sj3MM2FmILKlXsy4vZjuvJfbDk+bhxHzeBtkvHOZn0KXumyiUi/Y0nM2UiDoD0/w0lYREAz0xa0NUF4iVz8uvDBkHBse3MI86kSLipLuULGiG87aeN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AplNA7OL; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AplNA7OL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707217153; x=1738753153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GFE0NgHAgzgyV/uCoCvfAGJ2r1qJWqXm6q3YCZlsfhI=;
  b=AplNA7OLHCRfvMq+AaOLMKwBj9TGo4x8SQW2MrqfqEbj+cR5wBXQmk8P
   Zfj7UiRHyMYEUEs4D9vHOhsBFJ5sLM7UctfqsP0+o+Um5hHRo0tBPRNBl
   jTTMH62Hj0nxOoNEI5R4+lSYy3ZfeCvapHCehEhrmLB5ksHWmk++7FekV
   X3az85xdrPoUGzk8VtE4p9MXPlTxEpCCA8jDMGErlKY705zrr624qrDlt
   uKZH5yFvAhHBxiJqCdK2JL8TlzcovX39Tp/YY80a9isrcvI81IMH+P44s
   LHDTtvfCT9RvywTNMvDScI0P1XT5iI2+WXNgaLpqxT7aPmPwo8cHcpjYL
   g==;
X-CSE-ConnectionGUID: u8WtHPRERjmJKSF1s9Fvqw==
X-CSE-MsgGUID: DT71cZaQTX+2Qy+hkTCQKA==
X-IronPort-AV: E=Sophos;i="6.05,247,1701100800"; 
   d="scan'208";a="8663351"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2024 18:58:01 +0800
IronPort-SDR: qs/prwrtYNaV0VBFmJ4gi6DGEszdky6vkXLtQGfqKyKczuRoiK+Jk04Q94Swen0eoH4mw35IVD
 4ShLgtmu2NwA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2024 02:02:06 -0800
IronPort-SDR: UGSmthDuNzco9uFTSPeyz/RXdQJwrNigo6zK/Ov7njaNUZUMH2PFmcWn8FC1OTeg84jNUU1T/t
 zj0fIdI9FCEA==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2024 02:58:00 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 3/5] zbd: use a helper to calculate zone index
Date: Tue,  6 Feb 2024 19:57:53 +0900
Message-Id: <20240206105755.214891-4-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
References: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zone_lock() function contains the debug code to verify that the zone
being locked belongs to the job's working zone range. Clean up this
code by using a previously defined helper for calculating the zone
index to check.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 7577472e..37417660 100644
--- a/zbd.c
+++ b/zbd.c
@@ -104,8 +104,7 @@ static void zone_lock(struct thread_data *td, const struct fio_file *f,
 		      struct fio_zone_info *z)
 {
 #ifndef NDEBUG
-	struct zoned_block_device_info *zbd = f->zbd_info;
-	uint32_t const nz = z - zbd->zone_info;
+	unsigned int const nz = zbd_zone_idx(f, z);
 	/* A thread should never lock zones outside its working area. */
 	assert(f->min_zone <= nz && nz < f->max_zone);
 	assert(z->has_wp);
-- 
2.37.3

