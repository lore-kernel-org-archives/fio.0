Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08092C4332F
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhLJCTV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:21 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33935 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbhLJCTU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102547; x=1670638547;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=UB+ygvyrCNhagD3mansoTuLOMpw6QjjHJU0Lzxhrco8=;
  b=ZWfaX+eFI8BAlTB7XBBwu3sWdALafwZvOuujnrZERV8JLODvX1Wz3qjW
   vFMaBwkPioc5LcN0e0su3VoqUeJeTQWyc4EPlhr/qUehhUTJyw/rJXd83
   YjFbX7ENkxBATxecYL7o4IS4chqMBpc5H80f46csgCpdaa5WG4JbxpB1B
   TXk0aloUuooWuMYSeOzyI4B4f6PezVKeUsKCDCvzbPkvkzj+8ti42lcaq
   Hvkcsyusjoe0dw6DgY2lMHUND4zrm+1WbI/60jPOPDN2eWuXxqLKqdM4V
   NpnqFfgr4/AB31V+8s2OlgxvxU8p8apiJPjpTogqjxFrefKzBezlD33Ig
   A==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907578"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:46 +0800
IronPort-SDR: 0Gdm5wMcZ8d1q037CCXqi2/4whPYL4huAe3l7XDpYuDlNd9QAuwbQd4Z2u8B5w9+FpUPMf9ski
 5VWxWWDihCrGusIW5HquCdpExQBOPCnDfja4NbRZxDfcCH2YvF2fOcwsaA3xn5DWof7sxQbOqp
 yAEQuik9VOUQr5czcYylpCbn0v9bj5aCq4Qo6/zfLPwWrnf4ZS6bL2A7c10mUxWlhaWtq9sJ0v
 Q2GlppP2j1mwluCCaUtPM3Gd6LqndM5wGGVEA++LU+j7bbOQVH9aIgUPlUTBZC8USXDC+HVbgu
 UyE2YmtCuXaF574yfrEkJsmL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:18 -0800
IronPort-SDR: k7c1hMeLmmvMP+rVoq3qE1BC91SpkZ/T5SjFtRCbzWt2qoScXuBQuDQck10QPHq+t4aXlVXzjx
 YMck62BKdezxxJNbf2dY1MaJwgHbZ2wOWg8XnDIxnI11MQkL0TSJpN9roASIPKeCrDt+AOFSgU
 TpMiaR2CwD6W3z/THSAczqMDCKhGA1+nZK4Q+pZiSq/1bFxAQFX0EjVRyvrLxU3DWn8XmlKT2F
 0jplbDg6H1TqvYvZTwW+xs7KwtlpqxdmDpsYizcz2opbZIH/0QD6W6i4Glz4sHthSfgCw+NrEZ
 9Tg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:46 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dyp1Xc6z1Rvlf
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102545; x=1641694546; bh=UB+ygvyrCNhagD3man
        soTuLOMpw6QjjHJU0Lzxhrco8=; b=FzKKB+xKfD4UGUgLJFNrtoyzNeWAeDmaGg
        oQoZWNYLe7ev4mlUB2BTIhFbx4wOhJgp6AcHSXMLJin0G9eBiMp9m4SLQb3ZUzHq
        e8GpA6MAYsC9WIZ1XlQVNUO2jpbXrGfgRCDP/5ePCe7TnikFFuACCI7VCBoggTXf
        Hz0jZMaCuRvIRDTECF2tEP7MpJ10zLhdGZiNw7aslN8Y8cNySfVVhxUDtNEz4YLa
        ip4TVCXNqrSINR8gOeD49TukWsD29ishDeAiVRCnmswetVuv54x3d5FoXq0oV91Q
        FEspZqRa72SLoi+45JtzVXz9jJjHWI97eqbvDvswD/QkzCOZfk6Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id u3woE8UIA1JK for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:45 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dyn0YJjz1RvTh;
        Thu,  9 Dec 2021 18:15:44 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/11] zbd: move and cleanup code
Date:   Fri, 10 Dec 2021 11:15:33 +0900
Message-Id: <20211210021541.317315-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Move zone manipulation helper functions at the beginning of the zbd.c
file to avoid forward declarations and to group these functions
together apart from the IO manipulation functions.
Also fix function comments.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 582 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 301 insertions(+), 281 deletions(-)

diff --git a/zbd.c b/zbd.c
index 44e77227..20d53b15 100644
--- a/zbd.c
+++ b/zbd.c
@@ -22,6 +22,112 @@
 #include "pshared.h"
 #include "zbd.h"
