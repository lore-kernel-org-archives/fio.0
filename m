Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3302C64EC4
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjBGGhq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjBGGhq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:46 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69275222E7
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751864; x=1707287864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K/uqivJKEjKxZ6V6HOkPXYid/UQQAd1EnmJy3P0jSaI=;
  b=elBc/WrkR2Qubb4JdWsZwznZwN0nYg+agn8IB6RhAhXepZP/Aawq40O/
   ZDYOCXFcp7tq04INONNg6ZNjhooWExbUsl24KYsbWB2VpfQ1QuYudY2f6
   Clx8MSq0h98XHtBdSvH9S0jwZUpvX9SRlGxuc9mNQYl7aWB5PqSKhfr60
   dY1m23iR0QgKz+IRPr9Tas9rsOx2J+UGM1MuH4yOSeWPY9s3tnmtfGid8
   bSJhftmT+r9sf+9vVh0rX8K+qR8ew3oCaHDNx2eJ1EJ54So/30Lr9MkfQ
   S58OI12Qmsepz0lvrIt2/ZDhKb9+wSMKe/8ykV/sbuJsGR+vzFgHUxdi6
   g==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982652"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:44 +0800
IronPort-SDR: SWcjF+tsn59OFEYPnIT8u59C3rUoxtyDRLX54TZcmRXCiU9ZZSKRk8lIIMIuy8lIYA4F9NLtfZ
 Q6U/+rO8hcyVdLEB/KJOSU6McIHsn4Pv6Nf1kyGVuvbj0Dylketio3VvVAsKBHCLvM3ntioaD1
 GzvB2qWWkgGKut0XNHqVZbfvpAgUyUGFHqosb34tONexthvGeZdcShwLAIFt0CaaCjjDpeXkTj
 ILYFAePqkNG5idgLWq27hpdeCnbsBGIiDwpr12NslxpEBSxv/EZVyeZN4KAg/JhJuyGPKeh54w
 QHQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:55:00 -0800
IronPort-SDR: snmyPqrRpZ+viHO/xOzsRB/Xbsy64swhTdu839NpqxBTxle9/9uSWbwKMgTTAdpr5LNfI0hGdh
 F/n1yVFWA/VqudXU5C+6iRyJ1VEgNqGOWgQQ20gjRqCVeN2N5GswXYJogTFjP8OstU+cpN3f+9
 +3MQOIhKdht2DNwjV1+xoh9nf1XPmFY22okHHF1xz8EMjsKv6c2Hu7YHys3Rd0qFy/WbIipidS
 +iVVJkivZN4+N48DKNI6CrDoNVaNXMzUBcwwEIyEG8v0pWIA56YrxT1Av8vMLpTGvqs3SstqBy
 zj0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:42 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/8] zbd: remove CHECK_SWD feature
Date:   Tue,  7 Feb 2023 15:37:33 +0900
Message-Id: <20230207063739.1661191-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
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

