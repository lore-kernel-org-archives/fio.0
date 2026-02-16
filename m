Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04B728FC
	for <fio@vger.kernel.org>; Mon, 16 Feb 2026 08:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771228847; cv=none; b=IQFaJJMcVukD+aoqweANL7W0dCBsHHFVKEXI6K6CCbfatH4A/+monVtXmJwyAktiUSgBhlIijqFaI5w4wyD0UL+eBaN3TH0CSpz/58BOU552GZ/xPaPsEIqxG/NSlal/jNuLr37iCTngAG+IMKSjbpORjuoOlebjDC1NF5lFZHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771228847; c=relaxed/simple;
	bh=V8OnJtX3eAH2ckGvgGH0hCposlQM+osyZr7ErYgEB8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ubXwFgghn7dyBBe9x8KtgQ/soDj6igy/xZ1lm8Sjg1d4apyyJnZbn3B9gC31RcXODH8bMd1kSOX7vWqmU4kpPzvY9vZu5kSmFt8HxpiLWIIhKuFZ2buTMO0LkA5pZHPVNkRDOkyC7sFdvsKQPkuB7Kx5DgIKpPe1hjpjtNx7vOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GdvnYwjd; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GdvnYwjd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771228846; x=1802764846;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V8OnJtX3eAH2ckGvgGH0hCposlQM+osyZr7ErYgEB8Y=;
  b=GdvnYwjdptSVnIQNuH0BCYeoUP3rjeBeFRKbxgk/ChOA1UnL2hMZqWU5
   2ZdmiZeJeBd8DD8DJR2TLNYFKzvavB26WJZpz7uraKTMaya2CwHYrOjxk
   rQYiA3n+9TFKydKY5UdHSITybYtxT4BJq/tCfkSf0B526mcMlrhnwGB6t
   H9l1dmSi/ciaYMNNjQzGw4SBDvhtKQOq3g/R+KmGf9a+G1TNR0mo20Bz/
   Wa6ebnedZDblR1Yot2jmINxh+TuofAWMqxdFKMA4eaYL1F+IT6SAl+3Yq
   xwBC9XuaqAjAZdBGgNTV8jvPF81ONIn/NQCNm0zB8YUJm4BwSQ3esm0Bf
   Q==;
X-CSE-ConnectionGUID: LL4wwVkVQFOcNivJcyntGw==
X-CSE-MsgGUID: Ww+SE/kHRViqlfhiZVXBRA==
X-IronPort-AV: E=Sophos;i="6.21,293,1763395200"; 
   d="scan'208";a="140812870"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2026 15:59:38 +0800
IronPort-SDR: 6992ce6a_Qtv2IlflBPYT6foXfWw0n2M2e4W9nsLr3MzCJ5laK/eezWu
 ACGb6cPO75OHkNoGJeRg1C0/j+XUfdQsboRad0g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2026 23:59:38 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Feb 2026 23:59:38 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/8] zbd: fix problems of random write with unaligned block size
Date: Mon, 16 Feb 2026 16:59:28 +0900
Message-ID: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
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
 fio.1                         | 25 ++++++++--
 init.c                        | 13 ++++++
 options.c                     | 10 ++++
 server.h                      |  2 +-
 t/zbd/run-tests-against-nullb |  6 +++
 t/zbd/test-zbd-support        | 45 ++++++++++++++++--
 thread_options.h              |  2 +
 zbd.c                         | 87 ++++++++++++++++++++++++++---------
 10 files changed, 185 insertions(+), 33 deletions(-)

-- 
2.49.0

