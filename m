Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57640 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgCRMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Mar 2020 08:00:08 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEXMj-0001Wh-Mb
        for fio@vger.kernel.org; Wed, 18 Mar 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200318120001.F0E821BC0186@kernel.dk>
Date: Wed, 18 Mar 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5e8865c0e08861558c1253c521dc9098d0c773ee:

  t/io_uring: don't use *rand48_r() variants (2020-03-16 08:30:36 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3bd2078bdd1c173f9d02bc20e2d630302555a8a0:

  zbd: add test for stressing zone locking (2020-03-17 20:05:54 -0600)

----------------------------------------------------------------
Feng Tang (1):
      gauss.c: correct the stddev initializtion

Naohiro Aota (6):
      zbd: avoid initializing swd when unnecessary
      zbd: reset one zone at a time
      zbd: use zone_lock to lock a zone
      backend: always clean up pending aios
      io_u: ensure io_u_quiesce() to process all the IOs
      zbd: add test for stressing zone locking

 backend.c              |  5 ---
 io_u.c                 |  6 ++--
 lib/gauss.c            |  2 +-
 t/zbd/test-zbd-support | 30 ++++++++++++++++++
 zbd.c                  | 84 +++++++++++++++++++-------------------------------
 5 files changed, 66 insertions(+), 61 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 936203dc..feb34e51 100644
