Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 17/36] zbd: don't log "zone nnnn is not open" message
Date: Thu, 24 Dec 2020 11:12:00 +0900
Message-Id: <20201224021219.189727-18-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This log message has been added recently (it could have been my idea
to add it during internal review) and it turns out that the message
tends to flood the log when any decent workload is run with
--zonemode=zbd. Remove logging of this debug message.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/zbd.c b/zbd.c
index 8fb9c8cf..249835c2 100644
--- a/zbd.c
+++ b/zbd.c
@@ -786,11 +786,8 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 		if (f->zbd_info->open_zones[open_zone_idx] == zone_idx)
 			break;
 	}
-	if (open_zone_idx == f->zbd_info->num_open_zones) {
-		dprint(FD_ZBD, "%s: zone %d is not open\n",
-		       f->file_name, zone_idx);
+	if (open_zone_idx == f->zbd_info->num_open_zones)
 		return;
-	}
 
 	dprint(FD_ZBD, "%s: closing zone %d\n", f->file_name, zone_idx);
 	memmove(f->zbd_info->open_zones + open_zone_idx,
-- 
2.28.0


