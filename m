Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919F8C7EE23
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 07:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbjFHHGa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 03:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbjFHHG1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 03:06:27 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7876626B5
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 00:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686207984; x=1717743984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gx3doQmyvYr75Gai/JXJV0NEx+hvZiJ1/Cg31lD4DoI=;
  b=G4Sy3UxO0Qeyc4Or8fDA89/oyQRVlmOczSRKtnXhQTzItKq8LdPJt4PY
   f8R6WJ/szxak4fiAQx5jBqhqsAuqPXmIcVvn5nC4dfDe2o4xqfY38/4U2
   MOrIpHRPioKZnw92FwcBaGQA1+//fcRPKvj4JcwAKD0pkJnKk5JrzOuuv
   kJyYUI/xRXqIVflY2sHp8G5k5xW4uaRZrAZN6TCni2RuRc8mHK7U/LnYk
   zqULHnTTslyo/yCr6ewxPAzu/ORASuIS7ZMe3A/J+295Yc+XFC6WAD5ee
   CaTDFVqU1REzoChXk7Ufy8DOsuM1R2aXyUWzj4jOTtyNzzLoHrO29f8+a
   g==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="231238514"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 15:06:23 +0800
IronPort-SDR: N1Xg8LRo23LFwdDjtFyhVq8zqR/pdkjrgj+kK2LBBFF7Og8sKLGYq5ekI9ZrQBRo2YSXo8gkKN
 g0pLhaZz9AH1J4HrNFQ4iFyr6NLAuQdv0NUKrfQ3XoHHGv59yG2/zcOkQf5j+RiO0lPgtw/uN1
 +ECE9hNE9lB5r945xzg9BHrjetjvt659JtBSFpEbGZrTY1DJtTgMqvwpyDxFNraeDaKh3BUiIK
 Z47pJTG56WTs1z7jyb1MKNssOdeO8y8APfGOSqYb/c4mpeFzJBuhXVH/8bRVH/zZ/3G+Jyj9Yl
 bwg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 23:15:25 -0700
IronPort-SDR: gEEt4x3gbLFaUExqtIqB91nlQSR12Z3OmpJYUqzO3X2iidqccRFcRYW9vWM689R7l1cjH+sqN6
 j4Hu0EW7mMJeomtDNoT5h1JgDkgCcpCPwcbDAtXBn5n7NUm6AY3LlUhUyCS7Gl8/I6TnX6GAeY
 /7g3BQYQIUBiXYFrh9akH+fVmQFjGP0bcZvuOq2l9FTSQ6xJfE9gPKZmgiEvhyLclTelW3jcwR
 nc44kr2w84LYbMERHZkGdUxiV31637dE4GmjGmA4buVlOsCamjwQisQKn3jOP2x8VTxGh3Cg6H
 4aM=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jun 2023 00:06:20 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 7/7] t/zbd: test write zone accounting of trim workload
Date:   Thu,  8 Jun 2023 16:06:08 +0900
Message-Id: <20230608070608.1256970-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recent commit fixed the bug of the write zone accounting of trim
workload. Add a test case which confirms the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index cdaa0574..a3d37a7d 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1389,6 +1389,30 @@ test64() {
 		       >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test open zone accounting handles trim workload correctly. Prepare open zones
+# as many as max_open_zones=4. Trim one of the 4 zones. Then write to another
+# zone and check the write amount is expected size.
+test65() {
+	local off capacity
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	off=$((first_sequential_zone_sector * 512))
+	capacity=$(total_zone_capacity 1 $off "$dev")
+	run_fio --zonemode=zbd --direct=1 --zonesize="$zone_size" --thread=1 \
+		--filename="$dev" --group_reporting=1 --max_open_zones=4 \
+		"$(ioengine "psync")" \
+		--name="prep_open_zones" --rw=randwrite --offset="$off" \
+		--size="$((zone_size * 4))" --bs=4096 --io_size="$zone_size" \
+		--name=trimjob --wait_for="prep_open_zones" --rw=trim \
+		--bs="$zone_size" --offset="$off" --size="$zone_size" \
+		--name=write --wait_for="trimjob" --rw=write --bs=4096 \
+		--offset="$((off + zone_size * 4))" --size="$zone_size" \
+		>> "${logfile}.${test_number}" 2>&1
+
+	check_written $((zone_size + capacity))
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.40.1

