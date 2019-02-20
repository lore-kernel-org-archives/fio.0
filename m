Return-Path: <prvs=947609abe=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 6/8] zbd: Fix zone locking for async I/O engines
Date: Wed, 20 Feb 2019 16:17:23 +0900
Message-Id: <20190220071725.8487-7-damien.lemoal@wdc.com>
In-Reply-To: <20190220071725.8487-1-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

For a zoned block device with zonemode=zbd, the lock on the target zone
of an I/O is held from the time the I/O is prepared with
zbd_adjust_block() execution in fill_io_u() until the I/O is queued in
td_io_queue(). For a sync I/O engines, this means that the target zone
of an I/O operations is locked throughout the liftime of an I/O unit,
resulting in the serialization of write request preparation and
execution, as well as serialization of write operations and reset zone
operations for a zone, avoiding error inducing reordering.

However, in the case of an async I/O engine, the engine ->commit()
method falls outside of the zone lock serialization for all I/O units
that will be issued by the method execution. This results in potential
reordering of write requests during issuing, as well as simultaneous
queueing of write requests and zone reset operations resulting in
unaligned write errors.

For example, using a 1GB null_blk zoned device, the command:

fio --name=nullb0 --filename=/dev/nullb0 --direct=1 --zonemode=zbd
    --bs=4k --rw=randwrite --ioengine=libaio --group_reporting=1
    --iodepth=32 --numjobs=4

always fails due to unaligned write errors.

Fix this by refining the control over zone locking and unlocking.
Locking of an I/O target zone is unchanged and done in
zbd_adjust_block(), but the I/O callback function zbd_post_submit()
which updates a zone write pointer and unlocks the zone is split into
two different callbacks zbd_queue_io() and zbd_put_io().
zbd_queue_io() updates the zone write pointer for write operations and
unlocks the target zone only if the I/O operation was not queued or if
the I/O operation completed during the execution of the engine
->queue() method (e.g. a sync I/O engine is being used). The execution
of this I/O callback is done right after executing the I/O engine
->queue() method. The zbd_put_io() callback is used to unlock an I/O
target zone after completion of an I/O from within the put_io_u()
function.

To simplify the code the helper functions zbd_queue_io_u() and
zbd_put_io_u() which respectively call an io_u zbd_queue_io() and
zbd_put_io() callbacks are introduced. These helper functions are
conditionally defined only if CONFIG_LINUX_BLKZONED is set.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 io_u.c      | 10 ++-----
 io_u.h      | 17 +++++++++---
 ioengines.c |  6 ++---
 zbd.c       | 75 +++++++++++++++++++++++++++++++++++++++++------------
 zbd.h       | 22 ++++++++++++++++
 5 files changed, 98 insertions(+), 32 deletions(-)

diff --git a/io_u.c b/io_u.c
index bee99c37..910b7deb 100644
--- a/io_u.c
+++ b/io_u.c
@@ -775,10 +775,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	const bool needs_lock = td_async_processing(td);
 
-	if (io_u->post_submit) {
-		io_u->post_submit(io_u, io_u->error == 0);
-		io_u->post_submit = NULL;
-	}
+	zbd_put_io_u(io_u);
 
 	if (td->parent)
 		td = td->parent;
@@ -1340,10 +1337,7 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 		if (!fill_io_u(td, io_u))
 			break;
 
-		if (io_u->post_submit) {
-			io_u->post_submit(io_u, false);
-			io_u->post_submit = NULL;
-		}
+		zbd_put_io_u(io_u);
 
 		put_file_log(td, f);
 		td_io_close_file(td, f);
diff --git a/io_u.h b/io_u.h
index 97270c94..e75993bd 100644
--- a/io_u.h
+++ b/io_u.h
@@ -92,11 +92,22 @@ struct io_u {
 		struct workqueue_work work;
 	};
 
+#ifdef CONFIG_LINUX_BLKZONED
 	/*
-	 * Post-submit callback. Used by the ZBD code. @success == true means
-	 * that the I/O operation has been queued or completed successfully.
+	 * ZBD mode zbd_queue_io callback: called after engine->queue operation
+	 * to advance a zone write pointer and eventually unlock the I/O zone.
+	 * @q indicates the I/O queue status (busy, queued or completed).
+	 * @success == true means that the I/O operation has been queued or
+	 * completed successfully.
 	 */
-	void (*post_submit)(const struct io_u *, bool success);
+	void (*zbd_queue_io)(struct io_u *, int q, bool success);
+
+	/*
+	 * ZBD mode zbd_put_io callback: called in after completion of an I/O
+	 * or commit of an async I/O to unlock the I/O target zone.
+	 */
+	void (*zbd_put_io)(const struct io_u *);
+#endif
 
 	/*
 	 * Callback for io completion
diff --git a/ioengines.c b/ioengines.c
index 45e769e6..7e5a50cc 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -329,10 +329,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	ret = td->io_ops->queue(td, io_u);
-	if (ret != FIO_Q_BUSY && io_u->post_submit) {
-		io_u->post_submit(io_u, io_u->error == 0);
-		io_u->post_submit = NULL;
-	}
+	zbd_queue_io_u(io_u, ret);
 
 	unlock_file(td, io_u->file);
 
@@ -374,6 +371,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (!td->io_ops->commit) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
+		zbd_put_io_u(io_u);
 	}
 
 	if (ret == FIO_Q_COMPLETED) {
diff --git a/zbd.c b/zbd.c
index 9b603b97..310b1732 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1111,37 +1111,44 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	return NULL;
 }
 
-
 /**
- * zbd_post_submit - update the write pointer and unlock the zone lock
+ * zbd_queue_io - update the write pointer of a sequential zone
  * @io_u: I/O unit
- * @success: Whether or not the I/O unit has been executed successfully
+ * @success: Whether or not the I/O unit has been queued successfully
+ * @q: queueing status (busy, completed or queued).
  *
- * For write and trim operations, update the write pointer of all affected
- * zones.
+ * For write and trim operations, update the write pointer of the I/O unit
+ * target zone.
  */
