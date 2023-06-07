Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C57C83003
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 08:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbjFGIcm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 04:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235486AbjFGIcl (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 04:32:41 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB8C10F8
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 01:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686126761; x=1717662761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S8dDgKnYI6VQwVq3bwIowBlUEmKjEx8Y1BlrBdYPWAE=;
  b=CkaKs/Cm2pyMas8sAC4qgtpFJq/MdJsvSE/mIIKz0zKNcre6ZRVRMCAc
   vLzDWuI7rLzjD7XDrtVtVeQQMQV15aJtbxj7sRFjKnyU+I2jvimisIs2B
   xLHaqTNISGjbHsDobHc5XrlaJTaSZzLg/5uGatViCNdg6gHDk17OEOonP
   S+22TymNkKYvrWPGRbbD5ahj7ycv5nHJuXcAooNRB0K/dOt3ZFbQuCc3o
   Ov9wh8jzAYrpaDI9pM7si6GFPHKIs3LzKST+JtB2xJzVFCArggHcEFDTi
   BLQS+RFoH/hl7N3W30ghWNPp9S3Ybz6qAMaBnj6JyBaWBWsAjujoGrceF
   w==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681142400"; 
   d="scan'208";a="232851911"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 16:32:40 +0800
IronPort-SDR: ozorZvG9mUaSMM/9kBbAyayYJg9Z5e5NF6RxAksjsWZNKQDOPFnBBNy0PHzWNCJfFu8HRxPo4x
 P+PAiMsHbAvt3tSdRmWKeFbHARL8QH1IRx3Iw+LI17jgJEpQEg08vQKHD/iZfK4wWTFf80AMLQ
 HGEkUU9SRtsF5fI5DbeC4KEEAGj2n7sYd/pFTQQmPCQY1HPSAa4FHnrLMr1+QyDXiGC5I5UEb2
 iaDiL7fKrmcRZsfmMNlYMCsSbkEutcWixTTbIxT1Ss0B92kGWVwspZgKTAn1erGRhevfUUds59
 EVY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 00:47:22 -0700
IronPort-SDR: 9bdh0OP/GtBfS/tAdncPGsS0b5mIeWBO3bYaxZI/og0epw3wfFzyZ7OediNLwbTPako3WVDIr+
 alwfUyH2Xi57nhBm024LFnB+fadOHga+W1simNWmfIz1kge+d5NcXjOYqxNbP7HhK0TPV6LrcA
 X8QMsldXXv7a6ICj+q9gf/nr5bPXhPOhYkj3C878JNfDQGXECqvKZRrlbYqGoiSF1NgFVRQStl
 /pBGIXryHljxKDZY1l2MCCWk3nrVo6u2htDVj+t5X4guhkNO3rCEecIcUhRxFv5iQT2IIITQph
 +pY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Jun 2023 01:32:39 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 6/7] t/zbd: test write zone accounting of almost full zones
Date:   Wed,  7 Jun 2023 17:32:29 +0900
Message-Id: <20230607083230.1178573-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent commit fixed the bug of the write zone accounting for almost full
zones. Add a test case which confirms the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 86577952..cdaa0574 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1368,6 +1368,27 @@ test63() {
 	check_reset_count -eq 3 || return $?
 }
 
+# Test write zone accounting handles almost full zones correctly. Prepare an
+# almost full, but not full zone. Write to the zone with verify using larger
+# block size. Then confirm fio does not report write zone accounting failure.
+test64() {
+	local bs cap
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	bs=$((zone_size / 8))
+	cap=$(total_zone_capacity 1 $((first_sequential_zone_sector*512)) $dev)
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$((zone_size)) \
+		       --io_size=$((cap - bs)) \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+
+	bs=$((zone_size / 2))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$((zone_size)) --do_verify=1 --verify=md5 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.40.1

