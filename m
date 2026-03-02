Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30AA4A33
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418373; cv=none; b=AW0UQKqYofsEEkS1uXV76Sxz3GsvZHSN6X7Q6r03c1ObPFh2DKiP0vvMR7zOOrQA8S0uCwlQpTcH8X6b0My65UBQSTrB4bwiR6leB9k3LcUVwCvCV23hlJOTAhnFv75Ig75GAqdWV3whltn8l5HXo74j0MzMKoeKMIRmrD/a5SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418373; c=relaxed/simple;
	bh=yXs1wNdcidtsInW7gmfI4UJsEKhVDiqA20JKzGOgpvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UcS1O8RY+2oquMWtVsj9FW7bUjIy4wvLB17KqAzvnn8VlO3rOmtuvsinLHYPn28JI5luisI2ndTxI6J706U7eqqNLPSDCQpS8xRR9uM6Xt+RImlQu6UGVE3RDBgGePKjDNqXCQj6+T42CioZuTL9bagWqwozHyI/f8JbJXfH+tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WQCcIXR0; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WQCcIXR0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772418371; x=1803954371;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yXs1wNdcidtsInW7gmfI4UJsEKhVDiqA20JKzGOgpvw=;
  b=WQCcIXR0A3DZFs1ZRYId9WzJWOm7z30fz6eH7GrZBeI7MsWkoHLlSU4+
   vIpDaDQotPZ4mn6CN/qUY62Pu4dNNCvjNkjYj800Et8wqMKyCAvhGyBhc
   JYiG5eGlis1WUk++2D22iTQaQQByOX61l3AJCS+HkJlti6AOq941IIMLV
   7nTD72G7M68+vjCAqo5r4gYtJOpaZ2gAxsMtlYts1yAUqC5ZA+YKtWzkW
   TylnNMC45V2ysNR24E+FZZbZzdhk2sX7Y0eztVfb6pFaYPuyWPZGyb2N4
   ikKTzl76D6LVkuR5g+jsZa6pbZbwXvwYHHhuDrQc1FM4bRLePX5daVOil
   A==;
X-CSE-ConnectionGUID: HxjfHb4YTya03GKUh9WXig==
X-CSE-MsgGUID: pHmQMYrGTAe87fnj2yGi3A==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="141307933"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2026 10:26:11 +0800
IronPort-SDR: 69a4f543_pEW38ogq1XDuuFFB47+GshY46jPTMsSa5KEqp0evbeC++6i
 U1opA62HfImpILdt6mN9zuiv6ppgw3XYq0/4kpQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 18:26:11 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 18:26:10 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 0/8] zbd: fix problems of random write with unaligned block size
Date: Mon,  2 Mar 2026 11:26:01 +0900
Message-ID: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
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

