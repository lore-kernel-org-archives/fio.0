Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 5/9] zbd: make zbd_info->mutex non-recursive
Date: Tue,  5 May 2020 20:56:31 +0300
Message-Id: <20200505175634.2517-5-adobriyan@gmail.com>
In-Reply-To: <20200505175634.2517-1-adobriyan@gmail.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

There is no reason for it to be recursive. Resursiveness leaked
from struct fio_zone_info::mutex initialisation.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---
 zbd.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/zbd.c b/zbd.c
index b34ceb34..2926bae9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -373,9 +373,9 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		return -ENOMEM;
 
 	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	pthread_mutexattr_setpshared(&attr, true);
 	pthread_mutex_init(&zbd_info->mutex, &attr);
+	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (i = 0; i < nr_zones; i++, p++) {
@@ -417,7 +417,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	int i, j, ret = 0;
 
 	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	pthread_mutexattr_setpshared(&attr, true);
 
 	zones = calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));
@@ -454,6 +453,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	if (!zbd_info)
 		goto out;
 	pthread_mutex_init(&zbd_info->mutex, &attr);
+	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
 	for (offset = 0, j = 0; j < nr_zones;) {
@@ -796,14 +796,20 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
  * Reset zbd_info.write_cnt, the counter that counts down towards the next
  * zone reset.
  */
-static void zbd_reset_write_cnt(const struct thread_data *td,
-				const struct fio_file *f)
+static void _zbd_reset_write_cnt(const struct thread_data *td,
+				 const struct fio_file *f)
 {
 	assert(0 <= td->o.zrf.u.f && td->o.zrf.u.f <= 1);
 
-	pthread_mutex_lock(&f->zbd_info->mutex);
 	f->zbd_info->write_cnt = td->o.zrf.u.f ?
 		min(1.0 / td->o.zrf.u.f, 0.0 + UINT_MAX) : UINT_MAX;
+}
+
+static void zbd_reset_write_cnt(const struct thread_data *td,
+				const struct fio_file *f)
+{
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	_zbd_reset_write_cnt(td, f);
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 }
 
@@ -817,7 +823,7 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	if (f->zbd_info->write_cnt)
 		write_cnt = --f->zbd_info->write_cnt;
 	if (write_cnt == 0)
-		zbd_reset_write_cnt(td, f);
+		_zbd_reset_write_cnt(td, f);
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	return write_cnt == 0;
-- 
2.26.2


