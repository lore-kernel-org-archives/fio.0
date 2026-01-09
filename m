Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCC750096A
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926174; cv=none; b=g5fr9A2lHm6ZIPUwi/DPKpWcWLuouwrcLtFnavX7BWBsx3B8+RnDFY+m1fzPui5l8tE4hB+xSXCuf1VYYg8eGpOdEQYkTzUuUgPkFw5sTT3BqDj7C5WNHljWDU5jg1cXChU6IhjbS3AemWqJ/RXDVg49Bx4ugH7350sP/Tqu5sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926174; c=relaxed/simple;
	bh=TSdphrHM3BYzQJKGLF4eoHsF/mbvG6XWmijpDEBCaF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWetwKdp383p04Tp8ZHQVmkiC7idADrP0eNlReK4knT03vJeK+Hky5KE4u5cCdAibcZYQCVMCrR07bL1bYsKWwpMLQdxxErcjDcUJMZmJH92PNZuEIR73cLY61stHIcevc811qmqvF8nNQ6AiKLpKPFdEXKl08LClHR8AsKkeLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LyZwD5fR; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LyZwD5fR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926171; x=1799462171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TSdphrHM3BYzQJKGLF4eoHsF/mbvG6XWmijpDEBCaF8=;
  b=LyZwD5fRmNxSNRViqNe1gP+pt3609IVrGYItGMvi/ahgzGpfmkD5n8Vr
   Urv1/E04fkw8ZmWvO5B0XosU+IWyfAXzy0aFXNQmnyK945/S2/l/w+V1c
   wf63nciYexb4FfyW43z0W78kY932CW2qxtBwF0K+XpxHYC8FYYDxVGwrP
   eBP/VPdF5C4jF11mZtovhfhBhIrBwFAWcluvF3hg1xnF23GmB4OOMruiD
   2Ks31CMmQnpMq0sCblhl/S9DUAs5GKbJk7pnOt89FM4YXHoRoYH/qPA6g
   LOGX6XsFd+5YOruR44DcPebuqHTE9gY+vx6f+azR2f+Z1x2toAn5qLMgq
   A==;
X-CSE-ConnectionGUID: ny8TfktKSF2to2HCGoWpQw==
X-CSE-MsgGUID: zPBVOFyeScuAT7tcTP9ARw==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774580"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:11 +0800
IronPort-SDR: 6960699c_pT3OhiZVdqv2mYt5sM/YXnbL0qi7wRDz5xt+fk6a+lJsIdm
 rD2m5h6h1Jqgwj26v0SKoD7XPnTcMFNunzrWEFQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:13 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:12 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 07/12] oslib: remove blkzoned_finish_zone()
Date: Fri,  9 Jan 2026 11:35:58 +0900
Message-ID: <20260109023603.2848421-8-shinichiro.kawasaki@wdc.com>
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

Zone finish operation is no longer required, then the function
blkzoned_finish_zone() is not required either. Remove it.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 oslib/blkzoned.h       |  8 --------
 oslib/linux-blkzoned.c | 34 ----------------------------------
 2 files changed, 42 deletions(-)

diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index a8e4a948..c6549ecb 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -24,8 +24,6 @@ extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *
 extern int blkzoned_get_max_active_zones(struct thread_data *td,
 					 struct fio_file *f,
 					 unsigned int *max_active_zones);
-extern int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
-				uint64_t offset, uint64_t length);
 #else
 /*
  * Define stubs for systems that do not have zoned block device support.
@@ -71,12 +69,6 @@ static inline int blkzoned_get_max_active_zones(struct thread_data *td,
 {
 	return -EIO;
 }
-static inline int blkzoned_finish_zone(struct thread_data *td,
-				       struct fio_file *f,
-				       uint64_t offset, uint64_t length)
-{
-	return -EIO;
-}
 #endif
 
 #endif /* FIO_BLKZONED_H */
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index c45ef623..34ac66ce 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -338,40 +338,6 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 	return ret;
 }
 
-int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
-			 uint64_t offset, uint64_t length)
-{
-	struct blk_zone_range zr = {
-		.sector         = offset >> 9,
-		.nr_sectors     = length >> 9,
-	};
-	int fd, ret = 0;
-
-	/* If the file is not yet opened, open it for this function. */
-	fd = f->fd;
-	if (fd < 0) {
-		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
-		if (fd < 0)
-			return -errno;
-	}
-
-	if (ioctl(fd, BLKFINISHZONE, &zr) < 0) {
-		ret = -errno;
-		/*
-		 * Kernel versions older than 5.5 do not support BLKFINISHZONE
-		 * and return the ENOTTY error code. These old kernels only
-		 * support block devices that close zones automatically.
-		 */
-		if (ret == ENOTTY)
-			ret = 0;
-	}
-
-	if (f->fd < 0)
-		close(fd);
-
-	return ret;
-}
-
 int blkzoned_move_zone_wp(struct thread_data *td, struct fio_file *f,
 			  struct zbd_zone *z, uint64_t length, const char *buf)
 {
-- 
2.49.0

