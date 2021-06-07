Return-Path: <prvs=785b62de8=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 2/4] zbd: allow zonemode=zbd with regular files by
 emulating zones
Date: Mon, 7 Jun 2021 09:16:06 +0000
Message-ID: <20210607091558.21485-3-Niklas.Cassel@wdc.com>
References: <20210607091558.21485-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210607091558.21485-1-Niklas.Cassel@wdc.com>
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
index 60325d28..d1db9adc 100644
--- a/zbd.c
+++ b/zbd.c
@@ -37,6 +37,12 @@ int zbd_get_zoned_model(struct thread_data *td, struct f=
io_file *f,
 		return -EINVAL;
 	}
=20
+	/* If regular file, always emulate zones inside the file. */
+	if (f->filetype =3D=3D FIO_TYPE_FILE) {
+		*model =3D ZBD_NONE;
+		return 0;
+	}
+
 	if (td->io_ops && td->io_ops->get_zoned_model)
 		ret =3D td->io_ops->get_zoned_model(td, f, model);
 	else
@@ -414,7 +420,7 @@ static int init_zone_info(struct thread_data *td, struc=
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
@@ -435,6 +441,12 @@ static int init_zone_info(struct thread_data *td, stru=
ct fio_file *f)
 		return 1;
 	}
=20
+	if (f->real_file_size < zone_size) {
+		log_err("%s: file/device size %"PRIu64" is smaller than zone size %"PRIu=
64"\n",
+			f->file_name, f->real_file_size, zone_size);
+		return -EINVAL;
+	}
+
 	nr_zones =3D (f->real_file_size + zone_size - 1) / zone_size;
 	zbd_info =3D scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
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

