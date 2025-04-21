Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78E2264FBE
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239123; cv=none; b=Anu99iFly6w2TKohL7kEb2MtABaEpWYCogRRkUnW1sEVhTyLUuuN/cPq0RN3TgGHUAvt6QbfD/V3H1d2oUiXAYD2tK16UKRN2A8dw4p1F7xXdkpJwflfb73no4rTU+getTExQpXGMUuuM+NLsxVv3J36V2kOJoiAVonCg5CKRsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239123; c=relaxed/simple;
	bh=4f8vusejDokHFBLhEB28j+Jao3BANaue2ZU/wQg/fQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKutoKaSITksVKOjmQcQgSnr3o18P3ylyNE7px2XrHZmzYVie8CGCudv552l1v9ynYzPi0o0hrUIVgIbEIDukvV0tASprqoxZS3tfIiVIPxN6BkKE0yfG5wk91DgmkCpJC8ghjEqNpPq5369xLqyshOxnEHPsCX1/5+nMMlmsQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MmZPWpRi; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MmZPWpRi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239121; x=1776775121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4f8vusejDokHFBLhEB28j+Jao3BANaue2ZU/wQg/fQ4=;
  b=MmZPWpRi4IxcziS5p+D1v3riS8luGxbNJvAy4+6KnK0kg3Yneazo4QV7
   QAaC70ZJ8ZxNugM3nlGok8WVHtoTASlZMjGdbkeuyYfa+Ei8GLRPlgVq+
   TH6QvhSWavglXdiLf05REiSmmGL1JZqWSOYoSHcGpuS98hoQsX4YetGCR
   dlfshP7gkI2yQ8Hnydc3MPfmqLo6IuU9WtfoMbYQZDdvWDr8irCPlrc2j
   iohb56e5who/RszH4wdiVR8XhbcZi8f+G2/SWqinFTHulwaRI7KWR7Buk
   3ybPHqukdCFTM6Cp20KWfXGVPiCUAoLkh6feNvplioHwbQ2ZQf/hiDjmP
   w==;
X-CSE-ConnectionGUID: pCmZhGxmSRyXdjOyFPAQrA==
X-CSE-MsgGUID: sBvf3LDdSi+Ldxaivi9vvw==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027530"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:38 +0800
IronPort-SDR: 68062e38_ymhNfv5zwePgnC3ad7RnvxK4BfPBGTaXYKAsIjKkYNhBRZq
 k3BORAck7MOivAFPBIRPk9R7BZNUBWTt/Ln8IdQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:32 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:37 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 8/8] t/zbd: add run-tests-against-scsi_debug
Date: Mon, 21 Apr 2025 21:38:28 +0900
Message-ID: <20250421123828.82712-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
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

