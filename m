Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:37032 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbaBSPMb (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Feb 2014 10:12:31 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Wed, 19 Feb 2014 15:12:30 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 13C5C219005C
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:24 +0000 (GMT)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1JFCEpC66978004
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 15:12:14 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1JFCPxo005206
	for <fio@vger.kernel.org>; Wed, 19 Feb 2014 08:12:26 -0700
Message-ID: <5304C9D9.1010207@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 16:12:25 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [patch 1/9] fio: fix job clone mem leak
References: <20140219143639.168501090@linux.vnet.ibm.com>
In-Reply-To: <20140219143639.168501090@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

In the loop to create clones at the bottom of add_job the function 
get_new_job
clones the thread_data, just to occaisonally get the allocated pointers for
filename and files overwritten a few lines later.

The dup files also duplicates the name strings so the references to 
these are
lost by the setting to null.

This patch fixes takes care of that and frees the memory before 
discarding the
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


