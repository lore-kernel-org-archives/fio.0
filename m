Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28D9373BE5
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 01:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501531; cv=none; b=XFWGjtfqZZAr4XdCNq2G5OfTzCoQO8hs/GAaAcd0zFTeJ3HuS95FXCZeHn3lyOjdqxzA/ErdYTNPVhTfquzuyFRTla/2KeqCujDEHOTCTSrwUjN1F5NP2ETwnJd23HDwtYYJ67RNhadyIs072sASqhkVkri8KryVAm9YKLKko0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501531; c=relaxed/simple;
	bh=LrG98Z9enltYqKZCy7obqRKrw6e7abQCeXtZLyKPz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj1XevxY3mH6q8Oju29FJHqa8vreCpiUHbs9POf7KEtPt0CnshhP8ROUPcwC6H5Bd2JQR4xZJMRXiTdUAvgKp8c9DfHUFWgoZoCXpiBh8gYZZovWxIKRkOPE9O3UoQEhWS6ZPqDclG9gXcofKdQ9LKl8a2nbyYRTSxSpABdFCdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IrkZNDQR; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IrkZNDQR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772501529; x=1804037529;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LrG98Z9enltYqKZCy7obqRKrw6e7abQCeXtZLyKPz38=;
  b=IrkZNDQRUyDKK49ZIdItuMV93MfGRoJZD24wqgLbeoNPC3e+qVPK+pr2
   sZ/Y54b0nsLcUleBHRZ7wdJpZy1bP2GFRCSRbpRdi5ZcsE0VI3DbKN3xc
   b8SEeTPyPf3Y7llPCWMKizr+dc8a1GYJr/nFweeACJyYFtoDVq33ksvV6
   w80g3gQCEZuwoPVwDE33zRzqRt2pwrCuZ9CLLiuDLqMBRSoMbtVq93i26
   Z+BvUV7A0Kr5BLIRlontslnhhdIlvCdaoxUWAPY6U8GgeFaCaJDIDV90S
   LgIdsGlKwfi6k/aDeOnJxuXw1uGy0ukRSFUWcuJW33/Ox9DvO9e4NLCcu
   w==;
X-CSE-ConnectionGUID: 1u60S42jRdeth9jorEQzuw==
X-CSE-MsgGUID: JeeVq27BSt2PZr9ExRqijA==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140813526"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2026 09:32:09 +0800
IronPort-SDR: 69a63a19_lRTKuQKws2P6a3+wGrkU7aX+1z2qSDogkvdldhuMZisU631
 MHNprDeg1ex5hM8w/Vg0pdcnh34bkzm0N5yh0rA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 17:32:09 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2026 17:32:08 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 6/8] t/zbd: avoid test case 14 failure with write_zone_remainder option
Date: Tue,  3 Mar 2026 10:31:57 +0900
Message-ID: <20260303013159.3543787-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
References: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When -m option is provided for t/zbd/test-zbd-support, the option
write_zone_remainder is specified to fio. In this case, the test case
14 fails because the random map feature is disabled and then random
writes for conventional zones may have overlap. To avoid the failure,
modify the test case to count the number of overlaps.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 01fb4dd3..e5a5f75b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -665,7 +665,7 @@ test13() {
 
 # Random write to conventional zones.
 test14() {
-    local off size
+    local off size nr_overlaps
 
     if ! result=($(first_online_zone "$dev")); then
 	echo "Failed to determine first online zone"
@@ -678,10 +678,11 @@ test14() {
 
     run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
-		    --verify=md5 --offset=$off --size=$size\
+		    --verify=md5 --offset=$off --size=$size --debug=io \
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
+    nr_overlaps=$(grep "iolog: overlap" --count "${logfile}.${test_number}")
     check_written $((size)) || return $?
-    check_read $((size)) || return $?
+    check_read $((size - nr_overlaps * 16 * 1024)) || return $?
 }
 
 # Sequential read on a mix of empty and full zones.
-- 
2.49.0

