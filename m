Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D540BC43217
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbhLJCTb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:31 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33942 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbhLJCT3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102555; x=1670638555;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=0TyvdJFr3LaAYzz4AocKguPvvSJmUGdQPgLjspyQbt0=;
  b=nXoL5AOTGQTNGDypQrJImjsZxlPJ/xbYbzXfMPm/URUoZIlJoAQwiJE5
   WqnyafNlvHTDai+N9USyCeUvfLv3L+pEu/jxSPHZhVHulUznpJF1eovrB
   ACqORjqpYo45bNp+WNbFspsgEcDLNj9A7dCwBh43kleVfSd8gZD3TRade
   eswyPPBngfdx87T7XmS4LicHO5qs+aTYioTctmFl6a/6xL/VgcWHY45iE
   qLCfBE2AwRQYFr0ymM7dxU237Je4kQhyOEMUHBSn2oW536jME+oBXX2is
   WtFYc7S5ChgRl1LAXUaZSlKk7/EcVyNYU/ApLt7UlsUcCEi8gx+2hE24B
   A==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907590"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:52 +0800
IronPort-SDR: mowTMQt131a41uwYw/ZEL5E62TKxI1783lT1/iO6ETy5+2si7pZg+KqgppwYxW922W/HC+TZiM
 oFp7jjpY+2FqhxdgL38i3qgtzNaLzI22uT0nchfxs5lmQqH9HorwauXR6dDCFGiJim3eJr4XKh
 oOkzfUG2/r3nUiZzGn/qOo1aH7aA38qLHkc5BYAMS566O3Tnt36imdRHQGevYgrmtRV5WyMOne
 4K/7+5U8bQ+poAGYl8yTRGhs9WjlCIavPI9fA0Wzu94Vk+08pYjGvMHwJJK6fjbxdtDdeV9yZk
 TQvJHYfnfMT9yfqeJwMUqj+B
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:23 -0800
IronPort-SDR: Ik0HdNK6xQta2bbxXAVY+4iz6x572MVSdh0jTDK45brj0UcFxaLYNKGqLVg4mFJfcNcKH4qB4s
 s64ImqroEmvyJJFVfp88clYOjOHW/VkbetdlUCrqL0gd43eq/EGXKNCeKOnxwLJjLKWZ1qAgkb
 2guA92yvYypOcoPUXAs0bOxoJdXrm8PVNPodOXTY5tieMvnYnY1RwA/ufoOzSODBPg6j+u7lOs
 00TrM/xpsObvYgb7zThKIif9setAv+IkmbQABjkQQEDhmJ3TtP8/jywafpHVQMmX6pvy6jIMke
 ZtE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:51 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dyv2F2Gz1RwFN
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:51 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102550; x=1641694551; bh=0TyvdJFr3LaAYzz4Ao
        cKguPvvSJmUGdQPgLjspyQbt0=; b=Mjq8ABJD5kbVX0ALP+P/o8GLtVk49zUbO5
        jN8dqlUNBtV97ueCwJ7vnGuAMQOQguUCJbT+DUx8AObm/pj/I95rf84ppg7L8Mtp
        7hCB3TS6SOPJ8ci/y2MmB7HLq5i52Y+B2S2/xZIRNBQWlYfunbCQshg6qaAPHn8y
        MybEAoBtS3ACeQdMvu3A95P6jWstB4ejKl1vnayi7cGu3vI74ibK25OVbcI2dh7t
        XwWV5UDd3jpfBjM3pyY83lcKeT3TyPZ2Gi6pWRcFXaJA+6GhmkbUIrD9TMmAsIJG
        ngtCALZgDweS2zbgkL3ooRYwkjG8cygWDsOCDTGXjPuuypKHWXQQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vmLCLQZsfTBv for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:50 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyt3SYXz1RtVG;
        Thu,  9 Dec 2021 18:15:50 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/11] zbd: rename get_zone()
Date:   Fri, 10 Dec 2021 11:15:40 +0900
Message-Id: <20211210021541.317315-11-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Rename get_zone() to zbd_get_zone() to be consistent with the naming
pattern of most zbd functions.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/zbd.c b/zbd.c
index 7204f68f..5c0fe00b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -123,10 +123,10 @@ static inline void zone_unlock(struct fio_zone_info=
 *z)
 	assert(!ret);
 }
=20
-static inline struct fio_zone_info *get_zone(const struct fio_file *f,
-					     unsigned int zone_nr)
+static inline struct fio_zone_info *zbd_get_zone(const struct fio_file *=
f,
+						 unsigned int zone_idx)
 {
-	return &f->zbd_info->zone_info[zone_nr];
+	return &f->zbd_info->zone_info[zone_idx];
 }
