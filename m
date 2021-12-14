Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BCBC433EF
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbhLNBYX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:23 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60902 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbhLNBYX (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445063; x=1670981063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u8qu/kx0AHwk+LGYI7Ey0bfx32sv1rjcZwpz65js2O0=;
  b=PoUS5ut/+NIxEUlyTHDmAHVpn6i2UnS/lOsBFjnp4gTtF8xqIln9HRdH
   RlHBLAePO4t0G7tm/556udDBT/T8GyactwfE0fEZP42uod8v7yzGZyTE5
   nN2I5R16ibho6SMK3ScxdutosSx9kHQYUNXmiQkhuq00Qbbc/70ApDded
   YO2CZoMT4EmwtO8RufnbxehsLdiVpoACELWt0wWK1D7+YhbNUlzHPDyYG
   VbvKne77cejn0XNDr48NLnNY83V9NTSq6hPZ9fWiajgf7h4mSHirrmahk
   fG7QL9Q7+RiEV6CRxdWFnOPgXFyRbZULgut7bAzZXsw613nr9PYVR/fV1
   g==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300014503"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:23 +0800
IronPort-SDR: P/M8KCzUJm7zGZDbMLPnyfkbPw+uD3JBmach2NLGBIAN/GKnfpT8/eJEiDV/XD+oqHwKBKc7dZ
 XVX17EjBtXG5WhSYtu3ZI/XK6MBmmLzY8U2x9PHL/12b8ZBapPxPNsyuD0rkBmeWBj8qIXege4
 7WxYbbp8GxInh01RkHLazHyS69V6iMSkxJ7NtPrjMZsr7n0pwOc7APr6ySXE4V3TobWdHMDHqL
 zsZ6r302fyw2iTzKDBl8UorMH8/WmMRpzkQRU6gWt/i7tx5Hr519E2vmhmN2iGhhogBfkitpP2
 utnKQZeRBQQcJu30YZqFugoR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:49 -0800
IronPort-SDR: ztgUBqRth9k3q6vgTMEWzdXSV5enHNxC2DTFmXQmnOEoUS2+ABHr2xv8WGrckjZ6g+JpJH8IWP
 E78vW0noxO9bOyIymqESx/ZbEbgzEIzw2trnBrdBBiyzFkfbmY5e8OE0p0xIatbuZWvq2fIj0M
 Sukceu4ye6qmI6ylNoOK5XTxivy0i3mCBKTlUcSMBq+oi15OoQXZzqlYk2nS6/cRYBpekHH+sQ
 6N2T5RGZDkVKt7bBkOdhN5tuWtDqWJn7VTpan1kbaO45BlwhKnFX0kbnZ/A+Pr1Sbacfv167Om
 cKY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdg15pqz1Rvlf
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445061; x=1642037062; bh=u8qu/kx0AHwk+LGYI7
        Ey0bfx32sv1rjcZwpz65js2O0=; b=HDggtdglF8SEXdFWkGrG4TQBC+w3GY3itk
        veeOZSV8/7H/pPg1Gsj8rOQxcz/VTkBPfZfIT2x/pMOPoCMK96vFY4ZSz0JWhR5U
        4GRosuuwoZdQWiMa1SKK5cV3wCZriwAzSwdv+6SjUAZZnAhlY8igCoz/Rc+mnq5W
        0d6QXo7nW8CGIsvXLS8xowRh9IJYDxa4L7umvyo2IX79pbHKoA7z+GsKdmC40cI/
        KutSPJ2ypCgrlI9LJkSS3e3moyjh0aio5QRcoxez8Pxzi6vKIUFQ81/Zn7abMRzb
        H7dzcCQKDFnZO4qdfRloFHARCanFvgnjT0AM4tScW19HY9FG6rvA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yUzCmoKDwav5 for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:21 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdd11jSz1RtVG;
        Mon, 13 Dec 2021 17:24:20 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 06/12] zbd: fix code style issues
Date:   Tue, 14 Dec 2021 10:24:07 +0900
Message-Id: <20211214012413.464798-7-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 177 +++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 125 insertions(+), 52 deletions(-)

diff --git a/zbd.c b/zbd.c
index 11c15c62..b87fefc4 100644
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
@@ -595,6 +610,7 @@ static bool zbd_verify_bs(void)
=20
 			if (!f->zbd_info)
 				continue;
+
 			zone_size =3D f->zbd_info->zone_size;
 			if (td_trim(td) && td->o.bs[DDIR_TRIM] !=3D zone_size) {
 				log_info("%s: trim block size %llu is not the zone size %"PRIu64"\n"=
,
@@ -739,8 +755,8 @@ static int parse_zone_info(struct thread_data *td, st=
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
@@ -756,6 +772,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)
 						     PTHREAD_MUTEX_RECURSIVE);
 			p->start =3D z->start;
 			p->capacity =3D z->capacity;
+
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
 			case ZBD_ZONE_COND_FULL:
@@ -789,6 +806,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)
 		offset =3D z->start + z->len;
 		if (j >=3D nr_zones)
 			break;
+
 		nrz =3D zbd_report_zones(td, f, offset, zones,
 				       min((uint32_t)(nr_zones - j),
 					   ZBD_REPORT_MAX_ZONES));
@@ -856,7 +874,8 @@ out:
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
@@ -958,6 +977,7 @@ static int zbd_init_zone_info(struct thread_data *td,=
 struct fio_file *file)
 	ret =3D zbd_create_zone_info(td, file);
 	if (ret < 0)
 		td_verror(td, -ret, "zbd_create_zone_info() failed");
+
 	return ret;
 }
=20
@@ -970,6 +990,7 @@ int zbd_init_files(struct thread_data *td)
 		if (zbd_init_zone_info(td, f))
 			return 1;
 	}
