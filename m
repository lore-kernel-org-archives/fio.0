Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C28FECAAA1
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiJ1LyX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiJ1LyV (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:21 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7951F1D2B77
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958057; x=1698494057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l5CeVTmYAqHR/oD6Yt8OF0hfzvYySTFWIz6C5VJMS3M=;
  b=hJDhrNN6YvMUPXb4a/5omZ6WifvM5trxbWN4OrFlyzWpbb1a0LaB5Wdw
   j8+hEk4merAOYmZ6qzTsa73k7ppQjiFsRobVft4tBt/n/FV0vCHzTRtu9
   3O/QQ36BemqR34BUE2dvPLdafdtR8/UKGXuIuVDckILYII8L0bsG8bbPj
   iCIqulxLwS8baPqtB19bASPxKejAAPG+zc5hQH1x4Uo3gqYwNa1kU+YYl
   E0l7dqPT25hTDmekUTqLo1vbKTwPfOkmFDQEZB3Rb+bsYN6dsGSlVd8T9
   Kbdbowvtmn1kMKzGS1rOK8sH9ru6n5M4hSEcuxx0qY0CrBSoBN+9o29yc
   g==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074546"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:17 +0800
IronPort-SDR: /MbjIsCYUOpGvjhAz/7v7wft4ZG3okW2tiXTy2beyRmf/FFqaqwp07FIzP1y8pMOYx9Y/YfieH
 1u7XnUnESZD/nmivHORMcvpiUlUwe6vqdxuGZW0uLA8hAKbhXchSg3R3FDkChMAfRMeRs0xXnR
 2yHbnq1ydS69Q910duRks8u8KhNmDqwGWB2Gad8XhGBeWrtvYdB99ny0y/KJkUU+9GqvnpmuYU
 zmGxhG92i9bcPjlF7Lh3DeYMmdvm2DjoR3Rjg9I839+mvd4J2fQ0RFy6u60KfGTKhQZRwVxRBO
 NsVCyxIzRa0QIZ6SjWH6z3Bv
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:53 -0700
IronPort-SDR: j2b/8pNjaqU0yP8a0cQHIiduc81VuyGPlqD0+DiuXujfTkV6vVaY9eQBgng5TvDcBdqbcz27GU
 8Wx3yqXS3sumHo/M1OuW4hG8QDfpjKxDVt9z9ukwh1cFXn4pzV5giBJZAB6YYe2C5nDNN2kQHe
 iLOweu1p4iC/adY3os+psbsqh0vUbwSfkupPpZSjQhKAJFU8dImojPHBPq0EgJWau8ykqjItdO
 lAklNbgR9Kw+zYfkcny+Ro+kq2Q9fmS+Hz+ODpkUQ1uZKKOObUe3zXRdX6NdKPIhM6vOaLDpL8
 htk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:17 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 13/13] t/zbd: add test case to check experimental_verify option
Date:   Fri, 28 Oct 2022 20:53:54 +0900
Message-Id: <20221028115354.971715-14-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The option experimental_verify does not work with zonemode=zbd. Add a
test case to check that fio errors out when the both options are
specified.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index ce4a5916..4bc29d1b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1289,6 +1289,14 @@ test59() {
 		       >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test fio errors out experimental_verify option with zonemode=zbd.
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

