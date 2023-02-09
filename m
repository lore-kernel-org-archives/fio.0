Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F8EC05027
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBIHJM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBIHJM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:09:12 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F9416AE7
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675926550; x=1707462550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C3j5DfyNZ3dY65HkWeMAZVNtz9ZdrAMkGTxaXYKe22Q=;
  b=UcumD7rCcHdglCw/kMIftnIpB0rY0apweGOs0LVADvdNbsHOkDALKflX
   W3l7ddKEAoNpRjrj7EuQZfgGKXooGXHg1xVeAaaTROKGTgZ3n2MbjsD1N
   HpLRDnfWQNKKwEhSdWu93Bo1rh0d+mKF8Jefv0Ecbt0Pdr6khJJmM+Tqm
   pevIDfP+HdiUIqwJ9RJbvNZnoSco9VG2VHotFMlWnZqkGFHQhM8AA/sUT
   mTxj9NAcZAkeRWkD42uNtUDKCLxB6I2SoqPLGnmz2ZWcspSGW8vyGPgkw
   GhxGMGKpFgiFuhj068PvASHb1IOvO+T0TyuiQeL2CzcEhT7aZ1yhlDzFH
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="334848068"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:09:10 +0800
IronPort-SDR: CNoTPKrQFdunZ+FAZip9gcc07Ncv32f6Kcn3cfra+QzyqkiYoppJkzu38KJR3vr5HyyWAVsJl9
 JZj0Y2SvuzlSRMCIlaihIcTMtN+nKcI53l8sOPFFeQs8oRfv5nT+7rQKHZHAggTW7ohswgRqiP
 23zffHWdOV12flfNKUc+Z+8xv7I83fpEqsHoIxielURUdu4kr56D0a2/xlmm+w6HR3NIkT9wgV
 kkNfQvtiEhht1YqskBuNZR7H/IZmikQeCwXW7If5vjfQscang5rnamgSRKH/G7uDAo+mVM5KiI
 ugQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 22:20:40 -0800
IronPort-SDR: 5Vk9uVBcvQb/Dcws6ttv2uro//Ykq98szu3N7nOtTEOkFnL43yVRB85YV/ekEjinWXDjGxXXNJ
 3CmDrDCj2xisbanTXjKWYuRtSo7y2Th6OYHq89LtQtDCWTPhE07CPvb2YfxaAJbC8TbQjnn/vc
 4XdKZPMtduJomoRRWopzGk2ID6dK26VUZO8K1TxeOQ160qU3/u6HBka8qH/75MiAkOOtTVElqM
 TS+zNAZhVXY8BcZMOIEzmfWtDMuZetbu+u9to9KSW5g5vHYq8PiBlgJ5QR+UGjzNPE55pUEO9B
 qeg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Feb 2023 23:09:09 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 1/8] zbd: refer file->last_start[] instead of sectors with data accounting
Date:   Thu,  9 Feb 2023 16:09:00 +0900
Message-Id: <20230209070907.1733138-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

To decide the first IO direction of randrw workload, the function
zbd_adjust_ddir() refers to the zbd_info->sectors_with_data value which
indicates the number of bytes written to the zoned block devices being
accessed. However, this accounting has two issues. The first issue is
wrong accounting for multiple jobs with different write ranges. The
second issue is job start up failure due to zone lock contention.

Avoid using zbd_info->sectors_with_data and simply refer to file->
last_start[DDIR_WRITE] instead. It is initialized with -1ULL for each
job. After any write operation is done by the job, it keeps valid
offset. If it has valid offset, written data is expected and the first
IO direction can be read.

Also remove zbd_info->sectors_with_data, which is no longer used. Keep
the field zbd_info->wp_sectors_with_data since it is still used for
zones with write pointers.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 14 +++-----------
 zbd.h |  2 --
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/zbd.c b/zbd.c
index d1e469f6..f5e76c40 100644
--- a/zbd.c
+++ b/zbd.c
@@ -286,7 +286,6 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	}
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data -= data_in_zone;
 	f->zbd_info->wp_sectors_with_data -= data_in_zone;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
@@ -1201,7 +1200,6 @@ static uint64_t zbd_process_swd(struct thread_data *td,
 				const struct fio_file *f, enum swd_action a)
 {
 	struct fio_zone_info *zb, *ze, *z;
-	uint64_t swd = 0;
 	uint64_t wp_swd = 0;
 
 	zb = zbd_get_zone(f, f->min_zone);
@@ -1211,17 +1209,14 @@ static uint64_t zbd_process_swd(struct thread_data *td,
 			zone_lock(td, f, z);
 			wp_swd += z->wp - z->start;
 		}
-		swd += z->wp - z->start;
 	}
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	switch (a) {
 	case CHECK_SWD:
-		assert(f->zbd_info->sectors_with_data == swd);
 		assert(f->zbd_info->wp_sectors_with_data == wp_swd);
 		break;
 	case SET_SWD:
-		f->zbd_info->sectors_with_data = swd;
 		f->zbd_info->wp_sectors_with_data = wp_swd;
 		break;
 	}
@@ -1231,7 +1226,7 @@ static uint64_t zbd_process_swd(struct thread_data *td,
 		if (z->has_wp)
 			zone_unlock(z);
 
-	return swd;
+	return wp_swd;
 }
 
 /*
@@ -1640,10 +1635,8 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		 * have occurred.
 		 */
 		pthread_mutex_lock(&zbd_info->mutex);
-		if (z->wp <= zone_end) {
-			zbd_info->sectors_with_data += zone_end - z->wp;
+		if (z->wp <= zone_end)
 			zbd_info->wp_sectors_with_data += zone_end - z->wp;
-		}
 		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
@@ -1801,8 +1794,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
-	if (io_u->file->zbd_info->sectors_with_data ||
-	    td->o.read_beyond_wp)
+	if (io_u->file->last_start[DDIR_WRITE] != -1ULL || td->o.read_beyond_wp)
 		return DDIR_READ;
 
 	return DDIR_WRITE;
diff --git a/zbd.h b/zbd.h
index d425707e..9ab25c47 100644
--- a/zbd.h
+++ b/zbd.h
@@ -54,7 +54,6 @@ struct fio_zone_info {
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
- * @sectors_with_data: total size of data in all zones in units of 512 bytes
  * @wp_sectors_with_data: total size of data in zones with write pointers in
  *                        units of 512 bytes
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
@@ -76,7 +75,6 @@ struct zoned_block_device_info {
 	uint32_t		max_open_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
-	uint64_t		sectors_with_data;
 	uint64_t		wp_sectors_with_data;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
-- 
2.38.1

