Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8F1C636CD
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjBGGhs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBGGhr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:47 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A518722DD8
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751865; x=1707287865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=orhOuEZcGz0xVivWRBwCawk0qfu0GK9V5jXACc4krM0=;
  b=hMj3zgZqxTzExoNSJT4dN2nhqJc/LUVVkDyAkeK2eBVUmE+Wj2ZLs32C
   NN3iE83Mc3/KYH2xN9DQdu6xIzfos629Hq3XuL3S+PE3OsdyHOdR+eXEE
   MuT6vcfXCU8PMbWHyy6L97TiCRWf8KOjAlNl9H+iIp3+gGlTqqK8N+PV3
   lrahggn8rJ/p/FblMhBa/iu9PstUA5q0osz0Ym0x+IaqhvGhZk8hdWJPc
   rZygJpAdgFlLA+QFPq5pJCC/rPekPe5WZvs3CjgdQQXA7xr1bRyJoqMS2
   cGkwGCpgAKmtmrgwb4J2lzyzTRSrIxc49rvhOhqqeoDDXkcdtLsLZjZxD
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982654"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:45 +0800
IronPort-SDR: S70vt00DOWNgc29nwQFfo8U5DoziDwEWKvOlGMxB4Sc4OeBKxEQa5a59UtUouLF9baTwtW2wNA
 b7vD5VG3QPvhlkH/14MCBddxl35xoFt7SUEWo+wyJlc9Z9rhFFPaE7fGD+BVJJBVKy22sADGa9
 uHnhAGKAOTGPOWGa4H7tCYrE5d8duaa3YrwchMtbtlkWzxBr0B5jfbOj12rvB+HA0uT0Lmvxwk
 jPv4rfkUCVG0f8f3KXo3Sfqk70LZPP5MpXimFLnMMHuElwVNQYeuFH2W5kkubJpk5tgGaiuVqw
 E+0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:55:01 -0800
IronPort-SDR: 3yN3jOYT8rSIefuWqAih6UyOlxq2XINueOe0IOm1RJ1pdUbX4nnGL1VM+Yo5s+pKjJ7IURqZuG
 K+OXkhpPr1C0E+sUlxx4wayUg/8MewuTmgiVi2NHXwHvLx99ivoSYJ4jt0c6KUofG9CrMizrmO
 beUm6g+swECLQdwu9+osLxicNBuUyfoNzYXCefnUhET4+QNOBbUWQxxOpnADQg57B0CP4J3CkH
 9p/i4HfiJJnnmN8YwjB5OteSFdubYzf/OmSl7U+W+2A+ZUqhYz1SNr27KiabOTVrUG9TgzNS3p
 Dvg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:44 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 3/8] zbd: rename the accounting 'sectors with data' to 'valid data bytes'
Date:   Tue,  7 Feb 2023 15:37:34 +0900
Message-Id: <20230207063739.1661191-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The 'sectors with data' accounting was designed to have 'sector' as its
unit. Then related variables have the word 'sector' in their names. Also
related code comments use the words 'sector' or 'logical blocks'.
However, actually it was implemented to have 'byte' as unit. Rename
related variables and comments to indicate the byte unit. Also replace
the abbreviation swd to vdb.

Fixes: a7c2b6fc2959 ("Add support for resetting zones periodically")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support |  4 ++--
 zbd.c                  | 25 +++++++++++++------------
 zbd.h                  |  5 ++---
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4091d9ac..c32953c4 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1110,8 +1110,8 @@ test51() {
 	run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
-# Verify that zone_reset_threshold only takes logical blocks from seq
-# zones into account, and logical blocks of conv zones are not counted.
+# Verify that zone_reset_threshold only accounts written bytes in seq
+# zones, and written data bytes of conv zones are not counted.
 test52() {
 	local off io_size
 
diff --git a/zbd.c b/zbd.c
index b6cf2a93..455dad53 100644
--- a/zbd.c
+++ b/zbd.c
@@ -286,7 +286,7 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	}
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->wp_sectors_with_data -= data_in_zone;
+	f->zbd_info->wp_valid_data_bytes -= data_in_zone;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	z->wp = z->start;
@@ -1190,35 +1190,35 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
-static uint64_t zbd_set_swd(struct thread_data *td, const struct fio_file *f)
+static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze, *z;
-	uint64_t wp_swd = 0;
+	uint64_t wp_vdb = 0;
 
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
 		if (z->has_wp) {
 			zone_lock(td, f, z);
-			wp_swd += z->wp - z->start;
+			wp_vdb += z->wp - z->start;
 		}
 	}
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->wp_sectors_with_data = wp_swd;
+	f->zbd_info->wp_valid_data_bytes = wp_vdb;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	for (z = zb; z < ze; z++)
 		if (z->has_wp)
 			zone_unlock(z);
 
-	return wp_swd;
+	return wp_vdb;
 }
 
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
-	uint64_t swd;
+	uint64_t vdb;
 	bool verify_data_left = false;
 
 	if (!f->zbd_info || !td_write(td))
@@ -1226,10 +1226,10 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
-	swd = zbd_set_swd(td, f);
+	vdb = zbd_set_vdb(td, f);
 
-	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n",
-	       __func__, f->file_name, swd);
+	dprint(FD_ZBD, "%s(%s): valid data bytes = %" PRIu64 "\n",
+	       __func__, f->file_name, vdb);
 
 	/*
 	 * If data verification is enabled reset the affected zones before
@@ -1607,7 +1607,7 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		 */
 		pthread_mutex_lock(&zbd_info->mutex);
 		if (z->wp <= zone_end)
-			zbd_info->wp_sectors_with_data += zone_end - z->wp;
+			zbd_info->wp_valid_data_bytes += zone_end - z->wp;
 		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
@@ -1960,7 +1960,8 @@ retry:
 
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (zbdi->wp_sectors_with_data >= f->io_size * td->o.zrt.u.f &&
+			if (zbdi->wp_valid_data_bytes >=
+			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f))
 				zb->reset_zone = 1;
 		}
diff --git a/zbd.h b/zbd.h
index 9ab25c47..20b2fe17 100644
--- a/zbd.h
+++ b/zbd.h
@@ -54,8 +54,7 @@ struct fio_zone_info {
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
- * @wp_sectors_with_data: total size of data in zones with write pointers in
- *                        units of 512 bytes
+ * @wp_valid_data_bytes: total size of data in zones with write pointers
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
@@ -75,7 +74,7 @@ struct zoned_block_device_info {
 	uint32_t		max_open_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
-	uint64_t		wp_sectors_with_data;
+	uint64_t		wp_valid_data_bytes;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
-- 
2.38.1

