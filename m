Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757815Ab0CaRTg (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Mar 2010 13:19:36 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2VHJWuE012290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <fio@vger.kernel.org>; Wed, 31 Mar 2010 13:19:34 -0400
Received: from machine.usersys.redhat.com (dhcp-100-19-106.bos.redhat.com [10.16.19.106])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2VHJVJZ004838
	for <fio@vger.kernel.org>; Wed, 31 Mar 2010 13:19:32 -0400
Date: Wed, 31 Mar 2010 13:19:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] Do not delete cgroups upon completion of fio job
Message-ID: <20100331171931.GH14011@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Currently upon fio job completion, we delete the cgroups. But in the
process we also loose important debugging information presetn in cgroup
files. For example time information in blkio.time, sector information in
blkio.sectors and how many a times a group was dequeued blkio.dequeue.
Leaving the cgroups as it is, allows one to go and inspect those files
after the fio job is complete.

Secondly, cgroups might have already been created by user before fio job
started. In that case it is not very right to delete cgroups after job
completion.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 cgroup.c |    1 -
 1 file changed, 1 deletion(-)

Index: fio/cgroup.c
===================================================================
--- fio.orig/cgroup.c	2010-03-31 13:29:49.000000000 -0400
+++ fio/cgroup.c	2010-03-31 13:31:55.788002620 -0400
@@ -65,7 +65,6 @@ void cgroup_kill(struct flist_head *clis
 
 	flist_for_each_safe(n, tmp, clist) {
 		cm = flist_entry(n, struct cgroup_member, list);
-		rmdir(cm->root);
 		flist_del(&cm->list);
 		sfree(cm->root);
 		sfree(cm);


