Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552E5C05027
	for <fio@archiver.kernel.org>; Mon, 30 Jan 2023 02:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbjA3C25 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 29 Jan 2023 21:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjA3C24 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Jan 2023 21:28:56 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103EF1D902
        for <fio@vger.kernel.org>; Sun, 29 Jan 2023 18:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675045735; x=1706581735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4gzOM0QO4O1R34XViO/KPTDFDP4XxLcodk/b/HcWlJE=;
  b=omxKetLR8sAnXE4sW/1HwzNrCmpWuSYlF028DXy+eRacCJJweWnrMmZr
   Qg7dlXYcLIu8SlkoQCviXz/vraGvI6FHAhjgDO5Vqqfv9xQsUQ0hu/Uc9
   tXSPfsuCLYLaUD7ojRiGK5a5nTyEXCi+DLH1ZVbWX0f00NIoPSIJHI0XN
   obsW14NNjrjTtZ3yaExdXrexqRgAjOtzA1zTlH2aYy+giIF228Sqgffw0
   5Q52xYKjbE49brwyzKBpYHjXof+NDt80cQe3CzjB7JupSU639mLUzT1BA
   p7eVTgia9zadUAEnXGR8SvqAGamCb7uWcOdx/JEBZ0hZKIGHcYFcWzAXT
   w==;
X-IronPort-AV: E=Sophos;i="5.97,256,1669046400"; 
   d="scan'208";a="227010389"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 10:28:55 +0800
IronPort-SDR: kfh9+JR2ybt7K05Noe0x3uxfOd4EI35MhBAZS8xgKbX3QB9+aBlJn0Lv8FMmeFgv3U42XwykMh
 UMC3lsfd6teZ1IBnxHORAWa2Up1JL+yVmw1Pnd1DTLkK+s4AqSfrFL+YgirK41mn9LtDcd+42y
 4FyhznwnB/McJhO0L0BJDmzClinJXQ15Ba2rF01zv4h2syZ8UJ8GJRazAFen3hWxHcaZhPstXA
 pL+RSYS1e4URtQnCuB8NI1H2U7bLwUBGea7zBiX1m7RQMrG8S2sF08zBpQyjAZgoyhZNoVorEn
 kpY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Jan 2023 17:40:38 -0800
IronPort-SDR: pq2wV4sQUBpYUNHe6NsAQxKe8vyRBu/DpYdYgP6Mkzg1Vh0CeX0cpJKjuCH4LOv5M4rgzMVzjn
 3e+JtuZ2OxNYFge1+ql6RLueaeON0+4pmxGH9Uqs8tjznnAZ1B97ZksSHxpyyadzehxzyc8hy9
 yH22ajaz6L+sqxR8Y2/Uh0ub216+UvJmHuM+Sqwe//x3XzvT3PkkmY+ZQcxpMmvoEgiHQtJA06
 CvIvF7AltrMkMSOhLKqG35XgOcyqFxSMJgz4+R4pFSeiCwdkMcFJ1opMZsk+EvHATiHw3tg0Cg
 EAE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Jan 2023 18:28:54 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/5] zbd: remove sectors with data accounting feature
Date:   Mon, 30 Jan 2023 11:28:48 +0900
Message-Id: <20230130022850.1375523-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
References: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The sectors with data accounting values are no longer used by the helper
functions zbd_adjust_ddir() and zbd_adjust_block(). Remove the code
related to this accounting.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 73 +----------------------------------------------------------
 zbd.h |  5 ----
 2 files changed, 1 insertion(+), 77 deletions(-)

diff --git a/zbd.c b/zbd.c
index 8de909b7..7d19a214 100644
--- a/zbd.c
+++ b/zbd.c
@@ -286,8 +286,6 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	}
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data -= data_in_zone;
-	f->zbd_info->wp_sectors_with_data -= data_in_zone;
 	f->zbd_info->wp_zones_written_size -= data_in_zone;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
@@ -1196,68 +1194,9 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
-enum swd_action {
-	CHECK_SWD,
-	SET_SWD,
-};
-
-/* Calculate the number of sectors with data (swd) and perform action 'a' */
-static uint64_t zbd_process_swd(struct thread_data *td,
-				const struct fio_file *f, enum swd_action a)
-{
-	struct fio_zone_info *zb, *ze, *z;
-	uint64_t swd = 0;
-	uint64_t wp_swd = 0;
-
-	zb = zbd_get_zone(f, f->min_zone);
-	ze = zbd_get_zone(f, f->max_zone);
-	for (z = zb; z < ze; z++) {
-		if (z->has_wp) {
-			zone_lock(td, f, z);
-			wp_swd += z->wp - z->start;
-		}
-		swd += z->wp - z->start;
-	}
-
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	switch (a) {
-	case CHECK_SWD:
-		assert(f->zbd_info->sectors_with_data == swd);
-		assert(f->zbd_info->wp_sectors_with_data == wp_swd);
-		break;
-	case SET_SWD:
-		f->zbd_info->sectors_with_data = swd;
-		f->zbd_info->wp_sectors_with_data = wp_swd;
-		break;
-	}
-	pthread_mutex_unlock(&f->zbd_info->mutex);
-
-	for (z = zb; z < ze; z++)
-		if (z->has_wp)
-			zone_unlock(z);
-
-	return swd;
-}
-
-/*
- * The swd check is useful for debugging but takes too much time to leave
- * it enabled all the time. Hence it is disabled by default.
- */
-static const bool enable_check_swd = false;
-
-/* Check whether the values of zbd_info.*sectors_with_data are correct. */
-static void zbd_check_swd(struct thread_data *td, const struct fio_file *f)
-{
-	if (!enable_check_swd)
-		return;
-
-	zbd_process_swd(td, f, CHECK_SWD);
-}
-
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
-	uint64_t swd;
 	bool verify_data_left = false;
 
 	if (!f->zbd_info || !td_write(td))
@@ -1265,10 +1204,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
-	swd = zbd_process_swd(td, f, SET_SWD);
-
-	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n",
-	       __func__, f->file_name, swd);
 
 	/*
 	 * If data verification is enabled reset the affected zones before
@@ -1645,11 +1580,8 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		 * have occurred.
 		 */
 		pthread_mutex_lock(&zbd_info->mutex);
-		if (z->wp <= zone_end) {
-			zbd_info->sectors_with_data += zone_end - z->wp;
-			zbd_info->wp_sectors_with_data += zone_end - z->wp;
+		if (z->wp <= zone_end)
 			zbd_info->wp_zones_written_size += zone_end - z->wp;
-		}
 		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
@@ -1690,7 +1622,6 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	zbd_end_zone_io(td, io_u, z);
 
 	zone_unlock(z);
-	zbd_check_swd(td, f);
 }
 
 /*
@@ -1879,8 +1810,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
-	zbd_check_swd(td, f);
-
 	zone_lock(td, f, zb);
 
 	switch (io_u->ddir) {
diff --git a/zbd.h b/zbd.h
index 161dd5e0..534338bc 100644
--- a/zbd.h
+++ b/zbd.h
@@ -54,9 +54,6 @@ struct fio_zone_info {
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
- * @sectors_with_data: total size of data in all zones in units of 512 bytes
- * @wp_sectors_with_data: total size of data in zones with write pointers in
- *                        units of 512 bytes
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
@@ -79,8 +76,6 @@ struct zoned_block_device_info {
 	uint32_t		max_open_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
-	uint64_t		sectors_with_data;
-	uint64_t		wp_sectors_with_data;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
-- 
2.38.1

