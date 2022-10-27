Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E39C67871
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiJ0GDJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234354AbiJ0GCz (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:02:55 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F2C7AB17
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850551; x=1698386551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1gHy+73MkVKdGKhyBJQCTZr7jFQ0yOtINmSaO1JjKzs=;
  b=CEASdtXddadAfmRwBF5alFX5m+FkVzhPvD9vFxjs05NvYjfKBxsjHbSq
   /mDPrkVGXRrsFONIyqA1iCOITwv5kHUV7Av/DL7povZRKPACXioEnzKYH
   kaJOUMcTcb0hzojniEEtvsf1aWwLN+fqB43ppjSPqKV6fq/gmCaksG1h9
   vBAzhrXYnmjqS8FtR/Y5oV+NhFBuAHls8GlEJQybdIr2B/jZgJCHuFU9E
   BAZ1RRX7qsyDTbMitePFQQZi1fBESjZIgXQWDM/+QsfAyUayvGwDXxSLW
   k1UDLPrkRNi+s28blxf/jn4jo9jVYkT1/nsvO2B8GC2RmJxbVKFNThvjC
   A==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="215208197"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:52 +0800
IronPort-SDR: JryYSHaCVCGcLSQWkKxvNLKT2cuxEvouXN4WccqEhtgnVh+GLTtzO2KNbXlpcF1wUBtLquoySJ
 MJVay3jTy5Reh0z8J/rwn2jJHcgU2hr8T1bE4DC3GEIHGS12kCxJKg0l/b37b/7F7Cw7d6SXB+
 XSJQvAxaUupgH+f6pWy0v36uvaGGrvqlXi4rcdJ+6fCJMdLtmnmPKi3q8wQc8v7N6PkHgWMfow
 2OefLJTeB9Q+UcU/ezfiSondXn0V2z+HYycjRelrQikDpIgyfd/QsV2hLDGw6keX1j+1AdiGxD
 e4gTFm8/Wf5uXRxSpy92CFDm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:30 -0700
IronPort-SDR: gY1KUZm4FJ20Ht/YkjiodZY6njiqdyshKYIqo84VhGrqYcqVFa3FR8lTLTHd+OzAVK/FpCQg2k
 uksUbNViA28Z7x5WHxaCXFGaINrEtsYrCiAWUR5KcQkTCSioBSwNMH3GhD2eoPllj/dAjy5XfS
 KpcjVO5wtUj/4L3OxAh/Q3AMPyr6nQeD8XBDwSXSrGZ4v8lZebiYIJJxsbfykU1Gd0P2sPCqPl
 zGUl9DZDeTls8LGukVxkLKnTvjRubEP8foS1MzcR/baUe3elsMtFxYQeAJC3eqEo4QqUBnAGlW
 KyE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:51 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 08/13] zbd: prevent experimental verify with zonemode=zbd
Date:   Thu, 27 Oct 2022 15:01:34 +0900
Message-Id: <20221027060139.952508-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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
index 2a92ba60..5a6c877f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -290,7 +290,6 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	z->wp = z->start;
-	z->verify_block = 0;
 
 	td->ts.nr_zone_resets++;
 
@@ -1084,6 +1083,11 @@ int zbd_setup_files(struct thread_data *td)
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
@@ -1520,42 +1524,6 @@ out:
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
@@ -1906,10 +1874,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
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

