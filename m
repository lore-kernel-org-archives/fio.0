Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:38233 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbeHXWHU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Aug 2018 18:07:20 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 10/11] Add support for resetting zones periodically
Date: Fri, 24 Aug 2018 11:31:30 -0700
Message-Id: <20180824183131.13278-11-bart.vanassche@wdc.com>
In-Reply-To: <20180824183131.13278-1-bart.vanassche@wdc.com>
References: <20180824183131.13278-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>

Filesystems that support zoned block devices typically perform garbage
collection if device usage exceeds a certain threshold. Add two command
line options that allow to simulate this behavior.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 HOWTO            | 14 ++++++++
 fio.1            | 11 ++++++
 options.c        | 24 +++++++++++++
 thread_options.h |  2 ++
 zbd.c            | 89 +++++++++++++++++++++++++++++++++++++++++++++++-
 zbd.h            |  5 +++
 6 files changed, 144 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 25ce5c497821..7bbd589838ed 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1025,6 +1025,20 @@ Target file/device
 	number of open zones is defined as the number of zones to which write
 	commands are issued.
 
+.. option:: zone_reset_threshold=float
+
+	A number between zero and one that indicates the ratio of logical
+	blocks with data to the total number of logical blocks in the test
+	above which zones should be reset periodically.
+
+.. option:: zone_reset_frequency=float
+
+	A number between zero and one that indicates how often a zone reset
+	should be issued if the zone reset threshold has been exceeded. A zone
+	reset is submitted after each (1 / zone_reset_frequency) write
+	requests. This and the previous parameter can be used to simulate
+	garbage collection activity.
+
 
 I/O type
 ~~~~~~~~
diff --git a/fio.1 b/fio.1
index 7172d951ca2f..b555b208b382 100644
--- a/fio.1
+++ b/fio.1
@@ -786,6 +786,17 @@ When running a random write test across an entire drive many more zones will be
 open than in a typical application workload. Hence this command line option
 that allows to limit the number of open zones. The number of open zones is
 defined as the number of zones to which write commands are issued.
+.TP
+.BI zone_reset_threshold \fR=\fPfloat
+A number between zero and one that indicates the ratio of logical blocks with
+data to the total number of logical blocks in the test above which zones
+should be reset periodically.
+.TP
+.BI zone_reset_frequency \fR=\fPfloat
+A number between zero and one that indicates how often a zone reset should be
+issued if the zone reset threshold has been exceeded. A zone reset is
+submitted after each (1 / zone_reset_frequency) write requests. This and the
+previous parameter can be used to simulate garbage collection activity.
 
 .SS "I/O type"
 .TP
diff --git a/options.c b/options.c
index 20b64648004e..534233bdbc29 100644
--- a/options.c
+++ b/options.c
@@ -3318,6 +3318,30 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "zone_reset_threshold",
+		.lname	= "Zone reset threshold",
+		.help	= "Zoned block device reset threshold",
+		.type	= FIO_OPT_FLOAT_LIST,
+		.maxlen	= 1,
+		.off1	= offsetof(struct thread_options, zrt),
+		.minfp	= 0,
+		.maxfp	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
+	{
+		.name	= "zone_reset_frequency",
+		.lname	= "Zone reset frequency",
+		.help	= "Zoned block device zone reset frequency in HZ",
+		.type	= FIO_OPT_FLOAT_LIST,
+		.maxlen	= 1,
+		.off1	= offsetof(struct thread_options, zrf),
+		.minfp	= 0,
+		.maxfp	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
 	{
 		.name	= "lockmem",
 		.lname	= "Lock memory",
diff --git a/thread_options.h b/thread_options.h
index 597c4221f199..393158340e96 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -338,6 +338,8 @@ struct thread_options {
 	/* Parameters that affect zonemode=zbd */
 	unsigned int read_beyond_wp;
 	int max_open_zones;
+	fio_fp64_t zrt;
+	fio_fp64_t zrf;
 };
 
 #define FIO_TOP_STR_MAX		256
diff --git a/zbd.c b/zbd.c
index 2bf352122bf1..561976939298 100644
--- a/zbd.c
+++ b/zbd.c
@@ -589,6 +589,9 @@ static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
 	ze = &f->zbd_info->zone_info[zone_idx_e];
 	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		f->zbd_info->sectors_with_data -= z->wp - z->start;
+		pthread_mutex_unlock(&f->zbd_info->mutex);
 		z->wp = z->start;
 		z->verify_block = 0;
 		pthread_mutex_unlock(&z->mutex);
@@ -687,10 +690,65 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	return res;
 }
 
+/*
+ * Reset zbd_info.write_cnt, the counter that counts down towards the next
+ * zone reset.
+ */
+static void zbd_reset_write_cnt(const struct thread_data *td,
+				const struct fio_file *f)
+{
+	assert(0 <= td->o.zrf.u.f && td->o.zrf.u.f <= 1);
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	f->zbd_info->write_cnt = td->o.zrf.u.f ?
+		min(1.0 / td->o.zrf.u.f, 0.0 + UINT_MAX) : UINT_MAX;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+}
+
+static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
+					const struct fio_file *f)
+{
+	uint32_t write_cnt = 0;
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	assert(f->zbd_info->write_cnt);
+	if (f->zbd_info->write_cnt)
+		write_cnt = --f->zbd_info->write_cnt;
+	if (write_cnt == 0)
+		zbd_reset_write_cnt(td, f);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+
+	return write_cnt == 0;
+}
+
+/* Check whether the value of zbd_info.sectors_with_data is correct. */
+static void check_swd(const struct thread_data *td, const struct fio_file *f)
+{
+#if 0
+	struct fio_zone_info *zb, *ze, *z;
+	uint64_t swd;
+
+	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
+	ze = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset +
+						  f->io_size)];
+	swd = 0;
+	for (z = zb; z < ze; z++) {
+		pthread_mutex_lock(&z->mutex);
+		swd += z->wp - z->start;
+	}
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	assert(f->zbd_info->sectors_with_data == swd);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	for (z = zb; z < ze; z++)
+		pthread_mutex_unlock(&z->mutex);
+#endif
+}
+
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
-	struct fio_zone_info *zb, *ze;
+	struct fio_zone_info *zb, *ze, *z;
 	uint32_t zone_idx_e;
