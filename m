Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38A51A5B8B
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 06:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744612047; cv=none; b=PTR0wGT/hJgvjRBNgem9Ecs3U8cW/7aIbvZZ2jUvxDAUChl/NcImptMuYVlXsT8v8VyL/2Iii1J+tz4JfzIlrhk1V37q5Fbyrn1C99j1Bs0Pd4syk3QqwriS8RAcjNH/rbJ2hnAicNg3k4WOZiiOE/KqzUDdBzK+GgESiSohRe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744612047; c=relaxed/simple;
	bh=s6wAeuRY2kfgL0iwFyxQeG68KF1sWntnT/x97t1C1dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4Fsq/9KaLdV/S1Hv2GOamZI9nKfFYsBhdUQ+YcTbhRlQeYA/gCu30ga4FhXgcKfx358PDLwYnLEX02/PBI7skpMMLKvL9zcGwAfNUMJ3KR7yOJNy6PUKXKJvNkF4/RrzeLLABS+ybZkqEj03KhW1eMEx+iR7MGXYxZMfpE4E8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=b/wCGMEB; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="b/wCGMEB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744612046; x=1776148046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s6wAeuRY2kfgL0iwFyxQeG68KF1sWntnT/x97t1C1dI=;
  b=b/wCGMEBtpBgS85loio38kfOOx1hilKGaGvkuj+h8jNS6fJ/VEFF536V
   gLJnRksP5Z/FUB8P+i7kyGQZTxQK32MfJgHO4/5/i6Uh5hsQCAwhqA28c
   yLWdAABaem0Ev34wQCd2/YlR/eVAKe9KsqKLJT1I06RMW6S7e9/lQorfj
   202nxJJple/Z7glqSejBdBk809EsJn6iaVnI+Ul7IcWoHIkDnM2X9pt1R
   dXvKzpMn1qI9rPtZPafLqiSwjzpFu81Fk7aL2Jw16YW1Qc5LVI1TV5Set
   /TUWC7XcpVES0q4BSq0AW7Tfb7MDAZl53nDjrKWvrK8Iw50Z0I4jNoL2O
   g==;
X-CSE-ConnectionGUID: 3ZmUocsJRr2LHomFZK+AKg==
X-CSE-MsgGUID: 1wBlDrMbTuiHhlMz8m+1bA==
X-IronPort-AV: E=Sophos;i="6.15,211,1739808000"; 
   d="scan'208";a="78068687"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2025 14:27:25 +0800
IronPort-SDR: 67fc9cc3_GjashYnUzCfFXOtRxmLBVTYtUFRg1NT1Eosk8GdYW+KP/DS
 Wrigszvufa+jq5/1yAo5DvfMAPH9BLBN7F4hsXw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2025 22:27:31 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Apr 2025 23:27:24 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/4] zbd: factor out zbd_pick_write_zone()
Date: Mon, 14 Apr 2025 15:27:19 +0900
Message-ID: <20250414062721.87641-3-shinichiro.kawasaki@wdc.com>
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

To prepare for the following fix, factor out a part of
zbd_convert_to_write_zone() to the new function zbd_pick_write_zone().
This function randomly chooses a zone in the array of write zones.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 zbd.c | 81 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/zbd.c b/zbd.c
index ac65640b..d547bf3b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1386,6 +1386,43 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
 		f->zbd_info->num_write_zones / f->io_size;
 }
 
+/*
+ * Randomly choose a zone in the array of write zones and in the range for the
+ * file f. If such a zone is found, return its index in f->zbd_info->zone_info[]
+ * using @zone_idx, and return true. Otherwise, return false.
+ *
+ * Caller must hold f->zbd_info->mutex.
+ */
+static bool zbd_pick_write_zone(const struct fio_file* f,
+				const struct io_u *io_u, uint32_t *zone_idx)
+{
+	struct zoned_block_device_info *zbdi = f->zbd_info;
+	uint32_t write_zone_idx;
+	uint32_t cur_zone_idx;
+	int i;
+
+	/*
+	 * An array of write target zones is per-device, shared across all jobs.
+	 * Start with quasi-random candidate zone. Ignore zones which do not
+	 * belong to offset/size range of the current job.
+	 */
+	write_zone_idx = pick_random_zone_idx(f, io_u);
+	assert(!write_zone_idx || write_zone_idx < zbdi->num_write_zones);
+
+	for (i = 0; i < zbdi->num_write_zones; i++) {
+		if (write_zone_idx >= zbdi->num_write_zones)
+			write_zone_idx = 0;
+		cur_zone_idx = zbdi->write_zones[write_zone_idx];
+		if (f->min_zone <= cur_zone_idx && cur_zone_idx < f->max_zone) {
+			*zone_idx = cur_zone_idx;
+			return true;
+		}
+		write_zone_idx++;
+	}
+
+	return false;
+}
+
 static bool any_io_in_flight(void)
 {
 	for_each_td(td) {
@@ -1418,7 +1455,6 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z;
-	unsigned int write_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
 	bool wait_zone_write;
@@ -1480,8 +1516,6 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	 * has been obtained. Hence the loop.
 	 */
 	for (;;) {
-		uint32_t tmp_idx;
-
 		z = zbd_get_zone(f, zone_idx);
 		if (z->has_wp)
 			zone_lock(td, f, z);
@@ -1500,42 +1534,15 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 			}
 		}
 
-		/*
-		 * Array of write target zones is per-device, shared across all
-		 * threads. Start with quasi-random candidate zone. Ignore
-		 * zones which don't belong to thread's offset/size area.
-		 */
-		write_zone_idx = pick_random_zone_idx(f, io_u);
-		assert(!write_zone_idx ||
-		       write_zone_idx < zbdi->num_write_zones);
-		tmp_idx = write_zone_idx;
-
-		for (i = 0; i < zbdi->num_write_zones; i++) {
-			uint32_t tmpz;
-
-			if (tmp_idx >= zbdi->num_write_zones)
-				tmp_idx = 0;
-			tmpz = zbdi->write_zones[tmp_idx];
-			if (f->min_zone <= tmpz && tmpz < f->max_zone) {
-				write_zone_idx = tmp_idx;
-				goto found_candidate_zone;
-			}
-
-			tmp_idx++;
+		if (!zbd_pick_write_zone(f, io_u, &new_zone_idx)) {
+			dprint(FD_ZBD, "%s(%s): no candidate zone\n",
+			       __func__, f->file_name);
+			pthread_mutex_unlock(&zbdi->mutex);
+			if (z->has_wp)
+				zone_unlock(z);
+			return NULL;
 		}
 
-		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
-			__func__, f->file_name);
-
-		pthread_mutex_unlock(&zbdi->mutex);
-
-		if (z->has_wp)
-			zone_unlock(z);
-
-		return NULL;
-
-found_candidate_zone:
-		new_zone_idx = zbdi->write_zones[write_zone_idx];
 		if (new_zone_idx == zone_idx)
 			break;
 		zone_idx = new_zone_idx;
-- 
2.49.0

