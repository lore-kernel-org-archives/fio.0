Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFE020E6
	for <fio@vger.kernel.org>; Thu, 21 Mar 2024 03:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710990621; cv=none; b=VixEg8G0ITmLv7HZrAVt8+I9+MmVTFfnM/29Z6VqDO/6yA+GfPJ2tD/4skDj66ArJ9P0OpZz+i7Aw75+UGQtSMf19dOJ5qB/ay8+EOMJ/PczISLyFcIa+MW/QqUxaiR+AYWVacj+/cHtfV4+sSCrAr5wxPUxWho2YZ7hDpCyPGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710990621; c=relaxed/simple;
	bh=Z8XQpL1Al2g5HDLmtdN6QjdMq79cFCvi0zqFXy/CVjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q1gjhbDLAYmLEe+Jo/Bdvd61XMfi+zYvs7HtDwb7iEUqrW9dhHuOPaagUWVENmVXp+MnB//1ygYXd6XDd4bp2W9I9jBz9Wz7yZF4xojykNx70osm17KRi0yQPSwpgX2K5nx3vslvW4FLCGNFl7r05j24hsnDQtkjuQoComVo6RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GbllCCIc; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GbllCCIc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1710990619; x=1742526619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z8XQpL1Al2g5HDLmtdN6QjdMq79cFCvi0zqFXy/CVjA=;
  b=GbllCCIcrj5B1YDI0C4xFR0z6kiGw2HvR1uN86cjDcU0xOslhMGD1jLE
   SXlDlBMQyIiKyhE2EYiwS8Usd4ORFPMFaNbIEfZMxtyax8b9vqRuSgYLp
   wYiXFEhU3bnEz3BmKCDrWrg7+MbG2ZuH+MKug+AIQxpLPi5/Byx9cXjtj
   oV3+G6MhKHD8Timi8xQYRpE3uVV33GO5LMafp2wSyl7cNM4Y9pWLZj5no
   G1m7LS5QKqUzArz7aLX39mLnGInvLIOZTzAA3Q7UmJaPX3eDOf92T8MFG
   pSauwsquScxNC9pYTPqaYLthds0+JXuNshWW9lnxhdPyWeYdBk4q4+cKG
   g==;
X-CSE-ConnectionGUID: 2sXhLl3dQLKPqmoDbJuh4Q==
X-CSE-MsgGUID: ZQYELG/CSnKjeoLcm3DVQg==
X-IronPort-AV: E=Sophos;i="6.07,141,1708358400"; 
   d="scan'208";a="12730326"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Mar 2024 11:10:13 +0800
IronPort-SDR: EfICjjLHkTGsKd+5Xz2/tE/2XMBBC2pPXTyeoIrZgeHgSfE45uBoCA8cm03t43G6ODfQUtdeJw
 jZP+dekfMtNA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Mar 2024 19:19:05 -0700
IronPort-SDR: nrYuUT1sDrpqEY6E2pXLs3zl/Aa/YtvWAPfBFFEtdNH0Pwt5Opf2+ml/yTy9LRAznonMlDvxCs
 Q4sNCiqa+1Mw==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Mar 2024 20:10:12 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Kookoo Gu <Zhimin.Gu@solidigm.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] fix assertion failure with asynchronous I/O replay
Date: Thu, 21 Mar 2024 12:10:09 +0900
Message-ID: <20240321031011.4140040-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the commit b85c01f7e9df ("iolog.c: fix inaccurate clat when replay
trace") in fio version 3.36, asynchronous I/O replay with log recording
options trigger an assertion failure. The first patch in this series fixes
it. The second patch adds a test case to confirm the fix.

Shin'ichiro Kawasaki (2):
  iolog: regrow logs in iolog_delay()
  test: add the test for regrow logs with asynchronous I/O replay

 iolog.c              | 2 ++
 t/jobs/t0031-pre.fio | 8 ++++++++
 t/jobs/t0031.fio     | 7 +++++++
 t/run-fio-tests.py   | 9 +++++++++
 4 files changed, 26 insertions(+)
 create mode 100644 t/jobs/t0031-pre.fio
 create mode 100644 t/jobs/t0031.fio

-- 
2.44.0

