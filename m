Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580B54F211
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629216; cv=none; b=kItq8HZ/25BgNbLhxDbHGXIkQTfFkW+3mh1LaNIT0LvbbK7XfFFvMxv12NgDwS5A6qn6nDkAykiqRvRHr0xR6uig+of4knucrU+aODp303vN605KTgtoKOMK1cFrd+RCwXCl/xi/2gfnm2byWH3+tS0YNrclLSIYAANAxgwUEw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629216; c=relaxed/simple;
	bh=qdKRWqAkykZHJx+V5X3fnAONOooD7bbZh625UtcYF5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OZF57X5OWgQ9Oh2ydenx4K1yQ+aqtJ8E3F2i6WZbE7Ubjbk4CckpcU/XTa8OTtQv86fZz/TAIjJvM+y+m3Vd5zs2hrYWTpXJ9zRzZdLIOe18sVe807jO268ZZmm9GDZdJDRbSeRq3rVxh1Yu7ItbzZQsqUyVNf+cFZeq0xeDuYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pgWTJTcT; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pgWTJTcT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709629214; x=1741165214;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qdKRWqAkykZHJx+V5X3fnAONOooD7bbZh625UtcYF5k=;
  b=pgWTJTcTX+Nj1sN46mgsR+LiVS0onuwVvKNJNq7EP/46NE/tV2VoXVEi
   +C3x3B9x/j4RqtnGOllWu95QtsEyp6XBvLGQntxcX9BWhChE/W7EFSjBC
   mY9ACmM0xbA4VNaXUbsErgJuy6iuYy4kHxoV2YSPY3NlUe/tZ+UWgsp19
   ulieIuLg3queUPfMlMcHodrVoFUGgvf4kzkhnwPJrBKgZwmFRdH7MA6me
   HM7TS0qAkElqsF8siKTLmQg3QAcq5o062XWG/2XLm/P3Yrg++EEoOlYdc
   Ym2SJa6HDlu0PuZtC93TBdwz/1cHHvj80pQaitqIYgZT86JgyS47uQPGr
   g==;
X-CSE-ConnectionGUID: QdxvsvllTOm+f/+h6ckkpw==
X-CSE-MsgGUID: wJC2xPtYSLef23q7wI9XVQ==
X-IronPort-AV: E=Sophos;i="6.06,205,1705334400"; 
   d="scan'208";a="11070400"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2024 17:00:12 +0800
IronPort-SDR: LQa0GMTF+d9lJXNGIeETJfnpP86fWQObyuwEu9hmkoCeD9luDgIzsiRSaSRuA5PUnKSMIj3+lW
 dV5gNZSGZakA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2024 00:09:24 -0800
IronPort-SDR: Mj/X+XfLYTg78/cZXMJovzJuYf4FmyY7mKUE4JlmUx2ok92BLX4a34dxTLZXbLCaQIao62o5pO
 wUy3sqdyjVCA==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2024 01:00:12 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 0/5] Some minor cleanups
Date: Tue,  5 Mar 2024 11:00:03 +0200
Message-ID: <20240305090008.1216-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2->v3:
Attend Vincent's comments:
 - patch 3/6 - remove
 - patch 2/6 - fix typo
 - patch 6/6 - elaborate example in man page as well

v1->v2:
 - patch 5/6 - fix typo (Vincent)


Mainly fixing typos, style issues, etc.

Avri Altman (5):
  fio: Some minor code cleanups
  t/jobs: Further clarify regression test 7
  t/jobs: Rename test job 15
  t/jobs: Fix a typo in jobs 23 & 24
  Doc: Make note of using bsrange with ':'

 HOWTO.rst                                         | 4 ++--
 backend.c                                         | 4 ++--
 eta.c                                             | 8 +++++---
 fio.1                                             | 2 +-
 io_u.c                                            | 3 ++-
 parse.h                                           | 2 +-
 stat.h                                            | 1 -
 t/jobs/t0007-37cf9e3c.fio                         | 5 ++++-
 t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} | 0
 t/jobs/t0023.fio                                  | 4 ++--
 t/jobs/t0024.fio                                  | 2 +-
 t/run-fio-tests.py                                | 2 +-
 12 files changed, 21 insertions(+), 16 deletions(-)
 rename t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} (100%)

-- 
2.42.0

