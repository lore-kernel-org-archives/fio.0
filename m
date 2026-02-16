Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14292E7161
	for <fio@vger.kernel.org>; Mon, 16 Feb 2026 08:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771228849; cv=none; b=co207VmFTPcEGEIwNiHttCgDyIAS9q6ENVPYURL0roW0mqwDAkPvcs0OxWvyBQoPOza7YhC/pdqxuYIkKz71FM3w3V8vFo6u+dXs+PIDB6dHbCQJoNT9ZLVhr1vR8FDPEiqgt4v24T00CADKk5sjzs3au4DodVoqflKE5ZxM0WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771228849; c=relaxed/simple;
	bh=9WSLIr1ZGax1kudTBqi2s899tAbgWVuuuyaCesvMr7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyE/wcN+mDQTdogPC7DwdYPEsBC3C9jVMJ+v5Yt3UbRjggAZ7CRuQDjTwU0I+nhTZjwDMq6q5ivCOcEmKiGHfrRbPKZF4gXL7Xu0FGdSjbDkE4IIrAcW9392L+f0P2oTwcba8FrQU7Ys0j/YfgBnfigTjtbJZUwTlnXTxogOGxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EaJWUIa2; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EaJWUIa2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771228847; x=1802764847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9WSLIr1ZGax1kudTBqi2s899tAbgWVuuuyaCesvMr7U=;
  b=EaJWUIa2QPIvyGub4x0uVCT7BX7CpWL3QKWK+UWLsPfOKWqJv/P6M3jv
   ClAXMXqiMlJnUx4MPYTqc9lJHbzOBG/7N1B0G1i/tJ7H2yMChK1JxusF4
   f7aarhoDhCxUuooOQ3pazrD1dWBztEQ7IY5PtIyrPOOD9IFpc26bcUEzi
   b2wCERyHtS+TV7VVsh05W8cFYdIcYV0EDR/UuF8aIy/jiOzKw6b6O3g34
   2pPte2QjTeVJpQmu1wx+Evau9whh6d93E+cp0xfkW7f9HBHRk0ZiIxm5G
   e96Rvy5CWLGKVnJ9hp28uCpRwfSILdQInZytDqT9Vp8RCd2wLM1HigbGN
   g==;
X-CSE-ConnectionGUID: OhVM1UToTRyT2IFGAcfDJg==
X-CSE-MsgGUID: 7lRvy7rJSaa4hc1oN/7ckw==
X-IronPort-AV: E=Sophos;i="6.21,293,1763395200"; 
   d="scan'208";a="140812874"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2026 15:59:39 +0800
IronPort-SDR: 6992ce6b_YskKUytOkpJ56TsseFCvw3F6ExK3eU8btXqWj8syav6Gp/o
 ltO0JGgkRbo1e1ljQeStHBfE/ewSVa3IfMIOL4Q==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2026 23:59:40 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Feb 2026 23:59:39 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/8] zbd: fix zone selection of random writes
Date: Mon, 16 Feb 2026 16:59:29 +0900
Message-ID: <20260216075936.3318729-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
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

