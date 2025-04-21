Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50695264FB1
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239121; cv=none; b=lZOoCgnC1y9RHGluH3g/E2BfwpZnxkejguE84aEOWahlFmB8MN1A+78q1lLyMleN8b8uBD4ZayyTR/PFwP2Rq+BvRSU7gPn2H750FP5piOj4ulmNqkAhI1I359Reyn4A3K7se70TF2/2ywoz86vURW3T2tUE/9Jo18x3BGDWNj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239121; c=relaxed/simple;
	bh=rMsmlO83DE6xX8jVjAYB64cKEm6zUcIQ280ePOppbnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3aKbJ4c8aPXPao8GTDFlDZ0GCXQNCLOr9BwBppr0f500uxbqswIJdgl8fbt3wNhrleFTQNAmOViGXD34VcyVWWXbnh9zukx+V/RGOP/bb1dhE+h7HlwZqSJUywmB7zsF7zOpyUbg97x1GfI3dW08wjyTaG9PAJYprMEh0eHHj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jWr0I2iF; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jWr0I2iF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239120; x=1776775120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rMsmlO83DE6xX8jVjAYB64cKEm6zUcIQ280ePOppbnc=;
  b=jWr0I2iFgK/soFRkBSK9MetIg0KhlcLynkeo2B5g1pvGAQAAZeELezNb
   70t89sCOyuB/LPjnxJT5cW0/A1bX5iLBXAnouabsQmEQbLtVQQKoSBlo4
   Z2T50bMBMl67PQ0iOTliuPHhBbLM2F4g01hdOwVAf0kT0hqoPwVuVgMsM
   uULT8zLQb9JFfUsWiZpt+U8bih09P12lkqBkYfT2zCssdRA84j58TrkDP
   vF9LHUtHDWdzNl2IRzqthj9DhPPRLjkwsSeTSZve/FLbyyc90t2t1WYga
   cGgL6mc9hGex26jrc+aLz3w1UUyQT91hxDqGPU03xp++mxSEnkb3XFvdJ
   w==;
X-CSE-ConnectionGUID: 6VS9jVtBTJm3ZMM2oGT3Nw==
X-CSE-MsgGUID: w5hLt/5XT/yIK35bVyo/Vg==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027525"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:36 +0800
IronPort-SDR: 68062e36_HGEFY6Eil/kBaZtgw6K3jr1FCMo6E4haJClcx4KeugAS2GD
 aH7gONUohP+VqXb13wpoJsMkcLSnjgD11Kekfqw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:30 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:35 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 6/8] t/zbd: set badblocks related parameters in run-tests-against-nullb
Date: Mon, 21 Apr 2025 21:38:26 +0900
Message-ID: <20250421123828.82712-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a preparation to add test cases which check that the
continue_on_error option and the recover_zbd_write_error option work
when bad blocks cause IO errors, set additional null_blk parameters
badblocks_once and badblocks_partial_io. These parameters were added to
Linux kernel recently and allows more realistic scenario of write
failures on zoned block devices. The former parameter makes the
specified badblocks recover after the first write, and the latter
parameter leaves partially written data on the device.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/run-tests-against-nullb | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index 97d29966..f1cba355 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -91,6 +91,9 @@ configure_nullb()
 		fi
 	fi
 
+	[[ -w badblocks_once ]] && echo 1 > badblocks_once
+	[[ -w badblocks_partial_io ]] && echo 1 > badblocks_partial_io
+
 	echo 1 > power || return $?
 	return 0
 }
-- 
2.49.0

