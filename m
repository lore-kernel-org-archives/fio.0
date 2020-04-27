Return-Path: <prvs=379927889=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/5] zbd: Fix potential deadlock on read operations
Date: Mon, 27 Apr 2020 14:51:11 +0900
Message-Id: <20200427055115.107909-3-damien.lemoal@wdc.com>
In-Reply-To: <20200427055115.107909-1-damien.lemoal@wdc.com>
References: <20200427055115.107909-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

For read-only workloads, zbd_find_zone() has a similar zone locking
behavior as for write IOs: zones to be read are locked when an IO is
prepared and unlocked when the IO completes. With an asynchronous IO
engine, this can create deadlocks if 2 threads are trying to read the
same 2 zones. For instance, if thread A already has a lock on zone 1
and is waiting for a lock on zone 2 while thread B already has a lock
on zone 2 and waiting for a lock on zone 1.

The fix is similar to previous fixes for this potential deadlock,
namely, use zone_lock() instead of directly calling pthread_mutex_lock()
to ensure that a thread issues the IOs it already has prepared if it
encounters a locked zone, doing so ensuring forward progress.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 8dc3c397..5aaf1e2c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1141,7 +1141,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	 */
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
 		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
-			pthread_mutex_lock(&z1->mutex);
+			zone_lock(td, z1);
 			if (z1->start + min_bs <= z1->wp)
 				return z1;
 			pthread_mutex_unlock(&z1->mutex);
@@ -1150,7 +1150,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		}
 		if (td_random(td) && z2 >= zf &&
 		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
-			pthread_mutex_lock(&z2->mutex);
+			zone_lock(td, z2);
 			if (z2->start + min_bs <= z2->wp)
 				return z2;
 			pthread_mutex_unlock(&z2->mutex);
-- 
2.25.4


