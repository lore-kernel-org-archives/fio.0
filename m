Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18147 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727557AbeHXUGM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Aug 2018 16:06:12 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 09/11] Make it possible to limit the number of open zones
Date: Fri, 24 Aug 2018 09:30:44 -0700
Message-Id: <20180824163046.12304-10-bart.vanassche@wdc.com>
In-Reply-To: <20180824163046.12304-1-bart.vanassche@wdc.com>
References: <20180824163046.12304-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>

When running a random I/O test across an entire drive many more zones
will be open than in a typical application workload. Hence add a command
line option that allows to limit the number of open zones.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 HOWTO            |   8 ++
 fio.1            |   6 ++
 fio.h            |   2 +
 options.c        |  12 +++
 thread_options.h |   1 +
 zbd.c            | 224 ++++++++++++++++++++++++++++++++++++++++++++++-
 zbd.h            |   8 +-
 7 files changed, 257 insertions(+), 4 deletions(-)

diff --git a/HOWTO b/HOWTO
index b7e18529749b..25ce5c497821 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1017,6 +1017,14 @@ Target file/device
 	bandwidth and IOPS numbers fio only reads beyond the write pointer if
 	explicitly told to do so. Default: false.
 
+.. option:: max_open_zones=int
+
+	When running a random write test across an entire drive many more
+	zones will be open than in a typical application workload. Hence this
+	command line option that allows to limit the number of open zones. The
+	number of open zones is defined as the number of zones to which write
+	commands are issued.
+
 
 I/O type
 ~~~~~~~~
diff --git a/fio.1 b/fio.1
index 46b4cd08395b..7172d951ca2f 100644
--- a/fio.1
+++ b/fio.1
@@ -780,6 +780,12 @@ block device will complete the read without reading any data from the storage
 medium. Since such reads lead to unrealistically high bandwidth and IOPS
 numbers fio only reads beyond the write pointer if explicitly told to do
 so. Default: false.
+.TP
+.BI max_open_zones \fR=\fPint
+When running a random write test across an entire drive many more zones will be
+open than in a typical application workload. Hence this command line option
+that allows to limit the number of open zones. The number of open zones is
+defined as the number of zones to which write commands are issued.
 
 .SS "I/O type"
 .TP
diff --git a/fio.h b/fio.h
index 83654bbbf041..42015d3b7d21 100644
--- a/fio.h
+++ b/fio.h
@@ -167,6 +167,8 @@ struct zone_split_index {
 	uint64_t size_prev;
 };
 
+#define FIO_MAX_OPEN_ZBD_ZONES 128
+
 /*
  * This describes a single thread/process executing a fio job.
  */
diff --git a/options.c b/options.c
index 796187ed18a8..20b64648004e 100644
--- a/options.c
+++ b/options.c
@@ -3306,6 +3306,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "max_open_zones",
+		.lname	= "Maximum number of open zones",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, max_open_zones),
+		.maxval	= FIO_MAX_OPEN_ZBD_ZONES,
+		.help	= "Limit random writes to SMR drives to the specified"
+			  " number of sequential zones",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "lockmem",
 		.lname	= "Lock memory",
diff --git a/thread_options.h b/thread_options.h
index 32063112feaa..597c4221f199 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -337,6 +337,7 @@ struct thread_options {
 
 	/* Parameters that affect zonemode=zbd */
 	unsigned int read_beyond_wp;
+	int max_open_zones;
 };
 
 #define FIO_TOP_STR_MAX		256
diff --git a/zbd.c b/zbd.c
index 85beb3dcf15b..328cdead1fa3 100644
--- a/zbd.c
+++ b/zbd.c
@@ -718,17 +718,228 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 			td->runstate != TD_VERIFYING);
 }
 
