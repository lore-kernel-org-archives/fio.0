Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A132C001DE
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjGSK6K (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjGSK6I (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:08 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4C0186
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764287; x=1721300287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hGv6p/VWtHUKrPJKRtCdKeumtMe9W4cXRTJDB1wX7sk=;
  b=GGNsEJA9yrVOFngbKV97M1FkF4DuNx3XUIljQ76jY+Y5be3HUsRDZu9R
   hzIMrHFByDgol+s6NFFkftL8aoAXSbWFE/iULerLXA1Lpu/VAg+6fTydq
   m73IlQi0XO9L+4d2UI4ADnmtcLjGM73oKeGo49PH5A9AQncglQDNYuDvu
   ayCLQ5O4fC1Gk00uthaQQSwPKBNbtxKTDxXyi51LYf48pbBiYXuAehZIP
   CN0IofaromRBTZ7Jol2x4AJPbgPjh1RSSi8q3nIoZSJ19usBn6MGmXesa
   CJxaQvpO2w4iAMBGmP4fWip57G3zAXKGI/7vSg/czy4iOdvdp6dG7kElX
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860332"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:07 +0800
IronPort-SDR: NVdCD33EPLIPqlVWB1EB1uKyZBO++bpZCy7gOdhlt4Dze8/osSsyZVgiLm8c/rl2gJh4GcVa5K
 OYIubENE7YW6Jgcqdwb0rLot5BpIlyaA67+CgC8ipmhLebOBZDrYe5iS6GfoIVaM8QJmH6M5cv
 SHT+YC1V4+f8G+y8vsYbtWVMaZV3rD5BCRt3g/SoHKeIkAGEZpyDgW4p0DNxtsdhYCi0a3B3jY
 Qi4vULetxAIQERboFhuUpgzQ/yRdIKcKcvQ+db6zGX6cuZElPCFEeCdV8IvazwXbffVCGGt5u1
 9bk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:18 -0700
IronPort-SDR: BvKP29D9DHd4YgOw6qxFh4qdTZrkRG4TNUH0xJfhEqVJwrykQOwULAK+z6b3d2XEZJphaH8XRA
 A9ImCzoFwfoQzm9YA8JbofJZhQOGVZGe41AIRSqarqFkoAK+Xr63emfr0uGTg+Vd6cG3RgZF4Y
 GXGXuNu7tjZU14grHKaJB8OXanvnkBNk4suHv58WKmtzxgC1XH3O+v1K4xaQSdp3a67s3ov8pj
 6TsnHmo1OY2oG5CAx5zbB0adiB1rWM9M9noAjfIqoaJC0DdBEUByGYxiZCzyv7myEAUR4MQNEi
 Yjg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:06 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 07/13] t/zbd: add test case to check zones in closed condition
Date:   Wed, 19 Jul 2023 19:57:50 +0900
Message-Id: <20230719105756.553146-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
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

