Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:51115 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaBTNU4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Feb 2014 08:20:56 -0500
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Thu, 20 Feb 2014 13:20:54 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id F25402190061
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:48 +0000 (GMT)
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1KDKdEB1049070
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:39 GMT
Received: from d06av05.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1KDKoQo015404
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 06:20:51 -0700
Message-Id: <20140220132050.305734025@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 14:19:59 +0100
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 1/9] fio: fix job clone mem leak
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

*Resend with hopefully non mangled patches*
References: <20140220131958.965092001@linux.vnet.ibm.com>
Content-Disposition: inline; filename=fio-fix-cloneleak.diff

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

In the loop to create clones at the bottom of add_job the function get_new_job
clones the thread_data, just to occaisonally get the allocated pointers for
filename and files overwritten a few lines later.

The dup files also duplicates the name strings so the references to these are
lost by the setting to null.

This patch fixes takes care of that and frees the memory before discarding the
pointers (found via valgrind).

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 init.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

[diff]

--- a/init.c
+++ b/init.c
@@ -1118,10 +1118,21 @@ static int add_job(struct thread_data *t
 		td_new->o.new_group = 0;
 
 		if (file_alloced) {
-			td_new->o.filename = NULL;
 			td_new->files_index = 0;
 			td_new->files_size = 0;
-			td_new->files = NULL;
+			if (td_new->files) {
+				struct fio_file *f;
+				for_each_file(td_new, f, i) {
+					if (f->file_name)
+						free(f->file_name);
+					free(f);
+				}
+				td_new->files = NULL;
+			}
+			if (td_new->o.filename) {
+				free(td_new->o.filename);
+				td_new->o.filename = NULL;
+			}
 		}
 
 		job_add_num = numjobs - 1;