+/* The caller must hold f->zbd_info->mutex. */
+static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
+			 unsigned int zone_idx)
+{
+	struct zoned_block_device_info *zbdi = f->zbd_info;
+	int i;
+
+	assert(td->o.max_open_zones <= ARRAY_SIZE(zbdi->open_zones));
+	assert(zbdi->num_open_zones <= td->o.max_open_zones);
+
+	for (i = 0; i < zbdi->num_open_zones; i++)
+		if (zbdi->open_zones[i] == zone_idx)
+			return true;
+
+	return false;
+}
+
+/*
+ * Open a ZBD zone if it was not yet open. Returns true if either the zone was
+ * already open or if opening a new zone is allowed. Returns false if the zone
+ * was not yet open and opening a new zone would cause the zone limit to be
+ * exceeded.
+ */
+static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
+			  uint32_t zone_idx)
+{
+	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	const struct fio_file *f = io_u->file;
+	struct fio_zone_info *z = &f->zbd_info->zone_info[zone_idx];
+	bool res = true;
+
+	if (z->cond == BLK_ZONE_COND_OFFLINE)
+		return false;
+
+	/*
+	 * Skip full zones with data verification enabled because resetting a
+	 * zone causes data loss and hence causes verification to fail.
+	 */
+	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+		return false;
+
+	/* Zero means no limit */
+	if (!td->o.max_open_zones)
+		return true;
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	if (is_zone_open(td, f, zone_idx))
+		goto out;
+	res = false;
+	if (f->zbd_info->num_open_zones >= td->o.max_open_zones)
+		goto out;
+	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
+	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] = zone_idx;
+	z->open = 1;
+	res = true;
+
+out:
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	return res;
+}
+
+/* The caller must hold f->zbd_info->mutex */
+static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
+			   unsigned int open_zone_idx)
+{
+	uint32_t zone_idx;
+
+	assert(open_zone_idx < f->zbd_info->num_open_zones);
+	zone_idx = f->zbd_info->open_zones[open_zone_idx];
+	memmove(f->zbd_info->open_zones + open_zone_idx,
+		f->zbd_info->open_zones + open_zone_idx + 1,
+		(FIO_MAX_OPEN_ZBD_ZONES - (open_zone_idx + 1)) *
+		sizeof(f->zbd_info->open_zones[0]));
+	f->zbd_info->num_open_zones--;
+	f->zbd_info->zone_info[zone_idx].open = 0;
+}
+
+/*
+ * Modify the offset of an I/O unit that does not refer to an open zone such
+ * that it refers to an open zone. Close an open zone and open a new zone if
+ * necessary. This algorithm can only work correctly if all write pointers are
+ * a multiple of the fio block size. The caller must neither hold z->mutex
+ * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
+ */
+struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
+					       struct io_u *io_u)
+{
+	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
+	const struct fio_file *f = io_u->file;
+	struct fio_zone_info *z;
+	unsigned int open_zone_idx = -1;
+	uint32_t zone_idx, new_zone_idx;
+	int i;
+
+	assert(is_valid_offset(f, io_u->offset));
+
+	if (td->o.max_open_zones) {
+		/*
+		 * This statement accesses f->zbd_info->open_zones[] on purpose
+		 * without locking.
+		 */
+		zone_idx = f->zbd_info->open_zones[(io_u->offset -
+						    f->file_offset) *
+				f->zbd_info->num_open_zones / f->io_size];
+	} else {
+		zone_idx = zbd_zone_idx(f, io_u->offset);
+	}
+	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld)\n",
+	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
+
+	/*
+	 * Since z->mutex is the outer lock and f->zbd_info->mutex the inner
+	 * lock it can happen that the state of the zone with index zone_idx
+	 * has changed after 'z' has been assigned and before f->zbd_info->mutex
+	 * has been obtained. Hence the loop.
+	 */
+	for (;;) {
+		z = &f->zbd_info->zone_info[zone_idx];
+
+		pthread_mutex_lock(&z->mutex);
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		if (td->o.max_open_zones == 0)
+			goto examine_zone;
+		if (f->zbd_info->num_open_zones == 0) {
+			pthread_mutex_unlock(&f->zbd_info->mutex);
+			pthread_mutex_unlock(&z->mutex);
+			dprint(FD_ZBD, "%s(%s): no zones are open\n",
+			       __func__, f->file_name);
+			return NULL;
+		}
+		open_zone_idx = (io_u->offset - f->file_offset) *
+			f->zbd_info->num_open_zones / f->io_size;
+		assert(open_zone_idx < f->zbd_info->num_open_zones);
+		new_zone_idx = f->zbd_info->open_zones[open_zone_idx];
+		if (new_zone_idx == zone_idx)
+			break;
+		zone_idx = new_zone_idx;
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&z->mutex);
+	}
+
+	/* Both z->mutex and f->zbd_info->mutex are held. */
+
+examine_zone:
+	if ((z->wp << 9) + min_bs <= ((z+1)->start << 9)) {
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		goto out;
+	}
+	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
+	       zone_idx);
+	if (td->o.max_open_zones)
+		zbd_close_zone(td, f, open_zone_idx);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+
+	/* Only z->mutex is held. */
+
+	/* Zone 'z' is full, so try to open a new zone. */
+	for (i = f->io_size / f->zbd_info->zone_size; i > 0; i--) {
+		zone_idx++;
+		pthread_mutex_unlock(&z->mutex);
+		z++;
+		if (!is_valid_offset(f, z->start << 9)) {
+			/* Wrap-around. */
+			zone_idx = zbd_zone_idx(f, f->file_offset);
+			z = &f->zbd_info->zone_info[zone_idx];
+		}
+		assert(is_valid_offset(f, z->start << 9));
+		pthread_mutex_lock(&z->mutex);
+		if (z->open)
+			continue;
+		if (zbd_open_zone(td, io_u, zone_idx))
+			goto out;
+	}
+
+	/* Only z->mutex is held. */
+
+	/* Check whether the write fits in any of the already opened zones. */
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	for (i = 0; i < f->zbd_info->num_open_zones; i++) {
+		zone_idx = f->zbd_info->open_zones[i];
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&z->mutex);
+
+		z = &f->zbd_info->zone_info[zone_idx];
+
+		pthread_mutex_lock(&z->mutex);
+		if ((z->wp << 9) + min_bs <= ((z+1)->start << 9))
+			goto out;
+		pthread_mutex_lock(&f->zbd_info->mutex);
+	}
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_unlock(&z->mutex);
+	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
+	       f->file_name);
+	return NULL;
+
+out:
+	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
+	       zone_idx);
+	io_u->offset = z->start << 9;
+	return z;
+}
+
 /* The caller must hold z->mutex. */
