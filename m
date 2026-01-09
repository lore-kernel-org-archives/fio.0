Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB04318152
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926238; cv=none; b=Wm+1BJhro197OVPY31ATpA6sJzFDuO9AFfkd3aINzm8OGoza8iOkT5JLsmndQITj+61TRY/hOQikMiu1JrOqQ8ebB9bxNLeGGWiYXVMP7qPQDa8vnrcFoD4Tl76fU6+X1QurBL3ZEnuWRpLFJnv95zgGnn+1GD+mj8JguGz5wTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926238; c=relaxed/simple;
	bh=hZsFhCObKYP6KHuXEE2q+qdmuAzZvN7ua0ZjcFplqe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7NUfFB1YoWC6sGJviMvzPuG5npyuCGq0mv0rr7Et9d9xqcP5fuAoSjZILXgfqMJUgDchvXiIaqkbljH4ndnchWvSfVNiAyWiCCigKjboUtPIwfPBWLWTvAOD0smlIabBaoPuTNtJg08oBLTuHJ3A3U6pbk8aDK3XSaw6t08LRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=l+UUwehX; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="l+UUwehX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926236; x=1799462236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hZsFhCObKYP6KHuXEE2q+qdmuAzZvN7ua0ZjcFplqe0=;
  b=l+UUwehXFQAUgvE30yTOaXanviH+jpB4AGplMrUHRVySw5Ypi0LlzKLu
   Ns9avEGOXRbwaNO3YvEn4npEoeVEG53R34Uf7Z+Rd8LQZqdsa/68vXQoT
   A55qM/iaFOj7iolNWEL9T06CL1ejDXgHWNiEAoHBg/nbkuznoJIpReEUO
   1yvopMmAy1X/Pz0P1YOyrnlYrYCFAgsLtg1xk0nIubadHhK6TLXQvowll
   vdt4sdjFKaIrzKk2lyNFlAMvnXQ7PsACX6dSqQt554wxhEwGzsTTYXxN0
   1mdaXXSZbC1j2OrhrPE55mcaSGzFpMFmgjH4z5N4a7r+0rlhUG2qd/g6/
   Q==;
X-CSE-ConnectionGUID: YCtykxXHRXCYTnSNDWNCKw==
X-CSE-MsgGUID: AK3r9LY5TFWrEDoh1bne9Q==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774577"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:09 +0800
IronPort-SDR: 6960699a_THa+kMehBUrQLQBVMA+wMylZb6ezYrMI0nd0rinPEErdtEH
 nlmC2QbmowdFgFm5Gp4ZHvnt+nIyvu3mnyqNj/g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:11 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:10 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 05/12] zbd: remove io_u_quiesce() at write target zone switch
Date: Fri,  9 Jan 2026 11:35:56 +0900
Message-ID: <20260109023603.2848421-6-shinichiro.kawasaki@wdc.com>
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

zbd_convert_to_write_zones() calls io_u_quiesce() when write target zone
changes. This call was hiding the bug fixed by the previous commit. Now
it is safe to remove the io_u_quiesce() call. Remove it. This avoids the
performance drop at write target zone switch.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/zbd.c b/zbd.c
index e5f4c8f6..2682babb 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1507,7 +1507,6 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	struct fio_zone_info *z;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
-	bool wait_zone_write;
 	bool in_flight;
 	bool should_retry = true;
 
@@ -1589,29 +1588,10 @@ examine_zone:
 	}
 
 choose_other_zone:
-	/* Check if number of write target zones reaches one of limits. */
-	wait_zone_write =
-		zbdi->num_write_zones == f->max_zone - f->min_zone ||
-		(zbdi->max_write_zones &&
-		 zbdi->num_write_zones == zbdi->max_write_zones) ||
-		(td->o.job_max_open_zones &&
-		 td->num_write_zones == td->o.job_max_open_zones);
-
 	pthread_mutex_unlock(&zbdi->mutex);
 
 	/* Only z->mutex is held. */
 
-	/*
-	 * When number of write target zones reaches to one of limits, wait for
-	 * zone write completion to one of them before trying a new zone.
-	 */
-	if (wait_zone_write) {
-		dprint(FD_ZBD,
-		       "%s(%s): quiesce to remove a zone from write target zones array\n",
-		       __func__, f->file_name);
-		io_u_quiesce(td);
-	}
-
 retry:
 	/*
 	 * For random writes, retry from the zone chosen at the beginning using
-- 
2.49.0

