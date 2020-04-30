Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 5/7] zbd: consolidate zone mutex initialisation
Date: Thu, 30 Apr 2020 15:40:48 +0300
Message-Id: <20200430124050.20146-5-adobriyan@gmail.com>
In-Reply-To: <20200430124050.20146-1-adobriyan@gmail.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: adobriyan@gmail.com, damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Another mutex is coming!

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---
 zbd.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/zbd.c b/zbd.c
index 18cedfce..2febc8c3 100644
--- a/zbd.c
+++ b/zbd.c
@@ -351,7 +351,6 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *p;
 	uint64_t zone_size = td->o.zone_size;
 	struct zoned_block_device_info *zbd_info = NULL;
-	pthread_mutexattr_t attr;
 	int i;
 
 	if (zone_size == 0) {
@@ -372,14 +371,9 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	if (!zbd_info)
 		return -ENOMEM;
 
-	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_setpshared(&attr, true);
-	pthread_mutex_init(&zbd_info->mutex, &attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (i = 0; i < nr_zones; i++, p++) {
-		pthread_mutex_init(&p->mutex, &attr);
 		p->start = i * zone_size;
 		p->wp = p->start + zone_size;
 		p->type = ZBD_ZONE_TYPE_SWR;
@@ -393,7 +387,6 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
 		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
-	pthread_mutexattr_destroy(&attr);
 	return 0;
 }
 
@@ -413,12 +406,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *p;
 	uint64_t zone_size, offset;
 	struct zoned_block_device_info *zbd_info = NULL;
-	pthread_mutexattr_t attr;
 	int i, j, ret = 0;
 
-	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_setpshared(&attr, true);
-
 	zones = calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));
 	if (!zones)
 		goto out;
@@ -452,14 +441,11 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	ret = -ENOMEM;
 	if (!zbd_info)
 		goto out;
-	pthread_mutex_init(&zbd_info->mutex, &attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (offset = 0, j = 0; j < nr_zones;) {
 		z = &zones[0];
 		for (i = 0; i < nrz; i++, j++, z++, p++) {
-			pthread_mutex_init(&p->mutex, &attr);
 			p->start = z->start;
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
@@ -510,7 +496,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 out:
 	sfree(zbd_info);
 	free(zones);
-	pthread_mutexattr_destroy(&attr);
 	return ret;
 }
 
@@ -521,6 +506,7 @@ out:
  */
 static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 {
+	struct zoned_block_device_info *zbd;
 	enum zbd_zoned_model zbd_model;
 	int ret;
 
@@ -546,11 +532,27 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 		return -EINVAL;
 	}
 
-	if (ret == 0) {
-		f->zbd_info->model = zbd_model;
-		f->zbd_info->max_open_zones = td->o.global_max_open_zones;
+	if (ret)
+		return ret;
+
+	zbd = f->zbd_info;
+	zbd->model = zbd_model;
+	zbd->max_open_zones = td->o.global_max_open_zones;
+	{
+		pthread_mutexattr_t attr;
+
+		pthread_mutexattr_init(&attr);
+		pthread_mutexattr_setpshared(&attr, true);
+		pthread_mutex_init(&zbd->mutex, &attr);
+		pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+		for (uint32_t z = 0; z < zbd->nr_zones; z++) {
+			struct fio_zone_info *zi = &zbd->zone_info[z];
+
+			pthread_mutex_init(&zi->mutex, &attr);
+		}
+		pthread_mutexattr_destroy(&attr);
 	}
-	return ret;
+	return 0;
 }
 
 void zbd_free_zone_info(struct fio_file *f)
-- 
2.26.2


