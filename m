Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16925EB64D9
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjGGDPV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjGGDPR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:17 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1B71BC9
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699716; x=1720235716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XRDyAjoDW6VwBwJn/OxpVfKy6+eLN7elDdl0Iq1TgPY=;
  b=Wbn6F0+y8HznB27bpvMQEe1Ftc/QkRDH+QoGuHpuC0WoLO6f4bnJkrDZ
   BcLphlAxuKtBsFv0PLgabSHyx0r0EVJqeVy3wzr/lSSFOYtt0rm2EAwtY
   IJll915n3TyX6+Aq9zHR2jo1t0XDqzbjMHiNukFptGi5TqwB56adhc6MK
   vS1CMj0m99rT7gKUQKHZtoG2EXoF9zFlJ6qG7f31oChvJ9MxdhmNTtOhh
   kXeMLuvfXCIzqaPIe5nsW3aFB2q5jBFHjEaNHierGSXZ2V6KzSTglA9nG
   VAB0vjxg1on3Ik9b7nGPpPt8FRw7Q1Y9G3YgMjdFy0EaKtIYw3FA/Aqzr
   A==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468813"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:16 +0800
IronPort-SDR: +pX5/mABLWihrteYjFLdBzTs27oW8zPFr4e3vd8cTin3P+lC9PT3IJpxk88Hrbzez0FfiZiUp5
 dAMJMXAVJ8UfA4W0frqL4GZKhvecETOjecOrluCrg7PCyXNLlEXsjMZAPZ0GN4RYHy4cg2yebK
 drzSHC6+x0P81PlVRxTTGM1WSm7MrmK2XMeTNodd0ZmVMxrTSNCk0mBtj2CH9e8rwqgLUUQaaG
 0z7mDa5iaJ3skCyzZ6twRUUaAyCtHhSQmASi0eE7hO6r1DNd3WtQix18S/h9PQy9ddTZN5xx8O
 fPQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:23 -0700
IronPort-SDR: aYASgbmrPbaQkP93Dwo/VY44vJkuPEZ3eYWOZb9dupSLDd7x3M29HlmfNt28Gzdj+dc4U/fKCf
 rLkO3Dz/hq6Tcr25VsK8ECnCgan8WBT6nUbbrH5qzCwpMaBYB5gcz4Aw6sNyFh/T3UgzN67xzK
 FPE0ai3bAAwvFGbYU0UZdMmYPuL2s4g3G7GzsgJTF7b5eOs3g7UhQGSPGCgXSVOn44pgtjuoDu
 CtDcuVrVM1pTTfZ++50sa4fWr2rIPGYtZN9iE8Mjx5QIcWT9VJ+67lGQ9XHuZFgslD/865s7Xh
 9Vw=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:16 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 08/13] t/zbd: add test case to check max_active_zones limit error message
Date:   Fri,  7 Jul 2023 12:15:00 +0900
Message-Id: <20230707031505.3468915-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
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

