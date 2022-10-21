Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84EAFC433FE
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiJUGe3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiJUGe1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:27 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080CF11A14
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334064; x=1697870064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=luMbRXphxUmZZl2qjG87G62iLHnsmlklAQCwJU92BBA=;
  b=ZbS7XNS9nIpBpkogwGBz0YL+hFS6na5hxf8peYgIpyT/7XJ+WQVTZtMM
   CVB2MwI1vI8UtuOYjh42eMCNxygDGdJnJfWDoJqC/vsMTYTC6KIm80RxN
   8hBWb3Xc7+OgzbG5FHVC0pyTFdO8S5xmM/hfd30MTudMaCjUU5VHu6dcT
   Qk17G59gaFnDEEbNLkhfuGaZA4oIFbQxs9o4h7iI1dHusz8U+9n1p6hb6
   fwib+3SyuokIX0O3ouVEdOkB+ZaYyCUfYYSBvkp67yWMo97DkgkFtyh6A
   czRU7jEchy63SC4sGobB4aKySaVFCAl4x6YpOnGv6E2vXkihbAy68/dfL
   g==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733108"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:24 +0800
IronPort-SDR: r5ovJ1YjmuR1trAoHr9iz/W7muzQe3lHrnNpWH71ZfY+lfXy0tOLRHs33wQMtLwDFqOCQsQMQc
 SZZWDckjiLN7VjukJYk99MN8FuSSXm+qy+Fbmp7tz/BNq3ciGePknpzWGmlZzGGbOvfitUHqVE
 wEBQkzt8GCaa39wwP8PBaz7iUFT3l8kIn+fTgSg2+YLe7gy3Sbhs29M3J9Z8wHy58Y4iS+z51C
 B+4A2sReJvnE6m4YzEjNYaH6ctUnfQwSFL+2iFn93X+5Q7EiVeHQ2EkwzN8v5mGIDl9ZvG6xgM
 iTUKbFueDd+msktuzBDCU7dQ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:12 -0700
IronPort-SDR: jGa0myn4QSqGTvg70sY0PWkdKaeQ7IC89dryl5IBKKUEAAHG4VHaSGPpxeHCl9bDIo5viIkN59
 ie15+E+M2TNUYBdtm4MuaSxLB0uSd15ZxYHsXCYwT0+G2Ktn6AwWl/PjQlmaK8SqfceW/NjAB9
 wvgO+OtLzALDSCMQ5pnf5rG6HNvIlLFyUF5jB41NMmeIDpx0WPMo82TeVSiXidI4h95i0LjDn0
 uHSMQV0D+opvJgy7AAFsXvcxa4tnjvBH+ayKyLGfb4oTX51OVctYYyNOX0XFN5R2007cHB/f07
 iMg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:24 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 05/11] zbd: verify before zone reset for zone_reset_threshold option
Date:   Fri, 21 Oct 2022 15:34:10 +0900
Message-Id: <20221021063416.860438-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
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
---
 zbd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 61856ad1..3855ab0e 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2029,7 +2029,10 @@ retry:
 
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

