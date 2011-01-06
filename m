Return-Path: <fio-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:52189 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1AFLN7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Jan 2011 06:13:59 -0500
Received: from d06nrmr1307.portsmouth.uk.ibm.com (d06nrmr1307.portsmouth.uk.ibm.com [9.149.38.129])
	by mtagate7.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p06BDvRY012340
	for <fio@vger.kernel.org>; Thu, 6 Jan 2011 11:13:57 GMT
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com [9.149.37.248])
	by d06nrmr1307.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p06BDxV13661892
	for <fio@vger.kernel.org>; Thu, 6 Jan 2011 11:13:59 GMT
Received: from d06av07.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av07.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p06BDvgY009989
	for <fio@vger.kernel.org>; Thu, 6 Jan 2011 04:13:57 -0700
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] Document that write_iolog is unsafe for concurrent jobs
Date: Thu,  6 Jan 2011 11:13:46 +0000
Message-Id: <1294312426-3121-1-git-send-email-stefanha@linux.vnet.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

The write_iolog parameter should not be used in the global section since
each job will independently write to the same file.  The output will be
interspersed and the file will be corrupt.

Document that each job should write to its own iolog file.  This will
save users time when trying out the iolog feature for the first time.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
I considered adding code to check for:
1. Multiple jobs
2. write_iolog defined in the global section

But it seems options.c isn't geared towards detecting this case.  Instead of
adding a hack somewhere later in the code path I decided to document the
limitation on interspersed write_iolog.

 HOWTO  |    3 ++-
 README |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index dc21afc..7c94329 100644
--- a/HOWTO
+++ b/HOWTO
@@ -988,7 +988,8 @@ zoneskip=int	Skip the specified number of bytes when zonesize data has
 		io on zones of a file.
 
 write_iolog=str	Write the issued io patterns to the specified file. See
-		read_iolog.
+		read_iolog.  Specify a separate file for each job, otherwise
+		the iologs will be interspersed and the file may be corrupt.
 
 read_iolog=str	Open an iolog with the specified file name and replay the
 		io patterns it contains. This can be used to store a
diff --git a/README b/README
index 0f91c66..de06fb1 100644
--- a/README
+++ b/README
@@ -274,7 +274,9 @@ The job file parameters are:
 			and length entries being in bytes.
 	write_iolog=x	Write an iolog to file 'x' in the same format as iolog.
 			The iolog options are exclusive, if both given the
-			read iolog will be performed.
+			read iolog will be performed.  Specify a separate file
+			for each job, otherwise the iologs will be interspersed
+			and the file may be corrupt.
 	write_bw_log	Write a bandwidth log.
 	write_lat_log	Write a latency log.
 	lockmem=x	Lock down x amount of memory on the machine, to
-- 
1.7.2.3

