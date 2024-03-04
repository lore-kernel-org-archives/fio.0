Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75AD12E73
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 07:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536758; cv=none; b=qG1WEdTD6+n/ID/wvGQtWTQY8i+G3Yeuhh/wU5NMBdm8VrgQcFN2akgOb/AcA7c0Nji4fx+fyr7qT9bnYaBN3cVBPwsmUpaDdToVP/Z4p2VMyqd7t1SQDQqErOpEcXoUoUKX0gQ97xP1SU2mgJ22M7KEJk0JdjP+XOIqHFSmw9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536758; c=relaxed/simple;
	bh=xY5gsfCTN0+3GjqhSxeBDvxkYn4tzs+U1PSxnu6kzkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnPohgbzxosj7SPJrg4ceCxx3BAq2BoxlSacWkGU14jng7XvG99p1thttx5+Yl71b20K5pEd6r/nxBpPuF3zfcoMXsDIxL3Jkmpp9mtq91E85YCZw3PT8ZXZtC6nOn07Z8nKgmGlxgHDl6AXmjdGdze1mWXzESTnNhDU1dA501w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=M0IRkKS4; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="M0IRkKS4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709536756; x=1741072756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xY5gsfCTN0+3GjqhSxeBDvxkYn4tzs+U1PSxnu6kzkg=;
  b=M0IRkKS4vQHMkQfqwvHlAb55dSBKYKpOeufTlLUWT7d32AIAn6d8KTzy
   TaeDOminGiu23A2x5Qw9WHWhdVNBElVLlasddalI4tc21CBZqIf1nnOhn
   w/7E+VuIqzPBgzKTpPCCkAuqfg5HoIA+xDeVxFb79Xe0XUEYq6zBiDEG5
   DlvCeQb7LITFARRcCSivj+9Udr25fdziCSk4pUcjoSdC7FofXQi1q/O3J
   iMlRVHczEfuEXt77VCOmmaqspnHh6Cp6L8DBm6Syy4TB6J3mWPcVvDKtD
   9u1K89bkdgyKv8csqA2elgwdEhuM7Wd57fGW199CLPFd7mxWB4TMbqFYG
   g==;
X-CSE-ConnectionGUID: vioLkZ5zQL+eKR7Nfq6Umw==
X-CSE-MsgGUID: wEkzrUICQQiMmKdROQoHGw==
X-IronPort-AV: E=Sophos;i="6.06,203,1705334400"; 
   d="scan'208";a="10728615"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2024 15:19:16 +0800
IronPort-SDR: pb49/yAglVRXfSNyjiiqLENx0qur1+ZbAdA25osy07/qYGtFqtWFb752R6lTc+PIhAqUhuPtGN
 OwrgDhqTxlQA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2024 22:28:28 -0800
IronPort-SDR: oSLN0smNu97VGFaYa/RR+sQVLylJR+G4ASor2NoEbOiPvYVI4JeX0gYk0mmRppg51KIt+NB80T
 +UazepzUCBbw==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Mar 2024 23:19:14 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 5/6] t/jobs: Fix a typo in jobs 23 & 24
Date: Mon,  4 Mar 2024 09:18:50 +0200
Message-ID: <20240304071851.982-6-avri.altman@wdc.com>
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

s/bsrange/bssplit

Fixes: commit c37183f8a161 (test: test job for randtrimwrite)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/t0023.fio | 4 ++--
 t/jobs/t0024.fio | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/t/jobs/t0023.fio b/t/jobs/t0023.fio
index 4f0bef89..8e14a110 100644
--- a/t/jobs/t0023.fio
+++ b/t/jobs/t0023.fio
@@ -33,7 +33,7 @@ bsrange=512-4k
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
 
 # Expected result: 	trim issued to random offset followed by write to same offset
 # 			block sizes match
@@ -59,5 +59,5 @@ norandommap=1
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit_no_rm]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
 norandommap=1
diff --git a/t/jobs/t0024.fio b/t/jobs/t0024.fio
index 393a2b70..2b3dc94c 100644
--- a/t/jobs/t0024.fio
+++ b/t/jobs/t0024.fio
@@ -33,4 +33,4 @@ bsrange=512-4k
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
-- 
2.42.0

