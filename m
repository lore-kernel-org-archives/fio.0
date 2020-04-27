Return-Path: <prvs=379927889=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4/5] zbd: Introduce file zbd operations
Date: Mon, 27 Apr 2020 14:51:13 +0900
Message-Id: <20200427055115.107909-5-damien.lemoal@wdc.com>
In-Reply-To: <20200427055115.107909-1-damien.lemoal@wdc.com>
References: <20200427055115.107909-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Use a pointer to a function for implementing zbd_file_reset()
as an inline function resulting in an actual zbd function call only if
necessary, that is, if zonemode is "zbd" and the thread is writing.
This change also allows optimizing zbd_reset_file() (renamed from
zbd_file_reset()) to be a nop for read-only jobs, avoiding a costly
scan of all zones in the job access range.

Similarly change zbd_free_zone_info() too, renaming it as
zbd_file_close().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 file.h      |  5 +++-
 filesetup.c |  2 +-
 zbd.c       | 66 ++++++++++++++++++++++++++++-------------------------
 zbd.h       | 14 ++++++++++--
 4 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/file.h b/file.h
index ae0e6fc8..8a301d37 100644
--- a/file.h
+++ b/file.h
@@ -12,6 +12,7 @@
 
 /* Forward declarations */
 struct zoned_block_device_info;
+struct thread_data;
 
 /*
  * The type of object we are working on
@@ -101,9 +102,11 @@ struct fio_file {
 	uint64_t io_size;
 
 	/*
-	 * Zoned block device information. See also zonemode=zbd.
+	 * Zoned block device information and operations. See also zonemode=zbd.
 	 */
 	struct zoned_block_device_info *zbd_info;
+	void (*zbd_reset)(struct thread_data *, struct fio_file *);
+	void (*zbd_close)(struct fio_file *);
 
 	/*
 	 * Track last end and last start of IO for a given data direction
diff --git a/filesetup.c b/filesetup.c
index 8a4091fc..9f994c93 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1469,7 +1469,7 @@ void close_and_free_files(struct thread_data *td)
 			td_io_unlink_file(td, f);
 		}
 
-		zbd_free_zone_info(f);
+		zbd_file_close(f);
 
 		if (use_free)
 			free(f->file_name);
diff --git a/zbd.c b/zbd.c
index c30454b9..078d93a4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -542,7 +542,7 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 	return ret;
 }
 
-void zbd_free_zone_info(struct fio_file *f)
+static void zbd_close_file(struct fio_file *f)
 {
 	uint32_t refcount;
 
@@ -592,30 +592,6 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 	return ret;
 }
 
-int zbd_init(struct thread_data *td)
-{
-	struct fio_file *f;
-	int i;
-
-	for_each_file(td, f, i) {
-		if (zbd_init_zone_info(td, f))
-			return 1;
-	}
-
-	if (!zbd_using_direct_io()) {
-		log_err("Using direct I/O is mandatory for writing to ZBD drives\n\n");
-		return 1;
-	}
-
-	if (!zbd_verify_sizes())
-		return 1;
-
-	if (!zbd_verify_bs())
-		return 1;
-
-	return 0;
-}
-
 /**
  * zbd_reset_range - reset zones for a range of sectors
  * @td: FIO thread data.
@@ -743,8 +719,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 			reset_wp = z->wp != z->start;
 		} else {
-			reset_wp = (td->o.td_ddir & TD_DDIR_WRITE) &&
-					z->wp % min_bs != 0;
+			reset_wp = z->wp % min_bs != 0;
 		}
 		if (reset_wp) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
@@ -851,13 +826,12 @@ static void zbd_init_swd(struct fio_file *f)
 	       swd);
 }
 
-void zbd_file_reset(struct thread_data *td, struct fio_file *f)
+static void zbd_reset_file(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
 	uint32_t zone_idx_e;
 
-	if (!f->zbd_info)
-		return;
+	assert(td_write(td) && f->zbd_info);
 
 	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
 	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size);
@@ -869,7 +843,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing data, which causes data loss.
 	 */
 	zbd_reset_zones(td, f, zb, ze, td->o.verify != VERIFY_NONE &&
-			(td->o.td_ddir & TD_DDIR_WRITE) &&
 			td->runstate != TD_VERIFYING);
 	zbd_reset_write_cnt(td, f);
 }
@@ -1565,3 +1538,34 @@ char *zbd_write_status(const struct thread_stat *ts)
 		return NULL;
 	return res;
 }
+
+int zbd_init(struct thread_data *td)
+{
+	struct fio_file *f;
+	int i;
+
+	for_each_file(td, f, i) {
+		if (zbd_init_zone_info(td, f))
+			return 1;
+		if (!f->zbd_info)
+			continue;
+
+		/* Set file operations */
+		f->zbd_close = zbd_close_file;
+		if (td_write(td))
+			f->zbd_reset = zbd_reset_file;
+	}
+
+	if (!zbd_using_direct_io()) {
+		log_err("Using direct I/O is mandatory for writing to ZBD drives\n\n");
+		return 1;
+	}
+
+	if (!zbd_verify_sizes())
+		return 1;
+
+	if (!zbd_verify_bs())
+		return 1;
+
+	return 0;
+}
diff --git a/zbd.h b/zbd.h
index 5a660399..550d7a99 100644
--- a/zbd.h
+++ b/zbd.h
@@ -77,9 +77,7 @@ struct zoned_block_device_info {
 	struct fio_zone_info	zone_info[0];
 };
 
-void zbd_free_zone_info(struct fio_file *f);
 int zbd_init(struct thread_data *td);
-void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
 void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);
 enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
@@ -87,6 +85,18 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 
+static inline void zbd_file_reset(struct thread_data *td, struct fio_file *f)
+{
+	if (f->zbd_reset)
+		f->zbd_reset(td, f);
+}
+
+static inline void zbd_file_close(struct fio_file *f)
+{
+	if (f->zbd_close)
+		f->zbd_close(f);
+}
+
 static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
 {
 	if (io_u->zbd_queue_io) {
-- 
2.25.4


