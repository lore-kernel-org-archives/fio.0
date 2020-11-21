Return-Path: <prvs=587eb1fc6=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 15/15] zbd: use zone_lock() in zbd_process_swd()
Date: Sat, 21 Nov 2020 11:45:32 +0900
Message-Id: <20201121024532.16834-16-dmitry.fomichev@wdc.com>
In-Reply-To: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
References: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Most of ZBD code in fio uses zone_lock() to lock write pointer zones.
This wrapper, besides doing the obvious pthread mutex lock, quiesce
the outstanding i/o when running via asynchronous ioengines. This is
necessary to avoid deadlocks. The function zbd_process_swd(), however,
still uses the naked pthread mutex to lock zones and this leads to a
deadlock when running ZBD test #48 against regular nullb devices.

The fix added in the same patch series that introduced test #48 was to
NOT initialize SWD at all, but this solution is found to create
problems with verify. As the proper fix, modify zbd_process_swd()
to use zone_lock(). This makes the test #48 pass even when SWD counter
is initialized.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/zbd.c b/zbd.c
index 6a58115d..cdb4dc17 100644
--- a/zbd.c
+++ b/zbd.c
@@ -166,7 +166,8 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 		z->wp + required > zbd_zone_capacity_end(z);
 }
 
-static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zone_info *z)
+static void zone_lock(struct thread_data *td, const struct fio_file *f,
+		      struct fio_zone_info *z)
 {
 	struct zoned_block_device_info *zbd = f->zbd_info;
 	uint32_t nz = z - zbd->zone_info;
@@ -893,7 +894,8 @@ enum swd_action {
 };
 
 /* Calculate the number of sectors with data (swd) and perform action 'a' */
-static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
+static uint64_t zbd_process_swd(struct thread_data *td,
+				const struct fio_file *f, enum swd_action a)
 {
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t swd = 0;
@@ -903,7 +905,7 @@ static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
 	ze = get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
 		if (z->has_wp) {
-			pthread_mutex_lock(&z->mutex);
+			zone_lock(td, f, z);
 			wp_swd += z->wp - z->start;
 		}
 		swd += z->wp - z->start;
@@ -934,33 +936,27 @@ static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
 static const bool enable_check_swd = false;
 
 /* Check whether the values of zbd_info.*sectors_with_data are correct. */
-static void zbd_check_swd(const struct fio_file *f)
+static void zbd_check_swd(struct thread_data *td, const struct fio_file *f)
 {
 	if (!enable_check_swd)
 		return;
 
-	zbd_process_swd(f, CHECK_SWD);
-}
-
-static void zbd_init_swd(struct fio_file *f)
-{
-	uint64_t swd;
-
-	swd = zbd_process_swd(f, SET_SWD);
-	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
-	       swd);
+	zbd_process_swd(td, f, CHECK_SWD);
 }
 
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
+	uint64_t swd;
 
 	if (!f->zbd_info || !td_write(td))
 		return;
 
 	zb = get_zone(f, f->min_zone);
 	ze = get_zone(f, f->max_zone);
-	zbd_init_swd(f);
+	swd = zbd_process_swd(td, f, SET_SWD);
+	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
+	       swd);
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
@@ -1413,7 +1409,7 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	zbd_end_zone_io(td, io_u, z);
 
 	zone_unlock(z);
-	zbd_check_swd(f);
+	zbd_check_swd(td, f);
 }
 
 /*
@@ -1579,7 +1575,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
-	zbd_check_swd(f);
+	zbd_check_swd(td, f);
 
 	zone_lock(td, f, zb);
 
-- 
2.21.0


