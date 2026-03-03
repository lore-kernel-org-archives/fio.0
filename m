Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8576A220698
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 01:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501533; cv=none; b=MWQXstD6MIRe5IpCOFqFsu1SBPMIiTpOnXq11Q7AW8eEVLurHFRo5X9EBO24QpzQJfbWGZQtULGHAnWAtAgLVWhn6wpvvbx22GzZqY6FrimQaRVESGt1OXSy9ydu3AoWD11mySIcmO/ADZemDmj24ToWYEjEpKtf7yymSmEjFR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501533; c=relaxed/simple;
	bh=be3Ur8EjE7IlbBoyqqEnXlFVZjlh58miCkBuk4j+95E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh1h2xb798teWFWZL0qUQ7SxAp3ZUISRTp2/lKgy9Z/2oO8G1nZsezJjKhN2wCHH/gEfvIGISCoDKivuL4gEJ2IvZpfc22o3ZhEgTyn4GxRpO9vB8V3HOKYXeHJcBmtNc66tUE0IYINra3aomR5evIOqNWpxva233RR52lFXTUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NnnrAI7G; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NnnrAI7G"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772501532; x=1804037532;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=be3Ur8EjE7IlbBoyqqEnXlFVZjlh58miCkBuk4j+95E=;
  b=NnnrAI7GrAKMweRrTsD6U5FeGvmaAX69XtDOhxYvKEsJK1TIxL4SjSeh
   pB9qvamGkL/KeQulGSclpibHxbRP4v9h9lJGF0nYhNpQ6n1vvZFBouV7W
   tauEIFsdJWUaMpduB+OXvp1cwLw0/kYvCc4XeEN2dZ0Ye8xynYtkGjCu8
   G47LN+YZY1vc0I8F/bCWFOVMIBOiZ8d0ld23RcIJ//BcX6UtmtBMNAqPK
   e8FG2iKwe+juRBU17K460axy8iLrFOWipt0WwaNAS9S/yw1PJU7cxrzCk
   fjntSffEArdNKuARaqwUqPsDBt6o8lF8mC+zzoWd35QnDGdUc7t5lYK7v
   A==;
X-CSE-ConnectionGUID: Z3q92aHyRvagY6aTs/XLug==
X-CSE-MsgGUID: I/e7t4DMRVSQjKDBZYPgmg==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140813534"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2026 09:32:11 +0800
IronPort-SDR: 69a63a1b_PmATfnzSurSDq8iKVas9CIQRnihCb9Eksvl55iBrNUNvbmM
 7bQmT7siL0RTuMmZnOpyzjklKpdb2r5XvPXnFeA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 17:32:11 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2026 17:32:11 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 8/8] t/zbd: avoid test case 71 failure with write_zone_remainder option
Date: Tue,  3 Mar 2026 10:31:59 +0900
Message-ID: <20260303013159.3543787-9-shinichiro.kawasaki@wdc.com>
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
71 fails because fio does writes to small remainder areas at zone ends
and it changed the number of writes. To avoid the failure, modify the
test condition of the test case.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 10fd6690..2c57de95 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1768,7 +1768,8 @@ test71() {
 			--max_open_zones=1 --debug=zbd \
 		       >> "${logfile}.${test_number}" 2>&1 || return $?
 
-	check_written $((zone_size * 8)) || return $?
+	check_written $((zone_size * 8)) ||
+		check_written $((zone_size * 8 + 4096)) || return $?
 }
 
 set_nullb_badblocks() {
-- 
2.49.0

