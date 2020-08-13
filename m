Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Thu, 13 Aug 2020 19:36:32 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] zbd: use ->min_zone, ->max_zone in more places
Message-ID: <20200813163632.GB26072@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com
List-ID: <fio@vger.kernel.org>

Check that ->min_zone is less than ->max_zone.
This assert found one bug here.

Use it in more places, now that it was added.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 zbd.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

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

