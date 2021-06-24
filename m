Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62646 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhFXRZ2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Jun 2021 13:25:28 -0400
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 1/3] zbd: create a local zbdi variable for f->zbd_info
Date: Thu, 24 Jun 2021 17:23:07 +0000
Message-ID: <20210624172256.37177-2-Niklas.Cassel@wdc.com>
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>, Niklas Cassel <Niklas.Cassel@wdc.com>

From: Niklas Cassel <niklas.cassel@wdc.com>

Create a local zbdi variable for f->zbd_info for the following functions:
zbd_open_zone(), zbd_convert_to_open_zone(), and zbd_adjust_block().

This avoids unnecessary indirections.

No functional change intended.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 69 +++++++++++++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/zbd.c b/zbd.c
index 8e99eb95..f09b0ee6 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1114,6 +1114,7 @@ static bool zbd_open_zone(struct thread_data *td, con=
st struct fio_file *f,
 			  uint32_t zone_idx)
 {
 	const uint32_t min_bs =3D td->o.min_bs[DDIR_WRITE];
+	struct zoned_block_device_info *zbdi =3D f->zbd_info;
 	struct fio_zone_info *z =3D get_zone(f, zone_idx);
 	bool res =3D true;
=20
@@ -1127,7 +1128,7 @@ static bool zbd_open_zone(struct thread_data *td, con=
st struct fio_file *f,
 	if (td->o.verify !=3D VERIFY_NONE && zbd_zone_full(f, z, min_bs))
 		return false;
=20
-	pthread_mutex_lock(&f->zbd_info->mutex);
+	pthread_mutex_lock(&zbdi->mutex);
 	if (is_zone_open(td, f, zone_idx)) {
 		/*
 		 * If the zone is already open and going to be full by writes
@@ -1142,16 +1143,16 @@ static bool zbd_open_zone(struct thread_data *td, c=
onst struct fio_file *f,
 	if (td->o.job_max_open_zones > 0 &&
 	    td->num_open_zones >=3D td->o.job_max_open_zones)
 		goto out;
-	if (f->zbd_info->num_open_zones >=3D f->zbd_info->max_open_zones)
+	if (zbdi->num_open_zones >=3D zbdi->max_open_zones)
 		goto out;
 	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
-	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] =3D zone_idx;
+	zbdi->open_zones[zbdi->num_open_zones++] =3D zone_idx;
 	td->num_open_zones++;
 	z->open =3D 1;
 	res =3D true;
=20
 out:
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_unlock(&zbdi->mutex);
 	return res;
 }
=20
@@ -1175,6 +1176,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,
 {
 	const uint32_t min_bs =3D td->o.min_bs[io_u->ddir];
 	struct fio_file *f =3D io_u->file;
+	struct zoned_block_device_info *zbdi =3D f->zbd_info;
 	struct fio_zone_info *z;
 	unsigned int open_zone_idx =3D -1;
 	uint32_t zone_idx, new_zone_idx;
@@ -1185,10 +1187,10 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
=20
 	if (td->o.max_open_zones || td->o.job_max_open_zones) {
 		/*
-		 * This statement accesses f->zbd_info->open_zones[] on purpose
+		 * This statement accesses zbdi->open_zones[] on purpose
 		 * without locking.
 		 */
-		zone_idx =3D f->zbd_info->open_zones[pick_random_zone_idx(f, io_u)];
+		zone_idx =3D zbdi->open_zones[pick_random_zone_idx(f, io_u)];
 	} else {
 		zone_idx =3D zbd_zone_idx(f, io_u->offset);
 	}
@@ -1200,9 +1202,9 @@ static struct fio_zone_info *zbd_convert_to_open_zone=
(struct thread_data *td,
 	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
=20
 	/*
-	 * Since z->mutex is the outer lock and f->zbd_info->mutex the inner
+	 * Since z->mutex is the outer lock and zbdi->mutex the inner
 	 * lock it can happen that the state of the zone with index zone_idx
-	 * has changed after 'z' has been assigned and before f->zbd_info->mutex
+	 * has changed after 'z' has been assigned and before zbdi->mutex
 	 * has been obtained. Hence the loop.
 	 */
 	for (;;) {
@@ -1211,12 +1213,12 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
 		z =3D get_zone(f, zone_idx);
 		if (z->has_wp)
 			zone_lock(td, f, z);
-		pthread_mutex_lock(&f->zbd_info->mutex);
+		pthread_mutex_lock(&zbdi->mutex);
 		if (z->has_wp) {
 			if (z->cond !=3D ZBD_ZONE_COND_OFFLINE &&
 			    td->o.max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D 0)
 				goto examine_zone;
-			if (f->zbd_info->num_open_zones =3D=3D 0) {
+			if (zbdi->num_open_zones =3D=3D 0) {
 				dprint(FD_ZBD, "%s(%s): no zones are open\n",
 				       __func__, f->file_name);
 				goto open_other_zone;
@@ -1230,14 +1232,14 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
 		 */
 		open_zone_idx =3D pick_random_zone_idx(f, io_u);
 		assert(!open_zone_idx ||
-		       open_zone_idx < f->zbd_info->num_open_zones);
+		       open_zone_idx < zbdi->num_open_zones);
 		tmp_idx =3D open_zone_idx;
-		for (i =3D 0; i < f->zbd_info->num_open_zones; i++) {
+		for (i =3D 0; i < zbdi->num_open_zones; i++) {
 			uint32_t tmpz;
=20
-			if (tmp_idx >=3D f->zbd_info->num_open_zones)
+			if (tmp_idx >=3D zbdi->num_open_zones)
 				tmp_idx =3D 0;
-			tmpz =3D f->zbd_info->open_zones[tmp_idx];
+			tmpz =3D zbdi->open_zones[tmp_idx];
 			if (f->min_zone <=3D tmpz && tmpz < f->max_zone) {
 				open_zone_idx =3D tmp_idx;
 				goto found_candidate_zone;
@@ -1248,39 +1250,39 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
=20
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
-		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&zbdi->mutex);
 		if (z->has_wp)
 			zone_unlock(z);
 		return NULL;
=20
 found_candidate_zone:
-		new_zone_idx =3D f->zbd_info->open_zones[open_zone_idx];
+		new_zone_idx =3D zbdi->open_zones[open_zone_idx];
 		if (new_zone_idx =3D=3D zone_idx)
 			break;
 		zone_idx =3D new_zone_idx;
-		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&zbdi->mutex);
 		if (z->has_wp)
 			zone_unlock(z);
 	}
=20
-	/* Both z->mutex and f->zbd_info->mutex are held. */
+	/* Both z->mutex and zbdi->mutex are held. */
=20
 examine_zone:
 	if (z->wp + min_bs <=3D zbd_zone_capacity_end(z)) {
-		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&zbdi->mutex);
 		goto out;
 	}
=20
 open_other_zone:
 	/* Check if number of open zones reaches one of limits. */
 	wait_zone_close =3D
-		f->zbd_info->num_open_zones =3D=3D f->max_zone - f->min_zone ||
+		zbdi->num_open_zones =3D=3D f->max_zone - f->min_zone ||
 		(td->o.max_open_zones &&
-		 f->zbd_info->num_open_zones =3D=3D td->o.max_open_zones) ||
+		 zbdi->num_open_zones =3D=3D td->o.max_open_zones) ||
 		(td->o.job_max_open_zones &&
 		 td->num_open_zones =3D=3D td->o.job_max_open_zones);
=20
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_unlock(&zbdi->mutex);
=20
 	/* Only z->mutex is held. */
=20
@@ -1295,7 +1297,7 @@ open_other_zone:
 	}
=20
 	/* Zone 'z' is full, so try to open a new zone. */
-	for (i =3D f->io_size / f->zbd_info->zone_size; i > 0; i--) {
+	for (i =3D f->io_size / zbdi->zone_size; i > 0; i--) {
 		zone_idx++;
 		if (z->has_wp)
 			zone_unlock(z);
@@ -1318,12 +1320,12 @@ open_other_zone:
 	/* Only z->mutex is held. */
=20
 	/* Check whether the write fits in any of the already opened zones. */
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	for (i =3D 0; i < f->zbd_info->num_open_zones; i++) {
-		zone_idx =3D f->zbd_info->open_zones[i];
+	pthread_mutex_lock(&zbdi->mutex);
+	for (i =3D 0; i < zbdi->num_open_zones; i++) {
+		zone_idx =3D zbdi->open_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >=3D f->max_zone)
 			continue;
-		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
=20
 		z =3D get_zone(f, zone_idx);
@@ -1331,9 +1333,9 @@ open_other_zone:
 		zone_lock(td, f, z);
 		if (z->wp + min_bs <=3D zbd_zone_capacity_end(z))
 			goto out;
-		pthread_mutex_lock(&f->zbd_info->mutex);
+		pthread_mutex_lock(&zbdi->mutex);
 	}
-	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_unlock(&zbdi->mutex);
 	zone_unlock(z);
 	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
 	       f->file_name);
@@ -1683,6 +1685,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td,=
 struct io_u *io_u,
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_=
u)
 {
 	struct fio_file *f =3D io_u->file;
+	struct zoned_block_device_info *zbdi =3D f->zbd_info;
 	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len =3D io_u->buflen;
@@ -1690,7 +1693,7 @@ enum io_u_action zbd_adjust_block(struct thread_data =
*td, struct io_u *io_u)
 	uint64_t new_len;
 	int64_t range;
=20
-	assert(f->zbd_info);
+	assert(zbdi);
 	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
@@ -1802,12 +1805,12 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 		assert(io_u->offset + io_u->buflen <=3D zb->wp);
 		goto accept;
 	case DDIR_WRITE:
-		if (io_u->buflen > f->zbd_info->zone_size) {
+		if (io_u->buflen > zbdi->zone_size) {
 			td_verror(td, EINVAL, "I/O buflen exceeds zone size");
 			dprint(FD_IO,
 			       "%s: I/O buflen %llu exceeds zone size %llu\n",
 			       f->file_name, io_u->buflen,
-			       (unsigned long long) f->zbd_info->zone_size);
+			       (unsigned long long) zbdi->zone_size);
 			goto eof;
 		}
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
@@ -1822,7 +1825,7 @@ enum io_u_action zbd_adjust_block(struct thread_data =
*td, struct io_u *io_u)
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (f->zbd_info->wp_sectors_with_data >=3D
+			if (zbdi->wp_sectors_with_data >=3D
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
 				zb->reset_zone =3D 1;
--=20
2.25.1

