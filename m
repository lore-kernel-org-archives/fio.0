Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D11C05027
	for <fio@archiver.kernel.org>; Mon, 30 Jan 2023 02:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbjA3C27 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 29 Jan 2023 21:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjA3C26 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Jan 2023 21:28:58 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543071EBC0
        for <fio@vger.kernel.org>; Sun, 29 Jan 2023 18:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675045737; x=1706581737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WrDOGGaS8jQq6ySsTojtlXXsF5z/cY3b29f0iEoWN44=;
  b=OQfEu9VCthSKoYfRepdomTvbdrqsy2gsOhefnNaIYWGGpNLWKMmO5aY8
   9wzHcc+pdJoNdkKBX2lphl2KjFiMU9COghIufSD6ACog9zvVSAFU32IA1
   NKnGEiCTav2u1rinnnzVXBs6A37fkMW4CVK7BlIDmnAu5S0by+u89WJDM
   bj2RyHFR9EBhUVYTPTL9j369fxA7g1pDXl/01jR28zPsQiY7jgVMo4nBs
   sfP40vMS044MAEL1eWanWijCwFI9Ape5+9rFmDGxC7yrgzJqdJSjVbVBR
   gHY6RrD0HlhAsvNhC7ccg3IQSyX60cKFeNkS9Bnf7F4rbbMG4hz5siaWF
   w==;
X-IronPort-AV: E=Sophos;i="5.97,256,1669046400"; 
   d="scan'208";a="227010394"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 10:28:56 +0800
IronPort-SDR: Apv6rxuieLUFaLVL1lTaAEr2T1WeRNo5X348z2h87WmeiDqp2z7Jvk/J4OPIcSCNBen23t7orx
 NcGDI3rprANrxGc40IljnzgModFwmCFQ99Wpw2YEheqJxTpbOyg12ePvaBOLTVtCjfRsCl5Dd7
 G1Ncx+L6L99kQWj83Y8JcD0+iwo4hy+DrhvgGR4yWIPNvJuklgC4QVMuH3CiWu4X2aNVaroDFV
 h9aPNoI9EeyCmQJhrFZfa69kJwAXJdqj8T9231toTMjs1kH/Xo8Ag1aYiQKDQrHwd2oKTXkN/L
 vMY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Jan 2023 17:40:39 -0800
IronPort-SDR: T0bVD/2at/EdlshAlDWROUiIJtkoCrzjV4Qh/zDjL+DIGFO2fuqfw/DtOuaDUEeoo9V1WQ4SaL
 iLW15RtfENcWRaudc9Ga03cHZpbBKNNSuJ/tP8rq1ZIpt40jr8npzjaLsxSOnoVxMb05V7mLZh
 gMSpxc/L605VIfeDrB9hBllKDiadoWkwYZK+junaAArJZXKintWs89N3xRmnXEOMwZhxH2AAKV
 qCp2EmVuXUkoXw9C3etQTrvHrYd6E3GkXjiL7vqOPWKdJM9uLMvrXpSdJpVWNOjT65KFP7f6fj
 qh4=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Jan 2023 18:28:55 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/5] t/zbd: adjust test cases to zone_reset_threshold change
Date:   Mon, 30 Jan 2023 11:28:49 +0900
Message-Id: <20230130022850.1375523-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
References: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The commit ("zbd: calculate zone_reset_threshold ratio for device")
changed definition of the zone_reset_threshold option. Adjust test cases
24, 52 and 59 to reflect the change. Calculate the option using bc
command. Add a new global variable nr_seq_zones which holds the number
of sequential write required zones on the target device. Also add a
helper function require_command to check availability of the bc command.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 66 ++++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4091d9ac..22cbd4ce 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -272,6 +272,16 @@ require_max_open_zones() {
 	return 0
 }
 
