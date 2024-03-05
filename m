Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EB44F207
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 09:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629240; cv=none; b=p6Pjsg+Z65UrjnrJRDxZDG0py0LYtUHH28B5rvzlVQ7c6fKfpInWnHN6nLIukPvHyhHd8HjMacq3Uk5FS9AIC1ig0OmxHOf1bt5RFu0jCtRR9cL3+yQ2DF9cLlee49YPFMaoUFqQ6RudR50OC5ghT1WtgysZ5WsnWXAz4Jd9Avc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629240; c=relaxed/simple;
	bh=9dD+xFIyPzpLYjJRA+lDRNmGR4YtzptDfPHaYUU22vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjOsjjHELeplzeDmWVa7/q4AaZ/IXNMho9NTaRQzVTw2zDHDDhXgvtr06iEj+D/IJ8RhzUh+W+4qXZpJ5THtIk96wIlwFmpTZzJr4sgIc8O0JDcNsCNlPSjvV7GitlUOADy9G6UZE/5+pgpzQemz/OaVCE9l5TFpHCStS2fsF7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YXRjj8fu; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YXRjj8fu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709629239; x=1741165239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9dD+xFIyPzpLYjJRA+lDRNmGR4YtzptDfPHaYUU22vU=;
  b=YXRjj8fufE/PrZsWlkkbVOZ6oUPqa57HLahRiJOjzwjkHMBKW1b1RXwV
   IMQv3maN+DMR8vBN/HxNETYByVYsk0OlLYWmH1WjcPGxUK7sE+nyoFMn7
   Re9yrpNtKcoe1wN0othHxKhwdgPe/h0S9HYJz8+EEGmrseFsWh2+Z7XQS
   rVZWV+PUKbwYFakt7w8J+Ajm88HysGtgSQm6K8iPWXm1LEk7iXJ/hz/F+
   U8ohGKp+v99cexAk7qp9uWltQ4jVd5equ6A7OdcNcC1J+I8VbodRQdGLD
   SOmSYOMhzKebekKefMhbqsYmUa0PYPjm9Ipwn333T/I2rHmAwKSIIVb0V
   A==;
X-CSE-ConnectionGUID: 3mYwtPFDQC6fXCjw9tKzwA==
X-CSE-MsgGUID: zuaQByE4S2eHFtxvr4wpQQ==
X-IronPort-AV: E=Sophos;i="6.06,205,1705334400"; 
   d="scan'208";a="10678222"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2024 17:00:39 +0800
IronPort-SDR: Dk62slJ9e58rK6DruAeDOD3kLcXxsmbs8JGiGd1purKqoqo0PC06vZg54h62afiwNS52lpinLG
 BEerU4V5wW/A==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2024 00:09:49 -0800
IronPort-SDR: eHiGM81+GSZvtJsLoMUebro9hDo7CGUIiTDgZLmQ7JcF/RTqM0izgPDSc/xCelswqKLzE9m9sR
 CCE12Hm3qr7w==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2024 01:00:36 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 5/5] Doc: Make note of using bsrange with ':'
Date: Tue,  5 Mar 2024 11:00:08 +0200
Message-ID: <20240305090008.1216-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240305090008.1216-1-avri.altman@wdc.com>
References: <20240305090008.1216-1-avri.altman@wdc.com>
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
 fio.1     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
 
diff --git a/fio.1 b/fio.1
index e6b291a7..d955385d 100644
--- a/fio.1
+++ b/fio.1
@@ -1434,7 +1434,7 @@ described in \fBblocksize\fR. Example:
 .RS
 .RS
 .P
-bsrange=1k\-4k,2k\-8k
+bsrange=1k\-4k,2k\-8k or bsrange=1k:4k,2k:8k
 .RE
 .RE
 .TP
-- 
2.42.0

