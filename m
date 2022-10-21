Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E964C4332F
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJUGe2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiJUGe0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:26 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E355A65B0
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334063; x=1697870063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M09LQsdQ4Htdk1Vn04m8+hyrL6HleLcgPIl31c3oFA4=;
  b=lEVDLlojmDZtpqTU2n8iKFJPDvEpHaAkkB+MTv+1KsWU27xquTGxAxvp
   6hHiid+E7rAD8cnVD/n8+HhmEgsO9ZXrXudU6eHSbUdaFKpTtJgk01fZz
   xQPU5I1rHmjrf2WyvOAdv3KAbmEtBuQZ8kOi35jn834gsMRZgh57ZCr0J
   QaShs6Hm6arw8zOk3mT2wl3YzX3amFl1nGO0h4RqdaysmoMn7H5tn6cdu
   7RwE+cQKqurixPT+oZeiDhQFcKOLVTiCpooYJBWy1aQFXWir9ogPZ2srI
   HQA9OkAQgh+zdZ6H1D29iyHOZcVjfL7Du9oCXTaSj0koPI9IRmTwLSN3x
   A==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733106"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:23 +0800
IronPort-SDR: wk81+yRQMhUjQc7cQEzw2Lnu7s5p5vuSUbHX7vCDfqbXrMn1M/iY85s/RtLwARVZ5uywk1wu9a
 xmXzVON+H9y/xXdTxk6qhIxpP7/NeopRjUS77pa2xIPehoaiEJCOhq1TUT4oRB2SUH0KDW7bPI
 0lXQDSaklTxVKdt9X0Ppk2FKVGUmfYGn6sqepeYeRVVayOcCg9gYBm1YkjE0d9CpbLNt4cOwpW
 xesbYV3ewFrOaazIVzzKuy37c764X+GIGF70j66NDCGq7VCqKAe7veJ/y25bafaSHuunBlZ6AI
 O5Izn28ySlj7lVkupGypF1rw
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:11 -0700
IronPort-SDR: tyJoZO6Ft5zHL1bQfIFboTgvVbonAV6Abji61GIrsDk16M1+wi8YKV2e2JYObAmRgOr4Ge23jb
 074rasA8IQRLmv2XmW6y9y3PHaF1iJ7X5S/nRahcXutvjHNfhhBqhUhH9rbyYdrhQi9RygJfsE
 EVH5D+EfYNI9uYpQvrZT9hZF4If2GqqrO1zTmp5NUcP4F0zjTghrMAyghBCz9ThYW606XvlWfu
 HTiTMbSxqwNI90wtgjKUPEOg/mwuxVEEBWSFJzGe1Vup04qUkCKYGqrZbj9qYxtiOUus4op+FU
 DZE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:23 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 04/11] zbd: allow block size not divisor of zone size
Date:   Fri, 21 Oct 2022 15:34:09 +0900
Message-Id: <20221021063416.860438-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Current implementation checks that block size is divisor of zone size
when verify work load is specified. After the recent fix of block size
unaligned to zone, this check is no longer valid. Remove the check.

The check had been valid since such block size left unwritten area at
each zone end and keeps the zones in open/active status until verify
read is done. It easily hit max open/active zones limitation. After the
fix, the zones with unwritten area are finished then they do not hit the
limitation.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/zbd.c b/zbd.c
index 55c5c751..61856ad1 100644
--- a/zbd.c
+++ b/zbd.c
@@ -649,7 +649,7 @@ static bool zbd_verify_bs(void)
 {
 	struct thread_data *td;
 	struct fio_file *f;
-	int i, j, k;
+	int i, j;
 
 	for_each_td(td, i) {
 		if (td_trim(td) &&
@@ -671,15 +671,6 @@ static bool zbd_verify_bs(void)
 					 zone_size);
 				return false;
 			}
-			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
-				if (td->o.verify != VERIFY_NONE &&
-				    zone_size % td->o.bs[k] != 0) {
-					log_info("%s: block size %llu is not a divisor of the zone size %"PRIu64"\n",
-						 f->file_name, td->o.bs[k],
-						 zone_size);
-					return false;
-				}
-			}
 		}
 	}
 	return true;
-- 
2.37.1

