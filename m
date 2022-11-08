Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB0AC4332F
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiKHItz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiKHItw (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:52 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEDB2E6A5
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897391; x=1699433391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0e75BK3EeLlNyRk/K5XhpYnSIylTnEzX0C9gHKzA4JA=;
  b=i9QezdBnF/NXOLXSySmesv16KKSwIrmhjSJSlVuGnK8XY1Y8/t01rEdX
   7/lU8/tgYKx2sg7QodUUU98tjXAWGgefyyX4rtEVYlX2vdhUQHvR719My
   2qAW772ApIqBA4tXrharDYOMnxH/VdwyuPM8zCzGJPW4mvCZnGngfFuT3
   z29/0mTXl6kmnA1pPhL3p640/dcBnYmZ1hO+VSOClvu21SV0tlbCybfZf
   1is6xCDhs1fPI6aOZzXxQkREdhNUfJyh7hWywk7SnY+LYdkggGlJFh1oZ
   I2C/Fzr1FOn+jtNVg8dZTChUq342XnKZC3uUVE/9tclbt9BRPfiI7vr4s
   w==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="215743468"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:50 +0800
IronPort-SDR: fNN2K8EICaUAvlxp0Wgp4VOLY0WcwQ/2bQmbkxWwyqBJU51xkR2hIthxnn1h0GTFbsmUXF2HT9
 j7ngDChW+oJqPdqj7QNq3eUKEk234uK0cAHo+d0qkdud2Ket9lPBzRBTh04KAQKy4rle97ZrP7
 /F6td4N3iw49qShjavUxO3XuTUFImE5kpau2qugt63+86FJhvx5o008tW86QQvopIOEGgjkeeb
 cpW1fc574Gk7Ac6LxjW3lUNUKkwhcCixlinLcJobUEXILGI9TWMX6J3mvSe/LKuGFOnKhNqBmm
 1+s=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:12 -0800
IronPort-SDR: DHUOF9viVfohDwx47BwM91OeWKskPgiKRVbfX5guxsQhUPbR8HwA4aIwZuuWyOKFa7MZVpBodf
 boPsaS8SKmbF1IGLG0M3ruRSvL4gtVXjmtA88V+mPHfOMAW0GxElvM32KTVQHRGHabhCPvgH3w
 xpgf0TJOxbKiyhxvTEKjWXyzUiaVZbVtSKaygNKHevWi5Kbsg2mrjQiy9vSIWZnDzh+oEhhLfD
 wehEmZQAGKvdabPIt2CIcn/8Y5FCkCKtgUIDtDRDNEiJYA/3tDaCGB5cS7Fkn2ioIJACs+tkDv
 YVI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:50 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 07/13] zbd: fix zone reset condition for verify_backlog option
Date:   Tue,  8 Nov 2022 17:49:34 +0900
Message-Id: <20221108084940.1574939-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
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
index fadeb458..6faacdac 100644
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

