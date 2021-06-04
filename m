Return-Path: <prvs=782a7b7b5=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 2/4] zbd: allow zonemode=zbd with regular files by emulating
 zones
Date: Fri, 4 Jun 2021 12:18:52 +0000
Message-ID: <20210604121843.6047-3-Niklas.Cassel@wdc.com>
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

Currently when using zonemode=3Dzbd and running against a regular file,
fio will fail with:
fio: file hash not empty on exit

Treat regular files just like how we treat regular (non-zoned) block
devices: return ZBD_NONE and let zbd.c emulate zones inside the regular
file/block device.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c       | 14 +++++++++++++-
 zbd_types.h |  2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 60325d28..fb20f6cc 100644
--- a/zbd.c
+++ b/zbd.c
@@ -37,6 +37,18 @@ int zbd_get_zoned_model(struct thread_data *td, struct f=
io_file *f,
 		return -EINVAL;
 	}
=20
+	/* If regular file, always emulate zones inside the file. */
+	if (f->filetype =3D=3D FIO_TYPE_FILE) {
+		if (!f->real_file_size) {
+			log_err("%s: file size cannot be zero\n",
+				f->file_name);
+			return -EINVAL;
+		}
+
+		*model =3D ZBD_NONE;
+		return 0;
+	}
+
 	if (td->io_ops && td->io_ops->get_zoned_model)
 		ret =3D td->io_ops->get_zoned_model(td, f, model);
 	else
@@ -414,7 +426,7 @@ static int init_zone_info(struct thread_data *td, struc=
t fio_file *f)
 	int i;
=20
 	if (zone_size =3D=3D 0) {
-		log_err("%s: Specifying the zone size is mandatory for regular block dev=
ices with --zonemode=3Dzbd\n\n",
+		log_err("%s: Specifying the zone size is mandatory for regular file/bloc=
k device with --zonemode=3Dzbd\n\n",
 			f->file_name);
 		return 1;
 	}
diff --git a/zbd_types.h b/zbd_types.h
index 5ed41aa0..d0f4c44e 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -15,7 +15,7 @@
  */
 enum zbd_zoned_model {
 	ZBD_IGNORE,		/* Ignore file */
-	ZBD_NONE,		/* Regular block device */
+	ZBD_NONE,		/* No zone support. Emulate zones. */
 	ZBD_HOST_AWARE,		/* Host-aware zoned block device */
 	ZBD_HOST_MANAGED,	/* Host-managed zoned block device */
 };
--=20
2.31.1

