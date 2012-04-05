Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41403 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755667Ab2DESlL (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 5 Apr 2012 14:41:11 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.4/8.14.4) with SMTP id q35IdXwi004439
	for <fio@vger.kernel.org>; Thu, 5 Apr 2012 11:41:10 -0700
Received: from mail.thefacebook.com (corpout1.snc1.tfbnw.net [66.220.144.38])
	by mx0b-00082601.pphosted.com with ESMTP id 141fa9r5wt-4
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 05 Apr 2012 11:41:10 -0700
From: Lucian Adrian Grijincu <lucian@fb.com>
Subject: [PATCH] HOWTO: typo: write_log_log -> write_lat_log + use suffix
Date: Thu, 5 Apr 2012 11:41:00 -0700
Message-ID: <1333651260-29152-1-git-send-email-lucian@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian@fb.com>

- I guess 'write_log_log' was a copy-pasta typo.

- You used 'suffix' everywhere except for two places where you said
  'postfix'.
---
 HOWTO |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index 73e8265..92ce05d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -320,7 +320,7 @@ rw=str		Type of io pattern. Accepted values are:
 		one by appending a ':<nr>' to the end of the string given.
 		For a random read, it would look like 'rw=randread:8' for
 		passing in an offset modifier with a value of 8. If the
-		postfix is used with a sequential IO pattern, then the value
+		suffix is used with a sequential IO pattern, then the value
 		specified will be added to the generated offset for each IO.
 		For instance, using rw=write:4k will skip 4k for every
 		write. It turns sequential IO into sequential IO with holes.
@@ -1107,8 +1107,8 @@ write_bw_log=str If given, write a bandwidth log of the jobs in this job
 		file. Can be used to store data of the bandwidth of the
 		jobs in their lifetime. The included fio_generate_plots
 		script uses gnuplot to turn these text files into nice
-		graphs. See write_log_log for behaviour of given
-		filename. For this option, the postfix is _bw.log.
+		graphs. See write_lat_log for behaviour of given
+		filename. For this option, the suffix is _bw.log.
 
 write_lat_log=str Same as write_bw_log, except that this option stores io
 		submission, completion, and total latencies instead. If no
-- 
1.7.9.5

