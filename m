Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEDCECAAA1
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJ1LyE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJ1LyB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:01 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE72E1D2F44
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958040; x=1698494040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ixii7KEu/NzsYFQOPTvg6BQ/iQaq+nOmBln5fxl7xHw=;
  b=ZWsNr/1vYv1bKWM0OpczsB59sPJyTlFhGgOBM//6suggUE0CK427zjBP
   ZR6j+VzVRPt0WnFiMTP8InBmXpAsNbdf8a8DM3ryWsl5xxih/dGu2aAgY
   zndo+5l1gc/+3YueQn6bF6dJBM3RHWKrzN3jvxaCoNU5T0r+qUPxOcrjB
   0IJybIZwb9gEI7R/kbzAl6pZO2slLLx6Lfx91EerPo+hBkY7/GkoMFO8k
   y2cW7dmaJKKLqfo2Sdd5pO3iusbdrVx/o9trpQ6+bu58zfQlPVFMpUTYC
   iIiGkVPd9aSDPXo2T+6TknIe2EnU90VsyQzabJbx1B/i/Ze4kevbaclIt
   A==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074524"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:00 +0800
IronPort-SDR: ToiPqlfwNRWBz0/v9BflUIYWaChFySieUBXaIBZR23nMyLsRlW/i0X8MbqCTyRDLeWJzehgpDn
 EOnBL2ogZFud/cTMTeUpUj2qmNx8osNrt5R72yChxJEhSoqFyFMGwfUrjUIk0Qp0Jd5Hog9jkf
 HYTEZyFZdTwE7KQh840Y+/aESWh3EnTIOx6KeXlRLZrGtK+stnajTQaufjxgB51VNMBvITJp4x
 5knBkf/Rcfwan43QiBwvLtgiNdsfH1filyL2Y3GBFd+eCnfrP23VZCw1TdlSzBDR6CtxiZNv2Q
 woiPlhv7DWqpTT3B0VO6scOf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:36 -0700
IronPort-SDR: BIu5DknEyyurJSYheJSKwJ6mbkLKTOR5S/2bThunopkFpMIKP/fJ68c/h5AqN6o14v/3SB+el5
 aohvEOq64R/nVgEsZR2+ZyZ/KVG9mpEUvTbUXJ75hVC9r4fJb8qQUCuaqsE5igSHbg7Reu2KIK
 l86cYZfQxuIj/QtzsVYz+yYEgS4BfnUvE/2BnRW5F4CCi3kX/XmtfyfRZlFks0ImbWco5jCbC8
 bF4V1gPynkzx7Cf55tyRhmHFWVxgnHudRH2/8uMX6sIAwHaVzcSvM1koX9NtFiy7zgTxfjfzzI
 1r8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:53:59 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 03/13] zbd: add zbd_zone_remainder() helper function
Date:   Fri, 28 Oct 2022 20:53:44 +0900
Message-Id: <20221028115354.971715-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
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

