Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3764F211
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 09:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629227; cv=none; b=rd1nOv8TVgNvXxP0ILK7TNeucDeznUpPv6Emjdb6TMNHZplMG0GCspfA7dD9a8FixwKTZtm/6Rp4SuwIEayaC08XUA1Irnapn3LzwlNGNAYHN0XbTcNbJNhLkgC0wnrm1NQsw7xoR8bLkG8jM9N1i+NiVGoXenpeV6sv8clo74o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629227; c=relaxed/simple;
	bh=b0ttlntqpZCY0lFJZz6RFsRq9OfyBqzHa/bDkcl45Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKm2/pOnStYtdF41ZhKWHDL6zUeq2XOeMhvkwWmMVYdwT9/AwyP90aO0hDbj07eNoS8cR5tLl4zIU49qTOHvLhE9VmL+aWrhrhhzbpuBNHDW3/oQNutcgLkG8fh9e2BFTBVTnAcvJjzdI4SYIQ+PBpAwqxvqt3ZgPv2HYIy/DJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KTZ2K18L; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KTZ2K18L"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709629225; x=1741165225;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b0ttlntqpZCY0lFJZz6RFsRq9OfyBqzHa/bDkcl45Ks=;
  b=KTZ2K18L6pSDUQ4diugbQPMPNW4I8y948KdmIU/lOtynMOXEB49PYmxM
   HjQdgJiEu5FITdTzppcEy5FxxE06RWhPp/BepDsQ17ERFubV9a06JOx7z
   QFydt02144LHCICngXhmb9L84NAqcNNDQ18Sckwi0uFCLd1HoI0hrKQ3M
   j11BotE7vkNBqaQsXdp4DLCnkLukFgwIfCfkXDfMyy+ki88Z/3fiXDI8d
   tIrbo8Wj7BC13altKMXP6NMahiyydKhOtctQY2DluNrGER2H/kLBIsiJt
   QRrpPetXDgQAqJSZicWFywPB1Ex3EZ7YE6FDv/yXkkH/JKg7GVzDXd8A+
   Q==;
X-CSE-ConnectionGUID: pS9pBvk+QsqRuJo9+tdo6g==
X-CSE-MsgGUID: D5XPTBSQRPaOSO/icaesEA==
X-IronPort-AV: E=Sophos;i="6.06,205,1705334400"; 
   d="scan'208";a="10678198"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2024 17:00:25 +0800
IronPort-SDR: iYyEUcR9cGN7kIpuODYWvBq2SAlqXsXggtWQoGdtuw4DGVa0dc4GlG+NJEN5SmYyHgCuIfBFuz
 JjWX6f7U5BEg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2024 00:09:36 -0800
IronPort-SDR: 2nMoVm0gdtR4ZRP4PHlvAEEiHC+o91YTQ+W9jytgqyGJdbVccQlXL3gOYgMEKvW8odtyGI2Szw
 aJj1KujU0oRg==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2024 01:00:24 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 2/5] t/jobs: Further clarify regression test 7
Date: Tue,  5 Mar 2024 11:00:05 +0200
Message-ID: <20240305090008.1216-3-avri.altman@wdc.com>
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

Add some more details explaining why the the successful result should be
87,040KB data.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/t0007-37cf9e3c.fio | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/t/jobs/t0007-37cf9e3c.fio b/t/jobs/t0007-37cf9e3c.fio
index d3c98751..b2592694 100644
--- a/t/jobs/t0007-37cf9e3c.fio
+++ b/t/jobs/t0007-37cf9e3c.fio
@@ -1,4 +1,7 @@
-# Expected result: fio reads 87040KB of data
+# Expected result: fio reads 87040KB of data:
+# first read is at offset 0, then 2nd read is at offset 1.5m, then the 3rd
+# read is at offset 3m, and after the last read at offset 127m - we have only
+# read 87,040K data.
 # Buggy result: fio reads the full 128MB of data
 [foo]
 size=128mb
-- 
2.42.0

