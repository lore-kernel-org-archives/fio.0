Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17751F37D3
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 05:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745558514; cv=none; b=uadN0lyhbYZwIIaGLCjzD1e0CJvHwyEcQRtvT6WqZ+kpDpgQrIE2UMnJIyaNrx6Hkczr/PtK8KX5/GPOIcw4Prey5l5SmwG+mvwyjpYjgAtap4CsowFH5lMQ9QmRiX3nN17EZPe48iNrTa9/em8znn4/a+cshDNdJArt9Ex4Rvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745558514; c=relaxed/simple;
	bh=B7dc3b1OLIyW0q7P83L3wqtupl8H4a/8k1OPWHtTb6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeJlzN9ecmx4wbSnfkaMCAp0BMe1tDeXJYQUOMxINAIWQbkPzrHzwa+rZHN8KRmO4jAkqMXFYmhb/5la9OwNb3xKBKwhIkvlX31aTIDGIAOxKk060M8ktU8PB9Bk2xDh/I3OHdHwdX1Al284DiRqe/0J1Z4b9Bj6ABf6wMnqf2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hzAG1ato; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hzAG1ato"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745558512; x=1777094512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B7dc3b1OLIyW0q7P83L3wqtupl8H4a/8k1OPWHtTb6w=;
  b=hzAG1ato4IZ+Uz8zHnrzoqa2GL/SqF4TFt7uoxI1CqDuLBE/fxLy+2y+
   XlDlqmXNcG7dZOVLCCJapZo2+msXl9rPnsQjvD2ggoKs+8IhfCHRT1jkF
   cjrdYEBzS19kRbNGHFF/D8lU2pl1MxN685FKDNyy4YeZrT4Ox/zxLy1Qd
   jm8okQNJ08N+YICPwJkyb/vPQjsSla6d8AiDZCNtDcXprWWksjbtCs+fq
   d+FhINQlFz7ayYf/g3VWlNiS7EOdMYJ1LoJBHmDR4cWCM7fONN0PcJKid
   pfy5vSUVsjYYXXLATr4Q2Y2VFC5h/45AxcRyFb3fY5wxdiaQ6WXYe9AYv
   A==;
X-CSE-ConnectionGUID: GNGAehHeTg+bCE0fz+5CUA==
X-CSE-MsgGUID: AizlCcG2QD+1EPyC35soaQ==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="82381441"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 13:21:50 +0800
IronPort-SDR: 680b0dd2_AdlnriBvzZzkaUyhMpZ32vPiC08RHpSwggWkDmVi2yUqGLT
 ijSXS6nyUKE93X1uaQLxa7YwcXKuk2xyY3p0Qhw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2025 21:21:39 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Apr 2025 22:21:50 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/8] oslib: blkzoned: add blkzoned_move_zone_wp() helper function
Date: Fri, 25 Apr 2025 14:21:41 +0900
Message-ID: <20250425052148.126788-2-shinichiro.kawasaki@wdc.com>
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

