Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35BA264605
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239118; cv=none; b=glFuiqkbCrWLCswZpuhb0PCVgyjTvaHQiayQcubomHZmbqsmixf3zQrcuPSJ0IOPhTDknGF3U/yuvZ7kQeP3cbI58kI+lEd7M76nyq4OH4kyu3vouugmvdjwpjE6SbtWQc9EAY+OmRnPs0d3+3vPSx9rjbunrsu8pKBu+kKr88U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239118; c=relaxed/simple;
	bh=eQN7JtXj1A+snSzasn0zBcZu5Ilb65lWA2CdYK7vLag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jffHHO0KHI8EuYOPEZxjmq2C2ZCJ9+h7N6ZpnUf1T79xns9qJWFZrVPcwbzryWaTIusAxdZRyG8tobuVAyMqhBGQuybCFiNfeDcC8A8WHW1QmuiIBegOnjWDRnUHdK+mL+K9GbBCwXk2IAxKEbK3/LO9jxnMJ/vJlKgpqEEvgTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=j9BfAgwg; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j9BfAgwg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239116; x=1776775116;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eQN7JtXj1A+snSzasn0zBcZu5Ilb65lWA2CdYK7vLag=;
  b=j9BfAgwgo4M6bAUcN3JRIjsM+/XxgbZ1A/hoDQy2vTc1zQYlyYxd0cJe
   z3pr9SeKDWYbxdqMd5hQlnM+64KSZsV3htF9CqtAYjnObS6upBBcBvY6u
   BcqPLu48W/K83ApSY6fKhuaomnKaehQNAWjwiwhQCnTyiBzbYaachqjz7
   /R79c3nErIuBB3eKH5jZSUqy5UQWrRC9UidMJhz4S+WqPWmS4SOw/2r11
   jo1lLOA5pBWA1yPxVVsWlX/VhjFQA5c+GlHvcxdGB+VN5PfLXGMhjeZ1k
   /8bqVUH1f5whKr11DauK5a5LX1z/S0fpUEDgK8ES4ktu2Hz8sg5IJdRjW
   A==;
X-CSE-ConnectionGUID: CSPR0jmYRcm9SpVAIspWDA==
X-CSE-MsgGUID: URTuKMmRSTysnd7rq+n7Tw==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027513"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:29 +0800
IronPort-SDR: 68062e2f_+qeIvNCE+FtUUpJxpy7KGAM+MuyZYhJ98cn2oPE0E5FWLfb
 rds0ABVTDzLSN80FrLEEMBrxQTGKp5UznzJCrrw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:23 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:29 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/8] zbd: support continue_on_error for zonemode=zbd
Date: Mon, 21 Apr 2025 21:38:20 +0900
Message-ID: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the continue_on_error options is specified, it is expected that the
workload continues to run when non-critical errors happen. However,
write workloads with zonemode=zbd option can not continue after errors,
if the failed writes cause partial data write on the target device. This
partial write creates write pointer gap between the device and fio, then
the next write requests by fio will fail due to unaligned write command
errors. This restriction results in undesirable test stops during long
runs for SMR drives which can recover defect sectors.

To avoid this restriction, this patch series introduces the new option
recover_zbd_write_error. The first four patches prepare for it. The
fifth patch introduces the option. The last three patches add test cases
to confirm the behavior of the option.

Shin'ichiro Kawasaki (8):
  oslib: blkzoned: add blkzoned_move_zone_wp() helper function
  ioengine: add move_zone_wp() callback
  engines/libzbc: implement move_zone_wp callback
  zbd: introduce zbd_move_zone_wp()
  zbd: add the recover_zbd_write_error option
  t/zbd: set badblocks related parameters in run-tests-against-nullb
  t/zbd: add the test cases to confirm continue_on_error option
  t/zbd: add run-tests-against-scsi_debug

 HOWTO.rst                          |  11 ++
 engines/libzbc.c                   |  28 +++++
 fio.1                              |   9 ++
 io_u.c                             |   5 +
 io_u.h                             |   3 +-
 ioengines.c                        |   2 +-
 ioengines.h                        |   4 +-
 options.c                          |  10 ++
 oslib/blkzoned.h                   |   3 +
 oslib/linux-blkzoned.c             |  29 +++++
 server.h                           |   2 +-
 t/zbd/run-tests-against-nullb      |   3 +
 t/zbd/run-tests-against-scsi_debug |  33 +++++
 t/zbd/test-zbd-support             | 185 +++++++++++++++++++++++++++++
 thread_options.h                   |   2 +
 zbd.c                              | 162 ++++++++++++++++++++++++-
 zbd.h                              |  12 +-
 17 files changed, 492 insertions(+), 11 deletions(-)
 create mode 100755 t/zbd/run-tests-against-scsi_debug

-- 
2.49.0

