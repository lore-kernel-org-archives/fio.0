Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EE8C433FE
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiKNCNX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbiKNCNW (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:22 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07472E001
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392001; x=1699928001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ixii7KEu/NzsYFQOPTvg6BQ/iQaq+nOmBln5fxl7xHw=;
  b=Xj0WWWfCjup+Lw8hYqwcn/vvwh1AG3ZfTSQqwfmCG75PcLIyDpJbHdqN
   t5S7U7xehEIfcoeUKNnhJJVoeb5Sw04AB2sjEi6qBPuDOvGVaJ6t5jsE4
   VLJUUPiXLEjvM7+c4Cw5G6Z/ynEGxEWu+TVrCsrLVJd4xKOMQcKoXsQ0h
   cA+qMsUprqZe5aqboav85TRMZLcSObGkPZ3MUKP67CaL6e/7ET8TO8rl3
   lnQ+uCGRKhrMfnyF61/GuYbjwIYKpJgHZBhvjYwiRy1AiUo15T2GflAl+
   ITANVHzFGFBAvbzxIp5v4VdV1sdEJTwGkZCvxll9fomEPER/i2+IcFe1U
   A==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279217"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:16 +0800
IronPort-SDR: qnd+HMJaUf6EMq5g4G72spIvyE+zXUi7SWGlHHMe5Je7/EJ+0tE+SSuUq3ilkScY5k2k5nh2bW
 hKf7/VqRExpwX/wpXEtZxpQ1i+/usbdDVyKeBmRWCe+j5807ksYtDK8MgGtap4CWXqXOJ9Ru8J
 8notZ3br6lWHj70sGaavregmvT+MIwFoRW8acNfuyB+TZr2xSgR5KRj1VVuHoBlMZ3MNa/cze1
 9irViBFDVkhCn9sA8MNKd0QraIHr1borMLnQaO7RqYYE2D13yyGo519fgONsS74BAxsrDemPG/
 4b4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:16 -0800
IronPort-SDR: uNPP+v3A+XNNwaBpeiM6mtDp3d/j7bzik/PKeJOwM3PFmQZXEQfvxEZRQqoWekO2rUUUVklDxe
 V51tYZ4vQiAsyCb9YN6fFiekbAu+eBF297mj7SuIxgujDNH0dJA6n1Oro7qoKDsKdT8BNR1c6f
 Bw0Gqz0X1Gl2wK2CKcf6AKmS8TICnUq0p4r6mKD7GZPg/ZcPTTLlxxKc0ndNEz3eYWZ5yX7gEP
 yYZpi7ktuc68Cku0OwhXTolVVzs1usbosdd5mxKJShPcz0i6G4N8/epIMXQrhyfidcLH9RDOtZ
 FqE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:16 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 03/13] zbd: add zbd_zone_remainder() helper function
Date:   Mon, 14 Nov 2022 11:12:58 +0900
Message-Id: <20221114021308.1684141-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
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