=20
+static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
+{
+	return (uint64_t)(offset - f->file_offset) < f->io_size;
+}
+
+static inline unsigned int zbd_zone_nr(const struct fio_file *f,
+				       struct fio_zone_info *zone)
+{
+	return zone - f->zbd_info->zone_info;
+}
+
+/**
+ * zbd_zone_idx - convert an offset into a zone number
+ * @f: file pointer.
+ * @offset: offset in bytes. If this offset is in the first zone_size by=
tes
+ *	    past the disk size then the index of the sentinel is returned.
+ */
+static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
+{
+	uint32_t zone_idx;
+
+	if (f->zbd_info->zone_size_log2 > 0)
+		zone_idx =3D offset >> f->zbd_info->zone_size_log2;
+	else
+		zone_idx =3D offset / f->zbd_info->zone_size;
+
+	return min(zone_idx, f->zbd_info->nr_zones);
+}
+
+/**
+ * zbd_zone_end - Return zone end location
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_end(const struct fio_zone_info *z)
+{
+	return (z+1)->start;
+}
+
+/**
+ * zbd_zone_capacity_end - Return zone capacity limit end location
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info =
*z)
+{
+	return z->start + z->capacity;
+}
+
+/**
+ * zbd_zone_full - verify whether a minimum number of bytes remain in a =
zone
+ * @f: file pointer.
+ * @z: zone info pointer.
+ * @required: minimum number of bytes that must remain in a zone.
+ *
+ * The caller must hold z->mutex.
+ */
+static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info=
 *z,
