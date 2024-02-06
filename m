Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DA412D148
	for <fio@vger.kernel.org>; Tue,  6 Feb 2024 10:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707217153; cv=none; b=e9qEKmRRAvMHa5earzppbElDDvWV/NWzc6B8BH0ZHu1JIzNx3foSe/NVmtFzixrm8eb00rAtfh6moie9hC+GPslmTWf2xeJGqA6Bfe7W3thyvhf68jdD+QZJ6OMk9uAHhcWw1POAxXblpM3nL5W2zkHeT9FieUqLTk2WjD0jNSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707217153; c=relaxed/simple;
	bh=aW8bo7o29fGJXaB1wn0+xA6uIRIKyXesGrEnq3FKqQE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6HJsA5LkIQ8tdTnvJbYvM0DVPuWnc9bD4Sx7CBqm1VHXRlDSIHBfRDWocnan5lobYQjqMZDGmuY4W3kx00/I0rNYG0dwCv3ke6Z9OGraSuAimTvpvJ/ExJEnKD6azntVRT2+1D1+7l6CWLrD5wtDpVFPrQ2ErWTubK/UB3oXVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=p7fA670z; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="p7fA670z"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707217151; x=1738753151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aW8bo7o29fGJXaB1wn0+xA6uIRIKyXesGrEnq3FKqQE=;
  b=p7fA670zZYNyfuEIaex9g6n9v/DWW8ftQDM8nHjqsBBwLqLynR/bfai0
   giz4KpblIbgvIFNOSkYl5VfzU8ytKqPfajARl0mwGMbb6w4cuEcAULPNX
   kybEN0hGFcVKuo0n4jGhNx71FJpAq6JWc88urbckYLhCrFbxrXgVIZCax
   2gU3Lp9Tefx2jOTY0ssHez+imHLLNwdphJpo1h53BnTvwSMdnJwDGc5VZ
   e/KVbu07cbY/djc/fKw7oWvLLp7JsaBblQk9nVCij+YhVHXYwf2zxw08w
   WKDQvLoHHVo4xlF/zuizWi6+FuLb7V22i0CCKZkwlCRRrdLD3z4JkAVBd
   A==;
X-CSE-ConnectionGUID: sA0CWEgpSneQB+9H4Brxaw==
X-CSE-MsgGUID: quUTlNB4RjOCkI9gD0wn6Q==
X-IronPort-AV: E=Sophos;i="6.05,247,1701100800"; 
   d="scan'208";a="8663345"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2024 18:57:58 +0800
IronPort-SDR: 2LJmj2i5yzpPE/7S8MOhLpC98TK1I0pr6sTCPsU31JS9DqFGxaRDehxdN6m1bcQeXsg01o5zkv
 gWfB1tmMBilw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2024 02:02:03 -0800
IronPort-SDR: PjpBI8fHD6DPQ2FkJOUCBK/PVkGgSuZGLX6XChpNdlHww4MAihg860dQbogw0iq1M3JpqdmgLo
 su8xy1H2zCOw==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2024 02:57:57 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 1/5] zbd: avoid assertions during sequential read I/O
Date: Tue,  6 Feb 2024 19:57:51 +0900
Message-Id: <20240206105755.214891-2-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
References: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The following assert has been observed to be triggered
if the I/O offset + I/O size exceeds the device capacity in a
sequential read workload -

“zbd.c:110: zone_lock: Assertion `f->min_zone <= nz && nz < f->max_zone' failed.”

The code in zbd_zone_align_file_sizes() rounds down the I/O size to
avoid these situations, but it is bypassed if
td->o.td_ddir == TD_DDIR_READ.

Avoid this issue by modifying zbd_zone_align_file_sizes() to round down
the I/O size for read I/Os and leave the I/O offset untouched.

Fixes: bfbdd35b3e8f ("Add support for zoned block devices")
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/zbd.c b/zbd.c
index 61b5b688..7577472e 100644
--- a/zbd.c
+++ b/zbd.c
@@ -674,9 +674,20 @@ static bool zbd_zone_align_file_sizes(struct thread_data *td,
 		return false;
 	}
 
+	if (td->o.td_ddir == TD_DDIR_READ) {
+		z = zbd_offset_to_zone(f, f->file_offset + f->io_size);
+		new_end = z->start;
+		if (f->file_offset + f->io_size > new_end) {
+			log_info("%s: rounded io_size from %"PRIu64" to %"PRIu64"\n",
+				 f->file_name, f->io_size,
+				 new_end - f->file_offset);
+			f->io_size = new_end - f->file_offset;
+		}
+		return true;
+	}
+
 	z = zbd_offset_to_zone(f, f->file_offset);
-	if ((f->file_offset != z->start) &&
-	    (td->o.td_ddir != TD_DDIR_READ)) {
+	if (f->file_offset != z->start) {
 		new_offset = zbd_zone_end(z);
 		if (new_offset >= f->file_offset + f->io_size) {
 			log_info("%s: io_size must be at least one zone\n",
@@ -692,8 +703,7 @@ static bool zbd_zone_align_file_sizes(struct thread_data *td,
 
 	z = zbd_offset_to_zone(f, f->file_offset + f->io_size);
 	new_end = z->start;
-	if ((td->o.td_ddir != TD_DDIR_READ) &&
-	    (f->file_offset + f->io_size != new_end)) {
+	if (f->file_offset + f->io_size != new_end) {
 		if (new_end <= f->file_offset) {
 			log_info("%s: io_size must be at least one zone\n",
 				 f->file_name);
-- 
2.37.3

