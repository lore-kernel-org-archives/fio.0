Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F397CEB64DA
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjGGDPQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjGGDPO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:14 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724D419BD
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699712; x=1720235712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sf59ccK4tfV0tmT4OQ0ZqdPp3itzW+aP3cNbyCA18cc=;
  b=MTjqsP+ypxvNYKF2x2xuM9xcsh1Ju8IcPz1WXb0zr2vHtOyjVgs9tVUH
   KuC8Ham/i0omF96zOoxfS6OR1IXqmAA2NhAFSKztwee54+7/cX67js08q
   l9xNTkvrCzdHeHVyU1har/wf2jzBWxmse4mHGn/5jKMAuu9SPJ5hd9cfp
   Mer6DCSN03LIV0ezWp3m6EUXkm6okFx/iW8f77BXJiJrYzuC/RK9rYaEU
   uPpCxEfUGZAg/kD+x+FDzKGa/zZVBV+QGnKuojfXtjYx1nPDMZGu6/gh1
   sO3yeUd//6dUIXJUY+CnBeK2uzoHF2SdAdNYkIdEmX/9jH4gBvjoPVtNT
   w==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468800"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:11 +0800
IronPort-SDR: ZAIg5rBr6G7J1V2mFbpjKdjwdtrFs810Ym/QrwVeT3tz0+g2eiFqvQmL/fxoL+QfgaycnB4eO4
 pF8hSBZ4+auxzFx2kErK/Uprd5Z59T6P3tz/7mw+BiWrCVEFTbbt0ItM8FVbpX6tlBaKnyggL1
 DYLnbFWQJWhxG+fp4G5y62XkH9J7vb2zLGD1Yc31CZzyLg8P69a/MeFaoKMfwO1XZjXPPDSW+v
 ZCXVYXEa3DZGT9Qjr0n6USAGqdoPjjBZkCWM5pFa3ujXYF98Ibr83VRKOmZywsvCKmLjR+5cOe
 hus=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:19 -0700
IronPort-SDR: 2qwNCZQ/ClfSctThv0EfSuGScLcck7kufqpZ/740urB+MEZ9BqLjSIUL61JGlLC3cgwRUzmRWi
 U7aHJX1B7VFGkiV5Jg7J4RNz04IL+1trmE5xE4ZUF2m++u4lk8XB/NRGtAKtPqiRCLuFZp6plw
 V0RG1QxLB6jCRPxBoGMlqM+olWlE6sBDcvNyFD5Y9w3nLJj8N9yv0YJr3xTaS8mY3iae5UAXqp
 wZZejWKGglXp1p0HjuKuuQbPcrSJc04C6N61CdxzphjY8kA+2ERkkCQrRFjb67LJj5IzwWI1TL
 eX8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:11 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 04/13] docs: modify max_open_zones option description
Date:   Fri,  7 Jul 2023 12:14:56 +0900
Message-Id: <20230707031505.3468915-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

A recent commit modified the max_open_zones option to improve handling
of zoned block devices with max_active_zones limit. Modify description
of the option to meet the change.

For that purpose, explain the relation between the max_open_zones option
and the device side limits max_active_zones and max_open_zones. Also
mention about three zone conditions 'implicit open', 'explict open' and
'closed'. And replace the word 'zone state' with 'zone condition'.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 44 ++++++++++++++++++++++++++++----------------
 fio.1     | 36 ++++++++++++++++++++++++------------
 2 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 2e1e55c2..4d50ad41 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1056,22 +1056,34 @@ Target file/device
 
 .. option:: max_open_zones=int
 
