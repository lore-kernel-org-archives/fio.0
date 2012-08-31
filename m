Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48968 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2HaPPg (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 31 Aug 2012 11:15:36 -0400
Received: by pbbrr13 with SMTP id rr13so4999323pbb.19
        for <fio@vger.kernel.org>; Fri, 31 Aug 2012 08:15:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 31 Aug 2012 23:15:35 +0800
Message-ID: <CADu=CFpi4SSsCYVefXqZkECbw7JNhLs92TJT2Q_fd-k8E+_BGw@mail.gmail.com>
Subject: [PATCH] fio:modify a deprecated parameter(change timeout to runtime)
From: liang xie <xieliang007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: jaxboe@fusionio.com

since "timeout" had been deprecated long long ago, we should replace
to "runtime" both in code and docs

Signed-off-by: Liang Xie <xieliang@xiaomi.com>
---
 README |   12 ++++++------
 fio.1  |    4 ++--
 init.c |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/README b/README
index 8bce835..7589e2f 100644
--- a/README
+++ b/README
@@ -121,7 +121,7 @@ Command line
 $ fio
 	--debug			Enable some debugging options (see below)
 	--output		Write output to file
-	--timeout		Runtime in seconds
+	--runtime		Runtime in seconds
 	--latency-log		Generate per-job latency logs
 	--bandwidth-log		Generate per-job bandwidth logs
 	--minimal		Minimal (terse) output
@@ -138,8 +138,8 @@ $ fio
 				May be "always", "never" or "auto"
 	--section=name		Only run specified section in job file.
 				Multiple sections can be specified.
-	--alloc-size=kb	Set smalloc pool to this size in kb (def 1024)
-	--warnings-fatal Fio parser warnings are fatal
+	--alloc-size=kb		Set smalloc pool to this size in kb (def 1024)
+	--warnings-fatal	 Fio parser warnings are fatal
 	--max-jobs		Maximum number of threads/processes to support
 	--server=args		Start backend server. See Client/Server section.
 	--client=host		Connect to specified backend.
@@ -161,11 +161,11 @@ options in fio. Currently the options are:

 	process		Dump info related to processes
 	file		Dump info related to file actions
-	io			Dump info related to IO queuing
-	mem			Dump info related to memory allocations
+	io		Dump info related to IO queuing
+	mem		Dump info related to memory allocations
 	blktrace	Dump info related to blktrace setup
 	verify		Dump info related to IO verification
-	all			Enable all debug options
+	all		Enable all debug options
 	random		Dump info related to random offset generation
 	parse		Dump info related to option matching and parsing
 	diskutil	Dump info related to disk utilization updates
diff --git a/fio.1 b/fio.1
index 5b61e43..086cf9d 100644
--- a/fio.1
+++ b/fio.1
@@ -20,8 +20,8 @@ list all available tracing options.
 .BI \-\-output \fR=\fPfilename
 Write output to \fIfilename\fR.
 .TP
-.BI \-\-timeout \fR=\fPtimeout
-Limit run time to \fItimeout\fR seconds.
+.BI \-\-runtime \fR=\fPruntime
+Limit run time to \fIruntime\fR seconds.
 .TP
 .B \-\-latency\-log
 Generate per-job latency logs.
diff --git a/init.c b/init.c
index 824828c..9f597a9 100644
--- a/init.c
+++ b/init.c
@@ -1185,7 +1185,7 @@ static void usage(const char *name)
 		"\t\t\tprocess,file,io,mem,blktrace,verify,random,parse,\n"
 		"\t\t\tdiskutil,job,mutex,profile,time,net\n");
 	printf("  --output\t\tWrite output to file\n");
-	printf("  --timeout\t\tRuntime in seconds\n");
+	printf("  --runtime\t\tRuntime in seconds\n");
 	printf("  --latency-log\t\tGenerate per-job latency logs\n");
 	printf("  --bandwidth-log\tGenerate per-job bandwidth logs\n");
 	printf("  --minimal\t\tMinimal (terse) output\n");
-- 
1.7.9.6 (Apple Git-31.1)
