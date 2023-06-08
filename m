Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DFEC7EE2E
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 07:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbjFHHGU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 03:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbjFHHGS (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 03:06:18 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511371FDC
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 00:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686207977; x=1717743977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U1NivvjyfIghgxoQbX1Ymnl/w3kAqDszbT8VODzTmuE=;
  b=b/3l+V8pTztP02jmfS0tkzgpHnCuqdLysj+g56JqD0joUSEJPzArrBFT
   M7zlDkMOqPboYY8L1/As4YUVEC8Wl068LNAye4xOZk1g8lR4F14hFURRr
   +dSZsFeti+vAxYjX0vqWvKrluq0OQm8vwIZiN6wbm+oO+nGVXoxKb8kbh
   b8XhN/BH5Xy2kkC2uRPZNLg7R19kDbFV4zKmqj8fUOzDcERlHypRRDonL
   OjpHXZMAsqTipVzb0vTbPh2qtjjfcHJRJAFpS1Vg4ibC43StMEZxImqbt
   KjwgHt34BHhwebrazMIdufyNSY247UAPn9svRzATAhvLjFrR2y3frXThZ
   g==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="231238451"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 15:06:15 +0800
IronPort-SDR: oBUdwXZ/ywI8Fl+jsP+vGaPkO1uO2uFpPLIswd6y/3tAMUYlU3vJeLpmlli2+tIJjufU+F6pyg
 6qSqE+tpYJn269DMCtYVVpWfjq5ULezUh1Nj9ZJYvxhv1f/EipwFC8IT2gcqfESZGKbd3vvz6l
 7mOCE8ktDcMYDLjoF0zeuZv8W20pV52mXQACXSr0OBMLjLJrNzMDN+lpz+Jk+5UcX23MJp2YYR
 ehx67YjKT0+YJIw+xA275wKwjTgHzwt6hcXG0C5syEtadJ2v7WEUEJWB9Lx0VMOmIbHgGmX5Vw
 Zp0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 23:15:17 -0700
IronPort-SDR: VZj2EdO/dyE7CyXlM1lZL/1r0ABc02dfsJdlfp2avzXnX8/mXuNRCjUtiwiDtcNhcxPnWrGuPs
 7gFdNmbr4tN8AUCbcg1qOlxdVQt0guiQtTI2akjDrzBRx5vHdZ4Lr+n4BP5nVj5dFqiKyG6DAE
 XKOAxmxSK4hiKXEk/YucrcTF7e0qymXzMRzXbvs9TsizjllgSiE/3igs+vov+ywTKZDTZum171
 zLyC4MwwkkviBh3NBjuMnInOsC2ltxc4l5hIi3EH4noaL3n6u0UfmUaFlBe/9y3CC0WTm4LPJx
 ckg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jun 2023 00:06:14 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 3/7] zbd: fix write zone accounting of almost full zones
Date:   Thu,  8 Jun 2023 16:06:04 +0900
Message-Id: <20230608070608.1256970-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

For zonemode=zbd, fio checks condition of each zone and account it as
write target zone if it has open condition. However, when such a zone in
open condition is almost full and its remainder area for write is
smaller than the block size, fio does not handle it as a write target
zone. This causes difference between open zones accounting on the device
and write target zones accounting by fio. It results in unexpected
max_open_zones limit failure.

Avoid the zone accounting difference by handling the almost full zones
as write target zones at fio start. Introduce the helper function
__zbd_write_zone_get() which does same operation as zbd_write_zone_get()
except the check for the almost full zones. At fio start, call
__zbd_write_zone_get() so that almost full zones are added to write
target zones. During fio workload run, call zbd_write_zone_get() so that
the almost full zones are not chosen for write target.

Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/zbd.c b/zbd.c
index 832868cb..36b68d62 100644
--- a/zbd.c
+++ b/zbd.c
@@ -450,21 +450,19 @@ static int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 }
 
 /**
- * zbd_write_zone_get - Add a zone to the array of write zones.
+ * __zbd_write_zone_get - Add a zone to the array of write zones.
  * @td: fio thread data.
  * @f: fio file that has the write zones array to add.
  * @zone_idx: Index of the zone to add.
  *
- * Add a ZBD zone to write target zones array, if it is not yet added. Returns
- * true if either the zone was already added or if the zone was successfully
- * added to the array without exceeding the maximum number of write zones.
- * Returns false if the zone was not already added and addition of the zone
- * would cause the zone limit to be exceeded.
+ * Do same operation as @zbd_write_zone_get, except it adds the zone at
+ * @zone_idx to write target zones array even when it does not have remainder
+ * space to write one block.
  */
-static bool zbd_write_zone_get(struct thread_data *td, const struct fio_file *f,
-			       struct fio_zone_info *z)
+static bool __zbd_write_zone_get(struct thread_data *td,
+				 const struct fio_file *f,
+				 struct fio_zone_info *z)
 {
-	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	uint32_t zone_idx = zbd_zone_idx(f, z);
 	bool res = true;
@@ -476,7 +474,7 @@ static bool zbd_write_zone_get(struct thread_data *td, const struct fio_file *f,
 	 * Skip full zones with data verification enabled because resetting a
 	 * zone causes data loss and hence causes verification to fail.
 	 */
-	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+	if (td->o.verify != VERIFY_NONE && zbd_zone_remainder(z) == 0)
 		return false;
 
 	/*
@@ -521,6 +519,33 @@ out:
 	return res;
 }
 
+/**
+ * zbd_write_zone_get - Add a zone to the array of write zones.
+ * @td: fio thread data.
+ * @f: fio file that has the open zones to add.
+ * @zone_idx: Index of the zone to add.
+ *
+ * Add a ZBD zone to write target zones array, if it is not yet added. Returns
+ * true if either the zone was already added or if the zone was successfully
+ * added to the array without exceeding the maximum number of write zones.
+ * Returns false if the zone was not already added and addition of the zone
+ * would cause the zone limit to be exceeded.
+ */
+static bool zbd_write_zone_get(struct thread_data *td, const struct fio_file *f,
+			       struct fio_zone_info *z)
+{
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
+
+	/*
+	 * Skip full zones with data verification enabled because resetting a
+	 * zone causes data loss and hence causes verification to fail.
+	 */
+	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+		return false;
+
+	return __zbd_write_zone_get(td, f, z);
+}
+
 /* Verify whether direct I/O is used for all host-managed zoned block drives. */
 static bool zbd_using_direct_io(void)
 {
@@ -1202,7 +1227,7 @@ int zbd_setup_files(struct thread_data *td)
 			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
 			    z->cond != ZBD_ZONE_COND_EXP_OPEN)
 				continue;
-			if (zbd_write_zone_get(td, f, z))
+			if (__zbd_write_zone_get(td, f, z))
 				continue;
 			/*
 			 * If the number of open zones exceeds specified limits,
-- 
2.40.1