-	A zone of a zoned block device is in the open state when it is partially
-	written (i.e. not all sectors of the zone have been written). Zoned
-	block devices may have a limit on the total number of zones that can
-	be simultaneously in the open state, that is, the number of zones that
-	can be written to simultaneously. The :option:`max_open_zones` parameter
-	limits the number of zones to which write commands are issued by all fio
-	jobs, that is, limits the number of zones that will be in the open
-	state. This parameter is relevant only if the :option:`zonemode` =zbd is
-	used. The default value is always equal to maximum number of open zones
-	of the target zoned block device and a value higher than this limit
-	cannot be specified by users unless the option
-	:option:`ignore_zone_limits` is specified. When
-	:option:`ignore_zone_limits` is specified or the target device has no
-	limit on the number of zones that can be in an open state,
-	:option:`max_open_zones` can specify 0 to disable any limit on the
-	number of zones that can be simultaneously written to by all jobs.
+	When a zone of a zoned block device is partially written (i.e. not all
+	sectors of the zone have been written), the zone is in one of three
+	conditions: 'implicit open', 'explicit open' or 'closed'. Zoned block
+	devices may have a limit called 'max_open_zones' (same name as the
+	parameter) on the total number of zones that can simultaneously be in
+	the 'implicit open' or 'explicit open' conditions. Zoned block devices
+	may have another limit called 'max_active_zones', on the total number of
+	zones that can simultaneously be in the three conditions. The
+	:option:`max_open_zones` parameter limits the number of zones to which
+	write commands are issued by all fio jobs, that is, limits the number of
+	zones that will be in the conditions. When the device has the
+	max_open_zones limit and does not have the max_active_zones limit, the
+	:option:`max_open_zones` parameter limits the number of zones in the two
+	open conditions up to the limit. In this case, fio includes zones in the
+	two open conditions to the write target zones at fio start. When the
+	device has both the max_open_zones and the max_active_zones limits, the
+	:option:`max_open_zones` parameter limits the number of zones in the
+	three conditions up to the limit. In this case, fio includes zones in
+	the three conditions to the write target zones at fio start.
+
+	This parameter is relevant only if the :option:`zonemode` =zbd is used.
+	The default value is always equal to the max_open_zones limit of the
+	target zoned block device and a value higher than this limit cannot be
+	specified by users unless the option :option:`ignore_zone_limits` is
+	specified. When :option:`ignore_zone_limits` is specified or the target
+	device does not have the max_open_zones limit, :option:`max_open_zones`
+	can specify 0 to disable any limit on the number of zones that can be
+	simultaneously written to by all jobs.
 
 .. option:: job_max_open_zones=int
 
diff --git a/fio.1 b/fio.1
index 73b7e8c9..e8bc4f33 100644
--- a/fio.1
+++ b/fio.1
@@ -832,18 +832,30 @@ numbers fio only reads beyond the write pointer if explicitly told to do
 so. Default: false.
 .TP
 .BI max_open_zones \fR=\fPint
-A zone of a zoned block device is in the open state when it is partially written
-(i.e. not all sectors of the zone have been written). Zoned block devices may
-have limit a on the total number of zones that can be simultaneously in the
-open state, that is, the number of zones that can be written to simultaneously.
-The \fBmax_open_zones\fR parameter limits the number of zones to which write
-commands are issued by all fio jobs, that is, limits the number of zones that
-will be in the open state. This parameter is relevant only if the
-\fBzonemode=zbd\fR is used. The default value is always equal to maximum number
-of open zones of the target zoned block device and a value higher than this
-limit cannot be specified by users unless the option \fBignore_zone_limits\fR is
-specified. When \fBignore_zone_limits\fR is specified or the target device has
-no limit on the number of zones that can be in an open state,
+When a zone of a zoned block device is partially written (i.e. not all sectors
+of the zone have been written), the zone is in one of three
+conditions: 'implicit open', 'explicit open' or 'closed'. Zoned block devices
+may have a limit called 'max_open_zones' (same name as the parameter) on the
+total number of zones that can simultaneously be in the 'implicit open'
+or 'explicit open' conditions. Zoned block devices may have another limit
+called 'max_active_zones', on the total number of zones that can simultaneously
+be in the three conditions. The \fBmax_open_zones\fR parameter limits
+the number of zones to which write commands are issued by all fio jobs, that is,
+limits the number of zones that will be in the conditions. When the device has
+the max_open_zones limit and does not have the max_active_zones limit, the
+\fBmax_open_zones\fR parameter limits the number of zones in the two open
+conditions up to the limit. In this case, fio includes zones in the two open
+conditions to the write target zones at fio start. When the device has both the
+max_open_zones and the max_active_zones limits, the \fBmax_open_zones\fR
+parameter limits the number of zones in the three conditions up to the limit.
+In this case, fio includes zones in the three conditions to the write target
+zones at fio start.
+
+This parameter is relevant only if the \fBzonemode=zbd\fR is used. The default
+value is always equal to the max_open_zones limit of the target zoned block
+device and a value higher than this limit cannot be specified by users unless
+the option \fBignore_zone_limits\fR is specified. When \fBignore_zone_limits\fR
+is specified or the target device does not have the max_open_zones limit,
 \fBmax_open_zones\fR can specify 0 to disable any limit on the number of zones
 that can be simultaneously written to by all jobs.
 .TP
-- 
2.40.1

