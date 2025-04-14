Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F281A9B3D
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 06:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744612048; cv=none; b=eCvUHLwad7Uyts86RkX2LZ4ig1TozFlfDZ+pM99nU8vrv7jiCFBJNsDY87O/tNLlZ6dFm1C13D2Wnj1no9LV27H2os2r+Zg2m/FFdoMEdkk5cu71dWhVNa1MNh30TfZBuaP/us6gaj0bb4q+YYmEAQjjYTWLRq05HvqTI0/Pbss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744612048; c=relaxed/simple;
	bh=xMsxB3Ztoo6oweTsEagSTPeRcKKnLfsjYIqpa4QCDIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffxDFpO9254fpVYVOTzJt7dKiVqcsXzPsgxnFjng+5FUZwKUdmSobj3pZ0x6bc55HEo+1xKJL7gQaa+jYk5VI6ka3Dfm6a3TmMVm55vHkGuP+ciEfnl2fCaYcmtyPXdrgpy6qPzmUF70Yl0DS4PEoE/a8JhX5j6WqAe0q+lONGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QxVbwX9K; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QxVbwX9K"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744612047; x=1776148047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xMsxB3Ztoo6oweTsEagSTPeRcKKnLfsjYIqpa4QCDIo=;
  b=QxVbwX9KVKIpYiUaEh5lO9K6hOCs3Bs64kO6qUzc6tuHyuCQzQAPRaDG
   HfIbOFGU23W4fR9xWfyI6Pc4DKnA71G5UZzctKUQziBNE3IYikrK1hzY2
   GVZGIZfpjNqSQgQnEzGpW+beiNO1dWTNAcQWWGXKX8d/uhFPszD0KLhK1
   Bc3bcYnygm0h/BRjdrQ70BdQVEtFGLakof4IlCVsw8Czyqm/XadjpIPuX
   33NbeLTJYz8lPsrwgo7NOxRm+XWiEyvPieGGq75EMugdN4TQsAV5yH45v
   MvUC+QK1A8HuQC2e9yUigArJQ+Te4pQhxEtkaBzN5+w2cMheiIFMLtsjT
   g==;
X-CSE-ConnectionGUID: fHJ0LZBhQHWCqdCH6/V3nQ==
X-CSE-MsgGUID: HwYxjpAURvi9/hcKXzymTw==
X-IronPort-AV: E=Sophos;i="6.15,211,1739808000"; 
   d="scan'208";a="78068692"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2025 14:27:26 +0800
IronPort-SDR: 67fc9cc4_k+uxDmzt+YNlJVFgbhTMKLb/OWEFo5aN+KC3sUPpQ7fMFny
 mxBVe6LlvLypF6ZlvO43UAg+6XtswrjtGpVZTdg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2025 22:27:32 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Apr 2025 23:27:25 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 3/4] zbd: finish zone when all random write target zones have small remainder
Date: Mon, 14 Apr 2025 15:27:20 +0900
Message-ID: <20250414062721.87641-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
References: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 zbd.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index d547bf3b..89519234 100644
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

