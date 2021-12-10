Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555C1C4332F
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhLJCTa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:30 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33947 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbhLJCT3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102555; x=1670638555;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=GDW22msnE/yKvQJSAg/8Rraf6p+0Q3mMJPM5uY0vM6Y=;
  b=oth5RZGeFAfGp8v8AfmlshjKuA9/Rtv+9qNmDVTU93YsjrDVXaMMK3CV
   aEAOps1A5Aeqqh2AjB1gaECwsYwFxSj++139iJqajuxEEFPIyA5Mm24FI
   xqVz0vyocDh95aikWL+gMvuEcvfVBzYCv+A3ndv1Y5GqjICRQYd1/VXHJ
   KJSZKLmVoeO6oiJ9/FCIc1EhirR3s/JhqgGrm6JKd5LJ+8Sf6jTInulep
   DnoG88sXDsttISLisz8cDacq8UVYtIekA8aYzahydDgFYT+Q0zlpOnYwZ
   dqKEAfza/cI//yhSR4F394iqnZC/Dvz29WKcKbAdcrs3xfQHFzwDzFWrU
   w==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907589"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:51 +0800
IronPort-SDR: 7H/Yu3Z6Xdqrb4verhJSPVxG0tUO924gJOT3pg/Kljuez9BeXddRfkSXz2JJJnf4BK4gGuy0SE
 78GGtlCYjUM3fxgcaKW/JRgvxtsQ8FitwdreovFVWgsS5AiYeyTl996pxwZKZWOUbjHuURlA/j
 umnQCSuALM4dgPruhePsKPCpssa0hpxuUMuz5xymk526bFhAeAKgC/Sg9lXK3dCKT6x4g66FhD
 LGYb3dziqfdsUQaRV+QeouIi4yYhO8ytM3x2ZGM4ECF/Wi2cUHjiQVbiLyaKkzgJ1EeFZJAbMx
 Dg9Rzk4JabWzB2rUsgeKp5u2
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:22 -0800
IronPort-SDR: y+Dqb/86DiGyjgb6A/DWyhBKuzecG/fPh+xc4zNbVnZdQU4FCqj4Lgna4SyQZ07HS09sWk+akC
 vuJWPsJZpOQReYIYZvfhJqvh7ptsKeNp8Ni6Ot9TMDodSr9qdkVQsjZPbSfp8VZzjr3MvF/l/u
 1cEW4NEyrMjMNc3QkEbPnoP/4OVKJqSLFd+sn7Wk/Mk74QEZAtLP3A264uZQI8IyiHj38biic3
 qHGDlkFSdvOBo7/D5tY9BHaeqN9bov9+pLDIGh4Fpu04CsQesWnnpDkj5E/wbD336VDlqFSU0I
 +Ns=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:51 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dyt4NXjz1Rvlf
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:50 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102550; x=1641694551; bh=GDW22msnE/yKvQJSAg
        /8Rraf6p+0Q3mMJPM5uY0vM6Y=; b=QTb/mubi4dxOQhPKvHhUukI+UHxYxJBLka
        xZAU4hhz5NDj8LrBVDsJr4nza6s9Uwkd9z68rFu3ndPk53GZQdFMNrMoMWDOF1ej
        /TZgnUD4TjW1hMYKzE/Rm7XYQUVxy2IsdqbdcUyzrLH9wrjcN8kiuLjYRQCFg+mc
        vpNe3g3GFgt0AGXJuLw3V1MyGA4Z2h+j++Jm7Y6JAURPt5x50x51T/TKYQ6xcgi5
        bI2S25ss3Env6Uan9OIGrbkkK9yM3yrCbxJquVV3Vc7KgnmXbVfKfndMu0jcupOD
        TKi3Yeph1NQxoqvSeNePpie112M3FTy/0bppSTHsI0ZmefXSqqtA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hIjgnsyYovk5 for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:50 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dys5g7Hz1RvTh;
        Thu,  9 Dec 2021 18:15:49 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/11] zbd: rename zbd_zone_idx() and zbd_zone_nr()
