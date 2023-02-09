Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B78C636D4
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjBIHJN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBIHJN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:09:13 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F0116AE7
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675926552; x=1707462552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0B3XzdbY0eNAl7nG4Lh2uRBNdnvInMxkkWgmWWJRhkQ=;
  b=MzlsRCrsDDAL5yXkNCvi/au736YpXrmXuwxHvRAJUX76Pt4dH6NBd8/5
   IK3JG26/qtqDORd2WkWPsYEgac3oKpp9wiY4shiLBOBfG2HaTHRTkW+mf
   ebbGYw3LiKI5MhAEF2855u1oebKwVIBVak4ApISukWh4Hk/ZdVl9Ms2sC
   7P5tr1EDSLCSzYuo6m/HKxtmab5kwfpFt1kIXYFFRP8QQFyUbg+hfcg1A
   p2tKbTkndL+hAVEHSiPArdfyq4ptts+7R+DKoQBiwSsK4pK/P59nd+He2
   DApXKI5QDpLJf5NWeZgswhI274C9HF0pzVlqFU2JeOVK3TgnYKTN3zTCu
   A==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="334848071"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:09:11 +0800
IronPort-SDR: 6Q9UXWsj33SoXRgoBm7+qJOrlw4XaFCkLjO8iCVWXVDXpOODzPMyRD5SqjHacJdud3+5zogD/9
 2I3/Dq9jhxn2vZFpgymYLeqRz0AJEOV9rBQBhOXDb/Ft9hQ33PM8Ygu9PnTg9hzZAyA8k7KpLF
 VW1TnrsH9kert/jCVPnQIx2rowqadJjwxChtMm9G6iq+kje2iawn9NEDrG1Lk4UojlLh6rjab2
 dkcUuoyZNwb5eRjeHWU7QXKfmma5IHwXx9HSLQn8dm97Yg08IuCJ2LGf03DrwZZcbkJu/RskdF
 U5E=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 22:20:41 -0800
IronPort-SDR: tIA6UjxcspUIGokgZ4Q9nzS8c26jLy+g4DWB7aVxfKsXwAbFa8D/LI6+Qd1wf/pa5vhXR91uqH
 y4cGOsS4oA4W9pCubG/vxkxwwAbcjWF25Po4iLk6AF9TA78YevOFR2AOItSCjdfcNlHLTrzsfo
 XJ17fd+xq2YoXShb2XqC+p8bB5ZjcswbU+Vi+/poM9N3b17yYBEm22kf4/J2ov1OM50lD6NwpK
 r2bTXitDJQdAPtD3SXKN6apbvp3UbRwqJgpVj25O2qd28ARtZOR1QrpMgplmHvxb/DNT6fG7Hx
 MBk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Feb 2023 23:09:10 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 2/8] zbd: remove CHECK_SWD feature
Date:   Thu,  9 Feb 2023 16:09:01 +0900
Message-Id: <20230209070907.1733138-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The 'sectors with data' accounting had been used for CHECK_SWD debug
feature. It compared expected written data size and actually written
data size for zonemode=zbd. However, this feature has been disabled for
a while and not actively used. Also, the sector with data accounting has
two issues. The first issue is wrong accounting for multiple jobs with
different write ranges. The second issue is job start up failure due to
zone lock contention.

Avoid using the accounting by removing the CHECK_SWD feature and related
code. Also rename the function zbd_process_swd() to zbd_set_swd() to
clarify that it no longer works for CHECK_SWD.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 38 +++-----------------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/zbd.c b/zbd.c
index f5e76c40..b6cf2a93 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1190,14 +1190,7 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
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
+static uint64_t zbd_set_swd(struct thread_data *td, const struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t wp_swd = 0;
@@ -1212,14 +1205,7 @@ static uint64_t zbd_process_swd(struct thread_data *td,
 	}
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	switch (a) {
-	case CHECK_SWD:
-		assert(f->zbd_info->wp_sectors_with_data == wp_swd);
-		break;
-	case SET_SWD:
-		f->zbd_info->wp_sectors_with_data = wp_swd;
-		break;
-	}
+	f->zbd_info->wp_sectors_with_data = wp_swd;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	for (z = zb; z < ze; z++)
@@ -1229,21 +1215,6 @@ static uint64_t zbd_process_swd(struct thread_data *td,
 	return wp_swd;
 }
 
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
@@ -1255,7 +1226,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 
 	zb = zbd_get_zone(f, f->min_zone);
 	ze = zbd_get_zone(f, f->max_zone);
-	swd = zbd_process_swd(td, f, SET_SWD);
+	swd = zbd_set_swd(td, f);
 
 	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n",
 	       __func__, f->file_name, swd);
@@ -1677,7 +1648,6 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	zbd_end_zone_io(td, io_u, z);
 
 	zone_unlock(z);
-	zbd_check_swd(td, f);
 }
 
 /*
@@ -1866,8 +1836,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
-	zbd_check_swd(td, f);
-
 	zone_lock(td, f, zb);
 
 	switch (io_u->ddir) {
-- 
2.38.1

