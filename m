Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696A8FA3740
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJ1LyK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJ1LyH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:07 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C168C1D2F56
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958046; x=1698494046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=224OeXZYprGzXNw0SVvjFlrQ7aYXOAVKvwCSHtWvT30=;
  b=STOmFp+C2NkN8DMVyXLZ+ZXh3FDL6zOm4D6uQ9Ty1Hj9d6cE5IIwLAEP
   16yqtnf/isWBuclhMazglWEBfGH82/jIsoY9iMk1WAtlUF2SXpTYhXeKt
   ENZRJ6FfGZb92YdspoRP6c+oRteOUtDjBWbNTnf5vSFoUONfX4BHWdJ7p
   mZagAUJ1gcm94uG+u5SX/KxvJzKsbcgpMGfb9KNQdLrrxKHXvF13bL8Pj
   2CqVSVhDNmuGzs7n42riQfxflOCrtiBs2pu79cNK9Pt+5T+VTuVBXVcrt
   WXmXAcqdVhWNesruzeLVkR/gEoQh1Y043oOUGdFHTAWhIzC03gQI+wHH+
   A==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074531"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:06 +0800
IronPort-SDR: UJ3GL05D4aSB2pMR8ZwIDYWIBz1WK7LjnlNvL/nZYBoQnBwt9FN6H/mCz2M6nQH/WzR/sP+C8N
 dlRzDhnxB0YSF3yfMlHpgIuDrUggkx7LSyNOTV0pVGHdBUE1Kmf1dP7yzPDYciZaey564t+GOg
 4kNbCNp7KA5W52latMNqSlwBb17e/vG7vqVm4pc/C6pYUHH5MXnjRt80FPLrgMgutSSc55tKSD
 k9pn7xSHiT6IuRqe9TumM3CTC/1Aa5gMD3E8SqyJlOdclV+eUFib0AgXyLCU78Dwm5h6Ln7klg
 uHI5079OF6ia8Ffdjp6nOriU
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:42 -0700
IronPort-SDR: Uqx+YmGmKlp7a0HCPxK1hDgzBoK4Zjdfahwhdy4QqEOTQlf1Vh2nC8aNEIIv0YTN6FWZbmpSel
 7V0mA7hhzgi4WEG3OLsSFz/Cvobm7u3l77b33Y6Bu/RBeUpzzyB2DA8GgJSF/qiWHK/iubPp4r
 vODANBwQB5uPNLXGzYNMbvwkumPxGHDErUK/ceZt27bVvXNX60f9v+7Q4Wd9iJprnMeSrXfx7s
 iIYqL4nJ0HILvzVX9dxKIN/2bTyHSIytQT7MaYJ9TUKS6Z0GGosCky78Kg4aC9L0CJa0pFQ4dN
 e0c=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:06 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 07/13] zbd: fix zone reset condition for verify_backlog option
Date:   Fri, 28 Oct 2022 20:53:48 +0900
Message-Id: <20221028115354.971715-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When data verification is requested, zbd_file_reset() resets zones only
when td status is not TD_VERIFYING so that the data to read back for
verify is not wiped out. However, when verify_backlog option is set, the
verify data can be left even if td status is not TD_VERIFYING. This
causes verify failure.

Fix this by improving the condition to reset zones in zbd_file_reset().
Refer not only td status but also verify_batch and io_hist_len values to
avoid zone reset when verify_backlog option is set. This is same check
as check_get_verify().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index af761c17..54bbc82b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1249,6 +1249,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
 	uint64_t swd;
+	bool verify_ongoing;
 
 	if (!f->zbd_info || !td_write(td))
 		return;
@@ -1265,7 +1266,10 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing any data to avoid that a zone reset has to be issued while
 	 * writing data, which causes data loss.
 	 */
-	if (td->o.verify != VERIFY_NONE && td->runstate != TD_VERIFYING)
+	verify_ongoing = td->runstate == TD_VERIFYING || td->verify_batch;
+	if (td->io_hist_len && td->o.verify_backlog)
+		verify_ongoing = td->io_hist_len % td->o.verify_backlog;
+	if (td->o.verify != VERIFY_NONE && !verify_ongoing)
 		zbd_reset_zones(td, f, zb, ze);
 	zbd_reset_write_cnt(td, f);
 }
-- 
2.37.1

