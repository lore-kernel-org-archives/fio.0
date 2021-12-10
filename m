Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB632C433F5
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhLJCT3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:29 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33942 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbhLJCTY (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102550; x=1670638550;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=PCXZQnTf0p2YqjWWl6x4ckjhp9eo0V/TitoOg62W8JQ=;
  b=XTu0nYNqQQGNV/h59sGrFNGQ6OIvxFDs8ZfS0ddy/bYcC5HzJS5vYh0R
   O560cEV/g7Jjaa4nJ7yzB4Uam9+yHIRhRL5EkqGiEckN9bAyXJgV1jeAr
   9lvF9CewlFAPlduaLdnjIsK1LqIkwIBHqkoXNATh3209pYA3iSXeivYip
   L0+btxRXTl8IqVicP3pioZbyA9ahTD7BkUd10wQ/uKdfBizpCHUxX9fVM
   SMPEdu3soVwUmaQZMiYFnTHc+eOKFE9q6cjg0TPAKR7OJSNkmMMSsHM1b
   pagaMNj+t3gtQKEqvXQ58xmjkp8++RVqcdm3ERMM5ukhAoWrMbzHE1YVt
   w==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907584"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:49 +0800
IronPort-SDR: nsDuLLf5B14FcYFf1UENBxclz1bllO296mbey0kP+cp2rYvzzZ+5wUp2/Wnbn7pipxQwJ+ZFaX
 QgVAZxQB3t0hFEvpxZH0vvzpDJmGAVT4M3gEIunOuPjkQIkUWsvLT1rAmk+myFGywBtyiymoDi
 kpSRxVMa5O4YJlBKFaqiMUzJxO4ip9+PQn5/YgvAl5fdPwkQl5JHdGq+GzImuMRr7VswyxbjYi
 b/QXnSlDFgG5PZKekwiAlI5+21lq+HB/O6s+7jcyPg2sPe2Jm1MBo49JJ2gLNPORYsTRgEIR1R
 9gUOA5z32kEAnxZ0qcQunkij
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:21 -0800
IronPort-SDR: BF8qIwwU8YlGNw6eIDqpBPbcE/ruEKoGaf4BazTR35PrYv+bvRDb/rwp6sHfiwG5wRvirAyTN/
 /4wHFmQU8v0KEwx0R6Gt8nSG8JUZoMCyUuo7/zH8ryA/3bw4Tbbcf+80K9HpGp4lUXjgudA3Ad
 e8tI6BBaOYoVYlHNL3CPB/xRm5lO/zkXwPKnW5StdTbaCAWhtN7JllvtXMAKY7yB7M8xN+zQLi
 5DXIJJoEP409A7l86mVAsvHHOTt9ro9FzIILlQvAn2OTvLrlgx39kNpNfIh8h8PFrqbmY7+lPA
 gGQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:49 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dyr4bzKz1RwFN
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:48 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102547; x=1641694548; bh=PCXZQnTf0p2YqjWWl6
        x4ckjhp9eo0V/TitoOg62W8JQ=; b=BAKvZkMBLK/6HJo1Kto6nFF8RsKOfPL2CS
        xJoS5Z+Nxn8h+jdbZuwnre5wp1sCpk80UobHDyNFfO+exY9nX8npP3PZhYcyR4t9
        XwTCDh9MW9bxtDKC0A6HrYUQjy37sOpnumMYmY+FsK6KTgS5AWSP7qjdnrOLVL73
        8Ycd612JZJ6qLNDFX75KyYotFMQmNby9ulElsg9TKPFkLWOHd6XIWYJImFBZhAXd
        2V7mhlpaonHVt8fuc947Ijg+Fx/EyNGAtXKMJPp5CKzWFYUKPFrF/2S5hpOL3wxa
        1nXDWg8w4e2BDVXgpR5iL9ufIuwxSBfIi0+HfhjAe4HDaiuET2bg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XhtnXxH-8h9A for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:47 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyq2TTVz1RtVG;
        Thu,  9 Dec 2021 18:15:47 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/11] zbd: fix code style issues
