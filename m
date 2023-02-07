Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BFAC636CC
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBGGhv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBGGhu (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:50 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C8E222F7
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751868; x=1707287868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d4xn1xs8i0daCQ4uQAmX3RkJ42UYFkgsSWaF+P46NAc=;
  b=FpqzQ9owqMaGMX+LSZCH/b3QG70lLtavimM0nwQ1AI8dQ6vuhSQn6kP3
   bS9I+9pIOshnC2kT/1prXOVSxg9+pIMnFmCi6ifC5Eu/mCM2Wy/xBfyf0
   t9UKuTfPsV2PVIzmjdDQEFNfHDJL0yfgAf5ygMhVtTCsK58Q7cstrysyt
   v3JBPnACqJNsPjqFxEPQMbKKlyg1i9JL7AonEvDX/ZY5gtpe4e7wQ3x6l
   q55E/q1zjrl4kkyvPmzgZ2FwihEHyXPC6c7HpaDShzs46/0XSra7s65mS
   QemCpBLRA0o9Hc7MpFN8z0HB3ykuodLOorBHclENa1KeRDDDPLigvuHUu
   w==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982661"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:48 +0800
IronPort-SDR: dXRk3VfKDE/r5vG5kjSt0eU0zYw9EY9f2pyWXW0ERKevU7uTC0ofgjxC+SRPYN9yu4GBhrJb4o
 ZpAYiFCB11CU96QQsHCKmH5aTNCJUw6eXPNC7qTUiwdEcafaVocJ8kd3HcaPUH4bEFx42cuQjQ
 FZafu1YEEQZSL6m+fS01dKR4536DlszlCbZGWZGFZ33y95y+NIUL9FQeGM7sVoqtn/FxTn4z0M
 PfTNAGZIxjWREvponj3z9VFu0tO6F6gz2KgESdXRGQW/wQPB7Glpn3Y//NoUX1AUIFW6htpGMR
 hEM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:55:04 -0800
IronPort-SDR: 4o6RDYuqq+kgQwHdQ4REnQBTXUD13LZIkFbBsCzKSB3t0D9OAgRIZsgOFysywg7ORmNf0X0/cy
 Sb/O6+q+S2hfopJN1DktnxdKoK+AJ5++WCTler89ZAyvl+0Mr1sv+wgr+HVWbOXpK//XSh3jiV
 gtRNnrGJ5uTSyrYLQweHi26ew5wkguvmqfuBAFpbgt8MNVHa56D/dWZMF6CvygVWjLPvOIIFkP
 g28JrNcWlGQvE7F/acm2cX9kNnHYizJIl/5EH8IPBgLUTcCf/ntOrj1zFGlqFYv6QUmQQIqes1
 dRY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:46 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 5/8] zbd: account valid data bytes only for zone_reset_threshold option
Date:   Tue,  7 Feb 2023 15:37:36 +0900
Message-Id: <20230207063739.1661191-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The valid data bytes accounting is used only for zone_reset_threshold
option. Avoid the accounting when the option is not specified.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/zbd.c b/zbd.c
index 455dad53..6783acf9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -147,6 +147,11 @@ zbd_offset_to_zone(const struct fio_file *f,  uint64_t offset)
 	return zbd_get_zone(f, zbd_offset_to_zone_idx(f, offset));
 }
 
+static bool accounting_vdb(struct thread_data *td, const struct fio_file *f)
+{
+	return td->o.zrt.u.f && td_write(td);
+}
+
 /**
  * zbd_get_zoned_model - Get a device zoned model
  * @td: FIO thread data
@@ -285,9 +290,11 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 		break;
 	}
 
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->wp_valid_data_bytes -= data_in_zone;
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	if (accounting_vdb(td, f)) {
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		f->zbd_info->wp_valid_data_bytes -= data_in_zone;
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+	}
 
 	z->wp = z->start;
 
@@ -1195,6 +1202,9 @@ static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t wp_vdb = 0;
 
+	if (!accounting_vdb(td, f))
+		return 0;
+
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
@@ -1605,10 +1615,11 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		 * z->wp > zone_end means that one or more I/O errors
 		 * have occurred.
 		 */
-		pthread_mutex_lock(&zbd_info->mutex);
-		if (z->wp <= zone_end)
+		if (accounting_vdb(td, f) && z->wp <= zone_end) {
+			pthread_mutex_lock(&zbd_info->mutex);
 			zbd_info->wp_valid_data_bytes += zone_end - z->wp;
-		pthread_mutex_unlock(&zbd_info->mutex);
+			pthread_mutex_unlock(&zbd_info->mutex);
+		}
 		z->wp = zone_end;
 		break;
 	default:
-- 
2.38.1

