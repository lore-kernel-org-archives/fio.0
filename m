Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17A1823DE
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 01:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737509928; cv=none; b=sA431KgGGvpo4RRqmOBciLBWn2cEfgSOSRqs5/iQBpfDuj6sMl857njYFfewkxL7Aw/rKjR9M2VP56DJZCdFfatBwDke3wFQJR1GwLGnzRUP8K/hm5wzZGvimuAFXCkE+JfGPBrw7cVYZXpiznRrpnFiY+nsYg/PKupe0JRjcz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737509928; c=relaxed/simple;
	bh=0tzGRx4/wJvb7KCprdmlHJDNw/vRUbIzqXbOAa1SdRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NF33LBR4cmsSpXbh0VnS+wshzaFz/lYDYoq1BOYeMC64HpJ0bLZUlaOQfux6f7IgBgLY5IqfxoN1epg9P/VwRweU6MpyRwZ/ZLfATMZq0TDkzKGb21JSKbvdngLmzDuPxNPs2P0N1cniPdQyl1NL6754ibLr4kjoODqcKvz5HV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=N7un9/ju; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="N7un9/ju"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737509926; x=1769045926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0tzGRx4/wJvb7KCprdmlHJDNw/vRUbIzqXbOAa1SdRU=;
  b=N7un9/juryCsdAC1ewX7ToavDzHSXCCwacYFu06ejbpsr/7DOTL8h3Pc
   U/U5yiwp188P0oC+Okzo95qOtWT2EfWJooxj/9WyRZNgO2e/yBnRO84Zi
   OdzWfqmu01bpyMxvDBFCWkgNLmg4+iWLOlytYGQ/OwQrINHxutkYhwPnB
   X+bUlfU1cn1bsobEbWMEqnnbbQ0tvUbih39jJoNNDsSl3oVmmiOI+XTap
   I0urA6Q60C3+GsIJCQ5K0ProfEIgZ0iF2GXQDrnxe2Avjw5H3Umnv99ro
   F9iambxxrAuCHeUdcYYG/i95aVn+qSY6wGj2IvLTQuT4FO0oY4O+WUjMD
   Q==;
X-CSE-ConnectionGUID: mobUXWMpR+iZkzv59Xg8Bw==
X-CSE-MsgGUID: j0Xurn+cSW6TVo3KCmbZKg==
X-IronPort-AV: E=Sophos;i="6.13,223,1732550400"; 
   d="scan'208";a="37689158"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2025 09:38:39 +0800
IronPort-SDR: 67903e88_YX2GLc4bOHvrSTC+5H5fs8p0G4SAwDdmHQ2BR2YRUC9LQhj
 lBxjVhnUQoFiq0njS1UCs68fNAvHbCpO0okVQxg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jan 2025 16:40:40 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 21 Jan 2025 17:38:39 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/2] t/zbd: add test case to confirm no max_open_zones limit check
Date: Wed, 22 Jan 2025 10:38:35 +0900
Message-ID: <20250122013835.1223725-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
References: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous commit fixed the max_open_zones limit check for non-write
jobs. Add a test case to confirm the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e0b2a755..468fce70 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1608,6 +1608,35 @@ test69() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test max_open_zones and job_max_open_zones do not error out for non-write jobs
+test70() {
+	require_zbd || return "$SKIP_TESTCASE"
+
+	reset_zone "${dev}" -1
+
+	# Write data to two zones and make them open
+	run_fio_on_seq "$(ioengine "psync")" --io_size="$min_seq_write_size" \
+		       --rw=write --offset_increment=1z --numjobs=2 \
+		       --group_reporting=1 >> "${logfile}.${test_number}" 2>&1
+
+	# Confirm max_open_zones=1 for read workload does not fail
+	run_fio_on_seq "$(ioengine "psync")" --io_size="$min_seq_write_size" \
+		       --rw=read --max_open_zones=1 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+
+	# Confirm job_max_open_zones=1 for read workload does not fail
+	run_fio_on_seq "$(ioengine "psync")" --io_size="$min_seq_write_size" \
+		       --rw=read --job_max_open_zones=1 \
+		       >> "${logfile}.${test_number}" 2>&1
+	grep -q 'valid only for write jobs' \
+	     "${logfile}.${test_number}" || return $?
+
+	# Confirm max_open_zones=1 for trim workload does not fail
+	run_fio_on_seq "$(ioengine "psync")" --rw=trim --io_size=1z \
+		       --bs="$zone_size" --max_open_zones=1 \
+		       >> "${logfile}.${test_number}" 2>&1
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.47.0

