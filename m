Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59086 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847AbZDSNHd (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 19 Apr 2009 09:07:33 -0400
Received: by fxm2 with SMTP id 2so1535418fxm.37
        for <fio@vger.kernel.org>; Sun, 19 Apr 2009 06:07:31 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 19 Apr 2009 15:07:31 +0200
Message-ID: <ed038eb20904190607l1f3dde9bi9e595f3b6bdefec6@mail.gmail.com>
Subject: Bug in stats, KB/s vs. KiB/s?
From: Carl Henrik Lunde <chlunde@ping.uio.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi!  I think there's a bug in the stats report:

When I specify rate=8192 I got 8388 KiB/s in the report, which happens
to be 8192*1.024.

I believe the problem is that bytes / ms is used as KiB/s.  I'm not
sure what the correct value of "base" should be (1000 vs. 1024), but
it doesn't affect the result.  I haven't reviewed all the reporting,
but at least I *think* these three are wrong.

diff --git a/stat.c b/stat.c
index 5fecbd0..9fd0255 100644
--- a/stat.c
+++ b/stat.c
@@ -199,10 +199,10 @@ static void show_ddir_status(struct
group_run_stats *rs, struct thread_stat *ts,
        if (!ts->runtime[ddir])
                return;

-       bw = ts->io_bytes[ddir] / ts->runtime[ddir];
+       bw = (1000 * ts->io_bytes[ddir]) / ts->runtime[ddir];
        iops = (1000 * ts->total_io_u[ddir]) / ts->runtime[ddir];
-       io_p = num2str(ts->io_bytes[ddir] >> 10, 6, 1000, 1);
-       bw_p = num2str(bw, 6, 1000, 1);
+       io_p = num2str(ts->io_bytes[ddir] >> 10, 6, 1024, 1);
+       bw_p = num2str(bw >> 10, 6, 1024, 1);
        iops_p = num2str(iops, 6, 1, 0);

        log_info("  %s: io=%siB, bw=%siB/s, iops=%s, runt=%6lumsec\n",
@@ -623,8 +623,9 @@ void show_run_stats(void)

                        bw = 0;
                        if (ts->runtime[j])
-                               bw = ts->io_bytes[j]
-                                       / (unsigned long long) ts->runtime[j];
+                               bw = (1000 * ts->io_bytes[j])
+                                       / (unsigned long long) ts->runtime[j]
+                                       / 1024;
                        if (bw < rs->min_bw[j])
                                rs->min_bw[j] = bw;
                        if (bw > rs->max_bw[j])
@@ -750,7 +751,7 @@ void add_bw_sample(struct thread_data *td, enum
fio_ddir ddir,
        if (spent < td->o.bw_avg_time)
                return;

-       rate = (td->this_io_bytes[ddir] - ts->stat_io_bytes[ddir]) / spent;
+       rate = (td->this_io_bytes[ddir] - ts->stat_io_bytes[ddir]) *
1000 / spent / 1024;
        add_stat_sample(&ts->bw_stat[ddir], rate);

        if (ts->bw_log)




-- 
mvh
Carl Henrik
