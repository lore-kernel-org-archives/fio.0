Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200Ab0CaUqy (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Mar 2010 16:46:54 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2VKkrUW017342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <fio@vger.kernel.org>; Wed, 31 Mar 2010 16:46:54 -0400
Received: from machine.usersys.redhat.com (dhcp-100-19-106.bos.redhat.com [10.16.19.106])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2VKkrre026720
	for <fio@vger.kernel.org>; Wed, 31 Mar 2010 16:46:53 -0400
Date: Wed, 31 Mar 2010 16:46:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] Add an option "cgroup_nodelete" to not delete cgroups  after job completion
Message-ID: <20100331204652.GL14011@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

o Add an option cgroup_nodelete to not remove cgroups created by fio after
  the job completion. This can help a user in inspecting various cgroup
  files after fio job completion.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 HOWTO     |    6 ++++++
 cgroup.c  |   12 ++++++++----
 fio.1     |    6 ++++++
 fio.h     |    1 +
 options.c |    7 +++++++
 5 files changed, 28 insertions(+), 4 deletions(-)

Index: fio/HOWTO
===================================================================
--- fio.orig/HOWTO	2010-03-31 14:40:27.000000000 -0400
+++ fio/HOWTO	2010-03-31 14:42:12.415002796 -0400
@@ -1036,6 +1036,12 @@ cgroup_weight=int	Set the weight of the 
 		the documentation that comes with the kernel, allowed values
 		are in the range of 100..1000.
 
+cgroup_nodelete=bool Normally fio will delete the cgroups it has created after
+		the job completion. To override this behavior and to leave
+		cgroups around after the job completion, set cgroup_nodelete=1.
+		This can be useful if one wants to inspect various cgroup
+		files after job completion. Default: false
+
 uid=int		Instead of running as the invoking user, set the user ID to
 		this value before the thread/process does any work.
 
Index: fio/options.c
===================================================================
--- fio.orig/options.c	2010-03-31 14:40:27.000000000 -0400
+++ fio/options.c	2010-03-31 14:42:12.416002791 -0400
@@ -1818,6 +1818,13 @@ static struct fio_option options[FIO_MAX
 		.maxval	= 1000,
 	},
 	{
+		.name	= "cgroup_nodelete",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(cgroup_nodelete),
+		.help	= "Do not delete cgroups after job completion",
+		.def	= "0",
+	},
+	{
 		.name	= "uid",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(uid),
Index: fio/fio.h
===================================================================
--- fio.orig/fio.h	2010-03-31 14:40:27.000000000 -0400
+++ fio/fio.h	2010-03-31 14:42:12.416002791 -0400
@@ -281,6 +281,7 @@ struct thread_options {
 	 */
 	char *cgroup;
 	unsigned int cgroup_weight;
+	unsigned int cgroup_nodelete;
 
 	unsigned int uid;
 	unsigned int gid;
Index: fio/cgroup.c
===================================================================
--- fio.orig/cgroup.c	2010-03-31 14:42:04.000000000 -0400
+++ fio/cgroup.c	2010-03-31 14:44:53.060002430 -0400
@@ -14,6 +14,7 @@ static struct fio_mutex *lock;
 struct cgroup_member {
 	struct flist_head list;
 	char *root;
+	unsigned int cgroup_nodelete;
 };
 
 static char *find_cgroup_mnt(struct thread_data *td)
@@ -43,14 +44,16 @@ static char *find_cgroup_mnt(struct thre
 	return mntpoint;
 }
 
-static void add_cgroup(const char *name, struct flist_head *clist)
+static void add_cgroup(struct thread_data *td, const char *name,
+			struct flist_head *clist)
 {
 	struct cgroup_member *cm;
 
 	cm = smalloc(sizeof(*cm));
 	INIT_FLIST_HEAD(&cm->list);
 	cm->root = smalloc_strdup(name);
-
+	if (td->o.cgroup_nodelete)
+		cm->cgroup_nodelete = 1;
 	fio_mutex_down(lock);
 	flist_add_tail(&cm->list, clist);
 	fio_mutex_up(lock);
@@ -65,7 +68,8 @@ void cgroup_kill(struct flist_head *clis
 
 	flist_for_each_safe(n, tmp, clist) {
 		cm = flist_entry(n, struct cgroup_member, list);
-		rmdir(cm->root);
+		if (!cm->cgroup_nodelete)
+			rmdir(cm->root);
 		flist_del(&cm->list);
 		sfree(cm->root);
 		sfree(cm);
@@ -144,7 +148,7 @@ int cgroup_setup(struct thread_data *td,
 			goto err;
 		}
 	} else
-		add_cgroup(root, clist);
+		add_cgroup(td, root, clist);
 
 	if (td->o.cgroup_weight) {
 		if (write_int_to_file(td, root, "blkio.weight",
Index: fio/fio.1
===================================================================
--- fio.orig/fio.1	2010-03-31 13:30:12.000000000 -0400
+++ fio/fio.1	2010-03-31 17:02:44.940001605 -0400
@@ -762,6 +762,12 @@ your system doesn't have it mounted, you
 Set the weight of the cgroup to this value. See the documentation that comes
 with the kernel, allowed values are in the range of 100..1000.
 .TP
+.BI cgroup_nodelete \fR=\fPbool
+Normally fio will delete the cgroups it has created after the job completion.
+To override this behavior and to leave cgroups around after the job completion,
+set cgroup_nodelete=1. This can be useful if one wants to inspect various
+cgroup files after job completion. Default: false
+.TP
 .BI uid \fR=\fPint
 Instead of running as the invoking user, set the user ID to this value before
 the thread/process does any work.
