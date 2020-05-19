Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36306 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgESMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 19 May 2020 08:00:09 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb0um-0006fu-JA
        for fio@vger.kernel.org; Tue, 19 May 2020 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200519120001.B58D61BC1055@kernel.dk>
Date: Tue, 19 May 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 723f9bc5fe77ae8bedc08ed3ec3a25426b48c096:

  Merge branch 'rados' of https://github.com/vincentkfu/fio (2020-05-14 11:47:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f09a7773f5821d5b89428419dcef1987ced39b67:

  Allow more flexibility in zone start and span (2020-05-18 16:56:00 -0600)

----------------------------------------------------------------
Damien Le Moal (7):
      iolog: Fix write_iolog_close()
      zbd: Fix potential deadlock on read operations
      zbd: Fix read with verify
      zbd: Optimize zbd_file_reset()
      zbd: Rename zbd_init()
      io_u: Optimize set_rw_ddir()
      t/zbd: Use max-jobs=16 option

Pierre Labat (1):
      Allow more flexibility in zone start and span

 filesetup.c            |  4 ++--
 io_u.c                 |  3 ++-
 iolog.c                |  3 +++
 t/zbd/test-zbd-support |  4 ++--
 zbd.c                  | 28 +++++++++++++---------------
 zbd.h                  |  8 +++++++-
 6 files changed, 29 insertions(+), 21 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 8a4091fc..49c54b81 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1268,7 +1268,7 @@ done:
 	td_restore_runstate(td, old_state);
 
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
-		err = zbd_init(td);
+		err = zbd_setup_files(td);
 		if (err)
 			goto err_out;
 	}
@@ -1469,7 +1469,7 @@ void close_and_free_files(struct thread_data *td)
 			td_io_unlink_file(td, f);
 		}
 
-		zbd_free_zone_info(f);
+		zbd_close_file(f);
 
 		if (use_free)
 			free(f->file_name);
