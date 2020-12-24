Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 06/36] zbd: remove dependency on zone type during i/o
Date: Thu, 24 Dec 2020 11:11:49 +0900
Message-Id: <20201224021219.189727-7-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Two different type of zones have a write pointer: Sequential Write
Required (SWR) and Sequential Write Preferred (SWP). Introduce the
zone flag "has_wp" in struct zbd_zone_info and set it to 1 for these
zone types upon initialization, thus avoiding the necessity to check
multiple zone types in core zbd code. This flag replaces zbd_zone_swr()
function and lays the groundwork for supporting additional write
pointer zone types in the future.

The overall functionality stays the same after this commit.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 31 ++++++++++++++++---------------
 zbd.h |  2 ++
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/zbd.c b/zbd.c
index 0bda4c03..776d9b2c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -131,15 +131,6 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 	return min(zone_idx, f->zbd_info->nr_zones);
 }
 
-/**
- * zbd_zone_swr - Test whether a zone requires sequential writes
- * @z: zone info pointer.
- */
-static inline bool zbd_zone_swr(struct fio_zone_info *z)
-{
-	return z->type == ZBD_ZONE_TYPE_SWR;
-}
-
 /**
  * zbd_zone_end - Return zone end location
  * @z: zone info pointer.
@@ -171,7 +162,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 {
 	assert((required & 511) == 0);
 
-	return zbd_zone_swr(z) &&
+	return z->has_wp &&
 		z->wp + required > zbd_zone_capacity_end(z);
 }
 
@@ -249,7 +240,7 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	zone_idx_b = zbd_zone_idx(f, f->file_offset);
 	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size - 1);
 	for (zone_idx = zone_idx_b; zone_idx <= zone_idx_e; zone_idx++)
-		if (zbd_zone_swr(get_zone(f, zone_idx)))
+		if (get_zone(f, zone_idx)->has_wp)
 			return true;
 
 	return false;
@@ -429,6 +420,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		p->type = ZBD_ZONE_TYPE_SWR;
 		p->cond = ZBD_ZONE_COND_EMPTY;
 		p->capacity = zone_capacity;
+		p->has_wp = 1;
 	}
 	/* a sentinel */
 	p->start = nr_zones * zone_size;
@@ -512,8 +504,17 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 				p->wp = z->wp;
 				break;
 			}
+
+			switch (z->type) {
+			case ZBD_ZONE_TYPE_SWR:
+				p->has_wp = 1;
+				break;
+			default:
+				p->has_wp = 0;
+			}
 			p->type = z->type;
 			p->cond = z->cond;
+
 			if (j > 0 && p->start != p[-1].start + zone_size) {
 				log_info("%s: invalid zone data\n",
 					 f->file_name);
@@ -811,7 +812,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	for (z = zb; z < ze; z++) {
 		uint32_t nz = zbd_zone_nr(f, z);
 
-		if (!zbd_zone_swr(z))
+		if (!z->has_wp)
 			continue;
 		zone_lock(td, f, z);
 		if (all_zones) {
@@ -1313,7 +1314,7 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 	assert(zone_idx < zbd_info->nr_zones);
 	z = get_zone(f, zone_idx);
 
-	if (!zbd_zone_swr(z))
+	if (!z->has_wp)
 		return;
 
 	if (!success)
@@ -1373,7 +1374,7 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	assert(zone_idx < zbd_info->nr_zones);
 	z = get_zone(f, zone_idx);
 
-	if (!zbd_zone_swr(z))
+	if (!z->has_wp)
 		return;
 
 	dprint(FD_ZBD,
@@ -1538,7 +1539,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	orig_zb = zb;
 
 	/* Accept the I/O offset for conventional zones. */
-	if (!zbd_zone_swr(zb))
+	if (!zb->has_wp)
 		return io_u_accept;
 
 	/*
diff --git a/zbd.h b/zbd.h
index bff55f99..059a9f9e 100644
--- a/zbd.h
+++ b/zbd.h
@@ -28,6 +28,7 @@ enum io_u_action {
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
+ * @has_wp: whether or not this zone can have a valid write pointer
  * @open: whether or not this zone is currently open. Only relevant if
  *		max_open_zones > 0.
  * @reset_zone: whether or not this zone should be reset before writing to it
@@ -40,6 +41,7 @@ struct fio_zone_info {
 	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
+	unsigned int		has_wp:1;
 	unsigned int		open:1;
 	unsigned int		reset_zone:1;
 };
-- 
2.28.0


