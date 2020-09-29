Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 1/3] Add support for Explicit open zones
Date: Tue, 29 Sep 2020 18:29:48 +0530
Message-Id: <20200929125950.20343-2-krish.reddy@samsung.com>
In-Reply-To: <20200929125950.20343-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20200929125950.20343-1-krish.reddy@samsung.com>
	<CGME20200929130320epcas5p3fe001cbdeacc1f49a6f237c31c34e93d@epcas5p3.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Added a new FIO option zone_open. When it is enabled,
Zones will be opened explicitly before sending I/Os.

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 HOWTO                       | 13 ++++++++
 engines/skeleton_external.c | 12 ++++++++
 fio.1                       | 11 +++++++
 ioengines.h                 |  2 ++
 options.c                   | 20 ++++++++++++
 oslib/blkzoned.h            |  7 +++++
 oslib/linux-blkzoned.c      | 26 ++++++++++++++++
 thread_options.h            |  7 +++++
 zbd.c                       | 61 +++++++++++++++++++++++++++++++++++++
 9 files changed, 159 insertions(+)

diff --git a/HOWTO b/HOWTO
index 2d8c7a02..320a1083 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1022,6 +1022,19 @@ Target file/device
 	:option:`zonesize` bytes of data have been transferred. This parameter
 	must be zero for :option:`zonemode` =zbd.
 
+.. option:: zone_open=str
+
+	This parameter applies to :option:`zonemode` =zbd only.
+
+	Accepted values are:
+
+		**implicit**
+				Zones are opened implicitly before sending
+				the I/Os.
+		**explicit**
+				Zones are opened explicitly before sending
+				the I/Os.
+
 .. option:: read_beyond_wp=bool
 
 	This parameter applies to :option:`zonemode` =zbd only.
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 7f3e4cb3..828668b8 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -193,6 +193,17 @@ static int fio_skeleton_reset_wp(struct thread_data *td, struct fio_file *f,
 	return 0;
 }
 
+/*
+ * Hook called for explicitly opening zones of a ZBD_HOST_AWARE or
+ * ZBD_HOST_MANAGED zoned block device. All the zones in the range
+ * @offset..@offset + @length must be opened.
+ */
+static int fio_skeleton_open_zones(struct thread_data *td, struct fio_file *f,
+				   uint64_t offset, uint64_t length)
+{
+	return 0;
+}
+
 /*
  * Note that the structure is exported, so that fio can get it via
  * dlsym(..., "ioengine"); for (and only for) external engines.
@@ -212,6 +223,7 @@ struct ioengine_ops ioengine = {
 	.get_zoned_model = fio_skeleton_get_zoned_model,
 	.report_zones	= fio_skeleton_report_zones,
 	.reset_wp	= fio_skeleton_reset_wp,
+	.open_zones	= fio_skeleton_open_zones,
 	.options	= options,
 	.option_struct_size	= sizeof(struct fio_skeleton_options),
 };
diff --git a/fio.1 b/fio.1
index a881277c..de69f7af 100644
--- a/fio.1
+++ b/fio.1
@@ -789,6 +789,17 @@ once a zone is fully written (write workloads) or all written data in the
 zone have been read (read workloads). This parameter is valid only for
 sequential workloads and ignored for random workloads. For read workloads,
 see also \fBread_beyond_wp\fR.
+.TP
+.BI zone_open\fR=\fPstr
+For \fBzonemode\fR=zbd the accepted values are
+.RS
+.TP
+.B explicit
+Zones are opened Explicitly before sending I/Os.
+.TP
+.B implicit
+Zones are opened Implicitly before sending I/Os.
+.RE
 
 .TP
 .BI read_beyond_wp \fR=\fPbool
diff --git a/ioengines.h b/ioengines.h
index 54dadba2..8caac373 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -57,6 +57,8 @@ struct ioengine_ops {
 			    uint64_t, struct zbd_zone *, unsigned int);
 	int (*reset_wp)(struct thread_data *, struct fio_file *,
 			uint64_t, uint64_t);
+	int (*open_zones)(struct thread_data *, const struct fio_file *,
+			  uint64_t, uint64_t);
 	int option_struct_size;
 	struct fio_option *options;
 };
diff --git a/options.c b/options.c
index b497d973..2b2bbb6e 100644
--- a/options.c
+++ b/options.c
@@ -3332,6 +3332,26 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			   },
 		},
 	},
+	{
+		.name	= "zone_open",
+		.lname	= "zone_open",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, zone_open),
+		.help	= "Zone Open Mode (Implicit / Explicit) for Zoned Block Devices",
+		.def	= "implicit",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+		.posval	= {
+			   { .ival = "implicit",
+			     .oval = ZONE_OPEN_IMPLICIT,
+			     .help = "Open Zones Implicitly",
+			   },
+			   { .ival = "explicit",
+			     .oval = ZONE_OPEN_EXPLICIT,
+			     .help = "Open Zones Explicitly",
+			   },
+		},
+	},
 	{
 		.name	= "zonesize",
 		.lname	= "Zone size",
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 4cc071dc..9c1422d3 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -16,6 +16,8 @@ extern int blkzoned_report_zones(struct thread_data *td,
 				struct zbd_zone *zones, unsigned int nr_zones);
 extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
+extern int blkzoned_open_zone(struct thread_data *td, const struct fio_file *f,
+				uint64_t offset, uint64_t length);
 #else
 /*
  * Define stubs for systems that do not have zoned block device support.
@@ -44,6 +46,11 @@ static inline int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 {
 	return -EIO;
 }
+static inline int blkzoned_open_zone(struct thread_data *td, const struct fio_file *f,
+				     uint64_t offset, uint64_t length)
+{
+	return -EIO;
+}
 #endif
 
 #endif /* FIO_BLKZONED_H */
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 0a8a577a..f8cdce3b 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -240,3 +240,29 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 
 	return ret;
 }
