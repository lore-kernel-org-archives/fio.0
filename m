Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191B179F0
	for <fio@vger.kernel.org>; Sat,  2 Mar 2024 08:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709368592; cv=none; b=tl5srWG91jA9WIICzmgrK6SQay1XPK/KZ/i4/PFjiAeuhVH37K/dUscY76JH7Lkx7QaAoDLIBjq3iLTt7iMCKfgfwtV9sYVIjxCw3cMcLWwgCxg08TvC3hCTblWii1l2hKCBOshrynKrEerPNtI9xb/+6OGKvy3DKdnasDDoiow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709368592; c=relaxed/simple;
	bh=6b7gWtKOam7v3i7vgoE/k1vVZ6Gm1zXxfIZuFInRYm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NXTDnLefZigzqBLnqk+0Ff95A+zpO7q46EGN/nfxcNryHIQYSN/hWgWMlT+DBZ1Y2p2vASiM2ODIlexcVDhKw8o8AKqZcgDGuZy0NqOMr9NIWY7mJM2pLcnKqEWUZIu/vJ/Bv+Ah+ThEqiq4nb0SH26Il3GNybPFgx3w3qOphuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=evAnMag2; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="evAnMag2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709368590; x=1740904590;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6b7gWtKOam7v3i7vgoE/k1vVZ6Gm1zXxfIZuFInRYm8=;
  b=evAnMag2di96WrTRRPO3e9N9G6IFH0MmIXi1dvfP/WVT46sEoXiB8ZRs
   QQg7CQIPCPE0FzczlPsQWSx+1rNYve6Ug3p2nXoq6szjpOGRalt9rkvcF
   WQX6cTpFG4vi8SOHZM54L1IfSDQOEEGXVdh6nW81liKDk2yvECiFb6SLu
   KTwNmLY94ETe2NxYhr3lZ2WenctCbFbhV9V9Z2Yq6XS8r7/Cuplad39/8
   g7UdsdWNGa3G6FZwloVacDa5+enfiVvEOex2fw0ez2rIEN70C0JYjBcm7
   rIro90vwmSa6ELIVJk4Sr1yREqmSrw+PKppev4NvtfXayureWvcA8FLMa
   g==;
X-CSE-ConnectionGUID: DiG/jYOnTgyMvL75H+GdJQ==
X-CSE-MsgGUID: Bj/x5k2dSCqQBtU4QliDPw==
X-IronPort-AV: E=Sophos;i="6.06,199,1705334400"; 
   d="scan'208";a="10641720"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2024 16:36:28 +0800
IronPort-SDR: Ac3XxP3hovSDrN7awcmbv9D+2m5h0QwKPsrZm6+p4iomVF8zdeaFNqXtoblx0CzFkeQNcc1Pa8
 Z4B9txblgL2w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2024 23:45:43 -0800
IronPort-SDR: 4/QrvF9OF+3e0OLBio4Hvf30SSU4PXlk1MFpSQ9Z1m4i++ljImns7WQYv9lg9iI/H6uVG1/8ne
 Ge8uqzERVppA==
WDCIronportException: Internal
Received: from 87h6l33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.8])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2024 00:36:26 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/6] Some minor cleanups
Date: Sat,  2 Mar 2024 10:36:07 +0200
Message-ID: <20240302083613.602-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mainly fixing typos, style issues, etc.

Avri Altman (6):
  fio: Some minor code cleanups
  t/jobs: Further clarify regression test 7
  t/jobs: Further clarify regression test 8
  t/jobs: Rename test job 15
  t/jobs: Fix a typo in jobs 23 & 24
  Doc: Make note of using bsrange with ':'

 HOWTO.rst                                         | 4 ++--
 backend.c                                         | 4 ++--
 eta.c                                             | 8 +++++---
 io_u.c                                            | 3 ++-
 parse.h                                           | 2 +-
 stat.h                                            | 1 -
 t/jobs/t0007-37cf9e3c.fio                         | 5 ++++-
 t/jobs/t0008-ae2fafc8.fio                         | 3 ++-
 t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} | 0
 t/jobs/t0023.fio                                  | 4 ++--
 t/jobs/t0024.fio                                  | 2 +-
 t/run-fio-tests.py                                | 2 +-
 12 files changed, 22 insertions(+), 16 deletions(-)
 rename t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} (100%)

-- 
2.42.0

