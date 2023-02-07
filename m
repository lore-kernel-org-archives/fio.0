Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C2BC636D4
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjBGGhu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjBGGht (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:49 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BCE234E4
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751867; x=1707287867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T0iKoQl6aVrsOTH198BuqO+8ei+/bwCteiV3OpV8C2s=;
  b=ZFhSi9hHah2SCKuHZcAmDPDmChnspQ9L5hiGWbyTl3b2qIww6Yt0nilS
   wKPnAkPFiCpDJklxZB5eU8BRdWfaqFaNKHFS98bka6HVxAQrMahjMilTJ
   dpwI+CFjdP6FX8BAq+hpFM7Tv6rEtvAzpD6h+08KgR4SFz/nGOyCOAODi
   MbISwDnKGYHzPzngnAzg4fRHyDoF66TCgLaQZP+/uciEVbU29D3bEFdul
   T+mAPNqHml7EE8Wdy7hHbiHCDiVN4rTBAGDrrdh9aScis4dml8SaR1atE
   6O8ZDJ96xtmkF5lQddZsLZSZApdxGw6Jgtsz8+F2KnE9ayuXZy2EczyS1
   A==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982657"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:46 +0800
IronPort-SDR: 8kpHVgpz8N39+FP5DAywSnGW85N2ELQQSzhfuRMrE6iGIG6UsvrLtTeHmo52MStgzWnyfLMUKm
 aKxKvyZ3WVnswyMbcxdcgo/eZr/gQvBOcdfdiVim2DYi00plEuuKSuCBMj+XgwdCAbDLt7htjo
 1oRg7uelTh15xnicB9II5KNcGIG0AxZrfJWs9KLBab0FcB05gVpZam/NcVlCHqJHPvhED2qckF
 zpo6LfCSy4P2QucViL79PoDz0Q54bFvL2KMCrOdEZLkXC3NseoWsYam9MLc3NGwlEC7Cv7fpzZ
 Ue4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:55:03 -0800
IronPort-SDR: X2x4fs4lR3fk9mJTeAYZ1NpKWkvgW2gm3ATSRkJivRyDHt58Onk3ROswu5+yoYEoVYgByXQfaV
 pLiEvDgnANs0eVMjg1u9DBqNqsV7lZD3dp9ByGJXOy0YzSvwTgk0oCOGfSlNTHIKZFUMSaoDeI
 51iOUILdbfuy1riVbhE7+glagJrgiD7HcDVjJkVTlWENwGHi4MyAQU50kcdeWGU/8M9NKSXNZZ
 Xo5klym4YNCjK72XKQyJcuR3TjBepBodrFxucKQ45AIDiecMPDfLAOxqkoZq1x6Pd3sUK/oi8j
 uCE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:45 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 4/8] doc: fix unit of zone_reset_threshold and relation to other option
Date:   Tue,  7 Feb 2023 15:37:35 +0900
Message-Id: <20230207063739.1661191-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The zone_reset_threshold option uses the 'sectors with data' accounting
then it was described to have 'logical block' as its unit. However, the
accounting was implement with 'byte' unit. Fix the description of the
option.

Also, the zone_reset_threshold option works together with the
zone_reset_frequency option. Describe this relation also.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 7 ++++---
 fio.1     | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 17caaf5d..d08f8a18 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1085,9 +1085,10 @@ Target file/device
 
 .. option:: zone_reset_threshold=float
 
-	A number between zero and one that indicates the ratio of logical
-	blocks with data to the total number of logical blocks in the test
-	above which zones should be reset periodically.
+	A number between zero and one that indicates the ratio of written bytes
+	to the total size of the zones with write pointers in the IO range. When
+	current ratio is above this ratio, zones are reset periodically as
+	:option:`zone_reset_frequency` specifies.
 
 .. option:: zone_reset_frequency=float
 
diff --git a/fio.1 b/fio.1
index 527b3d46..54d2c403 100644
--- a/fio.1
+++ b/fio.1
@@ -854,9 +854,10 @@ of the zoned block device in use, thus allowing the option \fBmax_open_zones\fR
 value to be larger than the device reported limit. Default: false.
 .TP
 .BI zone_reset_threshold \fR=\fPfloat
-A number between zero and one that indicates the ratio of logical blocks with
-data to the total number of logical blocks in the test above which zones
-should be reset periodically.
+A number between zero and one that indicates the ratio of written bytes to the
+total size of the zones with write pointers in the IO range. When current ratio
+is above this ratio, zones are reset periodically as \fBzone_reset_frequency\fR
+specifies.
 .TP
 .BI zone_reset_frequency \fR=\fPfloat
 A number between zero and one that indicates how often a zone reset should be
-- 
2.38.1

