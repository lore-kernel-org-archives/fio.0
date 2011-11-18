Return-Path: <fio-owner@vger.kernel.org>
Received: from 67-207-137-80.slicehost.net ([67.207.137.80]:35389 "EHLO
	joshcarter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab1KRVhb (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 18 Nov 2011 16:37:31 -0500
Received: from [192.168.4.140] (207-225-98-3.dia.static.qwest.net [207.225.98.3])
	by joshcarter.com (Postfix) with ESMTPSA id 420103D862
	for <fio@vger.kernel.org>; Fri, 18 Nov 2011 21:37:34 +0000 (UTC)
From: Josh Carter <public@joshcarter.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [PATCH] Fix initialization of lastrate when using ratemin
Date: Fri, 18 Nov 2011 14:37:29 -0700
Message-Id: <36E51B62-69B0-4FCB-8D86-1603D3C21CF9@joshcarter.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

fio was copying td->bw_sample_time (single timeval) into td->lastrate
(array of two timevals) using the latter's size. Thus is would get one
timeval worth of good data plus who-knows-what for the second timeval.
I'm pretty sure the intent of this code was to copy bw_sample_time
into both members of lastrate.
---
 fio.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fio.c b/fio.c
index 9063c03..6ba445d 100644
--- a/fio.c
+++ b/fio.c
@@ -1284,9 +1284,12 @@ static void *thread_main(void *data)
 		memcpy(&td->iops_sample_time, &td->start, sizeof(td->start));
 		memcpy(&td->tv_cache, &td->start, sizeof(td->start));
 
-		if (td->o.ratemin[0] || td->o.ratemin[1])
-			memcpy(&td->lastrate, &td->bw_sample_time,
-							sizeof(td->lastrate));
+		if (td->o.ratemin[0] || td->o.ratemin[1]) {
+		        memcpy(&td->lastrate[0], &td->bw_sample_time,
+						sizeof(td->bw_sample_time));
+		        memcpy(&td->lastrate[1], &td->bw_sample_time,
+						sizeof(td->bw_sample_time));
+		}
 
 		if (clear_state)
 			clear_io_state(td);
-- 
1.7.4.4


