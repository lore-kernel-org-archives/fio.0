Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D42C636CD
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjBGGh4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBGGhz (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:55 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA8C2CFDA
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751871; x=1707287871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g6HnyVyU0H5CjyCKKbk4GmZksiOnr1BF9jI+sGKgARc=;
  b=LMOYAn+u2yUbeQFAsfoFMapVIffGaUyrlldhEfe30MsHuzSPfseVFzks
   3H6Ioq60WAtwTfPPtFOqAAagM3SNJ7rxl79PsoSLO6fWUdl1wB8976IGO
   5UTuBn6W1KI9DCDiP1lrk4dkQJveoroMYHPyC1IGv06lnGpa+Y5RC4Pc7
   ifkm6I4WtIzf0VoDbXc1AcOUkFUWEILfP5dd4tqf5p28EFVKNLb/Le8b0
   lWWlpsKDgFwK9e8ZqzbiuniKbSRO4JWHbDsCoy4B2DHhfPRPkSWQe3uYY
   s3tuig+X8BZYFoyw1OV/XDkm8NNsLIy85ehEo9cQxk7b4L1812oFYvbno
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982669"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:51 +0800
IronPort-SDR: +EpWjRS3PKh9uRplnUdBz97AX5dW7mfWyUEHSgbBWRn95WYyfMKVD7xN4VG8j/qUWL6yZaW9LI
 D5hkhy3AI6iAKh8DjR8TA6zdt7UEuR6gijlCIF/QcPkIjX7BDmWpqm71+NFUWseepz7cZSYs/+
 G7L2YfqB9IKyU9SeuMvjHD51/GNXHWk+kucI2WR8yTExvp4/Z910rx+Rfc+NibBCNy9H8dNHPJ
 /xW6ikx8kpEkrDPANin0sQo6FfBTtSFbZJMayhW/oGbaRtig5CwqjqcLwrpRL38eAGSP3dkoLy
 5O8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:55:07 -0800
IronPort-SDR: 1+s/t3nevIGjXyyl/mXhLOaIOPlZmjWxcIGH+aLmPdh//GP6pP1pqquEBsM/mw0LF/uFiY9coc
 5we2ZD/jPG9hnpvf6r0Wztfv0YlD3Xgd54PyUoioTViywV61z5AEpLHrkDVaYM/r1zRpB6bvg9
 yc2r62DguyUXNtwNPU74awd1bCKXl/gMMR9n4+G8cf0MI5rgrS3riXCoqXo/4AiCxXaRNdbqqL
 kSCiVM527ozVcxfZLfwr1UG4oZ97ycnTmxYWusAuNP2j3DBtnY7yZpAFf5varwiciQydB/4TVh
 6S4=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:49 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 7/8] zbd: initialize valid data bytes accounting at file set up
Date:   Tue,  7 Feb 2023 15:37:38 +0900
Message-Id: <20230207063739.1661191-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
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
reset to file set up before job start. It allows to access the write
pointers and the accounting field without locks. Remove the lock and
unlock codes which are no longer required. Ensure the locks are not
required by checking run-state in the struct thread_data.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 93 ++++++++++++++++++++++++++++-------------------------------
 1 file changed, 44 insertions(+), 49 deletions(-)

diff --git a/zbd.c b/zbd.c
index ca6816b9..a464d6df 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1074,6 +1074,44 @@ void zbd_recalc_options_with_zone_granularity(struct thread_data *td)
 	}
 }
 
+static uint64_t zbd_set_vdb(struct thread_data *td, const struct fio_file *f)
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
@@ -1099,6 +1137,7 @@ int zbd_setup_files(struct thread_data *td)
 		struct zoned_block_device_info *zbd = f->zbd_info;
 		struct fio_zone_info *z;
 		int zi;
+		uint64_t vdb;
 
 		assert(zbd);
 
@@ -1106,6 +1145,11 @@ int zbd_setup_files(struct thread_data *td)
 		f->max_zone =
 			zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
 
+		vdb = zbd_set_vdb(td, f);
+
+		dprint(FD_ZBD, "%s(%s): valid data bytes = %" PRIu64 "\n",
+		       __func__, f->file_name, vdb);
+
 		/*
 		 * When all zones in the I/O range are conventional, io_size
 		 * can be smaller than zone size, making min_zone the same
@@ -1197,54 +1241,9 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
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
-	if (zbdi->wp_write_min_zone != zbdi->wp_write_max_zone) {
-		if (zbdi->wp_write_min_zone != f->min_zone ||
-		    zbdi->wp_write_max_zone != f->max_zone) {
-			td_verror(td, EINVAL,
-				  "multi-jobs with different write ranges are "
-				  "not supported with zone_reset_threshold");
-			log_err("multi-jobs with different write ranges are "
-				"not supported with zone_reset_threshold\n");
-		}
-		return 0;
-	}
-
-	zbdi->wp_write_min_zone = f->min_zone;
-	zbdi->wp_write_max_zone = f->max_zone;
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
@@ -1252,10 +1251,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 
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

