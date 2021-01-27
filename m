Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 17/38] zbd: don't log "zone nnnn is not open" message
Date: Wed, 27 Jan 2021 13:19:24 +0900
Message-Id: <20210127041945.36909-18-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This log message has been added recently (it could have been my idea
to add it during internal review) and it turns out that the message
tends to flood the log when any decent workload is run with
--zonemode=zbd. Remove logging of this debug message.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/zbd.c b/zbd.c
index 2cebc5e6..634ee8f6 100644
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


