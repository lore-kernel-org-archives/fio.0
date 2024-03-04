Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C2053A6
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 07:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536743; cv=none; b=SMd0e5NVc9e+QSPtQODrIu6/dc92Bq+XomXJPJo1ZkteTHVEWRNnWNamRO9vzSeW4T1PGd0AWcr6fYmaynOovfK6N1zYUDy7EFBIFRyR6zRmSf4mZrrbtYxrsfVFOWPTN9IAFdj+ysn9hO96Kogq8dhwaNZnVSd0+ie2SyIs2hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536743; c=relaxed/simple;
	bh=yfAQ/m2XydvWyE6lbaVyvYJpMRbY6k7Y5GfVBMxRvSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BdTVcuaw/hsXTWOHAOLblLq0EMoayQzI7omTx0m/zKxQZsnu9b2iMY63WDIUJkBIOmUtxTScqpmIUyH+We1YRx/oRQO5dHZFWONnwo7A3oO8JHNiGwmrs2tnKQpcufJbcEvTC5hXFx+a7atAugjKMup26Ly/kteY5R/uGqwNIWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=J9BY29ri; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="J9BY29ri"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709536741; x=1741072741;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yfAQ/m2XydvWyE6lbaVyvYJpMRbY6k7Y5GfVBMxRvSo=;
  b=J9BY29riKg2elSo8oZAI9gpAylLct7f0LPkKpDlRDAlq6lNQQPQGGdim
   Be+LeJuBI6Omu3ADrB8MAmduKr/9uLjzRtuXf0pX1E9yzP2m6kRFqj3Co
   SNGYdRyuNRe/HLofdGnil2PU85bPm2dsqdTqTVw0Xd1cSqqYLY2wlh8hE
   kc53HhOZu6GTt3++6HGOsd/LPc8pibV3YHyM+irZo0dnaokyXpH0byXrW
   hkne2bQHxQS1vRASGrmcCmSR6RkwIxPS96hudXBkptWPH3SCnx+QI8wcK
   BrNT7Y8xbQ4IeE5UHGA8K9Hrh55meZhOnpmIgCHlwrx4JHRdxJ5rqNLyu
   A==;
X-CSE-ConnectionGUID: xzVjcT+KQQeC4LbKZv6Rig==
X-CSE-MsgGUID: NPvkISHvTnu1fzlcsB6S+w==
X-IronPort-AV: E=Sophos;i="6.06,203,1705334400"; 
   d="scan'208";a="10728583"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2024 15:18:54 +0800
IronPort-SDR: OaT7SNUQgZfz5KX/CRkGUuVkPIqLzLuIuaJEf75423puvdwXVhd2S0QVfre3KGc6lGFoHGB8ei
 hlqJLDqf4Cqg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2024 22:22:25 -0800
IronPort-SDR: 6AkiM8D6XQdn4S1hD7OHFs/IFMmo5NTN6mIjgiKQBXp18/6o6GKlzSxvYac+F1yjpsbBLzPaUV
 53V8RmrZ17zQ==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Mar 2024 23:18:53 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 0/6] Some minor cleanups
Date: Mon,  4 Mar 2024 09:18:45 +0200
Message-ID: <20240304071851.982-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1->v2:
 - patch 5/6 - fix typo (Vincent)


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

