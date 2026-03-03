Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB02372EE4
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 01:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501524; cv=none; b=JNtPpcMdp0XUchr9kFnVR94KIk6RTvKVck9AO7VBqlD+iOHmaKZs3HLEHDcp2Fcb7XPE/NYamF9quVs+K7B4RIZBz+HpalIgugCBYbHeZNbtNJhxX6moGwvyGsUcu4wt2r2weJKS3oODEXg+4ddqzA+vddangRO4sRNNcYgknbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501524; c=relaxed/simple;
	bh=ZYgw4Idemnn3CDADq6XlH/cRPJdu/0BN9Se8359EJrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtBqTePMa+x6paUBAmOzurngxLonCO2jAGabpyNz4YYJ7htwkDLHgXABpaGVVFU4i5LwHY0SfFE3jLUYWLvrBFk5a1Y2167cPg1TUTbBfHoMHGHH0AzgIfpm1sHQHhiujQqZxkVdtjmMKyXFjojhyq9b1r1FWsQKRnQ2qPsZfyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fK6Oa9oi; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fK6Oa9oi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772501523; x=1804037523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZYgw4Idemnn3CDADq6XlH/cRPJdu/0BN9Se8359EJrk=;
  b=fK6Oa9oik4pK5DasHH//QZIedv0TrYpveNDp4rHh5S5rPc+bY7M1dFOj
   zLP1RX0zxsljgiq5l1alzx5Ssh0kVtCNoPsaVbXASDp56xaqp+Jv0QcY4
   6giwc44WwnPTRtKsixOYjcNPQI1L381xd7Xs+S/BbZjfQda73opPom3Ww
   LhMhg24sldZg0ajq7MKfeVInEFNlI7v9X2Ok8TNec5SqrR1atuz5BI/ua
   JOgdpkjVDE+x2+Aobbf1BrxsXgJOseC1m8axSnA8+LYzUhixiqborOsVp
   yyoUvrdA3rSbEt33bCFhcJb7bRGytp8GulNadPumo0ejog0mKnW9HQCCB
   g==;
X-CSE-ConnectionGUID: V9urnZ+uRi6ORIA/D1lo6A==
X-CSE-MsgGUID: /3WgS3H3T9KdTotzNlXEcQ==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140813508"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2026 09:32:02 +0800
IronPort-SDR: 69a63a12_+d9EI5KXDkUSmjX9eJJYCNoj9+P0uuOY9MxsL+UomWc2R2F
 p94gtF2OHWXdZ1Zuk9ePg2G62tJFtuduJeLUyLQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 17:32:02 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2026 17:32:02 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 1/8] zbd: fix zone selection of random writes
Date: Tue,  3 Mar 2026 10:31:52 +0900
Message-ID: <20260303013159.3543787-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
References: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In zonemode=zbd, random write workloads targeting zoned block devices
with max write zones limits such as max_open_zones can not do write
operations to randomly chosen offset because of the zoned block device
constraint of writing at write pointers. To adjust the offsets to valid
positions, fio calls the function zbd_convert_to_write_zone(). This
function checks the current write target zones as the next offset
candidates but may fail depending on the conditions of those zones.
In such cases, the function waits for zone condition changes before
retrying.

However, the retry logic begins with the zone where the previous attempt
ended, and selects the zones that were previously write target.
Consequently, the same zones are repeatedly chosen for writing,
resulting in writes concentrating on certain zones despite the workload
specifying random write.

To ensure proper zone selection for random writes, modify
zbd_convert_to_write_zone() to retry the zone selection based on the
original offset provided to the function. The local variable 'zb' keeps
the reference to the zone corresponding to the original offset. Use 'zb'
at the retry attempt start.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/zbd.c b/zbd.c
index 08c537d7..cf825601 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1643,6 +1643,19 @@ choose_other_zone:
 	}
 
 retry:
+	/*
+	 * For random writes, retry from the zone chosen at the beginning using
+	 * the initial io_u random offset.
+	 */
+	if (td_random(td)) {
+		zone_unlock(z);
+		zone_lock(td, f, zb);
+		if (zbd_write_zone_get(td, f, zb))
+			return zb;
+		z = zb;
+		zone_idx = zbd_zone_idx(f, z);
+	}
+
 	/* Zone 'z' is full, so try to choose a new zone. */
 	for (i = f->io_size / zbdi->zone_size; i > 0; i--) {
 		zone_idx++;
-- 
2.49.0

