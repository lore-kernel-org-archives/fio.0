Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55808B661
	for <fio@vger.kernel.org>; Sat,  2 Mar 2024 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709368629; cv=none; b=WAzfAx6qpfuaB3sYiRbXxZnZn+a48fj2UmKrWxhwWoBT5X3/trgFugtVyY7J4/RzkEAZJYQEmJy+2AOFWjnWPZraL1Csqrdl0bdVV9Xm0Pvv+Jd6po31v4JFBp2Zabo3SM0cRVKwOYvZrpfXJxuZkqZ968uqQDz9PgeWLWIxJ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709368629; c=relaxed/simple;
	bh=dWVz0dT5vXoOsfNeSQyLEEuGnpKUFK6QuVfhbg3tVOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYYUtAxkYO2ifIopGJBDFl2R9TO4QTS2Z05EDIXkdXoWTKtLbg8mrB1n0HP+LN/1ODnhJreE/ax+a2R27znuhOvvCedeza5th35oh6/NI5PR6/41WAppqMbN+SAg+dDjUQHj1E3CUHKeBBWZYzYDxxEafjEaIPHjlOov/TRYmtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IS9ZrvbN; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IS9ZrvbN"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709368629; x=1740904629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dWVz0dT5vXoOsfNeSQyLEEuGnpKUFK6QuVfhbg3tVOM=;
  b=IS9ZrvbNs6FfCL+cV79VWwlAapEEMQhgoeeZXBNwP4SwD+CFtddIMj/K
   j77FircdRFH7ZaJQprTVTwliTjQujEaW7J1TMqXYCn/8HB/r83t2DJ6D8
   8/B+VKTcKe4OXUPFoYF6AMOdzHvGbQqMBryAcLiwX7c+z9NQuE2fUsfHa
   RR/UJSn9WEAGoqvNPrRxm0JONVg+Kins3CXUJsNH8Uo3R/T4p5j4mS26h
   BDDMbUJgsn3LyZsj+yjYxB5keG4z3rZ0UbEJt7Fdcg2wpwzw+wfn3dfk6
   CJgVyhD2oG4KXkucc5BhZ+AMsgZxCGcWbe9rmd1gbfYqaG+SRi/EggwtX
   w==;
X-CSE-ConnectionGUID: ErykwinMQeeWh1pu5K61Ew==
X-CSE-MsgGUID: 9YBzHfEDQom1Wprzoof4pw==
X-IronPort-AV: E=Sophos;i="6.06,199,1705334400"; 
   d="scan'208";a="10496863"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2024 16:37:08 +0800
IronPort-SDR: Vg4/C8dosB3u0f3Zct3GAI4qPACV9VNu2p5TupZguLkwVdKnwgriVlVQGelhzn/am2jB9/vM63
 QLpwgdhifgJg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2024 23:40:42 -0800
IronPort-SDR: 9kZXIAkB2V1jm5AuIMXe2E8scDdF5CCJBfsLjcKbj+dg4ecUjJFq0a755KNOnOCvkGKevKEcfL
 eNz9RrzVyfpA==
WDCIronportException: Internal
Received: from 87h6l33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.8])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2024 00:37:05 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 6/6] Doc: Make note of using bsrange with ':'
Date: Sat,  2 Mar 2024 10:36:13 +0200
Message-ID: <20240302083613.602-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240302083613.602-1-avri.altman@wdc.com>
References: <20240302083613.602-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Which is also a supported form of delimiter.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 HOWTO.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index c404d724..2386d806 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1631,7 +1631,7 @@ Block size
 	Comma-separated ranges may be specified for reads, writes, and trims as
 	described in :option:`blocksize`.
 
-	Example: ``bsrange=1k-4k,2k-8k``.
+	Example: ``bsrange=1k-4k,2k-8k`` also the ':' delimiter ``bsrange=1k:4k,2k:8k``.
 
 .. option:: bssplit=str[,str][,str]
 
-- 
2.42.0

