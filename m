Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE051E48A
	for <fio@vger.kernel.org>; Thu, 13 Feb 2025 05:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739424321; cv=none; b=eajnbzkPAzEZa2qrcSujhfdz554RKOfAbJeEGldFkRwS7UupW4uXLvAdjpcfMoSJ/vnOekDlBJyANPExdGAcynM76KQurUYIzW/K5uLd1GPHTdXUYz+hH/QrngC0ypN4VWC28S3zKsi7nmY0qVW2s77mpBpLRkGGzi0bUAmIU/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739424321; c=relaxed/simple;
	bh=TMlCbTJKjHBvbJmB03aGtJEC0rMyGaZ9YBFCp/d5PtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JRBft+tG5UvpwnbJtlh/JFpThgON9FlIh3ApdCRCqrwYEyQ0t3ZR983qMaob2UKNhTgvpizPmBOUPYO0yI0hSwjqOEMMll3wBYhJU36l8CxnYV5nxBuBHmATNTGu9OxuDLM959/AU+cQmQ+wS2VZoTQFRKdA3DNRtcXLF4UU73k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Xee1Tl1e; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Xee1Tl1e"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739424319; x=1770960319;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TMlCbTJKjHBvbJmB03aGtJEC0rMyGaZ9YBFCp/d5PtI=;
  b=Xee1Tl1eOjX6UQzCp4HpnaK+t+eplvP8c90h/4fxYWUj0mjM8vNCPWf8
   yJfKWA5J4MraGej1XSGoCQACkM8xpsYabbw+1QhH/Z5vaDGMqW4eVge9k
   0ISoAIHVWJ/o5JGdmsWGgSjk69BgHbRvceGtLGQs51K/K3vXEz9OFGrgK
   vHCEgqK+2MEM+ibrJjlmtBDigytw0r9a9nDiyicRxquzfxB/SuBOu3Zmp
   sa2U+ZvKmc74KDTFR+JhcWT1BLXXTXMsiq63Qxxcs09Nou7vZfRh2DOnm
   RGEMIObTbTqcRyDh9n5wdSMZoq/GMzEW1dbj2BdTV5NRZdeTBA64w+htV
   g==;
X-CSE-ConnectionGUID: BsCQ9EN1T32+E6kHTt6LZg==
X-CSE-MsgGUID: Me2qRmVZQNmQakSd+YmImw==
X-IronPort-AV: E=Sophos;i="6.13,282,1732550400"; 
   d="scan'208";a="38948606"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2025 13:25:12 +0800
IronPort-SDR: 67ad7485_ez/FoFKGpm1Xf2z6kpfy56Kzmpuji5N++pe+atqNY4SEpo2
 MPx25ICUxNhM2dIKa5ekpyy31Ubj3RstYmJae9w==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Feb 2025 20:26:45 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Feb 2025 21:25:11 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/3] fix verify stop for verify state of async writes
Date: Thu, 13 Feb 2025 14:25:07 +0900
Message-ID: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When asynchronous write workloads have the verify option and the
verify_state_save option enabled, fio saves the last write completions.
Subsequent verify workloads with the verify_state_load option read the
saved verify state file. The verify state file stores the last write
completions up to the iodepth limit. However, each write may take a
longer or shorter time to complete, causing the write completion order
to fluctuate. Consequently, the very state file does not always save the
last _issued_ writes as many as iodepth. If this occures, the subsequent
verify workloads stop unexpectedly without a message, confusing users.

This series addresses the problem. The first patch adds a message to
inform users why the verify workloads stop. The second patch increases
the number of writes saved in the verify state file to reduce the chance
of the unexpected stops in verify workloads. The last patch adjusts the
test tool "verify-state.c" to the previous patch.

Shin'ichiro Kawasaki (3):
  verify: print message when verify_state_should_stop() returns false
  verify: double number of writes to save completions
  t/verify-state.c: adjust to verify state format change

 backend.c        | 12 +++++++++++-
 fio.h            |  1 +
 io_u.c           |  2 +-
 t/verify-state.c |  8 +++++---
 verify-state.h   |  9 +++++----
 verify.c         | 12 ++++++++----
 6 files changed, 31 insertions(+), 13 deletions(-)

-- 
2.47.0