+
+int blkzoned_open_zone(struct thread_data *td, const struct fio_file *f,
+		       uint64_t offset, uint64_t length)
+{
+	struct blk_zone_range zr = {
+		.sector         = offset >> 9,
+		.nr_sectors     = length >> 9,
+	};
+	int fd, ret = 0;
+
+	/* If the file is not yet opened, open it for this function. */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
+		if (fd < 0)
+			return -errno;
+	}
+
+	if (ioctl(fd, BLKOPENZONE, &zr) < 0)
+		return -errno;
+
+	if (f->fd < 0)
+		close(fd);
+
+	return ret;
+}
diff --git a/thread_options.h b/thread_options.h
index 97c400fe..d8f352b7 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -18,6 +18,11 @@ enum fio_zone_mode {
 	ZONE_MODE_ZBD		= 3,
 };
 
+enum fio_zone_open {
+	ZONE_OPEN_IMPLICIT	= 0, /* Open Zones Implicitly */
+	ZONE_OPEN_EXPLICIT	= 1, /* Open Zones Explicitly */
+};
+
 /*
  * What type of allocation to use for io buffers
  */
@@ -197,6 +202,7 @@ struct thread_options {
 	unsigned long long zone_capacity;
 	unsigned long long zone_skip;
 	enum fio_zone_mode zone_mode;
+	enum fio_zone_open zone_open;
 	unsigned long long lockmem;
 	enum fio_memtype mem_type;
 	unsigned int mem_align;
@@ -640,6 +646,7 @@ struct thread_options_pack {
 	uint32_t allow_mounted_write;
 
 	uint32_t zone_mode;
+	uint32_t zone_open;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
diff --git a/zbd.c b/zbd.c
index 905c0c2b..70836e38 100644
--- a/zbd.c
+++ b/zbd.c
@@ -738,12 +738,53 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	z->wp = z->start;
 	z->verify_block = 0;
+	z->cond = ZBD_ZONE_COND_EMPTY;
 
 	td->ts.nr_zone_resets++;
 
 	return ret;
 }
 
+/**
+ * zbd_explicit_open_zone - Open a zone explicitly
+ * @td: FIO thread data.
+ * @f: FIO file associated with the disk for which to open the zone.
+ * @z: Zone to open.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ *
+ * The caller must hold z->mutex.
+ */
+static int zbd_explicit_open_zone(struct thread_data *td, const struct fio_file *f,
+				  struct fio_zone_info *z)
+{
+	uint64_t offset = z->start;
+	uint64_t length = (z+1)->start - offset;
+	int ret = 0;
+
+	assert(is_valid_offset(f, offset + length - 1));
+
+	switch (f->zbd_info->model) {
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		if (td->io_ops && td->io_ops->open_zones)
+			ret = td->io_ops->open_zones(td, f, z->start, f->zbd_info->zone_size);
+		else
+			ret = blkzoned_open_zone(td, f, z->start, f->zbd_info->zone_size);
+		if (ret < 0) {
+			td_verror(td, errno, "opening zone failed");
+			log_err("%s: Explicit open for zone :%d failed (%d).\n",
+				f->file_name, zbd_zone_nr(f->zbd_info, z), errno);
+		}
+		z->cond = ZBD_ZONE_COND_EXP_OPEN;
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 /* The caller must hold f->zbd_info->mutex */
 static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 			   unsigned int zone_idx)
@@ -986,6 +1027,11 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 		 */
 		if (z->wp >= zbd_zone_capacity_end(z))
 			res = false;
+		if (td->o.zone_open == ZONE_OPEN_EXPLICIT &&
+		    z->cond == ZBD_ZONE_COND_IMP_OPEN)
+			if (zbd_explicit_open_zone(td, f, z))
+				res = false;
+
 		goto out;
 	}
 	res = false;
@@ -996,6 +1042,16 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 	if (f->zbd_info->num_open_zones >= f->zbd_info->max_open_zones)
 		goto out;
 	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
+	if (td->o.zone_open == ZONE_OPEN_EXPLICIT) {
+		if (z->cond == ZBD_ZONE_COND_FULL) {
+			res = true;
+			goto out;
+		}
+		if (zbd_explicit_open_zone(td, f, z))
+			goto out;
+
+	} else
+		z->cond = ZBD_ZONE_COND_IMP_OPEN;
 	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] = zone_idx;
 	td->num_open_zones++;
 	z->open = 1;
@@ -1268,6 +1324,7 @@ static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
 
 	if (io_u->ddir == DDIR_WRITE &&
 	    io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
+		z->cond = ZBD_ZONE_COND_FULL;
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		zbd_close_zone(td, f, z - f->zbd_info->zone_info);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
@@ -1635,6 +1692,10 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			if (zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
 
+			if ((td->o.zone_open == ZONE_OPEN_EXPLICIT) &&
+			    zbd_explicit_open_zone(td, f, zb))
+				goto eof;
+
 			if (zb->capacity < min_bs) {
 				log_err("zone capacity %llu smaller than minimum block size %d\n",
 					(unsigned long long)zb->capacity,
-- 
2.17.1