diff --git a/io_u.c b/io_u.c
index 18e94617..aa8808b8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -746,7 +746,8 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 {
 	enum fio_ddir ddir = get_rw_ddir(td);
 
-	ddir = zbd_adjust_ddir(td, io_u, ddir);
+	if (td->o.zone_mode == ZONE_MODE_ZBD)
+		ddir = zbd_adjust_ddir(td, io_u, ddir);
 
 	if (td_trimwrite(td)) {
 		struct fio_file *f = io_u->file;
diff --git a/iolog.c b/iolog.c
index 917a446c..4a79fc46 100644
--- a/iolog.c
+++ b/iolog.c
@@ -342,6 +342,9 @@ void trim_io_piece(const struct io_u *io_u)
 
 void write_iolog_close(struct thread_data *td)
 {
+	if (!td->iolog_f)
+		return;
+
 	fflush(td->iolog_f);
 	fclose(td->iolog_f);
 	free(td->iolog_buf);
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index be889f34..de05f438 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -93,8 +93,8 @@ run_fio() {
 
     fio=$(dirname "$0")/../../fio
 
-    opts=("--aux-path=/tmp" "--allow_file_create=0" \
-			    "--significant_figures=10" "$@")
+    opts=("--max-jobs=16" "--aux-path=/tmp" "--allow_file_create=0" \
+	  "--significant_figures=10" "$@")
     opts+=(${var_opts[@]})
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
diff --git a/zbd.c b/zbd.c
index 8dc3c397..36de29fb 100644
--- a/zbd.c
+++ b/zbd.c
@@ -262,7 +262,8 @@ static bool zbd_verify_sizes(void)
 
 			zone_idx = zbd_zone_idx(f, f->file_offset);
 			z = &f->zbd_info->zone_info[zone_idx];
-			if (f->file_offset != z->start) {
+			if ((f->file_offset != z->start) &&
+			    (td->o.td_ddir != TD_DDIR_READ)) {
 				new_offset = (z+1)->start;
 				if (new_offset >= f->file_offset + f->io_size) {
 					log_info("%s: io_size must be at least one zone\n",
@@ -278,7 +279,8 @@ static bool zbd_verify_sizes(void)
 			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
 			z = &f->zbd_info->zone_info[zone_idx];
 			new_end = z->start;
-			if (f->file_offset + f->io_size != new_end) {
+			if ((td->o.td_ddir != TD_DDIR_READ) &&
+			    (f->file_offset + f->io_size != new_end)) {
 				if (new_end <= f->file_offset) {
 					log_info("%s: io_size must be at least one zone\n",
 						 f->file_name);
@@ -546,8 +548,7 @@ void zbd_free_zone_info(struct fio_file *f)
 {
 	uint32_t refcount;
 
-	if (!f->zbd_info)
-		return;
+	assert(f->zbd_info);
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	refcount = --f->zbd_info->refcount;
@@ -592,7 +593,7 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 	return ret;
 }
 
-int zbd_init(struct thread_data *td)
+int zbd_setup_files(struct thread_data *td)
 {
 	struct fio_file *f;
 	int i;
@@ -743,8 +744,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 			reset_wp = z->wp != z->start;
 		} else {
-			reset_wp = (td->o.td_ddir & TD_DDIR_WRITE) &&
-					z->wp % min_bs != 0;
+			reset_wp = z->wp % min_bs != 0;
 		}
 		if (reset_wp) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
@@ -856,7 +856,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *zb, *ze;
 	uint32_t zone_idx_e;
 
-	if (!f->zbd_info)
+	if (!f->zbd_info || !td_write(td))
 		return;
 
 	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
@@ -869,7 +869,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing data, which causes data loss.
 	 */
 	zbd_reset_zones(td, f, zb, ze, td->o.verify != VERIFY_NONE &&
-			(td->o.td_ddir & TD_DDIR_WRITE) &&
 			td->runstate != TD_VERIFYING);
 	zbd_reset_write_cnt(td, f);
 }
@@ -1141,7 +1140,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	 */
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
 		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
-			pthread_mutex_lock(&z1->mutex);
+			zone_lock(td, z1);
 			if (z1->start + min_bs <= z1->wp)
 				return z1;
 			pthread_mutex_unlock(&z1->mutex);
@@ -1150,7 +1149,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		}
 		if (td_random(td) && z2 >= zf &&
 		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
-			pthread_mutex_lock(&z2->mutex);
+			zone_lock(td, z2);
 			if (z2->start + min_bs <= z2->wp)
 				return z2;
 			pthread_mutex_unlock(&z2->mutex);
@@ -1349,9 +1348,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	 * devices with all empty zones. Overwrite the first I/O direction as
 	 * write to make sure data to read exists.
 	 */
-	if (td->o.zone_mode != ZONE_MODE_ZBD ||
-	    ddir != DDIR_READ ||
-	    !td_rw(td))
+	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
 	if (io_u->file->zbd_info->sectors_with_data ||
@@ -1409,7 +1406,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	switch (io_u->ddir) {
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING) {
-			zb = zbd_replay_write_order(td, io_u, zb);
+			if (td_write(td))
+				zb = zbd_replay_write_order(td, io_u, zb);
 			goto accept;
 		}
 		/*
diff --git a/zbd.h b/zbd.h
index 5a660399..e8dd3d6d 100644
--- a/zbd.h
+++ b/zbd.h
@@ -77,8 +77,8 @@ struct zoned_block_device_info {
 	struct fio_zone_info	zone_info[0];
 };
 
+int zbd_setup_files(struct thread_data *td);
 void zbd_free_zone_info(struct fio_file *f);
-int zbd_init(struct thread_data *td);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
 void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);
@@ -87,6 +87,12 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 
+static inline void zbd_close_file(struct fio_file *f)
+{
+	if (f->zbd_info)
+		zbd_free_zone_info(f);
+}
+
 static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
 {
 	if (io_u->zbd_queue_io) {

