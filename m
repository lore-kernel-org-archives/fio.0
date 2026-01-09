Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557073168E5
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926238; cv=none; b=kGZZ23ne3M70gOitt4/0tV7HbjQGyO4c77NqXfm58UwS2iTEEsJZS1GAl3+aNaJ+uFSZ7OUuFuV23Wf+fcVpzjK7Czq+ACAwvJbr88LF2gIf9+CGxRNXNPzEYyRpHwqU7NyPSq7mHlvkmKg3x1fmOb8pNLRCuDTZrt8rzeznkqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926238; c=relaxed/simple;
	bh=cFW5ti4ZcJu+q6E0TwmjuiQWJ5cXrHsrwiCqo1d7/CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K76z5+4whcl+9wseZwJUn00p+zYfizaN2p4YSbfWHtvKx68bYup1V/Ptjv1J5Jy4Drgr4MRpaV+4YWzZkdsWZ/L8JZPPI+fcd9C9RHp90js278ZrCG6jz7JqIUCWx2FEmAIOOkOZDSvwSoIaZP0QJXrta8YXDfPwNJ1fUfDlePU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Y/0PdF9K; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Y/0PdF9K"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926235; x=1799462235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cFW5ti4ZcJu+q6E0TwmjuiQWJ5cXrHsrwiCqo1d7/CE=;
  b=Y/0PdF9KfqgR9jep7ROVq1vJofQ7DLFYQbFUfTAgzOn8oQv5gc69nPQM
   A4mR9r2RNXUhEUhCwVvb7KLs5G9MQbF4eWpDHD7hFEl6tqP2lll4Q67mB
   0zMsMCUSJfssAv2aGkm2ZWm1X5QsBnDRGY//foRZJlBBd4ZLbNd/94Hzc
   /cCbj2iF89DyDmpXE8tYOzFkHLEQrmDM5bAKGkY4aXq3vbaxAga2u3M5z
   BBhAWAyHVY/GX35O6EvmDOHxfd/f0dkOqOlrNgouvTbxOQbiVuK9uK2R1
   R0BC38LyMhp1ckyaqr+u3HYC5UsVbWS08lPn/WsJQALnMBUo32NNiGmos
   A==;
X-CSE-ConnectionGUID: 1Oh+ywITTVSLb72HD6yjMg==
X-CSE-MsgGUID: Gic3OxN0TNy5UPbuuT9yDQ==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774575"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:06 +0800
IronPort-SDR: 69606998_2s9BrEzyJknojObjS/qZ+CnYqg48DshSdjuUbb3mb1V5icL
 KSm2Rmw32YV7VRBUTlRvuNAgziNJXGpcn4gHUGA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:09 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:08 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 03/12] zbd: write zone remainders smaller than minimum block size
Date: Fri,  9 Jan 2026 11:35:54 +0900
Message-ID: <20260109023603.2848421-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the specified block size is not aligned with the zone size or the
write pointer position at workload start, write workloads create
unwritten remainder areas at the ends of zones. These remainder areas
leave zones in an open condition. This disrupts the intended write
target zone selection.

Previous commits e1a1b59b0b9b ("zbd: finish zones with remainder smaller
than minimum write block size") and e2e29bf6f830 ("zbd: finish zone when
all random write target zones have small remainder") attempted to solve
this problem by issuing zone finish operation for zones with small
remainders. However, this approach caused performance degradation due to
two reasons. First, the zone finish operation requires substantial
execution time. Second, zone finish operation requires to wait for in-
flight writes from other jobs to complete, which is done by calling
io_u_quiesce() before the zone finish operation.

To avoid the performance degradation, just write the small remainder
areas instead of the zone finish operation. Writing these small
remainder areas shifts the target zone into the "full" condition,
freeing up the zone resource of the device and enabling writing to other
zones. Particularly in asynchronous I/O workloads, these write
operations are managed as part of queued I/Os, eliminating the need for
waiting on in-flight writes.

The drawback of this approach is that writing these remainders requires
write sizes smaller than the minimum block size. As a result, when using
zonemode=zbd, the random map feature must be disabled using the
norandommap=1 option, which is automatically done for zonemode=zbd.

Fixes: e1a1b59b0b9b ("zbd: finish zones with remainder smaller than minimum write block size")
Fixes: e2e29bf6f830 ("zbd: finish zone when all random write target zones have small remainder")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 93 ++++++++++-------------------------------------------------
 1 file changed, 15 insertions(+), 78 deletions(-)

diff --git a/zbd.c b/zbd.c
index b71f842c..9d5a3bc3 100644
--- a/zbd.c
+++ b/zbd.c
@@ -92,12 +92,9 @@ static inline uint64_t zbd_zone_remainder(struct fio_zone_info *z)
  *
  * The caller must hold z->mutex.
  */
-static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
-			  uint64_t required)
+static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z)
 {
-	assert((required & 511) == 0);
-
-	return z->has_wp && required > zbd_zone_remainder(z);
+	return z->has_wp && zbd_zone_remainder(z) == 0;
 }
 
 static void zone_lock(struct thread_data *td, const struct fio_file *f,
@@ -623,13 +620,11 @@ out:
 static bool zbd_write_zone_get(struct thread_data *td, const struct fio_file *f,
 			       struct fio_zone_info *z)
 {
-	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
-
 	/*
 	 * Skip full zones with data verification enabled because resetting a
 	 * zone causes data loss and hence causes verification to fail.
 	 */
-	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z))
 		return false;
 
 	return __zbd_write_zone_get(td, f, z);
