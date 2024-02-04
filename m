Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4B9286A2
	for <fio@vger.kernel.org>; Sun,  4 Feb 2024 21:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707081410; cv=none; b=gJvSLqM5dsibT1MTnhcXABkxzHhHe7VQaPARD7t9656eSuPf10YZ8LwCe3AbS/S6AlXsUHuheeswgHPEcqK4XJpeQSUjI3FlbQ6meT0H2CQhbfmcIfZ/cYa1x4L44aZa/nHo/tQd+TvmXtf8ro3dQ5R49Sa56ZEPQnIMT1lfbq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707081410; c=relaxed/simple;
	bh=GFE0NgHAgzgyV/uCoCvfAGJ2r1qJWqXm6q3YCZlsfhI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qHr51/tWdrp1AYosJlUAq461BwlXjkNMRSdYfYZCXB6DFDMDff61+kN1XWvHjnBc3M3GP2o0dM/KJ3gZWho4pHFlPaNC1zl1aRHTSNq6fZY6vLm/lkOjbu1umRawZesjBvDpZtMdS3/faa/qhss6Eg98gl32TkrMOvXKXHHtEVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rg2cnVvB; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rg2cnVvB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707081408; x=1738617408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GFE0NgHAgzgyV/uCoCvfAGJ2r1qJWqXm6q3YCZlsfhI=;
  b=rg2cnVvBuWtDObdht4vAJCW+IhkbEXsAdO+0KSnZMxgESdfH3oq1QTsR
   YzqMoNMKO62Bo+HmP1gRfLdHRh7LsvT/51MMjhiJBZfxzZPX2b2azIs5B
   1RrxW1Ur27CJO2jgY7GdDsswxlUEOD/0OsH/nCGPrNmDFwmCYf1r/HjRa
   CVJury+UYzAYQ9PYVTmOiFzxmbnC3cHg9wJW/Ox/3pxpoxz0Px64OYIpB
   /dZEXrfK1UHr+BM2cn36RCJ1CqfA1o3SD0a8zvWhZOziQR6qKtKYzvLl1
   o7H7qNFyQO04vZ9k4vwJH//66CpQ0nKpOie68RIoX2Rr2x5BmzGJEKEgG
   g==;
X-CSE-ConnectionGUID: SfIzy3zfQh2JRYIqTLyfwg==
X-CSE-MsgGUID: YAh0qCkSSgWyRGElPAjDGA==
X-IronPort-AV: E=Sophos;i="6.05,242,1701100800"; 
   d="scan'208";a="8472766"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2024 05:16:44 +0800
IronPort-SDR: lWMIunqc7t/CDbQWEMSA1STIqSjqKPjdZtzOleXyzXTpW0ZakHD3t+lw+WnRPmryH5cQpLFbB3
 7HqjZfXLVrGQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Feb 2024 12:20:50 -0800
IronPort-SDR: r7aHGq+HLnLrs7zgU6kuL7CimoLi6DH/dBuigt9AVilHu7N9+6Q05HpxBXrV2HvYyN7povig4d
 jVybXdfqPOSg==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Feb 2024 13:16:43 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 3/5] zbd: use a helper to calculate zone index
Date: Mon,  5 Feb 2024 06:16:35 +0900
Message-Id: <20240204211637.210199-4-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
References: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
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