Date:   Fri, 10 Dec 2021 11:15:36 +0900
Message-Id: <20211210021541.317315-7-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Avoid overly long lines, remove unnecessary curly brackets and add blank
lines to make the code more readable.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 177 +++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 125 insertions(+), 52 deletions(-)

diff --git a/zbd.c b/zbd.c
index 70073461..6a26269d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -252,8 +252,9 @@ static int zbd_reset_zone(struct thread_data *td, str=
uct fio_file *f,
=20
 	assert(is_valid_offset(f, offset + length - 1));
=20
-	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
-		zbd_zone_nr(f, z));
+	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n",
+	       f->file_name, zbd_zone_nr(f, z));
+
 	switch (f->zbd_info->model) {
 	case ZBD_HOST_AWARE:
 	case ZBD_HOST_MANAGED:
@@ -269,6 +270,7 @@ static int zbd_reset_zone(struct thread_data *td, str=
uct fio_file *f,
 	f->zbd_info->sectors_with_data -=3D data_in_zone;
 	f->zbd_info->wp_sectors_with_data -=3D data_in_zone;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
+
 	z->wp =3D z->start;
 	z->verify_block =3D 0;
=20
@@ -297,11 +299,14 @@ static void zbd_close_zone(struct thread_data *td, =
const struct fio_file *f,
 	if (open_zone_idx =3D=3D f->zbd_info->num_open_zones)
 		return;
=20
-	dprint(FD_ZBD, "%s: closing zone %d\n", f->file_name, zone_idx);
+	dprint(FD_ZBD, "%s: closing zone %d\n",
+	       f->file_name, zone_idx);
+
 	memmove(f->zbd_info->open_zones + open_zone_idx,
 		f->zbd_info->open_zones + open_zone_idx + 1,
 		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
 		sizeof(f->zbd_info->open_zones[0]));
+
 	f->zbd_info->num_open_zones--;
 	td->num_open_zones--;
 	get_zone(f, zone_idx)->open =3D 0;
@@ -326,23 +331,27 @@ static int zbd_reset_zones(struct thread_data *td, =
struct fio_file *f,
=20
 	assert(min_bs);
=20
-	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
-		zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
+	dprint(FD_ZBD, "%s: examining zones %u .. %u\n",
+	       f->file_name, zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
+
 	for (z =3D zb; z < ze; z++) {
 		uint32_t nz =3D zbd_zone_nr(f, z);
=20
 		if (!z->has_wp)
 			continue;
+
 		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		zbd_close_zone(td, f, nz);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
+
 		if (z->wp !=3D z->start) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
 			       f->file_name, zbd_zone_nr(f, z));
 			if (zbd_reset_zone(td, f, z) < 0)
 				res =3D 1;
 		}
+
 		zone_unlock(z);
 	}
=20
@@ -427,6 +436,7 @@ static bool zbd_open_zone(struct thread_data *td, con=
st struct fio_file *f,
 			res =3D false;
 		goto out;
 	}
+
 	res =3D false;
 	/* Zero means no limit */
 	if (td->o.job_max_open_zones > 0 &&
@@ -434,7 +444,10 @@ static bool zbd_open_zone(struct thread_data *td, co=
nst struct fio_file *f,
 		goto out;
 	if (zbdi->num_open_zones >=3D zbdi->max_open_zones)
 		goto out;
-	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
+
+	dprint(FD_ZBD, "%s: opening zone %d\n",
+	       f->file_name, zone_idx);
+
 	zbdi->open_zones[zbdi->num_open_zones++] =3D zone_idx;
 	td->num_open_zones++;
 	z->open =3D 1;
@@ -471,8 +484,10 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	uint32_t zone_idx, zone_idx_b, zone_idx_e;
=20
 	assert(f->zbd_info);
+
 	if (f->io_size =3D=3D 0)
 		return false;
+
 	zone_idx_b =3D zbd_zone_idx(f, f->file_offset);
 	zone_idx_e =3D zbd_zone_idx(f, f->file_offset + f->io_size - 1);
 	for (zone_idx =3D zone_idx_b; zone_idx <=3D zone_idx_e; zone_idx++)
@@ -592,6 +607,7 @@ static bool zbd_verify_bs(void)
=20
 			if (!f->zbd_info)
 				continue;
+
 			zone_size =3D f->zbd_info->zone_size;
 			if (td_trim(td) && td->o.bs[DDIR_TRIM] !=3D zone_size) {
 				log_info("%s: trim block size %llu is not the zone size %"PRIu64"\n"=
,
@@ -736,8 +752,8 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)
 		goto out;
 	}
=20
-	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n", f->file=
_name,
-	       nr_zones, zone_size / 1024);
+	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n",
+	       f->file_name, nr_zones, zone_size / 1024);
=20
 	zbd_info =3D scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -753,6 +769,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)
 						     PTHREAD_MUTEX_RECURSIVE);
 			p->start =3D z->start;
 			p->capacity =3D z->capacity;
+
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
 			case ZBD_ZONE_COND_FULL:
@@ -786,6 +803,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)
 		offset =3D z->start + z->len;
 		if (j >=3D nr_zones)
 			break;
