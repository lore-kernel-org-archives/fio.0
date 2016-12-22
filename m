Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:8418 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755324AbcLVGHa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 01:07:30 -0500
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com [15.241.140.78])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id D1EA21094
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:07:29 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id D407A58
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:34 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 09/12] Convert group_run_stats to use bytes instead of KiB/KB
Date: Thu, 22 Dec 2016 00:08:50 -0600
Message-Id: <20161222060853.64104-10-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

In group_run_stats, convert these fields:
* io_kb (bytes transferred)
* agg (aggregate average bandwidth)
* min_bw
* max_bw

from tracking either KiB or KB depending on kb_base to simply tracking bytes.
Rename io_kb to iobytes to match this new meaning.

This will simplify computing quantities and bandwidth rates with both IEC
binary and SI decimal unit prefixes (e.g., GiB/s and GB/s) in future patches.
---
 client.c |  2 +-
 server.c |  2 +-
 stat.c   | 23 +++++++++--------------
 stat.h   |  2 +-
 4 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/client.c b/client.c
index 48d4c52..1b4d3d7 100644
--- a/client.c
+++ b/client.c
@@ -972,7 +972,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->min_run[i]		= le64_to_cpu(src->min_run[i]);
 		dst->max_bw[i]		= le64_to_cpu(src->max_bw[i]);
 		dst->min_bw[i]		= le64_to_cpu(src->min_bw[i]);
-		dst->io_kb[i]		= le64_to_cpu(src->io_kb[i]);
+		dst->iobytes[i]		= le64_to_cpu(src->iobytes[i]);
 		dst->agg[i]		= le64_to_cpu(src->agg[i]);
 	}
 
diff --git a/server.c b/server.c
index 2e05415..b7ebd63 100644
--- a/server.c
+++ b/server.c
@@ -1444,7 +1444,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->min_run[i]		= cpu_to_le64(src->min_run[i]);
 		dst->max_bw[i]		= cpu_to_le64(src->max_bw[i]);
 		dst->min_bw[i]		= cpu_to_le64(src->min_bw[i]);
-		dst->io_kb[i]		= cpu_to_le64(src->io_kb[i]);
+		dst->iobytes[i]		= cpu_to_le64(src->iobytes[i]);
 		dst->agg[i]		= cpu_to_le64(src->agg[i]);
 	}
 
diff --git a/stat.c b/stat.c
index ebc5c78..f014e60 100644
--- a/stat.c
+++ b/stat.c
@@ -291,10 +291,10 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		if (!rs->max_run[i])
 			continue;
 
-		p1 = num2str(rs->io_kb[i], 6, rs->kb_base, i2p, 8);
-		p2 = num2str(rs->agg[i], 6, rs->kb_base, i2p, rs->unit_base);
-		p3 = num2str(rs->min_bw[i], 6, rs->kb_base, i2p, rs->unit_base);
-		p4 = num2str(rs->max_bw[i], 6, rs->kb_base, i2p, rs->unit_base);
+		p1 = num2str(rs->iobytes[i], 6, 1, i2p, 8);
+		p2 = num2str(rs->agg[i], 6, 1, i2p, rs->unit_base);
+		p3 = num2str(rs->min_bw[i], 6, 1, i2p, rs->unit_base);
+		p4 = num2str(rs->max_bw[i], 6, 1, i2p, rs->unit_base);
 
 		log_buf(out, "%s: io=%s, aggrb=%s/s, minb=%s/s, maxb=%s/s,"
 			 " mint=%llumsec, maxt=%llumsec\n",
@@ -1418,7 +1418,7 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
 		if (dst->min_bw[i] && dst->min_bw[i] > src->min_bw[i])
 			dst->min_bw[i] = src->min_bw[i];
 
-		dst->io_kb[i] += src->io_kb[i];
+		dst->iobytes[i] += src->iobytes[i];
 		dst->agg[i] += src->agg[i];
 	}
 
@@ -1696,19 +1696,14 @@ void __show_run_stats(void)
 				rs->max_run[j] = ts->runtime[j];
 
 			bw = 0;
-			if (ts->runtime[j]) {
-				unsigned long runt = ts->runtime[j];
-				unsigned long long kb;
-
-				kb = ts->io_bytes[j] / rs->kb_base;
-				bw = kb * 1000 / runt;
-			}
+			if (ts->runtime[j])
+				bw = ts->io_bytes[j] * 1000 / ts->runtime[j];
 			if (bw < rs->min_bw[j])
 				rs->min_bw[j] = bw;
 			if (bw > rs->max_bw[j])
 				rs->max_bw[j] = bw;
 
-			rs->io_kb[j] += ts->io_bytes[j] / rs->kb_base;
+			rs->iobytes[j] += ts->io_bytes[j];
 		}
 	}
 
@@ -1719,7 +1714,7 @@ void __show_run_stats(void)
 
 		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			if (rs->max_run[ddir])
-				rs->agg[ddir] = (rs->io_kb[ddir] * 1000) /
+				rs->agg[ddir] = (rs->iobytes[ddir] * 1000) /
 						rs->max_run[ddir];
 		}
 	}
diff --git a/stat.h b/stat.h
index 22083da..aa4ad80 100644
--- a/stat.h
+++ b/stat.h
@@ -7,7 +7,7 @@
 struct group_run_stats {
 	uint64_t max_run[DDIR_RWDIR_CNT], min_run[DDIR_RWDIR_CNT];
 	uint64_t max_bw[DDIR_RWDIR_CNT], min_bw[DDIR_RWDIR_CNT];
-	uint64_t io_kb[DDIR_RWDIR_CNT];
+	uint64_t iobytes[DDIR_RWDIR_CNT];
 	uint64_t agg[DDIR_RWDIR_CNT];
 	uint32_t kb_base;
 	uint32_t unit_base;
-- 
2.9.3

