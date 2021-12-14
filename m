Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004A0C433EF
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243269AbhLNBY2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:28 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60902 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243119AbhLNBY1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445067; x=1670981067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pTHgjAOGlaPiUVJpM8q3RIZQhsgB2cODkJp7bBzgPdg=;
  b=iEKw/urxMispS3V8/g9OmEU0Mo7S8tJYvqALJX6zKO3YXfPFcApfWg3y
   oxTGSNQh4AhcjY6GbRu1srFI8uPwpg9PzC1P1aQ/uNZT8eCc6u8Y/e00I
   T9Xn7wmkdIMLtBywYmdU0NnEh4yKDLRAocW856q7YPHCUrdEbahjrWdKP
   2ode1qGb5NaXfhVM8fy7k9xhhg2fOXZl5HL8vmgpo3BMtR7K9qonWmQ55
   0q5k3r67Y5jSueuWEta4p9MlYrPbuyfVSNMvEM46Acs9Db2XajmFAhXp2
   fPyORC+WIm2QHYj4w1n/gOzoPsHe4SxFkQaoqQTksEGiiImGOE/Wa3AfT
   g==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300014508"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:27 +0800
IronPort-SDR: 9tG+EilG0nS5DT2ySgDmG3rm41XuoeS4GFspMeodWOU2nEHKJxgRIg5CnKI7TNp8XtF9kt6xgN
 QrA2YhdkqivBwnp//Lr+9r0oZcVxySSuwgfWhfr/Vs0LpaoT1XCsrA5jALMYHRGUZuNPJwcRbE
 GQw1sdT0pB5leA1UNnQ86blcRv3ZtpeenW16mfwGsH8T1KKlycbv17qpOMmYzSRkXteFdR07wj
 KvcxemRxVdKpJCXnYsT4nOWGN1DANzB8m+yO7Ow7Fa4PN3/OT7Ykw4ORR7n1KUgXpj56lQHgcV
 066KoNB4+Pnssvy2bpkbwLrr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:53 -0800
IronPort-SDR: uGk/q8S2tPg4mjP7Krj5TZjQUydS9v21R8FMhzu0+/CewiQdoRQJjDhSLrISF2gMNjYKQJxh7H
 4Mxsnktg6gXQQVdd1RVQEUpXgTIUhW0xB79p+WXi7MVvZDZs16yfN8qIPUew0kN+xmjpYi830m
 Iox4kZV/6Cxpgd6EB4I+sk9loWsSGhVEaETXLc6u7i30JqJ1Nb8ridHIjHHaEZ2fF7Z5S/Rs6b
 r+N7Xw2QQppNB3XbWxMoi4MnkUsd/6iL8sPwLWwGE5wBZEyHzjVrAvAA9BOG45WxWpTjNgO+M1
 NDw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:27 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdk6YYtz1Rwnx
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:26 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445066; x=1642037067; bh=pTHgjAOGlaPiUVJpM8
        q3RIZQhsgB2cODkJp7bBzgPdg=; b=jit98j0PJ/46qQqtv6qoIKHKLeZo7AqmPj
        dnQT5WIT50xM/XfZd/Wzj6AYSFfBBh15t0iqVwDmxwJHFN2uBmfVFBC6mr2CMXDx
        wBsBOiJ2KQf6uRnOJetvswT7o8cfBkfXD62sBUeDQO2UTeucp582SgFnC2jDkHIu
        LybBl8sQBpG+L4N8BithhSN13vscLfWSrP/bAWGLkQY8eAY+YZCffMJNAdESLKtW
        sra0T2RS7vcXgwrXAzZtDEQ0EBdWQE8zTfnblLlFSrgj9d0CfTMWCaoQ9XJooC0/
        bdBC2haQNaiEya6+HTlMt9CXdXgZYchx796eqaBYEQrICA4z2ODg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Erp-I8WTWAEl for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:26 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdj5NQJz1RtVG;
        Mon, 13 Dec 2021 17:24:25 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 10/12] zbd: rename get_zone()
Date:   Tue, 14 Dec 2021 10:24:11 +0900
Message-Id: <20211214012413.464798-11-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Rename get_zone() to zbd_get_zone() to be consistent with the naming
pattern of most zbd functions.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/zbd.c b/zbd.c
index 592f7c03..095a6bad 100644
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
 		zbd_offset_to_zone_idx(f, f->file_offset + f->io_size - 1);
 	for (zone_idx =3D zone_idx_b; zone_idx <=3D zone_idx_e; zone_idx++)
