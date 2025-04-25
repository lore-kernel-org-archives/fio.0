Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3BD136E37
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 05:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745558512; cv=none; b=FayYrjgWqP6B7PJf2eCh7lBcpprBFcu3NH5pUh8bqXVbYm2fJJe0Noo6fXcXe/HI5eljbn2LxHbddS0D60xwW520K2HGklVpkT8ii3TWindt+IsRfVcjlnd++oA7aAzVD+z+N6XSWFv2JTP6bI8emq4/F2yk3A225/FaObQvfuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745558512; c=relaxed/simple;
	bh=qNLjm/jExJkhBhoXGf9v+bGKRw+6JuWS29SdnzUCecc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wfvg+lJu382lB6+0C8YDu0wMwvcoeQthw3Ew2ilZ+vmUHsXihqYCSD7UPTcDsiI4nJbaUEMkmpxeVTfe0zXLB8KoXufP4HCHJAC0B/rP75xQbo3kEFFKaAOIfJJa7NAx2YLyaqfGI8EQSjqqhJ5ZgQRtPaC0P1g/xZ9LDrYnZxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F11LzQFd; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F11LzQFd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745558510; x=1777094510;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qNLjm/jExJkhBhoXGf9v+bGKRw+6JuWS29SdnzUCecc=;
  b=F11LzQFdiDe+y/DYqiKcZ7po56TGVOwfnZ1s/eYNQgTXXmPnv7EL/kLF
   nkyKMP1DBEqQI8DqhwK8AsoeciPnlonJdPJ8HPZPzKEEJrglmgVH5/702
   xeti/81FZlSObJ7F0GIhCccotBBK04b9mrlrSL2vgN206rjj7/3QPzBk+
   Fm0uHJss0YI1YR2FYN2IoNysmDToE4m9hTwBK9FAW1HLCaSr39iKLlxuC
   Zpo8HWPHhhuBx4UIjuU8sI9w9eh+f71PePILQoYVk9UxCDhSCi793JdDD
   1dEWWx0UviqA6ifvDqWRFQrqWb+0OGUW9oQK85OwMIg0LN4LhsPRRFj/M
   g==;
X-CSE-ConnectionGUID: gMNX2dTDQnCU61k3Hni3VQ==
X-CSE-MsgGUID: cxGv6DqdSMCUzTo6QhMcgA==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="82381439"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 13:21:49 +0800
IronPort-SDR: 680b0dd1_ni8kFfs56K0+6hkkS4+Zmzp+iArPyB1QLwIESkCRvp9m9K0
 67Ta5RMjhACYewousDfBM+nhn39LdDctgzsSR4g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2025 21:21:38 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Apr 2025 22:21:49 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/8] zbd: support continue_on_error for zonemode=zbd
Date: Fri, 25 Apr 2025 14:21:40 +0900
Message-ID: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
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

Changes from v2:
* 5th patch: Added the missing changes for the new option in cconv.c
* 6th patch: Noted the kernel version which added the new null_blk parameters

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
 cconv.c                            |   2 +
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
 18 files changed, 494 insertions(+), 11 deletions(-)
 create mode 100755 t/zbd/run-tests-against-scsi_debug

-- 
2.49.0

