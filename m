Return-Path: <aherrmann@suse.com>
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v3 2/4] cgroup: Allow to use weights with cgroup-v2
Date: Mon, 21 Sep 2020 15:47:32 +0200
Message-ID: <20200921134730.19294-3-aherrmann@suse.com>
In-Reply-To: <20200921134730.19294-1-aherrmann@suse.com>
References: <20200921134730.19294-1-aherrmann@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, Andreas Herrmann <aherrmann@suse.com>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 cgroup.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/cgroup.c b/cgroup.c
index fc31d4cd..c6369f54 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -165,6 +165,26 @@ static int write_int_to_file(struct thread_data *td, c=
onst char *path,
=20
 }
=20
+static int write_str_to_file(struct thread_data *td, const char *path,
+			     const char *filename, const char *str,
+			     const char *onerr)
+{
+	char tmp[256];
+	FILE *f;
+
+	sprintf(tmp, "%s/%s", path, filename);
+	f =3D fopen(tmp, "w");
+	if (!f) {
+		td_verror(td, errno, onerr);
+		return 1;
+	}
+
+	fprintf(f, "%s", str);
+	fclose(f);
+	return 0;
+
+}
+
 static int cgroup_write_pid(struct thread_data *td, char *path, bool cgrou=
p2)
 {
 	unsigned int val =3D td->pid;
@@ -213,13 +233,19 @@ int cgroup_setup(struct thread_data *td, struct flist=
_head *clist, struct cgroup
=20
 	if (td->o.cgroup_weight) {
 		if ((*mnt)->cgroup2) {
-			log_err("fio: cgroup weit doesn't work with cgroup2\n");
-			goto err;
+			if (write_str_to_file(td, (*mnt)->path, "cgroup.subtree_control",
+						"+io", "cgroup open cgroup.subtree_control"))
+				goto err;
+			if (write_int_to_file(td, root, "io.weight",
+						td->o.cgroup_weight,
+						"cgroup open io.weight"))
+				goto err;
+		} else {
+			if (write_int_to_file(td, root, "blkio.weight",
+						td->o.cgroup_weight,
+						"cgroup open blkio.weight"))
+				goto err;
 		}
-		if (write_int_to_file(td, root, "blkio.weight",
-					td->o.cgroup_weight,
-					"cgroup open weight"))
-			goto err;
 	}
=20
 	if (!cgroup_write_pid(td, root, (*mnt)->cgroup2)) {
--=20
2.28.0


