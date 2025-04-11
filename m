Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212B5221260
	for <fio@vger.kernel.org>; Fri, 11 Apr 2025 11:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369945; cv=none; b=Gb+rI9Ah/k1B1/BTSzCG6HNoBVjbGCjbvjX1M6tlvKHafeGXIcdjGkUUXOHRvE1FPNNaxWDoMQCqjNC975bycJYmmjodfWGX3Z/5EAoY6dy+cFqlMneSvINjAb9zSZRGMlqprQMa6+zKyD1brAg0+4Y2nEI9uvH/FkCrhIcfX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369945; c=relaxed/simple;
	bh=uLxcwL8q8nI+wvFWUWRA7XxiMteKCT/cecxSNWrQips=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKq0/a4tHvHXYyYYZraZLZjXqUCfNmdaHABYgJt3BdjW2oZq4ExpHPdyvQhVdpa7mk+lqmQXiPYvA3mTqSZcCovsjHbox6Grv/2+L+7KUnMprLe1cn/ITmdVpFy56jv1+UrGXJA2FOPRz8zlQOe/Mn9/KVHDnQiL/SnVzSg5F40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EnXoGC65; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EnXoGC65"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744369944; x=1775905944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uLxcwL8q8nI+wvFWUWRA7XxiMteKCT/cecxSNWrQips=;
  b=EnXoGC65N/ApODQ3cfPWdRz4KZE0s8GY0T2VeFUbKFoV+GUi0nEGgR7b
   wHUKBPmojrG9SXC0j+WugsnvKZjBmcjhKIKZ8wOc7SBVZ56MNjSAQyIIX
   QJ7/jAW3Ay4vgrd7y+KGCJ5k6IrPFMZZYrw7PhdqJJ4C03DLwtSbKP83i
   qeSn26YAFFq5OEajVF/dTYC2uEowDpmenWrJfMkObrWcv5z+40VLL7DAP
   aS753c4jY+Ab8RwaVHq0i8mJIUpAoKw2VbUuh7CWzipaNDdsZxGNOouLM
   8cmBwP6eMXoqol0aVmtAX7XkuPEOfDSnXrC59qyPbSAIDX4pPInNVgDds
   Q==;
X-CSE-ConnectionGUID: AQIQLSffQCS0b/aNO41TDA==
X-CSE-MsgGUID: paF4KdQnRzae9bmRlay9Dw==
X-IronPort-AV: E=Sophos;i="6.15,205,1739808000"; 
   d="scan'208";a="81898587"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2025 19:12:24 +0800
IronPort-SDR: 67f8eb12_6KNhgB150FZ9R8s36r+ENL3KC5GMzPhKr5qI7o9k60oqjK8
 kccHjZWdJMzrWca/+3JgA5CIsZ25ReFQ4I5iecw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Apr 2025 03:12:34 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Apr 2025 04:12:23 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/4] zbd: finish zone when all random write target zones have small remainder
Date: Fri, 11 Apr 2025 20:12:18 +0900
Message-ID: <20250411111219.57424-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
References: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a random write target offset points to a zone that is not writable,
zbd_convert_to_write_zone() attempts to convert the write offset to a
different, writable zone. However, the conversion fails when all of the
following conditions are met:

1) the workload has the max_open_zones limit
2) every write target zones, up to the max_open_zones limit, has
   remainder sectors smaller than the block size
3) the next random write request targets a zone not in the write target
   zone list

In this case, zbd_convert_to_write_zone() can not open another zone
without exceeding the max_open_zones constraint. Therefore, It does not
convert the write to a different zone printing with the debug message
"did not choose another write zone". This leads to an unexpected stop of
the random write workload.

To prevent the unexpected write stop, finish one of the write target
zones with small remainder sectors. Check if all write target zones have
small remainder, and store the result in the new local boolean variable
all_write_zones_have_small_remainder. When this condition is true,
choose one of the write target zones and finish it. Then return the zone
from zbd_convert_to_write_zone() enabling the write process to continue.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 23c18bd3..35829db1 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1460,6 +1460,7 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	bool wait_zone_write;
 	bool in_flight;
 	bool should_retry = true;
+	bool need_zone_finish;
 
 	assert(is_valid_offset(f, io_u->offset));
 
@@ -1611,6 +1612,7 @@ retry:
 
 	/* Check whether the write fits in any of the write target zones. */
 	pthread_mutex_lock(&zbdi->mutex);
+	need_zone_finish = true;
 	for (i = 0; i < zbdi->num_write_zones; i++) {
 		zone_idx = zbdi->write_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
@@ -1621,8 +1623,10 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (zbd_zone_remainder(z) >= min_bs)
+		if (zbd_zone_remainder(z) >= min_bs) {
+			need_zone_finish = false;
 			goto out;
+		}
 		pthread_mutex_lock(&zbdi->mutex);
 	}
 
@@ -1645,6 +1649,26 @@ retry:
 		goto retry;
 	}
 
+	if (td_random(td) && td->o.verify == VERIFY_NONE && need_zone_finish)
+		/*
+		 * If all open zones have remainder smaller than the block size
+		 * for random write jobs, choose one of the write target zones
+		 * and finish it. When verify is enabled, skip this zone finish
+		 * operation to avoid verify data corruption by overwrite to the
+		 * zone.
+		 */
+		if (zbd_pick_write_zone(f, io_u, &zone_idx)) {
+			pthread_mutex_unlock(&zbdi->mutex);
+			zone_unlock(z);
+			z = zbd_get_zone(f, zone_idx);
+			zone_lock(td, f, z);
+			io_u_quiesce(td);
+			dprint(FD_ZBD, "%s(%s): All write target zones have remainder smaller than block size. Choose zone %d and finish.\n",
+			       __func__, f->file_name, zone_idx);
+			zbd_finish_zone(td, f, z);
+			goto out;
+		}
+
 	pthread_mutex_unlock(&zbdi->mutex);
 
 	zone_unlock(z);
-- 
2.49.0

