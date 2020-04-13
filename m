Return-Path: <prvs=36522ed81=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/3] zbd: Ensure first I/O is write for random read/write to sequential zones
Date: Mon, 13 Apr 2020 17:33:00 +0900
Message-Id: <20200413083300.256784-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
References: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

In case read is chosen for the first random I/O for sequential write
required zones, fio stops because no data can be read from the zones with
empty status. Enforce to write at the first I/O to make sure data to read
exists for the following read operations.

The unexpected fio stop symptom was observed with test case #30 of
t/zbd/test-zbd-support. When the test case was run repeatedly resetting
all zones with -r option, it often passes with too short run time.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/zbd.c b/zbd.c
index 0b0d4f40..abfa802c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1348,6 +1348,16 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	if (!zbd_zone_swr(zb))
 		return io_u_accept;
 
+	/*
+	 * In case read direction is chosen for the first random I/O, fio with
+	 * zonemode=zbd stops because no data can be read from zoned block
+	 * devices with all empty zones. Overwrite the first I/O direction as
+	 * write to make sure data to read exists.
+	 */
+	if (td_rw(td) && !f->zbd_info->sectors_with_data
+	    && !td->o.read_beyond_wp)
+		io_u->ddir = DDIR_WRITE;
+
 	/*
 	 * Accept the I/O offset for reads if reading beyond the write pointer
 	 * is enabled.
-- 
2.25.1


