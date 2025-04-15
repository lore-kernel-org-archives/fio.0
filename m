Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2193A294A01
	for <fio@vger.kernel.org>; Tue, 15 Apr 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744718412; cv=none; b=u1nvlKzBkq5xpLJszxkIsG/5U3JTXFQ250FPushCe0wqHPJRH30EkGLvfqVgdcKseTLlrG2PeBx6WHATjdSDWjHxohBgvLNdkrdFl27rfigUyS/z82jdIwLLFYfQl97CBUmmKaBRrx74flqa0/ruqeDU4bULQ7uy590SVW/+yWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744718412; c=relaxed/simple;
	bh=NmkXvKo3YpfsFFlm1OKXew20wztfNtWF9FJRUEr1Teg=;
	h=Subject:From:To:Message-Id:Date; b=tF8HZFCuz9cQZfbiqeh60WXKc4unJU1LRNECYsKYeneCml0iAd+bbMrhXNnEsdGlQgZVquLgPa4zXB2vPcwHnlGI1wJmSO27pqCzRJNXz/9s5lzkY1hmMXuaAQ+oKkV4Tlzntm28OS09NyBURO7u4LVn0LCxfycWusjxyAguCwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XhmvazEx; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XhmvazEx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=23pC08Y3DnctoXkse9xUGeJEvjz/2hciz7agzyE/2l4=; b=XhmvazExPcxW9qX01SojsYg+aG
	gFKXj1tTxW+gat3x155vwj9x5Gy2MhnsRuKQX6IagO2AVJIdwRUwMp93zuyU318RDgJESr4PNTXUm
	iWvNHzlQ4nxvlrk2LmmhKUDlw0X11wFliiLjMmB0/VDCzQT5N5iSFDxO+X8pbFz7dPFGrGB6XCq9I
	BtKZ+tpOmPEuLvHrWYFeaNVHKDOw6LnOQ1y52t8DRUQpjFlxdjOa+5lesFTELJJto+laIeJ7shhea
	bqU3pY43lxkhOPQ6ZXVBVpIJvizhtR6byBE49ZAinPooDwllhh9lgHI7pi16csJhtQMeqTlEwLUzo
	j0f98Fnw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u4exR-00000009s2N-0ZcF
	for fio@vger.kernel.org;
	Tue, 15 Apr 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 11DFB1BC0156; Tue, 15 Apr 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250415120002.11DFB1BC0156@kernel.dk>
