Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D86630148B
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501529; cv=none; b=COTeKjsBe9dekZl/CTL6eOpj7Q4uiGqa7Sfl2phoL8xZ/Rd2zqSYSpRrNCyMPhykYVozIEk153RO4e65IlnOqrHtB+xLKpwgCTcZyDlZSqDM6obD7d8MMyF6gKSK47uvLYADlhwLrilg9QnBloCpa8xb9djospFsvzlPP8qCywA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501529; c=relaxed/simple;
	bh=NHsVLE7mP6xBhXUIUEwEkT3Rkf4b3xw3xcd4GWvGyf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS+93W7y9775KcfIJxkt4YRMP92sBgzlX//S08/pMvu2ubmsAUiCgK3SdrAH3noL3cyXLVIwzpo2X3oO5gNgp16GBdU8IckW209UjKYpru9Jjs1/4WASTYsRumKcz5vVHFnsOYVUdNe7FRhmCqWwzKEnOBtU983jnKPw7zFJ6oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JXZIgM/2; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JXZIgM/2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772501527; x=1804037527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NHsVLE7mP6xBhXUIUEwEkT3Rkf4b3xw3xcd4GWvGyf8=;
  b=JXZIgM/2X6NZFEBq7ZTaOIwLY0eyCZRn32zSeNV7pTaGYdzE1rww5c/C
   7QO0C9s/TpHYQ/hO9VoQQBGWw0+uD91AT4FwCk0zmmwaUZMED5J3Xr+rp
   JKPtYT335ojzY4DrcSkVVfy6SVYtuKz4ET9hRahJ+79/fbTrKy3DITS92
   HfIBkAzxizFmnDZW3t2hy/P2S7mHTabMLqyVj6LBtvcysjK6kH+iJUIpW
   QnWebVuU7TP0A8IHiIQScIFXk8Y7eLd/zekbFQ1DfBAo0+vnx2Hrlv9uQ
   D63FhzG+CIGVOo8QOEsctNw34BQZGtITz1Wugeb3fEI2HolIMpzEtFoVJ
   g==;
X-CSE-ConnectionGUID: mX17guMESQmqLOdlx7hh0w==
X-CSE-MsgGUID: kbUOXbcVQa69voq5cMm9Zg==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140813510"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2026 09:32:05 +0800
IronPort-SDR: 69a63a15_jJOJh22H8UbYE6JpjUSZmtBG5yUIahxMT1uje8GwbfTb8Q7
 5N/wbiI5oDT/RXnJbdrqaF6T9q6I868wb0RB67Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 17:32:05 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2026 17:32:04 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 3/8] zbd: introduce write_zone_remainder option
Date: Tue,  3 Mar 2026 10:31:54 +0900
Message-ID: <20260303013159.3543787-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
References: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the specified block size is not aligned with the zone size or the
write pointer positions at workload start, write workloads create
unwritten remainder areas at the ends of zones. These remainder areas
leave zones in the open condition. This disrupts the intended write
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

To avoid the performance degradation, introduce the new option named
"write_zone_remainder". When the option is specified, issue writes to
the remainder areas instead of issuing zone finish operation. The write
operation makes the zones in the full condition in the same manner as
the zone finish operation, freeing up the zone resource of the device
and enabling writing to other zones. Also when the option is set, skip
the io_u_quiesce() which was required before the zone finish operation.
The performance benefit by eliminating the waits on in-flight writes are
particularly significant in asynchronous I/O workloads, where the write
operations to the remainder areas are managed as part of queued I/Os.

The drawback of this approach is that writing these remainders requires
write sizes smaller than the minimum block size. As a result, when using
the write_zone_remainder option, the random map feature must be disabled
using the norandommap=1 option, which is automatically done when the
option is specified.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 cconv.c          |  2 ++
 init.c           | 13 ++++++++++
 options.c        | 10 ++++++++
 server.h         |  2 +-
 thread_options.h |  2 ++
 zbd.c            | 62 +++++++++++++++++++++++++++++++-----------------
 6 files changed, 68 insertions(+), 23 deletions(-)

diff --git a/cconv.c b/cconv.c
index 4e9c4b32..1c1b7273 100644
--- a/cconv.c
+++ b/cconv.c
@@ -276,6 +276,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->max_open_zones = __le32_to_cpu(top->max_open_zones);
 	o->ignore_zone_limits = le32_to_cpu(top->ignore_zone_limits);
 	o->recover_zbd_write_error = le32_to_cpu(top->recover_zbd_write_error);
