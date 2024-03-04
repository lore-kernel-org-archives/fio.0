Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C888512E73
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 07:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536761; cv=none; b=Zl/0aJJXdV5QekOCNzbitGIulFBrbVtqaM+IXfsVdAw5sivut21Gc4/GirA/fpQdIs0xlvMvdxMPbpf5IgmNaGd8xa1Yx5pq3qoID7O40Bdjaqj/j7CU4UBLP3w0wq9m5DluUhnIrUdTlXdV5sA8JUbM8koz/Ks7Efm9WCghOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536761; c=relaxed/simple;
	bh=dWVz0dT5vXoOsfNeSQyLEEuGnpKUFK6QuVfhbg3tVOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTaPB0nmi9pvS/+euGek0g2pF6jFKfAOVN+9S0Cnh0MhEOjYO/+632SprFccpP8s2Q5mvtxkGSsNw2tfCSe/VQB8Q6Uz4AmQSny6xWIhHnTvtniGAIPdsavaN2WhVBMoCC3z4442pXiyZOKnUee4FHGsqIRwlsj3AUKFKxdA9ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WiaJvH9S; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WiaJvH9S"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709536759; x=1741072759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dWVz0dT5vXoOsfNeSQyLEEuGnpKUFK6QuVfhbg3tVOM=;
  b=WiaJvH9SFhH4ZPdrmd0K42Hnod/ivwrl6epiA2l0ofcBPOPqUGh60iId
   uBndbO6c0V1kihdlUu8YVZHJMAgKIMzbysZjiIVesed6H/NCOWWqiH+Ur
   RQJ8c6dYBHK0gtUg1Zfuxs/RdG4krn5yedjTc3bKZnrpwe+PwJlwpWGyl
   ycs9ham+WHFjGIGCMHxvARUbfVqp6+5HS8kF46uoKItMwtwmZmRnSb3cM
   Z9oK5m+sY5Tr4g0aVAZMn5SQ+bI6T5d9plQdJyxpvM6Wq/nOZ9ENI1A6U
   pWstL2oXgcYLr51pEASWYJeybJA0oWux/Ht6UN4eWHUkcQm6zy50Bj8Vt
   w==;
X-CSE-ConnectionGUID: ZzJ6CHjgTqq6yXIPDOdsFg==
X-CSE-MsgGUID: KxudsLq/RKiX4gRe9dT7bw==
X-IronPort-AV: E=Sophos;i="6.06,203,1705334400"; 
   d="scan'208";a="10728620"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2024 15:19:19 +0800
IronPort-SDR: lAAHJ7Owb5PuGdMC4P/IpO96JFgo/oyZbB3TmWLMo+jqJ1FfP4I8kOlEaX6/QV/s3mD+NcC2Py
 k4d6T5EkxyUQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2024 22:28:32 -0800
IronPort-SDR: xEyLCwm6V0UvvgbQ/g2EvYnpLsZqQMkFHxWwgZiVHcmCQ/rF/oDFv7Ia69IOzXff1FKbdEkOab
 dr6J9+71b64A==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Mar 2024 23:19:18 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 6/6] Doc: Make note of using bsrange with ':'
Date: Mon,  4 Mar 2024 09:18:51 +0200
Message-ID: <20240304071851.982-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304071851.982-1-avri.altman@wdc.com>
References: <20240304071851.982-1-avri.altman@wdc.com>
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

