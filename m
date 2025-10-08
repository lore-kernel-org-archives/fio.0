Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CFA243376
	for <fio@vger.kernel.org>; Wed,  8 Oct 2025 09:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759916933; cv=none; b=LLMROOzFOxHnBPqBeaReoyGhmFORn5BAlT6+VO4zlN25zj804+4eiiba+lLAtbCWQa4IaY5kN0Ga96U758ywzJgYjXo0RNpdeyo+3gjhnOIEv0DpkEyl9886PNs05tpFFgKmTroqmwcaqDbcmZdcKlZNXbUNVegsUttaJwzq+y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759916933; c=relaxed/simple;
	bh=QGfHnZZYHNiFC+tQ4hjrfJqZNfaImPKtQNEp9uaf2X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1AV4mSfbaMWLfPi+4oA7aBNqJKmmXuqyg72IcT5Gu2dAp+l9Akx9xsYIj/uIj5CHHs7g4x9/FRGwyVWaoa6Lwwi+mmopJjM5Pe0VpGTg95c21Crx175jT55Y4y//2xt+6pcjopD3WG88FTrzl/GwCtrF5+Z7HGRMxozb8EPKqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MVxJUVi6; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MVxJUVi6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759916931; x=1791452931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QGfHnZZYHNiFC+tQ4hjrfJqZNfaImPKtQNEp9uaf2X4=;
  b=MVxJUVi6+sziUFKmOTP/gHdCIiZ3VwXWdeMQoxI/Cgh0P6cXEM4eAS3e
   htFtfUbG//dUkVvqS9tfKVTkGDEIPjt362tLwe/wZ9OJ72x1NW6zfec+H
   TyRXKoYgjJPlO9mTwAAko1LnLn8lDM9oq9flGhpwR1kZrKpElxfBTjl8b
   HuUncadD7OAmT924yAKkTccmIZaty1RQ0dBuhMAVEqrrmB/tNxbf0TyNq
   IIYBrHdgITrZIkDJGeO+mbySLCOBPrRwQ1RZkxuuFHaHhGlVd6/LhWfxc
   gES8DcSDoWhkt/ux48qsQHvm7kXoAcipAxQAMRURwWgQwfFqaLmMw0HBc
   w==;
X-CSE-ConnectionGUID: PZy6rAC1Rk668oy593HGqw==
X-CSE-MsgGUID: lOfceqZBRsy74mNhw+26Pw==
X-IronPort-AV: E=Sophos;i="6.18,323,1751212800"; 
   d="scan'208";a="129836316"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2025 17:48:51 +0800
IronPort-SDR: 68e63383_v4wPwm06OEJZKLj9D/m/mKViSoA2pdCgFMfged44pwd+Im7
 a+I+HZrDhutQUj3ARYkf4GMvlLamgprulpRPo5g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Oct 2025 02:48:52 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Oct 2025 02:48:51 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] stat: report zone reset count in json output format
Date: Wed,  8 Oct 2025 18:48:47 +0900
Message-ID: <20251008094847.1628954-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
References: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When --output-format=json option is specified, fio currently does not
report the zone reset count even when zbd zonemode is specified. To
report it, add the new item "zone_resets" to the json output format.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 stat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/stat.c b/stat.c
index 76b74b3c..a67d3551 100644
--- a/stat.c
+++ b/stat.c
@@ -1946,6 +1946,10 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		json_object_add_value_array(data, "bw", bw);
 	}
 
+	if (ts->count_zone_resets)
+		json_object_add_value_int(root, "zone_resets",
+					  ts->nr_zone_resets);
+
 	return root;
 }
 
-- 
2.49.0

