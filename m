Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5531AC636CC
	for <fio@archiver.kernel.org>; Mon, 30 Jan 2023 02:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbjA3C24 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 29 Jan 2023 21:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjA3C2z (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Jan 2023 21:28:55 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC691166D3
        for <fio@vger.kernel.org>; Sun, 29 Jan 2023 18:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675045734; x=1706581734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WUw0Fww9tb6gtskA9gXxuQOpq1tMALrn0hZsDpzx33U=;
  b=Z2asoYjIwgRf+v9ZItUlJz4sdtis21DLxNv5gODAB0gJG9tkav3Hommy
   bBBZDTLQc+cqk2vU5uGFGVu/kgDS92E4MMv/l+7h9thHb2UAbTt30xcT7
   Z38qxRb1c+miinEE4Jm8/Yozd+zl6SokFhzlj1Iix3+hnxTi8cuBZN1aE
   z7Um7j0lreQllasBbg6rct2wiqnSM/Xuufn1qXbZ/ihlSgoJCnoeb+mVd
   Bp6InSSD762b3Nq3NAvm+/hgAU3iAybWZAIO9Dd4Nw6/xjkosPVmohSs/
   zYKeBadAuXoSCLN+bGHgteNFy3faqgogc2XGc++4WTEhx3hPyFcB70ZPJ
   A==;
X-IronPort-AV: E=Sophos;i="5.97,256,1669046400"; 
   d="scan'208";a="227010385"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 10:28:54 +0800
IronPort-SDR: 3lYYBS3wb4WGrK4F8I7+b8tzdoSvr48AW1Ka0YoER6ahEdDf4llUuYj72/0JUHsMQtgcXI26Qd
 YezwTmNgGYt58FiWPNAPY3jBZNY6XdiuqtHt1ovUGTmUuzdiHOO0t1nv1UgqWGVKZjze6HMVJg
 tSuPl/tlu181RXgGCTJpkgziVy/VBltPvXpvqgrUWoePwMNWlkFgTEZJ8hFGsIv3oRSlaWTVvn
 Q5bT+sBgIfCMZx2YOzAV9ioseSQafKHss9lCTg26Yrr4WW96JN7UhoDSG2XQ/MQ9OriFZA2uKB
 BGk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Jan 2023 17:40:36 -0800
IronPort-SDR: Zww/Yw1iiUV4jwkQNhy+9Dk886XBLxGg6zcZ7acq1ZP/WDXZbr+Zkv4jZqneoyf3GgttPUG7vC
 kVuS582cJcY0wI2RX1KMn2eH/NG/RUU1Q5LZgDC2juJQGLSInVWnYgsQGQAQ4j3o6VWkevsb2T
 dzhM5FSoPhkbvWdl1q2PnGho6NrfePLQVTmWLhQtluBq5PnxxbZn3he7386wlGLyLqVn0H0SSl
 6sJQF7Rzef1IyytTsUoPvsYHEOz3I4YgnCMHGVBJWYOLzEii/1gg9TI1q2srVlIMsWRIkBXprb
 8Qg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Jan 2023 18:28:52 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/5] zbd: calculate zone_reset_threshold ratio for device
Date:   Mon, 30 Jan 2023 11:28:47 +0900
Message-Id: <20230130022850.1375523-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
References: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The function zbd_adjust_block() uses the sectors with data accounting
for zones with write pointers to judge if a zone must be reset according
to the zone_reset_threshold option. However, the accounting feature has
two issues. The first issue is vague definition: accounting per job, or
accounting per device. The second issue is job start up failure due to
zone lock contention.

Avoid these issues by doing the correct accounting dedicated for the
zone_reset_threshold check. Add new fields wp_zones_size and
wp_zones_written_size to the struct fio_zone_info. The former field
indicates the total bytes capacity of all write pointer zones, the
latter field accounts for the written bytes within these zones,
regardless of the IO ranges of the jobs. Each job compares the current
ratio of wp_zones_written_size / wp_zones_size with its
zone_reset_threshold option value to judge if zone reset is required.

