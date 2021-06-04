Return-Path: <prvs=782a7b7b5=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 4/4] zbd: change some f->zbd_info conditionals to asserts
Date: Fri, 4 Jun 2021 12:18:53 +0000
Message-ID: <20210604121843.6047-5-Niklas.Cassel@wdc.com>
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

Unfortunately, generic fio code calls some zbd_* functions unconditionally.
These functions will be called regardless if zonemode =3D=3D ZONE_MODE_NONE=
,
ZONE_MODE_STRIDED or ZONE_MODE_ZBD, and cannot be optimized.

However, some functions are only called when zonemode =3D=3D ZONE_MODE_ZBD.
Since f->zbd_info will always be non-NULL for a job with zonemode=3Dzbd,
these functions can be optimized to not check if f->zbd_info is set.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/zbd.c b/zbd.c
index 7012cb93..0a48653c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -808,8 +808,7 @@ int zbd_setup_files(struct thread_data *td)
 		struct fio_zone_info *z;
 		int zi;
=20
-		if (!zbd)
-			continue;
+		assert(zbd);
=20
 		f->min_zone =3D zbd_zone_idx(f, f->file_offset);
 		f->max_zone =3D zbd_zone_idx(f, f->file_offset + f->io_size);
@@ -1470,8 +1469,7 @@ static void zbd_queue_io(struct thread_data *td, stru=
ct io_u *io_u, int q,
 	uint32_t zone_idx;
 	uint64_t zone_end;
=20
-	if (!zbd_info)
-		return;
+	assert(zbd_info);
=20
 	zone_idx =3D zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
@@ -1531,8 +1529,7 @@ static void zbd_put_io(struct thread_data *td, const =
struct io_u *io_u)
 	struct fio_zone_info *z;
 	uint32_t zone_idx;
=20
-	if (!zbd_info)
-		return;
+	assert(zbd_info);
=20
 	zone_idx =3D zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
@@ -1588,6 +1585,7 @@ void setup_zbd_zone_mode(struct thread_data *td, stru=
ct io_u *io_u)
=20
 	assert(td->o.zone_mode =3D=3D ZONE_MODE_ZBD);
 	assert(td->o.zone_size);
+	assert(f->zbd_info);
=20
 	zone_idx =3D zbd_zone_idx(f, f->last_pos[ddir]);
 	z =3D get_zone(f, zone_idx);
@@ -1662,6 +1660,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td,=
 struct io_u *io_u,
 	 * devices with all empty zones. Overwrite the first I/O direction as
 	 * write to make sure data to read exists.
 	 */
+	assert(io_u->file->zbd_info);
 	if (ddir !=3D DDIR_READ || !td_rw(td))
 		return ddir;
=20
@@ -1691,9 +1690,7 @@ enum io_u_action zbd_adjust_block(struct thread_data =
*td, struct io_u *io_u)
 	uint64_t new_len;
 	int64_t range;
=20
-	if (!f->zbd_info)
-		return io_u_accept;
-
+	assert(f->zbd_info);
 	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
--=20
2.31.1

