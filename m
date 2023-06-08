Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C18EC8300C
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 07:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbjFHHGW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 03:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbjFHHGU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 03:06:20 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C027D1FDA
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 00:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686207976; x=1717743976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6f9nhIiNjbwXfBfWsBnmF6FHNar5jD8MlBl1vvXndkQ=;
  b=NB0o9PUkDGcZTiRHUgR+0dnnnr14pY0I/mIPiKX5L6wqrgpMfp20L/Mu
   u8Ww4TN9LrsqUd7H3etRvEf/U93Npb9r1g9O5YUbDHUJ/eDWlpHFvIwlE
   ldgMpThDIRUgmt1xZDfWUTjgQd8AYTIqnCzaSz7xD/zLfiVjFaZCZwAwc
   9f2aDJQZQNEWF3PTbxy5xn2WuZ2WwfQ4D8PrJbglfFRG4pGVeHsMD5b8Y
   eYtHZ3Gt/YQnBvibTsLKUmVrA6Ui3wDHmpXhzuNCud59dZD6pMuq8ur1K
   Fu3RvESj+Xqpoq5vbInZeurBahVcjTnxi1Igr4BFIhP+lMM0dgIE/l8mO
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="237987005"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 15:06:15 +0800
IronPort-SDR: jF6FlGg5t55wHXj9cFYP2dSAWUb087XvE0+ab/s9nFeQTqbmjM7ahrIzLwhsH9k/v6thkasIyJ
 DwNUhWln5XCl4nt5iYQQ/iupqP2siWOXDxbNDWCJjHkac5NisoU/oeTghvvJAVD7xPpiEbwRbr
 LGzlJIEzW2YhjgD2hgugDqP4289Dt6Mchn5q7h8SZK0hBswPG9uW7J/kcBF+wF+Xvr9k5KwULE
 bo7fPfBjXpCZQZ/x8hjVo2RRWPju+BI2TBjpxWQQLh/ekHpH3h9ySLLLzuj52GMYXzgqGvsxKn
 htI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 23:20:57 -0700
IronPort-SDR: BQcAE0uAGuOhbje4juGX7Vzt/Fszc/rsgdmZ0geRJGyA0l0Wgdju6HGKYUQIiOx4JYDRP4eg8m
 YMy+ykb+NNCPHNA6wsTBRAqv9tdQkGPhRzHm8j2tQ2xf8fxnC5Xbpd0UFH2gUEs0G+uRmDAw7w
 79TTfEjnKizl/4+VYYGWcP818BSCWu/LhE4twOCjesl9JfexzxMROmAD3HDyWrN8wDpj35rLXg
 qD6mAr7GDtrDsJCkvCnVm5XQdouSDXepp04sW2OdVbC9Bwg6TKd0Ltuff7eoMLINTvdw05eE73
 k/M=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jun 2023 00:06:11 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/7] zbd: rename 'open zones' to 'write zones'
Date:   Thu,  8 Jun 2023 16:06:02 +0900
Message-Id: <20230608070608.1256970-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Current fio code for zonemode=zbd uses the word 'open zone' to mean the
zones that fio jobs write to. Before fio starts writing to a zone, it
calls zbd_open_zone(). When fio completes writing to a zone, it calls
zbd_close_zone(). This wording is good for zoned block devices with
max_open_zones limit, such as ZBC and ZAC devices. The devices use same
word 'open' to express the zone condition that the devices assign
resources for data write to zones. However, the word 'open' gets
confusing to support zoned block devices which has max_active_zones
limit, such as ZNS devices. These devices have both 'open' and 'active'
keywords to mean two different kinds of resources on the device. This
'active' status does not fit with the 'open zone' wording in the fio
code. Also, the word 'open' zone in fio code does not always match with
the 'open' condition of zones on the device (e.g. when
--ignore_zone_limits option is specified).

