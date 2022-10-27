Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7E1FA3741
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbiJ0GDK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiJ0GC4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:02:56 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C355E15B33A
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850550; x=1698386550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z2/YPy+pnpOSGMW3mzNDal5IlC48RISp+MZGHz/MjJg=;
  b=b0S3Ks14Btfq4YMzdaHtU0PwgZBSQ5PDRnoCW721Xo6ukYwhUGzGYTsT
   Yg+eQxs5zM4/lkURlT9JylFVMAy10iXBJVtQxidgjBGcmFbYIssQzF/C8
   J4h4qOIm5mXsB3HT5uoTdoMY3Dl9Xjy4gx2pBVnRx8TNBE3lVECm/pe7i
   PC8FhNi3ayYKZr+c+qUmYQjMGclNLCCDv3ZvX7sZp1KLAtiHNBvEq0X2W
   FDtsNUucXnUtMEFLv/YE6Vzav4vjhXpojysNTg6OS1PD0J8ORRN5XcsFQ
   YoAXbuiDkNF8KejHLp+QezOZ9emK6864ocC6nnqd4LQyTTKwJ/mCi7pmg
   w==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="215208194"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:51 +0800
IronPort-SDR: H+rBegrncvLJoAxAQYB/0oShLrSOfXxwE9vwVkZ6+LQQ9sDJrnsvCipQPRybC54uALwftnXXK+
 nmj6xMmOWy0FnUpN8LFwMtoLg0zgCggFx/Sl9suaVWj5uwGCTNkaqQY1TnPO1UBjDheG+9AR3x
 c0jMrU/DRExIHZF5RBCyB69VcjeAU6Xc7W5eypAich5RZpJDNAT6I1uDApqij42iieluxXv0yc
 jys+SimoZh7IbNb9hWWirpmLSPX6o1u/+FwS4pX4nCbliEXBPRUpIMaV6Evw382vHbfWMyOCID
 /hYix5NJxvXeIa3rUCabrDyH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:29 -0700
IronPort-SDR: /6lfVVb5gDv0k9qQOjz9AEEr9eKs7U2ITxTMdFV8ZRlg9H5t7q3QRe00+12cFPBt23lg4D2m7G
 7tZtjC8T5/o1h6lFIhwmDqD8kuVpbJi7ureOgtYAa+Okif1JjQZoT0QhP+TuWYCIAeAhHwjEU1
 yKEXB7J79PjhiIX1t6hT22AKy5qJGJj4K9s01004J2U4bj0eH49uUxvSNBnNQbY2Tln83GBfzh
 NJGV2zY2F+O0im7BYq7kFp0FaU5U3DXWMocKwsrHP5IIfvo4r+JyW8LlYJdVjbXRiLqJ8rLalD
 H48=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:50 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 07/13] zbd: fix zone reset condition for verify_backlog option
Date:   Thu, 27 Oct 2022 15:01:33 +0900
Message-Id: <20221027060139.952508-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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
index e1844e87..2a92ba60 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1248,6 +1248,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
 	uint64_t swd;
+	bool verify_ongoing;
 
 	if (!f->zbd_info || !td_write(td))
 		return;
@@ -1264,7 +1265,10 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
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

