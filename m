Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE5A1B6D10
	for <fio@vger.kernel.org>; Tue, 21 Jan 2025 08:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737448764; cv=none; b=mHDdALByCIVrPomsLOgdJxN8mRQSJwYGZfY2aMrNZXQLW58MMZCg47LnOLSWo+mjZw1tUtF/aSaZ9iUPa66gg8/wpSzQtrq/7TDFXq8oCoMUnPMakugFSLzTIv/R37efOzbj/cR0FmnOEnD3V9EiWT8Lqc8agwki5EffQd6+qHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737448764; c=relaxed/simple;
	bh=0tzGRx4/wJvb7KCprdmlHJDNw/vRUbIzqXbOAa1SdRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/J7fPMCE7SILLeBkUOM1joxZZIhkRzdhcC4MhcmOJDMlIW9YHvkm0ohzzV+zmQzqJ3hM1MtGr0/hmOi1boOQi2lEzntNxA7aWTcqdQjyClaE5+WPnHZeBdbOQ6mgrV1xLfbG8JhT5RtVyfnDZQI5ONEG1vD2zlgJ83qb+t0w2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PGjJWEsp; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PGjJWEsp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737448762; x=1768984762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0tzGRx4/wJvb7KCprdmlHJDNw/vRUbIzqXbOAa1SdRU=;
  b=PGjJWEsp9zUxMtMM+V6hsJFH+8+39iKDUOwtno5XrNm0iCOa6ZFOLlCo
   0FKoYaNMHaTsHY65stHg3TPDktm3N34PGhuw0/gJ4UsgxZnuyza+r/bOf
   ZCa1hj6cyZEPhD6RXbbJWVBKmboEkVGsgP4t0MPTvdwZY1s/TDQRVGJAK
   1IDh6KsV3RANewZ94AIfx1ipCcudSWWJBepVmHDly1vEyHNci/LxdrS+8
   E/4ZwF1ulNp5cjp1TdJuZ9EHyMYYsxPC1yWqEoJtZBeOZdDmZ1hH8T0KZ
   wjnelQ5G2FRGN4eFIkiu4vDKnhOdSgwR40UxDmv4Qy/MLa4BO6fz8TtjI
   Q==;
X-CSE-ConnectionGUID: z8pmv3oXTNmfHRdkCKmkgQ==
X-CSE-MsgGUID: 0jDuTIOXTcuxPZoTT4db2w==
X-IronPort-AV: E=Sophos;i="6.13,221,1732550400"; 
   d="scan'208";a="36408681"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jan 2025 16:39:18 +0800
IronPort-SDR: 678f4fa0_umE7xVcAjE29qd0By2weizlpYrXrR3hF8Wdwp7RsbEf338l
 ZfaQ8AiLwv7MALhi9TrgtwL44mhVtMrwLaKLkcw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jan 2025 23:41:19 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Jan 2025 00:39:16 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] t/zbd: add test case to confirm no max_open_zones limit check
Date: Tue, 21 Jan 2025 17:39:13 +0900
Message-ID: <20250121083913.1216619-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
References: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
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

