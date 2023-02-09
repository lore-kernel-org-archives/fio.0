Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24F2C05027
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBIHJX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBIHJV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:09:21 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921221C32D
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675926559; x=1707462559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LuYs+gddgLf0hi6yYsEr65JKr3hbG5j2iROVQsojqss=;
  b=FxS3TZZWyjkRAUiUnEb3Fcv7jVt0C/Pn3vO/mo5DNaCCWjSqpPtKdxAY
   wSABxzF9dkOLEYAaIuD/V7wAUJxY2Y/NOkxAJqdjSFXWGgYAGkWz8HKZP
   v+oYOTFgRhgtiiIJUvkXPhjuHv04n0L/M4efvoMn64jIQuVBjz5HZHFM7
   r7s8PzwTKXszy6tXgCtHJLddoRdfWbQ9Rgb5mB4ElSYNkFbACuRiiRXfV
   KtlRpbcf3ijrhCebMA5K4N04z1DYQdFMViCXG452++z5E303RQSbgjyWY
   oGRPE+I+ev9PnJVNvudrmEXCCha6WvdP8q+i16IH4Xh+3CeJNZ6aqpHcD
   g==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="334848085"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:09:19 +0800
IronPort-SDR: anFPiQqxoz7JLrLSufyK+4ZPH1Jocx0NPQ+1qo34/SFu4GWP2BHA5qVhiWiqKewkuQFnCRKttT
 I36ZC1sWOBR2qPlzAjksMr3KJLNOTyaFqMTedVF6bqlg+IWjab15ijb0Rp62Oep0qkBqosxkBB
 T146YL5/rK0dNY/nHvZbZnkQ9DZD7/RZjgL3mpk23b5sTshiDz1Ke4J+z+fwALsKLRjbXtoBmr
 4zWtUQwgV9rxqBryj539uieo07LAA5EPTJgLk/o92gaLGz1AqiOYmTtLUz2FLM+i6qBboP5w9P
 qLU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 22:20:49 -0800
IronPort-SDR: j9D988ir2jOOpnzgXx5nvlQlMuY3DlwBOY2tDKzAJXxJuO3D1MJnwjH/sX7f36XZbnMyc+UPuZ
 kGSJZ7UWXWuVmbwaugAAPRX5WT5KJ55u1cx9UuaT19+jAB8yhPM3JM2KQiNSmf38FOQQgiBkPU
 6ZWo/EiddvLdtKhsjqvgUXUhDvUd2xEVCjF/VAtPvyNJ5jsYYqsztIathVYjwI7uWNjlM5iEOG
 tYcOvJZ8eZAa0nkemlUOpnp48jWM7z3TuL1NwnzH5Hl8UJzslprt1Z0rhkMSsmUq2dTuxfCu/P
 U/o=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Feb 2023 23:09:18 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 7/8] zbd: initialize valid data bytes accounting at file setup
Date:   Thu,  9 Feb 2023 16:09:06 +0900
Message-Id: <20230209070907.1733138-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The valid data bytes accounting field is initialized at file reset,
after each job started. Each job locks zones to check write pointer
positions of its write target zones. This can cause zone lock contention
with write by other jobs.

To avoid the zone lock contention, move the initialization from file
reset to file setup before job start. It allows to access the write
pointers and the accounting field without locks. Remove the lock and
unlock codes which are no longer required. Ensure the locks are not
required by checking run-state in the struct thread_data. Also rename
the function zbd_set_vdb() to zbd_verify_and_set_vdb() to be consistent
with other functions called in zbd_setup_files().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 108 ++++++++++++++++++++++++++++------------------------------
 1 file changed, 52 insertions(+), 56 deletions(-)

diff --git a/zbd.c b/zbd.c
index 89379431..ba2c0401 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1074,6 +1074,52 @@ void zbd_recalc_options_with_zone_granularity(struct thread_data *td)
 	}
 }
 
