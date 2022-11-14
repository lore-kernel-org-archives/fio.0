Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3F9C433FE
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiKNCN3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbiKNCN1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:27 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD7AB39
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392005; x=1699928005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=05je2xMy92F/I3p0NDWnqwiNnoJ6m2hHIQteETpAewc=;
  b=JTv5reRJ9EqsKlEEEyi+9fMPaRwwF5ktCODLiemFkv8cZLNwROlaJD4B
   FAFkWzxa6Q2077OGmfEPfYsnPkvhQmb9Sf+wWQDRP6NBnZy69vPYNU8rB
   /n9jNJa+GBc3Vbh05h+mc14zQAR12O2BInnlmYCnOEBGRWT9re2AcP+RR
   pqEvxsOx6ruyZh2ntEe3PM9JhHOmIX7JwbL2YM1ujWstRyZrGwWvWOPPO
   Y6IsmU+QmPhc2UH/eJXStwXnhRWq/l2BNMGxGJbx6QMl1e0v+PNI1dFau
   z1u08Yfh6vrbOA8Ch6GP8LUkjPKM9HnFRARXmEhilanleUM5zLUzXkjTV
   A==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279231"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:25 +0800
IronPort-SDR: SqSdadgEgV64xunFO/ccgDq/iwArbnrx1t0H9AEx7HeE2wKSiEWeiTlMB+cJJy/k7bCtS7b07Q
 jyGwNMt2aRwhAiNFhVNt7imP08lU6aiI7jZYJlInXgXyPujkRZ7Lf6Jie9Xcqffcng963LMh5U
 xa0/wvqaRhqPya0iwMohZz1afptZM177DEkHGf3Rh/zS222Yh3nuQr/95ATeBRIvzQvogeMoUU
 ipuB8qKm/bD7ecP/tgnbnzg3e/IIoN4AolYyT5b9P942ADg1WaQ1xEy0PGXp2mJkpC8wB1yRbJ
 PEI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:25 -0800
IronPort-SDR: qgJjPlFT3FS27M9LX7SchkNtuSEGEnHZ16HXsRZKHJ3UV53zS/vm684nSd2pvvThT+Y5Balmse
 Xq9pMnvB4mm8JSlRr2p/TwsJ8f2IwciH5hTOS8wT4YUja1fO4CidggZ83r8FGAMeYErzF93cGh
 Wguby9k+7S6f0U6lbn4W3hST8hL1cmifTGUPzrBC33On9L1apPIjBLeg3XmbDohSfAUfjrYW6d
 9vfoHOMB8l+ZlK2f+yMeHfyHfLldVM1o+G2WC/0OFQu2upmiLHW9tzERZmOGShWNqGnG7pDcgj
 fys=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:24 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 07/13] zbd: fix zone reset condition for verify
Date:   Mon, 14 Nov 2022 11:13:02 +0900
Message-Id: <20221114021308.1684141-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When data verification is requested, zbd_file_reset() resets zones only
when td->runstate is not TD_VERIFYING so that the data to read back for
verify is not wiped out. However, even when verify data to read is left,
td->runstate is not always TD_VERIFYING. When verify_backlog option is
set, or when block size is not divisor of zone size, zbd_file_reset()
can be called while td->runstate is TD_RUNNING. This causes verify
failures.

To avoid the failures, improve the check condition to reset zones in
zbd_file_reset(). On top of td->runstate, refer td->io_hist_len,
td->verify_batch and td->o.verify_backlog values to avoid zone reset.
This is same check as check_get_verify().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index fadeb458..97faa0e5 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1249,6 +1249,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
 	uint64_t swd;
+	bool verify_data_left = false;
 
 	if (!f->zbd_info || !td_write(td))
 		return;
@@ -1265,8 +1266,16 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing any data to avoid that a zone reset has to be issued while
 	 * writing data, which causes data loss.
 	 */
-	if (td->o.verify != VERIFY_NONE && td->runstate != TD_VERIFYING)
-		zbd_reset_zones(td, f, zb, ze);
+	if (td->o.verify != VERIFY_NONE) {
+		verify_data_left = td->runstate == TD_VERIFYING ||
+			td->io_hist_len || td->verify_batch;
+		if (td->io_hist_len && td->o.verify_backlog)
+			verify_data_left =
+				td->io_hist_len % td->o.verify_backlog;
+		if (!verify_data_left)
+			zbd_reset_zones(td, f, zb, ze);
+	}
+
 	zbd_reset_write_cnt(td, f);
 }
 
-- 
2.37.1

