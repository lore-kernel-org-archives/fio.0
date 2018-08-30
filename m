Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:3508 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbeH3IPp (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Aug 2018 04:15:45 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 2/5] zbd: Remove inexitent function declaration
Date: Thu, 30 Aug 2018 13:15:28 +0900
Message-Id: <20180830041531.20963-3-damien.lemoal@wdc.com>
In-Reply-To: <20180830041531.20963-1-damien.lemoal@wdc.com>
References: <20180830041531.20963-1-damien.lemoal@wdc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>

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


