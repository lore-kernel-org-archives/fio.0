Return-Path: <prvs=785b62de8=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 1/4] zbd: disallow pipes for zonemode=zbd
Date: Mon, 7 Jun 2021 09:16:06 +0000
Message-ID: <20210607091558.21485-2-Niklas.Cassel@wdc.com>
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

zoned block device support in fio cannot handle pipes,
so simply reject them and give a clear error message.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/zbd.c b/zbd.c
index 5d9e331a..60325d28 100644
--- a/zbd.c
+++ b/zbd.c
@@ -32,6 +32,11 @@ int zbd_get_zoned_model(struct thread_data *td, struct f=
io_file *f,
 {
 	int ret;
=20
+	if (f->filetype =3D=3D FIO_TYPE_PIPE) {
+		log_err("zonemode=3Dzbd does not support pipes\n");
+		return -EINVAL;
+	}
+
 	if (td->io_ops && td->io_ops->get_zoned_model)
 		ret =3D td->io_ops->get_zoned_model(td, f, model);
 	else
--=20
2.31.1