Date: Tue, 15 Apr 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f18c2fd5f3e8114b5bfbe04e5511421c24b25fe1:

  ci: add verify-trim.py test script (2025-04-07 10:54:38 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 96afc2337db197a59fae916b5ff4226af8b0108f:

  t/zbd: add test for the case all write zones have small remainder (2025-04-14 08:27:31 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (4):
      zbd: move zone finish operation to zbd_convert_to_write_zone()
      zbd: factor out zbd_pick_write_zone()
      zbd: finish zone when all random write target zones have small remainder
      t/zbd: add test for the case all write zones have small remainder

 t/zbd/test-zbd-support |  48 +++++++++++++
 zbd.c                  | 191 +++++++++++++++++++++++++++++--------------------
 2 files changed, 162 insertions(+), 77 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 468fce70..0278ac17 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -346,6 +346,14 @@ require_max_active_zones() {
 	return 0
 }
 
+require_no_max_active_zones() {
+	if ((max_active_zones > 0)); then
+		SKIP_REASON="$dev has max_active_zones limit"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused for block devices.
 test1() {
     require_block_dev || return $SKIP_TESTCASE
@@ -1637,6 +1645,46 @@ test70() {
 		       >> "${logfile}.${test_number}" 2>&1
 }
 
+# Test random write does not end early when the zones as many as max_open_zones
+# have remainder smaller than block size.
+test71() {
+	local off size capacity zone_fill_size i
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_seq_zones 8 || return "$SKIP_TESTCASE"
+	require_no_max_active_zones || return "$SKIP_TESTCASE"
+
+	reset_zone "${dev}" -1
+
+	# Fill data to every other zone in the test target 8 zones. This leaves
+	# 4 zones in the implicit open condition. Leave 12kb remainder in the
+	# 4 zones.
+	off=$((first_sequential_zone_sector * 512))
+	size=$min_seq_write_size
+	capacity=$(total_zone_capacity 1 "$off" "$dev")
+	zone_fill_size=$((capacity - 3 * 4096))
+	run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off" \
+			--bs=4k --zonemode=strided \
+			--zonesize="$zone_fill_size" \
+			--zonerange=$((zone_size * 2)) \
+			--io_size=$((zone_fill_size * 4)) \
+			>> "${logfile}.${test_number}" 2>&1 || return $?
+	# Close the 4 zones to not fail the next fio command with the
+	# --max_open_zones=1 option
+	for ((i = 0; i < 4; i++)); do
+		close_zone "$dev" $(((off + zone_size * 2 * i) / 512)) || return $?
+	done
+
+	# Run random write with 8kb block size
+	run_one_fio_job "$(ioengine "psync")" --rw=randwrite --offset="$off" \
+			--bs=$((4096 * 2)) --zonemode=zbd \
+			--zonesize="$zone_size" --size=$((zone_size * 8)) \
+			--max_open_zones=1 --debug=zbd \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+
+	check_written $((zone_size * 8)) || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/zbd.c b/zbd.c
index ee095b1d..89519234 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1386,6 +1386,43 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
 		f->zbd_info->num_write_zones / f->io_size;
 }
 
+/*
+ * Randomly choose a zone in the array of write zones and in the range for the
+ * file f. If such a zone is found, return its index in f->zbd_info->zone_info[]
+ * using @zone_idx, and return true. Otherwise, return false.
+ *
+ * Caller must hold f->zbd_info->mutex.
+ */
+static bool zbd_pick_write_zone(const struct fio_file* f,
+				const struct io_u *io_u, uint32_t *zone_idx)
+{
+	struct zoned_block_device_info *zbdi = f->zbd_info;
+	uint32_t write_zone_idx;
+	uint32_t cur_zone_idx;
+	int i;
+
+	/*
+	 * An array of write target zones is per-device, shared across all jobs.
+	 * Start with quasi-random candidate zone. Ignore zones which do not
+	 * belong to offset/size range of the current job.
+	 */
+	write_zone_idx = pick_random_zone_idx(f, io_u);
+	assert(!write_zone_idx || write_zone_idx < zbdi->num_write_zones);
+
+	for (i = 0; i < zbdi->num_write_zones; i++) {
+		if (write_zone_idx >= zbdi->num_write_zones)
+			write_zone_idx = 0;
+		cur_zone_idx = zbdi->write_zones[write_zone_idx];
+		if (f->min_zone <= cur_zone_idx && cur_zone_idx < f->max_zone) {
+			*zone_idx = cur_zone_idx;
+			return true;
+		}
+		write_zone_idx++;
+	}
+
+	return false;
+}
+
 static bool any_io_in_flight(void)
 {
 	for_each_td(td) {
@@ -1396,30 +1433,65 @@ static bool any_io_in_flight(void)
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
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	struct fio_zone_info *z;
-	unsigned int write_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
 	bool wait_zone_write;
 	bool in_flight;
 	bool should_retry = true;
+	bool need_zone_finish;
 
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
@@ -1445,8 +1517,6 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	 * has been obtained. Hence the loop.
 	 */
 	for (;;) {
-		uint32_t tmp_idx;
-
 		z = zbd_get_zone(f, zone_idx);
 		if (z->has_wp)
 			zone_lock(td, f, z);
@@ -1465,42 +1535,15 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 			}
 		}
 
-		/*
-		 * Array of write target zones is per-device, shared across all
-		 * threads. Start with quasi-random candidate zone. Ignore
-		 * zones which don't belong to thread's offset/size area.
-		 */
-		write_zone_idx = pick_random_zone_idx(f, io_u);
-		assert(!write_zone_idx ||
-		       write_zone_idx < zbdi->num_write_zones);
-		tmp_idx = write_zone_idx;
-
-		for (i = 0; i < zbdi->num_write_zones; i++) {
-			uint32_t tmpz;
-
-			if (tmp_idx >= zbdi->num_write_zones)
-				tmp_idx = 0;
-			tmpz = zbdi->write_zones[tmp_idx];
-			if (f->min_zone <= tmpz && tmpz < f->max_zone) {
-				write_zone_idx = tmp_idx;
-				goto found_candidate_zone;
-			}
-
-			tmp_idx++;
+		if (!zbd_pick_write_zone(f, io_u, &new_zone_idx)) {
+			dprint(FD_ZBD, "%s(%s): no candidate zone\n",
+			       __func__, f->file_name);
+			pthread_mutex_unlock(&zbdi->mutex);
+			if (z->has_wp)
+				zone_unlock(z);
+			return NULL;
 		}
 
-		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
-			__func__, f->file_name);
-
-		pthread_mutex_unlock(&zbdi->mutex);
-
-		if (z->has_wp)
-			zone_unlock(z);
-
-		return NULL;
-
-found_candidate_zone:
-		new_zone_idx = zbdi->write_zones[write_zone_idx];
 		if (new_zone_idx == zone_idx)
 			break;
 		zone_idx = new_zone_idx;
@@ -1569,6 +1612,7 @@ retry:
 
 	/* Check whether the write fits in any of the write target zones. */
 	pthread_mutex_lock(&zbdi->mutex);
+	need_zone_finish = true;
 	for (i = 0; i < zbdi->num_write_zones; i++) {
 		zone_idx = zbdi->write_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
@@ -1579,8 +1623,10 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (zbd_zone_remainder(z) >= min_bs)
+		if (zbd_zone_remainder(z) >= min_bs) {
+			need_zone_finish = false;
 			goto out;
+		}
 		pthread_mutex_lock(&zbdi->mutex);
 	}
 
@@ -1603,6 +1649,26 @@ retry:
 		goto retry;
 	}
 
+	if (td_random(td) && td->o.verify == VERIFY_NONE && need_zone_finish)
+		/*
+		 * If all open zones have remainder smaller than the block size
+		 * for random write jobs, choose one of the write target zones
+		 * and finish it. When verify is enabled, skip this zone finish
+		 * operation to avoid verify data corruption by overwrite to the
+		 * zone.
+		 */
+		if (zbd_pick_write_zone(f, io_u, &zone_idx)) {
+			pthread_mutex_unlock(&zbdi->mutex);
+			zone_unlock(z);
+			z = zbd_get_zone(f, zone_idx);
+			zone_lock(td, f, z);
+			io_u_quiesce(td);
+			dprint(FD_ZBD, "%s(%s): All write target zones have remainder smaller than block size. Choose zone %d and finish.\n",
+			       __func__, f->file_name, zone_idx);
+			zbd_finish_zone(td, f, z);
+			goto out;
+		}
+
 	pthread_mutex_unlock(&zbdi->mutex);
 
 	zone_unlock(z);
@@ -2047,40 +2113,11 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
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