+	o->write_zone_remainder = le32_to_cpu(top->write_zone_remainder);
 	o->lockmem = le64_to_cpu(top->lockmem);
 	o->offset_increment_percent = le32_to_cpu(top->offset_increment_percent);
 	o->offset_increment = le64_to_cpu(top->offset_increment);
@@ -658,6 +659,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->max_open_zones = __cpu_to_le32(o->max_open_zones);
 	top->ignore_zone_limits = cpu_to_le32(o->ignore_zone_limits);
 	top->recover_zbd_write_error = cpu_to_le32(o->recover_zbd_write_error);
+	top->write_zone_remainder = cpu_to_le32(o->write_zone_remainder);
 	top->lockmem = __cpu_to_le64(o->lockmem);
 	top->ddir_seq_add = __cpu_to_le64(o->ddir_seq_add);
 	top->file_size_low = __cpu_to_le64(o->file_size_low);
diff --git a/init.c b/init.c
index 07278619..623c14e6 100644
--- a/init.c
+++ b/init.c
@@ -666,6 +666,19 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
+	if (o->zone_mode == ZONE_MODE_ZBD && o->write_zone_remainder) {
+		if (fio_option_is_set(o, norandommap)) {
+			if (o->norandommap == 0) {
+				log_err("fio: write_zone_remainder=1 requires norandommap=1\n");
+				ret |= 1;
+			}
+			/* if == 1, OK */
+		} else {
+			dprint(FD_ZBD, "fio: override norandommap=1 for write_zone_remainder=1\n");
+			o->norandommap = 1;
+		}
+	}
+
 	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_size) {
 		log_err("fio: --zonesize must be specified when using --zonemode=strided.\n");
 		ret |= 1;
diff --git a/options.c b/options.c
index 6406dd0c..8d9e3054 100644
--- a/options.c
+++ b/options.c
@@ -3939,6 +3939,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_ZONE,
 	},
