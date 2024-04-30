Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D0312BF15
	for <fio@vger.kernel.org>; Tue, 30 Apr 2024 10:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473036; cv=none; b=bbcX6mH396/CDQWiVrrApeNt3O9RHf43R+A3wnS5JGsB3rqKb/wIJdtxgO/0kIVZdCUXDCwUE9uUPW5/mOkku2sLTnsmyeYzlSzSiYbuBguIIZH4BVB80w/9KRHUSnywYfW0G0Hp6UIK7GYzUfxdi4ueoEWS2acVcck1QyvjCuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473036; c=relaxed/simple;
	bh=TgIqnMxiXbpX7qPUVXCSWb22PHFOZca7UHxBBATzmqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snZKIrVdushvoTrHEqLHbJ53+68AOlJsxnsTx+8Rh0VAX4tGARcLdiw8TGSEeuj8OWdjf962mZ/ehuMfOO/wznW2BzzJaoGe/Wp28eyVb6eg04AeUxPOJI8i/2cvUC5NDrMaaLKBS36rDCe7l2WLJb4oz8Yqydyf+Tk1lPugCWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kEmY9uqX; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kEmY9uqX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1714473035; x=1746009035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TgIqnMxiXbpX7qPUVXCSWb22PHFOZca7UHxBBATzmqQ=;
  b=kEmY9uqXrob9z2jG+PXiJzG52gmIn9ZjRi0E3j8m18wnDW1LvO0Nkgd4
   6AT4BiERNy3UyxQNQuHYp6rymNwmIEYbDHyhUOAZ9q5Jc8bmMrVtZLASc
   cNhjftp0E29NWhU08agf/u9x8X88NkIjWgikDsj9kLFuFo6gxC7N9imYa
   l0gXz+N18wMG8cwew6yyXqStYjzfezUepAZLVMqlR9rodx2Tya5kHGiZ4
   5YL1S/Jn7AoBRIITMPIdy5Ak1fIUiksc393l3Qc7oqlilLn1bIoGBapJD
   r8EfkQRYetptGMk+g6GLYVYFFLbGbTRVqEe1p4b4amcAdpqEft132L3YV
   w==;
X-CSE-ConnectionGUID: 4CeqU8hARBSjgLCs6mDFUg==
X-CSE-MsgGUID: an4S3xt/RLqvg0bFYddQUA==
X-IronPort-AV: E=Sophos;i="6.07,241,1708358400"; 
   d="scan'208";a="15244721"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2024 18:30:27 +0800
IronPort-SDR: JxmokRkOJiC1lQLgX1mCJHDj48mnTK/SbconxYwHWNiLi49Cw3iKR5p6smzzsXQ0jlxr5eHSEw
 iCa5wM43hGmRE+veleluuPxKNzGrS89n2NAPwQvN9O4mAduAI7PKHzqr9d1Q8nl/6LFc/vpwfO
 WqG05KXICp9C8pgAlOyRv5I7my0jko0rwX+pAYfHDAOFOLK5wjY/tFHE/GiQ3yBEWeqYvj4Byj
 lvUXn+ou+SNwauOPj315AsNtZHRMLH7ZDSUa5Zolen9w3kpuSFPnnyfsrLRzV0ksyoc6k+QxfR
 6iQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Apr 2024 02:38:30 -0700
IronPort-SDR: RgdOofziqm9TGs/ScOtG/n95amdF3xrSeW/junE6y7yzwQgNYxFzKBP49NsnkMQch3+JaASXM3
 txmBVboTTMgLK+7LMNpPTBUMfL0oj6ycne+7terlA4KbYx3U2utbbZp8Q2/Cm7kdt5PmF1UojR
 mR4d92IXs2dNgXOx5EB/4ECmFWR3n+es8QTvkN+4X6q5uAmDc1BJKL/GDPdFYsQDKxVjDNazzX
 d6vsBdEL8fRS0auHpDffqnsvLmx4dTUU33m89n807AltZ8vplVUWjB9+htz5PSZ9dH+uYwXb6B
 Wnw=
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 30 Apr 2024 03:30:27 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/3] t/zbd: avoid test case 31 failure with small devices
Date: Tue, 30 Apr 2024 19:30:22 +0900
Message-ID: <20240430103022.4136039-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
References: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test case assumed that the test target devices have 128 or more
sequential write required zones and uses 128 as the minimum number of
zones to write. This caused failure when the devices had a smaller
number of sequential write required zones. To avoid the failure, count
the actual number of sequential write required zones and use it if it is
smaller than 128.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index ef98835c..e0b2a755 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -852,12 +852,15 @@ test31() {
     # To distribute the write target zones evenly, skip certain zones for every
     # write. Utilize zonemode strided for such write patterns.
     bs=$((128 * 1024))
+    off=$((first_sequential_zone_sector * 512))
+    size=$((disk_size - off))
     nz=$((max_open_zones))
     if [[ $nz -eq 0 ]]; then
 	nz=128
     fi
-    off=$((first_sequential_zone_sector * 512))
-    size=$((disk_size - off))
+    if ((size / zone_size < nz)); then
+	nz=$((size / zone_size))
+    fi
     inc=$(((size / nz / zone_size) * zone_size))
     opts=("--name=$dev" "--filename=$dev" "--rw=write" "--bs=${bs}")
     opts+=("--offset=$off" "--size=$((inc * nz))" "--io_size=$((bs * nz))")
-- 
2.44.0