To avoid the confusion, stop using the word 'open zone' in the fio code.
Instead, use the word 'write zone' to mean that the zone is the write
target. When fio starts a write to a zone, it adds the zone to
write_zones array. When fio completes writing to a zone, it removes the
zone from the write_zones array. For this purpose, rename struct fields,
functions and a macro:

  ZBD_MAX_OPEN_ZONES -> ZBD_MAX_WRITE_ZONES
  struct fio_zone_info
    open -> write
  struct thread_data
    num_open_zones -> num_write_zones
  struct zoned_block_device_info:
    max_open_zones -> max_write_zones
    num_open_zones -> num_write_zones
    open_zones[] -> write_zones[]
  zbd_open_zone() -> zbd_write_zone_get()
  zbd_close_zone() -> zbd_write_zone_put()
  zbd_convert_to_open_zone() -> zbd_convert_to_write_zone()

To match up these changes, rename local variables and goto labels. Also
rephrase code comments.

Of note is that this rename is only for the fio code. The fio options
max_open_zones and job_max_open_zones are not renamed to not confuse
users.

Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 fio.h       |   2 +-
 options.c   |   4 +-
 zbd.c       | 218 ++++++++++++++++++++++++++--------------------------
 zbd.h       |  23 +++---
 zbd_types.h |   2 +-
 5 files changed, 126 insertions(+), 123 deletions(-)

diff --git a/fio.h b/fio.h
index 6fc7fb9c..c5453d13 100644
--- a/fio.h
+++ b/fio.h
@@ -275,7 +275,7 @@ struct thread_data {
 	unsigned long long num_unique_pages;
 
 	struct zone_split_index **zone_state_index;
-	unsigned int num_open_zones;
+	unsigned int num_write_zones;
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
diff --git a/options.c b/options.c
index 8193fb29..a7c4ef6e 100644
--- a/options.c
+++ b/options.c
@@ -3618,7 +3618,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Per device/file maximum number of open zones",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, max_open_zones),
-		.maxval	= ZBD_MAX_OPEN_ZONES,
+		.maxval	= ZBD_MAX_WRITE_ZONES,
 		.help	= "Limit on the number of simultaneously opened sequential write zones with zonemode=zbd",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
@@ -3629,7 +3629,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Job maximum number of open zones",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, job_max_open_zones),
-		.maxval	= ZBD_MAX_OPEN_ZONES,
+		.maxval	= ZBD_MAX_WRITE_ZONES,
 		.help	= "Limit on the number of simultaneously opened sequential write zones with zonemode=zbd by one thread/process",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
diff --git a/zbd.c b/zbd.c
index 5f1a7d7f..7529e68b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -304,39 +304,39 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 }
 
 /**
- * zbd_close_zone - Remove a zone from the open zones array.
+ * zbd_write_zone_put - Remove a zone from the write target zones array.
  * @td: FIO thread data.
- * @f: FIO file associated with the disk for which to reset a write pointer.
+ * @f: FIO file that has the write zones array to remove.
  * @zone_idx: Index of the zone to remove.
  *
  * The caller must hold f->zbd_info->mutex.
  */
