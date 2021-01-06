Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 07/38] zbd: skip offline zones in zbd_convert_to_open_zone()
Date: Thu,  7 Jan 2021 06:57:08 +0900
Message-Id: <20210106215739.264524-8-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Since all I/Os to an offline zone will fail, add a check in
zbd_convert_to_open_zone() to ignore zones that have this condition.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 776d9b2c..69befd5a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1078,7 +1078,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		if (td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
+		if (z->cond != ZBD_ZONE_COND_OFFLINE &&
+		    td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
 			goto examine_zone;
 		if (f->zbd_info->num_open_zones == 0) {
 			dprint(FD_ZBD, "%s(%s): no zones are open\n",
@@ -1200,6 +1201,7 @@ out:
 	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
 	       zone_idx);
 	io_u->offset = z->start;
+	assert(z->cond != ZBD_ZONE_COND_OFFLINE);
 	return z;
 }
 
-- 
2.28.0


