Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B10610953
	for <fio@vger.kernel.org>; Sat,  2 Mar 2024 08:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709368618; cv=none; b=FCohBe5r4fRMKxhCRpqqWA9vGfn6OBo/W8c1fuS70d6BDFHm/1lgrkZoZCqSo9VMCx3wWDKrtUZHz004BzCwSn6pBh5f3NKVWZkUty9sAybbu5bucUjmUoNDTJPqzdtTC+4nXmHA5SpT847bt5fxI+n1nRkWZMSFIUO3gUflco8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709368618; c=relaxed/simple;
	bh=xkitf4IE7EX7Inn4dqMppqbz9qTe0JbVxkzzvMIWW+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQ5AZ9ty8yR0sQ3isCuUB4ol6MpNjvoXa7dyWNLuZ/9PgSbD7rGkm2FIsJ0WWRSkmOKc6k2mV4u5GZpHhuPPT/8eVS+ZIQ9KLjQvskipu+PZrrtQM1iVmgDthleR6vPMovKc8Vn+rzKyEwSSfdA8SJszCwpGNvQlBaeVG9ZShoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=W9sIi4mL; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="W9sIi4mL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709368617; x=1740904617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkitf4IE7EX7Inn4dqMppqbz9qTe0JbVxkzzvMIWW+8=;
  b=W9sIi4mL/G5hAfg7y93x1+/Ss6lIOYYXSqc7oqch0kW7g5ASXaroUwPB
   HMJtGeZatGt3xrqUcK/TOtD8Ln+W8ghKAuiEg23ZmBqbLjLfb2fdtqop7
   15JjUm9H5uV4E53g1+Vh61VjAUe2FQZm4qyQFkR6BdH7Wp2IJ8PvIAr+N
   8AcYu9eL9IrI4cQAEsWCY4hoUj1879EISYe4MWyIYh0jYpFE00x1ivza3
   fwNNfgR3ObTn0byg81SghS7qSe1IMYdSNeZ8lXsR/kqEUSQsRlLpePrWa
   6hAcX8kte8IQ3sppjr0b54tuXtuLGNeRmbG0RaaeawXghRLAkzqzcQFXX
   Q==;
X-CSE-ConnectionGUID: McXqOu4OSN6UxPZ+WCQp0g==
X-CSE-MsgGUID: /fpIzOSKQleElpG1+7TTKw==
X-IronPort-AV: E=Sophos;i="6.06,199,1705334400"; 
   d="scan'208";a="10496842"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2024 16:36:56 +0800
IronPort-SDR: JM82jSyIDsu72q0Lj6EwrAuSJxceV1kQkAGotPMv/C4sVzmZsWsAWw7ROurelosumDnRB2+0Qv
 KVM+ZKpi8Sow==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2024 23:40:30 -0800
IronPort-SDR: CCeqwCTVrXnyNLT1U3aNTgRjr+TcPPfn5MncKImMVKeeRqIrwhGstU0goU5r1pzmQgHt28L0iM
 qEALJQoOEapg==
WDCIronportException: Internal
Received: from 87h6l33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.8])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2024 00:36:53 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 3/6] t/jobs: Further clarify regression test 8
Date: Sat,  2 Mar 2024 10:36:10 +0200
Message-ID: <20240302083613.602-4-avri.altman@wdc.com>
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

Add some more details explaining the expected result

Signe -off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/t0008-ae2fafc8.fio | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/jobs/t0008-ae2fafc8.fio b/t/jobs/t0008-ae2fafc8.fio
index 4b364850..f4e8a06e 100644
--- a/t/jobs/t0008-ae2fafc8.fio
+++ b/t/jobs/t0008-ae2fafc8.fio
@@ -1,4 +1,5 @@
-# Expected result: fio writes 16MB, reads 16+16MB
+# Expected result: fio writes 16MB, reads 16MB+16Kb of metadata:
+# 16mb writes of 4K blocks are 4k IOs, each creates a 4 bytes of crc data = 16K
 # Buggy result: fio writes 16MB, reads ~21MB
 [global]
 bs=4k
-- 
2.42.0

