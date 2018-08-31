Return-Path: <prvs=774163301=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 1/3] zbd: Improve read randomness
Date: Fri, 31 Aug 2018 13:46:36 +0900
Message-Id: <20180831044638.22476-2-damien.lemoal@wdc.com>
In-Reply-To: <20180831044638.22476-1-damien.lemoal@wdc.com>
References: <20180831044638.22476-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

With zonemode=zbd, for random read operations with read_beyond_wp=0,
the zbd code will always adjust an I/O offset so that the I/O hits a
non empty zone. However, the adjustment always sets the I/O offset to
the start of the zone, resulting in a high device read cache hit rate
if the device has few zones written.

Improve randomness of read I/Os by adjusting the I/O offset to a random
value within the range of written data of the chosen zone. Also ensure
that the modified I/O does not cross over the zone wp position by
adjusting its size. Doing so, the search for a new zone is now done only
if the target zone cannot accomodate an I/O of at least min_bs bytes.

The comments have also been changed to better explain the code.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 59 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/zbd.c b/zbd.c
index 56197693..93f14410 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1119,7 +1119,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 {
 	const struct fio_file *f = io_u->file;
 	uint32_t zone_idx_b;
-	struct fio_zone_info *zb, *zl;
+	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len = io_u->buflen;
 	uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	uint64_t new_len;
@@ -1132,6 +1132,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	assert(io_u->buflen);
 	zone_idx_b = zbd_zone_idx(f, io_u->offset);
 	zb = &f->zbd_info->zone_info[zone_idx_b];
+	orig_zb = zb;
 
 	/* Accept the I/O offset for conventional zones. */
 	if (zb->type == BLK_ZONE_TYPE_CONVENTIONAL)
@@ -1153,21 +1154,14 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto accept;
 		}
 		/*
-		 * Avoid reads past the write pointer because such reads do not
-		 * hit the medium.
+		 * Check that there is enough written data in the zone to do an
+		 * I/O of at least min_bs B. If there isn't, find a new zone for
+		 * the I/O.
 		 */
 		range = zb->cond != BLK_ZONE_COND_OFFLINE ?
-			((zb->wp - zb->start) << 9) - io_u->buflen : 0;
-		if (td_random(td) && range >= 0) {
-			io_u->offset = (zb->start << 9) +
-				((io_u->offset - (zb->start << 9)) %
-				 (range + 1)) / min_bs * min_bs;
-			assert(zb->start << 9 <= io_u->offset);
-			assert(io_u->offset + io_u->buflen <= zb->wp << 9);
-			goto accept;
-		}
-		if (zb->cond == BLK_ZONE_COND_OFFLINE ||
-		    (io_u->offset + io_u->buflen) >> 9 > zb->wp) {
+			(zb->wp - zb->start) << 9 : 0;
+		if (range < min_bs ||
+		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp << 9))) {
 			pthread_mutex_unlock(&zb->mutex);
 			zl = &f->zbd_info->zone_info[zbd_zone_idx(f,
 						f->file_offset + f->io_size)];
@@ -1179,14 +1173,39 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				       io_u->buflen);
 				goto eof;
 			}
-			io_u->offset = zb->start << 9;
+			/*
+			 * zbd_find_zone() returned a zone with a range of at
+			 * least min_bs.
+			 */
+			range = (zb->wp - zb->start) << 9;
+			assert(range >= min_bs);
+
+			if (!td_random(td))
+				io_u->offset = zb->start << 9;
 		}
-		if ((io_u->offset + io_u->buflen) >> 9 > zb->wp) {
-			dprint(FD_ZBD, "%s: %lld + %lld > %" PRIu64 "\n",
-			       f->file_name, io_u->offset, io_u->buflen,
-			       zb->wp);
-			goto eof;
+		/*
+		 * Make sure the I/O is within the zone valid data range while
+		 * maximizing the I/O size and preserving randomness.
+		 */
+		if (range <= io_u->buflen)
+			io_u->offset = zb->start << 9;
+		else if (td_random(td))
+			io_u->offset = (zb->start << 9) +
+				((io_u->offset - (orig_zb->start << 9)) %
+				 (range - io_u->buflen)) / min_bs * min_bs;
+		/*
+		 * Make sure the I/O does not cross over the zone wp position.
+		 */
+		new_len = min((unsigned long long)io_u->buflen,
+			      (unsigned long long)(zb->wp << 9) - io_u->offset);
+		new_len = new_len / min_bs * min_bs;
+		if (new_len < io_u->buflen) {
+			io_u->buflen = new_len;
+			dprint(FD_IO, "Changed length from %u into %llu\n",
+			       orig_len, io_u->buflen);
 		}
+		assert(zb->start << 9 <= io_u->offset);
+		assert(io_u->offset + io_u->buflen <= zb->wp << 9);
 		goto accept;
 	case DDIR_WRITE:
 		if (io_u->buflen > (f->zbd_info->zone_size << 9))
-- 
2.17.1


