Return-Path: <fio-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:42938 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1AEJWQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Jan 2011 04:22:16 -0500
Received: from d06nrmr1307.portsmouth.uk.ibm.com (d06nrmr1307.portsmouth.uk.ibm.com [9.149.38.129])
	by mtagate6.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p059MCAY019297
	for <fio@vger.kernel.org>; Wed, 5 Jan 2011 09:22:12 GMT
Received: from d06av11.portsmouth.uk.ibm.com (d06av11.portsmouth.uk.ibm.com [9.149.37.252])
	by d06nrmr1307.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p059ME5r3285030
	for <fio@vger.kernel.org>; Wed, 5 Jan 2011 09:22:14 GMT
Received: from d06av11.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av11.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p059MB54020700
	for <fio@vger.kernel.org>; Wed, 5 Jan 2011 02:22:11 -0700
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] Close iolog file if reading version string fails
Date: Wed,  5 Jan 2011 09:22:03 +0000
Message-Id: <1294219323-3809-1-git-send-email-stefanha@linux.vnet.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

Avoid leaking the iolog file if reading the version string fails.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 log.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/log.c b/log.c
index 266dc06..d4850a5 100644
--- a/log.c
+++ b/log.c
@@ -415,6 +415,7 @@ static int init_iolog_read(struct thread_data *td)
 	if (!p) {
 		td_verror(td, errno, "iolog read");
 		log_err("fio: unable to read iolog\n");
+		fclose(f);
 		return 1;
 	}
 
-- 
1.7.2.3

