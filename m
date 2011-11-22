Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39573 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1KVGxc (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 22 Nov 2011 01:53:32 -0500
Received: by iage36 with SMTP id e36so8318728iag.19
        for <fio@vger.kernel.org>; Mon, 21 Nov 2011 22:53:31 -0800 (PST)
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: [PATCH] Use the reentrant getmntent_r instead of getmntent
Date: Tue, 22 Nov 2011 14:56:43 +0800
Message-Id: <1321945003-14786-1-git-send-email-gaoyang.zyh@taobao.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Zhu Yanhai <gaoyang.zyh@taobao.com>

The function find_cgroup_mnt() could be called under multithread scenario, so
we should use the reentrant edition getmntent_r() instead of getmntent().

E.g, without this fix the output for below job file is wrong.

[root@localhost blkio-test]# cat small-read-file
[global]
ioengine=sync
direct=1
rw=read
bs=4k
filename=/dev/sdb
time_based
runtime=60
cgroup=small
cgroup_weight=500
numjobs=32
group_reporting
thread

[file1]

Then fio randomly says:
[cut here]
Starting 32 threads
fio: cgroup blkio does not appear to be mounted
fio: cgroup blkio does not appear to be mounted
fio: cgroup blkio does not appear to be mounted
---
 cgroup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/cgroup.c b/cgroup.c
index f36683a..4f02ecd 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -22,7 +22,8 @@ struct cgroup_member {
 static char *find_cgroup_mnt(struct thread_data *td)
 {
 	char *mntpoint = NULL;
-	struct mntent *mnt;
+	struct mntent *mnt, dummy;
+	char buf[256] = {0};
 	FILE *f;
 
 	f = setmntent("/proc/mounts", "r");
@@ -31,7 +32,7 @@ static char *find_cgroup_mnt(struct thread_data *td)
 		return NULL;
 	}
 
-	while ((mnt = getmntent(f)) != NULL) {
+	while ((mnt = getmntent_r(f, &dummy, buf, 256)) != NULL) {
 		if (!strcmp(mnt->mnt_type, "cgroup") &&
 		    strstr(mnt->mnt_opts, "blkio"))
 			break;
-- 
1.7.4.4

