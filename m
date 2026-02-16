Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC4A22D792
	for <fio@vger.kernel.org>; Mon, 16 Feb 2026 07:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771228787; cv=none; b=AHXDhtJz+kPeQdcF3jrZx5RpQjS84z/R0HLP88En9AiRMfK8dM+Mh+/NLTERb6r77irryJBlSjpE4ykzPQZTecHMOuKecV7wZ9gQYu6Z2esuM0aCcSx6ILf+2R5crGQx80Az3g9H25Yp3TrtkcbNrfOH00Y0+X01wsg+0iny0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771228787; c=relaxed/simple;
	bh=LrG98Z9enltYqKZCy7obqRKrw6e7abQCeXtZLyKPz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9dutGU9u2yMOj/UZsOK8ZeBD4VDltigjxZmo3YnSZ0Ii15P0KQf7ImkKzkCJhMr8oXoCLTHAH/to7VUDpghNj7DPP7TOEnWFoz0Qj614f+7XRQSIuxqPYb23qvBAXy45fvpAczL/AKu/BUr5AtCNge4j4a3Xl5oN9kn0Qo+AMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=A0hDMBbb; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="A0hDMBbb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771228786; x=1802764786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LrG98Z9enltYqKZCy7obqRKrw6e7abQCeXtZLyKPz38=;
  b=A0hDMBbbpZ+tDFY0xE4B0WE0pqxhYdJjnyzIrKBvwPwaFEXn5pqFJOVV
   KHvxo0ORTx3Fu28ONUcCTh2Aw6xGsaHcxqVOIGMQVWcgrhiSx3yPqyiyY
   EB4B2hpOkzRgMb+psqV7wmPAPkwsGGjf2OJtRFnrASTWu+/TtUm7KJBZf
   kXpzvBQrVAuDUkZqV6F0me/7B4McJTHyUxLc8vXfb03HguBpV92Euy9sO
   RZXjF1J+GJb6vsD9dCNJqsS5s1oRlPrpo+T3GmJRGiQdL5ft0ZEAcNeic
   WHl7d1/nHga+CY0fKq53iWqKb8foUnks/gqMRd9lGcnJh6Va2XBmcN/Eg
   w==;
X-CSE-ConnectionGUID: /wk99GgcRZCkbtMQMHGcjg==
X-CSE-MsgGUID: HIepY1gySVaAeq0q+B1BOQ==
X-IronPort-AV: E=Sophos;i="6.21,293,1763395200"; 
   d="scan'208";a="140812887"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2026 15:59:45 +0800
IronPort-SDR: 6992ce72_YAoBholpA4UDeg4Qtqd00+A5FmWHZy0ZagP19/25WgFwtXq
 AyRb7ey8dwXiYCTXwAkDUWQJnu/gB7p3BJaOqRg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2026 23:59:46 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Feb 2026 23:59:46 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 6/8] t/zbd: avoid test case 14 failure with write_zone_remainder option
Date: Mon, 16 Feb 2026 16:59:34 +0900
Message-ID: <20260216075936.3318729-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
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

