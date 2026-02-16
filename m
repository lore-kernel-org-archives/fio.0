Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C3128FC
	for <fio@vger.kernel.org>; Mon, 16 Feb 2026 08:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771228849; cv=none; b=kudIWX85pBMp+KZ32uF/D6tMHRqszwlMi1GiIKZUNAQx6rkhNoVgXA6jvw8WOaj65hM+uVWfKbqCSCSL6Zgy4QWUguuKNQO2qkHkFaAw77aEydcfHYyDX3eAxREhqmbYbqEu+ekMq5bvYZzS5c/E/toc4sI6jNiM8Y/4utIQSr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771228849; c=relaxed/simple;
	bh=VywhLZiFqAa929NJUW7se/tJxHoABLqfTpENyjVZ3vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2A2G3kym2yGvAx//teZrHKvyDINHZjn/eHejE+K2sh0QZgLOwH0Vp4hdabSeipTI29j5l9TtyKW7KGCUd8ch64x5KMo1xwVBIV9qL6kYwANj7gxlz0gLAZuwY6bKyngVswBABUjlcMVkT2xPDGJWbfxznNsh0FtERQN6G7k10A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FdFID9t9; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FdFID9t9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771228848; x=1802764848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VywhLZiFqAa929NJUW7se/tJxHoABLqfTpENyjVZ3vw=;
  b=FdFID9t9xu+2YX3tBAu5CYi9msCztBNXkghPL7NuGVvW68dzkLP60OdV
   bPKd2O2cLRHbFsDv6GO7JoHN3TbCAKKxiL7cyjXA4fK42UpRuIM5DQzlW
   0mR7/t/o7Eub6wamV6nPMPI821bN4OgNkg6Bxo9koM7Er9eSd7nj/xWtn
   tHfdd0hjr/4yhLAJmbcRKOu5J2aJEvnrGdyl1DcN+NZE3Lvu9GviNkrc2
   W+0e8rJnWb7o1LZPSqDy4e3DvJ7UfzsUi1l2I2VPx0OMN4/lACBu0qDzA
   2ViYyHJohhPqy5VV7qYOOdClZGvad1roOUWrYHMFzOdtn/SSui+KOHdO+
   A==;
X-CSE-ConnectionGUID: 1GpRLy/KTvuiA8BZgCxE2A==
X-CSE-MsgGUID: sufSk4r2TEOw0DgQ0P//EA==
X-IronPort-AV: E=Sophos;i="6.21,293,1763395200"; 
   d="scan'208";a="140812878"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2026 15:59:40 +0800
IronPort-SDR: 6992ce6c_qvs2+hbvdJBCRaIkcvvFa0bmkGCm3PE30e85UEkXC4YGy43
 pguEas5jRoMJqQ9eM+2J7BOUBydBpC7gJFaJiJg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2026 23:59:41 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Feb 2026 23:59:41 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/8] zbd: fix write zone accounting
Date: Mon, 16 Feb 2026 16:59:30 +0900
Message-ID: <20260216075936.3318729-3-shinichiro.kawasaki@wdc.com>
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

Currently, zbd_convert_to_write_zones() calls io_u_quiesce() when the
number of write target zones hits one of the limits of write zones. This
wait by io_u_quiesce() significantly degrade the performance. While I
tried to remove the io_u_quiesce(), I observed that the test case 58 of
t/zbd/test-zbd-support failed with null_blk devices that have a
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

