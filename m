Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EDA233136
	for <fio@vger.kernel.org>; Wed,  8 Oct 2025 09:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759916932; cv=none; b=k+MJABhKgjqHUa8d/NQcnJy2XcsmHI1sqAz9Th8Id6HfXrXNJBGXLKs/3GGU5IY1pqm8ZdECJftPYKxghAAeUJu+For+PHakgfaGG+zWxKGd5QaJRgaIMF37EHxKwO5C1VhdCLY8EpyFRx0evOHFaONOGIDD3JmCRCx1UBrhEDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759916932; c=relaxed/simple;
	bh=EDVUsWdfUah9uDzU9atEPwUwye8e3zoc6MklSphIlxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCjkQtfI47ylDSnb+zXqqnre21rwgrXuuLmhFpD5UiXgFVoRoFI4p9UzKZE4w9lQg6JB2MvEugWAVbs97oBVp+sZNwiLYqPqrisYemr8+TlyHzrRdd/bmEJwJRUK7Fh77oSReFoxKBHupfbkHcFACUXnlsaxJJLxQ/B8OYsNA3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kkog/6OD; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kkog/6OD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759916931; x=1791452931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EDVUsWdfUah9uDzU9atEPwUwye8e3zoc6MklSphIlxM=;
  b=kkog/6ODBcDs5ewV0WfMXtjA4InrXdF1QtgY3c1/I3bAckMrmgmD9dFw
   zGpsRSy1xoQ5Gh1kpWvlDygJLxb0Zt9/3qfrCc2N4jxvgQk/dmvO4/xIT
   I2Z+n63+I19jEnyofZVm0bmdxOSzJUmUzwm7u10fnjnR7ze4u+aRgWEDm
   qHffSSAtVXfhsj5ryeq9LVFT4lmWLWzJdx44H65KsBVnAHP+9jFYJ3MvS
   +mWfwCj/ptG/+a/PHBbg2AdyqmWi8oFuR0OqYMNgGUQWTELLK4BwTJNm5
   0M0S1D3Fr11XMaxpdi+afYtdssupNLrL6YhXIiFMCXvfI0f/br0BnJf3T
   Q==;
X-CSE-ConnectionGUID: X7YPGz/NRb+cIa1vR7kM7g==
X-CSE-MsgGUID: baesX0O0TZKi4C8aoqaizQ==
X-IronPort-AV: E=Sophos;i="6.18,323,1751212800"; 
   d="scan'208";a="129836314"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2025 17:48:50 +0800
IronPort-SDR: 68e63382_Ri4vj75oyFQPnATth3cRjYwCPRPkFB05YPLxaxQyLQoqVnS
 UYqQIKA+yqT0BdX8LkglPyttsT/lsftqvJ65iKw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Oct 2025 02:48:50 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Oct 2025 02:48:50 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] stat: report zone reset count only when zonemode is set to zbd
Date: Wed,  8 Oct 2025 18:48:46 +0900
Message-ID: <20251008094847.1628954-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
References: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, fio reports the zone reset count regardless of whether the
zbd zonemode is specified. Reporting the zone reset count lacking the
zbd zonemode is irrelevant and unnecessary.

Suppress the zone reset count report unless the zbd zonemode is
specified. For that purpose, introduce the new flag "count_zone_resets"
to the struct thread_stat. To maintain 32-bit alignment of the struct,
repurpose the existing "pad3" field to allocate the flag. To group the
related fields together, move the field "nr_zone_resets" and
"latency_depth" within the struct. Make corresponding adjustments in the
relevant functions fio_server_send_ts() and convert_ts(). Set the flag
count_zone_resets only when the zbd zonemode is set, and the workload is
write or trim. Refer to the flag in show_ddir_status() to determine if
the zone reset count should be reported. Also refer to the flag in
sum_thread_stats() to decide if the nr_zone_resets field should be
summed up.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 client.c | 4 +++-
 server.c | 4 +++-
 stat.c   | 7 +++++--
 stat.h   | 9 +++++----
 zbd.c    | 4 ++++
 5 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/client.c b/client.c
index 923b092e..8c0744b8 100644
--- a/client.c
+++ b/client.c
@@ -1027,7 +1027,6 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 
 	dst->total_submit	= le64_to_cpu(src->total_submit);
 	dst->total_complete	= le64_to_cpu(src->total_complete);
