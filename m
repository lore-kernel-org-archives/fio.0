Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2967525A2C8
	for <fio@vger.kernel.org>; Fri, 10 Oct 2025 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760097617; cv=none; b=CqFOUp78U+sCcjCAZH/RuhSFh0XykCKPin8kU7jIKdECNdjb2ND6Yz/BXLVopfgvZG3ZCESKOqjSWMKYn1EZW8PlgDIGAIKcXoBvJo06qzg2yP5oGg0jR9Mh1QqXaxjgXbk0EnIxBQ6PXMUWfuZ/+wuXbpwDBmk+T0p61ZUQI0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760097617; c=relaxed/simple;
	bh=GfxTOOkc38sf5z3z5DFW03q635BSyspj9ZM8QFrEemI=;
	h=Subject:From:To:Date:Message-Id; b=USINVpnuPVta06c+wEjxSZ/93emobEXGkmhXu3PlCmwztTgszaYEXGnYkL30krs1V5BbFOKMH95DzW6Fk/BjKnuiIS4OwF/9/VV6XyOIHIlCKTnLWeAWGum342ANqg0oBmez0QSxIlUnrKiKTEZbmthT6RZDr9B44FsYeB4LmHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NOitP3cA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NOitP3cA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=G7i1XWQlhDELqKi7+8R0/lhka2CdBABkdPCFLxd/wos=; b=NOitP3cADeLNMKfTnlClpd26c0
	/C0wFAo2vf4+Bn0ofmGlRArOWsfIoPC8T8E+7ra9BELlNE5jItpUVroMsFoaOBSBfQlmQhH382ebZ
	HMEEm1O9MIzfroIlqYLRPGo5huaOHrYDojtw4JQ9qxJLjVy2rEWCJ0aCz3UtGoslF9Ys6RbqTtuMs
	IXT3sXc2mIWEn56KafMf8jR16sjVGjhDukJYyfY98SRL8XJ5m9KKuxmGXGDVMRe/qgTYRFAob69ep
	Y3AYGFNu1OkkJsgn/1GzdB0FcKLT2HMxBO6MBA4wpDwvbI1rbIUobz38MyaXu7dC2YGYUHFRpomJN
	lQ3jAo/A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v7Bn1-0000000ANhj-2JO6
	for fio@vger.kernel.org;
	Fri, 10 Oct 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 22A811BC0147; Fri, 10 Oct 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 10 Oct 2025 06:00:02 -0600
Message-Id: <20251010120002.22A811BC0147@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ed31254c1bb4e88d1b3812c06212b50dcba795bc:

  Merge branch 'fix-includes' of https://github.com/betonmischer86/fio (2025-10-08 08:15:36 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b9b306b542afb8a3059c2035fb2034a89e4660d1:

  stat: report zone reset count in json output format (2025-10-09 13:16:51 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      stat: report zone reset count only when zonemode is set to zbd
      stat: report zone reset count in json output format

 client.c |  4 +++-
 server.c |  4 +++-
 server.h |  2 +-
 stat.c   | 11 +++++++++--
 stat.h   |  9 +++++----
 zbd.c    |  4 ++++
 6 files changed, 25 insertions(+), 9 deletions(-)

---

Diff of recent changes:

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
index 1151a09f..a67d3551 100644
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
@@ -1946,6 +1946,10 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		json_object_add_value_array(data, "bw", bw);
 	}
 
+	if (ts->count_zone_resets)
+		json_object_add_value_int(root, "zone_resets",
+					  ts->nr_zone_resets);
+
 	return root;
 }
 
@@ -2360,7 +2364,10 @@ void sum_thread_stats(struct thread_stat *dst, const struct thread_stat *src)
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
