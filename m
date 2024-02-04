Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146DF286A2
	for <fio@vger.kernel.org>; Sun,  4 Feb 2024 21:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707081408; cv=none; b=tGhLvtnB+u+PiUvSwQUngPvgC4PeYLAKaf82z8J3Drzn18fE2NeSczlHDWPcl+B/a3S8hOGl0YTa3VcY/prAM7uX9gMeHvMbfRODvzRGkwbpR7A+DnCwuBAcP+DmPbkwxaBiXBUWDUqF7wxiBh7MeAtmO4eH2xEbtgkbqg53zZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707081408; c=relaxed/simple;
	bh=BxrKpzpqgXPpdI/u9DIW9eEI5oucBt6UGov9JFGuJvA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=caMlqsQqjlaSzmJm4dh/OKc5W2SrQ2s8waA9UgweFCPnypOPLf5Va5O8ojMTci0fMKGwJde4ynN312opWU1BXvJmFLhnIdPCtfIr37U6xV5IK9ox+x0tCkJgI9bYZFQk+sKJBhxBvylUP0ZI9LErI76QUdXBMQAfegF5ZT0DZyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F6jMl9KG; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F6jMl9KG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707081406; x=1738617406;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BxrKpzpqgXPpdI/u9DIW9eEI5oucBt6UGov9JFGuJvA=;
  b=F6jMl9KGG3YiF276Wk8QjtgzHckaIlkvw5xWZOrliZ941KrmEjgO5BlB
   2W9tAYYIdMMmb9ANiexEfsC3H6zA2BDyTO7JixxrXd7EHWfETfmAppd5A
   PtZjjNpF2KtdvDPb0WAPY2EZ4wH92KsoIn07bsRXrQxt2rjSNrwjn9wQ3
   C9PsDFJsX+VXEcWN1qZTcqKKFQ6iRJumxZVcARTqkrMMiCs8hh+2DEdhh
   lMW75ODAlvBwmfRNaKWWKqKxSuvzXYEz+qJAvJ22mlt539jm+4RcXpdii
   nodvcNXvZJtqoFFnsiwU9a3Zw74uHZHK0y9deg4QuDeQsiwTJwl8kKg/R
   Q==;
X-CSE-ConnectionGUID: eEmCuTZUTVeHgZ5BIvwW0Q==
X-CSE-MsgGUID: M5DVd53LQOGkMhX0kAlsGQ==
X-IronPort-AV: E=Sophos;i="6.05,242,1701100800"; 
   d="scan'208";a="8472755"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2024 05:16:39 +0800
IronPort-SDR: XKn8A9AE4vwhUh5gNXeyRZ6HHFQv/BeySQ+Ty8BLDdD1oz4PauT1p+toYjaMsz3/XsaT+YdpB2
 C18g57nJaayw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Feb 2024 12:20:45 -0800
IronPort-SDR: FNPrQmudWa3DbLDPBR84NmOqsERh/bh9CvJgpSqlLqSR6FulYWptvsDibOrMJmBR1G4VLhHTQs
 w2ZR22o7woSw==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Feb 2024 13:16:38 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 0/5] zbd, t/zbd: miscellaneous fixes
Date: Mon,  5 Feb 2024 06:16:32 +0900
Message-Id: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
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

