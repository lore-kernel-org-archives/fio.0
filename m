Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DC93164A9
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926237; cv=none; b=T/mqiIeRVoESvvmV/wXp+jBkPyK2P7pwbBKHfDv9MY/5Ya/G+iA45pdqvt3MT+VmXfIRhkk9hmAK4J1aIJCJTb3ZsftkoW0tTxpPflkznPNu/GH6gh1ePaci7hs6UhBe/0WVQggPjr9y+HdwVRDOuwqvKmo7WnuI2h4Gomqhg0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926237; c=relaxed/simple;
	bh=9WSLIr1ZGax1kudTBqi2s899tAbgWVuuuyaCesvMr7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqBsyTbAgV+lFdWag6UiYFsln0ttAzyiB5jhtEhAqV6zdCNggfZulXW5DFIB2b/hkHIfZDO0K2Q9s+6IhBxXEqNN4j3jOL8GZl6KU8KhABZLn3n0J8O2vnU168XsnRU7I9mCWya1MQ0BLuoyL9ctjSy/qaVvjAKhrNLq0De09lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AicDBWG/; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AicDBWG/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926234; x=1799462234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9WSLIr1ZGax1kudTBqi2s899tAbgWVuuuyaCesvMr7U=;
  b=AicDBWG/jBY88F3RCXQfydSYK4EGAgvtQcNRdCiKZkAVTJMqC+eQtVQZ
   YoYT/uukrmg2ZxZO4t8MvYtbWUHlEMplSBu3S7O8o8ArbEzkml54r4H5Z
   D6Z2or6YsdcvU3/Xmx2lCTYbB0++el+HLIe59AAcXC8v3BLkG/yiV9Zkw
   g8luIeVIMzfh5y9iSz1K21r6zbVCTR0gaD8JvpG2M/5vh5TbKo9LPJNQ3
   tuqVsD4DsEZ1srUbUHRUT5mz2zCda0Tkuw1eyQtUJqqHi0KLq9ci+SAZB
   X1UqyVeMgoDPTkNiDbXtIBTu8AnEz201EqYMCmB0R5l5R0D1jPYOC03uP
   A==;
X-CSE-ConnectionGUID: 31GeL5q3RMKW1Eh5W45rqA==
X-CSE-MsgGUID: ZQCc3e28T5S4T/7ybWmHkg==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774573"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:04 +0800
IronPort-SDR: 69606996_bT/Yh+49v9eKAFsT+2fkFmpTyuN3rd0Fq9/iSVPJwr1RU39
 fqeqUrg1sszvzvD1GyfMy7VZj4AfhpgyzmEVgvA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:06 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:06 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 01/12] zbd: fix zone selection of random writes
Date: Fri,  9 Jan 2026 11:35:52 +0900
Message-ID: <20260109023603.2848421-2-shinichiro.kawasaki@wdc.com>
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