+	{
+		.name	= "write_zone_remainder",
+		.lname	= "Fill remainders of zones by write instead of zone finish operion",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, write_zone_remainder),
+		.def	= 0,
+		.help	= "When block size is unaligned, zones have small remainder write areas at ends. Fill them by write instead of zone finish operations for better performance.",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
 	{
 		.name   = "fdp",
 		.lname  = "Flexible data placement",
diff --git a/server.h b/server.h
index 589e8bea..6ac89013 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 119,
+	FIO_SERVER_VER			= 120,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index ff1f40ec..1b7f67eb 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -400,6 +400,7 @@ struct thread_options {
 	unsigned int job_max_open_zones;
 	unsigned int ignore_zone_limits;
 	unsigned int recover_zbd_write_error;
+	unsigned int write_zone_remainder;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 
@@ -731,6 +732,7 @@ struct thread_options_pack {
 	int32_t max_open_zones;
 	uint32_t ignore_zone_limits;
 	uint32_t recover_zbd_write_error;
+	uint32_t write_zone_remainder;
 
 	uint32_t log_entries;
 	uint32_t log_prio;
diff --git a/zbd.c b/zbd.c
index 2e600f97..6c93af51 100644
--- a/zbd.c
+++ b/zbd.c
@@ -86,18 +86,21 @@ static inline uint64_t zbd_zone_remainder(struct fio_zone_info *z)
 
 /**
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
- * @f: file pointer.
+ * @td: FIO thread data
  * @z: zone info pointer.
  * @required: minimum number of bytes that must remain in a zone.
  *
  * The caller must hold z->mutex.
  */
-static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
+static bool zbd_zone_full(const struct thread_data *td, struct fio_zone_info *z,
 			  uint64_t required)
 {
+	if (!z->has_wp)
+		return false;
+	if (td->o.write_zone_remainder)
+		return zbd_zone_remainder(z) == 0;
 	assert((required & 511) == 0);
-
-	return z->has_wp && required > zbd_zone_remainder(z);
+	return required > zbd_zone_remainder(z);
 }
 
 static void zone_lock(struct thread_data *td, const struct fio_file *f,
@@ -629,7 +632,7 @@ static bool zbd_write_zone_get(struct thread_data *td, const struct fio_file *f,
 	 * Skip full zones with data verification enabled because resetting a
 	 * zone causes data loss and hence causes verification to fail.
 	 */
-	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+	if (td->o.verify != VERIFY_NONE && zbd_zone_full(td, z, min_bs))
 		return false;
 
 	return __zbd_write_zone_get(td, f, z);
@@ -1513,14 +1516,16 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	struct fio_zone_info *z;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
-	bool wait_zone_write;
+	bool wait_zone_write = false;
 	bool in_flight;
 	bool should_retry = true;
 	bool need_zone_finish;
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (zbd_zone_remainder(zb) > 0 && zbd_zone_remainder(zb) < min_bs) {
+	/* If the first selected zone has remainder, finish it */
+	if (!td->o.write_zone_remainder && zbd_zone_remainder(zb) > 0 &&
+	    zbd_zone_remainder(zb) < min_bs) {
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		zbd_write_zone_put(td, f, zb);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
@@ -1619,13 +1624,18 @@ examine_zone:
 	}
 
 choose_other_zone:
-	/* Check if number of write target zones reaches one of limits. */
-	wait_zone_write =
-		zbdi->num_write_zones == f->max_zone - f->min_zone ||
-		(zbdi->max_write_zones &&
-		 zbdi->num_write_zones == zbdi->max_write_zones) ||
-		(td->o.job_max_open_zones &&
-		 td->num_write_zones == td->o.job_max_open_zones);
+	/*
+	 * When zones have small remainder at zone ends, zone finish operations
+	 * may take some time. In this case, check if number of write target
+	 * zones reaches one of limits to wait for the zone finish operations.
+	 */
+	if (!td->o.write_zone_remainder)
+		wait_zone_write =
+			zbdi->num_write_zones == f->max_zone - f->min_zone ||
+			(zbdi->max_write_zones &&
+			 zbdi->num_write_zones == zbdi->max_write_zones) ||
+			(td->o.job_max_open_zones &&
+			 td->num_write_zones == td->o.job_max_open_zones);
 
 	pthread_mutex_unlock(&zbdi->mutex);
 
@@ -1681,8 +1691,10 @@ retry:
 
 	/* Check whether the write fits in any of the write target zones. */
 	pthread_mutex_lock(&zbdi->mutex);
-	need_zone_finish = true;
+	need_zone_finish = !td->o.write_zone_remainder;
 	for (i = 0; i < zbdi->num_write_zones; i++) {
+		uint64_t remainder;
+
 		zone_idx = zbdi->write_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
 			continue;
@@ -1693,13 +1705,15 @@ retry:
 
 		zone_lock(td, f, z);
 		/*
-		 * If the zone has remainder larger than min_bs, the next write
+		 * Check remainder size of the zone to see if the next write
 		 * fits the zone. In that case, choose the zone for the write.
 		 * The zone might be already removed from zbdi->write_zones[] by
 		 * other jobs at this moment. Call zbd_write_zone_get() to
 		 * ensure that the zone for the write is in the array.
 		 */
-		if (zbd_zone_remainder(z) >= min_bs &&
+		remainder = zbd_zone_remainder(z);
+		if (((td->o.write_zone_remainder && remainder > 0) ||
+		     (!td->o.write_zone_remainder && remainder >= min_bs)) &&
 		    zbd_write_zone_get(td, f, z)) {
 			need_zone_finish = false;
 			goto out;
@@ -2229,7 +2243,8 @@ retry:
 			goto eof;
 		}
 
-		if (zbd_zone_remainder(zb) > 0 &&
+		if (!td->o.write_zone_remainder &&
+		    zbd_zone_remainder(zb) > 0 &&
 		    zbd_zone_remainder(zb) < min_bs)
 			goto retry;
 
@@ -2242,7 +2257,7 @@ retry:
 		}
 
 		/* Reset the zone pointer if necessary */
-		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
+		if (zb->reset_zone || zbd_zone_full(td, zb, min_bs)) {
 			if (td->o.verify != VERIFY_NONE) {
 				/*
 				 * Unset io-u->file to tell get_next_verify()
@@ -2277,7 +2292,7 @@ retry:
 		}
 
 		/* Make writes occur at the write pointer */
-		assert(!zbd_zone_full(f, zb, min_bs));
+		assert(!zbd_zone_full(td, zb, min_bs));
 		io_u->offset = zb->wp;
 		if (!is_valid_offset(f, io_u->offset)) {
 			td_verror(td, EINVAL, "invalid WP value");
@@ -2293,10 +2308,13 @@ retry:
 		 */
 		new_len = min((unsigned long long)io_u->buflen,
 			      zbd_zone_capacity_end(zb) - io_u->offset);
-		new_len = new_len / min_bs * min_bs;
+		if ((td->o.write_zone_remainder && new_len > min_bs) ||
+			!td->o.write_zone_remainder)
+			new_len = new_len / min_bs * min_bs;
+
 		if (new_len == io_u->buflen)
 			goto accept;
-		if (new_len >= min_bs) {
+		if (td->o.write_zone_remainder || new_len >= min_bs) {
 			io_u->buflen = new_len;
 			dprint(FD_IO, "Changed length from %u into %llu\n",
 			       orig_len, io_u->buflen);
-- 
2.49.0

