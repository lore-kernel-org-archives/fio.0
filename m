Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42F2C433FE
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiJUGe1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiJUGe0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:26 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A836587
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334063; x=1697870063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=77363/ZDyukEveeY1AKWXnwZ4xR2QZo8TpdAy0gzAEg=;
  b=rZmiF24NzDm363ukX1lh7zuGW4DGtof4pEXZuvF93CzxNgSS8wI6FPZ4
   rEnIRVHD/rr/WAOYmjI9OAN2aKRw5lwEVOB9BSdJPteI+rqP8ZsdIYewP
   AUmeM+TOnt8Y1qVQM1xUsAU3wLRGPHy13ueQsYav3gm0jpOLQFJ4gzWqi
   YSf6M4vncTCSf3NkvEbCOReQoovZsGkS4No5sDMTWiTpUBJKiHXOByvKg
   fCll/5T+d7hUbf+1toMxjU0e0zKBo013YIHDDmAF+1YSmEDm2Ym0jY8Up
   lCOCaXzImsNSbUwNm7U40d+UY86KEcIhWKvsRZjhCGegegaBG+SVyX1zh
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733103"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:22 +0800
IronPort-SDR: rnszPN0LcvGfezOj29N1sKjMVKeRvg0d+Jkeb2+JfnaVfUEnDKnbfanK648w3vt+qTv3VHBhbU
 oC/uFfP3xHqhLs02mI4EhoGo+CMN+BM/EWJ92ZlDlUDC9jy9Tw5UyvVq4rl7R7ak5cNW9fn+ks
 7KL2889FVaN7tmvPrVPuLwOXEfJrHFFFhx45IwZlQOOqBoji1VEQ5tihSIS4dhgcrB1S68Ulcf
 fUfVb+OjOWU7iQhQvisqqX1uaq4olFiJLkaQTwancWSSKPO2t97cLqPRy7aRtWLlfLgpyv0v6X
 qJjsjpGIJjnXyazgiD2FmzLK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:09 -0700
IronPort-SDR: MRv/fCRXSz1SZFsuofqOUOq6euEaaVU60TB+niseay4piLIZB2aAaUcaC9bss0tsyF5HzdzbhE
 vwIRb9GKXEk8k/GTjENTeHgzl/3pnFPDGSWNrajjfefUkcpuHc/SUaJ0B2hWf5HCLXDBNN+V4E
 THRHi64C7Z3yoxg/+e6vcUVn5A8FEXeTwPHEEDRuPnLnJDLKSPsZpGUZd4nNr35Y3SKsCuY+9p
 78c7PIakLQ0dHUJxFFf8Fa2cjG6MSzLB25SBrp5pUAuMz6IBg+5Eo/o4PaiKgO9eESQM7BBwf+
 Qyc=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:21 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 03/11] zbd: finish zones with remainder smaller than minimum write block size
Date:   Fri, 21 Oct 2022 15:34:08 +0900
Message-Id: <20221021063416.860438-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When zonemode is zbd and block size is not divisor of zone size, write
target zone selection does not work as expected. When the write is
random write and the device has max open zone limit, the random write is
repeated to the zones selected up to the max open zone limit. All writes
are repeated only to the zones. When the write is sequential write,
write is done only for the first zone. The cause of such unexpected zone
selection is current write target zone selection logic. It selects write
target zones within open zones. When block size is not divisor of zone
size, the selected open zone has only remainder of writable blocks
smaller than the block size. Fio reset such zone after zone selection
and continue writing to it. This zone reset is required not to exceed
the limit of max_open_zones option or max_active_zone limit of the zoned
device, but it does not simulate the workload.

To avoid the zone reset and unexpected write to same zone, fix write
target zone handling of zones with remainder smaller than write block
size. Do not reset but finish such zone not to exceed the max_open_zones
option and max_active_zone limit. Then choose the next to the finished
zone as the write target. To implement this, add helper functions
zbd_zone_remainder_not_writable() and zbd_finish_zone().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/zbd.c b/zbd.c
index 627fb968..55c5c751 100644
--- a/zbd.c
+++ b/zbd.c
@@ -70,6 +70,15 @@ static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info *z)
 	return z->start + z->capacity;
 }
 
+/**
+ * zbd_zone_remainder - Return bytes can be written to the zone.
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_remainder(struct fio_zone_info *z)
+{
+	return zbd_zone_capacity_end(z) - z->wp;
+}
+
 /**
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
  * @f: file pointer.
@@ -322,6 +331,44 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 	z->open = 0;
 }
 
+/**
+ * zbd_finish_zone - finish the specified zone
+ * @td: FIO thread data.
+ * @f: FIO file for which to finish a zone
+ * @z: Zone to finish.
+ *
+ * Finish the zone at @offset with open or close status.
+ */
+static int zbd_finish_zone(struct thread_data *td, struct fio_file *f,
+			   struct fio_zone_info *z)
+{
+	uint64_t offset = z->start;
+	uint64_t length = f->zbd_info->zone_size;
+	int ret = 0;
+
+	switch (f->zbd_info->model) {
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		if (td->io_ops && td->io_ops->finish_zone)
+			ret = td->io_ops->finish_zone(td, f, offset, length);
+		else
+			ret = blkzoned_finish_zone(td, f, offset, length);
+		break;
+	default:
+		break;
+	}
+
+	if (ret < 0) {
+		td_verror(td, errno, "finish zone failed");
+		log_err("%s: finish zone at sector %"PRIu64" failed (%d).\n",
+			f->file_name, offset >> 9, errno);
+	} else {
+		z->wp = (z+1)->start;
+	}
+
+	return ret;
+}
+
 /**
  * zbd_reset_zones - Reset a range of zones.
  * @td: fio thread data.
@@ -1941,6 +1988,33 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto eof;
 		}
 
+retry:
+		if (zbd_zone_remainder(zb) > 0 &&
+		    zbd_zone_remainder(zb) < min_bs) {
+			pthread_mutex_lock(&f->zbd_info->mutex);
+			zbd_close_zone(td, f, zb);
+			pthread_mutex_unlock(&f->zbd_info->mutex);
+			dprint(FD_ZBD,
+			       "%s: finish zone %d\n",
+			       f->file_name, zbd_zone_idx(f, zb));
+			io_u_quiesce(td);
+			zbd_finish_zone(td, f, zb);
+			if (zbd_zone_idx(f, zb) + 1 >= f->max_zone) {
+				if (!td_random(td))
+					goto eof;
+			}
+			zone_unlock(zb);
+
+			/* choose next zone with write pointer */
+			do {
+				zb++;
+				if (zbd_zone_idx(f, zb) >= f->max_zone)
+					zb = zbd_get_zone(f, f->min_zone);
+			} while (!zb->has_wp);
+
+			zone_lock(td, f, zb);
+		}
+
 		if (!zbd_open_zone(td, f, zb)) {
 			zone_unlock(zb);
 			zb = zbd_convert_to_open_zone(td, io_u);
@@ -1951,6 +2025,10 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			}
 		}
 
+		if (zbd_zone_remainder(zb) > 0 &&
+		    zbd_zone_remainder(zb) < min_bs)
+			goto retry;
+
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
 			if (zbdi->wp_sectors_with_data >= f->io_size * td->o.zrt.u.f &&
-- 
2.37.1

