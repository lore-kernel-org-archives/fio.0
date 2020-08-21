Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48369 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgHUGhn (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Aug 2020 02:37:43 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/7] zbd: Decrement open zones count at write command completion
Date: Fri, 21 Aug 2020 15:37:33 +0900
Message-Id: <20200821063739.390353-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
References: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

When max_open_zones or job_max_open_zones option is provided, fio counts
number of open zones. This open zone accounting is done during submission
of write commands. When write command is submitted to a zone for the
first time, the zone is counted as open. When a write command which will
fill the zone gets submitted, the zone is counted as closed. However,
this count at write command submission may open zones more than the
limit. When writes to zones more than the limit are submitted with high
queue depth, those writes in-flight open zones more than the limit.

To avoid such writes beyond max open zones limit, decrement number of
open zones count not at write command submission but at write command
completion. By doing this, the number of zones with in-flight write
commands are kept within the limit with accuracy. Introduce the helper
function zbd_end_zone_io() for this decrement and zbd_close_zone() call.

The zbd_close_zone() function requires thread_data argument. To refer
thread_data at write command completion, add the argument to zbd_put_io()
and zbd_queue_io() callbacks. Also add a loop to the zbd_close_zone()
function which converts zone_info array index to open_zones array index
to avoid loop code duplication.

Even when io_u points to an open zone, the zone may not be valid for
write since in-flight write commands may make the zone full. Check this
in zbd_open_zone() to handle such zones as in full status.

Because of the zone close timing change, there might be no open zone when
zbd_convert_to_open_zone() is called. Do not handle such case as an
error and open other zones.

When zbd_convert_to_open_zone() finds all open zones can not be used for
next write, it opens other zones. This zone open fails when the number of
open zones hits one of the limits: 1) number of zones in the fio write
target region, 2) max_open_zones option or 3) job_max_open_zones option.
To avoid the zone open failure, wait for writes in-flight completes and
open zones get closed before opening other zones.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 io_u.c      |  4 +--
 io_u.h      |  5 +--
 ioengines.c |  4 +--
 zbd.c       | 94 +++++++++++++++++++++++++++++++++++++++++------------
 zbd.h       |  9 ++---
 5 files changed, 86 insertions(+), 30 deletions(-)

diff --git a/io_u.c b/io_u.c
index 2ef5acec..62bfec47 100644
--- a/io_u.c
+++ b/io_u.c
@@ -795,7 +795,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	const bool needs_lock = td_async_processing(td);
 
-	zbd_put_io_u(io_u);
+	zbd_put_io_u(td, io_u);
 
 	if (td->parent)
 		td = td->parent;
@@ -1364,7 +1364,7 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 		if (!fill_io_u(td, io_u))
 			break;
 
-		zbd_put_io_u(io_u);
+		zbd_put_io_u(td, io_u);
 
 		put_file_log(td, f);
 		td_io_close_file(td, f);
