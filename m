Return-Path: <prvs=761aa9a9b=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 2/4] oslib/linux-blkzoned: move sysfs reading into its own
 function
Date: Fri, 14 May 2021 12:52:51 +0000
Message-ID: <20210514125233.10508-3-Niklas.Cassel@wdc.com>
References: <20210514125233.10508-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210514125233.10508-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Move the sysfs reading into its own function so that it can be reused.
This new function will be reused in a following patch.

No functional change intended.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 oslib/linux-blkzoned.c | 62 +++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 81e4e7f0..84a64ed3 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -74,12 +74,16 @@ static char *read_file(const char *path)
 	return strdup(line);
 }
=20
-int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,
-			     enum zbd_zoned_model *model)
+/*
+ * Get the value of a sysfs attribute for a block device.
+ *
+ * Returns NULL on failure.
+ * Returns a pointer to a string on success.
+ * The caller is responsible for freeing the memory.
+ */
+static char *blkzoned_get_sysfs_attr(const char *file_name, const char *at=
tr)
 {
-	const char *file_name =3D f->file_name;
-	char *zoned_attr_path =3D NULL;
-	char *model_str =3D NULL;
+	char *attr_path =3D NULL;
 	struct stat statbuf;
 	char *sys_devno_path =3D NULL;
 	char *part_attr_path =3D NULL;
@@ -87,13 +91,7 @@ int blkzoned_get_zoned_model(struct thread_data *td, str=
uct fio_file *f,
 	char sys_path[PATH_MAX];
 	ssize_t sz;
 	char *delim =3D NULL;
-
-	if (f->filetype !=3D FIO_TYPE_BLOCK) {
-		*model =3D ZBD_IGNORE;
-		return 0;
-	}
-
-	*model =3D ZBD_NONE;
+	char *attr_str =3D NULL;
=20
 	if (stat(file_name, &statbuf) < 0)
 		goto out;
@@ -123,24 +121,44 @@ int blkzoned_get_zoned_model(struct thread_data *td, =
struct fio_file *f,
 		*delim =3D '\0';
 	}
=20
-	if (asprintf(&zoned_attr_path,
-		     "/sys/dev/block/%s/queue/zoned", sys_path) < 0)
+	if (asprintf(&attr_path,
+		     "/sys/dev/block/%s/%s", sys_path, attr) < 0)
 		goto out;
=20
-	model_str =3D read_file(zoned_attr_path);
+	attr_str =3D read_file(attr_path);
+out:
+	free(attr_path);
+	free(part_str);
+	free(part_attr_path);
+	free(sys_devno_path);
+
+	return attr_str;
+}
+
+int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			     enum zbd_zoned_model *model)
+{
+	char *model_str =3D NULL;
+
+	if (f->filetype !=3D FIO_TYPE_BLOCK) {
+		*model =3D ZBD_IGNORE;
+		return 0;
+	}
+
+	*model =3D ZBD_NONE;
+
+	model_str =3D blkzoned_get_sysfs_attr(f->file_name, "queue/zoned");
 	if (!model_str)
-		goto out;
-	dprint(FD_ZBD, "%s: zbd model string: %s\n", file_name, model_str);
+		return 0;
+
+	dprint(FD_ZBD, "%s: zbd model string: %s\n", f->file_name, model_str);
 	if (strcmp(model_str, "host-aware") =3D=3D 0)
 		*model =3D ZBD_HOST_AWARE;
 	else if (strcmp(model_str, "host-managed") =3D=3D 0)
 		*model =3D ZBD_HOST_MANAGED;
-out:
+
 	free(model_str);
-	free(zoned_attr_path);
-	free(part_str);
-	free(part_attr_path);
-	free(sys_devno_path);
+
 	return 0;
 }
=20
--=20
2.25.1

