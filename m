Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDEF22D792
	for <fio@vger.kernel.org>; Mon, 16 Feb 2026 07:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771228789; cv=none; b=fxjQQEMG83JQyFeeo9mbyPWFSWzWmzuTY5dHsz0Ll5NK6Ks19cOyUw7LvJEePHRet12vIjvubE4j2ocz5nBke/rwTEzgqmUk/Lskkmgn48h7RcvLa4xPn4YQ79m8IoS8eLBtGiVaXUF63YzyP2u9AnkA7rq9lufAK6L43/SgJqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771228789; c=relaxed/simple;
	bh=kOZZDewUxwHBYYNb81tJk+KR8VWXSSfx1OhtNqVdz8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vc7Iui23j53XkaDz4mL1D/iZq5UKVxUA+yyAsF2385RmeNqOSwkiLyZkoJ4cu6FhV0j9a+UEeF9m2TcMEI99zgOez8mWOvty3pc6FTt/7aRoaPc27oz9KLvVmAW/+54uHTUbZRr+lzDUCJl4P3bygltxuG6U734pNvBskt7R+98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UDtBPaEi; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UDtBPaEi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771228788; x=1802764788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOZZDewUxwHBYYNb81tJk+KR8VWXSSfx1OhtNqVdz8w=;
  b=UDtBPaEiKuwowVvVygOtCFI5ZaoZz6SxIsmyVCl2/GguvkNBLrETxvlv
   gir6ja+0XWOB1xXqtv3Ouk5HDGjBIo/NnsQ96YzB4iGTv7fXPIrpdHH+F
   NJ/wEIh10dmv+AO9OxORxqBeUYzYNmXlydgfbSD9uiKSdRvTVyWoIAAJt
   ce1BLayY2wmLwatAOtPk7YduaQgRZ4aeULqIXC+i8UEYI7Nc/lKJ2Hdaj
   GKuRIk+zjGRfq8X+Pt3GlJ85AK/whgSU9tRLE5hcBja4J/lIB921aRX2E
   JD9NoyU0dckH2bbXNDqp/byYJlxqB5Sco0qk8PQtNs6GwStDO3KKuLDLf
   Q==;
X-CSE-ConnectionGUID: HA3CTQ1VSU+J3SvEUEOy2g==
X-CSE-MsgGUID: 0MAoDg9ySBO6C83H0fqj0g==
X-IronPort-AV: E=Sophos;i="6.21,293,1763395200"; 
   d="scan'208";a="140812893"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2026 15:59:48 +0800
IronPort-SDR: 6992ce74_YG8tfCoDfd6etqPdJoQbsxUM19xQ5EftitwSqz8WKc9tLhf
 ffW4ACnuQ6g7wOTQElQoCxRluhWnIST5MHxvldA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2026 23:59:49 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Feb 2026 23:59:48 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 8/8] t/zbd: avoid test case 71 failure with write_zone_remainder option
Date: Mon, 16 Feb 2026 16:59:36 +0900
Message-ID: <20260216075936.3318729-9-shinichiro.kawasaki@wdc.com>
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

