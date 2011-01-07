Return-Path: <fio-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:57940 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1AGU60 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 7 Jan 2011 15:58:26 -0500
Received: from d06nrmr1307.portsmouth.uk.ibm.com (d06nrmr1307.portsmouth.uk.ibm.com [9.149.38.129])
	by mtagate7.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p07KwPgO012126
	for <fio@vger.kernel.org>; Fri, 7 Jan 2011 20:58:25 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1307.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p07KwRcs753724
	for <fio@vger.kernel.org>; Fri, 7 Jan 2011 20:58:27 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost.localdomain [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p07KwOH7003053
	for <fio@vger.kernel.org>; Fri, 7 Jan 2011 13:58:25 -0700
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] setgid first, setuid second
Date: Fri,  7 Jan 2011 20:58:05 +0000
Message-Id: <1294433885-12177-1-git-send-email-stefanha@linux.vnet.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

Setting a new effective gid requires privileges.  We must set the gid
while we potentially still have superuser privileges.  Otherwise
setgid(2) fails because we've already changed to an unprivileged uid.

Here is a test case:
[global]
rw=read
directory=tmp
size=512m
buffered=0

[file1]
uid=1000
gid=1000

Without this patch fio will fail when invoked by root.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 fio.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fio.c b/fio.c
index 8dff813..8cc8fcf 100644
--- a/fio.c
+++ b/fio.c
@@ -1068,14 +1068,18 @@ static void *thread_main(void *data)
 	 */
 	fio_mutex_remove(td->mutex);
 
-	if (td->o.uid != -1U && setuid(td->o.uid)) {
-		td_verror(td, errno, "setuid");
-		goto err;
-	}
+	/*
+	 * A new gid requires privilege, so we need to do this before setting
+	 * the uid.
+	 */
 	if (td->o.gid != -1U && setgid(td->o.gid)) {
 		td_verror(td, errno, "setgid");
 		goto err;
 	}
+	if (td->o.uid != -1U && setuid(td->o.uid)) {
+		td_verror(td, errno, "setuid");
+		goto err;
+	}
 
 	/*
 	 * May alter parameters that init_io_u() will use, so we need to
-- 
1.7.2.3

