Return-Path: <prvs=36634da1a=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] zbd: Fix I/O direction adjustment step for random read/write
Date: Tue, 14 Apr 2020 19:00:17 +0900
Message-Id: <20200414100017.266406-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Commit fb0259fb ("zbd: Ensure first I/O is write for random read/write to
sequential zones") introduced a step to change direction of io_u from
read to write when that is the first I/O of the random read/write
workload to zoned block devices. However, such direction adjustment
results in inconsistent I/O length when read block size and write block
size are different.

To avoid the inconsistency between I/O direction and I/O length,
adjust the I/O direction before the I/O length is set. Move the step
from zbd_adjust_block() to set_rw_ddir(). To minimize changes in
set_rw_ddir(), introduce zbd_adjust_ddir() helper function.

Fixes: fb0259fb ("zbd: Ensure first I/O is write for random read/write to sequential zones")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 io_u.c |  2 ++
 zbd.c  | 34 ++++++++++++++++++++++++----------
 zbd.h  |  2 ++
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/io_u.c b/io_u.c
index 5d62a76c..234dd268 100644
--- a/io_u.c
+++ b/io_u.c
@@ -746,6 +746,8 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 {
 	enum fio_ddir ddir = get_rw_ddir(td);
 
+	zbd_adjust_ddir(td, io_u, &ddir);
+
 	if (td_trimwrite(td)) {
 		struct fio_file *f = io_u->file;
 		if (f->last_pos[DDIR_WRITE] == f->last_pos[DDIR_TRIM])
diff --git a/zbd.c b/zbd.c
index de0c5bf4..82810511 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1331,6 +1331,30 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	}
 }
 
+/**
+ * zbd_adjust_ddir - Adjust the I/O direction to zoned block devices.
+ *
+ * @td: FIO thread data.
+ * @io_u: FIO I/O unit.
+ * @ddir: Data direction to adjust.
+ */
+void zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
+		     enum fio_ddir *ddir)
+{
+	/*
+	 * In case read direction is chosen for the first random I/O, fio with
+	 * zonemode=zbd stops because no data can be read from zoned block
+	 * devices with all empty zones. Overwrite the first I/O direction as
+	 * write to make sure data to read exists.
+	 */
+	if (td->o.zone_mode == ZONE_MODE_ZBD &&
+	    td_rw(td) &&
+	    *ddir == DDIR_READ &&
+	    !io_u->file->zbd_info->sectors_with_data &&
+	    !td->o.read_beyond_wp)
+		*ddir = DDIR_WRITE;
+}
+
 /**
  * zbd_adjust_block - adjust the offset and length as necessary for ZBD drives
  * @td: FIO thread data.
@@ -1364,16 +1388,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	if (!zbd_zone_swr(zb))
 		return io_u_accept;
 
-	/*
-	 * In case read direction is chosen for the first random I/O, fio with
-	 * zonemode=zbd stops because no data can be read from zoned block
-	 * devices with all empty zones. Overwrite the first I/O direction as
-	 * write to make sure data to read exists.
-	 */
-	if (td_rw(td) && !f->zbd_info->sectors_with_data
-	    && !td->o.read_beyond_wp)
-		io_u->ddir = DDIR_WRITE;
-
 	/*
 	 * Accept the I/O offset for reads if reading beyond the write pointer
 	 * is enabled.
diff --git a/zbd.h b/zbd.h
index 4eaf902e..196853ab 100644
--- a/zbd.h
+++ b/zbd.h
@@ -82,6 +82,8 @@ int zbd_init(struct thread_data *td);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
 void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);
+void zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
+		     enum fio_ddir *ddir);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 
-- 
2.25.1