+
 	return 0;
 }
=20
@@ -980,27 +1001,24 @@ void zbd_recalc_options_with_zone_granularity(stru=
ct thread_data *td)
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
@@ -1143,6 +1161,7 @@ static uint64_t zbd_process_swd(struct thread_data =
*td,
 		}
 		swd +=3D z->wp - z->start;
 	}
+
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	switch (a) {
 	case CHECK_SWD:
@@ -1155,6 +1174,7 @@ static uint64_t zbd_process_swd(struct thread_data =
*td,
 		break;
 	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
+
 	for (z =3D zb; z < ze; z++)
 		if (z->has_wp)
 			zone_unlock(z);
@@ -1188,8 +1208,10 @@ void zbd_file_reset(struct thread_data *td, struct=
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
@@ -1204,8 +1226,8 @@ void zbd_file_reset(struct thread_data *td, struct =
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
@@ -1258,7 +1280,9 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
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
@@ -1273,10 +1297,13 @@ static struct fio_zone_info *zbd_convert_to_open_=
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
@@ -1286,14 +1313,15 @@ static struct fio_zone_info *zbd_convert_to_open_=
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
@@ -1310,9 +1338,12 @@ static struct fio_zone_info *zbd_convert_to_open_z=
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
@@ -1320,7 +1351,9 @@ found_candidate_zone:
 		if (new_zone_idx =3D=3D zone_idx)
 			break;
 		zone_idx =3D new_zone_idx;
+
 		pthread_mutex_unlock(&zbdi->mutex);
+
 		if (z->has_wp)
 			zone_unlock(z);
 	}
@@ -1351,7 +1384,8 @@ open_other_zone:
 	 * zone close before opening a new zone.
 	 */
 	if (wait_zone_close) {
-		dprint(FD_ZBD, "%s(%s): quiesce to allow open zones to close\n",
+		dprint(FD_ZBD,
+		       "%s(%s): quiesce to allow open zones to close\n",
 		       __func__, f->file_name);
 		io_u_quiesce(td);
 	}
@@ -1404,7 +1438,8 @@ retry:
 	 */
 	in_flight =3D any_io_in_flight();
 	if (in_flight || should_retry) {
-		dprint(FD_ZBD, "%s(%s): wait zone close and retry open zones\n",
+		dprint(FD_ZBD,
+		       "%s(%s): wait zone close and retry open zones\n",
 		       __func__, f->file_name);
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
@@ -1415,17 +1450,22 @@ retry:
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
@@ -1444,18 +1484,20 @@ static struct fio_zone_info *zbd_replay_write_ord=
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
@@ -1493,6 +1535,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *=
io_u, uint64_t min_bytes,
 		} else if (!td_random(td)) {
 			break;
 		}
+
 		if (td_random(td) && z2 >=3D zf &&
 		    z2->cond !=3D ZBD_ZONE_COND_OFFLINE) {
 			if (z2->has_wp)
@@ -1503,8 +1546,11 @@ zbd_find_zone(struct thread_data *td, struct io_u =
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
@@ -1567,11 +1613,12 @@ static void zbd_queue_io(struct thread_data *td, =
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
@@ -1671,8 +1718,8 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
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
@@ -1770,6 +1817,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
+
 	zone_idx_b =3D zbd_zone_idx(f, io_u->offset);
 	zb =3D get_zone(f, zone_idx_b);
 	orig_zb =3D zb;
@@ -1778,6 +1826,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 		/* Accept non-write I/Os for conventional zones. */
 		if (io_u->ddir !=3D DDIR_WRITE)
 			return io_u_accept;
+
 		/*
 		 * Make sure that writes to conventional zones
 		 * don't cross over to any sequential zones.
@@ -1791,12 +1840,16 @@ enum io_u_action zbd_adjust_block(struct thread_d=
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
@@ -1818,6 +1871,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			zb =3D zbd_replay_write_order(td, io_u, zb);
 			goto accept;
 		}
+
 		/*
 		 * Check that there is enough written data in the zone to do an
 		 * I/O of at least min_bs B. If there isn't, find a new zone for
@@ -1847,6 +1901,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			if (!td_random(td))
 				io_u->offset =3D zb->start;
 		}
+
 		/*
 		 * Make sure the I/O is within the zone valid data range while
 		 * maximizing the I/O size and preserving randomness.
@@ -1857,12 +1912,14 @@ enum io_u_action zbd_adjust_block(struct thread_d=
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
@@ -1874,9 +1931,12 @@ enum io_u_action zbd_adjust_block(struct thread_da=
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
@@ -1885,6 +1945,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			       f->file_name, io_u->buflen, zbdi->zone_size);
 			goto eof;
 		}
+
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
 			zone_unlock(zb);
 			zb =3D zbd_convert_to_open_zone(td, io_u);
@@ -1894,14 +1955,14 @@ enum io_u_action zbd_adjust_block(struct thread_d=
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
@@ -1924,6 +1985,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 				goto eof;
 			}
 		}
+
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
 		io_u->offset =3D zb->wp;
@@ -1933,6 +1995,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 			       f->file_name, io_u->offset);
 			goto eof;
 		}
+
 		/*
 		 * Make sure that the buflen is a multiple of the minimal
 		 * block size. Give up if shrinking would make the request too
@@ -1949,10 +2012,13 @@ enum io_u_action zbd_adjust_block(struct thread_d=
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
@@ -1968,7 +2034,9 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
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
@@ -1986,19 +2054,23 @@ accept:
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
@@ -2036,7 +2108,8 @@ int zbd_do_io_u_trim(const struct thread_data *td, =
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

