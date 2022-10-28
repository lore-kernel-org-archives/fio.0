Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A19C38A02
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJ1LyI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiJ1LyG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:06 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211FE1D2F4C
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958044; x=1698494044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ekwkpp73ua6DwEXe1Q//w5FZUJbbTx8dUgzdveRKUig=;
  b=Tt61ERdrXhng6WLEOiECMV6Pr+rI0ssaKXht1bukaeWWeCUvrsT4oN36
   lmMIEbM16IqnT6PUo3wQ/bLJi1+r+elkARwmt7ZnE53BDveGKd9T5b6hm
   KBElRDxxCgozdkCyiIjHHHJuyBI55/lkSZ7kK5Rt6ww19NU3u0qfjJdnI
   o6ztrkC1fsJs7ek4prlF46L8D4Fl6UcwHIMy76zjQzLzYO6xJuOaqyxpj
   MwX89QGHMLIgsjEs/2r9CrS999ReeGwxgw6GwYMjxtxw3tPd5VpmqQr0H
   ieFxiRExDSwPWidWh3N8AIyYptRXHzsV3flbn0Oi3d13I7QTcIR20l8H1
   A==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074528"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:04 +0800
IronPort-SDR: PcvOn65xN/eC2f7uTF4W4wExp6D0GzvcBKP8RFtTyNagkpR7bdJ6YPgUtb5F6g7zTidC0q6jDb
 KXL+yWKe6ou3nb/Qxxv3BP78wO7YOHw17weWxzDZHGM7H7kSMjiEWBQ7HHH2+gw7tWXJrOa1gd
 Y0Mq3CNQwN+OX0DZCamB/WxMXqqj6djyk3qwQjOzL6Mcse/M+IAkX1IoV8GD+HwfnBS2E2BlHm
 rhp6W2B68qnPvVLB/HazZs2RhEU+uQzat8YXvXRcP1O2rss5PaZKhlXAwxXPitGU+mRRw8/ax8
 eqnum6PGPkVGiPg3p8sjmFVG
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:41 -0700
IronPort-SDR: 7eN+bF0WXudLCzqXNYUPRym0Dp5+f7KVaUPeR4AQ2ynpmPkaC9YX085i83kMpS6ftF7TTSpivz
 o7/PK+6QRHq+AUvzKIUA8SRil6YFLgQA5FFLVcK7kIIB3hTJNq4TBbL7EVSSBm5ugp4xFHOOT+
 0VtM7AeJQtqpDHAYHYaJr8XcKMiTvX3RG/+S15SX8zLLZa+43vZpsApAmDxraFygQCV+utfS8o
 UHZm7tbErdn67LAgk15o7JARG4vFhuit0mp+LcBLrA2IPBBVtTj3BZvVN9tQ7IyA4fVAGVUjom
 zps=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:03 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 06/13] zbd: verify before zone reset for zone_reset_threshold option
Date:   Fri, 28 Oct 2022 20:53:47 +0900
Message-Id: <20221028115354.971715-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When verify option is specified together with zonemode=zbd and
zone_reset_threshold option, zone reset happens to zones not full. This
erases data for verify and causes verify failure. Current implementation
avoids this scenario by assert.

To allow zone_reset_threshold option together with zonemode=zbd and
verify option, do verify before the zone reset. When zone reset is
required to an open zone with verify data, call get_next_verify() to
get verify read unit and return it from zbd_adjust_block().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 6f4e5ab2..af761c17 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2032,7 +2032,10 @@ retry:
 
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
-			assert(td->o.verify == VERIFY_NONE);
+			if (td->o.verify != VERIFY_NONE &&
+			    !get_next_verify(td, io_u))
+				goto accept;
+
 			/*
 			 * Since previous write requests may have been submitted
 			 * asynchronously and since we will submit the zone
-- 
2.37.1

