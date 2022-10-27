Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C02C38A2D
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiJ0GDE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiJ0GCa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:02:30 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D457C310
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850541; x=1698386541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9yeeDIgJ8un1QGwAA2YhZ8rVElqHCKPskLil00f8C4s=;
  b=GofIBPvvDtMA7kkkn2g1vZxXdMgvFwrbGa3pZn9JpzVYp1E258HVBzVZ
   gADIKbYi2dOXVPJV58zXIzk2hQRLvw67p2sdeecyGv1UDmF4oznACbSDt
   aPty9zksSa3h1xWtcrMBRxJ8SrMYSe1JDj6euOm0BT3mhKul7YioHDwPh
   uGKOSTyllf0AJ7AIDcIPLqqfPZyiYmLo+l3UyOKftB5m5Kp/ycGn21qWZ
   2esR80wYGdQ6RtWSyXP5hrdLLnjePOMQVdxX9vgl3/dR0QWpTPOqpj11J
   vrDRKJyf9QTL1htKgbXbfDuMK9Hhnt5gWDjWU/Z2KppIljttZizcVEpbk
   w==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="215208190"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:50 +0800
IronPort-SDR: NcR2c/IODUsM1MqoU2SLY86qpc3avJDeB+2C8UJrvD4wyQbT4ub3mrKfvXuhndTykATYxeOMOB
 gxn+v/ZVLEPiU3zH8WqtfjXJc4rexflAw/EeEtep1XWG887eGI1BnZ8eheDK1nCif/+YlehSb3
 CtC1Ob6aoIs+N2G8dxf6RWJybcqwGY3qMhTa2IjATNJZDSUW3hOXg5iYYVB3v1/Jy0eEXS21th
 NY+yL8FKNdh+DV5RumgGy7q+IDcYOfvf3izq3rbiYGNW1u6sd90nFWnEACPvS+Rv00wWHCqmmd
 +Rlgmr4yejI2bkHbxHkYBnnD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:27 -0700
IronPort-SDR: FX+bHeT1ET4Vk3Jihr5DBPP61xY09c9CKNutUYdjumzAd6UuqKrabGaKZ24pcNYIHHW+GGD8eO
 NL4M5vgZop9uoxy7QZcLteRRMPm5giRUJfHwsSFTiQPxufm6t4h4h5qr6ZVlsi6ICVQbYtLAWb
 s5V2iH9DWyH8NC3a8exs3D3R5P9RydSoeJcJWwdan+MzboDdKOz8ncbyVqnmqgMn2A9XCse4wh
 rsxTaspBQh/bRc4kakd8hG6v2hw69VTBx1/IDzEwqdDrErC6yjSt7ycHo9ugW4LRAGdAZ3pYVY
 sy4=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:48 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 06/13] zbd: verify before zone reset for zone_reset_threshold option
Date:   Thu, 27 Oct 2022 15:01:32 +0900
Message-Id: <20221027060139.952508-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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
index d1044b5c..e1844e87 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2031,7 +2031,10 @@ retry:
 
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

