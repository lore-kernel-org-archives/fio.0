Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BCCEB64DA
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjGSK6I (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjGSK6H (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:07 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99009189
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764285; x=1721300285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UkSZLTwGnpvH6mhRbUmKTgNWjFqNMVHmTVwv8BRHpMw=;
  b=esx4I0nalFd1Q3n8hOwe1dXNiASbn6UmfLvolBn4dd2UToEkvlFqIRWT
   Otbj0tCVwqCHudj1uWEKlKxTLZODC5tndh6PMjdItTnJaJtr0aDkJMaOA
   AkgBz9Dlva7WzcQwMhbSlRgq8OwG2uUL9O4MEtScHRsaNHfgh/eCzYjc2
   iP7ZyrefQ0F5VuISP7Uwh0tkYYsIJpM/aVZbq31eiR4/sD+Ezw840WnHQ
   Pomz8zRIzukTCDDhensiXCwjxez/eMfVPj4TYNJ/i1EzcKmfBRid2qSlr
   mXwmAdloJTjrcuzWM1B7uJ3Oi/aAJoX+qVQrcHZZChMNCsTBzjW2pa0av
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860322"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:03 +0800
IronPort-SDR: 0v+7nLcpP/fEYShgUfVvM5sFzpWh0ow9WK9QaTKxzFeqHvajYEFbozIQDm3q6WunYmY+xuE1Ef
 4jrg2DG6H+34Pg1YNZ7z5gkgCAIaqJvNrRsaszuVcum4MZACByUFufDGIsAfUEtqhmDEHzczet
 DSB+Yy7Hpwf6XYP9UVicmAHBSEq+X19QCOSzeTHxUXC/qfQcrL75Yk7RJC0E707KqCfs/EKvwG
 RSAftx5kxMycAxDgI/tT3EF1wr9UPrEPEp9dBdvOTPbof6JFGnLknm2OTJwOVRysu98WS2I+eZ
 igE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:14 -0700
IronPort-SDR: nmRgRCO9IOJFQo5J22F6PcVgOiOj0GHwYjNLCslsN2WJUssbB56bYlFofb0Rap127E60ts0ZOP
 8jdJScF/r8+elkHAkLLiM1fMgtSDmurDUdhRmMLagMyZs8DiVi7Hg4vseIba70eceP0ulHdgsd
 qnyQby2Jtt7sNRPwBeWX0NFsc+IAyEr/LwYfIFfdQjKiW5j1yJdluOAVaoJpyHfHWAPxxhITSl
 LcNg3fWXUeXwXtVXKy3O6FL6HfV5kRNKcdO2rPnMnTtNPJx6boEGAhkEUGZfQJ7KfLOxQtEUKB
 Jp4=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:03 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 04/13] docs: modify max_open_zones option description
Date:   Wed, 19 Jul 2023 19:57:47 +0900
Message-Id: <20230719105756.553146-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
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
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 HOWTO.rst | 44 ++++++++++++++++++++++++++++----------------
 fio.1     | 36 ++++++++++++++++++++++++------------
 2 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 7ae8ea7b..7fe70fbd 100644
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
index da875276..20acd081 100644
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

