Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECB24C9F
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 01:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737509926; cv=none; b=Pkdvfi+0p/NcS0ZVGzxppw1gfIALasJM0a1SH5Q3ZvyoZq8/SIPYfc0nNsFo9sANJGRBFeggt36LkQFMNEcb0vWpwtvnVN7wvi3ym4wuxYvii0TdJpy3e14PP3V0xoCGU5V8pIns9Rzw0683mp6dnB4RqFAeep6F+Q41lwZoloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737509926; c=relaxed/simple;
	bh=Ri/CoeTUkYi6xcG0Ie9ykvwtXVl5KPMzt0H4DsC6jV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OaYRBZyC16s3PSFPVsxn5P640zTYLRSuP/zpNCSgxN/J36qUuFOG40dBAFCTcGfU8HbhL3L8GXKJPaKNcNkQKk2vBIf1p60AyzXvF0hqJD3uLnA93gopqL7ohyZeF99PFg50Xea6pgCeTY2bVENSfZux/d04yuwzHxwP+2/SYPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mc47PZCp; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mc47PZCp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737509924; x=1769045924;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ri/CoeTUkYi6xcG0Ie9ykvwtXVl5KPMzt0H4DsC6jV0=;
  b=mc47PZCplHryGrGkayKqM8hP3jr6P2Ojl0v3eImLD6lYb6yynyVbb9rR
   kYGI6kNWsr0JqSuBeTF/Qfa1VEFrCTZcTFKZXyKYPheWcAMuUEJjc2N2c
   JzwH4Fap3j7a30KTsZ8MKJVX0JIOPTnywIkH5Ag4NkHA/YG2r1SAP2JoN
   vjsfu1BqAR0z2zScpmtiJfMYTMLIW2LnOUbqFpCav+cKN3k5WKcvxS4KW
   eU8pPHdzXwXcvsrI77X+c/cx18CsbRG2llXZ+mufKm6Ia/h9O6RdQ4iB9
   XTUltd6UmPNHCF8HuLZu3YaRGkPrRzDVpFt7FxLmawdEd8ghoNdaQuHgG
   Q==;
X-CSE-ConnectionGUID: dQcpb0cSRgyWXOSxM7hMHQ==
X-CSE-MsgGUID: NU6pdnA/RV6LM2TvDQWWHA==
X-IronPort-AV: E=Sophos;i="6.13,223,1732550400"; 
   d="scan'208";a="37689155"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2025 09:38:36 +0800
IronPort-SDR: 67903e86_5//CBUDMwJIZtgoctzx1a0IG9eZeUpNhu2oFAgPDmkaTiQ2
 rYTeqSS8Sg7j4c9yREPtvzel5Y8eud3fsgAstFg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jan 2025 16:40:38 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 21 Jan 2025 17:38:36 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/2] zbd: fix open zone status check for non-write jobs
Date: Wed, 22 Jan 2025 10:38:33 +0900
Message-ID: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, fio checks if each zone within the IO range is in an open
condition or not. This check is done even if the job does not perform
any write operations, and causes confusion among users.

This series addresses the problem. The first patch fixes it, and the
second patch adds a test case to confirm the fix.

Changes from v1:
* 1st patch: added Fixes tags

Shin'ichiro Kawasaki (2):
  zbd: do not check open zones status and limits when jobs do not write
  t/zbd: add test case to confirm no max_open_zones limit check

 t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++
 zbd.c                  | 10 ++++++++++
 2 files changed, 39 insertions(+)

-- 
2.47.0

