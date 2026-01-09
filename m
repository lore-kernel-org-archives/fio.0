Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CCD3176E4
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926240; cv=none; b=gsAbxInJgtMpsyJWpppeSBeUZRn4QFGyS6LKBiRdfyx3Ge2A1k9BEwKbucvnyuaTnthOIo3nGRrOfZsLDQUWehEU+Frk5stYKwEypiM2HjMTAZEhntm0me9jDomEpHCNL3fPV5XwlndW6Sy3ZT1bSC/ACXCWVBEEyWqtSRwMfsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926240; c=relaxed/simple;
	bh=Qet0c2eyxEmt/GtqmovHBCa8RqVVq1jx9LLQCf4PlLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2j799q2K/eLCnakVfDr1tIZ5P4W7fM0heeFGSA4psF9NSvl4R2TsWpMGOpsTzu2JsNmzC0sFGLcCl05n+uRDPrq/Rqi6Wo2O2Fz/yaVoKE8L3L177nBHvdL4J62zp6qcPPTj7c9l2YKJoOYNFoaubhzMqMHPh19JQlwl4C0JM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dA8vd8oc; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dA8vd8oc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926236; x=1799462236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qet0c2eyxEmt/GtqmovHBCa8RqVVq1jx9LLQCf4PlLs=;
  b=dA8vd8ocUH3gc0rqKtwadyer0mpkVn9L7v3JYd1qkVgv9ApO9VaN3u0z
   Cov1VLZve1QJpv9txB2ExtsqrddWTTGJY+P6uJwB7q8e8ha2iNGquydsL
   YhHhKMR5dGi+rRiZvVpfmpQ26wmGILg4Fvjdx1EeAZzO/bd2qhBiCQ5M1
   TISZNLO7hSbNjMDKdPFgz9WqSgvKYh8V3FnZa8TPETO5QCfUWlE2y5i/Y
   UnZrcgDxIsuMrbFCyI1gqjajwJJW4s58vEsRWk1vBhsxmYbs2FYCgFsG1
   /EqBiypZLUgmvdNIUd7yLCcl+39/Ly75aDRu1IyMNn5prd/ytElTWZ6pe
   A==;
X-CSE-ConnectionGUID: FtPcH38bSGKR+XrJXbaVTw==
X-CSE-MsgGUID: vNea9rHtTzy+kvuShGpNIw==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774576"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:08 +0800
IronPort-SDR: 69606999_c83ZID6lVIPsJzXaYuvhpteP115k8vSaGc0POqfhVydbkjQ
 E1Cbz71d5HoMko8r4vlXvXOVZDE13qykDPkmt5w==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:10 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:09 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 04/12] zbd: fix write zone accounting
Date: Fri,  9 Jan 2026 11:35:55 +0900
Message-ID: <20260109023603.2848421-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, zbd_convert_to_write_zones() calls io_u_quiesce() when the
number of write target zones hits one of the limits of write zones. This
wait by io_u_quiesce() significantly degrade the performance. However,
when the io_u_quiesce() is removed, the test case 58 of
t/zbd/test-zbd-support fails with null_blk devices that have a
max_active_zones limit set.

The failure cause is an incorrect write target zone accounting in
zbd_convert_to_write_zones(). This function checks the current write
target zones, and selects one of them as the next write target zone.
After the zone selection, it locks the zone. But when the zone is
locked, another job might have removed the zone from the write target
zones array. This caused an incorrect zone accounting and the test case
failure.

To avoid the incorrect zone accounting, call zbd_write_zone_get() after
the selected zone gets locked. If the zone is removed from the write
target zones array, the function adds the zone back to the array.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 9d5a3bc3..e5f4c8f6 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1661,7 +1661,12 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (zbd_zone_remainder(z) > 0)
+		/*
+		 * The zone might be already removed from zbdi->write_zones[] by
+		 * other jobs at this moment. Even if the zone has remainder,
+		 * call zbd_write_zone_get() to ensure that it is in the array.
+		 */
+		if (zbd_zone_remainder(z) > 0 && zbd_write_zone_get(td, f, z))
 			goto out;
 		pthread_mutex_lock(&zbdi->mutex);
 	}
-- 
2.49.0

