Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAE827F19F
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418374; cv=none; b=jAJ4Uih3B3THKRf3e6jmTRvEDjm3KplGZIvyxxh07nGDL2OOhm84gA8nThJHPVJz9CzaQs7tD84Pb5sgf+1jabsaLvbhkIdaNg8fLCX9kUkD/psIfTGzVeqeP3mpDb83tNNYX16f36cKtozVUl76v1ns/QkKbRDaHni4oSUy+nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418374; c=relaxed/simple;
	bh=6zwA+Km+FjyatUF8Z2Q4iNJZ3+gB438mLiH4Yx7l+9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrV4xLUyPn44DkgMUSHlh92y1cdTOdPhr7oV+Zu12m05U0TocyC1i6mBFYrAv8QP7UsML/Di4CU4LS/YVXhyX89CSf0E2GWoCmZCy6eZ+2nBBhtNHi0wlMP1W6K4Jwkers/ZMGwM20U4q1D3BQ7Nr6p/WuGuF+ymWAcyMZoX+Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FR+7vqkX; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FR+7vqkX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772418373; x=1803954373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6zwA+Km+FjyatUF8Z2Q4iNJZ3+gB438mLiH4Yx7l+9Q=;
  b=FR+7vqkX02N6E/jFpvfRzqiuqzsvG2dGspedKuYvamcLvRHiGW4qT9q5
   4gn+k6Jl4w4UtLKieQUVpqJtBZXFsG4WXfLa4OTz/DizbyBMMO36vyPwV
   1ZhQrmZ5K8iylC4W3i3RJqkt7H6nq9nzrtv3Qb4ocvtzOulhCqrxoD111
   RDOL94zK4ONIyEcTr6BfB7vOZUsX0GZhXj9ZftxVtEeieYepf9r3qRuFS
   ZamCaKziXwbq5J727+84fsGKOC5+EY8IR0z4D4ppDDCxfdCSHTLeNUzRt
   DTfxhF5PoVfNjOp+qWaOun+73rFFGzFpTqhkPhrRWzWqvvX3VO26zZoNt
   g==;
X-CSE-ConnectionGUID: wejjgE9qQY+5R+VybhuTug==
X-CSE-MsgGUID: Wn7H+0C/Q1yIGczblRYaOQ==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="141307938"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2026 10:26:13 +0800
IronPort-SDR: 69a4f545_ypQJiyLEnhk8+rsl1lemBmPf5DQVHLMmzPSSztQ4+NE1D1N
 IbqsT6pEIMz/df0TyxhB0NnZ+IfgnW2AsRCEvsQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 18:26:13 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 18:26:12 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 2/8] zbd: fix write zone accounting
Date: Mon,  2 Mar 2026 11:26:03 +0900
Message-ID: <20260302022609.3526823-3-shinichiro.kawasaki@wdc.com>
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

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index b71f842c..c511b709 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1693,8 +1693,17 @@ retry:
 
 		zone_lock(td, f, z);
 		if (zbd_zone_remainder(z) >= min_bs) {
-			need_zone_finish = false;
-			goto out;
+			/*
+			 * The zone might be already removed from
+			 * zbdi->write_zones[] by other jobs at this moment.
+			 * Even if the zone has remainder, call
+			 * zbd_write_zone_get() to ensure that it is in the
+			 * array.
+			 */
+			if (zbd_write_zone_get(td, f, z)) {
+				need_zone_finish = false;
+				goto out;
+			}
 		}
 		pthread_mutex_lock(&zbdi->mutex);
 	}
-- 
2.49.0

