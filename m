Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E17F1AE005
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 05:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745558520; cv=none; b=jBS1ZPTRl/N8+Rr6KgYaiujucypjL/yzkIfXKJPegUPTh/x36FiPZs4V+v1bMRWwy87jVKjGrUIQcRbYE7xLH0Bh6UdFUr50r1lOZvPe/fLiwyil2BOE7ERHW6VRBSwIezrDxIEptPEdFDZIGWRzkAfe6vil/XCaaMuEkmta9pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745558520; c=relaxed/simple;
	bh=4f8vusejDokHFBLhEB28j+Jao3BANaue2ZU/wQg/fQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1Z9qw4Nhblk6i9MtZY2Vk2RpMdwPFhESF8LnEvJkvGnoYx1FeQY76rl2wFRm51JXjszczePamnfjwmIX6MYUbMsHc5iveSmSkUYVIo8sksysfG5/UB8qXX6OulLktJLMJjoZaF/kiAvSFkuAFIFaXH7yD8Je/voUCuvkppJT9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=l0Dmd2p/; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="l0Dmd2p/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745558519; x=1777094519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4f8vusejDokHFBLhEB28j+Jao3BANaue2ZU/wQg/fQ4=;
  b=l0Dmd2p/a9Kq+E+PXIwfCoVIIoYNC/Q32F8tK/J1zfjIRt2WvYNXfsJQ
   9X+MuuNbiTYH4HPm/viTKmiEMc+hVoHE3R17oax/IKNq1W5DP3R1Yzn0R
   BNFroNyeKYcGWB9VcBtCBVMEHUtxHFhP+O75Y+qzOiP/0FtNb5gksxKCG
   XlYUyx/GrR3/zC6keC33RPUgaantpq9lKw4rcICmphtePaIyOafjkjKPg
   ATkEJQXnREnjpuGjK3Y9Q0/fJ4z2VHU8uRv4G8sQWXTzL0sGh+y4avpnm
   hPX0wI4e9x/L9uiOSspHaxWS9kf2MTSsw/tmVagpscDqlGk6wsfjdXkLk
   Q==;
X-CSE-ConnectionGUID: fjl+BVpzRNuJENabgKWlZw==
X-CSE-MsgGUID: XkQDYzC4SY2kJiRnkSr9YQ==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="82381454"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 13:21:58 +0800
IronPort-SDR: 680b0dda_QPsSCMzbZCEJuepKuCDhnNgs5gmNVvm7tQmJSo+ikYL9gwi
 jW03LX5mEiCiQG7h6lYb4oLtpgOiL+C/eMh1i8A==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2025 21:21:47 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Apr 2025 22:21:58 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 8/8] t/zbd: add run-tests-against-scsi_debug
Date: Fri, 25 Apr 2025 14:21:48 +0900
Message-ID: <20250425052148.126788-9-shinichiro.kawasaki@wdc.com>
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

The newly added test cases in t/zbd/test-zbd-support 72 and 73 require
error injection feature. They can be run with either null_blk or
scsi_debug, which provides the error injection feature. To run the test
cases easily with scsi_debug, add another script run-tests-against-
scsi_debug. It simply prepares a zoned scsi_debug device and run the two
test cases.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/run-tests-against-scsi_debug | 33 ++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100755 t/zbd/run-tests-against-scsi_debug

diff --git a/t/zbd/run-tests-against-scsi_debug b/t/zbd/run-tests-against-scsi_debug
new file mode 100755
index 00000000..b50d7a24
--- /dev/null
+++ b/t/zbd/run-tests-against-scsi_debug
@@ -0,0 +1,33 @@
+#!/bin/bash
+#
+# Copyright (C) 2020 Western Digital Corporation or its affiliates.
+#
+# SPDX-License-Identifier: GPL-2.0
+#
+# A couple of test cases in t/zbd/test-zbd-support script depend on the error
+# injection feature of scsi_debug. Prepare a zoned scsi_debug device and run
+# only for the test cases.
+
+declare dev sg scriptdir
+
+scriptdir="$(cd "$(dirname "$0")" && pwd)"
+
+modprobe -qr scsi_debug
+modprobe scsi_debug add_host=1 zbc=host-managed zone_nr_conv=0
+
+dev=$(dmesg | tail -5 | grep "Attached SCSI disk" | grep -Po ".* \[\Ksd[a-z]*")
+
+if ! grep -qe scsi_debug /sys/block/"${dev}"/device/vpd_pg83; then
+	echo "Failed to create scsi_debug device"
+	exit 1
+fi
+
+sg=$(echo /sys/block/"${dev}"/device/scsi_generic/*)
+sg=${sg##*/}
+
+echo standard engine:
+"${scriptdir}"/test-zbd-support -t 72 -t 73 /dev/"${dev}"
+echo libzbc engine with block device:
+"${scriptdir}"/test-zbd-support -t 72 -t 73 -l /dev/"${dev}"
+echo libzbc engine with sg node:
+"${scriptdir}"/test-zbd-support -t 72 -t 73 -l /dev/"${sg}"
-- 
2.49.0

