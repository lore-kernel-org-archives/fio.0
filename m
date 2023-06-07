Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B111C7EE29
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 08:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjFGIcg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbjFGIcf (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 04:32:35 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71B510F9
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 01:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686126754; x=1717662754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0P6zLgrWm9nhA2eIIbITczuH5F3AHQvew/HN5OtSIDc=;
  b=MezqgaFNeFQ01u4fagIkcBLCobCDem2HlqaRLHv92fBSiWh1MvZuEQea
   m6Ny6gtzkabXCikgeeaz1s1OpLD7UaBee3SC9lwwVX1ziNSx03iXO2mAS
   pFmk4LZqDTxg75NW6vFvrEjgTCHuJeKGJ/C/uxNLkoNOmYoUifNd9Bi3N
   jAvu6NW7hajd5NpwhgnQzxjtYPVOon7gJLbs2r/L0rm/X5dITDEU30NH/
   WpXRTOSC1SKspEcfXQYKdlq76jJtxo6wbqAHujVHXggvY451n7EysOQGf
   jDqVyr3HxPbHhd7vYfm1bGbRQe9diof/f+Nc77jS8fAkH1OXqlRS4yflS
   A==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681142400"; 
   d="scan'208";a="233003998"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 16:32:34 +0800
IronPort-SDR: rpKsC2Y3Dupvlu57dPrL1lAXMQjeYiGgw29GeC8ehkOiXzfm6pCngfIzpt6I0+KRqfgrZvTbrg
 Au9vW0X+y5GYLinw2QjOdio7ZbfrU6haawXyJIBuSa2/nOttV8QFOexRvPHKwElRdnmZGXQdEr
 HCzTsQhqdWTOuZC2RkqsRpm6aVuJEczDqTwotOP13s/e8zeH5kvjUQq8/OK8gTX6r2wKQEkKlw
 0V4Wtaab6to1a1Xnr89nvHCBgoW4v65k2E3xmDM91gf3VyOvnTH3C/E+JILnODPJDZ5SBHXlV/
 xts=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 00:41:37 -0700
IronPort-SDR: 9fb4tNmSvr3RwpgQUgLeIGPFDCO5ThrcAe2bdyeUQwDD8nz2aJbooGSt9ZVHPNX8k/SIbc6H9/
 pOvRx0SCjZYA3MWDCnEmmWdsZrMCyzvY9a9xlek5MxOxq+dT4qZxkpIL+X0LX+XdLK+MjvM+29
 vdDrkcyzCdJz+sT86HwntmPBMJNokJ0oK6dqpl37dWbxiyjC2CIo+1uu9mHZaAR1HoMa2/cGOv
 TQNCiC0Ymmapdx9dzXTGacuc0bWarBpuGnGkCa2hkuFvP4l+IukSfgCX3ZhtM+m26RcV1eomPi
 C9Q=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Jun 2023 01:32:34 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/7] zbd: do not reset extra zones in open conditions
Date:   Wed,  7 Jun 2023 17:32:25 +0900
Message-Id: <20230607083230.1178573-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
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