Date:   Fri, 10 Dec 2021 11:15:39 +0900
Message-Id: <20211210021541.317315-10-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Rename zbd_zone_idx() to zbd_zone_idx_from_offset() to make it clear
that the argument determining the zone is a file offset. To be
consistent, rename zbd_zone_nr() to zbd_zone_idx() to avoid confusion
with a number of zones.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/zbd.c b/zbd.c
index 49aee9b8..7204f68f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -27,19 +27,20 @@ static bool is_valid_offset(const struct fio_file *f,=
 uint64_t offset)
 	return (uint64_t)(offset - f->file_offset) < f->io_size;
 }
=20
-static inline unsigned int zbd_zone_nr(const struct fio_file *f,
-				       struct fio_zone_info *zone)
+static inline unsigned int zbd_zone_idx(const struct fio_file *f,
+					struct fio_zone_info *zone)
 {
 	return zone - f->zbd_info->zone_info;
 }
=20
 /**
- * zbd_zone_idx - convert an offset into a zone number
+ * zbd_zone_idx_from_offset - convert an offset into a zone number
  * @f: file pointer.
  * @offset: offset in bytes. If this offset is in the first zone_size by=
tes
  *	    past the disk size then the index of the sentinel is returned.
  */
-static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
+static uint32_t zbd_zone_idx_from_offset(const struct fio_file *f,
+					 uint64_t offset)
 {
 	uint32_t zone_idx;
=20
@@ -253,7 +254,7 @@ static int zbd_reset_zone(struct thread_data *td, str=
uct fio_file *f,
 	assert(is_valid_offset(f, offset + length - 1));
=20
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n",
-	       f->file_name, zbd_zone_nr(f, z));
+	       f->file_name, zbd_zone_idx(f, z));
=20
 	switch (f->zbd_info->model) {
 	case ZBD_HOST_AWARE:
@@ -303,7 +304,7 @@ static void zbd_close_zone(struct thread_data *td, co=
nst struct fio_file *f,
 		return;
=20
 	dprint(FD_ZBD, "%s: closing zone %u\n",
-	       f->file_name, zbd_zone_nr(f, z));
+	       f->file_name, zbd_zone_idx(f, z));
=20
 	memmove(f->zbd_info->open_zones + ozi,
 		f->zbd_info->open_zones + ozi + 1,
@@ -335,7 +336,7 @@ static int zbd_reset_zones(struct thread_data *td, st=
ruct fio_file *f,
 	assert(min_bs);
=20
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n",
-	       f->file_name, zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
+	       f->file_name, zbd_zone_idx(f, zb), zbd_zone_idx(f, ze));
=20
 	for (z =3D zb; z < ze; z++) {
 		if (!z->has_wp)
@@ -348,7 +349,7 @@ static int zbd_reset_zones(struct thread_data *td, st=
ruct fio_file *f,
=20
 		if (z->wp !=3D z->start) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
-			       f->file_name, zbd_zone_nr(f, z));
+			       f->file_name, zbd_zone_idx(f, z));
 			if (zbd_reset_zone(td, f, z) < 0)
 				res =3D 1;
 		}
@@ -404,7 +405,7 @@ static bool zbd_open_zone(struct thread_data *td, con=
st struct fio_file *f,
 {
 	const uint64_t min_bs =3D td->o.min_bs[DDIR_WRITE];
 	struct zoned_block_device_info *zbdi =3D f->zbd_info;
-	uint32_t zone_idx =3D zbd_zone_nr(f, z);
+	uint32_t zone_idx =3D zbd_zone_idx(f, z);
 	bool res =3D true;
=20
 	if (z->cond =3D=3D ZBD_ZONE_COND_OFFLINE)
@@ -489,8 +490,9 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	if (f->io_size =3D=3D 0)
 		return false;
=20
-	zone_idx_b =3D zbd_zone_idx(f, f->file_offset);
-	zone_idx_e =3D zbd_zone_idx(f, f->file_offset + f->io_size - 1);
+	zone_idx_b =3D zbd_zone_idx_from_offset(f, f->file_offset);
+	zone_idx_e =3D
+		zbd_zone_idx_from_offset(f, f->file_offset + f->io_size - 1);
 	for (zone_idx =3D zone_idx_b; zone_idx <=3D zone_idx_e; zone_idx++)
 		if (get_zone(f, zone_idx)->has_wp)
 			return true;
@@ -535,7 +537,7 @@ static bool zbd_verify_file_sizes(struct thread_data =
*td, struct fio_file *f)
 		return false;
 	}
=20
-	zone_idx =3D zbd_zone_idx(f, f->file_offset);
+	zone_idx =3D zbd_zone_idx_from_offset(f, f->file_offset);
 	z =3D get_zone(f, zone_idx);
 	if ((f->file_offset !=3D z->start) &&
 	    (td->o.td_ddir !=3D TD_DDIR_READ)) {
@@ -552,7 +554,7 @@ static bool zbd_verify_file_sizes(struct thread_data =
*td, struct fio_file *f)
 		f->file_offset =3D new_offset;
 	}
=20
-	zone_idx =3D zbd_zone_idx(f, f->file_offset + f->io_size);
+	zone_idx =3D zbd_zone_idx_from_offset(f, f->file_offset + f->io_size);
 	z =3D get_zone(f, zone_idx);
 	new_end =3D z->start;
 	if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
@@ -1043,8 +1045,9 @@ int zbd_setup_files(struct thread_data *td)
=20
 		assert(zbd);
=20
-		f->min_zone =3D zbd_zone_idx(f, f->file_offset);
-		f->max_zone =3D zbd_zone_idx(f, f->file_offset + f->io_size);
+		f->min_zone =3D zbd_zone_idx_from_offset(f, f->file_offset);
+		f->max_zone =3D
+			zbd_zone_idx_from_offset(f, f->file_offset + f->io_size);
=20
 		/*
 		 * When all zones in the I/O range are conventional, io_size
@@ -1272,7 +1275,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
 		 */
 		zone_idx =3D zbdi->open_zones[pick_random_zone_idx(f, io_u)];
 	} else {
-		zone_idx =3D zbd_zone_idx(f, io_u->offset);
+		zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
 	}
 	if (zone_idx < f->min_zone)
 		zone_idx =3D f->min_zone;
@@ -1594,7 +1597,7 @@ static void zbd_queue_io(struct thread_data *td, st=
ruct io_u *io_u, int q,
=20
 	assert(zbd_info);
=20
-	zone_idx =3D zbd_zone_idx(f, io_u->offset);
+	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
 	z =3D get_zone(f, zone_idx);
=20
@@ -1652,7 +1655,7 @@ static void zbd_put_io(struct thread_data *td, cons=
t struct io_u *io_u)
=20
 	assert(zbd_info);
=20
-	zone_idx =3D zbd_zone_idx(f, io_u->offset);
+	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
 	z =3D get_zone(f, zone_idx);
=20
@@ -1708,7 +1711,7 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)
 	assert(td->o.zone_size);
 	assert(f->zbd_info);
=20
-	zone_idx =3D zbd_zone_idx(f, f->last_pos[ddir]);
+	zone_idx =3D zbd_zone_idx_from_offset(f, f->last_pos[ddir]);
 	z =3D get_zone(f, zone_idx);
=20
 	/*
@@ -1816,7 +1819,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
=20
-	zone_idx_b =3D zbd_zone_idx(f, io_u->offset);
+	zone_idx_b =3D zbd_zone_idx_from_offset(f, io_u->offset);
 	zb =3D get_zone(f, zone_idx_b);
 	orig_zb =3D zb;
=20
@@ -2099,7 +2102,7 @@ int zbd_do_io_u_trim(const struct thread_data *td, =
struct io_u *io_u)
 	uint32_t zone_idx;
 	int ret;
=20
-	zone_idx =3D zbd_zone_idx(f, io_u->offset);
+	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
 	z =3D get_zone(f, zone_idx);
=20
 	if (!z->has_wp)
--=20
2.31.1

