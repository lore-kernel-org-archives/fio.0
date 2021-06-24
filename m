Return-Path: <prvs=802d7391b=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 3/3] zbd: ensure that global max open zones limit is respected
Date: Thu, 24 Jun 2021 17:23:08 +0000
Message-ID: <20210624172256.37177-4-Niklas.Cassel@wdc.com>
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")
Introduced a global max open zones limit stored in zbd_info->max_open_zones=
.

This commit also changed checks against td->o.max_open_zones in zbd_open_zo=
ne()
with checks against zbd_info->max_open_zones.

It is obvious that zbd_info->max_open_zones was intended to replace
td->o.max_open_zones in all code that is executed after zbd_setup_files().

The commit itself was needed since zbd_info is shared over different jobs,
so it is important that the global limit of max open zones is the same,
for different jobs targeting the same device.

The problem with this commit is that in zbd_convert_to_open_zone(),
instead of replacing td->o.max_open_zones with zbd_info->max_open_zones,
it incorrectly just removed the references to td->o.max_open_zones.

This caused commit 00ca8df5468e ("zbd: Fix max_open_zones checks")
(written by another author) to incorrectly re-add the removed
td->o.max_open_zones checks in zbd_convert_to_open_zone().
The proper fix here should have been to add checks against
zbd_info->max_open_zones instead of td->o.max_open_zones,
just like the original author did for zbd_open_zone().

Replace all td->o.max_open_zones uses past zbd_setup_files() with
zbd_info->max_open_zones, and force set td->o.max_open_zones to
zbd_info->max_open_zones in zbd_setup_files(), so that even if checks are
introduced against the wrong limit, fio will still respect the global limit=
.

Fixes: 00ca8df5468e ("zbd: Fix max_open_zones checks")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/zbd.c b/zbd.c
index f19e3d47..04c68dea 100644
--- a/zbd.c
+++ b/zbd.c
@@ -842,6 +842,14 @@ int zbd_setup_files(struct thread_data *td)
 			return 1;
 		}
=20
+		/*
+		 * zbd->max_open_zones is the global limit shared for all jobs
+		 * that target the same zoned block device. Force sync the per
+		 * thread global limit with the actual global limit. (The real
+		 * per thread/job limit is stored in td->o.job_max_open_zones).
+		 */
+		td->o.max_open_zones =3D zbd->max_open_zones;
+
 		for (zi =3D f->min_zone; zi < f->max_zone; zi++) {
 			z =3D &zbd->zone_info[zi];
 			if (z->cond !=3D ZBD_ZONE_COND_IMP_OPEN &&
@@ -1205,7 +1213,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,
=20
 	assert(is_valid_offset(f, io_u->offset));
=20
-	if (td->o.max_open_zones || td->o.job_max_open_zones) {
+	if (zbdi->max_open_zones || td->o.job_max_open_zones) {
 		/*
 		 * This statement accesses zbdi->open_zones[] on purpose
 		 * without locking.
@@ -1236,7 +1244,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,
 		pthread_mutex_lock(&zbdi->mutex);
 		if (z->has_wp) {
 			if (z->cond !=3D ZBD_ZONE_COND_OFFLINE &&
-			    td->o.max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D 0)
+			    zbdi->max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D 0)
 				goto examine_zone;
 			if (zbdi->num_open_zones =3D=3D 0) {
 				dprint(FD_ZBD, "%s(%s): no zones are open\n",
@@ -1297,8 +1305,8 @@ open_other_zone:
 	/* Check if number of open zones reaches one of limits. */
 	wait_zone_close =3D
 		zbdi->num_open_zones =3D=3D f->max_zone - f->min_zone ||
-		(td->o.max_open_zones &&
-		 zbdi->num_open_zones =3D=3D td->o.max_open_zones) ||
+		(zbdi->max_open_zones &&
+		 zbdi->num_open_zones =3D=3D zbdi->max_open_zones) ||
 		(td->o.job_max_open_zones &&
 		 td->num_open_zones =3D=3D td->o.job_max_open_zones);
=20
--=20
2.25.1

