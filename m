Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35884 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbeI0SSZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Sep 2018 14:18:25 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g5Uxk-0006yu-Fj
        for fio@vger.kernel.org; Thu, 27 Sep 2018 12:00:27 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180927120001.A77072C031B@kernel.dk>
Date: Thu, 27 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7676a1c25fcdacfe27d84a0f86fe68077b7de79a:

  parse: fix negative FIO_OPT_INT too-large check (2018-09-25 20:15:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d60be7d51cbb601cc59dccc9f2a418072046a985:

  zbd: Remove unused function and variable (2018-09-26 08:26:01 -0600)

----------------------------------------------------------------
Damien Le Moal (2):
      eta: Avoid adjustements to a negative value
      zbd: Remove unused function and variable

 eta.c | 21 ++++++++++++++++++---
 zbd.c | 31 ++-----------------------------
 2 files changed, 20 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/eta.c b/eta.c
index 970a67d..b69dd19 100644
--- a/eta.c
+++ b/eta.c
@@ -177,12 +177,27 @@ static unsigned long thread_eta(struct thread_data *td)
 		bytes_total = td->fill_device_size;
 	}
 
-	if (td->o.zone_size && td->o.zone_skip && bytes_total) {
+	/*
+	 * If io_size is set, bytes_total is an exact value that does not need
+	 * adjustment.
+	 */
+	if (td->o.zone_size && td->o.zone_skip && bytes_total &&
+	    !fio_option_is_set(&td->o, io_size)) {
 		unsigned int nr_zones;
 		uint64_t zone_bytes;
 
-		zone_bytes = bytes_total + td->o.zone_size + td->o.zone_skip;
-		nr_zones = (zone_bytes - 1) / (td->o.zone_size + td->o.zone_skip);
+		/*
+		 * Calculate the upper bound of the number of zones that will
+		 * be processed, including skipped bytes between zones. If this
+		 * is larger than total_io_size (e.g. when --io_size or --size
+		 * specify a small value), use the lower bound to avoid
+		 * adjustments to a negative value that would result in a very
+		 * large bytes_total and an incorrect eta.
+		 */
+		zone_bytes = td->o.zone_size + td->o.zone_skip;
+		nr_zones = (bytes_total + zone_bytes - 1) / zone_bytes;
+		if (bytes_total < nr_zones * td->o.zone_skip)
+			nr_zones = bytes_total / zone_bytes;
 		bytes_total -= nr_zones * td->o.zone_skip;
 	}
 
diff --git a/zbd.c b/zbd.c
index 9c3092a..9c52587 100644
--- a/zbd.c
+++ b/zbd.c
@@ -620,12 +620,10 @@ static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
 static int zbd_reset_zone(struct thread_data *td, const struct fio_file *f,
 			  struct fio_zone_info *z)
 {
-	int ret;
-
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, z));
-	ret = zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
-	return ret;
+
+	return zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
 }
 
 /*
@@ -728,29 +726,6 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
-/* Check whether the value of zbd_info.sectors_with_data is correct. */
-static void check_swd(const struct thread_data *td, const struct fio_file *f)
-{
-#if 0
-	struct fio_zone_info *zb, *ze, *z;
-	uint64_t swd;
-
-	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
-	ze = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset +
-						  f->io_size)];
-	swd = 0;
-	for (z = zb; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
-		swd += z->wp - z->start;
-	}
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	assert(f->zbd_info->sectors_with_data == swd);
-	pthread_mutex_unlock(&f->zbd_info->mutex);
-	for (z = zb; z < ze; z++)
-		pthread_mutex_unlock(&z->mutex);
-#endif
-}
-
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze, *z;
@@ -1227,7 +1202,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			check_swd(td, f);
 			if (f->zbd_info->sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
@@ -1248,7 +1222,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb->reset_zone = 0;
 			if (zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
-			check_swd(td, f);
 		}
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));

