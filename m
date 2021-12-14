Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B1EC433FE
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243272AbhLNBY3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60902 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243342AbhLNBY2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445068; x=1670981068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HASb/hD2Au8IajtKG7e+G0Khp/42N+W5DDZXhdfEL2I=;
  b=Zeuuy76Nue8IslusT3aRZoCN9YIoATx2moNvoem/JbKhvO54fP3jFoTT
   SNvaxzTSbiYIvmq034cmKX0WeGFEj6Yjr7hm1WpnoHN7jkEJ/7iU2S6Yl
   dyyTVCrMWAlMXpdQ652t7YWlzmRinJqmm/0n0sJ82B44dTFpk3TdSfLht
   z1wL1bBmTXC221jWcIRPgc8Ap/YQgOAhhQuUUwoO9rRA9HP633WOJolDE
   AnE/bE8HQJpeygz0Gr72C0ytmDfKvyVQlU8hsmGH9KJGypx4hTi2rAH+n
   op/h6z0I3YVNEQQ5KQinBgBMbSd2t445erfMWR2gkRW3KfDaJtzW/wD/x
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300014511"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:28 +0800
IronPort-SDR: r72fSNJMnfdCHHAEIVX6Od59xpA2aK4k2L3lKcOlZYQFSRfn2cc7MkQDghTfFXJbWcUXkxVylA
 aKgEc+aIJtCx1wTxGIXGBCV6fV8G15DTOBes6MhkZgyz3Z5GhDM5WfLDGHccoXM8qTCKlSuDjK
 tm7kW/exjCf2EbFS3sNWekai8XMNFHM208PCroUahxo9xv3YRm2xImu7VXO56t/pW0A+lc5Ohk
 Qhwoa2nci256GXqIslcbZ+A5Er8AU3FnJZnupMO3ulLN+3qqObjEQSr74JkPTqrN4Sa9bfdFns
 rddhIRXZcoB0HDL3Dt7M6Bh3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:54 -0800
IronPort-SDR: flB2Tp7KnFR2nWAo5lxg6FNf9nNXOmCYhhuzjFR2c6fcnEmhp4+Q6GTnVTkC+HY9v70sxDJYGX
 qPKx6PEoD91xI0zTrODf9jffbf4u2u4CDPd0V/ELLe+UPLGFif5HAK6+DRODUGkEqZxHiPyyLP
 P+875waCMO9xHdKnlC80OhW6KRsNmkTxJbhgPXvCmtj2F0IuK0oPCsFBy0V4vD5tUYeIIwHNyQ
 aKaXGMyzmdRwtOL1GL8B4d+0HusC2VbOKCxA0ErHFhdU5Rl3LhM/SGhJLOzXWK54VNrWykXZ48
 E64=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:28 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdm1wNtz1RwFN
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:28 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445067; x=1642037068; bh=HASb/hD2Au8IajtKG7
        e+G0Khp/42N+W5DDZXhdfEL2I=; b=ewXpyDV48V5MYuRJZToragNOavXKr+GVJf
        OOI11JYZIYOLMusUH/AthKTEwUm3aPJd/Y3CXYarah4a8T1tc/3LuIcV95Dq7y5c
        FXqLo1cGJUkNgTBtWnbItFS45l9E3itpf0+KL1hWBE/vM5KGGKoWP99xNcR0GFLQ
        douMGtJuJmOw3ikmiiA/BSOkpcEEvLilSekBRtumF9MZEIVwSBN+62e4uZftPn7K
        iw4j9RWRLEf9+jEwByQAW9nkh3WN4vVGoWGq0ull5lpV5ZmQlSS8i7u0ZWv3FMk7
        aUBRnvHTBgUnXM9mY16f9DsX6DBVSVUAqL2hUopmtrypxfSyILlg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zVgGid5PI0wu for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:27 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdk5hK2z1Rwnv;
        Mon, 13 Dec 2021 17:24:26 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 11/12] zbd: introduce zbd_offset_to_zone() helper
Date:   Tue, 14 Dec 2021 10:24:12 +0900
Message-Id: <20211214012413.464798-12-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Introduce the helper function zbd_offset_to_zone() to get a zone
structure using a file offset. In many functions, this replaces the
two line code pattern:

	zone_idx =3D zbd_offset_to_zone_idx(f, offset);
	z =3D zbd_get_zone(f, zone_idx);

with a single line of code:

	z =3D zbd_offset_to_zone(f, offset);

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/zbd.c b/zbd.c
index 095a6bad..b1fd6b4b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -129,6 +129,12 @@ static inline struct fio_zone_info *zbd_get_zone(con=
st struct fio_file *f,
 	return &f->zbd_info->zone_info[zone_idx];
 }