-	dst->nr_zone_resets	= le64_to_cpu(src->nr_zone_resets);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		dst->io_bytes[i]	= le64_to_cpu(src->io_bytes[i]);
@@ -1043,6 +1042,9 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 
 	dst->sig_figs		= le32_to_cpu(src->sig_figs);
 
+	dst->nr_zone_resets	= le64_to_cpu(src->nr_zone_resets);
+	dst->count_zone_resets	= le16_to_cpu(src->count_zone_resets);
+
 	dst->latency_depth	= le32_to_cpu(src->latency_depth);
 	dst->latency_target	= le64_to_cpu(src->latency_target);
 	dst->latency_window	= le64_to_cpu(src->latency_window);
diff --git a/server.c b/server.c
index 5967f421..efb31879 100644
--- a/server.c
+++ b/server.c
@@ -1770,7 +1770,6 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	p.ts.total_submit	= cpu_to_le64(ts->total_submit);
 	p.ts.total_complete	= cpu_to_le64(ts->total_complete);
-	p.ts.nr_zone_resets	= cpu_to_le64(ts->nr_zone_resets);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		p.ts.io_bytes[i]	= cpu_to_le64(ts->io_bytes[i]);
@@ -1784,6 +1783,9 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.kb_base		= cpu_to_le32(ts->kb_base);
 	p.ts.unit_base		= cpu_to_le32(ts->unit_base);
 
+	p.ts.nr_zone_resets	= cpu_to_le64(ts->nr_zone_resets);
+	p.ts.count_zone_resets	= cpu_to_le16(ts->count_zone_resets);
+
 	p.ts.latency_depth	= cpu_to_le32(ts->latency_depth);
 	p.ts.latency_target	= cpu_to_le64(ts->latency_target);
 	p.ts.latency_window	= cpu_to_le64(ts->latency_window);
diff --git a/stat.c b/stat.c
index 1151a09f..76b74b3c 100644
--- a/stat.c
+++ b/stat.c
@@ -565,7 +565,7 @@ static void show_ddir_status(const struct group_run_stats *rs, struct thread_sta
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
 	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
-	if (ddir == DDIR_WRITE || ddir == DDIR_TRIM)
+	if (ts->count_zone_resets)
 		post_st = zbd_write_status(ts);
 	else if (ddir == DDIR_READ && ts->cachehit && ts->cachemiss) {
 		uint64_t total;
@@ -2360,7 +2360,10 @@ void sum_thread_stats(struct thread_stat *dst, const struct thread_stat *src)
 	dst->total_run_time += src->total_run_time;
 	dst->total_submit += src->total_submit;
 	dst->total_complete += src->total_complete;
-	dst->nr_zone_resets += src->nr_zone_resets;
+	if (src->count_zone_resets) {
+		dst->count_zone_resets = 1;
+		dst->nr_zone_resets += src->nr_zone_resets;
+	}
 	dst->cachehit += src->cachehit;
 	dst->cachemiss += src->cachemiss;
 }
diff --git a/stat.h b/stat.h
index 02bea976..f40507e3 100644
--- a/stat.h
+++ b/stat.h
@@ -233,17 +233,18 @@ struct thread_stat {
 	uint32_t first_error;
 	uint64_t total_err_count;
 
-	/* ZBD stats */
-	uint64_t nr_zone_resets;
-
 	uint64_t nr_block_infos;
 	uint32_t block_infos[MAX_NR_BLOCK_INFOS];
 
 	uint32_t kb_base;
 	uint32_t unit_base;
 
+	/* ZBD stats */
+	uint64_t nr_zone_resets;
+	uint16_t count_zone_resets; /* Flag to enable nr_zone_resets */
+	uint16_t pad3;
+
 	uint32_t latency_depth;
-	uint32_t pad3;
 	uint64_t latency_target;
 	fio_fp64_t latency_percentile;
 	uint64_t latency_window;
diff --git a/zbd.c b/zbd.c
index 8f0e4bc6..7a66b665 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1284,6 +1284,10 @@ int zbd_setup_files(struct thread_data *td)
 		return 1;
 	}
 
+	/* Enable zone reset stat report for write and trim workloads */
+	if (td_write(td) || td_trim(td))
+		td->ts.count_zone_resets = 1;
+
 	for_each_file(td, f, i) {
 		struct zoned_block_device_info *zbd = f->zbd_info;
 		struct fio_zone_info *z;
-- 
2.49.0

