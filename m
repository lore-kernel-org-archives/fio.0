Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA983164C5
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926177; cv=none; b=lhcNYjBbWd7C2n79OHT1UoUgF+odvK8ZKI486wh/gDSqu9oCkBCAR/ytMr9z7FXBN5nhRt/5gZX2e0GsQELtTVn/3Zc1u+RB4YiXO+h1sB9tpi+bG3U6n4F6Q6feBTv7uFogS3aNL3f2I75rXA5niF4tQLez/vwKtqfWeJLwztk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926177; c=relaxed/simple;
	bh=RXb3AO7eJ7WHLo/8PnDXN8JPRS0VGm0w+J+utmZNNX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8WIwJqQl9xmWYluZXj24dIpBmK2pca5ad+xQEIaS6cMDCeBLBs52jZP8jaH8NyvSdCWAteUttJlKq43DmJToZRJgxcKx0YQ435iiD/qNJxMgYIOZ3svrolGJQQ1hbW1CCex6I05XVGt4Xz2bMdTkNAKSOMR40DBAFaU4IkFSxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eC9YXbSU; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eC9YXbSU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926174; x=1799462174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RXb3AO7eJ7WHLo/8PnDXN8JPRS0VGm0w+J+utmZNNX0=;
  b=eC9YXbSUbPKcBqYOxb10bFF5ztVESw9i5voBJCbS3GsOskvv+sq6jhz8
   eEdhkTGq5HSpGkXjRnPGA0Hg2xLPbojQLKJ2de0v68Daxp3t6g70knLzo
   NxXFp2wlp/9rlO+YJwsZiyLytVsqYUZ/Wi/nPAjf2Adjo8m7MUt3uqrNh
   F5vSQnaB0/Yy9acS+u+NLkNgiDzEdj+Umb6tNKhhGU4N65DPbjd73k3+d
   TcWOsbaYWtKe8zEZE5Gou6QVy5E88XEPeD7gsgci5Q/oCWV3fz+1J7lRo
   IpFxMBF90/E9vfA9YTX1L0QzWLwiJaZIZEa0l8IxkkM022TsYAxpuW7jJ
   w==;
X-CSE-ConnectionGUID: KY42uN6NSDm4PWBgsgS9Ig==
X-CSE-MsgGUID: GqPz2VpeSxK9WhCkZhz7LA==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774586"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:14 +0800
IronPort-SDR: 6960699f_LxHew/E1qzJikSWWAST6Df3E94TdAXF3UIpK+11LpHAVRPD
 0IJnjhbVczMAjc76et07q0VhLed+yOmwAWFrBbQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:16 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:15 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 10/12] t/zbd: avoid test case 14 failure due to no randam map
Date: Fri,  9 Jan 2026 11:36:01 +0900
Message-ID: <20260109023603.2848421-11-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The recent change disabled the random map feature in zonemode=zbd. Then
random writes for conventional zones may have overlap. This made the
test case 14 fail. To avoid the failure, modify the test case to count
the number of overlaps.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 40f1de90..e7a711b9 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -637,7 +637,7 @@ test13() {
 
 # Random write to conventional zones.
 test14() {
-    local off size
+    local off size nr_overlaps
 
     if ! result=($(first_online_zone "$dev")); then
 	echo "Failed to determine first online zone"
@@ -650,10 +650,11 @@ test14() {
 
     run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
-		    --verify=md5 --offset=$off --size=$size\
+		    --verify=md5 --offset=$off --size=$size --debug=io \
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
+    nr_overlaps=$(grep "iolog: overlap" --count "${logfile}.${test_number}")
     check_written $((size)) || return $?
-    check_read $((size)) || return $?
+    check_read $((size - nr_overlaps * 16 * 1024)) || return $?
 }
 
 # Sequential read on a mix of empty and full zones.
-- 
2.49.0

