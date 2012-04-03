Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45028 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751566Ab2DCACs (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 2 Apr 2012 20:02:48 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.4/8.14.4) with SMTP id q32NsZgk011874
	for <fio@vger.kernel.org>; Mon, 2 Apr 2012 17:02:47 -0700
Received: from mail.thefacebook.com (corpout1.snc1.tfbnw.net [66.220.144.38])
	by mx0b-00082601.pphosted.com with ESMTP id 13yj1dgfdn-5
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Mon, 02 Apr 2012 17:02:47 -0700
From: Lucian Adrian Grijincu <lucian@fb.com>
Subject: [PATCH] HOWTO: emphasize units in --minimal mode: latency in usec, bw in KB/s
Date: Mon, 2 Apr 2012 17:02:42 -0700
Message-ID: <1333411362-18958-1-git-send-email-lucian@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian@fb.com>

It wasn't clear what unit were used in --minimal mode.

Signed-off-by: Lucian Adrian Grijincu <lucian@fb.com>
---
 HOWTO |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/HOWTO b/HOWTO
index 662689e..c47997f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1382,7 +1382,8 @@ runt=		The runtime of that thread
 		latency, since queue/complete is one operation there. This
 		value can be in milliseconds or microseconds, fio will choose
 		the most appropriate base and print that. In the example
-		above, milliseconds is the best scale.
+		above, milliseconds is the best scale. Note: in --minimal mode
+		latencies are always expressed in microseconds.
 	clat=	Completion latency. Same names as slat, this denotes the
 		time from submission to completion of the io pieces. For
 		sync io, clat will usually be equal (or very close) to 0,
@@ -1470,18 +1471,18 @@ Split up, the format is as follows:
 	terse version, fio version, jobname, groupid, error
 	READ status:
 		Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
-		Submission latency: min, max, mean, deviation (usec)
-		Completion latency: min, max, mean, deviation (usec)
+		Submission latency (usec): min, max, mean, deviation (usec)
+		Completion latency (usec): min, max, mean, deviation (usec)
 		Completion latency percentiles: 20 fields (see below)
-		Total latency: min, max, mean, deviation (usec)
-		Bw: min, max, aggregate percentage of total, mean, deviation
+		Total latency (usec): min, max, mean, deviation (usec)
+		Bw (KB/s): min, max, aggregate percentage of total, mean, deviation
 	WRITE status:
 		Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
-		Submission latency: min, max, mean, deviation (usec)
-		Completion latency: min, max, mean, deviation (usec)
+		Submission latency (usec): min, max, mean, deviation (usec)
+		Completion latency (usec): min, max, mean, deviation (usec)
 		Completion latency percentiles: 20 fields (see below)
-		Total latency: min, max, mean, deviation (usec)
-		Bw: min, max, aggregate percentage of total, mean, deviation
+		Total latency (usec): min, max, mean, deviation (usec)
+		Bw (KB/s): min, max, aggregate percentage of total, mean, deviation
 	CPU usage: user, system, context switches, major faults, minor faults
 	IO depths: <=1, 2, 4, 8, 16, 32, >=64
 	IO latencies microseconds: <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000
-- 
1.7.9.5

