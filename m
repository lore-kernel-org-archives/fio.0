Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF956C38A2D
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiJ0GDS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiJ0GDC (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:03:02 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D18C15DB33
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850558; x=1698386558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cTEpkdq8i6HI2WB7Ghw3Zm1AGcKYmITBl0leyfvYTvo=;
  b=nbU5mLBDum+aR6fV8pKn5xB4oS9+4y1tIAPMgJgzBIqxgj62hv9sqRUo
   xZtXRaMZ9YBjWuvw4jMIu4uEsNq7WrSRcRE+NihpAB+6bkFvZtt4BuHhd
   qkA2qFMrG14zT9VbDZ7bV6gJ2c0wl3ex6l8u8QxAv3pfxXw674/tT2H9+
   tkRkTHLf6y/GcjIo9hgPMY6R9eD8ObR6miGZY3kQTafnWnvtwKe4QChx7
   plRvPJZjSvhz4XTPhgSRhghIZKfNNgTPAuWIqJtnI78M4bQU6nZ9FHZeK
   o/IyEsD42zdHf9I2JpYx4w92jY4kx3u47faEissmGITCS8H7Abrf1HI/c
   A==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="319174477"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:58 +0800
IronPort-SDR: Wx+pT/BpPbI0lV0d80t/B+YXTRQ/af/1GsXxyoxQWLSH3rRiHsgC6nAFIdegia3meIETjArh9z
 bdcVT+JGsxyxpvfAtPAz19UrnwXFnXt8NC66ne4bS+3foWY/Vz5pa1eyWKDwqYDGysl+XJqtbw
 pkst8RCFww+oozfoUXopDeIrDzKxBcQuJCKNHlMySgKL2iwPQ4ZeEGOj+06DpFWbWf7/EHJqG6
 Utw0gN56wIxn6t4DbUm72hfX8hpNqcwqmhXjaLqpVS3hPWGaE7iTT+dztUrBDoEbN2g5QivhNp
 Rt4XwYHBk4B57XthHUN+3xK+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:37 -0700
IronPort-SDR: 4tHl3GXaMf5dsGhcYVrt8y9ygYzul1oZxqmOSs1PEXOuO7gPNQru+K2sHhFXooHLFYJ1omMCz8
 IulXDatFuL+ddL/n75xpORqatLEtsHStVNc0udhousqo1KYEQPcA0+UMsoTjJxVgq9JFbeqs/v
 Uc97TKYsTtv2AUVHXL+aDtsbWRGmNRJ7ZCkPTmWAnhvrkEgbO8/cFZHFi6plYKzTJKl6Fx7JrX
 Bb2uum6ZzX2/78jSFCWP/zO4BnxHzA0mBNNsuDceRw8c80M1VF3jokjB1pS9ai5ye+MFeNsVgi
 VyU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:58 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 13/13] t/zbd: add test case to check experimental_verify option
Date:   Thu, 27 Oct 2022 15:01:39 +0900
Message-Id: <20221027060139.952508-14-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The option experimental_verify does not work with zonemode=zbd. Add a
test case to check that fio errors out when the both options are
specified.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index ce4a5916..7f5e9b1f 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1289,6 +1289,14 @@ test59() {
 		       >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test fio erros out experimental_verify option with zonemode=zbd.
+test60() {
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --size=$zone_size \
+		       --do_verify=1 --verify=md5 --experimental_verify=1 \
+		       >> "${logfile}.${test_number}" 2>&1 && return 1
+	grep -q 'not support experimental verify' "${logfile}.${test_number}"
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.37.1