=20
+static inline struct fio_zone_info *
+zbd_offset_to_zone(const struct fio_file *f,  uint64_t offset)
+{
+	return zbd_get_zone(f, zbd_offset_to_zone_idx(f, offset));
+}
+
 /**
  * zbd_get_zoned_model - Get a device zoned model
  * @td: FIO thread data
@@ -510,7 +516,6 @@ static bool zbd_zone_align_file_sizes(struct thread_d=
ata *td,
 {
 	const struct fio_zone_info *z;
 	uint64_t new_offset, new_end;
-	uint32_t zone_idx;
=20
 	if (!f->zbd_info)
 		return true;
@@ -540,8 +545,7 @@ static bool zbd_zone_align_file_sizes(struct thread_d=
ata *td,
 		return false;
 	}
=20
-	zone_idx =3D zbd_offset_to_zone_idx(f, f->file_offset);
-	z =3D zbd_get_zone(f, zone_idx);
+	z =3D zbd_offset_to_zone(f, f->file_offset);
 	if ((f->file_offset !=3D z->start) &&
 	    (td->o.td_ddir !=3D TD_DDIR_READ)) {
 		new_offset =3D zbd_zone_end(z);
@@ -557,8 +561,7 @@ static bool zbd_zone_align_file_sizes(struct thread_d=
ata *td,
 		f->file_offset =3D new_offset;
 	}
=20
-	zone_idx =3D zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
-	z =3D zbd_get_zone(f, zone_idx);
+	z =3D zbd_offset_to_zone(f, f->file_offset + f->io_size);
 	new_end =3D z->start;
 	if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
 	    (f->file_offset + f->io_size !=3D new_end)) {
@@ -1595,15 +1598,11 @@ static void zbd_queue_io(struct thread_data *td, =
struct io_u *io_u, int q,
 	const struct fio_file *f =3D io_u->file;
 	struct zoned_block_device_info *zbd_info =3D f->zbd_info;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
 	uint64_t zone_end;
=20
 	assert(zbd_info);
=20
-	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
-	assert(zone_idx < zbd_info->nr_zones);
-	z =3D zbd_get_zone(f, zone_idx);
-
+	z =3D zbd_offset_to_zone(f, io_u->offset);
 	assert(z->has_wp);
=20
 	if (!success)
@@ -1611,7 +1610,7 @@ static void zbd_queue_io(struct thread_data *td, st=
ruct io_u *io_u, int q,
=20
 	dprint(FD_ZBD,
 	       "%s: queued I/O (%lld, %llu) for zone %u\n",
-	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+	       f->file_name, io_u->offset, io_u->buflen, zbd_zone_idx(f, z));
=20
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
@@ -1654,19 +1653,15 @@ static void zbd_put_io(struct thread_data *td, co=
nst struct io_u *io_u)
 	const struct fio_file *f =3D io_u->file;
 	struct zoned_block_device_info *zbd_info =3D f->zbd_info;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
=20
 	assert(zbd_info);
=20
-	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
-	assert(zone_idx < zbd_info->nr_zones);
-	z =3D zbd_get_zone(f, zone_idx);
-
+	z =3D zbd_offset_to_zone(f, io_u->offset);
 	assert(z->has_wp);
=20
 	dprint(FD_ZBD,
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
-	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+	       f->file_name, io_u->offset, io_u->buflen, zbd_zone_idx(f, z));
=20
 	zbd_end_zone_io(td, io_u, z);
=20
@@ -1708,14 +1703,12 @@ void setup_zbd_zone_mode(struct thread_data *td, =
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
-	zone_idx =3D zbd_offset_to_zone_idx(f, f->last_pos[ddir]);
-	z =3D zbd_get_zone(f, zone_idx);
+	z =3D zbd_offset_to_zone(f, f->last_pos[ddir]);
=20
 	/*
 	 * When the zone capacity is smaller than the zone size and the I/O is
@@ -1729,7 +1722,7 @@ void setup_zbd_zone_mode(struct thread_data *td, st=
ruct io_u *io_u)
 		       "%s: Jump from zone capacity limit to zone end:"
 		       " (%"PRIu64" -> %"PRIu64") for zone %u (%"PRIu64")\n",
 		       f->file_name, f->last_pos[ddir],
-		       zbd_zone_end(z), zone_idx, z->capacity);
+		       zbd_zone_end(z), zbd_zone_idx(f, z), z->capacity);
 		td->io_skip_bytes +=3D zbd_zone_end(z) - f->last_pos[ddir];
 		f->last_pos[ddir] =3D zbd_zone_end(z);
 	}
@@ -1810,7 +1803,6 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 {
 	struct fio_file *f =3D io_u->file;
 	struct zoned_block_device_info *zbdi =3D f->zbd_info;
-	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len =3D io_u->buflen;
 	uint64_t min_bs =3D td->o.min_bs[io_u->ddir];
@@ -1822,8 +1814,7 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
=20
-	zone_idx_b =3D zbd_offset_to_zone_idx(f, io_u->offset);
-	zb =3D zbd_get_zone(f, zone_idx_b);
+	zb =3D zbd_offset_to_zone(f, io_u->offset);
 	orig_zb =3D zb;
=20
 	if (!zb->has_wp) {
@@ -2102,12 +2093,9 @@ int zbd_do_io_u_trim(const struct thread_data *td,=
 struct io_u *io_u)
 {
 	struct fio_file *f =3D io_u->file;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
 	int ret;
=20
-	zone_idx =3D zbd_offset_to_zone_idx(f, io_u->offset);
-	z =3D zbd_get_zone(f, zone_idx);
-
+	z =3D zbd_offset_to_zone(f, io_u->offset);
 	if (!z->has_wp)
 		return 0;
=20
--=20
2.31.1

