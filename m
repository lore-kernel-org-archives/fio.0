Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD26C4332F
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiJUGem (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJUGej (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:39 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D191E32058
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334076; x=1697870076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YDxtPUni/hcAUaZvRgSnJdYFEBxZMnHMg0BDx6WERUg=;
  b=qpVqRv6nB8EVUDuwbz+Qbv6nWgJxzeajJJ4RvAUctu/0K3c0HfVpg+rh
   ksiN2ycBJKih8YvXGSFp0fpwh4adVuWQEiycsK1yEfTLZBMiz7XTJmY1I
   S8ZH39WVXZ3RYGWhqLXA3L2hyhhzSCG9AE5FyNVfvqFqkpROx5HPhRr+p
   K07z+QJj32RiUdV9g/fV3tZ8VmOogfqvw6GiFIOIWSaIakNcMsKCQsvkH
   vGSn6I3g8L9pVs4RAeU9yBOyXXlNSYFzWwSMp3pLHPY7zH55O1CplI8p+
   huk9e9T3Oc0C+ufzi0rzLUUb8BhbBdpZvgrofnCz9EbG2MTdPx184CdVe
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733124"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:31 +0800
IronPort-SDR: Eh4ZRN2DbNRI0EBxEo2A1nEd5p/4Q66iwDZpbObVLXsr5uk7Ud099AYHVIGF4+K1JgzbEuQtTf
 PY9EqTZ19E8JVl3zCQ/34Gtu06bvCp4v/rXkHCl1MuIIjx9hfj6XxSaxdb7XmQAxqByeEqYFbE
 MYedmJnOETNm/KGAgXpZkU88Up1JUVpu0YprGWAh5di6Z9zimAydIQAn0XShqOQZ7zijX2u10H
 EUKlxum1FcUd0BvaImX8rw1QyKmQpdT2gKbjb79tcMecwLCif1hd3YZfc+WPH23na4ElksdwMZ
 4KgM8xu12x1/uK5xQ1UHPu2K
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:19 -0700
IronPort-SDR: PKU2gx9fOGjS++pKif5D3DYG5FrTTmIbvi9WeEmQOeZkeM2Jy9QxYMSwFzXQnL1OGu/f/096VH
 yHSTCTpJoP7ju0+TmV8swsbbIZH7a3l/rXzxNd5iOrVEmhb5N2jlO4jJIvfZp+LVPeOl6w4dEs
 8HunMMFlbr2PPM6FoiCZrxSr5g8CqoumqNBShADp3yxgK/XzDs4HUTyMbbbknYlBuF2Ty/0Lr8
 mZsOQYQDNI3Xr8++0RvGFk6Kat+EU+6aEv/890k9fR2sWDDqZAQ63rv4SM6xfsgoNhF4DbfvaS
 3+E=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:30 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 10/11] t/zbd: add test case to check zone_reset_threshold option with verify
Date:   Fri, 21 Oct 2022 15:34:15 +0900
Message-Id: <20221021063416.860438-11-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent commit fix assertion failure observed with zone_reset_threshold
option with verify. Add a test case to confirm the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e17a81de..0e185997 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1276,6 +1276,20 @@ test58() {
 	    >>"${logfile}.${test_number}" 2>&1
 }
 
+# Test zone_reset_threshold with verify.
+test59() {
+	local off bs loops=2 size=$((zone_size))
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+
+	bs=$(min $((256*1024)) "$zone_size")
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$size --loops=$loops --do_verify=1 --verify=md5 \
+		       --zone_reset_frequency=.9 --zone_reset_threshold=.1 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.37.1