+	uint64_t swd = 0;
 
 	if (!f->zbd_info)
 		return;
@@ -698,6 +756,16 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
 	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size);
 	ze = &f->zbd_info->zone_info[zone_idx_e];
+	for (z = zb ; z < ze; z++) {
+		pthread_mutex_lock(&z->mutex);
+		swd += z->wp - z->start;
+	}
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	f->zbd_info->sectors_with_data = swd;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	for (z = zb ; z < ze; z++)
+		pthread_mutex_unlock(&z->mutex);
+	dprint(FD_ZBD, "%s(%s): swd = %ld\n", __func__, f->file_name, swd);
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
@@ -706,6 +774,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	zbd_reset_zones(td, f, zb, ze, td->o.verify != VERIFY_NONE &&
 			(td->o.td_ddir & TD_DDIR_WRITE) &&
 			td->runstate != TD_VERIFYING);
+	zbd_reset_write_cnt(td, f);
 }
 
 /* The caller must hold f->zbd_info->mutex. */
@@ -1007,6 +1076,14 @@ static void zbd_post_submit(const struct io_u *io_u, bool success)
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
 		zone_end = min(end, (z + 1)->start);
+		pthread_mutex_lock(&zbd_info->mutex);
+		/*
+		 * z->wp > zone_end means that one or more I/O errors
+		 * have occurred.
+		 */
+		if (z->wp <= zone_end)
+			zbd_info->sectors_with_data += zone_end - z->wp;
+		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
 	case DDIR_TRIM:
@@ -1121,6 +1198,15 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				goto eof;
 			zone_idx_b = zb - f->zbd_info->zone_info;
 		}
+		/* Check whether the zone reset threshold has been exceeded */
+		if (td->o.zrf.u.f) {
+			check_swd(td, f);
+			if ((f->zbd_info->sectors_with_data << 9) >=
+			    f->io_size * td->o.zrt.u.f &&
+			    zbd_dec_and_reset_write_cnt(td, f)) {
+				zb->reset_zone = 1;
+			}
+		}
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
 			assert(td->o.verify == VERIFY_NONE);
@@ -1135,6 +1221,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb->reset_zone = 0;
 			if (zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
+			check_swd(td, f);
 		}
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
diff --git a/zbd.h b/zbd.h
index 215a96388096..08751fd5bf34 100644
--- a/zbd.h
+++ b/zbd.h
@@ -60,11 +60,14 @@ struct fio_zone_info {
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in units of 512 bytes
+ * @sectors_with_data: total size of data in all zones in units of 512 bytes
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
  * @refcount: number of fio files that share this structure
  * @num_open_zones: number of open zones
+ * @write_cnt: Number of writes since the latest zone reset triggered by
+ *	       the zone_reset_frequency fio job parameter.
  * @open_zones: zone numbers of open zones
  * @zone_info: description of the individual zones
  *
@@ -76,10 +79,12 @@ struct zoned_block_device_info {
 	enum blk_zoned_model	model;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
+	uint64_t		sectors_with_data;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
 	uint32_t		num_open_zones;
+	uint32_t		write_cnt;
 	uint32_t		open_zones[FIO_MAX_OPEN_ZBD_ZONES];
 	struct fio_zone_info	zone_info[0];
 };
-- 
2.18.0


