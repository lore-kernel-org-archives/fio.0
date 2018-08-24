Return-Path: <prvs=76726b587=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 05/11] Pass offset and buffer length explicitly to mark_random_map()
Date: Fri, 24 Aug 2018 11:31:25 -0700
Message-Id: <20180824183131.13278-6-bart.vanassche@wdc.com>
In-Reply-To: <20180824183131.13278-1-bart.vanassche@wdc.com>
References: <20180824183131.13278-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

This patch does not change any functionality. The changes introduced by
this patch will be used by the zoned block device code.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 io_u.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/io_u.c b/io_u.c
index 29a360a95424..eed7d9d91c8d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -31,21 +31,24 @@ static bool random_map_free(struct fio_file *f, const uint64_t block)
 /*
  * Mark a given offset as used in the map.
  */
-static void mark_random_map(struct thread_data *td, struct io_u *io_u)
+static uint64_t mark_random_map(struct thread_data *td, struct io_u *io_u,
+				uint64_t offset, uint64_t buflen)
 {
 	unsigned long long min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	unsigned long long nr_blocks;
 	uint64_t block;
 
-	block = (io_u->offset - f->file_offset) / (uint64_t) min_bs;
-	nr_blocks = (io_u->buflen + min_bs - 1) / min_bs;
+	block = (offset - f->file_offset) / (uint64_t) min_bs;
+	nr_blocks = (buflen + min_bs - 1) / min_bs;
 
 	if (!(io_u->flags & IO_U_F_BUSY_OK))
 		nr_blocks = axmap_set_nr(f->io_axmap, block, nr_blocks);
 
-	if ((nr_blocks * min_bs) < io_u->buflen)
-		io_u->buflen = nr_blocks * min_bs;
+	if ((nr_blocks * min_bs) < buflen)
+		buflen = nr_blocks * min_bs;
+
+	return buflen;
 }
 
 static uint64_t last_block(struct thread_data *td, struct fio_file *f,
@@ -908,7 +911,8 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	 * mark entry before potentially trimming io_u
 	 */
 	if (td_random(td) && file_randommap(td, io_u->file))
-		mark_random_map(td, io_u);
+		io_u->buflen = mark_random_map(td, io_u, io_u->offset,
+					       io_u->buflen);
 
 out:
 	dprint_io_u(io_u, "fill");
-- 
2.18.0


