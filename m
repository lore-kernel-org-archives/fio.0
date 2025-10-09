Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A7E7E0E8
	for <fio@vger.kernel.org>; Thu,  9 Oct 2025 02:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977572; cv=none; b=O14Qr333dIJDedZLRP2LgUFol65L/L9zPNxukBeWWcja1pyFmcIdejF5SEJ8ykc130MbLIzHhV6NudgPxBRZgZl9oEW99Dc/grnK3RWfT1VNd/oB29gV8oXo1prySIEW7cbXJe1mh0NDgy0LH8s2EYfitUT6UuF3rIpumv4+UHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977572; c=relaxed/simple;
	bh=mnZt0cNLrCytZmLPigiPz01ojOS9QB1YD104iMvlVeA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bQVu1JZ8twga/PT0Puf3g73ftc0LRZp+NDIOVTyoRQI7dXbwt2l8Wz8hZMVpN1bo2SxDAOv/mKx5IU3Y1yDs2TVAgVYsL0a5a0iqqaYcCxWBhOgnyDFQ0sMGnA05aLdQ90ViSbq7T0JsEbaItf1ol2N3s2afK/DiCm0te83s6mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BvwQKiHv; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BvwQKiHv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759977570; x=1791513570;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mnZt0cNLrCytZmLPigiPz01ojOS9QB1YD104iMvlVeA=;
  b=BvwQKiHvM1Gv77257Zx3vJCfh9Xsf33am/WRiefMXHzpx0l40R3WGigT
   UqjAXxIOunIEpTWZdgBKkPkJICIrqy/iJrghxZb8FF41fs4pLENI/bJEt
   RjRFBRggKd06F5VZtemWotYLjdfUItorAYb9K2/+n/+TcwxurMe8zy0hv
   9mLlhV1/jQUhBVVdPpomUVNXhVZg125OWW+rZwyv6tmAWRhgSkeZ/1uXR
   bPX5urXzXOfLsUQuiDYifo8YiCbiIoX3WCuppMwvdGhFPBlZfMvmfta41
   6IQXjPdBtHHNpcNggwjlNeP2fcyvYRWH/5bi2L6VBa4Yi8HQrdrOOk5nc
   w==;
X-CSE-ConnectionGUID: fgxW+ExKQOK7Fa7CiHRzbA==
X-CSE-MsgGUID: 9+PiANYYRFOfTxhQEv2e1A==
X-IronPort-AV: E=Sophos;i="6.19,215,1754928000"; 
   d="scan'208";a="132880590"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Oct 2025 10:39:29 +0800
IronPort-SDR: 68e72061_UgBJvzliSjrBAuUq4U0umAogKVmpxqLzPw2XKWalqgB1efD
 2kZefxfLe/zhD9TIwWbtJL+SB9daBatUKgmegJA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Oct 2025 19:39:29 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Oct 2025 19:39:29 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/2] stat: improve zone reset count reporting
Date: Thu,  9 Oct 2025 11:39:26 +0900
Message-ID: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the zbd zonemode is specified, write or trim workloads can trigger
zone resets. Fio tracks the count of zone resets and includes the
information in its reports. However, current implementation has two
problems. Firstly, the zone reset count is reported even when the zbd
zonemode is not specified. For non-zbd zonemode, the zone reset count is
meaningless. Secondly, the zone reset count is not reported when the
json output format is specified. This series resolves these two problems
with two patches respectively.

Changes from v1:
* 1st patch: bumped up FIO_SERVER_VER

Shin'ichiro Kawasaki (2):
  stat: report zone reset count only when zonemode is set to zbd
  stat: report zone reset count in json output format

 client.c |  4 +++-
 server.c |  4 +++-
 server.h |  2 +-
 stat.c   | 11 +++++++++--
 stat.h   |  9 +++++----
 zbd.c    |  4 ++++
 6 files changed, 25 insertions(+), 9 deletions(-)

-- 
2.49.0

