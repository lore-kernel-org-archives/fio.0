Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD1F58101
	for <fio@vger.kernel.org>; Tue,  6 Feb 2024 10:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707217151; cv=none; b=qo4O3k61lFrJ9RInEbTQMUqmuwCUnQlfl4KhgXdI3TX5feJKhn4g4fOhOIoZed8LzI9qLP2kawCLOeunNjeCShtWOWmRHYDoVnVYQvwQICZLeaph6klTXhrSbzdWpnNKoDf87+hpWnYHjfU5ImrIuLq6/egqOsUV0+CF+FgAYG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707217151; c=relaxed/simple;
	bh=A0SA20US5mXuhVGTwMl4LX+yUYz6/NZYcJobfsOIo2I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rY2oeultIauw+LW2G5zrp6XP8Jr4UQQKUwg/P+blBeB/mATXWuxcOcMaPopS20P1ZdbwsN4e3fVIyr2fYvJQvr8HZEvAuA5ggOUAhAYygr5odNySJyR3LOIzhbMlSEesb7x4a6A/Y4XMcKeI4Uj7so+F6BmoOyiphyQ5od0WzaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bcmqO25u; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bcmqO25u"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707217149; x=1738753149;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A0SA20US5mXuhVGTwMl4LX+yUYz6/NZYcJobfsOIo2I=;
  b=bcmqO25uEn0QYyo3nNoSSPWaU9mKnyM8wDk1QRTGZFxv37OeVAu7/eh7
   bDr8zpVLXpXqOYJijR+bBV/XZ4esKxY1kawnu7rpMeGQ58+amdgC9jv41
   bu2Z2Wl47aw/PN/3uaPfRz6KPhLX96CGfNH4say72Jh8CRdrHT7SJ/PrS
   BEnyicY5Hdi7L+tyabLgtEt2V3ry3Ckvhfr3OkLa8dm+W6UQ37x7tzIN9
   ZjoakF4C1+HtamMX7MdvG4MroPjGCXgcw2h2KY8tYquteRSpXyCOiiDzg
   8N2Ek/OON642q3bO6Ju68ap/NiC/jQJtoGui9/66sX54xXxfKD4HhupJp
   w==;
X-CSE-ConnectionGUID: Z+/fcxGeTfawcvPlhjuzUw==
X-CSE-MsgGUID: dFZ5vUn9TSqeB0ifl7Kltw==
X-IronPort-AV: E=Sophos;i="6.05,247,1701100800"; 
   d="scan'208";a="8663342"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2024 18:57:57 +0800
IronPort-SDR: KyoTzIWSg55mvmt22y3ygHqjjGleDEirX6CZJLsJi7m+cAE2csSqo+BSeWL+rhfQ6gUz8mFtJx
 78lRgpLtQKzA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2024 02:02:02 -0800
IronPort-SDR: zAgcpDR1sqYX0qn0SeyVKe0JE50aA+woDyJLFq5MiP8sn2iEdPyah+Lt9wP7OBw2/GcFrAluVp
 xCdBzJijOu9w==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2024 02:57:56 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 0/5] zbd, t/zbd: miscellaneous fixes
Date: Tue,  6 Feb 2024 19:57:50 +0900
Message-Id: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains a few patches to make improvements to fio support
for zoned block devices (ZBDs).

The first patch fixes an assertion that has been reported in the field.
The fourth patch fixes a failure that happens while running the unit
tests against an uncommon class of ZBDs.

The rest are clean ups and some minor feature additions.

v1 -> v2:

 - correct the commit referred in the Fixes tag in the first
   patch (Niklas)
 - edit commit messages to make them more clear

Dmitry Fomichev (5):
  zbd: avoid assertions during sequential read I/O
  oslib: log BLKREPORTZONE error code
  zbd: use a helper to calculate zone index
  t/zbd: check device for unrestricted read support
  t/zbd: add -s option to test-zbd-support script

 oslib/linux-blkzoned.c |  2 ++
 t/zbd/functions        | 22 ++++++++++++++++++++++
 t/zbd/test-zbd-support | 20 ++++++++++++++++++--
 zbd.c                  | 21 +++++++++++++++------
 4 files changed, 57 insertions(+), 8 deletions(-)

-- 
2.37.3

