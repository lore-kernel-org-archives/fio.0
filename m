Return-Path: <prvs=802d7391b=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 2/3] zbd: allow an unlimited global max open zones limit
Date: Thu, 24 Jun 2021 17:23:07 +0000
Message-ID: <20210624172256.37177-3-Niklas.Cassel@wdc.com>
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

This commit also removed the following check from zbd_open_zone():

if (!td->o.max_open_zones)
        return true;

Before the commit in question, if td->o.max_open_zones =3D=3D 0, zbd_open_z=
one()
would not track the zone as open in the zbd_info->open_zones array.

After the commit in question, zbd_open_zone() would always track the zone
as open in the zbd_info->open_zones array, regardless if a --max_open_zones
limit was set or not.

Change the initialization of zbd_info->max_open_zones to yet again allow
unlimited max open zones. If zbd_info->max_open_zones is unlimited,
we do not track the open zones in the zbd_info->open zone array.

Not tracking open zones reduces fio overhead for testing the performance of
zoned block devices that do not have a limit on the maximum number of open
zones.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 zbd.c | 28 ++++++++++++++++++++++++----
 zbd.h |  3 ++-
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/zbd.c b/zbd.c
index f09b0ee6..f19e3d47 100644
--- a/zbd.c
+++ b/zbd.c
@@ -636,8 +636,12 @@ static int zbd_set_max_open_zones(struct thread_data *=
td, struct fio_file *f)
=20
 out:
 	/* Ensure that the limit is not larger than FIO's internal limit */
-	zbd->max_open_zones =3D min_not_zero(zbd->max_open_zones,
-					   (uint32_t) ZBD_MAX_OPEN_ZONES);
+	if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
+		td_verror(td, EINVAL, "'max_open_zones' value is too large");
+		log_err("'max_open_zones' value is larger than %u\n", ZBD_MAX_OPEN_ZONES=
);
+		return -EINVAL;
+	}
+
 	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",
 	       f->file_name, zbd->max_open_zones);
=20
@@ -827,8 +831,14 @@ int zbd_setup_files(struct thread_data *td)
 			log_err("Different 'max_open_zones' values\n");
 			return 1;
 		}
-		if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
-			log_err("'max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_ZONES=
);
+
+		/*
+		 * The per job max open zones limit cannot be used without a
+		 * global max open zones limit. (As the tracking of open zones
+		 * is disabled when there is no global max open zones limit.)
+		 */
+		if (td->o.job_max_open_zones && !zbd->max_open_zones) {
+			log_err("'job_max_open_zones' cannot be used without a global open zone=
s limit\n");
 			return 1;
 		}
=20
@@ -1093,6 +1103,8 @@ static bool is_zone_open(const struct thread_data *td=
, const struct fio_file *f,
 	struct zoned_block_device_info *zbdi =3D f->zbd_info;
 	int i;
=20
+	/* This function should never be called when zbdi->max_open_zones =3D=3D =
0 */
+	assert(zbdi->max_open_zones);
 	assert(td->o.job_max_open_zones =3D=3D 0 || td->num_open_zones <=3D td->o=
.job_max_open_zones);
 	assert(td->o.job_max_open_zones <=3D zbdi->max_open_zones);
 	assert(zbdi->num_open_zones <=3D zbdi->max_open_zones);
@@ -1128,6 +1140,14 @@ static bool zbd_open_zone(struct thread_data *td, co=
nst struct fio_file *f,
 	if (td->o.verify !=3D VERIFY_NONE && zbd_zone_full(f, z, min_bs))
 		return false;
=20
+	/*
+	 * zbdi->max_open_zones =3D=3D 0 means that there is no limit on the maxi=
mum
+	 * number of open zones. In this case, do no track open zones in
+	 * zbdi->open_zones array.
+	 */
+	if (!zbdi->max_open_zones)
+		return true;
+
 	pthread_mutex_lock(&zbdi->mutex);
 	if (is_zone_open(td, f, zone_idx)) {
 		/*
diff --git a/zbd.h b/zbd.h
index 64534393..39dc45e3 100644
--- a/zbd.h
+++ b/zbd.h
@@ -50,7 +50,8 @@ struct fio_zone_info {
  * zoned_block_device_info - zoned block device characteristics
  * @model: Device model.
  * @max_open_zones: global limit on the number of simultaneously opened
- *	sequential write zones.
+ *	sequential write zones. A zero value means unlimited open zones,
+ *	and that open zones will not be tracked in the open_zones array.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
--=20
2.25.1

