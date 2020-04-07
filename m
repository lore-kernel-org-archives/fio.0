Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46110 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgDGMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Apr 2020 08:00:05 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLmtf-000841-41
        for fio@vger.kernel.org; Tue, 07 Apr 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200407120001.A674E1BC0194@kernel.dk>
Date: Tue,  7 Apr 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6463db6c1d3a2a961008e87a86d464b596886f1a:

  fio: fix interaction between offset/size limited threads and "max_open_zones" (2020-04-02 13:33:49 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ebc403fe282864eddfd68ab1793f149a1b0eb1cd:

  zbd: fixup ->zone_size_log2 if zone size is not power of 2 (2020-04-06 19:41:45 -0600)

----------------------------------------------------------------
Alexey Dobriyan (1):
      zbd: fixup ->zone_size_log2 if zone size is not power of 2

Damien Le Moal (1):
      zbd: Fix potential zone lock deadlock

 zbd.c | 64 ++++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index 0dd5a619..e2f3f52f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -58,6 +58,24 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 		z->wp + required > z->start + f->zbd_info->zone_size;
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
 static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
 {
 	return (uint64_t)(offset - f->file_offset) < f->io_size;
@@ -380,7 +398,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
-		ilog2(zone_size) : -1;
+		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
 	pthread_mutexattr_destroy(&attr);
 	return 0;
@@ -497,7 +515,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
-		ilog2(zone_size) : -1;
+		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
 	zbd_info = NULL;
 	ret = 0;
@@ -716,18 +734,18 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
 	assert(f->fd != -1);
 	for (z = zb; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
-		if (z->type == BLK_ZONE_TYPE_SEQWRITE_REQ) {
-			reset_wp = all_zones ? z->wp != z->start :
-					(td->o.td_ddir & TD_DDIR_WRITE) &&
-					z->wp % min_bs != 0;
-			if (reset_wp) {
-				dprint(FD_ZBD, "%s: resetting zone %u\n",
-				       f->file_name,
-				       zbd_zone_nr(f->zbd_info, z));
-				if (zbd_reset_zone(td, f, z) < 0)
-					res = 1;
-			}
+		if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+			continue;
+		zone_lock(td, z);
+		reset_wp = all_zones ? z->wp != z->start :
+				(td->o.td_ddir & TD_DDIR_WRITE) &&
+				z->wp % min_bs != 0;
+		if (reset_wp) {
+			dprint(FD_ZBD, "%s: resetting zone %u\n",
+			       f->file_name,
+			       zbd_zone_nr(f->zbd_info, z));
+			if (zbd_reset_zone(td, f, z) < 0)
+				res = 1;
 		}
 		pthread_mutex_unlock(&z->mutex);
 	}
@@ -927,24 +945,6 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 	f->zbd_info->zone_info[zone_idx].open = 0;
 }
 
-static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
-{
-	/*
-	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
-	 * is changed or when io_u completes and zbd_put_io() executed.
-	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
-	 * other waiting for zone locks when building an io_u batch, first
-	 * only trylock the zone. If the zone is already locked by another job,
-	 * process the currently queued I/Os so that I/O progress is made and
-	 * zones unlocked.
-	 */
-	if (pthread_mutex_trylock(&z->mutex) != 0) {
-		if (!td_ioengine_flagged(td, FIO_SYNCIO))
-			io_u_quiesce(td);
-		pthread_mutex_lock(&z->mutex);
-	}
-}
-
 /* Anything goes as long as it is not a constant. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)

