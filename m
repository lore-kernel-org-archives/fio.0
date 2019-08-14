Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 1/7] zbd: Declare local functions 'static'
Date: Tue, 13 Aug 2019 19:20:32 -0700
Message-Id: <20190814022038.30941-2-bvanassche@acm.org>
In-Reply-To: <20190814022038.30941-1-bvanassche@acm.org>
References: <20190814022038.30941-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

This patch fixes two sparse warnings.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 zbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/zbd.c b/zbd.c
index d7e91e37e010..2383c57dfc90 100644
--- a/zbd.c
+++ b/zbd.c
@@ -481,7 +481,7 @@ out:
  *
  * Returns 0 upon success and a negative error code upon failure.
  */
-int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
+static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 {
 	enum blk_zoned_model zbd_model;
 	int ret = 0;
@@ -933,8 +933,8 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
  * a multiple of the fio block size. The caller must neither hold z->mutex
  * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
  */
-struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
-					       struct io_u *io_u)
+static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
+						      struct io_u *io_u)
 {
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	const struct fio_file *f = io_u->file;
-- 
2.22.0


