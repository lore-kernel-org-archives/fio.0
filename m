Return-Path: <prvs=7111401fc=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/2] zbd: avoid zone reset during asynchronous IOs in-flight
Date: Thu, 25 Mar 2021 11:15:34 +0900
Message-Id: <20210325021535.1531333-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210325021535.1531333-1-shinichiro.kawasaki@wdc.com>
References: <20210325021535.1531333-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

When fio repeats same workload on zoned block devices, zbd_file_reset()
is called for each repetition. This function resets target zones when
one of two conditions are met: 1) the write pointer of the zone has
offset from the device start unaligned to block size, or 2) the workload
is verify and verification is not in process. When the workload runs
with block size not a divisor of the zone size, the offsets of write
pointers from device start (not from zone start) become unaligned to
block size, then zbd_file_reset() resets target zones. This zone reset
happens even when the asynchronous IOs are in-flight and causes
unexpected IO results. Especially if write requests are in-flight, they
fail with unaligned write command error. A single thread may do both the
zone reset and the write request submit, recursive zone locks can not
prevent the zone reset during the writes.

The write pointer check for block size alignment is not working as
intended. It should have checked offset not from device start but from
zone start. Having said that, regardless of this write pointer check
correctness, the zone reset is not required since the zones are reset in
zbd_adjust_block() anyway when remainder of the zone between write
pointer and zone end is smaller than block size.

To avoid the zone reset during asynchronous IOs, do not reset zones in
zbd_file_reset() when the write pointer offset from the device start is
unaligned to block size. Modify zbd_file_reset() to call the helper
function zbd_reset_zones() only when the workload is verify and
verification is not in process. The function zbd_reset_zones() had an
argument 'all_zones' to inform that the zones should be reset when its
write pointer is unaligned to block size. This argument is not required.
Remove it and simplify the function accordingly.

The zone reset for verify workloads is still required. It does not
conflict with asynchronous IOs, since fio waits for IO completion at
verification end, then IOs are not in-flight when zbd_file_reset() is
called for repetition after verification.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/zbd.c b/zbd.c
index d16b890f..eed796b3 100644
--- a/zbd.c
+++ b/zbd.c
@@ -842,16 +842,13 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
  * @f: fio file for which to reset zones
  * @zb: first zone to reset.
  * @ze: first zone not to reset.
- * @all_zones: whether to reset all zones or only those zones for which the
- *	write pointer is not a multiple of td->o.min_bs[DDIR_WRITE].
  */
 static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			   struct fio_zone_info *const zb,
-			   struct fio_zone_info *const ze, bool all_zones)
+			   struct fio_zone_info *const ze)
 {
 	struct fio_zone_info *z;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
-	bool reset_wp;
 	int res = 0;
 
 	assert(min_bs);
@@ -864,16 +861,10 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		if (!z->has_wp)
 			continue;
 		zone_lock(td, f, z);
-		if (all_zones) {
-			pthread_mutex_lock(&f->zbd_info->mutex);
-			zbd_close_zone(td, f, nz);
-			pthread_mutex_unlock(&f->zbd_info->mutex);
-
-			reset_wp = z->wp != z->start;
-		} else {
-			reset_wp = z->wp % min_bs != 0;
-		}
-		if (reset_wp) {
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		zbd_close_zone(td, f, nz);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		if (z->wp != z->start) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
 			       f->file_name, zbd_zone_nr(f, z));
 			if (zbd_reset_zone(td, f, z) < 0)
@@ -996,8 +987,8 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing any data to avoid that a zone reset has to be issued while
 	 * writing data, which causes data loss.
 	 */
-	zbd_reset_zones(td, f, zb, ze, td->o.verify != VERIFY_NONE &&
-			td->runstate != TD_VERIFYING);
+	if (td->o.verify != VERIFY_NONE && td->runstate != TD_VERIFYING)
+		zbd_reset_zones(td, f, zb, ze);
 	zbd_reset_write_cnt(td, f);
 }
 
-- 
2.29.2