+static uint64_t zbd_verify_and_set_vdb(struct thread_data *td,
+				       const struct fio_file *f)
+{
+	struct fio_zone_info *zb, *ze, *z;
+	uint64_t wp_vdb = 0;
+	struct zoned_block_device_info *zbdi = f->zbd_info;
+
+	assert(td->runstate < TD_RUNNING);
+	assert(zbdi);
+
+	if (!accounting_vdb(td, f))
+		return 0;
+
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
+	zb = zbd_get_zone(f, f->min_zone);
+	ze = zbd_get_zone(f, f->max_zone);
+	for (z = zb; z < ze; z++)
+		if (z->has_wp)
+			wp_vdb += z->wp - z->start;
+
+	zbdi->wp_valid_data_bytes = wp_vdb;
+
+	return wp_vdb;
+}
+
 int zbd_setup_files(struct thread_data *td)
 {
 	struct fio_file *f;
@@ -1099,6 +1145,7 @@ int zbd_setup_files(struct thread_data *td)
 		struct zoned_block_device_info *zbd = f->zbd_info;
 		struct fio_zone_info *z;
 		int zi;
+		uint64_t vdb;
 
 		assert(zbd);
 
@@ -1106,6 +1153,11 @@ int zbd_setup_files(struct thread_data *td)
 		f->max_zone =
 			zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
 
+		vdb = zbd_verify_and_set_vdb(td, f);
+
+		dprint(FD_ZBD, "%s(%s): valid data bytes = %" PRIu64 "\n",
+		       __func__, f->file_name, vdb);
+
 		/*
 		 * When all zones in the I/O range are conventional, io_size
 		 * can be smaller than zone size, making min_zone the same
@@ -1197,61 +1249,9 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
-static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
-{
-	struct fio_zone_info *zb, *ze, *z;
-	uint64_t wp_vdb = 0;
-	struct zoned_block_device_info *zbdi = f->zbd_info;
-
-	if (!accounting_vdb(td, f))
-		return 0;
-
-	/*
-	 * Ensure that the I/O range includes one or more sequential zones so
-	 * that f->min_zone and f->max_zone have different values.
-	 */
-	if (!zbd_is_seq_job(f))
-		return 0;
-
-	if (zbdi->write_min_zone != zbdi->write_max_zone) {
-		if (zbdi->write_min_zone != f->min_zone ||
-		    zbdi->write_max_zone != f->max_zone) {
-			td_verror(td, EINVAL,
-				  "multi-jobs with different write ranges are "
-				  "not supported with zone_reset_threshold");
-			log_err("multi-jobs with different write ranges are "
-				"not supported with zone_reset_threshold\n");
-		}
-		return 0;
-	}
-
-	zbdi->write_min_zone = f->min_zone;
-	zbdi->write_max_zone = f->max_zone;
-
-	zb = zbd_get_zone(f, f->min_zone);
-	ze = zbd_get_zone(f, f->max_zone);
-	for (z = zb; z < ze; z++) {
-		if (z->has_wp) {
-			zone_lock(td, f, z);
-			wp_vdb += z->wp - z->start;
-		}
-	}
-
-	pthread_mutex_lock(&zbdi->mutex);
-	zbdi->wp_valid_data_bytes = wp_vdb;
-	pthread_mutex_unlock(&zbdi->mutex);
-
-	for (z = zb; z < ze; z++)
-		if (z->has_wp)
-			zone_unlock(z);
-
-	return wp_vdb;
-}
-
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
-	uint64_t vdb;
 	bool verify_data_left = false;
 
 	if (!f->zbd_info || !td_write(td))
@@ -1259,10 +1259,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
-	vdb = zbd_set_vdb(td, f);
-
-	dprint(FD_ZBD, "%s(%s): valid data bytes = %" PRIu64 "\n",
-	       __func__, f->file_name, vdb);
 
 	/*
 	 * If data verification is enabled reset the affected zones before
-- 
2.38.1