+			  uint64_t required)
+{
+	assert((required & 511) =3D=3D 0);
+
+	return z->has_wp &&
+		z->wp + required > zbd_zone_capacity_end(z);
+}
+
+static void zone_lock(struct thread_data *td, const struct fio_file *f,
+		      struct fio_zone_info *z)
+{
+	struct zoned_block_device_info *zbd =3D f->zbd_info;
+	uint32_t nz =3D z - zbd->zone_info;
+
+	/* A thread should never lock zones outside its working area. */
+	assert(f->min_zone <=3D nz && nz < f->max_zone);
+
+	assert(z->has_wp);
+
+	/*
+	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
+	 * is changed or when io_u completes and zbd_put_io() executed.
+	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
+	 * other waiting for zone locks when building an io_u batch, first
+	 * only trylock the zone. If the zone is already locked by another job,
+	 * process the currently queued I/Os so that I/O progress is made and
+	 * zones unlocked.
+	 */
+	if (pthread_mutex_trylock(&z->mutex) !=3D 0) {
+		if (!td_ioengine_flagged(td, FIO_SYNCIO))
+			io_u_quiesce(td);
+		pthread_mutex_lock(&z->mutex);
+	}
+}
+
+static inline void zone_unlock(struct fio_zone_info *z)
+{
+	int ret;
+
+	assert(z->has_wp);
+	ret =3D pthread_mutex_unlock(&z->mutex);
+	assert(!ret);
+}
+
+static inline struct fio_zone_info *get_zone(const struct fio_file *f,
+					     unsigned int zone_nr)
+{
+	return &f->zbd_info->zone_info[zone_nr];
+}
+
 /**
  * zbd_get_zoned_model - Get a device zoned model
  * @td: FIO thread data
@@ -123,6 +229,126 @@ static int zbd_reset_wp(struct thread_data *td, str=
uct fio_file *f,
 	return ret;
 }
=20
+/**
+ * zbd_reset_zone - reset the write pointer of a single zone
+ * @td: FIO thread data.
+ * @f: FIO file associated with the disk for which to reset a write poin=
ter.
+ * @z: Zone to reset.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ *
+ * The caller must hold z->mutex.
+ */
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			  struct fio_zone_info *z)
+{
+	uint64_t offset =3D z->start;
+	uint64_t length =3D (z+1)->start - offset;
+	uint64_t data_in_zone =3D z->wp - z->start;
+	int ret =3D 0;
+
+	if (!data_in_zone)
+		return 0;
+
+	assert(is_valid_offset(f, offset + length - 1));
+
+	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
+		zbd_zone_nr(f, z));
+	switch (f->zbd_info->model) {
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		ret =3D zbd_reset_wp(td, f, offset, length);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		break;
+	}
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	f->zbd_info->sectors_with_data -=3D data_in_zone;
+	f->zbd_info->wp_sectors_with_data -=3D data_in_zone;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	z->wp =3D z->start;
+	z->verify_block =3D 0;
+
+	td->ts.nr_zone_resets++;
+
+	return ret;
+}
+
+/**
+ * zbd_close_zone - Remove a zone from the open zones array.
+ * @td: FIO thread data.
+ * @f: FIO file associated with the disk for which to reset a write poin=
ter.
+ * @zone_idx: Index of the zone to remove.
+ *
+ * The caller must hold f->zbd_info->mutex.
+ */
+static void zbd_close_zone(struct thread_data *td, const struct fio_file=
 *f,
+			   unsigned int zone_idx)
+{
+	uint32_t open_zone_idx =3D 0;
+
+	for (; open_zone_idx < f->zbd_info->num_open_zones; open_zone_idx++) {
+		if (f->zbd_info->open_zones[open_zone_idx] =3D=3D zone_idx)
+			break;
+	}
+	if (open_zone_idx =3D=3D f->zbd_info->num_open_zones)
+		return;
+
+	dprint(FD_ZBD, "%s: closing zone %d\n", f->file_name, zone_idx);
+	memmove(f->zbd_info->open_zones + open_zone_idx,
+		f->zbd_info->open_zones + open_zone_idx + 1,
+		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
+		sizeof(f->zbd_info->open_zones[0]));
+	f->zbd_info->num_open_zones--;
+	td->num_open_zones--;
+	get_zone(f, zone_idx)->open =3D 0;
+}
+
+/**
+ * zbd_reset_zones - Reset a range of zones.
+ * @td: fio thread data.
+ * @f: fio file for which to reset zones
+ * @zb: first zone to reset.
+ * @ze: first zone not to reset.
+ *
+ * Returns 0 upon success and 1 upon failure.
+ */
+static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
+			   struct fio_zone_info *const zb,
+			   struct fio_zone_info *const ze)
+{
+	struct fio_zone_info *z;
+	const uint64_t min_bs =3D td->o.min_bs[DDIR_WRITE];
+	int res =3D 0;
+
+	assert(min_bs);
+
+	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
+		zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
+	for (z =3D zb; z < ze; z++) {
+		uint32_t nz =3D zbd_zone_nr(f, z);
+
+		if (!z->has_wp)
+			continue;
+		zone_lock(td, f, z);
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		zbd_close_zone(td, f, nz);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		if (z->wp !=3D z->start) {
+			dprint(FD_ZBD, "%s: resetting zone %u\n",
+			       f->file_name, zbd_zone_nr(f, z));
+			if (zbd_reset_zone(td, f, z) < 0)
+				res =3D 1;
+		}
+		zone_unlock(z);
+	}
+
+	return res;
+}
+
 /**
  * zbd_get_max_open_zones - Get the maximum number of open zones
  * @td: FIO thread data
@@ -152,103 +378,99 @@ static int zbd_get_max_open_zones(struct thread_da=
ta *td, struct fio_file *f,
 }
=20
 /**
- * zbd_zone_idx - convert an offset into a zone number
- * @f: file pointer.
- * @offset: offset in bytes. If this offset is in the first zone_size by=
tes
- *	    past the disk size then the index of the sentinel is returned.
+ * is_zone_open - Test if a zone is already in the array of open zones.
+ * @td: fio thread data.
+ * @f: fio file for which to test zones.
+ * @zone_idx: Index of the zone to check.
+ *
+ * The caller must hold f->zbd_info->mutex.
  */
-static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
+static bool is_zone_open(const struct thread_data *td, const struct fio_=
file *f,
+			 unsigned int zone_idx)
 {
-	uint32_t zone_idx;
-
-	if (f->zbd_info->zone_size_log2 > 0)
-		zone_idx =3D offset >> f->zbd_info->zone_size_log2;
-	else
-		zone_idx =3D offset / f->zbd_info->zone_size;
+	struct zoned_block_device_info *zbdi =3D f->zbd_info;
+	int i;
=20
-	return min(zone_idx, f->zbd_info->nr_zones);
-}
+	/*
+	 * This function should never be called when zbdi->max_open_zones =3D=3D=
 0.
+	 */
+	assert(zbdi->max_open_zones);
+	assert(td->o.job_max_open_zones =3D=3D 0 ||
+	       td->num_open_zones <=3D td->o.job_max_open_zones);
+	assert(td->o.job_max_open_zones <=3D zbdi->max_open_zones);
+	assert(zbdi->num_open_zones <=3D zbdi->max_open_zones);
=20
-/**
- * zbd_zone_end - Return zone end location
- * @z: zone info pointer.
- */
-static inline uint64_t zbd_zone_end(const struct fio_zone_info *z)
-{
-	return (z+1)->start;
-}
+	for (i =3D 0; i < zbdi->num_open_zones; i++)
+		if (zbdi->open_zones[i] =3D=3D zone_idx)
+			return true;
=20
-/**
- * zbd_zone_capacity_end - Return zone capacity limit end location
- * @z: zone info pointer.
- */
-static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info =
*z)
-{
-	return z->start + z->capacity;
+	return false;
 }
