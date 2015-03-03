Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:33157 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbbCCLpA (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 Mar 2015 06:45:00 -0500
Received: from /spool/local
	by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@de.ibm.com>;
	Tue, 3 Mar 2015 11:44:58 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id B4CCF17D8059
	for <fio@vger.kernel.org>; Tue,  3 Mar 2015 11:45:15 +0000 (GMT)
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t23Biud96160864
	for <fio@vger.kernel.org>; Tue, 3 Mar 2015 11:44:56 GMT
Received: from d06av10.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av10.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t23Biu2W011979
	for <fio@vger.kernel.org>; Tue, 3 Mar 2015 04:44:56 -0700
From: Christian Ehrhardt <ehrhardt@de.ibm.com>
Subject: [PATCH] fio: increase max smalloc pools
Date: Tue,  3 Mar 2015 12:44:54 +0100
Message-Id: <1425383094-9242-1-git-send-email-ehrhardt@de.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Christian Ehrhardt <ehrhardt@de.ibm.com>, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

For our tests with about 250k files we found the smalloc pool being depleated.
Now for us values of 3-4 would be enough, but since it is a compile time switch
I'd like to make it safe for everybody and set 8.

Since it is a dynamic sizing anyway that should hopefully be ok for everybody.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]

[diff]

---
 smalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/smalloc.c
+++ b/smalloc.c
@@ -26,7 +26,7 @@
 #define SMALLOC_BPL	(SMALLOC_BPB * SMALLOC_BPI)
 
 #define INITIAL_SIZE	16*1024*1024	/* new pool size */
-#define MAX_POOLS	1		/* maximum number of pools to setup */
+#define MAX_POOLS	8		/* maximum number of pools to setup */
 
 #define SMALLOC_PRE_RED		0xdeadbeefU
 #define SMALLOC_POST_RED	0x5aa55aa5U

