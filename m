Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D811C38A2D
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiJ0GC6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbiJ0GCZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:02:25 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA36C7B58F
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850530; x=1698386530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EApRTPRV06eRhm+H4XD30DUVom2xcrTuw9Cn4lsH0WI=;
  b=adCXPwUdIXSHAwdMRfLK6CzrrOKuEeMEXWBQe57/AP+VzQc6u4/TVHzd
   yiZLf4queEHCRZ+zxSjezoyrfYjDtv8FB/AU4FmLq788Olg+uJen9KaxZ
   sMWpXog2DPc16EL/1cVRatdnY7zN9WLh7fNgt0mDSU1ZeX8J/dE7ZcqLt
   LF0H/A/2gd5cvFY8b2ZJgiUGF/nn30MYnB4vsQ+tL88JisVt0EHytHR+i
   H94tdCjK33K9m9kpvpKKGBwo05IMgkqvgkVUnoT/m5g69vaNFhI9FgopT
   NJq04go7zaPU4ha4VSo0J6wId7PHM619S88psOjqYSjLvlqJ5NR1KPRTK
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="326954552"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:46 +0800
IronPort-SDR: JdMT0OgNbcaNUJ8RjrVPc/cih6x3JQYiW8/qxYItY8Vo9skrHNjF7vOWfisKj1ggMKsq3mPk8Z
 YbtNrnzOFNC4iJpaFlj8RLg6GXr4zEKPYHTYB0aJUYP7wp68np+COxNsAUO0BZv+F+1oZfV2Jn
 dRX+zp6S1RENdN+npG/7bdDDn8cAFehs3UzKeWxAwf9CWHvGvx9eyS/zw6Pn6uSWTpO0FGo2qB
 FLPzbZy1wWiURr0xjw7AEKwTTD1vfG1zfM58gej/2iX6kHkeRkUiQdLs+8akSSdm1rItCCPM22
 xavhC3Ctr6ApX2NwZF6pX4O+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:23 -0700
IronPort-SDR: +WEDjxN/nuGbVbfK1Tiw8vRLsLlBBdi6VGVF9XKo8UOQplC1E3oXP63HDIVa1Z13PT+IJi7vZR
 npokpJ6HZzdFfvge7F/gwIL294tZztarrm9E8kh0vOThpNrxivHkyJ7WHzQI96+9oRFglX53pK
 7S/h9EOOHxhPCMYRVmWOk/lB5EyRtglL9WZYX5eYmakpD4Ks+zjbQCccOwrLOlW/O+aDpAZqIy
 j2e8Kd7mkhTWUpv3/9DMiyhxbizANRvsPMLjYwfQmfzOC2Qa0yx7TvhY7inPuPRnEjwUEbgNw1
 f+k=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:44 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 03/13] zbd: add zbd_zone_remainder() helper function
Date:   Thu, 27 Oct 2022 15:01:29 +0900
Message-Id: <20221027060139.952508-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add the helper function zbd_zone_remainder(), which returns bytes can be
written to the zone. Use this function to improve readability. It will
also be used in the following patch.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/zbd.c b/zbd.c
index 627fb968..3e9c66d9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -70,6 +70,18 @@ static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info *z)
 	return z->start + z->capacity;
 }
 
+/**
+ * zbd_zone_remainder - Return bytes can be written to the zone.
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_remainder(struct fio_zone_info *z)
+{
+	if (z->wp >= zbd_zone_capacity_end(z))
+		return 0;
+
+	return zbd_zone_capacity_end(z) - z->wp;
+}
+
 /**
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
  * @f: file pointer.
@@ -83,8 +95,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 {
 	assert((required & 511) == 0);
 
-	return z->has_wp &&
-		z->wp + required > zbd_zone_capacity_end(z);
+	return z->has_wp && required > zbd_zone_remainder(z);
 }
 
 static void zone_lock(struct thread_data *td, const struct fio_file *f,
@@ -440,7 +451,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 		 * already in-flight, handle it as a full zone instead of an
 		 * open zone.
 		 */
-		if (z->wp >= zbd_zone_capacity_end(z))
+		if (!zbd_zone_remainder(z))
 			res = false;
 		goto out;
 	}
@@ -1368,7 +1379,7 @@ found_candidate_zone:
 	/* Both z->mutex and zbdi->mutex are held. */
 
 examine_zone:
-	if (z->wp + min_bs <= zbd_zone_capacity_end(z)) {
+	if (zbd_zone_remainder(z) >= min_bs) {
 		pthread_mutex_unlock(&zbdi->mutex);
 		goto out;
 	}
@@ -1433,7 +1444,7 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
+		if (zbd_zone_remainder(z) >= min_bs)
 			goto out;
 		pthread_mutex_lock(&zbdi->mutex);
 	}
-- 
2.37.1

