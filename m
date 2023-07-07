Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DA4EB64D9
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjGGDPU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjGGDPR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:17 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144B61FDA
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699715; x=1720235715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hGv6p/VWtHUKrPJKRtCdKeumtMe9W4cXRTJDB1wX7sk=;
  b=I9Ov8EuECZ5AOqW2eb0/DL8ypab1QVD+3q/u+rhqkdLA/epeC9XzSdS1
   MemFs5DPdqgO1moPpDAaPFzwMhGZXzyddPi467LypI5kmiUTF6DzlOvsM
   25bCUi7qORwDYmaFgfiWkyYRJ0/INZLDXAZTXwrxIUJhmY+A4IyNmIVxm
   bPGzflcnMWlqsra6I50jXH8xoIK2wXsRRKHJiFRFOzL+POUXxU9/zBxfr
   3EG2mGapXsAzejv++CIqJz+gXP1a0QbqUtfEbKgmaTFpZ2BqSmUWU8b+H
   yIyDsvAppaBpMs2LyxbxINPsnQ9FjSewGehmiPXLpMApVqYt3OaJgwybt
   g==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468805"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:15 +0800
IronPort-SDR: dj8z5RMATzo1eR6qFD/VaiL74lEne/pXhQtVK9mAxB9aviYwgs+K2nHk4gMzJKUkdZQj8wPu2l
 viE4VsbHAdRrLCmC5w4e9e3lo5vABGbE7ibD2SQCLk9kAO+BsLbdNofjyazSVAzx2gEcvS+s2W
 i8LaStZDRxq7DsVj9lmyUgpOb0K7X+pvgsCuhdXccx8uPyZVDsKVeOjvZpje2QH1X8TsD3sFJE
 9icvmheObmF0X2HUtWxvhH9phEq1Yhtws1ZEcXfsTn6VpQvttCXb2GQXJTEhJBzy4/Lk2c9fJP
 Rx4=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:22 -0700
IronPort-SDR: KjLbcfFWgfFFR6kcKe31G1hohB/itS0IbaaVeSyrvaBUB79InMTshHwVnccnlzrBYG54bJlo/X
 KHKWnQWQyk4ld1sbZaPzqcP8Amu/7tn9E6ecn5DFZFs/j+bt07M5SNsaELjFcO/8O3SbLZbbno
 ehkAFFUCKAAToRG/K2ziYNlc6uSNt9mJ6FzqIUd9Lq4ccf+kX8sNE4JExJ4F9KjODRWaCal2ln
 3EKmnunotUwDvwUzjlGjGOnT/B53yE+sGCBy3aSPD8DoLPlp+MsoLZjBlimEuqWryz+FFeNygv
 x48=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:15 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 07/13] t/zbd: add test case to check zones in closed condition
Date:   Fri,  7 Jul 2023 12:14:59 +0900
Message-Id: <20230707031505.3468915-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When the zoned block device has max_active_zones limit, the zones in
open or closed condition consume resource on the device. If the number
of zones in open or closed condition gets larger than the
max_active_zones limit, the device reports an error. Until the recent
fix ("zbd: write to closed zones on the devices with max_active_zones
limit"), fio handled only zones in open condition as write target then
fio was not able to avoid the error.

Add a test which confirms that the fix avoids the error by handling
zones in closed condition as write target. This test case requires the
device has max_active_zones limit. Prepare zones in closed condition as
many as the max_active_zones limit. Do random write and check no error.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index eed3d00d..6d44faf1 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1427,6 +1427,43 @@ test65() {
 	check_written $((zone_size + capacity))
 }
 
+# Test closed zones are handled as open zones. This test case requires zoned
+# block devices which has same max_open_zones and max_active_zones.
+test66() {
+	local i off
+
+	require_zbd || return $SKIP_TESTCASE
+	require_max_active_zones 2 || return $SKIP_TESTCASE
+	require_max_open_zones "${max_active_zones}" || return $SKIP_TESTCASE
+	require_seq_zones $((max_active_zones * 16)) || return $SKIP_TESTCASE
+
+	reset_zone "$dev" -1
+
+	# Prepare max_active_zones in closed condition.
+	off=$((first_sequential_zone_sector * 512))
+	run_fio --name=w --filename="$dev" --zonemod=zbd --direct=1 \
+		--offset=$((off)) --zonesize="${zone_size}" --rw=randwrite \
+		--bs=4096 --size="$((zone_size * max_active_zones))" \
+		--io_size="${zone_size}" "$(ioengine "psync")" \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+	for ((i = 0; i < max_active_zones; i++)); do
+		close_zone "$dev" $((off / 512)) || return $?
+		off=$((off + zone_size))
+	done
+
+	# Run random write to the closed zones and empty zones. This confirms
+	# that fio handles closed zones as write target open zones. Otherwise,
+	# fio writes to the empty zones and hit the max_active_zones limit.
+	off=$((first_sequential_zone_sector * 512))
+	run_one_fio_job --zonemod=zbd --direct=1 \
+		       "$(ioengine "psync")" --rw=randwrite --bs=4096 \
+		       --max_open_zones="$max_active_zones" --offset=$((off)) \
+		       --size=$((max_active_zones * 16 * zone_size)) \
+		       --io_size=$((zone_size)) --zonesize="${zone_size}" \
+		       --time_based --runtime=5s \
+		       >> "${logfile}.${test_number}" 2>&1
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.40.1