+
 		nrz =3D zbd_report_zones(td, f, offset, zones,
 				       min((uint32_t)(nr_zones - j),
 					   ZBD_REPORT_MAX_ZONES));
@@ -853,7 +871,8 @@ out:
 	/* Ensure that the limit is not larger than FIO's internal limit */
 	if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
 		td_verror(td, EINVAL, "'max_open_zones' value is too large");
-		log_err("'max_open_zones' value is larger than %u\n", ZBD_MAX_OPEN_ZON=
ES);
+		log_err("'max_open_zones' value is larger than %u\n",
+			ZBD_MAX_OPEN_ZONES);
 		return -EINVAL;
 	}
=20
@@ -955,6 +974,7 @@ static int zbd_init_zone_info(struct thread_data *td,=
 struct fio_file *file)
 	ret =3D zbd_create_zone_info(td, file);
 	if (ret < 0)
 		td_verror(td, -ret, "zbd_create_zone_info() failed");
+
 	return ret;
 }
=20
@@ -967,6 +987,7 @@ int zbd_init_files(struct thread_data *td)
 		if (zbd_init_zone_info(td, f))
 			return 1;
 	}
+
 	return 0;
 }
=20
@@ -977,27 +998,24 @@ void zbd_recalc_options_with_zone_granularity(struc=
t thread_data *td)
=20
 	for_each_file(td, f, i) {
 		struct zoned_block_device_info *zbd =3D f->zbd_info;
-		// zonemode=3Dstrided doesn't get per-file zone size.
-		uint64_t zone_size =3D zbd ? zbd->zone_size : td->o.zone_size;
+		uint64_t zone_size;
=20
+		/* zonemode=3Dstrided doesn't get per-file zone size. */
+		zone_size =3D zbd ? zbd->zone_size : td->o.zone_size;
 		if (zone_size =3D=3D 0)
 			continue;
=20
-		if (td->o.size_nz > 0) {
+		if (td->o.size_nz > 0)
 			td->o.size =3D td->o.size_nz * zone_size;
-		}
-		if (td->o.io_size_nz > 0) {
+		if (td->o.io_size_nz > 0)
 			td->o.io_size =3D td->o.io_size_nz * zone_size;
-		}
-		if (td->o.start_offset_nz > 0) {
+		if (td->o.start_offset_nz > 0)
 			td->o.start_offset =3D td->o.start_offset_nz * zone_size;
-		}
-		if (td->o.offset_increment_nz > 0) {
-			td->o.offset_increment =3D td->o.offset_increment_nz * zone_size;
-		}
-		if (td->o.zone_skip_nz > 0) {
+		if (td->o.offset_increment_nz > 0)
+			td->o.offset_increment =3D
+				td->o.offset_increment_nz * zone_size;
+		if (td->o.zone_skip_nz > 0)
 			td->o.zone_skip =3D td->o.zone_skip_nz * zone_size;
-		}
 	}
 }
