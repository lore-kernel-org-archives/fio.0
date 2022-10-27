Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93464C67871
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiJ0GBv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbiJ0GBs (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:01:48 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A477A51D
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850507; x=1698386507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BADSOeESf4EaPb9HvdjRUfFjPuw8gIddkqc9QTP+MdA=;
  b=NGljGnM40zUdFtfJtzn55mPrYbeplDQL8we/Tl7nixQMUM+QbTGCCiXp
   kKLrcfGPzGoOAMZAEHsgB3kN6Bepyy7H3gFr/Ml7js8FnCemxPYnXG6WI
   VU8mq7lo3FdXPCa0sE0DaKY8vd4njYRt8vg5ImJ120VpYANU8WI1UTi2d
   pfG0N9r5wA4Na8sEEchoR0IPl/Gc4NbC9MFxuwET7JhQa9Sim0pGlCwvC
   r92fmjBm1zs+voSovmmgfhkEPCCHnVIAXY9HeNQQEAN8bnMoBz2miv/Ky
   avjcY1nBEKMRyJ/nrW8rcQgweiLs7ebneEqxxnha5GjOeT+vG4B/Wwfbz
   w==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="214845842"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:46 +0800
IronPort-SDR: 5asnpFQ97qiHPDkm8538I60M3ADo6YaPbhJ2Dn771hTGTGIBP2Y3W5gRHYaBeBaXci8b2nBf8d
 WNHwooEzgaGnjLfWoUY24a9X4uI+LIg1FEKnBxfgSzQ0mRmWUGBVE8592UXxhXxL1ecyr/NcDm
 qX6IedQXoakinczm7mTWdKhoWVw5IV3Cwc1V+wYeSCgohS9p4Z1FofT+Ro617M+kZZwg5FuCQ3
 dxJa1/oSlugK/wO2gsM+rRRg8l0nG/phxFPnQZcy11PdaXykEyuj/oK90Y0NegqbM9aG+0/ld5
 hDjhQdRaG1V441ju9V0kKVr1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:25 -0700
IronPort-SDR: HwT5X83o22QydOsQC0uVKXvxZ7x+izaqJavP8bHXBFwjWvQGnl5ybQ01LFg/KolSPR24nXMkgK
 dLgZT7YBKANP9iK+xWiI5x5lWUhpfIAtvi2j1MxiEV8sYuIRavNckOQlhFtJ1RoF5RZzblHORr
 oNy3dsNhBLnM7Fc0n9ccuSxxOuO6Vabcw/0xiU9enO5qYTgO6bBpbWBuqHfs06FBm9GEluYUS9
 SSw4De5vzFX56PSo41uUNyWrSYElJFvqQk6mF3L0y8fDl5F9yC+VQNOFN+53w5ndUgQPVaAfnn
 MjY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:46 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 04/13] zbd: finish zones with remainder smaller than minimum write block size
Date:   Thu, 27 Oct 2022 15:01:30 +0900
Message-Id: <20221027060139.952508-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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
smaller than the block size. Fio resets such zone after zone selection
and continues writing to it. This zone reset is required not to exceed
the limit of max_open_zones option or max_active_zone limit of the zoned
device, but it does not simulate the workload.

To avoid the zone reset and unexpected write to same zone, fix write
target zone handling of zones with remainder smaller than write block
size. Do not reset but finish such zone not to exceed the max_open_zones
option and max_active_zone limit. Then choose the zone next to the
finished zone as write target. To implement this, add the helper
function zbd_finish_zone().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/zbd.c b/zbd.c
index 3e9c66d9..8c916456 100644
--- a/zbd.c
+++ b/zbd.c
@@ -333,6 +333,44 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
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
@@ -1952,6 +1990,33 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
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
+			/* Find the next write pointer zone */
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
@@ -1962,6 +2027,10 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
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

