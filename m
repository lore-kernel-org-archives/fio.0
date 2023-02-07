Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4887C6379F
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjBGGhp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjBGGho (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:44 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C812916C
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751863; x=1707287863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=odg4XPBo/581C6yLu8RPMV53Q7NEjGm7kvxTk8CuCuE=;
  b=gV3VrJL9HveZa2xwPnZJLu+0qgJum3huvoLPjLkD+GKH+2chFUX+t4Yq
   sYUMYvFQrZrOKi6B8GpAXqoG0buYn4s6AgkkmuIv5cV4VA7vHW1VdMAqc
   XxHoWbQ3ACKHUDSuZO0zOfb2F3DASD9kD1L7zpE+apccybyFgX7XStSoI
   3sgQpDuLhJBxPdbbZr4DUUAB5ThTwZ/sRffhyLGlK00SWNLe5RLqVuD9I
   2RpGQt02jO5PB6BdLWoDzWEnz6MvuipTMp6Y6Vmoo+MyL965CunEU8WUp
   gK85o0Mx6ILuZo5ers91gllvqH0dSMgAKzbc2/vyHIF5Z4k7moJsCfYgk
   g==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982649"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:42 +0800
IronPort-SDR: 3NFNqOUa29sYQshMD6n3CY80b8zWhRkDSuL1d1q6EJw0jt1+TRQOxkngdHBb2huAQYjV3+wdl6
 KZ7zkte5hiXZobwjEbB5at3bs8k24jOXisQFnI+icvhcuyoO5C0JT8S71EPc8dH9DbzcNgzC2X
 gF1HEma/FeKN9ez7u7HIEGxKzwCna8Xs5dPx2MAu0m7LESO3+0PNvL11jkDZYAN91VHGAsFttL
 geWnLpCuIIBoo+DwUcec0v6dT8Jp111Yg5Hrv8PhAHO2PjPmx7cB4tAfTxKDwjebUSE7Yyiieh
 NYE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:54:59 -0800
IronPort-SDR: ZTkJDj/2OssuTwMEDWYhocEFIajDgKLCqkoFCYeWAq32zynkr31nHDPzaSBxLPa+mgHYCjFgZY
 PU5aPcQ5f5i7kxQ/+hChWb2zMmsdv8aPCPdxrzCIlnz8BiAjQfvz4MdcgbLzDhBtBHnEICMLpg
 jilT41dWkVassY20paUv1lJBfUVV1IdbMyhMzc2ZrwH/v3QuCnchBBiOZz5vYBIU66Zdx7kok9
 SH6+eJmbp4lrVPQOn3Ad3ScKkd59agwm0Dw64pybu+OILbjeQ58/Pmk27Q7SwREvAMuMUwOkGd
 yi8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:41 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/8] zbd: refer file->last_start[] instead of sectors with data accounting
Date:   Tue,  7 Feb 2023 15:37:32 +0900
Message-Id: <20230207063739.1661191-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
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

