Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A5FC433FE
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiJUGei (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJUGeg (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:36 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE01217048
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334067; x=1697870067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PgUwrNjoFoWUPIWUggyyTsqAQkZxA9/uab/mGEFp5KQ=;
  b=p3jL4yTM90vEVQ2k6Ujf4O4yKogsJCogTaKusRc0V7Uw/Bsqm3u9oWUk
   xNCVXHcGfJUtTgQCOjdBiTqK4g4ERaKt1qPI7Zqx+48f4c4j9pmejavhX
   Vx3sMc85ioIC2FxeFRkE1Qccb+HXuKUqS8eIMYDWFzGV52u3lxlnm9Dow
   sUiN6NLWFnVKQ7aUs/A0Nt0dy2BmG0Ky40iPYx7BGncDs8e1/0s4tq21E
   8I9Q3g3j3TlOS+xMDcLvyM2YNAjSj+Cfqp/MxtYoqCDeCKowHDFc2kOkE
   kND07ZCtMPZEIudYUzhXcNZxOmS4ykdk5KB698ieXltkXmBZxMjB2VQsI
   w==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733113"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:27 +0800
IronPort-SDR: gFZLrfipz6hM4rPgQRG3W9ZI7c6FPnznD/CsFP7pG5cQENP60ZaPu/GGju8tm+ZJY5VjGCEIgD
 fIXCCBPsFkJrCmeBMiquQWh+nFr1b5RSe0GLlzDIORY4vDTwkQIxewmK8R6toeddOCBWzPobf5
 6Pw9fWKj1DDe98JSu5mLHcH+zlcvjVhKENchM5wL1lzBUmVHav7WOLeV/iUgdEEH/i4sWaZUXc
 CEwww3bmpTry7YpGz2BeMZUjCPWfpaQIB4XD9YMqhezgc0Bu71scprjxVyeA5mGioIHh/dGp6i
 6YqiEIM9UMUgBuzEWEDT+kGf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:14 -0700
IronPort-SDR: YgmddzJEv13/w0N6989alyOOeVb6W6kwhatl5K1Pylw8gUujO7gBu6gC6gn1GKXJPPRUBnfg7E
 VGf8ggBaSPoWXPd9IGRRnW90iNpqKXZfR0g43p1sUyNkTO17RYtfUmoRT09uM2tMUitY+tf0p3
 RCa2mNumrTVsqys1PpaLpFAK0ehvyw0l8JeaRLmC2jjRva1BAl+6lMAWXFhdMJOZgWwpugRaMW
 Pa/RPjQ3PbdvlC9Fnctadm/6X3EJbmTdpkyDzDscdr9XeJ3VIlAAN8f/u/LI4SkGguB11Hiv6o
 oFI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:26 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 07/11] zbd: prevent experimental verify with zonemode=zbd
Date:   Fri, 21 Oct 2022 15:34:12 +0900
Message-Id: <20221021063416.860438-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When experimental_verify options is specified, fio does not record
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
---
 zbd.c | 46 ++++++----------------------------------------
 zbd.h |  2 --
 2 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/zbd.c b/zbd.c
index b2f43860..ba9b9fee 100644
--- a/zbd.c
+++ b/zbd.c
@@ -288,7 +288,6 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	z->wp = z->start;
-	z->verify_block = 0;
 
 	td->ts.nr_zone_resets++;
 
@@ -1082,6 +1081,11 @@ int zbd_setup_files(struct thread_data *td)
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
@@ -1518,42 +1522,6 @@ out:
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
@@ -1904,10 +1872,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
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

