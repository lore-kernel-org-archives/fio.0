Return-Path: <prvs=761aa9a9b=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 1/4] zbd: only put an upper limit on max open zones once
Date: Fri, 14 May 2021 12:52:51 +0000
Message-ID: <20210514125233.10508-2-Niklas.Cassel@wdc.com>
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

There is an upper limit that is checked for each td, and for each file,
even though a file has a pointer to a zoned_block_device_info that has
already been created. Multiple files, from the same or from another td
can point to the same zoned_block_device_info.
All zoned_block_device_info:s have already been created earlier in the
call chain.

Simplify this by only checking the upper limit on max open zones when a
zoned_block_device_info is created.

This way, max_open_zones is handled from a single location, instead of
potentially being reassigned from a completely different location.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/zbd.c b/zbd.c
index eed796b3..46ff9aeb 100644
--- a/zbd.c
+++ b/zbd.c
@@ -588,7 +588,8 @@ static int zbd_create_zone_info(struct thread_data *td,=
 struct fio_file *f)
=20
 	if (ret =3D=3D 0) {
 		f->zbd_info->model =3D zbd_model;
-		f->zbd_info->max_open_zones =3D td->o.max_open_zones;
+		f->zbd_info->max_open_zones =3D
+			min_not_zero(td->o.max_open_zones, ZBD_MAX_OPEN_ZONES);
 	}
 	return ret;
 }
@@ -726,8 +727,6 @@ int zbd_setup_files(struct thread_data *td)
 		if (zbd_is_seq_job(f))
 			assert(f->min_zone < f->max_zone);
=20
-		zbd->max_open_zones =3D zbd->max_open_zones ?: ZBD_MAX_OPEN_ZONES;
-
 		if (td->o.max_open_zones > 0 &&
 		    zbd->max_open_zones !=3D td->o.max_open_zones) {
 			log_err("Different 'max_open_zones' values\n");
--=20
2.25.1

