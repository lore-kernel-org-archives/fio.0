Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8FB373BF4
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 01:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501531; cv=none; b=hAwdk75+VEGor4+SW97U0gAlrRU9UdgG3xre8ViHuzhkTyMlWG8YBYjuyDOcAq+RwCeNLbut4AG7F5PxL3wIvx8TQWvzOwPhZzlepVUXt+WVzpJm3sPinSI9YS/sdBpodjMXP1U+dPdGXA5xp3E8RFxjWnp1Y4+wH0EI6gUV0Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501531; c=relaxed/simple;
	bh=qKoIdiaapjEPcojKK6obuScxEx9dNO/EyBNHX9v76A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WP4BHvB41KTxLRjBLCteADfNmA6XlJZaRJb5/fLQJOGI/8X2Xc6pA/2AJfyq2dgkoyP0ezHYYRvpyBeYr8nnKeHli1EicF1mTJVW2lZfczU+3enTJi89Q9SoSwEvNHKnZ3NbCbiTl1DsT2b85+HURGFxewHrKuMFlTNSr4kv4Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Xx5r0dM7; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Xx5r0dM7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772501530; x=1804037530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qKoIdiaapjEPcojKK6obuScxEx9dNO/EyBNHX9v76A0=;
  b=Xx5r0dM7H3mb8bLjgHuSC7WvJgmCYsuaSuOKoSufCLokJsBNKT+f328X
   36fhWWB6yFpApJRaOO9cj3dW6+IFXclbMCSBXSXZk3beu5dRMhnosZS+D
   FBYCc7A5fnuc7kpPdX+l9Iah36kfdZ1qLYlZEtsm6Fu0ZoTsP2UU8V9Tc
   lzhNXnRucVmpOz+EjB/TgUQ9q8KfMuFsZJNsfa3QRrztLp2tcXX3plpCw
   iNxE7Vu8BHCkbfXaxbpIxJgd64jGOouoFfoXWG18BeExD77YPG7TP/0eS
   7AsOqNnBRgZx4NIZQjxLQMNABX9IQuG57Qrh0QZE+9mv1Qch/Uk1e8WUu
   A==;
X-CSE-ConnectionGUID: 2YxQRWjVS8iqyYfn78JbBw==
X-CSE-MsgGUID: 1kNKCQ4bT0yEnfb0nzWSUA==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140813531"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2026 09:32:10 +0800
IronPort-SDR: 69a63a1a_H8NMhpjOyF+NTpV5lRJ5JWVB9UtqJupqrnz9Na0lSiEhtCP
 BE7qX7sYdCxT0nqIHgREEs2qW3zb++7VJ+iJuvg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 17:32:10 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2026 17:32:09 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 7/8] t/zbd: avoid test case 33 failure with write_zone_remainder option
Date: Tue,  3 Mar 2026 10:31:58 +0900
Message-ID: <20260303013159.3543787-8-shinichiro.kawasaki@wdc.com>
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

