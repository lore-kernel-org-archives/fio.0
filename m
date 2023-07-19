Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB26C001B0
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjGSK6L (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjGSK6K (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:10 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C11186
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764288; x=1721300288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XRDyAjoDW6VwBwJn/OxpVfKy6+eLN7elDdl0Iq1TgPY=;
  b=mkkN5ESjBtBeAc58FNzdHuaH7a4E/idHCRhubytpWufX/5wXC0i7uLmV
   r1gwMDOi5weOclBfNdcPDtCtlLPzcB8e0bLL7qH5O+G/neAeu3Onieizb
   mkouU4IJTBdOkBZNxpF9RgFuKMnjic1dMcmhyVp43d0B37ZN5BYhDPI2B
   g2AQuH/sAPKngaHJcOIwmMFDWqT4NSzz9Ki6tKk28A1pf4VBvet6nVIUg
   iEcOiYwwcYGi3MWBoxOliO8ri6PmdMusWu333ID2LvQfXbjH/YEOX16pt
   lnE/mZRXw3UqIJNz6RRjpVPhTcNPz4idZJ92waxcIONlGIaJL19yRvDgm
   A==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860335"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:08 +0800
IronPort-SDR: SUYeZHWWL1Av1n7rWvriK4AKTydKYTctkcQGTqjPhJsd38C88XoEutbLsoJdlqTyF7pMV1DnCq
 HCkIbySgqY7MYIwfn45k7ecajiS0jP1gcIy3Uag/qWlA3FGyriQ/Vz0xVBD2pKRSL9wGTM3lBM
 ARphNi4u392WimE2QCSdANOSNyVsEfkUpdDnTNo+M+SVPuXjqcZ5ZEsAlc7rQ73iHh759WECAM
 CRZLWhhTsrfRprWgxgHvHaS/J4fCWh3JWW3nMIGM1TNtiKhLobfjkjrAlWI7MHN2+3AbGeLm9m
 aCg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:19 -0700
IronPort-SDR: OvAX8yGW7wBFBcp1RomLGBo5+Q8RpeXBftvcddbWJFM5Mqxh00t9FeyCnJr3u1Je76qEWmsrVF
 L+SMgWqz+YFNNkJmBYbvR33WKf31J9vbBzW8HnGVXgM07+o/s97djmyZwqv/CVos1rzUsDJqIr
 zJ7M1yDh1IdG7YUOTl/3p6u5TuL18VMJ2RPM5eS57DJBDvuYzWtjvpZWvBKxzS96W/6tGNOxry
 weRBIdrwmZUUw5+XZcR9sMbn5MHHKB+yA/MR0Exz8E4XLo+m9qu3Ri70XQ4tbjVPQDP14Q6Lug
 8lI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:07 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 08/13] t/zbd: add test case to check max_active_zones limit error message
Date:   Wed, 19 Jul 2023 19:57:51 +0900
Message-Id: <20230719105756.553146-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The recent fio change introduced a new error message to indicate
max_active_zones limit error of zoned block devices. Add a test case to
check the error message is reported.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 6d44faf1..1d1d389b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1464,6 +1464,34 @@ test66() {
 		       >> "${logfile}.${test_number}" 2>&1
 }
 
+# Test max_active_zones limit failure is reported with good error message.
+test67() {
+	local i off
+
+	require_zbd || return $SKIP_TESTCASE
+	require_max_active_zones 2 || return $SKIP_TESTCASE
+	require_max_open_zones "${max_active_zones}" || return $SKIP_TESTCASE
+	require_seq_zones $((max_active_zones + 1)) || return $SKIP_TESTCASE
+
+	reset_zone "$dev" -1
+
+	# Prepare max_active_zones in open condition.
+	off=$((first_sequential_zone_sector * 512))
+	run_fio --name=w --filename="$dev" --zonemod=zbd --direct=1 \
+		--offset=$((off)) --zonesize="${zone_size}" --rw=randwrite \
+		--bs=4096 --size="$((zone_size * max_active_zones))" \
+		--io_size="${zone_size}" "$(ioengine "psync")" \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+
+	# Write to antoher zone and trigger max_active_zones limit error.
+	off=$((off + zone_size * max_active_zones))
+	run_one_fio_job --zonemod=zbd --direct=1 "$(ioengine "psync")" \
+			--rw=write --bs=$min_seq_write_size --offset=$((off)) \
+			--size=$((zone_size)) --zonesize="${zone_size}" \
+			>> "${logfile}.${test_number}" 2>&1 && return $?
+	grep -q 'Exceeded max_active_zones limit' "${logfile}.${test_number}"
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.40.1

