Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DD9175A93
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418378; cv=none; b=oZPSYY3Q1HBexlVJgHGw+zX+XP+Tz4eNb/4pDcsJdYmFjT0nXRlgODay6bwggti9o25qE1FTKOC5JOMYUSevEswnKPYAUg8b189YVJAzxfGo+VGZQXc52NYNOebtHbEER9yeahtpUSkYDdbqLQXgIcQV4UhBJo6w0mRPBGeKjoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418378; c=relaxed/simple;
	bh=LrG98Z9enltYqKZCy7obqRKrw6e7abQCeXtZLyKPz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+3styFfrUv4KuO7By0SJh6lzdek7FwkF0e8T9CTW5ouTaCDCy+v7sAcZ/MRI+5bcb/F2ZU5e6cYTAM9RJfNB7DiVTUPYD1ul1+3qodnpKdSaUMGivupZzovm7npr4GG2zr8YuHjfoQl0VXd5DEQZiwX95pnIwg4dVZx4AuDhDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gdp9EI6I; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gdp9EI6I"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772418377; x=1803954377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LrG98Z9enltYqKZCy7obqRKrw6e7abQCeXtZLyKPz38=;
  b=gdp9EI6IfOn6CVuBgLzrpFfnUMIaDypv4S17TYG8rzAEXthfUMdogUpL
   ZPhqNBvm5gVlGLkYI/7d7Zf5FAWN283oTA6OYTcbCzIOYKSey7S+PkaaP
   zfD/R4RCFS+T8uukRUhO2jzXdnU8u0o6HS4qVx70wGs+t8jtvBONfX8Tl
   RWLoEPIlLUEXUblZNsb0JhkIxyskgc2pSEasENccindB1Zeo4chBDfhU4
   3UsUbcWt4JaoTPUYicUlor7QMtFczw+0m/VqT1erWgyUYPE69SKDlHe2M
   /O9pE/5CHUa8NKK+tiCvBArDjzFensteTsn8fbYDvOwviMppFqZIF0qDQ
   A==;
X-CSE-ConnectionGUID: i1bxmix4RgWBfbmlo7cpWw==
X-CSE-MsgGUID: 3f5ZSrx9TXmKHGeWFaRKeQ==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="141307955"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2026 10:26:17 +0800
IronPort-SDR: 69a4f549_ZDXnLqQss2p6XCycuIcPfZnxKZlOQLiNjFnSTcBWOyR4VQS
 AfQgPZ4FpQNWD7+LF5Xh//8rVuvRm9KRoUy8DbQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 18:26:17 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 18:26:17 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 6/8] t/zbd: avoid test case 14 failure with write_zone_remainder option
Date: Mon,  2 Mar 2026 11:26:07 +0900
Message-ID: <20260302022609.3526823-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
References: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
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

