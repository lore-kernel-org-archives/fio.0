Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F7636B047
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 01:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501527; cv=none; b=GzfRtyjXdWvbRoeBNL0GMtwXoN5edAo3ZCy8sj9KbvlHPUH4b96L+lvZkTthdccooqJMkAQ9vSbdybEjF5Ttl0VH6hbsXVEwewxAOI5mGTGnL8Amz1BklSRYNG2fzVIJ/yv/kAeMKwmrai9W1p0egXyhZM7HRkciw00khvhfFx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501527; c=relaxed/simple;
	bh=7jKyLo1rkedBgLRjBeaQ0z/Pt+hj4lGV6Da7WVoQm5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWfRjR/zKrvMkTnUzXklgOVwZING/sJj6oGopO3ORFCKtWfaqfZtGLCwo1biw4JwwXx7iuRfUvT7qtrNo/4RVBziJb+51GwL0NxwkBzx9mzmzq9kY1RB473PQM6jRnSpvMgI+KYBSipZXKSzAdC5IunGHnA9NDlLyZiBJKe2JEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kn6L7sP7; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kn6L7sP7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772501526; x=1804037526;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7jKyLo1rkedBgLRjBeaQ0z/Pt+hj4lGV6Da7WVoQm5M=;
  b=kn6L7sP7tEChJTBkIdzJMRAMwbXDpxJ4dj2eFMbZAdylHNqe7lSpMz/V
   exV595FhpttS2wP0Wr+x9bdzNihx27S6PUj+/RhGq3EAozZM2NcxqTx8R
   lHrJNwpuUwb00fyG4iWmF3efBeQl12bJKFOCsid62MCHBEmb1sm4SE4AL
   ui+b+zLo6BID8Av/jHdRENbl/0lXWvbY5ihcdomiMMHr1xQFpscz0sO8r
   00dZKoifpzMNnnWJPujQyQanD57ePjftUSMdU1+gPxPPNVr1Rcgxc64Av
   n9gNTGjULvcov9luoxzgD1Pz9enFEz01S/YoyIaE/PNMdDZHxD7z85wWN
   w==;
X-CSE-ConnectionGUID: 5oCCaaHjRa6HiAK3SR+Vyw==
X-CSE-MsgGUID: JmPAAQD5RdCCJ/IF2Smx6Q==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140813509"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2026 09:32:04 +0800
IronPort-SDR: 69a63a14_yUqLWfxXC8fI4rVmIgeXsUpoMTRHHZ1Rjwd6yUziOn/rpHQ
 sbKSlNwCuMoRWr0gyzsZpFI8Di9c96Xq9XulGOQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 17:32:04 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2026 17:32:03 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 2/8] zbd: fix write zone accounting
Date: Tue,  3 Mar 2026 10:31:53 +0900
Message-ID: <20260303013159.3543787-3-shinichiro.kawasaki@wdc.com>
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

Currently, zbd_convert_to_write_zones() calls io_u_quiesce() when the
number of write target zones hits one of the limits of write zones. This
wait by io_u_quiesce() significantly degrade the performance. While I
tried to remove the io_u_quiesce(), I observed that the test case 58 of
t/zbd/test-zbd-support failed with null_blk devices that have a
max_active_zones limit set.

The failure cause is an incorrect write target zone accounting in
zbd_convert_to_write_zones(). This function checks the current write
target zones, and selects one of them as the next write target zone.
After the zone selection, it locks the zone. However, when the zone is
locked, another job such as a trim workload or a write workload with the
zone_reset_threshold option might have already reset the zone and
removed it from the write target zones array. This unexpected zone
removal from the array caused an incorrect zone accounting and the test
case failure.

To avoid the incorrect zone accounting, call zbd_write_zone_get() after
the selected zone gets locked. If the zone is removed from the write
target zones array, the function adds the zone back to the array.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index cf825601..2e600f97 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1692,7 +1692,15 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (zbd_zone_remainder(z) >= min_bs) {
+		/*
+		 * If the zone has remainder larger than min_bs, the next write
+		 * fits the zone. In that case, choose the zone for the write.
+		 * The zone might be already removed from zbdi->write_zones[] by
+		 * other jobs at this moment. Call zbd_write_zone_get() to
+		 * ensure that the zone for the write is in the array.
+		 */
+		if (zbd_zone_remainder(z) >= min_bs &&
+		    zbd_write_zone_get(td, f, z)) {
 			need_zone_finish = false;
 			goto out;
 		}
-- 
2.49.0

