Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088BE315785
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926179; cv=none; b=uXC7PfxD4ScMz7kB1rt85QSSeucw1nqbRhAScYGPMueyaVNADIMgjXZw9+w3aSXAr7GKVs52Y+piojFoBuBTqlljGfvS2E2uMdG9MXcyXagfnT5Dg1ErnbhbeEzs0GaSeaSPbKqHlnr/jFQrpPTTetfrSBED25XZuknAI/fMno4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926179; c=relaxed/simple;
	bh=GaSn7F0mKnGI4zOVpBeBVs4ZPPP6PerIzMAMCRGwuVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G13WntfOq3/Ns0XlWNilqtixbEfMicxhkPcNlwt2fEagdsYpiqr1Wt9rfrNuTF9Qya6MJ2PXpDkAh5pJZlqmr5ZeXertFFG5qaVYGForV/Nr05phPQG+YI7wVBkLAEB0y9L3rSH1ZmMuCfANZpGloaErNh3c6eH2G4M9nzJJZY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=C3/Yuktg; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="C3/Yuktg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926176; x=1799462176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GaSn7F0mKnGI4zOVpBeBVs4ZPPP6PerIzMAMCRGwuVg=;
  b=C3/Yuktg9DtqWBgvhAGpdg7UOJVIYAThLyvxb6jQDrBQGVumIY3G0CRs
   2tedx5lqh3kNT/YQcl73r88N5i1a4dTr99w6+tpm/hjuQ77MAydXZQPSe
   6UIJRGpWHiuwT77hDJ6caH0nxRtGbecPbVVywxhC5nxXqA73X+Zo3bFli
   IAXlu5PcnifpUS+vqPd3r4reJWhVeO97x4ZYdfGJXrGuR+7gTMb3YX8c0
   PmdzCBarwUnfoTota9qeqnJbhQFiU5SBlZNcUdxiV2JlsmwK6kK99tJAj
   2s9vDyXfC6gCojjhDuSKlzdbZfJGmWR/9n0zO0ReftewQ2r+C/3J7AFKb
   g==;
X-CSE-ConnectionGUID: G45ZVamCQCWRqhKok88JpA==
X-CSE-MsgGUID: JMDjSqu+RCOpDQuVbFnnqQ==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774591"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:16 +0800
IronPort-SDR: 696069a1_ux1PGeRdBfkKquB0WazG/AYyWH+IDZmK7Ezbeey340Sf4Fx
 tn9MjrjS5LPB7G+JnNS/Z+axjG5QuxN8qM5NFiw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:18 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:17 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 12/12] t/zbd: avoid test case 71 failure due to zone end remainder
Date: Fri,  9 Jan 2026 11:36:03 +0900
Message-ID: <20260109023603.2848421-13-shinichiro.kawasaki@wdc.com>
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
ends. This changed the number of writes of the test case 71, and made
the test case fail. To avoid the failure, modify the test condition
of the test case.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c3ccb559..ae731d5a 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1737,7 +1737,8 @@ test71() {
 			--max_open_zones=1 --debug=zbd \
 		       >> "${logfile}.${test_number}" 2>&1 || return $?
 
-	check_written $((zone_size * 8)) || return $?
+	check_written $((zone_size * 8)) ||
+		check_written $((zone_size *8 + 4096)) || return $?
 }
 
 set_nullb_badblocks() {
-- 
2.49.0