+require_command() {
+	local cmd=${1}
+
+	if ! command -v "${cmd}" > /dev/null; then
+		SKIP_REASON="command $cmd is not available"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused for block devices.
 test1() {
     require_block_dev || return $SKIP_TESTCASE
@@ -630,21 +640,26 @@ test23() {
 
 test24() {
     local bs loops=9 size=$((zone_size))
-    local off capacity
+    local off capacity ratio
+
+    require_command bc || return $SKIP_TESTCASE
+
+    [ -n "$is_zbd" ] && reset_zone "$dev" -1
 
-    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
+    bs=$(min $((256*1024)) $((zone_size / 2)))
+    # Trigger zone reset when half of zone was filled.
+    ratio=$(echo "scale=7; $size / 2 / $((nr_seq_zones * zone_size))" | bc)
 
-    bs=$(min $((256*1024)) "$zone_size")
     run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs"		\
 		   --size=$size --loops=$loops				\
-		   --zone_reset_frequency=.01 --zone_reset_threshold=.90 \
+		   --zone_reset_frequency=1 --zone_reset_threshold="${ratio}" \
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((capacity * loops)) || return $?
-    check_reset_count -eq 8 ||
-	check_reset_count -eq 9 ||
-	check_reset_count -eq 10 || return $?
+    check_written $((size * loops)) || return $?
+
+    # Zone reset is expected loop * 2 times or minus one.
+    check_reset_count -eq 17 || check_reset_count -eq 18 || return $?
 }
 
 # Multiple non-overlapping sequential write jobs for the same drive.
@@ -1110,31 +1125,35 @@ test51() {
 	run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
-# Verify that zone_reset_threshold only takes logical blocks from seq
-# zones into account, and logical blocks of conv zones are not counted.
+# Verify that zone_reset_threshold only account seq zones and conv zones are not
+# accounted.
 test52() {
-	local off io_size
+	local off io_size capacity ratio
 
 	require_zbd || return $SKIP_TESTCASE
+	require_command bc || return $SKIP_TESTCASE
 	require_conv_zones 8 || return $SKIP_TESTCASE
 	require_seq_zones 8 || return $SKIP_TESTCASE
 
 	reset_zone "${dev}" -1
 
-	# Total I/O size is 1/8 = 0.125 of the I/O range of cont + seq zones.
-	# Set zone_reset_threshold as 0.1. The threshold size is less than
-	# 0.125, then, reset count zero is expected.
-	# On the other hand, half of the I/O range is covered by conv zones.
-	# If fio would count the conv zones for zone_reset_threshold, the ratio
-	# were more than 0.5 and would trigger zone resets.
+	# Use 16 zones as the IO range: 8 conv zones and 8 seq zones. Set
+	# zone_reset_threshold ratio so that zone reset to happen when single
+	# seq zone was filled. Write to the first 8 conv zones in the IO range.
+	# This write should not trigger zone reset since they are out of seq
+	# zones for zone_reset_threshold accounting. Then reset count zero is
+	# expected. If fio would count the conv zones for zone_reset_threshold,
+	# 2 conv zones write would exceed the zone_reset_threshold ratio and
+	# would trigger zone resets.
 
 	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
 	io_size=$((zone_size * 16 / 8))
+	ratio=$(echo "scale=7; $zone_size / $((nr_seq_zones * zone_size))" | bc)
 	run_fio --name=job --filename=$dev --rw=randwrite --bs=$((zone_size/16))\
 		--size=$((zone_size * 16)) --softrandommap=1 \
 		--io_size=$((io_size)) "$(ioengine "psync")" --offset=$off \
 		--zonemode=zbd --direct=1 --zonesize=${zone_size} \
-		--zone_reset_threshold=.1 --zone_reset_frequency=1.0 \
+		--zone_reset_threshold="${ratio}" --zone_reset_frequency=1.0 \
 		${job_var_opts[@]} --debug=zbd \
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 
@@ -1281,18 +1300,22 @@ test58() {
 
 # Test zone_reset_threshold with verify.
 test59() {
-	local off bs loops=2 size=$((zone_size)) w
+	local off bs loops=2 size=$((zone_size)) w capacity ratio
 	local -a workloads=(write randwrite rw randrw)
 
+	require_command bc || return $SKIP_TESTCASE
+
 	prep_write
 	off=$((first_sequential_zone_sector * 512))
+	capacity=$(total_zone_capacity 1 $off "$dev")
+	ratio=$(echo "scale=7; $capacity / 4 / $((nr_seq_zones * zone_size))" | bc)
 
 	bs=$(min $((256*1024)) "$zone_size")
 	for w in "${workloads[@]}"; do
 		run_fio_on_seq "$(ioengine "psync")" --rw=${w} --bs="$bs" \
 			       --size=$size --loops=$loops --do_verify=1 \
-			       --verify=md5 --zone_reset_frequency=.9 \
-			       --zone_reset_threshold=.1 \
+			       --verify=md5 --zone_reset_frequency=1 \
+			       --zone_reset_threshold="${ratio}" \
 			       >> "${logfile}.${test_number}" 2>&1 || return $?
 	done
 }
@@ -1450,6 +1473,7 @@ fi
 echo -n "First sequential zone starts at sector $first_sequential_zone_sector;"
 echo " zone size: $((zone_size >> 20)) MB"
 
+nr_seq_zones=$(((disk_size - first_sequential_zone_sector * 512) / zone_size))
 zone_cap_bs=$(zone_cap_bs "$dev" "$zone_size")
 
 if [ "${#tests[@]}" = 0 ]; then
-- 
2.38.1

