Return-Path: <prvs=379927889=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5/5] zbd: Introduce thread zbd operations
Date: Mon, 27 Apr 2020 14:51:14 +0900
Message-Id: <20200427055115.107909-6-damien.lemoal@wdc.com>
In-Reply-To: <20200427055115.107909-1-damien.lemoal@wdc.com>
References: <20200427055115.107909-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

When zonemode is not "zbd", calls to the functions zbd_adjust_ddir()
and zbd_adjust_block() are not necessary. Avoid executing these
functions by redifining them as inline functions implemented using
thread operation function pointers that are defined only for
zonemode=zbd cases.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fio.h  |  8 ++++++++
 io_u.c |  8 +++-----
 zbd.c  | 14 ++++++++------
 zbd.h  | 19 ++++++++++++++++---
 4 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fio.h b/fio.h
index bbf057c1..77db656f 100644
--- a/fio.h
+++ b/fio.h
@@ -268,6 +268,14 @@ struct thread_data {
 
 	int shm_id;
 
+	/*
+	 * zonemode=zbd hooks for adjusting IOs.
+	 */
+	enum fio_ddir (*zbd_adjust_ddir)(struct thread_data *,
+					 struct io_u *, enum fio_ddir);
+	enum io_u_action (*zbd_adjust_block)(struct thread_data *,
+					     struct io_u *);
+
 	/*
 	 * IO engine hooks, contains everything needed to submit an io_u
 	 * to any of the available IO engines.
diff --git a/io_u.c b/io_u.c
index 18e94617..d93665d0 100644
--- a/io_u.c
+++ b/io_u.c
@@ -922,11 +922,9 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	}
 
 	offset = io_u->offset;
-	if (td->o.zone_mode == ZONE_MODE_ZBD) {
-		ret = zbd_adjust_block(td, io_u);
-		if (ret == io_u_eof)
-			return 1;
-	}
+	ret = zbd_adjust_block(td, io_u);
+	if (ret == io_u_eof)
+		return 1;
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
 		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
diff --git a/zbd.c b/zbd.c
index 078d93a4..96a5cf89 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1313,8 +1313,8 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
  *
  * Return adjusted I/O direction.
  */
-enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
-			      enum fio_ddir ddir)
+static enum fio_ddir zbd_adjust_io_ddir(struct thread_data *td,
+					struct io_u *io_u, enum fio_ddir ddir)
 {
 	/*
 	 * In case read direction is chosen for the first random I/O, fio with
@@ -1322,9 +1322,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	 * devices with all empty zones. Overwrite the first I/O direction as
 	 * write to make sure data to read exists.
 	 */
-	if (td->o.zone_mode != ZONE_MODE_ZBD ||
-	    ddir != DDIR_READ ||
-	    !td_rw(td))
+	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
 	if (io_u->file->zbd_info->sectors_with_data ||
@@ -1343,7 +1341,8 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
  * to a sequential zone and if io_u_accept is returned. z is the zone that
  * corresponds to io_u->offset at the end of this function.
  */
-enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
+static enum io_u_action zbd_adjust_io_block(struct thread_data *td,
+					    struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	uint32_t zone_idx_b;
@@ -1567,5 +1566,8 @@ int zbd_init(struct thread_data *td)
 	if (!zbd_verify_bs())
 		return 1;
 
+	td->zbd_adjust_ddir = zbd_adjust_io_ddir;
+	td->zbd_adjust_block = zbd_adjust_io_block;
+
 	return 0;
 }
diff --git a/zbd.h b/zbd.h
index 550d7a99..dfd5e947 100644
--- a/zbd.h
+++ b/zbd.h
@@ -80,9 +80,6 @@ struct zoned_block_device_info {
 int zbd_init(struct thread_data *td);
 bool zbd_unaligned_write(int error_code);
 void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);
-enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
-			      enum fio_ddir ddir);
-enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 
 static inline void zbd_file_reset(struct thread_data *td, struct fio_file *f)
@@ -97,6 +94,22 @@ static inline void zbd_file_close(struct fio_file *f)
 		f->zbd_close(f);
 }
 
+static inline enum fio_ddir zbd_adjust_ddir(struct thread_data *td,
+				    struct io_u *io_u, enum fio_ddir ddir)
+{
+	if (td->zbd_adjust_ddir)
+		return td->zbd_adjust_ddir(td, io_u, ddir);
+	return ddir;
+}
+
+static inline enum io_u_action zbd_adjust_block(struct thread_data *td,
+						struct io_u *io_u)
+{
+	if (td->zbd_adjust_block)
+		return td->zbd_adjust_block(td, io_u);
+	return io_u_accept;
+}
+
 static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
 {
 	if (io_u->zbd_queue_io) {
-- 
2.25.4


