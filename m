Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19B7C4332F
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbiKNCN1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiKNCNZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:25 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC5BE009
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392002; x=1699928002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kA0TULFtjJz1oFzQETdxwAcR4cHbipppllGrHLwi4hI=;
  b=jtQ7G4ZKXjFVAQfhdD90MuujBN/ePnu3W2URPdB/2zABRjjnawXte23h
   AsuMavjwJcYKeODA8IU1QwLhLsWyVHPwCLdeJaNjeQ1IHDgDkrp1cLuSD
   FdM9PRIMxtqwh5XDdH4XEwT6QVKYRNM89vYxIbJYh82W73kHuxYj3Hup3
   OBv/QCqGIyKBBFPlovxXzO7t0oWGen/KfrqRU8VweGcr+4YeBfN4bj8n6
   wzAt/T/tJOBc3OUJ3ZmDaCHJdzI4u6jwcpkch25b3dtoHTXfF+vqt3Z4F
   snAz5Onw5wauUk2qEDoG86pcdZtfUyr4YOGfSd8m/J0GYQS7oyZPT66bf
   A==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279220"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:19 +0800
IronPort-SDR: TQc5i8OLyUDpN5AEf4UuWHwxrMtffIk9nVI6c6amRvFqquAxkHx07WZoKrcFaOPgqt4PEQpPjI
 rhkoM3nENm6CkMC0/bHg0yh7pzkAVt/ZvtBL+mizotRTYvpajtVVN13pUUNg8BrwHuEiovpY+I
 BxgSd3mDgeB4YvEYNUfbOKK3c9o4BX1o7CgPMTrpiqPFOOL99mxYlhYXwSXSVMCZPCHLJDybMS
 heUdk3LVSQUwWc1BaZHkbCHCYd2Od+jmFeayy7t+3WyF1WUywJPrV0Y+Cqz3PruKc5NZsjsBGG
 CKE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:18 -0800
IronPort-SDR: 0XMO8shmRspw9AmfZFtobe/bjJjJgWmcHoubBSiVBALKniXt8+djoFKH0niEBILJrQBzvRlUH+
 O3ZXDrOI4veVKttuwpfmswTloPi8GjyXJYpQILlslWfELb8yOjBntTWHcWC3H7xAhILe6Hui2C
 +r1MjlS+1SxDfiIX2XilSeOelpwe1ltGTLOFmj5jLCFesbue1VxevpwYe7kJLFAOw8+C9KeVPn
 OXK/4miuL96eE4FKYFKfX9upgEMrAk6quwsaEfymf02hAMkxJDh5jXAT2Ome6O8rsysyUkqc9t
 7Gs=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:18 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 04/13] zbd: finish zones with remainder smaller than minimum write block size
Date:   Mon, 14 Nov 2022 11:12:59 +0900
Message-Id: <20221114021308.1684141-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
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
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/zbd.c b/zbd.c
index 26a6404d..9ab78e2e 100644
--- a/zbd.c
+++ b/zbd.c
@@ -334,6 +334,44 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
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
@@ -1953,6 +1991,33 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
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
@@ -1963,6 +2028,10 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
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

