Return-Path: <prvs=761aa9a9b=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 4/4] engines/libzbc: add support for the get_max_open_zones
 io op
Date: Fri, 14 May 2021 12:53:15 +0000
Message-ID: <20210514125233.10508-5-Niklas.Cassel@wdc.com>
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

Add support for the new .get_max_open_zones io operation.

zbc.c will only ever call this callback for host-managed devices.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 engines/libzbc.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 2aacf7bb..3dde93db 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -19,6 +19,7 @@ struct libzbc_data {
 	struct zbc_device	*zdev;
 	enum zbc_dev_model	model;
 	uint64_t		nr_sectors;
+	uint32_t		max_open_seq_req;
 };
=20
 static int libzbc_get_dev_info(struct libzbc_data *ld, struct fio_file *f)
@@ -32,6 +33,7 @@ static int libzbc_get_dev_info(struct libzbc_data *ld, st=
ruct fio_file *f)
 	zbc_get_device_info(ld->zdev, zinfo);
 	ld->model =3D zinfo->zbd_model;
 	ld->nr_sectors =3D zinfo->zbd_sectors;
+	ld->max_open_seq_req =3D zinfo->zbd_max_nr_open_seq_req;
=20
 	dprint(FD_ZBD, "%s: vendor_id:%s, type: %s, model: %s\n",
 	       f->file_name, zinfo->zbd_vendor_id,
@@ -335,6 +337,24 @@ err:
 	return -ret;
 }
=20
+static int libzbc_get_max_open_zones(struct thread_data *td, struct fio_fi=
le *f,
+				     unsigned int *max_open_zones)
+{
+	struct libzbc_data *ld;
+	int ret;
+
+	ret =3D libzbc_open_dev(td, f, &ld);
+	if (ret)
+		return ret;
+
+	if (ld->max_open_seq_req =3D=3D ZBC_NO_LIMIT)
+		*max_open_zones =3D 0;
+	else
+		*max_open_zones =3D ld->max_open_seq_req;
+
+	return 0;
+}
+
 ssize_t libzbc_rw(struct thread_data *td, struct io_u *io_u)
 {
 	struct libzbc_data *ld =3D td->io_ops_data;
@@ -414,6 +434,7 @@ FIO_STATIC struct ioengine_ops ioengine =3D {
 	.get_zoned_model	=3D libzbc_get_zoned_model,
 	.report_zones		=3D libzbc_report_zones,
 	.reset_wp		=3D libzbc_reset_wp,
+	.get_max_open_zones	=3D libzbc_get_max_open_zones,
 	.queue			=3D libzbc_queue,
 	.flags			=3D FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
 };
--=20
2.25.1