=20
 /**
@@ -297,7 +297,7 @@ static void zbd_close_zone(struct thread_data *td, co=
nst struct fio_file *f,
 		return;
=20
 	for (ozi =3D 0; ozi < f->zbd_info->num_open_zones; ozi++) {
-		if (get_zone(f, f->zbd_info->open_zones[ozi]) =3D=3D z)
+		if (zbd_get_zone(f, f->zbd_info->open_zones[ozi]) =3D=3D z)
 			break;
 	}
 	if (ozi =3D=3D f->zbd_info->num_open_zones)
@@ -494,7 +494,7 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	zone_idx_e =3D
 		zbd_zone_idx_from_offset(f, f->file_offset + f->io_size - 1);
 	for (zone_idx =3D zone_idx_b; zone_idx <=3D zone_idx_e; zone_idx++)
-		if (get_zone(f, zone_idx)->has_wp)
+		if (zbd_get_zone(f, zone_idx)->has_wp)
 			return true;
=20
 	return false;
@@ -538,7 +538,7 @@ static bool zbd_verify_file_sizes(struct thread_data =
*td, struct fio_file *f)
 	}
=20
 	zone_idx =3D zbd_zone_idx_from_offset(f, f->file_offset);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
 	if ((f->file_offset !=3D z->start) &&
 	    (td->o.td_ddir !=3D TD_DDIR_READ)) {
 		new_offset =3D zbd_zone_end(z);
@@ -555,7 +555,7 @@ static bool zbd_verify_file_sizes(struct thread_data =
*td, struct fio_file *f)
 	}
=20
 	zone_idx =3D zbd_zone_idx_from_offset(f, f->file_offset + f->io_size);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
 	new_end =3D z->start;
 	if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
 	    (f->file_offset + f->io_size !=3D new_end)) {
@@ -1153,8 +1153,8 @@ static uint64_t zbd_process_swd(struct thread_data =
*td,
 	uint64_t swd =3D 0;
 	uint64_t wp_swd =3D 0;
=20
-	zb =3D get_zone(f, f->min_zone);
-	ze =3D get_zone(f, f->max_zone);
+	zb =3D zbd_get_zone(f, f->min_zone);
+	ze =3D zbd_get_zone(f, f->max_zone);
 	for (z =3D zb; z < ze; z++) {
 		if (z->has_wp) {
 			zone_lock(td, f, z);
@@ -1206,8 +1206,8 @@ void zbd_file_reset(struct thread_data *td, struct =
fio_file *f)
 	if (!f->zbd_info || !td_write(td))
 		return;
=20
-	zb =3D get_zone(f, f->min_zone);
-	ze =3D get_zone(f, f->max_zone);
+	zb =3D zbd_get_zone(f, f->min_zone);
+	ze =3D zbd_get_zone(f, f->max_zone);
 	swd =3D zbd_process_swd(td, f, SET_SWD);
=20
 	dprint(FD_ZBD, "%s(%s): swd =3D %" PRIu64 "\n",
@@ -1295,7 +1295,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
 	for (;;) {
 		uint32_t tmp_idx;
=20
-		z =3D get_zone(f, zone_idx);
+		z =3D zbd_get_zone(f, zone_idx);
 		if (z->has_wp)
 			zone_lock(td, f, z);
=20
@@ -1401,7 +1401,7 @@ retry:
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
 			zone_idx =3D f->min_zone;
-			z =3D get_zone(f, zone_idx);
+			z =3D zbd_get_zone(f, zone_idx);
 		}
 		assert(is_valid_offset(f, z->start));
 		if (!z->has_wp)
@@ -1424,7 +1424,7 @@ retry:
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
=20
-		z =3D get_zone(f, zone_idx);
+		z =3D zbd_get_zone(f, zone_idx);
=20
 		zone_lock(td, f, z);
 		if (z->wp + min_bs <=3D zbd_zone_capacity_end(z))
@@ -1519,7 +1519,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *=
io_u, uint64_t min_bytes,
 {
 	struct fio_file *f =3D io_u->file;
 	struct fio_zone_info *z1, *z2;
-	const struct fio_zone_info *const zf =3D get_zone(f, f->min_zone);
+	const struct fio_zone_info *const zf =3D zbd_get_zone(f, f->min_zone);
=20
 	/*
 	 * Skip to the next non-empty zone in case of sequential I/O and to
@@ -1599,7 +1599,7 @@ static void zbd_queue_io(struct thread_data *td, st=
ruct io_u *io_u, int q,
=20
 	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
=20
 	assert(z->has_wp);
=20
@@ -1657,7 +1657,7 @@ static void zbd_put_io(struct thread_data *td, cons=
t struct io_u *io_u)
=20
 	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
=20
 	assert(z->has_wp);
=20
@@ -1712,7 +1712,7 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)
 	assert(f->zbd_info);
=20
 	zone_idx =3D zbd_zone_idx_from_offset(f, f->last_pos[ddir]);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
=20
 	/*
 	 * When the zone capacity is smaller than the zone size and the I/O is
@@ -1820,7 +1820,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 	assert(io_u->buflen);
=20
 	zone_idx_b =3D zbd_zone_idx_from_offset(f, io_u->offset);
-	zb =3D get_zone(f, zone_idx_b);
+	zb =3D zbd_get_zone(f, zone_idx_b);
 	orig_zb =3D zb;
=20
 	if (!zb->has_wp) {
@@ -1883,7 +1883,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
 			zone_unlock(zb);
-			zl =3D get_zone(f, f->max_zone);
+			zl =3D zbd_get_zone(f, f->max_zone);
 			zb =3D zbd_find_zone(td, io_u, min_bs, zb, zl);
 			if (!zb) {
 				dprint(FD_ZBD,
@@ -2027,7 +2027,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
=20
 		/* Find out a non-empty zone to trim */
 		zone_unlock(zb);
-		zl =3D get_zone(f, f->max_zone);
+		zl =3D zbd_get_zone(f, f->max_zone);
 		zb =3D zbd_find_zone(td, io_u, 1, zb, zl);
 		if (zb) {
 			io_u->offset =3D zb->start;
@@ -2103,7 +2103,7 @@ int zbd_do_io_u_trim(const struct thread_data *td, =
struct io_u *io_u)
 	int ret;
=20
 	zone_idx =3D zbd_zone_idx_from_offset(f, io_u->offset);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
=20
 	if (!z->has_wp)
 		return 0;
--=20
2.31.1

