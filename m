Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26903 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgDHGqr (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Apr 2020 02:46:47 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/3] zbd: Fix missing mutex unlock and warnings detected with coverity
Date: Wed,  8 Apr 2020 15:46:45 +0900
Message-Id: <20200408064645.1621805-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

With max_open_zones != 0, if no candidate zone for open is found by
zbd_convert_to_open_zone(), the file zbd_info mutex as well as the
current target zone mutex must both be unlocked before returning NULL.

While at it, also assert check for min_bs != 0 where min_bs is used for
divisions to avoid division by zero warnings from coverity.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Fixes: 6463db6c1d3a ("fio: fix interaction between offset/size...")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/zbd.c b/zbd.c
index f4067802..baa6cdac 100644
--- a/zbd.c
+++ b/zbd.c
@@ -704,6 +704,8 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	bool reset_wp;
 	int res = 0;
 
+	assert(min_bs);
+
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
 	for (z = zb; z < ze; z++) {
@@ -1004,6 +1006,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&z->mutex);
 		return NULL;
 
 found_candidate_zone:
@@ -1332,6 +1336,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	if (!f->zbd_info)
 		return io_u_accept;
 
+	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
 	zone_idx_b = zbd_zone_idx(f, io_u->offset);
-- 
2.25.1