-		if (get_zone(f, zone_idx)->has_wp)
+		if (zbd_get_zone(f, zone_idx)->has_wp)
 			return true;
=20
 	return false;
@@ -541,7 +541,7 @@ static bool zbd_zone_align_file_sizes(struct thread_d=
ata *td,
 	}
=20
 	zone_idx =3D zbd_offset_to_zone_idx(f, f->file_offset);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
 	if ((f->file_offset !=3D z->start) &&
 	    (td->o.td_ddir !=3D TD_DDIR_READ)) {
 		new_offset =3D zbd_zone_end(z);
@@ -558,7 +558,7 @@ static bool zbd_zone_align_file_sizes(struct thread_d=
ata *td,
 	}
=20
 	zone_idx =3D zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
 	new_end =3D z->start;
 	if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
 	    (f->file_offset + f->io_size !=3D new_end)) {
@@ -1156,8 +1156,8 @@ static uint64_t zbd_process_swd(struct thread_data =
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
@@ -1209,8 +1209,8 @@ void zbd_file_reset(struct thread_data *td, struct =
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
@@ -1298,7 +1298,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
 	for (;;) {
 		uint32_t tmp_idx;
=20
-		z =3D get_zone(f, zone_idx);
+		z =3D zbd_get_zone(f, zone_idx);
 		if (z->has_wp)
 			zone_lock(td, f, z);
=20
@@ -1404,7 +1404,7 @@ retry:
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
 			zone_idx =3D f->min_zone;
-			z =3D get_zone(f, zone_idx);
+			z =3D zbd_get_zone(f, zone_idx);
 		}
 		assert(is_valid_offset(f, z->start));
 		if (!z->has_wp)
@@ -1427,7 +1427,7 @@ retry:
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
=20
-		z =3D get_zone(f, zone_idx);
+		z =3D zbd_get_zone(f, zone_idx);
=20
 		zone_lock(td, f, z);
 		if (z->wp + min_bs <=3D zbd_zone_capacity_end(z))
@@ -1522,7 +1522,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *=
io_u, uint64_t min_bytes,
 {
 	struct fio_file *f =3D io_u->file;
 	struct fio_zone_info *z1, *z2;
-	const struct fio_zone_info *const zf =3D get_zone(f, f->min_zone);
+	const struct fio_zone_info *const zf =3D zbd_get_zone(f, f->min_zone);
=20
 	/*
 	 * Skip to the next non-empty zone in case of sequential I/O and to
@@ -1602,7 +1602,7 @@ static void zbd_queue_io(struct thread_data *td, st=
ruct io_u *io_u, int q,
=20
 	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
=20
 	assert(z->has_wp);
=20
@@ -1660,7 +1660,7 @@ static void zbd_put_io(struct thread_data *td, cons=
t struct io_u *io_u)
=20
 	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
=20
 	assert(z->has_wp);
=20
@@ -1715,7 +1715,7 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)
 	assert(f->zbd_info);
=20
 	zone_idx =3D zbd_offset_to_zone_idx(f, f->last_pos[ddir]);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
=20
 	/*
 	 * When the zone capacity is smaller than the zone size and the I/O is
@@ -1823,7 +1823,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 	assert(io_u->buflen);
=20
 	zone_idx_b =3D zbd_offset_to_zone_idx(f, io_u->offset);
-	zb =3D get_zone(f, zone_idx_b);
+	zb =3D zbd_get_zone(f, zone_idx_b);
 	orig_zb =3D zb;
=20
 	if (!zb->has_wp) {
@@ -1886,7 +1886,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
 			zone_unlock(zb);
-			zl =3D get_zone(f, f->max_zone);
+			zl =3D zbd_get_zone(f, f->max_zone);
 			zb =3D zbd_find_zone(td, io_u, min_bs, zb, zl);
 			if (!zb) {
 				dprint(FD_ZBD,
@@ -2030,7 +2030,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
=20
 		/* Find out a non-empty zone to trim */
 		zone_unlock(zb);
-		zl =3D get_zone(f, f->max_zone);
+		zl =3D zbd_get_zone(f, f->max_zone);
 		zb =3D zbd_find_zone(td, io_u, 1, zb, zl);
 		if (zb) {
 			io_u->offset =3D zb->start;
@@ -2106,7 +2106,7 @@ int zbd_do_io_u_trim(const struct thread_data *td, =
struct io_u *io_u)
 	int ret;
=20
 	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
-	z =3D get_zone(f, zone_idx);
+	z =3D zbd_get_zone(f, zone_idx);
=20
 	if (!z->has_wp)
 		return 0;
--=20
2.31.1

