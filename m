Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34294 "EHLO
        mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934301AbcJEWPk (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Oct 2016 18:15:40 -0400
Received: by mail-pa0-f47.google.com with SMTP id rz1so667789pab.1
        for <fio@vger.kernel.org>; Wed, 05 Oct 2016 15:15:39 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 4/4] Update bandwidth log documentation
Date: Wed,  5 Oct 2016 15:15:29 -0700
Message-Id: <b7d06e572100b20436efcc95e3302f0f97dcf561.1475705698.git.osandov@fb.com>
In-Reply-To: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
References: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
In-Reply-To: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
References: <334c09f8e51802e0d751b485fe9e3538c430e9b3.1475705698.git.osandov@fb.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

The behavior of --bandwidth-log and write_bw_log has changed multiple
times, but the documentation hasn't been updated accordingly.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 README |  2 +-
 fio.1  | 16 ++++++++--------
 init.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/README b/README
index a69a578..a8a4fdf 100644
--- a/README
+++ b/README
@@ -149,7 +149,7 @@ $ fio
 	--parse-only		Parse options only, don't start any IO
 	--output		Write output to file
 	--runtime		Runtime in seconds
-	--bandwidth-log		Generate per-job bandwidth logs
+	--bandwidth-log		Generate aggregate bandwidth logs
 	--minimal		Minimal (terse) output
 	--output-format=type	Output format (terse,json,json+,normal)
 	--terse-version=type	Terse version output format (default 3, or 2 or 4).
diff --git a/fio.1 b/fio.1
index 8d596fb..48c2060 100644
--- a/fio.1
+++ b/fio.1
@@ -30,7 +30,7 @@ dump of the latency buckets.
 Limit run time to \fIruntime\fR seconds.
 .TP
 .B \-\-bandwidth\-log
-Generate per-job bandwidth logs.
+Generate aggregate bandwidth logs.
 .TP
 .B \-\-minimal
 Print statistics in a terse, semicolon-delimited format.
@@ -1462,13 +1462,13 @@ If set, this generates bw/clat/iops log with per file private filenames. If
 not set, jobs with identical names will share the log filename. Default: true.
 .TP
 .BI write_bw_log \fR=\fPstr
-If given, write a bandwidth log of the jobs in this job file. Can be used to
-store data of the bandwidth of the jobs in their lifetime. The included
-fio_generate_plots script uses gnuplot to turn these text files into nice
-graphs. See \fBwrite_lat_log\fR for behaviour of given filename. For this
-option, the postfix is _bw.x.log, where x is the index of the job (1..N,
-where N is the number of jobs). If \fBper_job_logs\fR is false, then the
-filename will not include the job index. See the \fBLOG FILE FORMATS\fR
+If given, write a bandwidth log for this job. Can be used to store data of the
+bandwidth of the jobs in their lifetime. The included fio_generate_plots script
+uses gnuplot to turn these text files into nice graphs. See \fBwrite_lat_log\fR
+for behaviour of given filename. For this option, the postfix is _bw.x.log,
+where x is the index of the job (1..N, where N is the number of jobs). If
+\fBper_job_logs\fR is false, then the filename will not include the job index.
+See the \fBLOG FILE FORMATS\fR
 section.
 .TP
 .BI write_lat_log \fR=\fPstr
diff --git a/init.c b/init.c
index f041acd..d8c0bd1 100644
--- a/init.c
+++ b/init.c
@@ -2005,7 +2005,7 @@ static void usage(const char *name)
 	printf("  --parse-only\t\tParse options only, don't start any IO\n");
 	printf("  --output\t\tWrite output to file\n");
 	printf("  --runtime\t\tRuntime in seconds\n");
-	printf("  --bandwidth-log\tGenerate per-job bandwidth logs\n");
+	printf("  --bandwidth-log\tGenerate aggregate bandwidth logs\n");
 	printf("  --minimal\t\tMinimal (terse) output\n");
 	printf("  --output-format=x\tOutput format (terse,json,json+,normal)\n");
 	printf("  --terse-version=x\tSet terse version output format to 'x'\n");
-- 
2.10.0

