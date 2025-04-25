Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5591DF73D
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 05:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745558514; cv=none; b=NGvHjF6GuBW0sX+/2gpjxlk2g4S2Lr/MGcxe9lIhW1u4DZLB95b1z9uD9Q/26yxsYZD3k552W3l226l3NvrLxHT14B/PWkO7WRPXmZhHlTGm9W3aFCpB3x6h+c156VW5FVsfegIVH9fqU5pVFZuEg2kFA+CY9q5hXgvwlbJ8Wus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745558514; c=relaxed/simple;
	bh=U2JetyA0HQB8SUf0vsJDMj1Q6D8yCSpkkvb7Eauuh4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV6F47Ns1Uhg04jpLYwPiXQii60TrAsA7lsB/M6lNS9XwFr20su87eV8KmBb9I9GSbPZGUrjR6Fi2/Xw2MfBh3Hr+y9pXz9hvMtb+tt9c+gIVwwxX6FkxQPff8ZhBQ9Imejw27cYmZvFT4bgGGdAS3J1kRfcN9y3pmaTLDJi2oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nvXqtUme; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nvXqtUme"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745558512; x=1777094512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U2JetyA0HQB8SUf0vsJDMj1Q6D8yCSpkkvb7Eauuh4c=;
  b=nvXqtUme1ohfIyrUP9cEqlVO85+ozYalmJWfPs8isgIMwHkunq9AwDpz
   gwsHb0m8q4wIXsxMoTL4vVrFYjYmr7+D6dqflJ6pLMiyDsynKja1+MWj1
   4Dz0i5v29L8SnkRGoKI5scl+sQfpwx9n7iW70T5sLeBsqmFotbV38O+n4
   Xe0sU60Vj32Tm5J5zIpO7k3NU0nDoZrV3hgFzyeF9Ltp+KuvPvG7lF5a6
   q473wNlD9wccAcvKrHl2Z8CpEnDYlOCXI/H8Va9dCxwR76fVbtZlwQa/e
   PyLB+KQF3EX14ITegeDCVJ+NI5bah9MoLo9oca/MiQqbR4eakXTuG1Tre
   w==;
X-CSE-ConnectionGUID: 5C6rGEnoTYm1LTAuvakoKw==
X-CSE-MsgGUID: c/j8f6sJTkGDQ4tekWsDwg==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="82381442"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 13:21:51 +0800
IronPort-SDR: 680b0dd3_F2Li4Q8/FB9UDwb/B2bbLr0YY1mZ4z9noInRtQKdIEQych2
 TkiNMZKjIMypUSrKlnCTqc125Mvf1KrCpwPTKgQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2025 21:21:40 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Apr 2025 22:21:51 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/8] ioengine: add move_zone_wp() callback
Date: Fri, 25 Apr 2025 14:21:42 +0900
Message-ID: <20250425052148.126788-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
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

