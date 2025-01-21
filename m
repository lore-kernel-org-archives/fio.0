Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFFC1714A5
	for <fio@vger.kernel.org>; Tue, 21 Jan 2025 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737448757; cv=none; b=fPdUoOxyqC/MbhsAC5OFdrZ3glTBA5c4dHNyg9OMOHTpQZhNeLh5Ku0Q2f4q2SEn5TG8Z/EI/VWevjQQ3jYgH1TeSBn3ExRTNE4zaw0ArrY6oAkEVNsZj1CBd0WY2R/Ddk1z97mVyOR7+4F0VWKclmyE+Fj04QyQ5/XWKnPeVdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737448757; c=relaxed/simple;
	bh=WqEPSs+04aX1wt5b4H1M7gc8Nb2v/kmH1U08JXkH+zw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CwVUD/Es0vC4kkPYm1huy3k4Oi8VLqeVjPHyqPkc05gBi45ld1waPTI307f09vLs2quAfuCykuJu21D6pp+uCW7iT8MR+kpVgrrg9Rl1XB6tZ0NFWcUxgzsmsMbBnJB6xSR3m6HA/FpYzHcg435y2xIiL3Hcf2k3m6eXM4sNcIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Y4hRWboo; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Y4hRWboo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737448756; x=1768984756;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WqEPSs+04aX1wt5b4H1M7gc8Nb2v/kmH1U08JXkH+zw=;
  b=Y4hRWbooVV9AkLoSx4UQeBWSBQPeFpDxnaUCNfHERS95K6K3lRpoHTzQ
   Ccg+jgZnwzvrxHazPY432DDZTxCHJ3P2T1koWPofUeCq8LiOkDoBk2MX4
   V25LmsCMRwznRV/392t+RE2FUBfqTTJEsX2OSxDiHnBpoLbBPSM/sLwLB
   3IlDcwG3HRWC0DsyLoiFXaCSjUw48z8gsTjRU9BRNl9jBFteO9v2dY3aW
   sZRWZTzricOjVplQ/2cNnm8CF6KEtAhwgl62S7YCBdsrFpiQGtg6XjRv3
   yBCAJ+/6/xdNlpCiRGfvGdmqmOqfbaFpHbJDGsWlrWNa1hv0fhgts6/M2
   g==;
X-CSE-ConnectionGUID: HsxqhxvbQB+Wy8nj61bLVg==
X-CSE-MsgGUID: mveDsFz+Q8CxOzkbPyod4Q==
X-IronPort-AV: E=Sophos;i="6.13,221,1732550400"; 
   d="scan'208";a="36408676"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jan 2025 16:39:15 +0800
IronPort-SDR: 678f4f9d_vV1+EFiKgp/ngbPSvndPkesyvNFipInBT0FB5QgKFHjwb3n
 hYZCiATGfWUw0AOak6XSYetgOe9v1F9D4hOg1DA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jan 2025 23:41:17 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Jan 2025 00:39:14 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] zbd: fix open zone status check for non-write jobs
Date: Tue, 21 Jan 2025 17:39:11 +0900
Message-ID: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, fio checks if each zone within the IO range is in an open
condition or not. This check is done even if the job does not perform
any write operations, and causes confusion among users.

This series addresses the problem. The first patch fixes it, and the
second patch adds a test case to confirm the fix.

Shin'ichiro Kawasaki (2):
  zbd: do not check open zones status and limits when jobs do not write
  t/zbd: add test case to confirm no max_open_zones limit check

 t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++
 zbd.c                  | 10 ++++++++++
 2 files changed, 39 insertions(+)

-- 
2.47.0

