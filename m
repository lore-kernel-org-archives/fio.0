Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAA4C7EE2E
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 07:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbjFHHGX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 03:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbjFHHGU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 03:06:20 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A85D1FDC
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 00:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686207979; x=1717743979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S8dDgKnYI6VQwVq3bwIowBlUEmKjEx8Y1BlrBdYPWAE=;
  b=Fk/9tb8at+0fWikUE9UtWiAwyQ5lUpiH0/DGMy6K4NfAr9ahnYJgNYNt
   Vo931UcSrwiKmCOLktN0U59okwDzGL4AoFqLvSF4oJEYA0YdhA2B2nMgy
   rAn2gqxtZ2ib4eIBjR+Psj4VaFBU9tRbi/fEoe2Sa9sM0SYH8VgovmOai
   EQjtSHDDl6x1d3xm1B7uFmJInsIO80sl8YpkC55EfBdmBDNU2Da3ZMHQt
   cJ1O7wT9+6EDES846p876Pv3HvmfDHhhq1WFdBj22ZYjt1xA0zUgCWUOo
   sWdZzxe1ziA0YI4aTvDpv4pcagaC9XcsHRacuQdJroiC+QPAj7A1JPUjO
   A==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="231238499"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 15:06:19 +0800
IronPort-SDR: n8f1D//p1Jjh2IFrd2XvQYfSLepyGZyNjlgEGxYEsjcQABtxa7852yrwuvP49tCkuFRUuddrhX
 KGraHjO1L0dCHP8nysw0vmWkVk4wuOc6L1IPfFvc0JV3/Z/D2ow87JAv4e/7p3BhYusdWNCR2z
 Sfkefn38MBpZmdX5f8hj1zxNDEZs3vkmcUOmww5TXAMEn6TsMF7J2QtS8lQ+nV2/HzDD+PG7jy
 YpcC7qQs1PzD2ETDajuLdLxsYlESzrEdYapS18Xw7GkSyh49zZYTfuS9l5+8HW39Ky2r0YhtAi
 4bs=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 23:15:21 -0700
IronPort-SDR: FOnCoXtgT93jrytWBhb9zTXtZMDRl3QL2R7XVCIIrYLh89qv2H+4Zbbt5RnfwnstWU61F/NtCF
 EZHQ9ct27MZGe7xoVmXgmedPurCTHmzjH/ctSlmgEjhHvVBHTPU7KT60ZcEOFLc31MncGPtuES
 xeDq9cu/xBbqSC4IxR9tWrDCn6NfREQVdZ2LFBpWB0Rt5v4fKIlScqCNZppuA2L2NT/Npmlrji
 NrasMnCsmXzGsU7MbRnScdC85D61F41N1TRL7d9P9tT/em+I0eCEj4HcjJrnSZOHA+piQRsR7C
 9qg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jun 2023 00:06:18 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 6/7] t/zbd: test write zone accounting of almost full zones
Date:   Thu,  8 Jun 2023 16:06:07 +0900
Message-Id: <20230608070608.1256970-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
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