=20
@@ -1140,6 +1158,7 @@ static uint64_t zbd_process_swd(struct thread_data =
*td,
 		}
 		swd +=3D z->wp - z->start;
 	}
+
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	switch (a) {
 	case CHECK_SWD:
@@ -1152,6 +1171,7 @@ static uint64_t zbd_process_swd(struct thread_data =
*td,
 		break;
 	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
+
 	for (z =3D zb; z < ze; z++)
 		if (z->has_wp)
 			zone_unlock(z);
@@ -1185,8 +1205,10 @@ void zbd_file_reset(struct thread_data *td, struct=
 fio_file *f)
 	zb =3D get_zone(f, f->min_zone);
 	ze =3D get_zone(f, f->max_zone);
 	swd =3D zbd_process_swd(td, f, SET_SWD);
-	dprint(FD_ZBD, "%s(%s): swd =3D %" PRIu64 "\n", __func__, f->file_name,
-	       swd);
+
+	dprint(FD_ZBD, "%s(%s): swd =3D %" PRIu64 "\n",
+	       __func__, f->file_name, swd);
+
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
@@ -1201,8 +1223,8 @@ void zbd_file_reset(struct thread_data *td, struct =
fio_file *f)
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
 {
-	return (io_u->offset - f->file_offset) * f->zbd_info->num_open_zones /
-		f->io_size;
+	return (io_u->offset - f->file_offset) *
+		f->zbd_info->num_open_zones / f->io_size;
 }
=20
 static bool any_io_in_flight(void)
@@ -1255,7 +1277,9 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
 		zone_idx =3D f->min_zone;
 	else if (zone_idx >=3D f->max_zone)
 		zone_idx =3D f->max_zone - 1;
-	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld=
)\n",
+
+	dprint(FD_ZBD,
+	       "%s(%s): starting from zone %d (offset %lld, buflen %lld)\n",
 	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
=20
 	/*
@@ -1270,10 +1294,13 @@ static struct fio_zone_info *zbd_convert_to_open_=
zone(struct thread_data *td,
 		z =3D get_zone(f, zone_idx);
 		if (z->has_wp)
 			zone_lock(td, f, z);
+
 		pthread_mutex_lock(&zbdi->mutex);
+
 		if (z->has_wp) {
 			if (z->cond !=3D ZBD_ZONE_COND_OFFLINE &&
-			    zbdi->max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D =
0)
+			    zbdi->max_open_zones =3D=3D 0 &&
+			    td->o.job_max_open_zones =3D=3D 0)
 				goto examine_zone;
 			if (zbdi->num_open_zones =3D=3D 0) {
 				dprint(FD_ZBD, "%s(%s): no zones are open\n",
@@ -1283,14 +1310,15 @@ static struct fio_zone_info *zbd_convert_to_open_=
zone(struct thread_data *td,
 		}
=20
 		/*
-		 * List of opened zones is per-device, shared across all threads.
-		 * Start with quasi-random candidate zone.
-		 * Ignore zones which don't belong to thread's offset/size area.
+		 * List of opened zones is per-device, shared across all
+		 * threads. Start with quasi-random candidate zone. Ignore
+		 * zones which don't belong to thread's offset/size area.
 		 */
 		open_zone_idx =3D pick_random_zone_idx(f, io_u);
 		assert(!open_zone_idx ||
 		       open_zone_idx < zbdi->num_open_zones);
 		tmp_idx =3D open_zone_idx;
+
 		for (i =3D 0; i < zbdi->num_open_zones; i++) {
 			uint32_t tmpz;
=20
@@ -1307,9 +1335,12 @@ static struct fio_zone_info *zbd_convert_to_open_z=
one(struct thread_data *td,
=20
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
+
 		pthread_mutex_unlock(&zbdi->mutex);
+
 		if (z->has_wp)
 			zone_unlock(z);
+
 		return NULL;
=20
 found_candidate_zone:
@@ -1317,7 +1348,9 @@ found_candidate_zone:
 		if (new_zone_idx =3D=3D zone_idx)
 			break;
 		zone_idx =3D new_zone_idx;
+
 		pthread_mutex_unlock(&zbdi->mutex);
+
 		if (z->has_wp)
 			zone_unlock(z);
 	}
@@ -1348,7 +1381,8 @@ open_other_zone:
 	 * zone close before opening a new zone.
 	 */
 	if (wait_zone_close) {
-		dprint(FD_ZBD, "%s(%s): quiesce to allow open zones to close\n",
+		dprint(FD_ZBD,
+		       "%s(%s): quiesce to allow open zones to close\n",
 		       __func__, f->file_name);
 		io_u_quiesce(td);
 	}
@@ -1401,7 +1435,8 @@ retry:
 	 */
 	in_flight =3D any_io_in_flight();
 	if (in_flight || should_retry) {
-		dprint(FD_ZBD, "%s(%s): wait zone close and retry open zones\n",
+		dprint(FD_ZBD,
+		       "%s(%s): wait zone close and retry open zones\n",
 		       __func__, f->file_name);
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
@@ -1412,17 +1447,22 @@ retry:
 	}
=20
 	pthread_mutex_unlock(&zbdi->mutex);
+
 	zone_unlock(z);
-	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
-	       f->file_name);
+
+	dprint(FD_ZBD, "%s(%s): did not open another zone\n",
+	       __func__, f->file_name);
+
 	return NULL;
=20
 out:
-	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
-	       zone_idx);
+	dprint(FD_ZBD, "%s(%s): returning zone %d\n",
+	       __func__, f->file_name, zone_idx);
+
 	io_u->offset =3D z->start;
 	assert(z->has_wp);
 	assert(z->cond !=3D ZBD_ZONE_COND_OFFLINE);
+
 	return z;
 }
=20
@@ -1441,18 +1481,20 @@ static struct fio_zone_info *zbd_replay_write_ord=
er(struct thread_data *td,
 	}
=20
 	if (z->verify_block * min_bs >=3D z->capacity) {
-		log_err("%s: %d * %"PRIu64" >=3D %"PRIu64"\n", f->file_name, z->verify=
_block,
-			min_bs, z->capacity);
+		log_err("%s: %d * %"PRIu64" >=3D %"PRIu64"\n",
+			f->file_name, z->verify_block, min_bs, z->capacity);
 		/*
 		 * If the assertion below fails during a test run, adding
 		 * "--experimental_verify=3D1" to the command line may help.
 		 */
 		assert(false);
 	}
+
 	io_u->offset =3D z->start + z->verify_block * min_bs;
 	if (io_u->offset + io_u->buflen >=3D zbd_zone_capacity_end(z)) {
-		log_err("%s: %llu + %llu >=3D %"PRIu64"\n", f->file_name, io_u->offset=
,
-			io_u->buflen, zbd_zone_capacity_end(z));
+		log_err("%s: %llu + %llu >=3D %"PRIu64"\n",
+			f->file_name, io_u->offset, io_u->buflen,
+			zbd_zone_capacity_end(z));
 		assert(false);
 	}
 	z->verify_block +=3D io_u->buflen / min_bs;
@@ -1490,6 +1532,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *=
io_u, uint64_t min_bytes,
 		} else if (!td_random(td)) {
 			break;
 		}
+
 		if (td_random(td) && z2 >=3D zf &&
 		    z2->cond !=3D ZBD_ZONE_COND_OFFLINE) {
 			if (z2->has_wp)
@@ -1500,8 +1543,11 @@ zbd_find_zone(struct thread_data *td, struct io_u =
*io_u, uint64_t min_bytes,
 				zone_unlock(z2);
 		}
 	}
-	dprint(FD_ZBD, "%s: no zone has %"PRIu64" bytes of readable data\n",
+
+	dprint(FD_ZBD,
+	       "%s: no zone has %"PRIu64" bytes of readable data\n",
 	       f->file_name, min_bytes);
+
 	return NULL;
 }
=20
@@ -1564,11 +1610,12 @@ static void zbd_queue_io(struct thread_data *td, =
struct io_u *io_u, int q,
 	case DDIR_WRITE:
 		zone_end =3D min((uint64_t)(io_u->offset + io_u->buflen),
 			       zbd_zone_capacity_end(z));
-		pthread_mutex_lock(&zbd_info->mutex);
+
 		/*
 		 * z->wp > zone_end means that one or more I/O errors
 		 * have occurred.
 		 */
+		pthread_mutex_lock(&zbd_info->mutex);
 		if (z->wp <=3D zone_end) {
 			zbd_info->sectors_with_data +=3D zone_end - z->wp;
 			zbd_info->wp_sectors_with_data +=3D zone_end - z->wp;
@@ -1668,8 +1715,8 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)
 	 * sequential write, skip to zone end if the latest position is at the
 	 * zone capacity limit.
 	 */
-	if (z->capacity < f->zbd_info->zone_size && !td_random(td) &&
-	    ddir =3D=3D DDIR_WRITE &&
+	if (z->capacity < f->zbd_info->zone_size &&
+	    !td_random(td) && ddir =3D=3D DDIR_WRITE &&
 	    f->last_pos[ddir] >=3D zbd_zone_capacity_end(z)) {
 		dprint(FD_ZBD,
 		       "%s: Jump from zone capacity limit to zone end:"
@@ -1767,6 +1814,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
+
 	zone_idx_b =3D zbd_zone_idx(f, io_u->offset);
 	zb =3D get_zone(f, zone_idx_b);
 	orig_zb =3D zb;
@@ -1775,6 +1823,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 		/* Accept non-write I/Os for conventional zones. */
 		if (io_u->ddir !=3D DDIR_WRITE)
 			return io_u_accept;
+
 		/*
 		 * Make sure that writes to conventional zones
 		 * don't cross over to any sequential zones.
@@ -1788,12 +1837,16 @@ enum io_u_action zbd_adjust_block(struct thread_d=
ata *td, struct io_u *io_u)
 			       "%s: off=3D%llu + min_bs=3D%"PRIu64" > next zone %"PRIu64"\n",
 			       f->file_name, io_u->offset,
 			       min_bs, (zb + 1)->start);
-			io_u->offset =3D zb->start + (zb + 1)->start - io_u->offset;
-			new_len =3D min(io_u->buflen, (zb + 1)->start - io_u->offset);
+			io_u->offset =3D
+				zb->start + (zb + 1)->start - io_u->offset;
+			new_len =3D min(io_u->buflen,
+				      (zb + 1)->start - io_u->offset);
 		} else {
 			new_len =3D (zb + 1)->start - io_u->offset;
 		}
+
 		io_u->buflen =3D new_len / min_bs * min_bs;
+
 		return io_u_accept;
 	}
=20
@@ -1815,6 +1868,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			zb =3D zbd_replay_write_order(td, io_u, zb);
 			goto accept;
 		}
+
 		/*
 		 * Check that there is enough written data in the zone to do an
 		 * I/O of at least min_bs B. If there isn't, find a new zone for
@@ -1844,6 +1898,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			if (!td_random(td))
 				io_u->offset =3D zb->start;
 		}
+
 		/*
 		 * Make sure the I/O is within the zone valid data range while
 		 * maximizing the I/O size and preserving randomness.
@@ -1854,12 +1909,14 @@ enum io_u_action zbd_adjust_block(struct thread_d=
ata *td, struct io_u *io_u)
 			io_u->offset =3D zb->start +
 				((io_u->offset - orig_zb->start) %
 				 (range - io_u->buflen)) / min_bs * min_bs;
+
 		/*
 		 * When zbd_find_zone() returns a conventional zone,
 		 * we can simply accept the new i/o offset here.
 		 */
 		if (!zb->has_wp)
 			return io_u_accept;
+
 		/*
 		 * Make sure the I/O does not cross over the zone wp position.
 		 */
@@ -1871,9 +1928,12 @@ enum io_u_action zbd_adjust_block(struct thread_da=
ta *td, struct io_u *io_u)
 			dprint(FD_IO, "Changed length from %u into %llu\n",
 			       orig_len, io_u->buflen);
 		}
+
 		assert(zb->start <=3D io_u->offset);
 		assert(io_u->offset + io_u->buflen <=3D zb->wp);
+
 		goto accept;
+
 	case DDIR_WRITE:
 		if (io_u->buflen > zbdi->zone_size) {
 			td_verror(td, EINVAL, "I/O buflen exceeds zone size");
@@ -1882,6 +1942,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			       f->file_name, io_u->buflen, zbdi->zone_size);
 			goto eof;
 		}
+
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
 			zone_unlock(zb);
 			zb =3D zbd_convert_to_open_zone(td, io_u);
@@ -1891,14 +1952,14 @@ enum io_u_action zbd_adjust_block(struct thread_d=
ata *td, struct io_u *io_u)
 				goto eof;
 			}
 		}
+
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (zbdi->wp_sectors_with_data >=3D
-			    f->io_size * td->o.zrt.u.f &&
-			    zbd_dec_and_reset_write_cnt(td, f)) {
+			if (zbdi->wp_sectors_with_data >=3D f->io_size * td->o.zrt.u.f &&
+			    zbd_dec_and_reset_write_cnt(td, f))
 				zb->reset_zone =3D 1;
-			}
 		}
