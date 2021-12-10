Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E92DC43219
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhLJCTb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:31 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33951 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbhLJCT3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102555; x=1670638555;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=fb82oMVMReIaBdhlUjb/gnSiFOiDweh6qbiGJ/VgI4U=;
  b=RE2QHkl+zLwJU/wotjFeBTnqwiXa2nosu2rwJr1uNYYBLW6+FFOkSr9M
   QswgbNNy8JZ6TNGV5v3zHsVpbtESoQsdYMMZjSg1veC2ecqKtcy2HwlDY
   b6y1m2gxhmodpJ6yGhbhDeCJbWCHsiTmY/0Hqll7JF4maO/+hRd19PxMX
   R1nwQSrk4yYkhZBcdee7V6ery5ce5hiF/lAHGCAQ71teIrr6ZogPufgNg
   tU0RmRGJpCc+8SwXj/tTgd2iBU7P8y44oH/0YSNnIYE1ch5tAcAz/GVLA
   3guX3c0QPuZiq6StFvoQLIY+KhpLYsITFdSiyURAuH8iMx6h6r4doEjtG
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907592"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:53 +0800
IronPort-SDR: E3ypiNtDwuSzHeOUlY6kG6W7nZlfcRVhkY3snWYNuQLjCNdCq+yUPRpxcynkqgiyAUse8bJCJo
 O1j1iTwGfPQG6q7z4nsPTACRP3ZDcFRWLYCOmhpn5v7LGnC+ScenB1GBcl/gAOP1JLKujXJ18b
 8CjF1D0BgKS+dN0jAxf4ff9Lcan6qM7VF8jWuUieA6Xl8KA/hldOkOqrT7Dq62p8VnTC5ncOJH
 GEsIL3xNzdLl7+7mOThq2ofb6Y8Sha5/p53fpMujM75u4j08VRSAEBLi/RtekDEWQg6gAyW+4I
 oJK57xRpkGOtcHXvkLjnCuFi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:24 -0800
IronPort-SDR: kCZl1hM78NGcSx3BLBUxtT7cVOIjcb6HstDs++YM24x/UtXHMlBKD7bsURZ3fn2K/0TyopvS6I
 2xEWKvb03M/G+fpi/mU9iQmzgfSXU+MpsmdiZvyRf+CkAt4qnLpsJ7bjuusL65t1aRHduiMxks
 FY50nBmbXoBcgn6vFyLd9L/AQgaN2yVTtJAXb0Tt294TJ+9zWQs8Ievmxy9G879CPvqSh1frux
 JOOgMXSGWvvdVUqWTO7qdXN6EArH76Hh/YZ/lA4M9oATMTRlS6Wq8iP1IFT5Etiqoa6HxUgniL
 U54=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:52 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dyw0MNTz1Rvlf
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:52 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102551; x=1641694552; bh=fb82oMVMReIaBdhlUj
        b/gnSiFOiDweh6qbiGJ/VgI4U=; b=hR72I/Z37kBLgsI/8c9GbTdDYZrx0SOsC4
        TY5oG3N8fMQbZp6721EzFV0uKF1uuajX5dePIsLBxutdFUlu2GS8McilVtjHCCjH
        9YnNQjhO9jiuM6mJyDke2iIG7ZWE8g9Txqh7WIFJz5FZ2NcJoPWfx+84v5iDpCi3
        0tZP2uMCoolk1QqnvhvD5TFTMpea0/qg5iZsFEEqsx/lMkn+ZE/koBNgtmaGIEjZ
        PBD2IFI4afUrDPMvqvdvL4AhnavfTHyqaORTSCW8BGX+17JCUPwD/N+BkhMqN0p4
        OUFak3ZY+UTS/I7mExM9VO1UDXufE++W1VlIpsAcgjG04iqJhyQg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id B5RMOMRanQYQ for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:51 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyv1Ktkz1RvTh;
        Thu,  9 Dec 2021 18:15:51 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/11] zbd: introduce zbd_get_zone_from_offset() helper
Date:   Fri, 10 Dec 2021 11:15:41 +0900
Message-Id: <20211210021541.317315-12-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Introduce the helper function zbd_get_zone_from_offset() to get a zone
structure using a file offset. This replaces the common code pattern:

	zone_idx =3D zbd_zone_idx_from_offset(f, _offset);
	z =3D zbd_get_zone(f, zone_idx);

with a single function call in many functions.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/zbd.c b/zbd.c
index 5c0fe00b..ba583c9f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -129,6 +129,12 @@ static inline struct fio_zone_info *zbd_get_zone(con=
st struct fio_file *f,
 	return &f->zbd_info->zone_info[zone_idx];
 }
