Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A94C38A2D
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiJ0GBw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiJ0GBs (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:01:48 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C117A74A
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850508; x=1698386508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wC+QkQP0Q+QQPY4qncId61biUjwJzp/X+9B5ajLCXA0=;
  b=Cno+tveJCOvHElLxkbovd54BHUXRMpUq3vuJAnzza87FSwMu1bhBHGnP
   ab82VIujfyDvBab6vRlfImWyp8O/bc/7nOoaXjNTUzYFHKgCna7lHXGMI
   dPxaTmw9atmGT4fWg+bUJYaZTBkPJHd6gwKr1Zy0nYCoGVVt6TKQJsRj2
   IAZXqOpFHyE0XK2P6Vhd1wyCAw6G65nSC5zK8aajo3XnQVfcVV/Owr/A8
   y7aCe/6+Bsl5li1zmmdktBnhg4rwgAdyEFMCL0c2/WtlDl3wl0vmIfiTT
   bDfDCtoFpKhtdtzwGF50rFV6c8xMJrFX7Epp1maedXGB6N0nGCLo9z8VI
   A==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="214845847"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:47 +0800
IronPort-SDR: cNXLMhBOe26N2KMo1DPo4lAzSXwHe8xskz4F6kAjijFxz/hRGC9dSFOPJxiMoDHtWIHD+wHmJQ
 rytDdxpQMr233QmYkUBrHwNdcKNdsu89oChrqtBblkPH7OwlnidAPCYXSuHV7RSjFWAXYJvz27
 AIGRLpj6fQVYsPNzlHOLqJ14jb/CEMsKGLuZk9XZAJ59dReIjqbmmeyOIN44rA8yfFuatALFYc
 Wly2EYh3x9E4xuXc6EVq4I6XBXBGsRGLYQ/CnrMVQ3+UJv2X94e0zZjSTK2rZpEsGPO0pd2T19
 tH0c7e4Ka35fVdFEHt14vAMy
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:26 -0700
IronPort-SDR: +R0VlRMoAwI45On/cp+LjhKhch40oyfRuepZB4o2UOYWqbC6bVqzORmXtPMXmwvJCSeP/DzKWB
 UrzgRXY1dW4nDqTu14iT4GYeyn2IYAkkYkKDjK26EERa+I23BLx6vsdU7oSTA13z4wZ+48/v/k
 sOd5W8Uj2da4hUSg13s6BZVrCeQEns+N3jrlMdevjl3BUr0I/18IrpqBCn0GFjOfz4S3/87AiA
 /H3/9XOE4JeuJSf6XL27gwDL68HWx7F4+FhNgN3KfJUHUP3qaTCf7JXRGc4uD8+fTPm5v9eUlJ
 3H8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:47 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 05/13] zbd: allow block size not divisor of zone size
Date:   Thu, 27 Oct 2022 15:01:31 +0900
Message-Id: <20221027060139.952508-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/zbd.c b/zbd.c
index 8c916456..d1044b5c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -651,7 +651,7 @@ static bool zbd_verify_bs(void)
 {
 	struct thread_data *td;
 	struct fio_file *f;
-	int i, j, k;
+	int i, j;
 
 	for_each_td(td, i) {
 		if (td_trim(td) &&
@@ -673,15 +673,6 @@ static bool zbd_verify_bs(void)
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