@@ -1507,7 +1502,6 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 						       struct io_u *io_u,
 						       struct fio_zone_info *zb)
 {
-	const uint64_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z;
@@ -1516,33 +1510,9 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	bool wait_zone_write;
 	bool in_flight;
 	bool should_retry = true;
-	bool need_zone_finish;
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (zbd_zone_remainder(zb) > 0 && zbd_zone_remainder(zb) < min_bs) {
-		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_write_zone_put(td, f, zb);
-		pthread_mutex_unlock(&f->zbd_info->mutex);
-		dprint(FD_ZBD, "%s: finish zone %d\n",
-		       f->file_name, zbd_zone_idx(f, zb));
-		io_u_quiesce(td);
-		zbd_finish_zone(td, f, zb);
-		zone_unlock(zb);
-
-		if (zbd_zone_idx(f, zb) + 1 >= f->max_zone && !td_random(td))
-			return NULL;
-
-		/* Find the next write pointer zone */
-		do {
-			zb++;
-			if (zbd_zone_idx(f, zb) >= f->max_zone)
-				zb = zbd_get_zone(f, f->min_zone);
-		} while (!zb->has_wp);
-
-		zone_lock(td, f, zb);
-	}
-
 	if (zbd_write_zone_get(td, f, zb))
 		return zb;
 
@@ -1613,7 +1583,7 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	/* Both z->mutex and zbdi->mutex are held. */
 
 examine_zone:
-	if (zbd_zone_remainder(z) >= min_bs) {
+	if (zbd_zone_remainder(z) > 0) {
 		pthread_mutex_unlock(&zbdi->mutex);
 		goto out;
 	}
@@ -1679,9 +1649,8 @@ retry:
 
 	/* Only z->mutex is held. */
 
-	/* Check whether the write fits in any of the write target zones. */
+	/* Check write target zones. */
 	pthread_mutex_lock(&zbdi->mutex);
-	need_zone_finish = true;
 	for (i = 0; i < zbdi->num_write_zones; i++) {
 		zone_idx = zbdi->write_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
@@ -1692,10 +1661,8 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (zbd_zone_remainder(z) >= min_bs) {
-			need_zone_finish = false;
+		if (zbd_zone_remainder(z) > 0)
 			goto out;
-		}
 		pthread_mutex_lock(&zbdi->mutex);
 	}
 
@@ -1718,26 +1685,6 @@ retry:
 		goto retry;
 	}
 
-	if (td_random(td) && td->o.verify == VERIFY_NONE && need_zone_finish)
-		/*
-		 * If all open zones have remainder smaller than the block size
-		 * for random write jobs, choose one of the write target zones
-		 * and finish it. When verify is enabled, skip this zone finish
-		 * operation to avoid verify data corruption by overwrite to the
-		 * zone.
-		 */
-		if (zbd_pick_write_zone(f, io_u, &zone_idx)) {
-			pthread_mutex_unlock(&zbdi->mutex);
-			zone_unlock(z);
-			z = zbd_get_zone(f, zone_idx);
-			zone_lock(td, f, z);
-			io_u_quiesce(td);
-			dprint(FD_ZBD, "%s(%s): All write target zones have remainder smaller than block size. Choose zone %d and finish.\n",
-			       __func__, f->file_name, zone_idx);
-			zbd_finish_zone(td, f, z);
-			goto out;
-		}
-
 	pthread_mutex_unlock(&zbdi->mutex);
 
 	zone_unlock(z);
@@ -2213,7 +2160,6 @@ retry_lock:
 			goto eof;
 		}
 
-retry:
 		zb = zbd_convert_to_write_zone(td, io_u, zb);
 		if (!zb) {
 			dprint(FD_IO, "%s: can't convert to write target zone",
@@ -2221,10 +2167,6 @@ retry:
 			goto eof;
 		}
 
-		if (zbd_zone_remainder(zb) > 0 &&
-		    zbd_zone_remainder(zb) < min_bs)
-			goto retry;
-
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
 			if (zbdi->wp_valid_data_bytes >=
@@ -2234,7 +2176,7 @@ retry:
 		}
 
 		/* Reset the zone pointer if necessary */
-		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
+		if (zb->reset_zone || zbd_zone_full(f, zb)) {
 			if (td->o.verify != VERIFY_NONE) {
 				/*
 				 * Unset io-u->file to tell get_next_verify()
@@ -2269,7 +2211,7 @@ retry:
 		}
 
 		/* Make writes occur at the write pointer */
-		assert(!zbd_zone_full(f, zb, min_bs));
+		assert(!zbd_zone_full(f, zb));
 		io_u->offset = zb->wp;
 		if (!is_valid_offset(f, io_u->offset)) {
 			td_verror(td, EINVAL, "invalid WP value");
@@ -2285,21 +2227,16 @@ retry:
 		 */
 		new_len = min((unsigned long long)io_u->buflen,
 			      zbd_zone_capacity_end(zb) - io_u->offset);
-		new_len = new_len / min_bs * min_bs;
+		assert(new_len > 0);
+		if (new_len > min_bs)
+			new_len = new_len / min_bs * min_bs;
 		if (new_len == io_u->buflen)
 			goto accept;
-		if (new_len >= min_bs) {
-			io_u->buflen = new_len;
-			dprint(FD_IO, "Changed length from %u into %llu\n",
-			       orig_len, io_u->buflen);
-			goto accept;
-		}
 
-		td_verror(td, EIO, "zone remainder too small");
-		log_err("zone remainder %lld smaller than min block size %"PRIu64"\n",
-			(zbd_zone_capacity_end(zb) - io_u->offset), min_bs);
-
-		goto eof;
+		io_u->buflen = new_len;
+		dprint(FD_IO, "Changed length from %u into %llu\n",
+		       orig_len, io_u->buflen);
+		goto accept;
 
 	case DDIR_TRIM:
 		/* Check random trim targets a non-empty zone */
-- 
2.49.0

