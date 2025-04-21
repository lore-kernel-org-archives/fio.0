Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A81264A84
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239118; cv=none; b=A0oqTlpFLli+XM1xN+jrwzF+Q8D/mowiKdcLkrknbJ/YarCvga/V33b5MMjYVfrvYJZArtm5TjjiR4mcaXZdgrsAtvdHzdxRWxont9e9okbdEQ+bh3sh29MnahZwrK76mJ8lvDWwFIoCR/tOuh/DYbb6+NOGEQZzXvwj89CVDBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239118; c=relaxed/simple;
	bh=B7dc3b1OLIyW0q7P83L3wqtupl8H4a/8k1OPWHtTb6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvZ80FtLr0HU0tNlJVymv8sFFqldJ2DOOyJ4qr0GsBEJReE8b5hP4qRX1xK/3FqRhPO4GD7LeKFVq3tHWNHOx1qvZ4thr6/fBMvHIXy1VA2aWbPRhCfaFpnO/QdiKZRPXlU0OHmSfNyEKr5uesQjCiFc56OquET9EiCst7HazKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hWSTGa7d; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hWSTGa7d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239116; x=1776775116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B7dc3b1OLIyW0q7P83L3wqtupl8H4a/8k1OPWHtTb6w=;
  b=hWSTGa7dZ27ZkbXqshmgOkFcCdjko7TIZUEbRAz1iowyRoJqoP4OKcjb
   oYy/MpBMKJWSYs4eU0qmST57T+/m/f+JELpnB0eqMWINyn0v5m7mB+Tp6
   LLBvS7CFh+8Bgp00i4bPNcS1UF51bawHadaN6EDjmWiW/6crOhi1kASiX
   J6EJuKuyqJ5gy5ixYjY75u+Q0ZumJRAR94BmSyc9Dc2e2jRFsB+Jn/Ryn
   DH4n3XJs0HIeDWUeFqKXCf6XoGmG3fGatUZYK4/xzn+O+4N9dfrCI1ViJ
   1PzyzKWkPRmIf/+tXwGinCQHypMrMrhhmsZ9UrWAQHfPKz+iZWnzGEyrE
   Q==;
X-CSE-ConnectionGUID: eo9pMJ7CQZG8F7nJfIHeQQ==
X-CSE-MsgGUID: 0oNWo2RwRH6U3moJ1XT0mg==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027515"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:30 +0800
IronPort-SDR: 68062e30_G0eC6mm17IullzpgQvm3pXuJNc2F+eK/roGs7FcIiqDJYJe
 e+S6OJAQR4/wr/4hw/821cgkW1S/bMzW4BzKvmA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:24 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:30 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/8] oslib: blkzoned: add blkzoned_move_zone_wp() helper function
Date: Mon, 21 Apr 2025 21:38:21 +0900
Message-ID: <20250421123828.82712-2-shinichiro.kawasaki@wdc.com>
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
introduce a new function blkzoned_move_zone_wp(). It moves the write
pointer by data write. If data buffer is provided, call pwrite() system
call. If data buffer is not provided, call fallocate() to write zero
data.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 oslib/blkzoned.h       |  3 +++
 oslib/linux-blkzoned.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index e598bd4f..3a4c73c2 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -16,6 +16,9 @@ extern int blkzoned_report_zones(struct thread_data *td,
 				struct zbd_zone *zones, unsigned int nr_zones);
 extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
+extern int blkzoned_move_zone_wp(struct thread_data *td, struct fio_file *f,
+				 struct zbd_zone *z, uint64_t length,
+				 const char *buf);
 extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				       unsigned int *max_open_zones);
 extern int blkzoned_get_max_active_zones(struct thread_data *td,
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 1cc8d288..78e25fca 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -370,3 +370,32 @@ int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 
 	return ret;
 }
+
+int blkzoned_move_zone_wp(struct thread_data *td, struct fio_file *f,
+			  struct zbd_zone *z, uint64_t length, const char *buf)
+{
+	int fd, ret = 0;
+
+	/* If the file is not yet open, open it for this function */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_WRONLY | O_DIRECT);
+		if (fd < 0)
+			return -errno;
+	}
+
+	/* If write data is not provided, fill zero to move the write pointer */
+	if (!buf) {
+		ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, z->wp, length);
+		goto out;
+	}
+
+	if (pwrite(fd, buf, length, z->wp) < 0)
+		ret = -errno;
+
+out:
+	if (f->fd < 0)
+		close(fd);
+
+	return ret;
+}
-- 
2.49.0

