Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B65264FA4
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239120; cv=none; b=gFIEjJRrji5fS7XlTmU5lj93JBemhp5Eeqpml8mg4Hh3UkYEKZaWBAIFQKLbHBa8Xvjnvvb266FLT3KWI4l99iMH1OJh3R7QSJepggOTf7uS6UpecwRz0HcbymuyfnTRqjr8mf4Tu9dfM1xykUyPDtt03K6qAo6UjEonuUXHoK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239120; c=relaxed/simple;
	bh=9wfE3dkXUIRTS5k+UWJ4lIIDG7DUdTCp88BQikM65g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7+ZbU4gajFoSFmYK3adXMaVuV5n0XKszMLHrevuhlGaHZq1l0sqiME8Oby5RA9R2TNTDGmvolEFfB8EOw6pp0391bU3Z5wjZnVx4DOckDeaz2kOxmYMsU2xe79ilKicvM7XqO4KfFqU0PEB2On2MP96WvzXDVOWq3Mscwd/9vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZoqL50JS; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZoqL50JS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239118; x=1776775118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9wfE3dkXUIRTS5k+UWJ4lIIDG7DUdTCp88BQikM65g4=;
  b=ZoqL50JSpZ7UgS7tj0RPVjoM2fULtRELK7FE2JGmbb44QFZ5XL7qXAN0
   PdjepuuaTgvVy7SNPtBsdpTTQd2BQ/vjdARxDI/Dm1TGX6BA38xXsf0O9
   PD71P04EyrP7gDYqraS8pYq3e9NBghXPzHH5VlSPxqIfy6HYdw5IJ7JM9
   EYjb1vDLnpM3Aa1w3N8J+CEU3jCXz/5b1tshH9Dk8beSYJqw0KWtVr/Gt
   FC8PuJbx2F6ldxOf3yF3gKjNAmISMRjPb+HGAHDuZENRihKLMO8YknFGN
   dGCAjp8tDt/NUR6D3A93bBR+WYTjtrlrs+aegp9ROarSUW8Ws3kKvhymK
   g==;
X-CSE-ConnectionGUID: 4uGu4cUvQb2oXaDTlJdJlA==
X-CSE-MsgGUID: pG45jHNRTA2xfTSeVpHW4A==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027521"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:33 +0800
IronPort-SDR: 68062e34_RFd+/aiA5R9b5TVc0oVRcl82hHx3pHX9EVqmt45iF8+0Bee
 mQW/TF9lvrZRA+v6cUYcgyXxVFr762D15ctlBcQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:28 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:33 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/8] zbd: introduce zbd_move_zone_wp()
Date: Mon, 21 Apr 2025 21:38:24 +0900
Message-ID: <20250421123828.82712-5-shinichiro.kawasaki@wdc.com>
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
introduce the function zbd_move_zone_wp(). It moves write pointers by
calling blkzoned_move_zone_wp() or move_zone_wp() callback of IO
engines.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/zbd.c b/zbd.c
index 89519234..61770575 100644
--- a/zbd.c
+++ b/zbd.c
@@ -442,6 +442,46 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	return res;
 }
 
+/**
+ * zbd_move_zone_wp - move the write pointer of a zone by writing the data in
+ *               the specified buffer
+ * @td: FIO thread data.
+ * @f: FIO file for which to move write pointer
+ * @z: Target zone to move the write pointer
+ * @length: Length of the move
+ * @buf: Buffer which holds the data to write
+ *
+ * Move the write pointer at the specified offset by writing the data
+ * in the specified buffer.
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+static int zbd_move_zone_wp(struct thread_data *td, struct fio_file *f,
+			    struct zbd_zone *z, uint64_t length,
+			    const char *buf)
+{
+	int ret = 0;
+
+	switch (f->zbd_info->model) {
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		if (td->io_ops && td->io_ops->move_zone_wp)
+			ret = td->io_ops->move_zone_wp(td, f, z, length, buf);
+		else
+			ret = blkzoned_move_zone_wp(td, f, z, length, buf);
+		break;
+	default:
+		break;
+	}
+
+	if (ret < 0) {
+		td_verror(td, errno, "move wp failed");
+		log_err("%s: moving wp for %"PRIu64" sectors at sector %"PRIu64" failed (%d).\n",
+			f->file_name, length >> 9, z->wp >> 9, errno);
+	}
+
+	return ret;
+}
+
 /**
  * zbd_get_max_open_zones - Get the maximum number of open zones
  * @td: FIO thread data
-- 
2.49.0

