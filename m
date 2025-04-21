Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8B33FC7
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239119; cv=none; b=ezl8/uLUyf+xJyUFJKG8egnOMa7WkX8Uwq4NiIdNNovSmfoNAyS4brTBwkf9B6afTsMEDzRX/tsdZSXNKVnOr/oGQhz3yv3ISLncPneuzHXf6xpbqSBoeQ3EjkRH6+7/uF8YsextgiYNbugmY457sp3NSfXYUh31ZKh94y7uSKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239119; c=relaxed/simple;
	bh=U2JetyA0HQB8SUf0vsJDMj1Q6D8yCSpkkvb7Eauuh4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ha7haNlS1w1sQQ1dTwtMvMnETsZ2nD7H4DGUT2UTPD8uIi+wfZj/VwDNkDckjN+roL6uD3iX0qYDWOHCMDgrm8tMY9PCUhoId5nTR3KAsSR6kQkG6PoS6s9LSfeTHVPwAfbj4Q7s3tbYTnwcKSqMNlm8/gTMly+1CcVnirgFaWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oHJYeYh1; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oHJYeYh1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239117; x=1776775117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U2JetyA0HQB8SUf0vsJDMj1Q6D8yCSpkkvb7Eauuh4c=;
  b=oHJYeYh14TiCCMk7DGhj8oX4shL+X6QvG1n24aJQFcECxSXmBtyXZ5m6
   cA/9TfO3rNAH0s4DCsjc9T/WPOJMKfjayebTK7KMKVaTQZoF8Xl3LVohZ
   Ba2tQLUjhVXXVJWlGC4Z9Kusvifx9q4ggJ6OGBOLo6ataiATDZ1Ejwgz+
   /8rxd5PuXpLMftmQG8fZNDW69vIr2CF4fe5JcwtnsBPhhPgDqWZe6yaeV
   phrZTU1KkCgkFD5UGzVKbGGOqQPbf2d+sCihjRRgvLBJMIhVMQk0KQj/S
   5/Jp/f6EFMnvW6tDpQWl9l6MK15BhwjaSCKCOPT7V4qs6Nlw46Eezld5i
   w==;
X-CSE-ConnectionGUID: Wo0ijYHoTsKEqw1nTlNbYQ==
X-CSE-MsgGUID: JRormQYeSYqHCm8M12k+wg==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027516"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:31 +0800
IronPort-SDR: 68062e31_nzkntWV69r6pHgQhrtvs0FtxDO5ykq/ehBJr9InjNNSogSz
 pqOU778628r51L6WuW2jxFWfsF8eD6wSmbWo9Bw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:25 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:31 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/8] ioengine: add move_zone_wp() callback
Date: Mon, 21 Apr 2025 21:38:22 +0900
Message-ID: <20250421123828.82712-3-shinichiro.kawasaki@wdc.com>
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

As a preparation for continue_on_error option support for zonemode=zbd,
introduce a new callback move_zone_wp() for the IO engines. It moves the
write pointer by writing data in the specified buffer. Also bump up
FIO_IOOPS_VERSION to note that the new callback is added.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 ioengines.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ioengines.h b/ioengines.h
index 1531cd89..bd5d189c 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "dataplacement.h"
 
-#define FIO_IOOPS_VERSION	36
+#define FIO_IOOPS_VERSION	37
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -60,6 +60,8 @@ struct ioengine_ops {
 			    uint64_t, struct zbd_zone *, unsigned int);
 	int (*reset_wp)(struct thread_data *, struct fio_file *,
 			uint64_t, uint64_t);
+	int (*move_zone_wp)(struct thread_data *, struct fio_file *,
+			    struct zbd_zone *, uint64_t, const char *);
 	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
 				  unsigned int *);
 	int (*get_max_active_zones)(struct thread_data *, struct fio_file *,
-- 
2.49.0