=20
 /**
- * zbd_zone_full - verify whether a minimum number of bytes remain in a =
zone
- * @f: file pointer.
- * @z: zone info pointer.
- * @required: minimum number of bytes that must remain in a zone.
+ * zbd_open_zone - Add a zone to the array of open zones.
+ * @td: fio thread data.
+ * @f: fio file that has the open zones to add.
+ * @zone_idx: Index of the zone to add.
  *
- * The caller must hold z->mutex.
+ * Open a ZBD zone if it is not already open. Returns true if either the=
 zone
+ * was already open or if the zone was successfully added to the array o=
f open
+ * zones without exceeding the maximum number of open zones. Returns fal=
se if
+ * the zone was not already open and opening the zone would cause the zo=
ne limit
+ * to be exceeded.
  */
-static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info=
 *z,
-			  uint64_t required)
-{
-	assert((required & 511) =3D=3D 0);
-
-	return z->has_wp &&
-		z->wp + required > zbd_zone_capacity_end(z);
-}
-
-static void zone_lock(struct thread_data *td, const struct fio_file *f,
-		      struct fio_zone_info *z)
+static bool zbd_open_zone(struct thread_data *td, const struct fio_file =
*f,
+			  uint32_t zone_idx)
 {
-	struct zoned_block_device_info *zbd =3D f->zbd_info;
-	uint32_t nz =3D z - zbd->zone_info;
-
-	/* A thread should never lock zones outside its working area. */
-	assert(f->min_zone <=3D nz && nz < f->max_zone);
+	const uint64_t min_bs =3D td->o.min_bs[DDIR_WRITE];
+	struct zoned_block_device_info *zbdi =3D f->zbd_info;
+	struct fio_zone_info *z =3D get_zone(f, zone_idx);
+	bool res =3D true;
=20
-	assert(z->has_wp);
+	if (z->cond =3D=3D ZBD_ZONE_COND_OFFLINE)
+		return false;
=20
 	/*
-	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
-	 * is changed or when io_u completes and zbd_put_io() executed.
-	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
-	 * other waiting for zone locks when building an io_u batch, first
-	 * only trylock the zone. If the zone is already locked by another job,
-	 * process the currently queued I/Os so that I/O progress is made and
-	 * zones unlocked.
+	 * Skip full zones with data verification enabled because resetting a
+	 * zone causes data loss and hence causes verification to fail.
 	 */
-	if (pthread_mutex_trylock(&z->mutex) !=3D 0) {
-		if (!td_ioengine_flagged(td, FIO_SYNCIO))
-			io_u_quiesce(td);
-		pthread_mutex_lock(&z->mutex);
-	}
-}
-
-static inline void zone_unlock(struct fio_zone_info *z)
-{
-	int ret;
+	if (td->o.verify !=3D VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+		return false;
=20
-	assert(z->has_wp);
-	ret =3D pthread_mutex_unlock(&z->mutex);
-	assert(!ret);
-}
+	/*
+	 * zbdi->max_open_zones =3D=3D 0 means that there is no limit on the ma=
ximum
+	 * number of open zones. In this case, do no track open zones in
+	 * zbdi->open_zones array.
+	 */
+	if (!zbdi->max_open_zones)
+		return true;
=20
-static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
-{
-	return (uint64_t)(offset - f->file_offset) < f->io_size;
-}
+	pthread_mutex_lock(&zbdi->mutex);
+	if (is_zone_open(td, f, zone_idx)) {
+		/*
+		 * If the zone is already open and going to be full by writes
+		 * in-flight, handle it as a full zone instead of an open zone.
+		 */
+		if (z->wp >=3D zbd_zone_capacity_end(z))
+			res =3D false;
+		goto out;
+	}
+	res =3D false;
+	/* Zero means no limit */
+	if (td->o.job_max_open_zones > 0 &&
+	    td->num_open_zones >=3D td->o.job_max_open_zones)
+		goto out;
+	if (zbdi->num_open_zones >=3D zbdi->max_open_zones)
+		goto out;
+	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
+	zbdi->open_zones[zbdi->num_open_zones++] =3D zone_idx;
+	td->num_open_zones++;
+	z->open =3D 1;
+	res =3D true;
=20
-static inline struct fio_zone_info *get_zone(const struct fio_file *f,
-					     unsigned int zone_nr)
-{
-	return &f->zbd_info->zone_info[zone_nr];
+out:
+	pthread_mutex_unlock(&zbdi->mutex);
+	return res;
 }
=20
 /* Verify whether direct I/O is used for all host-managed zoned drives. =
*/
@@ -751,11 +973,6 @@ static int zbd_init_zone_info(struct thread_data *td=
, struct fio_file *file)
 	return ret;
 }
