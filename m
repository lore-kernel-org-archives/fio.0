Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B813A3ED
	for <fio@vger.kernel.org>; Thu,  9 Oct 2025 02:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977573; cv=none; b=WC13yU8JROCLQb7DMTrLiXOdYgpCwKwWy81OJxaPYiQn9oKEV8ywJJsBj6jTArskd9c6D3tE0T24En6tG7AXZ78bE8hOtm+mnLkHyUzcqdENLvIJlZJaaRE5d0Dm/5ln7okUVUj3cnX9Q7Ym4KxPUxkwH3CND3mo30h9msRxl3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977573; c=relaxed/simple;
	bh=RQFdTSagIjypiKg2v8XVFR35p6sCElL8ReCWMLJJCps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laPx1BX8sEcj7h5jOFNuIdThePdr/eKXU286xDs0iZiY1/HCgyfD4oPeDIpNU6vr4wnt+BOBO4ijAf6pQBtqt6ESMp9MF3FbsiRNNf275C3ERDEee/gWEp4HuSdJTzQVfKf6mMTc/BhIdkCOVmA3NZCrH1lrZhuAzEwMVSAZ1wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Kt1e9m5S; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Kt1e9m5S"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759977571; x=1791513571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RQFdTSagIjypiKg2v8XVFR35p6sCElL8ReCWMLJJCps=;
  b=Kt1e9m5SFEO1UOx32TwuWXfGyspB6m+TaUMvb0wCDSJN9l3pKlg0lRt0
   QLvVAxYHJlHgWjxNznHBFHCfeN4k9xmd9uVbZykYcrwixOxgWNDwP2Ps4
   xoKiKTqYjrQ5XauLpWbwhI7QoUzLIskvasYUxpA5jplVlpNe1LWwVXOVK
   39uVGT8M2IaLjmlkL1NLoPnuuQ9S1I8YaTUkMIP4D+tYzdX8zUVBth4CB
   XiJXdMGOlN19PChbTxay0JI6brfPVKtpdubvTg4L//akjwf0a1701uMwJ
   cEY/lp5H2B5Gu66XAuGFoHHoIc+ZCdInksePz5ZriBjc7cjyFbCKLbSwC
   g==;
X-CSE-ConnectionGUID: OSFjgFrnREyhdC/lqqatYQ==
X-CSE-MsgGUID: VGnFw21fRdemiMulZhP8iQ==
X-IronPort-AV: E=Sophos;i="6.19,215,1754928000"; 
   d="scan'208";a="132880593"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Oct 2025 10:39:30 +0800
IronPort-SDR: 68e72062_6M61DSG4l9k6q4krrXpPI03Z/LmL1cfoxfbHXwx3/N/bjYy
 WGJtWPXk6HHsJGAJE9h/WEQQBdO5l7ppkqXNLJQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Oct 2025 19:39:31 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Oct 2025 19:39:30 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/2] stat: report zone reset count only when zonemode is set to zbd
Date: Thu,  9 Oct 2025 11:39:27 +0900
Message-ID: <20251009023928.1634382-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
References: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
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
relevant functions fio_server_send_ts() and convert_ts(). Bump up
FIO_SERVER_VER since these changes affect the struct cmd_ts_pdu that is
sent out from fio server.

Set the flag count_zone_resets only when the zbd zonemode is set, and
the workload is write or trim. Refer to the flag in show_ddir_status()
to determine if the zone reset count should be reported. Also refer to
the flag in sum_thread_stats() to decide if the nr_zone_resets field
should be summed up.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 client.c | 4 +++-
 server.c | 4 +++-
 server.h | 2 +-
 stat.c   | 7 +++++--
 stat.h   | 9 +++++----
 zbd.c    | 4 ++++
 6 files changed, 21 insertions(+), 9 deletions(-)

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
diff --git a/server.h b/server.h
index 5246af5c..139f84b1 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 113,
+	FIO_SERVER_VER			= 114,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
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