-static void zbd_post_submit(const struct io_u *io_u, bool success)
+static void zbd_queue_io(struct io_u *io_u, int q, bool success)
 {
-	struct zoned_block_device_info *zbd_info;
+	const struct fio_file *f = io_u->file;
+	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
 	uint32_t zone_idx;
-	uint64_t end, zone_end;
+	uint64_t zone_end;
 
-	zbd_info = io_u->file->zbd_info;
 	if (!zbd_info)
 		return;
 
-	zone_idx = zbd_zone_idx(io_u->file, io_u->offset);
-	end = io_u->offset + io_u->buflen;
-	z = &zbd_info->zone_info[zone_idx];
+	zone_idx = zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
+	z = &zbd_info->zone_info[zone_idx];
+
 	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
 		return;
+
 	if (!success)
 		goto unlock;
+
+	dprint(FD_ZBD,
+	       "%s: queued I/O (%lld, %llu) for zone %u\n",
+	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
-		zone_end = min(end, (z + 1)->start);
+		zone_end = min((uint64_t)(io_u->offset + io_u->buflen),
+			       (z + 1)->start);
 		pthread_mutex_lock(&zbd_info->mutex);
 		/*
 		 * z->wp > zone_end means that one or more I/O errors
@@ -1158,10 +1165,42 @@ static void zbd_post_submit(const struct io_u *io_u, bool success)
 	default:
 		break;
 	}
+
 unlock:
-	pthread_mutex_unlock(&z->mutex);
+	if (!success || q != FIO_Q_QUEUED) {
+		/* BUSY or COMPLETED: unlock the zone */
+		pthread_mutex_unlock(&z->mutex);
+		io_u->zbd_put_io = NULL;
+	}
+}
+
+/**
+ * zbd_put_io - Unlock an I/O unit target zone lock
+ * @io_u: I/O unit
+ */
+static void zbd_put_io(const struct io_u *io_u)
+{
+	const struct fio_file *f = io_u->file;
+	struct zoned_block_device_info *zbd_info = f->zbd_info;
+	struct fio_zone_info *z;
+	uint32_t zone_idx;
+
+	if (!zbd_info)
+		return;
 
-	zbd_check_swd(io_u->file);
+	zone_idx = zbd_zone_idx(f, io_u->offset);
+	assert(zone_idx < zbd_info->nr_zones);
+	z = &zbd_info->zone_info[zone_idx];
+
+	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+		return;
+
+	dprint(FD_ZBD,
+	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
+	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+
+	assert(pthread_mutex_unlock(&z->mutex) == 0);
+	zbd_check_swd(f);
 }
 
 bool zbd_unaligned_write(int error_code)
@@ -1354,8 +1393,10 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 accept:
 	assert(zb);
 	assert(zb->cond != BLK_ZONE_COND_OFFLINE);
-	assert(!io_u->post_submit);
-	io_u->post_submit = zbd_post_submit;
+	assert(!io_u->zbd_queue_io);
+	assert(!io_u->zbd_put_io);
+	io_u->zbd_queue_io = zbd_queue_io;
+	io_u->zbd_put_io = zbd_put_io;
 	return io_u_accept;
 
 eof:
diff --git a/zbd.h b/zbd.h
index 33e6d8bd..521283b2 100644
--- a/zbd.h
+++ b/zbd.h
@@ -96,6 +96,24 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
+
+static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
+{
+	if (io_u->zbd_queue_io) {
+		io_u->zbd_queue_io(io_u, status, io_u->error == 0);
+		io_u->zbd_queue_io = NULL;
+	}
+}
+
+static inline void zbd_put_io_u(struct io_u *io_u)
+{
+	if (io_u->zbd_put_io) {
+		io_u->zbd_put_io(io_u);
+		io_u->zbd_queue_io = NULL;
+		io_u->zbd_put_io = NULL;
+	}
+}
+
 #else
 static inline void zbd_free_zone_info(struct fio_file *f)
 {
@@ -125,6 +143,10 @@ static inline char *zbd_write_status(const struct thread_stat *ts)
 {
 	return NULL;
 }
+
+static inline void zbd_queue_io_u(struct io_u *io_u,
+				  enum fio_q_status status) {}
+static inline void zbd_put_io_u(struct io_u *io_u) {}
 #endif
 
 #endif /* FIO_ZBD_H */
-- 
2.20.1


