Return-Path: <prvs=771502ab2=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Remove inexitent function declaration
Date: Tue, 28 Aug 2018 14:34:28 +0900
Message-Id: <20180828053428.10143-3-damien.lemoal@wdc.com>
In-Reply-To: <20180828053428.10143-1-damien.lemoal@wdc.com>
References: <20180828053428.10143-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

zbd_do_trim() and zbd_update_wp() are not implemented.
Remove there declaration from zbd.h.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/zbd.h b/zbd.h
index 08751fd5..d750b67e 100644
--- a/zbd.h
+++ b/zbd.h
@@ -95,8 +95,6 @@ int zbd_init(struct thread_data *td);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
-int zbd_do_trim(struct thread_data *td, const struct io_u *io_u);
-void zbd_update_wp(struct thread_data *td, const struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 #else
 static inline void zbd_free_zone_info(struct fio_file *f)
@@ -123,16 +121,6 @@ static inline enum io_u_action zbd_adjust_block(struct thread_data *td,
 	return io_u_accept;
 }
 
-static inline int zbd_do_trim(struct thread_data *td, const struct io_u *io_u)
-{
-	return 1;
-}
-
-static inline void zbd_update_wp(struct thread_data *td,
-				 const struct io_u *io_u)
-{
-}
-
 static inline char *zbd_write_status(const struct thread_stat *ts)
 {
 	return NULL;
-- 
2.17.1


