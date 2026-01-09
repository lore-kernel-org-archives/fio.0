Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD28230BCB
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926174; cv=none; b=JDO1B2taEw1ZkM0ZmV0P40yA13MzdcRQrytXrKsVvz2RDvc45sG4ZZHEvhaFGIzNfKfyD7OcKpcysaU1bq3As18m1oQPQ7AqBq9fvHQROiZXsL2d0ha4QbpJDuTc7jhZPfaBI6MQcdzfLwiale9C6yOsVQUq7DuN1ViGVXq/jv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926174; c=relaxed/simple;
	bh=UenQodU3eCQA0Vz4kVKmBD7JF2d7o25KqAQLAKnaews=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyDpTLWw8joDkVhtBosKzuTwrujsq0ShPoaWI8BDtXyUM98++/I0Crmm41CapzAUiDm9Aojq1dnAZdja/Lf/RmjFPt1gLbIfR/kj7rQhFSpK119FM/X9SFBDFqbVUP4dYNpmqP/7GFKW4U0F+nADSa/9sagPOoNZYT/iA2wANME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F8oH/fUn; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F8oH/fUn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926171; x=1799462171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UenQodU3eCQA0Vz4kVKmBD7JF2d7o25KqAQLAKnaews=;
  b=F8oH/fUnznk82cqPSQalgVsBrT0XKJIwBP0CmKP4sKFoaozoMsamsObx
   rCV1y4VEOq7ioWqmKfz4Qi55U9r5eOb9QaK/Y7HcOT7di/WqlMOl0Vn8D
   bcPcqxSW61LEz4pOzL3ZwD9s9lYg0GmQy4fipp18py1bL1U2PWfe9R0Cw
   Ogx9jg3AJqZMSbqStkki3OaJiXtUN85nQmKHPRCw5OmfEo4JM10qA6MD7
   I1UO/lv0+ro2rl3xqNC0V5vRn6jKX80CWv4t5Pwh3vGisTDSaLJBSfvhP
   4kVXTI3AcBefllvzhgIvcffJIV5Yew1IwmbG3/Rbv4PORiUEAu1cphWWt
   g==;
X-CSE-ConnectionGUID: SL+/TtB5RduKQZVce/9JPw==
X-CSE-MsgGUID: BnQwbd3pTTSJrRVTcJNdYA==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774579"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:10 +0800
IronPort-SDR: 6960699b_Dqoeil1T0zl2iRz7LcwHTuV4LFGHt0r+OFoomNub9lz8MFn
 +ZDdSqCAYi8jQMmygMeIGH2N2zfo8zjiHv19OTQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:12 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:11 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 06/12] zbd: remove zbd_finish_zone()
Date: Fri,  9 Jan 2026 11:35:57 +0900
Message-ID: <20260109023603.2848421-7-shinichiro.kawasaki@wdc.com>
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

After the commit "zbd: write zone remainders smaller than minimum block
size", zbd_finish_zone() for zone finish operation is no longer
required. Remove it.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/zbd.c b/zbd.c
index 2682babb..25da87da 100644
--- a/zbd.c
+++ b/zbd.c
@@ -359,44 +359,6 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	return 0;
 }
 
-/**
- * zbd_finish_zone - finish the specified zone
- * @td: FIO thread data.
- * @f: FIO file for which to finish a zone
- * @z: Zone to finish.
- *
- * Finish the zone at @offset with open or close status.
- */
-static int zbd_finish_zone(struct thread_data *td, struct fio_file *f,
-			   struct fio_zone_info *z)
-{
-	uint64_t offset = z->start;
-	uint64_t length = f->zbd_info->zone_size;
-	int ret = 0;
-
-	switch (f->zbd_info->model) {
-	case ZBD_HOST_AWARE:
-	case ZBD_HOST_MANAGED:
-		if (td->io_ops && td->io_ops->finish_zone)
-			ret = td->io_ops->finish_zone(td, f, offset, length);
-		else
-			ret = blkzoned_finish_zone(td, f, offset, length);
-		break;
-	default:
-		break;
-	}
-
-	if (ret < 0) {
-		td_verror(td, errno, "finish zone failed");
-		log_err("%s: finish zone at sector %"PRIu64" failed (%d).\n",
-			f->file_name, offset >> 9, errno);
-	} else {
-		z->wp = (z+1)->start;
-	}
-
-	return ret;
-}
-
 /**
  * zbd_reset_zones - Reset a range of zones.
  * @td: fio thread data.
-- 
2.49.0

