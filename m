Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADFD285C9F
	for <fio@vger.kernel.org>; Mon, 16 Feb 2026 07:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771228788; cv=none; b=W1+DVUxF+wxWjFsgevNk1N0hsTalS6aE/Qyb5a+6lQRnJWKYR8WcJGd89PZsg7UmIfT1d7kDEulm2l+XoceHp50yzTZ7OMDds9n0nnYKfclLuYejEkk9Z8Xh6RBvPHYKsl+fUgibiPMcgB4VL6LywhBztJZd5ldVjKxQfla5dfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771228788; c=relaxed/simple;
	bh=qKoIdiaapjEPcojKK6obuScxEx9dNO/EyBNHX9v76A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6HlQNmkmOpK88+oWCWwE9pz9vDjb3U6syVi6lKOmmMZCWll6hCRtb0esmtRkm/nKZOw35t9VCcgY7pxBrPKff4uu3ncJ2Uf8xadRfkSlmc/YzdinMgOpnfJRAvRLZPyTSMXMCDfbiK+xK79eiuVMfkvvgXaXirGrdMcwgvkh5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SS4funuU; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SS4funuU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771228787; x=1802764787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qKoIdiaapjEPcojKK6obuScxEx9dNO/EyBNHX9v76A0=;
  b=SS4funuUxMmL6ECYVMSoXLdWu9VvB1vyDWa/3haiKwi6WNipjEid4DPJ
   fCL3zCKUker9NLNWf11h4AdDmLKs2b3zO36hVJ+9CiMWgqnm1vnNV0Vjk
   3TLi4maetUBnUSqo5QomyleVUcVGnxWxYRLl2GuRi/Nrs8DTaaXKY/IVb
   drJjl9o2IeU3j0WxflK9qret20mE97w7JPuJ/i5bdFOU+VgwjCxc81ZNu
   gno+i9dzNjAAZIct2sC+ihTKLh4VNfnV+kI3i9S79JAGvlp6s3t1Ot890
   zW2MQYJNhOCoohOZagFBH8SMa4AmuT0XrEiVULJIiY5Qs3qV5FZtOlVsv
   A==;
X-CSE-ConnectionGUID: okpzgpikTPS4xEdDXtAMLA==
X-CSE-MsgGUID: WoPbb9L/QFiwZclvs2BZyQ==
X-IronPort-AV: E=Sophos;i="6.21,293,1763395200"; 
   d="scan'208";a="140812891"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2026 15:59:47 +0800
IronPort-SDR: 6992ce73_gYH1FZ8GeZ9DRw+qMu40j2H9u7hTmji5qFlrALLbMtel1WF
 Yx+/E3DA8rFW2WOP4T8ZnhdYZTIqNwptKStpFeA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2026 23:59:47 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Feb 2026 23:59:47 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 7/8] t/zbd: avoid test case 33 failure with write_zone_remainder option
Date: Mon, 16 Feb 2026 16:59:35 +0900
Message-ID: <20260216075936.3318729-8-shinichiro.kawasaki@wdc.com>
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
33 fails because fio does writes to small remainder areas at zone ends
and it changed the number of writes. To avoid the failure, modify the
test condition of the test case.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e5a5f75b..10fd6690 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1002,10 +1002,13 @@ test33() {
     size=$((2 * zone_size))
     io_size=$((5 * capacity))
     bs=$((3 * capacity / 4))
+    if ((!write_zone_remainder)); then
+	    io_size=$((io_size / bs * bs))
+    fi
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((io_size / bs * bs)) || return $?
+    check_written $((io_size)) || return $?
 }
 
 # Test repeated async write job with verify using two unaligned block sizes.
-- 
2.49.0

