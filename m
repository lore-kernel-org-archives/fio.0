Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C49AC05027
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBIHJR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBIHJQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:09:16 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D873CE10
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675926555; x=1707462555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=70XWxUGKXBfwiOK7+Q5kDUgFdgUBeOuAJOHdrVfccdw=;
  b=JXxL0vNQ2l7ibea/QqZdaK+vDM2PmFuMRCORoe9NKtLav9HOeFNqF/Dm
   cNFbBv3pZPB+2n905g8xUD/NHrNuxkmRYyh1b9tGKqikOuMSl1KXpinvI
   K8Onw+MCexTajM0Al3y5+ULDqoG86ZUIkfrTQqh2xjMQBn82nWwfEw89A
   fOmrR/bsP+35vgqPs3Ngg1t4jxYcDnyP2rhH6JtpbFjZDRgaDVdCYAecV
   Lx9IvFqWjiEtp8CA80DmHXeEfnmEpmeAp8ZoHqtcg7xKfOxO6BRZdD0+Z
   u0TbJsLsNHVrUXlP3E4rNOzInaWcmwI5FQBWg5cMXYL8n4ozH6f9WzkLz
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="334848076"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:09:14 +0800
IronPort-SDR: 0k3S5u17cnq2gHe/VJrgI8tKpr38eGdxdWWKXRhBDJnJn2BDqqUMbpKV8dp5iDJmZhoodjFz1M
 8Wb1M0YIFxP147BW7Tg10/WsXYMhisTVWEM/sDfVs5HFgWim1XuIc82AOFAMU7Iz8Y6HSs0Cn+
 Ml5siI+5FCk6bzLHWKy9ntTvB+F46SzLpo7s+EH6V2MDOSABhfOc0Tv+xo9wPE4xUNvQ9pkV/6
 qHH2U3/u3nVgKs6NQt2YlqOqIb9rTpDzD+vbBFbbDO10cdbhQKMRrmQ27dBpIxUxn15iD3+iFO
 rt0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 22:20:44 -0800
IronPort-SDR: NAZBBajWZKMIKxZtj/4jtnbZ5qFPu2PZzPbUtkchw551w+x7ExKse1LY0FAaysukm2iR3J/jPx
 orDdshHKIZtm6t+FeHIZATVATAh6BCRUVC5CaclQ9OrUA2vA6IfoQ0q8vEtRIcQU5SkP0c0nxR
 7AmPOemKUgPXLMLULX2+zdKYXmco5qBV0cqDEDCKAXGgE7r08vcINF6yMA3MC0UFuYckrpPToG
 umGahoxOF+nL/sBYdUxcdhsxXHo4wrzWXSjRvYMC21844fjo9qXq5ZJH/cyrnvlbMtx/WxMbpQ
 yFk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Feb 2023 23:09:14 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 4/8] doc: fix unit of zone_reset_threshold and relation to other option
Date:   Thu,  9 Feb 2023 16:09:03 +0900
Message-Id: <20230209070907.1733138-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The zone_reset_threshold option uses the 'sectors with data' accounting
then it was described to have 'logical block' as its unit. However, the
accounting was implemented with 'byte' unit. Fix the description of the
option.

Also, the zone_reset_threshold option works together with the
zone_reset_frequency option. Describe this relation also.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 7 ++++---
 fio.1     | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 17caaf5d..a5f8cc2d 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1085,9 +1085,10 @@ Target file/device
 
 .. option:: zone_reset_threshold=float
 
-	A number between zero and one that indicates the ratio of logical
-	blocks with data to the total number of logical blocks in the test
-	above which zones should be reset periodically.
+	A number between zero and one that indicates the ratio of written bytes
+	in the zones with write pointers in the IO range to the size of the IO
+	range. When current ratio is above this ratio, zones are reset
+	periodically as :option:`zone_reset_frequency` specifies.
 
 .. option:: zone_reset_frequency=float
 
diff --git a/fio.1 b/fio.1
index 527b3d46..3556ad35 100644
--- a/fio.1
+++ b/fio.1
@@ -854,9 +854,10 @@ of the zoned block device in use, thus allowing the option \fBmax_open_zones\fR
 value to be larger than the device reported limit. Default: false.
 .TP
 .BI zone_reset_threshold \fR=\fPfloat
-A number between zero and one that indicates the ratio of logical blocks with
-data to the total number of logical blocks in the test above which zones
-should be reset periodically.
+A number between zero and one that indicates the ratio of written bytes in the
+zones with write pointers in the IO range to the size of the IO range. When
+current ratio is above this ratio, zones are reset periodically as
+\fBzone_reset_frequency\fR specifies.
 .TP
 .BI zone_reset_frequency \fR=\fPfloat
 A number between zero and one that indicates how often a zone reset should be
-- 
2.38.1

