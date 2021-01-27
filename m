Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 16/38] zbd: disable crossing from conventional to sequential zones
Date: Wed, 27 Jan 2021 13:19:23 +0900
Message-Id: <20210127041945.36909-17-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Write I/Os to conventional zones may have the range that spans across
zone boundaries. Such writes may cause I/O errors when its next zone
is a sequential zone.

To avoid such I/O errors, check for the cross over from a conventional
to a sequential zone. When the write crosses the boundary, shrink the
I/O length to fit within the first zone. If the offset is too close to
the end of the zone, wrap it around to the beginning of the same zone.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index cebde1b6..2cebc5e6 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1563,9 +1563,31 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	zb = get_zone(f, zone_idx_b);
 	orig_zb = zb;
 
-	/* Accept the I/O offset for conventional zones. */
-	if (!zb->has_wp)
+	if (!zb->has_wp) {
+		/* Accept non-write I/Os for conventional zones. */
+		if (io_u->ddir != DDIR_WRITE)
+			return io_u_accept;
+		/*
+		 * Make sure that writes to conventional zones
+		 * don't cross over to any sequential zones.
+		 */
+		if (!(zb + 1)->has_wp ||
+		    io_u->offset + io_u->buflen <= (zb + 1)->start)
+			return io_u_accept;
+
+		if (io_u->offset + min_bs > (zb + 1)->start) {
+			dprint(FD_IO,
+			       "%s: off=%llu + min_bs=%u > next zone %lu\n",
+			       f->file_name, io_u->offset, min_bs,
+			       (zb + 1)->start);
+			io_u->offset = zb->start + (zb + 1)->start - io_u->offset;
+			new_len = min(io_u->buflen, (zb + 1)->start - io_u->offset);
+		} else {
+			new_len = (zb + 1)->start - io_u->offset;
+		}
+		io_u->buflen = new_len / min_bs * min_bs;
 		return io_u_accept;
+	}
 
 	/*
 	 * Accept the I/O offset for reads if reading beyond the write pointer
-- 
2.28.0


