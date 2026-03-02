Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872B71AC44D
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418373; cv=none; b=ByvhO1u1qHjtQBUgec4SBju4f4uXweANvaUCwVDP6C57LkLsEjuyuYAe5Yj18vv2PD8f4370nSe76/hgFDikEBTVPsETOtfyP0xeolMhMp6GGr+VgQKK++XgVn+90mOy2jHbsu1d6v6BadARwG7hhydOOp6LsUiAcyPvYpOV7Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418373; c=relaxed/simple;
	bh=kQQQIcYXZXMbs9aKSG5Ild2a6StmkTU/HvyaAeeJxYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej1G/7RyepcdqQyq6K2YqVLjPNOEh1n9Wv9w33VxoQWyeUXhIOETwTxS9XtToNPuJ4Hkfo9nD95z8dZpJMMRGdHSiHB63uvfXOrx3H9gF3tUQY+t5PRec20cSNDaWtwlr3JcBgWlYDwivcIJaO2havckGwkkEM6hm3woCMMHuvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=O2AaLfB5; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="O2AaLfB5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772418372; x=1803954372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kQQQIcYXZXMbs9aKSG5Ild2a6StmkTU/HvyaAeeJxYk=;
  b=O2AaLfB5x1wjj90cSCnL//qxe0UCS8P/3NeN+/mbqQViI9Q2P9QCNS3S
   6z+RfeOmwSgYBb7Zjbw0p+ztpGDZrN4HvIuHKnjKxElJtWa25qyRXez7E
   9T+n7zTTY5vAkIwy07ixfvwJTQljnbU4YnRGiNUsE6b11NqynzTbn2qvn
   on3wB880q8deHougN3/Xh2BdwXdqE+H2R2evTxn5l9RnOZOLM9f7Qs0JZ
   DWh/wrPf2K628dNI4aY7ALayMSYvgvwUa/JZU2GHx9bkLAvqKlHkYzC6I
   7SGMAuBd3k1oyR0OiwyVnIeraPBMHBTYyePi8JPak3meyTzWaoVY651LW
   A==;
X-CSE-ConnectionGUID: Mr/Ou4YfRvyA7mF5t8U8tA==
X-CSE-MsgGUID: eP87HirNSS6xjQr4VGBNQQ==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="141307936"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2026 10:26:12 +0800
IronPort-SDR: 69a4f544_CJbVRiuDAWtWWpdsh6D588TZqQpwwjxHnuWnXjtNk00UIiJ
 MchfKzJ437/ZgYHHDHI2FmkTXGFANeygIfE70OA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 18:26:12 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 18:26:11 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 1/8] zbd: fix zone selection of random writes
Date: Mon,  2 Mar 2026 11:26:02 +0900
Message-ID: <20260302022609.3526823-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
References: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
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
index 7a66b665..b71f842c 100644
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

