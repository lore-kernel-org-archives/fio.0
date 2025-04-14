Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13041A239D
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 06:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744612046; cv=none; b=nMKxCTKdYt1K6ckf90VQgvFiLMHr6PattiFRBhljAEcOFvSVOY1ZMdDLMSryRwx98nB5Q9FyY/1m73L014EU/UuaSDZXUAAjG7loSTEhAE5rNF7TCEW4ovb5PS2mhuSCsynhLR3Fnmbalmmang4QLkytnIz7la6xI5q2F/Te7BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744612046; c=relaxed/simple;
	bh=Cj/xC8M5zmOUu3xZwZB+56hhpMel9Tb04J28ZNRphtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gM027FdHvAKZR5ZRbYy6Ts1e1sccSh+EUVM1WndPFsmf65A+N6Mme7yFdLoeJy6Y9FPrA4Em9xjQV++3Fk57vWbF2DAhzmrajzQB4mfEq+rrQokoTN52WLQKQ6FQgWigH6kuQUUHqxLo/actqvuhv0hqJxuuDqCohP4UDY2IpPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=A0Rxlmml; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="A0Rxlmml"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744612045; x=1776148045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cj/xC8M5zmOUu3xZwZB+56hhpMel9Tb04J28ZNRphtc=;
  b=A0RxlmmlWb06kluEjckItcbsbQ8Anm5py8twi3lQyTOfj+EjiZrRitsJ
   ujwLqYGdLC6mCgcP4x8u83M2XlviGSgOZ86atOhC39shjUI0PvXSRxDLI
   EXNctRKoMTYO/5K+kTwo5o12j0skmn/TSw/2j85Lkqml6A/hyVbudGMW9
   TQ1JAy8WGGhZBf9dORPbOjP2ftUUAZ0aKYJPakkftLOCTCmsjPxMXyZ94
   7tXuDPIW9QqZ/+i1ZuTXBCF1xpc9+HgwjFY5Cbk3BaY1e/5I5jD1P7Gau
   GKbuq963wvViyGfeZD3m4wpgJOjditkzDUvj2xJTCeq5NyPzkQDTfUmCV
   w==;
X-CSE-ConnectionGUID: +V5CHLXCTuCuM2xa//wUog==
X-CSE-MsgGUID: WGRlqkOoQl61I/88w/bizA==
X-IronPort-AV: E=Sophos;i="6.15,211,1739808000"; 
   d="scan'208";a="78068684"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2025 14:27:24 +0800
IronPort-SDR: 67fc9cc1_ROwydzur7GlTxvhrkbbojFgYlE9i3kWSTv955ftb3PNFUUN
 9XODHHs1IwQA5N+gFYcdKQDs88vBSwAK3vX+c/Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Apr 2025 22:27:30 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Apr 2025 23:27:23 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/4] zbd: move zone finish operation to zbd_convert_to_write_zone()
Date: Mon, 14 Apr 2025 15:27:18 +0900
Message-ID: <20250414062721.87641-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
References: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when a write target zone has fewer remainder sectors than
the block size, fio finishes the zone to make the zone inactive (not
open), so that another zone can be open and used as a write target zone.
This zone finish operation is implemented in zbd_adjust_block().
However, this placement is less ideal because zbd_adjust_block() manages
not just write requests but also read and trim requests.

Since the zone finish operation is exclusively necessary for write
requests, implement it into zbd_convert_to_write_zone(). While at it,
improve the function comment.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 zbd.c | 84 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/zbd.c b/zbd.c
index ee095b1d..ac65640b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1396,16 +1396,23 @@ static bool any_io_in_flight(void)
 	return false;
 }
 
-/*
+/**
+ * zbd_convert_to_write_zone - Convert the target zone of an io_u to a writable zone
+ * @td: The fio thread data
+ * @io_u: The I/O unit that targets the zone to convert
+ * @zb: The zone selected at the beginning of the function call. The caller must
+ *      hold zb->mutex.
+ *
  * Modify the offset of an I/O unit that does not refer to a zone such that
- * in write target zones array. Add a zone to or remove a zone from the lsit if
+ * in write target zones array. Add a zone to or remove a zone from the array if
  * necessary. The write target zone is searched across sequential zones.
  * This algorithm can only work correctly if all write pointers are
- * a multiple of the fio block size. The caller must neither hold z->mutex
- * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
+ * a multiple of the fio block size. The caller must not hold
+ * f->zbd_info->mutex. Returns with z->mutex held upon success.
  */
 static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
-						       struct io_u *io_u)
+						       struct io_u *io_u,
+						       struct fio_zone_info *zb)
 {
 	const uint64_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
@@ -1420,6 +1427,34 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 
 	assert(is_valid_offset(f, io_u->offset));
 
+	if (zbd_zone_remainder(zb) > 0 && zbd_zone_remainder(zb) < min_bs) {
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		zbd_write_zone_put(td, f, zb);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		dprint(FD_ZBD, "%s: finish zone %d\n",
+		       f->file_name, zbd_zone_idx(f, zb));
+		io_u_quiesce(td);
+		zbd_finish_zone(td, f, zb);
+		zone_unlock(zb);
+
+		if (zbd_zone_idx(f, zb) + 1 >= f->max_zone && !td_random(td))
+			return NULL;
+
+		/* Find the next write pointer zone */
+		do {
+			zb++;
+			if (zbd_zone_idx(f, zb) >= f->max_zone)
+				zb = zbd_get_zone(f, f->min_zone);
+		} while (!zb->has_wp);
+
+		zone_lock(td, f, zb);
+	}
+
+	if (zbd_write_zone_get(td, f, zb))
+		return zb;
+
+	zone_unlock(zb);
+
 	if (zbdi->max_write_zones || td->o.job_max_open_zones) {
 		/*
 		 * This statement accesses zbdi->write_zones[] on purpose
@@ -2047,40 +2082,11 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 
 retry:
-		if (zbd_zone_remainder(zb) > 0 &&
-		    zbd_zone_remainder(zb) < min_bs) {
-			pthread_mutex_lock(&f->zbd_info->mutex);
-			zbd_write_zone_put(td, f, zb);
-			pthread_mutex_unlock(&f->zbd_info->mutex);
-			dprint(FD_ZBD,
-			       "%s: finish zone %d\n",
-			       f->file_name, zbd_zone_idx(f, zb));
-			io_u_quiesce(td);
-			zbd_finish_zone(td, f, zb);
-			if (zbd_zone_idx(f, zb) + 1 >= f->max_zone) {
-				if (!td_random(td))
-					goto eof;
-			}
-			zone_unlock(zb);
-
-			/* Find the next write pointer zone */
-			do {
-				zb++;
-				if (zbd_zone_idx(f, zb) >= f->max_zone)
-					zb = zbd_get_zone(f, f->min_zone);
-			} while (!zb->has_wp);
-
-			zone_lock(td, f, zb);
-		}
-
-		if (!zbd_write_zone_get(td, f, zb)) {
-			zone_unlock(zb);
-			zb = zbd_convert_to_write_zone(td, io_u);
-			if (!zb) {
-				dprint(FD_IO, "%s: can't convert to write target zone",
-				       f->file_name);
-				goto eof;
-			}
+		zb = zbd_convert_to_write_zone(td, io_u, zb);
+		if (!zb) {
+			dprint(FD_IO, "%s: can't convert to write target zone",
+			       f->file_name);
+			goto eof;
 		}
 
 		if (zbd_zone_remainder(zb) > 0 &&
-- 
2.49.0

