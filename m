Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F20C311956
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926175; cv=none; b=tBScotrmZ8KgQsC3zJ3mYKnc6zTEH+OcHlrAJpXIlgmTMog3Dz9ueKClWrN7UMdwt9RyJCk4jbSJTYnbf4V7oN0UzFcD3dl7szpvxrN71ANExiOAWPshqK/3c4nuWGACU+xA2xy8tKdaFM8sQD6Gz+J8oqVHTdm9of2x6shFwDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926175; c=relaxed/simple;
	bh=skx5Z1FRD0TJkNeSukwj3uFiF01xeq5AzlF8v99EXrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjvFwqHsBjZZ9DbRz/tkr7rjm7+5Mppo6mUM5Dzymv5S9Ppx8t6cezwJQpzG5zKDTUxkBFHYzqZPsaSEX2cWtkiA5Tpqx77VISSMbSlF0pbOtDPbI3W0lrDHiQnxXHu57IJuBWStXYFLHoHV7Cx1CpsEBLVQs9et7XVIB8uV7Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FP2Tlz9Q; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FP2Tlz9Q"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926172; x=1799462172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=skx5Z1FRD0TJkNeSukwj3uFiF01xeq5AzlF8v99EXrw=;
  b=FP2Tlz9QtfJfyfpGxcH0kKrhPEA4sLMxqxrJc0R54o39CKm3UiCqDzZT
   ndMmYSc2p/r4PotaHMxuAD1CRZOi1vDQNuFiUK7KGdMHNCLln8NxFAn1c
   gWFmcCkDSq5qZIbUfwVehbS9vjYwt62EhsM0i4NPb4fZf4gliQLTcSdML
   RvusfeBJ+bAYeL0YfK8FF2+XWKsoEZLePgEAxcOJEJIu+uWAxpO4Paf6d
   /NAIHe7sWBHW/I3aWaAYM09nHotN2vxd6kWDmQxvT1jBz1/LbLzAN/CRl
   HKK3CQoohjty0I2bJUzn4zj9Qy5pFcx1kvuEDV21LcCeVStUWL4AGSspd
   w==;
X-CSE-ConnectionGUID: a7c0mpTAT5iciARlDP1neQ==
X-CSE-MsgGUID: Pnh2kRFPSziaDA30+6046g==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774581"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:12 +0800
IronPort-SDR: 6960699d_AkyEvLIM2LJHDTeXnMokKPGOI1aFXye/KobqIlQsw3J8Gnu
 Nfthi5v96X79Akq3G61a3nr9pykkhbtXk2PnZHQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:14 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:13 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 08/12] ioengine: remove finish_zone()
Date: Fri,  9 Jan 2026 11:35:59 +0900
Message-ID: <20260109023603.2848421-9-shinichiro.kawasaki@wdc.com>
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

Zone finish operation is no longer required, then the callback
function finish_zone() of I/O engines is not required either.
Remove it as well as its implementation libzbc_finish_zone()
for libzbc engine. Also increment FIO_IOOPS_VERSION to note
that struct ioengine_ops changed.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 engines/libzbc.c | 34 ----------------------------------
 ioengines.h      |  4 +---
 2 files changed, 1 insertion(+), 37 deletions(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 0fa6bfd1..1918bed7 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -350,39 +350,6 @@ static int libzbc_move_zone_wp(struct thread_data *td, struct fio_file *f,
 	return -ret;
 }
 
-static int libzbc_finish_zone(struct thread_data *td, struct fio_file *f,
-			      uint64_t offset, uint64_t length)
-{
-	struct libzbc_data *ld = td->io_ops_data;
-	uint64_t sector = offset >> 9;
-	unsigned int nr_zones;
-	struct zbc_errno err;
-	int i, ret;
-
-	assert(ld);
-	assert(ld->zdev);
-
-	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
-	assert(nr_zones > 0);
-
-	for (i = 0; i < nr_zones; i++, sector += td->o.zone_size >> 9) {
-		ret = zbc_finish_zone(ld->zdev, sector, 0);
-		if (ret)
-			goto err;
-	}
-
-	return 0;
-
-err:
-	zbc_errno(ld->zdev, &err);
-	td_verror(td, errno, "zbc_finish_zone failed");
-	if (err.sk)
-		log_err("%s: finish zone failed %s:%s\n",
-			f->file_name,
-			zbc_sk_str(err.sk), zbc_asc_ascq_str(err.asc_ascq));
-	return -ret;
-}
-
 static int libzbc_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				     unsigned int *max_open_zones)
 {
@@ -486,7 +453,6 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.reset_wp		= libzbc_reset_wp,
 	.move_zone_wp		= libzbc_move_zone_wp,
 	.get_max_open_zones	= libzbc_get_max_open_zones,
-	.finish_zone		= libzbc_finish_zone,
 	.queue			= libzbc_queue,
 	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
 };
diff --git a/ioengines.h b/ioengines.h
index 3d220a73..fd2c1242 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "dataplacement.h"
 
-#define FIO_IOOPS_VERSION	39
+#define FIO_IOOPS_VERSION	40
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -65,8 +65,6 @@ struct ioengine_ops {
 				  unsigned int *);
 	int (*get_max_active_zones)(struct thread_data *, struct fio_file *,
 				    unsigned int *);
-	int (*finish_zone)(struct thread_data *, struct fio_file *,
-			   uint64_t, uint64_t);
 	int (*fdp_fetch_ruhs)(struct thread_data *, struct fio_file *,
 			      struct fio_ruhs_info *);
 	int option_struct_size;
-- 
2.49.0

