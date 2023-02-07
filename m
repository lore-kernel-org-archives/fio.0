Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDB7C636D4
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjBGGhw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjBGGhv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:51 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD85A2916C
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751869; x=1707287869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f1Js0lu0XUfEKxPDjXmAZkcRWOnIDk7nWXFRd1mUkS0=;
  b=cb/qsirjN3GKn5puVRd2dRqyBHZCSpHLuOtgT3gPtS/4Xp1sqwYg+A2N
   J0uFD9mGcJr2AeKZ1fJYBJwXLROzDiwjyhp0dvdEAxgSZCjuWvnpKCHcv
   Eo1F5pv01r2HuGekuErQS/GT2QDBwr+QMm0t/4jfmv40Z14rakRvyHh04
   xcQykCAXT4qPNpdoFeze4UqQ10O90/p7AWnFAdAQjfxv3hZxlMbTvRLD0
   X02Z0+Y00cnW+qJWj3BOYSnQZbvnbJPsXsLBvzJqyS5KvyFtEpuS8X+yq
   cS73QIVYrWBzNogqKJC0APjZyOOv26FiLhJNitX0OXh7zcz9HKbnvbjLL
   A==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982667"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:49 +0800
IronPort-SDR: jJ8+H3bKh6HwZNmIjn8SAVR69Gmu2oeUmRXCqmzEYpr8e7lmbBpet3pbhstBDCjmUhR5XiHpUq
 bw4vj98f6WVfhKymU295voXSo0GC50y6EMgnGpb4ThLNgieIF+pGFgAaeAw6iwf2vpN32U5X2u
 XUfSokMHFpuUpbuqUsMsAQDAHQXaAz7KBQadQ5qK0j0cPU1rgIbKpZcPnLKrRFyPKw9eacNMr5
 iqxLMtGbo0F1b24w99ifjPcvw/vu8V6QOkJrGM8hOSImFUzfYt8Cbsxc7uQCo+2QRW08VpwA8J
 OaM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:55:06 -0800
IronPort-SDR: KvdIsOVPFMplytOYifFKFIAhdHFAIiynXyoqLcXGiyHtvoy/LhZWUYPgna3GWdN+HoKVAyb+JZ
 dmbUuv0YfGs2cFPT3lt0DnBzw4bzYkfe1C4VsilEjFlKM/w3JatVahH0ZNxLkCp0mLLhNKC3AM
 V5jVKY6eYUIfQc4tRKqBbuSk7gIsYxzypIVWmiIb7QJYP/XK3UDtIcaKLRJvDID/mqcCkVxDKw
 FQPDWFVIiUJLEJw+iIa5MBQzFEx6xwBFzP1wYQEk8aypWReyNC6kbblOmLhQnNYZddKDUK4Qyf
 2cQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:48 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 6/8] zbd: check write ranges for zone_reset_threshold option
Date:   Tue,  7 Feb 2023 15:37:37 +0900
Message-Id: <20230207063739.1661191-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The valid data bytes accounting is used for zone_reset_threshold option.
This accounting usage has two issues. The first issue is unexpected
zone reset due to different IO ranges. The valid data bytes accounting
is done for all IO ranges per device, and shared by all jobs. On the
other hand, the zone_reset_threshold option is defined as the ratio to
each job's IO range. When a job refers to the accounting value, it
includes writes to IO ranges out of the job's IO range. Then zone reset
is triggered earlier than expected.

The second issue is accounting value initialization. The initialization
of the accounting field is repeated for each job, then the value
initialized by the first job is overwritten by other jobs. This works as
expected for single job or multiple jobs with same write range. However,
when multiple jobs have different write ranges, the overwritten value is
wrong except for the last job.

To ensure that the accounting works as expected for the option, check
that write ranges of all jobs are same. If jobs have different write
ranges, report it as an error. Initialize the accounting field only once
for the first job. All jobs have same write range, then one time
initialization is enough. Update man page to clarify this limitation of
the option.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst |  3 ++-
 fio.1     |  3 ++-
 zbd.c     | 22 +++++++++++++++++++---
 zbd.h     |  4 ++++
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index d08f8a18..c71c3949 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1088,7 +1088,8 @@ Target file/device
 	A number between zero and one that indicates the ratio of written bytes
 	to the total size of the zones with write pointers in the IO range. When
 	current ratio is above this ratio, zones are reset periodically as
-	:option:`zone_reset_frequency` specifies.
+	:option:`zone_reset_frequency` specifies. If there are multiple jobs when
+	using this option, the IO range for all write jobs shall be the same.
 
 .. option:: zone_reset_frequency=float
 
diff --git a/fio.1 b/fio.1
index 54d2c403..80cd23b5 100644
--- a/fio.1
+++ b/fio.1
@@ -857,7 +857,8 @@ value to be larger than the device reported limit. Default: false.
 A number between zero and one that indicates the ratio of written bytes to the
 total size of the zones with write pointers in the IO range. When current ratio
 is above this ratio, zones are reset periodically as \fBzone_reset_frequency\fR
-specifies.
+specifies. If there are multiple jobs when using this option, the IO range for
+all write jobs shall be the same.
 .TP
 .BI zone_reset_frequency \fR=\fPfloat
 A number between zero and one that indicates how often a zone reset should be
diff --git a/zbd.c b/zbd.c
index 6783acf9..ca6816b9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1201,10 +1201,26 @@ static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t wp_vdb = 0;
+	struct zoned_block_device_info *zbdi = f->zbd_info;
 
 	if (!accounting_vdb(td, f))
 		return 0;
 
+	if (zbdi->wp_write_min_zone != zbdi->wp_write_max_zone) {
+		if (zbdi->wp_write_min_zone != f->min_zone ||
+		    zbdi->wp_write_max_zone != f->max_zone) {
+			td_verror(td, EINVAL,
+				  "multi-jobs with different write ranges are "
+				  "not supported with zone_reset_threshold");
+			log_err("multi-jobs with different write ranges are "
+				"not supported with zone_reset_threshold\n");
+		}
+		return 0;
+	}
+
+	zbdi->wp_write_min_zone = f->min_zone;
+	zbdi->wp_write_max_zone = f->max_zone;
+
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
@@ -1214,9 +1230,9 @@ static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
 		}
 	}
 
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->wp_valid_data_bytes = wp_vdb;
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_lock(&zbdi->mutex);
+	zbdi->wp_valid_data_bytes = wp_vdb;
+	pthread_mutex_unlock(&zbdi->mutex);
 
 	for (z = zb; z < ze; z++)
 		if (z->has_wp)
diff --git a/zbd.h b/zbd.h
index 20b2fe17..d4f81325 100644
--- a/zbd.h
+++ b/zbd.h
@@ -55,6 +55,8 @@ struct fio_zone_info {
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
  * @wp_valid_data_bytes: total size of data in zones with write pointers
+ * @wp_write_min_zone: Minimum zone index of all job's write ranges. Inclusive.
+ * @wp_write_max_zone: Maximum zone index of all job's write ranges. Exclusive.
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
@@ -75,6 +77,8 @@ struct zoned_block_device_info {
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		wp_valid_data_bytes;
+	uint32_t		wp_write_min_zone;
+	uint32_t		wp_write_max_zone;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
-- 
2.38.1

