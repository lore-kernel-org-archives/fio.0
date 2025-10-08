Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10A514A8E
	for <fio@vger.kernel.org>; Wed,  8 Oct 2025 09:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759916931; cv=none; b=KrI3JhjtZb1wG1hB5zCt6C/p/lCXLgmi+OV759kWzxDTRY3jsjNUtXa79hU3nghq/WdrIGTP9KebEEO82WOJwbjlM/29OFM8CPRJV8CFIltGAKfM4uDHpag2I5t2fjpWhEUZZn3lqlkNVigsWfN34YxkJ7EwJdCDSwPkxHBbon0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759916931; c=relaxed/simple;
	bh=02CJrb3dOTcUf9H6y5+v0Nu0ZjtlMRJusWclJLID4Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J9qaYTb+OszyfYXvUlsd5heLuU9TTSoxSjcsqZFs1F5DbP/alrxdZsjLp7urm95E0VigOvxD1SdL698e+EvVXWuNwLMZoSsUwFDygT2NgETLgt6pIfWLrY58Jabr8zD1VHXBjtm3AKVrMj8raxNdJ04O/QwbHvwFfpAIVO2dFiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=X7GWNRqJ; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="X7GWNRqJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759916930; x=1791452930;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=02CJrb3dOTcUf9H6y5+v0Nu0ZjtlMRJusWclJLID4Yk=;
  b=X7GWNRqJF3d87+RvfAOY6JOVrJAAt/dgdBgh4H5h7L2W0N985Q+pG2Ay
   NTB2vkcfYQMbj+VRHAHue7qUwGqAmaRXHYjffEnX3KuU6s30GeyWVG572
   tA48XI41WCrgqvfzOdLnf9v0T31SfcVg0TEtWv9zfjfj5EuKhA6nfO7E6
   GTPgj+kC1956nv+G0qGMLE0ahwkqeKzqs/IjePEJ3DDSX60eTn9RE6caS
   OyZYKehTe/D1vzXxoLZTaJ7MBajVx2vzB75kb3Wumo/4MaPCrMxnnehsm
   rlOQb4zIdsO/ScoeF1i0ARhGBRPVDZiOLTicR7RndMqoakRupYII5ktqD
   Q==;
X-CSE-ConnectionGUID: +23XkZPLTbWMB9vBNF1r0Q==
X-CSE-MsgGUID: JsjfpaerRXSWxapF28cA0w==
X-IronPort-AV: E=Sophos;i="6.18,323,1751212800"; 
   d="scan'208";a="129836310"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2025 17:48:49 +0800
IronPort-SDR: 68e63381_xZVn1QHiOTw9souPQgzYaAwT2ezRpixmt3siTP3VAC3/c8d
 bAjfwfQ1S3UfGzXLX7eWaZ3Kwg9WXEaS8IPCrvw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Oct 2025 02:48:49 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Oct 2025 02:48:48 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] stat: improve zone reset count reporting
Date: Wed,  8 Oct 2025 18:48:45 +0900
Message-ID: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
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

Shin'ichiro Kawasaki (2):
  stat: report zone reset count only when zonemode is set to zbd
  stat: report zone reset count in json output format

 client.c |  4 +++-
 server.c |  4 +++-
 stat.c   | 11 +++++++++--
 stat.h   |  9 +++++----
 zbd.c    |  4 ++++
 5 files changed, 24 insertions(+), 8 deletions(-)

-- 
2.49.0

