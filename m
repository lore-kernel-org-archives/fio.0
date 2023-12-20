Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F304923C0
	for <fio@vger.kernel.org>; Wed, 20 Dec 2023 00:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="I+QHBbxt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1703033935; x=1734569935;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aPnIWNfYiQmpbuxIqtruF61S5fRnyhI+bcu74zczkoo=;
  b=I+QHBbxtwmc10BwQfmPi1YczyMcwKy+5JXLAo6fYPJS6W9nsxIV1tJ+g
   KV8SemzdWJmsYH2f+pYEkZdprFQ/WyLkC6SjfaRhDSKYiApOhlx0kshxs
   wn5iIRSfJx4MplPeYdK4ODf/RW90HqYuQU50jseSHpSaz43b7/deJaBM7
   21ZpjN7yitb4Sa1dv7miOdl5dVmky3JtR5lxLqEQnxdTCxPDb83lpV3tw
   MKD8XpUeBtux+ipI4byz4t0flVPsIDzr614aRXjMz+9xq8a5D7DVuG9OH
   udPD4CYlY9GjTzrffC13v+cY0L/BXyPgkNH3ckxsq+NjZrH1rxLz6jAke
   Q==;
X-CSE-ConnectionGUID: IupJ/2nbTmS/HI1WJ0bn7g==
X-CSE-MsgGUID: lT4iKVjLR4uZoD6/9UlG8w==
X-IronPort-AV: E=Sophos;i="6.04,290,1695657600"; 
   d="scan'208";a="5634729"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2023 08:58:47 +0800
IronPort-SDR: chS+M0ktwmHmwPKj6RQw3lkXL0HBChKpa6Ouu4P7E+lAgjgBqstLnBu0/5ds6DcJYgTPu8UOPJ
 R7RP6u4qSACw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2023 16:03:52 -0800
IronPort-SDR: Pr/cDatyGPcfjX/BzDF6zVNedZ/Qm5FRie+nNTV5oSI4mge7K56RZCDpYlsivcVFwkedjwOS8V
 k1jsaIHTjRvQ==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 19 Dec 2023 16:58:47 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] zbd: fix unexpected write with rwmixwrite=0 option
Date: Wed, 20 Dec 2023 09:58:44 +0900
Message-ID: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently it was reported that rw=randrw issues write even when rwmixwrite=0 is
specified under zonemode=zbd condition. This series addresses it and adds a test
case to confirm the fix.

Shin'ichiro Kawasaki (2):
  zbd: avoid write with rwmixwrite=0 option
  t/zbd: add test case to confirm no write with rwmixwrite=0 option

 t/zbd/test-zbd-support | 23 +++++++++++++++++++++++
 zbd.c                  |  3 ++-
 2 files changed, 25 insertions(+), 1 deletion(-)

-- 
2.43.0

