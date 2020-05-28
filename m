Return-Path: <prvs=4108b2f29=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] zbd: Fix compilation error on BSD
Date: Thu, 28 May 2020 21:56:42 +0900
Message-Id: <20200528125642.103863-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200528125642.103863-1-shinichiro.kawasaki@wdc.com>
References: <20200528125642.103863-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Commit b76949618d55 ("fio: Generalize zonemode=zbd") enabled zbd.c
compilation on other operating systems than Linux. This caused a
compilation error on NetBSD as follows:

ld: zbd.o: in function `parse_zone_info':
fio/zbd.c:422: undefined reference to `pthread_mutexattr_setpshared'
ld: zbd.o: in function `init_zone_info':
fio/zbd.c:378: undefined reference to `pthread_mutexattr_setpshared'
gmake: *** [Makefile:483: fio] Error 1

Same error is expected on other BSD OSes.

Fix this by initializing mutex using helper functions pshared.c provides.
To initialize mutex with POSIX_MUTEX_RECURSIVE attribute type, utilize
mutex_init_pshared_with_type().

Reported-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Fixes: b76949618d55 ("fio: Generalize zonemode=zbd")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/zbd.c b/zbd.c
index 72352db0..a7572c9a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -19,6 +19,7 @@
 #include "oslib/asprintf.h"
 #include "smalloc.h"
 #include "verify.h"
+#include "pshared.h"
 #include "zbd.h"
 
 /**
@@ -353,7 +354,6 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *p;
 	uint64_t zone_size = td->o.zone_size;
 	struct zoned_block_device_info *zbd_info = NULL;
-	pthread_mutexattr_t attr;
 	int i;
 
 	if (zone_size == 0) {
@@ -374,14 +374,12 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	if (!zbd_info)
 		return -ENOMEM;
 
-	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_setpshared(&attr, true);
-	pthread_mutex_init(&zbd_info->mutex, &attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+	mutex_init_pshared(&zbd_info->mutex);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (i = 0; i < nr_zones; i++, p++) {
-		pthread_mutex_init(&p->mutex, &attr);
+		mutex_init_pshared_with_type(&p->mutex,
+					     PTHREAD_MUTEX_RECURSIVE);
 		p->start = i * zone_size;
 		p->wp = p->start + zone_size;
 		p->type = ZBD_ZONE_TYPE_SWR;
@@ -395,7 +393,6 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
 		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
-	pthread_mutexattr_destroy(&attr);
 	return 0;
 }
 
@@ -415,12 +412,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
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
@@ -454,14 +447,14 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	ret = -ENOMEM;
 	if (!zbd_info)
 		goto out;
-	pthread_mutex_init(&zbd_info->mutex, &attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+	mutex_init_pshared(&zbd_info->mutex);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (offset = 0, j = 0; j < nr_zones;) {
 		z = &zones[0];
 		for (i = 0; i < nrz; i++, j++, z++, p++) {
-			pthread_mutex_init(&p->mutex, &attr);
+			mutex_init_pshared_with_type(&p->mutex,
+						     PTHREAD_MUTEX_RECURSIVE);
 			p->start = z->start;
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
@@ -512,7 +505,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 out:
 	sfree(zbd_info);
 	free(zones);
-	pthread_mutexattr_destroy(&attr);
 	return ret;
 }
 
-- 
2.25.4


