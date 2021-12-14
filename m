Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07765C433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243257AbhLNBY0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:26 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60902 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243119AbhLNBY0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445066; x=1670981066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9JjX8CpEtnNlG/iY+mmE8GCt0xYxl+2+4gA6IJZLGO8=;
  b=QXcuAAOQZqibnkDoRuhcFULNLbW+MkgyihBg56hmR/hZImGzkijnF2YR
   BeWKlu1OZw45pzja+9fwlsnspkZsUNLd0aEygLvvHLDx2o7uz/DKXpm8B
   /bTzATtNeS4WQ4m7P78v3yyf1/EQx0dMsJ3eibAVCbBDNIvl9Pjk5W/H9
   V57t0XI+R8bg03mivxh0XCxVE7n6fo16PRcGfEA5RIu9cwfhJlJfb4HGo
   Am4NteIyKR9a8NtjOp9wMQywLfic6/bmCo4UQ+SLUA/6XxLe8gnJiG0AX
   RpHpCK24vTPjvzajgFm+eBMDfjx7RMUY53ZcyIXcmj8w4UxcJnjB+4/nW
   w==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300014507"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:26 +0800
IronPort-SDR: 283cAY/MOwVkj/6zRoxsL8XbDJJOip6TpCuENedElG5rYSo4JyS1ROCWHmOTyKA1dY7n/buvjp
 9k4jw0YZKIW+woaPTzESXptD/u8YCrqUFgJlc49F/fhaEGwL2rtGBQ/+13bscihXfzhbZtthVT
 j5Zc5F6S04iFUbfV9iSx++0zIbaaLT+xzVu3kPXdc4svEW0TfaI/EqKyH7gvD62fktK/Wow/KW
 DLHRGVHmVaovXglyCkezuy2oKVjHQswzLykuSTDAnY4ueAnppdU2mbJ5ntGCF7uTqRxiEBUkEY
 2kibLGHACDf6aLALu3zl5bvf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:52 -0800
IronPort-SDR: VJXnglQurfYXPDilmpan7EWpjviKkXtkmzvKwxEhIUZmHOpVC0Tw9aGhndL4BWkBtv33JiPIXd
 pRDb6A+MI9ZvS+CKja1iZjwyX94wt51LCVLAByP9vpLjN+FESPTj8GG0qG177gBtn4nHMaq1s/
 cJqGT68rh+g3uWuwia1uUHpHbBI9P+CJdR6UE72bQmQn+bS0T3UkrHLaeBleix9C8qCUCBfXD4
 5a62oZQ8mTftzmbQxxn/hB34L6RRHq/u8NcT0C5ho8SCeozbDXt+2eLdNOhpmpf8SHgDKi0Pmr
 mGI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:26 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdj6lTpz1RwFN
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:25 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445065; x=1642037066; bh=9JjX8CpEtnNlG/iY+m
        mE8GCt0xYxl+2+4gA6IJZLGO8=; b=Me0GESQL443FHvs4RqtAa2DxsIjjvok9cJ
        DHOQg+T+keniq7kbDO8XssSbc/7vAZ+CLJz3LFW5zZXgC5wA4Nmk0L0sQlFMSq+H
        a+S3UYI+posHx5XU/jPHBTz1N1oNZBlGgDBspLZM3+GwrwlX0g+zGbvEs/89nyc9
        MYF4lNiX+0PFwLCDkBFi4doYHgWmQ/49VMzquto8jYEwIP1T/SszuOy/FTbctxuC
        YXt3EEbezmKcmI7H9jEBLsfBkHEm+VC4i3j/ZG6bAy3/3w3buHAQsl2nEjYyI5zg
        vC7OFMlEnt7SyC1o1mEKRkuourtBKUTxZeDHsvxedajaN1Kt6QxQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FCS3wWwmJJt4 for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:25 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdh4S9sz1RvTh;
        Mon, 13 Dec 2021 17:24:24 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 09/12] zbd: rename zbd_zone_idx() and zbd_zone_nr()
Date:   Tue, 14 Dec 2021 10:24:10 +0900
Message-Id: <20211214012413.464798-10-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Rename zbd_zone_idx() to zbd_offset_to_zone_idx() to make it clear that
the argument determining the zone is a file offset. To be consistent,
rename zbd_zone_nr() to zbd_zone_idx() to avoid confusion with a number
of zones. While at it, have both functions return value be of the same
unsigned int type.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/zbd.c b/zbd.c
index b917fa42..592f7c03 100644
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
+ * zbd_offset_to_zone_idx - convert an offset into a zone number
  * @f: file pointer.
  * @offset: offset in bytes. If this offset is in the first zone_size by=