Also update descriptions of the zone_reset_threshold option to reflect
this change.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 7 ++++---
 fio.1     | 7 ++++---
 zbd.c     | 9 ++++++++-
 zbd.h     | 5 +++++
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 17caaf5d..b0d063ec 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1085,9 +1085,10 @@ Target file/device
 
 .. option:: zone_reset_threshold=float
 
-	A number between zero and one that indicates the ratio of logical
-	blocks with data to the total number of logical blocks in the test
-	above which zones should be reset periodically.
+	A number between zero and one that indicates the ratio of written bytes
+	to the total size of the zones with write pointers on the zoned block
+	device. When the current ratio is above this ratio, zones are reset
+	periodically as :option:`zone_reset_frequency` specifies.
 
 .. option:: zone_reset_frequency=float
 
diff --git a/fio.1 b/fio.1
index 527b3d46..0eeaaeda 100644
--- a/fio.1
+++ b/fio.1
@@ -854,9 +854,10 @@ of the zoned block device in use, thus allowing the option \fBmax_open_zones\fR
 value to be larger than the device reported limit. Default: false.
 .TP
 .BI zone_reset_threshold \fR=\fPfloat
-A number between zero and one that indicates the ratio of logical blocks with
-data to the total number of logical blocks in the test above which zones
-should be reset periodically.
+A number between zero and one that indicates the ratio of written bytes to the
+total size of the zones with write pointers on the zoned block device. When the
+current ratio is above this ratio, zones are reset periodically as
+\fBzone_reset_frequency\fR specifies.
 .TP
 .BI zone_reset_frequency \fR=\fPfloat
 A number between zero and one that indicates how often a zone reset should be
diff --git a/zbd.c b/zbd.c
index 8d8d5747..8de909b7 100644
--- a/zbd.c
+++ b/zbd.c
@@ -288,6 +288,7 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	f->zbd_info->sectors_with_data -= data_in_zone;
 	f->zbd_info->wp_sectors_with_data -= data_in_zone;
+	f->zbd_info->wp_zones_written_size -= data_in_zone;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	z->wp = z->start;
@@ -756,6 +757,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
 		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
+	f->zbd_info->wp_zones_size = nr_zones * zone_size;
 	return 0;
 }
 
@@ -834,6 +836,9 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			switch (z->type) {
 			case ZBD_ZONE_TYPE_SWR:
 				p->has_wp = 1;
+				zbd_info->wp_zones_size += zone_size;
+				zbd_info->wp_zones_written_size +=
+					p->wp - p->start;
 				break;
 			default:
 				p->has_wp = 0;
@@ -1643,6 +1648,7 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		if (z->wp <= zone_end) {
 			zbd_info->sectors_with_data += zone_end - z->wp;
 			zbd_info->wp_sectors_with_data += zone_end - z->wp;
+			zbd_info->wp_zones_written_size += zone_end - z->wp;
 		}
 		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
@@ -1999,7 +2005,8 @@ retry:
 
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (zbdi->wp_sectors_with_data >= f->io_size * td->o.zrt.u.f &&
+			if (zbdi->wp_zones_written_size >=
+			    zbdi->wp_zones_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f))
 				zb->reset_zone = 1;
 		}
diff --git a/zbd.h b/zbd.h
index d425707e..161dd5e0 100644
--- a/zbd.h
+++ b/zbd.h
@@ -62,6 +62,9 @@ struct fio_zone_info {
  * @nr_zones: number of zones
  * @refcount: number of fio files that share this structure
  * @num_open_zones: number of open zones
+ * @wp_zones_size: total size of all zones with write pointers in bytes.
+ * @wp_zones_written_size: total size written to all zones with write pointers
+ *                         in bytes.
  * @write_cnt: Number of writes since the latest zone reset triggered by
  *	       the zone_reset_frequency fio job parameter.
  * @open_zones: zone numbers of open zones
@@ -82,6 +85,8 @@ struct zoned_block_device_info {
 	uint32_t		nr_zones;
 	uint32_t		refcount;
 	uint32_t		num_open_zones;
+	uint64_t		wp_zones_size;
+	uint64_t		wp_zones_written_size;
 	uint32_t		write_cnt;
 	uint32_t		open_zones[ZBD_MAX_OPEN_ZONES];
 	struct fio_zone_info	zone_info[0];
-- 
2.38.1

