Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1919DEB64DA
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjGSK6T (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjGSK6S (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:18 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4052E4D
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764293; x=1721300293;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HshyRL9o4ImkVCrv1F0GVqun/JDw2Y9L6mXek7I8H5Q=;
  b=IwJuuSwIv5Im06F3livp8e/QpwhNwanhunwgs+Wt6mbqUHwRnutaDVeg
   IJagkEQ9yYYq02kUKVYzhnPT8yPL+K53Tgq/xdC/jj+S9Rffz6j2tr6A9
   UzJOoNTXQNZCBgN5qOU0CkGQACzm/y+seMaX/mYkVhomgc8vG10mSZl8p
   hdwZz9SboCuchB2lhR0urfpt5dRqZxf/+Y5AiPWlo2JzkxN35dZQke0B2
   RruaAGucs+cmN4hvoW0kJ5Oje7xahYXNT3yynTbEjd8kgt4Z1MSfiYv11
   c3InycqUHu4tIdmzNKA56Me93OvAUcoJjwG5OUf/eu2IaWpBf1TrKRaYG
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860344"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:12 +0800
IronPort-SDR: 0/PtdA0ngqbn6t5cf8h5WH/9DTLA+XCAbEocAHBqJCSAMO894SjbLi3QjTmfFmyPQkdjfRlf7v
 ZHe5g42N7dXE1wdf2tPIIhHqQeEPVtewBzGD19O7k0oixKttXozK6Qfjg1DyTuXrZRzH355259
 D00Jgc2c5swcCRfP0gCCC+zs5wux+8oq7N2q0Sw41Wuc//5Cf3F+221uAWhTiN0ghsnr1r9itk
 DlZK2wA8n2C1mpp3PT14yCECDA8jYytqHNa+atzukjmwWcx0ZB/FIyHjlMua/6qNdwAFDD/bXp
 nPE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:24 -0700
IronPort-SDR: WdN/ZIkzZfSmFCfgLoSGDvpycuIEgF7zyXiO9UFWx+vvKuZXJPwM/+MwkjF9MQ1265fBNTT+Ut
 mS/Ag4J1yP22b/W0uoqySrW25ZEsm64XaR1DqQlQB9uYGKu1+G4TFNw7DkabjBl5NyFvGHfowH
 tfC4Io85XWJ2svXboPBF8NciNCOFT5qq2HSvGcd+ZLitLH0Ooba16RAIvaIaA6vsf89ZQt0lpX
 88eQHB19IrLcJXMuFGKSIZfypbv+HEkn2R/J3ADWgNHKvCghPNzsPX39adBu5BNTpvTrtH2rW9
 D/o=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:12 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 12/13] t/zbd: fix null_blk configuration in run-tests-against-nullb
Date:   Wed, 19 Jul 2023 19:57:55 +0900
Message-Id: <20230719105756.553146-13-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Correctly set max_open in null_blk configfs.
Fix displayed number of conventional zones in section config banner.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/run-tests-against-nullb | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index 7d2c7fa8..4617e398 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -67,13 +67,20 @@ configure_nullb()
 			fi
 			echo "${zone_capacity}" > zone_capacity
 		fi
+
 		if ((conv_pcnt)); then
 			if ((!conv_supported)); then
 				echo "null_blk does not support conventional zones"
 				return 2
 			fi
 			nr_conv=$((dev_size/zone_size*conv_pcnt/100))
-			echo "${nr_conv}" > zone_nr_conv
+		else
+			nr_conv=0
+		fi
+		echo "${nr_conv}" > zone_nr_conv
+
+		if ((max_open)); then
+			echo "${max_open}" > zone_max_open
 		fi
 	fi
 
-- 
2.40.1