tes
  *	    past the disk size then the index of the sentinel is returned.
  */
-static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
+static unsigned int zbd_offset_to_zone_idx(const struct fio_file *f,
+					   uint64_t offset)
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
+	zone_idx_b =3D zbd_offset_to_zone_idx(f, f->file_offset);
+	zone_idx_e =3D
+		zbd_offset_to_zone_idx(f, f->file_offset + f->io_size - 1);
 	for (zone_idx =3D zone_idx_b; zone_idx <=3D zone_idx_e; zone_idx++)
 		if (get_zone(f, zone_idx)->has_wp)
 			return true;
@@ -538,7 +540,7 @@ static bool zbd_zone_align_file_sizes(struct thread_d=
ata *td,
 		return false;
 	}
=20
-	zone_idx =3D zbd_zone_idx(f, f->file_offset);
+	zone_idx =3D zbd_offset_to_zone_idx(f, f->file_offset);
 	z =3D get_zone(f, zone_idx);
 	if ((f->file_offset !=3D z->start) &&
 	    (td->o.td_ddir !=3D TD_DDIR_READ)) {
@@ -555,7 +557,7 @@ static bool zbd_zone_align_file_sizes(struct thread_d=
ata *td,
 		f->file_offset =3D new_offset;
 	}
=20
-	zone_idx =3D zbd_zone_idx(f, f->file_offset + f->io_size);
+	zone_idx =3D zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
 	z =3D get_zone(f, zone_idx);
 	new_end =3D z->start;
 	if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
@@ -1046,8 +1048,9 @@ int zbd_setup_files(struct thread_data *td)
=20
 		assert(zbd);
=20
-		f->min_zone =3D zbd_zone_idx(f, f->file_offset);
-		f->max_zone =3D zbd_zone_idx(f, f->file_offset + f->io_size);
+		f->min_zone =3D zbd_offset_to_zone_idx(f, f->file_offset);
+		f->max_zone =3D
+			zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
=20
 		/*
 		 * When all zones in the I/O range are conventional, io_size
@@ -1275,7 +1278,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
 		 */
 		zone_idx =3D zbdi->open_zones[pick_random_zone_idx(f, io_u)];
 	} else {
-		zone_idx =3D zbd_zone_idx(f, io_u->offset);
+		zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
 	}
 	if (zone_idx < f->min_zone)
 		zone_idx =3D f->min_zone;
@@ -1597,7 +1600,7 @@ static void zbd_queue_io(struct thread_data *td, st=
ruct io_u *io_u, int q,
=20
 	assert(zbd_info);
=20
-	zone_idx =3D zbd_zone_idx(f, io_u->offset);
+	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
 	z =3D get_zone(f, zone_idx);
=20
@@ -1655,7 +1658,7 @@ static void zbd_put_io(struct thread_data *td, cons=
t struct io_u *io_u)
=20
 	assert(zbd_info);
=20
-	zone_idx =3D zbd_zone_idx(f, io_u->offset);
+	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
 	z =3D get_zone(f, zone_idx);
=20
@@ -1711,7 +1714,7 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)
 	assert(td->o.zone_size);
 	assert(f->zbd_info);
=20
-	zone_idx =3D zbd_zone_idx(f, f->last_pos[ddir]);
+	zone_idx =3D zbd_offset_to_zone_idx(f, f->last_pos[ddir]);
 	z =3D get_zone(f, zone_idx);
=20
 	/*
@@ -1819,7 +1822,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
=20
-	zone_idx_b =3D zbd_zone_idx(f, io_u->offset);
+	zone_idx_b =3D zbd_offset_to_zone_idx(f, io_u->offset);
 	zb =3D get_zone(f, zone_idx_b);
 	orig_zb =3D zb;
=20
@@ -2102,7 +2105,7 @@ int zbd_do_io_u_trim(const struct thread_data *td, =
struct io_u *io_u)
 	uint32_t zone_idx;
 	int ret;
=20
-	zone_idx =3D zbd_zone_idx(f, io_u->offset);
+	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
 	z =3D get_zone(f, zone_idx);
=20
 	if (!z->has_wp)
--=20
2.31.1

