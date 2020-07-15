Return-Path: <prvs=4589743b3=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/6] options: Add zonecapacity option for zonemode=zbd
Date: Wed, 15 Jul 2020 15:41:37 +0900
Message-Id: <20200715064141.116415-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
References: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Hans Holmberg <hans.holmberg@wdc.com>

To test zone capacity handling by fio using regular block devices, add
zonecapacity option for zonemode=zbd. It allows to specify zone capacity
common to all zones.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO            | 18 +++++++++++++++---
 cconv.c          |  2 ++
 fio.1            | 13 +++++++++++--
 options.c        | 11 +++++++++++
 thread_options.h |  2 ++
 zbd.c            | 13 ++++++++++++-
 6 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/HOWTO b/HOWTO
index 8cf8d650..35ead0cb 100644
--- a/HOWTO
+++ b/HOWTO
@@ -970,14 +970,15 @@ Target file/device
 	Accepted values are:
 
 		**none**
-				The :option:`zonerange`, :option:`zonesize` and
-				:option:`zoneskip` parameters are ignored.
+				The :option:`zonerange`, :option:`zonesize`,
+				:option `zonecapacity` and option:`zoneskip`
+				parameters are ignored.
 		**strided**
 				I/O happens in a single zone until
 				:option:`zonesize` bytes have been transferred.
 				After that number of bytes has been
 				transferred processing of the next zone
-				starts.
+				starts. :option `zonecapacity` is ignored.
 		**zbd**
 				Zoned block device mode. I/O happens
 				sequentially in each zone, even if random I/O
@@ -1004,6 +1005,17 @@ Target file/device
 	For :option:`zonemode` =zbd, this is the size of a single zone. The
 	:option:`zonerange` parameter is ignored in this mode.
 
+
+.. option:: zonecapacity=int
+
+	For :option:`zonemode` =zbd, this defines the capacity of a single zone,
+	which is the accessible area starting from the zone start address.
+	This parameter only applies when using :option:`zonemode` =zbd in
+	combination with regular block devices. If not specified it defaults to
+	the zone size. If the target device is a zoned block device, the zone
+	capacity is obtained from the device information and this option is
+	ignored.
+
 .. option:: zoneskip=int
 
 	For :option:`zonemode` =strided, the number of bytes to skip after
diff --git a/cconv.c b/cconv.c
index 449bcf7b..2469389b 100644
--- a/cconv.c
+++ b/cconv.c
@@ -223,6 +223,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->ss_limit.u.f = fio_uint64_to_double(le64_to_cpu(top->ss_limit.u.i));
 	o->zone_range = le64_to_cpu(top->zone_range);
 	o->zone_size = le64_to_cpu(top->zone_size);
+	o->zone_capacity = le64_to_cpu(top->zone_capacity);
 	o->zone_skip = le64_to_cpu(top->zone_skip);
 	o->zone_mode = le32_to_cpu(top->zone_mode);
 	o->lockmem = le64_to_cpu(top->lockmem);
@@ -563,6 +564,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->ss_limit.u.i = __cpu_to_le64(fio_double_to_uint64(o->ss_limit.u.f));
 	top->zone_range = __cpu_to_le64(o->zone_range);
 	top->zone_size = __cpu_to_le64(o->zone_size);
+	top->zone_capacity = __cpu_to_le64(o->zone_capacity);
 	top->zone_skip = __cpu_to_le64(o->zone_skip);
 	top->zone_mode = __cpu_to_le32(o->zone_mode);
 	top->lockmem = __cpu_to_le64(o->lockmem);
diff --git a/fio.1 b/fio.1
index f134e0bf..68aeb21f 100644
--- a/fio.1
+++ b/fio.1
@@ -738,12 +738,13 @@ Accepted values are:
 .RS
 .TP
 .B none
-The \fBzonerange\fR, \fBzonesize\fR and \fBzoneskip\fR parameters are ignored.
+The \fBzonerange\fR, \fBzonesize\fR \fBzonecapacity and \fBzoneskip\fR
+parameters are ignored.
 .TP
 .B strided
 I/O happens in a single zone until \fBzonesize\fR bytes have been transferred.
 After that number of bytes has been transferred processing of the next zone
-starts.
+starts. The \fBzonecapacity parameter is ignored.
 .TP
 .B zbd
 Zoned block device mode. I/O happens sequentially in each zone, even if random
@@ -771,6 +772,14 @@ zoned block device, the specified \fBzonesize\fR must be 0 or equal to the
 device zone size. For a regular block device or file, the specified
 \fBzonesize\fR must be at least 512B.
 .TP
+.BI zonecapacity \fR=\fPint
+For \fBzonemode\fR=zbd, this defines the capacity of a single zone, which is
+the accessible area starting from the zone start address. This parameter only
+applies when using \fBzonemode\fR=zbd in combination with regular block devices.
+If not specified it defaults to the zone size. If the target device is a zoned
+block device, the zone capacity is obtained from the device information and this
+option is ignored.
+.TP
 .BI zoneskip \fR=\fPint
 For \fBzonemode\fR=strided, the number of bytes to skip after \fBzonesize\fR
 bytes of data have been transferred.
diff --git a/options.c b/options.c
index 85a0f490..251ad2c1 100644
--- a/options.c
+++ b/options.c
@@ -3327,6 +3327,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_ZONE,
 	},
+	{
+		.name	= "zonecapacity",
+		.lname	= "Zone capacity",
+		.type	= FIO_OPT_STR_VAL,
+		.off1	= offsetof(struct thread_options, zone_capacity),
+		.help	= "Capacity per zone",
+		.def	= "0",
+		.interval = 1024 * 1024,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
 	{
 		.name	= "zonerange",
 		.lname	= "Zone range",
diff --git a/thread_options.h b/thread_options.h
index 968ea0ab..3fe48ecc 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -193,6 +193,7 @@ struct thread_options {
 	unsigned int loops;
 	unsigned long long zone_range;
 	unsigned long long zone_size;
+	unsigned long long zone_capacity;
 	unsigned long long zone_skip;
 	enum fio_zone_mode zone_mode;
 	unsigned long long lockmem;
@@ -487,6 +488,7 @@ struct thread_options_pack {
 	uint32_t loops;
 	uint64_t zone_range;
 	uint64_t zone_size;
+	uint64_t zone_capacity;
 	uint64_t zone_skip;
 	uint64_t lockmem;
 	uint32_t mem_type;
diff --git a/zbd.c b/zbd.c
index c738a58b..85478aa5 100644
--- a/zbd.c
+++ b/zbd.c
@@ -371,6 +371,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	uint32_t nr_zones;
 	struct fio_zone_info *p;
 	uint64_t zone_size = td->o.zone_size;
+	uint64_t zone_capacity = td->o.zone_capacity;
 	struct zoned_block_device_info *zbd_info = NULL;
 	int i;
 
@@ -386,6 +387,16 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		return 1;
 	}
 
+	if (zone_capacity == 0)
+		zone_capacity = zone_size;
+
+	if (zone_capacity > zone_size) {
+		log_err("%s: job parameter zonecapacity %llu is larger than zone size %llu\n",
+			f->file_name, (unsigned long long) td->o.zone_capacity,
+			(unsigned long long) td->o.zone_size);
+		return 1;
+	}
+
 	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -402,7 +413,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		p->wp = p->start;
 		p->type = ZBD_ZONE_TYPE_SWR;
 		p->cond = ZBD_ZONE_COND_EMPTY;
-		p->capacity = zone_size;
+		p->capacity = zone_capacity;
 	}
 	/* a sentinel */
 	p->start = nr_zones * zone_size;
-- 
2.26.2


