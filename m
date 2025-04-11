Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3980320C005
	for <fio@vger.kernel.org>; Fri, 11 Apr 2025 11:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369946; cv=none; b=DC9iZgaJ2do3d0hwawO4OB68rMY/Yak9Gk+d/fyU2s+l9h8TMIToqzGPZH9NgOm5dp1IZkK6GotYu8ahIpE3413CSHG5lZHKY7YYIDa0Lr5cfH0jUFLUy9j2lbApPAuYOrsXCUODN78kac2YkI+mqG+z7POLqgM9qZIL7w0QbxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369946; c=relaxed/simple;
	bh=MOMauB9ZIay41OabnEOMtfbjEFaPPrvEYCW3OnU4FX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbkbUU3EfrM0bdcmcijy0uW6eA/mcNeA7iQWU0Srq2deDKJMWksJP+7Z2FNR0zqe7W8ESIhzRxKtR7tcjLTFL/YY0PkWmlYzyMBG8344ksINggmX9gAXBPPf8RlsOYNHFFN17Qu8zHZd9L6ph2F56Im2KgZL2KfkQVKfPlObl+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jOl90cX1; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jOl90cX1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744369945; x=1775905945;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MOMauB9ZIay41OabnEOMtfbjEFaPPrvEYCW3OnU4FX8=;
  b=jOl90cX1POESU1kuPKRgy6HEwLCthZlLKoG8SUueLNuNMVlCOOAcUyxL
   jRTBWc6zAw/CpVOEIk5QZ7IHba75fwjnOefIi9z5aQM++rXV0mXONAipo
   XoEI7xYu1yWNunXdNLhN0BR08rzUk7lxu9CGdz4+1UF2Icf/SguzgD6pq
   2O1zNEbyoOqodKD8WjPSWOBLrXhYXiQjrX+1gdUOE4LqxsksCLWNujy0T
   pXZjBuRUMHN29GHRJNpHFeVs7BiPCtzkEB3eOXbr9PxeNlD6PXy5gI1qz
   IdIFw6ec4BSX8Qm4NT3VUsGO4VhOe2eaMBq8MB/6MADijSix3COaKL94G
   A==;
X-CSE-ConnectionGUID: +JfMN3rZR4CUItJ6/Q6hLQ==
X-CSE-MsgGUID: pgATd1qTRu2o7V1+7AF4ZA==
X-IronPort-AV: E=Sophos;i="6.15,205,1739808000"; 
   d="scan'208";a="81898588"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2025 19:12:25 +0800
IronPort-SDR: 67f8eb13_20zgJv+ieU+El6isloxSFe0/fG21ZwQ8ZogjtkYvdGinojh
 7d7veGEtwbipAxMBy4AFyjR5JXXO8vL5aECihmQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Apr 2025 03:12:35 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Apr 2025 04:12:24 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/4] t/zbd: add test for the case all write zones have small remainder
Date: Fri, 11 Apr 2025 20:12:19 +0900
Message-ID: <20250411111219.57424-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
References: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
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

