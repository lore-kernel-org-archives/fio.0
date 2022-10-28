Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD07C38A02
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiJ1LyL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJ1LyK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:10 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B351D2B77
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958047; x=1698494047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=66gEBiDfMup2ZsfSsgnNGfZhGsfVsYgE2rm6toujTBQ=;
  b=WC16xtTr6oRCXixswZmio01suM/GzjiOJm90hpVLky8v9aeyFp8zcxb1
   ZVsAL3Owk0ECDM+MpVgdw0I6gWxRFzk76OP5xSWkd65vdBj7CnE/0u6EZ
   B8DodSm4/BRFY3rMmcNdVX1J/hQoPo3AVmlbKRf3g9L019igrLAmBm4RM
   1M4n8nqtwjwtMyw+dYc4a9zZcLnZRp9Hu7lRlxKasFB+QCMzMiOwHbiag
   SOTccCdrdbbSd2R3425YGBKxzibtKcKYGxPbECOPd6JY2iqWe02Tcu5Mx
   LBCs9vkYPrqj0LxMAc02Z8a3yEApdaozY2xZQgTRLeyKxcygv8jj/xezs
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074532"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:07 +0800
IronPort-SDR: /QsOk286V5729opmM7zkDQx2JLbTGH3tq5DveeJhqwB/4h6Qh6c6eCLDsl0OU03qHDTbthIKvQ
 r/R4fNJPxzPYjQyh5AxH2izMxYR2AGyViiI0dK+zy+87ECQwUQUb66hW/bvaQdfIb1d/Cq4HGq
 ylz75X11frGDROjtRneaapunDhzPuIUx/j0uzvUsIMfusPqnmy2znBCe+cjLbQ9q3tyIV3L89z
 VErZIerR83+YvR8zYUVfsVQeEsIIbw9A/aymwybRotVpPjFypABHDV+6RDUoPB1nXogQxw2KDi
 7jb2OH1J5OhKCSUIoygSeIVV
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:44 -0700
IronPort-SDR: Q9hWRqhgoSjqIpo3QDevtEaFfjvZZoLwKSWl3K5AAatOXyerQlqWkeOr6mSn6AYeuCUk1BPxEz
 1RnTAW59CM562Mqr1L2MxYb5Qlv5Dhmqax0K00I2uELotK83KG4uPfmqVKBlvzrulNVGqVgskM
 rUzf1VFVRSHOf/ggDzsebSaiSc25P9F7PTaYfDxYTDGIPCEcvIol/Q1i5LYp1X8CWn+ZI9E1T6
 ynyaAhAcHzM+xMMxkqUrq9BUcNzBRK4C7HOpooNrHSQyM3YSzqkwf8C6xI+GqRRYU1D+cpCCz7
 mx8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:07 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 08/13] zbd: prevent experimental verify with zonemode=zbd
Date:   Fri, 28 Oct 2022 20:53:49 +0900
Message-Id: <20221028115354.971715-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When the experimental_verify option is specified, fio does not record
normal I/O metadata to create verify read unit. Instead, fio resets file
status after normal I/O and before verify start, then replay I/Os to
regenerate write unit and adjust it to verify read. This I/O replay does
not work for zonemode=zbd since zone status needs to be restored at
verify start to the status before the normal I/O. However, such status
restore moves write pointers and erases data pattern for verify.

Check that the options experimental_verify and zonemode=zbd are not
specified together and error out in case they are both specified. Also
remove the helper function zbd_replay_write_order() which is called from
zbd_adjust_block(). This function adjusts verify read unit to meet zone
write restrictions for experimental verify, but such adjustment does not
work because zone status is not restored before verify start.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 46 ++++++----------------------------------------
 zbd.h |  2 --
 2 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/zbd.c b/zbd.c
index 54bbc82b..6bc6a5dc 100644
--- a/zbd.c
+++ b/zbd.c
@@ -291,7 +291,6 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	z->wp = z->start;
-	z->verify_block = 0;
 
 	td->ts.nr_zone_resets++;
 
@@ -1085,6 +1084,11 @@ int zbd_setup_files(struct thread_data *td)
 	if (!zbd_verify_bs())
 		return 1;
 
+	if (td->o.experimental_verify) {
+		log_err("zonemode=zbd does not support experimental verify\n");
+		return 1;
+	}
+
 	for_each_file(td, f, i) {
 		struct zoned_block_device_info *zbd = f->zbd_info;
 		struct fio_zone_info *z;
@@ -1521,42 +1525,6 @@ out:
 	return z;
 }
 
-/* The caller must hold z->mutex. */
-static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
-						    struct io_u *io_u,
-						    struct fio_zone_info *z)
-{
-	const struct fio_file *f = io_u->file;
-	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
-
-	if (!zbd_open_zone(td, f, z)) {
-		zone_unlock(z);
-		z = zbd_convert_to_open_zone(td, io_u);
-		assert(z);
-	}
-
-	if (z->verify_block * min_bs >= z->capacity) {
-		log_err("%s: %d * %"PRIu64" >= %"PRIu64"\n",
-			f->file_name, z->verify_block, min_bs, z->capacity);
-		/*
-		 * If the assertion below fails during a test run, adding
-		 * "--experimental_verify=1" to the command line may help.
-		 */
-		assert(false);
-	}
-
-	io_u->offset = z->start + z->verify_block * min_bs;
-	if (io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
-		log_err("%s: %llu + %llu >= %"PRIu64"\n",
-			f->file_name, io_u->offset, io_u->buflen,
-			zbd_zone_capacity_end(z));
-		assert(false);
-	}
-	z->verify_block += io_u->buflen / min_bs;
-
-	return z;
-}
-
 /*
  * Find another zone which has @min_bytes of readable data. Search in zones
  * @zb + 1 .. @zl. For random workload, also search in zones @zb - 1 .. @zf.
@@ -1907,10 +1875,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		if (td->runstate == TD_VERIFYING && td_write(td)) {
-			zb = zbd_replay_write_order(td, io_u, zb);
+		if (td->runstate == TD_VERIFYING && td_write(td))
 			goto accept;
-		}
 
 		/*
 		 * Check that there is enough written data in the zone to do an
diff --git a/zbd.h b/zbd.h
index 0a73b41d..d425707e 100644
--- a/zbd.h
+++ b/zbd.h
@@ -25,7 +25,6 @@ enum io_u_action {
  * @start: zone start location (bytes)
  * @wp: zone write pointer location (bytes)
  * @capacity: maximum size usable from the start of a zone (bytes)
- * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
@@ -39,7 +38,6 @@ struct fio_zone_info {
 	uint64_t		start;
 	uint64_t		wp;
 	uint64_t		capacity;
-	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		has_wp:1;
-- 
2.37.1

