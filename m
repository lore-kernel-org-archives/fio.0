Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2885CC7EE23
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 07:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbjFHHGS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 03:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbjFHHGR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 03:06:17 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E999E
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 00:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686207975; x=1717743975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Y3/MeBJ1bt8Msuzwfpxb4iKjlD2EAt6RAF/U37HpHU=;
  b=lLet3gpQrey0o8zBAm2UVW7xqndBO+c2UlYdDKQTM8jAV8xSh5ejm7pd
   hIxZoB1sOjYbFVbD8irRi0l4PWbKK+DfrDRXGYClW5KWOFc1D964G2lS3
   lRL/UQAN+SvilRgjLKhG79ovqNuzd7qck9QIN9neM+ugT7zZlNXfbV/eX
   +XptDRInBfqLKMAF+AdHcutTlpyxlo41cX+ZgwFQxYVe+2tB2/eppbGj+
   3lzd1P3TTrQLvO3vrqZq+YOsKQ0uA++GdD0D0I0H/0ruk0J5aAV+jfq7Y
   brmqIULnllRJlOO40ViommxOmgNFch+g98Qtc/bMu6iEPt8N+u8QKH4h6
   A==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="231238448"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 15:06:15 +0800
IronPort-SDR: dSwpKoEPQZRuEjWGDEbJuPvt+B029ltXmbFxdAUlMGVyl09STYO42STJkq3NeJ7K/pUdeavaAe
 sqzIwHiEbCfOPsDQAtnQ82AzLzSr9T7jLnvMxNdF7/cDmsvHQ8kVikF+ZmHBkdnBH/qrtjmtxK
 MrwJkjfR+V7kKLjglRfChHZyNnSfSKKPX/SClQwC8TN/UQdzE+g1VhjpPvJ3tXGhVpr9mM6+TH
 62pyZN4JUYGZuByRqXvd0KX9nW+5x2xpZsX2UULfRJ9PBV3XNcdDCXAe6Y3LKVfNKi4+KGZYcZ
 9ro=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 23:15:17 -0700
IronPort-SDR: 32anZfuQuwERYe2Qeey3G+CMyAkU1s0YZKlOoH8Gd9C3AVGlrAMdN3IvGT0iFKlrUuKTQKR0Hz
 TB/qwEiDZpdeep2uuVEusqPxUKwvQlnLI1OpQ7kLeaKeitxvVyKa6wyl3lljZf6EGm96BxXLFk
 0itM/2bsRc6wnk6ExL/H6PLWwEp4/tuQQveiG+F3bNYokyqdHb5lHhRFxVMGq0vDAwzmlh8ZUr
 fkPozd2HOVKqqvfO6trHoFpg+MRDLYyP2MFvG+M0XML3OMWUaG/Zic2lkfiO7ROPBCH8Gtyu12
 L9E=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jun 2023 00:06:12 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/7] zbd: do not reset extra zones in open conditions
Date:   Thu,  8 Jun 2023 16:06:03 +0900
Message-Id: <20230608070608.1256970-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The commit 954217b90191 ("zbd: Initialize open zones list referring zone
status at fio start") introduced zone resets for zones in open condition
which exceeds the limit of max_open_zones. However, this zone reset may
break data in the zones even when fio does no write to them. Avoid the
zone reset and report it as an error.

Fixes: 954217b90191 ("zbd: Initialize open zones list referring zone status at fio start")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/zbd.c b/zbd.c
index 7529e68b..832868cb 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1206,12 +1206,10 @@ int zbd_setup_files(struct thread_data *td)
 				continue;
 			/*
 			 * If the number of open zones exceeds specified limits,
-			 * reset all extra open zones.
+			 * error out.
 			 */
-			if (zbd_reset_zone(td, f, z) < 0) {
-				log_err("Failed to reest zone %d\n", zi);
-				return 1;
-			}
+			log_err("Number of open zones exceeds max_open_zones limit\n");
+			return 1;
 		}
 	}
 
-- 
2.40.1

