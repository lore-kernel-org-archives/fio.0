Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1143CEB64DA
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjGGDPd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjGGDPZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:25 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400721FE4
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699721; x=1720235721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HshyRL9o4ImkVCrv1F0GVqun/JDw2Y9L6mXek7I8H5Q=;
  b=qa2EMSH4w2u6qNWS/SAEFE4aTFqFTz8BQwxZpy4odRdCz65Uo6A5rDpX
   pEQuwMjiY947bSKjF3iOAotdhQpUjMEOWfLfqajW3Es9FyHhbtzPJrsbg
   BrGXrp5h27H31y3fjGUkO8806FbORiGq1fz0UwZiFK8N3Z2kCvNB/h560
   +xIQ8rZpijHVorFaoT49oSHY/eTHMtARjdPw+WLads/ad+eEk8p95lH8S
   ipRTBYicEUBkPF8rdcN4LpfKvYqSEweJJjHcyE4bUqPIkLWXz4DtgsnRm
   2JRcV1SJQ5E9c7VDTFO6LnwdVrLIL5+51dX/eux2C3dsBGSxOGVjzXa/7
   A==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468821"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:21 +0800
IronPort-SDR: 6TCTLwXApB/aFerrAir8ZP9Wco1VBNVMwYETKdUqCYG5GdTsNlu2pRkDioPl18w9Ro8mIQygk1
 JVo81qy8bNsHH3qF3+8LsTKijvj4GSBJqtX6JtRefl77l0P59DqJc+bN7UhlEwB7xhYoz3MWYz
 qbMR0fgfknQSUrJyk89kpbgmbxBza1ZHIeHr3i9vGuXz+mspNcL8A1Uin8C5q9OC3Q/CG3gP2U
 OWFDFJstqjoGWRCddOdNpsQpuCG1mYhUeR7jDD65OW6WAHbI4+hQrQF6+dOISUuzfsasnxatUJ
 Wn8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:28 -0700
IronPort-SDR: 8A14XZehQQlVxeXV8mfMzAeFQmWBS6g3VBANzOY0dZXwjYfwR5UGy2+SkuVIfUnUdGxo8p/ZPo
 NR0linpmUPDIpYTlhokGKgAIiQzwwdFvMTb/6OWulLErehrnFyzs+K3tnpp8EN7czrWxnznFfF
 9A31EW9rFnAKgt+MiE7rJPazGJUrrwmJMnJqwDTg2cVo8AQ3IGDshSbYvWJZdaRgw4RL61kCDF
 pgFN5ZCEcT0he5Yht43cbBfM6YDNReL9hNfF9JlKtiEXEhXX5T7ZUSBsQ38Z4P3/Tand9A0Whb
 m94=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:21 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 12/13] t/zbd: fix null_blk configuration in run-tests-against-nullb
Date:   Fri,  7 Jul 2023 12:15:04 +0900
Message-Id: <20230707031505.3468915-13-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
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