-static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
-			   struct fio_zone_info *z)
+static void zbd_write_zone_put(struct thread_data *td, const struct fio_file *f,
+			       struct fio_zone_info *z)
 {
-	uint32_t ozi;
+	uint32_t zi;
 
-	if (!z->open)
+	if (!z->write)
 		return;
 
-	for (ozi = 0; ozi < f->zbd_info->num_open_zones; ozi++) {
-		if (zbd_get_zone(f, f->zbd_info->open_zones[ozi]) == z)
+	for (zi = 0; zi < f->zbd_info->num_write_zones; zi++) {
+		if (zbd_get_zone(f, f->zbd_info->write_zones[zi]) == z)
 			break;
 	}
-	if (ozi == f->zbd_info->num_open_zones)
+	if (zi == f->zbd_info->num_write_zones)
 		return;
 
-	dprint(FD_ZBD, "%s: closing zone %u\n",
+	dprint(FD_ZBD, "%s: removing zone %u from write zone array\n",
 	       f->file_name, zbd_zone_idx(f, z));
 
-	memmove(f->zbd_info->open_zones + ozi,
-		f->zbd_info->open_zones + ozi + 1,
-		(ZBD_MAX_OPEN_ZONES - (ozi + 1)) *
-		sizeof(f->zbd_info->open_zones[0]));
+	memmove(f->zbd_info->write_zones + zi,
+		f->zbd_info->write_zones + zi + 1,
+		(ZBD_MAX_WRITE_ZONES - (zi + 1)) *
+		sizeof(f->zbd_info->write_zones[0]));
 
-	f->zbd_info->num_open_zones--;
-	td->num_open_zones--;
-	z->open = 0;
+	f->zbd_info->num_write_zones--;
+	td->num_write_zones--;
+	z->write = 0;
 }
 
 /**
@@ -405,7 +405,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, z);
+		zbd_write_zone_put(td, f, z);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 
 		if (z->wp != z->start) {
@@ -450,19 +450,19 @@ static int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 }
 
 /**
- * zbd_open_zone - Add a zone to the array of open zones.
+ * zbd_write_zone_get - Add a zone to the array of write zones.
  * @td: fio thread data.
- * @f: fio file that has the open zones to add.
+ * @f: fio file that has the write zones array to add.
  * @zone_idx: Index of the zone to add.
  *
- * Open a ZBD zone if it is not already open. Returns true if either the zone
- * was already open or if the zone was successfully added to the array of open
- * zones without exceeding the maximum number of open zones. Returns false if
- * the zone was not already open and opening the zone would cause the zone limit
- * to be exceeded.
+ * Add a ZBD zone to write target zones array, if it is not yet added. Returns
+ * true if either the zone was already added or if the zone was successfully
+ * added to the array without exceeding the maximum number of write zones.
+ * Returns false if the zone was not already added and addition of the zone
+ * would cause the zone limit to be exceeded.
  */
-static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
-			  struct fio_zone_info *z)
+static bool zbd_write_zone_get(struct thread_data *td, const struct fio_file *f,
+			       struct fio_zone_info *z)
 {
 	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 	struct zoned_block_device_info *zbdi = f->zbd_info;
@@ -480,20 +480,20 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 		return false;
 
 	/*
-	 * zbdi->max_open_zones == 0 means that there is no limit on the maximum
-	 * number of open zones. In this case, do no track open zones in
-	 * zbdi->open_zones array.
+	 * zbdi->max_write_zones == 0 means that there is no limit on the
+	 * maximum number of write target zones. In this case, do no track write
+	 * target zones in zbdi->write_zones array.
 	 */
-	if (!zbdi->max_open_zones)
+	if (!zbdi->max_write_zones)
 		return true;
 
 	pthread_mutex_lock(&zbdi->mutex);
 
-	if (z->open) {
+	if (z->write) {
 		/*
 		 * If the zone is going to be completely filled by writes
-		 * already in-flight, handle it as a full zone instead of an
-		 * open zone.
+		 * already in-flight, handle it as a full zone instead of a
+		 * write target zone.
 		 */
 		if (!zbd_zone_remainder(z))
 			res = false;
@@ -503,17 +503,17 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 	res = false;
 	/* Zero means no limit */
 	if (td->o.job_max_open_zones > 0 &&
-	    td->num_open_zones >= td->o.job_max_open_zones)
+	    td->num_write_zones >= td->o.job_max_open_zones)
 		goto out;
-	if (zbdi->num_open_zones >= zbdi->max_open_zones)
+	if (zbdi->num_write_zones >= zbdi->max_write_zones)
 		goto out;
 
-	dprint(FD_ZBD, "%s: opening zone %u\n",
+	dprint(FD_ZBD, "%s: adding zone %u to write zone array\n",
 	       f->file_name, zone_idx);
 
-	zbdi->open_zones[zbdi->num_open_zones++] = zone_idx;
-	td->num_open_zones++;
-	z->open = 1;
+	zbdi->write_zones[zbdi->num_write_zones++] = zone_idx;
+	td->num_write_zones++;
+	z->write = 1;
 	res = true;
 
 out:
@@ -894,7 +894,7 @@ out:
 	return ret;
 }
 
-static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
+static int zbd_set_max_write_zones(struct thread_data *td, struct fio_file *f)
 {
 	struct zoned_block_device_info *zbd = f->zbd_info;
 	unsigned int max_open_zones;
@@ -902,7 +902,7 @@ static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
 
 	if (zbd->model != ZBD_HOST_MANAGED || td->o.ignore_zone_limits) {
 		/* Only host-managed devices have a max open limit */
-		zbd->max_open_zones = td->o.max_open_zones;
+		zbd->max_write_zones = td->o.max_open_zones;
 		goto out;
 	}
 
@@ -913,13 +913,13 @@ static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
 
 	if (!max_open_zones) {
 		/* No device limit */
-		zbd->max_open_zones = td->o.max_open_zones;
+		zbd->max_write_zones = td->o.max_open_zones;
 	} else if (!td->o.max_open_zones) {
 		/* No user limit. Set limit to device limit */
-		zbd->max_open_zones = max_open_zones;
+		zbd->max_write_zones = max_open_zones;
 	} else if (td->o.max_open_zones <= max_open_zones) {
 		/* Both user limit and dev limit. User limit not too large */
-		zbd->max_open_zones = td->o.max_open_zones;
+		zbd->max_write_zones = td->o.max_open_zones;
 	} else {
 		/* Both user limit and dev limit. User limit too large */
 		td_verror(td, EINVAL,
@@ -931,15 +931,15 @@ static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
 
 out:
 	/* Ensure that the limit is not larger than FIO's internal limit */
-	if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
+	if (zbd->max_write_zones > ZBD_MAX_WRITE_ZONES) {
 		td_verror(td, EINVAL, "'max_open_zones' value is too large");
 		log_err("'max_open_zones' value is larger than %u\n",
-			ZBD_MAX_OPEN_ZONES);
+			ZBD_MAX_WRITE_ZONES);
 		return -EINVAL;
 	}
 
-	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",
-	       f->file_name, zbd->max_open_zones);
+	dprint(FD_ZBD, "%s: using max write zones limit: %"PRIu32"\n",
+	       f->file_name, zbd->max_write_zones);
 
 	return 0;
 }
@@ -981,7 +981,7 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 	assert(f->zbd_info);
 	f->zbd_info->model = zbd_model;
 
-	ret = zbd_set_max_open_zones(td, f);
+	ret = zbd_set_max_write_zones(td, f);
 	if (ret) {
 		zbd_free_zone_info(f);
 		return ret;
@@ -1174,7 +1174,7 @@ int zbd_setup_files(struct thread_data *td)
 			assert(f->min_zone < f->max_zone);
 
 		if (td->o.max_open_zones > 0 &&
-		    zbd->max_open_zones != td->o.max_open_zones) {
+		    zbd->max_write_zones != td->o.max_open_zones) {
 			log_err("Different 'max_open_zones' values\n");
 			return 1;
 		}
@@ -1184,25 +1184,25 @@ int zbd_setup_files(struct thread_data *td)
 		 * global max open zones limit. (As the tracking of open zones
 		 * is disabled when there is no global max open zones limit.)
 		 */
-		if (td->o.job_max_open_zones && !zbd->max_open_zones) {
+		if (td->o.job_max_open_zones && !zbd->max_write_zones) {
 			log_err("'job_max_open_zones' cannot be used without a global open zones limit\n");
 			return 1;
 		}
 
 		/*
-		 * zbd->max_open_zones is the global limit shared for all jobs
+		 * zbd->max_write_zones is the global limit shared for all jobs
 		 * that target the same zoned block device. Force sync the per
 		 * thread global limit with the actual global limit. (The real
 		 * per thread/job limit is stored in td->o.job_max_open_zones).
 		 */
-		td->o.max_open_zones = zbd->max_open_zones;
+		td->o.max_open_zones = zbd->max_write_zones;
 
 		for (zi = f->min_zone; zi < f->max_zone; zi++) {
 			z = &zbd->zone_info[zi];
 			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
 			    z->cond != ZBD_ZONE_COND_EXP_OPEN)
 				continue;
-			if (zbd_open_zone(td, f, z))
+			if (zbd_write_zone_get(td, f, z))
 				continue;
 			/*
 			 * If the number of open zones exceeds specified limits,
@@ -1284,12 +1284,12 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	zbd_reset_write_cnt(td, f);
 }
 
-/* Return random zone index for one of the open zones. */
+/* Return random zone index for one of the write target zones. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
 {
 	return (io_u->offset - f->file_offset) *
-		f->zbd_info->num_open_zones / f->io_size;
+		f->zbd_info->num_write_zones / f->io_size;
 }
 
 static bool any_io_in_flight(void)
@@ -1303,35 +1303,35 @@ static bool any_io_in_flight(void)
 }
 
 /*
- * Modify the offset of an I/O unit that does not refer to an open zone such
- * that it refers to an open zone. Close an open zone and open a new zone if
- * necessary. The open zone is searched across sequential zones.
+ * Modify the offset of an I/O unit that does not refer to a zone such that
+ * in write target zones array. Add a zone to or remove a zone from the lsit if
+ * necessary. The write target zone is searched across sequential zones.
  * This algorithm can only work correctly if all write pointers are
  * a multiple of the fio block size. The caller must neither hold z->mutex
  * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
  */
-static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
-						      struct io_u *io_u)
+static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
+						       struct io_u *io_u)
 {
 	const uint64_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z;
-	unsigned int open_zone_idx = -1;
+	unsigned int write_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
-	bool wait_zone_close;
+	bool wait_zone_write;
 	bool in_flight;
 	bool should_retry = true;
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (zbdi->max_open_zones || td->o.job_max_open_zones) {
+	if (zbdi->max_write_zones || td->o.job_max_open_zones) {
 		/*
-		 * This statement accesses zbdi->open_zones[] on purpose
+		 * This statement accesses zbdi->write_zones[] on purpose
 		 * without locking.
 		 */
-		zone_idx = zbdi->open_zones[pick_random_zone_idx(f, io_u)];
+		zone_idx = zbdi->write_zones[pick_random_zone_idx(f, io_u)];
 	} else {
 		zone_idx = zbd_offset_to_zone_idx(f, io_u->offset);
 	}
@@ -1361,34 +1361,34 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		if (z->has_wp) {
 			if (z->cond != ZBD_ZONE_COND_OFFLINE &&
-			    zbdi->max_open_zones == 0 &&
+			    zbdi->max_write_zones == 0 &&
 			    td->o.job_max_open_zones == 0)
 				goto examine_zone;
-			if (zbdi->num_open_zones == 0) {
-				dprint(FD_ZBD, "%s(%s): no zones are open\n",
+			if (zbdi->num_write_zones == 0) {
+				dprint(FD_ZBD, "%s(%s): no zone is write target\n",
 				       __func__, f->file_name);
-				goto open_other_zone;
+				goto choose_other_zone;
 			}
 		}
 
 		/*
-		 * List of opened zones is per-device, shared across all
+		 * Array of write target zones is per-device, shared across all
 		 * threads. Start with quasi-random candidate zone. Ignore
 		 * zones which don't belong to thread's offset/size area.
 		 */
-		open_zone_idx = pick_random_zone_idx(f, io_u);
-		assert(!open_zone_idx ||
-		       open_zone_idx < zbdi->num_open_zones);
-		tmp_idx = open_zone_idx;
+		write_zone_idx = pick_random_zone_idx(f, io_u);
+		assert(!write_zone_idx ||
+		       write_zone_idx < zbdi->num_write_zones);
+		tmp_idx = write_zone_idx;
 
-		for (i = 0; i < zbdi->num_open_zones; i++) {
+		for (i = 0; i < zbdi->num_write_zones; i++) {
 			uint32_t tmpz;
 
-			if (tmp_idx >= zbdi->num_open_zones)
+			if (tmp_idx >= zbdi->num_write_zones)
 				tmp_idx = 0;
-			tmpz = zbdi->open_zones[tmp_idx];
+			tmpz = zbdi->write_zones[tmp_idx];
 			if (f->min_zone <= tmpz && tmpz < f->max_zone) {
-				open_zone_idx = tmp_idx;
+				write_zone_idx = tmp_idx;
 				goto found_candidate_zone;
 			}
 
@@ -1406,7 +1406,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		return NULL;
 
 found_candidate_zone:
-		new_zone_idx = zbdi->open_zones[open_zone_idx];
+		new_zone_idx = zbdi->write_zones[write_zone_idx];
 		if (new_zone_idx == zone_idx)
 			break;
 		zone_idx = new_zone_idx;
@@ -1425,32 +1425,32 @@ examine_zone:
 		goto out;
 	}
 
-open_other_zone:
-	/* Check if number of open zones reaches one of limits. */
-	wait_zone_close =
-		zbdi->num_open_zones == f->max_zone - f->min_zone ||
-		(zbdi->max_open_zones &&
-		 zbdi->num_open_zones == zbdi->max_open_zones) ||
+choose_other_zone:
+	/* Check if number of write target zones reaches one of limits. */
+	wait_zone_write =
+		zbdi->num_write_zones == f->max_zone - f->min_zone ||
+		(zbdi->max_write_zones &&
+		 zbdi->num_write_zones == zbdi->max_write_zones) ||
 		(td->o.job_max_open_zones &&
-		 td->num_open_zones == td->o.job_max_open_zones);
+		 td->num_write_zones == td->o.job_max_open_zones);
 
 	pthread_mutex_unlock(&zbdi->mutex);
 
 	/* Only z->mutex is held. */
 
 	/*
-	 * When number of open zones reaches to one of limits, wait for
-	 * zone close before opening a new zone.
+	 * When number of write target zones reaches to one of limits, wait for
+	 * zone write completion to one of them before trying a new zone.
 	 */
-	if (wait_zone_close) {
+	if (wait_zone_write) {
 		dprint(FD_ZBD,
-		       "%s(%s): quiesce to allow open zones to close\n",
+		       "%s(%s): quiesce to remove a zone from write target zones array\n",
 		       __func__, f->file_name);
 		io_u_quiesce(td);
 	}
 
 retry:
-	/* Zone 'z' is full, so try to open a new zone. */
+	/* Zone 'z' is full, so try to choose a new zone. */
 	for (i = f->io_size / zbdi->zone_size; i > 0; i--) {
 		zone_idx++;
 		if (z->has_wp)
@@ -1465,18 +1465,18 @@ retry:
 		if (!z->has_wp)
 			continue;
 		zone_lock(td, f, z);
-		if (z->open)
+		if (z->write)
 			continue;
-		if (zbd_open_zone(td, f, z))
+		if (zbd_write_zone_get(td, f, z))
 			goto out;
 	}
 
 	/* Only z->mutex is held. */
 
-	/* Check whether the write fits in any of the already opened zones. */
+	/* Check whether the write fits in any of the write target zones. */
 	pthread_mutex_lock(&zbdi->mutex);
-	for (i = 0; i < zbdi->num_open_zones; i++) {
-		zone_idx = zbdi->open_zones[i];
+	for (i = 0; i < zbdi->num_write_zones; i++) {
+		zone_idx = zbdi->write_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
 			continue;
 		pthread_mutex_unlock(&zbdi->mutex);
@@ -1492,13 +1492,14 @@ retry:
 
 	/*
 	 * When any I/O is in-flight or when all I/Os in-flight get completed,
-	 * the I/Os might have closed zones then retry the steps to open a zone.
-	 * Before retry, call io_u_quiesce() to complete in-flight writes.
+	 * the I/Os might have removed zones from the write target array then
+	 * retry the steps to choose a zone. Before retry, call io_u_quiesce()
+	 * to complete in-flight writes.
 	 */
 	in_flight = any_io_in_flight();
 	if (in_flight || should_retry) {
 		dprint(FD_ZBD,
-		       "%s(%s): wait zone close and retry open zones\n",
+		       "%s(%s): wait zone write and retry write target zone selection\n",
 		       __func__, f->file_name);
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
@@ -1512,7 +1513,7 @@ retry:
 
 	zone_unlock(z);
 
-	dprint(FD_ZBD, "%s(%s): did not open another zone\n",
+	dprint(FD_ZBD, "%s(%s): did not choose another write zone\n",
 	       __func__, f->file_name);
 
 	return NULL;
@@ -1582,7 +1583,8 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint64_t min_bytes,
  * @io_u: I/O unit
  * @z: zone info pointer
  *
- * If the write command made the zone full, close it.
+ * If the write command made the zone full, remove it from the write target
+ * zones array.
  *
  * The caller must hold z->mutex.
  */
@@ -1594,7 +1596,7 @@ static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
 	if (io_u->ddir == DDIR_WRITE &&
 	    io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, z);
+		zbd_write_zone_put(td, f, z);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 	}
 }
@@ -1954,7 +1956,7 @@ retry:
 		if (zbd_zone_remainder(zb) > 0 &&
 		    zbd_zone_remainder(zb) < min_bs) {
 			pthread_mutex_lock(&f->zbd_info->mutex);
-			zbd_close_zone(td, f, zb);
+			zbd_write_zone_put(td, f, zb);
 			pthread_mutex_unlock(&f->zbd_info->mutex);
 			dprint(FD_ZBD,
 			       "%s: finish zone %d\n",
@@ -1977,11 +1979,11 @@ retry:
 			zone_lock(td, f, zb);
 		}
 
-		if (!zbd_open_zone(td, f, zb)) {
+		if (!zbd_write_zone_get(td, f, zb)) {
 			zone_unlock(zb);
-			zb = zbd_convert_to_open_zone(td, io_u);
+			zb = zbd_convert_to_write_zone(td, io_u);
 			if (!zb) {
-				dprint(FD_IO, "%s: can't convert to open zone",
+				dprint(FD_IO, "%s: can't convert to write target zone",
 				       f->file_name);
 				goto eof;
 			}
diff --git a/zbd.h b/zbd.h
index 05189555..25a3e0f1 100644
--- a/zbd.h
+++ b/zbd.h
@@ -29,8 +29,8 @@ enum io_u_action {
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
  * @has_wp: whether or not this zone can have a valid write pointer
- * @open: whether or not this zone is currently open. Only relevant if
- *		max_open_zones > 0.
+ * @write: whether or not this zone is the write target at this moment. Only
+ *              relevant if zbd->max_open_zones > 0.
  * @reset_zone: whether or not this zone should be reset before writing to it
  */
 struct fio_zone_info {
@@ -41,16 +41,17 @@ struct fio_zone_info {
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		has_wp:1;
-	unsigned int		open:1;
+	unsigned int		write:1;
 	unsigned int		reset_zone:1;
 };
 
 /**
  * zoned_block_device_info - zoned block device characteristics
  * @model: Device model.
- * @max_open_zones: global limit on the number of simultaneously opened
- *	sequential write zones. A zero value means unlimited open zones,
- *	and that open zones will not be tracked in the open_zones array.
+ * @max_write_zones: global limit on the number of sequential write zones which
+ *      are simultaneously written. A zero value means unlimited zones of
+ *      simultaneous writes and that write target zones will not be tracked in
+ *      the write_zones array.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
@@ -61,10 +62,10 @@ struct fio_zone_info {
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
  * @refcount: number of fio files that share this structure
- * @num_open_zones: number of open zones
+ * @num_write_zones: number of write target zones
  * @write_cnt: Number of writes since the latest zone reset triggered by
  *	       the zone_reset_frequency fio job parameter.
- * @open_zones: zone numbers of open zones
+ * @write_zones: zone numbers of write target zones
  * @zone_info: description of the individual zones
  *
  * Only devices for which all zones have the same size are supported.
@@ -73,7 +74,7 @@ struct fio_zone_info {
  */
 struct zoned_block_device_info {
 	enum zbd_zoned_model	model;
-	uint32_t		max_open_zones;
+	uint32_t		max_write_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		wp_valid_data_bytes;
@@ -82,9 +83,9 @@ struct zoned_block_device_info {
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
-	uint32_t		num_open_zones;
+	uint32_t		num_write_zones;
 	uint32_t		write_cnt;
-	uint32_t		open_zones[ZBD_MAX_OPEN_ZONES];
+	uint32_t		write_zones[ZBD_MAX_WRITE_ZONES];
 	struct fio_zone_info	zone_info[0];
 };
 
diff --git a/zbd_types.h b/zbd_types.h
index 0a8630cb..5f44f308 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -8,7 +8,7 @@
 
 #include <inttypes.h>
 
-#define ZBD_MAX_OPEN_ZONES	4096
+#define ZBD_MAX_WRITE_ZONES	4096
 
 /*
  * Zoned block device models.
-- 
2.40.1

