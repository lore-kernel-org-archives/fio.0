Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFBBC433FE
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiJUGel (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiJUGej (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:39 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E6833364
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334076; x=1697870076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rKtlTgxcSunIkXsyd0GYFDHc3ZJyrW78iduZMoSmo6A=;
  b=i76TPe8gsLV8iTICloBCcYCw//nDmqePtrOBLgcU8CBAJ9A7Xjs6j7wy
   5HF+VZpVNa7+OpS1DDvS34O4EdaQ5E9K+PHMeJj9UyR8MqeU4LYi7pqOF
   PYW8aPkqhWRKNsvOeh/hplLSlIuUEU5yyj8vii9m6XX4W78EkyrQOK8ai
   hCCMlwvZNvrM9SH3l3FzZT/viudFO23IURyyfrOl9aZv6+dD8n7lwb8Ue
   7dOyaJINmEJ16ATJ4NpJufCEclrxKpoYh6qQ06ijG0p/R9ykR72Dh2aR6
   QB2sFKK3M2noKwL09EtRY7SWIp5nBOMAntJqqns8vjDzlk7NWCThw3/mL
   w==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733132"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:32 +0800
IronPort-SDR: fAiFwFpgAnkdYiJXDJ75YlYIxmUQ0fBSOnJubo0KJVDI5XbxhmO/JwuiqK26THgcm1jrtMQWSb
 9t3wVVbB8EqnkbWKT5yzDUHkGkEp2ChjhidnReFp/cJuoPnBcMJmeZi33i2cCxJx+SeVyVdiqg
 62O8onjWbCNQMmdbv32/XnE1gDdwN/lJ5lkG+ul5VGPV4uI7mMW2zbr5wRr9EGX1zPFEqU/LWW
 maE1hU7KhKOIEz/cstKI7GH5/BtbTvvZbGOr+TN8uEI+wD0naF1C12GVAFIQcfzNmiEqNJabBt
 hWjvDrXLjUKRfwEHEF+lc1EK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:20 -0700
IronPort-SDR: nUlO7eF+Hvk0jK0NqpTGfAM7jxIqwopmGgCqI9xkXEOY+oLMap9ZhHASePFLHkqzx9BRMbIKIH
 3eJWpE40Z7dFHpYhUVa/5Z/YEOpvO2x5xmHnbdVoFBj8qHsSZJ69f8+NcvxXpOcJohEeFF013h
 /TrOVA2It6pKaUsFngZlfF7OrxWXMDO9Euh4pBD8j0+KMqnFdar3GRJCWd6Segy7FN7WCA82Ki
 /L3Uw7xY9WRlVtjhjl8hsX/SHdo9/MKHRahG5YGa89sblqkOgnuGfDgQDt9Xy48XLc2pPELYR5
 R1I=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:32 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 11/11] t/zbd: remove experimental_verify option from test case #54
Date:   Fri, 21 Oct 2022 15:34:16 +0900
Message-Id: <20221021063416.860438-12-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The option experimental_verify does not work with zonemode=zbd. Remove
it from the test case #54.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 1 -
 1 file changed, 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 0e185997..ce4a5916 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1178,7 +1178,6 @@ test54() {
 		--rw=randrw:2 --rwmixwrite=25 --bsrange=4k-${zone_size} \
 		--zonemode=zbd --zonesize=${zone_size} \
 		--verify=crc32c --do_verify=1 --verify_backlog=2 \
-		--experimental_verify=1 \
 		--alloc-size=65536 --random_generator=tausworthe64 \
 		${job_var_opts[@]} --debug=zbd \
 		>> "${logfile}.${test_number}" 2>&1 || return $?
-- 
2.37.1

