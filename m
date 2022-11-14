Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E6FC4332F
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiKNCNa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiKNCN3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:29 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0CEAE62
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392008; x=1699928008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U/BVdveaB7ki2I8u59bfJDKH4MI3RDxEI+ua9AIHGHI=;
  b=UMHQ8AjV6N+mn73vm2HW/BYupOAn3PRdRUrUa75yyBD1vFDBDP2ZiSmx
   2UN1VmBMgGS9Y9WlqILNiiarZg1kCUHUNFCPnclzXH0bZq69YxqA6Bvxt
   ZeF6WnDvHW8MuzrWBuog4hGwD6QaVkD2qaJvAYlXrkvf4Ajlq81S/DxgP
   j7Y5taEbNJdu3g3quae1TqWCgbgUvLv/pxH1eheaNb4tFM2g3kh88Pw9v
   kkBD2maKR1EnOPnCLyknQyK75k5/69SkwGq0Fa4PoijL/JCTi1eHl+JFx
   TBWz2Crg3b3fjQ14REk6RSZmKYemxxxDScvAWzQkS62dYtv4fw7umCac1
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279238"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:27 +0800
IronPort-SDR: v7MvdSAvpFSgO34lGT4kv9gIlwJ2OcwmxtNVKiIkBHzjZNXssuPqPNq0qH2Yn7TKRtHIFVXrFo
 ESbzjbel/FiONp59t+WDqJ8MoinV0PMaZ1q3siKJf5GHEyRwrRhWVtiu9njSrrB+cFDV5jfa2l
 hiV777D+V5tSUfqFjryaGRFGv4nEUinjiYxdmA8aE0oLWQyhk4L1jk02kAKLYTkjydYNXTMjFZ
 CXPTGlWXRD20lLKWzdf/xKuWPLpGubiPyeG5KSWUC01c3T4h5lnMxbJDN2qzDZOW/0pVh6OTve
 uoU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:26 -0800
IronPort-SDR: O7RD/NzrzrMUvQ1gc95Uh6QkqFOTxPykbRBCA0364HguNefML6lU3B8zKYdUXiDAvyJDy0/N64
 9pkRZ6gAv3GRU1DOnoFHFyWQ5pPyKk0CtINOtPERbW/5iBZRlOYLMUfxdgMxiewE5T0MhsbjrW
 gelKyLIkxjz/Wlp135bSxsPOg0pfQwKMp9BGjtRNQsmm385MZgrv76El1CoFJK+f284UQVU4SW
 UCnyeJ64tixvBiv6FR4/zM5wqa9bHT/glnERB2z0jYV/0bpwM6lEKTBdJEgAr76tqHDNsl19+z
 XYk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:27 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 08/13] zbd: prevent experimental verify with zonemode=zbd
Date:   Mon, 14 Nov 2022 11:13:03 +0900
Message-Id: <20221114021308.1684141-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
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
index 97faa0e5..d1e469f6 100644
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
@@ -1526,42 +1530,6 @@ out:
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
@@ -1912,10 +1880,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
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