--- a/backend.c
+++ b/backend.c
@@ -237,15 +237,10 @@ static void cleanup_pending_aio(struct thread_data *td)
 {
 	int r;
 
-	if (td->error)
-		return;
-
 	/*
 	 * get immediately available events, if any
 	 */
 	r = io_u_queued_complete(td, 0);
-	if (r < 0)
-		return;
 
 	/*
 	 * now cancel remaining active events
diff --git a/io_u.c b/io_u.c
index bcb893c5..5d62a76c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -606,7 +606,7 @@ static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 
 int io_u_quiesce(struct thread_data *td)
 {
-	int ret = 0, completed = 0;
+	int ret = 0, completed = 0, err = 0;
 
 	/*
 	 * We are going to sleep, ensure that we flush anything pending as
@@ -625,7 +625,7 @@ int io_u_quiesce(struct thread_data *td)
 		if (ret > 0)
 			completed += ret;
 		else if (ret < 0)
-			break;
+			err = ret;
 	}
 
 	if (td->flags & TD_F_REGROW_LOGS)
@@ -634,7 +634,7 @@ int io_u_quiesce(struct thread_data *td)
 	if (completed)
 		return completed;
 
-	return ret;
+	return err;
 }
 
 static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
diff --git a/lib/gauss.c b/lib/gauss.c
index 1d24e187..3f84dbc6 100644
--- a/lib/gauss.c
+++ b/lib/gauss.c
@@ -51,7 +51,7 @@ void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
 	gs->nranges = nranges;
 
 	if (dev != 0.0) {
-		gs->stddev = ceil((double) (nranges * 100.0) / dev);
+		gs->stddev = ceil((double)(nranges * dev) / 100.0);
 		if (gs->stddev > nranges / 2)
 			gs->stddev = nranges / 2;
 	}
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 5d079a8b..bd41fffb 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -755,6 +755,36 @@ test47() {
     grep -q 'zoneskip 1 is not a multiple of the device zone size' "${logfile}.${test_number}"
 }
 
+# Multiple overlapping random write jobs for the same drive and with a
+# limited number of open zones. This is similar to test29, but uses libaio
+# to stress test zone locking.
+test48() {
+    local i jobs=16 off opts=()
+
+    off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
+    size=$((16*zone_size))
+    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    opts=("--aux-path=/tmp" "--allow_file_create=0" "--significant_figures=10")
+    opts+=("--debug=zbd")
+    opts+=("--ioengine=libaio" "--rw=randwrite" "--direct=1")
+    opts+=("--time_based" "--runtime=30")
+    opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+    opts+=("--max_open_zones=4")
+    for ((i=0;i<jobs;i++)); do
+	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
+	opts+=("--io_size=$zone_size" "--iodepth=256" "--thread=1")
+	opts+=("--group_reporting=1")
+    done
+
+    fio=$(dirname "$0")/../../fio
+
+    { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
+
+    timeout -v -s KILL 45s \
+	    "${dynamic_analyzer[@]}" "$fio" "${opts[@]}" \
+	    >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
diff --git a/zbd.c b/zbd.c
index ee8bcb30..b2d94249 100644
--- a/zbd.c
+++ b/zbd.c
@@ -707,7 +707,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			   struct fio_zone_info *const zb,
 			   struct fio_zone_info *const ze, bool all_zones)
 {
-	struct fio_zone_info *z, *start_z = ze;
+	struct fio_zone_info *z;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 	bool reset_wp;
 	int res = 0;
@@ -717,48 +717,20 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	assert(f->fd != -1);
 	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
-		switch (z->type) {
-		case BLK_ZONE_TYPE_SEQWRITE_REQ:
+		if (z->type == BLK_ZONE_TYPE_SEQWRITE_REQ) {
 			reset_wp = all_zones ? z->wp != z->start :
 					(td->o.td_ddir & TD_DDIR_WRITE) &&
 					z->wp % min_bs != 0;
-			if (start_z == ze && reset_wp) {
-				start_z = z;
-			} else if (start_z < ze && !reset_wp) {
-				dprint(FD_ZBD,
-				       "%s: resetting zones %u .. %u\n",
+			if (reset_wp) {
+				dprint(FD_ZBD, "%s: resetting zone %u\n",
 				       f->file_name,
-					zbd_zone_nr(f->zbd_info, start_z),
-					zbd_zone_nr(f->zbd_info, z));
-				if (zbd_reset_range(td, f, start_z->start,
-						z->start - start_z->start) < 0)
+				       zbd_zone_nr(f->zbd_info, z));
+				if (zbd_reset_zone(td, f, z) < 0)
 					res = 1;
-				start_z = ze;
 			}
-			break;
-		default:
-			if (start_z == ze)
-				break;
-			dprint(FD_ZBD, "%s: resetting zones %u .. %u\n",
-			       f->file_name, zbd_zone_nr(f->zbd_info, start_z),
-			       zbd_zone_nr(f->zbd_info, z));
-			if (zbd_reset_range(td, f, start_z->start,
-					    z->start - start_z->start) < 0)
-				res = 1;
-			start_z = ze;
-			break;
 		}
-	}
-	if (start_z < ze) {
-		dprint(FD_ZBD, "%s: resetting zones %u .. %u\n", f->file_name,
-			zbd_zone_nr(f->zbd_info, start_z),
-			zbd_zone_nr(f->zbd_info, z));
-		if (zbd_reset_range(td, f, start_z->start,
-				    z->start - start_z->start) < 0)
-			res = 1;
-	}
-	for (z = zb; z < ze; z++)
 		pthread_mutex_unlock(&z->mutex);
+	}
 
 	return res;
 }
@@ -847,6 +819,9 @@ static void zbd_init_swd(struct fio_file *f)
 {
 	uint64_t swd;
 
+	if (!enable_check_swd)
+		return;
+
 	swd = zbd_process_swd(f, SET_SWD);
 	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
 	       swd);
@@ -952,6 +927,24 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 	f->zbd_info->zone_info[zone_idx].open = 0;
 }
 
+static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
+{
+	/*
+	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
+	 * is changed or when io_u completes and zbd_put_io() executed.
+	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
+	 * other waiting for zone locks when building an io_u batch, first
+	 * only trylock the zone. If the zone is already locked by another job,
+	 * process the currently queued I/Os so that I/O progress is made and
+	 * zones unlocked.
+	 */
+	if (pthread_mutex_trylock(&z->mutex) != 0) {
+		if (!td_ioengine_flagged(td, FIO_SYNCIO))
+			io_u_quiesce(td);
+		pthread_mutex_lock(&z->mutex);
+	}
+}
+
 /*
  * Modify the offset of an I/O unit that does not refer to an open zone such
  * that it refers to an open zone. Close an open zone and open a new zone if
@@ -994,7 +987,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	for (;;) {
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		pthread_mutex_lock(&z->mutex);
+		zone_lock(td, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		if (td->o.max_open_zones == 0)
 			goto examine_zone;
@@ -1042,7 +1035,7 @@ examine_zone:
 			z = &f->zbd_info->zone_info[zone_idx];
 		}
 		assert(is_valid_offset(f, z->start));
-		pthread_mutex_lock(&z->mutex);
+		zone_lock(td, z);
 		if (z->open)
 			continue;
 		if (zbd_open_zone(td, io_u, zone_idx))
@@ -1060,7 +1053,7 @@ examine_zone:
 
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		pthread_mutex_lock(&z->mutex);
+		zone_lock(td, z);
 		if (z->wp + min_bs <= (z+1)->start)
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
@@ -1346,20 +1339,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	zbd_check_swd(f);
 
-	/*
-	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
-	 * is changed or when io_u completes and zbd_put_io() executed.
-	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
-	 * other waiting for zone locks when building an io_u batch, first
-	 * only trylock the zone. If the zone is already locked by another job,
-	 * process the currently queued I/Os so that I/O progress is made and
-	 * zones unlocked.
-	 */
-	if (pthread_mutex_trylock(&zb->mutex) != 0) {
-		if (!td_ioengine_flagged(td, FIO_SYNCIO))
-			io_u_quiesce(td);
-		pthread_mutex_lock(&zb->mutex);
-	}
+	zone_lock(td, zb);
 
 	switch (io_u->ddir) {
 	case DDIR_READ:

