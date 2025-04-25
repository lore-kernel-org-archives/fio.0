Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EE41F4C8E
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 05:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745558515; cv=none; b=QsEFX4YHOHJcZt0VNTr4pivno+KorcaNBXdc7TsUeF1NQIOOocvOlxqDj++sB+SUjPVX4bgSvP8s8XX+2dIoWMxIeaUR8QmW+QMquqFrmR9xMYQMobxRRSFeSvYfTVWmzG0pX7WcMHF3/Tu5KjdaZVNqcpYtuYQjTu3/vj6bhmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745558515; c=relaxed/simple;
	bh=9wfE3dkXUIRTS5k+UWJ4lIIDG7DUdTCp88BQikM65g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdlgrZWFdDhLyIeJ4mwfr4dCjx6J/0+w7vhxJueZZ3DknC0K906lcJEcWDJ40OeU24M9Sum+PrIAFYfS1n7iLmU1xnFPRHWJGksPIlQ2B9YOuoEaKbQJLyWSdFuXsTWa8rE7Q70Al7peKtWCINTB0aU61klRWf08h7jOmr5KXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=p5pKKR+j; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="p5pKKR+j"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745558514; x=1777094514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9wfE3dkXUIRTS5k+UWJ4lIIDG7DUdTCp88BQikM65g4=;
  b=p5pKKR+j284iNM2htuhLNYrxKHhyOmsrZOXskpc9HVik0j3rO/wnqHTT
   9Eae84LAVdeSNtQPNBVUmZcFKy48dfNfEvB95ByRjAM9lyhyJQ6qs++0g
   oLcv5mlM73F8yLcannfeXKGkI6jAp1P2ZySggdHAKVvEemDZOLTaJWU3S
   QkjzOCDa1qnT+OtogFd+wNs1x4MEx210SbHlNMbqPmtd2K4HAkpmCBhqz
   nDI2yOLlpTsix3YKryFVnLceSsZdT4j4IHeQK53svHdOcBu5YHMZn1lJk
   sXE00WmDB3EXZtuhzRgRLP8++Lo3YyY4QdfYYQqJJA2op/UCSVue9cM2S
   A==;
X-CSE-ConnectionGUID: 9E8Ex0OkQX2Z04IQMBMArg==
X-CSE-MsgGUID: tJDmdaQsTh+kJ3ruoFw9xQ==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="82381446"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 13:21:54 +0800
IronPort-SDR: 680b0dd6_xUdYNDLDiOI9EHn1wF+ddYN0MlGSzYp5cHNzDFqYMz7lvSB
 8KJQVKzelB8Ln5HwnFHz8kbCpxKaLG3kWf13gYA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Apr 2025 21:21:42 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Apr 2025 22:21:53 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 4/8] zbd: introduce zbd_move_zone_wp()
Date: Fri, 25 Apr 2025 14:21:44 +0900
Message-ID: <20250425052148.126788-5-shinichiro.kawasaki@wdc.com>
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