=20
+static inline struct fio_zone_info *
+zbd_get_zone_from_offset(const struct fio_file *f,  uint64_t offset)
+{
+	return zbd_get_zone(f, zbd_zone_idx_from_offset(f, offset));
+}
+
 /**
  * zbd_get_zoned_model - Get a device zoned model
  * @td: FIO thread data
@@ -507,7 +513,6 @@ static bool zbd_verify_file_sizes(struct thread_data =
*td, struct fio_file *f)
 {
 	const struct fio_zone_info *z;
 	uint64_t new_offset, new_end;
-	uint32_t zone_idx;
=20
 	if (!f->zbd_info)
 		return true;
@@ -537,8 +542,7 @@ static bool zbd_verify_file_sizes(struct thread_data =
*td, struct fio_file *f)
 		return false;
 	}
=20
-	zone_idx =3D zbd_zone_idx_from_offset(f, f->file_offset);
-	z =3D zbd_get_zone(f, zone_idx);
+	z =3D zbd_get_zone_from_offset(f, f->file_offset);
 	if ((f->file_offset !=3D z->start) &&
 	    (td->o.td_ddir !=3D TD_DDIR_READ)) {
 		new_offset =3D zbd_zone_end(z);
@@ -554,8 +558,7 @@ static bool zbd_verify_file_sizes(struct thread_data =
*td, struct fio_file *f)
 		f->file_offset =3D new_offset;
 	}
=20
-	zone_idx =3D zbd_zone_idx_from_offset(f, f->file_offset + f->io_size);
-	z =3D zbd_get_zone(f, zone_idx);
+	z =3D zbd_get_zone_from_offset(f, f->file_offset + f->io_size);
 	new_end =3D z->start;
 	if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
 	    (f->file_offset + f->io_size !=3D new_end)) {
@@ -1592,15 +1595,11 @@ static void zbd_queue_io(struct thread_data *td, =
struct io_u *io_u, int q,
 	const struct fio_file *f =3D io_u->file;
 	struct zoned_block_device_info *zbd_info =3D f->zbd_info;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
 	uint64_t zone_end;
=20
 	assert(zbd_info);
=20
-	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
-	assert(zone_idx < zbd_info->nr_zones);
-	z =3D zbd_get_zone(f, zone_idx);
-
+	z =3D zbd_get_zone_from_offset(f, io_u->offset);
 	assert(z->has_wp);
=20
 	if (!success)
@@ -1608,7 +1607,7 @@ static void zbd_queue_io(struct thread_data *td, st=
ruct io_u *io_u, int q,
=20
 	dprint(FD_ZBD,
 	       "%s: queued I/O (%lld, %llu) for zone %u\n",
-	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+	       f->file_name, io_u->offset, io_u->buflen, zbd_zone_idx(f, z));
=20
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
@@ -1651,19 +1650,15 @@ static void zbd_put_io(struct thread_data *td, co=
nst struct io_u *io_u)
 	const struct fio_file *f =3D io_u->file;
 	struct zoned_block_device_info *zbd_info =3D f->zbd_info;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
=20
 	assert(zbd_info);
=20
-	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
-	assert(zone_idx < zbd_info->nr_zones);
-	z =3D zbd_get_zone(f, zone_idx);
-
+	z =3D zbd_get_zone_from_offset(f, io_u->offset);
 	assert(z->has_wp);
=20
 	dprint(FD_ZBD,
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
-	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+	       f->file_name, io_u->offset, io_u->buflen, zbd_zone_idx(f, z));
=20
 	zbd_end_zone_io(td, io_u, z);
=20
@@ -1705,14 +1700,12 @@ void setup_zbd_zone_mode(struct thread_data *td, =
struct io_u *io_u)
 	struct fio_file *f =3D io_u->file;
 	enum fio_ddir ddir =3D io_u->ddir;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
=20
 	assert(td->o.zone_mode =3D=3D ZONE_MODE_ZBD);
 	assert(td->o.zone_size);
 	assert(f->zbd_info);
=20
-	zone_idx =3D zbd_zone_idx_from_offset(f, f->last_pos[ddir]);
-	z =3D zbd_get_zone(f, zone_idx);
+	z =3D zbd_get_zone_from_offset(f, f->last_pos[ddir]);
=20
 	/*
 	 * When the zone capacity is smaller than the zone size and the I/O is
@@ -1726,7 +1719,7 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)
 		       "%s: Jump from zone capacity limit to zone end:"
 		       " (%"PRIu64" -> %"PRIu64") for zone %u (%"PRIu64")\n",
 		       f->file_name, f->last_pos[ddir],
-		       zbd_zone_end(z), zone_idx, z->capacity);
+		       zbd_zone_end(z), zbd_zone_idx(f, z), z->capacity);
 		td->io_skip_bytes +=3D zbd_zone_end(z) - f->last_pos[ddir];
 		f->last_pos[ddir] =3D zbd_zone_end(z);
 	}
@@ -1807,7 +1800,6 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 {
 	struct fio_file *f =3D io_u->file;
 	struct zoned_block_device_info *zbdi =3D f->zbd_info;
-	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len =3D io_u->buflen;
 	uint64_t min_bs =3D td->o.min_bs[io_u->ddir];
@@ -1819,8 +1811,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
=20
-	zone_idx_b =3D zbd_zone_idx_from_offset(f, io_u->offset);
-	zb =3D zbd_get_zone(f, zone_idx_b);
+	zb =3D zbd_get_zone_from_offset(f, io_u->offset);
 	orig_zb =3D zb;
=20
 	if (!zb->has_wp) {
@@ -2099,12 +2090,9 @@ int zbd_do_io_u_trim(const struct thread_data *td,=
 struct io_u *io_u)
 {
 	struct fio_file *f =3D io_u->file;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
 	int ret;
=20
-	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
-	z =3D zbd_get_zone(f, zone_idx);
-
+	z =3D zbd_get_zone_from_offset(f, io_u->offset);
 	if (!z->has_wp)
 		return 0;
=20
--=20
2.31.1

