Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025F61AC44D
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418381; cv=none; b=D7ND7tLHeKEYoSbgnytdZB8SLEByxIkQZ9Yol/AE2EaedkPL0VaE9kYuE2bqVZikm/ozU+PTCtErsosl0CHpAzQ1+GTl++RxUqMkMm1So+SHEnKzy2tG5GwqNzyqr38uAxeAq1Bpe+/gxW36XWh7UOLm8qKwB9HrYO65N6aimv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418381; c=relaxed/simple;
	bh=kOZZDewUxwHBYYNb81tJk+KR8VWXSSfx1OhtNqVdz8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzAindhOdMSPQnwqeXFRmIAzX/kJTlnc1nQUvSA6JJBvmp1MRO6puaNazXEKafWdaWkioeowiVOG8NSz11+4jflfLvlFDwsYm5/K/OZ6otcuORYCqVvUiNJAC+Dpujo48cp7y/ufWHXxCGzoZiMRJAg+2C/c2IB2/7E8P4ezf0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c0me3cr3; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c0me3cr3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772418380; x=1803954380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOZZDewUxwHBYYNb81tJk+KR8VWXSSfx1OhtNqVdz8w=;
  b=c0me3cr3Wxhs2jTQnIZbLBvIB7fpQuFGY80IOAtbaJCtqZrRyGsrpVwv
   pnotKDMHwjctbIJ/OmfUVKJK0ukQSHwbGJkr+S6QNibel7uH72xKIUnPU
   jO8S7gfx/eI6fSYIKq/ZYZGypkwQKYkiClfR98SgS35Crodwf2kG959Up
   h7ZuQW/FjBbGfuN1ECmyOARCfEaxpHeoRTSGuWw1LRFEPXi4dZfOaLvtC
   3dKGaskw3eM7zpnagAHrvb3H/5R6X39U6Ar4eKg+LYRREJni7lwQOf740
   aqYt0hN1CmnS8u/P0IJQ8YSBE3b765EZat8dU9kfc7fEc4PO3l2cVwlHi
   g==;
X-CSE-ConnectionGUID: 9N2InCrTSEOBCkUct5oMdg==
X-CSE-MsgGUID: X9Y9tTNVTHSJs5WMLTFJdA==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="141307964"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2026 10:26:19 +0800
IronPort-SDR: 69a4f54b_fYc5NPlUjPT6Smm8I9esPgNh/9UcuW0HzyMv/xPXKZEeQWd
 aG3yMNfJsHfTGjD2UC5T2SQ+v4Rr78dOvy7Gm4A==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 18:26:19 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 18:26:19 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 8/8] t/zbd: avoid test case 71 failure with write_zone_remainder option
Date: Mon,  2 Mar 2026 11:26:09 +0900
Message-ID: <20260302022609.3526823-9-shinichiro.kawasaki@wdc.com>
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
71 fails because fio does writes to small remainder areas at zone ends
and it changed the number of writes. To avoid the failure, modify the
test condition of the test case.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 10fd6690..466a8d4d 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1768,7 +1768,8 @@ test71() {
 			--max_open_zones=1 --debug=zbd \
 		       >> "${logfile}.${test_number}" 2>&1 || return $?
 
-	check_written $((zone_size * 8)) || return $?
+	check_written $((zone_size * 8)) ||
+		check_written $((zone_size *8 + 4096)) || return $?
 }
 
 set_nullb_badblocks() {
-- 
2.49.0

