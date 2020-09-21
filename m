Return-Path: <aherrmann@suse.com>
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v3 1/4] cgroup: Fix handling when cgroup blkio and cgroup-v2 are mounted
Date: Mon, 21 Sep 2020 15:47:30 +0200
Message-ID: <20200921134730.19294-2-aherrmann@suse.com>
In-Reply-To: <20200921134730.19294-1-aherrmann@suse.com>
References: <20200921134730.19294-1-aherrmann@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, Andreas Herrmann <aherrmann@suse.com>
List-ID: <fio@vger.kernel.org>

On systems that have a mixed setup of cgroup and cgroup-v2, blkio
controller might be active. I think in this case there is no point in
using cgroup-v2. One needs to boot with cgroup_no_v1=3Dblkio to be able
to use cgroup-v2 IO controller.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 cgroup.c | 58 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/cgroup.c b/cgroup.c
index 77e31a4d..fc31d4cd 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -20,11 +20,10 @@ struct cgroup_member {
=20
 static struct cgroup_mnt *find_cgroup_mnt(struct thread_data *td)
 {
-	struct cgroup_mnt *cgroup_mnt =3D NULL;
+	struct cgroup_mnt *cgroup_mnt, *cg1_mnt =3D NULL, *cg2_mnt =3D NULL;
 	struct mntent *mnt, dummy;
 	char buf[256] =3D {0};
 	FILE *f;
-	bool cgroup2 =3D false;
=20
 	f =3D setmntent("/proc/mounts", "r");
 	if (!f) {
@@ -34,27 +33,50 @@ static struct cgroup_mnt *find_cgroup_mnt(struct thread=
_data *td)
=20
 	while ((mnt =3D getmntent_r(f, &dummy, buf, sizeof(buf))) !=3D NULL) {
 		if (!strcmp(mnt->mnt_type, "cgroup") &&
-		    strstr(mnt->mnt_opts, "blkio"))
-			break;
-		if (!strcmp(mnt->mnt_type, "cgroup2")) {
-			cgroup2 =3D true;
+			strstr(mnt->mnt_opts, "blkio")) {
+			cg1_mnt =3D smalloc(sizeof(*cg1_mnt));
+			if (cg1_mnt) {
+				cg1_mnt->path =3D smalloc_strdup(mnt->mnt_dir);
+				if (!cg1_mnt->path) {
+					sfree(cg1_mnt);
+					cg1_mnt =3D NULL;
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
+			cg2_mnt =3D smalloc(sizeof(*cg2_mnt));
+			if (cg2_mnt) {
+				cg2_mnt->path =3D smalloc_strdup(mnt->mnt_dir);
+				if (!cg2_mnt->path) {
+					sfree(cg2_mnt);
+					cg2_mnt =3D NULL;
+					log_err("fio: could not allocate memory\n");
+				} else
+					cg2_mnt->cgroup2 =3D true;
+			}
+			/*
+			 * Check all mount points, there can be a mix
+			 * of cgroup-v1 and cgroup-v2
+			 */
+			continue;
 		}
 	}
=20
-	if (mnt) {
-		cgroup_mnt =3D smalloc(sizeof(*cgroup_mnt));
-		if (cgroup_mnt) {
-			cgroup_mnt->path =3D smalloc_strdup(mnt->mnt_dir);
-			if (!cgroup_mnt->path) {
-				sfree(cgroup_mnt);
-				log_err("fio: could not allocate memory\n");
-			} else {
-				cgroup_mnt->cgroup2 =3D cgroup2;
-			}
-		}
+	cgroup_mnt =3D NULL;
+	if (cg1_mnt) {
+		cgroup_mnt =3D cg1_mnt;
+		if (cg2_mnt)
+			sfree(cg2_mnt);
+	} else if (cg2_mnt) {
+		cgroup_mnt =3D cg2_mnt;
 	} else {
-		log_err("fio: cgroup blkio does not appear to be mounted\n");
+		log_err("fio: cgroup blkio or cgroup2 do not appear to be mounted\n");
 	}
=20
 	endmntent(f);
--=20
2.28.0


