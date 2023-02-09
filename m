Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD562C05027
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBIHJU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBIHJT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:09:19 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EF11C32D
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675926557; x=1707462557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JuIHCtNoJuWFSYLd5qeJePsioaXVZZrNk2GAVMvHvH8=;
  b=Mhm2+aVCLuo55x5FqAnmUEovo7P/AfGJ5ZNz0cRkDIkYIMr6tJiY7vQn
   g6Iw8ZPjSzSyPXIbf8gjrJkXtkXYHqek3s0/TmnDoKlCg8j7Ltj5bXd6m
   jpi77u+tpiSZaFO0hxINbJddX0sS88nDo/a76UqdOovKx9cE2SutxbfoP
   JYj/JyYan3JvfGnyvQ2i2nR4uRDcmOAwLjJKT3YShWmoNOiU3pkG+VOY2
   Dd1xJklkecfgMWNB04nB9/jDKElSDskiKOYXVAl3SgEJLMLy/2OCWOWeX
   1qK8cpNsbJCOTV43AJla9l2hV8l7Qovolu40Nz/jTHL45yvQ0rKSvEGby
   g==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="334848081"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:09:17 +0800
IronPort-SDR: /vCQ8dO7n+380FUeJLhMPhsObhlVcimbhqKKuKdIhxzcSCUAWcJJdIHIuiuObwDHTAl+WArYkT
 UW511mcBuHmoWcrEQbXpJRafTQr6MdeWkPnDt+Q7blHf4/OpRMregA/ebkO2gltQ9FvEg+wGfJ
 dWDTDgv9jUqfh2HPiATB4T4HVrqs5YTeBOR+ehrUhykjazMrciNIAi4bghXc3tfOOk2NNK/hnw
 3R2nbWPUBi9tklzrrUJKAzUIYdh6tJ1JF0y4nc06QBNca6fjbfrEjKvQUcl1yUkodzIDyY3xKz
 XPU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 22:20:47 -0800
IronPort-SDR: 5+T6MBwRjBrTrEhGdujZK5ObzdLmPUOlqK+2B2V4gO1ZImu7eSNykMumHsRD/vyP391wSF5Hy/
 RlR6cOQMnxYPRGPLQCNoK+dkVsNN3fvfzAPVrm+GUZAcRYlvHQatVA+1lBb4giOv0+uRsGaGYd
 xN4l1MMLQdD1RMAbai0x5ZnSq+UIFK0pacBd4o1d5Fc7NabiNXnlqV7i2Ti6bt1tMo7sWhE6qf
 9PDGKIXweEshmtiUzqJBJpI3JT1zEenmWEcn6jPQPkPUCgSYa8mv4vYSfdwldZ28Oj01BbvzQq
 Z7Y=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Feb 2023 23:09:16 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 6/8] zbd: check write ranges for zone_reset_threshold option
Date:   Thu,  9 Feb 2023 16:09:05 +0900
Message-Id: <20230209070907.1733138-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
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
 HOWTO.rst |  4 +++-
 fio.1     |  3 ++-
 zbd.c     | 31 +++++++++++++++++++++++++++----
 zbd.h     |  4 ++++
 4 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index a5f8cc2d..158c5d89 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1088,7 +1088,9 @@ Target file/device
 	A number between zero and one that indicates the ratio of written bytes
 	in the zones with write pointers in the IO range to the size of the IO
 	range. When current ratio is above this ratio, zones are reset
-	periodically as :option:`zone_reset_frequency` specifies.
+	periodically as :option:`zone_reset_frequency` specifies. If there are
+	multiple jobs when using this option, the IO range for all write jobs
+	has to be the same.
 
 .. option:: zone_reset_frequency=float
 
diff --git a/fio.1 b/fio.1
index 3556ad35..00a09353 100644
--- a/fio.1
+++ b/fio.1
@@ -857,7 +857,8 @@ value to be larger than the device reported limit. Default: false.
 A number between zero and one that indicates the ratio of written bytes in the
 zones with write pointers in the IO range to the size of the IO range. When
 current ratio is above this ratio, zones are reset periodically as
-\fBzone_reset_frequency\fR specifies.
+\fBzone_reset_frequency\fR specifies. If there are multiple jobs when using this
+option, the IO range for all write jobs has to be the same.
 .TP
 .BI zone_reset_frequency \fR=\fPfloat
 A number between zero and one that indicates how often a zone reset should be
diff --git a/zbd.c b/zbd.c
index 6783acf9..89379431 100644
--- a/zbd.c
+++ b/zbd.c
@@ -542,7 +542,7 @@ static bool zbd_using_direct_io(void)
 }
 
 /* Whether or not the I/O range for f includes one or more sequential zones */
-static bool zbd_is_seq_job(struct fio_file *f)
+static bool zbd_is_seq_job(const struct fio_file *f)
 {
 	uint32_t zone_idx, zone_idx_b, zone_idx_e;
 
@@ -1201,10 +1201,33 @@ static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t wp_vdb = 0;
+	struct zoned_block_device_info *zbdi = f->zbd_info;
 
 	if (!accounting_vdb(td, f))
 		return 0;
 
+	/*
+	 * Ensure that the I/O range includes one or more sequential zones so
+	 * that f->min_zone and f->max_zone have different values.
+	 */
+	if (!zbd_is_seq_job(f))
+		return 0;
+
+	if (zbdi->write_min_zone != zbdi->write_max_zone) {
+		if (zbdi->write_min_zone != f->min_zone ||
+		    zbdi->write_max_zone != f->max_zone) {
+			td_verror(td, EINVAL,
+				  "multi-jobs with different write ranges are "
+				  "not supported with zone_reset_threshold");
+			log_err("multi-jobs with different write ranges are "
+				"not supported with zone_reset_threshold\n");
+		}
+		return 0;
+	}
+
+	zbdi->write_min_zone = f->min_zone;
+	zbdi->write_max_zone = f->max_zone;
+
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
@@ -1214,9 +1237,9 @@ static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
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
index 20b2fe17..05189555 100644
--- a/zbd.h
+++ b/zbd.h
@@ -55,6 +55,8 @@ struct fio_zone_info {
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
  * @wp_valid_data_bytes: total size of data in zones with write pointers
+ * @write_min_zone: Minimum zone index of all job's write ranges. Inclusive.
+ * @write_max_zone: Maximum zone index of all job's write ranges. Exclusive.
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
@@ -75,6 +77,8 @@ struct zoned_block_device_info {
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		wp_valid_data_bytes;
+	uint32_t		write_min_zone;
+	uint32_t		write_max_zone;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
-- 
2.38.1

