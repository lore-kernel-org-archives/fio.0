Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE2727F19F
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418380; cv=none; b=iYQeINZ2CdlAHzhakvT6iUWxN9gij8JBsp8IZ2cVAGtfA+XsJGLF4fcflut5kqR9/Oxx9RLD8EYgjNaGRHsltHaUxRAGujdGMN7pdR6ttiuHGatN9RvkFk/nKt2rOk8m8JlhLHAEBqohoKdVX6eume9LdpdD6lsLvcV/XrtdaY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418380; c=relaxed/simple;
	bh=qKoIdiaapjEPcojKK6obuScxEx9dNO/EyBNHX9v76A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0OloRV/dWyAoQS1aLuyR3iGz+2lQeJlKMV7bPi0jSPNckFS1LBiIS1Nfsg1AEIVrglBpEynvE5sAlGcob7uuuAR5NRzHUJ/+17kCLMYAPnoC1fNNN7ZcGCo6Xwh19yDF9KgJCqvXM5jcHazr5R1qiOdcHM7ozNdLk29E/kGBRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NLggIpOn; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NLggIpOn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772418378; x=1803954378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qKoIdiaapjEPcojKK6obuScxEx9dNO/EyBNHX9v76A0=;
  b=NLggIpOnEI2ARD8mntCGItXaZccgmx0txUSuWvFfxmkcDkTQrEiEcHqS
   scGv/XRl4LC/4TD2nsZVuOLYjtFN/ttaG/WdN1FDpucIgKBTV4n1IwOit
   dLAeYNMmlfdD8yRtTlj5yR+jFSQynvM7KL5tgrW/p7+p8YiiUNMSIBgis
   lvwVVfHUNdR/BYkOstOU3ZnESt1fzOAA89WXXZqlh+15sT7osdWVx1edI
   B1wEFeozqGcLZKDgSm/zaUpjx16wJETQy4ReXioOQ+DBrRxUWQ6hrZr7N
   RMKslXf6LJoZyKJsQADu8DlTLWQXjoL4NBuFYm2GOnT7H6+EyzIqLMTSp
   g==;
X-CSE-ConnectionGUID: 9T0G82VLR1enZ0Zk5r0qAg==
X-CSE-MsgGUID: 2wdPuI6pQtS+r0+vkQ/CXQ==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="141307962"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2026 10:26:18 +0800
IronPort-SDR: 69a4f54a_6ePGg2kwirWjKAklW2C5V4hu59WcfAWlZitILT4zy9JY/iI
 tMWS8kkdf6OHV44wqq7V5/IhMEZT0zNqZxhc4pQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 18:26:18 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 18:26:18 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 7/8] t/zbd: avoid test case 33 failure with write_zone_remainder option
Date: Mon,  2 Mar 2026 11:26:08 +0900
Message-ID: <20260302022609.3526823-8-shinichiro.kawasaki@wdc.com>
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

