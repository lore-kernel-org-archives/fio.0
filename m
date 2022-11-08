Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D7EC4332F
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiKHIts (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiKHItr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:47 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F692E684
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897386; x=1699433386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ixii7KEu/NzsYFQOPTvg6BQ/iQaq+nOmBln5fxl7xHw=;
  b=FxijTDBDdIXDK46Xe+IjECuWLgd18Lhp34O3JNWwXBJO+L8nmgUWsxXX
   U25mlVafVjoNI93vFs0nfRFC2oArodsPn+tQK0OCphRSMTIwkBJcKNMOc
   dVaXD3jnouQU3b2nXYZDGKZ8xFvntzLBTQ+pFluSJR2paqKRmaJiqXOTR
   wz5sYYACLw7nCPB2Oo+4ZlBfRtwopO4yCvfE1RiqeqtPsjA10Pb2zegzO
   8bBqh1V5Dsub86evAPHwzR/88yc6Q4zkaBLn3/hn8iQF6CWEzB34H0rNs
   O+803cKM+nkGV7YBTyf4Vra8rmyESC/wSlgfqCx/6A+I7A7s5c3CntpTR
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="320079427"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:46 +0800
IronPort-SDR: R+Q38AC73FVAickc4wmX1Mk9+5Lz38x+jYjmvd3iwuNU3tYyJMWK8GbWi53T9IS3Kka3zze20X
 I3tqfq/0UyIAavmzoKeaCJr5ly1UF36xcy+aKf/RPBapEmL6SVFZ9BwfGNEsu89QJJinbq1axD
 HuAEzVt5WqZhCcuoE2qQIiMpWwUDxA3V8aRwWIqtCCU64vRXF/2Oqo021cLQHvKjVqeHcntFHV
 muICEzlPH9BzObKYazaBzlCPnkxGLOgg3BDJcTNbvuT3EoFEYRyzs+b1L4ljVgFlNERx0oVpvR
 U5o=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:07 -0800
IronPort-SDR: EZpqcXmiPHF57rqCf2VdBNYd7+OzJZtI1z37p35qwO4yS41eTfYbkVBZ9g+RFiJkLRiRQkl8nU
 cE2V91rA6rBv2CH2QrCrcc+QuQsac/mRc6O0WI8pHH3Jz4I27tsuyMmAFbKVow24XfpnixS/CQ
 1GtRbWvx5l3W80aHZEBrQjqiRu13zBHVLvRqqDGktuSgFju7rK1SOUOS7eO89jwVBXDEn6hcdO
 gk97jcNV74SQsRt1j5u45hbu7mbJFMJziDMZHsQG/RukU1GHmZrJa7hIpWQTJDUnl0uMHrCfJK
 qtw=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:45 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 03/13] zbd: add zbd_zone_remainder() helper function
Date:   Tue,  8 Nov 2022 17:49:30 +0900
Message-Id: <20221108084940.1574939-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add the helper function zbd_zone_remainder(), which returns the number
of bytes that are still available for writing before the zone gets full.
Use this function to improve readability. It will also be used in the
following patch.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/zbd.c b/zbd.c
index 627fb968..26a6404d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -70,6 +70,19 @@ static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info *z)
 	return z->start + z->capacity;
 }
 
+/**
+ * zbd_zone_remainder - Return the number of bytes that are still available for
+ *                      writing before the zone gets full
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
@@ -83,8 +96,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 {
 	assert((required & 511) == 0);
 
-	return z->has_wp &&
-		z->wp + required > zbd_zone_capacity_end(z);
+	return z->has_wp && required > zbd_zone_remainder(z);
 }
 
 static void zone_lock(struct thread_data *td, const struct fio_file *f,
@@ -440,7 +452,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 		 * already in-flight, handle it as a full zone instead of an
 		 * open zone.
 		 */
-		if (z->wp >= zbd_zone_capacity_end(z))
+		if (!zbd_zone_remainder(z))
 			res = false;
 		goto out;
 	}
@@ -1368,7 +1380,7 @@ found_candidate_zone:
 	/* Both z->mutex and zbdi->mutex are held. */
 
 examine_zone:
-	if (z->wp + min_bs <= zbd_zone_capacity_end(z)) {
+	if (zbd_zone_remainder(z) >= min_bs) {
 		pthread_mutex_unlock(&zbdi->mutex);
 		goto out;
 	}
@@ -1433,7 +1445,7 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
+		if (zbd_zone_remainder(z) >= min_bs)
 			goto out;
 		pthread_mutex_lock(&zbdi->mutex);
 	}
-- 
2.37.1

