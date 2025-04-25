Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AE1136E37
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 05:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745558515; cv=none; b=oneAWPKd4LUBs/4fKVSuj631IyLX1VuM9reYVg5XjEF7w4mhF2GQ7gtT1uTeQwr60i7S/+6Ge2A337dfok5fx8g9YVI111h2O9cXWHVKoNZy8rMJmh70zkm626FiWfYTDbVQwcSpLqqAKGg1RGM8G+25gGoPuLxfj2RV6Bgn9FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745558515; c=relaxed/simple;
	bh=/fskUVtlOoWzIpkw8XV0tHhoCji2zc2nrLnQL7V58p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBhlzLx0IoZys0d83AB3R9fWtA3HVn5un0Ev66kc7uSISPBr+AUeoyUGo2UsLvYCS+tBjrcyR0RMR4D24vS4cZdovnlIaf/5tAn3iQqVZ6I5WH4BtR5GDNUFpyH16cZg2rLlAIxEjwB8BhQAWEs1MiGWNkeUyAsTn/PkWmBEqNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=G9ItgO1p; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="G9ItgO1p"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745558513; x=1777094513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/fskUVtlOoWzIpkw8XV0tHhoCji2zc2nrLnQL7V58p4=;
  b=G9ItgO1pJhj2kpU60UuVN3G3/s+ms2BgSs6opflnrBdN0YlAl2JfXueR
   oev9UAU8T9j+PVNG+ovsKKi9d8B4rh2XF6YasIXWMaNk/Kif+pa09kA2J
   tRd5LDTFmVXFc91oWzhUpeNhCB4DT9uF/DqrvFbp9MevW6zj2JxqGnYmd
   X09q4+kYxOvDdTpMX0MEid/aP5QxhMlsHF1hGAqFPeJx02DhLBBlGU0Yk
   hSXHaYvchZ2swyild1a1Iy4JF2n+O32q6pIAH/IDc6Aa5iKrahduT8FCA
   NyImffYLH1+2ZvajZVpfDciL6VwX8ygx8Zq1oTq6KXNWFAunvaIHPQxgp
   A==;
X-CSE-ConnectionGUID: MNk4jzkFTq+IiiMOSuet4g==
X-CSE-MsgGUID: fEDYUESXSSq/RzwPjU/rjQ==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="82381445"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 13:21:52 +0800
IronPort-SDR: 680b0dd5_ifJCKGRaQ8WaNTXDENeO4aKa3H7hbWIVVzIXuA45m29LVf+
 a29LQ4xdvZEBkFyfvognywbMnSpz8bQm5JrSOnw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2025 21:21:41 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Apr 2025 22:21:52 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 3/8] engines/libzbc: implement move_zone_wp callback
Date: Fri, 25 Apr 2025 14:21:43 +0900
Message-ID: <20250425052148.126788-4-shinichiro.kawasaki@wdc.com>
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

As a preparation for continue_on_error option support for zonemode=zbd,
implement move_zone_wp() callback for libzbc IO engine.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 engines/libzbc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 1bf1e8c8..0fa6bfd1 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -323,6 +323,33 @@ err:
 	return -ret;
 }
 
+static int libzbc_move_zone_wp(struct thread_data *td, struct fio_file *f,
+			       struct zbd_zone *z, uint64_t length,
+			       const char *buf)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	uint64_t sector = z->wp >> 9;
+	size_t count = length >> 9;
+	struct zbc_errno err;
+	int ret;
+
+	assert(ld);
+	assert(ld->zdev);
+	assert(buf);
+
+	ret = zbc_pwrite(ld->zdev, buf, count, sector);
+	if (ret == count)
+		return 0;
+
+	zbc_errno(ld->zdev, &err);
+	td_verror(td, errno, "zbc_write for write pointer move failed");
+	if (err.sk)
+		log_err("%s: wp move failed %s:%s\n",
+			f->file_name,
+			zbc_sk_str(err.sk), zbc_asc_ascq_str(err.asc_ascq));
+	return -ret;
+}
+
 static int libzbc_finish_zone(struct thread_data *td, struct fio_file *f,
 			      uint64_t offset, uint64_t length)
 {
@@ -457,6 +484,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.get_zoned_model	= libzbc_get_zoned_model,
 	.report_zones		= libzbc_report_zones,
 	.reset_wp		= libzbc_reset_wp,
+	.move_zone_wp		= libzbc_move_zone_wp,
 	.get_max_open_zones	= libzbc_get_max_open_zones,
 	.finish_zone		= libzbc_finish_zone,
 	.queue			= libzbc_queue,
-- 
2.49.0

