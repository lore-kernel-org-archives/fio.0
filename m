Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A5DC61DA4
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBIHJY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjBIHJX (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:09:23 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D1C3F28B
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675926560; x=1707462560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=unb7vGolvfI5H5USTxT4vGJCq71ks99qG91lZF18NZc=;
  b=ZxaXbglMbLBoQ/Fj5+ZIsGMUngz32+1CaiO3ISp1h9ysMB1QD4+xU8zy
   6P97SEI/XX/uS5qK9iO9zg3VWE9m0HhPwdm7uflkpADjD2neGT8LZIpya
   +YbXpl7owh0yXOUiKDtL1uVwDS5zpvbdMKrcaWLg8j5OeIdOc1ln+aWGn
   HzBllXVNXmqxFTwpof5+4R73RPUAbNrRoU2E/9WsUbDnpbbZUmiPcmzUP
   SSp+BdMl38jj7nNcJhCyb7Hi0obdoBwtPABA3kNE03PgsofWf00yA2kBe
   gFRg7c5QWTwpvgCDqMgj8QdvFHuH5eDrxwkTQhSSVDLD2QFG7CRLC3L8Y
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="334848086"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:09:20 +0800
IronPort-SDR: 91kIpKtmohIajKRu7XUe9qUxpWjViRE8HLwXgHxCDCRmwpZNllc9nu4POceiaTxiaezm6O2cJP
 arxfmajTukl9hMc88ko9yqCtz9Mo6sJ+XiKY2Zdt5+aYMyz/RCte5BKDy2PVH/sIdgo5cNzJQs
 4Em0DrKV/7RMjXokIHQ00+S2hxZNbieTkfOf4qDgjJHBW6BTAlFDmVMIIRzk2cMkWZ+B1pzIH6
 DDe4QIK+mJCkaDXRel8eOxkChd0Wuc8dZeBQGv8EmNet178e65Zsski/jA0n9VI/bwGWaDu0T5
 rvU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 22:20:50 -0800
IronPort-SDR: fAyac9wFW6ZYbz+pufD35oEqIDKZtsL6jIWwHMsRyICqWIdYU4Gp70kTAH5VtScOyNFlBLuLFO
 8UC+KQS0NubcMqKpihu1HwQDB405v3OwTq5piZ3Ffi1doZ1bvefiFZW0dZnuC27rvAT4c6vU+I
 Yc9FKmX9FhRg876B996f5reJs5XqqQ0FrHVx255nnTCysbvLlSduggcXA6mEVuPuzvZqlYYJfK
 inY7MNMW4RLB1GsZagmsY20bOu1Hwz1jfkfFIWmahA1ZqVbhUdnWVAZ9+ekzt5m1LYkAapn4G8
 XiQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Feb 2023 23:09:19 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 8/8] t/zbd: add test cases for zone_reset_threshold option
Date:   Thu,  9 Feb 2023 16:09:07 +0900
Message-Id: <20230209070907.1733138-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The zone_reset_threshold option works for multiple jobs only when the
jobs have same write range. Add three test cases to confirm that the
option works for multiple jobs as expected. The first test case checks
that different write ranges are reported as an error. The second test
case checks that multiple write jobs work when they have same write
range. The third test case checks that a read job and a write job work
when they have different IO ranges.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 t/zbd/test-zbd-support | 56 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c32953c4..893aff3c 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1305,6 +1305,62 @@ test60() {
 	grep -q 'not support experimental verify' "${logfile}.${test_number}"
 }
 
+# Test fio errors out zone_reset_threshold option for multiple jobs with
+# different write ranges.
+test61() {
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --size="$zone_size" \
+		       --numjobs=2 --offset_increment="$zone_size" \
+		       --zone_reset_threshold=0.1 --zone_reset_frequency=1 \
+		       --exitall_on_error=1 \
+		       >> "${logfile}.${test_number}" 2>&1 && return 1
+	grep -q 'different write ranges' "${logfile}.${test_number}"
+}
+
+# Test zone_reset_threshold option works for multiple jobs with same write
+# range.
+test62() {
+	local bs loops=2 size=$((zone_size))
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	# Two jobs write to single zone twice. Reset zone happens at next write
+	# after half of the zone gets filled. So 2 * 2 * 2 - 1 = 7 times zone
+	# resets are expected.
+	bs=$(min $((256*1024)) $((zone_size / 4)))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$size --loops=$loops --numjobs=2 \
+		       --zone_reset_frequency=1 --zone_reset_threshold=.5 \
+		       --group_reporting=1 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	check_written $((size * loops * 2)) || return $?
+	check_reset_count -eq 7 || return $?
+}
+
+# Test zone_reset_threshold option works for a read job and a write job with
+# different IO range.
+test63() {
+	local bs loops=2 size=$((zone_size)) off1 off2
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	off1=$((first_sequential_zone_sector * 512))
+	off2=$((off1 + zone_size))
+	bs=$(min $((256*1024)) $((zone_size / 4)))
+
+	# One job writes to single zone twice. Reset zone happens at next write
+	# after half of the zone gets filled. So 2 * 2 - 1 = 3 times zone resets
+	# are expected.
+	run_fio "$(ioengine "psync")" --bs="$bs" --size=$size --loops=$loops \
+		--filename="$dev" --group_reporting=1 \
+		--zonemode=zbd --zonesize="$zone_size" --direct=1 \
+		--zone_reset_frequency=1 --zone_reset_threshold=.5 \
+		--name=r --rw=read --offset=$off1 "${job_var_opts[@]}" \
+		--name=w --rw=write --offset=$off2 "${job_var_opts[@]}" \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	check_written $((size * loops)) || return $?
+	check_reset_count -eq 3 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.38.1