-static void zbd_replay_write_order(struct thread_data *td, struct io_u *io_u,
-				   struct fio_zone_info *z)
+static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
+						    struct io_u *io_u,
+						    struct fio_zone_info *z)
 {
 	const struct fio_file *f = io_u->file;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 
+	if (!zbd_open_zone(td, io_u, z - f->zbd_info->zone_info)) {
+		pthread_mutex_unlock(&z->mutex);
+		z = zbd_convert_to_open_zone(td, io_u);
+		assert(z);
+	}
+
 	if (z->verify_block * min_bs >= f->zbd_info->zone_size)
 		log_err("%s: %d * %d >= %ld\n", f->file_name, z->verify_block,
 			min_bs, f->zbd_info->zone_size);
 	io_u->offset = (z->start << 9) + z->verify_block++ * min_bs;
+	return z;
 }
 
 /*
@@ -861,7 +1072,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	switch (io_u->ddir) {
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING) {
-			zbd_replay_write_order(td, io_u, zb);
+			zb = zbd_replay_write_order(td, io_u, zb);
 			goto accept;
 		}
 		/*
@@ -903,6 +1114,13 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_WRITE:
 		if (io_u->buflen > (f->zbd_info->zone_size << 9))
 			goto eof;
+		if (!zbd_open_zone(td, io_u, zone_idx_b)) {
+			pthread_mutex_unlock(&zb->mutex);
+			zb = zbd_convert_to_open_zone(td, io_u);
+			if (!zb)
+				goto eof;
+			zone_idx_b = zb - f->zbd_info->zone_info;
+		}
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
 			assert(td->o.verify == VERIFY_NONE);
diff --git a/zbd.h b/zbd.h
index b269ff0864ad..272cb9456e6f 100644
--- a/zbd.h
+++ b/zbd.h
@@ -8,6 +8,7 @@
 #define FIO_ZBD_H
 
 #include <inttypes.h>
+#include "fio.h"	/* FIO_MAX_OPEN_ZBD_ZONES */
 #ifdef CONFIG_LINUX_BLKZONED
 #include <linux/blkzoned.h>
 #endif
@@ -56,12 +57,15 @@ struct fio_zone_info {
 /**
  * zoned_block_device_info - zoned block device characteristics
  * @model: Device model.
- * @mutex: Protects the modifiable members in this structure (refcount).
+ * @mutex: Protects the modifiable members in this structure (refcount and
+ *		num_open_zones).
  * @zone_size: size of a single zone in units of 512 bytes
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
  * @refcount: number of fio files that share this structure
+ * @num_open_zones: number of open zones
+ * @open_zones: zone numbers of open zones
  * @zone_info: description of the individual zones
  *
  * Only devices for which all zones have the same size are supported.
@@ -75,6 +79,8 @@ struct zoned_block_device_info {
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
+	uint32_t		num_open_zones;
+	uint32_t		open_zones[FIO_MAX_OPEN_ZBD_ZONES];
 	struct fio_zone_info	zone_info[0];
 };
 
-- 
2.18.0


