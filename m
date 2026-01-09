Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECB73168E5
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926178; cv=none; b=OP4sGfZVTfk+MTAnZ3KXtAHkat9uq2v/1Zhg+wnE9eqaEtJm+7bjg2hdIm9YqxTtjU0tNUKNsTeK2/xumc7sHBPfEd039hKFlKrnLuZ/VQvatGu2/rZFAGAf9SwrAK60UaET3Pb81lHzO07s/Jzp3bPsnUmkGJ9rVFi/DqwJZEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926178; c=relaxed/simple;
	bh=YBOBb3YRBDCOGcV47kxXa6zqMvU26q8AeZZNF2+bP4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWS9KlmFHO0seb0jl2YrapgGJfpB3p1I7tVm4WuF2s6W8YjtL5fzqs1vdCNPsP1qnbbeJt+koxvyBKemGn+iscJrWsCOH+cl+yI39vJiBkxeOMjNFWQHbuDXb+HUt15JfBkvN5kxx6C/fuRgQkhw9ZFmi2A2i5JgGiK+10mztMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AsSU2CcO; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AsSU2CcO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926175; x=1799462175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YBOBb3YRBDCOGcV47kxXa6zqMvU26q8AeZZNF2+bP4o=;
  b=AsSU2CcOlEayorb+Wd6DUwj77FL7BskhW+Yd9Zr3Q5ex4kTMS+80K4gl
   9hzqWKEo0iDTPpk1exEQ8bef6zBAKIpa5krJNC2oT1S2waDIVXRVmm2EX
   wMUFT5iuhyyohVe6vdDmwxnaDIysk0o2ROrZH6Ru9aVfqaceq2jvQuiB9
   etaZUOW5ub0cN62WKpDW9OH3FYjHpO/aKgTCSJccCYeSUKw3HvcfSUYnX
   BovfiK4C1v3KjYliC96QIfzXqNHSXfxObBBvatUicC4HQ9XRhSGN4X7Oe
   U2vabROg/qBwCy0VDuzpbDKGox/ZqwoELlxg/PnxPVPkJwSNDUoFOO8Dy
   g==;
X-CSE-ConnectionGUID: k/2+jvh+SoihFga6i+GfPQ==
X-CSE-MsgGUID: BlquX2D7QpqMWmqCM9bNOg==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774587"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:15 +0800
IronPort-SDR: 696069a0_UMT6jlrLLyTW90RaZVT8fuSlf2BJxu9K8sGt7824XjyRBAu
 cZNEXB2Hja23NXmZ3PB1Wb5TwkZ+112koSBEwNQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:17 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:16 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 11/12] t/zbd: avoid test case 33 failure due to zone end remainder
Date: Fri,  9 Jan 2026 11:36:02 +0900
Message-ID: <20260109023603.2848421-12-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The recent change introduced the writes to small remainder areas at zone
ends. This changed the number of writes of the test case 33, and made
the test case fail. To avoid the failure, modify the test condition of
the test case.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e7a711b9..c3ccb559 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -977,7 +977,7 @@ test33() {
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((io_size / bs * bs)) || return $?
+    check_written $((io_size)) || return $?
 }
 
 # Test repeated async write job with verify using two unaligned block sizes.
-- 
2.49.0

