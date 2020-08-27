Return-Path: <fio-owner@vger.kernel.org>
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:54873 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729027AbgH0MMX (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 27 Aug 2020 08:12:23 -0400
Date: Thu, 27 Aug 2020 14:12:15 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 2/3] cgroup: Fix handling when cgroup blkio and cgroup-v2 are
 mounted
Message-ID: <20200827121215.GE6041@suselix>
References: <20200827120722.GC6041@suselix>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200827120722.GC6041@suselix>
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

On systems that have a mixed setup of cgroup and cgroup-v2, blkio
controller might be active. I think in this case there is no point in
using cgroup-v2. (One needs to boot with cgroup_no_v1=blkio to be able
to use cgroup-v2 IO controller.)

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 cgroup.c | 58 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/cgroup.c b/cgroup.c
index 9ee1b8c8..43513733 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -20,11 +20,10 @@ struct cgroup_member {
 
 static struct cgroup_mnt *find_cgroup_mnt(struct thread_data *td)
 {
-	struct cgroup_mnt *cgroup_mnt = NULL;
+	struct cgroup_mnt *cgroup_mnt, *cg1_mnt = NULL, *cg2_mnt = NULL;
 	struct mntent *mnt, dummy;
 	char buf[256] = {0};
 	FILE *f;
-	bool cgroup2 = false;
 
 	f = setmntent("/proc/mounts", "r");
 	if (!f) {
@@ -34,27 +33,50 @@ static struct cgroup_mnt *find_cgroup_mnt(struct thread_data *td)
 
 	while ((mnt = getmntent_r(f, &dummy, buf, sizeof(buf))) != NULL) {
 		if (!strcmp(mnt->mnt_type, "cgroup") &&
-		    strstr(mnt->mnt_opts, "blkio"))
-			break;
-		if (!strcmp(mnt->mnt_type, "cgroup2")) {
-			cgroup2 = true;
+			strstr(mnt->mnt_opts, "blkio")) {
+			cg1_mnt = smalloc(sizeof(*cg1_mnt));
+			if (cg1_mnt) {
+				cg1_mnt->path = smalloc_strdup(mnt->mnt_dir);
+				if (!cg1_mnt->path) {
+					sfree(cg1_mnt);
+					cg1_mnt = NULL;
+					log_err("fio: could not allocate memory\n");
+				}
+			}
+			/*
+			 * blkio controller has precedence
+			 */
 			break;
+		} if (!strcmp(mnt->mnt_type, "cgroup2")) {
+			if (cg2_mnt)
+				continue;
+			cg2_mnt = smalloc(sizeof(*cg2_mnt));
+			if (cg2_mnt) {
+				cg2_mnt->path = smalloc_strdup(mnt->mnt_dir);
+				if (!cg2_mnt->path) {
+					sfree(cg2_mnt);
+					cg2_mnt = NULL;
+					log_err("fio: could not allocate memory\n");
+				} else
+					cg2_mnt->cgroup2 = true;
+			}
+			/*
+			 * Check all mount points, there can be a mix
+			 * of cgroup-v1 and cgroup-v2
+			 */
+			continue;
 		}
 	}
 
-	if (mnt) {
-		cgroup_mnt = smalloc(sizeof(*cgroup_mnt));
-		if (cgroup_mnt) {
-			cgroup_mnt->path = smalloc_strdup(mnt->mnt_dir);
-			if (!cgroup_mnt->path) {
-				sfree(cgroup_mnt);
-				log_err("fio: could not allocate memory\n");
-			} else {
-				cgroup_mnt->cgroup2 = cgroup2;
-			}
-		}
+	cgroup_mnt = NULL;
+	if (cg1_mnt) {
+		cgroup_mnt = cg1_mnt;
+		if (cg2_mnt)
+			sfree(cg2_mnt);
+	} else if (cg2_mnt) {
+		cgroup_mnt = cg2_mnt;
 	} else {
-		log_err("fio: cgroup blkio does not appear to be mounted\n");
+		log_err("fio: cgroup blkio or cgroup2 do not appear to be mounted\n");
 	}
 
 	endmntent(f);
-- 
2.28.0


