Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7307E1A5B8B
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 06:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744612050; cv=none; b=onnDVQdJDydWy/ymcvDP7Rtg1TsnybNQSnDVBEy6EP2qI93KnjJ1WNxums8PdqY8b6gDp1Mrzq59voBisA5DBjJTSMTw1/fZyuUh4v+Ykwk0BN+IdQ2c3P2UNizK3FY1/cXLRabJHxiVE81izh1DSKrvhy0mdMJZSKfZ7TMAWGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744612050; c=relaxed/simple;
	bh=MOMauB9ZIay41OabnEOMtfbjEFaPPrvEYCW3OnU4FX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdiNAmgVEbJV06nEO0smEt7cxxrsQznLHjHGxPxMOSHmp85upGsMwYeIvKggxvh/HFfEjLbeAvuLe3uo0UYOiC5IuIY3L7ihwcoC5GFt2s7xzzNnhK8MpVIG4kPJHZFzwRwGEFvEhUs88PrXXSSz9JQ/nTK4q5w9Xs3w5NWcWKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hzAoFTqQ; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hzAoFTqQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744612048; x=1776148048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MOMauB9ZIay41OabnEOMtfbjEFaPPrvEYCW3OnU4FX8=;
  b=hzAoFTqQFWgDPbMjP83oAPbk34VMxVOTNf2BWVQsM1NNBxf+NPf2tITy
   OK6MOLTXobM7ZvrBYKbIaVHVaGr2Qh0jgNNa9ShIsSlRpJjJt87mbvczU
   zMWiXatI4BJrXdDZxMXGlgqkJXse6ndq2jwHyt6aCSPNOKa+4kcvKA6RJ
   0Jf1mlGCy3uH+V0DF+8M2He667szZMayY+wpRakzHfxWDO09ndkuewI3+
   44h1yUZ+Gd9uVGCaLeuESYjo0rpFZN7IAjEyJCDCFwfp39UiPBpQMuwaa
   vmGL3Htu6m6K+JeuY6GVzlaulB3EVld/vtWO97P7gXWGl+0ZZW2zG8LxL
   Q==;
X-CSE-ConnectionGUID: VbIW6djkTDaA4mSwbtYNPQ==
X-CSE-MsgGUID: OzgILZT1RKitIldk7LxJUg==
X-IronPort-AV: E=Sophos;i="6.15,211,1739808000"; 
   d="scan'208";a="78068695"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2025 14:27:27 +0800
IronPort-SDR: 67fc9cc5_6OlPOxkprE2o3LWppY21Bl/wWszLAO4cgkqw/h7nfsrDEGe
 3mxx33MTq8r0eePdNQ79hsbhEyzoQOT3oHzBRNA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2025 22:27:34 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Apr 2025 23:27:26 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 4/4] t/zbd: add test for the case all write zones have small remainder
Date: Mon, 14 Apr 2025 15:27:21 +0900
Message-ID: <20250414062721.87641-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
References: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous commit fixed the unexpected write stop when all write
target zones have small remainder sectors to write. Add a test case to
confirm the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 468fce70..0278ac17 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -346,6 +346,14 @@ require_max_active_zones() {
 	return 0
 }
 
+require_no_max_active_zones() {
+	if ((max_active_zones > 0)); then
+		SKIP_REASON="$dev has max_active_zones limit"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused for block devices.
 test1() {
     require_block_dev || return $SKIP_TESTCASE
@@ -1637,6 +1645,46 @@ test70() {
 		       >> "${logfile}.${test_number}" 2>&1
 }
 
+# Test random write does not end early when the zones as many as max_open_zones
+# have remainder smaller than block size.
+test71() {
+	local off size capacity zone_fill_size i
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_seq_zones 8 || return "$SKIP_TESTCASE"
+	require_no_max_active_zones || return "$SKIP_TESTCASE"
+
+	reset_zone "${dev}" -1
+
+	# Fill data to every other zone in the test target 8 zones. This leaves
+	# 4 zones in the implicit open condition. Leave 12kb remainder in the
+	# 4 zones.
+	off=$((first_sequential_zone_sector * 512))
+	size=$min_seq_write_size
+	capacity=$(total_zone_capacity 1 "$off" "$dev")
+	zone_fill_size=$((capacity - 3 * 4096))
+	run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off" \
+			--bs=4k --zonemode=strided \
+			--zonesize="$zone_fill_size" \
+			--zonerange=$((zone_size * 2)) \
+			--io_size=$((zone_fill_size * 4)) \
+			>> "${logfile}.${test_number}" 2>&1 || return $?
+	# Close the 4 zones to not fail the next fio command with the
+	# --max_open_zones=1 option
+	for ((i = 0; i < 4; i++)); do
+		close_zone "$dev" $(((off + zone_size * 2 * i) / 512)) || return $?
+	done
+
+	# Run random write with 8kb block size
+	run_one_fio_job "$(ioengine "psync")" --rw=randwrite --offset="$off" \
+			--bs=$((4096 * 2)) --zonemode=zbd \
+			--zonesize="$zone_size" --size=$((zone_size * 8)) \
+			--max_open_zones=1 --debug=zbd \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+
+	check_written $((zone_size * 8)) || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.49.0

