Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgHNMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Aug 2020 08:00:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C1AC061384
        for <fio@vger.kernel.org>; Fri, 14 Aug 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k6YNQ-0000Nj-GQ
        for fio@vger.kernel.org; Fri, 14 Aug 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200814120001.DADB61BC01B5@kernel.dk>
Date: Fri, 14 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 84abeef7d9f2f5cded36dcfc127b3f33db89ea57:

  io_u: calculate incremental residuals correctly (2020-08-12 11:48:15 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5c79c32f6afb39fae910912475e8fea786c3353e:

  zbd: use ->min_zone, ->max_zone in more places (2020-08-13 16:06:29 -0600)

----------------------------------------------------------------
Alexey Dobriyan (1):
      zbd: use ->min_zone, ->max_zone in more places

 zbd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index e4a480b7..5af8af4a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -319,6 +319,7 @@ static bool zbd_verify_sizes(void)
 
 			f->min_zone = zbd_zone_idx(f, f->file_offset);
 			f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
+			assert(f->min_zone < f->max_zone);
 		}
 	}
 
@@ -839,9 +840,8 @@ static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t swd = 0;
 
-	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
-	ze = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset +
-						  f->io_size)];
+	zb = &f->zbd_info->zone_info[f->min_zone];
+	ze = &f->zbd_info->zone_info[f->max_zone];
 	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
 		swd += z->wp - z->start;
@@ -1175,7 +1175,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z1, *z2;
 	const struct fio_zone_info *const zf =
-		&f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
+		&f->zbd_info->zone_info[f->min_zone];
 
 	/*
 	 * Skip to the next non-empty zone in case of sequential I/O and to
@@ -1482,8 +1482,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
 			pthread_mutex_unlock(&zb->mutex);
-			zl = &f->zbd_info->zone_info[zbd_zone_idx(f,
-						f->file_offset + f->io_size)];
+			zl = &f->zbd_info->zone_info[f->max_zone];
 			zb = zbd_find_zone(td, io_u, zb, zl);
 			if (!zb) {
 				dprint(FD_ZBD,

