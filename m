Return-Path: <fio-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:25852 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZELW2W (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 May 2009 18:28:22 -0400
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by acsinet12.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n4CMSCXV019262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <fio@vger.kernel.org>; Tue, 12 May 2009 22:28:13 GMT
Received: from abhmt007.oracle.com (abhmt007.oracle.com [141.146.116.16])
	by acsinet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n4CMSmYq013115
	for <fio@vger.kernel.org>; Tue, 12 May 2009 22:28:49 GMT
Message-ID: <4A09F87F.9060801@oracle.com>
Date: Tue, 12 May 2009 15:30:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Subject: [patch] fio docs corrections
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>


Correct fio mailing list address and unit of time for cpuchunks.
---

 HOWTO          |    2 +-
 REPORTING-BUGS |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -Naurp fio-1.26.2/REPORTING-BUGS~update2 fio-1.26.2/REPORTING-BUGS
--- fio-1.26.2/REPORTING-BUGS~update2	2009-05-11 01:37:33.000000000 -0700
+++ fio-1.26.2/REPORTING-BUGS	2009-05-12 15:26:15.000000000 -0700
@@ -2,7 +2,7 @@ Reporting a bug
 ---------------
 
 If you notice anything that seems like a fio bug, please do send email
-to the list (fio-devel@kernel.dk, see README) about it. You'll need
+to the list (fio@vger.kernel.org, see README) about it. You'll need
 to report at least:
 
 1) A description of what you think the bug is
diff -Naurp fio-1.26.2/HOWTO~update2 fio-1.26.2/HOWTO
--- fio-1.26.2/HOWTO~update2	2009-05-11 01:37:33.000000000 -0700
+++ fio-1.26.2/HOWTO	2009-05-12 15:27:19.000000000 -0700
@@ -874,7 +874,7 @@ cpuload=int	If the job is a CPU cycle ea
 		percentage of CPU cycles.
 
 cpuchunks=int	If the job is a CPU cycle eater, split the load into
-		cycles of the given time. In milliseconds.
+		cycles of the given time. In microseconds.
 
 disk_util=bool	Generate disk utilization statistics, if the platform
 		supports it. Defaults to on.



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
