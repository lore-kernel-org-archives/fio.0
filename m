Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3425.houston.hpe.com ([15.241.140.78]:51628 "EHLO
        g4t3425.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941596AbcLVUrr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 15:47:47 -0500
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id A392271
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 20:47:46 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 06/12] Line up colons across read, write, and trim thread stats
Date: Thu, 22 Dec 2016 14:50:45 -0600
Message-Id: <20161222205051.4677-6-elliott@hpe.com>
In-Reply-To: <20161222205051.4677-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
 <20161222205051.4677-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Line up the colons across the read, write, and trim
thread stats rows.

Example:
drive_0: (groupid=0, jobs=576): err= 0: pid=42198: Wed Dec 21 19:51:35 2016
  read : io=420642MB, bw=33953MB/s, iops=8289.3K, runt= 12389msec
  write: io=325276MB, bw=26177MB/s, iops=6390.9K, runt= 12426msec
  trim: io=0MB, bw=0MB/s, iops=0, runt= 12426msec

becomes:
drive_0: (groupid=0, jobs=576): err= 0: pid=42198: Wed Dec 21 19:51:35 2016
   read: io=420642MB, bw=33953MB/s, iops=8289.3K, runt= 12389msec
  write: io=325276MB, bw=26177MB/s, iops=6390.9K, runt= 12426msec
   trim: io=0MB, bw=0MB/s, iops=0, runt= 12426msec
---
 stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index 3e57e54..ebc5c78 100644
--- a/stat.c
+++ b/stat.c
@@ -380,7 +380,7 @@ static void display_lat(const char *name, unsigned long min, unsigned long max,
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			     int ddir, struct buf_output *out)
 {
-	const char *str[] = { "read ", "write", "trim" };
+	const char *str[] = { " read", "write", " trim" };
 	unsigned long min, max, runt;
 	unsigned long long bw, iops;
 	double mean, dev;
-- 
2.9.3

