Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 3/7] zbd: introduce per-device "max_open_zones" limit
Date: Thu, 30 Apr 2020 15:40:46 +0300
Message-Id: <20200430124050.20146-3-adobriyan@gmail.com>
In-Reply-To: <20200430124050.20146-1-adobriyan@gmail.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: adobriyan@gmail.com, damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

It is not possible to maintain equal per-thread iodepth. The way code
is written, "max_open_zones" acts as a global limit, and one thread
opens all "max_open_zones" for itself and others starve for available
zones and _exit_ prematurely.

This config is guaranteed to make equal number of zone resets/IO now:
each thread generates identical pattern and doesn't intersect with other
threads:

	zonemode=zbd
	zonesize=...
	rw=write

	numjobs=N
	offset_increment=M*zonesize

	[j]
	size=M*zonesize

Patch introduces "global_max_open_zones" which is per-device config
option. "max_open_zones" becomes per-thread limit. Both limits are
checked for each open zone so one thread can't starve others.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---
 fio.1            |  6 +++++-
 fio.h            |  1 +
 options.c        | 14 ++++++++++++--
 thread_options.h |  1 +
 zbd.c            | 37 +++++++++++++++++++++++++++++++++----
 zbd.h            |  3 +++
 6 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/fio.1 b/fio.1
index a2379f98..1c04a3af 100644
--- a/fio.1
+++ b/fio.1
@@ -804,7 +804,11 @@ so. Default: false.
 When running a random write test across an entire drive many more zones will be
 open than in a typical application workload. Hence this command line option
 that allows to limit the number of open zones. The number of open zones is
-defined as the number of zones to which write commands are issued.
+defined as the number of zones to which write commands are issued by one
+thread/process.
+.TP
+.BI global_max_open_zones \fR=\fPint
+Global limit on the number of simultaneously opened zones per block device.
 .TP
 .BI zone_reset_threshold \fR=\fPfloat
 A number between zero and one that indicates the ratio of logical blocks with
diff --git a/fio.h b/fio.h
index bbf057c1..20ca80e2 100644
--- a/fio.h
+++ b/fio.h
@@ -260,6 +260,7 @@ struct thread_data {
 	struct frand_state prio_state;
 
 	struct zone_split_index **zone_state_index;
+	unsigned int num_open_zones;
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
diff --git a/options.c b/options.c
index 2372c042..306874ea 100644
--- a/options.c
+++ b/options.c
@@ -3364,8 +3364,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, max_open_zones),
 		.maxval	= ZBD_MAX_OPEN_ZONES,
-		.help	= "Limit random writes to SMR drives to the specified"
-			  " number of sequential zones",
+		.help	= "Thread/process limit on the number of simultaneously opened sequential write zones in SMR/ZNS drives",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "global_max_open_zones",
+		.lname	= "Global maximum number of open zones",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, global_max_open_zones),
+		.maxval	= ZBD_MAX_OPEN_ZONES,
+		.help	= "Block device limit on the number of simultaneously opened sequential write zones in SMR/ZNS drives",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
diff --git a/thread_options.h b/thread_options.h
index c78ed43d..4078d46f 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -342,6 +342,7 @@ struct thread_options {
 	/* Parameters that affect zonemode=zbd */
 	unsigned int read_beyond_wp;
 	int max_open_zones;
+	unsigned int global_max_open_zones;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 };
diff --git a/zbd.c b/zbd.c
index e8f0a4d8..a517349a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -546,8 +546,10 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 		return -EINVAL;
 	}
 
-	if (ret == 0)
+	if (ret == 0) {
 		f->zbd_info->model = zbd_model;
+		f->zbd_info->max_open_zones = td->o.global_max_open_zones;
+	}
 	return ret;
 }
 
@@ -622,6 +624,27 @@ int zbd_init(struct thread_data *td)
 	if (!zbd_verify_bs())
 		return 1;
 
+	for_each_file(td, f, i) {
+		struct zoned_block_device_info *zbd = f->zbd_info;
+
+		if (!zbd)
+			continue;
+
+		if (zbd->max_open_zones == 0) {
+			zbd->max_open_zones = ZBD_MAX_OPEN_ZONES;
+		}
+
+		if (td->o.global_max_open_zones &&
+		    zbd->max_open_zones != td->o.global_max_open_zones) {
+			log_err("Different 'global_max_open_zones' values\n");
+			return 1;
+		}
+		if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
+			log_err("'global_max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_ZONES);
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -714,6 +737,7 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
 		sizeof(f->zbd_info->open_zones[0]));
 	f->zbd_info->num_open_zones--;
+	td->num_open_zones--;
 	f->zbd_info->zone_info[zone_idx].open = 0;
 }
 
@@ -895,8 +919,10 @@ static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
 	struct zoned_block_device_info *zbdi = f->zbd_info;
 	int i;
 
-	assert(td->o.max_open_zones <= ARRAY_SIZE(zbdi->open_zones));
-	assert(zbdi->num_open_zones <= td->o.max_open_zones);
+	assert(td->o.max_open_zones == 0 || td->num_open_zones <= td->o.max_open_zones);
+
+	assert(td->o.max_open_zones <= zbdi->max_open_zones);
+	assert(zbdi->num_open_zones <= zbdi->max_open_zones);
 
 	for (i = 0; i < zbdi->num_open_zones; i++)
 		if (zbdi->open_zones[i] == zone_idx)
@@ -937,10 +963,13 @@ static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
 	if (is_zone_open(td, f, zone_idx))
 		goto out;
 	res = false;
-	if (f->zbd_info->num_open_zones >= td->o.max_open_zones)
+	if (td->num_open_zones >= td->o.max_open_zones)
+		goto out;
+	if (f->zbd_info->num_open_zones >= f->zbd_info->max_open_zones)
 		goto out;
 	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
 	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] = zone_idx;
+	td->num_open_zones++;
 	z->open = 1;
 	res = true;
 
diff --git a/zbd.h b/zbd.h
index 5a660399..fb39fb82 100644
--- a/zbd.h
+++ b/zbd.h
@@ -45,6 +45,8 @@ struct fio_zone_info {
 /**
  * zoned_block_device_info - zoned block device characteristics
  * @model: Device model.
+ * @max_open_zones: global limit on the number of simultaneously opened
+ *	sequential write zones.
  * @mutex: Protects the modifiable members in this structure (refcount and
  *		num_open_zones).
  * @zone_size: size of a single zone in units of 512 bytes
@@ -65,6 +67,7 @@ struct fio_zone_info {
  */
 struct zoned_block_device_info {
 	enum zbd_zoned_model	model;
+	uint32_t		max_open_zones;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		sectors_with_data;
-- 
2.26.2


