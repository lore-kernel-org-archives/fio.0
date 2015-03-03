Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:43584 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbbCCLow (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 Mar 2015 06:44:52 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@de.ibm.com>;
	Tue, 3 Mar 2015 11:44:50 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id E16AB17D8042
	for <fio@vger.kernel.org>; Tue,  3 Mar 2015 11:45:07 +0000 (GMT)
Received: from d06av09.portsmouth.uk.ibm.com (d06av09.portsmouth.uk.ibm.com [9.149.37.250])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t23Bimt450593890
	for <fio@vger.kernel.org>; Tue, 3 Mar 2015 11:44:48 GMT
Received: from d06av09.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av09.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t23Bimxg017371
	for <fio@vger.kernel.org>; Tue, 3 Mar 2015 04:44:48 -0700
From: Christian Ehrhardt <ehrhardt@de.ibm.com>
Subject: [PATCH] fio: fix smalloc strdop allocation failure
Date: Tue,  3 Mar 2015 12:44:46 +0100
Message-Id: <1425383086-9188-1-git-send-email-ehrhardt@de.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Christian Ehrhardt <ehrhardt@de.ibm.com>, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

smalloc_strdup didn't check for allocation success and thereby ran into
segfaults if the single pool went out of memory.
Now with this patch applied it is still failing, but in a more consistent
way than segfaulting.

You still get a bad allocation, but it looks like this now:
  fio: smalloc OOM
  fio: filesetup.c:1495: dup_files: Assertion `0' failed.
  Aborted

In fact the upper layers expected smalloc_strdup to retrun NULL on failure.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 smalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

[diff]
---
 smalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/smalloc.c
+++ b/smalloc.c
@@ -492,9 +492,10 @@ void *scalloc(size_t nmemb, size_t size)
 
 char *smalloc_strdup(const char *str)
 {
-	char *ptr;
+	char *ptr = NULL;
 
 	ptr = smalloc(strlen(str) + 1);
-	strcpy(ptr, str);
+	if (ptr)
+		strcpy(ptr, str);
 	return ptr;
 }

