Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDD4158851
	for <fio@vger.kernel.org>; Thu, 18 Apr 2024 09:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713432159; cv=none; b=fS0ms9bGJykJ6GpXZiu4kgDcuc4ppUkPay8PHbYET8UyypxtniAE2wmDGSG5odMHHc0Fb7GR9YZiih3B8DLfVA2ltge3gY6b4ywYM6hz7Rj2X1sqD2mhfocgkiUEwhXsuiaDoxEcOjy5EiTDzJ9owLsWZbTNv6TImtPQr26llZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713432159; c=relaxed/simple;
	bh=bb+c1pJwqkmI6YKYTmMkJbH7TNrSbw3YZr/g8g/GqEI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=UMxYBNQEUxYiblHfQKlb3n7ZS9kMfvVIIVYhHTxoCo73jkVUvbBcJ1CoVepAg+nLc74HlL1GFKGUkqWyd0uKYmlJslEOryXCAs1/6xPl57BgXFayEOw6PW+1DUZWSr+PfNEwTB+2D+yzAl52JJ70LEkWTO56m8NQ54ixet/In+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=p1krOa+p; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="p1krOa+p"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1713432157; x=1744968157;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bb+c1pJwqkmI6YKYTmMkJbH7TNrSbw3YZr/g8g/GqEI=;
  b=p1krOa+poXUAS486hZHUgq61SfdNwsWrfQ1S+yFmdaol6JE5hF+tjPyK
   xsXt6Zc02IOGv0s3ptBjVsNfzyf81boawSrtp3bBZnT8CzhA8yQFGPxss
   7E/ED1fZYAzpHi+uBJMe0EYyZ3pBWB3CptzYf5Tw+HZ9kjRr/N49aAE2t
   rZ1WnaiJl/B+dBaRi1l5fvzsSVzBnSFYJQ236F69fB4+Bumf7pfkfLljo
   vqzbsBwt28+48Ed/NtGvblJ0yBhvGjtV8qSdRAL+pEYEh1SxS1sRY2i9F
   nVCLmBt7Hjrg7m5Ex1S9RmgI6tX2yg+QEDPOkMXdGVI2o9UOUtxKojTLc
   g==;
X-CSE-ConnectionGUID: F8thFkGjT/u5rpftKY58/w==
X-CSE-MsgGUID: Aej3PV8HTQGwWcrxXYH8Ew==
X-IronPort-AV: E=Sophos;i="6.07,211,1708358400"; 
   d="scan'208";a="14299558"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2024 17:22:36 +0800
IronPort-SDR: CuBnpKRmA1xoZA41uESImAWaciTMFRcoeaNsZBqDuO1z9h53VnWNHiHcWS/7otNtRAdGdouBun
 86s2mC4g2bwusil8sARrOPwq/UmLG9BV40aAjLcUg4ZLIXydd5oD+tflpt0szZq0kGvB0fucFs
 abIDYtT9+nit9JV3z7r7L7scA6z+xfLXEnBaEYkTnlU+hMV/KNCxPGzvC+PJ+hao+v1bIKcrJx
 5a9tfMwhoCFcolHwXPV+ggscrbuAH1Wxqyeqdufzp7UEL45gwiSNbF4ybDsqaFc9kf3d5rXpX4
 5p4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2024 01:25:13 -0700
IronPort-SDR: WaGn+eZMNhjxh46MGwS4h+h/K0AcLIEP3b2Js+vpdBufNE8YmWRsndGLekLdtRR6XLWMJyN1wh
 99WtvKnIsJ+v/2KDDCTSBPK3oW+IbyOQeXjAjBeCuSB1AgSq9eh/aPSGJnEAbqOY+wmu3lAQNz
 azK5+lPJTgz1yc19Jdui8pRnY2c9afVJoaai6KBNcRZ7XIVVWMJUkj8N5StTdPehGH+D1RzwCt
 dJQcCa+d8wp6Ic/jo16rZN4wpWauuJx1zqkMRBGZ6yypu9Lenocc3npLFCL6J6ddsQSSuMs+8z
 7L0=
WDCIronportException: Internal
Received: from 5cg1443s5d.ad.shared (HELO 5CG1421G2K.ad.shared) ([10.225.32.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Apr 2024 02:22:34 -0700
From: Chana Zaks <chana.zaks@wdc.com>
To: Jens,
	Axboe,
	axboe@kernel.dk,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Chana Zaks <chana.zaks@wdc.com>
Subject: [PATCH 0/2] Fix bug with rw sequence offset and io-size
Date: Thu, 18 Apr 2024 12:22:20 +0300
Message-Id: <20240418092222.20543-1-chana.zaks@wdc.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In readwrite mode, when io-size > size, we break too early and start
looping the addresses too soon.

Chana-Zaks-wdc (2):
  Don’t break too early in readwrite mode
  test: add test for readwrite issue

 backend.c                 |  5 +++++
 io_u.c                    | 11 +++++++++++
 t/jobs/t0032-43063a1c.fio | 12 ++++++++++++
 3 files changed, 28 insertions(+)
 create mode 100644 t/jobs/t0032-43063a1c.fio

-- 
2.25.1

