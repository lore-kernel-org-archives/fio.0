Return-Path: <prvs=782a7b7b5=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 3/4] zbd: remove zbd_zoned_model ZBD_IGNORE
Date: Fri, 4 Jun 2021 12:18:52 +0000
Message-ID: <20210604121843.6047-4-Niklas.Cassel@wdc.com>
References: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

For a job with zonemode=3Dzbd, we do not want any file to be ignored.
Each file's file type in that job should be supported by either zbd.c
or the ioengine. If not, we should return an error.
This way, ZBD_IGNORE becomes redundant and can be removed.

By removing ZBD_IGNORE, we know that all files belonging to a job that
has zonemode=3Dzbd set, will either be a zoned block device, or emulate
a zoned block device.

This means that for jobs that have zonemode=3Dzbd, f->zbd_info will always
be non-NULL. This will make the zbd code slightly easier to reason about
and to maintain.

When removing zbd_zoned_model ZBD_IGNORE, define the new first enum value
as 0x1, so that we avoid potential ABI problems with existing binaries.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/libzbc.c            | 3 +--
 engines/skeleton_external.c | 1 -
 oslib/linux-blkzoned.c      | 3 +--
 zbd.c                       | 3 +--
 zbd_types.h                 | 7 +++----
 5 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 3dde93db..c3551bec 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -181,8 +181,7 @@ static int libzbc_get_zoned_model(struct thread_data *t=
d, struct fio_file *f,
 	int ret;
=20
 	if (f->filetype !=3D FIO_TYPE_BLOCK && f->filetype !=3D FIO_TYPE_CHAR) {
-		*model =3D ZBD_IGNORE;
-		return 0;
+		return -EINVAL;
 	}
=20
 	ret =3D libzbc_open_dev(td, f, &ld);
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index c79b6f11..cff83a10 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -156,7 +156,6 @@ static int fio_skeleton_close(struct thread_data *td, s=
truct fio_file *f)
 /*
  * Hook for getting the zoned model of a zoned block device for zonemode=
=3Dzbd.
  * The zoned model can be one of (see zbd_types.h):
- * - ZBD_IGNORE: skip regular files
  * - ZBD_NONE: regular block device (zone emulation will be used)
  * - ZBD_HOST_AWARE: host aware zoned block device
  * - ZBD_HOST_MANAGED: host managed zoned block device
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 6f89ec6f..8cb9c53a 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -141,8 +141,7 @@ int blkzoned_get_zoned_model(struct thread_data *td, st=
ruct fio_file *f,
 	char *model_str =3D NULL;
=20
 	if (f->filetype !=3D FIO_TYPE_BLOCK) {
-		*model =3D ZBD_IGNORE;
-		return 0;
+		return -EINVAL;
 	}
=20
 	*model =3D ZBD_NONE;
diff --git a/zbd.c b/zbd.c
index fb20f6cc..7012cb93 100644
--- a/zbd.c
+++ b/zbd.c
@@ -661,8 +661,6 @@ static int zbd_create_zone_info(struct thread_data *td,=
 struct fio_file *f)
 		return ret;
=20
 	switch (zbd_model) {
-	case ZBD_IGNORE:
-		return 0;
 	case ZBD_HOST_AWARE:
 	case ZBD_HOST_MANAGED:
 		ret =3D parse_zone_info(td, f);
@@ -680,6 +678,7 @@ static int zbd_create_zone_info(struct thread_data *td,=
 struct fio_file *f)
 		return -EINVAL;
 	}
=20
+	assert(f->zbd_info);
 	f->zbd_info->model =3D zbd_model;
=20
 	ret =3D zbd_set_max_open_zones(td, f);
diff --git a/zbd_types.h b/zbd_types.h
index d0f4c44e..0a8630cb 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -14,10 +14,9 @@
  * Zoned block device models.
  */
 enum zbd_zoned_model {
-	ZBD_IGNORE,		/* Ignore file */
-	ZBD_NONE,		/* No zone support. Emulate zones. */
-	ZBD_HOST_AWARE,		/* Host-aware zoned block device */
-	ZBD_HOST_MANAGED,	/* Host-managed zoned block device */
+	ZBD_NONE		=3D 0x1,	/* No zone support. Emulate zones. */
+	ZBD_HOST_AWARE		=3D 0x2,	/* Host-aware zoned block device */
+	ZBD_HOST_MANAGED	=3D 0x3,	/* Host-managed zoned block device */
 };
=20
 /*
--=20
2.31.1