diff --git a/io_u.h b/io_u.h
index 31100928..5a28689c 100644
--- a/io_u.h
+++ b/io_u.h
@@ -101,13 +101,14 @@ struct io_u {
 	 * @success == true means that the I/O operation has been queued or
 	 * completed successfully.
 	 */
-	void (*zbd_queue_io)(struct io_u *, int q, bool success);
+	void (*zbd_queue_io)(struct thread_data *td, struct io_u *, int q,
+			     bool success);
 
 	/*
 	 * ZBD mode zbd_put_io callback: called in after completion of an I/O
 	 * or commit of an async I/O to unlock the I/O target zone.
 	 */
-	void (*zbd_put_io)(const struct io_u *);
+	void (*zbd_put_io)(struct thread_data *td, const struct io_u *);
 
 	/*
 	 * Callback for io completion
diff --git a/ioengines.c b/ioengines.c
index 1c5970a4..476df58d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -352,7 +352,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	ret = td->io_ops->queue(td, io_u);
-	zbd_queue_io_u(io_u, ret);
+	zbd_queue_io_u(td, io_u, ret);
 
 	unlock_file(td, io_u->file);
 
@@ -394,7 +394,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (!td->io_ops->commit) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
-		zbd_put_io_u(io_u);
+		zbd_put_io_u(td, io_u);
 	}
 
 	if (ret == FIO_Q_COMPLETED) {
diff --git a/zbd.c b/zbd.c
index 5af8af4a..82d9af62 100644
--- a/zbd.c
+++ b/zbd.c
@@ -722,12 +722,21 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 
 /* The caller must hold f->zbd_info->mutex */
 static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
-			   unsigned int open_zone_idx)
+			   unsigned int zone_idx)
 {
-	uint32_t zone_idx;
+	uint32_t open_zone_idx = 0;
 
-	assert(open_zone_idx < f->zbd_info->num_open_zones);
-	zone_idx = f->zbd_info->open_zones[open_zone_idx];
+	for (; open_zone_idx < f->zbd_info->num_open_zones; open_zone_idx++) {
+		if (f->zbd_info->open_zones[open_zone_idx] == zone_idx)
+			break;
+	}
+	if (open_zone_idx == f->zbd_info->num_open_zones) {
+		dprint(FD_ZBD, "%s: zone %d is not open\n",
+		       f->file_name, zone_idx);
+		return;
+	}
+
+	dprint(FD_ZBD, "%s: closing zone %d\n", f->file_name, zone_idx);
 	memmove(f->zbd_info->open_zones + open_zone_idx,
 		f->zbd_info->open_zones + open_zone_idx + 1,
 		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
@@ -766,13 +775,8 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			continue;
 		zone_lock(td, f, z);
 		if (all_zones) {
-			unsigned int i;
-
 			pthread_mutex_lock(&f->zbd_info->mutex);
-			for (i = 0; i < f->zbd_info->num_open_zones; i++) {
-				if (f->zbd_info->open_zones[i] == nz)
-					zbd_close_zone(td, f, i);
-			}
+			zbd_close_zone(td, f, nz);
 			pthread_mutex_unlock(&f->zbd_info->mutex);
 
 			reset_wp = z->wp != z->start;
@@ -952,8 +956,15 @@ static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
 		return false;
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	if (is_zone_open(td, f, zone_idx))
+	if (is_zone_open(td, f, zone_idx)) {
+		/*
+		 * If the zone is already open and going to be full by writes
+		 * in-flight, handle it as a full zone instead of an open zone.
+		 */
+		if (z->wp >= zbd_zone_capacity_end(z))
+			res = false;
 		goto out;
+	}
 	res = false;
 	/* Zero means no limit */
 	if (td->o.job_max_open_zones > 0 &&
@@ -995,6 +1006,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	unsigned int open_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
+	bool wait_zone_close;
 
 	assert(is_valid_offset(f, io_u->offset));
 
@@ -1030,11 +1042,9 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		if (td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
 			goto examine_zone;
 		if (f->zbd_info->num_open_zones == 0) {
-			pthread_mutex_unlock(&f->zbd_info->mutex);
-			pthread_mutex_unlock(&z->mutex);
 			dprint(FD_ZBD, "%s(%s): no zones are open\n",
 			       __func__, f->file_name);
-			return NULL;
+			goto open_other_zone;
 		}
 
 		/*
@@ -1081,14 +1091,30 @@ examine_zone:
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		goto out;
 	}
-	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
-	       zone_idx);
-	if (td->o.max_open_zones || td->o.job_max_open_zones)
-		zbd_close_zone(td, f, open_zone_idx);
+
+open_other_zone:
+	/* Check if number of open zones reaches one of limits. */
+	wait_zone_close =
+		f->zbd_info->num_open_zones == f->max_zone - f->min_zone ||
+		(td->o.max_open_zones &&
+		 f->zbd_info->num_open_zones == td->o.max_open_zones) ||
+		(td->o.job_max_open_zones &&
+		 td->num_open_zones == td->o.job_max_open_zones);
+
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	/* Only z->mutex is held. */
 
+	/*
+	 * When number of open zones reaches to one of limits, wait for
+	 * zone close before opening a new zone.
+	 */
+	if (wait_zone_close) {
+		dprint(FD_ZBD, "%s(%s): quiesce to allow open zones to close\n",
+		       __func__, f->file_name);
+		io_u_quiesce(td);
+	}
+
 	/* Zone 'z' is full, so try to open a new zone. */
 	for (i = f->io_size / f->zbd_info->zone_size; i > 0; i--) {
 		zone_idx++;
@@ -1203,6 +1229,28 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	return NULL;
 }
 
+/**
+ * zbd_end_zone_io - update zone status at command completion
+ * @io_u: I/O unit
+ * @z: zone info pointer
+ *
+ * If the write command made the zone full, close it.
+ *
+ * The caller must hold z->mutex.
+ */
+static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
+			    struct fio_zone_info *z)
+{
+	const struct fio_file *f = io_u->file;
+
+	if (io_u->ddir == DDIR_WRITE &&
+	    io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		zbd_close_zone(td, f, z - f->zbd_info->zone_info);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+	}
+}
+
 /**
  * zbd_queue_io - update the write pointer of a sequential zone
  * @io_u: I/O unit
@@ -1212,7 +1260,8 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
  * For write and trim operations, update the write pointer of the I/O unit
  * target zone.
  */
-static void zbd_queue_io(struct io_u *io_u, int q, bool success)
+static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
+			 bool success)
 {
 	const struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
@@ -1258,6 +1307,9 @@ static void zbd_queue_io(struct io_u *io_u, int q, bool success)
 		break;
 	}
 
+	if (q == FIO_Q_COMPLETED && !io_u->error)
+		zbd_end_zone_io(td, io_u, z);
+
 unlock:
 	if (!success || q != FIO_Q_QUEUED) {
 		/* BUSY or COMPLETED: unlock the zone */
@@ -1270,7 +1322,7 @@ unlock:
  * zbd_put_io - Unlock an I/O unit target zone lock
  * @io_u: I/O unit
  */
-static void zbd_put_io(const struct io_u *io_u)
+static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 {
 	const struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
@@ -1292,6 +1344,8 @@ static void zbd_put_io(const struct io_u *io_u)
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
 	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
 
+	zbd_end_zone_io(td, io_u, z);
+
 	ret = pthread_mutex_unlock(&z->mutex);
 	assert(ret == 0);
 	zbd_check_swd(f);
diff --git a/zbd.h b/zbd.h
index 021174c1..bff55f99 100644
--- a/zbd.h
+++ b/zbd.h
@@ -98,18 +98,19 @@ static inline void zbd_close_file(struct fio_file *f)
 		zbd_free_zone_info(f);
 }
 
-static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
+static inline void zbd_queue_io_u(struct thread_data *td, struct io_u *io_u,
+				  enum fio_q_status status)
 {
 	if (io_u->zbd_queue_io) {
-		io_u->zbd_queue_io(io_u, status, io_u->error == 0);
+		io_u->zbd_queue_io(td, io_u, status, io_u->error == 0);
 		io_u->zbd_queue_io = NULL;
 	}
 }
 
-static inline void zbd_put_io_u(struct io_u *io_u)
+static inline void zbd_put_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	if (io_u->zbd_put_io) {
-		io_u->zbd_put_io(io_u);
+		io_u->zbd_put_io(td, io_u);
 		io_u->zbd_queue_io = NULL;
 		io_u->zbd_put_io = NULL;
 	}
-- 
2.26.2


