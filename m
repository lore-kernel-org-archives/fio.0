Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 13 Apr 2020 21:51:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH v2] zbd: fix sequential write pattern with verify= and
 max_open_zones=
Message-ID: <20200413185155.GA2347@avx2>
References: <20200408221652.GA2592@avx2>
 <BY5PR04MB6900B4F8DFDDBB498EDA8768E7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200409171401.GA3220@avx2>
 <BY5PR04MB6900D077D39EEAF4AE35809FE7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <b6b09ff8-1149-c662-9838-35e61a7ce295@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6b09ff8-1149-c662-9838-35e61a7ce295@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Sequential write with max_open_zones=1 has interesting (read: buggy)
interaction with verify=.

If verify is off, then job runs correctly and IO is sequential,
and restarted from offset 0 and remains sequential.

If verify is on, then 1 full run is done and verified correctly.
At this point there is exactly 1 open zone which is the last zone.

Now IO restarts from offset 0 and pick_random_zone() picks opened zone
#0 which is the last zone because offset is 0. All IO is redirected
to the last zone, which is rewritten once triggering verify again.

IO pattern becomes: 1 full sequential rewrite followed by constant
sequential rewrites of the last zone.


	[global]
	filename=/dev/loop0
	direct=1
	zonemode=zbd
	zonesize=1M
	bs=512K
	rw=write
	verify=xxhash
	[j]
	max_open_zones=1
	io_size=3G

Fix is to close every zone given that verification acts as a barrier
between jobs.

max_open_zones=2 can restart from half of the device, etc.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 zbd.c |   52 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

--- a/zbd.c
+++ b/zbd.c
@@ -687,6 +687,22 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	return zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
 }
 
+/* The caller must hold f->zbd_info->mutex */
+static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
+			   unsigned int open_zone_idx)
+{
+	uint32_t zone_idx;
+
+	assert(open_zone_idx < f->zbd_info->num_open_zones);
+	zone_idx = f->zbd_info->open_zones[open_zone_idx];
+	memmove(f->zbd_info->open_zones + open_zone_idx,
+		f->zbd_info->open_zones + open_zone_idx + 1,
+		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
+		sizeof(f->zbd_info->open_zones[0]));
+	f->zbd_info->num_open_zones--;
+	f->zbd_info->zone_info[zone_idx].open = 0;
+}
+
 /*
  * Reset a range of zones. Returns 0 upon success and 1 upon failure.
  * @td: fio thread data.
@@ -710,12 +726,26 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
 	for (z = zb; z < ze; z++) {
+		uint32_t nz = z - f->zbd_info->zone_info;
+
 		if (!zbd_zone_swr(z))
 			continue;
 		zone_lock(td, z);
-		reset_wp = all_zones ? z->wp != z->start :
-				(td->o.td_ddir & TD_DDIR_WRITE) &&
-				z->wp % min_bs != 0;
+		if (all_zones) {
+			unsigned int i;
+
+			pthread_mutex_lock(&f->zbd_info->mutex);
+			for (i = 0; i < f->zbd_info->num_open_zones; i++) {
+				if (f->zbd_info->open_zones[i] == nz)
+					zbd_close_zone(td, f, i);
+			}
+			pthread_mutex_unlock(&f->zbd_info->mutex);
+
+			reset_wp = z->wp != z->start;
+		} else {
+			reset_wp = (td->o.td_ddir & TD_DDIR_WRITE) &&
+					z->wp % min_bs != 0;
+		}
 		if (reset_wp) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
 			       f->file_name,
@@ -905,22 +935,6 @@ out:
 	return res;
 }
 
-/* The caller must hold f->zbd_info->mutex */
-static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
-			   unsigned int open_zone_idx)
-{
-	uint32_t zone_idx;
-
-	assert(open_zone_idx < f->zbd_info->num_open_zones);
-	zone_idx = f->zbd_info->open_zones[open_zone_idx];
-	memmove(f->zbd_info->open_zones + open_zone_idx,
-		f->zbd_info->open_zones + open_zone_idx + 1,
-		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
-		sizeof(f->zbd_info->open_zones[0]));
-	f->zbd_info->num_open_zones--;
-	f->zbd_info->zone_info[zone_idx].open = 0;
-}
-
 /* Anything goes as long as it is not a constant. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)

