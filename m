Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E91264F89
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239120; cv=none; b=fbesbxB1UOirhxPRMqnRsA8C5snu/PY6wQk9SE5xOACnVWNphn0CUr+q6ZLzFsXtu/uKKACzY8RCu9kiyzG1cm1+fEz3Sd3Jdne38kGCG2rxZJZ5kwKK8uzr/SVfcRPk9Dv9hvDnDBRMrSz4Cy5ehbBF1OvXmaqSRSMmQn/dNMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239120; c=relaxed/simple;
	bh=/fskUVtlOoWzIpkw8XV0tHhoCji2zc2nrLnQL7V58p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFZxISSwbpeR25HrFFkR5T33JsTA779SMiTyXSRVmcv3va8bnUyytTZJWVa9pbXQMmEOnf4p376umdx32Kx+ZSaK0XTI1+XiA06xmXfPxPHdax0Hlw2q3ashfIp/NMLh4w3e1y1FYWt+aor56e8+upwIpxKzeMpXkTZI/V87tRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nPvEriSl; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nPvEriSl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239118; x=1776775118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/fskUVtlOoWzIpkw8XV0tHhoCji2zc2nrLnQL7V58p4=;
  b=nPvEriSlPhJ9UMYarihsJWJZeNbDzeItwLKE/1WeAt/6zIn6d6gLj5df
   hnKrzrRg63scXv0QvaG5NYLLojkxenggogYJ61hLcjJ0poCTJE3mID1gF
   ba6dGYShwitt+a1plbYHxZ6/Cz9eSk3Dv6VA/ahLOldvWHNlz8IV6Jaq4
   j3xZJatcBqWyjGK+T8hBcaW1m/0RqTWaNLYWtrb30fJRm1beX6kyIGdny
   M531orJy9lbBBsEWdnM0IbIcniTX27kbHzEi2PvBGUPx1hlqAZ8xWvrhe
   cr+h0FJqFWyNqQzgDYEJ/1LxMvediq//MvkXGzzRF4Ix2sbmtGNDCjhT+
   w==;
X-CSE-ConnectionGUID: 7InsvLY+T4mg/DVHUIesDQ==
X-CSE-MsgGUID: BZgGDKI8RzCxkT2mSb+SLA==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027519"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:32 +0800
IronPort-SDR: 68062e32_ceLeZqMEPEW0cxzyayNpVvalL9zYFb5Mgcs3NMq0NIDvvU4
 az+3i3PNJO3fSjdQw7wpSQzMpI5w9j80c0FdNig==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:27 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:32 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/8] engines/libzbc: implement move_zone_wp callback
Date: Mon, 21 Apr 2025 21:38:23 +0900
Message-ID: <20250421123828.82712-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
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

