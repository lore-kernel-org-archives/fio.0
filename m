Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38CF4689
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 06:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744612045; cv=none; b=mYrpLNACwVgQbTEs5SyDpW/+aXV/b7YOuFueG3V3ccCFBktso8Ra9rj57qIsrZ2vev3+wLpz0mXy/EKH45Y9hxulEQ5divdTJu69yCctOZ0eRnGG0wEmHwGZ8xlb+aNyqakhzJJX1c/XeH5Vd8oOt0jhHHsMzb6gtLFCh898fw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744612045; c=relaxed/simple;
	bh=5G78x3eex/GRQKXezZhl2pqjboDZl6CaoH70TZ4vOuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XL1lFcc69PsIcXI2dkt6mW46uw4ZokVYrFO2RpI/d0sF7e/m6orU8QbhAatisx8hpfP+01ir+J8rUxVs3L61xC0lJCGV/c+r/IDbo83GjLnN2E2YkEz4KToF6lkgDtHKLQHeQZFjRN5tMhNLpKTq5V5lzoP6a4tebzQj3dkZyjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NMNrmlQR; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NMNrmlQR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744612044; x=1776148044;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5G78x3eex/GRQKXezZhl2pqjboDZl6CaoH70TZ4vOuw=;
  b=NMNrmlQRWFhRNXvFP+IBmwUJDLkBmH93lbIRIed/Z5Ez1tzgN2t7asB2
   ns6oqwBZbHlXZtmZg3WnGiCqIWgS0VzfRd1VRBceuhDYvvefXG0A71yaL
   nvE9EIEDDlci/Q7vkkGSu5B1CT9Xi6dhaPZRQHfbcbUgg6behzV43uAyb
   4KiXRH5dX2C5F/996M4FlNtAXdYOn4ykd4mhQ3tnhhEJLfkmk6+i87lTE
   SwNyEl9N7kePP30uWcT9h6aKqlj7w9iub5YIt5OYPHGiWyCYqzlUn1qCS
   WIRzUmoNHaSet1xTARivIpQfcXmDhu1VfvAsUpTw7AJyhqcKK/6hxFsFP
   g==;
X-CSE-ConnectionGUID: O1pQBCt3QFurgI8weRIaxA==
X-CSE-MsgGUID: xuMOhjSuT1yTRieLeIEKHg==
X-IronPort-AV: E=Sophos;i="6.15,211,1739808000"; 
   d="scan'208";a="78068681"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2025 14:27:23 +0800
IronPort-SDR: 67fc9cc0_B2MDMaJhesLy3XjXSzanviH9jmkPU1fNITjRIltfR+d3amz
 RlvqXNbnOq4YU/krbksWazleqNiG2EBrS/kTt/w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2025 22:27:29 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Apr 2025 23:27:22 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/4] zbd: fix unexpected random write stop
Date: Mon, 14 Apr 2025 15:27:17 +0900
Message-ID: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a random write target offset points to a zone that is not writable,
zbd_convert_to_write_zone() attempts to convert the write offset to a
different, writable zone. However, the conversion fails under a specific
set of conditions. This series addresses the failure. The first two
patches prepare for the fix. The third patch fixes the failure. The
fourth patch adds a test case to confirm the fix.

Changes from v1:
* 1st, 2nd: Improved function comments per review comments on the list
* 1st-3rd: Added Reviewed-by tags

Shin'ichiro Kawasaki (4):
  zbd: move zone finish operation to zbd_convert_to_write_zone()
  zbd: factor out zbd_pick_write_zone()
  zbd: finish zone when all random write target zones have small
    remainder
  t/zbd: add test for the case all write zones have small remainder

 t/zbd/test-zbd-support |  48 +++++++++++
 zbd.c                  | 191 ++++++++++++++++++++++++-----------------
 2 files changed, 162 insertions(+), 77 deletions(-)

-- 
2.49.0