+
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
 			assert(td->o.verify =3D=3D VERIFY_NONE);
@@ -1921,6 +1982,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 				goto eof;
 			}
 		}
+
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
 		io_u->offset =3D zb->wp;
@@ -1930,6 +1992,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			       f->file_name, io_u->offset);
 			goto eof;
 		}
+
 		/*
 		 * Make sure that the buflen is a multiple of the minimal
 		 * block size. Give up if shrinking would make the request too
@@ -1946,10 +2009,13 @@ enum io_u_action zbd_adjust_block(struct thread_d=
ata *td, struct io_u *io_u)
 			       orig_len, io_u->buflen);
 			goto accept;
 		}
+
 		td_verror(td, EIO, "zone remainder too small");
 		log_err("zone remainder %lld smaller than min block size %"PRIu64"\n",
 			(zbd_zone_capacity_end(zb) - io_u->offset), min_bs);
+
 		goto eof;
+
 	case DDIR_TRIM:
 		/* Check random trim targets a non-empty zone */
 		if (!td_random(td) || zb->wp > zb->start)
@@ -1965,7 +2031,9 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			       f->file_name, io_u->offset);
 			goto accept;
 		}
+
 		goto eof;
+
 	case DDIR_SYNC:
 		/* fall-through */
 	case DDIR_DATASYNC:
@@ -1983,19 +2051,23 @@ accept:
 	assert(zb->cond !=3D ZBD_ZONE_COND_OFFLINE);
 	assert(!io_u->zbd_queue_io);
 	assert(!io_u->zbd_put_io);
+
 	io_u->zbd_queue_io =3D zbd_queue_io;
 	io_u->zbd_put_io =3D zbd_put_io;
+
 	/*
 	 * Since we return with the zone lock still held,
 	 * add an annotation to let Coverity know that it
 	 * is intentional.
 	 */
 	/* coverity[missing_unlock] */
+
 	return io_u_accept;
=20
 eof:
 	if (zb && zb->has_wp)
 		zone_unlock(zb);
+
 	return io_u_eof;
 }
=20
@@ -2033,7 +2105,8 @@ int zbd_do_io_u_trim(const struct thread_data *td, =
struct io_u *io_u)
 		return 0;
=20
 	if (io_u->offset !=3D z->start) {
-		log_err("Trim offset not at zone start (%lld)\n", io_u->offset);
+		log_err("Trim offset not at zone start (%lld)\n",
+			io_u->offset);
 		return -EINVAL;
 	}
=20
--=20
2.31.1

