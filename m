Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA04A1F4C8E
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 05:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745558519; cv=none; b=eKr5Qra4WedZ9SRkF4U/s9fkRzgmkFtHA321TGFT8XGjFsy14lJnQ9oZNEcuaue+ggDjvo3jTBh+d+EqtjWboXK7Qj/08CoxSL3fGyLOOY0HnvuWzxQ6OEnFIltB8V5kv5G4EYv+N3LSnQxtDwuZGXzHMhKCRsc5ki6ZEOjjwno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745558519; c=relaxed/simple;
	bh=VT4/WOj8S3xmCzR4oAD5rLludvmh/Vbqu0B3ivercZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDbZi64msUqcmB4+M1bLI4ZjyGfQKTKanWddgSWMCNLUnfSb56KgEUUWjYxrEFbGGiPxCFdZuPVNQIUe5zM6lZvc+VxsbZoIFDm1Kfv28bZAXfy/hjOgRIxiW6/wYjetHzIpU7R3nsg8PZhR1eBOjsf0g+bZWrsrjFeLLNzLhh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FfVaHtNb; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FfVaHtNb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745558516; x=1777094516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VT4/WOj8S3xmCzR4oAD5rLludvmh/Vbqu0B3ivercZE=;
  b=FfVaHtNbRMxKU5sIosoCMYwiN7MTSBOQOGTsVPvnZlnkUOsYPl8x7AXU
   vy5u7jTUVDW7fvDBKMa64w9OnOaqyaGg79fWm44zJf0CQPHJi0CZWUp/x
   4GKBDERiPLJCmP6+B3jI4qRCaITDBjzlXU7xCSZFNjUmu/VthGYGrMMzj
   TL3GG+vt8ZjcTXkrlUEyxUAOTV/z8/XrhM77290F0+6HX0YFtodvcsvY9
   uoNc++P6kHVIetgKyP3y4GxAPPYQ8lPrit7sC8sB0Eg583T0PCeB39hmo
   hFymMRbDPV/mjkPe1U7Qzt5LYL6QpZ034H1etTkKSmnd/Dz4OgVyDKf78
   w==;
X-CSE-ConnectionGUID: LBx+Db3FQd+Iu2mHP9iriw==
X-CSE-MsgGUID: sij/gCqWSDWCybsy3j0yHA==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="82381449"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 13:21:56 +0800
IronPort-SDR: 680b0dd8_iYaSbMUD+xFx4EWcoqWpTxqIYfAWuCKJUuw7GA//EgTy+qs
 Sixw2jLKZ9VDZwn8ZHjjoOcfXUdJZvifpe7LVxw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2025 21:21:45 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Apr 2025 22:21:55 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 6/8] t/zbd: set badblocks related parameters in run-tests-against-nullb
Date: Fri, 25 Apr 2025 14:21:46 +0900
Message-ID: <20250425052148.126788-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a preparation to add test cases which check that the
continue_on_error option and the recover_zbd_write_error option work
when bad blocks cause IO errors, set additional null_blk parameters
badblocks_once and badblocks_partial_io. These parameters were added to
Linux kernel version 6.15-rc1 and allows more realistic scenario of
write failures on zoned block devices. The former parameter makes the
specified badblocks recover after the first write, and the latter
parameter leaves partially written data on the device.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/run-tests-against-nullb | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index 97d29966..f1cba355 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -91,6 +91,9 @@ configure_nullb()
 		fi
 	fi
 
+	[[ -w badblocks_once ]] && echo 1 > badblocks_once
+	[[ -w badblocks_partial_io ]] && echo 1 > badblocks_partial_io
+
 	echo 1 > power || return $?
 	return 0
 }
-- 
2.49.0

