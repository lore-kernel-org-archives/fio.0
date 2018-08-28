Return-Path: <prvs=771502ab2=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Improve read randomness
Date: Tue, 28 Aug 2018 14:34:27 +0900
Message-Id: <20180828053428.10143-2-damien.lemoal@wdc.com>
In-Reply-To: <20180828053428.10143-1-damien.lemoal@wdc.com>
References: <20180828053428.10143-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

With zonemode=zbd, for random read operations with read_beyond_wp=0,
the zbd code will always adjust an I/O offset so that the I/O falls in
a non empty zone. The adjustment however always sets the I/O offset to
the start of the zone, resulting in a high device read cache hit rate
if the device has very few zones written.

Fix this by improving the randomness of the I/Os by adjusting the I/O
offset to a random value with the range of written data in the zone.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 56197693..a985e022 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1179,7 +1179,15 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				       io_u->buflen);
 				goto eof;
 			}
-			io_u->offset = zb->start << 9;
+			range = ((zb->wp - zb->start) << 9) - io_u->buflen;
+			if (td_random(td) && range >= 0)
+				io_u->offset = (zb->start << 9) +
+					((io_u->offset - (zb->start << 9)) %
+					 (range + 1)) / min_bs * min_bs;
+			else
+				io_u->offset = zb->start << 9;
+			assert(zb->start << 9 <= io_u->offset);
+			assert(io_u->offset + io_u->buflen <= zb->wp << 9);
 		}
 		if ((io_u->offset + io_u->buflen) >> 9 > zb->wp) {
 			dprint(FD_ZBD, "%s: %lld + %lld > %" PRIu64 "\n",
-- 
2.17.1


