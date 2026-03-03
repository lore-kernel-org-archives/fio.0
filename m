Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ACB36A025
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 01:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501524; cv=none; b=nUx6b20oi8iczZ29iWn2azEFbFdNrZhPpXhh9ziizKyrV0Eqor/fvq6mROVA69HB6uAH7oMabqnHSa7oyN6yM5DzrV6eChgXmDQNkyTtsaDUcIF1WO48gNFwfEu3vj0RCf26OjEsUxAK35Sfsocm3bmWv/OLm8FKZj3AKVjiH9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501524; c=relaxed/simple;
	bh=Ll6oFMG3VMPpxZcHpL1791adalHIUbA1SSWcu+lV3/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HN65C7qEn4StBnlMN14wHelkJqGIRqmcONHps/s2EejJpX52J8EkB8Bf1+8MOlTgsnGneJjNOifSsNoVdTNSV9QTpaaqtPMZcsQpOOiAX9xN1MFzVDv2KDX0CLas3xpm/Fch9LtEm2FdxXxbSF6duvQW6iFlTKXTTJszC6o2nPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GN6wZtCT; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GN6wZtCT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772501522; x=1804037522;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ll6oFMG3VMPpxZcHpL1791adalHIUbA1SSWcu+lV3/E=;
  b=GN6wZtCTHzRLche7y3nLGpv/Lat/2CrTc5xawHfeuIyLy8MbJDrCseEQ
   4ErJUOR63asYJpYQ56d0fb1BF8F0nFqyt238JufY7Pp3L/XNyqMRSan30
   BNTTYc1lpLtU95OI4RsNPFftZZfcHvBtAZjFVFlbGB0GFzRMA+zjqAOg2
   SSrBv8U3TgqyHKoeD+N1zyxjlWHR3iwrfEbh9EMPCffUNN0YAOxD4SiZe
   f8lqSRkd7HRlXlPI/2k9CgKwAptI7YWrWlvQLwvUEkiB276/6Hd6XN1Du
   0tHBrNhQ3UU8eKBhpC7vK7+RMjotYUJWfoTeH9jJXG+oXPycb/JyoJk5N
   A==;
X-CSE-ConnectionGUID: MGafBhrmTba3h3M8umcpbQ==
X-CSE-MsgGUID: s8p1vt4aRR6ugIrHd3gThQ==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140813506"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2026 09:32:01 +0800
IronPort-SDR: 69a63a11_YqEYe/A5NUVc3fRhQTUvjhHNkgIDsJcGqaLaeefEk3PcWoC
 7eBGZbgj93jGxg9WnymEX0kEThZs/IrwIynjPzA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 17:32:01 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2026 17:32:00 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 0/8] zbd: fix problems of random write with unaligned block size
Date: Tue,  3 Mar 2026 10:31:51 +0900
Message-ID: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When random write workload runs with zonemode=zbd and block size
unaligned to the zone size or the initial write pointer position, three
problems are observed. The first one is write target zone selection.
When one zone is filled by the write workload, the same zone is selected
as the next write target. This results in writes concentrating on
certain zones despite the workload specifies random write.

The second problem is wrong write target zone accounting. When a job
selects a zone for next write, another job might have removed the zone
from the write target zone under certain conditions.

The third problem is write performance. The writes with unaligned block
size leaves small remainder areas at the end of write target zones. To
free up the zone resource, current fio does zone finish operations to
the zones with the small remainder. Fio also calls io_u_quiesce() to
prepare for the zone finish operation and the write target zone
switching. These zone finish operation and io_u_quiesce() calls
significantly degrade the random write performance.

This series address these problems. The first two patches address the
first two problems respectively. The third patch introduces a new option
to address the performance problem. The last five patches adjust the
documentation and the test set for the new option introduced by the
third patch.

Changes from v3:
- 2nd patch: reflected review comments and added Reviewed-by tag
- 3rd patch: fixed conflicts related to FIO_SERVER_VER and the 2nd patch change
- Link to v3: https://lore.kernel.org/fio/20260302022609.3526823-1-shinichiro.kawasaki@wdc.com/

Changes from v2:
- 2nd patch: improved the commit message to explain which workloads
             remove zones from write target zones array
- 4th patch: reflected review comments
- Added Reviewed-by tags
- Link to v2: https://lore.kernel.org/fio/20260216075936.3318729-1-shinichiro.kawasaki@wdc.com/

Changes from v1:
- Per discussion with Vincent, keep the current zone finish operation as
  default and introduced the new option "write_zone_remainder".
- Dropped patches to remove codes for zone finish operation
- Moved "fix write zone accounting" patch from 4th to 2nd in the series
- Rebased to the latest master branch tip
- Link to v1: https://lore.kernel.org/fio/20260109023603.2848421-1-shinichiro.kawasaki@wdc.com/


Shin'ichiro Kawasaki (8):
  zbd: fix zone selection of random writes
  zbd: fix write zone accounting
  zbd: introduce write_zone_remainder option
  doc: explain the option write_zone_remainder
  t/zbd: add -m option to enable write_zone_remainder option
  t/zbd: avoid test case 14 failure with write_zone_remainder option
  t/zbd: avoid test case 33 failure with write_zone_remainder option
  t/zbd: avoid test case 71 failure with write_zone_remainder option

 HOWTO.rst                     | 26 ++++++++++-
 cconv.c                       |  2 +
 fio.1                         | 25 +++++++++--
 init.c                        | 13 ++++++
 options.c                     | 10 +++++
 server.h                      |  2 +-
 t/zbd/run-tests-against-nullb |  6 +++
 t/zbd/test-zbd-support        | 45 ++++++++++++++++---
 thread_options.h              |  2 +
 zbd.c                         | 81 ++++++++++++++++++++++++++---------
 10 files changed, 181 insertions(+), 31 deletions(-)

-- 
2.49.0

