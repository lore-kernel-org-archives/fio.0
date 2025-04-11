Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDC1221299
	for <fio@vger.kernel.org>; Fri, 11 Apr 2025 11:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369945; cv=none; b=EJcuVojOaMnmFV2o63yVEVYF3q8inaN7l02kXrrmiZOtNQIzBO7H5YNfL9FHPMdMAtqh0gq4umxtmpJyY26tpM8R8p4fAs5n5xUWlFeWXAQQ2nXajDUKFVy6f9jhLQw8c6FHNQ/7/38lqRKcvbupBoOtj4bm7qrmZ4n+XZCPur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369945; c=relaxed/simple;
	bh=Ws3Ub/Ba5uyJvTf1T4K661gJuYhUkzrqg4nJ2LQNAs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufd0AYah/LuSHlDS1NirZfYRbrZCLuMk1HUELBR2HlMIgWWNTd9ZCJx0MxFQV7HhTr8+fsyp5LpgtbcZPyhp1Y9b03rGTNKUaKLeTvIz1jDfN42vjZAO2nNuc8lcU8qVG5swxkI266I4th/h++RnDgdUGwW5cxJ8hRUmKB4Xhs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iQEaZOhu; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iQEaZOhu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744369944; x=1775905944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ws3Ub/Ba5uyJvTf1T4K661gJuYhUkzrqg4nJ2LQNAs8=;
  b=iQEaZOhuWewDNUcfvSEIAv8hRGihgQwf1bQTiQNyUQFq8jO0cwd9/P8K
   +/BVkVeceXLgCP12o4bNmQxjWyVZp85DXYn8/xbulHHoqBD/EBu6E5TzR
   tycWsINeHIEQk2m8GP8qwrbA1Pqf/xjFvC34WZxuzZMVJNG4Hp56WIuLE
   2UY8Lqpaqhf2E/tgdCqvEuBrBpReXl6KI5EmjRsDUPOih4PRQx1q5+6OA
   TBNr+PZ18DPDnHIX6OKNW23PT79hdnns+SY/xRdN17WqIsMcfLqeq4OV9
   2yWAQ7G1J0N2OfmJ2XZZx9wE/8O366WpCvMmPhTAQV8rgP/NDCgUK9uNP
   A==;
X-CSE-ConnectionGUID: KEBsfybKSeajmlpwJAIzHg==
X-CSE-MsgGUID: 6RGPeT9URFGDTPmv2UBuHw==
X-IronPort-AV: E=Sophos;i="6.15,205,1739808000"; 
   d="scan'208";a="81898584"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2025 19:12:23 +0800
IronPort-SDR: 67f8eb10_m5Y5HzUG5nV9tBoIy83Bw1+jQTcXzT7g8E2n3u5xckakfVO
 rfkixZxo2Dwbmk+3DnGPJR4PdD7P3GcbHSPNHjg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Apr 2025 03:12:33 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Apr 2025 04:12:21 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/4] zbd: factor out zbd_pick_write_zone()
Date: Fri, 11 Apr 2025 20:12:17 +0900
Message-ID: <20250411111219.57424-3-shinichiro.kawasaki@wdc.com>
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

To prepare for the following fix, factor out a part of
zbd_convert_to_write_zone() to the new function zbd_pick_write_zone().
This function chooses a zone from the current write target zones
randomly.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 81 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/zbd.c b/zbd.c
index 5e0f7f4e..23c18bd3 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1386,6 +1386,43 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
 		f->zbd_info->num_write_zones / f->io_size;
 }
 
+/*
+ * Choose a zone from the current write target zones randomly, which is in the
+ * range of the given f. If such a zone is found, set its index in
+ * f->zbd_info->zone_info[], and return true. Otherwise, return false.
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

