Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 22/38] zbd: set thread errors in zbd_adjust_block()
Date: Thu,  7 Jan 2021 06:57:23 +0900
Message-Id: <20210106215739.264524-23-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Several error conditions that are encountered during zone processing
in zbd_adjust_block() function cause it to return io_u_eof value.
This stops the i/o to the given file, but there is no error raised or
reported if this code is returned. For a few particular conditions,
just stopping the i/o is reasonable, but others are serious errors
that should be reported.

Add td_verror() calls to raise thread errors for a few abnormal
conditions during adjusting the i/o. The only test that needs to be
modified because of this changes is test #2.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/zbd.c b/zbd.c
index f51db783..e8fa54ca 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1688,13 +1688,22 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		assert(io_u->offset + io_u->buflen <= zb->wp);
 		goto accept;
 	case DDIR_WRITE:
-		if (io_u->buflen > f->zbd_info->zone_size)
+		if (io_u->buflen > f->zbd_info->zone_size) {
+			td_verror(td, EINVAL, "I/O buflen exceeds zone size");
+			dprint(FD_IO,
+			       "%s: I/O buflen %llu exceeds zone size %lu\n",
+			       f->file_name, io_u->buflen,
+			       f->zbd_info->zone_size);
 			goto eof;
+		}
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
 			zone_unlock(zb);
 			zb = zbd_convert_to_open_zone(td, io_u);
-			if (!zb)
+			if (!zb) {
+				dprint(FD_IO, "%s: can't convert to open zone",
+				       f->file_name);
 				goto eof;
+			}
 			zone_idx_b = zbd_zone_nr(f, zb);
 		}
 		/* Check whether the zone reset threshold has been exceeded */
@@ -1721,6 +1730,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				goto eof;
 
 			if (zb->capacity < min_bs) {
+				td_verror(td, EINVAL, "ZCAP is less min_bs");
 				log_err("zone capacity %llu smaller than minimum block size %d\n",
 					(unsigned long long)zb->capacity,
 					min_bs);
@@ -1731,8 +1741,9 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		assert(!zbd_zone_full(f, zb, min_bs));
 		io_u->offset = zb->wp;
 		if (!is_valid_offset(f, io_u->offset)) {
-			dprint(FD_ZBD, "Dropped request with offset %llu\n",
-			       io_u->offset);
+			td_verror(td, EINVAL, "invalid WP value");
+			dprint(FD_ZBD, "%s: dropped request with offset %llu\n",
+			       f->file_name, io_u->offset);
 			goto eof;
 		}
 		/*
@@ -1751,9 +1762,9 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			       orig_len, io_u->buflen);
 			goto accept;
 		}
-		log_err("Zone remainder %lld smaller than minimum block size %d\n",
-			(zbd_zone_capacity_end(zb) - io_u->offset),
-			min_bs);
+		td_verror(td, EIO, "zone remainder too small");
+		log_err("zone remainder %lld smaller than min block size %d\n",
+			(zbd_zone_capacity_end(zb) - io_u->offset), min_bs);
 		goto eof;
 	case DDIR_TRIM:
 		/* fall-through */
-- 
2.28.0