=20
-static bool zbd_open_zone(struct thread_data *td, const struct fio_file =
*f,
-			  uint32_t zone_idx);
-static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
-			  struct fio_zone_info *z);
-
 int zbd_init_files(struct thread_data *td)
 {
 	struct fio_file *f;
@@ -879,123 +1096,6 @@ int zbd_setup_files(struct thread_data *td)
 	return 0;
 }
=20
-static inline unsigned int zbd_zone_nr(const struct fio_file *f,
-				       struct fio_zone_info *zone)
-{
-	return zone - f->zbd_info->zone_info;
-}
-
-/**
- * zbd_reset_zone - reset the write pointer of a single zone
- * @td: FIO thread data.
- * @f: FIO file associated with the disk for which to reset a write poin=
ter.
- * @z: Zone to reset.
- *
- * Returns 0 upon success and a negative error code upon failure.
- *
- * The caller must hold z->mutex.
- */
-static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
-			  struct fio_zone_info *z)
-{
-	uint64_t offset =3D z->start;
-	uint64_t length =3D (z+1)->start - offset;
-	uint64_t data_in_zone =3D z->wp - z->start;
-	int ret =3D 0;
-
-	if (!data_in_zone)
-		return 0;
-
-	assert(is_valid_offset(f, offset + length - 1));
-
-	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
-		zbd_zone_nr(f, z));
-	switch (f->zbd_info->model) {
-	case ZBD_HOST_AWARE:
-	case ZBD_HOST_MANAGED:
-		ret =3D zbd_reset_wp(td, f, offset, length);
-		if (ret < 0)
-			return ret;
-		break;
-	default:
-		break;
-	}
-
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data -=3D data_in_zone;
-	f->zbd_info->wp_sectors_with_data -=3D data_in_zone;
-	pthread_mutex_unlock(&f->zbd_info->mutex);
-	z->wp =3D z->start;
-	z->verify_block =3D 0;
-
-	td->ts.nr_zone_resets++;
-
-	return ret;
-}
-
-/* The caller must hold f->zbd_info->mutex */
-static void zbd_close_zone(struct thread_data *td, const struct fio_file=
 *f,
-			   unsigned int zone_idx)
-{
-	uint32_t open_zone_idx =3D 0;
-
-	for (; open_zone_idx < f->zbd_info->num_open_zones; open_zone_idx++) {
-		if (f->zbd_info->open_zones[open_zone_idx] =3D=3D zone_idx)
-			break;
-	}
-	if (open_zone_idx =3D=3D f->zbd_info->num_open_zones)
-		return;
-
-	dprint(FD_ZBD, "%s: closing zone %d\n", f->file_name, zone_idx);
-	memmove(f->zbd_info->open_zones + open_zone_idx,
-		f->zbd_info->open_zones + open_zone_idx + 1,
-		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
-		sizeof(f->zbd_info->open_zones[0]));
-	f->zbd_info->num_open_zones--;
-	td->num_open_zones--;
-	get_zone(f, zone_idx)->open =3D 0;
-}
-
-/*
- * Reset a range of zones. Returns 0 upon success and 1 upon failure.
- * @td: fio thread data.
- * @f: fio file for which to reset zones
- * @zb: first zone to reset.
- * @ze: first zone not to reset.
- */
-static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
-			   struct fio_zone_info *const zb,
-			   struct fio_zone_info *const ze)
-{
-	struct fio_zone_info *z;
-	const uint64_t min_bs =3D td->o.min_bs[DDIR_WRITE];
-	int res =3D 0;
-
-	assert(min_bs);
-
-	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
-		zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
-	for (z =3D zb; z < ze; z++) {
-		uint32_t nz =3D zbd_zone_nr(f, z);
-
-		if (!z->has_wp)
-			continue;
-		zone_lock(td, f, z);
-		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, nz);
-		pthread_mutex_unlock(&f->zbd_info->mutex);
-		if (z->wp !=3D z->start) {
-			dprint(FD_ZBD, "%s: resetting zone %u\n",
-			       f->file_name, zbd_zone_nr(f, z));
-			if (zbd_reset_zone(td, f, z) < 0)
-				res =3D 1;
-		}
-		zone_unlock(z);
-	}
-
-	return res;
-}
-
 /*
  * Reset zbd_info.write_cnt, the counter that counts down towards the ne=
xt
  * zone reset.
@@ -1112,86 +1212,6 @@ void zbd_file_reset(struct thread_data *td, struct=
 fio_file *f)
 	zbd_reset_write_cnt(td, f);
 }
=20
-/* The caller must hold f->zbd_info->mutex. */
-static bool is_zone_open(const struct thread_data *td, const struct fio_=
file *f,
-			 unsigned int zone_idx)
-{
-	struct zoned_block_device_info *zbdi =3D f->zbd_info;
-	int i;
-
-	/* This function should never be called when zbdi->max_open_zones =3D=3D=
 0 */
-	assert(zbdi->max_open_zones);
-	assert(td->o.job_max_open_zones =3D=3D 0 || td->num_open_zones <=3D td-=
>o.job_max_open_zones);
-	assert(td->o.job_max_open_zones <=3D zbdi->max_open_zones);
-	assert(zbdi->num_open_zones <=3D zbdi->max_open_zones);
-
-	for (i =3D 0; i < zbdi->num_open_zones; i++)
-		if (zbdi->open_zones[i] =3D=3D zone_idx)
-			return true;
-
-	return false;
-}
-
-/*
- * Open a ZBD zone if it was not yet open. Returns true if either the zo=
ne was
- * already open or if opening a new zone is allowed. Returns false if th=
e zone
- * was not yet open and opening a new zone would cause the zone limit to=
 be
- * exceeded.
- */
-static bool zbd_open_zone(struct thread_data *td, const struct fio_file =
*f,
-			  uint32_t zone_idx)
-{
-	const uint64_t min_bs =3D td->o.min_bs[DDIR_WRITE];
-	struct zoned_block_device_info *zbdi =3D f->zbd_info;
-	struct fio_zone_info *z =3D get_zone(f, zone_idx);
-	bool res =3D true;
-
-	if (z->cond =3D=3D ZBD_ZONE_COND_OFFLINE)
-		return false;
-
-	/*
-	 * Skip full zones with data verification enabled because resetting a
-	 * zone causes data loss and hence causes verification to fail.
-	 */
-	if (td->o.verify !=3D VERIFY_NONE && zbd_zone_full(f, z, min_bs))
-		return false;
-
-	/*
-	 * zbdi->max_open_zones =3D=3D 0 means that there is no limit on the ma=
ximum
-	 * number of open zones. In this case, do no track open zones in
-	 * zbdi->open_zones array.
-	 */
-	if (!zbdi->max_open_zones)
-		return true;
-
-	pthread_mutex_lock(&zbdi->mutex);
-	if (is_zone_open(td, f, zone_idx)) {
-		/*
-		 * If the zone is already open and going to be full by writes
-		 * in-flight, handle it as a full zone instead of an open zone.
-		 */
-		if (z->wp >=3D zbd_zone_capacity_end(z))
-			res =3D false;
-		goto out;
-	}
-	res =3D false;
-	/* Zero means no limit */
-	if (td->o.job_max_open_zones > 0 &&
-	    td->num_open_zones >=3D td->o.job_max_open_zones)
-		goto out;
-	if (zbdi->num_open_zones >=3D zbdi->max_open_zones)
-		goto out;
-	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
-	zbdi->open_zones[zbdi->num_open_zones++] =3D zone_idx;
-	td->num_open_zones++;
-	z->open =3D 1;
-	res =3D true;
-
-out:
-	pthread_mutex_unlock(&zbdi->mutex);
-	return res;
-}
-
 /* Return random zone index for one of the open zones. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
--=20
2.31.1

