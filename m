Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DD11B4F1F
	for <fio@vger.kernel.org>; Thu,  9 Oct 2025 02:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977573; cv=none; b=UgcxdKRcHIi503/iEj4eDekr7L+mO4mEXmBQT9sh0ls33ZigsrNz+M/ClJmQOYfbcIZXcttqFOWHwfCKpEpsbfTB9yrKO4FGTmvGVyEbfSUzdOedVd21ugCuhRj7dKtSG6PDHsHXZrdv2pqxF66cVx2/zA3Lxz6TvLj8EawaoDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977573; c=relaxed/simple;
	bh=QGfHnZZYHNiFC+tQ4hjrfJqZNfaImPKtQNEp9uaf2X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKnTU7aoASAT44QBBDtQcTLWO7yza539FA/Bh6gp5GlXPQEgmJyVeYYcQaiA7A/4hOAq7nzBg/UysJvn3+AeYILauzSPt7fSM0p51yIAmiMpVZnimE/clojWGhc7bmBcB1A/H2fDSrQyFKI9mULvpcvdTG8ikE2nhbJ/uVsS1wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Nbt5Nf+O; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Nbt5Nf+O"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759977572; x=1791513572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QGfHnZZYHNiFC+tQ4hjrfJqZNfaImPKtQNEp9uaf2X4=;
  b=Nbt5Nf+OAV6GepY0Nng6GrdFM/5aN4GjUV3PluwbUjHXAVgeDDxiTSIu
   XnBk2XzDSRuHt85Q0oMHQhUA3jldE8M8fGfguF+z7ulPg7iEuYRk57wUM
   vafZs/I36qKfxFIllFHb4puyg7nd43GnttDdwBKddCNbvv0Kltmn4wmBe
   NsW31gf9KR73FJZL38jWpt9jc9QPawAkAphSyHWrdZ2Zx/pfE2sKRq1ie
   x1Y8HB9FE84dSDRYYJXluyh02ueyak+1RRrYkLDxg9uFG7aZC24B61wG6
   yVTtatRrKBgyk3fcMnRrNbAAx8ibEe/RC2X6kAIBxBv7yl2QE3t2nVgLk
   A==;
X-CSE-ConnectionGUID: 082heOxqS5GxDTnsV7zdrQ==
X-CSE-MsgGUID: YA8iCr3vToaTlur/b1AFDA==
X-IronPort-AV: E=Sophos;i="6.19,215,1754928000"; 
   d="scan'208";a="132880596"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Oct 2025 10:39:32 +0800
IronPort-SDR: 68e72064_6bnNUVxknCIi40cgzDJ/kOk/KZ5/NHFGWuod0MVRKIJ3v7G
 KGR+pnBxRGAAnYvafFqbS8+PUqU1cO5fc5FEe1Q==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Oct 2025 19:39:32 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Oct 2025 19:39:31 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/2] stat: report zone reset count in json output format
Date: Thu,  9 Oct 2025 11:39:28 +0900
Message-ID: <20251009023928.1634382-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
References: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
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

