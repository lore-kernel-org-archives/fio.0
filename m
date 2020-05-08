Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22452 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgEHH4u (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 May 2020 03:56:50 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 5/7] zbd: Rename zbd_init()
Date: Fri,  8 May 2020 16:56:43 +0900
Message-Id: <20200508075645.543890-6-damien.lemoal@wdc.com>
In-Reply-To: <20200508075645.543890-1-damien.lemoal@wdc.com>
References: <20200508075645.543890-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

Clarify the execution context of zbd_init() by renaming this function
to zbd_setup_files() as it is called from the setup_files() function.
While at it, wrap the use of zbd_free_zone_info() into the inline
function zbd_close_file() to avoid an unecessary function call when
closing files that are not zoned block device files of zonemode=zbd
jobs, that is, files that do not have zbd_info initialized.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 filesetup.c | 4 ++--
 zbd.c       | 5 ++---
 zbd.h       | 8 +++++++-
 3 files changed, 11 insertions(+), 6 deletions(-)

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
diff --git a/zbd.c b/zbd.c
index a64fd0c7..db6d09f2 100644
--- a/zbd.c
+++ b/zbd.c
@@ -546,8 +546,7 @@ void zbd_free_zone_info(struct fio_file *f)
 {
 	uint32_t refcount;
 
-	if (!f->zbd_info)
-		return;
+	assert(f->zbd_info);
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	refcount = --f->zbd_info->refcount;
@@ -592,7 +591,7 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 	return ret;
 }
 
-int zbd_init(struct thread_data *td)
+int zbd_setup_files(struct thread_data *td)
 {
 	struct fio_file *f;
 	int i;
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
-- 
2.25.4


