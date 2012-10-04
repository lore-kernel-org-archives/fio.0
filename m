Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62186 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2JDW6p (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Oct 2012 18:58:45 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so123811vcb.1
        for <fio@vger.kernel.org>; Thu, 04 Oct 2012 15:58:44 -0700 (PDT)
From: Akash Verma <akashv@google.com>
Subject: [PATCH] HOWTO: Fix description of grouping behavior with numjobs
Date: Thu,  4 Oct 2012 15:58:28 -0700
Message-Id: <1349391508-6931-1-git-send-email-akashv@google.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Akash Verma <akashv@google.com>


Signed-off-by: Akash Verma <akashv@google.com>
---
 HOWTO |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/HOWTO b/HOWTO
index 1362aea..cdff07a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1053,22 +1053,21 @@ wait_for_previous Wait for preceeding jobs in the job file to exit, before
 		points in the job file. A stone wall also implies starting
 		a new reporting group.
 
-new_group	Start a new reporting group. If this option isn't given,
-		jobs in a file will be part of the same reporting group
-		unless separated by a stone wall (or if it's a group
-		by itself, with the numjobs option).
+new_group	Start a new reporting group. See: group_reporting.
 
 numjobs=int	Create the specified number of clones of this job. May be
 		used to setup a larger number of threads/processes doing
-		the same thing. We regard that grouping of jobs as a
-		specific group.
-
-group_reporting	If 'numjobs' is set, it may be interesting to display
-		statistics for the group as a whole instead of for each
-		individual job. This is especially true of 'numjobs' is
-		large, looking at individual thread/process output quickly
-		becomes unwieldy. If 'group_reporting' is specified, fio
-		will show the final report per-group instead of per-job.
+		the same thing. Each thread is reported separately; to see
+		statistics for all clones as a whole, use group_reporting in
+		conjunction with new_group.
+
+group_reporting	It may sometimes be interesting to display statistics for
+		groups of jobs as a whole instead of for each individual job. This is
+		especially true if 'numjobs' is used; looking at individual
+		thread/process output quickly becomes unwieldy. To see the final report
+		per-group instead of per-job, use 'group_reporting'. Jobs in a file
+		will be part of the same reporting group, unless if separated by a
+		stonewall, or by using 'new_group'.
 
 thread		fio defaults to forking jobs, however if this option is
 		given, fio will use pthread_create(3) to create threads
-- 
1.7.7.3

